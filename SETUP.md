# OpenLinkHub Setup for B850I AORUS PRO + G.SKILL DDR5

Quick setup guide for getting OpenLinkHub working with iCUE LINK System Hub and G.SKILL DDR5 RGB on this system.

## Prerequisites

1. Install required packages:
```bash
sudo dnf install i2c-tools podman
# podman must be v5.6.0 or higher to use quadlet
```

2. Load i2c-dev module:
```bash
sudo modprobe i2c-dev
```

## Device Permissions Setup

1. Copy the i2c udev rules:
```bash
sudo cp 99-i2c.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && sudo udevadm trigger
```

2. Add your user to i2c group:
```bash
sudo groupadd -f i2c
sudo usermod -aG i2c $USER
```

## Service Setup (Modern Quadlet Approach)

Install the Quadlet container file:
```bash
podman quadlet install openlinkhub.container # reload-systemd is default
```

Start the service:
```bash
systemctl --user start openlinkhub
```

## Development Workflow

When making code changes:
```bash
podman build --no-cache -t localhost/openlinkhub:latest .

# Restart the service
systemctl --user restart openlinkhub
```

## RAM RGB Control (G.SKILL DDR5)

1. Add kernel parameter to `/etc/default/grub`:
```bash
# Add acpi_enforce_resources=lax to GRUB_CMDLINE_LINUX_DEFAULT
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

2. Reboot system

3. Control RAM RGB:
```bash
openrgb --list-devices  # Find RAM device number
openrgb --device X --mode static --color 000000  # Turn off
```

## Configuration

Enable memory control in `config.json`:
```json
{
  "memory": true,
  "memoryType": 5,
  "memorySmBus": "i2c-0"
}
```