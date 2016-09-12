This projects contains a set of high-res images of poker cards, with a drop shadows for use in iOS applications. It also contains instructions to regenerate them at any resolution or with different shadow parameters.

![king of spades](https://raw.githubusercontent.com/Xadeck/cards/master/final/1x/KS.png)

Initial card design obtained from https://sourceforge.net/projects/vector-cards/?source=typ_redirect
They were split into single files using [Sketch](https://www.sketchapp.com/)
They were then converted to fix the maximum sized indicated by https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions, that is:

```
320x480
750x1334
1242x2208
```

Poker cards have dimensions of 63.5cmx88.9cm according to [wikipedia](https://en.wikipedia.org/wiki/Standard_52-card_deck), which means an aspect ratio of 0.714. Applying that to above dimensions with fixed width yields the following sizes:
  
```
320x448
750x1050
1242x1739
```

Using [ImageMagick](http://www.imagemagick.org/), conversion is done via:

```bash
for svg in $(find svg -name \*.svg); do
  basename=$(basename $svg .svg)
  options="-background none -density 1200"
  convert $options -resize   320x448\! $svg png/1x/${basename}.png
  convert $options -resize  750x1050\! $svg png/2x/${basename}.png
  convert $options -resize 1242x1739\! $svg png/3x/${basename}.png
done
```

A drop shadow was then added using imagemagick and the `shadow.sh` script. Each size is enlarged by ~10% of its width (that is the `10` part of the command lines below).

```
for png in $(find png -name \*.png); do
  ./shadow.sh $png 10 ${png/#png/final}
done
```
