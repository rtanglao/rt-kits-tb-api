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

slugs = CSV.parse(File.read(CSV_WITH_SLUGS), headers: true).by_col[1].map(&:downcase)
ap slugs
tb_ga_csv = []
CSV.foreach(CSV_WITH_GA, headers: true).each do |ga_line|
  ga_l = ga_line.to_hash
  ap ga_l
  next if ga_l['Page'].nil?

  page = ga_l['Page'].downcase
  tb_ga_csv.push(ga_l) if page.include?('thunderbird') || slugs.include?(page)
end
ap tb_ga_csv
ap tb_ga_csv.first
ap tb_ga_csv.first.keys

TB_GA_OUTPUT_CSV = "just-thunderbird-desktop-articles-#{CSV_WITH_GA}".freeze
CSV.open(TB_GA_OUTPUT_CSV, 'w') do |csv|
  csv << tb_ga_csv.first.keys # adds the attributes name on the first line
  tb_ga_csv.each do |hash|
    csv << hash.values
  end
end
