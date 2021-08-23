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

if dialog --clear --yesno  "This will setup an Ubuntu based system. Continue?" 0 0; then
  if dialog --clear --yesno "Step 1 - Do you want to update the system?" 0 0; then
    clear
    sudo apt update
    sudo apt upgrade -y
  fi

  if dialog --clear --yesno "Step 2 - Setup the PPA for appimagelauncher and install the app." 0 0; then # change this to a msgbox and get rid of the if
    clear
    sudo add-apt-repository ppa:appimagelauncher-team/stable -y
    sudo apt-get update
    sudo apt install appimagelauncher -y

    dialog --clear --msgbox "Step 3 - You need to download appimages for BitWarden, pCloud and Streamlink Twitch Gui. Firefox will load when OK is clicked." 0 0

    firefox "https://bitwarden.com/download/" "https://www.pcloud.com/download-free-online-cloud-file-storage.html" "https://github.com/streamlink/streamlink-twitch-gui/releases" > /dev/null 2>&1 &

    dialog --clear --msgbox "Step 4 - You need to install Bitwarden and pCloud appimages with appimagelauncher. When pCloud has finished syncing, go to the next step." 0 0
  fi

  dialog --clear --msgbox "Step 5 - Install lots of things ..... " 0 0
  clear
  sudo apt install apt-transport-https curl -y
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt update
  sudo apt install synaptic brave-browser python3-pip neofetch powerline fonts-powerline terminator fortune-mod fish mpv fonts-inter -y

  dialog --clear --msgbox "Step 6 - Copy configs and do misc settings." 0 0
  clear
  chsh -s /usr/bin/fish
  mkdir ~/.config/fish
  mkdir ~/.config/variety
  cp config.fish.ubuntu ~/.config/fish/
  mv ~/.config/config.fish.ubuntu ~.config/fish/config.fish
  cp variety.conf ~/.config/variety
  mkdir -p ~/.config/terminator/plugins
  sudo pip3 install requests
  wget https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"
# copy configs
# ask if to do gnomesettings
# gnome themes
# kde themes

fi
