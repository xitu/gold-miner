> * 原文地址：[4 Security Concerns with iframes Every Web Developer Should Know](https://blog.bitsrc.io/4-security-concerns-with-iframes-every-web-developer-should-know-24c73e6a33e4)
> * 原文作者：[Piumi Liyana Gunawardhana](https://medium.com/@piumi-16)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/4-security-concerns-with-iframes-every-web-developer-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2021/4-security-concerns-with-iframes-every-web-developer-should-know.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[Usualminds](https://github.com/Usualminds)、[KimYangOfCat](https://github.com/KimYangOfCat)

# 每个 Web 开发人员都应该知道的 4 个 iframe 安全问题

![](https://cdn-images-1.medium.com/max/5760/1*2cHSuIdPoIsV-vgCfVp19A.jpeg)

iframe 是 Web 开发中最古老、最简单的内容嵌入技术之一，时至今日仍被使用。然而，在实践中使用 iframe 可能会带来一些安全隐患，向攻击者敞开大门。

---

因此，在这篇文章中，我将讨论使用 iframe 前需要注意的 4 个安全风险问题。

## 1. iframe 注入

> iframe 注入是一个非常常见的跨站脚本攻击（XSS）。

iframe 使用多个标签在网页上展示 HTML 文档并将用户重定向到其他的网站。此行为允许第三方将恶意的可执行程序、病毒或蠕虫植入你的 web 程序中，并在用户的设备上运行。

我们可以通过扫描 Web 服务器发送的 HTML 来找出 iframe 的注入位置。你需要做的只是在你的浏览器中打开一个页面，然后启用 `view source` 功能来查看 HTML。由于这些 iframe 通常指向原生 IP 地址，因此你应该搜索  `<iframe>` 标签，而不是域名。

举例来说，让我们看看以下的代码：

```
++++%23wp+/+GPL%0A%3CScript+Language%3D%27Javascript%27%3E%0A++++%3C%21–%0A++++document.write%28unescape%28%273c696672616d65207372633d27687474703a2f2f696e666
f736563696e737469747574652e636f6d2f272077696474683d273127206865696768743d273127207374
796c653d277669736962696c6974793a2068696464656e3b273e3c2f696672616d653e%27%29%29%3B%0A
++++//–%3E%0A++++%3C/Script%3E
```

它看起来很正常，似乎是和这个站点相关的代码。实际上，它就是问题的根源。如果你用 JavaScript 函数对其进行解码，输出结果会是这样的：

```
#wp / GPL
<Script Language=’Javascript’>
<!–
document.write(unescape(‘3c696672616d65207372633d27687474703a2f2f696e666f73656369
6e737469747574652e636f6d2f272077696474683d273127206865696768743d273127207374796c653d
277669736962696c6974793a2068696464656e3b273e3c2f696672616d653e’));
//–>
</Script>
```

同样，这看起来也是合法的，因为攻击者使用了 `GPL` 和 `wp` 并将语言设为 `JavaScript`。这些数字和字母似乎是十六进制的，所以接下来我们可以使用十六进制解码器来将其解码，最终结果如下：

```html
<iframe src='https://www.infosecinstitute.com/' width='1' height='1' style='visibility: hidden;'></iframe>
```

---

因此，当你在 HTML 中找到一个 iframe，并发现它不是你放置的，你应该尽快调查原因并从网站或数据库中移除它。

## 2. 跨框架脚本攻击

> 跨框架脚本攻击（XFS）结合 iframe 和 JavaScript 恶意脚本，用于窃取用户的资料。

XFS 攻击者说服用户访问由他所控制的网页，并通过 iframe 引用一个结合了恶意脚本的合法站点。当用户在向 iframe 中的合法网站输入凭据时，JavaScript 恶意脚本将记录他们的输入。

---

通过在 Web 服务器配置中设置 **`Content-Security-Policy: frame-ancestors`** 和 **`X-Frame-Options`** 能防止此攻击。

## 3. 点击劫持

点击劫持攻击能诱骗用户点击隐藏的网页元素。由此一来，用户可能会因此在无意中下载恶意程序，浏览恶意网站，提供密码或敏感信息、转账或进行网络购物。

> 攻击者通常会通过 iframe 在网站上覆盖一个不可见的 HTML 元素来执行点击劫持。

用户以为他点击了显示的那个页面，然而，他所点击的是覆盖在其之上的隐藏元素。

![攻击流程](https://cdn-images-1.medium.com/max/2390/1*OxkBOt9qymWtNpds8CZy7g.png)

有两种主要策略可以保护自己免受点击劫持：

* 客户端中最流行的方法是 Frame Busting，但这并不是最好的解决方法，因为 iframe 只是被忽略了而已。
* 服务端中的最好办法是使用 `X-Frame-Options`。安全专家强烈地建议从服务端解决点击劫持的问题。

## 4. iframe 网络钓鱼

试考虑一个社交平台，它允许用户和开发人员使用 iframe 将第三方网页合并到他们的粉丝页面或其他的应用程序中。

> 攻击者经常滥用这个功能来将 iframe 用于网络钓鱼攻击。

在预设情况下，iframe 中的内容能重定向顶级窗口。因此，攻击者可能会利用跨站脚本（XSS）漏洞来将网络钓鱼的代码当作 iframe 植入到 Web 应用程序中，引导用户进入钓鱼网站。

作为示例，试思考以下代码：

```html
<html>
  <head>
    <title>Infosec Institute iFrame by Irfan</title>
  </head>
  <body>
  <iframe src=”/user/piumi/” width=”1450″ height=”300″ frameborder=”0″></iframe>
  <iframe src=”http://phishing.com/wp-login” width=”1450″ height=”250″ frameborder=”0″></iframe>
  </body>
</html>
```

上方的代码中包含一个 iframe 嵌入的网络钓鱼站点。用户会被重定向到那里，如果用户没注意网址栏，攻击者将能轻松地获取用户凭据。

> iframe 网络钓鱼攻击者不能伪造网址栏，但他们能触发重定向，操纵用户之后所接收的内容。

---

这个问题可以通过替换 `sandbox` 中的 `allow-top-navigation` 属性值来避免。

## 最后的一些看法

iframe 能提高用户的互动性。但是，当你使用 iframe 的时候，你处理的内容是来自于你无法控制的第三方。因此，iframe 经常会对你的应用程序造成威胁。

然而，我们不能因为安全顾虑就停止使用 iframe。我们需要意识到这些问题并采取防范措施来保护我们的应用程序。

我认为这篇文章能帮你识别使用 iframe 的安全问题。在下方评论区让我知道你的看法。

---

谢谢您的阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
