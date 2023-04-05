#!/bin/bash
set -e
set -x

WORKDIR=$(readlink -f $(pwd))

install() {
    sudo pacman -S --noconfirm --needed "$@"
}

aur_install() {
    if [[ $(id -u) -eq 0 ]]; then
        echo "please run aur_install as normal user"
        exit 1
    fi
    yay -S --noconfirm --needed "$@"
}

VIDEO=(
    mesa vulkan-intel xf86-video-intel
    )

SOUND=(
    alsa alsa-utils pavucontrol pulseaudio
    )

FS=(
    ntfs-3g fuse gvfs
    )

CMDLINE=(
    alacritty
    bash-completion openssh tmux
    mlocate man-db man-pages
    ranger python-pdftotext highlight
    tree which wget curl
    clash
    )

QEMU=(
    qemu libvirt dmidecode dnsmasq bridge-utils
    )

COMPRESS=(
    tar zip unzip unrar
    )

COMPILER=(
    gcc make bear cmake gdb meson ninja
    clang llvm lldb
    python-pip
    )

BUILD_TOOLS=(
    pkgconf fakeroot
    flex bison bc
    )

NEOVIM=(
    neovim bash-language-server nodejs npm ripgrep
    )

WM=(
    sway swayidle waybar swaybg
    wdisplays
    dunst
    picom brightnessctl kanshi
    grim wl-clipboard
    clipman
    slurp swappy
    )

GUI_VIEWER=(
    mousepad
    zathura zathura-pdf-mupdf zathura-djvu
    )

FONTS=(
    ttf-dejavu ttf-roboto noto-fonts
    nerd-fonts-complete
    noto-fonts-cjk adobe-source-han-sans-cn-fonts
    adobe-source-han-serif-cn-fonts
    )

CN_FONTS=(
    wqy-microhei wqy-microhei-lite wqy-zenhei
    )

pacman_install() {
    install "${VIDEO[@]}"
    install "${SOUND[@]}"
    install "${FS[@]}"
    install "${CMDLINE[@]}"
    install "${QEMU[@]}"
    install "${COMPRESS[@]}"
    install "${COMPILER[@]}"
    install "${BUILD_TOOLS[@]}"
    install "${NEOVIM[@]}"
    sudo ln -sf /usr/bin/nvim /usr/bin/vim
    install "${WM[@]}"
    install "${GUI_VIEWER[@]}"
    install "${FONTS[@]}"
    install "${CN_FONTS[@]}"
}

set_mirror() {
    npm config set registry https://registry.npmmirror.com
    npm config get registry

    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
    pip config get global.index-url
}

config_deploy() {
    ln -sf $WORKDIR/material/bashrc ~/.bashrc

    sudo mkdir -p ~/.config
    ln -sf $WORKDIR/material/config/alacritty ~/.config/
    ln -sf $WORKDIR/material/config/sway ~/.config
    ln -sf $WORKDIR/material/config/waybar ~/.config
    ln -sf $WORKDIR/material/config/swappy ~/.config/
    ln -sf $WORKDIR/material/config/zathura ~/.config/
    if [[ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]]; then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim\
            ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    fi
    ln -sf $WORKDIR/material/config/nvim ~/.config/
    ln -sf $WORKDIR/material/config/clangd ~/.config/

    mkdir -p ~/.local/share
    ln -sf $WORKDIR/material/wallpaper ~/.local/share/

    mkdir -p ~/.local/bin
    ln -sf $WORKDIR/material/bin/blurlock ~/.local/bin/
    ln -sf $WORKDIR/material/bin/screenshot ~/.local/bin/

    sudo mkdir -p /etc/clash
    sudo ln -sf $WORKDIR/material/etc/clash/Country.mmdb /etc/clash/
    sudo ln -sf $WORKDIR/material/etc/clash/clash.service /etc/systemd/system/

    sudo ln -sf $WORKDIR/material/etc/asound.conf /etc/
}

auto_start() {
    sudo systemctl enable systemd-resolved.service
    sudo systemctl start systemd-resolved.service
    sudo systemctl enable dhcpcd
    sudo systemctl start dhcpcd
    sudo systemctl enable clash
    sudo systemctl restart clash
}

# AUR_INSTALL=(
#     microsoft-edge-stable-bin
#     swaylock-effects rofi-lbonn-wayland-only-git
#     )

# aur_install "${AUR_INSTALL[@]}"
