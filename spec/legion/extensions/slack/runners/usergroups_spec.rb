# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack::Runners::Usergroups do
  let(:test_obj) { Object.new.extend(described_class) }
  let(:mock_conn) { instance_double(Faraday::Connection) }

  before do
    allow(test_obj).to receive(:api_connection).and_return(mock_conn)
  end

  describe '#list_usergroups' do
    it 'calls usergroups.list' do
      allow(mock_conn).to receive(:get).with('usergroups.list',
                                             hash_including(include_users: false, include_disabled: false))
                                       .and_return(double(body: { 'ok' => true, 'usergroups' => [] }))
      result = test_obj.list_usergroups(token: 'xoxb')
      expect(result[:ok]).to be true
      expect(result[:usergroups]).to eq([])
    end

    it 'accepts include_users and include_disabled' do
      allow(mock_conn).to receive(:get).with('usergroups.list',
                                             hash_including(include_users: true, include_disabled: true))
                                       .and_return(double(body: { 'ok' => true, 'usergroups' => [] }))
      result = test_obj.list_usergroups(token: 'xoxb', include_users: true, include_disabled: true)
      expect(result[:ok]).to be true
    end
  end

  describe '#create_usergroup' do
    it 'calls usergroups.create' do
      allow(mock_conn).to receive(:post).with('usergroups.create', hash_including(name: 'my-group'))
                                        .and_return(double(body: { 'ok' => true, 'usergroup' => {} }))
      result = test_obj.create_usergroup(token: 'xoxb', name: 'my-group')
      expect(result[:ok]).to be true
    end

    it 'includes optional handle and description' do
      allow(mock_conn).to receive(:post).with('usergroups.create',
                                              hash_including(handle: 'mygroup', description: 'A group'))
                                        .and_return(double(body: { 'ok' => true, 'usergroup' => {} }))
      result = test_obj.create_usergroup(token: 'xoxb', name: 'my-group', handle: 'mygroup',
                                         description: 'A group')
      expect(result[:ok]).to be true
    end
  end

  describe '#update_usergroup' do
    it 'calls usergroups.update' do
      allow(mock_conn).to receive(:post).with('usergroups.update', hash_including(usergroup: 'S1'))
                                        .and_return(double(body: { 'ok' => true, 'usergroup' => {} }))
      result = test_obj.update_usergroup(token: 'xoxb', usergroup: 'S1', name: 'New Name')
      expect(result[:ok]).to be true
    end
  end

  describe '#disable_usergroup' do
    it 'calls usergroups.disable' do
      allow(mock_conn).to receive(:post).with('usergroups.disable', { usergroup: 'S1' })
                                        .and_return(double(body: { 'ok' => true, 'usergroup' => {} }))
      result = test_obj.disable_usergroup(token: 'xoxb', usergroup: 'S1')
      expect(result[:ok]).to be true
    end
  end

  describe '#enable_usergroup' do
    it 'calls usergroups.enable' do
      allow(mock_conn).to receive(:post).with('usergroups.enable', { usergroup: 'S1' })
                                        .and_return(double(body: { 'ok' => true, 'usergroup' => {} }))
      result = test_obj.enable_usergroup(token: 'xoxb', usergroup: 'S1')
      expect(result[:ok]).to be true
    end
  end

  describe '#list_usergroup_users' do
    it 'calls usergroups.users.list' do
      allow(mock_conn).to receive(:get).with('usergroups.users.list', { usergroup: 'S1' })
                                       .and_return(double(body: { 'ok' => true, 'users' => ['U1'] }))
      result = test_obj.list_usergroup_users(token: 'xoxb', usergroup: 'S1')
      expect(result[:ok]).to be true
      expect(result[:users]).to eq(['U1'])
    end
  end

  describe '#update_usergroup_users' do
    it 'calls usergroups.users.update' do
      allow(mock_conn).to receive(:post).with('usergroups.users.update',
                                              hash_including(usergroup: 'S1', users: 'U1,U2'))
                                        .and_return(double(body: { 'ok' => true, 'usergroup' => {} }))
      result = test_obj.update_usergroup_users(token: 'xoxb', usergroup: 'S1', users: 'U1,U2')
      expect(result[:ok]).to be true
    end
  end
end
