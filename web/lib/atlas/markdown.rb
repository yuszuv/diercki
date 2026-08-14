# frozen_string_literal: true

require 'kramdown'
require 'kramdown-parser-gfm'

module Atlas
  # The repo's own .md files, rendered for the workshop.
  #
  # GFM, because these documents are largely tables — README, BLAETTER, SORTEN,
  # the source registers — and the plain kramdown parser does not read them.
  # This replaces the hand-written renderer in web/md.js, which existed only
  # because the browser had no library available offline; a Ruby process has one.
  class Markdown
    OPTIONS = {
      input: 'GFM',
      hard_wrap: false,           # a line break in the source is not a <br>
      auto_ids: true,             # headings get ids, the table of contents links to them
      syntax_highlighter: nil,    # code blocks stay plain; site.css sets them
      smart_quotes: %w[sbquo lsquo bdquo ldquo] # German quotes: ‚ ' „ "
    }.freeze

    def render(text) = Kramdown::Document.new(text.to_s, **OPTIONS).to_html

    # Headings for the table of contents. Derived from the rendered HTML rather
    # than re-parsed from the source, so the ids are the ones actually in the
    # document — a second derivation would be a second chance to disagree.
    Heading = Data.define(:level, :text, :id)

    def headings(html)
      html.scan(%r{<h([23])\s+id="([^"]+)">(.*?)</h\1>}m).map do |level, id, inner|
        Heading.new(level: level.to_i, text: inner.gsub(/<[^>]+>/, '').strip, id:)
      end
    end
  end
end
