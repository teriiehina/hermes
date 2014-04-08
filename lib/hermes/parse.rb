require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

def updateParse (settings)

  return
  
  Parse.init  application_id: settings[:deploy]["parse"]["appId"],
              api_key:        settings[:deploy]["parse"]["apiKey"]

  newAppVersion                   = Parse::Object.new("ApplicationVersion")
  appOnParse                      = Parse::Pointer.new({"className" => "Application", "objectId" => settings[:deploy]["parse"]["dtStoreAppId"]})
  newAppVersion["applicationId"]  = appOnParse
  newAppVersion["level"]          = settings[:deploy]["parse"]["dtStoreAppLevel"]

  result = newAppVersion.save
  puts result

end

