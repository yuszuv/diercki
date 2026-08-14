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
      '/zufall' => 302,
      '/gibtsnicht' => 404 }.each do |path, status|
      get path
      assert_equal status, last_response.status, "#{path} sollte #{status} liefern"
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
    assert_equal 16, sheets.reject(&:deck?).size, 'Blätter aus den README-Tabellen'
    assert_equal 11, sheets.select(&:deck?).size, 'Präsentationen'

    entries = Atlas::Container['sources.register'].all.value!
    assert_equal 272, entries.size, 'Einträge in atlas/register.csv'
    assert_equal 86, entries.count(&:field), 'Suchgitterfelder — alle auf Blatt 4'
    assert entries.select(&:field).all?(&:on_grid_sheet?),
           'ein Feld darf nur auf dem Blatt mit Suchgitter stehen'
  end

  def test_the_sheet_key_marks_its_numbers_as_derived
    plates = Atlas::Container['sources.plates'].all.value!
    numbered = plates.select(&:numbered?)
    assert_equal (1..9).to_a, numbered.map(&:nr).sort
    assert numbered.all?(&:derived?),
           'die Blattnummern sind erschlossen, nicht belegt — siehe atlas/BLAETTER.md'
  end

  def test_no_sheet_number_is_cited_without_a_file
    plates = Atlas::Container['sources.plates']
    cited = Atlas::Container['sources.register'].cited_numbers
    assert_empty plates.unmapped(cited),
                 'register.csv nennt eine Blattnummer, die atlas/blaetter.csv nicht kennt'
  end

  # --- reading at runtime --------------------------------------------------

  def test_a_corrected_file_shows_up_without_a_restart
    # Tree#parse behält ein Ergebnis nur, solange mtime und Größe gleich
    # bleiben. Diese Zusage trägt die ganze Bauweise: keine abgeleitete Kopie,
    # die still veraltet. Ein Cache, der sie bräche, wäre schlimmer als der
    # Aufwand, den er spart.
    Dir.mktmpdir do |dir|
      file = File.join(dir, 'probe.csv')
      File.write(file, "a;b\n1;2\n")

      tree = Atlas::Container['sources.tree'].class.new(root: dir)
      parses = 0
      counted = ->(text) { parses += 1; text.lines.size }

      assert_equal 2, tree.parse('probe.csv', :lines, &counted).value!
      assert_equal 2, tree.parse('probe.csv', :lines, &counted).value!
      assert_equal 1, parses, 'unverändert: einmal geparst, dann gemerkt'

      # mtime auf ganze Sekunden gerundet auf manchen Dateisystemen — die Größe
      # ändert sich hier ohnehin mit.
      File.write(file, "a;b\n1;2\n3;4\n")
      assert_equal 3, tree.parse('probe.csv', :lines, &counted).value!
      assert_equal 2, parses, 'geändert: neu geparst'

      # Verschiedene Auswertungen derselben Datei stehen nebeneinander.
      tree.parse('probe.csv', :andere) { |t| t.length }
      assert_equal 3, tree.parse('probe.csv', :lines, &counted).value!
      assert_equal 2, parses, 'ein zweiter tag verdrängt den ersten nicht'
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

    refute_includes body, 'https://unpkg.com', 'keine CDN-Adresse darf übrig bleiben'
    refute_includes body, 'https://cdn.jsdelivr.net'
    assert_includes body, '/vendor/unpkg/d3@7.9.0/dist/d3.min.js'
    # Die Hashes stehen neben den Skripten und müssen weiter passen — die
    # eingebackenen Dateien sind byte-gleich, bin/vendor.rb prüft das.
    assert_includes body, 'sha384-CjloA8y00'
  end

  def test_the_sheets_on_disk_are_untouched
    # Die Umschrift geschieht im Ausgang. Stünde sie auf der Platte, sähe jeder
    # künftige Export wie ein Konflikt aus.
    original = File.read(File.join(ROOT, 'Rumaenien-Physisch.html'))
    assert_includes original, 'https://unpkg.com/d3@7.9.0/dist/d3.min.js'
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
                 'Rohlieferungen gehören nicht zum Atlas und werden nicht ausgeliefert'
  end

  def test_a_path_cannot_leave_the_tree
    get '/werkstatt/../../etc/passwd'
    assert_equal 404, last_response.status
  end

  # --- access protection ---------------------------------------------------
  #
  # Der Caddy des Hosts schützt Adressen; diese Anwendung erfindet für denselben
  # Inhalt neue. Ohne diese Prüfungen wäre der Schutz umgangen, und nichts sähe
  # dabei kaputt aus.

  def test_restricted_paths_get_no_second_address
    Atlas::Container['sources.restricted'].all.value!.each do |rule|
      next unless rule.path.end_with?('.md')

      get "/werkstatt#{rule.path}"
      assert_equal 302, last_response.status, "#{rule.path} darf nicht gerendert werden"
      assert_equal rule.path, last_response.headers['location']
    end

    get '/blatt/Gruss-an-Stefan-Waldmann.dc.html'
    assert_equal 302, last_response.status
    assert_equal '/Gruss-an-Stefan-Waldmann.dc.html', last_response.headers['location']
  end

  def test_restricted_documents_stay_visible_in_the_workshop
    # Verschweigen wäre eine andere Auskunft als verschließen.
    get '/werkstatt'
    assert_includes last_response.body, 'nicht öffentlich'
    assert_includes last_response.body, 'href="/recherche/achter-stock-freiburg.md"'
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
    assert_equal 1, rows, 'der Server filtert selbst, das Formular braucht kein Skript'

    get '/register?status=unbelegt'
    assert_operator last_response.body.scan(/<tr data-name=/).size, :>, 0
    refute_includes last_response.body, 'status-belegt'
  end

  def test_the_register_links_a_sheet_number_to_its_file
    get '/register'
    assert_includes last_response.body, 'href="/blatt/Rumaenien-Physisch.html"'
  end
end
