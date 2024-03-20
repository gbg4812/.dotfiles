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
fi

read -p "do you want to install lazygit? (Y/n) " ans
if [[ $ans == "Y" ]]; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
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

read -p "do you want to install wezterm config dependencys: Fira Code" ans
if [[ $ans == "Y" ]]; then
    sudo apt install fonts-firacode
fi

read -p "do you want to install tmux config dependencys: tpm" ans
if [[ $ans == "Y" ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm/tpm
fi

read -p "were would you like to keep your projects? (default ~/Projects) " prj
if [[ -z $prj ]]; then 
	prj=$(echo ~/Projects)
fi

if ! [[ -d $prj ]]; then 
	echo "creating $prj folder..."
	mkdir $prj
fi
