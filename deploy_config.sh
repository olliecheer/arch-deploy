#!/bin/bash
set -e
set -x

WORKDIR=$(readlink -f $(pwd))

reachable() {
    for it in "$@"; do
        if [[ ! $(which $it) ]]; then
            echo ">> $it is not reachable"
            return 1
        fi
    done
}

neovim_config() {
    if [[ $(reachable node) || $(reachable nodejs) ]] &&
        [[ $(reachable nvim rg clangd) ]];then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim\
            ~/.local/share/nvim/site/pack/packer/start/packer.nvim
        mkdir -p ~/.config
        ln -sf $WORKDIR/material/config/nvim ~/.config/
        ln -sf $WORKDIR/material/config/clangd ~/.config/
        echo ">> neovim config deployment done."
        echo ">> exec :PackerSync in nvim to install extensions"
    else
        exit 1
    fi
}

wm_config() {
    if [[ $(reachable sway waybar) ]]; then
        mkdir -p ~/.config
        ln -sf $WORKDIR/material/config/sway ~/.config
        ln -sf $WORKDIR/material/config/waybar ~/.config
    else
        exit 1
    fi
}

clash_config() {
    if [[ $(reachable clash) ]]; then
        sudo mkdir -p /etc/clash
        sudo ln -sf $WORKDIR/material/etc/clash/Country.mmdb /etc/clash/
        sudo ln -sf $WORKDIR/material/etc/clash/clash.service /etc/systemd/system/
        systemctl enable clash
        systemctl restart clash
    else
        exit 1
    fi
}

zathura_config() {
    if [[ $(reachable zathura) ]]; then
        sudo mkdir -p ~/.config
        ln -sf $WORKDIR/material/config/swappy ~/.config/
    fi
}

alacritty_config() {
    if [[ $(reachable alacritty) ]]; then
        sudo mkdir -p ~/.config
        ln -sf $WORKDIR/material/config/alacritty ~/.config/
    fi
}

wallpaper_deploy() {
    mkdir -p ~/.local/share
    ln -sf $WORKDIR/material/wallpaper ~/.local/share/
}

blurlock_deploy() {
    ln -sf $WORKDIR/material/bin/blurlock ~/.local/bin/
    ln -sf $WORKDIR/material/bin/screenshot ~/.local/bin/
}

mirror_npm() {
    npm config set registry https://registry.npmmirror.com
    npm config get registry
}

mirror_pip() {
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
    pip config get global.index-url
}
