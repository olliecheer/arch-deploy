#!/bin/bash
set -e
set -x

set_timezone() {
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    hwclock --systohc
}

set_locale() {
    sed -e 's/^#en_GB.UTF-8 UTF-8$/en_GB.UTF-8 UTF-8/' /etc/locale.gen
    echo 'LANG=en_GB.UTF-8'
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

auto_bootup() {
    # enable iwd by hand if needed
    # because target machine may not use wireless interface
    # systemctl enable iwd
    sysetmctl systemd-resolved.service
    systemctl enable dhcpcd
}

set_root_passwd() {
    passwd
}

set_grub() {
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux
    grub-mkconfig -o /boot/grub/grub.cfg
}
