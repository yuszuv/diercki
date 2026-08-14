# frozen_string_literal: true

require 'concurrent/map'
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
    # the change: the sheet showcase read web/geschuetzt.csv 27 times per
    # request — once per card — and README.md three times. Fixing that in each
    # reader would be four caches with four chances to invalidate differently.
    class Tree
      include Dry::Monads[:result]

      Entry = Data.define(:name, :path, :directory?)

      def initialize(root: Atlas::ROOT)
        @root = Pathname(root)
        @parsed = Concurrent::Map.new # Puma serves in threads
      end

      attr_reader :root

      # Read and transform a file, remembering the result until the file
      # changes. `tag` separates two parses of the same file.
      #
      # **The block must be pure.** It gets the file's contents and nothing else,
      # and on a memo hit it is not called at all — so a block that closes over
      # request state would let the first visitor decide what everybody after
      # them sees. Nothing enforces this; it is a contract.
      #
      # `tag` is what separates two parses of the same file, so two callers
      # should only share one by decision. Note that :html is used by both
      # App#sheet_sources and App#document_page, and their path spaces overlap in
      # atlas/quellen/ — that works because their blocks are identical, which is
      # a fact about today rather than a guarantee.
      #
      # Two threads asking for the same stale file both parse it, and the second
      # store wins. That is deliberate: the map is a memo, not a work queue, and
      # both threads compute the same value from the same bytes. Single-flight
      # would mean holding a lock across a read and a parse — the one place where
      # a slow disk could stall every other request.
      #
      # @yieldparam [String] the file's contents
      # @return [Dry::Monads::Result]
      def parse(path, tag)
        full = resolve(path)
        stamp = stamp_for(full)
        return read(path) if stamp.nil? # missing, unreadable, outside — let read say which

        # Keyed on the resolved path, not on the way it was spelled. Otherwise
        # "atlas/GLOSSAR.md" and "./atlas/GLOSSAR.md" are two entries for one
        # file — and /werkstatt/<path> takes user input, so an unbounded number
        # of spellings could each hold their own copy of the rendered HTML.
        key = [full.to_s, tag]
        remembered = @parsed[key]
        return remembered.last if remembered && remembered.first == stamp

        value = read_at(full).fmap { |text| yield(text) }

        # Only remember it if the file did not move underneath us. Between the
        # stat above and the read just now it may have been rewritten: the value
        # then describes the new bytes while the stamp describes the old ones,
        # and storing that pair labels a value with something it is not.
        #
        # On its own this check is worth little — that interleaving heals at the
        # next request anyway, because the stamp misses. What makes the pair
        # trustworthy is ctime being part of the stamp (see #stamp_for); this is
        # the cheap second belt, one stat and only on a miss.
        @parsed[key] = [stamp, value] if stamp_for(full) == stamp
        value
      end

      # @return [Dry::Monads::Result<String>]
      def read(path)
        full = resolve(path)
        return Failure([:outside_tree, path.to_s]) unless full

        read_at(full)
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

      # Reading from an already-resolved path, so #parse does not resolve twice.
      def read_at(full)
        return Failure([:missing, relative(full)]) unless full.file?

        Success(full.read)
      rescue SystemCallError => e
        Failure([:unreadable, "#{relative(full)} — #{e.class}"])
      end

      # Identity of a file, or nil if there is none to speak of. Takes the
      # resolved path — cheap enough to do twice per miss, which is what buys
      # both the freshness guarantee and the check that nothing moved mid-parse.
      #
      # ctime is in there, and it is the part that makes this an identity rather
      # than a guess. mtime and size alone can be made to recur with different
      # contents: `File.utime` puts mtime back, and a same-length rewrite keeps
      # the size — that is what rsync -a, cp -p, tar -x and a backup rollback do.
      # A stamp that recurred would match forever, and a corrected file would
      # stop appearing, which is the one failure this project must not have.
      #
      # ctime cannot be set from userspace: the kernel stamps it on every inode
      # change, including the utime call that forges mtime. Measured — with
      # mtime and size restored byte for byte, ctime still differs. It comes out
      # of the same stat, so it costs nothing.
      def stamp_for(full)
        return nil unless full

        stat = full.stat
        stat.file? ? [stat.mtime, stat.size, stat.ctime] : nil
      rescue SystemCallError
        nil
      end

      # Failures name the path as the repo sees it, not as an absolute path —
      # they end up on a page.
      def relative(full) = full.relative_path_from(root).to_s

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
