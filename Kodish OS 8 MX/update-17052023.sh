
# Atualizar o Kodi 20 para 20.1

sudo apt-get update -y
sudo apt-get install kodi -y

# Limpar o atalho
echo '' > /usr/share/applications/'Vix TV'.desktop

# Atualizar o Atalho do Vix
echo '[Desktop Entry]' >> /usr/share/applications/'Vix TV'.desktop
echo 'Version=1.0' >> /usr/share/applications/'Vix TV'.desktop
echo 'Type=Application' >> /usr/share/applications/'Vix TV'.desktop
echo 'Name=Vix TV' >> /usr/share/applications/'Vix TV'.desktop
echo 'Comment=' >> /usr/share/applications/'Vix TV'.desktop
echo 'Exec=/usr/bin/google-chrome-stable --kiosk www.vixbrasiltv.com' >> /usr/share/applications/'Vix TV'.desktop
echo 'Icon=/kodish/icons/vix.jpg' >> /usr/share/applications/'Vix TV'.desktop
echo 'Path=' >> /usr/share/applications/'Vix TV'.desktop
echo 'Terminal=false' >> /usr/share/applications/'Vix TV'.desktop
echo 'StartupNotify=false' >> /usr/share/applications/'Vix TV'.desktop

# corrigindo bugs de instalações anteriores
sudo namei -lx  /var/cache/man/*/CACHEDIR.TAG
sudo rm -r   /var/cache/man/*/CACHEDIR.TAG
sudo chown -R man: /var/cache/man/
sudo chmod -R 755 /var/cache/man/

# pegar home e atualizar os atalhos do menu iniciar 

t=$HOME 
cd $t/.config/xfce4/panel/
wget https://pastebin.com/raw/FbYYcai8
rm -r whiskermenu-1.rc
mv FbYYcai8 whiskermenu-1.rc

sudo echo '' >> /etc/skel/.bashrc
sudo echo "alias update='wget https://tinyurl.com/3kyssphv && mv 3kyssphv update-mx.sh && sh update-mx.sh'" >> /etc/skel/.bashrc

# atualizando os pacotes
sudo apt-get update -y
sudo apt-get upgrade -y 

# adicionado stremio via flatpak 

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install flathub com.stremio.Stremio
sudo echo '' >> /etc/skel/.bashrc
sudo echo "alias stremio='flatpak run com.stremio.Stremio'" >> /etc/skel/.bashrc

# atualizando terminal

cat /etc/skel/.bashrc > $t/.bashrc 

