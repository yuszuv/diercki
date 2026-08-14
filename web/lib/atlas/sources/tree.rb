# frozen_string_literal: true

require 'dry/monads'

module Atlas
  module Sources
    # The one place that touches disk.
    #
    # Every read returns a Result. That is not defensive plumbing: a missing file
    # is a documentation fault and the project rule is that it gets its own
    # visible class rather than a guess or a blank space. Failure is how that
    # travels from here to the template, which renders it as a .fehlfall block.
    #
    # Everything is checked on each request. A corrected file has to show up
    # without a restart — that is the point of reading at runtime, and the dev
    # preview shows the working tree. So #parse keeps a parsed value only for as
    # long as the file's mtime and size are unchanged: one stat per call instead
    # of a read plus a parse. The promise is kept literally; the waste is not.
    #
    # It needs to be here and not in the four readers above it. Measured before
    # the change: the sheet showcase read web/nicht-oeffentlich.csv 27 times per
    # request — once per card — and README.md three times. Fixing that in each
    # reader would be four caches with four chances to invalidate differently.
    class Tree
      include Dry::Monads[:result]

      Entry = Data.define(:name, :path, :directory?)

      def initialize(root: Atlas::ROOT)
        @root = Pathname(root)
        @parsed = {}
        @lock = Mutex.new # Puma serves in threads
      end

      attr_reader :root

      # Read and transform a file, remembering the result until the file
      # changes. `tag` separates two parses of the same file.
      #
      # @yieldparam [String] the file's contents
      # @return [Dry::Monads::Result]
      def parse(path, tag)
        stamp = stamp_for(path)
        return read(path) if stamp.nil? # missing, unreadable, outside — let read say which

        key = [path.to_s, tag]
        @lock.synchronize do
          remembered = @parsed[key]
          return remembered.last if remembered && remembered.first == stamp
        end

        value = read(path).fmap { |text| yield(text) }
        @lock.synchronize { @parsed[key] = [stamp, value] }
        value
      end

      # @return [Dry::Monads::Result<String>]
      def read(path)
        full = resolve(path)
        return Failure([:outside_tree, path.to_s]) unless full
        return Failure([:missing, path.to_s]) unless full.file?

        Success(full.read)
      rescue SystemCallError => e
        Failure([:unreadable, "#{path} — #{e.class}"])
      end

      # @return [Dry::Monads::Result<Array<Entry>>]
      def list(path)
        full = resolve(path)
        return Failure([:outside_tree, path.to_s]) unless full
        return Failure([:missing, path.to_s]) unless full.directory?

        entries = full.children.sort_by { |c| c.basename.to_s.downcase }.map do |child|
          Entry.new(name: child.basename.to_s,
                    path: child.relative_path_from(root).to_s,
                    directory?: child.directory?)
        end
        Success(entries)
      rescue SystemCallError => e
        Failure([:unreadable, "#{path} — #{e.class}"])
      end

      def exist?(path)
        full = resolve(path)
        !full.nil? && full.exist?
      end

      # Markdown files of a directory, names only, sorted. Missing directories
      # stay a Failure — the workshop lists them as an open case rather than as
      # an empty section, which would look like "there is nothing here".
      def markdown_in(path)
        list(path).fmap { |entries| entries.reject(&:directory?).select { |e| e.name.end_with?('.md') } }
      end

      private

      # Identity of a file, or nil if there is none to speak of. Cheap enough to
      # do on every request — that is what buys the freshness guarantee.
      def stamp_for(path)
        full = resolve(path)
        return nil unless full

        stat = full.stat
        stat.file? ? [stat.mtime, stat.size] : nil
      rescue SystemCallError
        nil
      end

      # Containment check. The routes below hand user input straight in
      # (/werkstatt/<path>), so ../ has to die here rather than in each caller.
      def resolve(path)
        candidate = root.join(path.to_s).cleanpath
        return nil unless candidate.to_s == root.to_s || candidate.to_s.start_with?("#{root}/")

        candidate
      end
    end
  end
end
