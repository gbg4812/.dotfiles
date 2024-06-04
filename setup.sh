#!/bin/bash

script=$(realpath $0)
wdir=$(dirname $script)

confd="$HOME/.config"
confirm="[Y/n]"

term="kitty"

# auto detect package manager
if apt-get >/dev/null 2>/dev/null; then
	install_cmd="apt-get install"
elif dnf >/dev/null; then
	install_cmd="dnf install"
elif pacman >/dev/null; then
	install_cmd="pacman -S"
else
	echo "install_cmd not compatible!"
fi

echo "Detected package manager: "$install_cmd

read -p "witch terminal do you prefere? kitty(1) wezterm(2): " ans
if [[ $ans -eq 2 ]]; then
	term="wezterm"
fi

link() {
	fpath=$(realpath $1)
	fname=$(basename $fpath)
	tpath=$(realpath $2)
	if [[ -e $fpath ]] && [[ ! -L $fpath ]]; then
		read -p "You want to replace $tpath/$fname? $confirm " ans

		if [[ $ans == "Y" ]]; then
			rm -rf $tpath/$fname
			ln -s $fpath $tpath
		fi
	else
		ln -s $fpath $tpath
	fi
}

link "$wdir/$term" "$HOME/.config"
link "$wdir/tmux" "$HOME/.config"
link "$wdir/.bashrc" "$HOME"
link "$wdir/.bash_aliases" "$HOME"
link "$wdir/.tmux-cht-languages" "$HOME"
link "$wdir/.tmux-cht-command" "$HOME"

read -p "do you want to install nvim config in ~/.config? $confirm " ans
if [[ $ans == "Y" ]]; then
	read -p "whitch config? lazy(1) personal(2): " ans
	if [[ $ans -eq 1 ]]; then
		pushd ~/.config
		git clone https://github.com/gbg4812/lazynvim.git nvim/
		popd
	else
		pushd ~/.config
		git clone https://github.com/gbg4812/nvim.git
		popd
	fi
fi

read -p "do you want to install the bin repository to ~/bin? $confirm " ans
if [[ $ans == "Y" ]]; then
	curr=$PWD
	pushd ~
	git clone https://github.com/gbg4812/bin.git
	popd
fi

read -p "do you want to install liked packages: fzf ripgrep cmake make curl tmux git gh? (Y/n) " ans
if [[ $ans == "Y" ]]; then
	sudo $install_cmd install fzf
	sudo $install_cmd install ripgrep
	sudo $install_cmd install tmux
	sudo $install_cmd install cmake
	sudo $install_cmd install make
	sudo $install_cmd install curl
	sudo $install_cmd install git
	sudo $install_cmd install gh

fi

read -p "do you want to install lazygit? (Y/n) " ans
if [[ $ans == "Y" ]]; then
	LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
	curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
	tar xf lazygit.tar.gz lazygit
	sudo install lazygit /usr/local/bin
	echo "cleaning..."
	rm lazygit lazygit.tar.gz
fi

read -p "do you want to install flatpak? (Y/n) " ans
if [[ $ans == "Y" ]]; then
	sudo apt install flatpak
	echo "if you want to install wezterm run: flatpak install flathub org.wezfurlong.wezterm"
fi

read -p "do you want to install nvim config dependencys: npm node (Y/n) " ans
if [[ $ans == "Y" ]]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
	bash -c "nvm install node"
fi

read -p "do you want to install tmux config dependencys: tpm (Y/n) " ans
if [[ $ans == "Y" ]]; then
	git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm/
fi
