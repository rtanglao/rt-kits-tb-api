#!/usr/bin/env ruby
require 'rubygems'
require 'amazing_print'
require 'net/http'
require 'logger'
require 'mechanize'
logger = Logger.new(STDERR)
logger.level = Logger::DEBUG
mechanize = Mechanize.new

ARGF.each_line do |kb_slug|
  kb_slug_url = "https://support.mozilla.org/en-US/kb/#{kb_slug.chomp}/show_translations"
  logger.debug "kb_slug_url #{kb_slug_url}"
  page = mechanize.get(kb_slug_url)
  page.css('.translated_locale').map { |link| link['href'] }.each do |localized_slug|
    fromuri = "https://support.mozilla.org#{localized_slug}"
    logger.debug "fromuri:#{fromuri}"
    from_uri= URI(fromuri)
    Net::HTTP.start(from_uri.host, from_uri.port, use_ssl: from_uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new from_uri.request_uri
      response = http.request request # Net::HTTPResponse object
      response_uri = response['location']
      puts response_uri.nil? ? localized_slug : response_uri
      sleep(1)
    end
  end
end
