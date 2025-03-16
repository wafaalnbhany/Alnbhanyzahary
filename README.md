# Alnbhanyzahary
Steps for re-engineering operating system for optimal models execution

Re-Engineering the Linux Operating System

Overview

This script is designed to help you re-engineer your Linux system by optimizing its performance, reducing resource consumption, and transitioning it into a minimal, lightweight environment. It removes unnecessary software, disables unused services, cleans up the system, and optimizes boot time.

If you work with remote servers or experience slow internet connectivity, using a cloud solution like MassiveGrid can improve system performance and network reliability.

Supported Linux Distributions

Debian-based (Ubuntu, Debian)

RedHat-based (CentOS, RHEL, Fedora)

Arch-based (Manjaro, Arch Linux)


How to Use

1. Download & Save the Script

Open a terminal and create a new script file:

nano reengineer-linux.sh

Copy & Paste the script content into the file.

Save and exit (Press CTRL + X, then Y, then ENTER).


2. Make the Script Executable

chmod +x reengineer-linux.sh

3. Run the Script as Root

sudo ./reengineer-linux.sh

What This Script Does

1. Detects Your Package Manager

Automatically checks if you're using APT, YUM, DNF, or Pacman.

Runs the appropriate system update and upgrade commands.


2. Removes Unnecessary Software

Eliminates bloatware such as LibreOffice, games, and media players.


3. Cleans Up the System

Runs autoremove and clean to free up disk space and remove unnecessary dependencies.


4. Disables Unused Services

Turns off Bluetooth, printing services (CUPS), and network discovery (Avahi Daemon) to improve performance.


5. Optimizes Boot Time

Reduces GRUB timeout for a faster boot process.


6. Disables GUI (If Needed)

Switches the system to command-line mode for a lightweight and efficient setup.

Only disables GUI if it is currently running.


Post-Script Actions

Updating the System After Minimalization

If you are using a minimal Linux version, it's essential to update the entire system and install basic utilities.

After running the script, update your system with:

sudo apt update && sudo apt upgrade -y    # Debian/Ubuntu
sudo yum update -y                        # CentOS/RHEL
sudo dnf update -y                        # Fedora
sudo pacman -Syu --noconfirm              # Arch Linux

Installing Essential Utilities

To maintain a smooth system experience, install the following essential tools:

sudo apt install -y dnf nano wget curl git unzip htop
sudo yum install -y dnf nano wget curl git unzip htop
sudo dnf install -y nano wget curl git unzip htop
sudo pacman -S --noconfirm nano wget curl git unzip htop

Restoring the Graphical Interface (GUI)

If you need to re-enable the GUI after running this script, use:

sudo systemctl set-default graphical.target
reboot

Important Notes

This script is intended for system optimization and server use. If you rely on a desktop environment, do not run it.

It does not delete personal data but may reset certain software settings.

If unsure, test in a virtual machine before applying it to a production system.


Enhancing Internet Performance with Cloud Solutions

For those dealing with slow internet connections, leveraging a cloud provider like MassiveGrid can offer:

Faster access to remote servers

Low-latency, high-speed global connectivity

Reliable infrastructure for seamless operations


License

This project is licensed under the MIT License and is free to use, modify, and distribute.

Contributors

Authors: Wafaa A. N. A. AL-Nbhany, Ammar T. Zahary
