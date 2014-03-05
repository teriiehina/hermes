require 'rubygems'
require 'bundler/setup'

require 'plist'

def buildApp (xcode_settings , deploy)

  userConfigPath      = xcode_settings[:userConfigPath]
  projectInfosPath    = xcode_settings[:projectInfosPath]

  applicationName     = xcode_settings[:applicationName]
  projectDirectory    = xcode_settings[:projectDirectory]
  
  workspaceName       = xcode_settings[:workspaceName]
  schemeName          = xcode_settings[:schemeName]
  targetSDK           = xcode_settings[:targetSDK]

  buildConfiguration  = xcode_settings[:buildConfiguration]
  buildDirectory      = xcode_settings[:buildDirectory]
  
  extra_commands      = xcode_settings[:extra_commands]

  puts "TODO: Mise-à-jour du fichier PagesJaunes-Info.plist"
  projectInfos = Plist::parse_xml(projectInfosPath)
  projectInfos['CFBundleDisplayName'] = deploy["displayName"]
  projectInfos['CFBundleIdentifier']  = deploy["bundleID"]
  projectInfos['PJServerConf']        = deploy["PJServerConf"]
  Plist::Emit.save_plist(projectInfos , projectInfosPath)
  puts "DONE: Mise-à-jour du fichier PagesJaunes-Info.plist"
  
  puts "Compilation de l'application #{applicationName}"
  
  xctool_command  = "xctool"
  xctool_command += " -workspace     \"#{workspaceName}\""
  xctool_command += " -scheme        \"#{schemeName}\""
  xctool_command += " -sdk           \"#{targetSDK}\""
  xctool_command += " -reporter        pretty"
  xctool_command += " -reporter        json-compilation-database:\"#{buildDirectory}/compile_commands.json\""
  xctool_command += " -configuration   #{buildConfiguration}"
  xctool_command += " BUILD_DIR=\"#{buildDirectory}\""
  xctool_command += " APPLICATION_SERVER=\"#{deploy[:server]}\""
  xctool_command += extra_commands
  
  puts xctool_command
  
  Dir.chdir "#{projectDirectory}"
  system("#{xctool_command} clean build")
  
end

