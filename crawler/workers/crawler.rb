# frozen_string_literal: true

require 'sidekiq'

class Crawler
  include Sidekiq::Worker

  sidekiq_options retry: false

  def process
    # Step 1: Get posts
    posts = adapters.flat_map do |adapter|
      adapter.fetch(hashtag: 'wearemagma', amount: 10)
    end

    # Step 2: Store them in db and separate new ones from old ones
    posts = store_posts_and_return_new_ones(posts)

    # Step 3: Send hubot new posts
    bot.send_posts(posts)

    # Done!
  end

  protected

  def adapters
    @adapters ||= [
      Adapters::Twitter.new,
    ]
  end

  def store_posts_and_return_new_ones(posts)
    new_posts = []
    db.transaction do
      @stored ||= db.stored_posts

      new_posts, old_posts = posts.partition do |post|
        !@stored.include?(post) && @stored.push(post)
      end

      db.stored_posts = @stored
    end
    new_posts
  end

  def db
    @db ||= DB.new
  end

  def bot
    @bot ||= Bot.new
  end
end
