#!/bin/bash
set -e

WORKDIR=$(readlink -f $(pwd))


#sudo echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
#
#sudo sed -i -e 's/^#\(en_GB.UTF-8 UTF-8\)/\1/' /etc/locale.gen
#sudo echo 'LANG=en_GB.UTF-8' > /etc/locale.conf
#sudo locale-gen
#
#read -d '' ARCHLINUXCN <<EOF || true
#[archlinuxcn]
#Server = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
#EOF
#
#if $(grep -qxF '[archlinuxcn]' /etc/pacman.conf); then
#	echo ">> [archlinuxcn] is already set in /etc/pacman.conf"
#else
#	sudo echo "$ARCHLINUXCN" >> /etc/pacman.conf
#	echo ">> [archlinuxcn] appended"
#fi
#
#sudo pacman -Sy
#sudo rm -rf /etc/pacman.d/gnupg
#sudo pacman-key --init
#sudo pacman-key --populate archlinux
#sudo pacman -S --noconfirm --needed archlinuxcn-keyring
#sudo pacman-key --populate archlinuxcn
#sudo pacman -S --noconfirm --needed yay
#
#
#install() {
#    sudo pacman -S --noconfirm --needed "$@"
#}
#
#aur_install() {
#    if [[ $(id -u) -eq 0 ]]; then
#        echo "please run aur_install as normal user"
#        exit 1
#    fi
#    yay -S --noconfirm --needed "$@"
#}
#
#
#CMDLINE=(
#    bash-completion openssh tmux
#    mlocate man-db man-pages
#    ranger python-pdftotext highlight
#    tree which wget curl
#)
#
#COMPRESS=(
#    tar zip unzip unrar
#)
#
#COMPILER=(
#    gcc make bear cmake gdb meson ninja
#    clang llvm lldb
#    python-pip
#)
#
#
#NEOVIM=(
#    neovim bash-language-server nodejs npm ripgrep
#    )
#
#install "${CMDLINE[@]}"
#install "${COMPRESS[@]}"
#install "${COMPILER[@]}"
#install "${NEOVIM[@]}"
#
#
#npm config set registry https://registry.npmmirror.com
#npm config get registry
#
#pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
#pip config get global.index-url


ln -sf $WORKDIR/material/bashrc ~/.bashrc
ln -sf $WORKDIR/material/bash_profile ~/.bash_profile
ln -sf $WORKDIR/material/config/tmux ~/.config/

if [[ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
	git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	    ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

ln -sf $WORKDIR/material/config/nvim ~/.config/
ln -sf $WORKDIR/material/config/clangd ~/.config/
