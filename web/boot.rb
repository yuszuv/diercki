# frozen_string_literal: true

# Boot the atlas web edition: container, dependencies, root path.
#
# Note on language, same as the rest of web/: identifiers and comments are English,
# user-visible strings and CSS class names are German — the latter are shared
# vocabulary with site.css, Muster.dc.html and the markup.

# dry-configurable before the provider sources, and this order is not cosmetic:
# dry/system/provider_sources references Dry::Configurable while loading without
# requiring it, and dies with an "uninitialized constant" otherwise.
require 'dry/configurable'
require 'dry/system'
require 'dry/system/provider_sources'
require 'dry/monads'

module Atlas
  # The repository root. Everything this application reads and serves lives below
  # it, and nothing is written back — the dev preview bind-mounts it read-only.
  ROOT = Pathname(File.expand_path('..', __dir__)).freeze

  # Where the nine vendored libraries sit. Outside the served tree on purpose: the
  # sheets reference /vendor/… after the rewrite, and that path must not collide
  # with a directory a visitor could otherwise reach.
  VENDOR_DIR = Pathname(ENV.fetch('ATLAS_VENDOR_DIR', ROOT.join('.vendor').to_s)).freeze

  # A bcrypt hash is "$2a$12$" followed by 53 characters of salt and digest.
  # %r{} rather than //: the character class holds a slash, which would end a
  # slash-delimited literal right there.
  BCRYPT = %r{\A\$2[aby]\$\d\d\$[./A-Za-z0-9]{53}\z}

  class Container < Dry::System::Container
    # The settings provider asks for `config.env`, and that setting only exists
    # with this plugin. The inferrer is not decoration either: the .env chain
    # below leaves out .env.local exactly when env is :test, so an environment
    # stuck at the default :development would pull a developer's local file into
    # the test suite.
    use :env, inferrer: -> { ENV.fetch('RACK_ENV', 'development').to_sym }

    configure do |config|
      config.root = ROOT

      config.component_dirs.add('web/lib') do |dir|
        # Register Atlas::Sources::Register as "sources.register", not
        # "atlas.sources.register".
        dir.namespaces.add 'atlas', key: nil

        # Only the readers are components. The transforms are pure function
        # modules, the middlewares are instantiated by Rack with arguments, and
        # the vendor list is data — none of them wants a container-built
        # singleton, and auto-registering them would call .new without arguments.
        dir.auto_register = lambda { |component|
          component.key.start_with?('sources.') || component.key == 'markdown'
        }

        # The readers hold no request state — they read files and return values.
        # One instance each is right, and it keeps Container[…] in the routes
        # down to a hash lookup.
        dir.memoize = true
      end
    end

    # The three values the login needs, declared once and checked on the way in.
    #
    # Every one of them is required and none gets a default. A fallback secret is
    # worse than none, because nothing looks broken while it is in place — so the
    # constructors below reject an empty value themselves. The provider has no
    # notion of "required"; a setting nobody sets and nobody rejects would simply
    # be nil.
    #
    # The gain over reading ENV by hand is that this collects. A hand-written
    # check aborts on the first thing it finds and you repair them one restart at
    # a time; Config.load runs every constructor, gathers what each one raised,
    # and reports all three at once.
    #
    # dotenv comes with the provider and reads, in this order, the first file
    # that sets a given name:
    #
    #   .env.<env>.local · .env.local (never in test) · .env.<env> · .env
    #
    # A variable already in the environment wins over all of them. That is what
    # lets the container, CI and a single overridden run set values without a
    # file — and it is what keeps the test suite hermetic on a machine that has a
    # real .env sitting here.
    register_provider(:settings, from: :dry_system) do
      settings do
        setting :atlas_konto, constructor: lambda { |value|
          raise ArgumentError, 'fehlt — der Kontoname für die Anmeldung' if value.to_s.empty?

          value
        }

        # The password hash travels base64-encoded, and this is not decoration.
        #
        # A bcrypt hash is "$2a$12$…" — three fields separated by dollar signs,
        # and everything on the way in chews on those. Measured, twice: docker
        # compose resolves ${…} in every value it reads, the .env included, and
        # "$2a$12$KDvI…/qxuoa" arrives inside the container as "a2/qxuoa";
        # dotenv, which reads the same file here, turns the same line into an
        # empty string. Neither quoting nor $$-doubling nor env_file: stops
        # either of them, and single quotes only stop the second.
        #
        # That failure is silent where it is not caught: the application starts
        # and the correct password is simply rejected. Base64 has no dollar
        # signs, so nothing on the way in can touch it — and the check below
        # turns a mangled value into a refusal to start instead of a login that
        # never works.
        setting :atlas_passwort_hash, constructor: lambda { |value|
          if value.to_s.empty?
            raise ArgumentError, <<~TEXT.chomp
              fehlt. Erwartet wird der bcrypt-Hash, base64-kodiert:
                  ruby -rbcrypt -e 'print [BCrypt::Password.create("DEIN PASSWORT")].pack("m0")'
            TEXT
          end

          # unpack1('m0') is strict base64 and comes with core Ruby — base64
          # stopped being a default gem in 3.4, and this needs no gem at all.
          hash = begin
            value.unpack1('m0')
          rescue ArgumentError
            raise ArgumentError, <<~TEXT.chomp
              ist kein gültiges Base64. Erzeugen mit:
                  ruby -rbcrypt -e 'print [BCrypt::Password.create("DEIN PASSWORT")].pack("m0")'
            TEXT
          end

          unless hash.to_s.match?(BCRYPT)
            raise ArgumentError, <<~TEXT.chomp
              ergibt dekodiert keinen bcrypt-Hash. Roh übergeben käme er
                  verstümmelt an, und das Passwort würde stillschweigend nicht mehr passen:
                  ruby -rbcrypt -e 'print [BCrypt::Password.create("DEIN PASSWORT")].pack("m0")'
            TEXT
          end

          hash
        }

        # Roda checks the length too, but only when AuthApp's class body runs —
        # and then it stands alone instead of next to whatever else is wrong.
        setting :atlas_session_secret, constructor: lambda { |value|
          if value.to_s.empty?
            raise ArgumentError, <<~TEXT.chomp
              fehlt. Erzeugen mit:
                  ruby -rsecurerandom -e 'print SecureRandom.hex(64)'
            TEXT
          end

          if value.bytesize < 64
            raise ArgumentError, <<~TEXT.chomp
              braucht mindestens 64 Zeichen, hat #{value.bytesize}:
                  ruby -rsecurerandom -e 'print SecureRandom.hex(64)'
            TEXT
          end

          value
        }
      end
    end
  end

  Import = Container.injector

  # The settings, with the failure translated back into something readable.
  #
  # Uncaught, InvalidSettingsError arrives as a backtrace with an English
  # preamble and the keys in their lowercase setting spelling — while the reader
  # is looking for the name they wrote in a .env. The reasons in the middle are
  # the German ones written above and are worth keeping verbatim, so this
  # replaces the frame around them and leaves the rest alone. If the library ever
  # changes that shape, the pattern below simply finds nothing and the original
  # message is printed unchanged.
  def self.settings
    Container['settings']
  rescue Dry::System::ProviderSources::Settings::InvalidSettingsError => e
    reasons = e.message.scan(/^(\w+): (.+(?:\n .+)*)$/)
    abort(reasons.empty? ? e.message : <<~TEXT)
      Der Atlas startet nicht. Diese Angaben aus der Umgebung stimmen nicht:

      #{reasons.map { |name, why| "  #{name.upcase} #{why}" }.join("\n\n")}

      Siehe README, Abschnitt „Getting it running", und .env.example.
    TEXT
  end
end

# Not components, so dry-system never reaches them on its own.
require_relative 'lib/atlas/transforms'
require_relative 'lib/atlas/views'
require_relative 'lib/atlas/vendor'
require_relative 'lib/atlas/middleware/files'
require_relative 'lib/atlas/middleware/guard'
require_relative 'lib/atlas/middleware/vendor_rewrite'
