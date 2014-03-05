require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

require_relative 'paths.rb'


def generateDeployPlist (xcode_settings , deploy)
  
  puts "Creation du plist"
  
  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildDirectory      = xcode_settings[:buildDirectory]
  buildNumber         = xcode_settings[:buildNumber]
  projectInfosPath    = xcode_settings[:projectInfosPath]
  
  projectInfos    = Plist::parse_xml(projectInfosPath)
  deployPlistPath = deployPlistPath(xcode_settings , deploy)
  
  deployPlist = Hash.new
  items       = Array.new
  item        = Hash.new
  
  
  assets      = Array.new
  asset       = Hash.new
  asset['kind'] = 'software-package'
  asset['url']  = deploy["uploadServer"]["publicURL"] + "/" + ipaName(xcode_settings , deploy)

  assets.push asset
  
  metadata    = Hash.new
  metadata['bundle-identifier'] = deploy["bundleID"]
  metadata['bundle-version']    = projectInfos['CFBundleVersion']
  metadata['subtitle']          = 'by SoLocal'
  metadata['title']             = deploy["displayName"]
  metadata['kind']              = 'software'
  
  item['assets']    = assets
  item['metadata']  = metadata
  
  items.push item
  deployPlist['items'] = items
  Plist::Emit.save_plist(deployPlist , deployPlistPath)
  
  puts "Plist : " + deployPlistPath
  
end

