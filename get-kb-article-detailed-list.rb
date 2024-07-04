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
require 'uri'
require 'ghostwriter'

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG

if ARGV.empty?
  puts "usage: #{$PROGRAM_NAME} <csv-file-with-slugs>"
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
  html_with_link_anchors_fixed = article['html'].gsub('href="#w', "href=\"/kb/#{slug}#w")
  logger.debug "html_with_link_anchors_fixed: #{html_with_link_anchors_fixed.ai}"
  # FIXME: get rid of regex by fixing ghostwriter see https://github.com/rtanglao/rt-kits-tb-api/issues/2 :-)
  article['text'] = if slug =~ /(dangerous-directories-Thunderbird-account-settings|keyboard-shortcuts-thunderbird)/i
                      Nokogiri::HTML.parse(article['html']).text
                    else
                      Ghostwriter::Writer.new(
                        link_base: 'https://support.mozilla.org'
                      ).textify(html_with_link_anchors_fixed)
                    end
  logger.debug article.ai
  article['url'] = "https://support.mozilla.org#{article['url']}"
  csv.push(article.except('products', 'topics'))
  sleep(1.0) # sleep 1 seconds between API calls
end

headers = csv[0].keys
CSV.open("details-#{CSV_SUMMARY_FILE}", 'w', write_headers: true, headers: headers) do |csv_object|
  csv.each { |row_array| csv_object << row_array }
end
