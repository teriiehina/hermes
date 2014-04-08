require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

require 'cfpropertylist'

require_relative 'settings.rb'
require_relative 'update_icon.rb'
require_relative 'build.rb'
require_relative 'plist.rb'
require_relative 'ipa.rb'
require_relative 'parse.rb'
require_relative 'paths.rb'
require_relative 'git.rb'
require_relative 'upload.rb'

def build_and_deploy (deployments , should_upload = true)

  #unlock_keychain

  deployments.each do |deploy|
    
    puts "Chargement des variables"
    settings = load_xcode_settings deploy

    puts "Création de l'.app"
    # buildApp        settings , deploy
    # updateBuild     settings , deploy
    
    puts "Création de l'.ipa et du .plist"
    buildArtefacts  settings , deploy

    if should_upload
      
      puts "Téléversement de l'.ipa et du .plist"
      uploadArtefacts   settings , deploy

      puts "Mise à jour de Parse"
      updateParse       settings , deploy

      puts "Création d'un tag git"
      tagGit            settings , deploy
    end
    
  end

end

def buildArtefacts (xcode_settings , deploy)
  #generateIpa   xcode_settings , deploy
  generatePlist xcode_settings , deploy
end

def unlock_keychain
  current_user = `whoami`

  keychainFilePath      = "/Users/jenkins/Library/Keychains/login.keychain"
  keychainPassword      = "j3nk1n5"
  
  puts("Dévérouillage du keychain en vue de la génération de l\'ipa")
  system("security unlock-keychain -p #{keychainPassword} #{keychainFilePath}")
end

def updateBuild (xcode_settings , deploy)
  
  # updateIcon    xcode_settings , deploy
  
  puts "TODO: Mise-à-jour du fichier PagesJaunes-Info.plist"
  
  projectInfosPath  = plistInAppPath(xcode_settings , deploy)
  # projectInfos      = Plist::parse_xml(projectInfosPath)
  
  plist         = CFPropertyList::List.new(file: projectInfosPath)
  projectInfos  = CFPropertyList.native_types(plist.value)
  
  projectInfos['CFBundleDisplayName'] = deploy["infosPlist"]["CFBundleDisplayName"]
  projectInfos['CFBundleIdentifier']  = deploy["infosPlist"]["CFBundleIdentifier"]
  projectInfos['PJServerConf']        = deploy["infosPlist"]["PJServerConf"]
  
  # Plist::Emit.save_plist(projectInfos , projectInfosPath)
  plist.value = CFPropertyList.guess(projectInfos)
  plist.save(projectInfosPath , CFPropertyList::List::FORMAT_BINARY)
  
  puts "DONE: Mise-à-jour du fichier PagesJaunes-Info.plist"
  
  if deploy["isVersioned"] == false
    return
  end
  
  infoPlistPath         = deploy["paths"]["projectAbsolutPath"] + "/" + deploy["paths"]["infosPlistRelativePath"]
  infoPlist             = Plist::parse_xml(infoPlistPath)
  appVersion            = infoPlist['CFBundleVersion']
  appName               = infoPlist['PJDistName']
  appFullName           = "#{appName}.#{appVersion}"
  
  smallVersion          = dtmobXMLVersionForEnv(deploy["infosPlist"]["PJServerConf"]).downcase
  versioned             = dtmobXMLVersionForEnv deploy["infosPlist"]["PJServerConf"]
  appFullNameVersioned  = "#{appFullName} - #{versioned}"
  
  path = deploy["uploadServer"]["path"]
  path = path.gsub(/([^\/]+)$/ , appFullName)
  
  publicURL = deploy["uploadServer"]["publicURL"]
  publicURL = publicURL.gsub(/([^\/]+)$/ , appFullName)
  
  deploy["uploadServer"]["path"]                = path
  deploy["uploadServer"]["publicURL"]           = publicURL
  deploy["uploadServer"]["applicationVersion"]  = appFullNameVersioned
  
  puts deploy["uploadServer"]["path"]
  puts deploy["uploadServer"]["publicURL"]
  puts deploy["uploadServer"]["applicationVersion"]
  
  deploy["infosPlist"]["CFBundleDisplayName"]   = "#{appVersion}.#{smallVersion.upcase}"
  
end


