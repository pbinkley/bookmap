# find most common page size:
identify *.jp2 | awk '{ print $3; }' | sort | uniq -c

# choose dimensions, calculate todal pixels: e.g. 1866x2884 = 5381544
# use those values to generate uniform page images:

ls source/dertotentanzvier00holb_jp2/*.jp2 | xargs -n 1 -I {} convert {} -thumbnail 5381544@ -gravity center -background white -extent 1866x2884 pages/`echo {} | sed 's/\//_/g'`.jpg

# merge page images into master
# montage tied the machine up completely: should run with increased niceness
montage -geometry +0+0 *.jpg ../../output.jpg

# installing gdal was difficult due to conflict with previous install; had to 
# overwrite lots of bits. To get python module to work, had to add to PYTHONPATH:
export PYTHONPATH=/usr/local/lib/python2.7/site-packages

gdal2tiles.py -p raster -w openlayers output.jpg

# this creates a directory named after the image, containing all the tile 
# directories, and a file "openlayers.html" which gives a basic zoomable view
