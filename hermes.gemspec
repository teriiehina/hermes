# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hermes/version'

Gem::Specification.new do |spec|
  spec.name          = "hermes"
  spec.version       = Hermes::VERSION
  
  s.homepage    = 'https://github.com/teriiehina/hermes'
  s.license     = 'MIT'
  
  s.date        = '2014-03-06'
  s.summary     = "Build and distribute iOS app"
  s.description = "A tool that works only with plist files"
  s.authors     = ["Peter Meuel"]
  s.email       = 'peter@teriiehina.net'
                    

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'thor'
  spec.add_development_dependency 'plist'
  spec.add_development_dependency 'net-scp'
  spec.add_development_dependency 'parse-ruby-client'
  spec.add_development_dependency 'nokogiri'
  
end
