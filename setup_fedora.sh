#!/bin/sh
#
# chmod ogu+x this file on the target system to ensure it can be executed in case user and group ids aren't the same
#

# TODO - prompt to edit the dnf conf for speed
# 
# install dialog if we don't already have it
if ! command -v dialog >/dev/null; then
    echo "dialog is required - installing ...."
    sudo dnf install  dialog -y
fi

if dialog --clear --msgbox  "This will setup a Fedora based system." 0 0; then

  if dialog --clear --yesno "Step 1 - Do you want to update the system?" 0 0; then
    clear
    sudo dnf update
  fi
	
  dialog --clear --msgbox "Step 1 and a bit - speed up dnf! Click ok." 0 0 
  echo 'fastestmirror=1' | sudo tee -a /etc/dnf/dnf.conf
  echo 'max_parallel_downloads=10' | sudo tee -a /etc/dnf/dnf.conf
  echo 'deltarpm=true' | sudo tee -a /etc/dnf/dnf.conf
  
  dialog --clear --msgbox "Step 2 - Download AppImageLauncher .rpm version!!).  Firefox will load when OK is clicked." 0 0

  firefox "https://github.com/TheAssassin/AppImageLauncher/releases" > /dev/null 2>&1 &
  
  dialog --clear --msgbox "Step 3 - Install  AppImageLauncher: dnf install ~/Downloads/appimagelauncher... and click ok when done" 0 0 

  dialog --clear --msgbox "Step 4 - You need to download appimages for BitWarden, pCloud and Streamlink Twitch Gui. Firefox will load when Ok is clicked." 0 0

  firefox "https://bitwarden.com/download/" "https://www.pcloud.com/download-free-online-cloud-file-sorage.html" "https://github.com/streamlink/streamlink-twitch-gui/releases" > /dev/null 2>&1 &

  dialog --clear --msgbox "Step 5 - Get pCloud syncing. When completed click Ok to go to the next step." 0 0

  dialog --clear --msgbox "Step 6 - Install lots of things ..... " 0 0

  clear

  sudo dnf install -y  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf upgrade --refresh
  sudo dnf -y groupupdate core
  sudo dnf install -y rpmfusion-free-release-tainted
  sudo dnf install -y dnf-plugins-core

  sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/

  sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc -y 

  sudo dnf install -y brave-browser powerline powerline-fonts variety neofetch fish util-linux-user mpv gimp rsms-inter-fonts jetbrains-mono-fonts fortune-mod gnome-extensions-app gnome-tweaks gnome-shell-extension-appindicator libva-intel-driver 

  dialog --clear --msgbox "Step 5 - copy configs and set default shell" 0 0
  clear
  chsh -s /usr/bin/fish
  mkdir ~/.config/fish
  mkdir ~/.config/variety
  cp config.fish ~/.config/fish/
  cp variety.conf ~/.config/variety
  gsettings set org.gnome.desktop.session idle-delay 3600
  gsettings set org.gnome.desktop.screensaver lock-delay 60#
  
  dialog --clear --msgbox "All done. Download themes, configure as necessary and enjoy!" 0 0
fi

