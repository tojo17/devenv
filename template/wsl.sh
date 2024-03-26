# WSL commands
# {[ win_home ]} is a placeholder for the Windows home directory path
# sync ssh keys with windows
rsync -avq --delete --chmod=600 {[win_home]}/.ssh ~
# use windows ssh-agent
export SSH_AUTH_SOCK={[win_home]}/ssh-agent.sock
# change windows dir color under ls
# dark gray for 256 terminals
export LS_COLORS="$LS_COLORS:ow=34;48;5;233:"
# black for ANSI terminal
# export LS_COLORS="$LS_COLORS:ow=34;40:"

