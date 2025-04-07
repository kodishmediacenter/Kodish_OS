#!/bin/bash

set -e

# Teclado e NTP
loadkeys br-abnt2
timedatectl set-ntp true

lsblk

# Pergunta o disco a ser usado
read -rp "Digite o disco para instalar (ex: /dev/sda, /dev/nvme0n1): " DISCO

# Confirmação
echo "⚠️  TODOS OS DADOS EM $DISCO SERÃO APAGADOS!"
read -rp "Deseja continuar? (s/N): " CONFIRMA
[[ "$CONFIRMA" != "s" && "$CONFIRMA" != "S" ]] && exit 1

# Particionamento UEFI
echo "Particionando $DISCO..."
parted "$DISCO" --script mklabel gpt
parted "$DISCO" --script mkpart ESP fat32 1MiB 513MiB
parted "$DISCO" --script set 1 esp on
parted "$DISCO" --script mkpart primary ext4 513MiB 100%

# Define partições
EFI="${DISCO}1"
ROOT="${DISCO}2"

# Formatação
mkfs.fat -F32 "$EFI"
mkfs.ext4 "$ROOT"

# Montagem
mount "$ROOT" /mnt
mkdir -p /mnt/boot/efi
mount "$EFI" /mnt/boot/efi

# Mirrorlist BR
pacman -Sy --noconfirm reflector
reflector --country Brazil --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

# Instalação base
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

systemctl enable NetworkManager

useradd -m -G wheel -s /bin/bash camila
echo "camila:123456" | chpasswd
echo "root:root" | chpasswd

echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
EOF

echo "✅ Instalação finalizada. Você pode reiniciar."
