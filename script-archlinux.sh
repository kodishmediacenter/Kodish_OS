#!/bin/bash

set -e

# Teclado ABNT2 e NTP
loadkeys br-abnt2
timedatectl set-ntp true

# Particionamento em UEFI (APAGA TUDO EM /dev/sda)
echo "Particionando disco /dev/sda..."
parted /dev/sda --script mklabel gpt
parted /dev/sda --script mkpart ESP fat32 1MiB 513MiB
parted /dev/sda --script set 1 esp on
parted /dev/sda --script mkpart primary ext4 513MiB 100%

# Formatação
mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

# Montagem
mount /dev/sda2 /mnt
mkdir /mnt/boot
mkdir /mnt/boot/efi
mount /dev/sda1 /mnt/boot/efi

# Mirrorlist BR
pacman -Sy --noconfirm reflector
reflector --country Brazil --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

# Instalação básica
pacstrap /mnt base linux linux-firmware sudo vim networkmanager grub efibootmgr

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Configuração dentro do sistema
arch-chroot /mnt /bin/bash <<EOF
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
echo "archlinux" > /etc/hostname

# NetworkManager
systemctl enable NetworkManager

# Usuário padrão
useradd -m -G wheel -s /bin/bash camila
echo "camila:123456" | chpasswd
echo "root:root" | chpasswd

# Sudo
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel

# GRUB UEFI
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
EOF

echo "Instalação concluída com sucesso! Pode reiniciar."
