#!/bin/bash
set -e

# Get script's directory for relative paths
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# pull latest
echo "Pulling latest updates..."
if ! git -C "$SELF_DIR" pull; then
    echo "Warning: Failed to pull latest updates"
fi

# generate rc file
SCRIPT_DIR="$SELF_DIR/template"

# if bash
if [ -n "$BASH_VERSION" ]; then
    echo "bash detected"
    RC_FILE=$SCRIPT_DIR/rc_bash.sh
    OUTFILE=~/.devbashrc
fi
# if zsh
if [ -n "$ZSH_VERSION" ]; then
    echo "zsh detected"
    RC_FILE=$SCRIPT_DIR/rc_zsh.sh
    OUTFILE=~/.devzshrc
fi

# if OUTFILE is not set, exit
if [ -z "$OUTFILE" ]; then
    echo "Shell not supported or not detected"
    exit 1
fi


echo "Generating $OUTFILE"
# Check if files exist before trying to read them
if [ ! -f "$RC_FILE" ]; then
    echo "Error: RC file $RC_FILE not found"
    exit 1
fi

if [ ! -f "$SCRIPT_DIR/aliases.sh" ]; then
    echo "Error: aliases.sh not found"
    exit 1
fi

# Create temporary file to avoid partial writes
TEMP_OUTFILE="${OUTFILE}.tmp"

# Write to temporary file first
cat "$RC_FILE" >| "$TEMP_OUTFILE" || { echo "Error writing to $TEMP_OUTFILE"; exit 1; }
echo "" >> "$TEMP_OUTFILE" || { echo "Error appending to $TEMP_OUTFILE"; exit 1; }
cat "$SCRIPT_DIR/aliases.sh" >> "$TEMP_OUTFILE" || { echo "Error appending aliases to $TEMP_OUTFILE"; exit 1; }
echo "" >> "$TEMP_OUTFILE" || { echo "Error appending to $TEMP_OUTFILE"; exit 1; }
# check if WSL
if [ -f "/proc/version" ] && grep -iq Microsoft /proc/version; then
    echo "WSL detected"
    
    # Check if wsl.sh exists
    if [ ! -f "$SCRIPT_DIR/wsl.sh" ]; then
        echo "Error: wsl.sh not found"
        exit 1
    fi
    
    # get windows home path
    WIN_HOME=""
    if ! WIN_HOME_RAW=$(powershell.exe -NoProfile -NonInteractive -Command "\$Env:UserProfile" 2>/dev/null); then
        echo "Error getting Windows home path"
        exit 1
    fi
    
    # Clean and sanitize the Windows path
    WIN_HOME_CLEAN=$(echo "$WIN_HOME_RAW" | tr -d '\r')
    if [ -z "$WIN_HOME_CLEAN" ]; then
        echo "Error: Empty Windows home path"
        exit 1
    fi
    
    # Convert to WSL path with proper quoting
    if ! WIN_HOME=$(wslpath "$WIN_HOME_CLEAN" 2>/dev/null); then
        echo "Error converting Windows path"
        exit 1
    fi
    
    echo "Windows home path: $WIN_HOME"
    
    # Safely replace placeholder with WIN_HOME
    if ! sed "s|{\[win_home\]}|$WIN_HOME|g" "$SCRIPT_DIR/wsl.sh" >> "$TEMP_OUTFILE"; then
        echo "Error appending WSL configuration"
        exit 1
    fi
fi

# Move temp file to final location
if ! mv "$TEMP_OUTFILE" "$OUTFILE"; then
    echo "Error moving $TEMP_OUTFILE to $OUTFILE"
    exit 1
fi

# pull update for all plugins if exists
PLUGINS_DIR="$HOME/devenv-plugins"
mkdir -p "$PLUGINS_DIR"

# Use find instead of ls for better portability and handling
if [ -d "$PLUGINS_DIR" ] && [ "$(find "$PLUGINS_DIR" -maxdepth 1 -type d | wc -l)" -gt 1 ]; then
    echo "Updating plugins..."
    find "$PLUGINS_DIR" -maxdepth 1 -type d -not -path "$PLUGINS_DIR" | while read -r plugin_path; do
        plugin_name=$(basename "$plugin_path")
        # check if git repo
        if [ -d "$plugin_path/.git" ]; then
            echo "Updating plugin: $plugin_name"
            if ! git -C "$plugin_path" pull; then
                echo "Warning: Failed to update plugin $plugin_name"
            fi
        else
            echo "$plugin_name is not a git repo, skipping"
        fi
    done
else
    echo "No plugins found in $PLUGINS_DIR"
fi

echo "Update completed successfully"