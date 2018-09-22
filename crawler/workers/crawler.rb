# frozen_string_literal: true

require 'sidekiq'

class Crawler
  include Sidekiq::Worker

  sidekiq_options retry: false

  #
  # This worker should fetch posts and send them to the bot. Each driver is
  # responsible for fetching posts and avoid post duplication.
  #
  def perform
    posts = adapters.flat_map do |adapter|
      adapter.fetch(hashtag: 'wearemagma', amount: 5)
    end
    bot.send_posts(posts) if posts.count.positive?
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
