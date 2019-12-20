## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

# Removendo programas do Kodish 
sudo apt-get remove --purge libreoffice* -y
sudo apt-get remove --purge firefox -y
sudo apt-get purge --auto-remove thunderbird -y 
sudo apt-get purge --auto-remove pidgin -y
sudo apt-get autoremove

# instalando Atualizações do Sistema 
sudo apt-get update -y
sudo apt-get upgrade -y

# removendo libreoffice
sudo apt-get purge --auto-remove libreoffice-* -y


# Instalar o Kodish OS 7.0 
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:team-xbmc/ppa -y
sudo apt-get update -y
sudo apt-get install kodi -y
sudo apt-get install kodi-pvr-* -y
sudo apt-get install kodi-audioencoder-* -y
sudo apt-get install kodi-game-* -y
sudo apt-get install vlc -y
wget https://dl.strem.io/linux/v4.4.54/stremio_4.4.52-1_amd64.deb
dpkg -i stremio_4.4.52-1_amd64.deb
sudo apt-get install -f
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install unzip
mkdir /opt/kodish
chmod 777 /opt/kodish

# mudei para deb o spotify
wget http://repository.spotify.com/pool/non-free/s/spotify-client/spotify-client_1.1.10.546.ge08ef575-19_amd64.deb
dpkg -i spotify-client_1.1.10.546.ge08ef575-19_amd64.deb
apt-get install -f

# instalando os serviços que kodish usa

sudo apt-get install samba -y
sudo apt-get install git -y 

