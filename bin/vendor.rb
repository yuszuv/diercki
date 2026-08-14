#!/usr/bin/env ruby
# frozen_string_literal: true

#
# vendor.rb — fetch the libraries the sheets would otherwise pull from a CDN.
#
# The list lives in web/lib/atlas/vendor.rb and nowhere else; this script and the
# rewrite middleware read the same hash. It used to exist three times: twice as
# sub_filter blocks in web/nginx.conf and once as a shell function here in the
# Dockerfile.
#
# Usage:  ruby bin/vendor.rb                    # into .vendor/
#         ruby bin/vendor.rb /opt/vendor        # into a given directory
#         ATLAS_VENDOR_DIR=… ruby bin/vendor.rb
#
# Needs the network, and only here — nothing else in the atlas does. Once the
# files are down, the preview and the served site work with the network unplugged.
#
# Exits non-zero on a download failure or an SRI mismatch. That is deliberate:
# a mismatched d3 would make the browser silently refuse the script later, and
# the sheet would come up blank with nothing in the log to explain it.

require 'net/http'
require 'uri'
require 'fileutils'
require 'pathname'

ROOT = Pathname(File.expand_path('..', __dir__))
require_relative '../web/lib/atlas/vendor'

TARGET = Pathname(ARGV[0] || ENV['ATLAS_VENDOR_DIR'] || ROOT.join('.vendor').to_s)

def fetch(url, redirects: 3)
  raise "too many redirects for #{url}" if redirects.negative?

  response = Net::HTTP.get_response(URI(url))
  case response
  when Net::HTTPSuccess then response.body
  when Net::HTTPRedirection then fetch(response['location'], redirects: redirects - 1)
  else raise "#{response.code} #{response.message} for #{url}"
  end
end

failures = []
unchanged = 0

Atlas::Vendor::LIBRARIES.each do |url, relative|
  path = TARGET.join(relative)
  FileUtils.mkdir_p(path.dirname)

  if path.file? && !ENV['ATLAS_VENDOR_FORCE']
    unchanged += 1
    next
  end

  begin
    path.binwrite(fetch(url))
  rescue StandardError => e
    failures << "#{relative}: #{e.message}"
    next
  end

  # Verify rather than hope. Two sheets carry these hashes as integrity
  # attributes; a mismatch here is the last place it can still be said out loud.
  expected = Atlas::Vendor::INTEGRITY[relative]
  next unless expected

  actual = Atlas::Vendor.integrity_for(path)
  next if actual == expected

  failures << "#{relative}: SRI mismatch\n    expected #{expected}\n    got      #{actual}"
  path.delete
end

count = Atlas::Vendor::LIBRARIES.size
puts "#{count - failures.size - unchanged} fetched, #{unchanged} already there, " \
     "#{Atlas::Vendor::INTEGRITY.size} hashes verified → #{TARGET}"

unless failures.empty?
  warn "\nFailed:"
  failures.each { |f| warn "  #{f}" }
  exit 1
end
