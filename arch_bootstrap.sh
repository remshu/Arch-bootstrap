#!/bin/bash

# Download dialog for TUI creation
sudo pacman -S -noconfirm dialog >/dev/null

dialog --backtitle "Bootstrap script for fresh Arch install"\
		--title "Before installation"\
		--yesno "\n This script was made for fresh Arch installation ONLY.\n\nResult is not garanteed! :) \n\nChoose \"yes\" if you agree with that." 15 45

[ $? -eq 1 ] && echo "exiting..." &&  exit 1


# Load main package
dialog --infobox "Downloading main packages..."
sudo pacman -S --noconfirm xorg-server xorg-xinit pulseaudio alsa-utils feh git zsh pass msmtp isync man gimp texlive-core tllocalmgr picom neomutt mpv sxiv zathura newsboat calcurse gscreenshot >/dev/null

# prepare .local -> src
[ ! -d ~/.local ] && mkdir ~/.local || [ -d ~/.local ] && [ ! -d ~/.local/src ] && mkdir ~/.local/src
# Load yay
dialog --infobox "Setup yay..."
git clone https://aur.archlinux.org/yay-git.git ~/.local/src/yay-git >/dev/null
cd ~/.local/src/yay-git
makepkg -si >/dev/null

# Load yay packages
dialog --infobox "Download yay packages..."
yay -S --noconfirm mutt-wizard >/dev/null

# Font that work well with oh-my-zsh
yay -S --noconfirm ttf-meslo-nerd-font-powerlevel10k >/dev/null


# clone suckless
dialog --infobox "Clone suckless..."
git clone https://github.com/ArtemShchelkunov/suckless.git ~/.local/src/suckless >/dev/null
dialog --infobox "Build suckless..."
# build suckless
# dwm
cd ~/.local/src/suckless/dwm && sudo make && sudo make clean install >/dev/null
# dmenu
cd ~/.local/src/suckless/dmenu && sudo make && sudo make clean install >/dev/null
# mwmblocks
cd ~/.local/src/suckless/dwmblocks && sudo make && sudo make clean install >/dev/null
# st
cd ~/.local/src/suckless/st && sudo make && sudo make clean install >/dev/null

# prepare .config
[ ! -d ~/.config ] && mkdir ~/.config

# load dotfiles
dialog --infobox "Clone dotfiles..."
git clone https://github.com/ArtemShchelkunov/dotfiles ~/.config/dotfiles >/dev/null

# source szhenv to get access to path variables
source ~/.config/dotfiles/.zshenv

# Link dotfiles
# X11 (xinit, not startx)

dialog --infobox "Creating softlincs from dotfiles to configs dirs..."
[ ! -d "$XDG_CONFIG_HOME"/X11 ] && mkdir "$XDG_CONFIG_HOME"/X11
ln -s "$XDG_CONFIG_HOME"/dotfiles/.xinitrc "$XDG_CONFIG_HOME"/X11/xinitrc
ln -s "$XDG_CONFIG_HOME"/dotfiles/.xserverrc "$XDG_CONFIG_HOME"/X11/xserverrc

# ZSH
[ ! -d "$XDG_CONFIG_HOME"/zsh ] && mkdir "$XDG_CONFIG_HOME"/zsh
ln -s "$XDG_CONFIG_HOME"/dotfiles/.zshenv /etc/zsh/zshenv
ln -s "$XDG_CONFIG_HOME"/dotfiles/.zlogin "$XDG_CONFIG_HOME"/zsh/.zlogin

# xbindkeys
ln -s "$XDG_CONFIG_HOME"/dotfiles/.xbindkeys "$XDG_CONFIG_HOME"/xbindkeys/config

# vim
ln -s "$XDG_CONFIG_HOME"/dotfiles/.vimrc "$XDG_CONFIG_HOME"/vim/vimrc

# abook
[ ! -d "$XDG_CONFIG_HOME"/abook ] && mkdir "$XDG_CONFIG_HOME"/abook
[ ! -d "$XDG_DATA_HOME" ] && mkdir -p "$XDG_DATA_HOME"


# Setup Vundle

## Check if dirs created && create

dialog --infobox "Setting up Vundle..."
[ ! -d "$XDG_CONFIG_HOME"/vim ] && mkdir "$XDG_CONFIG_HOME"/vim
[ ! -d "$XDG_CONFIG_HOME"/vim/bundle ] && mkdir "$XDG_CONFIG_HOME"/vim/bundle

## Clone Vundle
git clone https://github.com/VundleVim/Vundle.vim.git "$XDG_CONFIG_HOME"/vim/bundle >/dev/null
sed -i 's&.vim/bundle&.config/vim/bundle&' "$XDG_CONFIG_HOME"/vim/Vundle.vim/autoload/vundle.vim


## Download vim plugins
dialog --infobox "Load vim pluggins..."
vim +PluginInstall +qall

# setup folder for gscreenshot
[ ! -d ~/screenshots ] && mkdir ~/screenshots

# make basic home folders
dialog --infobox "Create basic home folders..."
[ ! -d ~/docs ] && [ ! -d ~/Documents ] && mkdir ~/docs
[ ! -d ~/pics ] && [ ! -d ~/Pictures ] && mkdir ~/pics
[ ! -d ~/music ] && [ ! -d ~/Music ] && mkdir ~/music
[ ! -d ~/vids ] && [ ! -d ~/Videos ] && mkdir ~/vids

# Change shell to zsh
wget -O "$XDG_CONFIG_HOME"/wall.jpg
feh --bg-scale "$XDG_CONFIG_HOME"/wall.jpg
mv "$HOME"/.fehbg "$HOME"/.config/feh/fehbg
chsh -s /bin/zsh
