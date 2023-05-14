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
require_relative 'fix-kludged-time'

logger = Logger.new(STDERR)
logger.level = Logger::DEBUG
if ARGV.length < 6
  puts "usage: #{$0} yyyy mm dd end-yyyy mm id"
  exit
end
# because of issue 3686, https://github.com/mozilla/kitsune/issues/3686,
# go back one day and forward one day
min_created_time = Time.gm(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i)
greater_than_time = (min_created_time - 3600 * 24).strftime('%Y-%-m-%-e')
less_than = Time.gm(ARGV[3].to_i, ARGV[4].to_i, ARGV[5].to_i)
end_time = Time.gm(ARGV[3].to_i, ARGV[4].to_i, ARGV[5].to_i, 23, 59, 59)

less_than_time = (less_than + 3600 * 24).strftime('%Y-%-m-%-e')
less_than_time_parsed = Time.parse(less_than_time + ' 00:00:00 UTC')
logger.debug "min_created_time #{min_created_time}"
logger.debug 'greater than time' + greater_than_time.to_s
logger.debug 'less than' + less_than.to_s
logger.debug 'less than time' + less_than_time.to_s

url_params = {
  format: 'json',
  product: 'thunderbird',
  created__gt: greater_than_time,
  created__lt: less_than_time,
  ordering: '+created'
}

url = 'https://support.mozilla.org/api/2/question/'
end_program = false
question_number = 0
csv = []
until end_program
  questions = getKitsuneResponse(url, url_params, logger)
  url_params = nil
  logger.debug "question count:#{questions['count']}"
  url_params = nil
  created = ''
  questions['results'].each do |q|
    logger.ap q
    question_number += 1
    logger.debug "QUESTION number:#{question_number}"
    updated = q['updated']
    created = q['created']
    logger.debug "created from API: #{created} <-- this is PST not UTC despite the 'Z'"
    # All times returned by the API are in PST not PDT and not UTC
    # All URL parameters for time are also in PST not UTC
    # See https://github.com/mozilla/kitsune/issues/3961 and
    # https://github.com/mozilla/kitsune/issues/3946
    # The above may change in the future if we migrate the Kitsune database to UTC

    created = kludge_time_from_bogusZ_to_utc(q['created'])
    logger.debug "created with PST correction: #{created}"

    unless updated.nil?
      logger.debug "updated from API: #{updated} <-- this is PST not UTC despite the 'Z'"
      updated = kludge_time_from_bogusZ_to_utc(q['updated'])
      logger.debug "updated with PST correction: #{updated}"
    end
    id = q['id']
    logger.debug "QUESTION id: #{id}"
    logger.debug "QUESTION number: #{question_number}"
    tags = q['tags']
    tag_str = ''
    tags.each { |t| tag_str = tag_str + t['slug'] + ';' }
    answers = q['answers']
    answers_str = ''
    answers.each { |a| answers_str = answers_str + a.to_s + ';' }
    creator = q['creator']['username']
    logger.debug "createdtop: #{created.to_i}"
    logger.debug "min_created_time: #{min_created_time.to_i}"
    logger.debug "less_than_time_parsed: #{less_than_time_parsed.to_i}"
    logger.debug "answers_str: #{answers_str}"
    logger.debug "creator: #{creator}"
    if created.to_i >= min_created_time.to_i && created.to_i <= end_time.to_i
      logger.debug 'NOT skipping'
      csv.push(
        [
          id, created.to_s, updated.to_s, q['title'], q['content'].tr("\n", ' '),
          tag_str, q['product'], q['topic'], q['locale'],
          answers_str, creator
        ]
      )
    else
      logger.debug 'SKIPPING'
    end
  end
  url = questions['next']
  if url.nil?
    logger.debug 'nil next url'
  else
    logger.debug "next url:#{url}"
  end
  logger.debug "created: #{created.to_i}"
  logger.debug "min_created_time: #{min_created_time.to_i}"
  if (created.to_i < min_created_time.to_i) || url.nil?
    end_program = true
    break
  else
    sleep(1.0) # sleep 1 second between API calls
  end
end
headers = %w[id created updated title content tags product topic locale answers creator]
fn_str = '%<yyyy1>4.4d-%<mm1>2.2d-%<dd1>2.2d-%<yyyy2>4.4d-%<mm2>2.2d-%<dd2>2.2d'
fn_str += '-thunderbird-creator-answers-desktop-all-locales.csv'
FILENAME = format(fn_str,
                  yyyy1: ARGV[0].to_i, mm1: ARGV[1].to_i, dd1: ARGV[2].to_i,
                  yyyy2: ARGV[3].to_i, mm2: ARGV[4].to_i, dd2: ARGV[5].to_i)
CSV.open(FILENAME, 'w', write_headers: true, headers: headers) do |csv_object|
  csv.each { |row_array| csv_object << row_array }
end
