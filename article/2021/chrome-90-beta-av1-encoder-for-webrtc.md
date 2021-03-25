> * 原文地址：[Chrome 90 Beta: AV1 Encoder for WebRTC, New Origin Trials, and More](https://blog.chromium.org/2021/03/chrome-90-beta-av1-encoder-for-webrtc.html)
> * 原文作者：[Chromium Dev](https://blog.chromium.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/chrome-90-beta-av1-encoder-for-webrtc.md](https://github.com/xitu/gold-miner/blob/master/article/2021/chrome-90-beta-av1-encoder-for-webrtc.md)
> * 译者：
> * 校对者：

# Chrome 90 Beta: AV1 Encoder for WebRTC, New Origin Trials, and More

Unless otherwise noted, changes described below apply to the newest Chrome beta channel release for Android, Chrome OS, Linux, macOS, and Windows. Learn more about the features listed here through the provided links or from the list on [ChromeStatus.com](https://www.chromestatus.com/features#milestone%3D90). Chrome 90 is beta as of March 11, 2021.

## AV1 Encoder

An [AV1 encoder](https://www.chromestatus.com/feature/6206321818861568) is shipping in Chrome desktop that is specifically optimized for video conferencing with WebRTC integration. The benefits of AV1 include:

* Better compression efficiency than other types of video encoding, reducing bandwidth consumption and improve visual quality
* Enabling video for users on very low bandwidth networks (offering video at 30kbps and lower)
* Significant screen sharing efficiency improvements over VP9 and other codecs.

This is an important addition to WebRTC especially since it recently became an [official W3C and IETF standard](https://web.dev/webrtc-standard-announcement/).

## Origin Trials

This version of Chrome introduces the origin trials described below. Origin trials allow you to try new features and give feedback on usability, practicality, and effectiveness to the web standards community. To register for any of the origin trials currently supported in Chrome, including the ones described below, visit the [Chrome Origin Trials dashboard](https://developer.chrome.com/origintrials/#/trials/active). To learn more about origin trials in Chrome, visit the [Origin Trials Guide for Web Developers](https://web.dev/origin-trials/). Microsoft Edge runs its own origin trials separate from Chrome. To learn more, see the [Microsoft Edge Origin Trials Developer Console](https://developer.microsoft.com/en-us/microsoft-edge/origin-trials/).

### New Origin Trials

#### getCurrentBrowsingContextMedia()

The [mediaDevices.getCurrentBrowsingContextMedia() method](https://developer.chrome.com/origintrials/#/view_trial/3654671097611157505) allows capturing a MediaStream with the current tab's video (and potentially audio), similar to getDisplayMedia(). Unlike getDisplayMedia(), calling this new method will eventually present the user with a simple accept/reject dialog box. If the user accepts, the current tab is captured. However, this will require some additional security measures which are still being finalized. Until then, or if the call is made with these measures absent, a dialog is displayed to the user that allows the selection of any source, but highlights the option of the current tab (whereas normally getDisplayMedia highlights the option of entire-screen).

#### MediaStreamTrack Insertable Streams (a.k.a. Breakout Box)

An API for [manipulating raw media carried by MediaStreamTracks](https://www.chromestatus.com/feature/5499415634640896) such as the output of a camera, microphone, screen capture, or the decoder part of a codec and the input to the decoder part of a codec. It uses WebCodecs interfaces to represent raw media frames and exposes them using streams, similar to the way the WebRTC Insertable Streams API exposes encoded data from RTCPeerConnections. This is intended to support use cases such as:

* [Funny Hats](https://www.w3.org/TR/webrtc-nv-use-cases/#funnyhats*): Refers to manipulation of media either before encoding and after decoding to provide effects such as background removal, funny hats, voice effects.
* [Machine Learning](https://www.w3.org/TR/webrtc-nv-use-cases/#machinelearning*): Refers to applications such as real-time object identification/annotation.

This origin trial is expected to run through Chrome 92.

#### Subresource Loading with Web Bundles

[Subresource loading with Web Bundles](https://developer.chrome.com/origintrials/#/view_trial/-6307291278132379647) provides a new approach to loading a large number of resources efficiently using a format that allows multiple resources to be bundled., e.g. Web Bundles.

The output of JavaScript bundlers (e.g. webpack) doesn't interact well with browsers. They are good tools but:

* Their output can't interact with the HTTP cache at any finer grain than the bundle itself (not solved with this origin trial). This can make them incompatible with new requirements like dynamic bundling (e.g. small edit with tree shaking could invalidate everything).
* They force compilation and execution to wait until all bytes have arrived. Ideally loading multiple subresources should be able to utilize full streaming and parallelization, but that's not possible if all resources are bundled as one javascript. (This origin trial allows compilation to proceed in parallel. For JavaScript modules, execution still needs to wait for the entire tree due to the current deterministic execution model).
* They can require non-JS resources like stylesheets and images to be encoded as JS strings, which forces them to be parsed twice and can increase their size. This origin trial allows those resources to be loaded in their original form.

This origin trial also allows a bundle to include the source for an opaque-origin iframe as `urn:uuid:` resources. The scheme for these resources is expected to change in Chrome 91.

This origin trial is expected to run through Chrome 92.

#### WebAssembly Exception Handling

WebAssembly [now provides exception handling](https://developer.chrome.com/origintrials/#/view_trial/2393663201947418625) support. Exception handling allows code to break control flow when an exception is thrown. The exception can be any that is known by the WebAssembly module, or it may be an unknown exception that was thrown by a called imported function. This origin trial is expected to run through Chrome 94.

## Completed Origin Trials

The following features, previously in a Chrome origin trial, are now enabled by default.

#### WebXR AR Lighting Estimation

[Lighting estimation](https://www.chromestatus.com/feature/5704707957850112) allows sites to query for estimates of the environmental lighting conditions within WebXR sessions. This exposes both spherical harmonics representing the ambient lighting, as well as a cubemap texture representing "reflections". Adding Lighting Estimation can make your models feel more natural and like they "fit" better with the user's environment.

## Other Features in this Release

### CSS

#### aspect-ratio Interpolation

The [`aspect-ratio` property](https://www.chromestatus.com/feature/5682100885782528) allows for automatically computing the other dimension if only one of width or height is specified on any element. This property was originally launched as non-interpolable (meaning that it would snap to the target value) when animated. This feature provides smooth interpolation from one aspect ratio to another.

#### Custom State Pseudo Classes

Custom elements [now expose their states](https://www.chromestatus.com/feature/6537562418053120) via the state CSS pseudo class. Built-in elements have states that can change over time depending on user interaction and other factors, which are exposed to web authors through pseudo classes. For example, some form controls have the "invalid" state, which is exposed through the :invalid pseudo class. Since custom elements also have states it makes sense to expose their states in a manner similar to built-in elements.

#### Implement 'auto' value for appearance and -webkit-appearance

The default values of CSS property `appearance` and `-webkit-appearance` for the following form controls are changed to `'auto'`.

* `<input type=color>` and `<select>`
* Android only: `<input type=date>`, `<input type=datetime-local>`, `<input type=month>`, `<input type=time>`, and `<input type=week>`

Note that the default rendering of these controls are not changed.

#### overflow: clip Property

The [`clip` value for `overflow`](https://www.chromestatus.com/feature/5638444178997248) results in a box's content being clipped to the box's overflow clip edge. In addition, no scrolling interface is provided, and the content cannot be scrolled by the user or programmatically. Additionally the box is not considered a scroll container, and does not start a new formatting context. As a result, this value has better performance than `overflow: hidden`.

#### overflow-clip-margin Property

The [`overflow-clip-margin` property](https://www.chromestatus.com/feature/5638444178997248) enables specifying how far outside the bounds an element is allowed to paint before being clipped. It also allows the developer to expand the clip border. This is particularly useful for cases where there is ink overflow that should be visible.

### Permissions-Policy Header

The `Permissions-Policy` HTTP header [replaces the existing `Feature-Policy` header](https://www.chromestatus.com/feature/5745992911552512) for controlling delegation of permissions and powerful features. The header allows sites to more tightly restrict which origins can be granted access to features.

The [Feature Policy API](https://developers.google.com/web/updates/2018/06/feature-policy#js), introduced in Chrome 74, was recently renamed to "Permissions Policy", and the HTTP header has been renamed along with it. At the same time, the community has settled on a new syntax, based on [structured field values for HTTP](https://httpwg.org/http-extensions/draft-ietf-httpbis-header-structure.html).

### Protect application/x-protobuffer via Cross-Origin-Read-Blocking

[Protect `application/x-protobuffer` from speculative execution](https://www.chromestatus.com/feature/5670287242690560) attacks by adding it to the list of never sniffed MIME types used by `Cross-Origin-Read-Blocking`. `application/x-protobuf` is already protected as a never sniffed mime type. `application/x-protobuffer` is another commonly used MIME type that is defined as an `"ALT_CONTENT_TYPE"` by the protobuf library.

### Seeking Past the End of a File in the File System Access API

When data is passed to `FileSystemWritableFileStream.write()` that would extend past the end of the file, [the file is now extended by writing `0x00` (`NUL`)](https://www.chromestatus.com/feature/6556060494069760). This enables creating sparse files and greatly simplifies saving content to a file when the data to be written is received out of order.  
Without this functionality, applications that receive file contents out of order (for example, BiTtorrent downloads) would have to manually resize the file either ahead of time or when needed during writing.

### StaticRange Constructor

Currently, [`Range`](https://developer.mozilla.org/en-US/docs/Web/API/Range) is the only constructible range type available to web authors. However, `Range` objects are "live" and maintaining them can be expensive. For every tree change, all affected `Range` objects need to be updated. [The new `StaticRange` objects](https://www.chromestatus.com/feature/5676695065460736) are not live and represent a lightweight range type that is not subject to the same maintenance cost as `Range`. Making `StaticRange` constructible allows web authors to use them for ranges that do not need to be updated on every DOM tree change.

### Support Specifying Width and Height on <source> Elements for <picture>

The `<source>` element [now supports `width` and `height` properties](https://www.chromestatus.com/feature/5737185317748736) when used inside a `<picture>` element. This allows Chrome to compute an aspect ratio for `<picture>` elements. This matches similar behavior for `<img>`, `<canvas>` and `<video>` elements.

### WebAudio: OscillatorOptions.periodicWave is Not Nullable

It is [no longer possible to set periodicWave to null](https://www.chromestatus.com/feature/5086267630944256) when creating a new `OscillatorNode` object. This value is set on the options object passed to the `OscillatorNode()` constructor. The WebAudio spec doesn't allow setting this value to null. Chrome now matches both the spec and Firefox.

## JavaScript

This version of Chrome incorporates version 9.0 of the V8 JavaScript engine. It specifically includes the changes listed below. You can find a complete [list of recent features](https://v8.dev/blog) in the V8 release notes.

### Relative Indexing Method for Array, String, and TypedArrays

Array, String, and TypedArray [now support the `at()` method](https://www.chromestatus.com/feature/6123640410079232), which supports relative indexing with negative numbers. For example, the code below returns the last item in the given array.

```js
let arr = [1, 2, 3, 4];
arr.at(-1);
```

## Deprecations, and Removals

This version of Chrome introduces the deprecations and removals listed below. Visit ChromeStatus.com for lists of [current deprecations](https://www.chromestatus.com/features#browsers.chrome.status%3A%22Deprecated%22) and [previous removals](https://www.chromestatus.com/features#browsers.chrome.status:%22Removed%22).

### Remove Content Security Policy Directive 'plugin-types'

The ['plugin-types' directive allows developers to restrict](https://www.chromestatus.com/feature/5742693948850176) which types of plugin can be loaded via `<embed>` or `<object>` html elements. This allowed developers to block Flash in their pages. Since Flash support has been discontinued, there is no longer any need for this policy directive.

### Remove WebRTC RTP Data Channels

Chrome has [removed support for the non-standard RTP data channels](https://www.chromestatus.com/feature/6485681910054912) in WebRTC. Users should use the standard SCTP-based data channels instead.

### Return Empty for navigator.plugins and navigator.mimeTypes

Chrome [now returns empty for `navigator.plugins` and `navigator.mimeTypes`](https://www.chromestatus.com/feature/5741884322349056). With the removal of Flash, there is no longer the need to return anything for these properties.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
