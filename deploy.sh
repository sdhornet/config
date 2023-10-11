#!/bin/bash

# Deploy tools to a fresh VPS
# Nate Golick
# 09/10/23

# USAGE:
# wget https://tinyurl.com/deployVPS -O deploy.sh
# chmod +x deploy.sh
# ./deploy.sh

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Update and upgrade system packages
apt-get update && apt-get upgrade -y

# Install the required packages
apt-get install tmux git zsh task-xfce-desktop dbus-x11 openjdk-17-jdk make bat -y

# Download tmux conf file
wget https://raw.githubusercontent.com/sdhornet/config/main/tmux.conf -O .tmux.conf

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

# Installing Go
# wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
# rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
# echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.zshrc
# #source ~/.zshrc
# rm go1.21.0.linux-amd64.tar.gz
# go version

#Install Evilnginx2
# git clone https://github.com/kgretzky/evilginx2.git /opt/evilginx2
# cd /opt/evilnginx2
# make
# cd /root

# Install certbot
# apt install snapd -y
# snap install core; sudo snap refresh core
# snap install --classic certbot
# ln -s /snap/bin/certbot /usr/bin/certbot

# Setup Bat
mv /usr/bin/batcat /usr/bin/bat
mkdir -p /root/.config/bat
touch /root/.config/bat/config
echo '--theme="1337"' >> /root/.config/bat/config

# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Remove existing .zshrc and download a new one from the specified link
rm ~/.zshrc
wget https://gitlab.com/kalilinux/packages/kali-defaults/-/raw/kali/master/etc/skel/.zshrc

echo "[+] All tasks completed!"
