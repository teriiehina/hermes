require "hermes/version"
require 'thor'
require 'plist'

require 'hermes/deploy'

module Hermes

  class Hermes < Thor

    desc "check", "will check if everything necessary for building easily is present"
    def check
      puts "checking. Missing tools will be installed, if possible."
      
    end

    desc "build JOB", "will build the job"
    def build(plist)
      deployments   = Plist::parse_xml(plist)      
      buildDeployments deployments
    end
    
    desc "upload JOB", "will upload the job (must have been 'build' before)"
    def upload(plist)
      deployments   = Plist::parse_xml(plist)
      uploadDeployments deployments
    end
    
    desc "deploy JOB", "will deploy the job (must have been 'build' and 'upload' before)"
    def deploy(plist)      
      deployments   = Plist::parse_xml(plist)
      deployDeployments deployments
    end
    
    desc "pan JOB", "will build, upload and deploy the job"
    def pan(plist)
      deployments   = Plist::parse_xml(plist)
      panDeployments deployments
    end
    
  end
  
end


 