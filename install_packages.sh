#!/bin/bash
set -e
set -x

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

install_basic() {
    install "${VIDEO[@]}"
    install "${SOUND[@]}"
    install "${FS[@]}"
}

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

install_comandline() {
    install "${CMDLINE[@]}"
    install "${QEMU[@]}"
    install "${COMPRESS[@]}"
}


COMPILER=(
    gcc make bear cmake gdb meson ninja
    clang llvm lldb
    python-pip
    )

install_languages() {
    install "${COMPILER[@]}"
}

BUILD_TOOLS=(
    pkgconf fakeroot
    flex bison bc
    )

install_build_tools() {
    install "${BUILD_TOOLS[@]}"
}

NEOVIM=(
    neovim bash-language-server  nodejs npm 
    )

install_neovim() {
    sudo ln -sf /usr/bin/nvim /usr/bin/vim
    install "${NEOVIM[@]}"
}

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

install_desktop() {
    install "${WM[@]}"
    install "${GUI_VIEWER[@]}"
    install "${FONTS[@]}"
    install "${CN_FONTS[@]}"
    aur_install "${BROWSER[@]}"
}

AUR_INSTALL=(
    microsoft-edge-stable-bin
    swaylock-effects rofi-lbonn-wayland-only-git
    )


install_basic
install_comandline
install_languages
install_neovim
install_desktop
install_build_tools

aur_install "${AUR_INSTALL[@]}"
