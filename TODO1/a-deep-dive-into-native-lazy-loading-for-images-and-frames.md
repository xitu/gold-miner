> * 原文地址：[A Deep Dive into Native Lazy-Loading for Images and Frames](https://css-tricks.com/a-deep-dive-into-native-lazy-loading-for-images-and-frames/)
> * 原文作者：[Erk Struwe](https://css-tricks.com/author/erkstruwe/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-deep-dive-into-native-lazy-loading-for-images-and-frames.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-deep-dive-into-native-lazy-loading-for-images-and-frames.md)
> * 译者：[Baddyo](https://juejin.im/user/5b0f6d4b6fb9a009e405dda1)
> * 校对者：[Mcskiller](https://github.com/Mcskiller)

# 深入理解图片和框架的原生懒加载功能

当今的网站上充斥着大量媒体资源，例如图片和视频。图片约占[网站平均通信量的 50%](https://httparchive.org/reports/page-weight#bytesImg)。然而这些图片中的大部分都没机会进入用户的视野，因为它们位于网站页面的[头版](https://en.wikipedia.org/wiki/Above_the_fold)之外。

看到本文标题你会问「懒加载是什么东西？」CSS-Tricks 网站中有非常多的探讨**懒加载**的[文章](https://css-tricks.com/?s=lazy+load&orderby=relevance&post_type=post%2Cpage%2Cguide)，其中有一篇非常详尽的《[用 JavaScript 花式实现懒加载的指南文档](https://css-tricks.com/the-complete-guide-to-lazy-loading-images/)》。简言之，我们要讨论的是一种延迟网络资源加载的机制，在该机制下，网页内容按需加载，或者说得更直白些，当网页内容进入用户视野时再触发加载。

这样做有什么好处？压缩初始页面的体积以提升加载速度；免于为用户根本不会看到的内容浪费网络请求。

如果你之前读过关于懒加载的其他文章，你就会明白，我们必须借助各种不同的方式才能实现懒加载功能。而当原生 HTML 用 `loading` 特性支持懒加载功能后，那可就柳暗花明又一村了。目前仅有 [Chrome](https://css-tricks.com/a-native-lazy-load-for-the-web-platform/) 支持 `loading` 特性，但有望全面开花。Chrome 近期正在开发和测试对原生懒加载特性的支持功能，预计在 2019 年 9 月初发布的 Chrome 77 版本中面世。

![懒加载的饿豹图（但图片还是立即加载了，因为它位于头版中）](https://demo.tiny.pictures/native-lazy-loading/eager-cat.jpg?height=550&resizeType=cover&gravity=0.45%2C0.58&width=904) 

## 非原生的方法

截至目前，我们这群开发者仍需要用 JavaScript（不论是借助第三方库还是自己从零手写）实现懒加载功能。大多数懒加载库的原理都是：

* 服务端返回的 HTML 响应中包含一个初始的、不带 `src` 特性的 `img` 元素，这样浏览器就不会加载任何数据。而图片的链接地址放在 `img` 元素的其他特性上，例如 `data-src`。

```html
<img data-src="https://tiny.pictures/example1.jpg" alt="...">
```

* 然后，载入一个懒加载库，运行它。

```html
<script src="LazyLoadingLibrary.js"></script>
<script>LazyLoadingLibrary.run()</script>
```

* 该懒加载库时刻记录用户滚动页面的行为，告诉浏览器加载即将滚入用户视野的图片。加载方式是把 `data-src` 特性的值赋给原本为空的 `src` 特性。

```html
<img src="https://tiny.pictures/example1.jpg" data-src="https://tiny.pictures/example1.jpg" alt="...">
```

长期以来，我们都在用这种方式实现懒加载。但这并不是理想的实现方式。

该方式的显著问题就是，要展示网站页面，得经过好几个关键步骤。总共要三个步骤，还必须得按顺序执行：

1. 加载初始的 HTML 响应内容
2. 加载懒加载库
3. 加载图片

如果把这样的懒加载技术应用到头版中的图片上，页面在加载期间会**发生闪烁**，因为一开始绘制的时候，页面中没有图片（闪烁发生于第 1 步还是第 2 步之后，取决于载入库的脚本用的是 `defer` 还是 `async`），懒加载库生效后，图片才姗姗来迟。这还会给用户造成网页加载速度缓慢的错觉。

另外，懒加载库本身也是对带宽和 CPU 算力的占用。而且别忘了，如果用户**禁用了 JavaScript**（都已经2019年了，这种情况我们不予考虑，[你说对吧？](https://www.wired.com/2015/11/i-turned-off-javascript-for-a-whole-week-and-it-was-glorious/)），那么懒加载库是行不通的。

哦对了，那些依赖 RSS 来发布内容的网站（如 CSS-Tricks）又该怎么办呢？如果初始的页面中不载入图片，那么 RSS 版本的页面就始终不会显示图片。

凡此种种，不一而足。

## 原生懒加载前来救驾！

![懒加载的懒猫图](https://demo.tiny.pictures/native-lazy-loading/lazy-cat.jpg?height=550&resizeType=cover&gravity=0.3%2C0.5&width=904) 

如前文所说，Chromium 开发团队和 Google Chrome 开发团队从 Chrome 75 开始，装载 `loading` 特性支持的原生懒加载功能。关于该特性及其值，我们稍后再讨论，还是先在浏览器里启用这个功能来一探究竟吧。

### 启用原生懒加载功能

从 Chrome 75 开始，我们可以切换两个开关来手动启用懒加载功能。预计从 Chrome 77（计划于 2019 年 9 月发布）开始，该功能就会是默认开启的了。

1. 在 Chromium 或 Chrome Canary 打开 `chrome://flags`。
2. 搜索关键词 `lazy`。
3. 把「Enable lazy image loading」和「Enable lazy frame loading」两项都激活。
4. 点击屏幕右下角的按钮重启浏览器。

![](https://css-tricks.com/wp-content/uploads/2019/05/s_160B9CF1BF8B57931AB686E69B9B21D9BB06362CE31DD0F75344D0CE817B67F2_1557201494561_chrome-native-lazy-loading-flags.png)

↑↑↑ 示意图：Google Chrome 中的原生懒加载功能开关 ↑↑↑

打开 JavaScript 控制台（按 `F12` 键），看看懒加载功能是否已经成功激活。如果成功激活，你会看到如下警告信息：

> [Intervention] Images loaded lazily and replaced with placeholders. Load events are deferred.（图片以懒惰方式加载并替换为占位符。加载事件被延迟。）

都搞定了吗？那就一起深入了解 `loading` 吧。

## loading 特性

`img` 和 `iframe` 元素都支持 `loading` 特性。切记，`loading` 特性的值不是让浏览器严格执行的命令，而是帮助浏览器自己决定是否要懒加载图片或者框架。

下面会介绍 `loading` 特性可取的三个值。在下文中的每张图片下面，你都可以看到一张表格，其中列着每个图片资源的加载时序。**范围请求**（译者注：原文用词为 Range response，疑似笔误）指的是一种预检图片局部的请求，用来确定图片文件的大小（参见详细[原理](https://github.com/xitu/gold-miner/pull/5886#loading-%E7%89%B9%E6%80%A7%E7%9A%84%E5%8E%9F%E7%90%86)）。如果该列有内容，证明浏览器成功发出了范围请求。

请注意 **startTime** 列，该列表明了在 DOM 解析后，图片的加载被推迟了多长时间。你可以使用强制刷新（CTRL + Shift + R）重新触发范围请求。

### 默认值：`auto`

```html
<img src="auto-cat.jpg" loading="auto" alt="...">
<img src="auto-cat.jpg" alt="...">
<iframe src="https://css-tricks.com/" loading="auto"></iframe>
<iframe src="https://css-tricks.com/"></iframe>
```

![自动加载的车模照](https://demo.tiny.pictures/native-lazy-loading/auto-cat.jpg?width=452)

↑↑↑ 示意图：自动加载的车模照 ↑↑↑

| 度量 / 请求 | #1          |
| ---------------- | ----------- |
| encodedBodySize  | 20718 bytes |
| decodedBodySize  | 20718 bytes |
| transferSize     | 0 bytes     |
| startTime        | 54 ms       |
| requestStart     | 592 ms      |
| responseStart    | 596 ms      |
| responseEnd      | 601 ms      |
| timeToFirstByte  | 4 ms        |
| downloadDuration | 5 ms        |

把 `loading` 设为 `auto`（或者将其置空：`loading=""`），可以让**浏览器自己决定**是否懒加载图片。决定是否懒加载要考虑很多因素，例如平台、是否处于 Data Saver 模式（译者注：Chrome 已于 2019 年 5 月 6 日废弃了该功能）、网络状况、图片大小、是图片还是 iframe 以及 CSS 的 `display` 属性等等。（关于考虑这些因素的原因，参见[此处](https://github.com/xitu/gold-miner/pull/5886#loading-%E7%89%B9%E6%80%A7%E7%9A%84%E5%8E%9F%E7%90%86)。）

### 急脾气的值：`eager`

```html
<img src="auto-cat.jpg" loading="eager" alt="...">
<iframe src="https://css-tricks.com/" loading="eager"></iframe>
```

![急切加载的疾豹图](https://demo.tiny.pictures/native-lazy-loading/eager-cat.jpg?width=452)

↑↑↑ 示意图：急切加载的急豹图 ↑↑↑

| 度量 / 请求 | #1          |
| ---------------- | ----------- |
| encodedBodySize  | 24019 bytes |
| decodedBodySize  | 24019 bytes |
| transferSize     | 0 bytes     |
| startTime        | 54 ms       |
| requestStart     | 592 ms      |
| responseStart    | 600 ms      |
| responseEnd      | 605 ms      |
| timeToFirstByte  | 7 ms        |
| downloadDuration | 5 ms        |

`eager` 告诉浏览器这张图片需要**立即**加载。如果加载已经被延迟了（比如初始值为 `lazy`，后来用 JavaScript 改成了`eager`），那么浏览器也应该立即加载图片。

### 懒洋洋的值：`lazy`

```html
<img src="auto-cat.jpg" loading="lazy" alt="...">
<iframe src="https://css-tricks.com/" loading="lazy"></iframe>
```

![懒加载的懒猫图](https://demo.tiny.pictures/native-lazy-loading/lazy-cat.jpg?width=452)

↑↑↑ 示意图：懒加载的懒猫图 ↑↑↑

| 度量 / 请求 | #1          |
| ---------------- | ----------- |
| encodedBodySize  | 12112 bytes |
| decodedBodySize  | 12112 bytes |
| transferSize     | 0 bytes     |
| startTime        | 54 ms       |
| requestStart     | 593 ms      |
| responseStart    | 599 ms      |
| responseEnd      | 604 ms      |
| timeToFirstByte  | 6 ms        |
| downloadDuration | 5 ms        |

`lazy` 告诉浏览器此图片应该懒加载。懒加载到底有多「懒」，这应该由浏览器来解释，而[说明文档](https://github.com/scott-little/lazyload)表明，懒加载始于**用户将页面滚动到图片附近**之时，意即当图片即将进入视野时加载。

## `loading` 特性的原理

与基于 JavaScript 的懒加载库不同，原生懒加载功能使用了一种预检请求来获取**图片文件的前 2048 字节数据**。根据预先取得的数据，浏览器会试着确定该图片的大小，便于在完整图片的位置插入一个隐形的占位符，防止加载过程中页面发生闪烁现象。

在第一个（如果图片大小小于 2 KB，一个预检请求就够了）或第二个请求完成后，完整图片一加载完毕，其 `load` 事件就会解除监听。请注意，如果没有完成第二个请求，那么`load` 事件可能会一直绑定着。

> 从今以后，浏览器因获取图片而发出的请求的数量可能会翻倍。每张图片对应两个请求：先是范围请求，再是完整请求。要确保你的服务器支持 HTTP `Range: 0-2047` 请求头，而响应状态码要用 `206（部分内容）`，防止整个图片被传送两次。

每个用户都会发送大量的后续请求，因此 Web 服务器对 HTTP/2 协议的支持变得越来越重要。

现在我们来聊聊延迟的内容。Chrome 浏览器的渲染引擎 [Blink](https://en.wikipedia.org/wiki/Blink_(browser_engine)) 采用启发式技术来确定哪些内容应该延迟加载、延迟多久。Scott Little 在他的[设计文档](https://docs.google.com/document/d/1e8ZbVyUwgIkQMvJma3kKUDg8UUkLRRdANStqKuOIvHg/)中全面地列出了确定延迟策略的条件。下面是确定延迟对象的简短策略：

* 所有平台中设置了 `loading="lazy"` 的图片和框架
* 浏览器为 Android 系统中的 Chrome，启用了 Data Saver 模式；并且满足下列条件的图片：
    * 设置了 `loading="auto"` 或 `loading=""`
    * `width` 和 `height` 特性的值都不小于 10 px
    * 非 JavaScript 插入的图片
* 满足下列条件的框架：

  * 设置了 `loading="auto"` 或 `loading=""`
  * 来自第三方（与被插入页面的域名或协议不同）
  * 宽、高都大于 4 像素（防止将微型跟踪框架一并延迟加载）
  * 未设置 `display: none` 或 `visibility: hidden`（防止将跟踪框架一并延迟加载）
  * 未用负坐标值定位于屏幕区域以外

## 带有 `srcset` 特性的响应式图片

对于带有 `srcset` 特性的响应式图片，原生懒加载同样有效。`srcset` 特性提供了一系列图片文件供浏览器选用。根据用户的屏幕尺寸、设备像素比、网络状况等因素，浏览器会选取最适合情境的图片。像 [tiny.pictures](https://tiny.pictures/) 这样的图片优化 CDN 可以**实时提供备选图片，无需后端开发**。

```html
<img src="https://demo.tiny.pictures/native-lazy-loading/lazy-cat.jpg" srcset="https://demo.tiny.pictures/native-lazy-loading/lazy-cat.jpg?width=400 400w, https://demo.tiny.pictures/native-lazy-loading/lazy-cat.jpg?width=800 800w" loading="lazy" alt="...">
```

## 浏览器支持

在撰写本文时，还没有浏览器默认支持原生懒加载功能。但就像之前说的，Chrome 从 77 版本开始会默认开启懒加载。除此之外，目前还没有浏览器厂商宣称支持该功能。（Edge 将是个例外，因为它即将[转为 Chromium 内核](https://css-tricks.com/edge-goes-chromium-what-does-it-mean-for-front-end-developers/)。）

你可以用几行 JavaScript 代码检查支持情况：

```javascript
if ("loading" in HTMLImageElement.prototype) {
  // 支持。
} else {
  // 不支持。你可能需要引入懒加载库（下文已列出）。
}
```

参见 [CodePen](https://codepen.io) 中 Erk Struwe（[@erkstruwe](https://codepen.io/erkstruwe)）的代码示例：[浏览器原生懒加载支持探测器](https://codepen.io/erkstruwe/pen/OGQdJp/)

## 以模糊图片自动回退到 JavaScript 方案

多数基于 JavaScript 的懒加载库都有一个炫酷的功能：[模糊占位图片（LQIP）](https://css-tricks.com/the-complete-guide-to-lazy-loading-images/#article-header-id-9)。该功能基本上利用了这个原理：即使后来 `src` 特性的值会被另外的 URL 替换掉，浏览器还是会在一开始就立刻加载 `img` 元素。这样，我们可以在页面载入时先加载一个不清晰的小图片，之后再用完整图片代替它。

现在我们可以利用这个功能，在不支持懒加载的浏览器中模拟原生懒加载的 2 KB 范围请求，以期实现模糊占位图片相同的效果。

参见 [CodePen](https://codepen.io) 中 Erk Struwe（[@erkstruwe](https://codepen.io/erkstruwe)）的代码示例：[针对原生懒加载的 JavaScript 回退方案，以及模糊占位图片功能](https://codepen.io/erkstruwe/pen/ROQmWa/)

## 总结

这个新功能着实让我激动。原生懒加载功能的发布近在眼前，会对全球互联网通信产生非凡影响。就算它只能改变[启发式技术](https://en.wikipedia.org/wiki/Heuristic)的一小部分，老实说我仍不明白为何人们不给予足够的关注。

想想吧，随着在不同的 Chrome 平台中逐渐推广、`auto` 值成为默认选项，**世界上最流行的浏览器即将对视口外的图片和框架应用懒加载技术**。决堤般的通信量会大面积击溃那些健壮性不足的网站，而且，蜂拥而至的图片探测请求也会伤及网络服务器。

接下来遭殃的就是追踪技术: 假设那些深受信赖的追踪像素和追踪框架都无法加载，那么数据分析领域及其周边产业将面临被动局面。我们只能希望他们千万别惊慌失措，千万别给每个图片都加上 `loading="eager"` 这项伟大功能，这样添加 `loading` 特性根本不是为了服务网站用户，实在暴殄天物。他们更应该改写代码，以便于被[启发式技术](https://github.com/xitu/gold-miner/pull/5886#loading-%E7%89%B9%E6%80%A7%E7%9A%84%E5%8E%9F%E7%90%86)识别为追踪像素。

> Web 开发者、数据分析经理和运营经理应该立即检查自己的网站，确保前端支持原生懒加载、后端支持范围请求和 HTTP/2 协议。

万一原生懒加载功能出现问题，或者你想把图片加载优化到极致（包括自动支持 WebP、模糊占位图片等等），图片优化 CDN 能助你一臂之力。更多内容参见 [tiny.pictures](https://tiny.pictures)！

## 参考文献

* [Blink 引擎关于懒加载的设计文档](https://docs.google.com/document/d/1e8ZbVyUwgIkQMvJma3kKUDg8UUkLRRdANStqKuOIvHg/)
* [Blink 引擎关于图片懒加载的设计文档](https://docs.google.com/document/d/1jF1eSOhqTEt0L1WBCccGwH9chxLd9d1Ez0zo11obj14)
* [Blink 引擎关于框架懒加载的设计文档](https://docs.google.com/document/d/1ITh7UqhmfirprVtjEtpfhga5Qyfoh78UkRmW8r3CntM)
* [Blink 引擎关于图片替换的设计文档](https://docs.google.com/document/d/1691W7yFDI1FJv69N2MEtaSzpnqO2EqkgGD3T0O-pQ08/edit#heading=h.mexcvf6leeqf)
* [Chromium 的公共故障跟踪](https://bugs.chromium.org/p/chromium/issues/detail?id=954323)
* [针对禁用 page-wide 功能的政策提案](https://github.com/w3c/webappsec-feature-policy/issues/193)
* [Addy Osmani 关于原生懒加载的博文](https://addyosmani.com/blog/lazy-loading/)
* [Chrome 平台下的懒加载功能](https://chromestatus.com/feature/5645767347798016)
* [Scott Little 的懒加载详解](https://github.com/scott-little/lazyload)
* [HTML 标准的合并请求（Pull request）](https://github.com/whatwg/html/pull/3752)
* [Chrome 平台状态以及发布时间线](https://www.chromestatus.com/features/schedule)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
