# frozen_string_literal: true

require_relative 'lib/siege/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.name    = 'siege'
  spec.version = Siege::VERSION
  spec.authors = ['Rustam Ibragimov']
  spec.email   = ['iamdaiver@gmail.com']

  spec.summary     = 'Infrastruction-level tools and abstractions for your software.'
  spec.description = 'Software architecture principles realized as a code.'
  spec.homepage    = 'https://github.com/0exp/siege'
  spec.license     = 'MIT'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/0exp/siege'
  spec.metadata['changelog_uri']   = 'https://github.com/0exp/siege/blob/master/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'smart_container', '~> 0.5'

  spec.add_development_dependency 'bundler',          '~> 2.1'
  spec.add_development_dependency 'rake',             '~> 13.0'
  spec.add_development_dependency 'rspec',            '~> 3.9'
  spec.add_development_dependency 'armitage-rubocop', '~> 0.78'
  spec.add_development_dependency 'simplecov',        '~> 0.17'
  spec.add_development_dependency 'pry',              '~> 0.12'
  spec.add_development_dependency 'solargraph',       '~> 0.38'
end
