#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Update and upgrade system packages
apt-get update && apt-get upgrade -y

# Install the required packages
apt-get install tmux git zsh task-xfce-desktop dbus-x11 openjdk-11-jdk -y

# Download tmux conf file
wget https://raw.githubusercontent.com/sdhornet/config/main/tmux.conf

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Remove existing .zshrc and download a new one from the specified link
rm ~/.zshrc
wget https://gitlab.com/kalilinux/packages/kali-defaults/-/raw/kali/master/etc/skel/.zshrc

# Remove nomachine if it exists and install a new version
dpkg --purge nomachine
wget -q 'https://download.nomachine.com/download/8.8/Linux/nomachine_8.8.1_1_amd64.deb'
dpkg -i nomachine_8.8.1_1_amd64.deb >/dev/null

# Modify the NX server configuration
sed -i.bak 's/#EnableNetworkBroadcast 1/EnableNetworkBroadcast 0/' /usr/NX/etc/server.cfg
sed -i.bak 's/#NXdListenAddress ""/NXdListenAddress "127.0.0.1"/' /usr/NX/etc/server.cfg

# Restart related services
systemctl stop display-manager #lightdm
systemctl restart nxserver

echo "All tasks completed!"

