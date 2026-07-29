import os
import subprocess
import sys

def verify_environment():
    print("[*] Initializing Pizzley Bear Architecture: Sovereign Axis Node...")
    print(f"[*] Active Environment: {os.environ.get('PREFIX')}")
    
    # Check core tools availability
    tools = ['hydra', 'sqlmap.py', 'nmap', 'tor']
    for tool in tools:
        path = subprocess.run(f"which {tool}", shell=True, capture_output=True, text=True)
        status = "ONLINE" if path.returncode == 0 else "OFFLINE/LOCAL"
        print(f"    - {tool}: {status}")

if __name__ == "__main__":
    verify_environment()
    print("[+] Sovereign Truth Engine operational parameters loaded.")
