#!/bin/bash

# Deploy tools to a fresh VPS
# Nate Golick
# 08/20/2025

# USAGE:
# chmod +x deploy.sh
# ./deploy.sh

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Update and upgrade system packages
echo -e "[+] Initial updates Started\n"
apt-get update && apt-get upgrade -y
echo -e "[+] Initial updates Complete\n"

# Install the required packages
echo -e "[+] Package updates Started\n"
apt-get install tmux git zsh task-xfce-desktop dbus-x11 make bat btop++ vim net-tools -y

# Download tmux conf file
wget https://raw.githubusercontent.com/sdhornet/config/main/tmux.conf -O .tmux.conf
echo -e "[+] Package updates Complete\n"

# Remove nomachine if it exists and install a new version
echo -e "[+] NoMachine install Started\n"
dpkg --purge nomachine
wget -q 'https://web9001.nomachine.com/download/9.1/Linux/nomachine_9.1.24_6_amd64.deb'
dpkg -i nomachine_9.1.24_6_amd64.deb >/dev/null
echo -e "[+] NoMachine install Complete\n"

# Modify the NX server configuration
echo -e "[+] NoMachine configuration Started\n"
sed -i 's/#EnableLocalNetworkBroadcast 1/EnableLocalNetworkBroadcast 0/' /usr/NX/etc/server.cfg
sed -i 's/#NXDListenAddress ""/NXDListenAddress "127.0.0.1"/' /usr/NX/etc/server.cfg
sed -i 's/^#NXUDPPort 4000/NXUDPPort 0/' /usr/NX/etc/server.cfg

# Restart related services
systemctl stop display-manager #lightdm
systemctl restart nxserver
echo -e "[+] NoMachine configuration Complete\n"

#Installing Go
#echo -e "[+] Installing Go\n"
#wget https://go.dev/dl/go1.22.1.linux-amd64.tar.gz
#rm -rf /usr/local/go && tar -C /usr/local -xzf go1.22.1.linux-amd64.tar.gz
#rm go1.22.1.linux-amd64.tar.gz
#echo -e "[+] Go install Complete\n"
#go version

#Install Evilnginx2
# git clone https://github.com/kgretzky/evilginx2.git /opt/evilginx2
# Wait for download
# sleep 5
# cd /opt/evilnginx2
# make
# cd /root

#Install certbot
echo -e "[+] Installing certbot\n"
apt install snapd -y
snap install core; sudo snap refresh core
snap install --classic certbot
ln -s /snap/bin/certbot /usr/bin/certbot

# Setup Bat
echo -e "[+] Configuring bat\n"
mv /usr/bin/batcat /usr/bin/bat
mkdir -p /root/.config/bat
touch /root/.config/bat/config
echo '--theme="1337"' >> /root/.config/bat/config

echo -e "[+] Installing ZSH\n"
# Install ohmyzsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Remove existing .zshrc and download a new one from the specified link
rm ~/.zshrc
wget https://gitlab.com/kalilinux/packages/kali-defaults/-/raw/kali/master/etc/skel/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/zsh-autosuggestions

# Update our new zshrc file with the Go Path
#echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.zshrc

echo "[+] All tasks completed!"
