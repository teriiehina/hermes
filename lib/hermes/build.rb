require 'rubygems'
require 'bundler/setup'

require 'plist'

def buildApp (settings)
  
  puts "Build désactivée pour l'instant"
  return
  
  applicationName     = settings[:applicationName]
  projectDirectory    = settings[:projectDirectory]
  
  workspaceName       = settings[:workspaceName]
  schemeName          = settings[:schemeName]
  targetSDK           = settings[:targetSDK]
  
  buildConfiguration  = settings[:buildConfiguration]
  buildDirectory      = settings[:buildDirectory]
  
  puts "Compilation de l'application #{applicationName}"
  
  build_command  = "xcodebuild"
  build_command += " -workspace \"#{workspaceName}\""
  build_command += " -scheme \"#{schemeName}\""
  build_command += " -configuration #{buildConfiguration}"
  build_command += " BUILD_DIR=\"#{buildDirectory}\""
  build_command += " clean build"
  build_command += " | tee \"#{buildDirectory}/xcodebuild.log\""
  build_command += " | xcpretty -c --report html"
  
  puts build_command
  
  Dir.chdir "#{projectDirectory}"
  system("#{build_command}")
  
end

def updateBuild (settings)
  
  # updateIcon settings , settings[:deploy]
  
  puts "Mise-à-jour du fichier PagesJaunes-Info.plist"
  
  projectInfosPath  = plistInAppPath(settings , settings[:deploy])
  # projectInfos      = Plist::parse_xml(projectInfosPath)
  
  plist         = CFPropertyList::List.new(file: projectInfosPath)
  projectInfos  = CFPropertyList.native_types(plist.value)
  
  projectInfos['CFBundleDisplayName'] = settings[:deploy]["infosPlist"]["CFBundleDisplayName"]
  projectInfos['CFBundleIdentifier']  = settings[:deploy]["infosPlist"]["CFBundleIdentifier"]
  projectInfos['PJServerConf']        = settings[:deploy]["infosPlist"]["PJServerConf"]
  
  # Plist::Emit.save_plist(projectInfos , projectInfosPath)
  plist.value = CFPropertyList.guess(projectInfos)
  plist.save(projectInfosPath , CFPropertyList::List::FORMAT_BINARY)
  
end

