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
require_relative 'get-kitsune-response'

logger = Logger.new($stderr)
logger.level = Logger::DEBUG
url_params = {
  format: 'json'
}

url = 'https://support.mozilla.org/api/2/locales/'
csv = []
locales = getKitsuneResponse(url, url_params, logger)
logger.debug "locales: #{locales.ai}"
locales.each do |l|
  logger.debug "l:#{l.ai}"
  row =
    {
      locale_slug: l[0],
      locale_name: l[1]['name'],
      locale_localized_name: l[1]['localized_name'],
      locale_aaq_enabled: l[1]['aaq_enabled'],
      locale_url: "https://support.mozilla.org/en-US/kb/locales/#{l[0]}"
    }
  csv.push(row)
  logger.debug "row: #{row}"
end

headers = csv[0].keys
CSV.open('all-sumo-locales.csv', 'w', write_headers: true, headers: headers) do |csv_object|
  csv.each { |row_array| csv_object << row_array }
end
