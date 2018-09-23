# frozen_string_literal: true

require 'bundler/setup'

require_relative '../models/post'
require_relative '../models/bot'
require_relative '../models/db'
require_relative '../adapters/base'
require_relative '../adapters/twitter'
require_relative '../workers/crawler'

require 'sidekiq/api'
require 'sidekiq-scheduler'
