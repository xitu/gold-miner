> * 原文地址：[New Standards to Access User Device Hardware using JavaScript](https://blog.bitsrc.io/new-standards-to-access-user-device-hardware-using-javascript-86b0c156dd3d)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/new-standards-to-access-user-device-hardware-using-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/new-standards-to-access-user-device-hardware-using-javascript.md)
> * 译者：[Badd](https://juejin.cn/user/1134351730353207)
> * 校对者：[Chorer](https://github.com/Chorer)，[KimYangOfCat](https://github.com/KimYangOfCat)

# 用 JavaScript 访问用户设备硬件的新标准

![](https://cdn-images-1.medium.com/max/5760/1*qfJbVEgiwXf7b-nEviGJHg.jpeg)

你是否曾仅为了能访问用户设备硬件而不得不开发一个桌面应用？你不是唯一一个深受其苦的人。就在不久之前，用 JavaScript 访问硬件的方式还是勉强而麻烦的。 然而，随着近期的 Chrome 开发工具的更新，用 JavaScript 与硬件交互已是梦想成真。

因此，在本文中，我将会介绍 3 个新的 JavaScript API，即 **WebHID**、**WebNFC** 以及 **WebUSB**，它们将可用于访问设备硬件。下面让我们来逐一了解每个新技术点。

## 1. 什么是 WebHID？

在把一个 HID（Human Interface Device，人机接口设备）集成到软件中的时候，开发者面对的主要问题就是需要做大量的兼容工作，包括对旧/新设备、通用/非通用模型等的兼容。

> WebHID 提供了一个 API 来解决这个问题，此 API 让我们能够用 JavaScript 实现针对特定设备的逻辑。

举个简单的例子，如果你想要用任天堂 Switch 的 Joy-Con 手柄玩 Chrome 的离线小恐龙 🦖 游戏，有了 WebHID 就可以实现。是不是挺酷的？

用下面这段代码，你就能检测运行环境是否支持 WebHID。

```js
if ("hid" in navigator) { /* 支持 WebHID API。 */ }
```

当一个应用使用了 WebHID 去连接一个设备，就会显示下图这样的提示弹窗。

![](https://cdn-images-1.medium.com/max/2560/1*jGpe3g9CW13dDzmCCbBaYQ.jpeg)

而你需要做的就是，选择正确的设备，然后点击连接（Connect）。就这么简单。

> WebHID API 是异步的。因此在等待连接新设备或者用户输入时，界面也不会被阻塞。

### 安全性考量

我知道当你了解了 WebHID 能做什么之后，一定会想到安全问题。

Chromium 文档规定了[对强大的 Web 平台特性的访问控制](https://chromium.googlesource.com/chromium/src/+/lkgr/docs/security/permissions-for-powerful-web-platform-features.md)，而这个 API 正是根据文档中定义的核心原则开发的，包括用户控制、透明度、人体工程学等方面的原则。更严格的是，同一时刻只允许连接一个 HID 设备。

另外，Chrome 开发者工具针对浏览器当前连接的设备提供了日志输出功能，这让调试设备连接更加容易。该日志可在 `chrome://device-log`（Chrome 内部页面）中看到。

在本文中，我们不会涉及底层实现细节。如果你想要了解实现细节，请在评论区留言。

### 浏览器兼容性

目前桌面端的 Chrome 和 Edge 支持 WebHID。

![引用自 [https://developer.mozilla.org/en-US/docs/Web/API/WebHID_API](https://developer.mozilla.org/en-US/docs/Web/API/WebHID_API)](https://cdn-images-1.medium.com/max/2004/1*F47jvMuDaIypYRjt_PFbaA.png)

接着让我们来看看 WebNFC。

## 2. 什么是 WebNFC？

相信你之前肯定接触过 NFC（Near field communications，近距离通信技术）这个缩写名词。

有了 WebNFC，当一个 NFC 标签位于你的设备的识别范围之内时，你就能对其读取或写入数据了。这是通过 NDEF（NFC 数据交换格式）技术实现的，是 NFC 标签支持的一种格式。

### 使用 WebNFC

假设一个场景：你需要管理自家店铺的库存。你可以通过 WebNFC 向库存商品上的 NFC 标签读/写数据，这样就能搭建起一个库存管理站点。

WebNFC 带来的可能性是无限的。这是一个机会，一个能让许多过程自动化、让日常工作提效的机会。

与 WebHID 类似，你可以用下面的代码检查 WebNFC 的支持情况。

```js
if ('NDEFReader' in window) { /* 扫描、写入 NFC 标签 */ }
```

### 安全性考量

> 为了防患于未然，只有顶层框架和安全的浏览环境（只允许 HTTPS 协议）能够使用 WebNFC。

如果一个实现了 WebNFC 功能的网页消失了或肉眼不可见，那么和该网页连接的所有 NFC 标签都会被挂起连接。当页面重新可见时，这些连接才会恢复。页面可见性 API 可以帮你识别 NFC 操作的连接状态。

如果你不熟悉页面可见性 API 的话，可以读读[这篇文章](https://blog.bitsrc.io/page-lifecycle-api-a-browser-api-every-frontend-developer-should-know-b1c74948bd74)。

### 浏览器兼容性

目前仅有 Android 端的 Chrome 支持 WebNFC。

![引用自 [https://developer.mozilla.org/en-US/docs/Web/API/Web_NFC_API](https://developer.mozilla.org/en-US/docs/Web/API/Web_NFC_API)](https://cdn-images-1.medium.com/max/4048/1*fN-b18bMyZ8OPvq3eYzNvQ.png)

下面，让我们一起来看看 WebUSB API。

## 3. 什么是 WebUSB？

从 Chrome 61 版本开始，WebUSB API 让你可以用 JavaScript 与 USB 端口进行通信。

然而，你可能会想，我们怎么才能访问每个 USB 设备的相关驱动，对吧？有了 WebHID API 的支持，硬件厂商能够针对自家的硬件设备开发出跨平台的 JavaScript SDK。

与上述 API 类似，我们可以使用下列代码检测 WebUSB 的支持情况。

```js
if ("usb" in navigator) { /* 支持 WebUSB API。 */ }
```

### 安全性

有许多控制措施可以保护未授权的 USB 访问的安全性，而且它仅在只允许 HTTPS 协议的安全环境运行，以此来保护传输的数据。另外，会有标准浏览器授权流程来请求和授予访问权限。

WebUSB API 相关的调试任务也可以在 `chrome://device-log` 页面看到，页面里会列出当前连接的所有 USB 设备及相关事件。

### 浏览器兼容性

桌面端 Chrome、Edge，以及 Android 端 Chrome 支持 WebUSB。

![引用自 [https://developer.mozilla.org/en-US/docs/Web/API/USB](https://developer.mozilla.org/en-US/docs/Web/API/USB)](https://cdn-images-1.medium.com/max/2006/1*l3vDUrDveghLc6IUMAD2Mg.png)

关于 WebUSB API 的更多细节，你可以参阅 [Web 端访问 USB 设备文档](https://web.dev/usb/)。

## 总结

不管是你的网站要和硬件交互，还是你有要和 Web 应用交互的硬件，新标准带来的都是双赢，因为它们无需再安装专门的驱动或软件就能进行连接了。

在我看来，这个新功能太酷了，会让生活更加便捷。

欢迎和我分享你对此的想法。感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
