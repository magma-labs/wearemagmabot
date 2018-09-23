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
    puts 'I have awaken. Fetching posts...'
    posts = adapters.flat_map do |adapter|
      adapter.fetch(hashtag: HASHTAG_TO_LOOK_FOR, amount: POSTS_AMOUNT)
    end

    puts "#{posts.count} post(s) fetched."
    if posts.any?
      posts.each.with_index { |post, index| puts "Post ##{index}: #{post.to_json}" }
      puts 'Sending posts to bot...'
      bot.send_posts(posts)
    else
      puts 'Nothing to do here.'
    end

    puts 'My work is done. Back to sleep.'
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
