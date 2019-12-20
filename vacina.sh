cd /usr/share/kodi/system
sudo mkdir python
cd python
sudo mkdir Lib
sudo ln -s /usr/lib/python2.7/* /usr/share/kodi/system/python/Lib/
cd /usr/lib/python2.7/
sudo chmod 777 shutil.py
