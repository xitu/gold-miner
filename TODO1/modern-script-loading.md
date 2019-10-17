> * 原文地址：[Modern Script Loading](https://jasonformat.com/modern-script-loading/)
> * 原文作者：[Jason Miller](https://jasonformat.com/author/developit/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/modern-script-loading.md](https://github.com/xitu/gold-miner/blob/master/TODO1/modern-script-loading.md)
> * 译者：[w2ly](https://github.com/w2ly)
> * 校对者：[sin7777](https://github.com/sin7777)、[Baddyo](https://github.com/Baddyo)

# 现代脚本加载

> 为不同浏览器提供合适的代码，这可能有些棘手。下面有一些备选方案。

![](https://res.cloudinary.com/wedding-website/image/upload/v1562702391/modern-script-loading_ku0eml.jpg)

为现代浏览器提供现代代码可以提高性能。你的 JavaScript 代码包可以在包含更简洁优化的现代语法同时，依然支持旧版浏览器。

工具生态系统已经整合使用 [module/nomodule 模式](https://philipwalton.com/articles/deploying-es2015-code-in-production-today/) 以声明方式加载现代或传统代码 —— 为浏览器提供两者，并让其决定使用哪个：

```html
<script type="module" src="/modern.js"></script>  
<script nomodule src="/legacy.js"></script>  
```

但很不幸，这不是那么简单。上面提到的基于 HTML 的方法会引发 [Edge 和 Safari 浏览器中脚本过度获取](https://gist.github.com/jakub-g/5fc11af85a061ca29cc84892f1059fec)的问题。

### 我们能做什么？

那我们能做什么呢？我们希望能针对浏览器提供两种不同的编译目标产物，但一些旧版浏览器不完全支持这种简洁语法。

首先，这里有针对 [Safari 浏览器的修复](https://gist.github.com/samthor/64b114e4a4f539915a95b91ffd340acc)。Safari 10.1 支持 JS Modules，但却不支持应用在脚本文件上的 `nomodule` 属性，这会导致浏览器会同时执行现代和传统代码 **（啊呀好气啊！）**。值得庆幸的是，Sam 找到了一种方式，这种方式可以使用 Safari 10 和 11 支持的非标准 `beforeload` 事件弥补不支持 `nomodule` 的情况。

#### 方案一：动态加载脚本

通过实现一个小型的脚本加载器，我们可以规避这个问题。加载器的工作方式类似于 [LoadCSS](https://github.com/filamentgroup/loadCSS)。我们尝试忽略浏览器对 ES Modules 和 `nomodule` 属性的实现，转而让浏览器执行一段 Module 脚本作为测试，借此结果决定加载现代或传统代码。

```html
<!-- 使用 module 脚本检测现代浏览器： -->  
<script type=module>  
  self.modern = true
</script>

<!-- 根据 self.modern 标记加载现代或传统代码： -->  
<script>  
  addEventListener('load', function() {
    var s = document.createElement('script')
    if (self.modern) {
      s.src = '/modern.js'
      s.type = 'module'
    }
    else {
      s.src = '/legacy.js'
    }
    document.head.appendChild(s)
  })
</script>  
```

然而，由于 `<script type=module>` 异步执行的原因，上述方案需要等待头一个测试脚本运行之后才能去注入正确的脚本。

下面还有更好的方案。

以上方案的独立变体之一，是通过检测浏览器是否支持 `nomodule` 属性确定加载对应代码。这意味着像 Safari 10.1 这样的浏览器，虽然支持模块，但依然会被视为传统浏览器。这[可能](https://github.com/web-padawan/polymer3-webpack-starter/issues/33#issuecomment-474993984)是[一件好事](https://github.com/babel/babel/pull/9584)。这是该方案的代码：

```js
var s = document.createElement('script')  
if ('noModule' in s) {  // notice the casing  
  s.type = 'module'
  s.src = '/modern.js'
}
else  
  s.src = '/legacy.js'
}
document.head.appendChild(s)  
```

这可以快速地转换为加载现代或传统代码的方法，并确保两者都异步加载：

```html
<script>  
  $loadjs("/modern.js","/legacy.js")
  function $loadjs(src,fallback,s) {
    s = document.createElement('script')
    if ('noModule' in s) s.type = 'module', s.src = src
    else s.async = true, s.src = fallback
    document.head.appendChild(s)
  }
</script>  
```

那还有什么折衷方案吗？**预加载**不错。

上述方案的问题在于，由于它完全是动态的，因此浏览器在运行我们编写的引导代码之前，将无法发现要注入的 JavaScript 资源。通常浏览器在流式传输时，会扫描 HTML 查找可以预加载的资源。有一个不完美的解决方案：使用 `<link rel = modulepreload>` 在现代浏览器里预加载现代版本的代码包。但很不幸，[目前只有 Chrome 浏览器支持](https://developers.google.com/web/updates/2017/12/modulepreload)。

```html
<link rel="modulepreload" href="/modern.js">  
<script type=module>self.modern=1</script>  
<!-- etc -->  
```

这种技术是否对你适用，可以归结于嵌入脚本的 HTML 文档大小。如果 HTML 有效负载像启动屏幕一样小，或者足以引导客户端应用程序，那放弃预加载扫描不大可能影响性能。如果你使用服务端渲染大量有意义的 HTML 供浏览器流式传输，那么预加载扫描就是你的朋友。但这可能不是最佳方法。

在生产环境下可以采取如下方案：

```html
<link rel="modulepreload" href="/modern.js">  
<script type=module>self.modern=1</script>  
<script>  
  $loadjs("/modern.js","/legacy.js")
  function $loadjs(e,d,c){c=document.createElement("script"),self.modern?(c.src=e,c.type="module"):c.src=d,document.head.appendChild(c)}
</script>  
```

还要指出的是，[对 JS Modules 的浏览器支持](https://caniuse.com/#feat=es6-module) 非常类似于[对 `<link rel=preload>` 的支持](https://caniuse.com/#feat=link-rel-preload)。对于某些网站，使用 `<link rel=preload as=script crossorigin>` 而不是依赖于 modulepreload 可能更有意义。这可能有性能上的缺点，因为经典脚本预加载不会像 modulepreload 那样随着时间的推移而被扩展解析特性。

#### 方案二：用户代理（UA）检测

我没有这方面的简洁代码示例，因为用户代理（UA）检测非常重要。这篇 [Smashing Magazine 文章](https://www.smashingmagazine.com/2018/10/smart-bundling-legacy-code-browsers/) 讨论了这件事。

本质上讲，这种技术在所有浏览器的 HTML 中都以相同的 `<script src=bundle.js>` 开头。当请求 `bundle.js` 时，服务器解析浏览器的用户代理（UA）字符串，并选择返回现代或传统 JavaScript，这取决于该浏览器是否被识别为现代浏览器。

虽然这种方法很通用，但它也带来了一些严重的影响：

* 由于需要服务器去智能判断，这种方法不适用于静态部署（静态站点生成器、Netlify 等静态网站托管服务）
* 对 JavaScript 资源的缓存基于用户代理（UA）的不同而变化，这非常不稳定
* 对用户代理（UA）的检测很困难，容易出现错误分类
* 用户代理（UA）很容易被欺骗，并且经常会有新的用户代理（UA）产生

解决这些限制的一种方法是将 `module/nomodule` 模式和区分用户代理（UA）的模式相结合，以避免首先发送多个代码包版本。这种方法依然会降低页面的可缓存性，但因为生成 HTML 的服务器可以了解到是否使用 `modulepreload` 或者 `preload` ，所以允许了有效的预加载。

```js
function renderPage(request, response) {  
  let html = `<html><head>...`;

  const agent = request.headers.userAgent;
  const isModern = userAgent.isModern(agent);
  if (isModern) {
    html += `
      <link rel=modulepreload href=modern.mjs>
      <script type=module src=modern.mjs></script>
    `;
  } else {
    html += `
      <link rel=preload as=script href=legacy.js>
      <script src=legacy.js></script>
    `;
  }

  response.end(html);
}
```

对于在服务器上生成 HTML 以响应每个请求的网站，这可以是现代脚本加载的有效解决方案。

#### 方案三：“惩罚”旧版本浏览器

module/nomodule 模式的不良影响出现在旧版本 Chrome、Firefox 和 Safari —— 这些浏览器用户量很小，因为用户会自动更新到最新版本。Edge 16-18 的用户应当不会去自行更新，但新版本的 Edge 依然有希望得到支持：新版本的 Edge 将使用不受此问题影响的基于 Chromium 的渲染器。

对于某些应用程序来说，接受这一点作为权衡取舍可能是完全合理的：可以在 90% 的浏览器中提供现代代码，但代价是旧浏览器会付出额外带宽。值得注意的是，没有一款遭受这种过度获取问题的浏览器占据了显著的移动市场份额 —— 因此这些流量不太可能来自昂贵的移动计划或通过具有缓慢处理器的设备。

如果正在构建一个用户主要位于移动设备或新版浏览器上的网站，那么最简单的 module/nomodule 模式将适用于绝大多数用户。如果要支持较旧的 iOS 设备，请确保包含 [Safari 10.1 补丁](https://gist.github.com/samthor/64b114e4a4f539915a95b91ffd340acc)。

```html
<!-- polyfill `nomodule` in Safari 10.1: -->  
<script type=module>  
!function(e,t,n){!("noModule"in(t=e.createElement("script")))&&"onbeforeload"in t&&(n=!1,e.addEventListener("beforeload",function(e){if(e.target===t)n=!0;else if(!e.target.hasAttribute("nomodule")||!n)return;e.preventDefault()},!0),t.type="module",t.src=".",e.head.appendChild(t),t.remove())}(document)
</script>

<!-- 90% 以上的浏览器 -->  
<script src=modern.js type=module></script>

<!-- IE, Edge <16, Safari <10.1, 旧版本桌面浏览器 -->  
<script src=legacy.js nomodule async defer></script>  
```

#### 方案四：使用条件代码包

这里有一个聪明的方案 —— 使用 `nomodule` 按需加载包含现代浏览器中不需要的代码包，如 polyfill 。用这种方法，最坏的情况是 polyfill 被加载甚至可能被执行（在 Safari 10.1 中），但效果仅限于“过度填充”。鉴于当前流行的方法是在所有浏览器中加载和执行 polyfill，这可能是一种有效的优化。

```html
<!-- 新版本的浏览器不会加载这个代码包 -->  
<script nomodule src="polyfills.js"></script>

<!-- 所有的浏览器都会加载这个 -->  
<script src="/bundle.js"></script>  
```

Angular CLI 可以配置使用此方法进行 polyfill，就像 [Minko Gechev 展示的](https://blog.mgechev.com/2019/02/06/5-angular-cli-features/#conditional-polyfill-serving)那样。在读到了这种方法后，我意识到我们可以在 preact-cli 中使用这种自动 polyfill —— [这个提议](https://github.com/preactjs/preact-cli/pull/833/files)为我们展现了采用这种技术是多么容易。

对于使用 Webpack 的项目，有一个应用在 `html-webpack-plugin` 上的[方便的插件](https://github.com/swimmadude66/webpack-nomodule-plugin)，可以很容易地将 nomodule 添加到 polyfill 包中。

---

### 你应当怎么做？

这个问题的答案由你的用例决定。

* 如果你在构建一个客户端应用程序，并且应用程序的 HTML 有效负载只不过是一个 `<script>`，那么**方案一**对我们更有吸引力
* 如果你在构建一个服务端渲染的网站，并且能够承受缓存影响，那么**方案二**可能更适合你
* 如果你使用[同构渲染](https://developers.google.com/web/updates/2019/02/rendering-on-the-web#rehydration)方案，预加载扫描提供的性能优势可能非常重要，我们可以选择**方案三**或**方案四**

选择适合你当前架构的方案。

就我个人而言，相比降低某些桌面浏览器的下载成本来说，我更倾向于决定在移动设备上优化以获得更短的解析时间。移动端用户将解析和数据成本视为实际费用 —— 电池消耗和数据费用 —— 而桌面端用户不会受到这些限制。此外，它为我提供了 90% 的优化 —— 我开发和维护的产品面向的大多数用户都使用现代浏览器和（或）移动浏览器。

> 译者注：估摸着原作者使用了方案三

### 扩展阅读

有兴趣深入了解吗？这里有一些开始挖掘的地方：

* 在 Phil 的 [webpack-esnext-boilerplate](https://github.com/philipwalton/webpack-esnext-boilerplate/issues/1) 里提到了一些背景材料
* Ralph [在 Next.js 中实现了 module/nomodule](https://github.com/zeit/next.js/pull/7704) ，并致力于解决提出的问题

在此感谢 [Phil](https://twitter.com/philwalton)、[Shubhie](https://twitter.com/shubhie)、[Alex](https://twitter.com/atcastle)、[Houssein](https://twitter.com/hdjirdeh)、[Ralph](https://twitter.com/Janicklas) 和 [Addy](https://twitter.com/addyosmani) 对这篇文章的反馈。

**2019-07-16:** 修复了方案一中的代码示例，解决了由异步初始化代码 `self.modern` 引发的问题。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
