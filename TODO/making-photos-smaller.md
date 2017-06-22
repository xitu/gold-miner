> * 原文地址：[Making Photos Smaller Without Quality Loss](https://engineeringblog.yelp.com/2017/06/making-photos-smaller.html)
> * 原文作者：[Stephen Arthur](https://engineeringblog.yelp.com/2017/06/making-photos-smaller.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# 如何在无损的情况下让图片变的更小

Yelp（美国最大点评网站）已经有超过 1 亿张用户上传的照片了，其中有他们的晚餐，发型，对于一个我们最新的特性，[#yelfies](https://www.yelpblog.com/2016/11/yelfie)。这些上传图片的账户占据了我们 app 和网站的主要带宽，同时也代表了主要的存储和传输成本。为了给我们的用户最好的用户体验，我们竭尽所能的优化我们的图片，最终达到图片大小平均减少 30%。这不仅节省了我们用户的时间和带宽，还减少了我们的服务器成本。对了，关键的是我们的这个过程是完全无损的！

# 背景

Yelp 保存用户上传的图片已经有 12 年了。我们将 PNG 和 GIF 保存为无损格式的 PNG，其他格式的保存为 JPEG。我们使用 Python 和 [Pillow](https://python-pillow.org/) 保存图片，让我们直接从上传图片开始吧：

```
# do a typical thumbnail, preserving aspect ratio
new_photo = photo.copy()
new_photo.thumbnail(
    (width, height),
    resample=PIL.Image.ANTIALIAS,
)
thumbfile = cStringIO.StringIO()
save_args = {'format': format}
if format == 'JPEG':
    save_args['quality'] = 85
new_photo.save(thumbfile, **save_args)
```

现在让我们开始研究研究有没有一种文件大小的优化方式可以以无损的形式进行。

# 优化

首先，我们要决定是选择我们自己，还是一个 CDN 提供商 [magically change](https://www.fastly.com/io) 来处理我们的图片。在高质量内容优先的情况下，评估如何在图片大小和质量之间做取舍就显得非常重要了。让我们来研究一下当前图片文件减小的一些方法，我们可以做哪些改变以及每种方法我们可以减少多少大小和质量。完成这项研究之后，我们决定

1. Pillow 中的改变
- 优化 flag
- 渐进式 JPEG
2. 更改应用的照片逻辑
- 大 PNG 检测
- JPEG 动态质量
3. 更换 JPEG 编码器
- Mozjpeg (栅格量化，自定义量化矩阵)

# Pillow 中的改变

## 优化 Flag

这是我们做的其中一个最简单的改变：启用 Pillow 中负责额外文件大小的设置来节约 CPU 耗时 (`optimize=True`)。由于本质没变，所有这对于图片质量丝毫没有影响。

对于 JPEG 来说，对个选项告诉编码器通过对每个图片进行一次额外的扫描以找到最佳的 [霍夫曼编码](https://en.wikipedia.org/wiki/Huffman_coding)。第一次，不写入文件，而是计算每个值出现的次数，以及可以计算出理想编码的必要信息。PNG 内部使用 zlib，所以优化 flag 就需要告诉编码器使用 `gzip -9` 而不是 `gzip -6`。

这是一个很简单的改变，但是事实证明它也不是银弹，只减少了百分之几。

## 渐进式 JPEG

当我们将一张图片保存为 JPEG 时，你可以从下面的选项中选择不同的类型：

- 基线从顶部到底部载入 JPEG 图片
- 渐进式 JPEG 图片从模糊到清晰载入。渐进式的选项可以在 Pillow 中轻松的启用 (`progressive=True`)。这是一个能明显感觉到的性能提升(就是比起不是清晰的图片，只加载一半的图片更容易注意到。)

还有就是渐进式文件的被打包时会有一个小幅的压缩。更详细的解释请看 [Wikipedia article](https://en.wikipedia.org/wiki/JPEG#Entropy_coding)，JPEG 格式使用一个基于 8x8 像素块的 zigzag 的模式来编码。当这些像素块的值被解压并按顺序展开时，通常你会发现没有 0 也没有 0 的序列，那个模式会对图片的每一个 8x8 的像素块进行隔行扫描。使用渐进编码时，松散的像素块的顺序会逐渐改变。每个块的较大的值将会在文件中首先出现，(这就是一张渐进式图片的不同块的最早的扫描)，并且较长跨度的小值，包括 0，会在末尾添加更多完整详细的信息。这种图片数据的重新排列不会改变图片本身，但是或许在一行（这一行可以被更容易的压缩）中确实增加了 0 的数量。

一个美味的甜甜圈的图片的对比(点击放大)：

[![A mock of how a baseline JPEG renders.](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/baseline-tiny.gif)](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/baseline-large.gif)

基线 JPEG 渲染的模拟。

[![A mock of how a progressive JPEG renders.](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/progressive-tiny.gif)](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/progressive-large.gif)

渐进式 JPEG 渲染的模拟

# 更改应用的照片逻辑

## 大 PNG 检测

Yelp 为用户上传的图片主要提供两种格式 - JPEG 和 PNG。JPEG 对于照片来说是一个很棒的格式，但是对于高对比度的设计内容，类似 logo，就不那么优秀了。而 PNG 则是完全无损的，所以非常适用于图形类型的图片，但是对于微小变化不明显的图片又显得太大了。如果用户上传的 PNG 图片是照片的话，我们使用 JPEG 格式来存储会节省很大的空间。通常情况下，Yelp 上的 PNG 图片都是移动设备和给图片加特效的 app 的截图。

![(left) A typical composited PNG upload with logo and border. (right) A typical PNG upload from a screenshot.](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/example-pngs.png)

(左边) 一张明显的 PNG 合成图。(右边) 一张明显的 PNG 的截图。

我们想减少这些不必要的 PNG 图片的数量，但重要的是要避免过度干预，改变格式或者损坏图片的质量。那么，如何才能像素来判断一张图片是照片呢？

通过一组 2500 张图片的实验样本，我们发现文件大小和独立像素结合起来可以很好的帮助我们判断。我们在最大分辨率下生成我们的候选缩略图，然后看看输出的 PNG 文件是否大于 300KB。如果是，我们就检测图片内容是否有超过 2^16 个独立像素(Yelp 会将 RGBA 图片转化为 RGB，即使不转，我们也会做这个检测。)

在实验数据集中，这些手动调优的参数可以减少**高达** 88% 的文件大小(也就是说，如果我们将所有的图片都转换的话，我们预期可以节约的存储空间)，并且还是在对精细图片没有任何负面影响的情况下。

## JPEG 动态质量

第一个也是最广为人知的减小 JPEG 文件大小的方法就是设置 `quality`。很多应用保存 JPEG 时都会设置一个特定质量数值。

质量其实是个很抽象的概念。实际上，一张 JPEG 图片的每个颜色通道都有不同的质量。质量等级从 0 到 100 在不同的颜色通道上都对应不同的[量化表](https://en.wikipedia.org/wiki/JPEG#JPEG_codec_example)，同时也决定了有多少信息会丢失。JPEG 编码过程中处理丢失信息的第一步就是量化信号域。

减少文件大小最简单的方法其实就是降低图片的质量，引入更多的噪点。但是在给定的质量等级下，不是每张图片都会丢失同样多的信息。

我们可以动态的设置对于每张图片最优的的质量等级，在质量和大小之间找到一个平衡点。我们有以下两种方法可以做到这点：

- **Bottom-up：** 这些算法是在 8x8 像素块级别上处理图片来生成调优量化表的。它们会同时计算理论质量丢失量和和人眼视觉信息丢失量。
- **Top-down：** 这些算法是将一整张图片和它原版进行对对比然后检测出丢失了多少信息。通过不断的用不同的质量参数生成候选图片，然后选择丢失量最小的那一张。

我们评估一下 bottom-up 算法，到目前为止，在我们希望的高质量范围中它还没有得到一个让我们满意的结果(即使在中等质量这个编码器可以很大胆的处理丢失的字节的范围内它或许还有很大的潜力)。在 90 年代早期，这个算力昂贵并且选择捷径走了选项 B 的时代，发表了很多关于这个策略 [学术](https://vision.arc.nasa.gov/publications/spie93abw/spie93abw.html.d/spie93.html)[论文](ftp://ftp.cs.wisc.edu/pub/techreports/1994/TR1257.pdf) 。

所以我们选择第二种方法：使用二分法在不同的质量等级下生成候选图片，然后使用 [pyssim](https://github.com/jterrace/pyssim/) 计算它的结构相似矩阵 ([SSIM](https://en.wikipedia.org/wiki/Structural_similarity)) 来评估每张候选图片损失的质量，直到这个值不是静态阀值而是可配置的为止。这种方法可以让我们仅仅对那些不能感知到图片质量下降的那些图片选择更低的平均文件大小和平均质量。

在下面的图表中，我们画出了通过 3 个不同的质量等级生成的 2500 张图片的 SSIM 值的图像。

1. 蓝色的线为 `quality = 85` 生成的原始图。
2. 红色的线为`quality = 80` 生成的图。
3. 最后，橘色的图是我们最后使用的动态质量，参数为 `SSIM 80-85`。为一张图片基于汇合点或者超过 SSIM 比率（一个提前计算好的可以在图片范围的中部发生转变的的静态值）的地方在 80 到 85 (包括 85) 之间选择一个质量值。这种方法可以让我们在不降低我们最差质量图片的质量的情况下，有效的减小图片的大小。

![SSIMs of 2500 images with 3 different quality strategies.](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/ssims-strategies.png)

2500 张 3 种不同的质量策略的 SSIM 值。

### SSIM

这里有不少的可以模拟人类视觉系统的图片质量算法。我们已经评估了很多方法，但是 SSIM 对于基于特征的迭代优化算法是最有效的：

1. 对[ JPEG 量化误差](http://users.eecs.northwestern.edu/~pappas/papers/brooks_tip08.pdf)敏感。
2. 快速，简单的算法。
3. 可以不转换成 PNG 的 PIL 本地图片对象上计算，并且还可以通过命令行工具计算(查看 #2).

动态质量的实例代码：

```
import cStringIO
import PIL.Image
from ssim import compute_ssim


def get_ssim_at_quality(photo, quality):
    """Return the ssim for this JPEG image saved at the specified quality"""
    ssim_photo = cStringIO.StringIO()
    # optimize is omitted here as it doesn't affect
    # quality but requires additional memory and cpu
    photo.save(ssim_photo, format="JPEG", quality=quality, progressive=True)
    ssim_photo.seek(0)
    ssim_score = compute_ssim(photo, PIL.Image.open(ssim_photo))
    return ssim_score


def _ssim_iteration_count(lo, hi):
    """Return the depth of the binary search tree for this range"""
    if lo >= hi:
        return 0
    else:
        return int(log(hi - lo, 2)) + 1


def jpeg_dynamic_quality(original_photo):
    """Return an integer representing the quality that this JPEG image should be
    saved at to attain the quality threshold specified for this photo class.

    Args:
        original_photo - a prepared PIL JPEG image (only JPEG is supported)
    """
    ssim_goal = 0.95
    hi = 85
    lo = 80

    # working on a smaller size image doesn't give worse results but is faster
    # changing this value requires updating the calculated thresholds
    photo = original_photo.resize((400, 400))

    if not _should_use_dynamic_quality():
        default_ssim = get_ssim_at_quality(photo, hi)
        return hi, default_ssim

    # 95 is the highest useful value for JPEG. Higher values cause different behavior
    # Used to establish the image's intrinsic ssim without encoder artifacts
    normalized_ssim = get_ssim_at_quality(photo, 95)
    selected_quality = selected_ssim = None

    # loop bisection. ssim function increases monotonically so this will converge
    for i in xrange(_ssim_iteration_count(lo, hi)):
        curr_quality = (lo + hi) // 2
        curr_ssim = get_ssim_at_quality(photo, curr_quality)
        ssim_ratio = curr_ssim / normalized_ssim

        if ssim_ratio >= ssim_goal:
            # continue to check whether a lower quality level also exceeds the goal
            selected_quality = curr_quality
            selected_ssim = curr_ssim
            hi = curr_quality
        else:
            lo = curr_quality

    if selected_quality:
        return selected_quality, selected_ssim
    else:
        default_ssim = get_ssim_at_quality(photo, hi)
        return hi, default_ssim
```

这里有关于这项技术的其他的一些博客，[这篇](https://medium.com/@duhroach/reducing-jpg-file-size-e5b27df3257c) 是 Colt Mcanlis 写的。Etsy 也发表过[一篇](https://codeascraft.com/2017/05/30/reducing-image-file-size-at-etsy/)！快去看看吧！

# 更换 JPEG 编码器

## Mozjpeg

[Mozjpeg](https://github.com/mozilla/mozjpeg/) 是 [libjpeg-turbo](http://libjpeg-turbo.virtualgl.org/) 的一个开源分支，是通过执行时间来置换文件的大小的编码器。这种方法完美的契合离线批处理再生成图片。在比 libjpeg-turbo 多投入 3 到 5 倍的时间，和一点复杂的算法就可以使图片变的更小了！

mozjpeg 这个编码器最大的不同点就是使用了一张另外的量化表。就像上面提到的，质量是每一个颜色通道量化表的一个抽象的概念。默认 JPEG 量化表的所有信号点都十分容易击中。用 [JPEG 指导](https://www.w3.org/Graphics/JPEG/itu-t81.pdf) 中的话说就是：

> 这些表仅供参考，不能保证在任何应用中都是适用的。

所以说，大部分编码器的实现默认情况下使用这些表就不足为奇了。

Mozjpeg 已经渡过了我们替代表的基准测试，并且它新建的图片中也使用了最好表现的替代表。

## Mozjpeg + Pillow
大部分 Linux 发行版 都会默认安装 libjpeg。所以[默认情况下](https://github.com/python-pillow/Pillow/issues/539)在 Pillow 中是无法使用 mozjpeg 的，但是配置好它并不难。当你要用 mozjpeg 编译时，使用 `--with-jpeg8` 这个参数，并确认 Pillow 可以链接并找到它就可以了。如果你使用 Docker，你也可以像这样写一个 Dockerfile：
Most Linux distributions have libjpeg installed by default. So using mozjpeg under Pillow doesn’t work by [default](https://github.com/python-pillow/Pillow/issues/539), but configuring it isn’t terribly difficult either.
When you build mozjpeg, use the `--with-jpeg8` flag and make sure it can be linked by Pillow will find it. If you’re using Docker, you might have a Dockerfile like:

```
FROM ubuntu:xenial

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
	# build tools
	nasm \
	build-essential \
	autoconf \
	automake \
	libtool \
	pkg-config \
	# python tools
	python \
	python-dev \
	python-pip \
	python-setuptools \
	# cleanup
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and compile mozjpeg
ADD https://github.com/mozilla/mozjpeg/archive/v3.2-pre.tar.gz /mozjpeg-src/v3.2-pre.tar.gz
RUN tar -xzf /mozjpeg-src/v3.2-pre.tar.gz -C /mozjpeg-src/
WORKDIR /mozjpeg-src/mozjpeg-3.2-pre
RUN autoreconf -fiv \
	&& ./configure --with-jpeg8 \
	&& make install prefix=/usr libdir=/usr/lib64
RUN echo "/usr/lib64\n" > /etc/ld.so.conf.d/mozjpeg.conf
RUN ldconfig

# Build Pillow
RUN pip install virtualenv \
	&& virtualenv /virtualenv_run \
	&& /virtualenv_run/bin/pip install --upgrade pip \
	&& /virtualenv_run/bin/pip install --no-binary=:all: Pillow==4.0.0
```

这就 OK 了！编译它就就可以在你的图片工作流中使用支持 mozjpeg 的 Pillow 了。
That’s it! Build it and you’ll be able to use Pillow backed by mozjpeg within your normal images workflow.
# 影响
# Impact
那么这些方法到底带来了多少提升呢？让我们来研究研究，在 Yelp 的图片库中随机抽取 2500 张图片并使用我们的工作流来处理，看看文件大小都有什么变化：
How much did each of those improvements matter for us? We started this research by randomly sampling 2,500 of Yelp’s business photos to put through our processing pipeline and measure the impact on file size.

1. 更改 Pillow 的设置可以减小 4.5%
2. 大 PNG 检测可以减小 6.2%
3. 动态质量可以减小 4.5%
4. 更换为 mozjpeg 编码器可以减小 13.8%

5. Changes to Pillow settings were responsible for about 4.5% of the savings
6. Large PNG detection was responsible for about 6.2% of the savings
7. Dynamic Quality was responsible for about 4.5% of the savings
8. Switching to the mozjpeg encoder was responsible for about 13.8% of the savings

这些全部加起来可以让图片大小平均减小大概 30%，并且我们应用的是我们最大同时也是最常见的分辨率，对于用户来说我们的网页变的更快同时平均每天可以节约兆兆字节的数据传输量。从 CDN 上就可见一斑：
This adds up to an average image file size reduction of around 30%, which we applied to our largest and most common image resolutions, making the website faster for users and saving terabytes a day in data transfer. As measured at the CDN:

![Average filesize over time, as measured from the CDN (combined with non-image static content).](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/Filesize-over-time.png)

CDN 上的时间变化与平均文件大小的趋势图(包含非图片的静态内容)。
Average filesize over time, as measured from the CDN (combined with non-image static content).
# 我们没有做的
# What we didn’t do
这一部分是为了介绍一些其他你们可能会用到的改善的方法，Yelp 没有涉及到是因为我们选择的工具链以及一些其他的权衡。
This section is intended to introduce a few other common improvements that you might be able to make, that either weren’t relevant to Yelp due to defaults chosen by our tooling, or tradeoffs we chose not to make.
## 二次抽样
## Subsampling
[二次抽样](https://en.wikipedia.org/wiki/Chroma_subsampling) 是决定网页图片质量和文件大小的主要因素。大段的关于二次抽样的描述可以在网上找到，但是对于这篇博客简而言之就是我们已经使用 `4:1:1` 二次抽样过了(Pillow 在不指定任何参数的情况下的默认设置)，所以这里我们并不能得到任何提升。
[Subsampling](https://en.wikipedia.org/wiki/Chroma_subsampling) is a major factor in determining both quality and file size for web images. Longer descriptions of subsampling can be found online, but suffice it to say for this blog post that we were already subsampling at `4:1:1` (which is Pillow’s default when nothing else is specified) so we weren’t able to realize any further savings here.
## 有损 PNG 编码
## Lossy PNG encoding
看到我们对 PNG 的处理之后，你可以选择将一部分图片使用类似 [pngmini](https://pngmini.com/lossypng.html) 的有损编码器保存为 PNG，虽然我们选择把它们保存为 JPEG。这是另外一种合理的结果，通过没有修改用户的 PNG 就可以减小文件大小的 72-85% 。
After learning what we did about PNGs, choosing to preserve some of them as PNG but with a lossy encoder like [pngmini](https://pngmini.com/lossypng.html) could have made sense, but we chose to resave them as JPEG instead. This is an alternate option with reasonable results, 72-85% file size savings over unmodified PNGs according to the author.
## 动态格式
## Dynamic content types
支持更多的像 WebP，JPEG2k 这样的现代的图片类型正在计划中。即使这个项目我们运行了，因为用户请求的长尾效应，这些现在优化过的 JPEG 和 PNG 图片仍然是值得继续努力优化的。
Support for more modern content types like WebP or JPEG2k is certainly on our radar. Even once that hypothetical project ships, there will be a long-tail of users requesting these now-optimized JPEG/PNG images which will continue to make this effort well worth it.

## SVG

在我们的网站上很多地方都使用了 SVG，像我们的设计师按照我们的[风格指导](http://yelp.design)设计的静态资源。这种格式使用像 [svgo](https://github.com/svg/svgo) 这样的优化工具会显著减少网页的负担，只是和我们这里要做的没什么关系。
We use SVG in many places on our website, like the static assets created by our designers that go into our [styleguide](http://yelp.design). While this format and optimization tools like [svgo](https://github.com/svg/svgo) are useful to reduce website page weight, it isn’t related to what we did here.
## 供应商的魔力
## Vendor Magic
市面上有很多的供应商可以提供图片的传输，改变大小，剪裁和转码服务。包括开源的 [thumbor](https://github.com/thumbor/thumbor)。或许未来对我们来说这是支持响应式图片，动态格式和保留边框最简单方法。但是目前来看我们的解决方案可以从容应对。
There are too many providers to list that offer image delivery / resizing / cropping / transcoding as a service. Including open-source [thumbor](https://github.com/thumbor/thumbor). Maybe this is the easiest way to support responsive images, dynamic content types and remain on the cutting edge for us in the future. For now our solution remains self-contained.
# 延伸阅读
# Further Reading
下面的这两本书绝对有他们博客中没有提到的干货，同时也是今天这个主题强烈推荐的延伸阅读书籍。
Two books listed here absolutely stand on their own outside the context of the post, and are highly recommended as further reading on the subject.

- [High Performance Images](https://content.akamai.com/pg6293-high-performance-images-ebook.html)
- [Designing for Performance](http://designingforperformance.com/)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
