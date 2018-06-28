# frozen_string_literal: true

RSpec.describe Crawler do
  let(:foobar_posts) do
    5.times.map { |n| Post.new("Post #{n}", "http://foo.bar/#{n}", 'foo.bar') }
  end

  let(:foobar_adapter) { double('Foo.bar adapter') }

  let(:adapters) do
    [
      foobar_adapter
    ]
  end

  let(:db) { spy('Storage') }
  let(:bot) { spy('Bot') }

  before do
    allow(foobar_adapter).to receive(:fetch) { foobar_posts }
    allow(subject).to receive_messages(adapters: adapters, db: db, bot: bot)
  end

  describe '#perform' do
    let(:post_included) { false }

    before do
      allow(db).to receive(:include?) { post_included }
      subject.perform
    end

    it 'fetches posts from adapters' do
      expect(foobar_adapter).to have_received(:fetch).once
    end

    context 'when there are new posts to notify' do
      it 'sends new posts to bot' do
        expect(bot).to have_received(:send_posts).once
      end
    end

    context 'when there are no new posts' do
      let(:post_included) { true }

      it 'does not send new posts to bot' do
        expect(bot).not_to have_received(:send_posts)
      end
    end
  end
end
