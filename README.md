## Tuto/mémo - Publication d'une PiCam avec données météos locales à partir d'une RPI et de Weewx
###### Dernière modif tuto : 05/06/2016
**Ce tuto est largement inspiré de celui du site [Épinglé !](http://www.epingle.info/?p=3070), mais avec tout de même quelques ajouts.**

### 0 - Objectif
Le but est de pouvoir prendre une photo avec une PiCam sur une Raspberry Pi, pour ensuite lui ajouter quelques données de notre station météo, elle même gérée par Weewx sur la même Raspberry Pi, ou sur une autre.
<br><br>
En ce qui concerne la génération du fichier ``data.txt`` par Weewx, vous trouverez le template à mettre en place du côté de Weewx avec une courte explication pour la configuration à cette adresse : https://github.com/RaphaelChochon/RPI-Weewx#création-du-fichier-datatxt-pour-publication-dune-webcam
<br><br>
Je vous invite d'abord à parcourir le tuto original [du site Épinglé !](http://www.epingle.info/?p=3070) afin de mieux comprendre. Si vous ne possédez pas de station météo perso, vous pouvez insérer les données d'une station METAR proche. Dans ce cas la, se référer au tuto précédemment cité.
<br><br>
Introduction de son tutoriel, et schéma l'illustrant :<br>
> Pour ce faire, nous allons utiliser tous les outils Raspbian pour mettre en œuvre la prise d'images régulière, le traitement de cette image et l'envoi sur un serveur distant. Schématiquement cela donne :
<br>
![Serveur PiCam](img/serveur_picam.jpg)


### 1 - Installation de paquets sur la RPI


Si vous avez une PiCam et une station météo perso, alors nous pouvons installer deux paquets :
```
	sudo apt-get update && sudo apt-get upgrade
	sudo apt-get install imagemagick ftp unzip
```


### 2 - Récupération des scripts


On va récupérer les scripts présents ici :

```
	cd /home/pi
	wget https://github.com/RaphaelChochon/RPI-PiCam/archive/master.zip
	unzip master.zip
```

Et on les déplace:
```
	cp -r RPI-PiCam-master/webcam/ /home/pi/webcam
```

Si tout va bien, on retrouve nos scripts dans le dossier ``/home/pi/webcam``


### 3 - Personnalisation des scripts


Dans ce dossier ``webcam`` on devrait retrouver plusieurs scripts shell :
* **webcam.sh** : C'est le script principal qui va appeler tous les autres !
* **data_copy.sh** ou **data_ftp.sh** : Il faudra choisir entre l'un des deux. Ces script font la même chose, c'est à dire qu'ils vont récupérer le fichier data.txt produit par Weewx, lui même alimenté par notre station météo perso. Si la station météo et Weewx sont sur la même RPI que celle qu'on est en train de configurer pour la PiCam, alors on utilisera le script ``data_copy.sh``. Sinon, on utilisera le script ``data_ftp.sh`` qui ira se connecter à notre serveur web pour récupérer le fichier ``data.txt``.
* **dtstamp.sh** : C'est le script qui va se servir du paquet ``imagemagick`` installé précédemment, afin de "tagué" l'image (texte, insertion du logo etc)
* **ftp.sh** : C'est le dernier ! Il va envoyer sur notre site web via FTP l'image produite.


#### 3.1 - ``webcam.sh``


On commence par éditer celui ci. Et il n'y a pas grand chose à faire !
En fait on va simplement venir lui dire pour la récupération du fichier data.txt, quel script utiliser.
ça se passe entre la ligne 10 et 11, et on aura le choix entre deux propositions :

```
	#sudo ./data_copy.sh
	#sudo ./data_ftp.sh
```

Pour rappel on utilisera le script ``data_copy.sh`` si la station météo et Weewx sont sur la même RPI que celle qu'on est en train de configurer pour la PiCam.<br>
Sinon on utilisera le ``data_ftp.sh``.

Pour choisir entre les deux, on décommentera celui que l'on veut utiliser (le # devant une ligne, signifie que cette ligne est un commentaire ; Elle n'est donc pas pris en compte lors de l'éxécution du script). Par exemple si je veut utiliser ``data_copy.sh`` :

```
	sudo ./data_copy.sh
	#sudo ./data_ftp.sh
```
Et inversément :
```
	#sudo ./data_copy.sh
	sudo ./data_ftp.sh
```

***

Ensuite, on peut voir que le script attend 20 secondes avant de passer à l'étape suivante. Le but est d'attendre que le ``data_ftp.sh`` est fini de récupérer le fichier ``data.txt``. Ce temps peut être considérablement réduit si on dispose d'une excellente connexion internet, ou si on utilise le script ``data_copy.sh``.

***

La ligne 17 exécute le script ``dtstamp.sh`` qui va permettre de taguer l'image avec le texte, le logo etc...

***

On attend à nouveau 10 secondes, pour laisser le temps à la RPI de "fabriquer" notre image.

***

A la ligne 26 on exécute le script ``ftp.sh``, qui va transmettre notre image taguée sur notre site.

***

Et enfin, à la ligne 26, on supprime l'image temporaire pour faire de la place pour la suivante.


#### 3.2 - ``data_ftp.sh`` & ``data_copy.sh``


Passons maintenant à la configuration de la connexion FTP qui va aller récupérer notre fichier data.txt sur le serveur de notre site.

Il est assez simple à configurer, puisqu'il suffit de compléter les identifiants de connexion comme c'est indiqué à l'interieur. Quatres paramètres sont importants : ``HOST``, ``LOGIN``, ``PASSWORD`` et ``PORT``.<br>
Ensuite deux chemins sont à configurer :
* Le premier à la ligne 9 n'a normallement pas besoin d'être modifié, sauf si on a stocké nos scripts ailleurs sur la RPI.
* Le deuxième à la ligne 16 est **important**, et sera surement différent selon la configuration serveur. Ce qu'il faut comprendre, c'est qu'il s'agit du chemin qui emmène à l'endroit ou est stocké le fichier ``data.txt``.
Il peut être d'ailleurs intéréssant de configurer la connexion FTP utilisée ici à n'accèder qu'à ce répertoire.
<br>
Ensuite, on peut voir qu'avec la commande ``get`` on récupère vers nous le fichier ``data.txt``.

***

Si nous utilisons le script ``data_copy.sh``, nous pouvons voir qu'il s'agit d'une simple commande de copié/collé en local sur la RPI. Rien de plus simple que de changer les chemins d'accès en focntion de notre configuration.


#### 3.3 - ``dtstamp.sh``


Ce script est un petit peu plus complexe, mais nous n'avons pas grand chose à y configurer.
De la ligne 5 à la ligne 21, on traite le fichier ``data.txt`` en récupérant que ce qui nous intéresse, et on place le contenu dans des variables que nous utiliserons plus bas.

***

Ce qui nous intéresse ce situe à partir de la ligne 76. A cette ligne on récupère le logo ``Raspberry_Pi.png`` fourni avec les scripts qui va être placé en bas à droite de l'image. Vous pouvez le modifiez à votre guise, mais attention si vous changez son nom, à ne pas oublier de venir écrire son nouveau nom ici même.

***

Ensuite à la ligne 79 on va configurer les dimensions et la couleur du bandeau gris en haut de l'image qui va contenir les données météos, l'heure etc...<br>
``rectangle 0,0,3280,110`` : Les deux derniers nombres sont la largeur et la hauteur en pixels du bandeau. En fonction de la qualité de la PiCam utilisée, il faudra changer la largeur. 2592px pour la PiCam V1, et 3280 pour la PiCam V2.

***

Enfin, chacune des lignes suivantes vont taguer le bandeau avec du texte.
La première ligne ajoutera l'heure en haut à gauche.
La seconde configure la ligne juste en dessous, avec comme contenu toutes les variables configurées tout en haut de ce script et contenant les données météos.
La troisième le nom de la station, l'altitude etc...
Et enfin la quatrième ... ce que vous voulez.
A noter que le nombre juste après la mention ``pointsize`` à chaque ligne est la taille de la police de caractère. A modifier en fonction de la qualité de la webcam...
<br><br>
Enfin la ligne 84 configure la qualité de compression jpg de l'image. Une valeure de 75 est largement correct et économise de la bande passante. Pour les puristes vous pouvez laisser 95.
<br><br>
On peut voir à la ligne 85 le nom du l'image de sortie ``viewcam.jpg``.


#### 3.4 - ``ftp.sh``


Ce dernier script ressemble énormément au script ``data_ftp.sh`` puisque c'est la configuration pour l'envoi FTP vers le serveur.
Cette fois-ci la ligne 16 pointe vers le répertoire qui receptionnera l'image définitive de la webcam.


### 4 - L'automatisation !


**Trés important, à ne pas oublier**<br>
Il faut absolument rentre tous ces scipts exécutables :

```
	sudo chmod a+x webcam.sh data_ftp.sh data_copy.sh dtstamp.sh ftp.sh
```

***

Pour exécuter tout ceci de manière régulière et automatique, on va paramétrer une tache cron sur la RPI. Pour cela :

```
	crontab -e
```

Et tout en bas, on y ajoute cette ligne pour une exécution toutes les 2 minutes :

```
	*/2 * * * * sh /home/pi/webcam/webcam.sh
```
