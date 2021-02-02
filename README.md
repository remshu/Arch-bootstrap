# Arch-bootstrap

This script was made for basic programs deployment and initial system configuration.

It'll load some applications (they'll be listed below), load my dotfiles, patched suckless programs, setup GUI and make some changes suggested by [XDG base directory specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html), when patch some other programs to better suite this suggestions.

Programs to be installed:

1. pacman 
  - Provide apportunity to deploy GUI
    * xorg-server  
    * xorg-init 
  
  - Sound control
    * pulseaudio    
    * alsa-utils    
  
  - Mail dependencies  
    * pass    
    * neomutt 
    * msmtp   
    * isync
  
  - Media
    * chromium
    * zathura
    * sxiv
    * newsboat
    * calcurse
    * texlive-core
    * gimp
  
  - Misc
    * wget
    * xbindkeys
    * feh
    * zsh
    * picom

2. yay
  * mutt-wizard
  * ttf-meslo-mnerd-font-powerlevel10k
  * zsh-theme-powerlevel10k
  
__NB!__ : Some configs are made __specifically__ for my __ThinkPad X220__ lapton:
for example, some bindings that placed in ~/.config/xbindkeys/config are made specially for this model.

You can easily change it, identifying your own combinations by xbindkeys --multikey or xbindkeys --key commands.
