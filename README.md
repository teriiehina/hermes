hermes
======

Simple tool to build and deploy iOS apps

# Not usable

Be very careful. `hermes` is not intended to be used yet. Neither in production nor development.
This repo is for collaboration for a tool in its very first iteration.

Wet paint, you've been warned.

# What hermes should do

In french for now, translation coming soon.

hermes est une gem ruby

hermes ne prend en paramètre qu'un fichier plist

hermes se lance dans un repo git clean et le laisse clean à la fin

hermes est toujours lancé depuis le répertoire qui contient le xcworkspace ou le xccodeproj

hermes part du principe que

  - dans le cas d'une livraison versionnée, c'est une nouvelle version
  - l'on peut se connecter en ssh password-less sur le serveur d'upload
  - qu'on peut accéder au repo 'origin' pour envoyer les tags en fin de livraison

hermes pourra soumettre à Apple

A la fin de la livraison, hermes taggue le job en fonction du nom et de la version 

voir comment unlocker le keychain (regarder du côté de visudo)

Le plist indique

  - les paths (qui sont toujours relatif au dossier depuis lequel on lance hermes):
    - le path vers le Info.plist
            
  - la compilation
    - le nom du projet ou du workspace
    - le scheme ou la target à builder
    - le targetSDK
    - la configuration de build (Debug , Release)
    - l'identité et le profil de signature
    
  - un dictionnaire dont les "clés/valeurs" sont copiées automatiquement dans le Info.plist
    
  - tous les paramètre de build
    - bundle id
    - environnement du cimob
    
  - le chemin des icones à modifier
    
  - si la livraison est versionnée ou pas
  
  - si on modifie l'icone ou pas
  
  - pour l'upload des ressources (ipa, plist et dsym) générées:
    - l'ip ou l'url du serveur
    - le login ssh
    - le path local sur le serveur
    - l'url publique
    
  - si on tagge le job
  
  
Expliciter les valeurs par défaut
Mieux définir les noms des fichiers générés