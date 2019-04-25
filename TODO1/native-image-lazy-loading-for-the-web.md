> * 原文地址：[Native image lazy-loading for the web!](https://addyosmani.com/blog/lazy-loading/)
> * 原文作者：[addyosmani](http://twitter.com/addyosmani)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/native-image-lazy-loading-for-the-web.md](https://github.com/xitu/gold-miner/blob/master/TODO1/native-image-lazy-loading-for-the-web.md)
> * 译者：[nanjingboy](https://github.com/nanjingboy)
> * 校对者：[xionglong58](https://github.com/xionglong58), [portandbridge](https://github.com/portandbridge)

# 图片懒加载

在本文中，我们将研究新的 [`loading`](https://github.com/scott-little/lazyload) 属性，它为 `<img>` 及 `<iframe>` 带来了延迟加载的能力。如果你对此感兴趣，可查看以下示例：

```html
<img src="celebration.jpg" loading="lazy" alt="..." />
<iframe src="video-player.html" loading="lazy"></iframe>
```

我们希望在 ~[Chrome 75](https://chromestatus.com/feature/5645767347798016) 中为 `loading` 提供支持，并且我们正在深入研究即将发布的新特性。在此之前，让我们深入了解它的工作原理。

## 简介

Web 页面通常包含大量的图片，这些图片将影响网络流量、[页面尺寸](https://httparchive.org/reports/state-of-images)及页面加载速度。这些图片中许多处于屏幕外，往往需要用户滚动页面才能看到。

过去，为了降低屏幕外的图片对页面加载时间的影响，开发人员不得不使用 JavaScript 库（比如：[LazySizes](https://github.com/aFarkas/lazysizes)）来推迟这些图片的加载时机，直到用户将页面滚动到它们附近。

![](https://addyosmani.com/assets/images/without-lazyload@2x.png)

页面加载 211 张图片。没有延迟加载的版本加载了 10 MB 数据。延迟加载版本（使用 LazySizes）仅预先加载了 250 KB 数据 - 其他图片将随着用户的滚动而加载。查看 [WPT](https://webpagetest.org/video/compare.php?tests=190406_2K_30b9b9cd6b48735a41bce2daee27b7f5,190406_6R_4ce0ac65b7e11d2e132e4ea8d887edd9)。

如果浏览器就能帮你做到避免加载屏幕外的图片呢？这将有助于加快视窗中内容的加载、减少整体网络数据量以及低端设备下内存使用量。因此，我很高兴地告诉大家，很快就可以使用 image 和 iframe 的新属性 `loading` 来实现了。

## `loading` 属性

`loading` 属性允许浏览器推迟加载屏幕外的 image 和 iframe 直到用户将页面滚动到它们附近。`loading` 支持三个值：

*   **`lazy`**：延迟加载。
*   **`eager`**：立即加载。
*   **`auto`**：由浏览器来决定是否延迟加载。

如果不指定该属性，其默认值为 auto。

![](https://addyosmani.com/assets/images/loading-attribute@2x.png)

[HTML 标准](https://github.com/whatwg/html/pull/3752) 正在研究将 `<img>` 和 `<iframe>` 的 `loading` 属性作为标准的一部分。

### 例子

`loading` 属性适用于 `<img>`（包括包含 `srcset` 属性及位于 `<picture>` 内部）和 `<iframe>`：

```html
<!-- 延迟加载屏幕外的图片直到用户滚动到它附近 -->
<img src="unicorn.jpg" loading="lazy" alt=".."/>

<!-- 立即加载（而非延迟加载）图片 -->
<img src="unicorn.jpg" loading="eager" alt=".."/>

<!-- 浏览器决定是否延迟加载图片 -->
<img src="unicorn.jpg" loading="auto" alt=".."/>

<!-- 延迟加载 <picture> 内的图片。<img> 用来驱动图片的加载，因此 <picture> 及 srcset
会将合适的图片呈现在 <img> 上 -->
<picture>
  <source media="(min-width: 40em)" srcset="big.jpg 1x, big-hd.jpg 2x">
  <source srcset="small.jpg 1x, small-hd.jpg 2x">
  <img src="fallback.jpg" loading="lazy">
</picture>

<!-- 延迟加载设定 srcset 属性的图片-->
<img src="small.jpg"
     srcset="large.jpg 1024w, medium.jpg 640w, small.jpg 320w"
     sizes="(min-width: 36em) 33.3vw, 100vw"
     alt="A rad wolf" loading="lazy">

<!-- 延迟加载屏幕外的 iframe 直到用户滚动到它附近 -->
<iframe src="video-player.html" loading="lazy"></iframe>
```

由浏览器完成“当用户滚动到附近时”的确切检测。一般来说，我们希望浏览器在快要进入视窗口之前便开始提取延迟图片和 iframe 的内容。这将增加图片或 iframe 在用户滚动到它们时完成加载的更改。

注意：我曾[建议](https://github.com/whatwg/html/pull/3752#issuecomment-478200976)应该将 `loading` 属性值作为属性名称，因为它的命名与 [`decoding`](https://developer.mozilla.org/en-US/docs/Web/API/HTMLImageElement/decoding) 属性较为接近。在之前的提议中，类似 `lazyload` 这样的属性没有被接受，这是因为我们需要支持多个值（`lazy`、`eager` 及 `auto`）。

## 特性检测

我们已知道为延迟加载（跨浏览器支持）获取及应用 JavaScript 库的重要性。`loading` 的支持情况可以通过以下方式进行检测：

```html
<script>
if ('loading' in HTMLImageElement.prototype) {
    // 浏览器支持 `loading`..
} else {
   // 获取并应用 polyfill/JavaScript 类库
   // 来替代 lazy-loading。
}
</script>
```

注意：你还可以使用 `loading` 作为一种渐进的增强功能。支持该属性的浏览器可通过 `loading=lazy` 获得新的延迟加载能力，不支持该属性的浏览器仍然会加载图片。

### 跨浏览器的图片延迟加载

如果跨浏览器支持图片的延迟加载非常重要，那么仅仅在使用 `<img src=unicorn.jpg loading=lazy />` 的标记中进行特性检测、使用延迟加载库是不够的。

该标记需使用类似 `<img data-src=unicorn.jpg />`（而非 `src`、`srcset` 或 `<source>`）的属性，以避免在不支持新属性的浏览器下触发立刻加载。如果浏览器支持 `loading`，可以使用 JavaScript 将这些属性更改为正确的属性，否则加载类库。

下面是一个可以说明其可能是什么样子的例子。

* 视窗/一屏展示图片是常规的 `<img>` 标签。`data-src` 会破坏预加载扫描程序，因此我们希望避免它出现在视窗中的所有内容中。
* 我们在图片上使用 `data-src` 以避免在不支持的浏览器中触发立刻加载，如果浏览器支持 `loading`，我们将 `data-src` 替换为 `src`。
* 如果 `loading` 不被支持，我们加载一个后备（LazySizes）脚本并启动它。在这里，我们用 `class=lazyload` 向 LazySizes 指出，哪些图片要延迟加载。

```html
<!-- 让我们在视窗内正常加载这个图片 -->
<img src="hero.jpg" alt=".."/>

<!-- 让我们以延迟加载的方式加载剩余图片 -->
<img data-src="unicorn.jpg" loading="lazy" alt=".." class="lazyload"/>
<img data-src="cats.jpg" loading="lazy" alt=".." class="lazyload"/>
<img data-src="dogs.jpg" loading="lazy" alt=".." class="lazyload"/>

<script>
(async () => {
    if ('loading' in HTMLImageElement.prototype) {
        const images = document.querySelectorAll("img.lazyload");
        images.forEach(img => {
            img.src = img.dataset.src;
        });
    } else {
        // 动态引入 LazySizes 库
        const lazySizesLib = await import('/lazysizes.min.js');
        // 初始化 LazySizes（读取 data-src & class=lazyload）
        lazySizes.init(); // lazySizes 在全局环境下工作。
    }
})();
</script>
```

## 示例

看看这个！[一个 `loading=lazy` 示例，展示了整整 100 张小猫图片](https://mathiasbynens.be/demo/img-loading-lazy)。

详见 YouTube 视频：https://youtu.be/bhnfL6ODM68

## Chrome 实现细节

**我们强烈建议等到 `loading` 属性处于稳定版本后再在你的生产环境中使用它。早期测试人员可能会发现以下注解非常有用。**

### 立刻尝试

转到 `chrome://flags` 并同时开启 "Enable lazy frame loading" 和 "Enable lazy image loading"，然后重新启动 Chrome。

### 配置

Chrome 延迟加载的实现不仅仅基于当前滚动位置的接近程度，还取决于网络连接速度。对于不同的网络连接速度，延迟加载 frame 和图片的视窗距离阈值是[硬编码](https://cs.chromium.org/chromium/src/third_party/blink/renderer/core/frame/settings.json5?l=937-1003&rcl=e8f3cf0bbe085fee0d1b468e84395aad3ebb2cad)的，可以通过命令行覆盖该值。以下是一个覆盖图片延迟加载设置的示例：

```
canary --user-data-dir="$(mktemp -d)" --enable-features=LazyImageLoading --blink-settings=lazyImageLoadingDistanceThresholdPxUnknown=5000,lazyImageLoadingDistanceThresholdPxOffline=8000,lazyImageLoadingDistanceThresholdPxSlow2G=8000,lazyImageLoadingDistanceThresholdPx2G=6000,lazyImageLoadingDistanceThresholdPx3G=4000,lazyImageLoadingDistanceThresholdPx4G=3000 'https://mathiasbynens.be/demo/img-loading-lazy'
```

以上命令对应于（当前）默认配置。将所有值更改为 `400` 以便仅在滚动位置在距离图片的 400 像素以内开始延迟加载。下面我们还可以看到距离阈值设为 1 像素的另一个做法（在本文前面的视频中使用）：

```
canary --user-data-dir="$(mktemp -d)" --enable-features=LazyImageLoading --blink-settings=lazyImageLoadingDistanceThresholdPxUnknown=1,lazyImageLoadingDistanceThresholdPxOffline=1,lazyImageLoadingDistanceThresholdPxSlow2G=1,lazyImageLoadingDistanceThresholdPx2G=1,lazyImageLoadingDistanceThresholdPx3G=1,lazyImageLoadingDistanceThresholdPx4G=1 'https://mathiasbynens.be/demo/img-loading-lazy'
```

由于实现在未来几周内稳定下来，我们的默认配置很可能会发生变化。

### DevTools

Chrome 中 `loading` 的一个实现细节是它会在页面加载时获取前 2 KB 的图片数据。如果服务器支持范围请求，则前 2 KB 可能包含图片尺寸。这使得我们能够生成/显示具有相同尺寸的占位符。如果像是图标一类的资源的话，前 2 KB 也很有可能包含整幅图片了。

![](https://addyosmani.com/assets/images/lazy-load-devtools.png)

Chrome 会在用户即将看到图片时抓取其剩余数据。Chrome DevTools 中要注意的地方是，这可能导致（1）在 DevTools 的网络面板中“出现” 两次获取和（2）为每个图片提供两个请求的资源定时。

## 服务端确定 `loading` 支持

在一个美好的世界中，你不需要依赖客户端上的 JavaScript 特性检测来决定是否需要加载兼容库 — 你需要在提供包含 JavaScript 延迟加载库的 HTML 之前处理此问题。客户端提示可以启用此类检查。

传递 `loading` 参数的提示已经被[考虑](https://bugs.chromium.org/p/chromium/issues/detail?id=949365)，但目前正处于早期讨论阶段。

## 总结

试试看 `<img loading>`，并让我们知道你的想法。我对大家如何探索跨浏览器的经验，及是否有任何我们错过的边缘情况特别感兴趣。

## 参考资料

*   [Intent to ship this feature in Blink](https://groups.google.com/a/chromium.org/forum/#!msg/blink-dev/jxiJvQc-gVg/wurng4zZBQAJ)
*   [Specification PR](https://github.com/whatwg/html/pull/3752)
*   [Explainer](https://github.com/scott-little/lazyload)
*   [Demo](https://mathiasbynens.be/demo/img-loading-lazy)

**感谢 Simon Pieters、Yoav Weiss 和 Mathias Bynens 的反馈。非常感谢 Ben Greenstein、Scott Little、Raj T 和 Houssein Djirdeh 在 LazyLoad 上的工作。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
