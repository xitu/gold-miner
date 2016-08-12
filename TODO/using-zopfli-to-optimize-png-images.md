>* 原文链接 : [Using Zopfli to Optimize PNG Images](https://ariya.io/2016/06/using-zopfli-to-optimize-png-images)
* 原文作者 : [Ariya Hidayat](https://ariya.io/about)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [cyseria](https://github.com/cyseria)
* 校对者:[yifili09](https://github.com/yifili09), [rccoder](https://github.com/rccoder)

# 使用使用Zopfli优化PNG图片

[PNG格式](http://www.libpng.org/pub/png/) 在图片存储中是个很有用的格式，因为他能够保护截图的颜色不失真，能够很好地还原所有图片信息。然而，有许多图像应用并不提供导出较小 PNG 格式图片的功能。幸好，我们可以用一个 Google 发布的扩展工具 [Zopfli](https://en.wikipedia.org/wiki/Zopfli) 来解决这个问题。

Zopfli 是实现 DEFLATE 的编码器，这是一个 PNG 格式中常用的压缩方法（当然也有很多其他的方法来压缩 png，像 ZIP 等等），用来输出可能的最小压缩文件。由于他是一种无损转换，用 Zopfli 做再次压缩的 PNG 文件仍有预期中的像素。

![zopflipng](https://ariya.io/images/2016/06/zopflipng.png)

对于一个有很多 png 图片的 web 服务，将所有图片都用 `Zopfli` 来做压缩是非常有利的。使用（不失真的）压缩图片可以让（文件）传输更快，这就意味着网站访客能得到更好的用户体验。如果网站非常受欢迎，那就可能会显著的节省总带宽了。


在 Linux 或者 macOS（之前叫 OS X ）系统编译 `Zopfli` 非常简单：
```
    $ git clone https://github.com/google/zopfli.git
    $ cd zopfli
    $ make zopflipng
```

之后，我通常会将 `zopflipng` 复制到 `~/bin` 中
```
    $ cp ./zopflipng ~/bin
    $ ./zopflipng
    ZopfliPNG, a Portable Network Graphics (PNG) image optimizer.

    Usage: zopflipng [options]... infile.png outfile.png
           zopflipng [options]... --prefix=[fileprefix] [files.png]...
```

压缩单张图片：
```
$ zopflipng screenshot.png screenshot_small.png
```
注意，由于 Zopfli 压缩是[CPU密集型操作](https://developers.googleblog.com/2013/02/compress-data-more-densely-with-zopfli.html)，过程中往往需要几秒钟。

对于批量转换，需要一个简单的脚本来做辅助。我写了一个简单的脚本 `png-press.sh`
```
    #!/usr/bin/env sh

    tmpfile=$(mktemp)
    zopflipng -m -y $1 $tmpfile
    mv $tmpfile $1
```

现在可以进入一个全是图片的目录并执行：
```
    $ find . -iname *.png  | xargs -I % ./png-press.sh %
```

作为一个插画网站，这个博客有超过280张png图片（大多都是截图），总共占了  24.4MB 的空间。执行上述步骤之后，空间占用量减少到了 19.1MB。节省了整整 5MB 空间！

现在，你有什么理由不使用 Zopfliy 优化去优化你的截图呢？




