#!/bin/bash

## Removendo travas eventuais do apt ##

sudo rm /var/lib/dpkg/lock-frontend; sudo rm /var/cache/apt/archives/lock ;

# Instalando Wine e Lutris
wget -nc https://dl.winehq.org/wine-builds/winehq.key 
sudo apt-key add winehq.key -y
sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
sudo apt install lutris libvulkan1 libvulkan1:i386 -y
sudo apt-get install --install-recommends winehq-stable wine-stable wine-stable-i386 wine-stable-amd64 -y
