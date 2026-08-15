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

  # Handed out by the messages below, and by .env.example. Once, so a change to
  # either command cannot leave stale copies behind.
  MAKE_HASH = %(ruby -rbcrypt -e 'print [BCrypt::Password.create("DEIN PASSWORT")].pack("m0")')
  MAKE_SECRET = "ruby -rsecurerandom -e 'print SecureRandom.hex(64)'"

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

    # The three values the login needs. None of them gets a default, and the
    # constructors have to enforce that themselves: the provider knows no such
    # thing as "required", so a value nobody sets and nobody rejects is simply
    # nil.
    #
    # dotenv comes with the provider and reads a chain — first file that sets a
    # name wins: .env.<env>.local · .env.local (never in test) · .env.<env> ·
    # .env. The environment wins over all of them, which is what keeps the test
    # suite hermetic on a machine that has a real .env sitting here.
    #
    # Why the provider at all, and the measurements behind the base64 rule:
    # recherche/entscheidungen-webanwendung.md.
    register_provider(:settings, from: :dry_system) do
      settings do
        setting :atlas_konto, constructor: lambda { |value|
          raise ArgumentError, 'fehlt — der Kontoname für die Anmeldung' if value.to_s.empty?

          value
        }

        # base64 because both readers of a .env resolve $, and a bcrypt hash is
        # made of $-fields: compose mangles a raw one, dotenv empties it. Silent
        # either way — the correct password would just stop matching.
        setting :atlas_passwort_hash, constructor: lambda { |value|
          if value.to_s.empty?
            raise ArgumentError, "fehlt. Erwartet wird der bcrypt-Hash, base64-kodiert:\n    #{MAKE_HASH}"
          end

          # Strict base64 from core Ruby; the base64 gem stopped being a default
          # gem in 3.4 and is not needed for this.
          hash = begin
            value.unpack1('m0')
          rescue ArgumentError
            raise ArgumentError, "ist kein gültiges Base64. Erzeugen mit:\n    #{MAKE_HASH}"
          end

          unless hash.to_s.match?(BCRYPT)
            raise ArgumentError, "ergibt dekodiert keinen bcrypt-Hash. Erzeugen mit:\n    #{MAKE_HASH}"
          end

          hash
        }

        # Roda checks the length too, but only when AuthApp's class body runs —
        # and then it stands alone instead of next to whatever else is wrong.
        setting :atlas_session_secret, constructor: lambda { |value|
          raise ArgumentError, "fehlt. Erzeugen mit:\n    #{MAKE_SECRET}" if value.to_s.empty?

          if value.bytesize < 64
            raise ArgumentError, "braucht mindestens 64 Zeichen, hat #{value.bytesize}:\n    #{MAKE_SECRET}"
          end

          value
        }
      end
    end
  end

  Import = Container.injector

  # Uncaught, InvalidSettingsError arrives as a backtrace framed in English with
  # the keys in their lowercase setting spelling, while the reader is looking for
  # the name they wrote in a .env. Only that frame is replaced; if the library
  # changes its shape the pattern finds nothing and the original is printed.
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

# Not components, so dry-system never reaches them on its own. Table has to come
# before the readers that include it: an include runs when the class body is
# read, which is earlier than the container resolving anything.
require_relative 'lib/atlas/transforms'
require_relative 'lib/atlas/table'
require_relative 'lib/atlas/views'
require_relative 'lib/atlas/vendor'
require_relative 'lib/atlas/middleware/files'
require_relative 'lib/atlas/middleware/guard'
require_relative 'lib/atlas/middleware/vendor_rewrite'
