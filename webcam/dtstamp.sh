#!/bin/sh
# Change the font variable to point to your font location
#font="http://fonts.googleapis.com/css?family=Pathway+Gothic+One"

# Fonction permettrant d'extraire du fichier 2 caractères de la 3ème ligne (température) :
temp=$(cat data.txt | sed -n '3 p' | cut -c7-11)

# Fonction permettrant d'extraire la pression atmosphérique :
hpa=$(cat data.txt | sed -n '6 p' | cut -c7-13)

# Fonction permettrant d'extraire la vitesse du vent :
wind=$(cat data.txt | sed -n '5 p' | cut -c7-9)

# Fonction permettrant d'extraire la direction vent :
wind2=$(cat data.txt | sed -n '7 p' | cut -c7-12)

# Fonction permettrant d'extraire la pluie du jour :
rain=$(cat data.txt | sed -n '4 p' | cut -c7-11)

# Fonction permettrant d'extraire l'heure des data
time_data=$(cat data.txt | sed -n '2 p' | cut -c7-13)

time=$(date +"%d/%m/%Y %H:%M")

if [ $# -eq 0 ]
   then
	  cat << _EOF_

USAGE: $0 file1 file2 ..., or
	   $0 *.jpg, or
	   $0 dir/*.jpg
	   ...

_EOF_
	  exit
fi

while [ "$1" != "" ]; do
		# Skip directories
		if [ -d "$1" ]; then
			shift
			continue
		fi
		# Skip already converted files (may get overwritten)
		if [[ $1 == *_DT* ]]
			then
				echo "------  Skipping: $1"
			shift
			continue
		fi

		# Work out a new file name by adding "_DT" before file extension
		file="$1"
		echo "######  Working on file: $file"
		filename=${file%.*}
		extension=${file##*.}
		composite=${filename}_CP.${extension}
		output=${filename}_DT.${extension}

		# Get the file dimension
		dim=$(identify -format "%w %h" "$file")
		width=${dim%% *}
		height=${dim#* }

		# Decide the font size automatically
		if [ $width -ge $height ]
			then
				pointsize=$(($width/30))
			else
				pointsize=$(($height/30))
		fi

		echo "        Width: $width, Height: $height. Using pointsize: $pointsize"

		# The real deal here
		composite -geometry +20+20 -gravity SouthEast Raspberry_Pi.png "$file" \
			"$composite"

		convert "$composite" -fill '#00000080' -draw 'rectangle 0,0,3280,110' \
			-gravity NorthEast -pointsize 55 -fill white -annotate +$pointsize+10 "Dernière image : $time"  \
			-gravity NorthEast -pointsize 45 -fill white -annotate +$pointsize+55 "Conditions locales : $temp °C | $wind km/h $wind2 | $hpa hPa | Pluie auj : $rain mm | MAJ $time_data"  \
			-gravity NorthWest -pointsize 55 -fill white -annotate +10+10 "Le nom de ma station - L'altitude de ma station - Mon numéro de dpt"  \
			-gravity NorthWest -pointsize 45 -fill white -annotate +10+55 "Association Nice Météo 06 - www.nicemeteo.fr"  \
			-quality 95 \
			"viewcam.jpg"

		shift
done

exit 0
