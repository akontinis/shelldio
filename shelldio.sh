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
	echo '                                       .-_   _-.'
	echo '                                      / /     \ \ '
	echo '                                     ( ( (-o-) ) )'
	echo '                                      \.\_-!-_/./'
	echo '                                         --|--'
	echo "                                           |"
	echo '                                           |'
	echo ' .-;______________________________________;|'
	echo '| [___________________________________I__] |'
	echo '|   #######################       (_) (_)  | '
	echo "|_______________ Shelldio _________________|"
	echo "|                 v2.0.0                   |"
	echo "|                                          |"
	echo "|       Ακούστε τους αγαπημένους σας       |"
	echo "|        σταθμούς από το τερματικό         |"
	echo "|                                          |"
	echo "| https://github.com/CerebruxCode/Shelldio |"
	echo "|__________________________________________|"
}

option_detail() {
	cat <<EOF

Το shelldio έχει τις παρακάτω επιλογές

	Χρήση: shelldio [όρισμα]

Αν δεν δοθεί όρισμα, το shelldio θα ξεκινήσει με τους αγαπημένους σας σταθμούς (εφόσον υπάρχουν)

Αν θέλουμε να ξεκινήσουμε το shelldio με όρισμα τότε αυτό μπορεί να είναι ένα απο τα παρακάτω:

	-a, --add : Δημιουργεί το αρχείο ~/.shelldio/my_stations.txt
				στο οποίο μεταφέρει τους αγαπημένους σας σταθμούς
	-f, --fresh : Κατεβάζει εκ νέου την λίστα των σταθμών 
				  με επικαιροποιημένους ραδιοφωνικούς σταθμούς
	
	-h, --help: Εμφανίζει πληροφορίες για την χρήση της εφαρμογής
	
	-l, --list: Εμφανίζει την λίστα με τους ραδιοφωνικούς σταθμούς.
	
	-r, --remove: Διαγράφει σταθμούς της επιλογής σας από το my_stations.txt
EOF
}

# Δημιουργεί και εμφανίζει σε λίστα τους σταθμούς στο txt file που δέχεται σαν flag
list_stations() {
	while IFS='' read -r line || [[ -n "$line" ]]; do
		num=$((num + 1))
		echo ["$num"] "$line" | cut -d "," -f1
	done <"$1"
}

# Πληροφορίες που εμφανίζονται μετά την επιλογή του σταθμού
info() {
	welcome_screen
	echo -ne "| Η ώρα είναι $(date +"%T")\n| Ακούτε $stathmos_name\n| Πατήστε Q/q για έξοδο ή R/r για επιστροφή στη λίστα σταθμών"
}

add_stations() {
	echo "Εμφάνιση λίστας σταθμών"
	sleep 2
	list_stations "$all_stations"
	while true; do
		read -rp "Επέλεξε αριθμού σταθμού  (Q/q για έξοδο): " input_station
		if [[ $input_station = "q" ]] || [[ $input_station = "Q" ]]; then
			echo "Έξοδος..."
			exit 0
		elif [ "$input_station" -gt 0 ] && [ "$input_station" -le $num ]; then #έλεγχος αν το input είναι μέσα στο εύρος της λίστας των σταθμών
			station=$(sed "${input_station}q;d" "$all_stations")
			stathmos_name=$(echo "$station" | cut -d "," -f1)
			stathmos_url=$(echo "$station" | cut -d "," -f2)
			echo "$stathmos_name,$stathmos_url" >>"$my_stations"
			echo " Προστέθηκε ο σταθμός $stathmos_name."
		else
			echo "Αριθμός εκτός λίστας"
		fi
	done
	exit 0

}

remove_station() {
	if [ ! -f "$HOME/.shelldio/my_stations.txt" ]; then
		echo "Δεν έχει δημιουργηθεί το αρχείο my_stations."
		echo "Για πληροφορίες τρέξε την παράμετρο --help."
	else
		echo "Εμφάνιση λίστας προσωπικών σταθμών"
		sleep 2
		list_stations "$my_stations"
		while true; do
			read -rp "Επέλεξε αριθμού σταθμού  (Q/q για έξοδο): " remove_station
			if [[ $remove_station = "q" ]] || [[ $remove_station = "Q" ]]; then
				echo "Έξοδος..."
				exit 0
			elif [ "$remove_station" -gt 0 ] && [ "$remove_station" -le $num ]; then #έλεγχος αν το input είναι μέσα στο εύρος της λίστας των σταθμών
				station=$(sed "${remove_station}q;d" "$my_stations")
				stathmos_name=$(echo "$station" | cut -d "," -f1)
				grep -v "$stathmos_name" "$HOME/.shelldio/my_stations.txt" > "$HOME/.shelldio/my_stations.tmp" && mv "$HOME/.shelldio/my_stations.tmp" "$HOME/.shelldio/my_stations.txt"
				echo "Διαγράφηκε ο σταθμός $stathmos_name."
			else
				echo "Αριθμός εκτός λίστας"
			fi
		done
	fi
}

### Λίστα με τις επιλογές σαν 1ο όρισμα shelldio --[option]

