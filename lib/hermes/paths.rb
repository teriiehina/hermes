require 'rubygems'
require 'bundler/setup'

def appPath (settings , deploy)
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  bundleName          = settings[:bundleName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{bundleName}.app"
  
end

def plistInAppPath (settings , deploy)
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  bundleName          = settings[:bundleName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{bundleName}.app/Info.plist"  
end

def ipaName(settings , deploy)

  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]
  
  pjServerConf        = deploy["infosPlist"]["PJServerConf"]
  cimob               = fileNameForEnv pjServerConf

  "#{applicationName}.#{cimob}.#{buildNumber}.ipa"
  
end

def ipaPath (settings , deploy)
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]
  ipaName             = ipaName(settings , deploy)
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{ipaName}"
  
end


def remoteIpaPath (settings , deploy , destination)

  ipaName             = ipaName(settings , deploy)
  remotePath          = destination["path"]
  
  "#{remotePath}/#{ipaName}"
  
end


def dsymPath (settings , deploy)
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  bundleName          = settings[:bundleName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{bundleName}.app.dSYM"
  
end

def savedDsymPath (settings , deploy)
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{applicationName}.#{buildNumber}.app.dSYM"
  
end

def zippedDsymPath (settings , deploy)
  
  savedDsymPath(settings , deploy) + ".zip"
  
end

def remoteDsymPath (settings , deploy , destination)
  
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]  
  
  remotePath  = destination["path"]  
  dsymName    = "#{applicationName}.#{buildNumber}.app.dSYM.zip"
  
  "#{remotePath}/#{dsymName}"
  
end

def deployPlistPath (settings , deploy)

  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{applicationName}.#{buildNumber}.plist"

end

def remoteDeployPlistPath (settings , deploy , destination)
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]
  ipaName             = ipaName(settings , deploy)
  remotePath          = destination["path"]
  pjServerConf        = deploy["infosPlist"]["PJServerConf"]
  fileName            = fileNameForEnv pjServerConf
  
  plistName = "app_#{fileName}.plist"
  
  "./test/#{plistName}"
  
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

