
> * 原文地址：[webpack & HTTP/2](https://medium.com/webpack/webpack-http-2-7083ec3f3ce6)
> * 原文作者：[Tobias Koppers](https://medium.com/@sokra?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/webpack-http-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/webpack-http-2.md)
> * 译者：[薛定谔的猫](https://github.com/Aladdin-ADD)
> * 校对者：

# webpack & HTTP/2

让我们从 HTTP/2 的一个传言开始：

> 有了 HTTP/2，你就不再需要打包模块了。

HTTP/2 可以多路复用，所有模块都可以并行使用同一个连接，因此多个请求不再需要多余的往返数据。每个模块都可以独立缓存。

很遗憾，现实并不如意。

## 以前的文章

下面的文章详细解释了相关信息，并且做了一些实验来验证。你可以阅读它们（或者跳过它们，只看总结）。

[**Forgo JS packaging? Not so fast** *The traditional advice for web developers is to bundle the JavaScript files used by their webpages into one or (at most…*engineering.khanacademy.org](http://engineering.khanacademy.org/posts/js-packaging-http2.htm)

[**The Right Way to Bundle Your Assets for Faster Sites over HTTP/2** *Speed is always a priority in web development. With the introduction of HTTP/2, we can have increased performance for a…*medium.com](https://medium.com/@asyncmax/the-right-way-to-bundle-your-assets-for-faster-sites-over-http-2-437c37efe3ff)

文章主旨：

* 相比拼接为一个文件，多个文件传输仍然有 **协议负担（protocol overhead）**。
* **压缩**成单文件优于多个小文件。
* 相比处理单个大文件，**服务器**处理多个小文件较慢。

因此我们需要在两者中间取得一个折中。我们将模块分为 _n_ 个包，n 大于 1，小于模块数。改变其中一个模块使其缓存失效，因为相应的包只是整个应用的一部分，其它的包的缓存仍然有效。

> 更多的包意味着缓存命中率更高，但不利于压缩？

## AggressiveSplittingPlugin

webpack 2 为你提供了这样的工具。webpack 内部大多都是这样，将一组模块组装成块（chunk）输出一个文件。我们还有一个优化阶段可以改变这些块（chunk），只是需要一个插件来做这个优化。

插件 _AggressiveSplittingPlugin_ 将原始的块分的更小。你可以指定你想要的块大小。它提高的缓存，但损害了压缩（对 HTTP/1 来说也影响传输时间）。

为了结合相似的模块，它们在分离之前会按照路径的字母顺序排序。通常在同一目录下的文件往往是相关的，从压缩来看也是一样。通过这种排序，它们也就能分离到相同的块中了。

对于 HTTP/2 我们现在有高效的分块方式了。

## 修改应用

但这还没结束。当应用更新时我们要尽量复用之前创建的块。因此每次 AggressiveSplittingPlugin 都能够找到一个合适的块大小（在限制内），并将块的模块（modules）和哈希（hash）保存到 *records* 中。

> **Records** 是 webpack 编译过程中**编译状态**的概念，可以通过 JSON 文件存取。

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
