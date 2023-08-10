# dpkg --purge nomachine
# wget -q 'https://download.nomachine.com/download/7.7/Linux/nomachine_7.7.4_1_amd64.deb'
# dpkg -i nomachine_7.7.4_1_amd64.deb >/dev/null
# sed -i.bak 's/#EnableNetworkBroadcast 1/EnableNetworkBroadcast 0/' /usr/NX/etc/server.cfg
# #sed -i.bak 's/#EnableScreenBlanking 0/EnableScreenBlanking 1/' /usr/NX/etc/server.cfg
# #sed -i.bak 's/#EnableLockScreen 0/EnableLockScreen 1/' /usr/NX/etc/server.cfg
# sed -i.bak 's/#NXdListenAddress ""/NXdListenAddress "127.0.0.1"/' /usr/NX/etc/server.cfg
systemctl stop display-manager #lightdm
systemctl restart nxserver
