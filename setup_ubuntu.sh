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

  dialog --clear --msgbox "Step 2 - Setup the PPA for appimagelauncher and install the app." 0 0
  clear
  sudo add-apt-repository ppa:appimagelauncher-team/stable -y
  sudo apt-get update
  sudo apt install appimagelauncher -y

  dialog --clear --msgbox "Step 3 - You need to download appimages for BitWarden, pCloud and Streamlink Twitch Gui. Firefox will load when OK is clicked." 0 0

  firefox "https://bitwarden.com/download/" "https://www.pcloud.com/download-free-online-cloud-file-storage.html" "https://github.com/streamlink/streamlink-twitch-gui/releases" &

  dialog --clear --msgbox "Step 4 - You need to install Bitwarden and pCloud appimages with appimagelauncher. When pCloud has finished syncing, go to the next step." 0 0
fi
