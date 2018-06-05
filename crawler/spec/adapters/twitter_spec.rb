# frozen_string_literal: true

RSpec.describe Adapters::Twitter do
  describe '#fetch' do
    let(:tweets) do
      VCR.use_cassette 'twitter/tweets' do
        subject.fetch hashtag: '#wearemagma', amount: 10
      end
    end

    it 'gets last 10 tweets that include #wearemagma' do
      expect(tweets.count).to eql 10
    end

    it 'returns a post object for each tweet' do
      tweets.each { |tweet| expect(tweet).to be_a Post }
    end

    it 'each post object includes a url' do
      tweets.each { |tweet| expect(tweet.url).to match /^https:\/\/twitter\.com\// }
    end
  end
end
