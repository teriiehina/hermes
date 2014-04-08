require 'rubygems'
require 'bundler/setup'


def load_settings(deploy)

  #
  # Variable Jenkins
  #

  projectDirectory      = deploy["paths"]["projectAbsolutPath"]
  buildURL              = "#{ENV['BUILD_URL']}"
  buildNumber           = "#{ENV['BUILD_NUMBER']}"
  jobName               = "#{ENV['JOB_NAME']}"
  
  buildConfiguration    = deploy["build"]["buildConfiguration"]
  signingIdentity       = deploy["signing"]["identity"]
  provisioningProfile   = deploy["signing"]["profile"]
  
  provisioningProfile   = "\"#{projectDirectory}/#{provisioningProfile}\""

  #
  # Variable Xcode
  #

  settings = Hash.new

  
  settings[:applicationName]      = deploy["infosPlist"]["CFBundleDisplayName"]
  settings[:projectDirectory]     = projectDirectory

  settings[:workspaceName]        = deploy["build"]["workspaceName"]
  settings[:projectName]          = deploy["build"]["projectName"]
  settings[:schemeName]           = deploy["build"]["schemeName"]
  settings[:projectInfosPath]     = deploy["paths"]["projectAbsolutPath"] + "/" + deploy["paths"]["infosPlistRelativePath"]
  settings[:userConfigPath]       = "#{projectDirectory}/UserConfig.h"

  settings[:targetSDK]            = deploy["build"]["targetSDK"]
  settings[:buildConfiguration]   = buildConfiguration
  settings[:buildDirectory]       = deploy["paths"]["projectAbsolutPath"] + "/" + deploy["paths"]["buildRelativePath"]
  settings[:buildNumber]          = deploy["build"]["buildNumber"]

  settings[:signingIdentity]      = signingIdentity
  settings[:provisioningProfile]  = provisioningProfile
  
  settings[:bundleName]           = deploy["build"]["schemeName"]
  
  settings

end