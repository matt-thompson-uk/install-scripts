#!/bin/sh
#
# chmod ogu+x this file on the target system to ensure it can be executed in case user and group ids aren't the same
#

# install dialog if we don't already have it
if ! command -v dialog >/dev/null; then
    echo "dialog is required - installing ...."
    sudo pacman -S dialog --noconfirm
fi

if dialog --clear --msgbox  "This will setup an Arch based system." 0 0; then

  if dialog --clear --yesno "Step 1 - Do you want to update the system?" 0 0; then
    clear
    sudo pacman -Syu 	
  fi

  dialog --clear --msgbox "Step 2 - install yay, base-devel, pcloud and bitwarden" 0 0
  clear
  sudo pacman -S yay base-devel --noconfirm
  yay -S pcloud-drive bitwarden-bin --noconfirm

  dialog --clear --msgbox "Step 3 - Now, log in to pcloud and setup sync. Press enter when pcloud is fully synced." 0 0

  dialog  --clear --msgbox "Step 4 - install lots of things........." 0 0
  clear
  yay -S brave-bin powerline powerline-fonts variety neofetch fortune-mod fish mpv streamlink-twitch-gui gimp inter-font ttf-jetbrains-mono lsd ttf-nerd-fonts-symbols --noconfirm

  dialog --clear --msgbox "Step 5 - copy configs and set default shell" 0 0
  clear
  chsh -s /usr/bin/fish
  mkdir ~/.config/fish
  mkdir ~/.config/variety
  cp config.fish ~/.config/fish/
  cp variety.conf ~/.config/variety

  if dialog --clear --yesno "Step 6 - Install Gtk themes/icons ?" 0 0; then
    clear
    yay -S qogir-icon-theme-git qogir-gtk-theme-git orchis-theme-git tela-icon-theme --noconfirm
  fi

  if dialog --clear --yesno "Step 7 - Install Plasma themes/icons?" 0 0; then
    clear
    yay -S qogir-icon-theme qogir-kde-theme-git orchi-kde-theme-git tela-icon-theme --noconfirm
  fi

  dialog --clear --msgbox "All done. Configure as necessary and enjoy!" 0 0
fi

