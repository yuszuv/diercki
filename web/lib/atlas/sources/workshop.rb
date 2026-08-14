# frozen_string_literal: true

module Atlas
  module Sources
    # The workshop: not a sheet, but the scaffolding underneath — source
    # registers, research notes, rules, catalogues.
    #
    # The registers and the notes are read from their directories, so a file
    # added there appears without anyone editing a list. FIXED names what lies
    # outside them and nothing else — it exists for the title ("Verbindliche
    # Regeln" beats "claude"), and that mapping has to live somewhere.
    class Workshop
      include Atlas::Import['sources.tree']

      SOURCES_DIR = 'atlas/quellen'
      NOTES_DIR = 'recherche'

      # An authoring convention, not a derived flag: a note files itself as
      # finished by opening with a blockquote whose bold run starts "Erledigt".
      DONE = /^>\s*\*\*Erledigt\b/
      DONE_WITHIN = 12

      FIXED = [
        ['Aufbau des Repos', 'README.md'],
        ['Die Webanwendung', 'WEB-APPLICATION.md'],
        ['Arbeiten an zwei Orten', 'TWO-PLACES.md'],
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

      # Swallows the Failure on purpose, unlike every other reader here: the
      # document is listed and linked either way, only its heading depends on
      # this read.
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
