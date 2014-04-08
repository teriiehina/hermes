require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

require_relative 'paths.rb'

def updateParse (settings)

  Parse.init  application_id: settings[:deploy]["parse"]["appId"],
              api_key:        settings[:deploy]["parse"]["apiKey"]
              
  parseInfos = settings[:deploy]["parse"]

  newAppVersion                     = Parse::Object.new("ApplicationVersion")
  newAppVersion["applicationId"]    = parseInfos["applicationId"]
  newAppVersion["versionNumber"]    = parseInfos["versionNumber"]
  newAppVersion["versionChangeLog"] = parseInfos["versionChangeLog"]
  newAppVersion["versionLevel"]     = parseInfos["versionLevel"].to_i
  newAppVersion["versionUrl"]       = publicPlistURL settings

  result = newAppVersion.save
  
  puts result.to_s

end

