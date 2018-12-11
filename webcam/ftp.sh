#!/bin/sh
# constantes
HOST=IP_SERVEUR_DISTANT
LOGIN=USER_FTP
PASSWORD=PASSWORD
PORT=21
# le transfert lui même
# Ce chemin concerne la RPI hôte
cd /home/pi/webcam
ftp -i -n $HOST $PORT << END_SCRIPT
quote USER $LOGIN
quote PASS $PASSWORD
pwd
bin
# Ce chemin concerne le serveur distant auquel on est en train de se connecter
cd /web/webcam
put viewcam_temp.jpg
rename viewcam_temp.jpg viewcam.jpg
quit
END_SCRIPT
