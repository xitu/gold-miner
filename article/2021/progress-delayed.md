> * 原文地址：[Progress Delayed Is Progress Denied](https://infrequently.org/2021/04/progress-delayed/)
> * 原文作者：[Infrequently Noted](https://infrequently.org/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/progress-delayed.md](https://github.com/xitu/gold-miner/blob/master/article/2021/progress-delayed.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：

# 进度延迟是进度被拒绝

## App Store 政策会伤害开发者吗？ 网络是一个可靠的选择吗？ 一 快看数据

***更新（2021 年 6 月 16 日）：** 尝试构建移动网络游戏的人们通知我 [Fullscreen API](https://developer.mozilla.org/en-US/docs/Web/API/Fullscreen_API) 在 [iOS 上的非视频元素仍然不可用](https://developer.apple.com/forums/thread/133248)。这以一种难以夸大的方式阻碍了游戏和沉浸式媒体体验。说到步履蹒跚，最初的帖子称赞 Apple 最终发布了一个可用的 IndexedDB 实现，[这似乎为时过早，这里就有一个 IndexedDB 的 Bug 了](https://www.theregister.com/2021/06/16/apple_safari_indexeddb_bug/).*

---

三个事实……

1. [Apple 禁止来自 iOS 上唯一允许的 App Store 的网络应用](https://developer.apple.com/app-store/review/guidelines/#4.2).<sup>[1]</sup>
2. [Apple 强制竞争浏览器的开发者在 iOS 上的所有浏览器上使用他们的引擎](https://developer.apple.com/app-store/review/guidelines/#2.5.6)，限制他们提供更好的网络平台版本。
3. [Apple 声称](https://firt.dev/pwa-2021#tim-cook-promoting-pwas) [iOS 上的浏览​​器是足以支持反对 App Store 条款的开发者的平台](https://firt.dev/ios-14.5/#progressive-web-apps-on-ios-14.5) 。

一次满足……不是，是和一个提议：

> Apple 的 iOS 浏览器（Safari）和引擎（WebKit）的动力不足。重要功能交付的持续延迟确保网络永远不能成为其专有工具和 App Store 的可靠替代品。

这是一个大胆的断言，证明它需要压倒性的证据。这篇文章挖掘了有关兼容性修复和功能添加速度的公开数据，以评估我们应该怎样向 Apple 索赔。

### 史蒂夫和蒂姆的特写魔术

误导通常会破坏围绕浏览器、网络角色和 iOS 上 App Store 政策的辩论。该流派的经典包括：

> Apple 只专注于性能！

> ……该功能在技术预览版中出现了。

> 苹果正在尝试，他们刚刚添加了<期待已久的功能>。

这些要点可以同时有效并且对 Web 的适用性无关紧要，作为在 iOS 上进行本地应用程序开发的有效替代方案。

要了解 Apple 在 Web 和原生之间创建和维护的差距，我们应该关注趋势而不是单个版本。就像是要知道我们是否处于干旱中，我们必须检查水库水位和季节性降雨量。可能【正在下雨功能】**就在这一刻**出现了，但天气可不是气候。

在我们开始测量水位之前，我想让一些事情**令人难以忍受地**清楚。

首先，以下内容不是对 Safari 团队或 WebKit 项目中的个人的批评，而是向 Apple [提供帮助](https://www.cnbc.com/2021/01/27/apple-q1-cash-hoard-heres-how-much-apple-has-on-hand.html) 帮助他们能够充分完成他们的工作<sup>[2]</sup>。他们是全球最优秀的引擎开发者之一，并且真正想要为网络带来好东西。Apple 有错，而不是开源工程师或支持他们的经理有错。

其次，在前沿具有不同优先级的浏览器项目是**自然和健康的**。迅速解决和达成协议也是如此。不健康的是引擎远远落后多年，**更糟糕的是**是无法通过浏览器选择解决的情况。假设功能的“兼容核心”继续以稳定的速度扩展，团队在不同领域处于领先地位是**好的**。我们不应期望在短期内保持统一 —— 它不会为领导留下任何空间<sup>[3]</sup>。

最后，虽然这篇文章**确实**衡量了 Safari 的滞后距离，但请不要将其误认为是核心问题：**阻止有意义的浏览器竞争的 iOS App Store 政策是这里的问题**。

Safari 以大致相同的幅度落后于竞争的 MacOS 浏览器，但这不是危机，因为选择真正的浏览器可以提供有意义的替代方案。

MacOS Safari 足够引人注目，在激烈的竞争中多年来一直保持 40-50% 的份额。Safari 有很多不错的功能，在开放的市场中，选择它是完全合理的。

## 性能参数

作为浏览器团队的一名工程师，我一直在了解各种性能项目、基准演习以及性能营销对工程优先级的影响方式。

所有现代浏览器运行起来都很快，包括 Chromium 和 Safari/WebKit，但没有浏览器**永远**都最快的。就像太阳从东方升起一样可靠，新的基准测试启动了重新构建内部结构的项目，以取得领先，这是应该的。

健康竞争的特点是竞争对手有规律地领先。[关于性能“差 10 倍”的虚假报道](https://news.ycombinator.com/item?id=26186114)值得强烈怀疑。

经过 20 年的并驾齐驱的竞争，通常是从常见的代码谱系开始，现在已经没有多少**那么多**可以从系统中榨取了。[持续改进](https://blog.chromium.org/2021/04/digging-for-performance-gold.html) 是这场游戏的主题，它仍然可以[有积极的影响，特别是当用户随着时间的推移越来越依赖于计算机上](https://blog.chromium.org/2021/03/advanced-memory-management-and-more.html)。

所有浏览器都在深入优化过程，导致进行了复杂的权衡。改进一种类型的设备或应用程序的东西可以使它们回归其他类型。现在的显着收益**倾向于**[来自（巧妙地）与开发者解除合同](https://blog.chromium.org/2020/11/tab-throttling-and-more-performance.html)而希望用户没注意。引擎之间对性能工程的关注并没有太大的差距。

小差距和领先的频繁交接意味着能力和正确性的差异不是一个团队专注于表现而其他团队追求不同目标的结果<sup>[4]</sup>。

最后，为特征和正确性工作提供资金的选择与提高性能并不相互排斥。下面列表中的许多延迟功能将使网络应用程序在 iOS 上运行得更快。[内部的重新架构](https://blog.mozilla.org/blog/2017/11/14/introducing-firefox-quantum/)提高正确性之余也经常[产生性能优势](https://developers.google.com/web/updates/2019/06/layoutNG)。

## 兼容性成本

Web 开发者是一群热情的人；我们不会在第一次发现错误或引擎之间的不兼容时就放弃。[知识的深渊](https://alistapart.com/article/understandingprogressiveenhancement/)和[实践](https://alistapart.com/article/responsive-web-design/)以问题为中心：*“尽管他们的浏览器支持的内容不同，我们应该如何为每个人提供良好的体验？”*

适应是熟练的前端人员的一种生活方式。

适应的文化价值具有巨大的影响。首先，Web 开发者不会将单个浏览器视为他们的开发目标。教育、工具和培训都支持支持更多浏览器更好的前提（[*其他条件不变下*](https://en.wikipedia.org/wiki/Ceteris_paribus#Economics)），这为润滑吱吱作响的轮子创造了巨大的动力。因此，缩小领先浏览器和落后浏览器之间的差距是 Web 开发社区的一个重点。花费大量时间和精力为滞后引擎开发变通方法（最好是低运行成本）<sup>[5]</sup>。在变通方法失败的情况下，削减功能和 UI 保真度被认为是正确的做法。

跨引擎的兼容性是开发者生产力的关键。如果一个引擎拥有（或大约拥有）超过 10% 的份额，开发者倾向于将其缺乏的功能视为“未准备好”。因此，有可能会因为无法带来这些功能而在在全球范围内拒绝 Web 开发者访问这些功能。

一个重要的、滞后的引擎可以通过这种方式降低整个网络的竞争力。

为了判断 iOS 在这个维度上的影响，我们可以尝试回答几个问题：

1. Safari 在正确性方面落后**两个**竞争引擎有多远？
2. 当 Safari 实现基本功能时，它多久领先一次？多久落后一次？

感谢 [Web 平台测试项目](https://web-platform-tests.org/) 和 [`wpt.fyi`](https://wpt.fyi)，我们为第一个问题能有所回答：

![仅在给定浏览器中失败的测试。越低越好。](https://infrequently.org/2021/04/progress-delayed/bsf.webp)
<small>仅在给定浏览器中失败的测试。越低越好。</small>

黄色的 Safari 线粗略地衡量了其他浏览器兼容的频率，但 Safari 的实现是错误的。相反，低得多的 Chrome 和 Firefox 行表明 Blink 和 Gecko 更有可能在核心网络标准方面达成一致和正确<sup>[6]</sup>。

[`wpt.fyi` 的新 Compat 2021](https://wpt.fyi/compat2021?feature=summary&stable) 仪表板将这个完整的测试范围缩小到一个[选择代表最痛苦的兼容性错误的子集](https://web.dev/compat2021/#choosing-what-to-focus-on)：

![随着时间的推移，稳定通道的 Compat 2021 结果。越高越好。](https://infrequently.org/2021/04/progress-delayed/compat_21_stable.png)
<small>随着时间的推移，稳定通道的 Compat 2021 结果。越高越好。</small>

![Tip-of-tree 改进在 WebKit 中可见。可悲的是，这些需要四分之一的时间才能到达设备，因为 Apple 将 WebKit 功能与操作系统发布的缓慢节奏联系起来。](https://infrequently.org/2021/04/progress-delayed/compat_21_exp.png)

在 WebKit 中可以看到最近有所改进。可悲的是，这些功能需要大概一个季度的时间才能被用户用上，因为 Apple 将 WebKit 功能与操作系统发布的缓慢节奏联系在一起。

几乎在每个领域，Apple 对 **WebKit 上的功能的支持**的低质量实现都需要变通方法。开发者无需在 Firefox（Gecko）或 Chrome/Edge/Brave/Samsung Internet（Blink）中查找和修复这些问题。这增加了为 iOS 开发的费用。

## 聚合视图

[Web Confluence Metrics](https://web-confluence.appspot.com/#!/) 项目提供了另一个了解这个问题的途径。

该数据集是[通过遍历暴露于 JavaScript 的 Web 平台特征树导出的](https://github.com/GoogleChromeLabs/confluence/blob/master/CatalogDataCollection.md#what-data-are-collected)，一个重要的子集的特点。可用数据进一步追溯，更全面地了解发动机完整性的趋势线。

引擎以不同的速度添加功能，[Confluence 图](https://web-confluence.appspot.com/#!/confluence)阐明了差异的绝对规模和版本添加新功能的速度。数据很难在这些图表之间进行比较，因此我提取了它以生成一个[一张图表](https://infrequently.org/2021/04/progress-delayed/confluence_data/index.html)：

![](https://infrequently.org/2021/04/progress-delayed/confluence_data/rates.svg)
<small>蓝色：Chrome，红色：Firefox，黄色：Safari</small>
<small>[Web Confluence](https://web-confluence.appspot.com/#!/confluence) 从 JavaScript 提供的 API 数量。越高越好。</small>

根据 Web Platform Tests 数据，Chromium 和 Firefox 实现了更多功能并更稳定地将它们推向市场。从这个数据我们可以看出，iOS 是 Web 平台最不完整和竞争力的实现，而且差距越来越大。在上次 Confluence 运行时，差距已经扩大到近 1000 个 API，自 2016 年以来翻了一番。

也许计算 API 会产生扭曲的观点？

一些小的添加（例如 [CSS 的新类型化对象模型](https://developers.google.com/web/updates/2018/03/cssom)可能会在 API 表面进行大的扩展。同样，一些变革性的 API（例如 [通过 `getUserMedia()` 访问网络摄像头](https://www.html5rocks.com/en/tutorials/getusermedia/intro/) 或 [Media Sessions](https://web.dev/media-session/)）可能只会添加一些方法和属性。

要了解 Web Confluence 数据形成的直觉在方向上是否正确，我们需要更深入地查看功能开发的历史并将 API 与它们启用的应用程序类型联系起来。

## 重大影响

浏览器发行说明和 [caniuse](https://caniuse.com/) 表格自 [Blink 在 2013 年从 WebKit 独立后](https://www.zdnet.com/article/the-real-reason-why-google-forked-webkit/)<sup>[7]</sup> 在比 WPT 或 Confluence 数据集更长的时间内捕获每个引擎中特征的到达。此记录可以让我们更深入地了解单个功能和**一组**功能如何解锁新型应用程序。

浏览器有时会同时启动新功能（例如，[CSS Grid](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout) 和 [ES6](https://caniuse.com/?search=es6))。更常见的是，第一个和其余的之间存在滞后。为了提供相当大的“宽限期”，并考虑引擎优先级的短期差异，我们主要关注**三年或更长时间**<sup>[8]</sup>的功能。

接下来是对这个时代推出的功能进行全面统计的尝试。每个 API 的摘要及其缺失的影响都伴随着每个项目。

### Chrome 落后的地方

引擎有不同的优先级是健康的，导致每个浏览器都避免某些功能。Chrome 已经错过了 3 年多的几个 API：

#### [存储访问 Storage Access API](https://developer.mozilla.org/en-US/docs/Web/API/Storage_Access_API)

三年前在 Safari 中引入，此反跟踪 API 未指定，导致 [跨实现的 API 行为存在显着差异](https://developer.mozilla.org/en-US/docs/Web/API/Storage_Access_API#safari_implementation_differences)。苹果最初版本的“智能跟踪预防”质量低下[创造了*一个更糟糕的*跟踪向量](https://storage.googleapis.com/pub-tools-public-publication-data/pdf/7450c395e2d3ca583b24f0b8fbf704aa3c781692.pdf)（[随后有了修复](https://support.apple.com/en-us/HT210792)）<sup>[9]</sup>。

从积极的一面来看，这引发了围绕网络隐私的更广泛对话，从而产生了[许多新的、更明确的提议](https://github.com/privacycg) 和[提议的模型](https://web.dev/digging-into-the-privacy-sandbox/)。

#### [CSS Snappoints](https://caniuse.com/css-snappoints)

使用此功能构建图像轮播和其他基于触摸的 UI 会更流畅、更容易。Blink 团队内部关于交付此与 [Animation Worklets](https://developers.google.com/web/updates/2018/10/animation-worklet) 的正确顺序的分歧导致了令人遗憾的延迟。

#### [CSS Initial Letter](https://caniuse.com/css-initial-letter)

[LayoutNG 项目](https://developers.google.com/web/updates/2019/06/layoutNG) 完成后，在 Blink 中计划的高级排版功能。

#### [`position:sticky`](https://www.chromestatus.com/feature/6190250464378880)

使基于滚动的 UI 中的“固定”元素更容易构建。最初的实现从 Blink post-fork 中删除，几年后在新的基础设施上重新实现。

#### [CSS `color()`](https://css-tricks.com/wide-gamut-color-in-css-with-display-p3/)

广色域颜色在创意应用中很重要。Chrome 尚不在这一点上支持 CSS，但 [正在为 `<canvas>` 和 WebGL 开发](https://chromestatus.com/feature/5701580166791168)。

#### JPEG 2000

[许可问题](http://en.swpat.org/wiki/JPEG_2000) 导致 [Chrome 转而使用 WebP](https://developers.google.com/speed/webp/docs/c_study)。

#### [HEVC/H.265](https://caniuse.com/hevc)

许多现代芯片都支持下一代视频编解码器，但也是许可雷区。开放的、免版税的编解码器 [AV1](https://en.wikipedia.org/wiki/AV1) 已[交付](https://caniuse.com/av1)。

### iOS 落后的地方

此列表中的某些功能在 Safari 中启动，但未为其他浏览器启用 [被迫在 iOS 上使用 WebKit](https://developer.apple.com/app-store/review/guidelines/#:~:text=2.5.6%20Apps%20that%20browse%20the%20web%20must%20use%20the%20appropriate%20WebKit%20framework%20and%20WebKit%20Javascript.)（例如 [Service Workers](https://developers.google.com/web/fundamentals/primers/service-workers)、[`getUserMedia`](https://developers.google.com/web/fundamentals/media/recording-video))。在这些情况下，只考虑在 Safari 中交付的延迟。

#### [`getUserMedia()`](https://developers.google.com/web/fundamentals/media/recording-video)

[提供对网络摄像头的访问](https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia) 是构建有竞争力的视频体验所必需的，包括消息传递和视频会议。

这些类别的应用程序在 iOS Web 上延迟了五年才出现。

#### [WebRTC](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API)

用于启用视频会议、桌面共享和游戏流应用程序的实时网络协议。

耽误了五年。

#### [游戏手柄 API](https://caniuse.com/?search=gamepad%20api)

支持游戏流 PWA（Stadia、GeForce NOW、Luna、xCloud）现在到达 iOS 的基础。

耽误了五年。

#### [音频工作集](https://developers.google.com/web/updates/2017/12/audio-worklet)

Audio Worklet 是网络上富媒体和游戏的基本推动者。结合 WebGL2/WebGPU 和 WASM 线程（见下文），Audio Worklets 可以释放更多设备的可用计算能力，从而产生始终如一的良好声音而无需担心出现故障。

经过多年的标准讨论并于 2018 年首次交付给其他平台，iOS 14.5 终于在**本周**发布了 Audio Worklets。

#### [IndexedDB](https://developers.google.com/web/ilt/pwa/working-with-indexeddb)

在 Web 开发者心目中是名副其实的 [Safari 迟到和低质量的典型](https://arstechnica.com/information-technology/2015/06/op-ed-safari-is-the-new-internet-explorer/)。IndexedDB 是传统的 [WebSQL API](http://html5doctor.com/introducing-web-sql-databases/) 的现代替代品。它为开发者提供了一种在本地存储复杂数据的方法。

最初 [延迟两年](https://caniuse.com/indexeddb)，该功能的第一个版本[在 iOS 上严重地无法使用](https://www.raymondcamden.com/2014/09/25/IndexedDB-on-iOS-8-Broken-Bad/)，独立开发者开始[维护一列表的显示错误](https://gist.github.com/nolanlawson/08eb857c6b17a30c1b26)。

如果 Apple 在前两次尝试中的任何一次中都发布了可用版本，IndexedDB 就不会晚那三年才可以正常使用 —— iOS 10 的发布终于提供了一个可行的版本 —— 相较于 Chrome 和 Firefox 的滞后时间则分别拉到了四年和五年。

#### [Pointerlock](https://caniuse.com/pointerlock)

用鼠标玩游戏的关键。仍然不适用于 iOS 或 iPadOS。

#### [Media Recorder](https://developers.google.com/web/updates/2016/01/mediarecorder)

从根本上支持视频创作应用程序。没有它，视频记录必须记录进内存中，从而导致崩溃。

这是 Chrome *曾经*（以星级衡量）最受期待的开发者功能。它被 iOS 推迟了五年。

#### [指针事件](https://developers.google.com/web/updates/2016/10/pointer-events)

[用于处理用户输入的统一 API](https://developers.google.com/web/updates/2016/10/pointer-events)，例如鼠标移动和屏幕点击，这对于使内容适应移动设备很重要, [特别是关于多点触控手势](https://javascript.info/pointer-events)。

最初由微软提出，被苹果推迟了三年<sup>[10]</sup>。

#### [Service Worker](https://web.dev/service-worker-mindset/)

支持现代、可靠的离线 Web 体验和 PWA 的关键 API。

延迟了三年（[Chrome 40，2014 年 11 月](https://blog.chromium.org/2014/12/chrome-40-beta-powerful-offline-and.html) 与 [Safari 11.1，2018 年 4 月](https://webkit.org/blog/8216/new-webkit-features-in-safari-11-1/)，但直到几个版本之后才可用）。

#### [WebM 和 VP8/VP9](https://caniuse.com/?search=webm)

免版税的编解码器和容器；具有竞争力的压缩和功能的 H.264/H.265 的免费替代品。缺乏支持迫使开发者花费时间和金钱对多种格式（除了多种比特率）进行转码和服务。

它们仅支持在 WebRTC 中使用，而不支持用于媒体播放的常用方法（`<audio>` 和 `<video>`）。

#### [CSS 类型对象模型](https://developer.mozilla.org/en-US/docs/Web/API/CSS_Typed_OM_API)

[高性能](https://github.com/w3c/css-houdini-drafts/issues/634#issuecomment-366358609)给元素添加样式的[接口](https://developers.google.com/web/updates/2018/03/cssom)。[启用了](https://bugs.webkit.org/showdependencytree.cgi?id=190217&hide_resolved=0) 其他 [“Houdini” 功能，如 CSS 自定义绘制功能](https://www.smashingmagazine.com/2020/03/practical-overview-css-houdini/)的基础。

不适用于 iOS。

#### [CSS Containment](https://www.smashingmagazine.com/2019/12/browsers-containment-css-contain-property/)

在渲染 UI 中[启用始终如一的高性能](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Containment) 的功能，以及[新功能](https://web.dev/content-visibility/)可以显着提高大页面和应用程序的性能。

不适用于 iOS。

#### [CSS 运动路径](https://www.infoq.com/news/2020/02/css-motion-path-browser-support/)

启用[不使用 JavaScript 的复杂动画](https://blog.logrocket.com/css-motion-path-the-end-of-gsap/)。

[不适用于 iOS](https://caniuse.com/css-motion-paths)。

#### [媒体源 API（又名“MSE”）](https://developers.google.com/web/fundamentals/media/mse/basics)

MSE 启用 [`MPEG-DASH`](https://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP) 视频流协议。Apple 提供了 [HLS](https://developer.apple.com/streaming/) 的实现，但禁止使用替代方案。

仅适用于 iPadOS。

#### [`element.animate()`](https://hacks.mozilla.org/2016/08/animating-like-you-just-dont-care-with-element-animate/)

浏览器对完整 Web Animations API 的支持一直很不稳定，Chromium、Firefox 和 Safari [去年都完成了对完整规范的支持](https://caniuse.com/web-animation)。

`element.animate()` 是完整 API 的一个子集，使开发者能够更轻松地创建 [高性能视觉效果](https://developers.google.com/web/updates/2014/05/Web-Animations-element-animate-is-now-in-Chrome-36) 自 2014 年以来在 Chrome 和 Firefox 中视觉卡顿的风险较低。

#### [`EventTarget` 构造函数](https://twitter.com/passle_/status/1246468359589412870)

看似微不足道，但很基础。它能让开发者与浏览器的内部消息传递机制集成。

在 iOS 上延迟了近三年。

#### Web 性能 API

iOS 始终无法提供现代 API 来衡量三年或更长时间的 Web 性能。延迟或缺失的功能不限于：

* [`navigator.sendBeacon()`](https://developers.google.com/web/updates/2014/10/Send-beacon-data-in-Chrome-39)
* [Paint Timing](https://web.dev/fcp/) ([延迟](https://chromestatus.com/feature/5688621814251520) [两到四年](https://webkit.org/blog/11648/new-webkit-features-in-safari-14-1/))
* [用户计时](https://www.html5rocks.com/en/tutorials/webperformance/usertiming/)
* [资源计时](https://developers.google.com/web/fundamentals/performance/navigation-and-resource-timing)
* [性能观察者](https://developers.google.com/web/updates/2016/06/performance-observer)

缺少 Web 性能 API 的影响在很大程度上是一个规模问题：一个人尝试在 Web 上提供的站点或服务越大，衡量标准就变得越重要。

#### [`fetch()`](https://caniuse.com/fetch) 和 [Streams](https://caniuse.com/mdn-api_readablestream)

[在某些情况下显着提高性能](https://jakearchibald.com/2016/streams-ftw/) 的现代异步网络 API。

延迟两到四年，具体取决于如何计算。

并非 iOS 上被阻止或延迟的每个功能都具有变革性，此列表忽略了泡沫中的案例（例如，[BigInt](https://v8.dev/features/bigint) 的 2.5 年滞后）。综上所述，即使对于低争议的 API，Apple 产生的延迟也使得企业难以将 Web 视为一个严肃的开发平台。

### 代价

假设 Apple 及时实施了 WebRTC 和 Gamepad API。谁能说现在正在发生的[游戏流媒体革命](https://pocketnow.com/apple-says-cloud-gaming-services-like-stadia-and-xcloud-violate-app-store-policies)发生得更早？ [Amazon Luna](https://www.theverge.com/2020/10/20/21525339/amazon-luna-hands-on-cloud-gaming-streaming-early-access-price-games)、[NVIDIA GeForce NOW](https://pocketnow.com/nvidias-game-streaming-service-arrives-on-ios-googles-stadia-is-next-in-line)、[Google Stadia](https://www.macworld.com/article/234952/googles-stadia-game-streaming-service-is-now-available-on-ios-via-web-app.html) 和 [Microsoft xCloud](https://www.theverge.com/2021/4/20/22393793/microsoft-xbox-cloud-gaming-xcloud-iphone-ipad-hands-on) 本可以早几年建成。

也有可能在所有其他平台上提供但尚未在*任何* iOS 浏览器（因为 Apple）上可用的 API 可能会在网络上解锁整个类别的体验。

虽然 Apple 目前或预计将延迟多年的数十项功能，但一些影响较大的功能值得特别提及：

#### [WebGL2](https://webgl2fundamentals.org/webgl/lessons/webgl2-whats-new.html)

Apple 目前持有的两个现代 3D 图形 API 中的第一个 [WebGL2](https://hacks.mozilla.org/2017/01/webgl-2-lands-in-firefox/) 显着提高了 3D 的视觉保真度网络上的应用程序，包括游戏。 [OpenGL ES 3.0] (https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/BestPracticesforAppleA7GPUsandLater/BestPracticesforAppleA7GPUsandLater.html) 的底层图形功能[自 20103 年起在 iOS 中可用]（https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/AdoptingOpenGLES3/AdoptingOpenGLES3.html#//apple_ref/doc/uid/TP40008793-CH504-SW4）。 WebGL 2 在 [Chrome 和 Firefox 于 2017 年](https://caniuse.com/webgl2) 上针对其他平台推出。虽然 WebGL2 [正在 WebKit 中开发](https://webkit.org/status/#specification-webgl-2)，但这些功能的预期端到端延迟已接近五年。

#### [WebGPU](https://hacks.mozilla.org/2020/04/experimental-webgpu-in-firefox/)

WebGPU 是 WebGL 和 WebGL2 的继任者，通过更好地与下一代对齐[提高图形性能](https://www.construct.net/en/blogs/ashleys-blog-2/webgl-webgpu-construct-1519)低级图形 API（[Vulkan](https://www.khronos.org/vulkan/)、[Direct3D 12](https://en.wikipedia.org/wiki/Direct3D#Direct3D_12) 和 [Metal](https://en.wikipedia.org/wiki/Metal_(API)))。

WebGPU 还将为网络解锁更丰富的 [GPU 计算](https://developers.google.com/web/updates/2019/08/get-started-with-gpu-compute-on-the-web#performance_findings)，加速了[机器学习](https://medium.com/octoml/webgpu-powered-machine-learning-in-the-browser-with-apache-tvm-3e5d79c77618)和媒体应用程序。WebGPU 很可能会在 2021 年末在 Chrome 中发布。尽管标准机构在 Apple 工程师的要求下推迟了多年，但 iOS 上的 WebGPU 的时间表尚不清楚。敏锐的观察家预计至少会出现几年的额外延迟。

#### [WASM 线程](https://medium.com/google-earth/performance-of-web-assembly-a-thread-on-threading-54f62fd50cf7) 和 [共享数组缓冲区](https://caniuse.com/mdn-javascript_builtins_sharedarraybuffer)

现在所有浏览器都支持 Web Assembly（“WASM”），但 iOS 缺少“线程”（一起使用多个处理器内核的能力）的扩展。

对线程的支持可以实现[更丰富、更流畅的 3D 体验](https://www.youtube.com/watch?v=khM7iilBgc0)、游戏、AR/VR 应用程序、创意工具、模拟和科学计算。此功能的历史很复杂，但是长话短说，[它们现在可供选择加入的网站使用](https://web.dev/coop-coep/)（在除 iOS 之外的每个平台上）。更糟糕的是，iOS 在这个项目上没有安排，而且它们很快就会问世的希望很小。

结合 Audio Worklets、现代图形 API 和 Offscreen Canvas 的延迟，拥有 iOS 设备的许多令人信服的理由已无法在网络上提供。<sup>[11]</sup>

#### [WebXR](https://immersiveweb.dev/)

在多年毫无音讯后[现在正在 WebKit 中开发](https://bugs.webkit.org/showdependencytree.cgi?id=208988&hide_resolved=1)，[WebXR API](https://web.dev/vr-comes-to-the-web/) 向 Web 应用程序提供增强现实和虚拟现实输入和场景信息。结合（延迟的）高级图形 API 和线程支持，WebXR 可在网络上实现沉浸式、低摩擦的商务和娱乐。

[多年来](https://caniuse.com/webxr)已在其他平台的领先浏览器中支持越来越多的这些功能。Apple 没有规定 Web 开发者何时可以向 iOS 用户（在任何浏览器中）提供同等体验的时间表。

这些遗漏意味着 Web 开发者无法在游戏、购物和创意工具等类别中与 iOS 上的本地应用程序同行竞争。

开发者在引入原生功能和相应的浏览器 API 之间[预计 **一些** 滞后](https://infrequently.org/2020/06/platform-adjacency-theory/)。Apple 反对浏览器引擎选择的政策增加了多年的延迟**超出**设计迭代、规范编写和浏览器功能开发的（预期）延迟。

这些延迟会阻止开发者接触到具有丰富网络体验的富有用户。这种差距是由 Apple 政策独家创造的，几乎迫使企业离开网络并进入 App Store，在那里 Apple [阻止开发者通过网络体验接触用户](https://developer.apple.com/app-store/review/guide/#:~:text=your%20app%20should%20include%20features,%20content,%20and%20ui%20that%20elevate%20it%20beyond%20a%20repackaged%20website.)。

### 只是遥不可及

人们可能会想象，3D、媒体和游戏的五年延迟可能是 Apple 阻止浏览器引擎进步的政策的最严重影响。那将是错误的。

下一层缺失的功能是标准组织中相对没有争议的提案，Apple 参与了这些提案，或者得到了 Web 开发者的足够支持，可以“毫不费力”。每个都可以实现更高质量的网络应用程序。预计很快不会在 iOS 上出现：

#### [Scroll TImeline](https://flackr.github.io/scroll-timeline/demo/parallax/) 用于 CSS 和 Web 动画

可能会在今年晚些时候在 Chromium 中发布，支持基于滚动和滑动的流畅动画，这是现代移动设备上的关键交互模式。

Apple 没有透露 iOS 上的 Web 开发者是否或何时可以使用此功能。

#### `content-visibility`

[显着提高渲染性能](https://web.dev/content-visibility/) 的 CSS 扩展，适用于大页面和复杂的应用程序。

#### [WASM SIMD](https://robaboukhalil.medium.com/webassembly-and-simd-7a7daa4f2ecd)

下个月将推出的 Chrome 支持 [WASM SIMD 启用高性能向量数学](https://v8.dev/features/simd)和[显着提高性能](https://www.infoq.com/articles/webassembly-simd-multithreading-performance-gains/)，适用于许多媒体、ML 和 3D 应用程序。

#### [与表单相关的 Web 组件](https://web.dev/more-capable-form-controls/)

减少 Web 表单中的数据丢失并使组件能够跨项目和站点轻松重用。

#### [CSS 自定义绘制](https://houdini.how/)

有效启用[网络上绘制内容的新样式](https://bobrov.dev/css-paint-demos/)，消除了[视觉丰富度](https://houdini.how/)、可访问性之间的许多艰难权衡，和性能。

#### [可信类型](https://web.dev/trusted-types/)

一种方法的标准版本 [在 Google 的网络应用程序中展示以显着提高安全性](https://security.googleblog.com/2020/07/towards-native-security-defenses-for.html)。

#### [CSS 容器查询](https://css-tricks.com/say-hello-to-css-container-queries/)

来自 Web 开发者和 [预计今年晚些时候在 Chrome 中](https://bugs.chromium.org/p/chromium/issues/detail?id=1145970) 的最高要求，CSS 容器查询使内容能够[更好地适应不同的设备外形因素](https://piccalil.li/blog/container-queries-are-actually-coming)。

#### [`<dialog>`](https://css-tricks.com/some-hands-on-with-the-html-dialog-element/)

通用 UI 模式的内置机制，提高了性能和一致性。

#### [`inert` 属性](https://css-tricks.com/focus-management-and-inert/#enter-inert)

改进焦点管理和可访问性。

#### [浏览器辅助延迟加载](https://web.dev/lazy-loading-images/#images-inline-browser-level)

减少数据使用并提高页面加载性能。

这些功能中的基础功能较少（例如 SIMD）。然而，即使是那些可以通过其他方式模拟的内容，仍然会向开发者和 iOS 用户强加成本，以弥补 Apple 在 Web 平台实施中的差距。这种成本可能会在不小心的情况下[其他平台上的用户体验缓慢](https://www.debugbear.com/blog/how-does-browser-support-impact-bundle-size)以及<sup>[12]</sup>。

### 可能是什么

除了这些相对无争议的（MIA）特征之外，还有一片被取消抵押品赎回权的可能性。如果苹果愿意允许 MacOS 用户喜欢的那种针对 iOS 的诚实浏览器竞争，这样的功能将支持全新的 Web 应用程序类别。也许这就是问题所在。

Apple 正在阻止*任何*浏览器提供给 iOS 的一些关键功能（在所有其他操作系统上提供），没有特定的顺序：

#### [推送通知](https://developers.google.com/web/fundamentals/push-notifications)

在反网络守门的令人震惊的展示中，Apple 已经为 iOS *既没有* 实现了长期标准的 [Web Push API](https://web.dev/push-notifications-overview/) *也没有* [Apple 的自己的](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/NotificationProgrammingGuideForWebsites/Introduction/Introduction.html)，还有完全专有的 [MacOS Safari 推送通知系统](https://developer.apple.com/notifications/safari-push-notifications/)

在现代移动平台上缺乏推送通知所带来的挑战怎么强调都不为过。跨类别的开发者报告缺乏推送通知是杀手，包括：

* 聊天、消息传递和社交应用程序（出于显而易见的原因）
* [电子商务](https://developers.google.com/web/showcase/2015/beyond-the-rack)（购物车提醒、发货更新等）
* 新闻发布者（突发新闻警报）
* 旅行（行程更新和一目了然的信息）
* [骑行分享](https://developers.google.com/web/showcase/2017/ola)和快递（状态更新）

这种遗漏已经在网络的水箱中放了沙子 —— 这对 Apple 的原生平台有利，该平台[已享受推送通知支持 12 年了](https://en.wikipedia.org/wiki/Apple_Push_Notification_service)。

#### [PWA 安装提示](https://developer.mozilla.org/en-US/docs/Web/Progressive_web_apps/Add_to_home_screen)

早在 iOS 上，Apple 就率先推出了[支持将某些 Web 应用程序安装到设备的主屏幕](https://developer.apple.com/library/archive/documentation/AppleApplications/Reference/SafariWebContent/ConfiguringWebApplications/ConfiguringWebApplications.html) 1.0 版本，但自 2007 年以来，对这些功能的支持几乎没有改善。

随后，Apple [增加了促进原生应用安装的能力](https://developer.apple.com/documentation/webkit/promoting_apps_with_smart_app_banners)，但并未提供对等的网络应用“安装提示”工具。

同时，其他平台的浏览器也开发了[环境（浏览器提供）推广](https://web.dev/promote-install/#browser-promotion)和[程序化机制](https://web.dev/customize-install/)来指导用户将常用的 Web 内容保存到他们的设备中。

Apple 维护原生和 Web 之间的此功能差距（尽管对该机制有明确的底层支持）并且不愿意让其他 iOS 浏览器改善这种情况<sup>[13]</sup>，并结合 App Store 防止放置 Web 中的内容的策略，非常重视发现使用 Apple 专有 API 构建的内容。

#### [PWA 应用程序图标标记](https://web.dev/badging-api/)

提供对“未读消息计数”的支持，例如用于电子邮件和聊天程序。不适用于添加到 iOS 主屏幕的网络应用程序。

#### [媒体会话 API](https://firt.dev/ios-14.5/#background-audio)

使网络应用程序能够在后台播放媒体。它还允许开发者插入（和配置）用于后退/前进/播放/暂停/等的系统控件。并提供曲目元数据（标题、专辑、封面）。

缺少此功能会阻止整个类别的媒体应用程序（播客和音乐应用程序，如 Spotify）变得合理。

[正在开发中](https://firt.dev/ios-14.5/#:~:text=but%20there%20is%20one%20hope%3A%20the%20media%20session%20api%20is%20now%20available%20as%20an%20experiment)，但如果它在今年秋天（最早的窗口）发布，网络媒体应用程序将被推迟五年以上。

#### [导航预加载](https://developers.google.com/web/updates/2017/02/navigation-preload)

可以用于 [Service Workers](https://developers.google.com/web/fundamentals/primers/service-workers) 以在提供离线体验的网站上显着提高页面加载性能。

多个排名前 10 的网络资产向 Apple 报告称，缺少此功能会阻止他们为用户部署更具弹性的体验版本（包括在 iOS 上构建 [PWA](https://web.dev/progressive-web-apps/)）。

#### [屏幕外画布](https://medium.com/samsung-internet-dev/offscreencanvas-workers-and-performance-3023ca15d7c7)

通过将渲染工作移至单独的线程，提高 3D 和媒体应用程序的流畅度。对于 XR 和游戏等对延迟敏感的用例，此功能对于始终如一地提供有竞争力的体验是必要的。

#### `TextEncoderStream` & `TextDecoderStream`

这些 [TransformStream 类型](https://github.com/ricea/encoding-streams/blob/master/stream-explainer.md) 帮助应用程序有效地处理大量二进制数据。[他们*可能*已在 iOS 14.5 中发布](https://firt.dev/ios-14.5/)但[发行说明含糊不清](https://webkit.org/blog/11648/new-webkit-features-in-safari-14-1/)。

#### [`requestVideoFrameCallback()`](https://blog.tomaac.com/2020/05/15/the-requestvideoframecallback-api/)

帮助网络上的媒体应用程序在进行视频处理时节省电池电量。

#### [压缩流](https://github.com/wicg/compression/blob/main/explainer.md)

使开发者无需向浏览器下载大量代码即可高效压缩数据。

#### [键盘锁API](https://web.dev/keyboard-lock/)

远程桌面应用程序的重要组成部分和一些连接键盘的游戏流场景（对 [iPadOS 用户而言并不少见](https://www.apple.com/shop/ipad/accessories/keyboards)）。

#### [声明式影子 DOM](https://web.dev/declarative-shadow-dom/)

[Web Components](https://www.webcomponents.org/introduction) 系统的补充，为 YouTube 和 Apple Music 等应用程序提供支持。声明式 Shadow DOM 可以[提高加载性能](https://github.com/mfreed7/declarative-shadow-dom/blob/master/README.md#performance)并帮助开发者在脚本被禁用或无法加载时为用户提供 UI 加载。

#### [Reporting API](https://developer.mozilla.org/en-US/docs/Web/API/Reporting_API)

对于提高网站质量和避免因浏览器弃用而造成的破坏必不可少。更新的版本[也能让开发者知道应用程序何时崩溃](https://developer.mozilla.org/en-US/docs/Web/API/CrashReportBody)，帮助他们诊断和修复损坏的站点。

#### [权限 API](https://developers.google.com/web/updates/2015/04/permissions-api-for-the-web)

帮助开发者呈现更好、更具上下文的选项和提示，减少用户烦恼和“提示垃圾邮件”。

#### [屏幕唤醒](https://web.dev/wake-lock/)

防止屏幕变暗或屏幕保护程序接管。对于提供登机牌和用于扫描的 QR 码的应用程序以及演示应用程序（例如 PowerPoint 或 Google 幻灯片）很重要。

#### [Intersection Observer V2](https://web.dev/intersectionobserver-v2/)

减少广告欺诈并启用一键注册流程，从而提高商业转化率。

#### [内容索引](https://web.dev/content-indexing-api/)

Service Workers 的一个扩展，它使浏览器能够在离线时向用户呈现缓存的内容。

#### [AV1/AVIF](https://developer.mozilla.org/en-US/docs/Web/Media/Formats/Video_codecs#:~:text=the%20aomedia%20video%201%20(av1)%20codec%20is%20an%20open%20format%20designed%20by%20the%20alliance%20for%20open%20media%20specifically%20for%20internet%20video.)

现代的无成本的视频编解码器，在 Safari 之外几乎得到普遍支持。

#### [PWA 应用程序快捷方式](https://web.dev/app-shortcuts/)

允许开发者为安装到主屏幕或 Dock 的 Web 应用程序配置“长按”或“右键单击”选项。

#### [Shared Workers](https://developer.mozilla.org/en-US/docs/Web/API/SharedWorker) 和 [广播频道](https://developers.google.com/web/updates/2016/09/broadcastchannel)

协调 API 允许应用程序节省内存和处理能力（尽管最常见的是台式机和平板电脑外形）。

#### [`getInstalledRelatedApps()`](https://web.dev/get-installed-related-apps/)

帮助开发者避免提示用户输入可能与系统上已有的应用程序重复的权限。对于避免重复推送通知尤其重要。

#### [后台同步](https://developers.google.com/web/updates/2015/12/background-sync)

一种在网络连接断断续续的情况下可靠地发送数据（例如聊天和电子邮件消息）的工具。

#### [后台 fetch API](https://www.youtube.com/watch?v=cElAoxhQz6w)

允许应用程序通过进度指示器和控件[高效地上传和下载批量媒体](https://developers.google.com/web/updates/2018/12/background-fetch)。对于可靠地同步音乐或视频播放列表以供离线或同步照片/媒体以进行共享非常重要。

#### [定期后台同步](https://web.dev/periodic-background-sync/)

帮助应用程序确保它们有新鲜的内容以对电池和带宽敏感的方式离线显示。

#### [网络共享目标](https://web.dev/web-share-target/)

允许已安装的网络应用程序通过系统用户界面**接收**共享请求，使聊天和社交媒体应用程序能够帮助用户更轻松地发布内容。

媒体、社交、电子商务、3d 应用程序和游戏缺少的基础 API 列表令人惊讶。由于 Apple 创造并延续的功能差距，App Store 中最受欢迎的类别中的基本应用程序无法在 iOS 上的网络上尝试。

### 设备 API：最后的前沿

浏览器制造商强烈反对，但基于 Chromium 的浏览器（Chrome、Edge、三星互联网、Opera、UC 等）取得进展的领域是对硬件设备的访问。虽然对于大多数“传统”网络应用程序来说不是必不可少的，但这些功能是教育和创意音乐应用程序等充满活力的类别的基础。 iOS Safari 目前不支持这些应用程序，而其他操作系统上的 Chromium 浏览器可在网络上启用这些应用程序：

#### [网络蓝牙](https://web.dev/bluetooth/)

允许低功耗蓝牙设备安全地与 Web 应用程序通信，无需下载重量级应用程序来配置单个 IoT 设备。

#### [Web MIDI](https://www.smashingmagazine.com/2018/03/web-midi-api/)

在网络上启用创意音乐应用程序，包括合成器、混音套件、鼓机和音乐录制。

#### [Web USB](https://web.dev/usb/)

提供从 Web 对 USB 设备的安全访问，在浏览器中启用新类别的应用程序，从 [教育](https://www.microsoft.com/en-us/makecode) 到 [软件开发](https://flash.android.com/welcome) 和 [调试](https://app.vysor.io/#/)。

#### [网络串行](https://web.dev/serial/)

支持与旧设备的连接。在工业、物联网、医疗保健和教育场景中尤为重要。

Web Serial、Web Bluetooth 和 Web USB 使教育编程工具能够帮助学生学习对物理设备进行编程，包括 [LEGO](https://makecode.mindstorms.com/bluetooth)。

独立开发者 [Henrik Jorteg](https://twitter.com/HenrikJoreteg) [详细阐述了由于无法在 iOS 上访问这些功能而引起的挫败感](https://joreteg.com/blog/project-fugu-a-new-hope)，并[证明了他们实现低成本开发的方式](https://www.youtube.com/watch?v=14pb8t1lHws&t=1640s)。iOS 上缺少 Web API 不仅让开发者感到沮丧。它推高了商品和服务的价格，减少了可以提供这些服务的组织数量。

#### [Web HID](https://web.dev/hid-examples/)

启用安全连接到输入 [设备](https://github.com/robatwilliams/awesome-webhid#devices) 传统上不支持作为键盘、鼠标或游戏手柄。

此 API 通过它们已经支持的标准协议提供对小众硬件的专用功能的安全访问，无需专有软件或不安全的原生二进制下载。

#### [Web NFC](https://web.dev/nfc/)

让网络应用程序安全地读取和写入 NFC 标签，例如用于点击支付应用程序。

#### [形状检测](https://web.dev/shape-detection/)

Unlocks 平台和操作系统提供了对条形码、面部、图像和视频中的文本进行高性能识别的功能。

在视频会议、商务和 IoT 设置场景中很重要。

#### [通用传感器 API](https://web.dev/generic-sensor/)

用于访问手机中传感器标准的统一 API，包括陀螺仪、接近传感器、设备方向、加速度传感器、重力传感器和环境光检测器。

这个不穷尽的列表中的每个条目都可以阻止整个类别的应用程序在网络上可信地成为可能。现实世界的影响难以衡量。权衡无谓损失似乎是经济学家研究的一个好角度。初创企业没有尝试，服务没有建立，企业被迫多次开发原生应用程序的价格更高，也许可以估计。

## 不协调

数据一致地证明了：Apple 的 Web 引擎在兼容性和功能方面始终落后于其他引擎，导致与 Apple 的原生平台存在巨大且持续的差距。

Apple 希望我们接受：

* 强制 iOS 浏览器使用其 Web 引擎是合理的，要让 iOS 处于后沿。
* 对于对 App Store 政策不满意的开发者，Web 是 iOS 上的一个可行替代方案。

其中一个可能是合理的。或者两个？唔……

对数字生态系统健康感兴趣的各方应该忽略 Apple 的主张，并关注进步的不同速度。

---

***完全披露**：在过去的 12 年里，我一直在 Google 从事 Chromium 工作，跨越了前叉时代，在 WebKit 项目中讨论了 Chrome 和 Safari 的潜在功能，以及 [Post-Fork](https://techcrunch.com/2013/04/03/google-forks-webkit-and-launches-blink-its-own-rendering-engine-that-will-soon-power-chrome-and-chromeos/) 时代。在这段时间里，我领导了多个项目来向网络添加功能，其中一些遭到了 Safari 工程师的反对。*

*今天，我领导 [Project Fugu](https://web.dev/fugu-status/)，这是 Chromium 内部的一个协作项目，直接负责上述大多数设备 API。 Microsoft、Intel、Google、Samsung 和其他公司正在为这项工作做出贡献，并且正在公开进行，希望标准化，但我对其成功的兴趣很大。我的前排的位置让我可以毫不含糊地声明，独立软件开发者正在大声疾呼这些 API，但在他们向 Apple 请求支持时却被忽略了。无法为希望接触 iOS 用户的开发者（所有开发者）提供这些改进，这让我个人感到沮丧。我的兴趣和偏见是显而易见的。*

*之前，我曾帮助领导开发 Service Workers、推送通知和 PWA，克服了 Apple 工程师和经理们频繁而尖锐的反对意见。Service Worker 的设计起源于谷歌、Mozilla、三星、Facebook、微软和独立开发者之间的合作，旨在开发更好、更可靠的 Web 应用程序。Apple 仅在其他 Web 引擎交付工作实现后才加入该组织。对于 iOS 用户和有兴趣为他们提供良好服务的开发者而言，Service Workers 的可用性延迟（以及高度要求的后续功能，如导航预加载）同样带来了不可否认的个人记忆负担。*

---

1. iOS 的独特之处在于不允许网络参与其唯一的应用程序商店。 MacOS 的内置 App Store 有类似的反网络术语，但 MacOS 允许多个应用商店（例如 Steam 和 Epic Store），以及真正的浏览器选择。

   [Android](https://developer.chrome.com/docs/android/trusted-web-activity/overview/) 和 [Windows](https://docs.microsoft.com/en-us/microsoft-edge/progress-web-apps-chromium/microsoft-store) 直接在其默认商店中包含对网络应用程序的支持，允许多个商店，并促进真正的浏览器选择。 [↩︎](#fnref-progress-delayed-1)

2. 由于 Safari 和 WebKit 团队没有足够的人员配备，我们必须坚持要求 Apple 更改 iOS 政策，以允许竞争对手安全地填补 Apple 自己的肤浅选择造成的空白。 [↩︎](#fnref-progress-delayed-2)

3. 声称我（或其他 Chromium 贡献者）会很高兴看到引擎同质性的说法完全错误。

4. 一些评论者似乎混淆了与硬件不同的软件差异。例如，苹果*绝对杀死它*的领域是[CPU设计](https://infrequently.org/2021/03/the-performance-inequality-gap/#mind-the-gap)。由此产生的 [Speedometer](https://browserbench.org/Speedometer2.0/) 分数在旗舰 Android 和 iOS 设备之间的差异证明了苹果在移动 CPU 方面的霸气领先地位。

A 系列芯片已经围绕其他 ARM 部件运行了超过五年，主要是通过 [gobsmacking 数量的 L2/L3 缓存每个内核](https://twitter.com/slightlylate/status/1371325558806573056?s=20) . Apple 对 iOS 浏览器引擎选择的限制使得展示软件平价变得困难。 Safari 不能在 Android 上运行，Apple 也不允许在 iOS 上运行 Chromium。

   值得庆幸的是，M1 Mac 的出现使得从比较中消除硬件差异成为可能。十多年来，Apple 一直在缓存层次结构、分支预测、指令集和 GPU 设计方面做出权衡和独特的决策。相互竞争的浏览器制造商现在才开始探索这些差异并调整他们的引擎以充分利用它们。

   随着这一进程的进行，结果与英特尔的情况一致：Chromium 与 WebKit 大致一样快，在许多情况下还要快得多。

   与往常一样，性能分析的教训是，必须始终反复检查以确保您实际衡量您希望达到的目标。

1. 十年前，后缘浏览器主要是无法（或不会）升级的安装碎片。 [自动更新的无情游行](https://twitter.com/TheRealNooshu/status/1385598013037551617?s=20) 在很大程度上消除了这一障碍。 2021 年剩余的一组显着浏览器差异是以下因素组合的结果：

    * 浏览器更新率的市场特定差异；例如，新兴市场在浏览器发布日期和完全更换之间存在数月的额外延迟
    * 遗留浏览器持续存在的企业场景越来越少（例如，IE11）
    * 引擎之间功能支持的差异

   随着其他影响逐渐消失，最后一个出现。当先前版本的替代品缺乏开发者需要的功能时，自动更新的效果不如预期。尽管操作系统更新率很高，但 iOS 通过将 WebKit 领先优势的缺陷投射到*每个 iOS 设备上的每个浏览器*，从而破坏了整个网络。

2. 也许不言而喻，但 Firefox/Gecko 实现比 Safari/WebKit 更高质量的功能的倾向是 Apple 的一大黑眼圈。

   一个没有 [~2000 亿美元银行存款的开源项目](https://www.cnbc.com/2021/01/27/apple-q1-cash-hoard-heres-how-much-apple-has-on-hand.html) 正在做世界上最有价值的计算公司不会做的事情：投资浏览器质量并提供比 Apple 更兼容的引擎**跨更多的操作系统和平台*。

   这应该足以让 Apple 允许 Mozilla 在 iOS 上发布 Gecko。对于它对全球 Web 开发者的征税，他们不这样做就更加站不住脚了。

3. [MDN 浏览器兼容性数据库](https://developer.mozilla.org/en-US/docs/MDN/Structures/Compatibility_tables) 和 [caniuse 数据库](https://caniuse.com) 捕获的数据/) 通常是不完整的，有时是不正确的。

   在我意识到它们不准确的地方——通常与首次出现功能的版本有关——或者他们不同意的地方，已经参考了原始来源（浏览器发行说明、同期博客）来构建最准确的延迟图。

   尚未考虑“开发者预览版”、测试版分支或用户必须手动翻转的标志后面的功能的存在。基于一些明显的担忧，这是合理的：开发者不能指望该功能尚未完全发布，从而对市场产生任何潜在影响：

    * 某些功能在这些标志后面存在多年（例如 Safari 中的 WebGL2）。
    * 发布分支上尚不可用的功能可能仍会改变其 API 形状，这意味着开发者将面临昂贵的代码改动和重新测试以在此状态下支持它们。
    * 浏览器供应商普遍不鼓励用户手动启用实验标志

4. 由于 3 年以上的滞后截止时间，竞争引擎在许多未包含在此列表中的功能上领先 WebKit。

   数据显示，由于一部分特征以领先与落后的方式登陆，因此关注哪个时间范围并不重要。 WebKit 中领先/落后功能的比例保持相对稳定。省略较短时间段的原因之一是为了减少 Apple 无精打采的功能发布时间表的影响。

即使 Apple 的 [Tech Preview](https://developer.apple.com/safari/technology-preview/) 与 [Edge](https://www.microsoftedgeinsider.com/en- us/welcome)、[Chrome](https://www.google.com/chrome/beta/) 或 [Firefox](https://www.mozilla.org/en-US/firefox/channel/desktop/ ) Beta 版本，由于 Apple 引入新功能的独特缓慢方式，它们可能会延迟到达用户（并因此对开发者可用）。与每六周交付一次改进的领先引擎不同，Safari 中新功能的推出速度与 Apple 每年两次的 iOS 点发布节奏有关。在 2015 年之前，这种滞后通常与一整年一样严重。仅引用具有较长延迟的功能有助于消除此类发布节奏不​​匹配效应对 WebKit 的好处。

   对于 Cupertino 的案例来说，省略了少于三年的差距的特征是非常慷慨的。

1. Apple 强制 Web 引擎单一文化的一个影响是，与其他平台不同，影响 WebKit 的问题*也会影响 iOS 上的所有其他浏览器*。

   WebKit 中的安全问题导致整个操作系统暴露于只能以应用操作系统更新的速度修复的问题时，开发者不仅会遭受不受欢迎的统一质量问题，还会对用户产生负面影响。

2.  Apple 为 iOS 实施 Pointer Events 的三年延迟*另外*是由于 Apple 在 W3C 内产生的关于触摸屏输入的各种事件模型标准化的许可戏剧而导致的延迟。

3.  在这篇文章的起草过程中，iOS 14.5 和 Safari 14.1 发布了。

出于善意，Apple 最初 [拒绝在更新中提供 Web 平台功能的发行说明](https://twitter.com/firt/status/1386793991165911041?s=20)。

在接下来的日子里，[迟来的文档包含一个令人震惊的启示：出乎所有人的意料，iOS 14.5 带来了 WASM 线程！](/2021/04/progress-delayed/safari_14.1_wasm_thread_release_notes_cropped.png) 等待结束了！ iOS 的 WASM 线程完全出乎意料，因为 WebKit 需要关闭距离才能添加真正的 [站点隔离](https://security.googleblog.com/2018/07/mitigating-spectre-with-site-isolation.html ) 或 [新的开发者选择加入机制，以保护敏感内容免受现代 CPU 的侧信道攻击](https://web.dev/coop-coep/)。今年，WebKit 似乎都无法实现。

可以理解，Web Assembly 社区非常兴奋并 [开始测试该声明](https://twitter.com/RReverser/status/1387874356257345543?s=20)，但似乎无法使该功能按预期工作。

不久之后，Apple [更新了它的文档](https://twitter.com/RReverser/status/1387884606792339458?s=20) 并[提供了实际上添加的内容的详细信息](https://twitter.com/othermaciej/status/1387903432279826433?s=20)。最终对 WebKit 中的 WASM 线程解决方案至关重要的基础设施已经可用，但它有点像测试架上的引擎：没有汽车的其余部分，它是美丽的工程，无法将人们带到他们想去的地方.

iOS 的 WASM 线程已经看到了它们的影子，预计还要等待六个月（最少）。至少我们会有一个负担过重的 CPU 内核来保暖。

1.  世界各地的用户和开发者都为 Apple 对 Safari/WebKit 开发的资金不足支付税款，实际上是在补贴世界上最富有的公司，这是有悖常理的。

2.  Safari 使用其他 iOS 浏览器不可用的私有 API 将 Web 应用程序安装到主屏幕。

今天在 iOS 上切换浏览器的用户相反，不太能够让网络成为他们计算生活中更重要的部分，并且其他浏览器无法提供网络应用程序安装给开发者带来了挑战，他们必须考虑到差距并推荐用户切换到 Safari 以安装他们的网络体验。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
