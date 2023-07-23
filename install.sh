#!/bin/bash

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "You must BE a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

# Get username, working directory, i3 vsersion, distro name & debian version
username=$(id -u -n 1000)
builddir=$(pwd)
debianversion=$(cat /etc/debian_version) && debianversion=${debianversion%.*}

# Updating system & installing programs
echo ""; echo "Doing a system update & Installing the required programs..."
apt update && apt upgrade -y
apt install fonts-powerline x11-utils x11-xserver-utils curl imagemagick pulseaudio pavucontrol i3 i3status lightdm slick-greeter xfce4-terminal stterm wget nitrogen python3-pip dmenu fonts-font-awesome xserver-xorg-video-intel xserver-xorg-input-libinput picom light-locker -y

# Change the current working directory
cd "$builddir" || exit

# Creating necessary directories
echo ""; echo "Making necessary directories..."
mkdir -p /home/"$username"/.config/i3/
mkdir -p /home/"$username"/.config/i3status/
mkdir -p /home/"$username"/.config/picom/
mkdir -p /home/"$username"/Screenshots/
mkdir -p /usr/share/backgrounds/

# Copy config files
echo ""; echo "Copying config files..."
cp -R dotfiles/i3scripts /home/"$username"/.config/i3/ # python scripts to add program icons to workspaces in i3-bar
cp welcome-to-my-i3.md /home/"$username"/ # kind-of a user manual for my i3wm setup
cp dotfiles/config /home/"$username"/.config/i3/ # i3wm customizations
cp dotfiles/i3status /home/"$username"/.config/i3status/config # i3 bottom bar customizations
cp dotfiles/picom.conf /home/"$username"/.config/picom/ # Picom Compositor config file
chown -R "$username":"$username" /home/"$username" #otherwise you need sudo privileges whenever you want to change some of these files

# i3 tweaks
./scripts/reboot-poweroff.sh # For configuring reboot-poweroff commands to work without password
. ./scripts/j4-i3scripts.sh # Installing j4-dmenu-desktop and dependencies of i3scripts
curl -o /usr/bin/i3status-title-on-bar -L "https://github.com/rholder/i3status-title-on-bar/releases/latest/download/i3status-title-on-bar-linux_amd64"
chmod +x /usr/bin/i3status-title-on-bar # I've hidden the titlebar of windows. Instead I am using i3bar as a titlebar using this script.

# Done
echo "Installation is now complete. Reboot your system for the changes to take place.
Remember, upon reboot no wallpaper will be set. Use the app Nitrogen > Preferences to set a wallpaper.
Also, there would a file called 'welcome-to-my-i3.md' in the home folder.
Open it with a text editor of your choice. You'll get a qucik rundown of some important keyboard-mouse shortcuts."
