#!/bin/bash

MODEL="llama3" # Change to your preferred local ollama model if needed
CURRENT_DATE=$(date -u +"%Y-%m-%d")

echo "[+] Scanning workspace for deleted or uncommitted state to recycle through Ollama..."

find . -type d -name ".git" | while read -r repo_dir; do
    repo_path=$(dirname "$repo_dir")
    echo "--------------------------------------------------"
    echo "[*] Processing repo: $repo_path"
    
    cd "$repo_path" || continue

    # Check git reflog or recent history for deleted files
    deleted_files=$(git status --porcelain | grep "^ D" | cut -c4-)
    
    if [ -n "$deleted_files" ]; then
        echo "[+] Found deleted files to reconstruct via Ollama:"
        echo "$deleted_files"

        for file in $deleted_files; do
            echo "[*] Regenerating content for: $file"
            
            # Extract historical context or diff before deletion
            old_content=$(git show HEAD:"$file" 2>/dev/null || echo "New or untracked file structure")
            
            # Prompt Ollama to reconstruct and optimize the deleted content
            prompt="Reconstruct, refactor, and improve the following code/content for '$file' to make it clean, functional, and production-ready. Return only the raw content/code without markdown wrappers:\n\n$old_content"
            
            ollama run "$MODEL" "$prompt" > "$file"
            echo "[+] Successfully regenerated: $file"
        done

        # Stage and commit the recycled files
        git add .
        git commit -m "refactor: recycle and regenerate deleted work via Ollama on $CURRENT_DATE"
        
        current_branch=$(git branch --show-current)
        if [ -z "$current_branch" ]; then
            current_branch="main"
        fi

        git push origin "$current_branch" --force-with-lease
        echo "[+] Pushed recycled changes upstream for $repo_path"
    else
        echo "[+] No deleted files pending recycling in $repo_path."
    fi

    cd - > /dev/null || exit
done

echo "--------------------------------------------------"
echo "[+] Ollama workspace recycling complete."
