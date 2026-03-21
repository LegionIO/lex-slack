# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Search do
  let(:test_obj) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(test_obj).to receive(:api_connection).and_return(mock_conn)
  end

  describe '#search_messages' do
    it 'calls search.messages' do
      allow(mock_conn).to receive(:get).with('search.messages', hash_including(query: 'hello', count: 20))
                                       .and_return(double(body: { 'ok' => true, 'messages' => {} }))
      result = test_obj.search_messages(token: 'xoxb', query: 'hello')
      expect(result[:ok]).to be true
    end

    it 'includes sort and sort_dir when provided' do
      allow(mock_conn).to receive(:get).with('search.messages',
                                             hash_including(sort: 'timestamp', sort_dir: 'asc'))
                                       .and_return(double(body: { 'ok' => true, 'messages' => {} }))
      result = test_obj.search_messages(token: 'xoxb', query: 'hello', sort: 'timestamp', sort_dir: 'asc')
      expect(result[:ok]).to be true
    end
  end

  describe '#search_files' do
    it 'calls search.files' do
      allow(mock_conn).to receive(:get).with('search.files', hash_including(query: 'report', count: 20))
                                       .and_return(double(body: { 'ok' => true, 'files' => {} }))
      result = test_obj.search_files(token: 'xoxb', query: 'report')
      expect(result[:ok]).to be true
    end

    it 'includes cursor when provided' do
      allow(mock_conn).to receive(:get).with('search.files', hash_including(cursor: 'next'))
                                       .and_return(double(body: { 'ok' => true, 'files' => {} }))
      result = test_obj.search_files(token: 'xoxb', query: 'report', cursor: 'next')
      expect(result[:ok]).to be true
    end
  end
end
