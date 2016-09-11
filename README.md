Initial card design obtained from https://sourceforge.net/projects/vector-cards/?source=typ_redirect

They were split into single files using https://www.sketchapp.com/

They were then converted using http://www.imagemagick.org/ with

```bash
convert -background none -size 320x480 $src $dst
convert -background none -size 750x1334 $src $dst
convert -background none -size 1242x2208 $src $dst
```
where the size were obtained from https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions

Since cards have a different aspect ratio, the resulting size are

```
320x449
750x1053
1242x1744
```

A drop shadow was then added using imagemagick and the `shadow.sh` script. Each size is enlarged by ~30% of its width.

```
shadow png/1x/2C.png 320x449x30 
```

