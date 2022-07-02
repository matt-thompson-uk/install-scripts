#!/bin/sh
#
# chmod ogu+x this file on the target system to ensure it can be executed in case user and group ids aren't the same
#

# TODO - prompt to edit the dnf conf for speed
# 
# install dialog if we don't already have it
if ! command -v dialog >/dev/null; then
    echo "dialog is required - installing ...."
    sudo zypper install dialog
fi

if dialog --clear --msgbox  "This will setup an OpenSuse based system." 0 0; then

  if dialog --clear --yesno "Step 1 - Do you want to update the system?" 0 0; then
    clear
    sudo zypper update
  fi
	
  dialog --clear --msgbox "Step 2 - Download AppImageLauncher .rpm version!!).  Firefox will load when OK is clicked." 0 0

  firefox "https://github.com/TheAssassin/AppImageLauncher/releases" > /dev/null 2>&1 &
  
  dialog --clear --msgbox "Step 3 - Install  AppImageLauncher: sudo zypper install ~/Downloads/appimagelauncher... Note : ignore the signature verification failure. Click ok when done" 0 0

  dialog --clear --msgbox "Step 4 - You need to download appimages for BitWarden, pCloud and Streamlink Twitch Gui. Firefox will load when Ok is clicked." 0 0

  firefox "https://bitwarden.com/download/" "https://www.pcloud.com/download-free-online-cloud-file-sorage.html" "https://github.com/streamlink/streamlink-twitch-gui/releases" > /dev/null 2>&1 &

  dialog --clear --msgbox "Step 5 - Get pCloud syncing. When completed click Ok to go to the next step." 0 0

  dialog --clear --msgbox "Step 6 - Install packman repository and lots of other things ..... " 0 0

  clear
  sudo zypper ar -cfp 90 https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
  sudo zypper dup --from packman --allow-vendor-change

  sudo zypper install curl
  sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
  sudo zypper addrepo --refresh https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
  sudo zypper install  brave-browser latte-dock kvantum-manager powerline powerline-fonts variety neofetch fish mpv gimp inter-fonts adobe-sourcecodepro-fonts fortune lib libva-vdpau-driver libqt4 streamlink

  dialog --clear --msgbox "Step 7 - copy configs and set default shell" 0 0
  clear
  chsh -s /usr/bin/fish
  mkdir ~/.config/fish
  mkdir ~/.config/variety
  cp config.fish.opensuse ~/.config/fish/
  mv ~/.config/fish/config.fish.opensuse ~/.config/fish/config.fish
  cp variety.conf ~/.config/variety
  
  if dialog --clear --yesno "Step 8 - Do you want to install Plasma themes? It might be better to install them from Discover, they'll get automatically updated..." 0 0; then

    mkdir -p ~/.local/share/plasma/plasmoids

    git clone https://github.com/vinceliuice/Orchis-kde.git
    cd Orchis-kde
    ./install.sh
    cd ..

    git clone https://github.com/vinceliuice/Qogir-kde
    cd Qogir-kde
    ./install.sh
    cd ..

    git clone https://github.com/vinceliuice/Qogir-kde
    cd Qogir-kde
    ./install.sh
    cd ..

    git clone https://github.com/vinceliuice/Qogir-icon-theme.git
    cd Qogir-icon-theme
    ./install.sh
    cd ..

    git clone https://github.com/vinceliuice/Tela-icon-theme
    cd Tela-icon-theme
    ./install.sh -a
    cd ..
  fi

  dialog --clear --msgbox "All done, configure as necessary and enjoy!" 0 0
fi

