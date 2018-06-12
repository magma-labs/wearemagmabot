# frozen_string_literal: true

require 'json'
require 'redis-namespace'

# Redis adapter for crawler data storage. Can be easily modified to support a different
# DB backend.
class DB
  def stored_posts
    JSON.parse(@redis.get('posts'), '[]')
        .map { |hash| Post.new(hash[:content], hash[:url], hash[:origin]) }
  end

  def stored_posts=(posts)
    @redis.set :posts, posts.to_json
  end

  def transaction(&block)
    @redis.multi(&block)
  end

  protected

  def redis
    @redis ||= begin
      namespace = ENV.fetch('ENVIRONMENT', 'development')
      Redis::Namespace.new(ns: namespace, redis: Redis.new)
    end
  end
end
