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

# Create autologin group for tty
usermod -aG autologin $username

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
nala install feh kitty dmenu arandr ufw picom thunar lightdm lxpolkit x11-xserver-utils unzip wget pipewire pavucontrol build-essential libx11-dev libx11-xcb-dev libxft-dev libxinerama-dev libxcb-xinerama0-dev libxcb-res0-dev -y
# Installing Other less important Programs
nala install neofetch lxappearance tldr -y

# Download and install necessary fonts
nala install fonts-font-awesome -y
mkdir -p /home/$username/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d /home/$username/.local/share/fonts

# Reload fonts
fc-cache -v -f
rm ./Meslo.zip

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

## Copy existing lightdm.conf file to /etc/lightdm
cd /etc/lightdm
mv lightdm.conf lightdm.conf.bak
mv /home/$username/.config/lightdm/lightdm.conf /etc/lightdm

# Enable graphical login and change target from CLI to GUI
systemctl enable lightdm
systemctl set-default graphical.target

#Enable ufw
ufw enable

# Download, compile, and install DWM
cd $builddir
git clone https://github.com/Apelesko/dwm-config
chown -R $username:$username dwm-config
mv dwm-config ..
cd ../dwm-config
make install

# Configure lightdm to use dwm
cp dwm.desktop /usr/share/xsessions

# Beautiful bash
#git clone https://github.com/ChrisTitusTech/mybash
#cd mybash
#bash setup.sh
#cd $builddir
