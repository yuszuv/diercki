# frozen_string_literal: true

module Atlas
  module Sources
    # The workshop: not a sheet, but the scaffolding underneath — source
    # registers, research notes, rules, catalogues.
    #
    # Two of the three sections are read from the directory, so a note added
    # under recherche/ appears without anyone editing a list. The third is a
    # fixed list, because "Verbindliche Regeln" is a better label for CLAUDE.md
    # than "claude", and that mapping has to live somewhere.
    class Workshop
      include Atlas::Import['sources.tree']

      SOURCES_DIR = 'atlas/quellen'
      NOTES_DIR = 'recherche'

      # A note says for itself when it is finished: a blockquote among its first
      # lines whose bold run opens with "Erledigt". The file is the only place
      # that knows, and it is read while the request runs — a list of finished
      # notes kept beside the directory would be a second thing to keep in step,
      # and it would go stale exactly when someone finishes a note in a hurry.
      #
      # Saying nothing counts as running, and that is the safe way round: a note
      # that makes no claim has not claimed the work is done.
      DONE = /^>\s*\*\*Erledigt\b/
      DONE_WITHIN = 12

      FIXED = [
        ['Aufbau des Repos', 'README.md'],
        ['Die Webanwendung', 'WEB-APPLICATION.md'],
        ['Arbeiten an zwei Orten', 'TWO-PLACES.md'],
        ['Was in bmeise nachzuziehen ist', 'recherche/bmeise-nachzuziehen.md'],
        ['Umbau: Konfiguration über dry-system', 'recherche/settings-umbau.md'],
        ['Verbindliche Regeln', 'CLAUDE.md'],
        ['Einstieg für Agents', 'AGENTS.md'],
        ['Glossar der Fachbegriffe', 'atlas/GLOSSAR.md'],
        ['Signaturenkatalog — Regeln', 'atlas/SIGNATUREN.md'],
        ['Blattschlüssel — Nummer zu Datei', 'atlas/BLAETTER.md'],
        ['Welches Skript welche Datei erzeugt', 'atlas/geodaten/LIESMICH.md'],
        ['Hanfsorten und Nutzungsrichtung', 'atlas/geodaten/brandenburg/SORTEN.md'],
        ['Klimastationen', 'atlas/geodaten/brandenburg/KLIMA.md'],
        ['Geodaten Brandenburg', 'atlas/geodaten/brandenburg/README.md'],
        ['Was an Daten fehlt', 'DATENBEDARF.md'],
        ['Backlog und lose Enden', 'IDEEN.md'],
        ['Repo-Bindung und Sync-Stand', 'github.md']
      ].freeze

      Document = Data.define(:title, :path)

      def source_registers = documents_in(SOURCES_DIR)

      # Running and finished from one listing: the split is a property of the
      # files themselves, so it costs a stat each and not a second walk.
      def notes
        documents_in(NOTES_DIR).fmap do |documents|
          running, finished = documents.partition { |doc| running?(doc) }
          { running:, finished: }
        end
      end

      # Kept as a Result even though the list is a constant: a fixed entry can
      # point at a file that has been renamed, and that is a documentation fault
      # like any other. Missing ones are reported, not dropped.
      def catalogues
        present, absent = FIXED.partition { |(_, path)| tree.exist?(path) }
        { present: present.map { |title, path| Document.new(title:, path:) },
          absent: absent.map { |_, path| path } }
      end

      private

      # The document is listed and linked either way — only the heading it lands
      # under depends on this read. So an unreadable head leaves it among the
      # running ones instead of becoming a case of its own: there is nothing
      # missing to draw, and the note is still right there to open.
      def running?(doc)
        tree.parse(doc.path, :abschluss) { |text|
          text.lines.first(DONE_WITHIN).none? { |line| line.match?(DONE) }
        }.value_or(true)
      end

      def documents_in(dir)
        tree.markdown_in(dir).fmap do |entries|
          entries.map { |e| Document.new(title: prettify(e.name), path: e.path) }
        end
      end

      # "uebergabe-2026-08-07.md" → "uebergabe 2026 08 07"
      def prettify(name) = name.sub(/\.md\z/, '').tr('-', ' ')
    end
  end
end
