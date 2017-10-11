
> * 原文地址：[webpack & HTTP/2](https://medium.com/webpack/webpack-http-2-7083ec3f3ce6)
> * 原文作者：[Tobias Koppers](https://medium.com/@sokra?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/webpack-http-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/webpack-http-2.md)
> * 译者：
> * 校对者：

# webpack & HTTP/2

Let’s start with a myth about HTTP/2:

> With HTTP/2 you don’t need to bundle your modules anymore.

HTTP/2 can multiplex all your modules over the same connection in parallel. So there are no additional round trips for the many requests. Each module can be separately cached.

Sadly **it’s not that easy** in reality.

## Prior work

You can read the following articles, which explain everything in detail and do some experiments to verify them (or just skip and and read the summary).

[**Forgo JS packaging? Not so fast** *The traditional advice for web developers is to bundle the JavaScript files used by their webpages into one or (at most…*engineering.khanacademy.org](http://engineering.khanacademy.org/posts/js-packaging-http2.htm)

[**The Right Way to Bundle Your Assets for Faster Sites over HTTP/2** *Speed is always a priority in web development. With the introduction of HTTP/2, we can have increased performance for a…*medium.com](https://medium.com/@asyncmax/the-right-way-to-bundle-your-assets-for-faster-sites-over-http-2-437c37efe3ff)

This is the gist of the articles:

* There is still a **protocol overhead** for each request compared to a single concatenated file.
* The **compression** of the single large file is better than many small files.
* **Servers** are slower serving many small files than a single large file.

So we need to find the middle ground to get the best for both worlds. We put the modules into _n_ bundles where _n_ is greater than 1 and smaller than the number of modules. Changing one module invalidates the cache for one bundle which is only a part of the complete application. The remaining application is still cached.

> More bundles means better caching, but less compression.

## The AggressiveSplittingPlugin

The upcoming webpack 2 gives you the tool to do so. The most webpack internals are already there anyway. We already have chunks as a group of modules which form a output file. We have an optimization phase which can change these chunks. We just need a plugin to perform this optimization.

The _AggressiveSplittingPlugin_ splits the original chunks into smaller chunks. You specify the chunk size you want to have. This improves the caching while worsens the compression (and transferring for HTTP/1).

To combine similar modules, they are sorted alphabetically (by path) before splitting. Modules in the same folder are probably related to each other and similar from compression point of view. With this sorting they end up in the same chunk.

Now we have efficient chunking for HTTP/2.

## Changes to the application

But that’s not the end of the story. When the application is **updated** we need to **try hard** to **reuse** the previously created chunks. Therefore every time the *AggressiveSplittingPlugin* finds a good chunk (size within the limits), it stores the chunk’s **modules** and **hash** into *records*.

> **Records** is webpack’s concept of **state** that is kept between compilations. It’s stored to and read from a JSON file.

When the *AggressiveSplittingPlugin* is called again it first tries to **restore** the chunks from _records_ before trying to split the remaining modules. This ensures that cached chunks are reused.

## Bootstrapping and Server

An application using this technique no longer emits a single file which can be included in the HTML file. It emits multiple chunks which all need to be loaded. In an application using this optimization multiple script-tags are used to load every chunk (in parallel). Maybe like this:

```
<script src="1ea296932eacbe248905.js"></script>
<script src="0b3a074667143853404c.js"></script>
<script src="0dd8c061aff2a2791815.js"></script>
<script src="191b812fa5f7504151f7.js"></script>
<script src="08702f45497539ef6ea6.js"></script>
<script src="195c9326275620b0e9c2.js"></script>
<script src="19817b3a0378aedb2143.js"></script>
<script src="0e7a65e649387d773247.js"></script>
<script src="13167c9702de79d2f4fd.js"></script>
<script src="1154be40ff0e8dd16e9f.js"></script>
<script src="129ce3c198a25d9ace74.js"></script>
<script src="032d1fc9a213dfaf2c79.js"></script>
<script src="07df084bbafc95c1df47.js"></script>
<script src="15c45a570bb174ae448e.js"></script>
<script src="02099ada43bbf02a9f73.js"></script>
<script src="17bc99aaed6b9a23da78.js"></script>
<script src="02d127598b1c99dcd2d0.js"></script>
```

webpack emit these chunk in **order of age**. The oldest file is executed first and the most recent one last. The browser can start executing files in cache while waiting for the download of the most recent files. Older files are more likely to be in the cache already.

**HTTP/2 Server push** can be used to send these chunks to the client when the HTML page is requested. Best start pushing the most recent file first, as older files are more likely to be in the cache already. The client can cancel push responses for files it already have, but this takes a round trip.

When using Code Splitting for **on demand loading** webpack handles the parallel requests for you.

## Conclusion

webpack 2 gives you the tooling to improve caching and transfer of your application when using HTTP/2\. Don’t be afraid that your stack won’t be future-proof.

Note that the _AggressiveSplittingPlugin_ is still **experimental**.

I’m very interested in your experiences…


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
