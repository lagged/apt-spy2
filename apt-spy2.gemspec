# frozen_string_literal: true

require 'English'
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'apt/spy2/version'

Gem::Specification.new do |spec|
  spec.name          = 'apt-spy2'
  spec.version       = Apt::Spy2::VERSION
  spec.authors       = ['till']
  spec.email         = ['till@php.net']
  spec.description   = 'Keep your /etc/apt/sources.list up to date'
  spec.summary       = 'apt-spy2, or apt-spy for ubuntu'
  spec.homepage      = 'https://github.com/lagged/apt-spy2'
  spec.license       = 'BSD-2-Clause'

  spec.required_ruby_version = ['>= 2.7', '< 3.3']

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'colored', '>= 1.2'
  spec.add_dependency 'json'
  spec.add_dependency 'nokogiri', '~> 1.14.1'
  spec.add_dependency 'thor', '>= 0.18.1'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.15.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov', '~> 0.18'
  spec.add_development_dependency 'simplecov-lcov', '~> 0.8.0'
end
