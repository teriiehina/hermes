require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

require_relative 'paths.rb'

def generateIpa settings
  
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]
  
  appPath       = appPath(settings)
  ipaPath       = ipaPath(settings)
  
  dsymPath        = dsymPath(settings)
  savedDsymPath   = savedDsymPath(settings)
  zippedDsymPath  = zippedDsymPath(settings)
  
  signingIdentity     = settings[:signingIdentity]
  provisioningProfile = settings[:provisioningProfile]
  
  puts "Construction de l'IPA"
  
  signingCommand =  "/usr/bin/xcrun -sdk iphoneos PackageApplication"
  signingCommand +=  " -v \"#{appPath}\""
  signingCommand +=  " -o \"#{ipaPath}\""
  signingCommand +=  " --sign \"#{signingIdentity}\""
  signingCommand +=  " --embed \"#{provisioningProfile}\""
  signingCommand +=  " | tee \"#{settings[:buildDirectory]}/PackageApplication.log\""
  
  
  puts   signingCommand
  system signingCommand
  
  system("rm -f \"#{savedDsymPath}\"")
  system("cp -R \"#{dsymPath}\" \"#{savedDsymPath}\"")
  system("zip -r \"#{zippedDsymPath}\" \"#{savedDsymPath}\"")
  
end
