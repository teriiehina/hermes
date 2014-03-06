require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

require_relative 'paths.rb'

def generateIpa (xcode_settings , deploy)
    
  buildDirectory      = xcode_settings[:buildDirectory]
  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildNumber         = xcode_settings[:buildNumber]
  applicationName     = xcode_settings[:applicationName]
  
  appPath       = appPath(xcode_settings , deploy)
  ipaPath       = ipaPath(xcode_settings , deploy)
  
  dsymPath        = dsymPath(xcode_settings , deploy)
  savedDsymPath   = savedDsymPath(xcode_settings , deploy)
  zippedDsymPath  = zippedDsymPath(xcode_settings , deploy)

  signingIdentity     = xcode_settings[:signingIdentity]
  provisioningProfile = xcode_settings[:provisioningProfile]
  
  puts "Construction de l'IPA"
  
  signingCommand =  "/usr/bin/xcrun -sdk iphoneos PackageApplication \
                                    -v \"#{appPath}\" \
                                    -o \"#{ipaPath}\" \
                                    --sign \"#{signingIdentity}\" \
                                    --embed \"#{provisioningProfile}\""
                                    
  puts   signingCommand
  system signingCommand
  
  system("rm -f \"#{savedDsymPath}\"")
  system("cp -R \"#{dsymPath}\" \"#{savedDsymPath}\"")
  system("zip -r \"#{zippedDsymPath}\" \"#{savedDsymPath}\"")
  
end
