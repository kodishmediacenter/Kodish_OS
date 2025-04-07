#!/bin/bash
# Instala o reflector (não vem no ISO)
pacman -Sy reflector wget

set -e

# Layout do teclado
loadkeys br-abnt2
timedatectl set-ntp true

# Detecta o maior disco
DISCO=$(lsblk -dpo NAME,SIZE,TYPE | grep -w disk | sort -k2 -h | tail -n1 | awk '{print $1}')
echo "Disco detectado: $DISCO"
read -rp "⚠️ TODOS OS DADOS EM $DISCO SERÃO APAGADOS! Deseja continuar? (s/N): " CONFIRMA
[[ "$CONFIRMA" != "s" && "$CONFIRMA" != "S" ]] && exit 1

# Limpa disco
#wipefs -a "$DISCO"

# Particiona GPT
parted "$DISCO" --script mklabel gpt
parted "$DISCO" --script mkpart ESP fat32 1MiB 513MiB
parted "$DISCO" --script set 1 esp on
parted "$DISCO" --script mkpart primary ext4 513MiB 100%

# Define partições
if [[ "$DISCO" == *"nvme"* ]]; then
  EFI="${DISCO}p1"
  ROOT="${DISCO}p2"
else
  EFI="${DISCO}1"
  ROOT="${DISCO}2"
fi

# Formata
mkfs.fat -F32 "$EFI"
mkfs.ext4 "$ROOT"

# Monta
mount "$ROOT" /mnt
mkdir -p /mnt/boot/efi
mount "$EFI" /mnt/boot/efi

# Mirrorlist BR
pacman -Sy --noconfirm reflector
reflector --country Brazil --protocol https --latest 10 --sort rate --save /etc/pacman.d/mirrorlist

# Pacotes principais
pacstrap /mnt base linux linux-firmware vim sudo networkmanager grub efibootmgr os-prober mtools dosfstools

# fstab
genfstab -U /mnt >> /mnt/etc/fstab

# 🛠️ Configuração no sistema
arch-chroot /mnt /bin/bash <<EOF

# Localização
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf

# Hostname
echo "archlinux" > /etc/hostname

# NetworkManager
systemctl enable NetworkManager

# Usuário camila
useradd -m -G wheel -s /bin/bash kodish
echo "kodish:kodish" | chpasswd
echo "roo:root" | chpasswd
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel

# Ativa detecção de outros sistemas (ex: Windows)
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
os-prober

# GRUB UEFI
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg

# XFCE + Firefox + Xorg + Login gráfico
pacman -Sy --noconfirm xorg xfce4 xfce4-goodies lightdm lightdm-gtk-greeter firefox

# Ativa interface gráfica
systemctl enable lightdm

EOF

# ✅ Fim
echo -e "\n✅ Arch Linux com XFCE e suporte a Dual Boot instalado com sucesso!"
