# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Reminders do
  let(:test_obj) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(test_obj).to receive(:api_connection).and_return(mock_conn)
  end

  describe '#add_reminder' do
    it 'calls reminders.add' do
      allow(mock_conn).to receive(:post).with('reminders.add', hash_including(text: 'Call Bob', time: 1_000_000))
                                        .and_return(double(body: { 'ok' => true, 'reminder' => { 'id' => 'Rm1' } }))
      result = test_obj.add_reminder(token: 'xoxb', text: 'Call Bob', time: 1_000_000)
      expect(result[:ok]).to be true
      expect(result[:reminder]).to include('id' => 'Rm1')
    end

    it 'includes user when provided' do
      allow(mock_conn).to receive(:post).with('reminders.add', hash_including(user: 'U1'))
                                        .and_return(double(body: { 'ok' => true, 'reminder' => {} }))
      result = test_obj.add_reminder(token: 'xoxb', text: 'Call Bob', time: 1_000_000, user: 'U1')
      expect(result[:ok]).to be true
    end
  end

  describe '#complete_reminder' do
    it 'calls reminders.complete' do
      allow(mock_conn).to receive(:post).with('reminders.complete', { reminder: 'Rm1' })
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.complete_reminder(token: 'xoxb', reminder: 'Rm1')
      expect(result[:ok]).to be true
    end
  end

  describe '#delete_reminder' do
    it 'calls reminders.delete' do
      allow(mock_conn).to receive(:post).with('reminders.delete', { reminder: 'Rm1' })
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.delete_reminder(token: 'xoxb', reminder: 'Rm1')
      expect(result[:ok]).to be true
    end
  end

  describe '#reminder_info' do
    it 'calls reminders.info' do
      allow(mock_conn).to receive(:get).with('reminders.info', { reminder: 'Rm1' })
                                       .and_return(double(body: { 'ok' => true, 'reminder' => { 'id' => 'Rm1' } }))
      result = test_obj.reminder_info(token: 'xoxb', reminder: 'Rm1')
      expect(result[:ok]).to be true
      expect(result[:reminder]).to include('id' => 'Rm1')
    end
  end

  describe '#list_reminders' do
    it 'calls reminders.list' do
      allow(mock_conn).to receive(:get).with('reminders.list', {})
                                       .and_return(double(body: { 'ok' => true, 'reminders' => [] }))
      result = test_obj.list_reminders(token: 'xoxb')
      expect(result[:ok]).to be true
      expect(result[:reminders]).to eq([])
    end
  end
end
