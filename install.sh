#!/bin/bash
#
# Installs all scripts in this repository using symlinks.
#
# Will put sudo in front of every command if needed. Set the do_root flag to
# false to disable any action that would need sudo. This will only install files
# into the user's home directory.
#
# Script originally from chozo aka koenk:
# https://github.com/koenk/configs/blob/master/install.sh

# Few basic options
do_root=false
do_remove=false
do_global=false
no_global=false


is_server=true
make_backups=false
root_homedir="/root"

if [ -n "$1" ]; then
    if [ "$1" == "global" ]; then
        do_global=true
        do_root=true
        if [ -n "$2" ]; then
            if [ "$2" == "remove" ]; then
                do_remove=true
            fi
        fi
        if ! $do_remove; then
            echo " :: Copying all files globally"
        else
            echo " :: Removing all the global files"
        fi
    elif [ "$1" == "noglobal" ]; then
        no_global=true;
        if [ -n "$2" ]; then
            if [ "$2" == "remove" ]; then
                do_remove=true
                if [ -n "$3" ]; then
                    HOME="/home/$3"
                    do_root=true
                fi
            else
                HOME="/home/$2"
                do_root=true
            fi
        fi
        if ! $do_remove; then
            echo " :: Only copying the files that have no global dir to $HOME"
        else
            echo " :: Removing non-global files from $HOME"
        fi
    elif [ "$1" == "root" ]; then
        do_root=true
        HOME=$root_homedir
    elif [ "$1" == "remove" ]; then
        do_remove=true
        if [ -n "$2" ]; then
            HOME="/home/$2"
            do_root=true
        fi
        echo " :: Removing all files from $HOME"
    else
        HOME="/home/$1"
        do_root=true
    fi
fi


# Where are all destinations located
zshrc="$HOME/.zshrc"
zshrc_global="/etc/zsh/zshrc"

vimrc="$HOME/.vimrc"
vimrc_global="/etc/vimrc"
vimdir="$HOME/.vim"

tmux="$HOME/.tmux.conf"
tmux_global="/etc/tmux.conf"

compiz="$HOME/.config/compiz"
#No global

zkbd="$HOME/.zkbd"
#No global

htop="$HOME/.config/htop"
#No global


# How are the files called in the repository
local_dir="$( cd "$( dirname "$0" )" && pwd)"
zshrc_local="$local_dir/zsh/.zshrc"
vimrc_local="$local_dir/vim/vimrc"
vimdir_local="$local_dir/vim/vim"
tmux_local="$local_dir/tmux/.tmux.conf"
compiz_local="$local_dir/compiz/"
zkbd_local="$local_dir/zkbd/"
htop_local="$local_dir/htop/"

function do_install() {
    # Sudo stuff
    cmd_prefix=""
    if [ $# -eq 3 ]; then
        if ! $do_root; then
            echo " :: Ignoring root file $2"
            return
        else
            cmd_prefix="sudo "
        fi
    else
        if $do_root; then #For when root might be needed to copy the files
            cmd_prefix="sudo "
        fi
    fi

    echo " :: Installing $1 as $2"

    # File already exists?
    if $cmd_prefix [ -e $2 ]; then
       echo " :: File exists $2" 
	    if $make_backups; then
            cmd="mv "$2" "$2.bak""
        else
            if [ -d $2 ]; then
                cmd="rm -rf "$2""
            else
                cmd="rm -f "$2""
            fi
        fi
        echo "$cmd_prefix$cmd"
        $($cmd_prefix$cmd)
    fi

    cmd="ln -sT "$1" "$2""
    echo "$cmd_prefix$cmd"
    $($cmd_prefix$cmd)
}

function do_remove(){
    cmd_prefix=""
    if $do_root; then
        cmd_prefix="sudo "
    fi

    # File already exists?
    if $cmd_prefix [ -e $1 ]; then
        echo " :: File exists $1" 
        if [ -d $1 ]; then
            cmd="rm -rf "$1""
        else
            cmd="rm -f "$1""
        fi
        echo "$cmd_prefix$cmd"
        $($cmd_prefix$cmd)
    fi
}

if [ $do_global == true ]; then
    if ! $do_remove; then
        do_install "$zshrc_local" "$zshrc_global" "root"
        do_install "$vimrc_local" "$vimrc_global" "root"
        do_install "$tmux_local" "$tmux_global" "root"
        echo ""
        echo " :: Done copying. Please keep in mind that you need to run "
        echo " :: 'install.sh noglobal' to copy these files:"
        echo "    - zkbd config"
        echo "    - Vimdir. This file cannot be copied globally!"
        echo "    - Htop config."
        if ! $is_server ; then
            echo "    - compiz config"
        fi
    else
        do_remove "$zshrc_global"
        do_remove "$vimrc_global"
        do_remove "$tmux_global"
        echo ""
        echo " :: Done removing. Please keep in mind that you need to run"
        echo " :: 'install.sh noglobal remove' to remove these files:"
        echo "    - zkbd config"
        echo "    - Vimdir"
        echo "    - Htop config"
        if ! $is_server ; then
            echo "    - compiz config"
        fi
    fi
elif [ $no_global == true ]; then
    if ! $do_remove; then
        do_install "$zkbd_local" "$zkbd"
        do_install "$vimdir_local" "$vimdir"
        do_install "$htop_local" "$htop"
        if ! $is_server; then
            do_install "$compiz_local" "$compiz"
        fi
        echo ""
        echo " :: Done installing."
    else
        do_remove "$zkbd"
        do_remove "$vimdir"
        do_remove "$htop"
        if ! $is_server; then
            do_remove "$compiz"
        fi
        echo ""
        echo " :: Done removing."
    fi
else
    if ! $do_remove; then
        do_install "$zshrc_local" "$zshrc" 
        do_install "$vimrc_local" "$vimrc"
        do_install "$vimdir_local" "$vimdir"
        do_install "$tmux_local" "$tmux" 
        do_install "$zkbd_local" "$zkbd"
        do_install "$htop_local" "$htop"
        if ! $is_server; then
            do_install "$compiz_local" "$compiz"
        fi
        echo ""
        echo " :: Done installing files to $HOME"
    else
        do_remove "$zshrc"
        do_remove "$vimrc"
        do_remove "$vimdir"
        do_remove "$tmux"
        do_remove "$zkbd"
        do_remove "$htop"
        if ! $is_server; then
            do_remove "$compiz"
        fi
        echo ""
        echo " :: Done removing files from $HOME"
    fi
fi

# do_install "$local_bashrc" "$bashrc"
# do_install "$local_bashrc" "$bashrc_root" "root"
# do_install "$local_vimrc" "$vimrc"
# do_install "$local_vimrc" "$vimrc_root" "root"
# do_install "$local_vimdir" "$vimdir"
# do_install "$local_vimdir" "$vimdir_root" "root"
# do_install "$local_tmux" "$tmux" "root"
# do_install "$local_xresources" "$xresources"
# do_install "$local_awesomerc" "$awesomerc"
