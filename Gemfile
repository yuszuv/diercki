# The web edition of the atlas. Roda routes, dry-rb carries the data.
#
# The map sheets themselves need none of this — they are standalone HTML and open
# from the filesystem. What is served here is the application AROUND them: the
# showcase, the name register, the workshop, and the frame that puts a sheet next
# to its source register.
#
# No CDN, no npm. Everything the browser gets is either in this repo or vendored
# into the image by bin/vendor.rb.

source 'https://rubygems.org'

# The series, not the patch level. `.ruby-version` next to this file pins the
# exact build for rbenv locally; the image tracks ruby:3.4-alpine and gets
# whatever patch that carries. Reading .ruby-version here instead would mean a
# security release upstream breaking the build for saying 3.4.10 where the file
# says 3.4.2.
ruby '~> 3.4.0'

# --- The application ---------------------------------------------------------
gem 'puma', '~> 8.0'  # also serves the static tree; there is no nginx anymore
gem 'roda', '~> 3.107'

# Roda's render plugin. Erubi over ERB: it escapes by default with <%= %>, which
# is the right way round for a page assembled from files on disk.
gem 'erubi', '~> 1.13'
gem 'tilt', '~> 2.6'

# --- dry-rb ------------------------------------------------------------------
gem 'dry-auto_inject', '~> 1.2'
gem 'dry-monads', '~> 1.10'  # Result — a missing file is a case, not an exception
gem 'dry-system', '~> 1.2'
gem 'dry-transformer', '~> 1.1'  # the parse pipelines for README tables and CSV

# --- Markdown ----------------------------------------------------------------
# The workshop renders the repo's own .md files. GFM because the docs are full of
# tables, which plain kramdown does not read.
gem 'kramdown', '~> 2.5'
gem 'kramdown-parser-gfm', '~> 1.1'

group :test do
  gem 'minitest', '~> 5.25'
  gem 'rack-test', '~> 2.2'
end
