#!/bin/zsh


# if [[ "$HOST" = "holodeck" ]]; then
    #Because it's a VM
    sudo VboxClient-all &
# fi

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources



exec /usr/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
