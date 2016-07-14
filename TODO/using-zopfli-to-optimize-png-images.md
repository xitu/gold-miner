>* 原文链接 : [Using Zopfli to Optimize PNG Images](https://ariya.io/2016/06/using-zopfli-to-optimize-png-images)
* 原文作者 : [Ariya Hidayat](https://ariya.io/about)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


[PNG format](http://www.libpng.org/pub/png/) is very useful because it preserve all the colors, making it suitable to depict a screenshot faithfully. Unfortunately, many graphics applications do not produce a PNG file with the smallest possible size. Fortunately, this situation can be remedied using an additional tool such as [Zopfli](https://en.wikipedia.org/wiki/Zopfli) from Google.

Zopfli is an encoder implementation of [DEFLATE](https://tools.ietf.org/html/rfc1951), a compression method commonly used in PNG format (among many other usages, e.g. ZIP, etc), designed to produce the likely smallest compressed output. Since it is a [lossless](https://en.wikipedia.org/wiki/Lossless_compression) transformation, a PNG file that is recompressed with Zopfli still retains all the pixels as expected.

![zopflipng](https://ariya.io/images/2016/06/zopflipng.png)

For a web site that serve a lot of PNGs, it is beneficial to run Zopfli on all the PNG images. Making the files smaller (without losing any pixels) means that the web site visitor will enjoy an improved experience due to a faster transport. If the site is extremely popular, the total bandwidth saving could be significant.

Compiling Zopfli on Linux or macOS (formerly known as OS X) is easy:

    $ git clone https://github.com/google/zopfli.git
    $ cd zopfli
    $ make zopflipng

After this, usually I stash the `zopflipng` executable to my `~/bin`:

    $ cp ./zopflipng ~/bin
    $ ./zopflipng
    ZopfliPNG, a Portable Network Graphics (PNG) image optimizer.

    Usage: zopflipng [options]... infile.png outfile.png
           zopflipng [options]... --prefix=[fileprefix] [files.png]...

To optimize a single image:

    $ zopflipng screenshot.png screenshot_small.png

Note that since Zopfli’s compressor is a [CPU-intensive operation](https://developers.googleblog.com/2013/02/compress-data-more-densely-with-zopfli.html), the process often takes a few seconds.

For a batch conversion, a simple script can be helpful. For instance, I have this `png-press.sh`:

    #!/usr/bin/env sh

    tmpfile=$(mktemp)
    zopflipng -m -y $1 $tmpfile
    mv $tmpfile $1

Now go to a directory full of images and run:

    $ find . -iname *.png  | xargs -I % ./png-press.sh %

As an illustration, this blog site has over 280 PNG images (mostly screenshots), taking a total of 24.4 MB in space. After running the above step, the space consumption is reduced to only 19.1 MB. A good 5 MB saving!

Now, what’s your excuse not to Zopfliy your screenshots?

