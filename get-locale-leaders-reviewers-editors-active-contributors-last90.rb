#!/usr/bin/env ruby
require 'rubygems'
require 'amazing_print'
require 'net/http'
require 'logger'
require 'mechanize'
require 'csv'
require_relative 'get_locale_leaders_reviewers_editors_active_last90_filename_by_yyyymmdd'

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG
if ARGV.empty?
  puts "usage: #{$PROGRAM_NAME} <csv-file-with-locale_info>"
  exit
end
CSV_LOCALES_FILE = ARGV[0]
csv_filename = get_locale_leaders_reviewers_editors_active_last90_filename_by_yyyymmdd(Time.now.strftime('%Y-%m-%d'))

mechanize = Mechanize.new
output_csv = []
CSV.foreach(CSV_LOCALES_FILE, headers: true).each do |locale_info|
  locale_url = locale_info['locale_url']
  logger.debug "locale_url #{locale_url}"
  begin
    page = mechanize.get(locale_url)
  rescue Mechanize::ResponseCodeError
    logger.debug "Mechanize error, probably 404 in locale: #{locale_url}! Skipping locale!!!"
    next
  end
  locale_leaders = page.css('.leaders a.author-name').map do |link|
    "https://support.mozilla.org#{link['href']}"
  end.join(';')
  locale_reviewers = page.css('.reviewers a.author-name').map do |link|
    "https://support.mozilla.org#{link['href']}"
  end.join(';')
  locale_editors = page.css('.editors a.author-name').map do |link|
    "https://support.mozilla.org#{link['href']}"
  end.join(';')
  active_contributors_last90 = page.css('.active a.author-name').map do |link|
    "https://support.mozilla.org#{link['href']}"
  end.join(';')
  locale_info['locale_url']
  locale_row =
    {
      locale_slug: locale_info['locale_slug'],
      locale_name: locale_info['locale_name'],
      locale_localized_name: locale_info['locale_localizedname'],
      locale_url: locale_info['locale_url'],
      locale_leaders: locale_leaders,
      locale_reviewers: locale_reviewers,
      locale_editors: locale_editors,
      active_contributors_last90: active_contributors_last90
    }
  logger.debug("locale_row: #{locale_row.ai}")
  output_csv.push(locale_row)
  sleep(1) # Keep Kitsune from throttling this script :-)
end
headers = output_csv[0].keys
CSV.open(
  csv_filename,
  'w',
  write_headers: true,
  headers: headers
) do |csv_object|
  output_csv.each { |row_array| csv_object << row_array }
end
