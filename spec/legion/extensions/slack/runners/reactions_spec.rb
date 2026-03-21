# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Reactions do
  let(:test_obj) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(test_obj).to receive(:api_connection).and_return(mock_conn)
  end

  describe '#add_reaction' do
    it 'calls reactions.add' do
      allow(mock_conn).to receive(:post).with('reactions.add',
                                              hash_including(channel: 'C1', timestamp: '1.0', name: 'thumbsup'))
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.add_reaction(token: 'xoxb', channel: 'C1', timestamp: '1.0', name: 'thumbsup')
      expect(result[:ok]).to be true
    end
  end

  describe '#remove_reaction' do
    it 'calls reactions.remove' do
      allow(mock_conn).to receive(:post).with('reactions.remove',
                                              hash_including(channel: 'C1', timestamp: '1.0', name: 'thumbsup'))
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.remove_reaction(token: 'xoxb', channel: 'C1', timestamp: '1.0', name: 'thumbsup')
      expect(result[:ok]).to be true
    end
  end

  describe '#get_reactions' do
    it 'calls reactions.get' do
      allow(mock_conn).to receive(:get).with('reactions.get', { channel: 'C1', timestamp: '1.0' })
                                       .and_return(double(body: { 'ok' => true, 'message' => {} }))
      result = test_obj.get_reactions(token: 'xoxb', channel: 'C1', timestamp: '1.0')
      expect(result[:ok]).to be true
    end
  end

  describe '#list_reactions' do
    it 'calls reactions.list' do
      allow(mock_conn).to receive(:get).with('reactions.list', hash_including(limit: 100))
                                       .and_return(double(body: { 'ok' => true, 'items' => [],
                                                                  'response_metadata' => {} }))
      result = test_obj.list_reactions(token: 'xoxb')
      expect(result[:ok]).to be true
      expect(result[:items]).to eq([])
    end

    it 'includes user and cursor when provided' do
      allow(mock_conn).to receive(:get).with('reactions.list', hash_including(user: 'U1', cursor: 'next'))
                                       .and_return(double(body: { 'ok' => true, 'items' => [],
                                                                  'response_metadata' => {} }))
      result = test_obj.list_reactions(token: 'xoxb', user: 'U1', cursor: 'next')
      expect(result[:ok]).to be true
    end
  end
end
