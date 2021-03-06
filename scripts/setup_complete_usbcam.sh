#!/bin/sh
echo "Installing mjpg-streamer..."
sudo apt update  # To get the latest package lists
sudo apt install git cmake libjpeg8-dev gcc g++ -y
cd /home/pi
git clone https://github.com/jacksonliam/mjpg-streamer
cd /home/pi/mjpg-streamer/mjpg-streamer-experimental
make


sudo raspi-config nonint do_camera 1
sudo raspi-config nonint do_memory_split 256

sudo wget -O /etc/systemd/system/mjpg-streamer.service https://raw.githubusercontent.com/WullT/PoECam/main/services/mjpg-streamer.service
sudo wget -O /etc/systemd/system/.mjpgconf https://raw.githubusercontent.com/WullT/PoECam/main/services/.mjpgconf_usbcam

sudo systemctl daemon-reload
sudo systemctl enable mjpg-streamer.service
sudo systemctl start mjpg-streamer.service

systemctl is-active --quiet mjpg-streamer.service && echo mjpg-service is running || echo mjpg-service is not running


mkdir /home/pi/register

wget -O /home/pi/register/register.py https://raw.githubusercontent.com/WullT/PoECam/main/register/register.py

sudo wget -O /etc/systemd/system/register.service https://raw.githubusercontent.com/WullT/PoECam/main/services/register.service

sudo systemctl daemon-reload
sudo systemctl enable register.service
sudo systemctl start register.service