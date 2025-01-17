#!/bin/bash

script=$(realpath $0)
wdir=$(dirname $script)

confd="$HOME/.config"
confirm="[Y/n]"

term="kitty"
shell="zsh"

# auto detect package manager
if apt moo >/dev/null 2>/dev/null; then
    install_cmd="apt-get install"
elif dnf >/dev/null 2>/dev/null; then
    install_cmd="dnf install"
elif pacman -h >/dev/null 2>/dev/null; then
    install_cmd="pacman -S"
else
    echo "$install_cmd not compatible!"
    exit 1
fi

echo "Detected package manager: "$install_cmd

read -p "witch terminal do you prefere? kitty(1) wezterm(2): " ans
if [[ $ans -eq 2 ]]; then
    term="wezterm"
fi

read -p "which shell do you prefere zsh(1) bash(2): " ans
if [[ $ans -eq 2 ]]; then
    shell="bash"
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

if [[ $shell = "bash" ]]; then
    link "$wdir/.bashrc" "$HOME"
    link "$wdir/.bash_aliases" "$HOME"
fi

if [[ $shell = "zsh" ]]; then
    sudo $install_cmd zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    rm -rf ~/.oh-my-zsh/custom/
    sudo $install_cmd gh
    gh auth login
    gh repo clone gbg4812/zsh_custom ~/.oh-my-zsh/custom/
fi

read -p "do you want to install nvim and config in ~/.config? $confirm " ans
if [[ $ans == "Y" ]]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    sudo ln -s /opt/nvim-linux64/bin/nvim /bin/
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

read -p "do you want to install liked packages: fzf ripgrep cmake make curl tmux git gh tree-sitter? (Y/n) " ans
if [[ $ans == "Y" ]]; then
    sudo $install_cmd fzf
    sudo $install_cmd ripgrep
    sudo $install_cmd tmux
    sudo $install_cmd cmake
    sudo $install_cmd make
    sudo $install_cmd curl
    sudo $install_cmd git
    sudo $install_cmd github-cli
    sudo $install_cmd tree-sitter
    if [[ -z "${DISPLAY+x}" ]]; then
        sudo $install_cmd xclip
    elif [[ -z "$((WAYLAND_DISPLAY + x))" ]]; then
        sudo $install_cmd wl-clipboard
    fi
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
    sudo $install_cmd flatpak
    if [[ $term == "wezterm" ]]; then
        echo "if you want to install wezterm run: flatpak install flathub org.wezfurlong.wezterm"
    fi
fi

read -p "do you want to install nvim config dependencys: npm node (Y/n) " ans
if [[ $ans == "Y" ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    nvm install node
fi

read -p "do you want to install tmux config dependencys: tpm (Y/n) " ans
if [[ $ans == "Y" ]]; then
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm/
fi
