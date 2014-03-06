require "hermes/version"
require 'thor'

module Hermes

  class Hermes < Thor

    desc "check", "will check if everything necessary for building easily is present"
    def check
      puts "checking. Missing tools will be installed, if possible."
      system("PagesJaunes/PagesJaunes/jenkins/install.sh")
    end

    desc "build JOB", "will build the job"
    def build(job, cimob_env = nil)
      puts "building #{job}"

      current_path = File.expand_path(File.dirname(__FILE__))
    
      builds = ["ranorex" , "latest" , "debug" , "livraison"]

      if ! builds.include? job
        puts "job inconnu"
        return
      end
    
      command = "WORKSPACE='#{current_path}' BUILD_NUMBER=111 ruby PagesJaunes/PagesJaunes/jenkins/#{job}/#{job}.rb"
    
    
    
      system command

    end
  end
  
end


 