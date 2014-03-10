require 'rubygems'
require 'bundler/setup'


def load_xcode_settings(deploy , extra_commands)

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

  xcode_settings = Hash.new

  
  xcode_settings[:applicationName]      = deploy["infosPlist"]["CFBundleDisplayName"]
  xcode_settings[:projectDirectory]     = projectDirectory

  xcode_settings[:workspaceName]        = deploy["build"]["workspaceName"]
  xcode_settings[:projectName]          = deploy["build"]["projectName"]
  xcode_settings[:schemeName]           = deploy["build"]["schemeName"]
  xcode_settings[:projectInfosPath]     = deploy["paths"]["projectAbsolutPath"] + "/" + deploy["paths"]["infosPlistRelativePath"]
  xcode_settings[:userConfigPath]       = "#{projectDirectory}/UserConfig.h"

  xcode_settings[:targetSDK]            = deploy["build"]["targetSDK"]
  xcode_settings[:buildConfiguration]   = buildConfiguration
  xcode_settings[:buildDirectory]       = deploy["paths"]["projectAbsolutPath"] + "/" + deploy["paths"]["buildRelativePath"]
  xcode_settings[:buildNumber]          = deploy["build"]["buildNumber"]

  xcode_settings[:signingIdentity]      = signingIdentity
  xcode_settings[:provisioningProfile]  = provisioningProfile
  
  xcode_settings[:bundleName]           = deploy["build"]["schemeName"]
  
  if extra_commands
    xcode_settings[:extra_commands] = " " + extra_commands
  end
  
  xcode_settings

end