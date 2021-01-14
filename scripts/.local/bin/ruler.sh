#!/bin/bash
# Take user parameters or set defaults
# From https://www.ibm.com/developerworks/library/l-pixelruler/index.html
rulername="${1:-ruler.gif}"
rulerlength="${2:-572}"
drawstring=""
# Build the line definitions for the ruler marks
for x1 in $(seq 0 72 "$rulerlength"); do
    drawstring="$drawstring line $x1,70 $x1,100"
    for x2 in 0 36; do
        offset=$((x1 + x2))
        drawstring="$drawstring line $offset,80 $offset,100"
        for x3 in $(seq 6 6 30); do
            offset2=$((offset + x3))
            drawstring="$drawstring line $offset2,90 $offset2,100"
        done
    done
done
# Add the labels
labelfont="-fill black -font Cantarell -pointsize 24 -draw"
labelstring="text 0,60 '0' "
for x3 in 72; do
  offset3=$((x3 - 12))
  labelstring="$labelstring text $offset3,60 '$x3' "
done
for x4 in $(seq 144 72 $rulerlength); do
  offset4=$((x4 - 18))
  labelstring="$labelstring text $offset4,60 '$x4' "
done
# Add a title
titledimension=$(convert -size 572x100 xc:lightblue -font Cantarell\
  -pointsize 36  -fill black -undercolor lavender\
  -annotate +40+50 'Pixel Ruler' -trim info: | awk ' {print $3 } ')
titlewidth=${titledimension%x*}
titlefont="-fill NavyBlue -font Cantarell -pointsize 36"  
titlepos=$(((rulerlength - titlewidth) / 2))
titletext="text $titlepos,30 'Pixel Ruler' "
# Create the ruler
convert -size "${rulerlength}x100" xc:lightblue \
 -fill black  -draw "$drawstring" $labelfont "$labelstring" \
 $titlefont -draw "$titletext" "$rulername"
