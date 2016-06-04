## Tuto/mémo - Publication d'une PiCam avec données météos locales à partir d'une RPI et de Weewx
###### Dernière modif tuto : 04/06/2016
**Ce tuto est largement inspiré de celui du site [Épinglé !](http://www.epingle.info/?p=3070), mais avec tout de même quelques ajouts.**

### 0 - Objectif
Le but est de pouvoir prendre une photo avec une PiCam sur une Raspberry Pi, pour ensuite lui ajouter quelques données de notre station météo, elle même gérée par Weewx sur la même Raspberry Pi, ou sur une autre.
<br>
Je vous invite d'abord à parcourir le tuto original [du site Épinglé !](http://www.epingle.info/?p=3070) afin de mieux comprendre. Si vous ne possédez pas de station météo perso, vous pouvez insérer les données d'une station METAR proche. Dans ce cas la, se référer au tuto précédemment cité.
<br>
Introduction de son tutoriel, et schéma l'illustrant :<br>
> Pour ce faire, nous allons utiliser tous les outils Raspbian pour mettre en œuvre la prise d'images régulière, le traitement de cette image et l'envoi sur un serveur distant. Schématiquement cela donne :
<br>
![Serveur PiCam](img/serveur_picam.jpg)

### 1 - Installation de paquets sur la RPI

Si vous avez une PiCam et une station météo perso, alors nous pouvons installer deux paquets :
```
	sudo apt-get update && sudo apt-get upgrade
	sudo apt-get install imagemagick ftp
```

### 2 - Récupération des scripts


On va récupérer les scripts présents ici :

```
	cd /home/pi
	wget
```
