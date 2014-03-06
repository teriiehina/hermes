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

def deploy (deployments , extra_commands)

  unlock_keychain
  

  deployments.each do |deploy|
    
    extra_commands = deploy["clangExtraCommands"]
  
    puts "Chargement des variables"
    xcode_settings = load_xcode_settings deploy , extra_commands
    
    add_version_if_needed xcode_settings , deploy
    updateIcon            xcode_settings , deploy

    buildApp              xcode_settings , deploy

    generateIpa           xcode_settings , deploy
    generateDeployPlist   xcode_settings , deploy

    uploadArtefacts       xcode_settings , deploy
    
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
    
  infoPlistPath     = "#{ENV['WORKSPACE']}/PagesJaunes/PagesJaunes/PagesJaunes-Info.plist"
  infoPlist         = Plist::parse_xml(infoPlistPath)
  appVersion        = infoPlist['CFBundleVersion']
  appName           = infoPlist['PJDistName']
  appFullName       = "#{appName}.#{appVersion}"

  puts appFullName

  # chargement des doonées

  plist_name        = "/" + File.basename(__FILE__).sub(".rb" , ".plist")
  plist_path        = File.expand_path(File.dirname(__FILE__)) + plist_name
  deployments       = Plist::parse_xml(plist_path)
  extra_commands    = ""
  
  smallVersion          = dtmobXMLVersionForEnv(deploy["PJServerConf"]).downcase
  versioned             = dtmobXMLVersionForEnv deploy["PJServerConf"]
  appFullNameVersioned  = "#{appFullName} - #{versioned}"
  
  path = deploy["uploadServer"]["path"]
  path = path.gsub(/([^\/]+)$/ , appFullName)
  
  publicURL = deploy["uploadServer"]["publicURL"]
  publicURL = publicURL.gsub(/([^\/]+)$/ , appFullName)

  deploy["uploadServer"]["path"]                = path
  deploy["uploadServer"]["publicURL"]           = publicURL
  deploy["uploadServer"]["applicationVersion"]  = appFullNameVersioned
  
  #  deploy["bundleID"]    = "com.pagesjaunes.dsem.beta.#{appName.downcase}.#{smallVersion}"
  deploy["bundleID"]    = "com.pagesjaunes.ad4screen"
  deploy["displayName"] = "#{appVersion}.#{smallVersion.upcase}"
  
end


