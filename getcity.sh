#!/bin/bash

# Vorwahlen CSV:
# https://www.bundesnetzagentur.de/SharedDocs/Downloads/DE/Sachgebiete/Telekommunikation/Unternehmen_Institutionen/Nummerierung/Rufnummern/ONRufnr/Vorwahlverzeichnis_ONBzip.html

# Lege die CSV Datei im gleichen Ordner wie das Script ab. Die CSV muss "vorwahl.csv" heißen.
# Starte das Script mit der Nummer als Parameter, also "bash getcity.sh 017134..."

# Geschrieben von
# Matthias Pröll <proell.matthias@gmail.com>
# Letzte Anpassung: 2019/12/06

# set const
CURRENTFOLDER=`pwd`
SCRIPTNAME=`basename "$0"`

#Check if number was given
if [ -z "$1" ]; then
    clear
    echo "Bitte Nummer als Parameter übergeben!"
    echo
    echo "Beispiel:"
    echo
    echo "bash $SCRIPTNAME 017134..."
    echo
    exit 1
fi

# Get Infos from CSV file
if [ -f "$CURRENTFOLDER/vorwahl.csv" ];then
    CSVDATEN=`cat "$CURRENTFOLDER/vorwahl.csv"`
else
    clear
    echo "CSV Datei nicht gefunden!"
    echo
    echo "Bitte lade die CSV Datei von diesem Link herunter und platziere in $CURRENTFOLDER als vorwahl.csv :"
    echo
    echo "https://www.bundesnetzagentur.de/SharedDocs/Downloads/DE/Sachgebiete/Telekommunikation/Unternehmen_Institutionen/Nummerierung/Rufnummern/ONRufnr/Vorwahlverzeichnis_ONBzip.html"
    echo
    exit 1
fi

givenphonenumber="$1"

if [[ `echo "$givenphonenumber" | head -c 2` == '01' ]];then
    echo "Handynummer"
    exit
fi

givenphonenumber=`echo "$1" | sed -e 's/^\s*.//g' -e 's/+49//g'`
sumofnumbers=`echo -n $givenphonenumber | wc -c`
echo "$CSVDATEN" | grep "$givenphonenumber" | cut -d ';' -f 2

while [[ $sumofnumbers > 0 ]];do

    checkphonenumber=`echo "$givenphonenumber" | head -c "$sumofnumbers"`
    city=`echo "$CSVDATEN" | grep "$checkphonenumber"`

    if [[ "$?" == 0 ]];then
        city=`echo $city | cut -d ';' -f 2`
        echo "$city"
        exit
    fi
    let sumofnumbers-- 
done