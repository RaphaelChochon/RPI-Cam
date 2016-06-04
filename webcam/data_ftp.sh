#!/bin/sh
# constantes
HOST=IP_SERVEUR_DISTANT
LOGIN=USER_FTP
PASSWORD=PASSWORD
PORT=21
# le transfert lui même
cd /home/pi/webcam
ftp -i -n $HOST $PORT << END_SCRIPT
quote USER $LOGIN
quote PASS $PASSWORD
pwd
bin
cd /web/weewx_rpi/smartphone
get data.txt
quit
END_SCRIPT
