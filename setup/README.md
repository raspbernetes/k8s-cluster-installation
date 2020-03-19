# Ubuntu

The following instructions are to flash your SD card with the desired OS and configuration specified in the cloud-init config [file](./cloud-config.yml).
> See http://cloudinit.readthedocs.io/en/0.7.9/ for more details.

## Downloads the Flash tool

```bash
sudo curl -L "https://github.com/hypriot/flash/releases/download/2.5.0/flash" -o /usr/local/bin/flash
sudo chmod +x /usr/local/bin/flash
```

## Download and extract the image

```bash
curl -L "http://cdimage.ubuntu.com/releases/eoan/release/ubuntu-19.10.1-preinstalled-server-arm64+raspi3.img.xz" -o ~/Downloads/ubuntu-19.10.1-preinstalled-server-arm64+raspi3.img.xz
unxz -T 0 ~/Downloads/ubuntu-19.10.1-preinstalled-server-arm64+raspi3.img.xz
```

## Flash

```bash
flash \
    --userdata setup/cloud-config.yml \
    ~/Downloads/ubuntu-19.10.1-preinstalled-server-arm64+raspi3.img
```

## Boot

Place the SD Card in your RPi and give the system approx ~10 minutes to boot before trying to SSH.
