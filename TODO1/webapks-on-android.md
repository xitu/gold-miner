> * 原文地址：[WebAPKs on Android](https://developers.google.cn/web/fundamentals/integration/webapks?hl=zh-cn)
> * 原文作者：[Pete LePage](https://developers.google.cn/web/resources/contributors/petelepage?hl=zh-cn)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/webapks-on-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/webapks-on-android.md)
> * 译者：[Yuhanlolo] (https://github.com/Yuhanlolo)
> * 校对者：

# PWA 再进化，可以生成一个安卓原生的 WebAPK 了

在安卓系统上，[网络应用安装横幅](https://developers.google.cn/web/fundamentals/app-install-banners/?hl=zh-cn)不仅仅只是将渐进式网络应用（PWA）添加到用户的主屏幕。 Chrome 会自动为你的应用生成一个特殊的 APK，有时候我们称之为 **WebAPK**。 将应用以 APK 的形式安装到手机上，使得它能够出现在用户的应用程序启动器和系统设置里，以及注册一系列 intent filters。

为了[生成 WebAPK](https://chromium.googlesource.com/chromium/src/+/master/chrome/android/webapk/README)，Chrome 需要检查 [web app manifest](https://developers.google.cn/web/fundamentals/web-app-manifest/?hl=zh-cn)和元数据. 一旦 manifest 改变了，Chrome 将会生成一个新的 APK。

> 注意：由于 manifest 的改变会重新生成 WebAPK，我们建议只在必要的情况下修改它。同时，不要用 manifest 储存任何跟用户有关的信息，或是其他需要经常变更的数据。因为频繁地修改 manifest 将会触发 Chrome 不断生成新的 WebAPK，从而导致安装时间的延长。

## 安卓 intent filters

当安装一个 PWA 到安卓系统上时，该应用将会为它所有的 URL 注册一系列[intent filters](https://developer.android.google.cn/guide/components/intents-filters?hl=zh-cn)。当用户点击任何包括在这个 PWA 中的链接时，该应用将会以应用程序的形式被打开，而不是在浏览器中被打开。

让我们看看下面这个 `manifest.json` 文件的片段，当它从程序启动器中被调用时，它将会以一个独立应用程序的形式启动 `https://example.com/`，并且不需要任何浏览器。

```
"start_url": "/",
"display": "standalone",
```

一个 WebAPK 包括如下的 intent filters：

```
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
    android:scheme="https"
    android:host="example.com"
    android:pathPrefix="/" />
</intent-filter>
```

如果用户在某个应用程序中点击了一个跳转到 `https://example.com/read` 的链接，这一行为将会被 intent 捕捉到，并且在对应的 PWA 中打开该链接。

> 注意：从地址栏里直接跳转到 `https://example.com/app/` 和从带有该消息传递对象（intent）过滤器的原生应用里打开这个链接是一样的。Chrome 会认为用户是 **有意识地** 想要访问这个地址并且打开它。

### 使用 `scope` 限制 intent filters

如果你不想要你的 PWA 处理网站上所有的链接，你可以添加 [`scope`](https://developers.google.cn/web/fundamentals/web-app-manifest/?hl=zh-cn#scope) 属性到 manifest 中。`scope` 属性会告诉安卓系统只在 URL 与 `origin` 和 `scope` 匹配时打开你的 PWA，并且规定哪些 URL 应该在 PWA 中被开打以及哪些 URL 应该在浏览器中被打开。当你的应用与其他非应用内容在同一个域名下时，`scope` 非常有帮助。

让我们看看下面这个 `manifest.json` 文件的片段，当它从程序启动器中被调用时，它将会以一个独立应用程序的形式启动 `https://example.com/app/`，并且不需要任何浏览器。

```
"scope": "/app/",
"start_url": "/",
"display": "standalone",
```

和之前一样，生成的 WebAPK 将会包括 intent filters，但它会修改 APK 中 `AndroidManifest.xml` 里的 `android:pathPrefix` 属性：

```
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
    android:scheme="https"
    android:host="example.com"
    android:pathPrefix="/app/" />
</intent-filter>
```

让我们看几个简单的例子:  
✅ `https://example.com/app/` - 在`/app/`路径下
✅ `https://example.com/app/read/book` - 在 `/app/`路径下
❌ `https://example.com/help/` - 不在 `/app/`路径下
❌ `https://example.com/about/` - 不在 `/app/`路径下

如果你不想设置 `scope` 属性，或者想知道如何定义 PWA 的 `scope`， 更多内容请参考 [`scope`](https://developers.google.cn/web/fundamentals/web-app-manifest/?hl=zh-cn)。

## 权限管理

权限管理的运作和其他网络应用是一样的，它们需要在运行的时候请求而不是在安装的时候请求。理想的情况是只在你需要它们的时候请求。比如说，不要在一开始加载的时候就请求相机的权限，而是在用户准备拍照的时候再请求。

> 注意：通常情况下，安卓系统会马上授予刚安装的应用发送通知的权限，但这并不适用于通过 WebAPK 安装的应用。因此，你需要在运行的时候发起通知权限的请求。

## 管理储存空间和应用状态

虽然 PWA 是通过 APK 安装的，Chrome 会使用当前的配置文件存储数据，并且不会将它们隔离开。这为浏览器和应用程序之间交互提供了数据共享的体验。在这里，缓存是共享且活跃的，任何客户端的储存空间都是可以被访问的。与此同时，服务器端也是安装好并且随时可以运行的。

不过，这在用户清除他们的 Chrome 配置文件或者网站数据时会出现问题。

## 常见问题

**如果用户已经安装了该网站的原生应用怎么办？**

就像 PWA 安装横幅一样，用户可以添加任何独立于原生应用的网站到主屏幕。如果你期望用户同时安装这两者，我们建议你用不同的图标或者名字来区别你的网站和应用。

**当用户通过安装了的 PWA 打开某个站点时，Chrome 在运行吗？**

是的，一旦该站点通过主屏幕被打开，主要的活动依旧在 Chrome 下运行。缓存、权限以及所有的浏览器状态将会被两者共享。

**如果用户清除了浏览器缓存，已安装的 PWA 的储存空间会被清除吗？**

是的。

**如果我使用一个新的设备，我的 PWA 会被重新安装吗？**

并不是所有的时候都会。但我们认为这是一个很重要的问题，并且在努力完善它。

**我可以注册我自己处理 URL 的方法和协议吗？**

不可以。

**权限问题是如何解决的？我收到的提示是来自于安卓系统还是 Chrome？**

权限依旧是通过 Chrome 管理的。用户将会收到 Chrome 的提示从而授予权限，并且可以在 Chrome 设置中编辑这些权限。

**PWA 可以在哪一个版本的安卓系统上运行？**

PWA 可以在所有安装了 Chrome 的安卓系统上运行， 具体来说就是 Jelly Bean 以上的版本。

**PWA 使用的是 WebView 吗？**

不是，网站是通过 Chrome 打开的，打开网站的 Chrome 的版本则是用户添加该 PWA 的那一版本。

**我们可以上传能够提交到应用商店的 APK 吗？**

不可以，因为目前还没有可以支持 PWA 上传到应用商店的签名信息。

**PWA 在应用商店的列表中吗？**

不在。

**我是安卓平台上其他浏览器的开发者，我能为我的网络应用实现这样快捷的安装流程吗？**

我们正在为此努力。我们希望所有的浏览器都可以支持 PWA。更多的细节我们会在之后公布。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
