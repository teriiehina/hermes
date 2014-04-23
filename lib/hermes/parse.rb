require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

require_relative 'paths.rb'

def updateParse (settings)

  Parse.init  application_id: settings[:deploy]["parse"]["appId"],
              api_key:        settings[:deploy]["parse"]["apiKey"]
              
  parseInfos = settings[:deploy]["parse"]
  
  objectId = parseInfos["objectId"]
  
  if (objectId.nil? or objectId.length == 0)
    appVersion = Parse::Object.new("ApplicationVersion")
  else
    appVersionsQuery = Parse::Query.new("GameScore")
    appVersionsQuery.eq("objectId", objectId)
    appVersion = appVersionsQuery.get.first
  end

  appVersion["applicationId"]    = parseInfos["applicationId"]
  appVersion["versionNumber"]    = parseInfos["versionNumber"]
  appVersion["versionChangeLog"] = parseInfos["versionChangeLog"]
  appVersion["versionLevel"]     = parseInfos["versionLevel"].to_i
  appVersion["versionUrl"]       = publicPlistURL settings

  result = newAppVersion.save
  
  settings[:deploy]["parse"]["objectId"] =  result["objectId"]
  
  puts "we should save #{result["objectId"]}"
  
  
  puts result.to_s

end

