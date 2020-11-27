> * 原文地址：[Top Image Lazy Loading Libraries for JavaScript](https://blog.bitsrc.io/top-image-lazy-loading-libraries-for-javascript-dc39fbc9511f)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/top-image-lazy-loading-libraries-for-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/top-image-lazy-loading-libraries-for-javascript.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[rocwong-cn](https://github.com/rocwong-cn)、[JohnieXu](https://github.com/JohnieXu)

# 分享九个 JavaScript 图片懒加载库

![Photo by [Annie Spratt](https://unsplash.com/@anniespratt?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/6000/0*IeWD36cpByaa0F2d)

## 为什么要图片懒加载

在 web 应用程序中性能至关重要。你可以拥有世界上最漂亮、最吸引人的网站，但如果它不能在浏览器上快速加载，人们会倾向于略过它。要想使你的网站表现得非常好，可能相当棘手。这是因为 web 开发中存在许多瓶颈，例如耗费性能的 JavaScript、解析缓慢的 web 字体显示、 尺寸过大的图片资源等等。

本文我们主要关注图片资源对网站的影响。根据 [Jecelyn](https://twitter.com/jecelynyeen) 研究，一个网页仅用于加载图片平均就要消耗 5MB 的流量。这对用户来说可能是一个沉重的负担，因为某些国家的移动流量非常昂贵。用户也会遇到站点加载时间过久的问题，尤其是在网速较慢的情况下。这些都会对你的网站产生负面影响。

根据 [Jakob Nielson](https://www.nngroup.com/articles/website-response-times/) 研究，以下是一些你应该记住的重要统计数据：

* 网站加载时间低于 100 毫秒被认为是瞬时的。
* 100 到 300 毫秒之间的延迟是可以感知到的。
* 47% 的用户希望网页在两秒钟或更短的时间内加载完成。
* 40% 的用户在放弃网站之前，将等待不超过 3 秒加载时间。

## 什么是懒加载

有几种策略可以为网站的图片资源提供高效服务，而不会影响性能和质量，懒加载就是其中之一。懒加载是指只加载所需的内容，并将其余内容延迟到需要的时候。这个策略可以应用于图片、视频、文本和其他类型的数据。但大多数情况下，它适用于图片资源等大体积的内容。

有好几种方法可以在网站上实现图片懒加载。例如可以使用 `Intersection Observer API`，或者使用事件处理程序来确定元素是否在视图中。还有几个功能强大的 JavaScript 库，可以根据需要和兼容性使用以下几种图片懒加载库的方法。让我们来看看吧！

## Lazy Sizes

[Lazy Sizes](https://github.com/aFarkas/lazysizes) 是目前最好的懒加载库之一，在 Github 上拥有超过 14.1K 收藏，把它压缩后只有 [3.4kB](https://bundlephobia.com/result?p=lazysizes@5.2.2)。该库的浏览器端支持率达到了 98.5%，同时它的文档也写的通俗易懂。

#### 特点

* 包含对响应式图片的支持。
* 通过在用户代理的帮助下检测搜索引擎并立即加载所有图像，从而优化 SEO。
* 基于高效实用的代码。
* 当网络连接空闲时预先加载资源。
* 包含对 LQIPs 的支持。
* 支持 `IntersectionObserver`、`MutationObserver` 和 `getElementsByClassName` 等。
* 支持使用插件来扩展特性。
* 支持自动计算响应图片大小。

你可以在[这里](http://afarkas.github.io/lazysizes/#examples)查看示例。

![LazySizes 仓库截图](https://cdn-images-1.medium.com/max/2682/1*Ifefl4QqsSO-zNmfCiPJPg.png)

## Lozad.js

[Lozad.js](https://github.com/ApoorvSaxena/lozad.js) 支持图片、`iframe`、广告、视频和其他元素的懒加载。它在 Github 上拥有近 6.4K 的 star，在社区里非常受欢迎。据研究小组称，这个库被特斯拉、多米诺、小米和 BBC 等几个品牌的网络应用程序所使用。它非常小巧，压缩后只有 [1.1kB](https://bundlephobia.com/result?p=lozad@1.16.0)。由于它使用 `IntersectionObserver` API 和 `MutationObserver` API，所以它的浏览器支持率只有 92% 左右。

#### 特点

* 不存在依赖关系。
* 支持动态添加元素的懒加载。
* 完全使用 JavaScript。
* 包含对 LQIPs 和响应图片的支持。
* 比使用 `getBoundingClientRect()` 的库更高效。
* Polyfills 可以在不受支持的浏览器上使用。

你可以在[这里](https://apoorv.pro/lozad.js/demo/)查看示例。

![Lozad.js 仓库截图](https://cdn-images-1.medium.com/max/2690/1*qFRDVwpjSbhaoT7b-cIhbA.png)

## Tuupola 的 Lazyload

[Lazyload by Tuupola](https://github.com/tuupola/lazyload) 是 Github 上另一个流行的图片懒加载库，有近 8.4K 的 star。它使用了 `IntersectionObserver` API，并且简单易用。压缩后仅有 [956 bytes](https://bundlephobia.com/result?p=lazyload@2.0.0-rc.2)，比其他的库都小。这可以归功于它只使用了 `IntersectionObserver` API，因为其他库使用了别的组合来实现更好的兼容性和性能。此外，由于这一点，目前其浏览器支持率占比为 92%。

#### 特点

* 为了方便起见，它包含了一个 jQuery 包装器。
* 包括对 LQIPs 和响应图片的支持。
* 可以通过传递其他参数来配置核心 `IntersectionObserver` API。

## Andrea Verlicchi 的 Vanilla Lazyload

[Vanilla lazy load](https://github.com/verlok/vanilla-lazyload) 是另一个用于延迟加载图片、视频和 iframe 的纯粹 JavaScript 库。它在 Github 上非常受欢迎，有将近 1500 个存储库和包可供使用。它在 NPM 中每年有超过 190 万次的下载。把它压缩后仅有 [2.7kB](https://bundlephobia.com/result?p=vanilla-lazyload@17.1.2)。与其他库类似，该库使用 `IntersectionObserver` API，目前其浏览器支持率为 92%。

* 搜索引擎优化友好，因为库不从搜索引擎覆盖图片。
* 支持不稳定的网络连接，因为库会在连接中断后自动重新加载图片。
* 如果图片退出视口，则取消加载图片。
* 包含对 LQIPs 和响应图片的支持。
* 完全使用 JavaScript。

![](https://cdn-images-1.medium.com/max/2682/1*tPp7c2D1JBJZ6Vj7Fb3xBA.png)

你可以在[这里](https://github.com/verlok/vanilla-lazyload/tree/master/demos)查看示例。

## Yall.js

[Yall.js](https://github.com/malchata/yall.js) 是另外一个 JavaScript 库，也只使用 `IntersectionObserver` API 来延迟加载图片、视频、`iframe` 和 CSS 背景图片。这个库大约有 1.1K 的 star，并且有 91 个用户在其项目库中使用。这个库可以压缩到 [1kB](https://bundlephobia.com/result?p=yall-js@3.2.0)。正如我们在以前的库中所见，因为使用了 `IntersectionObserver` API，Yall.js 的浏览器支持率有 92%。必须注意，如果浏览器不支持 `IntersectionObserver` API，则不会有备份。在那种情况下你必须用 `polyfill` 。

#### 特点

* 借助 `MutationObserver` API 支持动态加载元素的检测。
* 借助 `requestIdleCallback` 方法优化浏览器空闲时间。
* 支持通过 `src` 属性直接实现 LQIP。
* 支持延迟加载 CSS 背景图。

## Layzr.js

[Layzr.js](https://github.com/callmecavs/layzr.js) 是一个基于 JavaScript 的轻量级图片懒加载库。它主要使用 `Element.classList`，很少有 ES5 数组方法和 `requestAnimationFrame` 方法。由于这些 API，97% 以上的浏览器用户都支持该库。Layzr.js 在 Github 上拥有超过 5.6K 收藏，非常受欢迎，把它压缩后只有 [1kB](https://bundlephobia.com/result?p=layzr.js@2.2.2)。

* 不依赖于任何其他库。
* 基于浏览器兼容性和可用性智能选择图片源。
* 支持动态添加的元素。
* 清晰简洁的文档和示例。
* 具有**阈值**属性的视口调整图片懒加载，可以根据需要提前或稍后加载图片。

你可以在[这里](http://callmecavs.com/layzr.js/)查看示例。

![Layzr.js Demo — Screenshot by Author](https://cdn-images-1.medium.com/max/2654/1*nHQAXoOiLy5CGfsE5pdT8g.png)

## Blazy.js

[Blazy.js](https://github.com/dinbror/blazy) 是另一个轻量级的 JavaScript 懒加载库，能够处理图片、视频和 `iframe`。它在 Github 上非常流行，有 2.6K 的 star，目前有超过 860 个开源项目库在使用。它压缩后只有 [1.9kB](https://bundlephobia.com/result?p=blazy@1.8.2)。

使用 `Element.getBoundingClientRect()` 方法，与实现 `IntersectionObserver` API 的其他库相比，该方法可能无法执行。但是由于这种方法，这个库有超过 98% 的浏览器用户支持。它还使用 `Element.closest()`。这个 API 的浏览器支持率仅超过 94%。在这种情况下，您不必担心遗漏的 6%，因为库包含一个用于不支持浏览器的 `polyfill`。

#### 特点

* 用于每月访问量达数百万的实际网站。
* 不存在依赖关系。
* 支持响应图片。
* 类似 Layzr.js 允许加载具有偏移量的元素。
* 带有示例代码的清晰[文档](http://dinbror.dk/blog/blazy/)。
* 支持 AMD、CommonJS 和 globals 等模块格式。
* 非常容易提供视网膜图片。

你可以在[这里](http://dinbror.dk/blazy/?ref=github)查看示例。

![Blazy.js Demo — Screenshot by Author](https://cdn-images-1.medium.com/max/2650/1*mJsrNbt7H3GpZDTEog4b_g.png)

## Responsively Lazy

[Responsively lazy](https://github.com/ivopetkov/responsively-lazy) 也是用于图片的懒加载库。它的内容简洁，压缩后只有 1.1kB。由于它良好的语法实现，让其从众多库中脱颖而出。上面我们讨论过的大多数库都要求您对禁用 javascript 的浏览器使用 `noscript` 标记，忽略 `src` 属性等。但是 lazy 可以使用传统的 `src` 属性，并为受支持的浏览器添加 `srcset` 和 `data-src` 属性。这使得这个库对搜索引擎优化（SEO）友好。这个库也使用 `Element.getBoundingClientRect()` 因此，因此强制布局重排也将出现在该库中。

此外，这个库在 Github 上有近 1.1K 的 star，几乎 95% 的浏览器用户都支持这个库。

#### 特点

* 支持响应式图片。
* 支持 webp 格式图片。
* 对搜索引擎优化（SEO）友好。
* 可用的自定义项不多。

你可以在[这里](http://ivopetkov.github.io/responsivelyLazy/)查看示例。

![Responsively lazy demo 截图](https://cdn-images-1.medium.com/max/2000/1*Z3WoOAwwTdEsGJhPcEzQ0Q.png)

## LazyestLoad.js

[LazyestLoad.js](https://github.com/Paul-Browne/lazyestload.js) 是此列表中最小的库之一。它只有 700 字节，压缩后仅仅 639 字节。这个库有两个版本，`lazyload` 和 `lazyestload`。它们都有不同的用法，`lazyload` 版本的工作方式与普通库类似，图片将在其即将进入视口时加载；但是 `lazyestload` 版本只在用户停止滚动且图片在视口中或在 100 像素以内时，才会加载图片。这有助于减少网络负荷，如果用户只是滚动而不暂停看图片。

它主要使用 `Element.getBoundingClientRect()` 方法，与其他实现相比效率不高，还有众所周知的[触发布局重排](https://gist.github.com/paulirish/5d52fb081b3570c81e3a)。

这个库只处理图片，不像其他库可以处理视频和 `iframe` 的库。它在 Github 上还有超过 1.5K 的 star。

#### 特点

* 简单直截了当。
* 不允许像其他库一样进行大量自定义。
* 支持响应式图片。
* 文档不够详细。

你可以查看 [lazyload 示例](https://rawgit.com/Paul-Browne/lazyestload.js/master/dist/lazyload.html)和查看 [lazyestload 示例](https://rawgit.com/Paul-Browne/lazyestload.js/master/dist/lazyestload.html)。

---

随着大多数现代浏览器都将支持原生的懒加载，因此建议使用原生实现。原生懒加载还可以确保即使在浏览器中禁用 JavaScript，图片也可以延迟加载。只需在 `img` 标记中使用 `loading="lazy"` 属性，就可以省去所有麻烦。

大多数现代浏览器都支持原生懒加载，并且也即将支持 Safari 浏览器。目前，浏览器的支持率为 [74%](https://caniuse.com/loading-lazy-attr)，如果浏览器不支持原生实现则可以使用 [polyfill](https://github.com/mfranzke/loading-attribute-polyfill) 或者上述懒加载库中的某个库。

为了安全起见，您可能仍需要使用动态导入来实现其中一个库。

## 了解你的目标受众

如果您仔细分析以上所有给定的库，您会发现它们在三个方面存在激烈的竞争：性能、大小和浏览器兼容性（用户覆盖率）。这些通常不得不牺牲至少一个来提高另一个的水平。

例如，如果您使用实现 `IntersectionObserver` API 的库，您将获得一个高性能的库，但它的用户覆盖范围会更小。如果需要修补，则需要有后备选项，例如 `polyfills`，这将增加库的整体大小。

在另一个示例中，如果懒加载库使用 `getBoundingClientRect()` 方法，它的性能将不如 `IntersectionObserver` API，因为众所周知它存在[强制布局回流](https://gist.github.com/paulirish/5d52fb081b3570c81e3a)问题。虽然牺牲了性能，但用户覆盖率将高于前者。希望我能把这一点说清楚。

**如何将兼容性问题降至最低并最大限度地提高性能？**

可以通过了解目标受众及其浏览器使用情况来改进这些方面。如果你知道你的目标受众和他们使用的浏览器，你可以确保你的延迟加载的实现更适合那些浏览器版本。这将减少对不受支持的浏览器包含 `polyfill` 的需要，因为已经知道需要关注哪些浏览器。当你有一个异常值（不支持的浏览器），图片可以直接加载没有任何延迟或延迟。如果你对受众有很好的了解，那么这些异常值的数量将可以忽略不计。

这种方法将有助于使用性能良好的实现库，通过忽略浏览器异常将库大小保持在最小值，并支持目标用户的浏览器版本。

---

本文简要讨论了 JavaScript 的懒加载库以及一些提高效率和改善用户体验的方法。请在下面的评论中发表你的看法。

感谢阅读，祝编码快乐！！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
