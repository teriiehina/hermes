require 'rubygems'
require 'bundler/setup'

require 'plist'

def buildApp (xcode_settings , deploy)
  
  applicationName     = xcode_settings[:applicationName]
  projectDirectory    = xcode_settings[:projectDirectory]
  
  workspaceName       = xcode_settings[:workspaceName]
  schemeName          = xcode_settings[:schemeName]
  targetSDK           = xcode_settings[:targetSDK]
  
  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildDirectory      = xcode_settings[:buildDirectory]
  
  puts "Compilation de l'application #{applicationName}"
  
  build_command  = "xcodebuild"
  build_command += " -workspace \"#{workspaceName}\""
  build_command += " -scheme \"#{schemeName}\""
  # build_command += " -sdk \"#{targetSDK}\""
  # build_command += " -reporter pretty"
  # build_command += " -reporter json-compilation-database:\"#{buildDirectory}/compile_commands.json\""
  build_command += " -configuration #{buildConfiguration}"
  build_command += " BUILD_DIR=\"#{buildDirectory}\""
  build_command += " clean build"
  build_command += " | tee \"#{buildDirectory}/xcodebuild.log\""
  build_command += " | xcpretty -c --report html"
  
  puts build_command
  
  Dir.chdir "#{projectDirectory}"
  system("#{build_command}")
  
end

