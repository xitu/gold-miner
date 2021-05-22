> - 原文地址：[Deep dive in CORS: History, how it works, and best practices](https://ieftimov.com/post/deep-dive-cors-history-how-it-works-best-practices/)
> - 原文作者：[Ilija Eftimov](https://ieftimov.com/)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/deep-dive-cors-history-how-it-works-best-practices.md](https://github.com/xitu/gold-miner/blob/master/article/2021/deep-dive-cors-history-how-it-works-best-practices.md)
> - 译者：[snowyYU](https://github.com/snowyYU)
> - 校对者：[Kimhooo](https://github.com/Kimhooo)、[Chorer](https://github.com/Chorer)

# 深入理解 CORS：发展史、工作原理和最佳实践

了解同源策略和 CORS 的历史和演变，深入了解 CORS 和各种跨域访问的类型，并学习（一些）最佳实践。

## 译者注：

- 本篇中使用的浏览器为 FireFox 浏览器，代码演示结果和 Chrome 浏览器等略有差别。
- 后端 nodejs 版本代码可以在[这里](https://github.com/snowyYU/Deep-dive-in-CORS-BK-Code)查看。

## 浏览器控制台常见的报错信息

> No ‘Access-Control-Allow-Origin’ header is present on the requested resource.

> Cross-Origin Request Blocked: The Same Origin Policy disallows reading the remote resource at [https://example.com/](https://example.com/)

> Access to fetch at ‘[https://example.com](https://example.com)’ from origin ‘http://localhost:3000’ has been blocked by CORS policy.

这些报错你肯定见到过，没见过的话也没关系，下文会出现很多 CORS 相关的错误信息供你参考。

看到这些报错总会使人特别烦躁。不过平心而论，CORS 绝对是个特别有用的机制，可以有效的规避后端服务因配置上的问题导致的漏洞，防止恶意攻击，推动 web 标准的演化。

让我们从头说起吧

## 从第一个子资源的诞生说起

子资源是一个 HTML 元素，通常被嵌入到文档流中，或者在相关上下文中被执行（比如 `<script>` 标签）。[1993 年](http://1997.webhistory.org/www.lists/www-talk.1993q1/0182.html)，第一个子资源 `<img>` 被引入进来。随着 `<img>` 标签的引入，网站得以变得更加美观，当然，也是从这时起，网站开始变得越来越复杂。

![回首 1993](https://ieftimov.com/back-to-the-origin-with-cors/meet-img.png)

你可以看到，如果浏览器需要渲染一个带有 `<img>` 标签的页面，它会从一个地方获取相关的子**资源**。当浏览器发起资源请求时，发起请求地址相较于目标地址，如果协议、域名、端口号三者中有一个或者一个以上不相同当话，那么这个请求就是**跨域请求**。

### 源和跨域

一个完整的源由三者组成：协议、合规的域名和端口，比如说，`http://example.com` 和 `https://example.com` 两者是不同的源 —— 第一个使用 `http` 协议而第二个使用 `https` 协议。 此外，`http` 默认使用 80 端口，而`https` 默认使用 443 端口。虽然域名都是 `example.com` ，但它们有着不同的协议和端口，所以属于不同的源。

懂了吧 —— 上文提到的三个因素中只要有一个不一致，那它们的源就不是同一个。

我们将 `https://blog.example.com/posts/foo.html` 和如下的 URL 做个对比，是否同源一目了然：

| URL                                            | Result | Reason                                |
| ---------------------------------------------- | ------ | ------------------------------------- |
| `https://blog.example.com/posts/bar.html`      | 同源   | 只有路径不同                          |
| `https://blog.example.com/contact.html`        | 同源   | 只有路径不同                          |
| `http://blog.example.com/posts/bar.html`       | 不同源 | 不同协议                              |
| `https://blog.example.com:8080/posts/bar.html` | 不同源 | 不同端口 (`https://` 默认为 443 端口) |
| `https://example.com/posts/bar.html`           | 不同源 | 不同主机名                            |

举个例子来说明跨域请求，假如 `http://example.com/posts/bar.html` 这个页面尝试去渲染来自 `https://example.com` 这个地址的资源，那么就产生了跨域请求（注意它们的协议不同）。

### 跨域请求的危害多多

上文我们了解了什么是同源，什么是跨域，现在来看看主要存在的问题。

在引入了 `<img>` 之后，新的标签更是扎堆涌现出来。比如 `<script>`、`<frame>`、`<video>`、`<audio>`、`<iframe>`、`<link>`、`<form>` 等等。在网页的加载过程中，可以通过上述的标签获取到页面需要的资源，而这些获取资源的请求既有可能是同源的也有可能是跨域的。

想象一下，如果不存在 CORS，并且浏览器允许各种跨域请求。

假如在我 `evil.com` 域名下的页面上有一个 `<script>` 标签。看起来这只是个普普通通的页面，用户可以在上面获取一些有用的信息。实际上，在 `<script>` 标签中，我写了一段向银行的 `DELETE /account` 接口发起请求的代码。由于上文我们假设浏览器允许各种跨域请求，所以每当你访问这个页面时，都会有个 AJAX 请求悄悄地调用银行的 API。

![噗，你的账号完犊子了🌬](https://ieftimov.com/back-to-the-origin-with-cors/malicious-javascript-injection.png)

嘿嘿 —— 想象一下你正悠闲地浏览网页，突然就收到了一封来自银行的邮件，内容是恭喜你成功删除了你的账户。我知道你在想啥，如果这么简单就能把账户删掉的话，那就能对银行做**任何事**了，咳咳，离题了。

为了让我的邪恶 `<script>` 能正常工作，我还需要在请求中加入来自目标银行网站的认证信息（cookies）。这样银行的服务器就知道你是谁和要删谁的账户啦。

我们看看另外一个没那么邪恶的例子。

我想知道**棒棒公司**的员工信息，他们公司的内网是 `intra.awesome-corp.com`。在我的网站 `dangerous.com` 上，我放置了一个标签 `<img src="https://intra.awesome-corp.com/avatars/john-doe.png">`。

对于那些没有目标公司内网 `intra.awesome-corp.com` 访问权限的人来说，上文的标签是加载不出来图片的 —— 会产生一个错误信息。相反，如果你可以连上棒棒公司内网的话，此时你打开 `dangerous.com` 网站，那么我就知道你有棒棒公司内网的访问权限了。

这意味着我将能够获得有关你的一些信息。 虽然这些信息不足以让我发起一次有价值的攻击，不过你能访问棒棒公司的内网，这条消息对于攻击发起者来说就比较有价值了。

![向第三方泄露信息 💦](https://ieftimov.com/back-to-the-origin-with-cors/resource-embed-attack-vector.png)

以上两个例子非常简单，不过也恰恰说明了同源策略和 CORS 的必要性。当然跨域请求的危害也不止这些。有的危害我们可以避免，但也有一些危害让我们束手无策 —— 它们天然根植于网络当中。不过目前通过媒介发起的攻击已经大大减少 —— 这多亏了 CORS。

不过在聊起 CORS 之前，还是先说说同源策略吧。

## 同源策略

同源策略通过阻断从不同源加载的资源的读取权限来防止跨域攻击。不过这个策略还是允许一些标签加载不同源的资源，比如说 `<img>` 标签。

同源策略在 1995 时被引入 Netscape Navigator 2.02，最初旨在保护对 DOM 的跨域访问。

尽管没有硬性要求同源策略的实现要遵循某个确切的规范，但所有的现代浏览器都用自己的方式实现了这个策略。关于同源策略的细则阐述，可以在互联网工程任务组（IETF）的 [RFC6454](https://tools.ietf.org/html/rfc6454) 找到。

此规则集定义了同源策略的实现：

| Tags                  | Cross-origin | Note                                                       |
| --------------------- | ------------ | ---------------------------------------------------------- |
| `<iframe>`            | 允许嵌入     | 取决于 `X-Frame-Options`                                   |
| `<link>`              | 允许嵌入     | 可能需要正确的 `Content-Type`                              |
| `<form>`              | 允许写入     | 经常用此标签进行跨域写入操作                               |
| `<img>`               | 允许嵌入     | 禁止通过 JavaScript 跨域读取并将其加载到 `<canvas>` 标签中 |
| `<audio>` / `<video>` | 允许嵌入     |                                                            |
| `<script>`            | 允许嵌入     | 可能会被禁止访问特定的 API                                 |

同源策略解决了很多问题，但是也带来了诸多的限制。特别是在单页应用和富媒体网站中，它的众多规则反而限制了网站的发展。

在这种背景下，CORS 诞生了，其目标就是在同源策略的框架内为跨域访问提供更加灵活的方式。

## 走进 CORS

目前我们已经搞清楚了什么是源、它是怎么定义的、跨域请求的缺点以及浏览器实现的同源策略。

现在是时候让我们熟悉跨源资源共享（CORS）了。CORS 是一种机制，允许通过网络控制对网页上子资源的访问。该机制将子资源的访问分为三种：

1. 跨域写操作
2. 跨域资源嵌入
3. 跨域读操作

在我们详细介绍这三者之前，需要明白，尽管浏览器（默认情况下）可能允许某种类型的跨域请求，但是这**并不意味着该请求会被服务器接收**。

**跨域写入**包括链接、重定向和表单提交。在浏览器启用 CORS 的情况下，所有的这些操作都**被允许**。有些情况下会产生一个叫做**预检请求**的东西，这时可能会影响到跨域写操作，我们在下文会详细地说明这种情况。

**跨域嵌入**是指通过 `<script>`、`<link>`、`<img>`、`<video>`、`<audio>`、`<object>`、`<embed>`、`<iframe>` 等标签加载的子资源。默认情况下它们均被**允许**跨域嵌入。不过 `<iframe>` 有点特别 —— 因为它的目的是在框架内加载不同的页面，可以使用 `X-Frame-options` 响应头控制其是否可以跨域加载。

像 `<img>` 这种可以嵌入网站的子资源 —— 它们诞生的原因之一就是为了获取不同源的资源。这就是为什么在 CORS 中区分跨域嵌入和跨域读取，并且相应的处理方式也不同。

**跨域读取** 是由 AJAX / `fetch` 获取子资源所产生的。 默认情况下，浏览器会**限制**此类请求。当然，有一种通过嵌入子资源的方法也能实现跨域读取，不过相应地，如今的浏览器也存在着另一个策略来应对这种方法。

如果你的浏览器已更新至最新版本，那么它应该已经实现以上的策略了。

### 跨域写操作

执行跨域写入操作有时不会成功，让我们看一个例子，看看 CORS 的具体作用。

首先，我们看下使用 [Crystal](https://crystal-lang.org/) (框架使用 [Kemal](https://kemalcr.com/)) 语言实现的一个 HTTP 服务：

```crystal
require "kemal"

port = ENV["PORT"].to_i || 4000

get "/" do
  "Hello world!"
end

get "/greet" do
  "Hey!"
end

post "/greet" do |env|
  name = env.params.json["name"].as(String)
  "Hello, #{name}!"
end

Kemal.config.port = port
Kemal.run
```

在 `/greet` 路径中接收一个请求，首先获取了请求体中的 `name` 属性值，之后返回了 `Hello #{name}!`。我们使用如下的命令来启动这个小服务：

```bash
$ crystal run server.cr
```

服务启动并开始监听 `localhost:4000`。通过浏览器访问 `localhost:4000`，将会看到 “Hello World”：

![Hello, world! 🌍](https://ieftimov.com/back-to-the-origin-with-cors/hello-world-localhost.png)

好啦，我们的服务已经成功运行了，现在从浏览器的控制台向 `localhost:4000` 发起一个 `POST /greet` 请求吧。我们使用 `fetch` 方法发起请求：

```javascript
fetch('http://localhost:4000/greet', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ name: 'Ilija' }),
})
  .then((resp) => resp.text())
  .then(console.log)
```

执行此段代码后，我们收到了来自服务的问候：

![Hi there! 👋](https://ieftimov.com/back-to-the-origin-with-cors/hello-world-localhost-post.png)

这是一个没有跨域的 `POST` 请求，是从 `http://localhost:4000`（和请求目标地址同源）页面发起的同源请求。

我们尝试向此地址发送一个跨域请求。我们打开 `https://google.com`，然后从此标签页发起一个和上文相同的请求：

![Hello, CORS! 💣](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post.png)

通过此方法，我们看到了著名的 CORS 错误。尽管 Crystal 服务可以响应这个请求，我们的浏览器还是拦截了请求。从报错信息我们可以了解到，请求在尝试进行跨域写入操作。

第一个例子中，我们从 `http://localhost:4000` 页面向 `http://localhost:4000/greet` 发起请求，因为页面地址和目标地址同源，所以浏览器没有拦截此请求。相反在第二个例子中，从网站（`https://google.com`）发起的请求试图向 `http://localhost:4000` 执行写入操作，然后浏览器对请求做了标记，并且拦截了它。

### 预检请求

查看开发者控制台中 Network 标签页里的内容，我们会看到上述代码发起了两次请求：

![在 “Network” 面板中看到两个出站请求](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-network.png)

有趣的是第一个请求的方法是 `OPTIONS`，而第二个请求的方法是 `POST`。

仔细观察下 `OPTIONS` 请求，会发现浏览器先发送了`OPTIONS` 请求，再发送了 `POST` 请求：

![细究下 OPTIONS 请求 🔍](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-network-options.png)

有意思的是，即使 `OPTIONS` 请求的响应已经是 HTTP 200，在请求列表中它还是被标记为红色了，这是为什么呢？

这是现代浏览器发起的**预检请求**。如果 CORS 认为一个请求是复杂请求，那么浏览器会先发起预检请求。判定一个请求为 **复杂** 请求的标准如下：

- 请求使用的方法不是 `GET`、`POST` 或者 `HEAD`
- 请求头包含了 `Accept`、`Accept-Language` 和 `Content-Language` 以外的字段
- 请求头包含了 `Content-Type` 字段，且它的值不在 `application/x-www-form-urlencoded`、`multipart/form-data` 和 `text/plain` 三者中

因此在上文的例子中，即使我们发起的是 `POST` 请求，但是由于请求头中的 `Content-Type: application/json`，浏览器最后还是判定我们的请求为复杂请求。

如果我们修改下我们的请求和服务，使之可以发送并处理 `text/plain` 类型的内容（代替 JSON），那么浏览器就不会发起预检请求了：

```crystal
require "kemal"

get "/" do
  "Hello world!"
end

get "/greet" do
  "Hey!"
end

post "/greet" do |env|
  body = env.request.body

  name = "there"
  name = body.gets.as(String) if !body.nil?

  "Hello, #{name}!"
end

Kemal.config.port = 4000
Kemal.run
```

现在我们可以发起请求头带有 `Content-type: text/plain` 的请求了:

```javascript
fetch('http://localhost:4000/greet', {
  method: 'POST',
  headers: {
    'Content-Type': 'text/plain',
  },
  body: 'Ilija',
})
  .then((resp) => resp.text())
  .then(console.log)
```

看吧，这次就没有预检请求了，不过浏览器的 CORS 策略仍在拦截响应：

![CORS 依然坚挺](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-text-plain.png)

不过也正因为我们这次发起的不是**复杂**请求，所以我们的浏览器 **也并没有拦截请求**:

![请求发起成功 ➡️](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-text-plain-response-blocked.png)

简而言之：针对 `text/plain` 这种跨域请求，由于我们的服务**缺少响应的配置**，导致无法处理此请求，也没有做异常的统一处理，这部分和浏览器也没什么关系。不过浏览器尽力做到了如下的措施 —— 它不会将响应直接暴露在页面和请求列表中。因此，在此例中，CORS 没有拦截请求 —— **它拦截了响应**。

浏览器中的 CORS 策略认为此请求是一个跨域读取请求，即使请求的方法为 `POST`，请求头中 `Content-type` 的属性值却说明了它本质上和 `GET` 请求无异。跨域读取请求默认会被拦截，因此在请求列表中我们看到了被拦截的响应。

消除预检请求以应对 CORS 策略可并不是一个好办法，实际上，如果你希望服务器可以妥善处理预检请求，那就应该针对 `OPTIONS` 方式的请求返回带有正确响应头的响应。

在处理 `OPTIONS` 请求时，你需要知道浏览器会特别关注三个出现在预检请求响应头的属性：

- `Access-Control-Allow-Methods` —— 这个属性标识了在 CORS 策略下，响应的 URL 支持哪些请求方法。
- `Access-Control-Allow-Headers` —— 这个属性标识了在 CORS 策略下，响应的 URL 支持哪些请求头。
- `Access-Control-Max-Age` —— 它表示可以缓存 `Access-Control-Allow-Methods` 和 `Access-Control-Allow-Headers` 头部中提供的信息的秒数（默认为 5）。

现在看一下上文举例的复杂请求：

```javascript
fetch('http://localhost:4000/greet', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ name: 'Ilija' }),
})
  .then((resp) => resp.text())
  .then(console.log)
```

从上文我们已经知道，当发起这个请求时，我们的浏览器会先根据预检请求的响应来检查服务器是否可以处理跨域请求。为了能正确地响应这个跨域请求，我们首先要将 `OPTIONS /greet` 端点加入我们的服务中。在这服务的响应头中, 新加入的端点会告知浏览器：来自源 `https://www.google.com` 并且带有 `Content-type: application/json` 头部的 `POST /greet` 请求可以被接收。

为了达到目标，我们使用 `Access-Control-Allow-*` 这种响应头部：

```crystal
options "/greet" do |env|
  # Allow `POST /greet`...
  env.response.headers["Access-Control-Allow-Methods"] = "POST"
  # ...with `Content-type` header in the request...
  env.response.headers["Access-Control-Allow-Headers"] = "Content-type"
  # ...from https://www.google.com origin.
  env.response.headers["Access-Control-Allow-Origin"] = "https://www.google.com"
end
```

重启服务，再次发起请求：

![还是被拦截了？ 🤔](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-blocked.png)

我们的请求仍然被拦截了。即使我们的 `OPTIONS /greet` 端点确实对请求做了合适的处理，但我们还是看到了报错信息。不过开发者工具中的网络标签向我们展示了一些有趣的信息：

![OPTIONS 那行请求变成绿色了！ 🎉](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-blocked-network-inspect.png)

向 `OPTIONS /greet` 端点发起的请求成功了！但是 `POST /greet` 调用仍然失败。如果我们看一下 `POST /greet` 请求的内部结构，我们将看到一个熟悉的信息：

![POST 也是成功的？ 😲](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-blocked-post-inspect.png)

实际上，请求成功了 —— 服务返回了 HTTP 200。预检请求确实起效了 —— 浏览器顺利发起了 `POST` 请求。但是针对 `POST` 请求的响应中没有包含有关 CORS 的头部信息，所以即使浏览器发起了请求，但响应也被它自己拦截了。

为了使浏览器正确处理来自 `POST /greet` 请求的响应，我们也需要为 `POST` 端点加一个 CORS 头部：

```crystal
post "/greet" do |env|
  name = env.params.json["name"].as(String)

  env.response.headers["Access-Control-Allow-Origin"] = "https://www.google.com"

  "Hello, #{name}!"
end
```

我们给响应头加了 `Access-Control-Allow-Origin` 属性后，会告知浏览器打开 `https://www.google.com` 的标签页可以访问响应内容。

再尝试一下：

![POST 成功啦！](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-success.png)

我们看到 `POST /greet` 返回了正确的响应内容，同时没有任何报错。再瞄一眼 Network 标签，会发现两个请求都是绿色的了：

![OPTIONS & POST 成功！ 💪](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-success-network.png)

通过在预检端点 `OPTIONS /greet` 使用正确的响应头，使跨域请求可以访问我们服务中的 `POST /greet` 端点。最重要的是，在为 `POST /greet` 端点添加正确的 CORS 响应头信息后，浏览器终于可以不再拦截跨域响应了。

### 跨域读取

正如我们上文提到的那样，默认情况下跨域读取会被拦截。这是故意的 —— 我们不会想在当前页面上加载其他源上的资源。

假如我们在 Crystal 服务中加入对 `GET /greet` 请求的操作：

```crystal
get "/greet" do
  "Hey!"
end
```

我们从 `www.google.com` 页面试着请求 `GET /greet` 端点，会发现遭到了 CORS 拦截：

![CORS 拦截 🙅](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-get.png)

仔细查看下请求内容，我们会发现一些有趣的东西：

![ GET 请求成功 🎉](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-get-blocked-inspect.png)

如之前一样，浏览器确实让请求顺利发起了 —— 收到了 HTTP 200 的响应。不过浏览器没有将那个请求的响应显示在页面/控制台中。同样的，这个例子中 CORS 没有拦截请求 —— **它拦截的是响应**。

就像跨域写入操作一样，我们可以设置 CORS 并使其可用于跨域读取 —— 通过添加带有 `Access-Control-Allow-Origin` 的头部信息：

```crystal
get "/greet" do |env|
  env.response.headers["Access-Control-Allow-Origin"] = "https://www.google.com"
  "Hey!"
end
```

浏览器获取到来自服务器的响应时，它会去检查响应头的 `Access-Control-Allow-Origin` 属性值，用以决定是否让页面读取响应内容。现在我们将值设为 `https://www.google.com` 后，就可以正确地加载响应了：

![成功发起 GET 跨域请求 🎉](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-get-success.png)

这样浏览器既可以防止跨域读取造成的危害，又给予后端服务一定的操作空间，使之可以响应特定的跨域请求。

## 配置 CORS

如上文例子中做的那样，为了迎合浏览器中的 CORS 策略，我们针对 `/greet` 请求的处理设置了响应头中 `Access-Control-Allow-Origin` 属性值为 `https://www.google.com`：

```crystal
post "/greet" do |env|
  body = env.request.body

  name = "there"
  name = body.gets.as(String) if !body.nil?

  env.response.headers["Access-Control-Allow-Origin"] = "https://www.google.com"
  "Hello, #{name}!"
end
```

这将允许 `https://www.google.com` 源调用我们的服务，并且浏览器没报任何错误。设置好 `Access-Control-Allow-Origin` 的值后，我们可以尝试再次执行 `fetch` 操作：

![成功！ 🎉](https://ieftimov.com/back-to-the-origin-with-cors/google-cross-origin-post-text-plain-success.png)

成功了！现在可以从 `https://www.google.com` 向 `/greet` 发起跨域请求了。或者，我们可以设置头部中相应的属性值为 `*`，这样浏览器会允许任何源向我们的服务发起正确的跨域请求。
配置成此值需要三思而后行，不过**大多数情况下**是安全的。这里有一条总结出来的建议可供你参考：如果跨域请求从浏览器无痕模式下的标签发出，并且其获取到的数据也正是你想展示的，那么你就可以设置一个宽松的值（`*`）来应对 CORS 策略。

另一种配置 CORS 使之放宽对请求限制的方法是使用带有 `Access-Control-Allow-Credentials` 属性的响应头。当请求的 credetials 模式为 `include` 时，浏览器会根据响应头中 `Access-Control-Allow-Credentials` 的值来决定是否将响应暴露给前端 JavaScript 代码。

请求中的 credetials 模式出自 [Fetch API](https://fetch.spec.whatwg.org/) 文档，其起源可追溯到原始 XMLHttpRequest 对象：

```javascript
var client = new XMLHttpRequest()
client.open('GET', './')
client.withCredentials = true
```

从 `fetch` 方法的文档中我们了解到， XML 中的 `withCredentials` 属性在 `fetch` 方法的调用中是作为一个可选的参数使用的：

```javascript
fetch('./', { credentials: 'include' }).then(/* ... */)
```

可选的 `credentials` 属性值为 `omit`、`same-origin` 和 `include`。后端服务可以根据请求中不同的 `credentials` 属性值，决定浏览器怎样显示响应（通过 `Access-Control-Allow-Credentials` 响应头）。

Fetch API 说明文档将 CORS 和 `fetch` API 的交互以及浏览器所采用的安全性机制做了详细的[划分与说明](https://fetch.spec.whatwg.org/#cors-protocol-and-credentials)。

## 一些最佳实践

在总结之前，让我们介绍一下跨源资源共享（CORS）的一些最佳实践。

### 面向海量用户

一个常见的例子是，如果你拥有一个网站，该网站显示的内容是公开的，它不需要用户付费、验证身份或授权后才能查看 —— 这种情况下你可以针对获取这些内容的请求设置响应头 `Access-Control-Allow-Origin: *`。

在下列场景中将值设为 `*` 会比较好：

- 大量用户可以不受限制地访问此资源
- 此资源需要不受限制地被大量用户访问
- 访问资源的源和客户端种类繁多，无法设置特定的值，或者你根本不在乎跨域请求造成的问题

如果将此设置应用于响应私有网络（比如受防火墙保护，或者需要挂载 VPN 才可以访问）上资源的请求，会有一定的风险。当你通过 VPN 连上公司的内网后，有了内网文件的访问权限：

![简化 VPNs 连接的示例](https://ieftimov.com/back-to-the-origin-with-cors/vpn-access-diagram.png)

现在，假设攻击者的网站 `dangerous.com` 上有一个连接到内网文件的链接，则他们（理论上）可以在其网站上创建有该文件访问权限的脚本：

![文件泄漏](https://ieftimov.com/back-to-the-origin-with-cors/vpn-access-attacker-diagram.png)

虽然发起这样的攻击很难，并且需要大量有关 VPN 及其中存储的文件的知识，但我们必须要意识到设置为 `Access-Control-Allow-Origin: *` 是有潜在风险的。

### 面向内部

继续上文的例子，假设我们需要对自己的网站进行统计分析，我们可能需要借助用户浏览器发送的相关数据去采集用户的体验和行为。

常见的方法是定期使用 JavaScript 从用户的浏览器发起异步请求。后端有个 API 用来接收这些请求，然后进行数据上的存储和处理。

此例中，我们的后端 API 是公共的，不过我们可不希望 **任何** 网站都可以向我们的数据采集 API 发送数据。实际上，我们只对来自我们自己网站上的请求感兴趣 —— 就是这样。

![](https://ieftimov.com/back-to-the-origin-with-cors/no-cross-origin-api.png)

此例中，我们将 API 的响应头属性 `Access-Control-Allow-Origin` 值设置为我们网站的 URL。这样的话来自别的源的请求会被浏览器拦截。

即使用户或别的网站拼命地塞数据到我们的统计接口，在 API 资源响应头部设置的 `Access-Control-Allow-Origin` 属性也不会让请求通过：

![](https://ieftimov.com/back-to-the-origin-with-cors/failed-cross-origin-api.png)

### 请求头中 Origin 属性值为 NUll

另一个有趣的例子是 `null` 源。当使用浏览器直接打开一个带有资源请求的本地文件时，就会出现这种情况。比如，来自本地计算机上静态文件中运行的某些 JavaScript 的请求会将请求头中的 `Origin` 属性设置为 `null`。

在这种情况下，如果我们的服务不允许 origin 值为 `null` 的请求访问我们的资源，那么此举可能会影响到开发人员的效率。在你的网站/产品是面向开发人员的情况下，可以通过设置 `Access-Control-Allow-Origin` 来允许这种类型的跨域请求访问资源。

### 尽量避免使用 cookies

上文中我们聊到了在使用 `Access-Control-Allow-Credentials` 字段的时候，默认情况下是不允许请求中带上 cookies 的，只需要设置响应头 `Access-Control-Allow-Credentials: true` 就可以允许跨域请求发送 cookie 了。这会告知浏览器后端服务允许跨域请求携带认证信息（比如 cookies）。

允许并接受跨域 Cookie 可能会有一定的风险。此举会将自身暴露给潜在的攻击媒介，所以应该在**非常必须**的时候才开启它。

当你确切知道哪些客户端将访问你的服务器时，此时跨域 Cookie 才能发挥其自身的价值。这正是当允许跨域请求携带认证信息时，CORS 规则不允许我们设置 `Access-Control-Allow-Origin: *` 的原因

单纯从技术上来说，`Access-Control-Allow-Origin: *` 和 `Access-Control-Allow-Credentials: true` 是可以组合起来使用的，不过此种情况是一个[反面模式](https://zh.wikipedia.org/wiki/%E5%8F%8D%E9%9D%A2%E6%A8%A1%E5%BC%8F)，应该避免这样使用。

如果你希望服务可以被不同的客户端和源访问，则应该考虑开发一个 API 生成认证信息（使用基于 token 的身份验证）而不是使用 Cookie。但是，如果无法采用 API 方式解决问题，那么请确保你针对跨站请求伪造（CSRF）进行了防御。

## 附加阅读

希望这篇（长）文章可以让你对 CORS 有清晰的认知，包括其原理还有其存在的意义。下面有一部分是本文的参考链接，还有一些是我个人觉得很棒的关于 CORS 的文章：

- [Cross-Origin Resource Sharing (CORS)](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- [`Access-Control-Allow-Credentials` header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Credentials) on MDN Web Docs
- [Authoritative guide to CORS (Cross-Origin Resource Sharing) for REST APIs](https://www.moesif.com/blog/technical/cors/Authoritative-Guide-to-CORS-Cross-Origin-Resource-Sharing-for-REST-APIs/)
- The [“CORS protocol” section](https://fetch.spec.whatwg.org/#http-cors-protocol) of the [Fetch API spec](https://fetch.spec.whatwg.org)
- [Same-origin policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy) on MDN Web Docs
- [Quentin’s](https://stackoverflow.com/users/19068/quentin) great [summary of CORS](https://stackoverflow.com/a/35553666) on StackOverflow

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
