# frozen_string_literal: true

# Boot the atlas web edition: container, dependencies, root path.
#
# Note on language, same as the rest of web/: identifiers and comments are English,
# user-visible strings and CSS class names are German — the latter are shared
# vocabulary with site.css, Muster.dc.html and the markup.

require 'dry/system'
require 'dry/monads'

module Atlas
  # The repository root. Everything this application reads and serves lives below
  # it, and nothing is written back — the dev preview bind-mounts it read-only.
  ROOT = Pathname(File.expand_path('..', __dir__)).freeze

  # Where the nine vendored libraries sit. Outside the served tree on purpose: the
  # sheets reference /vendor/… after the rewrite, and that path must not collide
  # with a directory a visitor could otherwise reach.
  VENDOR_DIR = Pathname(ENV.fetch('ATLAS_VENDOR_DIR', ROOT.join('.vendor').to_s)).freeze

  class Container < Dry::System::Container
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
  end

  Import = Container.injector
end

# Not components, so dry-system never reaches them on its own.
require_relative 'lib/atlas/transforms'
require_relative 'lib/atlas/views'
require_relative 'lib/atlas/vendor'
require_relative 'lib/atlas/middleware/files'
require_relative 'lib/atlas/middleware/guard'
require_relative 'lib/atlas/middleware/vendor_rewrite'
