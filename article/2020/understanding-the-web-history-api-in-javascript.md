> * 原文地址：[Understanding The Web History API in JavaScript](https://medium.com/javascript-in-plain-english/understanding-the-web-history-api-in-javascript-eac987071d4d)
> * 原文作者：[Mehdi Aoussiad](https://medium.com/@mehdiouss315)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-the-web-history-api-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/understanding-the-web-history-api-in-javascript.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[lsvih](https://github.com/lsvih)

# 浏览器 Web History API 的应用

![Photo by [Kevin Ku](https://unsplash.com/@ikukevk?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/9184/0*wBiqieIBMgVIDeJ_)

## Web API 的介绍

**API** 是指应用程序接口（**A**pplication **P**rogramming **I**nterface），它是一些预先定义的函数接口，允许程序员访问应用程序、操作系统或其他服务的特定功能或数据。**Web API** 是用于 Web 开发的应用程序接口，它可以用于 Web 浏览器或 Web 服务器。我们可以使用 Java 或 Node 等不同的技术来构建我们自己的 Web API。还有一种 API 叫做第三方 API，它不是内置在浏览器中的。你必须从网上下载代码才能使用它，比如 Youtube API 或 Twitter API。在本文中，主要是介绍关于 Web API 中的 History API 的使用。

![Photo by [Joshua Aragon](https://unsplash.com/@goshua13?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/5492/0*crcbHF8nQYE3cCwp)

## History API 的介绍

所有浏览器都支持 History API。在 **window.history** 对象及其原型上有一些可用的方法，接下来将展示这些方法。它还包含用户访问的所有网站记录。打开浏览器控制台来查看这个对象。请看下面的示例：

![The **window.history** Object in the console.](https://cdn-images-1.medium.com/max/2000/1*CF4GD-BAFVbCyyvkX96P7g.png)

显而易见，**window.history** 对象及其原型上有一些可用的方法，接下来将依次介绍。

## History.back() 方法

`History.back()` 方法可以加载历史记录列表中以前访问过的 **URL**。这与在浏览器中单击“后退箭头”相同。再来看下面的例子：

```HTML
<button onclick="myFunction()">Go Back</button>

<script>
function myFunction() {
  window.history.back();
}
</script>
```

当用户点击按钮时，它将跳转到浏览器历史记录列表中的上一个链接（URL）。

## History.go() 方法

`History.go()` 方法允许用户在浏览器历史记录列表中加载特定的 URL。再来看下面的例子：

```HTML
<button onclick="myFunction()">Go Back 2 Pages</button>

<script>
function myFunction() {
  window.history.go(-2);
}
</script>
```

当用户点击按钮时，将返回到上面示例中指定的第 2 页。

## History.forward() 方法

`History.forward()` 方法加载历史记录列表中的下一个 URL。下面是如何使用它的示例：

```HTML
<button onclick="myFunction()">Go Back</button>

<script>
function myFunction() {
  window.history.forward();
}
</script>
```

当用户点击按钮时，将加载浏览器历史记录列表中的下一个 URL。

## 结论

总而言之，当用户使用网站从一个页面到另一个页面时，History Web API 是非常有用和重要的，所以很有必要掌握它的使用。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
