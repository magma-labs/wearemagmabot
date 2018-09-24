# frozen_string_literal: true

# Clean sidekiq jobs queue
Sidekiq::Queue.new('infinity').clear
Sidekiq::RetrySet.new.clear
Sidekiq::ScheduledSet.new.clear
