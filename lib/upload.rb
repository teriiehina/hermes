require 'rubygems'
require 'bundler/setup'
require 'net/scp'
require 'nokogiri'
require 'date'

require_relative 'paths.rb'

def uploadArtefacts (xcode_settings , deploy)

  host        = deploy["uploadServer"]["host"]
  login       = deploy["uploadServer"]["login"]
  path        = deploy["uploadServer"]["path"]
  buildNumber = xcode_settings[:buildNumber]

  ipaPath                 = ipaPath (xcode_settings , deploy)
  remoteIpaPath           = remoteIpaPath (xcode_settings , deploy)
  
  deployPlistPath         = deployPlistPath (xcode_settings , deploy)
  remoteDeployPlistPath   = remoteDeployPlistPath (xcode_settings , deploy)
    
  dsymPath                = zippedDsymPath(xcode_settings , deploy)
  remoteDsymPath          = remoteDsymPath(xcode_settings , deploy)
  
  dtmobApplicationName    = deploy["uploadServer"]["applicationTitle"]
  dtmobApplicationVersion = deploy["uploadServer"]["applicationVersion"]
  
  files_to_upload = Array.new
  files_to_upload.push([ipaPath         , remoteIpaPath])
  files_to_upload.push([deployPlistPath , remoteDeployPlistPath])
  files_to_upload.push([dsymPath        , remoteDsymPath])

  puts "#{host} : #{login} : #{path}"

  Net::SCP.start(host, login) do |scp|
    files_to_upload.each do |names|
      puts 'Envoi du fichier ' + names[0] + ' vers ' + names[1]
      scp.upload!(names[0].to_s, names[1])
    end
  end
  
  updateDTMobXML xcode_settings , deploy
  
end

def updateDTMobXML (xcode_settings , deploy)
  
  # après upload des artefacts, on peut mettre à jour le fichier dtmob.xml
  # et pourquoi pas dsem.xml
  
  host        = deploy["uploadServer"]["host"]
  login       = deploy["uploadServer"]["login"]
  path        = deploy["uploadServer"]["path"]
  buildNumber = xcode_settings[:buildNumber]
  
  dtmobApplicationName    = deploy["uploadServer"]["applicationTitle"]
  dtmobApplicationVersion = deploy["uploadServer"]["applicationVersion"]
  
  Net::SCP.start(host, login) do |scp|
    puts 'Mise-à-jour du fichier dtmob.xml'
    scp.download!(remoteDTMobFile, localDTMobFile)
    
    file  = File.read(localDTMobFile)
    dtmob = Nokogiri::XML(file)
    
    timeFormat        = "%Y-%m-%d %H-%M-%S"
    lastUpdate        = DateTime.now.strftime(timeFormat)
    applicationXPath  = "//application[title='#{dtmobApplicationName}']"
    versionXPath      = "version[numero='#{dtmobApplicationVersion}']"
    changeLogXPath    = "changelog"
    changeLogContent  = <<-EOXML
    <![CDATA[
    <ul>
    <li>Last update: #{lastUpdate}</li>
    <li>Build number: #{buildNumber}</li>
    </ul>]]>
    EOXML
    
    application       = dtmob.xpath(applicationXPath)
    version           = application.xpath(versionXPath)
    
    #    if version.nil?
    #      version = newVersionNode xcode_settings , deploy
    #
    #      version.
    #
    #      application.addNode version
    #    end
    
    changeLog            = version.xpath(changeLogXPath).first
    changeLog.inner_html = changeLogContent
    
    # save the output into a new file
    File.open(localDTMobFile, "w") do |f|
      f.write dtmob.to_xml
    end
    
    
    scp.upload(localDTMobFile , remoteDTMobFile)
  end
  
end
  
def newVersionNode (xcode_settings , deploy)
  #  <version>
  #  <numero>LATEST - 1T</numero>
  #  <changelog>    <![CDATA[
  #  <ul>
  #  <li>Last update: 2014-02-04 16-42-06</li>
  #  <li>Build number: 111</li>
  #  </ul>]]>
  #  </changelog>
  #  <url>http://dsem.pagesjaunes.fr/factory/ipad/latest/app_inte.plist</url>
  #  </version>
  
  return nil
end

