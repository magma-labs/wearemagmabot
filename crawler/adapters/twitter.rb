# frozen_string_literal: true

require 'twitter'

module Adapters
  class Twitter < Base
    def fetch(hashtag:, amount:)
      client.search("#{hashtag}", result_type: :recent).take(amount).map do |tweet|
        Post.new tweet.text, build_url(tweet.url), :twitter
      end
    end

    private

    def client
      @client ||= ::Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
      end
    end

    def build_url(url)
      "#{url.scheme}://#{url.host}#{url.path}"
    end
  end
end
