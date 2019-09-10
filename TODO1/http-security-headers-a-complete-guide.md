> * 原文地址：[HTTP Security Headers - A Complete Guide](https://nullsweep.com/http-security-headers-a-complete-guide/)
> * 原文作者：[Charlie](https://nullsweep.com/charlie/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/http-security-headers-a-complete-guide.md](https://github.com/xitu/gold-miner/blob/master/TODO1/http-security-headers-a-complete-guide.md)
> * 译者：[cyz980908](https://github.com/cyz980908)
> * 校对者：[TokenJan](https://github.com/TokenJan)，[hanxiaosss](https://github.com/hanxiaosss)

# HTTP Security Headers 完整指南

[![](https://images.unsplash.com/photo-1489844097929-c8d5b91c456e?ixlib=rb-1.2.1&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=1080&fit=max&ixid=eyJhcHBfaWQiOjExNzczfQ)](https://nullsweep.com/http-security-headers-a-complete-guide/)

销售“安全记分卡”的公司数量正在上升，并已开始成为企业销售的一个因素。我曾听说过一些客户，他们担心从评级较差的供应商那里购买产品，并且有至少一个客户，他们改变了最初基于评级的采购决定。

我调查了这些评级公司计算公司安全分数的方式，调查表明，他们使用的是 HTTP Security Headers 和 IP 信誉的组合。

IP 信誉基于黑名单和垃圾邮件列表以及公共 IP 所有权数据。只要您的公司不发送垃圾邮件并且可以快速检测并阻止恶意软件感染，这些通常应该是干净的。 HTTP Security Headers 使用的计算方式与 [Mozilla Observatory](https://observatory.mozilla.org/) 的工作方式类似。

因此，对于大多数公司而言，他们的分数很大程度上取决于在面向公众的网站上设置的 Security Headers。

您可以快速完成（通常不需要进行大量测试）正确 Headers 的设置，同时可以提高网站安全性，现在还可以帮助您赢得与具有安全意识的客户的交易。

我对这些测试方法论的价值和这些公司提出的过高定价方案都持怀疑态度。我认为这都与真正的产品安全性无关。然而，它确实增加了花时间设置 Header 和正确设置 Header 的重要性。

在本文中，我将介绍通常评估的 Header，为每个 Header 推荐安全值，并给出一个示例 Header 设置。在文章的最后，我将介绍常见应用程序和 web 服务器的示例设置。

## 重要的 Security Headers

### Content-Security-Policy

CSP 通过指定允许加载哪些资源来防止跨站点脚本。在此列表的所有项目中，这可能是创建和维护最耗时的，也是最容易出现风险的。在开发 CSP 期间，请务必仔细测试它 —— 以有效的方式阻止您的站点使用的内容源将会破坏站点的功能。

一个创建初稿的好工具是 [Mozilla laboratory CSP 浏览器扩展](https://addons.mozilla.org/en-US/firefox/addon/laboratory-by-mozilla/)。在浏览器中安装这个，彻底浏览要为其创建 CSP 的站点，然后在您的站点上使用生成的 CSP。理想情况下，还可以重构 JavaScript，因此不会保留内联脚本，因此您可以删除“unsafe inline”指令。

CSP 是复杂而令人困惑的，所以如果你想要更深入的研究，请参阅[官方网站](https://content-security-policy.com/)。

一个好的 CSP 的开始可能是这样的（这可能需要在一个真实的站点上进行大量的修改）。在站点包含的每个部分中添加域。

```bash
# 默认只允许来自当前站点的内容
# 允许来自当前网站和 imgur.com 的图片
# 不允许使用 Flash 和 Java 等对象
# 只允许来自当前站点的脚本
# 仅允许当前站点的样式
# 只允许当前站点的 frame
# 将 <base> 标记中的 URL 限制为当前站点
# 允许表单仅提交到当前站点
Content-Security-Policy: default-src 'self'; img-src 'self' https://i.imgur.com; object-src 'none'; script-src 'self'; style-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self';
```

### Strict-Transport-Security

这个 Header 告诉浏览器，该网站应仅允许 HTTPS 访问 —— 始终在您的网站启用 HTTPS 时启用。如果您使用子域名，我也建议在任何被使用的子域名上强制开启它。

```bash
Strict-Transport-Security: max-age=3600; includeSubDomains
```

### X-Content-Type-Options

此 header 确保浏览器遵守应用程序设置的 MIME 类型。这有助于防止某些类型的跨站点脚本绕过。

它还减少了由于浏览器可能不正确猜测某些内容导致的意外应用程序行为，例如当开发人员标记一个页面 HTML，但浏览器认为它看起来像 JavaScript，并试图将其作为 JavaScript 来渲染。这这个 Header 将确保浏览器始终遵守服务器设置的 MIME 类型。

```bash
X-Content-Type-Options: nosniff
```

### Cache-Control

这一个比其他的稍微复杂一些，因为您可能需要针对不同的内容类型使用不同的缓存策略。

任何具有敏感数据的页面，例如用户页面或客户结帐页面，都应该设置为无缓存。原因之一是防止其他使用共享计算机的人按下后退按钮或浏览历史并查看个人信息。

但是，很少更改的页面，如静态资源（图像，CSS 文件和 JavaScript 文件）很适合缓存。这可以在逐页的基础上完成，也可以在服务器配置上使用正则表达式完成。

```bash
# 默认情况下不缓存
Header set Cache-Control no-cache

# 缓存静态资源 1 天
<filesMatch ".(css|jpg|jpeg|png|gif|js|ico)$">
    Header set Cache-Control "max-age=86400, public"
</filesMatch>
```

### Expires

这将设置当前请求缓存到期的时间。如果设置了 Cache-Control max-age 的 Header，它将被忽略。所以我们只在一个简单的扫描器测试它而不考虑 cache-control 的情况下设置它。

出于安全考虑，我们假设浏览器不应该缓存任何东西，因此我们将把这个设置为一个日期，该日期的计算值总是为过去。

```bash
Expires: 0
```

### X-Frame-Options

这个 Header 指是否应该允许站点在 iFrame 中显示。

如果恶意网站将您的网站置于 iFrame 中，则恶意网站可以通过运行一些 JavaScript 来执行点击攻击，该 JavaScript 会捕获 iFrame 上的鼠标点击，然后代表用户与该网站进行交互（不一定点击他们认为他们点击的地方！）。

这应该总是设置为 deny，除非您特别使用 Frames, 在这种情况下，它应该设置为同源（same-origin）。如果您在设计中将 Frames 与其他网站一起使用，您也可以在此处白名单列出其他域名。

还应注意，此 Header 已被 CSP frame-ancestrs 指令取代。我仍然建议现在就设置它以作为缓冲工具，但将来它可能会逐步被淘汰。

```bash
X-Frame-Options: deny
```

### Access-Control-Allow-Origin

告诉浏览器哪些其他站点的前端 JavaScript 代码可能会对该页面发出请求。除非需要设置此值，否则默认值通常是正确的设置。

例如，如果 SiteA 提供了一些想要向 SiteB 发出请求的 JavaScript，那么 SiteB 必须提供带有 Header 的响应，这个 Header 指定 SiteA 被允许发出这个请求。如果需要设置多个源，请参阅 [MDN 上的详细信息页面](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin).

这可能有点令人困惑，所以我绘制了一个图表来说明这个 Header 如何运作：

![](https://nullsweep.com/content/images/2019/07/Screen-Shot-2019-07-17-at-4.38.37-PM.png)

具有 Access-Control-Allow-Origin 的数据流

```bash
Access-Control-Allow-Origin: http://www.one.site.com
```

### Set-Cookie

确保您的 Cookie 仅通过 HTTPS（加密）发送，并且不能通过 JavaScript 访问它们。如果您的站点也支持 HTTPS，则只能发送 HTTPS Cookie，这是应该的。您应该始终设置以下标志：

* Secure
* HttpOnly

Cookie 定义示例:

```bash
Set-Cookie: <cookie-name>=<cookie-value>; Domain=<domain-value>; Secure; HttpOnly
```

有关更多 Cookie 的信息，请参阅有关 Cookie 的优秀 [Mozilla 文档](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie)。

### X-XSS-Protection

这个 Header 指示浏览器停止检测到的跨站点脚本攻击的执行。它通常是低风险设置，但仍应在投入生产前进行测试。

```bash
X-XSS-Protection: 1; mode=block
```

## Web 服务器示例配置

通常，最好在服务器配置中添加站点范围内的 Headers。Cookie 是一个例外，因为它们通常在应用程序本身中定义。

在将任何 Header 添加到站点之前，我建议首先通过检查 Mozilla Observatory 或手动查看 Headers，看看哪些已经设置好了。一些框架和服务器会自动为您设置其中一些，因此只需要实现您需要或想要更改的那些。

### Apache 配置

.htaccess 中的 Apache 设置示例：

```bash
<IfModule mod_headers.c>
    ## CSP
    Header set Content-Security-Policy: default-src 'self'; img-src 'self' https://i.imgur.com; object-src 'none'; script-src 'self'; style-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self';

    ## 一般的 Security Headers
    Header set X-XSS-Protection: 1; mode=block
    Header set Access-Control-Allow-Origin: http://www.one.site.com
    Header set X-Frame-Options: deny
    Header set X-Content-Type-Options: nosniff
    Header set Strict-Transport-Security: max-age=3600; includeSubDomains

    ## 缓存规则
    # 默认情况下不缓存
    Header set Cache-Control no-cache
    Header set Expires: 0

    # 缓存静态资源 1 天
    <filesMatch ".(ico|css|js|gif|jpeg|jpg|png|svg|woff|ttf|eot)$">
        Header set Cache-Control "max-age=86400, public"
    </filesMatch>

</IfModule>
```

### Nginx 配置

```bash
## CSP
add_header Content-Security-Policy: default-src 'self'; img-src 'self' https://i.imgur.com; object-src 'none'; script-src 'self'; style-src 'self'; frame-ancestors 'self'; base-uri 'self'; form-action 'self';

## 一般的 Security Headers
add_header X-XSS-Protection: 1; mode=block;
add_header Access-Control-Allow-Origin: http://www.one.site.com;
add_header X-Frame-Options: deny;
add_header X-Content-Type-Options: nosniff;
add_header Strict-Transport-Security: max-age=3600; includeSubDomains;

## 缓存规则
# 默认情况下不缓存
add_header Cache-Control no-cache;
add_header Expires: 0;

# 缓存静态资源 1 天
location ~* \.(?:ico|css|js|gif|jpe?g|png|svg|woff|ttf|eot)$ {
    try_files $uri @rewriteapp;
    add_header Cache-Control "max-age=86400, public";
}
```

## 应用程序级别的 Header 设置

如果您无权访问 Web 服务器，或者有复杂的 Header 设置需求，您可能希望在应用程序本身中设置这些。这通常可以通过整个站点的框架中间件来完成，以及基于每个响应进行一次性 Header 设置。

为了简单起见，我只在示例中包含了一个 Header。并以同样的方式通过这个方法添加所有需要的内容。

### Node 和 express：

添加全局挂载路径：

```JavaScript
app.use(function(req, res, next) {
    res.header('X-XSS-Protection', 1; mode=block);    
    next();
});
```

### Java 和 Spring：

我并没有很多使用 Spring 的经验，但是 [Baeldung](https://www.baeldung.com/spring-response-header) 有一篇很好的文章关于 Spring 中的 Header 设置。

### PHP：

我不熟悉各种 PHP 框架。寻找能够处理请求的中间件。对于单个响应，它非常简单。

```php
header("X-XSS-Protection: 1; mode=block");
```

### Python / Django

Django 包含可配置的[安全中间件](https://docs.djangoproject.com/en/2.2/ref/middleware/)，它可以为您处理所有这些设置。先启用它们。

对于特定页面，可以将响应视为字典。Django 有一种处理缓存的特殊方法，如果试图以这种方式设置缓存 Headers，那么应该研究这种方法。

```python
response = HttpResponse()
response["X-XSS-Protection"] = "1; mode=block"
```

## 总结

设置 Header 相对快速且简单。在数据保护、跨站点脚本攻击和点击劫持方面，您的站点安全性将有相当大的提高。

您还可以确保您不会因为依赖于这些信息的公司安全评级而失去未来的业务交易。这种做法似乎越来越多，我希望它在未来几年里能继续在企业销售中发挥作用。

我有遗漏你认为应该包含在内的 Header 吗？请告诉我！

[站在威胁行动者的角度](https://nullsweep.com/empathizing-with-threat-actors/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
