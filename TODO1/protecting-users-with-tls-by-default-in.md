> * 原文地址：[Protecting users with TLS by default in Android P](https://android-developers.googleblog.com/2018/04/protecting-users-with-tls-by-default-in.html)
> * 原文作者：[Chad Brubaker](https://android-developers.googleblog.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-users-with-tls-by-default-in.md](https://github.com/xitu/gold-miner/blob/master/TODO1/protecting-users-with-tls-by-default-in.md)
> * 译者：
> * 校对者：

# Protecting users with TLS by default in Android P

Posted by Chad Brubaker, Senior Software Engineer Android Security

Android is committed to keeping users, their devices, and their data safe. One of the ways that we keep data safe is by protecting all data that enters or leaves an Android device with Transport Layer Security (TLS) in transit. As we [announced](https://android-developers.googleblog.com/2018/03/previewing-android-p.html) in our Android P developer preview, we're further improving these protections by preventing apps that target Android P from allowing unencrypted connections by default.

This follows a variety of changes we've made over the years to better protect Android users.To prevent accidental unencrypted connections, we introduced the `android:usesCleartextTraffic` manifest attribute in Android Marshmallow. In Android Nougat, we extended that attribute by creating the [Network Security Config](https://developer.android.com/training/articles/security-config.html) feature, which allows apps to indicate that they do not intend to send network traffic without encryption. In Android Nougat and Oreo, we still allowed cleartext connections.

## How do I update my app?

If your app uses TLS for all connections then you have nothing to do. If not, update your app to use TLS to encrypt all connections. If you still need to make cleartext connections, keep reading for some best practices.

### Why should I use TLS?

Android considers all networks potentially hostile and so encrypting traffic should be used at all times, for all connections. Mobile devices are especially at risk because they regularly connect to many different networks, such as the Wi-Fi at a coffee shop.

All traffic should be encrypted, regardless of content, as any unencrypted connections can be used to inject content, increase attack surface for potentially vulnerable client code, or track the user. For more information, see our past [blog post](https://android-developers.googleblog.com/2016/04/protecting-against-unintentional.html) and [Developer Summit talk](https://www.youtube.com/watch?v=fcWVV0Hafuk&t=1s).

### Isn't TLS slow?

[No, it's not](https://istlsfastyet.com/).

### How do I use TLS in my app?

Once your server supports TLS, simply change the URLs in your app and server responses from http:// to https://. Your HTTP stack handles the TLS handshake without any more work.

If you are making sockets yourself, use an [SSLSocketFactory](https://developer.android.com/reference/javax/net/ssl/SSLSocketFactory.html) instead of a [SocketFactory](https://developer.android.com/reference/javax/net/SocketFactory.html). Take extra care to use the socket correctly as [SSLSocket](https://developer.android.com/reference/javax/net/ssl/SSLSocket.html) doesn't perform hostname verification. Your app needs to do its own hostname verification, preferably by calling `[getDefaultHostnameVerifier()](https://developer.android.com/reference/javax/net/ssl/HttpsURLConnection.html#getDefaultHostnameVerifier())` with the expected hostname. Further, beware that `[HostnameVerifier.verify()](https://developer.android.com/reference/javax/net/ssl/HostnameVerifier.html#verify(java.lang.String, javax.net.ssl.SSLSession))` doesn't throw an exception on error but instead returns a boolean result that you must explicitly check.

### I need to use cleartext traffic to...

While you should use TLS for all connections, it's possibly that you need to use cleartext traffic for legacy reasons, such as connecting to some servers. To do this, change your app's network security config to allow those connections.

We've included a couple example configurations. See the [network security config](https://developer.android.com/training/articles/security-config.html) documentation for a bit more help.

### Allow cleartext connections to a specific domain

If you need to allow connections to a specific domain or set of domains, you can use the following config as a guide:

```
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">insecure.example.com</domain>
        <domain includeSubdomains="true">insecure.cdn.example.com</domain>
    </domain-config>
</network-security-config>
```

### Allow connections to arbitrary insecure domains

If your app supports opening arbitrary content from URLs over insecure connections, you should disable cleartext connections to your own services while supporting cleartext connections to arbitrary hosts. Keep in mind that you should be cautious about the data received over insecure connections as it could have been tampered with in transit.

```
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">example.com</domain>
        <domain includeSubdomains="true">cdn.example2.com</domain>
    </domain-config>
    <base-config cleartextTrafficPermitted="true" />
</network-security-config>
```

## How do I update my library?

If your library directly creates secure/insecure connections, make sure that it honors the app's cleartext settings by checking [isCleartextTrafficPermitted](https://developer.android.com/reference/android/security/NetworkSecurityPolicy.html#isCleartextTrafficPermitted(java.lang.String)) _before_ opening any cleartext connection.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
