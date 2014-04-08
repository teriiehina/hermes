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
      
      puts "building using the file #{plist}"
      
      should_upload = false
      deployments   = Plist::parse_xml(plist)

      build_and_deploy deployments , should_upload
    end
    
    desc "deploy JOB", "will build the job, and then deploy it"
    def deploy(plist)
      
      puts "building and deployingll using the file #{plist}"
      
      should_upload = true
      deployments   = Plist::parse_xml(plist)

      build_and_deploy deployments , should_upload
    end
    
  end
  
end


 