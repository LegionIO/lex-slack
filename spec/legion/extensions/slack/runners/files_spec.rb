# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Files do
  let(:test_obj) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(test_obj).to receive(:api_connection).and_return(mock_conn)
  end

  describe '#upload_file' do
    it 'performs two-step upload' do
      allow(mock_conn).to receive(:get).with('files.getUploadURLExternal', hash_including(filename: 'test.txt'))
                                       .and_return(double(body: { 'upload_url' => 'https://upload.example.com/file',
                                                                  'file_id'    => 'F1' }))
      allow(Faraday).to receive(:put).with('https://upload.example.com/file', 'content', anything)
                                     .and_return(double(status: 200))
      allow(mock_conn).to receive(:post).with('files.completeUploadExternal',
                                              hash_including(files: [{ id: 'F1', title: 'test.txt' }]))
                                        .and_return(double(body: { 'ok' => true, 'files' => [] }))
      result = test_obj.upload_file(token: 'xoxb', filename: 'test.txt', content: 'content')
      expect(result[:ok]).to be true
    end

    it 'uses provided title and includes channel_id when given' do
      allow(mock_conn).to receive(:get).with('files.getUploadURLExternal', anything)
                                       .and_return(double(body: { 'upload_url' => 'https://upload.example.com/file',
                                                                  'file_id'    => 'F2' }))
      allow(Faraday).to receive(:put).and_return(double(status: 200))
      allow(mock_conn).to receive(:post).with('files.completeUploadExternal',
                                              hash_including(files:      [{ id: 'F2', title: 'My File' }],
                                                             channel_id: 'C1'))
                                        .and_return(double(body: { 'ok' => true, 'files' => [] }))
      result = test_obj.upload_file(token: 'xoxb', filename: 'data.txt', content: 'data',
                                    channel: 'C1', title: 'My File')
      expect(result[:ok]).to be true
    end
  end

  describe '#list_files' do
    it 'calls files.list' do
      allow(mock_conn).to receive(:get).with('files.list', hash_including(limit: 100))
                                       .and_return(double(body: { 'ok' => true, 'files' => [] }))
      result = test_obj.list_files(token: 'xoxb')
      expect(result[:ok]).to be true
      expect(result[:files]).to eq([])
    end

    it 'includes channel and user when provided' do
      allow(mock_conn).to receive(:get).with('files.list', hash_including(channel: 'C1', user: 'U1'))
                                       .and_return(double(body: { 'ok' => true, 'files' => [] }))
      result = test_obj.list_files(token: 'xoxb', channel: 'C1', user: 'U1')
      expect(result[:ok]).to be true
    end
  end

  describe '#file_info' do
    it 'calls files.info' do
      allow(mock_conn).to receive(:get).with('files.info', { file: 'F1' })
                                       .and_return(double(body: { 'ok' => true, 'file' => { 'id' => 'F1' } }))
      result = test_obj.file_info(token: 'xoxb', file: 'F1')
      expect(result[:ok]).to be true
      expect(result[:file]).to include('id' => 'F1')
    end
  end

  describe '#delete_file' do
    it 'calls files.delete' do
      allow(mock_conn).to receive(:post).with('files.delete', { file: 'F1' })
                                        .and_return(double(body: { 'ok' => true }))
      result = test_obj.delete_file(token: 'xoxb', file: 'F1')
      expect(result[:ok]).to be true
    end
  end

  describe '#share_file' do
    it 'calls files.sharedPublicURL' do
      allow(mock_conn).to receive(:post).with('files.sharedPublicURL', { file: 'F1' })
                                        .and_return(double(body: { 'ok' => true, 'file' => {} }))
      result = test_obj.share_file(token: 'xoxb', file: 'F1')
      expect(result[:ok]).to be true
    end
  end
end
