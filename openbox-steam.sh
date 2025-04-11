#!/bin/bash

# Detecta tela e ajusta resolução máxima
OUT=$(xrandr | grep " connected" | cut -d" " -f1)
RES=$(xrandr | grep -A1 "$OUT connected" | tail -n1 | awk '{print $1}')
xrandr --output "$OUT" --mode "$RES"

# Evita sleep/apagar
xset -dpms
xset s off
xset s noblank

# Inicia o Openbox como WM leve
openbox-session &

# Delayzinho opcional pra garantir que o X esteja pronto
sleep 1

# Inicia Steam em modo Deck
steam -steamos -tenfoot -fulldesktopres
