# frozen_string_literal: true

require 'sidekiq'

class Crawler
  POSTS_AMOUNT = ENV.fetch('CRAWLER_POSTS_AMOUNT', 5)
  HASHTAG_TO_LOOK_FOR = ENV.fetch('CRAWLER_HASHTAG_TO_LOOK_FOR', 'wearemagma')

  include Sidekiq::Worker

  sidekiq_options retry: false

  #
  # This worker should fetch posts and send them to the bot. Each driver is
  # responsible for fetching posts and avoid post duplication.
  #
  def perform
    posts = store_posts_and_return_new_ones(fetch_posts)
    puts "#{posts.count} new post(s) fetched."

    if posts.any?
      posts.each.with_index { |post, i| puts "Post ##{i}: #{post.to_json}" }
      bot.send_posts(posts)
      puts 'Posts sent!'
    else
      puts 'Nothing to do here.'
    end
  end

  protected

  def fetch_posts
    adapters.flat_map do |adapter|
      adapter.fetch(hashtag: HASHTAG_TO_LOOK_FOR, amount: POSTS_AMOUNT)
    end
  end

  def store_posts_and_return_new_ones(posts)
    # Separate new posts from ones we already sent
    stored = db.stored_posts
    new_posts = posts.select { |post| stored.include?(post) }

    # Store new posts so we avoid post duplication.
    db.stored_posts = stored + new_posts

    new_posts
  end

  def adapters
    @adapters ||= [
      Adapters::Twitter.new
    ]
  end

  def db
    @db ||= DB.new
  end

  def bot
    @bot ||= Bot.new
  end
end
