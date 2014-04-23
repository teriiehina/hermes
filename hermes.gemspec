# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hermes/version'

Gem::Specification.new do |spec|
  spec.name          = "hermes"
  spec.version       = Hermes::VERSION
  
  spec.homepage    = 'https://github.com/teriiehina/hermes'
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

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake" , '~> 0'
  spec.add_development_dependency 'thor', '~> 0'
  spec.add_development_dependency 'plist', '~> 0'
  spec.add_development_dependency 'net-scp', '~> 0'
  spec.add_development_dependency 'parse-ruby-client', '~> 0'
  spec.add_development_dependency 'nokogiri', '~> 0'
  spec.add_development_dependency 'CFPropertyList', '~> 0'
  spec.add_development_dependency 'xcpretty', '~> 0'
end
