# Removendo programas do Kodish 
sudo apt-get remove --purge libreoffice* -y
sudo apt-get purge --auto-remove thunderbird -y 
sudo apt-get purge --auto-remove pidgin -y
sudo apt remove --purge gnome-keyring -y
sudo apt remove --purge ristretto -y
sudo apt-get autoremove

# instalando Atualizações do Sistema 
sudo apt-get update -y
sudo apt-get upgrade -y

# removendo libreoffice
sudo apt-get purge --auto-remove libreoffice-* -y

