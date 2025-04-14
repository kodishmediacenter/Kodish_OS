#!/bin/bash

set -e

# Nome do sistema personalizado
NAME="Kodish OS"
PRETTY_NAME="Kodish OS 10 Gamer Edition"
ID="kodish"
VERSION="10 Gamer Edition"
HOME_URL="http://kodish.space/grupo.html"

# Cores
GREEN="\e[32m"
RESET="\e[0m"

echo -e "${GREEN}🚀 Iniciando a personalização do sistema para $PRETTY_NAME...${RESET}"

# Backup dos arquivos
backup_file() {
    if [ -f "$1" ]; then
        sudo cp -v "$1" "$1.bak_$(date +%Y%m%d%H%M%S)"
    fi
}

echo -e "${GREEN}📦 Fazendo backup dos arquivos...${RESET}"
backup_file /etc/os-release
backup_file /etc/lsb-release
backup_file /etc/default/grub

# Editar /etc/os-release
echo -e "${GREEN}✏️ Atualizando /etc/os-release...${RESET}"
sudo bash -c "cat > /etc/os-release" <<EOF
NAME="$NAME"
PRETTY_NAME="$PRETTY_NAME"
ID=$ID
VERSION="$VERSION"
VERSION_ID=10
HOME_URL="$HOME_URL"
SUPPORT_URL="$HOME_URL"
BUG_REPORT_URL="$HOME_URL"
EOF

# Editar /etc/lsb-release
echo -e "${GREEN}✏️ Atualizando /etc/lsb-release...${RESET}"
sudo bash -c "cat > /etc/lsb-release" <<EOF
DISTRIB_ID=$NAME
DISTRIB_RELEASE=10
DISTRIB_CODENAME=gamer
DISTRIB_DESCRIPTION="$PRETTY_NAME"
EOF

# Editar GRUB
echo -e "${GREEN}✏️ Atualizando /etc/default/grub...${RESET}"
sudo sed -i 's/^GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="Kodish OS 10 Gamer Edition"/' /etc/default/grub

echo -e "${GREEN}🔄 Atualizando GRUB...${RESET}"
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo -e "${GREEN}✅ Sistema renomeado com sucesso para: $PRETTY_NAME!${RESET}"
