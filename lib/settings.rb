require 'rubygems'
require 'bundler/setup'


def load_xcode_settings(deploy , extra_commands)

  #
  # Variable Jenkins
  #

  projectDirectory      = "#{ENV['WORKSPACE']}/PagesJaunes"
  buildURL              = "#{ENV['BUILD_URL']}"
  buildNumber           = "#{ENV['BUILD_NUMBER']}"
  jobName               = "#{ENV['JOB_NAME']}"
  
  buildConfiguration    = deploy["buildConfiguration"].nil?  ? "Release" : deploy["buildConfiguration"]
  signingIdentity       = deploy["signing"]["identity"].nil? ? "iPhone Distribution: PagesJaunes" : deploy["signing"]["identity"]
  provisioningProfile   = deploy["signing"]["profile"].nil?  ? "PagesJaunes/jenkins/profiles/DSEM_Distribution_Profile.mobileprovision" : deploy["signing"]["profile"]
  provisioningProfile   = "\"#{projectDirectory}/#{provisioningProfile}\""

  #
  # Variable Xcode
  #

  xcode_settings = Hash.new

  xcode_settings[:applicationName]      = deploy["displayName"]
  xcode_settings[:projectDirectory]     = projectDirectory

  xcode_settings[:workspaceName]        = "PagesJaunes.xcworkspace"
  xcode_settings[:projectName]          = "PagesJaunes"
  xcode_settings[:schemeName]           = "PagesJaunes"
  xcode_settings[:projectInfosPath]     = "#{projectDirectory}/PagesJaunes/PagesJaunes-Info.plist"
  xcode_settings[:userConfigPath]       = "#{projectDirectory}/UserConfig.h"

  xcode_settings[:targetSDK]            = "iphoneos7.0"
  xcode_settings[:buildConfiguration]   = buildConfiguration
  xcode_settings[:buildDirectory]       = "#{projectDirectory}/build"
  xcode_settings[:buildNumber]          = buildNumber

  xcode_settings[:signingIdentity]      = signingIdentity
  xcode_settings[:provisioningProfile]  = provisioningProfile

  if extra_commands
    xcode_settings[:extra_commands] = " " + extra_commands
  end
  
  xcode_settings

end