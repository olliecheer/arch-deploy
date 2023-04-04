#!/bin/bash
set -e
set -x

cat <<EOF
Please make the check list is satisified:
1. mount your root partition to /mnt
2. mount your boot partition to /mnt/boot
3. swapon your linux-swap partition if needed
4. network is available
EOF

read -p "Press y to continue: " input

if [[ ! "$input" == "y" ]]; then
    echo "canceled."
    exit
fi

echo 'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

pacstrap /mnt base linux linux-firmware neovim iwd dhcpcd \
    grub efibootmgr os-prober

genfstab -U /mnt >> /mnt/etc/fstab

cp ./material/chroot-do-install.sh /mnt/tmp/ 

arch-chroot /mnt bash /tmp/chroot-do-install.sh
