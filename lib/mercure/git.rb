require 'rubygems'
require 'bundler/setup'

require 'highline/import'

def checkOutGitVersion (settings)
  
  tags            = `git tag`
  tag_name        = settings[:CFBundleVersion]
  current_commit  = settings[:gitSHA1]
  
  # choose do |menu|
  #   menu.prompt = "Would you like to create a tag for this build ?  "
  #
  #   menu.choice(:yes) { say("Good choice!") }
  #   menu.choice(:no) { say("Too bad") }
  # end
  
  if tags.include?("#{tag_name}\n") == false
    puts "Le tag #{tag_name} n'existe pas."
    puts "Nous allons le créer pour pointer vers le commit actuel (#{current_commit})"

    create_tag = `git tag #{tag_name}`
  end
  
  puts "On checkout le tag #{tag_name}"
  co_tag = `git checkout #{tag_name}`
end

def tagGit (settings)
  
  tag_name       = settings[:CFBundleVersion]
  current_commit = settings[:gitSHA1]
  
  # si le tag existe déjà on l'efface
  tags = `git tag`
  
  if tags.include?("#{tag_name}\n")
    puts "Le tag #{tag_name} existe déjà."
    puts "Nous allons le faire pointer vers le commit actuel (#{current_commit})"

    delete_tag = `git tag -d #{tag_name}`
  end
  
  create_tag = `git tag #{tag_name}`

end