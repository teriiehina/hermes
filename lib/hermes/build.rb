require 'rubygems'
require 'bundler/setup'

require 'plist'

def buildApp (xcode_settings , deploy)
  
  projectInfosPath    = xcode_settings[:projectInfosPath]
  
  applicationName     = xcode_settings[:applicationName]
  projectDirectory    = xcode_settings[:projectDirectory]
  
  workspaceName       = xcode_settings[:workspaceName]
  schemeName          = xcode_settings[:schemeName]
  targetSDK           = xcode_settings[:targetSDK]
  
  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildDirectory      = xcode_settings[:buildDirectory]
  
  puts "TODO: Mise-à-jour du fichier PagesJaunes-Info.plist"
  
  projectInfos = Plist::parse_xml(projectInfosPath)
  
  projectInfos['CFBundleDisplayName'] = deploy["infosPlist"]["CFBundleDisplayName"]
  projectInfos['CFBundleIdentifier']  = deploy["infosPlist"]["CFBundleIdentifier"]
  projectInfos['PJServerConf']        = deploy["infosPlist"]["PJServerConf"]
  
  Plist::Emit.save_plist(projectInfos , projectInfosPath)
  
  puts "DONE: Mise-à-jour du fichier PagesJaunes-Info.plist"
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

