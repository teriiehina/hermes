require 'rubygems'
require 'bundler/setup'
require 'plist'

require_relative 'paths.rb'

# adapt this shell script in ruby
# http://www.merowing.info/2013/03/overlaying-application-version-on-top-of-your-icon/


def updateIcon (settings)

  iconsBasePath = "#{settings[:projectDirectory]}/PagesJaunes/Data/Images/SPLASH+ICONE"
  icons = [["icone_base.png" , "icone.png"] , ["icone_base@2x.png" , "icone@2x.png"]]
  
  should_update_icon = settings[:deploy]["icon"]["addExtraInfosInIcon"]
  
  # if !should_update_icon
  #   return
  # end
  
  basePath = appPath(settings)

  icons.each do |files|
    
    source_file = "#{iconsBasePath}/#{files[0]}"
    dest_file   = "#{basePath}/#{files[1]}"
    
    puts "Modification de #{source_file}"
    puts "vers #{dest_file}"

    addInfosToIcon settings , source_file , dest_file
    
  end

end

def addInfosToIcon (settings , source_file , dest_file)

  projectInfosPath  = settings[:projectInfosPath]
  projectInfos      = Plist::parse_xml(projectInfosPath)

  version       = projectInfos["CFBundleVersion"]
  commit        = `git rev-parse --short HEAD`.strip
  branch        = `git rev-parse --abbrev-ref HEAD`.strip
  pjServerConf  = fileNameForEnv settings[:deploy]["PJServerConf"]
    
  width    = `identify -format %w #{source_file}`
  
  caption = iconCaptionForDeploy settings[:deploy]

  command  = "convert -background '#0008'"
  command += " -fill white -gravity center"
  command += " -size #{width}x40"
  command += " caption:\"#{caption}\" \"#{source_file}\""
  command += " +swap -gravity south -composite \"#{dest_file}\""

  system(command)

end

def iconCaptionForDeploy(deploy)
  
  caption = ""
  
  if !deploy["icon"]["addBuildNumber"]
    caption += "#{version}"
  end
  
  if !deploy["icon"]["addCIMobEnv"]
    caption += "#{pjServerConf}"
  end
  
  if !deploy["icon"]["addCommitId"]
    caption += "#{commit}"
  end
    
  caption
end
