require "mercure/version"
require 'thor'
require 'plist'

require 'mercure/deploy'

module Mercure

  class Mercure < Thor

    desc "check", "will check if everything necessary for building easily is present"
    def check
      puts "checking. Missing tools will be installed, if possible."
      
    end

    desc "build JOB", "will build the job"
    def build(plist)
      buildDeployments plist
    end
    
    desc "upload JOB", "will upload the job (must have been 'build' before)"
    def upload(plist)
      uploadDeployments plist
    end
    
    desc "deploy JOB", "will deploy the job (must have been 'build' and 'upload' before)"
    def deploy(plist)      
      deployDeployments plist
    end
    
    desc "pan JOB", "will build, upload and deploy the job"
    def pan(plist)
      panDeployments plist
    end
    
  end
  
end


 