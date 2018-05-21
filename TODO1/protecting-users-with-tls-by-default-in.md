> * 原文地址：[Protecting users with TLS by default in Android P](https://android-developers.googleblog.com/2018/04/protecting-users-with-tls-by-default-in.html)
> * 原文作者：[Chad Brubaker](https://android-developers.googleblog.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-users-with-tls-by-default-in.md](https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-users-with-tls-by-default-in.md)
> * 译者：[hanliuxin5](https://github.com/hanliuxin5)
> * 校对者：

# 在 Android P 中使用默认的 TLS 来保护你的用户

攥写自 Chad Brubaker，Android 安全部门高级软件工程师。

Android 致力于保持其用户，他们的设备以及他们数据的安全。其中一种我们保持数据安全的方式是让所有进入或离开 Android 设备的数据通过安全传输层（TLS）来通信。如同我们在 Android P 预览版中[宣布](https://android-developers.googleblog.com/2018/03/previewing-android-p.html)的一样，我们正在通过阻止目标为 Android P 的应用在默认情况下允许未加密的连接这一行为来进一步改进这些保护措施。

伴随着多年来我们为了更好地保护 Android 用户所做出的改变。为了防止意外的非加密链接，我们在 Android Marshmallow 中引入了新的 manifest 属性 `android:usesCleartextTraffic`。在 Android Nougat 中，我们通过创建 [Network Security Config](https://developer.android.com/training/articles/security-config.html) 来扩展了这个属性，用来表明 app 并没有使用加密网络链接的倾向。在 Android Nougat 和 Oreo 中， 我们仍然允许明文传播。

## 如何更新我的 APP 呢？

如果你 app 的所有网络请求已经使用上了 TLS，那么你什么都不用做。但如果不是，你则是需要使用 TLS 来加密你所有的网络请求。如果你仍然需要发起明文传输的请求，继续往下读读看吧。

### 为什么我需要使用 TLS 呢？

Android 系统认为所有网络都可能是具有敌意的，因此应始终使用加密流量。移动设备则是更加容易受到攻击的存在，因为它们经常性地链接到许多不同的网络，比如咖啡店的 Wi-Fi。

所有的网络传输都应该被加密，无论它们传输的何种内容，因为任何未加密的链接都可能被攻击并被注入额外内容，让潜在拥有脆弱防护性能的客户端代码更能够被多点击破，或是用来跟踪用户。如要获取更多的讯息，请查看我们之前的文章 [protecting-against-unintentional](https://android-developers.googleblog.com/2016/04/protecting-against-unintentional.html) 和 [Developer Summit talk](https://www.youtube.com/watch?v=fcWVV0Hafuk&t=1s)。

### TLS 会很慢吗？

[当然不是！](https://istlsfastyet.com/)

### 如何在我的 APP 中使用 TLS？

一旦你的服务器端支持了 TLS，你只需要简单地将你 App 中和服务器响应的的 URL 从 http:// 该变成 https://。你的 HTTP 堆栈将会自动地处理好相关事宜。

如果你需要自己处理套接字，请使用 [SSLSocketFactory] 而不是 [SocketFactory]。请一定要特别注意正确地使用套接字，因为 [SSLSocket] 没有提供主机名的验证。你的 APP 需要自己来处理主机名验证，最好通过调用 `[getDefaultHostnameVerifier()]` 来处理主机名。而是，当你调用 `[HostnameVerifier.verify()](https://developer.android.com/reference/javax/net/ssl/HostnameVerifier.html#verify(java.lang.String, javax.net.ssl.SSLSession))` 时一定要谨慎，它没有抛出任何异常或者错误，相反它返回了一个需要明确检查值的布尔值结果。

### 我还是需要使用明文传输...

当然你真的应该在所有链接中使用 TLS，但有可能由于历史原因你还是需要使用明文传输，比如连接上一台无人维护的老旧服务器。要这样做，你需要配置你 APP 的网络安全设置来允许这些链接。

我们已经有了一些这样的范例配置。请查看 [network security config](https://developer.android.com/training/articles/security-config.html) 来获得更多的帮助。

### 允许特殊的域名使用明文传输

如果您需要允许连接到特定域名或一组域名，可以使用以下配置作为指导：

```
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">insecure.example.com</domain>
        <domain includeSubdomains="true">insecure.cdn.example.com</domain>
    </domain-config>
</network-security-config>
```

### 允许连接到任意不安全的域名

如果您的应用支持通过不安全连接从 URL 打开任意内容，你应该只是设置与你自己的服务器通信时才使用加密传输。时刻记住，小心处理你从非安全链接得到的数据，它们可能已经在传输过程中被篡改。

```
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">example.com</domain>
        <domain includeSubdomains="true">cdn.example2.com</domain>
    </domain-config>
    <base-config cleartextTrafficPermitted="true" />
</network-security-config>
```

## 如何更新我的库呢？

如果你使用的库直接地创建了安全或者非安全的链接，确保它们在发起任意明文传输请求前调用过 [isCleartextTrafficPermitted](https://developer.android.com/reference/android/security/NetworkSecurityPolicy.html#isCleartextTrafficPermitted(java.lang.String)) 来检查其行为可行性。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
