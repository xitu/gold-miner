> * 原文地址：[Self-Host Your Static Assets](https://csswizardry.com/2019/05/self-host-your-static-assets/)
> * 原文作者：[Harry](https://twitter.com/intent/follow?original_referer=https%3A%2F%2Fcsswizardry.com%2F2019%2F05%2Fself-host-your-static-assets%2F&ref_src=twsrc%5Etfw&region=follow_link&screen_name=csswizardry&tw_p=followbutton)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/self-host-your-static-assets.md](https://github.com/xitu/gold-miner/blob/master/TODO1/self-host-your-static-assets.md)
> * 译者：
> * 校对者：

# Self-Host Your Static Assets

One of the quickest wins—and one of the first things I recommend my clients do—to make websites faster can at first seem counter-intuitive: you should self-host all of your static assets, forgoing others’ CDNs/infrastructure. In this short and hopefully very straightforward post, I want to outline the disadvantages of hosting your static assets ‘off-site’, and the overwhelming benefits of hosting them on your own origin.

## What Am I Talking About?

It’s not uncommon for developers to link to static assets such as libraries or plugins that are hosted at a public/CDN URL. A classic example is jQuery, that we might link to like so:

```html
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
```

There are a number of perceived benefits to doing this, but my aim later in this article is to either debunk these claims, or show how other costs vastly outweigh them.

* **It’s convenient.** It requires very little effort or brainpower to include files like this. Copy and paste a line of HTML and you’re done. Easy.
* **We get access to a CDN.** `code.jquery.com` is served by [StackPath](https://www.stackpath.com/products/cdn/), a CDN. By linking to assets on this origin, we get CDN-quality delivery, free!
* **Users might already have the file cached.** If `website-a.com` links to `https://code.jquery.com/jquery-3.3.1.slim.min.js`, and a user goes from there to `website-b.com` who also links to `https://code.jquery.com/jquery-3.3.1.slim.min.js`, then the user will already have that file in their cache.

## Risk: Slowdowns and Outages

I won’t go into too much detail in this post, because I have a [whole article](https://csswizardry.com/2017/07/performance-and-resilience-stress-testing-third-parties/) on the subject of third party resilience and the risks associated with slowdowns and outages. Suffice to say, if you have any critical assets served by third party providers, and that provider is suffering slowdowns or, heaven forbid, outages, it’s pretty bleak news for you. You’re going to suffer, too.

If you have any render-blocking CSS or synchronous JS hosted on third party domains, go and bring it onto your own infrastructure **right now**. Critical assets are far too valuable to leave on someone else’s servers.

## Risk: Service Shutdowns

A far less common occurrence, but what happens if a provider decides they need to shut down the service? This is exactly what [Rawgit](https://rawgit.com) did in October 2018, yet (at the time of writing) a crude GitHub code search still yielded [over a million references](https://github.com/search?q=rawgit&type=Code) to the now-sunset service, and almost 20,000 live sites are still linking to it!

![](https://csswizardry.com/wp-content/uploads/2019/05/big-query-rawgit.jpg)

Many thanks to [Paul Calvano](https://twitter.com/paulcalvano) who very kindly [queried the HTTPArchive](https://bigquery.cloud.google.com/savedquery/226352634162:7c27aa5bac804a6687f58db792c021ee) for me.

## Risk: Security Vulnerabilities

Another thing to take into consideration is the simple question of trust. If we’re bringing content from external sources onto our page, we have to hope that the assets that arrive are the ones we were expecting them to be, and that they’re doing only what we expected them to do.

Imagine the damage that would be caused if someone managed to take control of a provider such as `code.jquery.com` and began serving compromised or malicious payloads. It doesn’t bear thinking about!

### Mitigation: Subresource Integrity

To the credit of all of the providers referenced so far in this article, they do all make use of [Subresource Integrity](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity) (SRI). SRI is a mechanism by which the provider supplies a hash (technically, a hash that is then Base64 encoded) of the exact file that you both expect and intend to use. The browser can then check that the file you received is indeed the one you requested.

```html
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
        integrity="sha256-pasqAKBDmFT4eHoN2ndd6lN370kFiGUFyTiUHWhU7k8="
        crossorigin="anonymous"></script>
```

Again, if you absolutely must link to an externally hosted static asset, make sure it’s SRI-enabled. You can add SRI yourself using [this handy generator](https://www.srihash.org/).

## Penalty: Network Negotiation

One of the biggest and most immediate penalties we pay is the cost of opening new TCP connections. Every new origin we need to visit needs a connection opening, and that can be very costly: DNS resolution, TCP handshakes, and TLS negotiation all add up, and the story gets worse the higher the latency of the connection is.

I’m going to use an example taken straight from Bootstrap’s own [Getting Started](https://getbootstrap.com/docs/4.3/getting-started/introduction/). They instruct users to include these following four files:

```html
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="..." crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="..." crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="..." crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="..." crossorigin="anonymous"></script>
```

These four files are hosted across three different origins, so we’re going to need to open three TCP connections. How much does that cost?

Well, on a reasonably fast connection, hosting these static assets off-site is 311ms, or 1.65×, slower than hosting them ourselves.

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-off-site-cable.png)

By linking to three different origins in order to serve static assets, we cumulatively lose a needless 805ms to network negotiation. [Full test.](https://www.webpagetest.org/result/190531_FY_618f9076491312ef625cf2b1a51167ae/3/details/)

Okay, so not exactly terrifying, but Trainline, a client of mine, found that by reducing latency by 300ms, [customers spent an extra £8m a year](https://wpostats.com/2016/05/04/trainline-spending.html). This is a pretty quick way to make eight mill.

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-self-hosted-cable.png)

By simply moving our assets onto the host domain, we completely remove any extra connection overhead. [Full test.](https://www.webpagetest.org/result/190531_FX_f7d7b8ae511b02aabc7fa0bbef0e37bc/3/details/)

On a slower, higher-latency connection, the story is much, much worse. Over 3G, the externally-hosted version comes in at an eye-watering **1.765s slower**. I thought this was meant to make our site faster?!

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-off-site-3g.png)

On a high latency connection, network overhead totals a whopping 5.037s. All completely avoidable. [Full test.](https://www.webpagetest.org/result/190531_XE_a95eebddd2346f8bb572cecf4a8dae68/3/details/)

Moving the assets onto our own infrastructure brings load times down from around 5.4s to just 3.6s.

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-self-hosted-3g.png)

By self-hosting our static assets, we don’t need to open any more connections. [Full test.](https://www.webpagetest.org/result/190531_ZF_4d76740567ec1eba1e6ec67acfd57627/1/details/)

If this isn’t already a compelling enough reason to self-host your static assets, I’m not sure what is!

### Mitigation: `preconnect`

Naturally, my whole point here is that you should not host any static assets off-site if you’re otherwise able to self-host them. However, if your hands are somehow tied, then you can use [a `preconnect` Resource Hint](https://speakerdeck.com/csswizardry/more-than-you-ever-wanted-to-know-about-resource-hints?slide=28) to preemptively open a TCP connection to the specified origin(s):

```html
<head>

  ...

  <link rel="preconnect" href="https://code.jquery.com" />

  ...

</head>
```

For bonus points, deploying these as [HTTP headers](https://andydavies.me/blog/2019/03/22/improving-perceived-performance-with-a-link-rel-equals-preconnect-http-header/) will be even faster.

**N.B.** Even if you do implement `preconnect`, you’re still only going to make a small dent in your lost time: you still need to open the relevant connections, and, especially on high latency connections, it’s unlikely that you’re ever going to fully pay off the overhead upfront.

## Penalty: Loss of Prioritisation

The second penalty comes in the form of a protocol-level optimisation that we miss out on the moment we split content across domains. If you’re running over HTTP/2—which, by now, you should be—you get access to prioritisation. All streams (ergo, resources) within the same TCP connection carry a priority, and the browser and server work in tandem to build a dependency tree of all of these prioritised streams so that we can return critical assets sooner, and perhaps delay the delivery of less important ones.

To fully understand the benefits of prioritisation, [Pat Meenan’s post](https://calendar.perfplanet.com/2018/http2-prioritization/) on the topic serves as a good primer.

**N.B.** Technically, owing to H/2’s [connection coalescence](https://daniel.haxx.se/blog/2016/08/18/http2-connection-coalescing/), requests can be prioritised against each other over different domains as long as they share the same IP address.

If we split our assets across multiple domains, we have to open up several unique TCP connections. We cannot cross-reference any of the priorities within these connections, so we lose the ability to deliver assets in a considered and well designed manner.

Compare the two HTTP/2 dependency trees for both the off-site and self-hosted versions respectively:

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-dep-tree-off-site.png)

Notice how we need to build new dependency trees per origin? Stream IDs 1 and 3 keep reoccurring.

![](https://csswizardry.com/wp-content/uploads/2019/05/wpt-dep-tree-self-hosted.png)

By hosting all content under the same origin, we can build one, more complete dependency tree. Every stream has a unique ID as they’re all in the same tree.

Fun fact: Stream IDs with an odd number were initiated by the client; those with an even number were initiated by the server. I honestly don’t think I’ve ever seen an even-numbered ID in the wild.

If we serve as much content as possible from one domain, we can let H/2 do its thing and prioritise assets more completely in the hopes of better-timed responses.

## Penalty: Caching

By and large, static asset hosts seem to do pretty well at establishing long-lived `max-age` directives. This makes sense, as static assets at versioned URLs (as above) will never change. This makes it very safe and sensible to enforce a reasonably aggressive cache policy.

That said, this isn’t always the case, and by self-hosting your assets you can design [much more bespoke caching strategies](https://csswizardry.com/2019/03/cache-control-for-civilians/).

## Myth: Cross-Domain Caching

A more interesting take is the power of cross-domain caching of assets. That is to say, if lots and lots of sites link to the same CDN-hosted version of, say, jQuery, then surely users are likely to already have that exact file on their machine already? Kinda like peer-to-peer resource sharing. This is one of the most common arguments I hear in favour of using a third-party static asset provider.

Unfortunately, there seems to be no published evidence that backs up these claims: there is nothing to suggest that this is indeed the case. Conversely, [recent research](https://discuss.httparchive.org/t/analyzing-resource-age-by-content-type/1659) by [Paul Calvano](https://twitter.com/paulcalvano) hints that the opposite might be the case:

> There is a significant gap in the 1st vs 3rd party resource age of CSS and web fonts. 95% of first party fonts are older than 1 week compared to 50% of 3rd party fonts which are less than 1 week old! This makes a strong case for self hosting web fonts!

In general, third party content seems to be less-well cached than first party content.

Even more importantly, [Safari has completely disabled this feature](https://andydavies.me/blog/2018/09/06/safari-caching-and-3rd-party-resources/) for fear of abuse where privacy is concerned, so the shared cache technique cannot work for, at the time of writing, [16% of users worldwide](http://gs.statcounter.com/).

In short, although nice in theory, there is no evidence that cross-domain caching is in any way effective.

## Myth: Access to a CDN

Another commonly touted benefit of using a static asset provider is that they’re likely to be running beefy infrastructure with CDN capabilities: globally distributed, scalable, low-latency, high availability.

While this is absolutely true, if you care about performance, you should be running your own content from a CDN already. With the price of modern hosting solutions being what they are (this site is fronted by Cloudflare which is free), there’s very little excuse for not serving your own assets from one.

Put another way: if you think you need a CDN for your jQuery, you’ll need a CDN for everything. Go and get one.

## Self-Host Your Static Assets

There really is very little reason to leave your static assets on anyone else’s infrastructure. The perceived benefits are often a myth, and even if they weren’t, the trade-offs simply aren’t worth it. Loading assets from multiple origins is demonstrably slower. Take ten minutes over the next few days to audit your projects, and fetch any off-site static assets under your own control.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
