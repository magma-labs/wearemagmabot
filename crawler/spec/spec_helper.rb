# frozen_string_literal: true

require 'vcr'
require_relative '../config/environment'

RSpec.configure do |config|
  ENV['ENVIRONMENT'] = 'test'

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.disable_monkey_patching!
  config.order = :random

  Kernel.srand config.seed

  VCR.configure do |vcr_config|
    vcr_config.cassette_library_dir = 'spec/support/fixtures/vcr_cassettes'
    vcr_config.hook_into :webmock
  end
end
