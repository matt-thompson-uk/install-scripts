#
# setup and configure an Elementary system

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

if dialog --clear --yesno  "This will setup an Elementary OS system. Continue?" 0 0; then

  dialog --clear --msgbox "Step 1  - Disable unattened upgrades."
  clear
  sudo dpkg-reconfigure unattended-upgrades

  if dialog --clear --yesno "Step 2 - Do you want to update the system?" 0 0; then
    clear
    sudo apt update
    sudo apt upgrade -y
  fi

  if dialog --clear --yesno "Step 3 - Setup the PPA for appimagelauncher and install the app." 0 0; then # change this to a msgbox and get rid of the if
    clear
    sudo add-apt-repository ppa:appimagelauncher-team/stable -y
    sudo apt-get update
    sudo apt install appimagelauncher -y

    dialog --clear --msgbox "Step 4 - You need to download appimages for BitWarden, pCloud and Streamlink Twitch Gui. Firefox will load when OK is clicked." 0 0

    flatpak run org.gnome.Epiphany "https://bitwarden.com/download/" "https://www.pcloud.com/download-free-online-cloud-file-storage.html" "https://github.com/streamlink/streamlink-twitch-gui/releases" > /dev/null 2>&1 &

    dialog --clear --msgbox "Step 5 - You need to install Bitwarden and pCloud appimages with appimagelauncher. When pCloud has finished syncing, go to the next step." 0 0
  fi

  dialog --clear --msgbox "Step 6 - Install lots of things ..... " 0 0
  clear
  sudo apt install apt-transport-https curl -y
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt update
  sudo apt install synaptic brave-browser python3-pip neofetch powerline fonts-powerline terminator fortune-mod variety gimp fish mpv -y

  sudo pip3 install streamlink
  sudo pip3 install bpytop --upgrade

  # pantheon tweaks
  sudo apt install -y software-properties-common
  sudo add-apt-repository -y ppa:philip.scott/pantheon-tweaks
  sudo apt update
  suso apt install -y pantheon-tweaks

  dialog --clear --msgbox "Step 7 - Copy configs, set default shell and do misc settings." 0 0
  clear
  echo "Changing default shell to fish..."
  chsh -s /usr/bin/fish
  mkdir ~/.config/fish
  mkdir ~/.config/variety
  cp config.fish.ubuntu ~/.config/fish/
  mv ~/.config/fish/config.fish.ubuntu ~/.config/fish/config.fish
  cp variety.conf ~/.config/variety
  mkdir -p ~/.config/terminator/plugins
  sudo pip3 install requests
  wget https://git.io/v5Zww -O $HOME"/.config/terminator/plugins/terminator-themes.py"

  mkdir -p ~/.config/conky/images
  cp ~/Sync/AP-Weather-White-Plasma.conkyrc  ~/.config/conky/
  unzip ~/Sync/conkyimages.zip -d ~/.config/conky/
  cp ~/Sync/conky.desktop ~/.config/autostart/

  dialog --clear --msgbox "Step 8 - setup Appindicator support. Download the reqd .deb file (to ~/Downloads) and click Ok" 0 0
  flatpak run org.gnome.Epiphany "https://github.com/Lafydev/wingpanel-indicator-ayatana/blob/master/com.github.lafydev.wingpanel-indicator-ayatana_2.0.7_amd64.deb"
  dialog --clear --msgbox "Step 8.5 - Click Ok to install install the .deb" 0 0
  sudo dpkg -i ~/Downloads/com.github.lafydev.wingpanel*.deb
  cp /etc/xdg/autostart/indicator-application.desktop ~/.config/autostart/
  sed -i 's/^OnlyShowIn.*/OnlyShowIn=Unity;GNOME;Pantheon;/' ~/.config/autostart/indicator-application.desktop
  dialog --clear --msgbox "Step 8.75 - Nano will launch when Ok is clicked. Add 'Pantheon;'' to the end of  OnlyShowIn line.." 0 0
  sudo nano /etc/xdg/autostart/indicator-application.desktop 
  dialog --clear --msgbox "All done. Install Libreoffice from flathub then configure everything as necessary. Reboot and enjoy!" 0 0

fi
