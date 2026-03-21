# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Views do
  let(:test_obj) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }
  let(:sample_view) { { type: 'modal', title: { type: 'plain_text', text: 'My Modal' }, blocks: [] } }

  before do
    allow(test_obj).to receive(:api_connection).and_return(mock_conn)
  end

  describe '#open_view' do
    it 'calls views.open' do
      allow(mock_conn).to receive(:post).with('views.open',
                                              hash_including(trigger_id: 'T1', view: sample_view))
                                        .and_return(double(body: { 'ok' => true, 'view' => {} }))
      result = test_obj.open_view(token: 'xoxb', trigger_id: 'T1', view: sample_view)
      expect(result[:ok]).to be true
    end
  end

  describe '#push_view' do
    it 'calls views.push' do
      allow(mock_conn).to receive(:post).with('views.push',
                                              hash_including(trigger_id: 'T1', view: sample_view))
                                        .and_return(double(body: { 'ok' => true, 'view' => {} }))
      result = test_obj.push_view(token: 'xoxb', trigger_id: 'T1', view: sample_view)
      expect(result[:ok]).to be true
    end
  end

  describe '#update_view' do
    it 'calls views.update' do
      allow(mock_conn).to receive(:post).with('views.update',
                                              hash_including(view_id: 'V1', view: sample_view))
                                        .and_return(double(body: { 'ok' => true, 'view' => {} }))
      result = test_obj.update_view(token: 'xoxb', view_id: 'V1', view: sample_view)
      expect(result[:ok]).to be true
    end

    it 'includes hash when provided' do
      allow(mock_conn).to receive(:post).with('views.update', hash_including(hash: 'abc123'))
                                        .and_return(double(body: { 'ok' => true, 'view' => {} }))
      result = test_obj.update_view(token: 'xoxb', view_id: 'V1', view: sample_view, hash: 'abc123')
      expect(result[:ok]).to be true
    end
  end

  describe '#publish_view' do
    it 'calls views.publish' do
      allow(mock_conn).to receive(:post).with('views.publish',
                                              hash_including(user_id: 'U1', view: sample_view))
                                        .and_return(double(body: { 'ok' => true, 'view' => {} }))
      result = test_obj.publish_view(token: 'xoxb', user_id: 'U1', view: sample_view)
      expect(result[:ok]).to be true
    end
  end
end
