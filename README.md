Initial card design obtained from https://sourceforge.net/projects/vector-cards/?source=typ_redirect

They were split into single files using [Sketch](https://www.sketchapp.com/)

They were then converted to fix the maximum sized indicated by https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions, that is:

```
320x480
750x1334
1242x2208
```

Poker cards have dimensions of 63.5x88.9 according to [wikipedia](https://en.wikipedia.org/wiki/Standard_52-card_deck), which means an aspect ratio of 0.714. Applying that to above dimensions with fixed width yields the following sizes:

```
320x448
750x1050
1242x1739
```

Using [ImageMagick](http://www.imagemagick.org/), conversion is done via:

```bash
for svg in $(find svg -name \*.svg); do
  basename=$(basename $svg .svg)
  convert -background none -resize   320x448\! $svg png/1x/${basename}.png
  convert -background none -resize  750x1050\! $svg png/2x/${basename}.png
  convert -background none -resize 1242x1739\! $svg png/3x/${basename}.png
done
```

A drop shadow was then added using imagemagick and the `shadow.sh` script. Each size is enlarged by ~10% of its width (that is the `10` part of the command lines below).

```
find png/1x -name \*.png -print0 | xargs -0 -n 1 -I % ./shadow.sh % 10 final/1x/$(basename %)
find png/2x -name \*.png -print0 | xargs -0 -n 1 -I % ./shadow.sh % 10 final/2x/$(basename %)
find png/3x -name \*.png -print0 | xargs -0 -n 1 -I % ./shadow.sh % 10 final/3x/$(basename %)
```
