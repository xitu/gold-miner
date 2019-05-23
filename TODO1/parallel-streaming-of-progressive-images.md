> * 原文地址：[Parallel streaming of progressive images](https://blog.cloudflare.com/parallel-streaming-of-progressive-images/)
> * 原文作者：[Andrew Galloni](https://blog.cloudflare.com/author/andrew-galloni/), [Kornel Lesiński.](https://blog.cloudflare.com/author/kornel/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/parallel-streaming-of-progressive-images.md](https://github.com/xitu/gold-miner/blob/master/TODO1/parallel-streaming-of-progressive-images.md)
> * 译者：
> * 校对者：

# Parallel streaming of progressive images

![](https://blog.cloudflare.com/content/images/2019/05/880BAE29-39B3-4733-96DA-735FE76443D5.png)

Progressive image rendering and HTTP/2 multiplexing technologies have existed for a while, but now we've combined them in a new way that makes them much more powerful. With Cloudflare progressive streaming **images appear to load in half of the time, and browsers can start rendering pages sooner**.

- 视频：https://crates.rs/cf-test/comparison.mp4

In HTTP/1.1 connections, servers didn't have any choice about the order in which resources were sent to the client; they had to send responses, as a whole, in the exact order they were requested by the web browser. HTTP/2 improved this by adding multiplexing and prioritization, which allows servers to decide exactly what data is sent and when. We’ve taken advantage of these new HTTP/2 capabilities to improve perceived speed of loading of progressive images by sending the most important fragments of image data sooner.

> This feature is compatible with all major browsers, and doesn’t require any changes to page markup, so it’s very easy to adopt. Sign up for the [Beta](https://forms.gle/G2iHC4qWB8XHN3Ly6) to enable it on your site!

### What is progressive image rendering?

Basic images load strictly from top to bottom. If a browser has received only half of an image file, it can show only the top half of the image. Progressive images have their content arranged not from top to bottom, but from a low level of detail to a high level of detail. Receiving a fraction of image data allows browsers to show the entire image, only with a lower fidelity. As more data arrives, the image becomes clearer and sharper.

![](https://blog.cloudflare.com/content/images/2019/05/image6.jpg)

This works great in the JPEG format, where only about 10-15% of the data is needed to display a preview of the image, and at 50% of the data the image looks almost as good as when the whole file is delivered. Progressive JPEG images contain exactly the same data as baseline images, merely reshuffled in a more useful order, so progressive rendering doesn’t add any cost to the file size. This is possible, because JPEG doesn't store the image as pixels. Instead, it represents the image as frequency coefficients, which are like a set of predefined patterns that can be blended together, in any order, to reconstruct the original image. The inner workings of JPEG are really fascinating, and you can learn more about them from my recent [performance.now() conference talk](https://www.youtube.com/watch?v=jTXhYj2aCDU).

The end result is that the images can look almost fully loaded in half of the time, for free! The page appears to be visually complete and can be used much sooner. The rest of the image data arrives shortly after, upgrading images to their full quality, before visitors have time to notice anything is missing.

### HTTP/2 progressive streaming

But there's a catch. Websites have more than one image (sometimes even hundreds of images). When the server sends image files naïvely, one after another, the progressive rendering doesn’t help that much, because overall the images still load sequentially:

![](https://blog.cloudflare.com/content/images/2019/05/image5.gif)

Having complete data for half of the images (and no data for the other half) doesn't look as good as having half of the data for all images.

And there's another problem: when the browser doesn't know image sizes yet, it lays the page out with placeholders instead, and relays out the page when each image loads. This can make pages jump during loading, which is inelegant, distracting and annoying for the user.

Our new progressive streaming feature greatly improves the situation: we can send all of the images at once, in parallel. This way the browser gets size information for all of the images as soon as possible, can paint a preview of all images without having to wait for a lot of data, and large images don’t delay loading of styles, scripts and other more important resources.

This idea of streaming of progressive images in parallel is as old as HTTP/2 itself, but it needs special handling in low-level parts of web servers, and so far this hasn't been implemented at a large scale.

When we were improving [our HTTP/2 prioritization](https://blog.cloudflare.com/better-http-2-prioritization-for-a-faster-web), we realized it can be also used to implement this feature. Image files as a whole are neither high nor low priority. The priority changes within each file, and dynamic re-prioritization gives us the behavior we want:

* The image header that contains the image size is very high priority, because the browser needs to know the size as soon as possible to do page layout. The image header is small, so it doesn't hurt to send it ahead of other data.

![Known image sizes make layout stable](https://blog.cloudflare.com/content/images/2019/05/image7.jpg)

* The minimum amount of data in the image required to show a preview of the image has a medium priority (we'd like to plug "holes" left for unloaded images as soon as possible, but also leave some bandwidth available for scripts, fonts and other resources)

![Half of the data looks good enough](/content/images/2019/05/secondhalf.png)

* The remainder of the image data is low priority. Browsers can stream it last to refine image quality once there's no rush, since the page is already fully usable.

Knowing the exact amount of data to send in each phase requires understanding the structure of image files, but it seemed weird to us to make our web server parse image responses and have a format-specific behavior hardcoded at a protocol level. By framing the problem as a dynamic change of priorities, were able to elegantly separate low-level networking code from knowledge of image formats. We can use Workers or offline image processing tools to analyze the images, and instruct our server to change HTTP/2 priorities accordingly.

The great thing about parallel streaming of images is that it doesn’t add any overhead. We’re still sending the same data, the same amount of data, we’re just sending it in a smarter order. This technique takes advantage of existing web standards, so it’s compatible with all browsers.

### The waterfall

Here are waterfall charts from [WebPageTest](https://webpagetest.org) showing comparison of regular HTTP/2 responses and progressive streaming. In both cases the files were exactly the same, the amount of data transferred was the same, and the overall page loading time was the same (within measurement noise). In the charts, blue segments show when data was transferred, and green shows when each request was idle.

![](https://blog.cloudflare.com/content/images/2019/05/image8.png)

The first chart shows a typical server behavior that makes images load mostly sequentially. The chart itself looks neat, but the actual experience of loading that page was not great — the last image didn't start loading until almost the end.

The second chart shows images loaded in parallel. The blue vertical streaks throughout the chart are image headers sent early followed by a couple of stages of progressive rendering. You can see that useful data arrived sooner for all of the images. You may notice that one of the images has been sent in one chunk, rather than split like all the others. That’s because at the very beginning of a TCP/IP connection we don't know the true speed of the connection yet, and we have to sacrifice some opportunity to do prioritization in order to maximize the connection speed.

### The metrics compared to other solutions

There are other techniques intended to provide image previews quickly, such as low-quality image placeholder (LQIP), but they have several drawbacks. They add unnecessary data for the placeholders, and usually interfere with browsers' preload scanner, and delay loading of full-quality images due to dependence on JavaScript needed to upgrade the previews to full images.

* Our solution doesn't cause any additional requests, and doesn't add any extra data. Overall page load time is not delayed.
* Our solution doesn't require any JavaScript. It takes advantage of functionality supported natively in the browsers.
* Our solution doesn't require any changes to page's markup, so it's very safe and easy to deploy site-wide.

The improvement in user experience is reflected in performance metrics such as **SpeedIndex** metric and and time to visually complete. Notice that with regular image loading the visual progress is linear, but with the progressive streaming it quickly jumps to mostly complete:

![](https://blog.cloudflare.com/content/images/2019/05/image1-5.png)

![](https://blog.cloudflare.com/content/images/2019/05/image4.png)

### Getting the most out of progressive rendering

Avoid ruining the effect with JavaScript. Scripts that hide images and wait until the `onload` event to reveal them (with a fade in, etc.) will defeat progressive rendering. Progressive rendering works best with the good old `<img>` element.

### Is it JPEG-only?

Our implementation is format-independent, but progressive streaming is useful only for certain file types. For example, it wouldn't make sense to apply it to scripts or stylesheets: these resources are rendered as all-or-nothing.

Prioritizing of image headers (containing image size) works for all file formats.

The benefits of progressive rendering are unique to JPEG (supported in all browsers) and JPEG 2000 (supported in Safari). GIF and PNG have interlaced modes, but these modes come at a cost of worse compression. WebP doesn't even support progressive rendering at all. This creates a dilemma: WebP is usually 20%-30% smaller than a JPEG of equivalent quality, but progressive JPEG **appears** to load 50% faster. There are next-generation image formats that support progressive rendering better than JPEG, and compress better than WebP, but they're not supported in web browsers yet. In the meantime you can choose between the bandwidth savings of WebP or the better perceived performance of progressive JPEG by changing Polish settings in your Cloudflare dashboard.

### Custom header for experimentation

We also support a custom HTTP header that allows you to experiment with, and optimize streaming of other resources on your site. For example, you could make our servers send the first frame of animated GIFs with high priority and deprioritize the rest. Or you could prioritize loading of resources mentioned in `<head>` of HTML documents before `<body>` is loaded.

The custom header can be set only from a Worker. The syntax is a comma-separated list of file positions with priority and concurrency. The priority and concurrency is the same as in the whole-file cf-priority header described in the previous blog post.

```http
cf-priority-change: <offset in bytes>:<priority>/<concurrency>, ...
```

For example, for a progressive JPEG we use something like (this is a fragment of JS to use in a Worker):

```javascript
let headers = new Headers(response.headers);
headers.set("cf-priority", "30/0");
headers.set("cf-priority-change", "512:20/1, 15000:10/n");
return new Response(response.body, {headers});
```

Which instructs the server to use priority 30 initially, while it sends the first 512 bytes. Then switch to priority 20 with some concurrency (`/1`), and finally after sending 15000 bytes of the file, switch to low priority and high concurrency (`/n`) to deliver the rest of the file.

We’ll try to split HTTP/2 frames to match the offsets specified in the header to change the sending priority as soon as possible. However, priorities don’t guarantee that data of different streams will be multiplexed exactly as instructed, since the server can prioritize only when it has data of multiple streams waiting to be sent at the same time. If some of the responses arrive much sooner from the upstream server or the cache, the server may send them right away, without waiting for other responses.

### Try it!

You can use our Polish tool to convert your images to progressive JPEG. Sign up for the [beta](https://forms.gle/G2iHC4qWB8XHN3Ly6) to have them elegantly streamed in parallel.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
