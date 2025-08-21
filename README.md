# Gnome-Shell Extension - HyperX Battery Indicator

**Displays battery percentage for HyperX devices (Cloud II Core, Cloud II Wireless, Cloud Stinger 2 Wireless, Cloud Alpha Wireless).**

Forked from [https://github.com/MichalW/gnome-bluetooth-battery-indicator](https://github.com/MichalW/gnome-bluetooth-battery-indicator)

Hid implementation based on  [https://github.com/auto94/HyperX-Cloud-2-Battery-Monitor](https://github.com/auto94/HyperX-Cloud-2-Battery-Monitor)


Vertical:
![Call](static/Screenshot-2.png)

Horizontal:
![Call](static/Screenshot-1.png)


## Compatibility

Cloud II Core,
Cloud II Wireless,
Cloud Stinger 2 Wireless,
Cloud Alpha Wireless

## Installation

**Prerequisites:**

*   GNOME Shell (version 40 or later is recommended)
*   `python3-hid` (Debian/Ubuntu) – `sudo apt install python3-hid`

### Manual Installation

1.  **Clone the repo:**

    ```sh
    git clone https://github.com/deividgermano/gnome-hyperx-battery-indicator.git
    ```
2. **Udev Rules** (Crucial for HID access)

    Create a new file in `/etc/udev/rules.d/99-HyperHeadset.rules` with the following content inside:

    ```
    SUBSYSTEMS=="usb", ATTRS{idProduct}=="018b", ATTRS{idVendor}=="03f0", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idProduct}=="0696", ATTRS{idVendor}=="03f0", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idProduct}=="1718", ATTRS{idVendor}=="0951", MODE="0666"
    SUBSYSTEMS=="usb", ATTRS{idProduct}=="0d93", ATTRS{idVendor}=="03f0", MODE="0666"
    ```

    Reload udev rules:

    ```
    sudo udevadm control --reload && sudo udevadm trigger
    ```
  

3.  **Copy to extensions:**

    ```sh
    cp -R gnome-hyperx-battery-indicator ~/.local/share/gnome-shell/extensions/hyperx-battery@deividgermano.github.com.shell-extension
    ```

4. Enable using extension manager

## Troubleshooting

Show debug log of this plugin: `journalctl -f -o cat /usr/bin/gnome-shell`
