require 'rubygems'
require 'bundler/setup'


def load_settings(deploy)

  settings = Hash.new
  
  settings[:deploy]               = deploy
  
  settings[:applicationName]      = deploy["infosPlist"]["CFBundleDisplayName"]
  settings[:CFBundleVersion]      = deploy["infosPlist"]["CFBundleVersion"]

  settings[:projectDirectory]     = Dir.pwd
  settings[:projectInfosPath]     = settings[:projectDirectory] + "/" + deploy["paths"]["infosPlistRelativePath"]
  
  settings[:bundleName]           = deploy["build"]["projectName"]
  settings[:workspaceName]        = deploy["build"]["workspaceName"]
  settings[:schemeName]           = deploy["build"]["schemeName"]
  settings[:targetSDK]            = deploy["build"]["targetSDK"]

  settings[:buildConfiguration]   = deploy["build"]["buildConfiguration"]
  settings[:buildDirectory]       = settings[:projectDirectory] + "/" + deploy["paths"]["buildRelativePath"]
  settings[:buildNumber]          = `git rev-list --max-count=1 HEAD`[0..7]

  settings[:gitSHA1]              = `git rev-list --max-count=1 HEAD`[0..7]

  settings[:signingIdentity]      = deploy["signing"]["identity"]
  settings[:provisioningProfile]  = "\"#{settings[:projectDirectory]}/#{deploy["signing"]["profile"]}\""
    
  settings

end