Gem::Specification.new do |s|
  
  s.name        = 'hermes'
  s.version     = '0.0.1'
  s.date        = '2014-03-05'
  s.summary     = "Build and distribute iOS app"
  s.description = "A tool that works only with plist files"
  s.authors     = ["Peter Meuel"]
  s.email       = 'peter@teriiehina.net'
  s.files       = ["lib/build.rb" , "lib/deploy.rb" , "lib/git.rb" , "lib/ipa.rb" , 
                    "lib/parse.rb" , "lib/paths.rb" , "lib/plist.rb" , "lib/settings.rb" , 
                    "lib/update_icon.rb" , "lib/upload.rb"]
  s.homepage    = 'https://github.org/teriiehina/hermes'
  s.license     = 'MIT'

end