while [ "$1" != "" ]; do
	case $1 in
	-h | --help)
		option_detail
		exit
		;;
	-l | --list)
		welcome_screen
		while true; do
			if [ -f "$my_stations" ]; then
				read -rp "Θέλετε να εμφανισθούν όλοι οι σταθμοί ή οι αγαπημένοι σας σταθμοί; (a=Όλοι οι σταθμοί | f=Αγαπημένοι):" list_choice
				if [ "$list_choice" == "a" ]; then
					echo "Εμφάνιση όλων των σταθμών:"
					sleep 1
					list_stations "$all_stations"
					exit 0
				elif [ "$list_choice" == "f" ]; then
					echo "Εμφάνιση αγαπημένων σταθμών:"
					sleep 1
					list_stations "$my_stations"
					exit 0
				else
					echo "Λάθος επιλογή, θα πρέπει να γράψετε a ή f και να πατήσετε enter"
				fi
			else
				list_stations "$all_stations"
				exit 0
			fi
		done
		;;
	-a | --add)
		welcome_screen
		add_stations
		exit
		;;
	-r | --remove)
		welcome_screen
		remove_station
		exit
		;;
	-f | --fresh)
		welcome_screen
		echo "Γίνεται λήψη του αρχείου των σταθμών από το αποθετήριο."
		sleep 1
		curl -sL https://raw.githubusercontent.com/CerebruxCode/shelldio/stable/.shelldio/all_stations.txt --output "$HOME/.shelldio/all_stations.txt"
		exit
		;;
	esac
done

### Base script

while true; do
	terms=0
	trap ' [ $terms = 1 ] || { terms=1; kill -TERM -$$; };  exit' EXIT INT HUP TERM QUIT

	# Έλεγχος αν υπάρχει ο mpv
	if ! command -v mpv &>/dev/null; then
		echo "Δεν βρέθηκε συμβατός player. Συμβατός player είναι ο mpv"
		exit
	fi

	if [ "$#" -eq "0" ]; then #στην περίπτωση που δε δοθεί όρισμα παίρνει το προκαθορισμένο αρχείο
		if [ -d "$HOME/.shelldio/" ]; then
			if [ -f "$my_stations" ]; then
				if [ -s "$my_stations" ]; then
					stations="$my_stations"
				else
					stations="$all_stations"
				fi
			else
				if [ ! -f "$all_stations" ]; then
					echo "Δεν ήταν δυνατή η εύρεση του αρχείου σταθμών. Γίνεται η λήψη του..."
					sleep 2
					curl -sL https://raw.githubusercontent.com/CerebruxCode/shelldio/stable/.shelldio/all_stations.txt --output "$HOME/.shelldio/all_stations.txt"
				fi
				stations="$all_stations"
			fi
		else
			echo "Δημιουργείται ο κρυφός φάκελος .shelldio ο οποίος θα περιέχει τα αρχεία των σταθμών."
			sleep 2
			mkdir -p "$HOME/.shelldio"
			echo "Γίνεται η λήψη του αρχείου με όλους τους σταθμούς."
			sleep 2
			curl -sL https://raw.githubusercontent.com/CerebruxCode/shelldio/stable/.shelldio/all_stations.txt --output "$HOME/.shelldio/all_stations.txt"
			stations="$all_stations"
		fi
	else
		stations="$1"
	fi

	while true; do

		welcome_screen

		num=0

		list_stations "$stations"

		if [ ! -f "$my_stations" ]; then
			echo "Από προεπιλογή η λίστα σταθμών περιέχει όλους τους σταθμούς."
			echo "Μπορείς να δημιουργήσεις ένα αρχείο με τους αγαπημένους σου σταθμούς."
			echo "shelldio --help για να δεις πως μπορείς να το κάνεις!"
		elif [ ! -s "$my_stations" ]; then
			echo "Το αρχείο my_stations.txt υπάρχει αλλά είναι κενό."
			echo "Θα φορτώσει η λίστα με όλους τους σταθμούς."
			echo "Αν θέλεις να προσθέσεις αγαπημένους σταθμούς δοκίμασε την επιλογή add"
			echo "shelldio --add"
		fi
		echo "---------------------------------------------------------"
		read -rp "Διαλέξτε Σταθμό (ή Q/q για έξοδο): " input_play

		if [[ $input_play = "q" ]] || [[ $input_play = "Q" ]]; then
			echo "Έξοδος..."
			exit 0
		elif [ "$input_play" -gt 0 ] && [ "$input_play" -le $num ]; then #έλεγχος αν το input είναι μέσα στο εύρος της λίστας των σταθμών
			station=$(sed "${input_play}q;d" "$stations")
			stathmos_name=$(echo "$station" | cut -d "," -f1)
			stathmos_url=$(echo "$station" | cut -d "," -f2)
			break
		else
			echo "Αριθμός εκτός λίστας"
			sleep 2
			clear
		fi
	done

	mpv "$stathmos_url" &>/dev/null &

	while true; do
		clear
		info
		sleep 0
		read -r -n1 -t1 input_play # Για μικρότερη αναμονή της read
		if [[ $input_play = "q" ]] || [[ $input_play = "Q" ]]; then
			clear
			echo "Έξοδος..."
			exit 0
		elif [[ $input_play = "r" ]] || [[ $input_play = "R" ]]; then
			for pid in $(pgrep '^mpv$'); do
				url="$(ps -o command= -p "$pid" | awk '{print $2}')"
				if [[ "$url" == "$stathmos_url" ]]; then
					echo "Έξοδος..."
					kill "$pid"
				else
					printf "Απέτυχε ο αυτόματος τερματισμός. \nΠάτα τον συνδυασμό Ctrl+C ή κλείσε το τερματικό \nή τερμάτισε το Shelldio απο τις διεργασίες του συστήματος"
				fi
			done
			clear
			echo "Επιστροφή στη λίστα σταθμών"
			sleep 2
			clear
			break
		fi

	done

done
