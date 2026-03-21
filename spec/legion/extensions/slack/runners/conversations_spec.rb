# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Conversations do
  let(:test_obj) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(test_obj).to receive(:api_connection).and_return(mock_conn)
  end

  describe '#list_conversations' do
    it 'calls conversations.list' do
      allow(mock_conn).to receive(:get).with('conversations.list', hash_including(limit: 200))
                                       .and_return(double(body: { 'ok' => true, 'channels' => [],
                                                                  'response_metadata' => {} }))
      result = test_obj.list_conversations(token: 'xoxb')
      expect(result[:ok]).to be true
      expect(result[:channels]).to eq([])
    end

    it 'includes types and cursor when provided' do
      allow(mock_conn).to receive(:get).with('conversations.list',
                                             hash_including(types: 'public_channel', cursor: 'abc'))
                                       .and_return(double(body: { 'ok' => true, 'channels' => [],
                                                                  'response_metadata' => {} }))
      result = test_obj.list_conversations(token: 'xoxb', types: 'public_channel', cursor: 'abc')
      expect(result[:ok]).to be true
    end
  end

  describe '#conversation_info' do
    it 'calls conversations.info' do
      allow(mock_conn).to receive(:get).with('conversations.info', { channel: 'C1' })
                                       .and_return(double(body: { 'ok' => true, 'channel' => { 'id' => 'C1' } }))
      result = test_obj.conversation_info(token: 'xoxb', channel: 'C1')
      expect(result[:ok]).to be true
      expect(result[:channel]).to include('id' => 'C1')
    end
  end

  describe '#conversation_history' do
    it 'calls conversations.history' do
      allow(mock_conn).to receive(:get).with('conversations.history', hash_including(channel: 'C1', limit: 100))
                                       .and_return(double(body: { 'ok' => true, 'messages' => [],
                                                                  'has_more' => false, 'response_metadata' => {} }))
      result = test_obj.conversation_history(token: 'xoxb', channel: 'C1')
      expect(result[:ok]).to be true
      expect(result[:has_more]).to be false
    end

    it 'includes oldest and latest when provided' do
      allow(mock_conn).to receive(:get).with('conversations.history',
                                             hash_including(oldest: '100.0', latest: '200.0'))
                                       .and_return(double(body: { 'ok' => true, 'messages' => [],
                                                                  'has_more' => false, 'response_metadata' => {} }))
      result = test_obj.conversation_history(token: 'xoxb', channel: 'C1', oldest: '100.0', latest: '200.0')
      expect(result[:ok]).to be true
    end
  end

  describe '#conversation_replies' do
    it 'calls conversations.replies' do
      allow(mock_conn).to receive(:get).with('conversations.replies', hash_including(channel: 'C1', ts: '1.0'))
                                       .and_return(double(body: { 'ok' => true, 'messages' => [],
                                                                  'has_more' => false }))
      result = test_obj.conversation_replies(token: 'xoxb', channel: 'C1', ts: '1.0')
      expect(result[:ok]).to be true
    end

    it 'includes cursor when provided' do
      allow(mock_conn).to receive(:get).with('conversations.replies', hash_including(cursor: 'next'))
                                       .and_return(double(body: { 'ok' => true, 'messages' => [],
                                                                  'has_more' => false }))
      result = test_obj.conversation_replies(token: 'xoxb', channel: 'C1', ts: '1.0', cursor: 'next')
      expect(result[:ok]).to be true
    end
  end

  describe '#conversation_members' do
    it 'calls conversations.members' do
      allow(mock_conn).to receive(:get).with('conversations.members', hash_including(channel: 'C1'))
                                       .and_return(double(body: { 'ok' => true, 'members' => [],
                                                                  'response_metadata' => {} }))
      result = test_obj.conversation_members(token: 'xoxb', channel: 'C1')
      expect(result[:ok]).to be true
    end
  end

  describe '#join_conversation' do
    it 'calls conversations.join' do
      allow(mock_conn).to receive(:post).with('conversations.join', { channel: 'C1' })
                                        .and_return(double(body: { 'ok' => true, 'channel' => { 'id' => 'C1' } }))
      result = test_obj.join_conversation(token: 'xoxb', channel: 'C1')
      expect(result[:ok]).to be true
    end
  end

  describe '#leave_conversation' do
    it 'calls conversations.leave' do
      allow(mock_conn).to receive(:post).with('conversations.leave', { channel: 'C1' })
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.leave_conversation(token: 'xoxb', channel: 'C1')
      expect(result[:ok]).to be true
    end
  end

  describe '#invite_to_conversation' do
    it 'calls conversations.invite' do
      allow(mock_conn).to receive(:post).with('conversations.invite',
                                              hash_including(channel: 'C1', users: 'U1,U2'))
                                        .and_return(double(body: { 'ok' => true, 'channel' => {} }))
      result = test_obj.invite_to_conversation(token: 'xoxb', channel: 'C1', users: 'U1,U2')
      expect(result[:ok]).to be true
    end
  end

  describe '#open_conversation' do
    it 'calls conversations.open with users' do
      allow(mock_conn).to receive(:post).with('conversations.open', hash_including(users: 'U1'))
                                        .and_return(double(body: { 'ok' => true, 'channel' => {} }))
      result = test_obj.open_conversation(token: 'xoxb', users: 'U1')
      expect(result[:ok]).to be true
    end

    it 'calls conversations.open with channel' do
      allow(mock_conn).to receive(:post).with('conversations.open', hash_including(channel: 'C1'))
                                        .and_return(double(body: { 'ok' => true, 'channel' => {} }))
      result = test_obj.open_conversation(token: 'xoxb', channel: 'C1')
      expect(result[:ok]).to be true
    end
  end

  describe '#create_conversation' do
    it 'calls conversations.create' do
      allow(mock_conn).to receive(:post).with('conversations.create',
                                              hash_including(name: 'general', is_private: false))
                                        .and_return(double(body: { 'ok' => true, 'channel' => {} }))
      result = test_obj.create_conversation(token: 'xoxb', name: 'general')
      expect(result[:ok]).to be true
    end

    it 'creates private conversation when is_private true' do
      allow(mock_conn).to receive(:post).with('conversations.create', hash_including(is_private: true))
                                        .and_return(double(body: { 'ok' => true, 'channel' => {} }))
      result = test_obj.create_conversation(token: 'xoxb', name: 'secret', is_private: true)
      expect(result[:ok]).to be true
    end
  end

  describe '#archive_conversation' do
    it 'calls conversations.archive' do
      allow(mock_conn).to receive(:post).with('conversations.archive', { channel: 'C1' })
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.archive_conversation(token: 'xoxb', channel: 'C1')
      expect(result[:ok]).to be true
    end
  end

  describe '#set_conversation_topic' do
    it 'calls conversations.setTopic' do
      allow(mock_conn).to receive(:post).with('conversations.setTopic',
                                              hash_including(channel: 'C1', topic: 'New Topic'))
                                        .and_return(double(body: { 'ok' => true, 'topic' => 'New Topic' }))
      result = test_obj.set_conversation_topic(token: 'xoxb', channel: 'C1', topic: 'New Topic')
      expect(result[:ok]).to be true
      expect(result[:topic]).to eq('New Topic')
    end
  end
end
