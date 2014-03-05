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

  current_user = `whoami`

  keychainFilePath      = "/Users/jenkins/Library/Keychains/login.keychain"
  keychainPassword      = "j3nk1n5"
  
  puts("Dévérouillage du keychain en vue de la génération de l\'ipa")
  system("security unlock-keychain -p #{keychainPassword} #{keychainFilePath}")

  deployments.each do |deploy|
  
    puts "Chargement des variables"
    xcode_settings = load_xcode_settings deploy , extra_commands
    
    updateIcon          xcode_settings , deploy
    buildApp            xcode_settings , deploy
    generateIpa         xcode_settings , deploy
    generateDeployPlist xcode_settings , deploy
    uploadArtefacts     xcode_settings , deploy
    #updateParse         xcode_settings , deploy # to do
    #tagGit              xcode_settings , deploy
    
    # to do : soumettre à Apple
    # xcrun -sdk iphoneos Validation /path/to/MyApp.app or /path/to/MyApp.ipa
  end
  
  #system("git co -- .")

end


