
> * 原文地址：[The Right Way to Bundle Your Assets for Faster Sites over HTTP/2](https://medium.com/@asyncmax/the-right-way-to-bundle-your-assets-for-faster-sites-over-http-2-437c37efe3ff)
> * 原文作者：[Max Jung](https://medium.com/@asyncmax?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-right-way-to-bundle-your-assets-for-faster-sites-over-http-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-right-way-to-bundle-your-assets-for-faster-sites-over-http-2.md)
> * 译者：
> * 校对者：

# The Right Way to Bundle Your Assets for Faster Sites over HTTP/2

Speed is always a priority in web development. With the introduction of HTTP/2, we can have increased performance for a small amount of effort. This article will briefly go over the basics of HTTP/2 for those who are unfamiliar, and will show benchmark data to support some simple development guidelines to ensure that your site is optimized for HTTP/2.

## HTTP/2 and Why It Matters

With websites constantly growing and HTTP/1.1 remaining unchanged since its introduction in 1997, HTTP/2 was introduced in 2015 as the new major version upgrade to HTTP1.1 to consider web page latency. A user’s perceived performance of web applications depends mostly on the [latency](https://docs.google.com/presentation/d/1r7QXGYOLCh4fcUq0jDdDwKJWNqWK1o4xMtYpKZCJYjM/edit#slide=id.g518e3c87f_2_0), not bandwidth. So the major goal of HTTP/2 design was to solve the latency problem by introducing [multiplexing](https://http2.github.io/faq/#why-is-http2-multiplexed) as well as some other design considerations, including header compression.

HTTP/2 is carefully designed to be semantically compatible with HTTP/1.1 so there is no difference from web developers’ perspective in terms of how to write your code. However, to take full advantage of multiplexing, we have to adjust our asset delivery strategy according to the new behavior of HTTP/2 environment. As an increasing number of hosting providers offer HTTP/2 support and knowledge of this technology becomes more popularized, it becomes even more important to optimize your site for HTTP/2 in order to stay relevant in the endless race for the fastest site. According to W3Techs, as of April 2016, 7.1% of the top 10 million websites supported HTTP/2, and that number will continue to grow quickly. Also, CloudFlare posted an interesting [article](https://blog.cloudflare.com/introducing-http2/) about the real world statistics of SPDY & HTTP/2 traffic. It showed that 81% of all traffic to their network was served over either SPDY or HTTP/2 connection as of December 2015.

Because SPDY provides most benefits of HTTP/2 as a predecessor, we can think of it as a variation of HTTP/2\. With SPDY included, we can see that HTTP/2 is not the future, but the present — it’s already ubiquitous, with most desktop and mobile browsers today having support for either of them.

## The HTTP/2 Bundling Myth

So how do we prepare our assets to best take advantage of HTTP/2? In the HTTP/1.1 era, there was no question that concatenating multiple assets into one big file is the most important optimization for increasing loading performance of web applications.

One downside of this approach was a negative impact on browser’s cache management. If one small asset changes, the whole big file has to be downloaded again. But the performance gain from the concatenation simply outweighs this penalty in HTTP/1.1 environment.

On the other hand, [concatenation has been considered to be bad](https://docs.google.com/presentation/d/1r7QXGYOLCh4fcUq0jDdDwKJWNqWK1o4xMtYpKZCJYjM/edit#slide=id.g518e3c87f_0_318) in a HTTP/2 environment because HTTP/2 is designed to transfer multiple small files simultaneously without much overhead. By avoiding concatenation, browser cache can work much more efficiently.

But in real world, things are [not to be that simple](http://engineering.khanacademy.org/posts/js-packaging-http2.htm).

Contrary to popular belief, our benchmark test showed that asset concatenation is still good for improving loading performance in HTTP/2\. However, instead of a singular concatenated file that’s typical in HTTP/1.1, it’s the most optimal to group assets into several smaller bundles containing related assets since it will not only decrease latency, but it will allow flexibility in browser cache management. Even in the scenario where the client only supports HTTP/1.1, page performance is not affected drastically when serving several bundle files compared to a singular concatenated file.

## HTTP/2 Benchmark Details

There are 4 web pages in this benchmark test and each web page loads a different set of external JavaScript files to simulate a different level of concatenation. Though the number of files and size are different, total amount of data transfer for loading each page is about the same.

The test was ran against 3 web servers located on 3 different AWS availability zones to simulate varying level of distance between user’s browser and web server. The network was a 15Mbps Comcast residential cable connection and Chrome 50 on Windows 10 was used.

Each column shows the result of 4 different level of concatenation as follows. The rows show the result of 10 different sampling tests (with browser cache disabled) with some interval of time between each.

* **1000**: Loading 1000 small (819 bytes each) JavaScript files, simulating no concatenation.
* **50**: Loading 50 medium (16399 bytes each) JavaScript files, simulating moderate concatenation.
* **6**: Loading 6 large (136666 bytes each) JavaScript files, simulating aggressive concatenation.
* **1**: Loading 1 huge (819999 bytes) JavaScript file, simulating extreme concatenation.

### Between San Jose and US West (N. California)

![](https://cdn-images-1.medium.com/max/800/1*_7p74XMRQjuoeEYcA_jjYg.png)

![](https://cdn-images-1.medium.com/max/800/1*lFAaGiYTuBHVZM7lguCsjA.png)

Going from 1000 files to 50 increases speed by an average of 66%. 6 files and 1 file concatenated show almost a 70% page load speed increase as well.

### Between San Jose and US East (N. Virginia)

[](https://cdn-images-1.medium.com/max/800/1*Iepr45KgMK6pQ263xTFkOg.png)

![](https://cdn-images-1.medium.com/max/800/1*37Z0AJ3JLerHGc_yRUY9Tw.png)

In this benchmark test, going from 1000 files to 50 showed an average increase in speed of 28.4%.

### Between San Jose and Asia Pacific (Seoul)

![](https://cdn-images-1.medium.com/max/800/1*Kpxr2LBNWR75grAagVgu0g.png)

![](https://cdn-images-1.medium.com/max/800/1*f5rh5cgcRuzJHLeBQ9sYPA.png)

We can see here that the average page load speed is much slower because of the distance between the client and server, but going from 1000 files to 50 and below has an average speed increase of around 27%.

## Results and Key Findings

* Even in HTTP/2 environment, any level of concatenation showed a significant improvement compared to non-concatenation.
* The improvement was most significant (3x faster) when the distance between browser and server is shortest (i.e. over a connection with least latency).
* Differences among concatenation levels below 1000 (50, 6 or 1) were negligible.
* As distance between browser and server is getting farther (more latency), fluctuations of loading speed between samplings became bigger. This means comparing two numbers measured long interval between them can be irrelevant.

## Final Takeaways

### Always concatenate files into several bundles

Even though HTTP/2 is designed to be highly efficient in transferring many small files, tiny overhead of each small file can add up and becomes noticeable when we are dealing with many files. Plus, there’s a limit to the amount of concurrent streams that the browser or the server allows. [Chrome’s limit appears to be 256](https://github.com/gourmetjs/http2-concat-benchmark-docs/blob/master/images/chrome_limit.png), and NGINX’s ngx_http_v2_module, which is used for this benchmark test, has [http2_max_concurrent_streams](http://nginx.org/en/docs/http/ngx_http_v2_module.html#http2_max_concurrent_streams) configuration directive set to 128 as default. A modern web application without concatenation will easily have over several hundred asset files and HTTP/2 will [not transfer it all at once](https://github.com/gourmetjs/http2-concat-benchmark-docs/blob/master/images/stream_concurrency.png).

In order to enhance browser’s cache performance, create smaller bundles instead of one gigantic bundle. Each bundle should have a set of related asset files. If a bundle consists of related assets, most changes in a group can be contained locally without impacting other groups.

For example, creating a bundle per NPM module can be a good strategy because one specific module’s update will invalidate only that module’s bundle in browser cache. This strategy may result in increased number of bundles. But as we saw in the benchmark result, if we keep the number of bundles under a certain level(50 in this benchmark), it will not hurt the performance thanks to HTTP/2’s multiplexing. Be wary of all the suggestions to forego concatenation — as you can see, the amount of overhead in not concatenating will undoubtedly impact performance.

### Consider HTTP/1.1 compatibility

Even though HTTP/2 (or SPDY) is surprisingly pervasive, HTTP/1.1 can’t be totally ignored. It may be more critical for vertical applications.

For the best result in both HTTP/2 and HTTP/1.1 environment, using two different concatenating strategies based on browser’s capability (moderate for HTTP/2, aggressive for HTTP/1.1) would be the best solution. However, maintaining two different strategies will be a overkill for most cases.

What if we use the same concatenation strategy for HTTP/1.1 connection as well?

![](https://cdn-images-1.medium.com/max/800/1*fy8n3lBauSinX37LlLGyAA.png)

As you can see, loading 50 bundles via HTTP/1.1 doesn’t seem to be terribly slow compared to 6 bundles or 1 bundle. So using a “balanced” number of bundles for both HTTP/2 and HTTP/1.1 can be a reasonable compromise.

> **NOTE 1**: HTTP/1.1 mode was tested by connecting the web servers over a plain HTTP, not HTTPS, using Chrome browser. Because Chrome browser uses 6 simultaneous TCP connections for a HTTP/1.1 website, real world HTTP/1.1 browsers may show far worse performance degradation as the number of bundles increases.

> **NOTE 2**: Keep in mind that these numbers should not be compared to the above HTTP/2 results because this HTTP/1.1 test was executed on Sunday afternoon and overall internet performance was better than busy hours of the weekday when the HTTP/2 test was executed.

### Use image sprites

It has been recommended to avoid [image sprites](http://www.w3schools.com/css/css_image_sprites.asp) in HTTP/2 environment for the same reason as concatenation.

However, if individual icon files are small and icons in a sprite share a common design theme, it can be actually beneficial to use image sprites as opposed to bunch of tiny individual image files.

If icons in a sprite are inter-related and share a theme, changes will highly likely occur to many icons, defying the benefit of granular cache-ability anyway.

### Carefully use data URIs

It has been also recommended to avoid inlining assets using [data URIs](https://developer.mozilla.org/en-US/docs/Web/HTTP/data_URIs).

This is more subtle topic. An appropriate answer would be “it depends”. If the assets are really small(under 100 bytes), inlining can make more sense. Even if the assets are relatively big, inlining can be still beneficial if they are expected to change frequently or changes to them are supposed to be in sync with changes to the hosting document.

### Enable both SPDY and HTTP/2

This is a deployment issue rather than development. There are many browsers out there that support SPDY only. This will change over time and SPDY will be completely replaced by HTTP/2 sometime in the future.

In the meantime, we can’t ignore SPDY yet. Enable both SPDY and HTTP/2 when you deploy your web server. For NGINX, CloudFlare [open sourced](https://blog.cloudflare.com/open-sourcing-our-nginx-http-2-spdy-code/) a patch for that.

* * *

Despite best practices not being established yet considering the newness of HTTP/2, web developers heeding this advice when bundling their assets should reap the benefits HTTP/2 performance as well as flexible browser caching.

Check out the benchmark code here: [https://github.com/gourmetjs/http2-concat-benchmark](https://github.com/gourmetjs/http2-concat-benchmark)

Get tables and pictures in this article here: [https://github.com/gourmetjs/http2-concat-benchmark-docs](https://github.com/gourmetjs/http2-concat-benchmark-docs)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
