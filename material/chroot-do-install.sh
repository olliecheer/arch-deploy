#!/bin/bash
set -e
set -x

set_timezone() {
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc
}


set_locale() {
	#sed -i -e 's/^#\(en_GB.UTF-8 UTF-8$\)/en_GB.UTF-8 UTF-8/' /etc/locale.gen
    sed -i -e 's/^#\(en_GB.UTF-8 UTF-8\)/\1/' /etc/locale.gen 
    echo 'LANG=en_GB.UTF-8' > /etc/locale.conf
    locale-gen
}


set_hostname() {
    echo "Arch" > /etc/hostname
}

set_hosts() {
    cat <<EOF >/etc/hosts
127.0.0.1	localhost
::1			localhost	ip6-localhost	ip6-loopback
127.0.1.1 	Arch.localdomain	Arch
ff02::1		ip6-allnodes
ff02::2		ip6-allrouters
EOF
}

set_user() {
    passwd root
    read -p "Press y to create a normal user: " input
    if [[ ! "$input" == "y" ]]; then
        read -p "Input username: " username
        useradd -m $username
        passwd ollie
    fi
}

set_grub() {
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux
    grub-mkconfig -o /boot/grub/grub.cfg
}

setup_package_manager() {
    echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

    read -d '' ARCHLINUXCN <<EOF || true
[archlinuxcn]
Server = https://mirrors.aliyun.com/archlinuxcn/\$arch
EOF

    if $(grep -qxF '[archlinuxcn]' /etc/pacman.conf); then
        echo ">> [archlinuxcn] is already set in /etc/pacman.conf"
    else
        sudo echo "$ARCHLINUXCN" >> /etc/pacman.conf
        echo ">> [archlinuxcn] appended"
    fi

    pacman -Sy
    rm -rf /etc/pacman.d/gnupg
    pacman-key --init
    pacman-key --populate archlinux
    pacman -S --noconfirm --needed archlinuxcn-keyring
    pacman-key --populate archlinuxcn
    pacman -S --noconfirm --needed yay
}


set_timezone
set_locale
set_hostname
set_hosts
set_user
set_grub
setup_package_manager
