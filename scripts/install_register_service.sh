#!/bin/sh

mkdir /home/pi/register

wget -O /home/pi/register/register.py https://raw.githubusercontent.com/WullT/PoECam/main/register/register.py

sudo wget -O /etc/systemd/system/register.service https://raw.githubusercontent.com/WullT/PoECam/main/services/register.service

sudo systemctl daemon-reload
sudo systemctl enable register.service
sudo systemctl start register.service