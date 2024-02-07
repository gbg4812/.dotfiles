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

        if [[ $ans == "Y" ]]; then
            rm -rf $tpath/$fname
            ln -s $fpath $tpath
        fi
    else 
        ln -s $fpath $tpath
    fi
}

link "$wdir/wezterm" "$HOME/.config"
link "$wdir/tmux" "$HOME/.config"
link "$wdir/.bashrc" "$HOME"
link "$wdir/.bash_aliases" "$HOME"
link "$wdir/.gitconfig" "$HOME"
link "$wdir/.tmux-cht-languages" "$HOME"
link "$wdir/.tmux-cht-command" "$HOME"

read -p "do you want to install nvim config in ~/.config? (Y/n) " ans
if [[ $ans == "Y" ]]; then
	curr=$PWD
	cd ~/.config
	git clone https://github.com/gbg4812/nvim.git
	cd $curr
fi


read -p "do you want to install the bin repository to ~/bin? (Y/n) " ans
if [[ $ans == "Y" ]]; then
	curr=$PWD
	cd ~
	git clone https://github.com/gbg4812/bin.git
	cd $curr
fi

read -p "do you want to install liked packages: fzf ripgrep cmake make curl tmux neovim? (Y/n) " ans
if [[ $ans == "Y" ]]; then
	sudo apt install fzf
	sudo apt install ripgrep
	sudo apt install tmux
    sudo apt install cmake
    sudo apt install make
    sudo apt install curl

    sudo snap install neovim
fi

read -p "do you want to install flatpak and wezterm with it? (Y/n) " ans
if [[ $ans == "Y" ]]; then
    sudo apt install flatpak
    flatpak install flathub org.wezfurlong.wezterm
fi

read -p "do you want to install nvim config dependencys: npm node" ans
if [[ $ans == "Y" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    bash -c "nvm install node"
fi

read -p "were would you like to keep your projects? (default ~/Projects) " prj
if [[ -z $prj ]]; then 
	prj=$(echo ~/Projects)
fi

if ! [[ -d $prj ]]; then 
	echo "creating $prj folder..."
	mkdir $prj
fi
