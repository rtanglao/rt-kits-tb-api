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

logger = Logger.new($stderr)
logger.level = Logger::DEBUG

answer_number = 0
csv = []
url_params = { format: 'json' }
CSV.new(ARGF.file, headers: :first_row).each do |my_answer|
  my_answer = my_answer.to_hash
  question = my_answer['question']
  logger.debug "my_answer: #{my_answer}"
  url = 'https://support.mozilla.org/api/2/answer/'
  url_params = { format: 'json', question: my_answer['question'] }

  all_answers = getKitsuneResponse(url, url_params, logger)
  next if all_answers.nil?

  # FIXME: Assuming: all_answers['next'] is nil i.e. only 1 page of answers
  next_page_of_answers = all_answers['next']
  logger.debug "More than one page of answers for #{question}. Ignoring page2-" unless next_page_of_answers.nil?

  all_answers['results'].each do |answer|
    logger.ap answer
    created = kludge_time_from_bogusZ_to_utc(answer['created'])
    # if created time is after my answer's created time then print the question url
    if created > Time.parse(my_answer['created'])
      puts my_answer['question_url']
      break
    end
  end
  sleep(0.5) # sleep 0.5 seconds between API calls
end
