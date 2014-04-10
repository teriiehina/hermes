require 'rubygems'
require 'bundler/setup'


def load_settings(deploy)


  # trouver un moyen d'avoir un numéro incrémental unique
  buildNumber           = "#{ENV['BUILD_NUMBER']}"

  settings = Hash.new
  
  settings[:deploy]               = deploy
  
  settings[:applicationName]      = deploy["infosPlist"]["CFBundleDisplayName"]
  settings[:projectDirectory]     = deploy["paths"]["projectAbsolutPath"]

  settings[:workspaceName]        = deploy["build"]["workspaceName"]
  settings[:schemeName]           = deploy["build"]["schemeName"]
  settings[:projectInfosPath]     = deploy["paths"]["projectAbsolutPath"] + "/" + deploy["paths"]["infosPlistRelativePath"]

  settings[:targetSDK]            = deploy["build"]["targetSDK"]
  settings[:buildConfiguration]   = deploy["build"]["buildConfiguration"]
  settings[:buildDirectory]       = deploy["paths"]["projectAbsolutPath"] + "/" + deploy["paths"]["buildRelativePath"]
  settings[:buildNumber]          = deploy["build"]["buildNumber"]

  settings[:signingIdentity]      = deploy["signing"]["identity"]
  settings[:provisioningProfile]  = "\"#{deploy["paths"]["projectAbsolutPath"]}/#{deploy["signing"]["profile"]}\""
  
  settings[:bundleName]           = deploy["build"]["schemeName"]
  
  settings

end