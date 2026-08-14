# frozen_string_literal: true

# What the web edition promises, checked.
#
#   bundle exec ruby -Itest test/web_test.rb
#
# Deliberately few and deliberately blunt: these are the claims that would be
# expensive to get wrong and cheap to get wrong silently — the CDN rewriting, the
# access protection the host's Caddy expects, and the rule that a missing file
# becomes a visible case rather than a blank space or a 500.
#
# The numbers below (272 register entries, 16 sheets) are read from the real
# files, not fixtures: this suite is also a check that the parsers still agree
# with the data as it stands.

ENV['RACK_ENV'] = 'test'

# The login refuses to start without these, on purpose. A fixed password here so
# the suite can log in; nothing else in the repo knows it.
require 'bcrypt'
ENV['ATLAS_KONTO'] ||= 'pruefer'
# base64, like everywhere else — see the comment on Atlas::Auth::BCRYPT.
ENV['ATLAS_PASSWORT_HASH'] ||= [BCrypt::Password.create('probelauf')].pack('m0')
ENV['ATLAS_SESSION_SECRET'] ||= 'p' * 64

require 'minitest/autorun'
require 'rack/test'
require 'rack/builder'
require 'tmpdir'

ROOT = File.expand_path('..', __dir__)
APPLICATION = Rack::Builder.parse_file(File.join(ROOT, 'config.ru'))

