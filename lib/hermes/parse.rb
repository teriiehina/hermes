require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

def updateParse (settings , deploy)

  return
  
  Parse.init  application_id: deploy["parse"]["appId"],
              api_key:        deploy["parse"]["apiKey"]

  newAppVersion                   = Parse::Object.new("ApplicationVersion")
  appOnParse                      = Parse::Pointer.new({"className" => "Application", "objectId" => deploy["parse"]["dtStoreAppId"]})
  newAppVersion["applicationId"]  = appOnParse
  newAppVersion["level"]          = deploy["parse"]["dtStoreAppLevel"]

  result = newAppVersion.save
  puts result

end

