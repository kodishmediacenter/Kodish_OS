#!/bin/bash

# Garante que o serviço iwd esteja ativo
systemctl start iwd

# Descobre a interface Wi-Fi automaticamente
INTERFACE=$(iwctl device list | awk '/station/ {print $1}')
if [ -z "$INTERFACE" ]; then
    echo "❌ Nenhuma interface Wi-Fi encontrada."
    exit 1
fi

# Lista as redes disponíveis
iwctl station "$INTERFACE" scan
sleep 2  # Aguarda alguns segundos para a varredura
REDES=($(iwctl station "$INTERFACE" get-networks | awk '/\*/ {print $2}'))

# Verifica se encontrou redes
if [ ${#REDES[@]} -eq 0 ]; then
    echo "❌ Nenhuma rede Wi-Fi encontrada."
    exit 1
fi

# Exibe o menu
echo "📶 Redes Wi-Fi encontradas:"
for i in "${!REDES[@]}"; do
    echo "  [$i] ${REDES[$i]}"
done

# Pede a escolha do usuário
read -p "Digite o número da rede desejada: " ESCOLHA

# Verifica entrada válida
if ! [[ "$ESCOLHA" =~ ^[0-9]+$ ]] || [ "$ESCOLHA" -ge "${#REDES[@]}" ]; then
    echo "❌ Escolha inválida."
    exit 1
fi

SSID="${REDES[$ESCOLHA]}"
read -s -p "Digite a senha para a rede '$SSID': " PASSWORD
echo

# Tenta conectar
echo "$PASSWORD" | iwctl station "$INTERFACE" connect "$SSID"

# Testa conexão
if ping -c 1 archlinux.org &> /dev/null; then
    echo "✅ Conectado com sucesso à rede '$SSID'!"
else
    echo "❌ Falha ao conectar à rede '$SSID'."
fi