class AtlasTest < Minitest::Test
  include Rack::Test::Methods

  def app = APPLICATION

  # --- routes --------------------------------------------------------------

  def test_every_route_answers
    { '/' => 200,
      '/health' => 200,
      '/blaetter' => 200,
      '/register' => 200,
      '/werkstatt' => 200,
      '/blatt/Rumaenien-Braunbaer.html' => 200,
      '/werkstatt/atlas/BLAETTER.md' => 200,
      '/gibtsnicht' => 404 }.each do |path, status|
      get path
      assert_equal status, last_response.status, "#{path} should answer #{status}"
    end
  end

  def test_a_sheet_is_still_reachable_at_its_own_address
    get '/Rumaenien-Physisch.html'
    assert_equal 200, last_response.status
    assert_includes last_response.headers['content-type'], 'text/html'
  end

  # --- the data the pages are built from -----------------------------------

  def test_sheet_list_and_register_parse_to_the_expected_size
    sheets = Atlas::Container['sources.sheets'].all.value!
    assert_equal 16, sheets.reject(&:deck?).size, 'Blätter from the README tables'
    assert_equal 11, sheets.select(&:deck?).size, 'Präsentationen'

    entries = Atlas::Container['sources.register'].all.value!
    assert_equal 272, entries.size, 'entries in atlas/register.csv'
    assert_equal 86, entries.count(&:field), 'Suchgitter fields — all on Blatt 4'
    assert entries.select(&:field).all?(&:on_grid_sheet?),
           'a field may only appear on the Blatt that carries a Suchgitter'
  end

  def test_the_sheet_key_marks_its_numbers_as_derived
    plates = Atlas::Container['sources.plates'].all.value!
    numbered = plates.select(&:numbered?)
    assert_equal (1..9).to_a, numbered.map(&:nr).sort
    assert numbered.all?(&:derived?),
           'the Blattnummern are derived, not evidenced — see atlas/BLAETTER.md'
  end

  def test_no_sheet_number_is_cited_without_a_file
    plates = Atlas::Container['sources.plates']
    cited = Atlas::Container['sources.register'].cited_numbers
    assert_empty plates.unmapped(cited),
                 'register.csv cites a Blattnummer that atlas/blaetter.csv does not map'
  end

  # --- reading at runtime --------------------------------------------------

  def test_a_corrected_file_shows_up_without_a_restart
    # Tree#parse keeps a result only while mtime and size are unchanged. That
    # promise carries the whole design: no derived copy that quietly goes
    # stale. A cache that broke it would be worse than the work it saves.
    Dir.mktmpdir do |dir|
      file = File.join(dir, 'probe.csv')
      File.write(file, "a;b\n1;2\n")

      tree = Atlas::Container['sources.tree'].class.new(root: dir)
      parses = 0
      counted = ->(text) { parses += 1; text.lines.size }

      assert_equal 2, tree.parse('probe.csv', :lines, &counted).value!
      assert_equal 2, tree.parse('probe.csv', :lines, &counted).value!
      assert_equal 1, parses, 'unchanged: parsed once, then remembered'

      # mtime is rounded to whole seconds on some filesystems — the size
      # changes here anyway.
      File.write(file, "a;b\n1;2\n3;4\n")
      assert_equal 3, tree.parse('probe.csv', :lines, &counted).value!
      assert_equal 2, parses, 'changed: parsed again'

      # Two different parses of the same file live side by side.
      tree.parse('probe.csv', :other) { |t| t.length }
      assert_equal 3, tree.parse('probe.csv', :lines, &counted).value!
      assert_equal 2, parses, 'a second tag does not evict the first'
    end
  end

  def test_spellings_of_one_path_share_one_entry
    # The key is the resolved path, not the way it was written. /werkstatt/<path>
    # takes user input, so a key made of spellings would grow without bound — and
    # each entry holds its own copy of the rendered output.
    Dir.mktmpdir do |dir|
      File.write(File.join(dir, 'probe.md'), "eins\n")
      tree = Atlas::Container['sources.tree'].class.new(root: dir)

      parses = 0
      counted = ->(text) { parses += 1; text }

      ['probe.md', './probe.md', './././probe.md', 'x/../probe.md'].each do |spelling|
        assert_equal "eins\n", tree.parse(spelling, :t, &counted).value!
      end

      assert_equal 1, parses, 'vier Schreibweisen, eine Datei, ein Eintrag'
    end
  end

  def test_a_stamp_that_recurs_does_not_resurrect_a_stale_value
    # The dangerous interleaving is not "the file changed" — that heals by
    # itself, because the next stat misses. It is a stored entry labelled with a
    # stamp that does not describe the bytes it holds. That entry lies forever as
    # soon as [mtime, size] recurs with different contents, which is what an
    # mtime-preserving restore does: rsync -a, cp -p, tar -x, a backup rollback.
    #
    # Reproduced here deterministically: same length, mtime put back.
    Dir.mktmpdir do |dir|
      file = File.join(dir, 'probe.md')
      File.write(file, "alt\n")
      stat = File.stat(file)
      tree = Atlas::Container['sources.tree'].class.new(root: dir)

      # The file is rewritten while the parse is in flight, then restored to its
      # original identity — same size, same mtime, different contents.
      swapped = false
      tree.parse('probe.md', :t) do |text|
        unless swapped
          swapped = true
          File.write(file, "neu\n")
          File.utime(stat.atime, stat.mtime, file)
        end
        text
      end

      assert_equal [stat.mtime, stat.size], [File.stat(file).mtime, File.stat(file).size],
                   'die Probe muss die Identität wirklich wiederherstellen'

      assert_equal "neu\n", tree.parse('probe.md', :t) { |t| t }.value!,
                   'ein Eintrag unter einem Stempel, der seine Bytes nicht beschreibt, ' \
                   'würde hier für immer die alte Fassung ausliefern'
    end
  end

  def test_a_missing_file_is_still_a_failure_after_caching
    Dir.mktmpdir do |dir|
      tree = Atlas::Container['sources.tree'].class.new(root: dir)
      2.times do
        result = tree.parse('gibtsnicht.md', :html) { |t| t }
        assert result.failure?
        assert_equal :missing, result.failure.first
      end
    end
  end

  # --- vendoring -----------------------------------------------------------

  def test_the_cdn_addresses_are_rewritten_and_nothing_else_is
    get '/Rumaenien-Physisch.html'
    body = last_response.body

    refute_includes body, 'https://unpkg.com', 'no CDN address may survive'
    refute_includes body, 'https://cdn.jsdelivr.net'
    assert_includes body, '/vendor/unpkg/d3@7.9.0/dist/d3.min.js'
    # The hashes sit next to the scripts and must keep matching — the vendored
    # files are byte-identical, and bin/vendor.rb checks that.
    assert_includes body, 'sha384-CjloA8y00'
  end

  def test_the_sheets_on_disk_are_untouched
    # The rewriting happens on the way out. On disk it would make every future
    # export look like a conflict.
    original = File.read(File.join(ROOT, 'Rumaenien-Physisch.html'))
    assert_includes original, 'https://unpkg.com/d3@7.9.0/dist/d3.min.js'
  end

  def test_a_large_file_is_passed_through_untouched
    # Above MAX_BYTES the middleware does not even read the body. The two files
    # that size are map data and the design-system bundle; neither carries one of
    # the nine addresses, which is what makes the limit safe rather than lossy.
    get '/_ds/sternprodukt-design-system-760a3f03-bdcc-480e-bb81-66fc2988f194/_ds_bundle.js'
    assert_equal 200, last_response.status
    assert_operator last_response.body.bytesize, :>, Atlas::Middleware::VendorRewrite::MAX_BYTES
  end

  def test_the_two_javascript_files_that_carry_addresses_are_rewritten
    get '/support.js'
    refute_includes last_response.body, 'https://unpkg.com'
    assert_includes last_response.body, '/vendor/unpkg/react@18.3.1'
  end

  def test_vendored_libraries_are_served
    get '/vendor/unpkg/d3@7.9.0/dist/d3.min.js'
    assert_equal 200, last_response.status
    assert_operator last_response.body.bytesize, :>, 200_000
  end

  # --- what is not served --------------------------------------------------

  def test_raw_geodata_is_not_served
    get '/atlas/geodaten/source.gpkg'
    assert_equal 404, last_response.status,
                 'raw deliveries are not part of the atlas and are not served'
  end

  def test_a_path_cannot_leave_the_tree
    get '/werkstatt/../../etc/passwd'
    assert_equal 404, last_response.status
  end

  # --- access protection ---------------------------------------------------
  #
  # The host's Caddy guards addresses; this application invents new ones for the
  # same content. Without these checks the guard would be walked around, and
  # nothing would look broken while it happened.

  def test_guarded_paths_ask_for_a_login
    Atlas::Container['sources.restricted'].all.value!.each do |rule|
      get rule.path
      assert_equal 302, last_response.status, "#{rule.path} darf ohne Anmeldung nicht heraus"
      assert_equal '/anmelden', last_response.headers['location']
    end
  end

  def test_a_guarded_static_file_is_guarded_too
    # The reason the guard is a middleware and not a branch of the routing tree:
    # this is a PNG served by Middleware::Files, which answers before Roda ever
    # sees the request.
    get '/uploads/neumaier-frueher.png'
    assert_equal 302, last_response.status
    assert_equal '/anmelden', last_response.headers['location']
  end

  def test_a_guarded_file_keeps_its_derived_addresses_guarded
    ['/blatt/Gruss-an-Stefan-Waldmann.dc.html',
     '/werkstatt/recherche/achter-stock-freiburg.md'].each do |path|
      get path
      assert_equal 302, last_response.status, "#{path} zeigt denselben Inhalt und erbt den Schutz"
    end
  end

  def test_logging_in_opens_the_guarded_paths
    get '/anmelden'
    assert_equal 200, last_response.status
    token = last_response.body[/name="_csrf"\s+value="([^"]+)"/, 1]
    refute_nil token, 'das Formular muss ein CSRF-Token tragen'

    post '/anmelden', login: ENV['ATLAS_KONTO'], password: 'falsch', _csrf: token
    refute_equal 302, last_response.status, 'ein falsches Passwort meldet nicht an'
    get '/uploads/neumaier-frueher.png'
    assert_equal 302, last_response.status

    post '/anmelden', login: ENV['ATLAS_KONTO'], password: 'probelauf', _csrf: token
    assert_equal 302, last_response.status

    get '/uploads/neumaier-frueher.png'
    assert_equal 200, last_response.status
    assert_equal 'PNG', last_response.body.byteslice(1, 3)

    get '/werkstatt/recherche/achter-stock-freiburg.md'
    assert_equal 200, last_response.status
  end

  def test_an_unguarded_sheet_needs_no_login
    get '/Rumaenien-Physisch.html'
    assert_equal 200, last_response.status
  end

  def test_no_spelling_of_a_guarded_path_gets_through
    # A guard that compares strings guards nothing. Sources::Tree canonicalises
    # before it reads, so "/recherche/./x.md" and "/recherche/x.md" are one file
    # to the reader — and were two strings to the guard. Eight spellings served
    # guarded content without a login before this was closed.
    #
    # Checked on CONTENT, not on the status code: some spellings are rewritten by
    # Roda before the guard sees them and end up on the home page, which is a 200
    # and perfectly harmless. Only the bytes tell the two apart.
    deck = File.read(File.join(ROOT, 'Gruss-an-Stefan-Waldmann.dc.html'))
    note = File.read(File.join(ROOT, 'recherche/sternprodukt-notizen.md'))
    png  = File.read(File.join(ROOT, 'uploads/neumaier-frueher.png'), mode: 'rb')

    {
      '/werkstatt/recherche/./sternprodukt-notizen.md'          => note[200, 60],
      '/werkstatt/./recherche/sternprodukt-notizen.md'          => note[200, 60],
      '/werkstatt/recherche//sternprodukt-notizen.md'           => note[200, 60],
      '/werkstatt/atlas/../recherche/sternprodukt-notizen.md'   => note[200, 60],
      '/werkstatt/recherche/%2e/sternprodukt-notizen.md'        => note[200, 60],
      '/./Gruss-an-Stefan-Waldmann.dc.html'                     => deck[3000, 60],
      '/atlas/../Gruss-an-Stefan-Waldmann.dc.html'              => deck[3000, 60],
      '/uploads/./neumaier-frueher.png'                         => png[100, 40]
    }.each do |path, needle|
      get path
      refute_includes last_response.body.b, needle.b,
                      "#{path} liefert geschützten Inhalt ohne Anmeldung"
    end
  end

  def test_guarded_documents_stay_visible_in_the_workshop
    # Hiding them would be a different answer than locking them.
    get '/werkstatt'
    assert_includes last_response.body, 'nicht öffentlich'
    assert_includes last_response.body, 'href="/werkstatt/recherche/achter-stock-freiburg.md"'
  end

  # --- missing things become visible cases ---------------------------------

  def test_a_missing_document_is_a_case_and_not_a_crash
    get '/werkstatt/recherche/gibtsnicht.md'
    assert_equal 404, last_response.status
    assert_includes last_response.body, 'fehlfall'
    assert_includes last_response.body, 'recherche/gibtsnicht.md'
  end

  def test_a_sheet_without_a_source_register_says_so
    get '/blatt/Rumaenien-Physisch.html'
    assert_includes last_response.body, 'noch kein Quellenregister'
  end

  def test_a_sheet_outside_the_bound_volume_says_so
    get '/blatt/Inhalt.dc.html'
    assert_includes last_response.body, 'Kein Blatt des gebundenen Bandes'
  end

  # --- the register filter -------------------------------------------------

  def test_the_filter_works_without_javascript
    get '/register?q=arad&art=stadt'
    rows = last_response.body.scan(/<tr data-name=/).size
    assert_equal 1, rows, 'the server filters on its own; the form needs no script'

    get '/register?status=unbelegt'
    assert_operator last_response.body.scan(/<tr data-name=/).size, :>, 0
    refute_includes last_response.body, 'status-belegt'
  end

  def test_the_register_links_a_sheet_number_to_its_file
    get '/register'
    assert_includes last_response.body, 'href="/blatt/Rumaenien-Physisch.html"'
  end
end
