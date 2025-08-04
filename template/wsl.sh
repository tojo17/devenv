# WSL commands
# {[ win_home ]} is a placeholder for the Windows home directory path

# sync ssh keys with windows
# rsync -avq --delete --chmod=600 {[win_home]}/.ssh ~
# proxy windows ssh-agent
# export SSH_AUTH_SOCK={[win_home]}/ssh-agent.sock

# use windows OpenSSH binaries if they exist
for cmd in ssh-add ssh scp sftp; do
    if command -v ${cmd}.exe >/dev/null 2>&1; then
        alias $cmd="${cmd}.exe"
    else
        echo "Warning: ${cmd}.exe not found, alias not created"
    fi
done

# use windows git and gh if they exist
for cmd in git gh; do
    if command -v ${cmd}.exe >/dev/null 2>&1; then
        alias $cmd="${cmd}.exe"
    else
        echo "Warning: ${cmd}.exe not found, alias not created"
    fi
done

# change windows dir color under ls
# dark gray for 256 terminals
export LS_COLORS="$LS_COLORS:ow=34;48;5;233:"
# black for ANSI terminal
# export LS_COLORS="$LS_COLORS:ow=34;40:"

# cd to windows path - safely handle paths with spaces and special characters
cdw() {
    if [ -z "$1" ]; then
        echo "Usage: cdw <windows_path>"
        return 1
    fi
    
    local wsl_path
    # Handle errors from wslpath
    if ! wsl_path=$(wslpath "$1" 2>/dev/null); then
        echo "Error: Failed to convert Windows path: $1"
        return 1
    fi
    
    # Check if converted path exists or can be created
    if [ ! -d "$wsl_path" ]; then
        echo "Warning: Directory does not exist: $wsl_path"
    fi
    
    # Change to directory
    cd "$wsl_path" || return 1
}
