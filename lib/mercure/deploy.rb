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

# 
# Build
#

def buildDeployments (plist)
  
  deployments = Plist::parse_xml(plist)      
  
  deployments.each do |deploy|
    buildDeploy deploy
  end
  
end

def buildDeploymentsByAsking (plist)
  
  deployments = Plist::parse_xml(plist)
  
  deployments.each do |deploy|
    
    settings = load_settings deploy
    
    choose do |menu|
      
      versionText = " dans sa version #{settings[:CFBundleVersion]}" if not settings[:CFBundleVersion].nil?
      menu.prompt = "Veux-tu builder #{settings[:applicationName]}#{versionText} ?"

      menu.choice(:oui) do
        say("Bon choix !")
        buildDeploy deploy
      end
      
      menu.choice(:non) { say("Dommage") }
    end

  end  
end


def buildDeploy (deploy)
  
  puts "Chargement des variables"
  settings = load_settings deploy
  
  # on s'assure d'être dans la bonne version du code
  # si le Info.plist ne contient pas de valeur pour la clé
  # :CFBundleVersion (ce qui serait un peu embetant)
  # on taggue le commit courant
  checkOutGitVersion settings

  puts "Création de l'.app"
  buildApp settings
  updateBuild settings
  
  puts "Création de l'.ipa et du .plist"
  buildArtefacts settings
  
end


# 
# Upload
#

def uploadDeploymentsByAsking (plist)
  
  deployments = Plist::parse_xml(plist)
  
  deployments.each do |deploy|
    
    settings = load_settings deploy
    
    choose do |menu|
      
      versionText = " dans sa version #{settings[:CFBundleVersion]}" if not settings[:CFBundleVersion].nil?
      menu.prompt = "Veux-tu uploader #{settings[:applicationName]}#{versionText} ?"

      menu.choice(:oui) do
        say("Bon choix !")
        uploadDeployments deploy
      end
      
      menu.choice(:non) { say("Dommage") }
    end

  end  
end

def uploadDeployments (plist)
  
  deployments = Plist::parse_xml(plist)      
  
  deployments.each do |deploy|
    uploadDeploy deploy
  end
end


def uploadDeploy (deploy)
  puts "Chargement des variables"
  settings = load_settings deploy
  
  puts "Téléversement de l'.ipa et du .plist"
  uploadArtefacts settings
end

# 
# Deploy
#

def deployDeploymentsByAsking (plist_path)
  
  plist_content = CFPropertyList::List.new(file: plist_path)
  deployments   = CFPropertyList.native_types(plist_content.value)
  
  deployments.each do |deploy|
    
    choose do |menu|
      
      versionText = " dans sa version #{settings[:CFBundleVersion]}" if not settings[:CFBundleVersion].nil?
      menu.prompt = "Veux-tu déployer #{settings[:applicationName]}#{versionText} ?"

      menu.choice(:oui) do
        say("Bon choix !")
        deployDeploy deploy
      end
      
      menu.choice(:non) { say("Dommage") }
    end
    
  end
  
  puts "sauvegardes des infos de parse"
  plist_content.value = CFPropertyList.guess(deployments)
  plist_content.save(plist_path , CFPropertyList::List::FORMAT_XML)
  
end


def deployDeployments (plist_path)
  
  plist_content = CFPropertyList::List.new(file: plist_path)
  deployments   = CFPropertyList.native_types(plist_content.value)
  
  deployments.each do |deploy|
    deployDeploy deploy
  end
  
  puts "sauvegardes des infos de parse"
  plist_content.value = CFPropertyList.guess(deployments)
  plist_content.save(plist_path , CFPropertyList::List::FORMAT_XML)
  
end


# I know, I know
def deployDeploy (deploy)
  
  puts "Chargement des variables"
  settings = load_settings deploy
    
  puts "Mise à jour de Parse"
  objectId = updateParse settings
  deploy["parse"]["objectId"] = objectId
  
end

#
# pan
#

def panDeployments (plist)
  
  deployments = Plist::parse_xml(plist)      
  
  deployments.each do |deploy|
    
    puts "Chargement des variables"
    settings = load_settings deploy
    
    # on s'assure d'être dans la bonne version du code
    # si le Info.plist ne contient pas de valeur pour la clé
    # :CFBundleVersion (ce qui serait un peu embetant)
    # on taggue le commit courant
    checkOutGitVersion settings

    puts "Création de l'.app"
    buildApp settings
    updateBuild settings
    
    puts "Création de l'.ipa et du .plist"
    buildArtefacts settings
    
    puts "Téléversement de l'.ipa et du .plist"
    uploadArtefacts settings

    puts "Mise à jour de Parse"
    updateParse settings
  
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


