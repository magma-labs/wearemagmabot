# frozen_string_literal: true

require 'twitter'

module Adapters
  #
  # Retrieves tweets with a hashtag on them.
  #
  class Twitter < Base
    def fetch(hashtag:, amount:)
      params = { result_type: :recent }
      client.search("##{hashtag}", params).take(amount).map do |tweet|
        Post.new tweet.text, build_url(tweet.url), :twitter
      end
    end

    private

    def client
      @client ||= ::Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
        config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
        config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
        config.access_token_secret = ENV.fetch('TWITTER_ACCESS_SECRET')
      end
    end

    def build_url(url)
      "#{url.scheme}://#{url.host}#{url.path}"
    end
  end
end
