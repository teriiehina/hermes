require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

require_relative 'settings.rb'
require_relative 'update_icon.rb'
require_relative 'build.rb'
require_relative 'plist.rb'
require_relative 'ipa.rb'
require_relative 'parse.rb'
require_relative 'git.rb'
require_relative 'upload.rb'

def deploy (deployments)

  #unlock_keychain

  deployments.each do |deploy|
    
    extra_commands = deploy["build"]["clangExtraCommands"]
  
    puts "Chargement des variables"
    xcode_settings = load_xcode_settings deploy , extra_commands
    
    add_version_if_needed xcode_settings , deploy
    updateIcon            xcode_settings , deploy

    buildApp              xcode_settings , deploy

    generateIpa           xcode_settings , deploy
    generateDeployPlist   xcode_settings , deploy

    # uploadArtefacts       xcode_settings , deploy
    
    #updateParse         xcode_settings , deploy # to do
    #tagGit              xcode_settings , deploy
    
    # to do : soumettre à Apple
    # xcrun -sdk iphoneos Validation /path/to/MyApp.app or /path/to/MyApp.ipa
  end
  
  #system("git co -- .")

end

def unlock_keychain
  current_user = `whoami`

  keychainFilePath      = "/Users/jenkins/Library/Keychains/login.keychain"
  keychainPassword      = "j3nk1n5"
  
  puts("Dévérouillage du keychain en vue de la génération de l\'ipa")
  system("security unlock-keychain -p #{keychainPassword} #{keychainFilePath}")
end

def add_version_if_needed (xcode_settings , deploy)
  
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


