#!/bin/bash
#
#
# Shelldio - ακούστε online ραδιόφωνο από το τερματικό
# Copyright (c)2018 Vasilis Niakas and Contributors
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation version 3 of the License.
#
# Please read the file LICENSE and README for more information.
#
#

### Variable List
all_stations="$HOME/.shelldio/all_stations.txt"
my_stations="$HOME/.shelldio/my_stations.txt"

### Functions List

# Μήνυμα καλωσορίσματος

welcome_screen() {
	echo " __________________________________________"
	echo "|                 Shelldio                 |"
	echo "|       Ακούστε τους αγαπημένους σας       |"
	echo "|        σταθμούς από το τερματικό         |"
	echo "| https://github.com/CerebruxCode/Shelldio |"
	echo "|__________________________________________|"
}

option_detail() {
	echo "--help: Εμφανίζει πληροφορίες για την χρήση της εφαρμογής"
	echo -e "--list: Εμφανίζει την λίστα με τους σταθμούς.\n  Βρίσκεται στο ~/.shelldio/all_stations.txt"
	echo -e "--add : Δημιουργεί το αρχείο ~/.shelldio/my_stations.txt\n  και μεταφέρει τους αγαπημένους σας σταθμούς"
	echo "--remove: Διαγράφει σταθμούς της επιλογής σας από το my_stations.txt"
}


# Δημιουργεί και εμφανίζει σε λίστα τους σταθμούς στο txt file που δέχεται σαν flag
list_stations(){
while IFS='' read -r line || [[ -n "$line" ]]; do
    num=$(( num + 1 ))
    echo ["$num"] "$line" | cut -d "," -f1		
done < "$1"
}

# Πληροφορίες που εμφανίζονται μετά την επιλογή του σταθμού
info() {
echo -ne "| Η ώρα είναι $(date +"%T")\n| Ακούτε $stathmos_name\n| Πατήστε Q/q για έξοδο ή R/r για επιστροφή στη λίστα σταθμών"
}

add_stations() {
	echo "Εμφάνιση λίστας σταθμών"
	sleep 2
	list_stations "$all_stations"
	while true
	do
	read -rp "Επέλεξε αριθμού σταθμού  (Q/q για έξοδο): " input_station
		if [[ $input_station = "q" ]] || [[ $input_station = "Q" ]]; then
			echo "Έξοδος..."
			exit 0
		elif [ "$input_station" -gt 0 ] && [ "$input_station" -le $num ]; then #έλεγχος αν το input είναι μέσα στο εύρος της λίστας των σταθμών
			stathmos_name=$(< "$all_stations" head -n$(( "$input_station" )) | tail -n1 | cut -d "," -f1)
			stathmos_url=$(< "$all_stations" head -n$(( "$input_station" )) | tail -n1 | cut -d "," -f2)
			echo "$stathmos_name,$stathmos_url" >> "$my_stations"
			echo " Προστέθηκε ο σταθμός $stathmos_name."
		else
			echo "Αριθμός εκτός λίστας"
		fi
	done
	exit 0

}

remove_station(){
	if [ ! -f "$HOME/.shelldio/my_stations.txt" ]; then
		echo "Δεν έχει δημιουργηθεί το αρχείο my_stations."
		echo "Για πληροφορίες τρέξε την παράμετρο --help."
	else
		echo "Εμφάνιση λίστας προσωπικών σταθμών"
		sleep 2
		list_stations "$HOME/.shelldio/my_stations.txt"
		while true
		do
		read -rp "Επέλεξε αριθμού σταθμού  (Q/q για έξοδο): " remove_station
		if [[ $remove_station = "q" ]] || [[ $remove_station = "Q" ]]; then
			echo "Έξοδος..."
			exit 0
		elif [ "$remove_station" -gt 0 ] && [ "$remove_station" -le $num ]; then #έλεγχος αν το input είναι μέσα στο εύρος της λίστας των σταθμών
			stathmos_name=$(< "$HOME/.shelldio/my_stations.txt" head -n$(( "$remove_station" )) | tail -n1 | cut -d "," -f1)
			stathmos_url=$(< "$HOME/.shelldio/my_stations.txt" head -n$(( "$remove_station" )) | tail -n1 | cut -d "," -f2)
			sed -i "$num""d" "$HOME/.shelldio/my_stations.txt"
			echo "Διαγράφηκε ο σταθμός $stathmos_name."
		else
			echo "Αριθμός εκτός λίστας"
		fi
		done
	fi
}

