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
nala install feh kitty rofi picom thunar lightdm lxpolkit x11-xserver-utils unzip wget pulseaudio pavucontrol build-essential libx11-dev libx11-xcb-dev libxft-dev libxinerama-dev libxcb-xinerama0-dev libxcb-res0-dev zram-tools-y
# Installing Other less important Programs
nala install neofetch lxappearance tldr -y

# Install brave-browser
nala install apt-transport-https curl -y
curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
nala update
nala install brave-browser -y

# Install sublime-text
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
nala update
nala install sublime-text -y

# Configure lightdm
## Create a dwm.desktop session in /usr/share/xsessions
cd /usr/share/xsessions
touch dwm.desktop
echo [Desktop Entry] >> dwm.desktop
echo Encoding=UTF-8 >> dwm.desktop
echo Name=dwm >> dwm.desktop
echo Comment=Dynamic Window Manager >> dwm.desktop
echo Exec=dwm >> dwm.desktop
echo Icon=dwm >> dwm.desktop
echo Type=XSession >> dwm.desktop

## Copy existing lighdm.conf file to /etc/lightdm
cd /etc/lightdm
mv lightdm.conf lightdm.conf.bak
mv /home/$username/.config/lightdm/lightdm.conf /etc/lightdm

# Enable graphical login and change target from CLI to GUI
systemctl enable lightdm
ssystemctl set-default graphical.target

# Download, compile, and install DWM
cd $builddir
git clone https://github.com/Apelesko/dwm-config
cd dwm-config
make install

# Beautiful bash
#git clone https://github.com/ChrisTitusTech/mybash
#cd mybash
#bash setup.sh
#cd $builddir
