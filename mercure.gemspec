# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mercure/version'

Gem::Specification.new do |spec|
  spec.name          = "mercure"
  spec.version       = Mercure::VERSION
  
  spec.homepage    = 'https://github.com/teriiehina/mercure'
  spec.license     = 'MIT'
  
  spec.date        = '2014-03-06'
  spec.summary     = "Build and distribute iOS app"
  spec.description = "A tool that works only with plist files"
  spec.authors     = ["Peter Meuel"]
  spec.email       = 'peter@teriiehina.net'
                    

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bundler"
  spec.add_runtime_dependency "rake"
  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'plist'
  spec.add_runtime_dependency 'net-scp'
  spec.add_runtime_dependency 'parse-ruby-client'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'CFPropertyList'
  spec.add_runtime_dependency 'xcpretty'
end
