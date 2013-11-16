Bookmap
=======

Generate an OpenLayers-based zoomable image of all the pages of an Internet Archive book, layed out as a grid.

This is a pair of bash scripts that download the JPEG2000 files from a given Internet Archive scanned book, generate a single large image containing all the pages in a grid, and produce an HTML file that gives an OpenLayers-based zoomable view of the whole book. See an example here: http://www.wallandbinkley.com/bookmap/storyofdoghisuse00ceci/openlayers.html

These packages must be available on the path:

- ImageMagick
- [jq][1]
- [gdal][2]
- python

To generate a view for a given IA item "abxxxx", there are two steps

- run "./fetch.sh abxxxx" - this will download and unzip the JPEG2000s
- run "./process.sh abxxxx"

Process.sh will generate a uniform JPEG image of each page, using the most common dimensions found among the JPEG2000s. Pages that do not have these dimensions will be cropped or padded to fit. It will then use ImageMagick's montage to stitch the page images into a single image. This can take a very long time (three hours for a 244-page book on a MacBook Pro), and will initially tie up the CPU to a great extent; after a few minutes it will relax its grip and make the machine more responsive. Finally, process.sh will run GDAL to generate the tiles and the html file. They will be created in a directory named with the Internet Archive ID.

The example took about three hours to process, and the generated tiles allowed nine levels of zoom and came to 2.2gb. For the example linked above, I have removed the lowest two levels, leaving 200mb of tiles, in order to save server space.

I have developed this under OS/X but the tools should all run on Linux, and perhaps on Windows.

Note: I installed jq and gdal with Homebrew. I had trouble with gdal because of conflicts with an earlier attempt to install it from source. I also had trouble adding JPEG2000 support to ImageMagick from Homebrew, and ended up installing this package instead: http://cactuslab.com/imagemagick/



> Written with [StackEdit](https://stackedit.io/).


  [1]: http://stedolan.github.io/jq/
  [2]: http://www.gdal.org/
