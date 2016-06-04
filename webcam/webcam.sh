#!/bin/sh

# On se place dans le bon répertoire
cd /home/pi/webcam

# On prend une photo qui s'appellera image.jpg
raspistill --output image.jpg

# On exécute le script data.sh
sudo ./data_ftp.sh

# On attend 20 secondes pour être sur qu'on a bien récup le fichier txt
sleep 20s

# On exécute le script dtstamp.sh sur image.jpg
sudo ./dtstamp.sh image.jpg

# On attend à nouveau 10 secondes
sleep 10s

# On exécute le script ovh.sh qui va FTP
sudo ./ftp.sh

# On supprime l'image originale
rm -rf image.jpg
