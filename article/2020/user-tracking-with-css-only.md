> * 原文地址：[User-Tracking With CSS Only](https://medium.com/javascript-in-plain-english/tracking-with-css-ec98e3d81046)
> * 原文作者：[Louis Petrik](https://medium.com/@louispetrik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/user-tracking-with-css-only.md](https://github.com/xitu/gold-miner/blob/master/article/2020/user-tracking-with-css-only.md)
> * 译者：[黄梵高](https://github.com/mangotsing)
> * 校对者：[zenblo](https://github.com/zenblo)

# 只使用 CSS 进行用户追踪

![来源：作者](https://tva1.sinaimg.cn/large/007S8ZIlly1gjuhozerabj312w0t6ab1.jpg)

在浏览器里进行用户追踪会引发关于隐私和数据保护一次又一次的讨论。类似 Google 分析之类的工具几乎可以抓到所有需要的内容，包括来源，语言，设备，停留时间等等。

但是，想获取一些感兴趣的信息，你可能不需要任何外部追踪器，甚至不需要 JavaScript。本文将向你展示，即便用户禁用了 JavaScript，依然可以跟踪用户的行为。

## 追踪器通常如何工作

通常，这类追踪器分析工具要使用到 JavaScript。因此，大多数等信息可以十分轻松的读取，并且可以立刻发送到服务端。

这就是为什么出现越来越多的方式来阻止浏览器中跟踪器的原因。。某些勇敢的浏览器或者某些 chrome 扩展程序会阻止跟踪器的加载，例如 google 分析。
其中一个诀窍是，例如 Google 分析总是从外部集成的，一段来自 Google CDN 的 JavaScript 代码。嵌入的 URL 总是相同的，因此可以轻松的将它阻止掉。

因此追踪器总是会用 JavaScript 做些什么。甚至如果你通过阻止 URL 限制了追踪器，网站拥有者可能会通过将 JavaScript 代码嵌入页面的方式继续使用。最强有力的保护措施就是禁用 JavaScript，虽然这可能会付出非常大的代价。

最后，我们仍然可以不使用 JavaScript 追踪一些内容，而是使用一些 CSS 技巧。当然 CSS 并不是为追踪使用的，让我们开始实践吧。

## 找到设备类型信息

媒体查询应该是每一个 web 开发者都知道的。有了这个，我们可以让 CSS 代码只在某些确定的屏幕条件下执行。所以我们可以为智能手机或平板电脑等，编写自己的查询条件。

我们所有 CSS 追踪器背后的魔法就是它们的属性，比如我们可以将一段 URL 作为属性值。有一个比较好的例子是 background-image 的属性，它允许我们为一个元素设置一张背景图片。这张图片从一段 URL 获取，并且在执行过程中，它是优先请求的，因此会向这个 URL 地址： `background-image: url('/dog.png');` 发送一个 GET 请求。

但是最后，没人强制我们必须确保这段 URL 链接确实能访问到图片。服务器甚至不需要对请求进行应答，但我们仍然可以响应 GET 请求，向数据库输入数据。

```js
const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.sendFile(__dirname + "/index.html");
});

app.get("/mobile", (req, res) => {
  console.log("is mobile")
  res.end()
)}
        
app.listen(8080)
```

至于后端，我使用 Express.js 作为服务器。它提供了一个简单的 HTML 网站；如果访问设备是智能手机，则会调用 mobile 路由。并且我们的后端是唯一使用 JavaScript 的地方。

```css
@media only screen and (max-width: 768px) {
  body {
    background-image: url("http://localhost:8080/mobile");
  }
}
```

在我们的 index.html 文件中，我们有了上面的 CSS 代码。只有在用户设备与媒体查询匹配的时候，才请求背景图片。

如果现在一部智能手机访问这个页面，媒体查询会执行，并发送请求背景图片的请求，同时服务端会输出它是智能手机。这些操作是完全没有使用 JavaScript。

并且由于我们不会发送一张图片作为回应，这个网站内容将不会有任何改变。

## 找到操作系统信息

现在变得更加疯狂，我们能大致找到用户操作系统通过它支持的字体。在 CSS 中，我们可以使用多种后备方案，换句话说，可以指定多种字体。如果第一个在系统上不起作用，浏览器将会尝试第二个。

`font-family: BlinkMacSystemFont, "Arial";` 当我在我们的网站嵌入这句代码时，我的 MacBook 使用第一种苹果标准字体，这字体只可以在 Mac OS 上使用。当在我的 Windows PC 上，Arial 正常使用。

当使用字体时，我们可以定义自定义字体以及从什么地方加载它。Google 字体的工作方式相同，如果我们要从某处使用自定义的字体，必须先从服务器加载它。并且我们可以多次使用字体。

```css
 @font-face {
  font-family: Font2;
  src: url("http://localhost:8080/notmac");
 }

body {
  font-family: BlinkMacSystemFont, Font2, "Arial";
}
```

这里我们为了全部的 body 部分设置了字体。从逻辑上讲，你只能使用一种字体。以至于在 MacBook 上，使用的是第一种字体，即系统自己的字体。在类似 Windows 的其他系统上，系统检查字体是否存在。当然，肯定不存在，因此尝试使用下一种我们自己定义的字体。它仍然不得不从服务端加载，因此我们的 CSS 代码会再次触发 GET 请求。

毕竟 **Font2** 不是一个真正的字体，因此我们继续尝试，最终将使用 Arial 字体。尽管如此，我们仍然可以在用户无感知的情况下，使用一个合理的字体。

## 追踪元素信息

到目前为止，我们所做的事情就是当用户抵达网站，立即对信息进行分析。当然，我们也可以利用 CSS 对单独的事件做出应对。

如下所示，我们可以使用下面的例子，来分析鼠标悬停或活动事件。

```html
<head>
  <style>
    #one:hover {
      background-image: url("http://localhost:8080/one-hovered/");
    }
  </style>
</head>
<body>
  <button id="one">Hover me</button>
</body>
```

当鼠标每次悬停在按钮上，它会一次又一次的设置背景图片，一个 GET 请求也随之发出。

我们可以在按钮被点击时，做相同的事情。在 CSS 中，这就是活动事件。

```html
<head>
  <style>
    #one:active {
      background-image: url("http://localhost:8080/one-clicked/");
    }
  </style>
</head>
<body>
  <button id="one">Click me</button>
</body>
```

还有一系列其他事件。例如，悬停事件几乎适用在每一个元素上。因此从理论上来讲，我们可以追踪用户的每一个行为。

#### 犹豫计时器

使用更多的代码，我们可以组合这些事件并且了解更多信息，而不仅仅是发生了那些事件。

对于许多网站主来说，更感兴趣的是，用户在看到或悬停在元素上犹豫了多久才点击某个元素。通过下面的代码，我们可以测量用户悬停后点击所花费的时间。

```js
let counter;
app.get("/one-hovered", (req, res) => {
  counter = Date.now();
});

app.get("/one-active", (req, res) => {
  console.log("Clicked after", (Date.now() - counter) / 1000, "seconds");
});
```

用户一旦悬停，计时器就会启动。最后，我们可以算出直到点击过了几秒。

你可能会认为由于它嵌入在 CSS 代码中，统计的可能并不准确，但事实并非如此。由于请求的体积十分小，并且立即作用在服务器上。我试了几次并测量了时间，最终测量的结果非常精确。

很惊人，不是吗？

## 让整个功能更美观

为了不被发现，使用不显眼的 URL 是十分有意义的。
最后，每个人都可以看到完整的前端代码。

你也可以使用自己想到的关键词，代替个别特别显眼的路由单词。最后，前端和后端的 URL 必须匹配。

对于上面的示例，我始终将我自己的路由用作 GET 请求。这样十分清晰明白。一种更优雅的方式是使用 URL 的查询，这在 CSS 当中也适用。

```css
@font-face {
  font-family: Font2;
  src: url("http://192.168.2.110:8080/os/mac");
  /* or: */ 
  src: url("http://192.168.2.110:8080/?os=mac");
}
```

有关 Express.js 中 URL 查询与参数的相关的详细教程可以在这里查看：

[**在 Express.js 中 URL 的查询与参数**](https://medium.com/javascript-in-plain-english/query-strings-url-parameters-d1a35b9a694f)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
