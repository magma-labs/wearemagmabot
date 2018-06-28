# frozen_string_literal: true

require 'bundler/setup'
require 'byebug' unless ENV['ENVIRONMENT'] == 'production'

require_relative '../models/post'
require_relative '../models/db'
require_relative '../models/bot'
require_relative '../adapters/base'
require_relative '../adapters/twitter'
require_relative '../workers/crawler'

require 'sidekiq/api'
require 'sidekiq-scheduler'

# Clean sidekiq jobs queue
Sidekiq::Queue.new('infinity').clear
Sidekiq::RetrySet.new.clear
Sidekiq::ScheduledSet.new.clear
