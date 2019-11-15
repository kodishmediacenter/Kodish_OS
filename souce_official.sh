## Removendo travas eventuais do apt ##
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

# Instalar o Kodish OS 7.0 
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:team-xbmc/ppa -y
sudo apt-get update -y
sudo apt-get install kodi -y
sudo apt-get install kodi-pvr-* -y
sudo apt-get install kodi-audioencoder-* -y
sudo apt-get install kodi-game-* -y
sudo apt-get install vlc -y
sudo snap install spotify
wget https://dl.strem.io/linux/v4.4.54/stremio_4.4.52-1_amd64.deb
sudo apt-get install -f
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get install unzip
mkdir /opt/kodish
chmod 777 /opt/kodish

