> * 原文地址：[How to debug front-end: optimising network assets](https://blog.pragmatists.com/how-to-debug-front-end-optimising-network-assets-c0bfcad29b40)
> * 原文作者：[Michał Witkowski](https://blog.pragmatists.com/@WitkowskiMichau?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-debug-front-end-optimising-network-assets.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-debug-front-end-optimising-network-assets.md)
> * 译者：
> * 校对者：

# How to debug front-end: optimising network assets

![](https://cdn-images-1.medium.com/max/800/1*RD1J6kKPcfZV3MeAq-f4bA.jpeg)

Network performance can determine whether our web app succeeds or not. At the very beginning, when our app is small and fresh, few developers care about constantly checking how many megabytes are sent to the user or how long it takes.

If you’ve never measured your performance, most likely there is some room for improvement. The question is how much do you need to improve for your customer to notice.

In the study below, you can find information about a noticeable difference in loading time that a person can detect. If you want your customer to notice your efforts, go beyond the 20% threshold. [Read more](https://www.smashingmagazine.com/2015/09/why-performance-matters-the-perception-of-time/#the-need-for-performance-optimization-the-20-rule)

In this piece, I will cover (TL;DR):

*   Measuring performance via Chrome Devtool Audit
*   Image optimisation
*   Web font optimisation
*   JavaScript Optimisation
*   Improvements for render blocking assets
*   Other performance measurement applications/extensions

If you are struggling with some other problems, let us know in comments — our team and readers will be happy to help.

**This article is part of How to debug Front-end series:**

*   [How to debug Front-end: HTML/CSS](https://blog.pragmatists.com/how-to-debug-front-end-elements-d97da4cbc3ea)
*   [How to debug Front-end: Console](https://blog.pragmatists.com/how-to-debug-front-end-console-3456e4ee5504)

### Measure your performance

#### Chrome Devtools Audits

As the entire series is about Chrome Devtools, we will start with Audit Tab (which btw. uses Lightouse)

Open Chrome Devtools > Audits > Perform an audit… > Run audit

I’ve decided to check Performance and Best practices, but we are not touching the Progressive Web App topic today or Accessibility.

![](https://cdn-images-1.medium.com/max/800/0*Vu8XSuJJ4qkaGqzQ.)

Cool. After a little while, we have our performance review done and opportunities to improve it as a metric. Don’t worry if Audit changes the screen resolution to ‘mobile device’, as this is normal for Chrome. I strongly encourage you to use Chrome Canary for audits. Canary has an option to audit desktop sites and add the throttling option — see image below.

![](https://cdn-images-1.medium.com/max/800/0*VJ1eB8sRN7fB3Pr-.)

### Metrics

![](https://cdn-images-1.medium.com/max/800/0*2OAae2UKiLFk2b6T.)

Metrics gathers basic measurements and gives you a general overview on a page’s load time.

`**First meaningful paint** `— audit identifies the time at which the user sees the primary content. Try to keep it below 1 sec if possible. [Read more](https://developers.google.com/web/fundamentals/performance/rail)

`**First interactive**` — is the time at which the user sees some UI interactive elements and the page responds.

`**Perceptual Speed Index**` — is the average time at which visible parts of the page are displayed. It is expressed in milliseconds and is dependent on the size of the view port. Try to keep it below 1250 ms. Read more (https://sites.google.com/a/webpagetest.org/docs/using-webpagetest/metrics/speed-index)

`**Estimated Input Latency**` — is the app response for user input in ms.

#### Opportunities

`**Opportunities**` — is a rather more detailed section, gathering information about images, CSS and response time. I will go through each of them, adding tips on how to speed things up.

#### Reduce render-blocking stylesheets

CSS files are treated as render-blocking resources. This means the browser will wait for them to load, before rendering any content. The easiest step is simply not to load unnecessary CSS files. If you’re using bootstrap, maybe you don’t need the whole library to style your page — especially at the beginning of a project.

Later on, you can think about optimisation for different screen sizes. To decrease the level of loading CSS, you can use conditional loading, which loads only CSS files that are needed for particular screen resolution. Example below.

```
<link href="other.css" rel="stylesheet" media="(min-width: 40em)">
<link href="print.css" rel="stylesheet" media="print">
```

When that is not enough for you, Keith Clark comes up with a nice idea for loading CSS without blocking page-rendering. The trick is to use a link element with an invalid value for the media query. When the media query evaluates to false, the browser still downloads stylesheets but won’t delay with rendering the page. You can separate obligatory CSS from the rest and download it later. [Read more](https://keithclark.co.uk/articles/loading-css-without-blocking-render/)

#### Keep server response times low

Though this section is probably self-explanatory, it is still worth reminding ourselves of its use. To decrease server response time, you can consider using CDN’s for some assets. Implement HTTP2, or simply remove unnecessary requests and lazy load them after rendering the page.

#### Properly size Images, Offscreen images and next-gen formats

Those three sections are strongly connected with the same topic, images. To know exactly which images you are loading and how much they weigh, go into Network tab in Chrome Devtools and filter via IMG. By looking at the Size and Time rows, figure out if you are happy with those results. There is no general rule on how much each file should weigh. That strongly depends on your client devices, client group and many more conditions that only you are aware of.

![](https://cdn-images-1.medium.com/max/800/0*0QWY_H341qffDwUE.)

I would like to add a few words about image optimisation here. The topic will appear several times in Audit results.

#### Image Optimisation

There are rasters and vectors. A raster image is made of pixels. We usually use them for photos and complicated animations. Extensions: jpg, jpeg, gif.

A vector image is made of geometric shapes. We use them for logos and icons, as they scale very nicely. Extension: svg.

#### SVG

SVG’s is relatively small at the very start, but you can make it even smaller with those optimiser.

*   [SvgOmg](https://jakearchibald.github.io/svgomg/)
*   [Svg-optimiser](http://petercollingridge.appspot.com/svg-optimiser)

#### Raster

Here it’s a bit more tricky, since raster images can be very large. There are a few techniques to keep them large in size and small in weight.

#### Few images

Start with preparing a few versions of your image. You don’t want to load a retina-size image on your phone, right? Try to make 3–4 of them. Mobile, tablet, desktop, retina. Their size depends on what devices you are targeting. If you have any problems figuring this out, look at standard queries in the [link](https://css-tricks.com/snippets/css/media-queries-for-standard-devices/).

#### Srcset attribute

Once your images are ready to go, src attribute helps to define when to load certain images.

```
<img src="ing.jpg" srcset="img.jpg, img2x.jpg 2x" alt="img">
```

`src`for browser not supporting `srcset`
`srcset` for browser supporting srcset
`img2x.jpg` for devices with pixel ratio 2.0 (retina)

```
<img src="img.jpg" srcset="img1024.jpg 1024w, img2048.jpg 2048w" alt="img">
```

`src` for browser not supporting `srcset`
`srcset` for browser supporting `srcset`
`img` 1024 for 1024w etc.

This example comes from [Developer Mozilla](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images)

#### Media queries

You can also create the aforementioned media queries and styles such as tablet, or phone. This method is especially efficient with CSS preprocessors.

The alternative for srcset attribute are media queries, where the rule will not be in HTML, but in the CSS file. With pure CSS, this option is time-consuming and not worth your effort. Here, the preprocessor comes to the rescue with mixins and variables. With preprocessors, media queries are a good competitor to srcset. The decision is yours.

```
@desktop:   ~"only screen and (min-width: 960px) and (max-width: 1199px)";
@tablet:    ~"only screen and (min-width: 720px) and (max-width: 959px)";

@media @desktop {
  footer {
    width: 940px;
  }
}

@media @tablet {
  footer {
    width: 768px;
  }
}
```

#### Image CDNs

When pictures are ready and optimised, you can also take care of delivery. Tools such as Cloudinary significantly reduce response latency. Their servers are based all over the world, so delivery will be faster. Using HTTP, you are limited to 6 parallel requests to the server. With CDN’s, you can multiply the number of servers and requests.

#### Lazy load

Sometimes pictures just need to be fancy and big. If you still struggle with long latency, try experimenting with blurry images or lazy load.

Lazy load is a method of loading pictures or any content when needed. Not all pictures need to be loaded when the gallery has 1000 of them. Just load the first 10 and the rest when users need them.

There are tons of libraries to do so. [Read more](https://www.sitepoint.com/five-techniques-lazy-load-images-website-performance/)

Blurring is currently used by Facebook. When you open somebody’s profile with a poor connection, the picture is blurry at first; later it gets sharper. [Read more](https://css-tricks.com/the-blur-up-technique-for-loading-background-images/)

### Diagnostics

![](https://cdn-images-1.medium.com/max/800/0*pJgV5n0ujBTL3zhB.)

Diagnostics closes the series of tests. I won’t go through each one on the list, as some topics have already been covered. I’ll only mention some of them and try to cover those topics in general.

#### Uses inefficient cache policy on static assets

Google is very into caching and serverless apps. Cashing depends totally on you and I’m not a big fan of cashing. If you want to learn more about cashing, Google prepared some good courses for it. [Read more](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching#cache-control)

#### Critical Request Chains / render-blocking scripts

Critical request chains contain a request that needs to be fulfilled before page-render. It is crucial to keep it as small as possible.

We mentioned CSS loading before, let’s talk about webfont now.

#### Optimising Web Fonts

When creating web apps/websites, we currently use four font formats: EOT, TTF, WOFF, WOFF2.

There isn’t one right format, so once again, we need to use a different format per browser. ‘Ready to go’ queries and more explanation on this topic here. [Read more](https://css-tricks.com/snippets/css/using-font-face/)
At first, ask yourself if you really need to use a webfont? There’s a very nice article about it [here](https://hackernoon.com/web-fonts-when-you-need-them-when-you-dont-a3b4b39fe0ae).

#### Font-compression

Fonts are a collection of shapes and path-descriptions, creating letters. Each letter is different, but luckily they have much in common, so we can compress them a little.
As EOT and TTF formats are not compressed by default, make sure that your servers are configured to apply GZIP.
WOFF has built-in compression. Use optimal compression settings on your server.
WOFF2 has custom preprocessing. [Read more](http://www.w3.org/TR/WOFF20ER/)

#### Limit characters

Are you writing in English? Remember: there is no need to add Arabic or Greek letters into your font. You can also use unicode codepoints. This enables the browser to split large Unicode font into smaller subsets. [Read more](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/unicode-range)

#### Font-loading strategy

Loading fonts blocks page-rendering, as the browser needs to build DOM with all fonts in it.
The implementation of a font-loading strategy prevents loading delay. Fonts-display, which is a part of strategy, is in CSS properties. [Read more](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/font-display)

### Optimising JavaScript

#### Unnecessary dependencies

Nowadays, we use webpack and gulp widely, as ES6 gets us imports. When working with libraries, it’s important to remember that you don’t always need the whole library. If you don’t need to import the whole lodash, just import one function.

`import _ from 'lodash '`— will put whole library into bundle

`import {map} from 'lodash' `— will put whole library into bundle, you can use plugins such as [lodash-webpack-plugin](https://github.com/lodash/lodash-webpack-plugin), [babel-plugin-lodash](https://github.com/lodash/babel-plugin-lodash)

`import map from 'lodash/map' `— will put only map module into bundle

Look closely into ES6 functions and your native functions in the framework. You don’t need a new library for every feature. To inspect how your bundle is built, use tools from the links below.

*   [Webpack bundle analyzer](https://www.npmjs.com/package/webpack-bundle-analyzer)
*   [Bundle buddy](https://github.com/samccone/bundle-buddy)

#### Other tools

There are of course more tools to measure your site performance.
One of them is tools.pingdom.com which more or less gives you the same information as the Audits + Network tab.

![](https://cdn-images-1.medium.com/max/800/0*tVmtmD2cIQkhmfnO.)

I’d also recommend installing PageSpeed Insights, a Chrome extension. It shows you directly which image needs to be smaller.

### Summary

This article attempted to show you how to make your website lighter, by decreasing your assets’ weight. It’s merely a first step to enhancing your performance. After all, the field is broad and changes with the development of modern front-end. Keep your eye on the topic and on your competition. Try to be one step ahead.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
