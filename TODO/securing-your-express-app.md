> * 原文地址：[Putting the helmet on – Securing your Express app](https://www.twilio.com/blog/2017/11/securing-your-express-app.html)
> * 原文作者：[Dominik Kundel](https://www.twilio.com/blog/author/dominik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/securing-your-express-app.md](https://github.com/xitu/gold-miner/blob/master/TODO/securing-your-express-app.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[swants](http://www.swants.cn)

# 为你的网站带上帽子 — 使用 helmet 保护 Express 应用

![](https://www.twilio.com/blog/wp-content/uploads/2017/11/4Txtn2Pl8SQnB241Dz1jvqSmUCLJksk6M97TAJYyNHPsIZE8Q9PA1NKBYZtua-v2C5UqpyBKBCFr2SaljImM2DGDGkK-XfJs1mfMkbJ7_Sc_hGP4Q70cnqgJHpVjd7NYIgjU4AJj.png)

[Express](https://expressjs.com/) 基于 [Node.js](https://nodejs.org/)，是一款用于构建 Web 服务的优秀框架。它很容易上手，且得益于其中间件的概念，可以很方便地进行配置与拓展。尽管现在有[各种各样的用于创建 Web 应用的框架](https://www.twilio.com/blog/2016/07/how-to-receive-a-post-request-in-node-js.html)，但我的第一选择始终是 Express。然而，直接使用 Express 不能完全遵循安全性的最佳实践。因此我们需要使用类似 [`helmet`](https://helmetjs.github.io/) 的模块来改善应用的安全性。

### 部署

在开始之前，请确认你已经安装好了 Node.js 以及 npm（或 yarn）。你可以[在 Node.js 官网下载以及查看安装指南](https://nodejs.org/en/download/)。

我们将以一个新的工程为例，不过你也可以将这些功能应用于现有的工程中。

在命令行中运行以下命令创建一个新的工程：

```
mkdir secure-express-demo
cd secure-express-demo
npm init -y
```

运行以下命令安装 Express 模块：

```
npm install express --save
```

在 `secure-express-demo` 目录下创建一个名为 `index.js` 的文件，加入以下代码：

```
const express = require('express');
const PORT = process.env.PORT || 3000;
const app = express();

app.get('/', (req, res) => {
  res.send(`<h1>Hello World</h1>`);
});

app.listen(PORT, () => {
  console.log(`Listening on http://localhost:${PORT}`);
});
```

保存文件，试运行看看它是否能正常工作。运行以下命令启动服务：

```
node index.js
```

访问 [http://localhost:3000](http://localhost:3000)，你应该可以看到 `Hello World`。

![hello-world.png](https://www.twilio.com/blog/wp-content/uploads/2017/11/iWq7mudUzwNSEw_IBcqBqZ9ah771qXS-SOzOng3EGIkBPVG6LoDhADeDKyCCFiF53KKrU0ZIDhEeSDz4HdjRzK3JsvigkR5wq4vYMLQS9ffmGhZ_omI9oBvTocxI_7QPLeUcsPNT.png)

### 检查 Headers

![giphy.gif](https://www.twilio.com/blog/wp-content/uploads/2017/11/M4qx6F5BhzDuSPYBHPEx74-xorzQFM8qD-Zi7FPS4In-cPvifztKGkHsRKE7wInEw9w6717-_GAC3HczMoXtFo-otYsS3DGTwQsj1IwdBw1gnssD2fW-sMdPuTz2QxBCcseUyIgP.png)

现在让我们通过增加与删除一些 HTTP headers 来改善应用安全性。你可以用一些工具来检查它的 headers，例如使用 `curl` 运行以下命令：

```
curl http://localhost:3000 --include
```

`--include` 标志可以让其输出 response 的 HTTP headers。如果你没有安装 `curl`，也可以用你最常用浏览器开发者工具的 network 面板代替。

你可以看到在收到的 response 中包含的以下 HTTP headers：

```
HTTP/1.1 200 OK
X-Powered-By: Express
Content-Type: text/html; charset=utf-8
Content-Length: 20
ETag: W/"14-SsoazAISF4H46953FT6rSL7/tvU"
Date: Wed, 01 Nov 2017 13:36:10 GMT
Connection: keep-alive
```

一般来说，由 `X-` 开头的 header 是非标准头部。请注意那个 `X-Powered-By` 的 header，它会暴露你使用的框架。对于攻击者来说，这可以降低攻击成本，因为他们只专注攻击此框架的已知漏洞即可。

### 戴上头盔（helmet）

![giphy.gif](https://www.twilio.com/blog/wp-content/uploads/2017/11/24T5xMrL0RCEEObLniOCuiZ4f4p-w6QUJWDJb4UlbayqlUnzn51IvLbbWH04jjVi1GxRzUX12_lseIPgJo0ZeW3TbO6ArTOS_B32kjbeUWfxb6qKp0_HNHbwolL40zF_1gCr3dbC.png)

来看看如果我们使用 `helmet` 会发生什么。运行以下命令安装 `helmet`：

```
npm install helmet --save
```

将 `helmet` 中间件加入你的应用中。对 `index.js` 进行如下修改：

```
const express = require('express');
const helmet = require('helmet');
const PORT = process.env.PORT || 3000;
const app = express();

app.use(helmet());

app.get('/', (req, res) => {
  res.send(`<h1>Hello World</h1>`);
});

app.listen(PORT, () => {
  console.log(`Listening on http://localhost:${PORT}`);
});
```

这样就使用了 `helmet` 的默认配置。接下来看看它做了什么事情。重启服务，再次通过以下命令检查 HTTP headers：

```
curl http://localhost:3000 --inspect
```

新的 headers 会类似于下面这样：

```
HTTP/1.1 200 OK
X-DNS-Prefetch-Control: off
X-Frame-Options: SAMEORIGIN
Strict-Transport-Security: max-age=15552000; includeSubDomains
X-Download-Options: noopen
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Content-Type: text/html; charset=utf-8
Content-Length: 20
ETag: W/"14-SsoazAISF4H46953FT6rSL7/tvU"
Date: Wed, 01 Nov 2017 13:50:42 GMT
Connection: keep-alive
```

首先值得庆祝的是 `X-Powered-By` header 不见了。但现在又多了好些新的 header，它们是做什么的呢？

#### X-DNS-Prefetch-Control

这个 header 对增加安全性并没有太大作用。它的值为 `off` 时，将关闭浏览器对页面中 URL 的 DNS 预读取。DNS 预读取可以提高你的网站的性能，根据 MDN 描述，它可以[增加 5% 或更高的图片加载速度](https://developer.mozilla.org/zh-CN/docs/Controlling_DNS_prefetching)。不过开启这项功能也可能会使用户在多次访问同一个网页时缓存出现问题。
> 译注：缓存问题未查到资料，如果您了解这块请留言

它的默认值是 `off`，如果你希望通过它提升性能，可以在调用 `helmet()` 时传入 `{ dnsPrefetchControl: { allow: true }}` 开启 DNS 预读取。

#### X-Frame-Options

`X-Frame-Options` 可以让你控制页面是否能在 `<frame/>`、`<iframe/>` 或者 `<object/>` 之类的页框内加载。除非你的确需要通过这些方式来打开页面，否则请通过下面的配置完全禁用它：

```
app.use(helmet({
  frameguard: {
    action: 'deny'
  }
}));
```

[所有的现代浏览器都支持 `X-Frame-Options`](http://caniuse.com/#feat=x-frame-options)。你也可以通过稍后将介绍的内容安全策略来控制它。

#### Strict-Transport-Security

它也被称为 HSTS（严格安全 HTTP 传输），用于确保在访问 HTTPS 网站时不出现协议降级（回到 HTTP）的情况。如果用户一旦访问了带有此 header 的 HTTPS 网站，浏览器就会确保将来再次访问次网站时不允许使用 HTTP 进行通信。此功能有助于防范中间人攻击。

有时，当你使用公共 WiFi 时尝试访问 https://google.com 之类的门户网页时就能看到此功能运作。WiFi 尝试将你重定向到他们的门户网站去，但你曾经通过 HTTPS 访问过 `google.com`，且它带有 `Strict-Transport-Security` 的 header，因此浏览器将阻止重定向。

你可以访问 [MDN](https://developer.mozilla.org/zh-CN/docs/Security/HTTP_Strict_Transport_Security) 或者 [OWASP wiki](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security_Cheat_Sheet) 查看更多相关信息。

#### X-Download-Options

这个 header 仅用于保护你的应用免受老版 IE 漏洞的困扰。一般来说，如果你部署了不能被信任的 HTTP 文件用于下载，用户可以直接打开这些文件（而不需要先保存到硬盘去）并且可以直接在你 app 的上下文中执行。这个 header 可以确保用户在访问这种文件前必须将其下载到本地，这样就能防止这些文件在你 app 的上下文中执行了。

你可以访问 [helmet 文档](https://helmetjs.github.io/docs/ienoopen/)和 [MSDN 博文](https://blogs.msdn.microsoft.com/ie/2008/07/02/ie8-security-part-v-comprehensive-protection/)查看更多相关信息。

#### X-Content-Type-Options

一些浏览器不使用服务器发送的 `Content-Type` 来判断文件类型，而使用“MIME 嗅探”，根据文件内容来判断内容类型并基于此执行文件。

假设你在网页中提供了一个上传图片的途径，但攻击者上传了一些内容为 HTML 代码的图片文件，如果浏览器使用 MIME 嗅探则会将其作为 HTML 代码执行，攻击者就能执行成功的 XSS 攻击了。

通过设置 header 为 `nosniff` 可以禁用这种 MIME 嗅探。

#### X-XSS-Protection

此 header 能在用户浏览器中开启基本的 XSS 防御。它不能避免一切 XSS 攻击，但它可以防范基本的 XSS。例如，如果浏览器检测到查询字符串中包含类似 `<script>` 标签之类的内容，则会阻止这种疑似 XSS 攻击代码的执行。这个 header 可以设置三种不同的值：`0`、`1` 和 `1; mode=block`。如果你想了解更多关于如何选择模式的知识，请查看 [`X-XSS-Protection` 及其潜在危害](https://blog.innerht.ml/the-misunderstood-x-xss-protection/) 一文。

#### 升级你的 helmet

以上只是 [`helmet`](https://helmetjs.github.io/docs/) 提供的默认设置。除此之外，它还可以让你设置 [`Expect-CT`](https://helmetjs.github.io/docs/expect-ct/)、[`Public-Key-Pins`](https://helmetjs.github.io/docs/hpkp/)、[`Cache-Control`](https://helmetjs.github.io/docs/nocache/) 和 [`Referrer-Policy`](https://helmetjs.github.io/docs/referrer-policy/) 之类的 header。你可以在 [`helmet` 文档](https://helmetjs.github.io/docs/) 中查找更多相关配置。

### 保护你的网页免受非预期内容的侵害

![giphy.gif](https://www.twilio.com/blog/wp-content/uploads/2017/11/CiDkwYBIJX1JQmhyaq8kYH0dkEpphioLjjva6KUWc5pS4KuSyX94eKxSfohWC_v574aYYn6Z2c6ALeyw0hizq7f66Po8ibiV1d_naYdPaoO1B8C72mQ4pLZij6ytKGH0v5WsQSPB.png)

跨站脚本执行对于 web 应用来说是无法根绝的威胁。如果攻击者可以在你的应用中注入并运行代码，其后果对于你和你的用户来说可能是一场噩梦。有一种能试图阻止在你网页中运行非预期代码的方案：`CSP`（内容安全策略）。

CSP 允许你设定一组规则，以定义你的页面能够加载资源的来源。任何违反规则的资源都会被浏览器自动阻止。

你可以通过修改 `Content-Security-Policy` HTTP header 来指定规则，或者你不能改 header 时也可以使用 meta 标签来设定。

这个 header 类似于这样：

```
Content-Security-Policy: default-src 'none';
    script-src 'nonce-XQY ZwBUm/WV9iQ3PwARLw==';
    style-src 'nonce-XQY ZwBUm/WV9iQ3PwARLw==';
    img-src 'self';
    font-src 'nonce-XQY ZwBUm/WV9iQ3PwARLw==' fonts.gstatic.com;
    object-src 'none';
    block-all-mixed-content;
    frame-ancestors 'none';
```

在这个例子中，你可以看到我们只允许从自己的域名或者 Google Fonts 的 fonts.gstatic.com 来获取字体；只允许加载本域名下的图片；只允许加载不指定来源，但必须包含指定 `nonce` 值的脚本及样式文件。这个 nonce 值需要用下面这样的方式指定：

```
<script src="myscript.js" nonce="XQY ZwBUm/WV9iQ3PwARLw=="></script>
<link rel="stylesheet" href="mystyles.css" nonce="XQY ZwBUm/WV9iQ3PwARLw==" />
```

当浏览器收到 HTML 时，为了安全起见它会清除所有的 nonce 值，其它的脚本无法得到这个值，也就无法添加进网页中了。

你还可以禁止所有在 HTTPS 页面中包含的 HTTP 混合内容和所有 `<object />` 元素，以及通过设置 `default-src` 为 `none` 来禁用一切不为图片、样式表以及脚本的内容。此外，你还可以通过 `frame-ancestors` 来禁用 iframe。

你可以自己手动去编写这些 header，不过走运的是 Express 中已经有了许多现成的 CSP 解决方案。[`helmet` 支持 CSP](https://helmetjs.github.io/docs/csp/)，但 `nonce` 需要你自己去生成。我个人为此使用了一个名为 `express-csp-header` 的模块。

安装及运行 `express-csp-header`：

```
npm install express-csp-header --save
```

为你的 `index.js` 添加并修改以下内容，启用 CSP：

```
const express = require('express');
const helmet = require('helmet');
const csp = require('express-csp-header');

const PORT = process.env.PORT || 3000;
const app = express();

const cspMiddleware = csp({
  policies: {
    'default-src': [csp.NONE],
    'script-src': [csp.NONCE],
    'style-src': [csp.NONCE],
    'img-src': [csp.SELF],
    'font-src': [csp.NONCE, 'fonts.gstatic.com'],
    'object-src': [csp.NONE],
    'block-all-mixed-content': true,
    'frame-ancestors': [csp.NONE]
  }
});

app.use(helmet());
app.use(cspMiddleware);

app.get('/', (req, res) => {
  res.send(`
    <h1>Hello World</h1>
    <style nonce=${req.nonce}>
      .blue { background: cornflowerblue; color: white; }
    </style>
    <p class="blue">This should have a blue background because of the loaded styles</p>
    <style>
      .red { background: maroon; color: white; }
    </style>
    <p class="red">This should not have a red background, the styles are not loaded because of the missing nonce.</p>
  `);
});

app.listen(PORT, () => {
  console.log(`Listening on http://localhost:${PORT}`);
});
```

重启服务，访问 [http://localhost:3000](http://localhost:3000)，可以看到一个带有蓝色背景的段落，因为相关的样式成功被加载了。而另一个段落没有样式，因为其样式缺少了 nonce 值。

![csp-output.png](https://www.twilio.com/blog/wp-content/uploads/2017/11/OYQ_GhVogC6bcGAZOtqKO9DL4l4KhV8YatnWhJP9sjliXdN7beuXhTbPLwyvCQmqyxmy-z5FN4_mDySsRorhjOxarh2p1EAWKusxZ4qSIsI0CAq_1p_BlrhFiCoG6mPa4iZhR2WO.png)

CSP header 还可以设定报告违规的 URL，你还可以在严格启用 CSP 之前仅开启报告模式，收集相关数据。

你可以在 [MDN CSP 介绍](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Security-Policy__by_cnvoid)查看更多信息，并浏览 [“Can I Use” 网站查看 CSP 兼容性](http://caniuse.com/#feat=contentsecuritypolicy)。大多数主流浏览器都支持这项特性。

### 总结

![giphy.gif](https://www.twilio.com/blog/wp-content/uploads/2017/11/JtIZ-AdTwknGCyMvERM7uj2ttVknsuo6KgKDzKGlOS-TWUu3GVTEtqu-TxByxxaptnsZsvoXPll__9_5ScxtUnoTDqPzuPuGcGSuYNDKHljkTF6XP8xUYWuqtCuqScWryS3me3M5.png)

可惜的是，在安全性方面不存在所谓的万能方案，新的漏洞层出不穷。但是，你可以很轻松地在你的 web 应用中设置这些 HTTP header，显著地提升你应用的安全性，何乐而不为呢？如果你想了解更多有关 HTTP header 提高安全性的最佳实践，请浏览 [securityheaders.io](https://securityheaders.io/)。

如果你想了解更多 web 安全方面的最佳实践，请访问 [Open Web Applications Security Project（OWASP）](https://www.owasp.org/index.php/Main_Page)，它涵盖了广泛的主题及有用的资源。

如果你有任何问题，或有其它用于提升 Node.js web 应用的工具，请随时联系我：

*   Twitter：[@dkundel](https://twitter.com/dkundel)
*   Email：[dkundel@twilio.com](mailto:dkundel@twilio.com)
*   GitHub：[dkundel](https://github.com/dkundel)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


