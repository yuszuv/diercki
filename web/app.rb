# frozen_string_literal: true

require_relative 'boot'
require 'roda'

module Atlas
  # The web edition of the atlas.
  #
  # Three strands, equal in weight: Blätter (showcase), Register (reference
  # work), Werkstatt (journal) — plus the Blattschau that frames a sheet with its
  # Quellenregister, which is what turns a file listing into an application.
  #
  # Everything is read at runtime: the sheet list from README.md, the names from
  # register.csv, the Blattschlüssel from blaetter.csv, the prose from the .md
  # files. A correction in a file shows up on the next request, and there is no
  # derived copy that can quietly go stale.
  #
  # Where something is missing, nothing is guessed. Every reader returns a
  # Result, and a Failure is rendered as a visible .fehlfall block — the same
  # treatment a Kartenblatt gives a hemp variety with no row in the table.
  #
  # Language, as noted in web/site.js: identifiers and comments are English,
  # user-visible strings, CSS class names and routes are German. The routes are
  # addresses people read and share, so /blaetter it is.
  #
  # The readers are resolved from the container rather than injected: Roda builds
  # one instance per request with new(env), and dry-auto_inject wants the
  # constructor for itself. The container memoises them, so this costs a hash
  # lookup.
  class App < Roda
    include Dry::Monads[:result]
    include Views

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

      # Which commit is serving. bmeise's deploy asks this and fails if it is not
      # the commit it just checked out. Unset outside a built image, and then it
      # says so rather than inventing a value — "arbeitsbaum" can never equal a
      # SHA, which is what keeps the comparison honest.
      r.get('version') do
        response['content-type'] = 'text/plain; charset=utf-8'
        "#{revision || 'arbeitsbaum'}\n"
      end

      r.root { page :start }

      r.on('blaetter') { r.get(true) { page :sheets, title: 'Blätter' } }

      # Both a sheet name and a deck path have to fit: "Rumaenien-Physisch.html"
      # and "praesentationen/Pitch-Hoehle-der-Loewen.dc.html".
      r.on('blatt') { sheet_page(remaining(r)) }

      r.on('register') do
        r.get(true) do
          page :register, title: 'Namensregister',
                          query: r.params['q'].to_s,
                          kind: r.params['art'].to_s,
                          status: r.params['status'].to_s
        end
      end

      # The evidence standing of the whole atlas. /register answers it per entry,
      # the Blattschau per sheet; this is the only place that answers it for the
      # atlas as a thing.
      r.on('belegstand') do
        r.get(true) do
          page :belegstand, title: 'Belegstand',
                            status: r.params['status'].to_s,
                            sheet: r.params['blatt'].to_s
        end
      end

      r.on 'werkstatt' do
        r.get(true) { page :workshop, title: 'Werkstatt' }
        document_page(remaining(r))
      end

      not_found
    end

    error do |e|
      # An exception here is a bug. A missing file is not one — it travels as a
      # Failure and never reaches this point.
      response.status = 500
      @title = 'Etwas ist schiefgegangen'
      view('error', locals: { error: e })
    end

    # REASONS and #open_case come from Views, included above. They used to stand
    # here as well, word for word, and this class overrode the module it had just
    # included — identical today, two opinions about the same Fehlfall tomorrow.

    # --- readers -------------------------------------------------------------

    def sheets     = Container['sources.sheets']
    def register   = Container['sources.register']
    def evidence   = Container['sources.evidence']
    def plates     = Container['sources.plates']
    def workshop   = Container['sources.workshop']
    def restricted = Container['sources.restricted']
    def tree       = Container['sources.tree']
    def markdown   = Container['markdown']

    private

    def remaining(request)
      Rack::Utils.unescape(request.remaining_path.to_s.delete_prefix('/'))
    end

    def page(name, title: nil, **locals)
      @title = title
      view(name.to_s, locals: locals)
    end

    def not_found
      response.status = 404
      page :not_found, title: 'Nichts unter dieser Adresse'
    end

    # --- the Blattschau ------------------------------------------------------

    def sheet_page(file)
      return not_found if file.empty?

      sheet = sheets.find(File.basename(file))
      return not_found if sheet.failure?

      plate = plates.for_file(File.basename(file))
      nr = plate.success? ? plate.value!.nr : nil

      page :sheet,
           title: sheet.value!.title,
           sheet: sheet.value!,
           plate: plate,
           sources: sheet_sources(plate),
           entries: register.for_plate(nr)
    end

    # The Quellenregister of a sheet. Two Failures are possible and they mean
    # different things: no row in blaetter.csv (the Blattschlüssel is
    # incomplete), or a row naming a file that is not there (a broken
    # reference). Both are shown.
    def sheet_sources(plate)
      plate.bind do |p|
        next Failure([:no_source_register, p.file]) unless p.sources_path

        tree.parse(p.sources_path, :html) { |md| markdown.render(md) }
      end
    end

    # --- the workshop document view -----------------------------------------

    def document_page(path)
      return not_found unless path.end_with?('.md')

      rendered = tree.parse(path, :html) { |md| markdown.render(md) }
      if rendered.failure?
        response.status = 404
        return page(:document_missing, title: 'Nicht gefunden', path: path)
      end

      html = rendered.value!
      page :document, title: nil, path: path,
                      html: html, outline: markdown.headings(html)
    end
  end
end
