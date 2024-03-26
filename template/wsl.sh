# WSL template
# {[win_home]} is a placeholder for the Windows home directory path
rsync -avq --delete --chmod=600 {[win_home]}/.ssh ~
export SSH_AUTH_SOCK={[win_home]}/ssh-agent.sock
