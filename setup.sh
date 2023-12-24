#!/bin/bash

script=$(realpath $0)
wdir=$(dirname $script)

confd="$HOME/.config"

link() {
    fpath=$(realpath $1)
    fname=$(basename $fpath)
    tpath=$(realpath $2)
    if [[ -e $fpath ]]; then
        read -p "You want to replace $tpath/$fname? (Y/n) " ans

        if [[ ans -eq y ]]; then
            rm -rf $tpath/$fname
            ln -s $fpath $tpath
        fi
    else 
        ln -s $fpath $tpath
    fi
}

link "$wdir/wezterm" "$HOME/.config"
link "$wdir/nvim" "$HOME/.config"
link "$wdir/tmux" "$HOME/.config"
link "$wdir/.bashrc" "$HOME"
link "$wdir/.bash_aliases" "$HOME"
link "$wdir/.gitconfig" "$HOME"
