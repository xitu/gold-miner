> * 原文地址：[A Deep Dive into Native Lazy-Loading for Images and Frames](https://css-tricks.com/a-deep-dive-into-native-lazy-loading-for-images-and-frames/)
> * 原文作者：[Erk Struwe](https://css-tricks.com/author/erkstruwe/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-deep-dive-into-native-lazy-loading-for-images-and-frames.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-deep-dive-into-native-lazy-loading-for-images-and-frames.md)
> * 译者：
> * 校对者：

# A Deep Dive into Native Lazy-Loading for Images and Frames

Today's websites are packed with heavy media assets like images and videos. Images make up around [50% of an average website's traffic](https://httparchive.org/reports/page-weight#bytesImg). Many of them, however, are never shown to a user because they're placed way [below the fold](https://en.wikipedia.org/wiki/Above_the_fold).

What’s this thing about images being lazy, you ask? **Lazy-loading** is something that’s been covered [quite a bit](https://css-tricks.com/?s=lazy+load&orderby=relevance&post_type=post%2Cpage%2Cguide) here on CSS-Tricks, including a thorough [guide with documentation for different approaches using JavaScript](https://css-tricks.com/the-complete-guide-to-lazy-loading-images/). In short, we’re talking about a mechanism that defers the network traffic necessary to load content when it’s needed — or rather when trigger the load when the content enters the viewport.

The benefit? A smaller initial page that loads faster and saves network requests for items that may not be needed if the user never gets there.

If you read through other lazy-loading guides on this or other sites, you’ll see that we’ve had to resort to different tactics to make lazy-loading work. Well, that’s about to change when lazy-loading will be available natively in HTML as a new `loading` attribute… [at least in Chrome](https://css-tricks.com/a-native-lazy-load-for-the-web-platform/) which will hopefully lead to wider adoption. Chrome is currently developing and testing support for native lazy-loading and is expected to enable it in Chrome 77, which is slated to release in early September 2019.

![Eager cat loaded lazily (but still immediately because it's above the fold)](https://demo.tiny.pictures/native-lazy-loading/eager-cat.jpg?height=550&resizeType=cover&gravity=0.45%2C0.58&width=904) 

## The pre-native approach

Until now, developers like ourselves have had to use JavaScript (whether it’s a library or something written from scratch) in order to achieve lazy-loading. Most libraries work like this:

* The initial, server-side HTML response includes an `img` element without the `src` attribute so the browser does not load any data. Instead, the image's URL is set as another attribute in the element's data set, e. g. `data-src`.

```html
<img data-src="https://tiny.pictures/example1.jpg" alt="...">
```

* Then, a lazy-loading library is loaded and executed.

```html
<script src="LazyLoadingLibrary.js"></script>
<script>LazyLoadingLibrary.run()</script>
```

* That keeps track of the user's scrolling behavior and tells the browser to load the image when it is about to be scrolled into view. It does that by copying the `data-src` attribute's value to the previously empty `src` attribute.

```html
<img src="https://tiny.pictures/example1.jpg" data-src="https://tiny.pictures/example1.jpg" alt="...">
```

This has worked for a pretty long time now and gets the job done. But it’s not ideal for good reasons.

The obvious problem with this approach is the length of the **critical path** for displaying the website. It consists of three steps, which have to be carried out in sequence (after each other):

1. Load the initial HTML response
2. Load the lazy-loading library
3. Load the image file

If this technique is used for images above the fold **the website will flicker** during loading because it is first painted without the image (after step 1 or 2, depending on if the script uses `defer` or `async`) and then — after having been loaded — include the image. It will also be perceived as loading slowly.

In addition, the lazy-loading library itself puts an **extra weight** on the website's bandwidth and CPU requirements. And let’s not forget that a JavaScript approach won't work for people who have **JavaScript disabled** (although we shouldn't really care about them in 2019, [should we?](https://www.wired.com/2015/11/i-turned-off-javascript-for-a-whole-week-and-it-was-glorious/)).

Oh, and what about sites that rely on RSS to distribute content, like CSS-Tricks? The initial image-less render means there are no images in the RSS version of content as well.

And so on.

## Native lazy-loading to the rescue!

![Lazy cat loaded lazily](https://demo.tiny.pictures/native-lazy-loading/lazy-cat.jpg?height=550&resizeType=cover&gravity=0.3%2C0.5&width=904) 

As we noted at the start, Chromium and Google Chrome will ship a native lazy-loading mechanism in the form of a new `loading` attribute, starting in Chrome 75. We’ll go over the attribute and its values in just a bit, but let’s first get it working in our browsers so we can check it out together.

### Enable native lazy-loading

In Chrome versions starting from 75, we can enable lazy-loading manually by switching two flags. Chrome is expected to enable this feature by default from version 77 (release planned for September 2019).

1. Open `chrome://flags` in Chromium or Chrome Canary.
2. Search for `lazy`.
3. Enable both the "Enable lazy image loading" and the "Enable lazy frame loading" flag.
4. Restart the browser with the button in the lower right corner of the screen.

![](https://css-tricks.com/wp-content/uploads/2019/05/s_160B9CF1BF8B57931AB686E69B9B21D9BB06362CE31DD0F75344D0CE817B67F2_1557201494561_chrome-native-lazy-loading-flags.png)

Native lazy-loading flags in Google Chrome

You can check if the feature is properly enabled by opening your JavaScript console (`F12`). You should see the following warning:

> [Intervention] Images loaded lazily and replaced with placeholders. Load events are deferred."

All set? Now we get to dig into the `loading` attribute.

## The loading attribute

Both the `img` and the `iframe` elements will accept the `loading` attribute. It's important to note that its values will not be taken as a strict order by the browser but rather as a hint to help the browser make its own decision whether or not to load the image or frame lazily.

The attribute can have three values which are explained below. Next to the images, you'll find tables listing your individual resource loading timings for this page load. **Range response** refers to a kind of partial pre-flight request made to determine the image's dimensions (see [How it works](#article-header-id-7)) for details). If this column is filled, the browser made a successful range request.

Please note the **startTime** column, which states the time image loading was deferred after the DOM had been parsed. You might have to perform a hard reload (CTRL + Shift + R) to re-trigger range requests.

### The auto (or unset) value

```html
<img src="auto-cat.jpg" loading="auto" alt="...">
<img src="auto-cat.jpg" alt="...">
<iframe src="https://css-tricks.com/" loading="auto"></iframe>
<iframe src="https://css-tricks.com/"></iframe>
```

![Auto cat loaded automatically](https://demo.tiny.pictures/native-lazy-loading/auto-cat.jpg?width=452)

Auto cat loaded automatically

Setting the `loading` attribute to `auto` (or simply leaving the value blank, as in `loading=""`) lets the **browser decide** whether or not to lazy-load an image. It takes many things into consideration to make that decision, like the platform, whether Data Saver mode is enabled, network conditions, image size, image vs. iframe, the CSS `display` property, among others. (See [How it works](#article-header-id-7)) for info about why all this is important.)

### The eager value

```html
<img src="auto-cat.jpg" loading="eager" alt="...">
<iframe src="https://css-tricks.com/" loading="eager"></iframe>
```

![Eager cat loaded eagerly](https://demo.tiny.pictures/native-lazy-loading/eager-cat.jpg?width=452)

Eager cat loaded eagerly

The `eager` value provides a hint to the browser that an image **should be loaded immediately**. If loading was already deferred (e. g. because it had been set to `lazy` and was then changed to `eager` by JavaScript), the browser should start loading the image immediately.

### The lazy value

```html
<img src="auto-cat.jpg" loading="lazy" alt="...">
<iframe src="https://css-tricks.com/" loading="lazy"></iframe>
```

![Lazy cat loaded lazily](https://demo.tiny.pictures/native-lazy-loading/lazy-cat.jpg?width=452)

Lazy cat loaded lazily

The `lazy` value provides a hints to the browser that an image should be lazy-loaded. It's up to the browser to interpret what exactly this means, but the [explainer document](https://github.com/scott-little/lazyload) states that it should start loading **when the user scrolls "near" the image** such that it is probably loaded once it actually comes into view.

## How the loading attribute works

In contrast to JavaScript lazy-loading libraries, native lazy-loading uses a kind of pre-flight request to get the **first 2048 bytes of the image file**. Using these, the browser tries to determine the image's dimensions in order to insert an invisible placeholder for the full image and prevent content from jumping during loading.

The image's `load` event is fired as soon as the full image is loaded, be it after the first request (for images smaller than 2 KB) or after the second one. Please note that the load event may never be fired for certain images because the second request is never made.

> In the future, browsers might make twice as many image requests as there would be under the current proposal. First the range request, then the full request. Make sure your servers support the HTTP `Range: 0-2047` header and respond with status code `206 (Partial Content)` to prevent them from delivering the full image twice.

Due to the higher number of subsequent requests made by the same user, web server support for the HTTP/2 protocol will become more important.

Let’s talk about deferred content. Chrome's rendering engine Blink uses heuristics to determine which content should be deferred and for how long to defer it. You can find a comprehensive list of requirements in [Scott Little's design documentation](https://docs.google.com/document/d/1e8ZbVyUwgIkQMvJma3kKUDg8UUkLRRdANStqKuOIvHg/). This is a short breakdown of what will be deferred:

* Images and frames on all platforms which have `loading="lazy"` set
* Images on Chrome for Android with Data Saver enabled and that satisfy all of the following:
    * `loading="auto"` or unset
    * no `width` and `height` attributes smaller than 10px
    * not created programmatically in JavaScript
* Frames which satisfy all of the following:

* `loading="auto"` or unset
* is from a third-party (different domain or protocol than the embedding page)
* larger than 4 pixels in height and width (to prevent deferring tiny tracking frames)
* not marked as `display: none` or `visibility: hidden` (again, to prevent deferring tracking frames)
* not positioned off-screen using negative `x` or `y` coordinates

## Responsive images with srcset

Native lazy-loading also works with responsive `img` elements using the `srcset` attribute. This attribute offers a list of image file candidates to the browser. Based on the user's screen size, display pixel ratio, network conditions, etc., the browser will choose the **optimal image candidate for the occasion**. Image optimization CDNs like [tiny.pictures](https://tiny.pictures/) are able to provide all image candidates in **real-time without any back end development necessary**.

```html
<img src="https://demo.tiny.pictures/native-lazy-loading/lazy-cat.jpg" srcset="https://demo.tiny.pictures/native-lazy-loading/lazy-cat.jpg?width=400 400w, https://demo.tiny.pictures/native-lazy-loading/lazy-cat.jpg?width=800 800w" loading="lazy" alt="...">
```

## Browser support

At the time of this writing, no browser supports native-loading by default. However, Chrome will enable the feature, as we’ve covered, starting in Chrome 77. No other browser vendor has announced support so far. (Edge being a kind of exception because it will soon [make the switch to Chromium](https://css-tricks.com/edge-goes-chromium-what-does-it-mean-for-front-end-developers/).)

You can detect the feature with a few lines of JavaScript:

```javascript
if ("loading" in HTMLImageElement.prototype) {
  // Support.
} else {
  // No support. You might want to dynamically import a lazy-loading library here (see below).
}
```

See the Pen[Native lazy-loading browser support](https://codepen.io/erkstruwe/pen/OGQdJp/) by Erk Struwe ([@erkstruwe](https://codepen.io/erkstruwe)) on [CodePen](https://codepen.io).

## Automatic fallback to JavaScript solution with low-quality image placeholder

One very cool feature of most JavaScript-based lazy-loading libraries is [the low-quality image placeholder (LQIP)](https://css-tricks.com/the-complete-guide-to-lazy-loading-images/#article-header-id-9). Basically, it leverages the idea that browsers load (or perhaps I should say **used** to load) the `src` of an `img` element immediately, even if it gets later replaced by another URL. This way, it’s possible to load a tiny file size, low-quality image file on page load and later replace it with a full-sized version.

We can now use this to mimic the native lazy-loading’s 2 KB range requests in browsers that do not support this feature in order to achieve the same result, namely a placeholder with the actual image dimensions and a tiny file size.

See the Pen[Native lazy-loading with JavaScript library fallback and low-quality image placeholder](https://codepen.io/erkstruwe/pen/ROQmWa/) by Erk Struwe ([@erkstruwe](https://codepen.io/erkstruwe)) on [CodePen](https://codepen.io).

## Conclusion

I'm really excited about this feature. And frankly, I'm still wondering why it hasn't got much more attention until now, given the fact that its release is imminent and the impact on global internet traffic will be remarkable, even if only small parts of the heuristics are changed.

Think about it: After a gradual roll-out for the different Chrome platforms and with `auto` being the default setting, **the world's most popular browser will soon lazy-load below-the-fold images and frames by default.** Not only will the traffic amount of many badly-written websites drop significantly, but web servers will be hammered with tiny requests for image dimension detection.

And then there's tracking: Assuming many unsuspecting tracking pixels and frames will be prevented from being loaded, the analytics and affiliate industry will have to act. We can only hope they don't panic and add `loading="eager"` to every single image, rendering this great feature useless for their users. They should rather change their code to be recognized as tracking pixels by the heuristics described [above](#article-header-id-7).

> Web developers, analytics and operations managers should check their website's behavior with this feature and their servers' support for `Range` requests and HTTP/2 immediately.

Image optimization CDNs could help out in case there are any issues to be expected or if you’d like to take image delivery optimization to the max (including automatic WebP support, low-quality image placeholders, and much more). Read more about [tiny.pictures](https://tiny.pictures)!

## References

* [Blink LazyLoad design documentation](https://docs.google.com/document/d/1e8ZbVyUwgIkQMvJma3kKUDg8UUkLRRdANStqKuOIvHg/)
* [Blink LazyImages design documentation](https://docs.google.com/document/d/1jF1eSOhqTEt0L1WBCccGwH9chxLd9d1Ez0zo11obj14)
* [Blink LazyFrames design documentation](https://docs.google.com/document/d/1ITh7UqhmfirprVtjEtpfhga5Qyfoh78UkRmW8r3CntM)
* [Blink ImageReplacement design documentation](https://docs.google.com/document/d/1691W7yFDI1FJv69N2MEtaSzpnqO2EqkgGD3T0O-pQ08/edit#heading=h.mexcvf6leeqf)
* [Public Chromium tracking bug](https://bugs.chromium.org/p/chromium/issues/detail?id=954323)
* [Feature Policy proposal for disabling the feature page-wide](https://github.com/w3c/webappsec-feature-policy/issues/193)
* [Addy Osmani's blog post announcing native lazy-loading](https://addyosmani.com/blog/lazy-loading/)
* [Chrome Platform Status feature page](https://chromestatus.com/feature/5645767347798016)
* [Lazy-load explainer by Scott Little](https://github.com/scott-little/lazyload)
* [HTML specs pull request](https://github.com/whatwg/html/pull/3752)
* [Chrome platform status and release timeline](https://www.chromestatus.com/features/schedule)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
