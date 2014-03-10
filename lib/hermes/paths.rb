require 'rubygems'
require 'bundler/setup'

def appPath (xcode_settings , deploy)
  
  buildDirectory      = xcode_settings[:buildDirectory]
  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildNumber         = xcode_settings[:buildNumber]
  bundleName          = xcode_settings[:bundleName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{bundleName}.app"
  
end

def ipaName(xcode_settings , deploy)

  buildDirectory      = xcode_settings[:buildDirectory]
  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildNumber         = xcode_settings[:buildNumber]
  applicationName     = xcode_settings[:applicationName]
  
  pjServerConf        = deploy["infosPlist"]["PJServerConf"]
  cimob               = fileNameForEnv pjServerConf

  "#{applicationName}.#{cimob}.#{buildNumber}.ipa"
  
end

def ipaPath (xcode_settings , deploy)
  
  buildDirectory      = xcode_settings[:buildDirectory]
  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildNumber         = xcode_settings[:buildNumber]
  applicationName     = xcode_settings[:applicationName]
  ipaName             = ipaName(xcode_settings , deploy)
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{ipaName}"
  
end

def remoteIpaPath (xcode_settings , deploy)
  
  ipaName             = ipaName(xcode_settings , deploy)
  remotePath          = deploy["uploadServer"]["path"]
  
  "#{remotePath}/#{ipaName}"
  
end



def dsymPath (xcode_settings , deploy)
  
  buildDirectory      = xcode_settings[:buildDirectory]
  buildConfiguration  = xcode_settings[:buildConfiguration]
  bundleName          = xcode_settings[:bundleName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{bundleName}.app.dSYM"
  
end

def savedDsymPath (xcode_settings , deploy)
  
  buildDirectory      = xcode_settings[:buildDirectory]
  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildNumber         = xcode_settings[:buildNumber]
  applicationName     = xcode_settings[:applicationName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{applicationName}.#{buildNumber}.app.dSYM"
  
end

def zippedDsymPath (xcode_settings , deploy)
  
  savedDsymPath(xcode_settings , deploy) + ".zip"
  
end

def remoteDsymPath (xcode_settings , deploy)
  
  buildDirectory      = xcode_settings[:buildDirectory]
  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildNumber         = xcode_settings[:buildNumber]
  applicationName     = xcode_settings[:applicationName]
  ipaName             = ipaName(xcode_settings , deploy)
  remotePath          = deploy["uploadServer"]["path"]
  pjServerConf        = deploy["infosPlist"]["PJServerConf"]
  fileName            = fileNameForEnv pjServerConf
  
  dsymName = "#{applicationName}.#{buildNumber}.app.dSYM.zip"
  
  "#{remotePath}/#{dsymName}"
  
end

def deployPlistPath (xcode_settings , deploy)

  buildDirectory      = xcode_settings[:buildDirectory]
  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildNumber         = xcode_settings[:buildNumber]
  applicationName     = xcode_settings[:applicationName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{applicationName}.#{buildNumber}.plist"

end

def remoteDeployPlistPath (xcode_settings , deploy)
  
  buildDirectory      = xcode_settings[:buildDirectory]
  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildNumber         = xcode_settings[:buildNumber]
  applicationName     = xcode_settings[:applicationName]
  ipaName             = ipaName(xcode_settings , deploy)
  remotePath          = deploy["uploadServer"]["path"]
  pjServerConf        = deploy["infosPlist"]["PJServerConf"]
  fileName            = fileNameForEnv pjServerConf
  
  plistName = "app_#{fileName}.plist"
  
  "#{remotePath}/#{plistName}"
  
end

def fileNameForEnv(pjServerConf)

  if pjServerConf == "inte1" then
    return "inte"
  elsif pjServerConf == "inte2" then
    return "2t"
  elsif pjServerConf == "inte3" then
    return "3t"
  elsif pjServerConf == "pp2" then
    return "preprod"
  elsif pjServerConf == "prod" then
    return "prod"
  elsif pjServerConf == "prod-new" then
    return "ubu"
  end

end

def dtmobXMLVersionForEnv(pjServerConf)
  
  if pjServerConf == "inte1" then
    return "1T"
    elsif pjServerConf == "inte2" then
    return "2T"
    elsif pjServerConf == "inte3" then
    return "3T"
    elsif pjServerConf == "pp2" then
    return "PP"
    elsif pjServerConf == "prod" then
    return "P"
    elsif pjServerConf == "prod-new" then
    return "UBU"
  end
  
end

def remoteDTMobFile
  
  "./dtmob.xml"
  
end

def localDTMobFile
  
  "/tmp/dtmob.xml"
 
end

