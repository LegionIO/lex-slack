require_relative 'lib/legion/extensions/slack/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-slack'
  spec.version       = Legion::Extensions::Slack::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX::Slack'
  spec.description   = 'Connects Legion to Slack'
  spec.homepage      = 'https://bitbucket.org/legion-io/lex-slack'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://bitbucket.org/legion-io/lex-slack/src'
  spec.metadata['documentation_uri'] = 'https://legionio.atlassian.net/wiki/spaces/LEX/pages/631504974'
  spec.metadata['changelog_uri'] = 'https://legionio.atlassian.net/wiki/spaces/LEX/pages/631570484'
  spec.metadata['bug_tracker_uri'] = 'https://bitbucket.org/legion-io/lex-slack/issues'
  spec.require_paths = ['lib']

  spec.add_development_dependency 'legionio'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'

  spec.add_dependency 'faraday'
end
