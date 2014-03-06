require 'rubygems'
require 'bundler/setup'

def tagGit (xcode_settings , deploy)

  tag_name    = "jenkins_" + xcode_settings[:buildNumber]
  create_tag  = "git tag #{tag_name}"
  push_tag    = "git push --tags"

  system(create_tag)
  system(push_tag)

end