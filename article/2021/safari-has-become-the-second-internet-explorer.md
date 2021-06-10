> * 原文地址：[Safari Has Become The Second Internet Explorer](https://medium.com/javascript-in-plain-english/safari-has-become-the-second-internet-explorer-e2c2dd114837)
> * 原文作者：[Golosay Volodymyr](https://medium.com/@golosay)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/safari-has-become-the-second-internet-explorer.md](https://github.com/xitu/gold-miner/blob/master/article/2021/safari-has-become-the-second-internet-explorer.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[lsvih](https://github.com/lsvih)

# 恭喜 Safari 荣获「第二个 Internet Explorer」的美誉

![Safari 有时候看起来长得跟 IE 没啥不一样的](https://cdn-images-1.medium.com/max/2300/1*obluMaNgoWxwefRpP__Elg.png)

如果你去问问一个程序员他对听到 IE 这个词的感受，一般来说，绝对是这样的 —— OMG 痛苦的要死！我当然也不是例外！我作为一名 Web 开发者已经有了十多年，在这段时间里面，开发过不少必须要兼容 IE 的项目。我清晰地认识到，某些奇葩浏览器不支持别的浏览器支持的常见功能这个问题，是如何令我们这群本已秃头的程序员们更加头秃沮丧的。或者说，有的时候，这种坑货浏览器甚至还会错误地将部分元素渲染在错误的地方！更糟糕的是，你可能有些时候还得去调试某些意料之外的错误的行为。

幸（讽）运（刺）的是，我在日常生活中使用着一台 M1 芯片的新款 MacBook Pro。我超级喜欢使用 Apple 所开发的软件，因为它们总是快速、节能、美观的。Safari 就是 Apple 所提供的软件的其中之一。我好想再爱一遍 Safari 啊，可惜我越多地与它共事，就越多地回想起 IE。因此，点明这些关切到我们每个人切身头发安全的问题是非常之重要的。而对于其中一些问题，我将会为大家提供防脱发治疗手段。

## PWA 支持

Safari 对 PWA 的支持？更确切地说应该是缺乏支持！Apple 是现当时最离谱的拒绝 PWA 的厂商之一。你知道什么是 PWA 吗？PWA 是一类可以在浏览器中打开它，并在本地安装的网络应用。它看起来和从应用商店中安装的普通应用一样，并且具有离线启动的功能。从理论上讲，你可以立即在你的浏览器上尝试一下（例如在 iPhone 上安装 PWA 应用程序），但是好心的 Apple 会用如下的借口劝退你：

* 你不能存储超过 50 MB 的数据
* 不支持蓝牙
* 不支持原生的分享框
* 没有后台同步或是 Web 推送通知
* 没有 Web App 横幅提醒用户安装应用
* 不支持自定义启动画面

这些限制使 PWA 这项技术毫无用处。比起技术，Apple 可能更希望控制市场，让用户仅可以通过 App Store 安装所谓真正的应用程序。

在 Mac 上的 Safari 中，你根本无法用它。

## Web 推送通知

这个话题虽说位列 PWA 的限制列表中，但也值得单独一提。

在 Mac 上，某些应用程序的 Web 版本无法发送推送通知，导致不能提供全部功能。

![推送通知浏览器支持表格](https://github.com/PassionPenguin/gold-miner-images/blob/master/safari-has-become-the-second-internet-explorer-developer.mozilla.org_en-US_docs_Web_API_Push_API.png?raw=true)

Messenger 应用们就是最好的例子。如今，Telegram 或 Facebook Messenger 只能在网站打开时通过变更标题和播放声音来通知用户有关新消息的信息。如果用户静音了，并将浏览器最小化了，显然就会错过新的消息。

此限制的唯一好处是，新闻站点没有烦人的通知告示希望你去订阅它们的提醒 —— 这可真棒，但丝毫不等同于我们不需要通知功能！

## 滑动表现

Apple 为 Safari 的性能和能效感到骄傲（这点的确如此）！

为了获得如此好的性能，他们实施了许多优化，其中之一是在用户进行动态滚动操作时阻止 DOM 更新。但是优化之后，用户们开始发现浏览器出现了一些滚动的滞后。最著名的问题 —— 在 YouTube 视频页面上滚动评论。大量的用户在[官方支持论坛](https://discussions.apple.com/thread/250853003)和 MacRumors 上对有关问题进行了讨论。

要解决此问题，你必须安装 UserScripts 扩展并添加一些 CSS 样式：

```scss
// ==UserScript==
// @name        FixYouTubeScrolling
// @description Stop improper styling, Google
// @match       *://*youtube.*
// ==/UserScript==

ytd-page-manager {
    overflow-y: unset !important;
}

#page-manager.ytd-app {
    overflow-x: unset !important;
}
```

但这不是存在此问题的唯一地方。我在许多不同的在滚动事件上附加了很多功能的网站（例如 Youtube 音乐、Facebook、Reddit 等）上都发现了类似的滚动上的问题。

这就实现快速滚动的代价，所以我希望 Apple 能够在性能和表现上找到一个更好的平衡点。

## YouTube

让我们讨论讨论 YouTube！你大概率遇到过缩略图或头像无法加载的问题，可以在 Apple 论坛中找到有关此问题的许多帖子（例如[这个](https://discussions.apple.com/thread/252092264)和[这个](https://forums.macrumors.com/threads/youtube-website-scrolling-issue.2272026/)）。

我不知道问题的根源，但已经明确了是缓存中的错误。虽说清除缓存可以解决此问题。但是它有时仍然会复现。

有两种清除 Safari 中缓存的方法：

1. 在 Safari 中单击"刷新"按钮的同时，按键盘上的 `Shift` 键。
2. 按键盘上的 **`Command（⌘）`** + **`Option（⌥, alt）`** + **`R`**。

随你选择～

## 图标

你是否能在 Mac 的 Safari 中看到 Instagram 网页的图标？出于某种原因，它是黑白的。

![左上角的黑白图标](https://cdn-images-1.medium.com/max/5744/1*GgbMRIpIX_cuz6eCaLSoXA.png)

这是个次要的但也是个非常奇怪的问题。你可以自己尝试访问一下，会发现真正的图标应该是有颜色的。这个问题也出现在了我的 [methodist.io](https://methodist.io) 网页上。我在许多站点上都发现了此问题，而如果你知道此问题的发生原因以及解决方法，麻烦在评论中分享～

## 拓展

在 2018 年之前，Safari 并没有用于构建浏览器扩展的框架。因此，App Store 中针对 Safari 的扩展程序真的很少。仅在 2018 年之后，他们才开始像 Chrome 一样使用 WebExtensions Api。对于扩展程序开发人员而言，这是一个巨大的进步，因为主要浏览器的核心 API 已经相同了。虽说已经过了很长一段时间了，但如今，Safari 与其他浏览器相比，扩展的数量依旧存在着巨大的差异。

## 媒体格式标准化

你们可能都知道 JPEG 和 PNG 图像格式。它们年代久远（诞生于 1992 年），文件又大。因此，在 2017 年，科技巨头们都决定设计更高效的媒体格式。苹果发布了 HEIC（High-Efficiency Image Coding 高效图片编码），谷歌推广了 WebP。但是由于某些原因，他们都彼此不认可对方。Chrome 仅支持 WebP，而 Safari 又仅支持 HEIC。直到 2020 年年中，Apple 才在 Safari 中添加了对 WebP 的支持。

这个问题是关于图像的，但同样也适用于视频。Google 为视频设计了 **WebM** 格式，但即使现在（2021 年 1 月），**Safari 也不支持这个格式**。

在 2019 年，IT 巨头开始合作，开发先进、免费的视频编解码器 **AV1**。苹果、谷歌、Netflix 等公司（这个名单令人印象深刻）成立了一家”开放媒体联盟“公司，这些企业共享了他们的技术和专利，以创建跨时代的解编码器。目前，解编码器已开发完了，Netflix 也业已在其应用中使用了它，但是 Safari 还是不支持它。

![开放媒体联盟](https://cdn-images-1.medium.com/max/2000/1*4Hu_Vd2eexqGCyRn16_AZg.jpeg)

如你所见，Safari 是一款非常保守的浏览器，而 Apple 总是不愿意与用户的意愿保持一致。

## 小结

Safari 是快速的、节能的一款（甚至是）安全的浏览器。但是 Apple 它呢有它自己的想法。当然，Apple 还是喜欢赚钱，而让用户能够避开 App Store 安装应用程序可不是什么有利可图的想法。类似的辩解口径对于自己不兼容某些主流的媒体格式都是通用的，但是这些问题可真真实实地阻碍了技术的发展，给我们这群头秃的开发人员平添了更多的麻烦。

**感谢你的阅读！**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
