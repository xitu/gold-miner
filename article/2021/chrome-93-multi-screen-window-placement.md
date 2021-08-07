> * 原文地址：[Chrome 93: Multi-Screen Window Placement, PWAs as URL Handlers, and More](https://blog.chromium.org/2021/07/chrome-93-multi-screen-window-placement.html)
> * 原文作者：[Chromium dev team](https://blog.chromium.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/chrome-93-multi-screen-window-placement.md](https://github.com/xitu/gold-miner/blob/master/article/2021/chrome-93-multi-screen-window-placement.md)
> * 译者：
> * 校对者：

# Chrome 93: Multi-Screen Window Placement, PWAs as URL Handlers, and More

Unless otherwise noted, changes described below apply to the newest Chrome beta channel release for Android, Android WebView, Chrome OS, Linux, macOS, and Windows. Learn more about the features listed here through the provided links or from the list on [ChromeStatus.com](https://www.chromestatus.com/features#milestone%3D76). Chrome 93 is beta as of July 29, 2021.

### Origin Trials

This version of Chrome introduces the origin trials described below. Origin trials allow you to try new features and give feedback on usability, practicality, and effectiveness to the web standards community. To register for any of the origin trials currently supported in Chrome, including the ones described below, visit the [Chrome Origin Trials dashboard](https://developers.chrome.com/origintrials/#/trials/active). To learn more about origin trials in Chrome, visit the [Origin Trials Guide for Web Developers](https://web.dev/origin-trials/). Microsoft Edge runs its own origin trials separate from Chrome. To learn more, see the [Microsoft Edge Origin Trials Developer Console](https://developer.microsoft.com/en-us/microsoft-edge/origin-trials/).

## New Origin Trials

### Cross-Origin-Embedder-Policy: credentialless

Cross-origin no-CORS requests [can now be made to omit credentials](https://developer.chrome.com/origintrials/#/view_trial/3036552048754556929) (cookies, client certificates, etc.) using the `credentialless` keyword. Similarly to `COEP: require-corp`, it can enable cross-origin isolation.

Sites that wish to continue using `SharedArrayBuffer` must opt-in to cross-origin isolation. Today, `COEP: require-corp` exists, and is used to enable cross-origin isolation. It is functional and solid, but turns out to be difficult to deploy at scale, as it requires all subresources to explicitly opt-in. This is fine for some sites, but creates dependency problems for sites that gather content from users (Google Earth, social media generally, forums, etc.).

### Multi-Screen Window Placement

The [Multi-Screen Window Placement API](https://web.dev/multi-screen-window-placement/) allows you to place windows on any display connected to your machine, store that placement, and make a window full-screen on any display. With this API, a presentation app can show slides on one screen and speaker notes on another. An art or music creation app can place palettes on a second screen. And a restaurant can show a touchscreen menu on a kiosk and a separate window for employees. Incorporating developer feedback from the first origin trial, the API enters a second origin trial with an improved shape and ergonomics.

### Window Controls Overlay for Installed Desktop Web Apps

Window controls overlay extends an app's client area to cover the entire window, including the title bar, and the window control buttons (close, maximize/restore, minimize). The web app developer is responsible for drawing and input-handling for the entire window except for the window controls overlay. Developers can use this feature to make their installed desktop web apps look like O.S. apps. For more information, see [Customize the window controls overlay of your PWA's title bar](https://web.dev/window-controls-overlay/).

### PWAs as URL Handlers

[PWA as URL Handlers](https://web.dev/pwa-url-handler/) allows apps like `music.example.com` to register themselves as URL handlers for URLs that match patterns like `https://music.example.com`, `https://*.music.example.com`, or `https://🎵.example.com`, so that links from outside of the PWA, for example, from an instant messenger application or an email client, open in the installed PWA rather than in a browser tab.

## Completed Origin Trials

The following features, previously in a Chrome origin trial, are now enabled by default.

### Subresource loading with Web Bundles

[Web Bundles](https://www.chromestatus.com/feature/5710618575241216) provides a new approach to load a large number of resources efficiently using a format that allows multiple resources to be bundled. This feature addresses issues with previous approaches to resource bundling.

The output of some JavaScript bundlers does not interact well with the HTTP cache and configuring them can sometimes be difficult. Even with bundled JavaScript, execution needs to wait for all bytes to download. Ideally loading multiple subresources should use streaming and parallelization, which is not possible with one JavaScript file. For JavaScript modules, execution still needs to wait for an entire resource tree to download because of deterministic execution.

### WebXR Plane Detection API

WebXR applications can now [retrieve data about planes present in a user's environment](https://www.chromestatus.com/feature/5732397976911872), which enables augmented reality applications to create more immersive experiences. Without this feature, developers would have to resort to running their own computer vision algorithms on data from `getUserMedia()` (available on `navigator` and `MediaDevices`) in order to detect planes present in the users' environment. Such solutions have thus far been unable to match the quality and accuracy of native augmented reality capabilities or support world scale.

## Other features in this release

### AbortSignal.abort() Static Method

[`AbortSignal.abort()` is a static method](https://www.chromestatus.com/feature/5642501387976704) that allows creating a new `AbortSignal` object that is already aborted. It is similar in spirit to `Promise.reject()`, and provides improved developer ergonomics.

Web developers have found aborted `AbortSignal` objects to be useful for a variety of purposes. They signify to JavaScript APIs that no work should be done. Currently, creating an already-aborted `AbortSignal` object requires multiple lines of code. `AbortSignal.abort()` requires one:

`return AbortSignal.abort();`

### CSS Flexbox: Support Alignment Keywords start, end, self-start, self-end, left, right

The flexbox and flex items [now obey](https://www.chromestatus.com/feature/5777880099323904) [positional alignment keywords](https://drafts.csswg.org/css-align-3/#positional-values). Flexbox previously only obeyed `center`, `flex-start`, and `flex-end`. The additional alignment keywords (`start`, `end`, `self-start`, `self-end`, `left`, `right`) allow authors to more easily align the flex items in the face of varying writing modes and flex flows.

Without these additional keywords, developers need to change the keyword values whenever they change the writing mode, text direction, or flex reversal properties (`flex-direction: row-reverse`, `flex-direction:column-reverse` or `align-content: wrap-reverse`). The keywords implemented here let them set alignment once.

### Error.cause Property

The `Error()` constructor supports [a new options property called cause](https://www.chromestatus.com/feature/5727099325251584), which will be assigned to the error as a property. This allows errors to be chained without unnecessary and overelaborate formalities on wrapping the errors in conditions.

### Honor Media HTML Attribute for meta name=theme-color

[The meta element's "media" attribute will be honored](https://www.chromestatus.com/feature/5764461413531648) for `meta[name="theme-color"]` so that web developers can adjust the [theme color](https://web.dev/add-manifest/#theme-color) of their site based on a media query (dark and light modes for instance). The first one that matches will be picked.

### noplaybackrate in HTMLMediaElement.controlsList

The [HTMLMediaElement.controlsList property now supports `noplaybackrate`](https://www.chromestatus.com/feature/5092414224072704), which allows websites to enabled or disable the playback speed control exposed by the browser. With browser vendors adding playback speed control to their media controls, developers should have a way to control the visibility of this new control. Try the new property on the [`noplaybackrate` in `HTMLMediaElement.controlsList` Sample](https://googlechrome.github.io/samples/media/controlslist-noplaybackrate.html).

### Sec-CH-Prefers-Color-Scheme Client Hint Header

The CSS user preference media feature [`prefers-color-scheme`](https://web.dev/prefers-color-scheme/) has a potentially significant impact on the amount of CSS that needs to be delivered by a page and on the experience the user is going to have when the page loads. The new [`Sec-CH-Prefers-Color-Scheme`](https://github.com/WICG/user-preference-media-features-headers#demo-of-sec-ch-prefers-color-scheme) client hint header allows sites to obtain the user's preference optionally at request time, allowing servers to inline the right CSS and therefore avoid a flash of incorrect color theme.

### User-Agent Client Hints API Updates

This version of Chrome adds [four new features and changes](https://www.chromestatus.com/feature/5733498725859328) to the User-Agent client hints API.

- **Sec-CH-UA-Bitness:** a request header that gives a server information about the bitness of the architecture of the platform on which a given user agent is executing. Bitness is the number of bits comprising the basic value a particular system can evaluate.
- **Make Sec-CH-UA-Platform a low-entropy hint: **`Sec-CH-UA-Platform` is a request header that gives a server information about the platform on which a given user agent is executing.
- **Adds low-entropy hints to UADataValues.getHighEntropyValues():** If a hint moves from high to low-entropy, this future proofs any code relying on it.
- **Improves** **NavigatorUAData.toJSON() method:** This method now returns useful data.

Low-entropy hints are those that don't give away too much information, or give information that would be too easy to discover in other ways to realistically hide. In the context of client hints, this means that these hints are available in every request, whether or not the origin involved requested it or whether the frame involved is a first or third party context.

### WebOTP API: Cross-Device Support

[The WebOTP API will now be supported on desktop](https://developer.chrome.com/blog/cross-device-webotp/) when both Chrome on Desktop and Android Chrome are logged in using the same Google account. The WebOPT API provides the ability to programmatically read a one-time code from specially-formatted SMS messages addressed to their origin, reducing user friction during sign-on. Previously, this was only available on mobile devices where SMS was supported.

[![](https://1.bp.blogspot.com/-iVMXuQ7BS-U/YQQEj7I-rgI/AAAAAAAABow/OchREkcfsMku8AexLegD2UEmZamTABL7gCLcBGAsYHQ/w640-h420/x-device-webotp.gif)](https://1.bp.blogspot.com/-iVMXuQ7BS-U/YQQEj7I-rgI/AAAAAAAABow/OchREkcfsMku8AexLegD2UEmZamTABL7gCLcBGAsYHQ/s800/x-device-webotp.gif)

## JavaScript

This version of Chrome incorporates version 9.3 of the V8 JavaScript engine. It specifically includes the changes listed below. You can find a complete [list of recent features](https://v8.dev/blog) in the V8 release notes.

### Object.hasOwn

[`Object.hasOwn`](https://www.chromestatus.com/feature/5662263404920832), a new boolean property, provides an easier-to-use, static method version of `Object.prototype.hasOwnProperty`.

## Deprecations, and Removals

This version of Chrome introduces the deprecations and removals listed below. Visit ChromeStatus.com for lists of [current deprecations](https://www.chromestatus.com/features#browsers.chrome.status%3A%22Deprecated%22) and [previous removals](https://www.chromestatus.com/features#browsers.chrome.status:%22Removed%22).

### Block ports 989 and 990

[Connections to HTTP, HTTPS or FTP servers on ports 989 and 990 now fail.](https://www.chromestatus.com/feature/5678858554572800) These ports are used by the FTPS protocol, which has never been implemented in Chrome. However, FTPS servers can be attacked in a cross-protocol attack by malicious web pages using carefully-crafted HTTPS requests. This is a mitigation for [the ALPACA attack](https://alpaca-attack.com/).

### Remove 3DES in TLS

Chrome has [now removed support for the TLS_RSA_WITH_3DES_EDE_CBC_SHA](https://www.chromestatus.com/feature/6678134168485888) cipher suite. TLS_RSA_WITH_3DES_EDE_CBC_SHA is a remnant of the SSL 2.0 and SSL 3.0 era. 3DES in transport layer security (TLS) is vulnerable to the [Sweet32 attack](https://sweet32.info/). Being a CBC cipher suite, it is also vulnerable to the [Lucky Thirteen](https://en.wikipedia.org/wiki/Lucky_Thirteen_attack) attack. The first replacement AES cipher suites were defined for TLS in RFC3268, published around 19 years ago, and there have been several iterations since.

### WebAssembly Cross-Origin Module Sharing

WebAssembly module sharing between cross-origin but same-site environments [will be deprecated](https://chromestatus.com/feature/5650158039597056) to allow agent clusters to be scoped to origins long term. This follows a WebAssembly specification change, which has an impact on the platform as well.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