### Λίστα με τις επιλογές σαν 1ο όρισμα ./shelldio --[option]

while [ "$1" != "" ]; do
	case $1 in 
		-h | --help ) 
			welcome_screen && option_detail
			exit
			;;
		-l | --list ) 
			welcome_screen 
			echo "Εμφάνιση όλων των σταθμών."
			sleep 2 
		 	list_stations "$all_stations"
			exit
			;;
		-a | --add )
			welcome_screen
			add_stations
			exit
			;;
		-r | --remove )
			welcome_screen
			remove_station
			exit
			;;
	esac
done



### Base script 

while true
do
terms=0
trap ' [ $terms = 1 ] || { terms=1; kill -TERM -$$; };  exit' EXIT INT HUP TERM QUIT 

# Έλεγχος αν υπάρχει ο mpv
if  ! command -v mpv &> /dev/null ; then 
	echo "Δεν βρέθηκε συμβατός player. Συμβατός player είναι ο mpv"
	exit
fi

if [ "$#" -eq "0" ]; then #στην περίπτωση που δε δοθεί όρισμα παίρνει το προκαθορισμένο αρχείο
	if [ -d "$HOME/.shelldio/" ]; then 
		if [ -f "$my_stations" ]; then
			stations="$my_stations"
		else
			if [ ! -f "$all_stations" ]; then
				echo "Δεν ήταν δυνατή η εύρεση του αρχείου σταθμών. Γίνεται η λήψη του..."
    			sleep 2
				curl -sL https://raw.githubusercontent.com/CerebruxCode/shelldio/features/.shelldio/all_stations.txt --output "$HOME/.shelldio/all_stations.txt"
			fi	
			stations="$all_stations"
		fi
	else 
		echo "Δημιουργείτε ο φάκελος .shelldio ο οποίος θα περιέχει τα αρχεία των σταθμών."
		sleep 2
		mkdir -p "$HOME/.shelldio"
		echo "Γίνεται η λήψη του αρχείου με όλους τους σταθμούς."
		sleep 2
		curl -sL https://raw.githubusercontent.com/CerebruxCode/shelldio/features/.shelldio/all_stations.txt --output "$HOME/.shelldio/all_stations.txt"
    	stations="$all_stations"
	fi
fi

while true 
do

welcome_screen 

num=0 

list_stations "$stations"

if [ ! -f "$my_stations" ]; then
		echo "Από προεπιλογή η λίστα σταθμών περιέρχει όλους τους σταθμούς."
		echo "Μπορείς να δημιουργήσεις ένα αρχείο με τους αγαπημένους σου σταθμούς."
		echo "./shelldio --help για να δεις πως μπορείς να το κάνεις!"
	fi	
echo "---------------------------------------------------------"
read -rp "Διαλέξτε Σταθμό (Q/q για έξοδο): " input_play

if [[ $input_play = "q" ]] || [[ $input_play = "Q" ]]; then
	echo "Έξοδος..."
	exit 0
elif [ "$input_play" -gt 0 ] && [ "$input_play" -le $num ]; then #έλεγχος αν το input είναι μέσα στο εύρος της λίστας των σταθμών
	stathmos_name=$(< "$stations" head -n$(( "$input_play" )) | tail -n1 | cut -d "," -f1)
	stathmos_url=$(< "$stations" head -n$(( "$input_play" )) | tail -n1 | cut -d "," -f2)
	break
else
	echo "Αριθμός εκτός λίστας"
	sleep 2
	clear
fi
done

mpv "$stathmos_url" &> /dev/null &

while true
do 
	clear 
	info
	sleep 0
	read -r -n1 -t1 input_play          # Για μικρότερη αναμονή της read
	if [[ $input_play = "q" ]] || [[ $input_play = "Q" ]]; then
		clear
		echo "Έξοδος..."
    	exit 0
    elif [[ $input_play = "r" ]] || [[ $input_play = "R" ]]; then
	killall -9 mpv &> /dev/null
	clear
	echo "Επιστροφή στη λίστα σταθμών"
	sleep 2
	clear
	break
   fi

done

done
