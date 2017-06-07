> * 原文地址：[Making Photos Smaller Without Quality Loss](https://engineeringblog.yelp.com/2017/06/making-photos-smaller.html)
> * 原文作者：[Stephen Arthur](https://engineeringblog.yelp.com/2017/06/making-photos-smaller.html)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Making Photos Smaller Without Quality Loss

Yelp has over 100 million user-generated photos ranging from pictures of dinners or haircuts, to one of our newest features, [#yelfies](https://www.yelpblog.com/2016/11/yelfie). These images account for a majority of the bandwidth for users of the app and website, and represent a significant cost to store and transfer. In our quest to give our users the best experience, we worked hard to optimize our photos and were able to achieve a 30% average size reduction. This saves our users time and bandwidth and reduces our cost to serve those images. Oh, and we did it all without reducing the quality of these images!

# Background

Yelp has been storing user-uploaded photos for over 12 years. We save lossless formats (PNG, GIF) as PNGs and all other formats as JPEG. We use Python and [Pillow](https://python-pillow.org/) for saving images, and start our story of photo uploads with a snippet like this:

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

With this as a starting point, we began to investigate potential optimizations on file size that we could apply without a loss in quality.

# Optimizations

First, we had to decide whether to handle this ourselves or let a CDN provider [magically change](https://www.fastly.com/io) our photos. With the priority we place on high quality content, it made sense to evaluate options and make potential size vs quality tradeoffs ourselves. We moved ahead with research on the current state of photo file size reduction – what changes could be made and how much size / quality reduction was associated with each. With this research completed, we decided to work on three primary categories. The rest of this post explains what we did and how much benefit we realized from each optimization.

1. Changes in Pillow
  - Optimize flag
  - Progressive JPEG
2. Changes to application photo logic
  - Large PNG detection
  - Dynamic JPEG quality
3. Changes to JPEG encoder
  - Mozjpeg (trellis quantization, custom quantization matrix)

# Changes in Pillow

## Optimize Flag

This is one of the easiest changes we made: enabling the setting in Pillow responsible for additional file size savings at the cost of CPU time (`optimize=True`). Due to the nature of the tradeoff being made, this does not impact image quality at all.

For JPEG, this flag instructs the encoder to find the optimal [Huffman coding](https://en.wikipedia.org/wiki/Huffman_coding) by making an additional pass over each image scan. Each first pass, instead of writing to file, calculates the occurrence statistics of each value, required information to compute the ideal coding. PNG internally uses zlib, so the optimize flag in that case effectively instructs the encoder to use `gzip -9` instead of `gzip -6`.

This is an easy change to make but it turns out that it is not a silver bullet, reducing file size by just a few percent.

## Progressive JPEG

When saving an image as a JPEG, there are a few different types you can choose from:

- Baseline JPEG images load from top to bottom.
- Progressive JPEG images load from more blurry to less blurry. The progressive option can easily be enabled in Pillow (`progressive=True`). As a result, there is a perceived performance increase (that is, it’s easier to notice when an image is partially absent than it is to tell it’s not fully sharp).

Additionally, the way progressive files are packed generally results in a small reduction to file size. As more fully explained by the [Wikipedia article](https://en.wikipedia.org/wiki/JPEG#Entropy_coding), JPEG format uses a zigzag pattern over the 8x8 blocks of pixels to do entropy coding. When the values of those blocks of pixels are unpacked and laid out in order, you generally have non-zero numbers first and then sequences of 0s, with that pattern repeating and interleaved for each 8x8 block in the image. With progressive encoding, the order of the unwound pixel blocks changes. The higher value numbers for each block come first in the file, (which gives the earliest scans of a progressive image its distinct blockiness), and the longer spans of small numbers, including more 0s, that add the finer details are towards the end. This reordering of the image data doesn’t change the image itself, but does increase the number of 0s that might be in a row (which can be more easily compressed).

Comparison with a delicious user-contributed image of a donut (click for larger):

[![A mock of how a baseline JPEG renders.](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/baseline-tiny.gif)](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/baseline-large.gif)

A mock of how a baseline JPEG renders.

[![A mock of how a progressive JPEG renders.](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/progressive-tiny.gif)](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/progressive-large.gif)

A mock of how a progressive JPEG renders.

# Changes to Application Photo Logic

## Large PNG Detection

Yelp targets two image formats for serving user-generated content - JPEG and PNG. JPEG is a great format for photos but generally struggles with high-contrast design content (like logos). By contrast, PNG is fully-lossless, so great for graphics but too large for photos where small distortions are not visible. In the cases where users upload PNGs that are actually photographs, we can save a lot of space if we identify these files and save them as JPEG instead. Some common sources of PNG photos on Yelp are screenshots taken by mobile devices and apps that modify photos to add effects or borders.

![(left) A typical composited PNG upload with logo and border. (right) A typical PNG upload from a screenshot.](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/example-pngs.png)

(left) A typical composited PNG upload with logo and border. (right) A typical PNG upload from a screenshot.

We wanted to reduce the number of these unnecessary PNGs, but it was important to avoid overreaching and changing format or degrading quality of logos, graphics, etc. How can we tell if something is a photo? From the pixels?

Using an experimental sample of 2,500 images, we found that a combination of file size and unique pixels worked well to detect photos. We generate a candidate thumbnail image at our largest resolution and see if the output PNG file is larger than 300KiB. If it is, we’ll also check the image contents to see if there are over 2^16 unique colors (Yelp converts RGBA image uploads to RGB, but if we didn’t, we would check that too).

In the experimental dataset, these hand-tuned thresholds to define “bigness” captured 88% of the possible file size savings (i.e. our expected file size savings if we were to convert all of the images) without any false-positives of graphics being converted.

## Dynamic JPEG Quality

The first and most well-known way to reduce the size of JPEG files is a setting called `quality`. Many applications capable of saving to the JPEG format specify quality as a number.

Quality is somewhat of an abstraction. In fact, there are separate qualities for each of the color channels of a JPEG image. Quality levels 0 - 100 map to different [quantization tables](https://en.wikipedia.org/wiki/JPEG#JPEG_codec_example) for the color channels, determining how much data is lost (usually high frequency). Quantization in the signal domain is the one step in the JPEG encoding process that loses information.

The simplest way to reduce file size is to reduce the quality of the image, introducing more noise. Not every image loses the same amount of information at a given quality level though.

We can dynamically choose a quality setting which is optimized for each image, finding an ideal balance between quality and size. There are two ways to do this:

- **Bottom-up:** These are algorithms that generate tuned quantization tables by processing the image at the 8x8 pixel block level. They calculate both how much theoretical quality was lost and how that lost data either amplifies or cancels out to be more or less visible to the human eye.
- **Top-down:** These are algorithms that compare an entire image against an original version of itself and detect how much information was lost. By iteratively generating candidate images with different quality settings, we can choose the one that meets a minimum evaluated level by whichever evaluation algorithm we choose.

We evaluated a bottom-up algorithm, which in our experience did not yield suitable results at the higher end of the quality range we wanted to use (though it seems like it may still have potential in the mid-range of image qualities, where an encoder can begin to be more adventurous with the bytes it discards). Many of the [scholarly](https://vision.arc.nasa.gov/publications/spie93abw/spie93abw.html.d/spie93.html)[papers](ftp://ftp.cs.wisc.edu/pub/techreports/1994/TR1257.pdf) on this strategy were published in the early 90s when computing power was at a premium and took shortcuts that option B addresses, such as not evaluating interactions across blocks.

So we took the second approach: use a bisection algorithm to generate candidate images at different quality levels, and evaluate each candidate image’s drop in quality by calculating its structural similarity metric ([SSIM](https://en.wikipedia.org/wiki/Structural_similarity)) using [pyssim](https://github.com/jterrace/pyssim/), until that value is at a configurable but static threshold. This enables us to selectively lower the average file size (and average quality) only for images which were above a perceivable decrease to begin with.

In the below chart, we plot the SSIM values of 2500 images regenerated via 3 different quality approaches.

1. The original images made by the current approach at `quality = 85` are plotted as the blue line.
2. An alternative approach to lowering file size, changing `quality = 80`, is plotted as the red line.
3. And finally, the approach we ended up using, dynamic quality, `SSIM 80-85`, in orange, chooses a quality for the image in the range 80 to 85 (inclusive) based on meeting or exceeding an SSIM ratio: a pre-computed static value that made the transition occur somewhere in the middle of the images range. This lets us lower the average file size without lowering the quality of our worst-quality images.

![SSIMs of 2500 images with 3 different quality strategies.](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/ssims-strategies.png)
SSIMs of 2500 images with 3 different quality strategies.

### SSIM?

There are quite a few image quality algorithms that try to mimic the human vision system.
We’ve evaluated many of these and think that SSIM, while older, is most suitable for this iterative optimization based on a few characteristics:

1. Sensitive to [JPEG quantization error](http://users.eecs.northwestern.edu/~pappas/papers/brooks_tip08.pdf)
2. Fast, simple algorithm
3. Can be computed on PIL native image objects without converting images to PNG and passing them to CLI applications (see #2)

Example Code for Dynamic Quality:

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

There are a few other blog posts about this technique, [here](https://medium.com/@duhroach/reducing-jpg-file-size-e5b27df3257c) is one by Colt Mcanlis. And as we go to press, Etsy has published one [here](https://codeascraft.com/2017/05/30/reducing-image-file-size-at-etsy/)! High five, faster internet!

# Changes to JPEG Encoder

## Mozjpeg

[Mozjpeg](https://github.com/mozilla/mozjpeg/) is an open-source fork of [libjpeg-turbo](http://libjpeg-turbo.virtualgl.org/), which trades execution time for file size. This approach meshes well with the offline batch approach to regenerating images. With the investment of about 3-5x more time than libjpeg-turbo, a few more expensive algorithms make images smaller!

One of mozjpeg’s differentiators is the use of an alternative quantization table. As mentioned above, quality is an abstraction of the quantization tables used for each color channel. All signs point to the default JPEG quantization tables as being pretty easy to beat. In the words of the [JPEG spec](https://www.w3.org/Graphics/JPEG/itu-t81.pdf):

> These tables are provided as examples only and are not necessarily suitable for any particular application.

So naturally, it shouldn’t surprise you to learn that these tables are the default used by most encoder implementations… 🤔🤔🤔

Mozjpeg has gone through the trouble of benchmarking alternative tables for us, and uses the best performing general-purpose alternative for images it creates.

## Mozjpeg + Pillow

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

That’s it! Build it and you’ll be able to use Pillow backed by mozjpeg within your normal images workflow.

# Impact

How much did each of those improvements matter for us? We started this research by randomly sampling 2,500 of Yelp’s business photos to put through our processing pipeline and measure the impact on file size.

1. Changes to Pillow settings were responsible for about 4.5% of the savings
2. Large PNG detection was responsible for about 6.2% of the savings
3. Dynamic Quality was responsible for about 4.5% of the savings
4. Switching to the mozjpeg encoder was responsible for about 13.8% of the savings

This adds up to an average image file size reduction of around 30%, which we applied to our largest and most common image resolutions, making the website faster for users and saving terabytes a day in data transfer. As measured at the CDN:

![Average filesize over time, as measured from the CDN (combined with non-image static content).](https://engineeringblog.yelp.com/images/posts/2017-05-31-making-images-smaller/Filesize-over-time.png)
Average filesize over time, as measured from the CDN (combined with non-image static content).

# What we didn’t do

This section is intended to introduce a few other common improvements that you might be able to make, that either weren’t relevant to Yelp due to defaults chosen by our tooling, or tradeoffs we chose not to make.

## Subsampling

[Subsampling](https://en.wikipedia.org/wiki/Chroma_subsampling) is a major factor in determining both quality and file size for web images. Longer descriptions of subsampling can be found online, but suffice it to say for this blog post that we were already subsampling at `4:1:1` (which is Pillow’s default when nothing else is specified) so we weren’t able to realize any further savings here.

## Lossy PNG encoding

After learning what we did about PNGs, choosing to preserve some of them as PNG but with a lossy encoder like [pngmini](https://pngmini.com/lossypng.html) could have made sense, but we chose to resave them as JPEG instead. This is an alternate option with reasonable results, 72-85% file size savings over unmodified PNGs according to the author.

## Dynamic content types

Support for more modern content types like WebP or JPEG2k is certainly on our radar. Even once that hypothetical project ships, there will be a long-tail of users requesting these now-optimized JPEG/PNG images which will continue to make this effort well worth it.

## SVG

We use SVG in many places on our website, like the static assets created by our designers that go into our [styleguide](http://yelp.design). While this format and optimization tools like [svgo](https://github.com/svg/svgo) are useful to reduce website page weight, it isn’t related to what we did here.

## Vendor Magic

There are too many providers to list that offer image delivery / resizing / cropping / transcoding as a service. Including open-source [thumbor](https://github.com/thumbor/thumbor). Maybe this is the easiest way to support responsive images, dynamic content types and remain on the cutting edge for us in the future. For now our solution remains self-contained.

# Further Reading

Two books listed here absolutely stand on their own outside the context of the post, and are highly recommended as further reading on the subject.

- [High Performance Images](https://content.akamai.com/pg6293-high-performance-images-ebook.html)
- [Designing for Performance](http://designingforperformance.com/)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
