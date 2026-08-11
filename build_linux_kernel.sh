#!/usr/bin/env bash
set -e

echo "================================================================"
echo "          LINUX KERNEL SOURCE CONFIGURATION & BUILD             "
echo "================================================================"

# 1. Install toolchain dependencies
echo "[*] Installing build dependencies (clang, llvm, make, git)..."
pkg update -y
pkg install -y clang llvm make git bc bison flex libelf-dev libssl-dev || true

# 2. Clone Linux source tree if not already present
if [ ! -d "linux" ]; then
    echo "[*] Cloning Linux kernel repository (shallow clone for speed)..."
    git clone --depth 1 https://github.com/torvalds/linux.git
else
    echo "[+] Linux repository already cloned."
fi

cd linux

# 3. Configure default target
echo "[*] Generating default architecture configuration..."
make defconfig

# 4. Compile with parallel jobs
echo "[*] Initiating kernel compilation (-j2)..."
make -j2

echo "================================================================"
echo "[+] Kernel build sequence executed successfully."
echo "================================================================"
