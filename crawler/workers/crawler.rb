# frozen_string_literal: true

require 'sidekiq'

class Crawler
  POSTS_AMOUNT = 10
  HASHTAG_TO_LOOK_FOR = ENV.fetch('CRAWLER_HASHTAG_TO_LOOK_FOR', 'wearemagma')

  include Sidekiq::Worker

  sidekiq_options retry: false

  #
  # This worker should fetch posts and send them to the bot. Each driver is
  # responsible for fetching posts and avoid post duplication.
  #
  def perform
    posts = adapters.flat_map do |adapter|
      adapter.fetch(hashtag: HASHTAG_TO_LOOK_FOR, amount: POSTS_AMOUNT)
    end
    bot.send_posts(posts) if posts.any?
  end

  protected

  def adapters
    @adapters ||= [
      Adapters::Twitter.new
    ]
  end

  def bot
    @bot ||= Bot.new
  end
end
