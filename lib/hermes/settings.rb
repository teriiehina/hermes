require 'rubygems'
require 'bundler/setup'


def load_settings(deploy)

  settings = Hash.new
  
  settings[:deploy]               = deploy
  
  settings[:applicationName]      = deploy["infosPlist"]["CFBundleDisplayName"]
  settings[:projectDirectory]     = deploy["paths"]["projectAbsolutPath"]
  settings[:projectDirectory]     = Dir.pwd
  

  settings[:workspaceName]        = deploy["build"]["workspaceName"]
  settings[:schemeName]           = deploy["build"]["schemeName"]
  settings[:projectInfosPath]     = settings[:projectDirectory] + "/" + deploy["paths"]["infosPlistRelativePath"]

  settings[:targetSDK]            = deploy["build"]["targetSDK"]
  settings[:buildConfiguration]   = deploy["build"]["buildConfiguration"]
  settings[:buildDirectory]       = settings[:projectDirectory] + "/" + deploy["paths"]["buildRelativePath"]
  settings[:buildNumber]          = deploy["build"]["buildNumber"]
  settings[:buildNumber]          = `git rev-list --max-count=1 HEAD`[0..7]

  settings[:signingIdentity]      = deploy["signing"]["identity"]
  settings[:provisioningProfile]  = "\"#{settings[:projectDirectory]}/#{deploy["signing"]["profile"]}\""
  
  
  settings[:bundleName]           = deploy["build"]["projectName"]
  
  settings

end