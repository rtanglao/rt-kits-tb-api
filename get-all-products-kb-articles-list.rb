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

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG
url_params = {
  format: 'json'
}

url = 'https://support.mozilla.org/api/1/kb/'
end_program = false
article_number = 0
csv = []
until end_program
  sleep(1.0) # sleep 1 second between API calls
  articles = getKitsuneResponse(url, url_params, logger)
  logger.debug "article count:#{articles['count']}"
  url_params = nil
  articles['results'].each do |a|
    logger.ap a
    article_number += 1
    logger.debug "ARTICLE number:#{article_number}"
    slug = a['slug']
    title = a['title']
    logger.debug "slug: #{slug}"
    logger.debug "title: #{title}"
    csv.push([slug, title])
  end
  url = articles['next']
  if url.nil?
    logger.debug 'nil next url'
    end_program = true
    next
  else
    logger.debug "next url:#{url}"
  end
end
headers = %w[slug title]
CSV.open('allproducts-kb-title-slug-all-articles.csv', 'w', write_headers: true, headers: headers) do |csv_object|
  csv.each { |row_array| csv_object << row_array }
end
