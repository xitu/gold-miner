> * 原文地址：[Top Image Lazy Loading Libraries for JavaScript](https://blog.bitsrc.io/top-image-lazy-loading-libraries-for-javascript-dc39fbc9511f)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/top-image-lazy-loading-libraries-for-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/top-image-lazy-loading-libraries-for-javascript.md)
> * 译者：
> * 校对者：

# Top Image Lazy Loading Libraries for JavaScript

![Photo by [Annie Spratt](https://unsplash.com/@anniespratt?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6000/0*IeWD36cpByaa0F2d)

## Why Lazy Load Images?

Performance is crucial in web applications. You can have the most beautiful and engaging website in the world, but if it does not load quickly on the browser, people would tend to skip it. It can be quite tricky to make your website perform really well. This is because of the numerous bottlenecks present in web development such as expensive JavaScript, slow web font delivery, heavy images, etc.

Let’s focus on how images affect your performance. According to [Jecelyn](https://twitter.com/jecelynyeen), on average a web page consumes 5 MB of data just for images. This can be a heavy burden on the users as it can be very costly in some countries, especially on mobile data. The users will also have issues with site loading times, notably with slower connection speeds. This can have a negative impact on your website.

According to [Jakob Nielson](https://www.nngroup.com/articles/website-response-times/), here are some key statistics you should keep in mind.

* Under 100 milliseconds is perceived as instantaneous.
* A 100ms to 300ms delay is perceptible.
* 47% of consumers expect a web page to load in two seconds or less
* 40% of consumers will wait no more than three seconds for a web page to render before abandoning the site.

## What is Lazy Loading?

There are several strategies that can be implemented to help you serve your images efficiently and effectively without compromising on performance and quality. Lazy loading is one of them. The concept of lazy loading loads only the required content and delays the remaining until needed. This concept can be applied to images, videos, text, and other types of data. But mostly it is applied to heavy content such as images.

There are several ways of implementing lazy-loaded images on your website. You can use the Intersection Observer API, or even use event handlers to determine whether an element is in view. There are several powerful libraries available that use several methods of lazy loading images according to the need and compatibility. Let’s have a look at them.

## Lazy Sizes

[Lazy Sizes](https://github.com/aFarkas/lazysizes) is one of the best lazy loading libraries out there with over 14.1K stars on Github. It has a size of [3.4kB](https://bundlephobia.com/result?p=lazysizes@5.2.2) minified and gzipped. It also has support for around 98.5% of browser users. I personally love how deep and well explained the documentation is.

#### Features

* Includes responsive image support
* Improved SEO by detecting a search engine with the help of the user-agent and immediately load all images at once.
* Based on highly efficient and practical code
* Prefetches resources when the network connection is idle
* Includes support for LQIPs
* Chooses whichever is supported from `IntersectionObserver`, `MutationObserver` and `getElementsByClassName`.
* Extendable features by using plugins
* Supports responsive images with automated size calculations

You can view the demo over [here](http://afarkas.github.io/lazysizes/#examples).

![LazySizes Repo — Screenshot by Author](https://cdn-images-1.medium.com/max/2682/1*Ifefl4QqsSO-zNmfCiPJPg.png)

## Lozad.js

[Lozad.js](https://github.com/ApoorvSaxena/lozad.js) supports lazy loading for images, iframes, ads, videos, and other elements. It has almost 6.4K stars on Github and is very popular amongst the community. According to the team, this library is used by several brands such as Tesla, Dominos, Xiaomi, and BBC on their web applications. It is very light with a size of [1.1kB](https://bundlephobia.com/result?p=lozad@1.16.0) minified and gzipped. It supports almost 92% of browser users as it uses the `IntersectionObserver` API and the `MutationObserver` API.

#### Features

* No dependencies
* Support lazy loading of dynamically added elements
* Uses pure JavaScript
* Includes support for LQIPs and responsive images
* Efficient and performant than libraries using `getBoundingClientRect()`
* Polyfills can be used on unsupported browsers

You can view the demo over [here](https://apoorv.pro/lozad.js/demo/).

![Lozad.js Repo — Screenshot by Author](https://cdn-images-1.medium.com/max/2690/1*qFRDVwpjSbhaoT7b-cIhbA.png)

## Lazyload by Tuupola

[Lazyload by Tuupola](https://github.com/tuupola/lazyload) is another popular image lazy loading library with almost 8.4K stars on Github. It uses the `IntersectionObserver` API and simple and easy to use. The minified and gzipped script is [956 bytes](https://bundlephobia.com/result?p=lazyload@2.0.0-rc.2) and smaller than the rest. But this can be attributed due to the use of only the `IntersectionObserver` API as other libraries use a combination of other libraries to achieve better compatibility and performance. Furthermore, due to this, it is supported by 92% of browser users present currently.

#### Features

* Includes a jQuery wrapper for convenience
* Includes support for LQIPs and responsive images
* The core `IntersectionObserver` API can be configured by passing additional parameters

## Vanilla Lazyload by Andrea Verlicchi

[Vanilla lazy load](https://github.com/verlok/vanilla-lazyload) is another pure JavaScript library for lazy loading images, videos, and iframes. It is quite popular with almost 5.7K stars on Github and is used by almost 1500 repositories and packages. It has over 1.9 million downloads per year in NPM. The minified gzipped source is [2.7kB](https://bundlephobia.com/result?p=vanilla-lazyload@17.1.2). Similar to other libraries, this library uses the `IntersectionObserver` API and is supported by 92% of browser users.

* SEO friendly as the library does not hide the images from the search engine
* Supports unstable connections as the library reloads images automatically after a connection disruption
* Cancel loading of images if they exit the viewport
* Includes support for LQIPs and responsive images
* Pure JavaScript

![](https://cdn-images-1.medium.com/max/2682/1*tPp7c2D1JBJZ6Vj7Fb3xBA.png)

You can view the demos over [here](https://github.com/verlok/vanilla-lazyload/tree/master/demos).

## Yall.js

[Yall.js](https://github.com/malchata/yall.js) too is another JavaScript library that solely uses the `IntersectionObserver` API to lazy load images, videos, iframes, and CSS background images. The repository has around 1.1K stars and is used by almost 91 users in their repos. The size of the library comes gzipped and minified at [1kB](https://bundlephobia.com/result?p=yall-js@3.2.0). As we saw in previous libraries, yall.js too supports 92% of browsers because of the `IntersectionObserver` API. You must note that there is no fallback if the browser does not support the `IntersectionObserver` API. You must use a polyfill in that case.

#### Features

* Support detection of dynamically loaded elements thanks to the `MutationObserver` API
* Optimizes browser idle time with the help of the `requestIdleCallback` method
* Supports a direct implementation of LQIP via `src` property
* Supports lazy loading CSS backgrounds

## Layzr.js

[Layzr.js](https://github.com/callmecavs/layzr.js) is a lightweight lazy loading library for images in JavaScript. It primarily uses `Element.classList` , few ES5 array methods and the `requestAnimationFrame` method. Due to these APIs, this library is supported by over 97% of browser users. Layzr.js has over 5.6K stars on Github and is quite popular. This compact library comes packed at [1kB](https://bundlephobia.com/result?p=layzr.js@2.2.2) minified and gzipped.

* No dependencies
* Intelligently select image source based on browser compatibility and availability
* Support dynamically added elements
* Clear and concise documentation with examples
* Adjust delay with image load relative to the viewport with the **threshold** property. You can load the images earlier or later depending on your requirement.

You can view the demo over [here](http://callmecavs.com/layzr.js/).

![Layzr.js Demo — Screenshot by Author](https://cdn-images-1.medium.com/max/2654/1*nHQAXoOiLy5CGfsE5pdT8g.png)

## Blazy.js

[Blazy.js](https://github.com/dinbror/blazy) is another lightweight lazy loading library for JavaScript that is capable of handling images, videos, and iframes. It is very popular in Github with 2.6K stars and is being used by over 860 public repositories. The library comes gzipped and minified at a size of [1.9kB](https://bundlephobia.com/result?p=blazy@1.8.2).

Uses the Element.getBoundingClientRect() method which might not be performant compared to the other libraries implementing the `IntersectionObserver` API. But because of this approach, this library has over 98% of browser users supported natively. It also uses the `Element.closest()` method in its implementation as well. This API has browser support of just over 94%. You would not need to worry about the left out 6% in this case as the library includes a polyfill for non-supporting browsers.

#### Features

* Used in real-world websites with millions of monthly visitors
* No dependencies
* Support for responsive images
* Similar to Layzr.js, allows you to load element with an offset
* Clear [documentation](http://dinbror.dk/blog/blazy/) with sample code
* Supports module formats such as AMD, CommonJS and globals
* Very easy to serve retina images

You can view the demo over [here](http://dinbror.dk/blazy/?ref=github).

![Blazy.js Demo — Screenshot by Author](https://cdn-images-1.medium.com/max/2650/1*mJsrNbt7H3GpZDTEog4b_g.png)

## Responsively Lazy

[Responsively lazy](https://github.com/ivopetkov/responsively-lazy) is a lazy loading library for images. It is very compact at a size of 1.1kB minified and gzipped. This library stands out from the crowd due to its syntax implementation. Most of the above libraries we’ve discussed require you to use the `noscript` tag for browsers that have javascript disabled, ignore `src` attribute, etc. But responsively lazy allows you to work with the traditional `src` attribute and add a `srcset` and `data-src` attributes for supported browsers. This enables this library to be SEO friendly. This library also uses Element.getBoundingClientRect() and therefore the forced layout reflows will be present in this library as well.

Furthermore, this library has almost 1.1K stars on Github and is supported by almost 95% of browser users.

#### Features

* Supports responsive images
* Supports webp
* SEO friendly
* Not many customizations available

You can view the demo over [here](http://ivopetkov.github.io/responsivelyLazy/).

![Responsively lazy demo — Screenshot by Author](https://cdn-images-1.medium.com/max/2000/1*Z3WoOAwwTdEsGJhPcEzQ0Q.png)

## LazyestLoad.js

[LazyestLoad.js](https://github.com/Paul-Browne/lazyestload.js) is one of the smallest libraries in this list. It is served at a minified size of 700 bytes and 639 bytes. There are two variants of this library, `lazyload` and `lazyestload`. Both of them have different use cases. The `lazyload` variant works like a normal library where images are loaded when they are about to enter the viewport. But the `lazyestload` version only loads the image when the user has stopped scrolling just when the image is in the viewport or within 100 pixels. This can help reduce the network load if the user simply scrolls without pausing to look at the pictures.

It primarily uses the Element.getBoundingClientRect() method which is not efficient compared to other implementation and is known to [trigger a layout reflow](https://gist.github.com/paulirish/5d52fb081b3570c81e3a).

This library only handles images, unlike other libraries which handle videos and iframes as well. It still has over 1.5K stars on Github.

#### Features

* Simple and straight to the point.
* Does not allow much customization like other libraries
* Supports responsive images
* Not well documented

You can view the demo for lazyload over [here](https://rawgit.com/Paul-Browne/lazyestload.js/master/dist/lazyload.html) and lazyestload over [here](https://rawgit.com/Paul-Browne/lazyestload.js/master/dist/lazyestload.html).

---

With native lazy loading being supported in most modern browsers, it is advised to make use of this native implementation. This implementation removes the need for any additional libraries we’ve discussed above. Native lazy loading also ensures that the images will get lazy-loaded even if JavaScript is disabled in the browser. You can simply save all the hassle by using the `loading="lazy"` attribute in your `img` tags.

Native lazy loading is supported in most modern browsers with support for Safari very close. Currently, browser support is at [74%](https://caniuse.com/loading-lazy-attr) and you can use either a [polyfill](https://github.com/mfranzke/loading-attribute-polyfill) or one of the above-mentioned libraries if a browser does not support the native implementation.

You might still need to implement one of the libraries if necessary using dynamic imports just to be safe.

## Why Should You Know Your Target Audience?

If you sharply analyze all of the above-given libraries, you would notice that they heavily compete under three aspects: Performance, Size, and Browser Compatibility(User coverage). They often have to sacrifice at least one to get better at another.

For example, if you use a library which implements the `IntersectionObserver` API, you would get a high performant library, but it would have less user coverage. If you need to patch up on that, you will need to have fallback options such as polyfills which would increase the overall size of the library.

On another example, if the library uses the `getBoundingClientRect()` method, it will be less performant than the `IntersectionObserver` API as it is known to have issues with [forced layout reflows](https://gist.github.com/paulirish/5d52fb081b3570c81e3a). Although you sacrifice on performance, you will have higher user coverage than the former. Hope I made that point clear.

**How to minimize compatibility issues and maximize performance?**

You can improve these aspects by understanding your target audience and their browser distribution. If you know your audience and the browsers they use, you can make sure your implementation of lazy loading is more tailormade towards those browser versions. This would reduce the need for you to include polyfills for unsupported browsers as you already know what browsers you need to focus on. And when you have an outlier(unsupported browser), the images can be directly loaded without any delay or deferring. The number of these outliers will be negligible if you have a great understanding of your audience.

This approach would help you use a well-performing implementation, keep the library size at a minimum by disregarding outlier browsers, and support the browser versions of your target audience.

---

We have briefly discussed lazy loading libraries for JavaScript and some approaches for better efficiency and user experience. Let me know your thoughts in the comments below.

Thank you for reading & happy coding!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
