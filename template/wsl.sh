# WSL commands
# {[ win_home ]} is a placeholder for the Windows home directory path

# sync ssh keys with windows
# rsync -avq --delete --chmod=600 {[win_home]}/.ssh ~
# proxy windows ssh-agent
# export SSH_AUTH_SOCK={[win_home]}/ssh-agent.sock

# use windows OpenSSH binaries
alias ssh-add='ssh-add.exe'
alias ssh='ssh.exe'
alias scp='scp.exe'
alias sftp='sftp.exe'

# use windows git
alias git='git.exe'
alias gh='gh.exe'

# change windows dir color under ls
# dark gray for 256 terminals
export LS_COLORS="$LS_COLORS:ow=34;48;5;233:"
# black for ANSI terminal
# export LS_COLORS="$LS_COLORS:ow=34;40:"

# functions for interactive shells only
if [[ $- == *i* ]]; then # if running interactively
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

    # fix network DNS configuration
    fixnet() {
        local resolv_conf="/etc/resolv.conf"
        
        # Get DNS servers from Windows and write to resolv.conf, then append options
        powershell.exe -c "Get-DnsClientServerAddress -AddressFamily IPv4|Select -ExpandProperty ServerAddresses" | tr -d "\r" | sed "s/^/nameserver /" | sudo tee "$resolv_conf" >/dev/null && \
        echo "options timeout:1 attempts:1 rotate" | sudo tee -a "$resolv_conf" >/dev/null && \
        echo "DNS configuration updated in $resolv_conf" || {
            echo "Error: Failed to update DNS configuration"
            return 1
        }
    }
fi
