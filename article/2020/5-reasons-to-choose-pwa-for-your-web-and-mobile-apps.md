> * 原文地址：[5 Reasons to Choose PWA for Your Web and Mobile Apps](https://blog.bitsrc.io/5-reasons-to-choose-pwa-for-your-web-and-mobile-apps-515c6d0e784d)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga87)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-reasons-to-choose-pwa-for-your-web-and-mobile-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-reasons-to-choose-pwa-for-your-web-and-mobile-apps.md)
> * 译者：[rocwong-cn](https://github.com/rocwong-cn)
> * 校对者：[Isildur46](https://github.com/Isildur46)、[Misszhu](https://github.com/Misszhu)

# 让你的 Web 应用和移动应用选择 PWA 的 5 个理由

![Photo by **[Lisa Fotios](https://www.pexels.com/@fotios-photos) on [Pixels](https://www.pexels.com/)**](https://cdn-images-1.medium.com/max/12000/1*tNa6Nnn7Ffq8uDEomL_pWw.jpeg)

我敢肯定你们中大多数的人都听说过渐进式网页应用（PWA）。PWA 是一项令人兴奋的技术，它具有颠覆我们开发 Web 和移动应用的方式的潜力。然而，有些人可能会说 PWA 只是将网站转换为移动应用，还有些人则在争论其功能、安全性以及相较于原生移动应用的性能。

因此，在本文中，我将阐述 PWA 的五个有价值的特性，这些特性对于您将来的 Web 和移动应用会非常有用。

## 1. 开发 Web 和移动应用只需一种技术

在现代技术世界中，我们可以看到很多开发人员给自己贴上 Web 开发人员，移动端开发人员等标签。

究其原因，我们可以发现技术、工具和不同的平台在分工中发挥了重要的作用。

以原生 App 开发为例，则需要了解一些特定的技术，例如 Java、Kotlin、Swift、Flutter 等编程语言，以及 Android Studio、XCode 等工具包。

![Screenshot by Auther (Source — [StackOverflow](https://insights.stackoverflow.com/survey/2019#technology))](https://cdn-images-1.medium.com/max/2000/1*ugxSh7SYNtRB_CmJD_gn_A.png)

相比之下，使用 JavaScript/TypeScript、HTML、CSS 以及 Angular 这样的框架或 React 这样的库是很容易的。[2019 年 stack overflow 的调查结果](https://insights.stackoverflow.com/survey/2019#most-loved-dreaded-wanted)显示，上述这些 Web 开发语言是最受欢迎的。

这些结果影响着开发人员的技术选型，因此，会有更多的开发人员选择 Web 领域。

## 2. 性能可靠

我们可以发现，快速、可靠和沉浸式体验是 PWA 的重要特性。Application Shell 架构是实现这些特性的最佳方法之一。即使用户处于弱网或离线状态，该架构体系也可以为用户提供快速、可靠的性能。让我们看看该架构的主要优势是什么。

![Shell vs. Content Structure](https://cdn-images-1.medium.com/max/4000/0*Fi5V2irPUGri9v-D)

如果我们遵循 Application Shell 架构原则，可以将应用分为 **Shell** 和 **Content** 两个主要部分。初始化用户界面所需的最小应用程序内容称为 Shell，而其他需要通过联网获取的动态部分称为 Content。 因此，Shell 负责通过缓存其内容以供离线环境使用，从而为用户提供快速、可靠的用户体验。这种方法非常适合单页面应用（SPA），并且为用户节省了数据流量，带来了可靠和快速的性能以及原生的交互体验。

## 3. 使用 Service Worker 提供最佳的用户体验

如果您是 Web 开发人员，那么我相信您一定已经使用或听说过 Service Worker。Service Worker 在您的 Web 应用程序的后台运行，并处理大量不需要用户关注的任务。这些 Service Worker 通常在新的 Web 应用程序中使用，也可以在 PWA 中使用。让我们看一下 Service Worker 为 PWA 提供的主要功能。

#### 离线运行

与原生应用相比，离线运行是 PWA 的颇具竞争力的特性之一，PWA 借助 Service Worker 来实现此功能。使用 Service Worker，您可以缓存应用的 Shell，当用户再次访问时它将立即加载。这些后台操作可改善应用的用户体验，因为用户不会看到在线和离线模式之间有任何重大差异。但是只有在联网后，动态内容才会刷新。我们可以使用 telegram（一个通讯平台）来举例，该应用程序将照常打开，即使您处于离线状态，您也可以查看和阅读以前的聊天记录。联机后，应用程序将刷新并显示新消息。

#### 后台同步

后台同步是 Service Worker 提供的另一项功能，它使应用程序可以在网络连接可用时响应任何关键请求，甚至包括您在离线模式发起的调用。例如，如果您在断网时发送消息，Service Worker 将负责处理并在连接可用时完成该请求。后台同步的 Demo 实现如下所示：

```js
navigator.serviceWorker.register('/service_worker.js');

navigator.serviceWorker.ready.then(function(swRegistration) {
  return swRegistration.sync.register('backGroundSync');
});

self.addEventListener('sync', function(event) {
  if (event.tag == 'backGroundSync') {
    event.waitUntil(yourFunction());
  }
});
```

如上所述，即使关闭了应用程序，Service Worker 仍被用作事件目标，以使后台同步工作。 `yourFunction()` 将返回一个 `Promise`，该 `Promise` 将标记活动的状态为成功或者失败。如果成功，则完成后台同步；如果失败，则稍后再安排一次同步。另外，请注意 `yourFunction()` 的名称对于给定的同步应该是唯一的。

除了这两项之外，Service Worker 还为 PWA 提供了许多功能，例如即使应用程序不活跃时也可以接收推送通知、缓存网络请求以及缓存静态内容等。

## 4. 原生应用的外观和体验

简单地讲，Web 应用的 manifest 配置就是为 PWA 定义原生外观的 JSON 文件。当我们从 play store 或者 app store 安装一个应用时，就可以在手机上看到一个应用的图标，这就使得移动应用相较于网站更具交互性。对于 PWA，Web 应用的 manifest 文件是所有用户交互的入口，并且包含应用的外观相关配置的元数据。使用此 JSON 文件，我们可以轻松地更改应用的许多元素，包括应用的图标、主题色、屏幕横竖和启动屏页面。下面我们一个实例来更深入的讨论一下这些属性。

```
{
  "name": "My Example App",
  "short_name": "My App",
  "start_url": ".",
  "display": "standalone"  
  "background_color": "#ffffff",
  "theme_color": "red"
  "description": "Demo App.",
  "orientation": "portrait-primary",
  "icons": [{
    "src": "images/logo.png",
    "sizes": "48x48",
    "type": "image/png"
  } ... ],
  "related_applications": [{
    "platform": "play",
    "url": "https://play.google.com/store/apps/details?..."
  }]
}
```

一个简单的 Web manifest JSON 文件如上所示，**name，short_name** 属性用于应用程序显示名称。在这里，**icon** 属性是一个列表，包含不同尺寸的应用图标。**display** 属性可以具有全屏、独立、最小用户界面和浏览器这些值，全屏模式会删除所有浏览器元素，并为您的应用程序提供最佳的原生体验。**start_url** 定义了用户从主屏幕启动 PWA 时加载的页面。除此之外，还有许多属性可用于为 PWA 带来原生的体验。最重要的是，作为开发人员，您可以完全控制应用程序的启动过程，并且可以利用这些属性轻松地与原生应用一较高下。

## 5. 增强安全性以及设备访问的透明性

安全是我们需要考虑的另一个重要方面。随着全球安全事件的增加，用户比以往任何时候都更加关注其数据设备是否具备足够的安全性来防止恶意攻击。因此，作为开发人员，我们必须使用我们选择的技术来建立安全的最佳实践以避免这些问题。因此，让我们看看如何通过 PWA 向用户保证安全性。

PWA 强制要求在传输层使用安全协议。因此，对用户而言，敏感信息在传输过程中是加密的，并且只能使用存储在服务器中的私钥来解密数据。出于这个原因，应该使用 HTTPS 为 PWA 的网站提供服务，并且必须在服务器中安装 SSL 证书。

另外，未经用户许可，PWA 不会与设备硬件进行交互，并且在 PWA 应用程序中隐藏任何恶意代码也不容易。如果我们遵循最佳实践，仅在必要时才请求获取访问设备的权限，并使用最新的受信任的 JavaScript 库，则风险将大大降低。

## 结论

除了这 5 个原因以外，PWA 还满足了我们对其他 Web 或者移动应用的要求，例如响应速度、可靠性以及用户体验等。作为开发人员，您无需承担语言和框架上负担，因此开发 PWA 很容易。与原生应用的开发相比，PWA 花费的时间更少。

如果您决定使用 PWA，在业务层面，成本会更低，市场占有率会更高，并且可以快速地进行搜索引擎优化。因此，下次寻求 Web 或者移动端的解决方案时，请马上尝试 PWA 吧。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
