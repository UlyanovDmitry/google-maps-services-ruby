# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google/maps/services/version'

Gem::Specification.new do |spec|
  spec.name          = 'google-maps-services'
  spec.version       = GoogleMaps::Services::VERSION
  spec.authors       = ['Dmitry Ulyanov']
  spec.email         = ['ulyanovda8@gmail.com']

  spec.summary       = 'This helps you to work with Google Maps Distance Matrix API'
  spec.description   = 'This helps you to work with Google Maps Distance Matrix API'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w(lib)

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
