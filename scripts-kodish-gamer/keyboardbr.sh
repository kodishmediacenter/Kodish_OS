#!/bin/bash

echo "🧩 Configurando teclado ABNT2 para o console (TTY)..."
sudo bash -c 'echo "KEYMAP=br-abnt2" > /etc/vconsole.conf'
sudo loadkeys br-abnt2

echo "🧩 Configurando teclado ABNT2 para o ambiente gráfico (X11)..."
sudo localectl set-keymap br-abnt2
sudo localectl set-x11-keymap br abnt2

# Criação do arquivo para garantir configuração do X11
echo "🧩 Garantindo configuração do teclado no X11..."
sudo mkdir -p /etc/X11/xorg.conf.d
sudo tee /etc/X11/xorg.conf.d/00-keyboard.conf > /dev/null <<EOF
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "br"
    Option "XkbModel" "abnt2"
EndSection
EOF

echo "✅ Teclado configurado como ABNT2 (Português Brasil) para console e ambiente gráfico."
echo "🔁 Reinicie o sistema para aplicar completamente: sudo reboot"
