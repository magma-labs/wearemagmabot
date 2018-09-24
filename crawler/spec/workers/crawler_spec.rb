# frozen_string_literal: true

RSpec.describe Crawler do
  before do
    # Mocking $stdout.puts so the crawler doesn't log anything during tests.
    allow($stdout).to receive(:puts)
  end

  let(:foobar_posts) do
    Array(5).map { |n| Post.new("Post #{n}", "http://foo.bar/#{n}", 'foo.bar') }
  end

  let(:foobar_adapter) { spy('Foo.bar adapter') }
  let(:adapters) do
    [
      foobar_adapter
    ]
  end

  let(:bot) { spy('Bot') }
  let(:db) { spy('Storage') }

  before do
    allow(subject).to receive_messages(adapters: adapters, db: db, bot: bot)
  end

  describe '#perform' do
    it 'fetches posts from adapters' do
      subject.perform
      expect(foobar_adapter).to have_received(:fetch).once
    end

    context 'when there are new posts to notify' do
      before do
        allow(foobar_adapter).to receive(:fetch) { foobar_posts }
      end

      it 'sends new posts to bot' do
        subject.perform
        expect(bot).to have_received(:send_posts).once
      end
    end

    context 'when there are no new posts' do
      before do
        allow(foobar_adapter).to receive(:fetch) { [] }
      end

      it 'does not send new posts to bot' do
        subject.perform
        expect(bot).not_to have_received(:send_posts)
      end
    end
  end
end
