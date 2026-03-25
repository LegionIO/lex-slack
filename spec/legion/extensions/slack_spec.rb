# frozen_string_literal: true

RSpec.describe Legion::Extensions::Slack do
  it 'has a version number' do
    expect(Legion::Extensions::Slack::VERSION).to eq('0.3.2')
  end

  it 'defines Helpers::Client' do
    expect(described_class::Helpers::Client).to be_a(Module)
  end

  it 'defines all runner modules' do
    expect(described_class::Runners::Blocks).to be_a(Module)
    expect(described_class::Runners::Chat).to be_a(Module)
    expect(described_class::Runners::Conversations).to be_a(Module)
    expect(described_class::Runners::Users).to be_a(Module)
    expect(described_class::Runners::Reactions).to be_a(Module)
    expect(described_class::Runners::Files).to be_a(Module)
    expect(described_class::Runners::Pins).to be_a(Module)
    expect(described_class::Runners::Bookmarks).to be_a(Module)
    expect(described_class::Runners::Reminders).to be_a(Module)
    expect(described_class::Runners::Usergroups).to be_a(Module)
    expect(described_class::Runners::Views).to be_a(Module)
    expect(described_class::Runners::Search).to be_a(Module)
  end

  it 'defines Client' do
    expect(described_class::Client).to be_a(Class)
  end

  it 'defines Actor::MessagePoller' do
    expect(described_class::Actor::MessagePoller).to be_a(Class)
  end
end
