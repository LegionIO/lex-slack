# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Chat do
  let(:test_obj) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }
  let(:mock_webhook_conn) { instance_double(Faraday::Connection) }

  before do
    allow(test_obj).to receive(:api_connection).and_return(mock_conn)
    allow(test_obj).to receive(:webhook_connection).and_return(mock_webhook_conn)
  end

  describe '#post_message' do
    it 'posts to chat.postMessage' do
      allow(mock_conn).to receive(:post).with('chat.postMessage', hash_including(channel: 'C123', text: 'Hello'))
                                        .and_return(double(body: { 'ok' => true, 'ts' => '1234.5', 'channel' => 'C123', 'message' => {} }))
      result = test_obj.post_message(token: 'xoxb', channel: 'C123', text: 'Hello')
      expect(result[:ok]).to be true
      expect(result[:ts]).to eq('1234.5')
    end

    it 'includes optional blocks and thread_ts' do
      allow(mock_conn).to receive(:post).with('chat.postMessage',
                                              hash_including(blocks: [], thread_ts: '999.0'))
                                        .and_return(double(body: { 'ok' => true, 'ts' => '1.0', 'channel' => 'C1', 'message' => {} }))
      result = test_obj.post_message(token: 'xoxb', channel: 'C1', text: 'Hi', blocks: [], thread_ts: '999.0')
      expect(result[:ok]).to be true
    end
  end

  describe '#send_webhook' do
    it 'posts to webhook URL' do
      allow(mock_webhook_conn).to receive(:post).with('/services/T/B/X', { text: 'Hello' })
                                                .and_return(double(body: 'ok'))
      result = test_obj.send_webhook(message: 'Hello', webhook: '/services/T/B/X')
      expect(result[:success]).to be true
    end

    it 'returns body in result' do
      allow(mock_webhook_conn).to receive(:post).with('/services/T/B/X', { text: 'Hi' })
                                                .and_return(double(body: 'ok'))
      result = test_obj.send_webhook(message: 'Hi', webhook: '/services/T/B/X')
      expect(result).to have_key(:body)
    end
  end

  describe '#update_message' do
    it 'posts to chat.update' do
      allow(mock_conn).to receive(:post).with('chat.update',
                                              hash_including(channel: 'C1', ts: '1.0'))
                                        .and_return(double(body: { 'ok' => true, 'ts' => '1.0', 'channel' => 'C1' }))
      result = test_obj.update_message(token: 'xoxb', channel: 'C1', ts: '1.0', text: 'Updated')
      expect(result[:ok]).to be true
    end

    it 'includes blocks when provided' do
      allow(mock_conn).to receive(:post).with('chat.update',
                                              hash_including(blocks: []))
                                        .and_return(double(body: { 'ok' => true, 'ts' => '1.0', 'channel' => 'C1' }))
      result = test_obj.update_message(token: 'xoxb', channel: 'C1', ts: '1.0', blocks: [])
      expect(result[:ok]).to be true
    end
  end

  describe '#delete_message' do
    it 'posts to chat.delete' do
      allow(mock_conn).to receive(:post).with('chat.delete', hash_including(channel: 'C1', ts: '1.0'))
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.delete_message(token: 'xoxb', channel: 'C1', ts: '1.0')
      expect(result[:ok]).to be true
    end
  end

  describe '#schedule_message' do
    it 'posts to chat.scheduleMessage' do
      allow(mock_conn).to receive(:post).with('chat.scheduleMessage',
                                              hash_including(channel: 'C1', text: 'Later', post_at: 9_999_999))
                                        .and_return(double(body: { 'ok' => true,
                                                                   'scheduled_message_id' => 'sm1', 'post_at' => 9_999_999 }))
      result = test_obj.schedule_message(token: 'xoxb', channel: 'C1', text: 'Later', post_at: 9_999_999)
      expect(result[:ok]).to be true
      expect(result[:scheduled_message_id]).to eq('sm1')
    end

    it 'includes blocks when provided' do
      allow(mock_conn).to receive(:post).with('chat.scheduleMessage',
                                              hash_including(blocks: []))
                                        .and_return(double(body: { 'ok' => true, 'scheduled_message_id' => 'sm2',
                                                                   'post_at' => 1 }))
      result = test_obj.schedule_message(token: 'xoxb', channel: 'C1', text: 'Later', post_at: 1, blocks: [])
      expect(result[:ok]).to be true
    end
  end

  describe '#delete_scheduled' do
    it 'posts to chat.deleteScheduledMessage' do
      allow(mock_conn).to receive(:post).with('chat.deleteScheduledMessage',
                                              hash_including(channel: 'C1', scheduled_message_id: 'sm1'))
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.delete_scheduled(token: 'xoxb', channel: 'C1', scheduled_message_id: 'sm1')
      expect(result[:ok]).to be true
    end
  end
end
