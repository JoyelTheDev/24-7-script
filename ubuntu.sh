#!/usr/bin/env bash
set -euo pipefail

# =================================
#  Ubuntu 24.04 XRDP + XFCE Installer
#  Simple Version
# =================================

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

# Helpers
log()  { echo -e "${CYAN}[INFO]${RESET} $1"; }
ok()   { echo -e "${GREEN}[OK]${RESET}   $1"; }
warn() { echo -e "${YELLOW}[WARN]${RESET} $1"; }

# Check if Ubuntu 24.04
if [[ ! -f /etc/os-release ]] || ! grep -q "VERSION_ID=\"24.04\"" /etc/os-release; then
    echo -e "${RED}[ERROR]${RESET} This script is for Ubuntu 24.04 only"
    exit 1
fi

# Header
clear
echo "========================================================"
echo "   Ubuntu 24.04 XRDP + XFCE Setup"
echo "   Simple & Clean"
echo "========================================================"
sleep 1

# Step 1: Update system
log "[1/5] Updating system..."
sudo apt update -y && sudo apt upgrade -y
ok "System updated"

# Step 2: Install XFCE and XRDP
log "[2/5] Installing XFCE and XRDP..."
sudo apt install -y xfce4 xfce4-goodies xrdp dbus-x11
ok "XFCE and XRDP installed"

# Step 3: Configure XRDP
log "[3/5] Configuring XRDP session..."
echo "xfce4-session" > ~/.xsession
chmod 644 ~/.xsession
sudo adduser xrdp ssl-cert 2>/dev/null || true
ok "XRDP configured"

# Step 4: Start XRDP service
log "[4/5] Starting XRDP service..."
sudo systemctl enable xrdp
sudo systemctl restart xrdp
ok "XRDP service started"

# Step 5: Verify
log "[5/5] Verifying installation..."
if systemctl is-active xrdp >/dev/null 2>&1; then
    ok "XRDP is running"
else
    warn "XRDP may not be running"
fi

# Done
echo
echo "========================================================"
echo -e " 🎉 ${GREEN}Installation Complete!${RESET}"
echo
echo " Your XFCE desktop is ready for RDP connection."
echo " Use any RDP client to connect to:"
echo "   IP Address: $(hostname -I | awk '{print $1}')"
echo "   Username: $(whoami)"
echo "========================================================"
