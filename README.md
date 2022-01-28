# PoECam

Consists of 

* [mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer), a command line tool that copies JPEG frames from an input (Raspberry Pi Camera od USB camera) to HTTP output plugin
* [register](register/register.py), a simple Python script that periodically sends a POST request to the camera at the [APGateway](https://github.com/WullT/APGateway)

## Setup

### Write Raspberry Pi OS to an SD card

- Download [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and run it
- Select *OS &rarr; Raspberry Pi OS (other) &rarr; Raspberry Pi OS Lite (Legacy)*
- Click `CTRL + SHIFT + X` to enter advanced options
- Enter a Hostname, starting with `cam-` , e.g. `cam-1234-5678` where `1234-5678` is the ID of the device
- Check the button next to `enable SSH`
- Set an SSH password
- Enter Wifi credentials (best is a smartphone hotspot) and set the WiFi-country
- Click Save
- Select your SD card
- Click Write

### Access the Raspberry Pi

- Insert the SD card into the Raspberry Pi
- Plug in the power supply
- If you are using a smartphone hotspot, you will see a connected device and its ip
- Open a cmd terminal and type `ssh pi@<raspberrypi_hostname>.local` , e.g.
```sh
ssh pi@cam-1234-5678.local
```
- enter your password
- If you have chosen a weak password, change the password with:
```sh
passwd
```

### Install mjpg-streamer and the register app

Setup all in one (Raspberry Cam):
```sh
curl https://raw.githubusercontent.com/WullT/PoECam/main/scripts/setup_complete_raspicam.sh | bash
```

Setup all in one (USB Cam):
```sh
curl https://raw.githubusercontent.com/WullT/PoECam/main/scripts/setup_complete_usbcam.sh | bash
```

Only Register:
```sh
curl https://raw.githubusercontent.com/WullT/PoECam/main/scripts/install_register_service.sh | bash
```

>Reboot after running the scripts:
```sh
sudo reboot
```

### Change the IP of the [AP Gateway](https://github.com/WullT/APGateway)

The [register](register/register.py) script sends request to the [registrationserver](https://github.com/WullT/APGateway/blob/main/apps/registrationserver.py) on the AP Gateway. By default, the requests are sent to `http://ap-gateway.local:8888`. The hostname and the port can be changed in the register script:
```sh
nano /home/pi/register/register.py
```



## Change camera resolution and basic auth credentials

To check available camera resolutions:
```sh
# DFRobot USB Endoscope connected (https://www.dfrobot.com/product-2328.html)
v4l2-ctl --list-formats-ext
ioctl: VIDIOC_ENUM_FMT
        Type: Video Capture

        [0]: 'MJPG' (Motion-JPEG, compressed)
                Size: Discrete 640x480
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 352x288
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 320x240
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 640x360
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 160x120
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 960x540
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1024x768
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x720
                        Interval: Discrete 0.033s (30.000 fps)
                Size: Discrete 1280x960
                        Interval: Discrete 0.033s (30.000 fps)
```

Modify [.mjpgconf](services/.mjpgconf_raspicam)
```sh
sudo nano /etc/systemd/system/.mjpgconf
```

Raspberry Pi Camera:
```conf
INPUTARG=-i "input_raspicam.so -x <RESOLUTION_WIDTH> -y <RESOLUTION_HEIGHT> -fps 5"
OUTPUTARG=-o "output_http.so -p 8080 --credentials <USERNAME>:<PASSWORD>"
```

USB Camera:
```conf
INPUTARG=-i "input_uvc.so -r <RESOLUTION IN FORMAT 1280x960> "
OUTPUTARG=-o "output_http.so -p 8080 --credentials <USERNAME>:<PASSWORD>"
```

## Set static IP

Edit `/etc/network/interfaces`

```sh
sudo nano /etc/network/interfaces
```

```conf
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source /etc/network/interfaces.d/*

auto lo eth0 wlan0

allow-hotplug eth0
 iface eth0 inet static
   address 192.168.50.5/24

allow-hotplug wlan0
 iface wlan0 inet dhcp
 wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```