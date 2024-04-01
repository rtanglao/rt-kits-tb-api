#!/usr/bin/env ruby
require 'rubygems'
require 'amazing_print'
require 'logger'
require 'csv'

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG

if ARGV.length != 2
  puts "usage: #{$0} <csv-file-with-tb-slugs> <csv-file-with-allproducts-ga>"
  exit
end
CSV_WITH_SLUGS = ARGV[0]
CSV_WITH_GA = ARGV[1]
ap CSV.parse(File.read(CSV_WITH_SLUGS), headers: true).by_col[1]
# CSV.foreach(CSV_WITH_GA, headers: true).each do |ga_line|
# end