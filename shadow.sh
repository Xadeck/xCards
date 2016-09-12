#!/usr/local/bin/bash

if ((BASH_VERSINFO[0] < 4)); then
  echo "This script requires bash version 4"
  exit 1
fi

# Read arguments from the command line
SRC=$1       # input image
PERCENT=$2   # a percentage of the width
DST=$3       # where to save the image

# Compute dimensions from the given size
IFS='x' read -ra DIMENSIONS <<< $SPEC
WIDTH=$(identify -format %w $SRC)
HEIGHT=$(identify -format %h $SRC)
SIGMA=$[WIDTH * PERCENT / 500] # one fifth of increase in width (empirically found)

# Compute a shadow image if it does not exist already.
SHADOW=/tmp/shadow-${WIDTH}x${HEIGHT}.png
if [ ! -f $SHADOW ]; then
  echo "Generating shadow ${WIDTH}x${HEIGHT}..."
  # Imagemagick script to generate an enlarged drop shadow around the card.
  # (in [] is the size of the image stack after the command)
  #
  #    load from $SRC, specifying image stayed centered with transparent background
  # [1] enlarge the image by $PERCENT
  # [1] get it's alpha mask (white for card, black around)
  # [1] clone and invert (black for card, white around) 
  # [2] swap the two previous images 
  # [2] and composite them (black for card, transparent around)
  # [1] gaussian blur that result (represents the shadow)
  #     save to $DST
  convert $SRC -gravity center -background none \
         -extent $[100+PERCENT]% \
         -alpha extract \
         \( +clone -negate \) -swap 0,1 \
         -alpha Off -compose CopyOpacity -composite \
         -virtual-pixel transparent \
         -gaussian-blur 0x$SIGMA \
         $SHADOW
fi
# Imagemagick script to combine drop shadow and the card.
# (in [] is the size of the image stack)
#
#    load from $SRC, specifying image stayed centered with transparent background
# [1] enlarge the image by $PERCENT
# [1] load shadow
# [2] composite the two
# [1] resize to initial width height
#     save to $DST
convert $SRC -gravity center -background none \
        -extent $[100+PERCENT]% \
        $SHADOW \
        -compose Dst_Over -composite \
        -geometry ${WIDTH}x${HEIGHT} \
        $DST        

echo "Added shadow to $SRC(${WIDTH}x${HEIGHT}) -> $DST($(identify -format %w $DST)x$(identify -format %h $DST))"