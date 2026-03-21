# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Bookmarks do
  let(:test_obj) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(test_obj).to receive(:api_connection).and_return(mock_conn)
  end

  describe '#add_bookmark' do
    it 'calls bookmarks.add with channel_id' do
      allow(mock_conn).to receive(:post).with('bookmarks.add',
                                              hash_including(channel_id: 'C1', title: 'Docs', type: 'link'))
                                        .and_return(double(body: { 'ok' => true, 'bookmark' => {} }))
      result = test_obj.add_bookmark(token: 'xoxb', channel: 'C1', title: 'Docs', type: 'link')
      expect(result[:ok]).to be true
    end

    it 'includes optional link and emoji' do
      allow(mock_conn).to receive(:post).with('bookmarks.add',
                                              hash_including(link: 'https://example.com', emoji: ':book:'))
                                        .and_return(double(body: { 'ok' => true, 'bookmark' => {} }))
      result = test_obj.add_bookmark(token: 'xoxb', channel: 'C1', title: 'Docs', type: 'link',
                                     link: 'https://example.com', emoji: ':book:')
      expect(result[:ok]).to be true
    end
  end

  describe '#edit_bookmark' do
    it 'calls bookmarks.edit' do
      allow(mock_conn).to receive(:post).with('bookmarks.edit',
                                              hash_including(channel_id: 'C1', bookmark_id: 'Bm1'))
                                        .and_return(double(body: { 'ok' => true, 'bookmark' => {} }))
      result = test_obj.edit_bookmark(token: 'xoxb', channel: 'C1', bookmark_id: 'Bm1', title: 'New Title')
      expect(result[:ok]).to be true
    end

    it 'includes optional title, link, emoji' do
      allow(mock_conn).to receive(:post).with('bookmarks.edit',
                                              hash_including(link: 'https://new.example.com'))
                                        .and_return(double(body: { 'ok' => true, 'bookmark' => {} }))
      result = test_obj.edit_bookmark(token: 'xoxb', channel: 'C1', bookmark_id: 'Bm1',
                                      link: 'https://new.example.com')
      expect(result[:ok]).to be true
    end
  end

  describe '#remove_bookmark' do
    it 'calls bookmarks.remove' do
      allow(mock_conn).to receive(:post).with('bookmarks.remove',
                                              { channel_id: 'C1', bookmark_id: 'Bm1' })
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.remove_bookmark(token: 'xoxb', channel: 'C1', bookmark_id: 'Bm1')
      expect(result[:ok]).to be true
    end
  end

  describe '#list_bookmarks' do
    it 'calls bookmarks.list with channel_id' do
      allow(mock_conn).to receive(:get).with('bookmarks.list', { channel_id: 'C1' })
                                       .and_return(double(body: { 'ok' => true, 'bookmarks' => [] }))
      result = test_obj.list_bookmarks(token: 'xoxb', channel: 'C1')
      expect(result[:ok]).to be true
      expect(result[:bookmarks]).to eq([])
    end
  end
end
