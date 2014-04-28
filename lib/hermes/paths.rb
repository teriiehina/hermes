require 'rubygems'
require 'bundler/setup'

#
# Application
#

def appPath (settings)
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  bundleName          = settings[:bundleName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{bundleName}.app"
  
end

#
# IPA
#

def ipaName (settings)

  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]
  
  pjServerConf        = settings[:deploy]["infosPlist"]["PJServerConf"]

  "#{applicationName}.#{buildNumber}.ipa"
  
end

def ipaPath (settings)
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]
  ipaName             = ipaName(settings)
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{ipaName}"
  
end

def remoteIpaPath (settings , destination)

  ipaName             = ipaName(settings)
  remotePath          = destination["path"]
  
  "#{remotePath}/#{ipaName}"
  
end


#
# Plist
#

def plistInAppPath (settings)
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  bundleName          = settings[:bundleName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{bundleName}.app/Info.plist"  
end

def deployPlistPath (settings)

  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]
  plistName           = plistName settings
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{plistName}"

end

def remoteDeployPlistPath (settings , destination)
  
  remotePath  = destination["path"]  
  plistName   = plistName (settings)
  
  "#{remotePath}/#{plistName}"
  
end

def plistName (settings)
  
  applicationName     = settings[:applicationName]
  pjServerConf        = settings[:deploy]["infosPlist"]["PJServerConf"]
  buildNumber         = settings[:buildNumber]
  
  "#{applicationName}.#{buildNumber}.plist"
  
end

def publicPlistURL (settings)
  
  publicURL  = settings[:deploy]["uploadServer"]["plist"][0]["publicURL"]  
  plistName   = plistName (settings)
  
  "#{publicURL}/#{plistName}"
  
end

#
# Dsym
#

def dsymPath (settings)
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  bundleName          = settings[:bundleName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{bundleName}.app.dSYM"
  
end

def savedDsymPath (settings)
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]
  
  "#{buildDirectory}/#{buildConfiguration}-iphoneos/#{applicationName}.#{buildNumber}.app.dSYM"
  
end

def zippedDsymPath (settings)
  
  savedDsymPath(settings) + ".zip"
  
end

def remoteDsymPath (settings , destination)
  
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]  
  
  remotePath  = destination["path"]  
  dsymName    = "#{applicationName}.#{buildNumber}.app.dSYM.zip"
  
  "#{remotePath}/#{dsymName}"
  
end

#
# Extra
#


def remoteDTMobFile
  
  "./dtmob.xml"
  
end

def localDTMobFile
  
  "/tmp/dtmob.xml"
 
end

