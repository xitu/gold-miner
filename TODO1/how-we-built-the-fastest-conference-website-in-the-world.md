> * 原文地址：[How we built the fastest conference website in the world](https://2019.jsconf.eu/news/how-we-built-the-fastest-conference-website-in-the-world/)
> * 原文作者：[Malte Ubl](https://twitter.com/cramforce) 
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-built-the-fastest-conference-website-in-the-world.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-we-built-the-fastest-conference-website-in-the-world.md)
> * 译者：
> * 校对者

# How we built the fastest conference website in the world

> This is a guest post by JSConf EU Organiser [Malte Ubl](https://twitter.com/cramforce).

The clickbait headline got you here, so let's make this worth your while! I have no idea whether this is the fastest conference website in the world but I also don't know that it isn't; and I've spent a completely unreasonable amount of time trying to make it be the fastest conference website in the world. I'm also the creator of [AMP](https://www.ampproject.org/), a web component library for making reliably fast websites, and this website is my playground to try out new techniques for future optimizations that I can apply to my day job. Also, fast websites [have better conversion rates](https://www.cloudflare.com/learning/performance/more/website-performance-conversion-rates/), which in our case means: [sell more tickets](https://ti.to/jsconfeu/jsconf-eu-x-2019/).

The [JSConf EU website](https://2019.jsconf.eu/) is built on the static site generator [wintersmith](http://wintersmith.io/). If you know what [Jekyll](https://jekyllrb.com/) is, you know what wintersmith is. Basically the same thing, just Node.js based. Wintersmith is alright. It doesn't do anything terrible by default, but there are a few things I needed that I had to build myself.

## Fonts

### INLINING

OMG, I spent so much time optimizing font performance. Do you know how to have faster font performance than the JSConf website? Use system fonts, yes, but that is boring. Fonts are nice and we are using Typekit for fonts. Typekit requires you to load a CSS or JS file to teach the page where the font files are. That is horrible for performance: loading a file means waiting for the network and the network is slow. Adding a CSS file pointing to a third party host to your page can easily impact [First Contentful Paint](https://developers.google.com/web/tools/lighthouse/audits/first-contentful-paint) by 600ms due to the DNS resolution, TCP and TLS connect, etc. I fixed that by [simply downloading the CSS file in the build process](https://github.com/jsconf/festival-x.jsconf.eu/blob/master/scripts/generate-locals.js#L5) and inlining it into the CSS. Problem solved. 600ms won.

It turns out the Typekit CSS file actually uses `@import` to load another CSS file. I'm not sure whether that blocks rendering, but it isn't good. Turns out the file is empty and the request is only used for stats collection. To avoid this, the script I wrote removes the `@import` ([Yaihh, regexes](https://github.com/jsconf/festival-x.jsconf.eu/blob/master/scripts/generate-locals.js#L19)) from the inlined CSS and instead saves the URL to be requested after page load (when it no longer hurts) from JavaScript.

### FONT DISPLAY

Alright, now that we inlined Typekit's CSS we can also very easily change it with a [few more regexes](https://github.com/jsconf/festival-x.jsconf.eu/blob/master/scripts/generate-locals.js#L25). Adding [`font-display: fallback`](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/font-display) to the `@font-face` rules makes font painting not block the download, so we do that.

## Immutable URLs

I wish wintersmith had a true asset pipeline. It does have asset handlers, but only one per asset type. So, you can't easily do things for, say, CSS files and for SVGs without some code duplication. But who cares about code duplication for a conference website?

I [hacked wintersmith](https://github.com/jsconf/festival-x.jsconf.eu/blob/master/plugins/nunjucks.js#L130-L138) to insert a hash into all locally available asset URLs, and gave them a common path prefix that is configured in the CDN to emit effectively infinite caching headers. Similarly, [our ServiceWorker knows](https://github.com/jsconf/festival-x.jsconf.eu/blob/master/contents/sw.js#L23-L30) that it never has to worry about these URLs expiring and can keep the assets forever. If you copy our code, consider shortening the hash. Nobody needs that full SHA-Whatever in the real world for this use case, and not having the full hash saves quite a few bytes in the HTML. I'm not gonna change it now, because that would bust the cache for all the assets.

## CSS

### DEAD CODE ELIMINATION

The JSConf EU website uses [Tachyons](https://tachyons.io/) as a CSS framework. Tachyons is nice, except it is huge and has literally all of the features even in the smallest base package. I installed a [CSS Dead Code Elimination (DCE) post processing step](https://github.com/purifycss/purifycss) that looks at the actual markup generated by the static site generator and then prunes all the CSS selectors that could never match anything. In our case that reduces CSS size by a cool 85%.

### INLINING

Now that the CSS is super small, it makes sense to inline it into every page. You might think "but what about caching?" Good question, but if you want to win contests for fastest websites, you cannot afford that extra request in the cold cache state. And so, I inlined the CSS. But if you inline the CSS, you can actually do better on the CSS DCE. And so I run it again for every page, saving another 15-25% of CSS size on a per page basis.

As an aside: It makes a lot of sense to run CSS DCE once for the entire site and then per page. That is because the DCE process is `O(allHTMLSize + CSSsize)` for the whole site and `O(pageCount * (averageHTMLSize + CSSsize)` on a per page basis. If you run the whole site optimization first, the reduction in CSS makes the subsequent per page runs significantly faster--at least if the initial run reduces size by something like the 85% that it achieves in our case.

## Content Management

Most static site generators expect maintenance of the site via markdown files checked into git. The JSConf EU site instead uses a Google Spreadsheet for maintaining structured data (such as speaker profiles) and Google Docs to hold blog posts like this one. While this doesn't make the site faster, it does make editing faster, so it still counts towards being the fastest conference website. [This](https://docs.google.com/document/d/1oZWzjy0cPyBmdbghIREd9iVbUGXlUHd1Dnv7CmSQNPk/edit?usp=sharing), for example, is the document that you are seeing right now!

As part of the build process from the Google GSuite backend (LOL), we run image optimizations. Unfortunately, there wasn't yet enough time to also produce webp images, so if you want to build a faster conference website there would definitely be that opening!

## ServiceWorker

The JSConf website has a ServiceWorker based on [Workbox](https://developers.google.com/web/tools/workbox/). ServiceWorkers aren't always good for performance. They have to spin up and then often additionally IndexedDB has to spin up. This can cost 100s of milliseconds. For a conference website, however, the offline capability under bad conference Wi-Fi definitely wins over the performance concerns (Our event Wi-Fi is generally stellar, but with 1400 folks in the room, we want to be prepared). It is additionally mitigated by using [navigation preload](https://developers.google.com/web/updates/2017/02/navigation-preload) which amortizes the startup time over the document network request in good web browsers.

To trade-off freshness and offline capability, the site uses a "network-first" strategy, where we first try to fetch a fresh document and fallback to the cache if there is no response within 2 seconds.

Since all the assets of the sites use immutable URLs, the ServiceWorker will cache those forever and always serve from cache if available.

## Animations

You might have noticed that there is a big animated X on our homepage. Obviously, the page would load faster if it wasn't there, but where is the fun in that? The animation is based on the [Lottie-Web](https://github.com/airbnb/lottie-web) library which is an open source Adobe AfterEffects animation web player created by AirBnB, and, generally speaking, incredibly awesome. Unfortunately, it is also huge. And here this refers to both the animation runtime, and the animation data itself. The latter is a massive blob of JSON. We load that JSON as part of the animation JS rather than using `JSON.parse`, which gets us parsing of the data off the main thread in good web browsers.

## Script loading

The JSConf EU website actually loads some JavaScript--but it doesn't block the page paint, and we inline every bit that is necessary for interaction. That way, when the browser paints a page, all critical interactions always work, independently of whether the external JS has already loaded. Yes, that doesn't make the [CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP) happy, but YOLO. The JS we load also doesn't change the DOM in a way that would trigger additional paints (except, of course, for animations), so whatever the browser first paints is what will stay on the screen until user interaction.

## Pre-fetching

Jokes aside, one of the main things we hope people do on this website is [buy a ticket](https://ti.to/jsconfeu/jsconf-eu-x-2019). That is why early in the page load lifecycle we prefetch the landing page for our ticket payment provider, so that it loads more or less instantly when you decide to buy a ticket (which you should!). Additionally, all pages linked to from the main navigation are prefetched, so that navigation within the site are ultra speedy. Unfortunately, the prefetch feature isn't in all web browsers, but yours truly has lately spent a lot of time thinking about how to make it compatible with Safari's double-keyed caching infrastructure, so there is hope--albeit not for JSConf EU 2019.

## HTTP Cascade

The website paints with one HTTP round-trip, and never needs to fetch a HTTP resource to figure out what else to fetch except for the primary document. That means the maximum depth of the HTTP cascade is 2 requests. Especially on mobile, page load times are often dominated by latency. In these cases having a flat request cascade means that latency has a reduced negative effect, or to go back to O-notation: Page load time is `O(latency * HTTPCascadeDepth + timeItTakesToDownloadStuff)` if latency is big relative to available or required bandwidth. Being able to always paint with 1 HTTP round-trip means that in many cases the load time of a page is dominated by DNS and TLS connection. These often look bad in lab tests. With CDNs supporting [TLS1.3](https://blog.cloudflare.com/rfc-8446-aka-tls-1-3/) or even [Quic/HTTP3](https://en.wikipedia.org/wiki/QUIC) real-world performance can be look much better, especially for repeat visitors.

[![The request waterfall of
2019.jsconf.eu](https://2019.jsconf.eu/immutable/2ecf1ff4188e623f5f25400024c9eaebd9d77b30/images/cms/image-4656bb72.png#ar=105)](https://www.webpagetest.org/result/190318_AA_b2ed333c2d4c4b5cf441dc205162f23a/1/details/#waterfall_view_step1)A very flat HTTP cascade (The thing on the bottom right is the ServiceWorker booting, which doesn't impact the original page load).

## Image loading

OMG, I hate it when images load without their size being known upfront and they jank the page once they are coming over the network. On this site, all images either have a static size, or use the [`padding-top: XX%` hack](https://css-tricks.com/aspect-ratio-boxes/) to make the images expand to the available horizontal space. They also use the [intrinsicsize attribute](https://github.com/WICG/intrinsicsize-attribute) to not need that hack (currently supported in zero browsers) and the [lazyload attribute](https://css-tricks.com/a-native-lazy-load-for-the-web-platform/) for, well, lazy loading (also currently supported in zero browsers) and the [`decoding=async`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/decoding) (currently supported in good web browsers) for avoiding blocking the main thread for image decodes.

> What'd they call aspect ratio in CSS? They call it padding-top with percent.[Jan 18, 2018](https://twitter.com/cramforce/status/954005742234738688)

(Minor irony alert: The tweet above janked the page, but I put it so far down the page that you probably didn't notice. I'm sorry).

## Summary

And that's it. Making fast websites in 2019 isn't difficult. You just have to be buddies with browser makers, get paid to make websites faster, hang out on Twitter all day for all the hot performance tips, and prefer hacking on performance tweaks to watching Netflix.

## Acknowledgments

This post was written by [Malte Ubl](https://twitter.com/cramforce). This website itself was initially developed by the overly talented [Lukasz Klis](https://twitter.com/lukaszklis), and the awesome design was created by the amazing [Silke Voigts](https://twitter.com/silkine).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
