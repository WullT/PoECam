#!/bin/sh

mkdir /home/pi/discoveryserver

wget -O /home/pi/discoveryserver/discoveryserver.py https://raw.githubusercontent.com/WullT/PoECam/main/discoveryserver/discoveryserver.py

sudo wget -O /etc/systemd/system/discoveryserver.service https://raw.githubusercontent.com/WullT/PoECam/main/services/discoveryserver.service

sudo systemctl daemon-reload
sudo systemctl enable discoveryserver.service
sudo systemctl start discoveryserver.service