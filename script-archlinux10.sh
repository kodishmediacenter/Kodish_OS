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
umount -R /mnt || true
wipefs -a "$DISCO"

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

# Pacotes principais
pacman -Sy archlinux-keyring --noconfirm
rm -f /var/cache/pacman/pkg/*.zst
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

# Usuário padrão
useradd -m -G wheel -s /bin/bash kodish
echo "kodish:kodish" | chpasswd
echo "root:root" | chpasswd
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/wheel

# Ativa detecção de outros sistemas
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
os-prober

# GRUB UEFI com fallback
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=Arch --removable --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# Interface gráfica XFCE + Xorg
pacman -Sy --noconfirm xorg xfce4 xfce4-goodies lightdm lightdm-gtk-greeter xfce4-whiskermenu-plugin

# Define XFCE como sessão padrão
# echo "exec startxfce4" > /home/kodish/.xinitrc
# chown kodish:kodish /home/kodish/.xinitrc

# Ativa LightDM
systemctl enable lightdm
systemctl set-default graphical.target

# Ativa repositório multilib
sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
pacman -Sy

# Steam + suporte 32-bit
pacman -S --noconfirm steam lib32-mesa lib32-libglvnd lib32-vulkan-icd-loader

# Codecs multimídia
pacman -S --noconfirm gst-libav gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly ffmpeg
pacman -S --noconfirm firefox flatpak gparted

# Whisker Menu no painel do XFCE
mkdir -p /home/kodish/.config/xfce4/xfconf/xfce-perchannel-xml

cat > /home/kodish/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml <<XML
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="panel-1" type="empty">
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
      </property>
      <property name="position" type="string" value="p=6;x=0;y=0"/>
      <property name="size" type="uint" value="28"/>
    </property>
  </property>

  <property name="plugins" type="empty">
    <property name="plugin-1" type="string" value="whiskermenu"/>
    <property name="plugin-2" type="string" value="separator"/>
    <property name="plugin-3" type="string" value="systray"/>
    <property name="plugin-4" type="string" value="clock"/>
  </property>
</channel>
XML

# Permissões de usuário
chown -R kodish:kodish /home/kodish/.config
systemctl enable lightdm

# Extras
pacman -S --noconfirm alsa-utils
pacman -S --noconfirm pipewire pipewire-pulse wireplumber zenity jq lutris
pacman -S --noconfirm noto-fonts-cjk kodi kodi-addon-inputstream-adaptive

systemctl --user enable --now pipewire pipewire-pulse wireplumber

# Flatpak 
flatpak install flathub com.google.Chrome
flatpak install flathub com.heroicgameslauncher.hgl
flatpak install flathub com.vysp3r.ProtonPlus

# Remover pacotes 
pacman -Rs xfce4-dict 
pacman -Rs ristretto 
pacman -Rs parole
pacman -Rs bvnc 

EOF

# ✅ Fim
echo -e "\n✅ Arch Linux com XFCE + Whisker, Steam, Multilib e Codecs instalado com sucesso!"
