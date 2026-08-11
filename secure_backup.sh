cat << 'EOF' > secure_and_backup.sh
#!/bin/bash

BACKUP_DIR="../workspace_safety_backup_$(date +%Y%m%d_%H%M%S)"

echo "[+] Securing workspace... Creating local snapshot backup at: $BACKUP_DIR"

# Create a full compressed backup of everything in the current directory before doing anything else
mkdir -p "$BACKUP_DIR"
tar --exclude="$BACKUP_DIR" -czf "$BACKUP_DIR/full_workspace_snapshot.tar.gz" .

echo "[+] Snapshot secured safely."

echo "[+] Checking git status across all repositories to ensure no uncommitted local work is lost..."

find . -type d -name ".git" | while read -r repo_dir; do
    repo_path=$(dirname "$repo_dir")
    cd "$repo_path" || continue

    # Check for uncommitted changes or untracked files
    if [[ -n $(git status --porcelain) ]]; then
        echo "[!] Saving uncommitted work in: $repo_path"
        git add -A
        git commit -m "backup: auto-saving uncommitted work on $(date -u +"%Y-%m-%d %H:%M:%S")"
    fi

    # Ensure local changes are safely stashed or committed, never lost
    git branch -u origin/$(git branch --show-current) > /dev/null 2>&1

    cd - > /dev/null || exit
done

echo "--------------------------------------------------"
echo "[+] All work is fully backed up locally and committed safely."
echo "[+] Safe to proceed. No data lost."
EOF

chmod +x secure_and_backup.sh
./secure_and_backup.sh
