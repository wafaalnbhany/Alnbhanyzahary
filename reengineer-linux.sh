#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root."
  exit 1
fi

echo "Starting Linux re-engineering process..."

# Detect the package manager
if command -v apt &> /dev/null; then
    PM="apt"
elif command -v yum &> /dev/null; then
    PM="yum"
elif command -v dnf &> /dev/null; then
    PM="dnf"
elif command -v pacman &> /dev/null; then
    PM="pacman"
else
    echo "Unsupported package manager. Exiting."
    exit 1
fi

# Update and upgrade packages
echo "Updating system..."
case $PM in
    apt) apt update && apt upgrade -y ;;
    yum) yum update -y ;;
    dnf) dnf update -y ;;
    pacman) pacman -Syu --noconfirm ;;
esac

# Remove unnecessary software
echo "Removing unnecessary packages..."
case $PM in
    apt)
        apt remove --purge -y \
            libreoffice* thunderbird cups gnome-games rhythmbox evolution \
            totem cheese transmission* aisleriot gnome-calendar gnome-contacts \
            gnome-weather shotwell brasero empathy deja-dup simple-scan \
            gnome-mines gnome-sudoku gnome-mahjongg || true
        ;;
    yum|dnf)
        yum remove -y libreoffice* thunderbird cups rhythmbox evolution gnome-games || true
        ;;
    pacman)
        pacman -Rns --noconfirm libreoffice thunderbird cups rhythmbox evolution gnome-games || true
        ;;
esac

# Clean up orphaned packages and temporary files
echo "Cleaning up the system..."
case $PM in
    apt) apt autoremove -y && apt clean ;;
    yum)
        if command -v package-cleanup &> /dev/null; then
            orphaned_packages=$(package-cleanup --leaves 2>/dev/null || true)
            if [ -n "$orphaned_packages" ]; then
                yum remove -y $orphaned_packages
            fi
        fi
        yum clean all 2>/dev/null || true
        ;;
    dnf) dnf autoremove -y && dnf clean all ;;
    pacman)
        if pacman -Qdtq &>/dev/null; then
            pacman -Rns --noconfirm $(pacman -Qdtq)
        fi
        ;;
esac

# Disable unnecessary services
echo "Disabling unnecessary services..."
for service in cups bluetooth avahi-daemon; do
    if systemctl is-enabled $service &> /dev/null; then
        systemctl disable $service
        systemctl stop $service
    fi
done

# Reduce GRUB timeout for faster boot
echo "Optimizing GRUB settings..."
if [ -f /etc/default/grub ]; then
    if grep -q "^GRUB_TIMEOUT=" /etc/default/grub; then
        sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
    elif ! grep -q "GRUB_TIMEOUT=1" /etc/default/grub; then
        echo "GRUB_TIMEOUT=1" >> /etc/default/grub
    fi

    if command -v update-grub &> /dev/null; then
        update-grub
    elif command -v grub2-mkconfig &> /dev/null; then
        grub2-mkconfig -o /boot/grub2/grub.cfg
    else
        echo "GRUB update command not found. Please update GRUB manually."
    fi
else
    echo "GRUB config file not found. Skipping boot optimization."
fi

# Disable GUI if it's running
if systemctl get-default | grep -q "graphical.target"; then
    echo "Switching to minimal CLI mode..."
    systemctl set-default multi-user.target
else
    echo "GUI is already disabled or not available."
fi

echo "Re-engineering process completed! Please reboot for all changes to take effect."
