#!/usr/bin/env python3
import os
import subprocess
import json

def force_mount_sd():
    print("================================================================")
    print("        FORCE-BINDING 32GB SD CARD TO TERMUX HOME               ")
    print("================================================================")
    
    # Common external SD card mount paths on Android devices
    sd_candidates = [
        "/storage/extSdCard",
        "/storage/sdcard1",
        "/storage/external-1",
        "/mnt/sdcard",
        "/storage/emulated/0/Android/data/com.termux/files"
    ]
    
    # Let's check storage directory first
    storage_base = os.path.expanduser("~/storage")
    if os.path.exists(storage_base):
        for item in os.listdir(storage_base):
            sd_candidates.append(os.path.join(storage_base, item))
            
    active_sd = None
    for path in sd_candidates:
        if os.path.exists(path):
            try:
                test_file = os.path.join(path, ".sd_write_test")
                with open(test_file, "w") as f:
                    f.write("OK")
                os.remove(test_file)
                active_sd = path
                break
            except Exception:
                continue
                
    if not active_sd:
        print("[!] Standard automated SD paths require permissions or manual link.")
        print("[*] Creating symlink wrapper to external storage...")
        # Check if termux-setup-storage was done, point to shared storage root
        shared_root = "/storage/emulated/0"
        if os.path.exists(shared_root):
            active_sd = shared_root
            
    if active_sd:
        target_dir = os.path.join(active_sd, "robdoerootauthority_storage")
        os.makedirs(target_dir, exist_ok=True)
        print(f"[+] Found writable external storage at: {target_dir}")
        
        # Move heavy directories (.cargo, .ollama, pip cache) to SD card to save internal storage
        home_dir = os.path.expanduser("~")
        
        for folder in [".cargo", ".ollama"]:
            src = os.path.join(home_dir, folder)
            dst = os.path.join(target_dir, folder)
            if os.path.exists(src) and not os.path.islink(src):
                print(f"[*] Migrating {folder} to SD card...")
                if os.path.exists(dst):
                    subprocess.run(["rm", "-rf", dst])
                subprocess.run(["mv", src, dst])
                os.symlink(dst, src)
                print(f"[+] Linked {src} -> {dst}")
                
        print("[+] External SD storage successfully bound and configured!")
    else:
        print("[!] Could not automatically map SD card. Run 'termux-setup-storage' or check path mounts.")
        
    print("================================================================")

if __name__ == "__main__":
    force_mount_sd()
