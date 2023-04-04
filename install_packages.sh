#!/bin/bash
set -e
set -x

install() {
    sudo pacman -S --noconfirm --needed "$@"
}

prepare_aur() {
    read -d '' ARCHLINUXCN <<EOF || true
[archlinuxcn]
Server = https://mirrors.aliyun.com/archlinuxcn/\$arch
EOF

    if [[ ! $(grep -qxF '[archlinuxcn]' /etc/pacman.conf) ]]; then
        echo ">> [archlinuxcn] is already set in /etc/pacman.conf"
    else
        sudo echo "$ARCHLINUXCN" > /etc/pacman.conf
        echo ">> [archlinuxcn] appended"
    fi

    sudo rm -rf /etc/pacman.d/gnupg
    install archlinuxcn-keyring
    sudo pacman-key --init
    sudo pacman-key --polulate archlinux
    sudo pacman-key --polulate archlinuxcn
    install yay
}

aur_install() {
    if [[ $(id -u) == "0" ]]; then
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

deploy_asound() {

}

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
    tree which
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
    )

install_languages() {
    install "${COMPILER[@]}"
}

BUILD_TOOLS=(
    pkg-config
    flex bison bc
    )

install_build_tools() {
    install "${BUILD_TOOLS[@]}"
}

NEOVIM=(
    neovim bash-language-server 
    )

install_neovim() {
    install "${NEOVIM[@]}"
}

WM=(
    sway swayidle waybar wdisplays dunst
    picom brightnessctl kanshi
    grim wl-clipboard clipman slurp swappy
    )

GUI_VIEWER=(
    mousepad
    zathura zathura-pdf-mupdf zathura-djvu
    )

FONTS=(
    ttf-dejavu ttf-roboto noto-fonts nerd-fonts-complete
    noto-fonts-cjk adobe-source-han-sans-cn-fonts
    adobe-source-han-serif-cn-fonts
    )

CN_FONTS=(
    wqy-microhei wqy-microhei-lite wqy-zenhei
    )

BROWSER=(
    microsoft-edge-stable-bin
    )

install_desktop() {
    install "${WM[@]}"
    install "${GUI_VIEWER[@]}"
    install "${FONTS[@]}"
    install "${CN_FONTS[@]}"
    aur_install "${BROWSER[@]}"
}


install_basic
install_comandline
install_languages
install_neovim
install_desktop

prepare_aur

aur_install swaylock-effects rofi-lbonn-wayland-only-git
