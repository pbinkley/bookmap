#!/bin/bash
# assume we have an IA id as first param
if [ "$1" = "" ]
then
  echo "Usage: $0 <Internet Archvie id>"
  exit
fi

IAID=$1

# find most common page size:
#DIMS=`identify source/$IAID\_jp2/*.jp2 | awk '{ print $3; }' | sort | uniq -c | sort -n | tail -1 | awk '{ print $2; }'`
DIMS=1866x2914
WIDTH=`echo $DIMS | awk -Fx '{ print $1; }'`
HEIGHT=`echo $DIMS | awk -Fx '{ print $2; }'`
PIXELS=$(($WIDTH * $HEIGHT))
echo Most common dimensions: $WIDTH x $HEIGHT = $PIXELS

# choose dimensions, calculate todal pixels: e.g. 1866x2884 = 5381544
# use those values to generate uniform page images:

echo Generating jpg images
ls source/$IAID\_jp2/*.jp2 | xargs -n 1 -I {} convert {} -thumbnail $PIXELS@ -gravity center -background white -extent $DIMS `echo {} | sed 's/\//_/g'`.jpg

# merge page images into master
# montage tied the machine up completely: should run with increased niceness
echo Generating master jpg: source/$IAID.jpg
time nice montage -geometry +0+0 source/$IAID\_jp2/*.jpg source/$IAID.jpg
identify source/$IAID.jpg

# generate tiles
# this creates a directory named after the image, containing all the tile 
# directories, and a file "openlayers.html" which gives a basic zoomable view
gdal2tiles.py -p raster -w openlayers source/$IAID.jpg
