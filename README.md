# PoECam

Consists of 

* [mjpg-streamer](https://github.com/jacksonliam/mjpg-streamer), a command line tool that copies JPEG frames from an input (Raspberry Pi Camera od USB camera) to HTTP output plugin
* [discoveryserver](https://github.com/WullT/PoECam/blob/main/discoveryserver/discoveryserver.py), a simple HTTP server on port 8000 that is used to get discovered by the [APGateway](https://github.com/WullT/APGateway)

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

### Install mjpg-streamer and discoveryserver

Setup all in one (Raspberry Cam):
```sh
curl https://raw.githubusercontent.com/WullT/PoECam/main/scripts/setup_complete_raspicam.sh | bash
```

Setup all in one (USB Cam):
```sh
curl https://raw.githubusercontent.com/WullT/PoECam/main/scripts/setup_complete_usbcam.sh | bash
```

Only Discoveryserver:
```sh
curl https://raw.githubusercontent.com/WullT/PoECam/main/scripts/install_discovery_service.sh | bash
```

>Reboot after running the scripts:
```sh
sudo reboot
```


## Change Resolution and basic auth credentials

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
