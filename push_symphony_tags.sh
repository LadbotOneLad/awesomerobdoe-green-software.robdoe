cat << 'EOF' > push_symphony_tags.sh
#!/bin/bash

echo "[+] Preparing Symphony Tag Suite..."

# Ensure we are on the main active branch
current_branch=$(git branch --show-current)
if [ -z "$current_branch" ]; then
    current_branch="main"
fi

echo "[+] Working on branch: $current_branch"

# Drop and recreate the Symphony Emoji Tags (Tags 4, 5, 6) locally
git tag -f "tag-4-🔌🔥💎🚀" > /dev/null 2>&1
git tag -f "tag-5-🌐🛡️⚡🔮" > /dev/null 2>&1
git tag -f "tag-6-🧬⚛️🔮⚓" > /dev/null 2>&1

echo "[+] Local Symphony tags synchronized."

# Push branch and force-push all tags upstream
echo "[+] Pushing branch and Symphony tag symphony upstream..."
git push origin "$current_branch" --force-with-lease
git push origin --tags --force

echo "[+] Symphony push complete."
EOF

chmod +x push_symphony_tags.sh
./push_symphony_tags.sh
