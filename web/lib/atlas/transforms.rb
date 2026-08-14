# frozen_string_literal: true

module Atlas
  # The parse pipelines. Two inputs, both maintained by hand and both read at
  # runtime: the sheet tables in README.md and the semicolon CSVs under atlas/.
  #
  # These used to live in web/site.js. Splitting them into named steps is not
  # decoration — it is what makes "drop the divider row" and "keep only rows
  # whose first cell is an HTML file" reviewable as separate claims, and lets the
  # sheet table and the deck table share every step but the heading they start
  # at.
  #
  # Plain module functions. dry-transformer sat here for a while and earned
  # nothing: two of its three imports went unused, exactly one function
  # (map_array) was called, the composition had to be broken open anyway because
  # #section takes a second argument, and #sheets rebuilt the whole chain on
  # every call only to invoke it once. The named steps below were always what
  # carried the argument; the Registry around them did not.
  module Transforms
    module_function

    def lines(text)
      text.to_s.gsub(/\r\n?/, "\n").split("\n")
    end

    # Everything below a `## Heading` line, up to the next heading of any level.
    def section(lines, heading)
      start = lines.index { |l| l.strip == heading }
      return [] unless start

      lines[(start + 1)..].to_a.take_while { |l| !l.match?(/\A\#{1,6}\s/) }
    end

    # A markdown table row into its cells. Leading and trailing pipes are the
    # frame, not a cell.
    def pipe_cells(line)
      line.sub(/\A\s*\|/, '').sub(/\|\s*\z/, '').split('|').map(&:strip)
    end

    def table_rows(lines)
      lines
        .select { |l| l.include?('|') }
        .reject { |l| l.match?(/\A\s*\|?[\s:|-]+\z/) } # the |---|---| divider
        .map { |l| pipe_cells(l) }
        .select { |cells| cells.length >= 2 }
    end

    # Only rows whose first cell names an HTML file. The README tables carry
    # other rows too (the "Zuordnungstabellen" table, for one).
    def html_rows(rows)
      rows.select { |cells| cells[0].delete('`').strip.match?(/\.html\z/) }
    end

    def to_sheet(cells)
      { file: cells[0].delete('`').strip, text: cells[1].to_s }
    end

    # Semicolon CSV as the atlas writes it: # comments, then a header row.
    # Deliberately not the csv stdlib — these files carry no quoting and no
    # embedded semicolons, and reading them literally keeps the failure mode
    # obvious if they ever do.
    def drop_comments(lines)
      lines.reject { |l| l.strip.empty? || l.start_with?('#') }
    end

    def semicolon_table(lines)
      return [] if lines.empty?

      head = lines.first.split(';').map { |c| c.strip.to_sym }
      lines.drop(1).map do |line|
        cells = line.split(';', -1)
        head.each_with_index.to_h { |key, i| [key, cells[i].to_s.strip] }
      end
    end

    # An empty cell and an absent one mean the same thing in these files: no
    # value. Saying so once beats three readers each having their own opinion.
    def presence(value)
      trimmed = value.to_s.strip
      trimmed.empty? ? nil : trimmed
    end

    # --- the two pipelines ---------------------------------------------------

    # README.md → the sheets of one table. The heading is the only difference
    # between the sheet list, the "further sheets" list and the decks.
    def sheets(markdown, heading)
      html_rows(table_rows(section(lines(markdown), heading))).map { |cells| to_sheet(cells) }
    end

    # register.csv, blaetter.csv, geschuetzt.csv → symbol-keyed rows.
    def rows(text)
      semicolon_table(drop_comments(lines(text)))
    end
  end
end
