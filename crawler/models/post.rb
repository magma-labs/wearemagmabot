# frozen_string_literal: true

Post = Struct.new :content, :url, :origin do
  def to_json(options = {})
    to_h.to_json(options)
  end
end
