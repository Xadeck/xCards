#!/usr/local/bin/bash

if ((BASH_VERSINFO[0] < 4)); then
  echo "This script requires bash version 4"
  exit 1
fi

# Read arguments from the command line
SRC=$1    # input image
SPEC=$2   # dimensions specification e.g. 100x200x10
DST=$3    # where to save the image

# Compute dimensions from the given size
IFS='x' read -ra DIMENSIONS <<< $SPEC
WIDTH=${DIMENSIONS[0]}   # will be 200 in example above
HEIGHT=${DIMENSIONS[1]}  # will be 100 in example above
PERCENT=${DIMENSIONS[2]}   # will be 10% in example above
SIGMA=$[WIDTH * PERCENT / 500] # one fifth of increase in width (empirically found)

# Imagemagick script to put a drop shadow around the card.
# (in [] is the size of the image stack)
#
#    load from $SRC, specifying image stayed centered with transparent background
# [1] enlarge the image by $PERCENT
# [2] clone it and get it's alpha mask (white for card, black around)
# [3] clone and invert (black for card, white around) 
# [3] swap the two previous images 
# [2] and composite them (black for card, transparent around)
# [2] gaussian blur that result (represents the shadow)
# [1] composite with the enlarged image
# [1] resize to initial width height
#     save to $DST
convert $SRC -gravity center -background none \
       -extent $[100+PERCENT]% \
        \( +clone -alpha extract \
          \( +clone -negate \) -swap 0,1 \
          -alpha Off -compose CopyOpacity -composite \
          -virtual-pixel transparent \
          -gaussian-blur 0x$SIGMA \) \
        -compose Dst_Over -composite \
        -geometry ${WIDTH}x${HEIGHT} \
        $DST        

echo "Added shadow to $SRC -> $DST (both are ${WIDTH}x${HEIGHT})"