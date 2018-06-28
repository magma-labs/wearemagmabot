# frozen_string_literal: true

require 'redis-namespace'

#
# NOTE: This spec needs a running redis instance to work
#
RSpec.describe DB do
  let(:redis) { Redis::Namespace.new ns: 'test', redis: Redis.new }

  let(:posts) do
    [
      { content: 'Post 1', url: 'https://ty.co/1', origin: 'ty' },
      { content: 'Post 2', url: 'https://ty.co/1', origin: 'ty' },
      { content: 'Post 3', url: 'https://ty.co/1', origin: 'ty' }
    ]
      .map { |hash| Post.new *hash.values }
  end

  after do
    redis.del 'posts'
  end

  describe '#stored_posts' do
    context 'when there are no posts in the db' do
      it 'returns an empty array' do
        expect(subject.stored_posts).to eql []
      end
    end

    context 'when there are posts in the db' do
      let(:stored_posts) { subject.stored_posts }

      before do
        redis.set 'posts', posts.to_json
      end

      it 'returns an array of Post objects' do
        stored_posts.each { |post| expect(post).to be_a Post }
        expect(stored_posts.count).to eql 3
      end
    end
  end

  describe '#stored_posts=' do
    it 'stores posts' do
      subject.stored_posts = posts
      expect(redis.get('posts')).to eql posts.to_json
    end
  end
end
