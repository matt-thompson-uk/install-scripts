#
# setup and configure an Ubuntu based system

#!/bin/sh
#
#
# git clone git://github.com/matt-thompson-uk/install-scripts.git
#
# chmod ogu+x this file on the target system to ensure it can be executed in case user and group ids aren't the same
#

# install dialog if we don't already have it
if ! command -v dialog >/dev/null; then
    echo "dialog is required - installing ...."
    sudo apt install dialog -y
fi

if dialog --clear --yesno  "This will setup a Deepin based system. Continue?" 0 0; then

  if dialog --clear --yesno "Step 1 - Do you want to update the system?" 0 0; then
    clear
    sudo apt update
    sudo apt upgrade -y
  fi

  dialog --clear --msgbox "Step 2 - Download AppImageLauncher .deb version!!).  Deepin Browser will load when OK is clicked." 0 0

  browser "https://github.com/TheAssassin/AppImageLauncher/releases" > /dev/null 2>&1 &
  
  dialog --clear --msgbox "Step 3 - Install AppImageLauncher and click ok when done" 0 0 

  dialog --clear --msgbox "Step 4 - You need to download appimages for BitWarden, pCloud and Streamlink Twitch Gui. Deepin Browser will load when Ok is clicked." 0 0

  browser "https://bitwarden.com/download/" "https://www.pcloud.com/download-free-online-cloud-file-storage.html" "https://github.com/streamlink/streamlink-twitch-gui/releases" > /dev/null 2>&1 &

  dialog --clear --msgbox "Step 5 - Get pCloud syncing. When completed click Ok to go to the next step." 0 0

  dialog --clear --msgbox "Step 6 - Install lots of things ..... " 0 0
  clear
  sudo apt install apt-transport-https curl -y
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt update
  sudo apt install synaptic brave-browser python3-pip neofetch powerline fonts-powerline fortune-mod gimp fish mpv conky -y

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

  sudo pip3 install streamlink
  sudo pip3 install bpytop --upgrade

  dialog --clear --msgbox "Step 7 - Copy configs, set default shell and do misc settings." 0 0
  clear
  echo "Changing default shell to fish..."
  chsh -s /usr/bin/fish
  mkdir ~/.config/fish
  cp config.fish.ubuntu ~/.config/fish/
  mv ~/.config/fish/config.fish.ubuntu ~/.config/fish/config.fish

  mkdir -p ~/.config/conky/images
  cp ~/Sync/AP-Weather-White-Plasma.conkyrc  ~/.config/conky/
  unzip ~/Sync/conkyimages.zip -d ~/.config/conky/
  cp ~/Sync/conky.desktop ~/.config/autostart/
  
  mkdir -p ~/.config/deepin/dde/daemon/appearance/custom-wallpapers
  sudo cp -r ~/Sync/variety_faves/* ~/.config/deepin/dde/daemon/appearance/custom-wallpapers
	
  # todo don't install variety
#	  copy variety faves imageas to /usr/share/wallpapers/deepin
#	  install conky and get the weather/cpu temp thing working
#	  check streamlink/mpv vdpau

  dialog --clear --msgbox "All done, but you can download Inter font from https://fonts.google.com/specimen/Inter and then extract the .ttfs and put them in ~/.local/share/fonts/fonts/ttf. You can also test conky with conky -d -p5 -c ~/.config/conky/AP-Weather-White-Plasma.conkyrc" 0 0

fi
