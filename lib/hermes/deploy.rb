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


def buildDeployments (deployments)
  
  deployments.each do |deploy|
    
    puts "Chargement des variables"
    settings = load_settings deploy

    puts "Création de l'.app"
    buildApp settings
    updateBuild settings
    
    puts "Création de l'.ipa et du .plist"
    buildArtefacts settings
    
  end
  
end

def uploadDeployments (deployments)
  
  deployments.each do |deploy|
    puts "Chargement des variables"
    settings = load_settings deploy
    
    puts "Téléversement de l'.ipa et du .plist"
    uploadArtefacts settings
  end
  
end

def deployDeployments (deployments)
  
  deployments.each do |deploy|
    puts "Chargement des variables"
    settings = load_settings deploy
    
    puts "Mise à jour de Parse"
    updateParse settings
    
    puts "Création d'un tag git"
    tagGit settings
    
  end
  
end

def panDeployments (deployments)
  
  deployments.each do |deploy|
    puts "Chargement des variables"
    settings = load_settings deploy
    
    puts "Chargement des variables"
    settings = load_settings deploy

    puts "Création de l'.app"
    buildApp settings
    updateBuild settings
    
    puts "Création de l'.ipa et du .plist"
    buildArtefacts settings

    if should_upload
      
      puts "Téléversement de l'.ipa et du .plist"
      uploadArtefacts settings

      puts "Mise à jour de Parse"
      updateParse settings

      puts "Création d'un tag git"
      tagGit settings
      
    end
    
  end
  
end



def buildArtefacts (xcode_settings)
  generateIpa   xcode_settings
  generatePlist xcode_settings
end

# def unlock_keychain
#   current_user = `whoami`
# 
#   keychainFilePath      = "/Users/jenkins/Library/Keychains/login.keychain"
#   keychainPassword      = "j3nk1n5"
#   
#   puts("Dévérouillage du keychain en vue de la génération de l\'ipa")
#   system("security unlock-keychain -p #{keychainPassword} #{keychainFilePath}")
# end


