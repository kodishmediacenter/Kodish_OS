#!/bin/bash

# 1. Detecta o nome da saída principal conectada
DISPLAY_OUT=$(xrandr | grep " connected" | cut -d" " -f1)

# 2. Detecta a resolução máxima disponível
MAX_RES=$(xrandr | grep -A1 "$DISPLAY_OUT connected" | tail -n 1 | awk '{print $1}')

# 3. Aplica a resolução máxima
xrandr --output "$DISPLAY_OUT" --mode "$MAX_RES"

# 4. Evita sleep e tela preta
xset -dpms
xset s off
xset s noblank

# 5. Inicia o Steam no modo "Deck"
steam -steamos -tenfoot -fulldesktopres
