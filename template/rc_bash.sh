# processing for all platforms
bind '"\C-h": backward-kill-word'
bind '"\e[3;5~": kill-word'
bind '"\e[1~": beginning-of-line'  # \e[1~ is often used for Home key
bind '"\e[4~": end-of-line'        # \e[4~ is often used for End key
bind '"\e[3~": delete-char'