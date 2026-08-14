# frozen_string_literal: true

module Atlas
  # View helpers shared by the two Roda apps. Atlas::App renders the atlas;
  # Atlas::AuthApp renders the login and logout pages — and both use the same
  # layout, the same heading and the same box for an open case, because to a
  # reader they are one site.
  module Views
    def heading(title, lead = nil)
      render('_heading', locals: { title: title, lead: lead })
    end

    # Every Failure becomes one of these. The wording per reason lives in one
    # place so the same missing file reads the same way wherever it turns up.
    REASONS = {
      missing: 'Die Datei liegt nicht im Repo. Wer den Verweis gesetzt hat, hat ihn nicht geprüft.',
      unreadable: 'Die Datei ist da, ließ sich aber nicht lesen.',
      outside_tree: 'Der Pfad zeigt aus dem Repo heraus und wird nicht ausgeliefert.',
      not_listed: 'Diese Datei steht in keiner Blätter-Tabelle der README.',
      not_a_directory: 'Dieses Verzeichnis gibt es nicht.',
      no_plate_row: 'Für dieses Blatt gibt es keine Zeile in atlas/blaetter.csv — ohne sie ist ' \
                    'keine Blattnummer und kein Quellenregister zugeordnet.',
      no_source_register: 'Für dieses Blatt gibt es noch kein Quellenregister unter atlas/quellen/.',
      no_sheet_number: 'Ohne Blattnummer lässt sich im Namensregister nichts nachschlagen — ' \
                       'es führt seine Einträge über die Nummern des gebundenen Bandes.'
    }.freeze

    def open_case(result, title: 'Offener Fall')
      reason, path = result.failure
      render('_open_case',
             locals: { title: title, path: path,
                       reason: REASONS.fetch(reason, reason.to_s) })
    end

    # Whether anybody is logged in, for the navigation. AuthApp puts rodauth into
    # the env for every request, so both apps can ask.
    def logged_in? = request.env['rodauth']&.logged_in? || false
  end
end
