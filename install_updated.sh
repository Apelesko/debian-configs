#!/bin/bash

# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Install nala
apt install nala -y

# Use nala
bash scripts/usenala

# Making .config and Moving config files and background to Pictures
cd $builddir
mkdir -p /home/$username/.config
mkdir -p /home/$username/Pictures
mkdir -p /home/$username/Pictures/backgrounds
cp -R dotconfig/* /home/$username/.config/
cp -R Pictures/* /home/$username/Pictures/backgrounds/
mv user-dirs.dirs /home/$username/.config
chown -R $username:$username /home/$username

# Installing Essential Programs 
#nala install feh kitty rofi picom thunar nitrogen lxpolkit x11-xserver-utils unzip wget pulseaudio pavucontrol build-essential libx11-dev libxft-dev libxinerama-dev -y
nala install feh kitty rofi picom thunar lightdm lxpolkit x11-xserver-utils unzip wget pulseaudio pavucontrol build-essential libx11-dev libx11-xcb-dev libxft-dev libxinerama-dev libxcb-xinerama0-dev libxcb-res0-dev -y
# Installing Other less important Programs
nala install neofetch lxappearance -y

# Install brave-browser
nala install apt-transport-https curl -y
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
nala update
nala install brave-browser -y

# Enable graphical login and change target from CLI to GUI
systemctl enable lightdm
ssystemctl set-default graphical.target

# Download, compile, and install DWM


# Beautiful bash
#git clone https://github.com/ChrisTitusTech/mybash
#cd mybash
#bash setup.sh
#cd $builddir
