# frozen_string_literal: true

require_relative 'boot'
require 'roda'

module Atlas
  # The web edition of the atlas.
  #
  # Three strands, equal in weight: Blätter (showcase), Register (reference
  # work), Werkstatt (journal) — plus the sheet view that frames a sheet with
  # its source register, which is what turns a file listing into an application.
  #
  # Everything is read at runtime: the sheet list from README.md, the names from
  # register.csv, the sheet key from blaetter.csv, the prose from the .md files.
  # A correction in a file shows up on the next request, and there is no derived
  # copy that can quietly go stale.
  #
  # Where something is missing, nothing is guessed. Every reader returns a
  # Result, and a Failure is rendered as a visible .fehlfall block — the same
  # treatment a map sheet gives a hemp variety with no row in the table.
  #
  # The readers are resolved from the container rather than injected: Roda
  # builds one instance per request with new(env), and dry-auto_inject wants the
  # constructor for itself. The container memoises them, so this costs a hash
  # lookup.
  class App < Roda
    include Dry::Monads[:result]

    plugin :render,
           views: File.join(__dir__, 'templates'),
           # :engine doubles as the file extension in Roda. "html.erb" so a
           # template says what it produces, not only how.
           engine: 'html.erb',
           layout: 'layout',
           escape: true # <%= %> escapes; <%== %> is the deliberate exception

    plugin :error_handler
    plugin :h # for the few places that build markup in a loop
    plugin :head
    plugin :default_headers,
           'content-type' => 'text/html; charset=utf-8',
           'x-content-type-options' => 'nosniff',
           'referrer-policy' => 'same-origin'

    # No CSRF plugin: the atlas holds no accounts and no form that writes. The
    # register filter is a GET. Named here so the absence stays a decision.

    route do |r|
      r.get('health') do
        response['content-type'] = 'text/plain; charset=utf-8'
        "ok\n"
      end

      r.root { page :start }

      r.on('blaetter') { r.get(true) { page :blaetter, titel: 'Blätter' } }

      # Both a sheet name and a deck path have to fit: "Rumaenien-Physisch.html"
      # and "praesentationen/Pitch-Hoehle-der-Loewen.dc.html".
      r.on('blatt') { sheet_page(remaining(r)) }

      r.on('register') do
        r.get(true) do
          page :register, titel: 'Namensregister',
                          query: r.params['q'].to_s,
                          art: r.params['art'].to_s,
                          status: r.params['status'].to_s
        end
      end

      r.on 'werkstatt' do
        r.get(true) { page :werkstatt, titel: 'Werkstatt' }
        document_page(remaining(r))
      end

      # Wer nichts Bestimmtes sucht, fängt irgendwo an. A redirect rather than
      # the browser deciding: the destination stays a real, shareable address,
      # and the button works without JavaScript.
      r.get('zufall') { r.redirect random_destination }

      not_found
    end

    error do |e|
      # An exception here is a bug. A missing file is not one — it travels as a
      # Failure and never reaches this point.
      response.status = 500
      @titel = 'Etwas ist schiefgegangen'
      view('fehler', locals: { fehler: e })
    end

    # --- readers -------------------------------------------------------------

    # --- view helpers --------------------------------------------------------

    def kopf(titel, vorspann = nil)
      render('_kopf', locals: { titel: titel, vorspann: vorspann })
    end

    # Every Failure becomes one of these. The wording per reason lives in one
    # place so the same missing file reads the same way wherever it turns up.
    GRUENDE = {
      missing: 'Die Datei liegt nicht im Repo. Wer den Verweis gesetzt hat, hat ihn nicht geprüft.',
      unreadable: 'Die Datei ist da, ließ sich aber nicht lesen.',
      outside_tree: 'Der Pfad zeigt aus dem Repo heraus und wird nicht ausgeliefert.',
      not_listed: 'Diese Datei steht in keiner Blätter-Tabelle der README.',
      no_plate_row: 'Für dieses Blatt gibt es keine Zeile in atlas/blaetter.csv — ohne sie ist keine Blattnummer und kein Quellenregister zugeordnet.',
      no_source_register: 'Für dieses Blatt gibt es noch kein Quellenregister unter atlas/quellen/.'
    }.freeze

    def fehlfall(result, titel: 'Offener Fall')
      grund, pfad = result.failure
      render('_fehlfall',
             locals: { titel: titel, pfad: pfad,
                       grund: GRUENDE.fetch(grund, grund.to_s) })
    end

    def sheets    = Container['sources.sheets']
    def register  = Container['sources.register']
    def plates    = Container['sources.plates']
    def workshop   = Container['sources.workshop']
    def restricted = Container['sources.restricted']
    def tree      = Container['sources.tree']
    def markdown  = Container['markdown']

    private

    def remaining(request)
      Rack::Utils.unescape(request.remaining_path.to_s.delete_prefix('/'))
    end

    def page(name, titel: nil, **locals)
      @titel = titel
      view(name.to_s, locals: locals)
    end

    def not_found
      response.status = 404
      page :nicht_gefunden, titel: 'Nichts unter dieser Adresse'
    end

    # --- the sheet view ------------------------------------------------------

    def sheet_page(file)
      return not_found if file.empty?
      return request.redirect("/#{file}") if restricted.restricted?("/#{file}")

      sheet = sheets.find(File.basename(file))
      return not_found if sheet.failure?

      plate = plates.for_file(File.basename(file))
      nr = plate.success? ? plate.value!.nr : nil

      page :blatt,
           titel: sheet.value!.title,
           blatt: sheet.value!,
           plate: plate,
           quellen: sheet_sources(plate),
           eintraege: register.for_plate(nr)
    end

    # The source register of a sheet. Two Failures are possible and they mean
    # different things: no row in blaetter.csv (the key is incomplete), or a row
    # naming a file that is not there (a broken reference). Both are shown.
    def sheet_sources(plate)
      plate.bind do |p|
        next Failure([:no_source_register, p.file]) unless p.sources_path

        tree.parse(p.sources_path, :html) { |md| markdown.render(md) }
      end
    end

    # --- the workshop document view -----------------------------------------

    def document_page(path)
      return not_found unless path.end_with?('.md')

      # Not a second gate — a refusal to open a second door. The password prompt
      # lives at the original address; this route must not walk around it.
      return request.redirect("/#{path}") if restricted.restricted?("/#{path}")

      rendered = tree.parse(path, :html) { |md| markdown.render(md) }
      if rendered.failure?
        response.status = 404
        return page(:dokument_fehlt, titel: 'Nicht gefunden', pfad: path)
      end

      html = rendered.value!
      page :dokument, titel: nil, pfad: path,
                      html: html, gliederung: markdown.headings(html)
    end

    # --- the random entry point ---------------------------------------------

    # Nothing restricted in the lucky dip: a password prompt is a poor answer to
    # "fang irgendwo an".
    def random_destination
      by_sheet = sheets.all.value_or([])
                       .reject { |s| restricted.restricted?("/#{s.file}") }
                       .map { |s| "/blatt/#{s.file}" }
      by_name = register.all.value_or([]).map { |e| "/register?q=#{Rack::Utils.escape(e.name)}" }
      (by_sheet + by_name).sample || '/'
    end
  end
end
