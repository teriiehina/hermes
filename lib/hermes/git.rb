require 'rubygems'
require 'bundler/setup'

def tagGit (settings)

  return
  
  tag_name    = "jenkins_" + settings[:buildNumber]
  create_tag  = "git tag #{tag_name}"
  push_tag    = "git push --tags"

  system(create_tag)
  system(push_tag)

end