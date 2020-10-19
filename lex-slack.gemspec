require_relative 'lib/legion/extensions/slack/version'

Gem::Specification.new do |spec|
  spec.name          = 'legion-extensions-slack'
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
  spec.metadata['changelog_uri'] = 'https://bitbucket.org/legion-io/lex-slack/src/master/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'legionio'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
