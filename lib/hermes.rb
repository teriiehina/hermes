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
      
      deployments = Plist::parse_xml(plist)

      deploy deployments
    end
    
  end
  
end


 