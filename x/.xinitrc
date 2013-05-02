#!/bin/bash


if [[ "$HOST" = "holodeck" ]]; then
    #Because it's a VM
    sudo VBoxClient-all &
fi

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources


#And our sound:
/usr/bin/start-pulseaudio-x11 &

# Fix dropbox issues without wifi
sleep 20 && dropbox stop && dropbox start &

xfce4-power-manager & 

nm-applet &

exec /usr/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
