#!/usr/bin/env bash
set -e

# Node parameters
DISTRO="debian"
ROOT_DIR="$HOME/robdoerootauthority"

echo "================================================================"
echo "          PROOT-DISTRO // DEBIAN NODE BOOTSTRAP                "
echo "================================================================"

# 1. Ensure proot-distro is installed
if ! command -v proot-distro &> /dev/null; then
    echo "[*] Installing proot-distro package..."
    pkg update -y && pkg install proot-distro -y
fi

# 2. Check if Debian rootfs is installed, install if missing
if [ ! -d "$PREFIX/var/lib/proot-distro/installed-rootfs/$DISTRO" ]; then
    echo "[*] Installing Debian distribution via proot-distro..."
    proot-distro install "$DISTRO"
else
    echo "[+] Debian rootfs already installed."
fi

# 3. Ensure local workspace mount target exists
mkdir -p "$ROOT_DIR"

echo "[*] Launching Debian container with shared mounts and workspace bind..."
echo "================================================================"

# 4. Login with full hardware/system bindings and workspace shared directory
proot-distro login "$DISTRO" \
    --shared-tmp \
    --bind /dev \
    --bind /proc \
    --bind /sys \
    --bind "$ROOT_DIR:/root/robdoerootauthority"

