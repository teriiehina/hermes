require 'rubygems'
require 'bundler/setup'
require 'plist'

require_relative 'paths.rb'

# adapt this shell script in ruby
# http://www.merowing.info/2013/03/overlaying-application-version-on-top-of-your-icon/


def updateIcon (xcode_settings , deploy)

  icons = [["icone_base.png" , "icone.png"] , ["icone_base@2x.png" , "icone@2x.png"]]

  icons.each do |files|
    
    source_file = "#{xcode_settings[:projectDirectory]}/#{files[0]}"
    dest_file   = "#{xcode_settings[:projectDirectory]}/#{files[1]}"

    addInfosToIcon xcode_settings , deploy , source_file , dest_file
    
  end

end

def addInfosToIcon (xcode_settings , deploy , source_file , dest_file)

  projectInfosPath  = xcode_settings[:projectInfosPath]
  projectInfos      = Plist::parse_xml(projectInfosPath)

  version       = projectInfos["CFBundleVersion"]
  commit        = `git rev-parse --short HEAD`.strip
  branch        = `git rev-parse --abbrev-ref HEAD`.strip
  pjServerConf  = fileNameForEnv deploy["PJServerConf"]
    
  width    = `identify -format %w #{source_file}`

  command  = "convert -background '#0008'"
  command += " -fill white -gravity center"
  command += " -size #{width}x40"
  command += " caption:\"#{version} #{pjServerConf} #{commit}\" \"#{source_file}\""
  command += " +swap -gravity south -composite \"#{dest_file}\""

  system(command)

end
