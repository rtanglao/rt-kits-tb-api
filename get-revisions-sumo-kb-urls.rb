#!/usr/bin/env ruby
require 'rubygems'
require 'amazing_print'
require 'bundler/setup'
require 'net/http'
require 'logger'
require 'mechanize'
require 'pry'
require 'pry-byebug'
logger = Logger.new($stderr)
logger.level = Logger::DEBUG
mechanize = Mechanize.new
# Prior art from 2017 :-)
# https://github.com/rtanglao/rt-li-sumo-redirects/blob/master/OTHER-LANGUAGE/get-other-language-urls.rb
puts 'en-us-slug,localized-slug'
ARGF.each_line do |kb_slug|
  kb_slug_url = "https://support.mozilla.org/en-US/kb/#{kb_slug.chomp}/history"
  logger.debug "kb_slug_url #{kb_slug_url}"
  page = mechanize.get(kb_slug_url)
  ap page

  # from https://stackoverflow.com/questions/34781600/how-to-parse-a-html-table-with-nokogiri
  table = page.css('table').first
  rows = table.css('tr')
  # On each of the remaining rows
  rows.shift
  rows.map do |row|
    # We get the name (<th>)
    # On the first row this will be Raw name 1
    #  on the second - Raw name 2, etc.
    datetime = row.css('.date a time').attr('datetime').value
    ap datetime
    status = row.css('.status').at('span').attr('class')
    ap status
    creator = row.css('.creator a').attr('href').value
    ap creator
    display_name = row.css('.creator a').text.strip
    ap display_name
    revision = row.css('td.date a').attr('href').value
    ap revision
    binding.pry
  end
  ###
end
