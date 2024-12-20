#!/bin/bash

# Deploy tools to a fresh node
# Nate Golick
# 12/20/24

# USAGE:
# chmod +x deploy.sh
# ./node_deploy.sh

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
apt-get install tmux zsh bat btop++ -y

# Download tmux conf file
wget https://raw.githubusercontent.com/sdhornet/config/main/tmux.conf -O .tmux.conf
echo -e "[+] Package updates Complete\n"

# Restart related services
# systemctl stop display-manager #lightdm
# systemctl restart nxserver
# echo -e "[+] NoMachine configuration Complete\n"

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
wget https://raw.githubusercontent.com/sdhornet/config/refs/heads/main/zshrc -O .zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions /usr/share/zsh-autosuggestions


echo "[+] All tasks completed!"
