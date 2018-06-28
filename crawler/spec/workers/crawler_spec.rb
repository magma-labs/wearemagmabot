# frozen_string_literal: true

RSpec.describe Crawler do
  let(:foobar_posts) do
    10.times.map { |n| Post.new("Post #{n}", "http://foo.bar/#{n}", 'foo.bar') }
  end

  let(:foobar_adapter) do
    adapter = double('Foo.bar adapter')
    allow(adapter).to receive(:fetch) { foobar_posts }
    adapter
  end

  let(:adapters) do
    [
      foobar_adapter
    ]
  end

  let(:db) { spy('Storage') }
  let(:bot) { spy('Bot') }

  before do
    allow(subject).to receive_messages(adapters: adapters, db: db, bot: bot)
  end

  describe '#process' do
    before { subject.process }

    it 'fetches posts from adapters' do
      expect(foobar_adapter).to have_received(:fetch).once
    end

    it 'sends new posts to bot' do
      expect(bot).to have_received(:send_posts).once
    end
  end
end
