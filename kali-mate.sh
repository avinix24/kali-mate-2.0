#!/bin/bash

# Run this script as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Use sudo." 
   exit 1
fi

echo "Updating and upgrading the system..."
apt update && apt upgrade -y

echo "Adding Kali Linux repositories..."
echo "deb http://http.kali.org/kali kali-rolling main contrib non-free" | tee /etc/apt/sources.list.d/kali.list
wget -q -O - https://archive.kali.org/archive-key.asc | apt-key add -

echo "Updating package lists..."
apt update

echo "Installing MATE desktop environment..."
sudo apt install -y mate-desktop-environment mate-desktop-environment-extra mate-tweak

echo "Installing Kali Linux themes and tools..."
sudo apt install -y kali-desktop-mate  -o dpkg::options::="--force-overwrite"
 kali-themes kali-menu kali-archive-keyring 
echo "Installing additional themes and icon packs..."
apt install -y arc-theme papirus-icon-theme numix-gtk-theme

echo "Setting MATE desktop as default session..."
echo "exec mate-session" > ~/.xsession
sed -i 's/^Exec=.*/Exec=mate-session/' /usr/share/xsessions/mate.desktop

echo "Configuring themes, fonts, and icons..."
gsettings set org.mate.interface gtk-theme "BlackMATE"
gsettings set org.mate.interface icon-theme "Papirus-Dark"
gsettings set org.mate.interface font-name "DejaVu Sans 10"
gsettings set org.mate.Marco.general theme "BlackMATE"

echo "Setting up panel layout similar to Kali 2.0 MATE..."
mate-panel --reset
gsettings set org.mate.panel default-layout "kali-mate"
mate-panel --replace &

echo "Cleaning up..."
apt autoremove -y
apt clean

echo "Setup complete! Reboot your system to use Kali MATE desktop on Debian."
