# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruolo/version'

Gem::Specification.new do |spec|
  spec.name = 'ruolo'
  spec.version = Ruolo::VERSION
  spec.authors = ['Mario Finelli']
  spec.email = ['mario@finel.li']

  spec.summary = 'A library to keep your static role-based access control policies in sync with your database.'
  spec.description = 'A library to keep your static role-based access control policies in sync with your database.'
  spec.homepage = 'https://github.com/mfinelli/ruolo'
  spec.license = 'Apache-2.0'
  spec.required_ruby_version = '>= 2.4.0'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'sequel', '~> 5.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'
end
