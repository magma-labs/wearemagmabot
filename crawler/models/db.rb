# frozen_string_literal: true

require 'redis-namespace'

# Redis adapter for crawler data storage. Can be easily modified to support a different
# DB backend.
class DB
  def stored_posts
    posts = JSON.parse(redis.get('posts') || '[]')
    posts.map { |hash| Post.new hash['content'], hash['url'], hash['origin'].to_sym }
  end

  def stored_posts=(posts)
    posts = posts.nil? ? posts : posts.to_json
    redis.set :posts, posts
  end

  def transaction(&block)
    redis.multi(&block)
  end

  protected

  def redis
    @redis ||= begin
      namespace = ENV.fetch('ENVIRONMENT', 'development')
      Redis::Namespace.new(ns: namespace, redis: Redis.new)
    end
  end
end
