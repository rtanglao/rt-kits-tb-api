#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'typhoeus'
require 'amazing_print'
require 'json'
require 'time'
require 'date'
require 'csv'
require 'logger'
require 'pry'
require_relative 'get-kitsune-response'

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG

if ARGV.length < 1
  puts "usage: #{$0} <csv-file-with-slugs>"
  exit
end
article_number = 0
CSV_SUMMARY_FILE = ARGV[0]
logger.debug "CSV_SUMMARY_FILE: #{CSV_SUMMARY_FILE}"
csv = []
url_params = { format: 'json' }
CSV.foreach(CSV_SUMMARY_FILE, headers: true).each do |a|
  a = a.to_hash
  slug = a['slug']
  url = "https://support.mozilla.org/api/1/kb/#{slug}"
  article = getKitsuneResponse(url, url_params, logger)
  next if article.nil?

  article = article.to_hash
  article['products_str'] = article['products'].join(';')
  article['topics_str'] = article['topics'].join(';')
  logger.debug article.ai
  csv.push(article.except('products', 'topics'))
  sleep(0.125) # sleep 1/8 second between API calls
end

headers = csv[0].keys
CSV.open("details-#{CSV_SUMMARY_FILE}", 'w', write_headers: true, headers: headers) do |csv_object|
  csv.each { |row_array| csv_object << row_array }
end
