sudo pacman -S xfce4 xfce4-goodies
sudo pacman -S lightdm lightdm-gtk-greeter
sudo pacman -S kodi
sudo pacman -S kodi-gles
sudo pacman -S asunder
sudo pacman -S networkmanager
sudo pacman -S firefox
sudo pacman -S gparted
sudo pacman -S wget

sudo systemctl enable lightdm.service
sudo systemctl enable networkmanager
sudo systemctl enable NetworkManager.service


sudo flatpak install flathub com.obsproject.Studio
sudo flatpak install flathub com.stremio.Stremio
sudo flatpak install flathub org.chromium.Chromium

wget https://github.com/complexlogic/flex-launcher/releases/download/v2.1/flex-launcher-2.1-1-x86_64.pkg.tar.zst
sudo pacman -U flex-launcher-2.1-1-x86_64.pkg.tar.zst

sudo pacman -Rs xfce4-dict 
sudo pacman -Rs ristretto 
sudo pacman -Rs parole
sudo pacman -Rs bvnc 


