> * 原文地址：[Of SVG, Minification and Gzip](https://blog.usejournal.com/of-svg-minification-and-gzip-21cd26a5d007)
> * 原文作者：[Anton Khlynovskiy](https://blog.usejournal.com/@subzey?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/of-svg-minification-and-gzip.md](https://github.com/xitu/gold-miner/blob/master/TODO/of-svg-minification-and-gzip.md)
> * 译者：
> * 校对者：

# Of SVG, Minification and Gzip

![](https://cdn-images-1.medium.com/max/800/1*p926hOBc0YrbqPceYbLk0A.png)

Smaller files are downloaded faster, so making an asset file size smaller before sending it to a client is a good thing to do.

Actually, it’s not just a good thing to do, minification and compression are something that a modern developer is _supposed_ to do. But minifiers are not perfect and compressors can perform better or worse depending on the data they compress. There are some tricks and patterns to turn these tools up to eleven. Interested? Let’s dive in!

### Getting Started

We’ll use a simple SVG file as an example:

![](https://cdn-images-1.medium.com/max/800/1*_ScxMaOWN_FCnKKJlQ3oQQ.png)

An `<svg>` image with two 6×6 squares (`<rect>`) inside a 10×10 pixels area (`viewBox`). 176 bytes raw, 138 b gzipped.

Yup, it’s not a piece of fine art. But it’s enough to cover the topic without turning this Medium post into a scientific paper.

### Step 0: Svgo

Running `svgo image.svg` instantly improves the compression.

![](https://cdn-images-1.medium.com/max/800/1*LwteS1LS9iPlpJOtllVqbA.png)

_(Carriage returns and indentations are added for readability)_

The most notably, the `rect`s were replaced with `path`s. A path shape is defined by its `d` attribute, a sequence of commands that moves a virtual pen just like canvas drawing methods. Commands can be absolute (move **to** x, y) and relative (move **by** x, y). Let’s take a closer look at one of the paths:

`M 0 0`: start at (0, 0)
`h 6`: move horizontally by 6 px right
`v 6`: move vertically by 6 px down
`H 0`: move horizontally to x = 0
`z`: close path: move to the point the path was started

Quite an elaborate way to draw a square! But it’s a more compact representation than a `rect` element.

The other change is that `#f00` became `red`. One byte less, yay!

The file is now 135 b raw, 126 b gzipped.

### Step 1: Scale Everything

You might have noticed all the coordinates in both paths are even. What if we divide each coordinate by two?

![](https://cdn-images-1.medium.com/max/800/1*LNM-zlZDg_s99ZxSOk6KYw.png)

The image now looks the same, but it’s twice as small. Now we can just scale the `viewBox` and the image looks correct again.

![](https://cdn-images-1.medium.com/max/800/1*ci39eVsuha9jkXj-APDOXA.png)

133 bytes raw, 124 bytes gzipped.

### Step 2: Unclosed paths

Back to the paths. The last commands in both paths are `z`, “close path”. But paths are implicitly closed when they are filled. So we could just remove those commands.

![](https://cdn-images-1.medium.com/max/800/1*mBTPJaeMYpb1ekVmPzhuiA.png)

2 raw bytes less, now the file is 131 b long, 122 gzipped. Fewer raw bytes makes fewer compressed bytes, seems legit. And we’ve already saved 4 gzipped bytes even after svgo.

_You might wonder: why doesn’t svgo make these optimizations automatically. The reason is that scaling an image and removing the trailing z commands are unsafe. Here, take a look:_

![](https://cdn-images-1.medium.com/max/800/1*TV-Vc8ehkKYNkuVqgFJmoQ.png)

Various versions of the image with the stroke applied. Left to right: original, unclosed, unclosed & scaled.

_Strokes are all messed up. It’s good to know we’re not going to use strokes. Svgo cannot know that, so it has to play safe, avoiding potentially unsafe transformations._

Looks like there’s nothing else to remove from the code. The XML syntax is strict, all the attributes are required and its values cannot be left unquoted.

Is that all? Oh, no, it’s just the beginning.

### Step 3: Reducing the Alphabet

Now it’s time to introduce a very handy tool, [gzthermal](https://encode.ru/threads/1889-gzthermal-pseudo-thermal-view-of-Gzip-Deflate-compression-efficiency). It analyzes the gzipped file and colors the raw bytes depending on how many bits are used to encode. Better compressed data is green, worse compressed one is red, it’s that simple.

![](https://cdn-images-1.medium.com/max/800/1*wrB-Z6jgspiHE8tculNVVw.png)

Let’s take a look at the d attributes again. Particularly at the M commands as they are marked red and worth our attention. No, we cannot delete those, but we can make it a relative command: `m2 2`.

The initial “cursor” position is the axis origin, (0, 0), so there’s no difference between moving **to** (2, 2) and moving **by** (2, 2) from the origin. So, let’s try that.

![](https://cdn-images-1.medium.com/max/800/1*eogrWPzKTpjvhnkFhhPcZg.png)

![](https://cdn-images-1.medium.com/max/800/1*Vk-9DDQMFoBraOaWAOF74Q.png)

Still 131 bytes raw, but 121 bytes gzipped. _Whoa!_ What just happened? The answer is…

#### Huffman Trees

Gzip is powered by the [DEFLATE](https://en.wikipedia.org/wiki/DEFLATE) algorithm, and DEFLATE is built on top of Huffman trees.

The core idea of Huffman coding is that more frequent symbols are encoded with fewer bits, and vice versa, less frequent symbols need more bits.

_Yes, bits, not bytes: DEFLATE treats a string of bytes just as a sequence of bits, and if there were 7, or 9, or 100 bits in a byte, DEFLATE would work just the same._

As an example we’ll take a string Test and construct the codes from its alphabet:
`00` T
`01` e
`10` s
`11` t

Now to encode the string Test we just write out the bits for each character: `00011011`, 8 bits.

Now let’s make an initial letter T lowercase, `test`, and try again:
`0` t
`10` e
`11` s

The letter t is now more frequent and it gets a shorter, 1 bit, code. And the encoded string is: `010110`, 6 bits!

* * *

We did just the same with the letter M in our SVG. After lowering the case there’s no more uppercase M left in the code, so it’s got thrown away from the tree entirely, making the average code length smaller.

When writing a gzip friendly code, it’s generally a good idea to prefer more frequent characters and thus making those even more frequent. Even if you couldn’t make the code lengths smaller, more frequent chars are less bit consuming.

### Step 4: Backreferences

There’s another DEFLATE feature: backreferences. Certain code points do not encode values directly, instead, it tell the decoder to copy some bytes that were decoded recently.

So instead of encoding raw bytes with the same bits again and again it can be referenced: _go back n bytes and copy m bytes_. For example:

`Hey diddle diddle, the cat and the fiddle.`

`Hey diddle**<7,7>**, the cat and**<12,5>**f**<24,5>**.`

Luckily, gzthermal has a special mode that shows only backreferences. `gzthermal -z` gives the following image:

![](https://cdn-images-1.medium.com/max/800/1*p3j1ITiSJDpNfV16YPRqng.png)

Literal bytes are painted orange, backrefs are blue. [Here’s the same image animated for better clarity.](https://github.com/subzey/svg-gz-supplement/blob/master/backrefs-animated.gif)

The second path is almost entirely constructed using backrefs, except the fill value, `m` command and the last `H` command. Nothing can be done with the fill and the m: the second square indeed has different color and positions.

But the shapes are the same, and we could state in more clearly for the gzip. We’ll just replace absolute commands `H 0` and `H 2` with a relative one: `h-3`.

![](https://cdn-images-1.medium.com/max/800/1*oa2ts-oANaSS4hrIOlrXTg.png)

![](https://cdn-images-1.medium.com/max/800/1*ye5f4jzIDt5YYbCeLHa37A.png)

Now two separate backrefs are joined into the single one, and the file is now 133 bytes raw, 119 bytes gzipped. We’ve added two uncompressed bytes, but the gzipped result is two bytes shorter!

And we only care about the compressed size: There’s 99.9% chance an asset would be delivered to the client being compressed with gzip or brotli. By the way, talking of…

### Brotli

[Brotli](https://en.wikipedia.org/wiki/Brotli) is an algorithm presented in 2015 to replace gzip (from 1992) in web browsers. But in many aspects it works like gzip: it’s built upon Huffman coding and backreferences as well. So brotli can benefit all the tweaks we made for gzip. Let’s use it for all the steps we made and take a look.

Original: 106 bytes
After step 0 (svgo): 104 bytes
After step 1 (viewBox): 105 bytes
After step 2 (unclosed paths): 113 bytes
After step 3 (lowercase m): 116 bytes
After step 4 (relative commands): 102 bytes

As you can see, the final result is smaller than what the svgo offered us. That’s good evidence that all of gzip’s specific bells and whistles work for brotli as well.

But the intermediate results are… confusing. The “brotlied” file was only bigger. Brotli is not gzip, it’s a separate brand new algorithm. And despite all similarities with gzip there are certain differences.

Most notably, brotli has the builtin predefined dictionary, it uses the context heuristics when encoding data, and the minimal backreference size is 2 bytes (gzip can only create backrefs of 3 bytes and longer).

I’d say, brotli is _less predictable_ than gzip. I’d love to explain what caused the compression degradation, but unfortunately, I can’t. Gzip/DEFLATE has aforementioned gzthermal and a more powerful low level analyze tool, [defdb](https://encode.ru/threads/1428-defdb-a-tool-to-dump-the-deflate-stream-from-gz-and-png-files). Brotli has… none. All we’re left with is [the spec](https://tools.ietf.org/html/rfc7932) and the method of trial and error.

### Trial and Error

We’ll try once more. This time we address the color inside the `fill` attribute. Sure, `red` is shorter than `#f00`, but maybe Brotli could utilize the longer backref.

![](https://cdn-images-1.medium.com/max/800/1*MwGlmyjaYFlhUhxQ5d4xDA.png)

120 bytes gzipped, 100 bytes brotlied. The gzip stream is now 1 byte longer and the brotli stream is 2 bytes shorter.

It’s better in brotli, but worse in gzip. And I suppose, it’s totally fine! Hardly ever could we optimize the data to get the _best possible_ results in two different compressors at once. The compression is like solving a horribly wrong Rubik’s cube: It cannot be solved correctly, it can only be solved good enough.

### Conclusion

All the tweaks described above are not exclusively specific to SVG or to gzip. There are common principles of writing a more compressible code:

1.  Compressing **smaller raw data** would probably produce smaller compressed data.
2.  **Fewer distinct characters** means less entropy. Less entropy is better compression.
3.  More frequently found characters are compressed with less number of bits. **Getting rid of less common characters** and **making the more common chars to be even more common** would most probably improve the compression.
4.  **Long runs of duplicated code** are compressed with a few bits. [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) is not always the best option. Sometimes you’d like to **repeat yourself** to get better results.
5.  Sometimes more raw data will produce smaller compressed data. **Removing entropy** will allow the compressor to better remove what is redundant.

You can find all source, compressed images and extras in [this GitHub repo](https://github.com/subzey/svg-gz-supplement/).

I hope, you liked this post, next time we’ll talk about compressing JavaScript in general and webpack bundles in particular.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
