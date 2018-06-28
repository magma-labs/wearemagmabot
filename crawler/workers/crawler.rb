# frozen_string_literal: true

require 'sidekiq'

class Crawler
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform
    # Step 1: Get posts
    posts = adapters.flat_map do |adapter|
      adapter.fetch(hashtag: 'wearemagma', amount: 5)
    end

    # Step 2: Store them in db and separate new ones from old ones
    posts = store_posts_and_return_new_ones(posts)

    # puts "New posts fetched: #{posts.to_json}"

    # Step 3: Send hubot new posts
    bot.send_posts(posts) if posts.count > 0

    # Done!
  end

  protected

  def adapters
    @adapters ||= [
      Adapters::Twitter.new
    ]
  end

  def store_posts_and_return_new_ones(posts)
    stored = db.stored_posts

    old_posts, new_posts = posts.partition { |post| stored.include?(post) }

    db.stored_posts = stored + new_posts
    new_posts
  end

  def db
    @db ||= DB.new
  end

  def bot
    @bot ||= Bot.new
  end
end
