#!/bin/bash
# assume we have an IA id as first param
if [ "$1" = "" ]
then
  echo "Usage: $0 <Internet Archvie id>"
  exit
fi

IAID=$1
echo Fetching $IAID

wget -O source/$IAID.json https://archive.org/details/$IAID?output=json
DIR=`jq -r '.dir' source/$IAID.json`
SERVER=`jq -r '.server' source/$IAID.json`
JP2='_jp2.zip'
ZIP=$IAID$JP2

mkdir source

if [ -e "source/$ZIP" ]
then
	echo "source/$ZIP exists, not downloading again"
else
	echo Fetching  https://$SERVER$DIR/$ZIP
	wget -O source/$ZIP https://$SERVER$DIR/$ZIP
fi

echo Unzipping $ZIP
cd source
unzip $ZIP
 
 
