#!/usr/bin/env ruby
require 'rubygems'
require 'amazing_print'
require 'net/http'
require 'logger'
require 'mechanize'
require 'csv'
logger = Logger.new(STDERR)
logger.level = Logger::DEBUG
if ARGV.empty?
  puts "usage: #{$PROGRAM_NAME} <csv-file-with-locale_info>"
  exit
end
CSV_LOCALES_FILE = ARGV[0]
mechanize = Mechanize.new
output_csv = []
CSV.foreach(CSV_LOCALES_FILE, headers: true).each do |locale_info|
  locale_url = locale_info['locale_url']
  logger.debug "locale_url #{locale_url}"
  page = mechanize.get(locale_url)
  locale_leaders = ''
  page.css('.leaders .author-name').each do |l|
    locale_leaders += "#{l.attr('href')};"
  end
    locale_reviewers = ''
  page.css('.reviewers .author-name').each do |l|
    locale_reviewers += "#{l.attr('href')};"
  end
  logger.debug "locale_leaders: #{locale_leaders.ai}"
  logger.debug "locale_reviewers: #{locale_reviewers.ai}"

  exit
  page.css('html.js body.html-ltr.logged-in.responsive.en-US div#main-content.mzp-l-content div.sumo-page-section--inner div.sumo-l-two-col main.sumo-l-two-col--main article#locale-listing div#locale-leaders.editable.sumo-page-section--inner ul.users.leaders.cf li div.avatar-details.user-meta div.user div.asked-by')
  page.css('.translated_locale').map { |link| link['href'] }.each do |localized_slug|
    fromuri = "https://support.mozilla.org#{localized_slug}"
    logger.debug "fromuri:#{fromuri}"
    from_uri = URI(fromuri)
    Net::HTTP.start(from_uri.host, from_uri.port, use_ssl: from_uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new from_uri.request_uri
      response = http.request request # Net::HTTPResponse object
      response_uri = response['location']
      localized_slug_after_redirect = response_uri.nil? ? localized_slug : response_uri
      puts "#{kb_slug.chomp},#{localized_slug_after_redirect}"
      sleep(1) # Keep Kitsune from throttling this script :-)
    end
  end
end
