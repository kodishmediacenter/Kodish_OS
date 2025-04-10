#!/bin/bash

# Configuração de login automático no LightDM para o usuário "kodish"

USER="kodish"
CONF="/etc/lightdm/lightdm.conf"
BACKUP="/etc/lightdm/lightdm.conf.bak_$(date +%Y%m%d%H%M%S)"

echo "🔒 É necessário acesso root para configurar o LightDM."
echo "👤 Usuário: $USER"
echo "📦 Fazendo backup de $CONF em $BACKUP..."
sudo cp "$CONF" "$BACKUP"

echo "🛠️ Editando $CONF para ativar login automático..."
# Ativa e configura a seção [Seat:*]
sudo sed -i '/^\[Seat:\*\]/,/^\[.*\]/ s/^#\?\(autologin-user=\).*$/\1'"$USER"'/' "$CONF"
sudo sed -i '/^\[Seat:\*\]/,/^\[.*\]/ s/^#\?\(autologin-session=\).*$/\1xfce/' "$CONF"

# Garante que as opções existem, se não existirem
sudo grep -q "^\[Seat:\*\]" "$CONF" || echo -e "\n[Seat:*]" | sudo tee -a "$CONF"
sudo grep -q "^autologin-user=" "$CONF" || echo "autologin-user=$USER" | sudo tee -a "$CONF"
sudo grep -q "^autologin-session=" "$CONF" || echo "autologin-session=xfce" | sudo tee -a "$CONF"

echo "✅ Login automático ativado para o usuário '$USER'. Reinicie o sistema para aplicar."
