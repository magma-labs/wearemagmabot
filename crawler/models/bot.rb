# frozen_string_literal: true

require 'uri'
require 'net/http'

class Bot
  def send_posts(posts)
    Net::HTTP.post URI("#{bot_url}/send-new-posts"), posts.to_json, bot_headers
  end

  protected

  def bot_url
    ENV.fetch('HUBOT_URL')
  end

  def bot_headers
    {
      'Content-Type': 'application/json'
    }
  end
end
