#!/bin/bash

# Download dialog for TUI creation
sudo pacman -S -noconfirm dialog >/dev/null 2>&1

dialog --backtitle "Bootstrap script for fresh Arch install"\
		--title "Before installation"\
		--yesno "\n This script was made for fresh Arch installation ONLY.\n\nResult is not garanteed! :) \n\nChoose \"yes\" if you agree with that." 15 45

[ $? -eq 1 ] && echo "exiting..." &&  exit 1


# Load main package
dialog --infobox "Downloading main packages..." 5 35
sudo pacman -S --noconfirm xorg-server xorg-xinit pulseaudio alsa-utils feh git zsh pass msmtp isync man gimp texlive-core tllocalmgr picom neomutt mpv sxiv zathura newsboat calcurse gscreenshot >/dev/null 2>&1

# prepare .local -> src
[ ! -d ~/.local ] && mkdir ~/.local || [ -d ~/.local ] && [ ! -d ~/.local/src ] && mkdir ~/.local/src
# Load yay
dialog --infobox "Setup yay..." 5 35
git clone https://aur.archlinux.org/yay-git.git ~/.local/src/yay-git
cd ~/.local/src/yay-git
makepkg -si

# Load yay packages
dialog --infobox "Download yay packages..." 5 35

## Luke's mail autoconfig
yay -S --noconfirm mutt-wizard >/dev/null 2>&1

## Font that work well with oh-my-zsh
yay -S --noconfirm ttf-meslo-nerd-font-powerlevel10k >/dev/null 2>&1

## p10k theme
yay -S --noconfirm zsh-theme-powerlevel10k-git >/dev/null 2>&1

# clone suckless
dialog --infobox "Clone suckless..." 5 35
git clone https://github.com/ArtemShchelkunov/suckless.git ~/.local/src/suckless >/dev/null 2>&1
dialog --infobox "Build suckless..." 5 35
# build suckless
# dwm
cd ~/.local/src/suckless/dwm && sudo make && sudo make clean install >/dev/null 2>&1
# dmenu
cd ~/.local/src/suckless/dmenu && sudo make && sudo make clean install >/dev/null 2>&1
# mwmblocks
cd ~/.local/src/suckless/dwmblocks && sudo make && sudo make clean install >/dev/null 2>&1
# st
cd ~/.local/src/suckless/st && sudo make && sudo make clean install >/dev/null 2>&1

# prepare .config
[ ! -d ~/.config ] && mkdir ~/.config

# load dotfiles
dialog --infobox "Clone dotfiles..." 5 35
git clone https://github.com/ArtemShchelkunov/dotfiles ~/.config/dotfiles >/dev/null 2>&1

# source szhenv to get access to path variables
source ~/.config/dotfiles/.zshenv
# Link dotfiles


dialog --infobox "Creating softlincs from dotfiles to configs dirs..." 5 35

## X11 (xinit, not startx)
[ ! -d "$XDG_CONFIG_HOME"/X11 ] && mkdir "$XDG_CONFIG_HOME"/X11
ln -s "$XDG_CONFIG_HOME"/dotfiles/.xinitrc "$XDG_CONFIG_HOME"/X11/xinitrc
ln -s "$XDG_CONFIG_HOME"/dotfiles/.xserverrc "$XDG_CONFIG_HOME"/X11/xserverrc

## ZSH
[ ! -d "$XDG_CONFIG_HOME"/zsh ] && mkdir "$XDG_CONFIG_HOME"/zsh
sudo ln -s "$XDG_CONFIG_HOME"/dotfiles/.zshenv /etc/zsh/zshenv
ln -s "$XDG_CONFIG_HOME"/dotfiles/.zlogin "$XDG_CONFIG_HOME"/zsh/
ln -s "$XDG_CONFIG_HOME"/dotfiles/.p10k.zsh "$XDG_CONFIG_HOME"/zsh/
ln -s "$XDG_CONFIG_HOME"/dotfiles/.zshrc "$XDG_CONFIG_HOME"/zsh/

## xbindkeys
[ ! -d "$XDG_CONFIG_HOME"/xbindkeys ] && mkdir "$XDG_CONFIG_HOME"/xbindkeys
ln -s "$XDG_CONFIG_HOME"/dotfiles/.xbindkeys "$XDG_CONFIG_HOME"/xbindkeys/config

## vim

[ ! -d "$XDG_CONFIG_HOME"/vim ] && mkdir "$XDG_CONFIG_HOME"/vim
ln -s "$XDG_CONFIG_HOME"/dotfiles/.vimrc "$XDG_CONFIG_HOME"/vim/vimrc

## abook
[ ! -d "$XDG_CONFIG_HOME"/abook ] && mkdir "$XDG_CONFIG_HOME"/abook
[ ! -d "$XDG_DATA_HOME" ] && mkdir -p "$XDG_DATA_HOME"


# Setup Vundle

## Check if dirs created && create

dialog --infobox "Setting up Vundle..." 5 35
[ ! -d "$XDG_CONFIG_HOME"/vim ] && mkdir "$XDG_CONFIG_HOME"/vim
[ ! -d "$XDG_CONFIG_HOME"/vim/bundle ] && mkdir "$XDG_CONFIG_HOME"/vim/bundle

## Clone Vundle
git clone https://github.com/VundleVim/Vundle.vim.git "$XDG_CONFIG_HOME"/vim/bundle/Vundle.vim >/dev/null 2>&1
sed -i 's&.vim/bundle&.config/vim/bundle&' "$XDG_CONFIG_HOME"/vim/Vundle.vim/autoload/vundle.vim


## Download vim plugins
dialog --infobox "Load vim pluggins..." 5 35
vim +PluginInstall +qall

# setup folder for gscreenshot
[ ! -d ~/screenshots ] && mkdir ~/screenshots

# make basic home folders
dialog --infobox "Create basic home folders..." 5 35
[ ! -d ~/docs ] && [ ! -d ~/Documents ] && mkdir ~/docs
[ ! -d ~/pics ] && [ ! -d ~/Pictures ] && mkdir ~/pics
[ ! -d ~/music ] && [ ! -d ~/Music ] && mkdir ~/music
[ ! -d ~/vids ] && [ ! -d ~/Videos ] && mkdir ~/vids

# set wallpapers
wget -O "$XDG_CONFIG_HOME"/wall.jpg https://images.wallpaperscraft.com/image/temple_mountains_lake_127937_1920x1080.jpg
feh --bg-scale "$XDG_CONFIG_HOME"/wall.jpg
[ ! -d "$XDG_CONFIG_HOME"/feh ] && mkdir "$XDG_CONFIG_HOME"/feh 
mv "$HOME"/.fehbg "$HOME"/.config/feh/fehbg

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null 2>&1 &
rm -r ~/.zsh* ~/.vim* ~/.bash*
# Change shell to zsh
echo "Now you may be asked for password. It's needed to end the configuration process. After that computer will be rebooted"
chsh -s /bin/zsh
sudo reboot now
