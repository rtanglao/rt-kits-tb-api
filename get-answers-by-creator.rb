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
require_relative 'fix-kludged-time'

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG

if ARGV.empty?
  puts "usage: #{$PROGRAM_NAME} <creator>"
  exit
end
CREATOR = ARGV[0]
logger.debug "CREATOR: #{CREATOR}"
url_params = {
  format: 'json',
  creator: CREATOR
}
csv = []

url = 'https://support.mozilla.org/api/2/answer/'
end_program = false
answer_number = 0
csv = []
until end_program
  answers = getKitsuneResponse(url, url_params, logger)
  logger.debug "answer count:#{answers['count']}"
  url_params = nil
  answers['results'].each do |a|
    logger.ap a
    answer_number += 1
    logger.debug "ANSWER number:#{answer_number}"
    id = a['id']
    question = a['question']
    created = a['created']
    updated = a['updated']
    logger.debug "created from API: #{created} <-- this is PST not UTC despite the 'Z'"
    # All times returned by the API are in PST not PDT and not UTC
    # All URL parameters for time are also in PST not UTC
    # See https://github.com/mozilla/kitsune/issues/3961 and
    # https://github.com/mozilla/kitsune/issues/3946
    # The above may change in the future if we migrate the Kitsune database to UTC

    created = kludge_time_from_bogusZ_to_utc(created)
    logger.debug "created with PST correction: #{created}"

    unless updated.nil?
      logger.debug "updated from API: #{updated} <-- this is PST not UTC despite the 'Z'"
      updated = kludge_time_from_bogusZ_to_utc(a['updated'])
      logger.debug "updated with PST correction: #{updated}"
    end
    s_question_url = "https://support.mozilla.org/question/#{question}"
    csv.push([id, question, s_question_url, a['content'], created,
              a['creator']['username'], a['creator']['display_name'],
              updated, a['updated_by'], a['is_spam'], a['num_helpful_votes'],
              a['num_unhelpful_votes']])
  end
  url = answers['next']
  if url.nil?
    logger.debug 'nil next url'
    end_program = true
    next
  else
    logger.debug "next url:#{url}"
    sleep(0.5) # sleep 0.5 seconds between API calls
  end
end
headers = %w[id question question_url content created creator display_name updated
             updated_by is_spam num_helpful_votes num_unhelpful_votes]
CSV.open("#{CREATOR}-answers.csv", 'w', write_headers: true, headers: headers) do |csv_object|
  csv.each { |row_array| csv_object << row_array }
end
