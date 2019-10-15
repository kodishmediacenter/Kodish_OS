import xbmcgui
import xbmc
import os

stremio = os.path.join(xbmc.translatePath("special://home/addons/plugin.executable/stremio.sh").decode("utf-8"))


dialog = xbmcgui.Dialog()
ret = dialog.select('[COLOR yellow]Kodish Menu [/COLOR]', ['Youtube Kids','Stremio','Netflix','Spotify','Plex', 'Youtube TV','Youtube Music','', '','','','','','','','','',''])


if ret == 0:
	url = "https://www.youtubekids.com"
	os.system("google-chrome --kiosk " + url)

if ret == 1:
	os.system("stremio")

if ret == 2:
	url = "https://www.netflix.com/br/"
	os.system("google-chrome --kiosk " + url)
if ret == 3:
	os.system("/snap/bin/spotify")
if ret == 4: 
	os.system("/opt/kodish/plex/Plex_Media_Player.AppImage")
if ret == 5:
	url2 = "https://www.youtube.com/tv#/surface?c=FEtopics&resume"
	os.system("kill google-chrome")
	os.system("google-chrome --kiosk " + url2)
if ret == 6:
	url3 = "https://music.youtube.com/"
	os.system("kill google-chrome")
	os.system("google-chrome --kiosk " + url3)
	


