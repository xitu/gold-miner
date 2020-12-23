> * 原文地址：[Page Lifecycle API: A Browser API Every Frontend Developer Should Know](https://blog.bitsrc.io/page-lifecycle-api-a-browser-api-every-frontend-developer-should-know-b1c74948bd74)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/page-lifecycle-api-a-browser-api-every-frontend-developer-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2020/page-lifecycle-api-a-browser-api-every-frontend-developer-should-know.md)
> * 译者：[Sam](https://github.com/xutaogit)
> * 校对者：[ZavierTang](https://github.com/ZavierTang)，[Zenblo](https://github.com/zenblo)

# 页面生命周期 API：每一个前端开发者都应该知道的浏览器 API

![Photo by [Jeremy Perkins](https://unsplash.com/@jeremyperkins?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11120/0*s7XvAqERxLnWWPbS)

作为用户，我们在浏览网页时总是喜欢同时开启多个页面。因此，打开多个浏览器标签页是很常见的，因为这有助于我们并行地完成任务。但同时，这些标签页每一个都会消耗系统资源，如内存和 CPU。

由于不可能限制用户打开新标签页，也不能放任不管新标签页。所以浏览器在标签页非激活态时采取了一些措施来重新分配资源。

> 如今的现代浏览器有时会在系统资源有限的情况下，暂停页面或完全丢弃页面。—— Philip Walton

#### 那么你可能会有疑问，既然浏览器已经处理好了，我们为什么还要担心这个问题呢？

浏览器并没有完全处理好所有事情。此外，这些浏览器的干预措施会直接影响 JavaScript 的执行。好消息是，几乎所有现代浏览器都通过页面生命周期 API 把这些干预作为事件暴露出来了。

## 页面生命周期 API

顾名思义，页面生命周期 API 向 JavaScript 暴露了网页生命周期的钩子。然而，这不是一个全新的概念。[页面可见性 API（Page Visibility API）](https://developer.mozilla.org/en-US/docs/Web/API/Page_Visibility_API) 已经存在一段时间了，为 JavaScript 提供了一些页面可见性事件。

然而，如果你恰好需要在这两者之间作出抉择，就需要考虑一下页面可见性 API 的一些限制。

* 它只提供了网页显示和隐藏的状态
* 它不能捕获被操作系统抛弃的页面（安卓、IOS 和最新的 Windows 系统可以终止后台进程以保存系统资源）

让我们看一下通过页面生命周期 API 暴露的页面生命周期状态。

## 页面生命周期 API 状态

API 中介绍的状态有 6 种，其中，有两个状态和我们开发息息相关。

* **冻结** —— CPU 暂停的生命周期状态（隐藏的页面会被冻结以节约资源）

如果一个网页被隐藏了很久，并且用户没有关闭这个页面，浏览器将冻结它并把这个页面移动到这个状态里。然而，运行的任务会一直存在直到完成。但定时器、回调函数的执行和 DOM 操作将被停止以释放 CPU。

![Chrome Resource consumption](https://cdn-images-1.medium.com/max/2202/1*9XvnVKo4Z5YoFrJJZF6aHQ.png)

> # 当我查看我的电脑上的 Chrome 浏览器资源消耗时，我注意到有两个激活的标签页分别消耗 14.7% 和 11% 的 CPU 资源，而冻结的那些标签消耗接近为 0%。

* **废弃** —— 冻结的窗口会被移到 Discarded 状态，以节省资源。

假想一个网页长时间处于冻结态。这种情况下，浏览器将自动卸载页面让它进入废弃状态，以释放部分内存。并且如果用户重新访问废弃页面，浏览器将重新加载页面并回到激活状态。

> 值得注意的是，用户通常会在资源受限的设备中体验到废弃的状态。

除了上述两种状态，API 中引入的其他四种状态为：

* **激活** —— 页面可见并有输入焦点
* **被动** —— 页面可见但没有输入焦点
* **隐藏** —— 页面不可见（也不是冻结态）
* **终止** —— 页面已卸载并且已从内存中清除

你可以通过看下图找到生命周期状态和过渡的详细情况。

![Page Lifecycle API States and Transition](https://cdn-images-1.medium.com/max/2860/1*3NsVfS6gu7r39LRewVfKOQ.png)

## 如何应对生命周期状态

现在我们明白了页面生命周期 API，让我们看看咱们该如何应对每个事件。

> 这里最重要的事情是当应用到达每个状态时，确认什么是需要保留的，以及哪些是需要停止的。

* **激活态** —— 由于用户在页面上是完全活跃的，所以你的网页应该完全响应用户的输入。任何 UI 阻塞任务都应该去掉优先级，比如同步和阻塞网络请求。
* **被动态** —— 即便用户在这个阶段不和页面发生交互，他们仍然可以看到页面。因此你的网页应当流畅地运行所有 UI 更新和动画效果。
* **隐藏态** —— 隐藏状态应视为用户在网页上的会话结束。此时可以将未保存的应用状态持久化，并停止任何用户不需要在后台运行的 UI 更新或任务。
* **冻结态** —— 任何可能影响其他标签的定时器和连接都应在此阶段终止。例如，你应该关闭所有打开的 IndexedDB 连接，任何打开的 Web Socket 连接，释放任何被持有的 Web 锁，等等。
* **终止态** —— 由于会话结束逻辑是在隐藏状态下处理的，所以（该阶段）一般不需要操作。
* **废弃态** —— 这种状态是应用程序无法观测到的。因此，任何可能丢弃的准备工作都应该在隐藏或冻结状态下进行。然而，你可以在页面加载时通过检查 `document.wasDiscarded` 对页面的任何恢复做出响应。

---

好的，现在我们知道在每个状态要做什么了，让我们看看如何在我们的应用程序中捕获每个状态。

## 如何在你的代码中捕获生命周期状态

你可以使用下面的 JavaScript 函数来确定一个给定页面的激活、被动和隐藏状态。

```js
const getState = () => {
  if (document.visibilityState === 'hidden') {
    return 'hidden';
  }
  if (document.hasFocus()) {
    return 'active';
  }
  return 'passive';
};
```

随着 Chrome 68 的发布，开发者可以通过监听 `document` 对象上的 `freeze` 和 `resume` 事件来观察隐藏标签何时被冻结和解冻。

```js
document.addEventListener('freeze', (event) => {
  // 页面现在是冻结的
});

document.addEventListener('resume', (event) => {
  // 页面被解冻
});
```

要确定一个页面在隐藏标签页中是否被丢弃，可以使用以下代码。

```js
if (document.wasDiscarded) {
// 页面之前在隐藏标签页中被浏览器丢弃
} 
```

上面提到的 `wasDiscarded` 属性可以在页面加载时被观察到。

## 浏览器兼容性

一些老的浏览器不具备检测何时网页被冻结或废弃的能力。然而，随着 Chome 68 的发布，预测页面下一个状态的能力也被加了进来。

#### 已知的兼容性问题

* 一些浏览器在切换标签时不触发 `blur` 事件，这样可以避免页面进入到被动态。
* 老版本的 IE（10 以下）没有实现 `visibilityChange` 事件。
* 当关闭标签页时，Safari 浏览器不会一定确保能触发 `pagehide` 或 `visibilitychange` 事件。

为了解决跨浏览器不兼容性问题，Google 已经开发了一个名叫 [Pagelifecycle.js](https://github.com/GoogleChromeLabs/page-lifecycle) 的库，为以下浏览器做补充使用。

![Source: [Github](https://github.com/GoogleChromeLabs/page-lifecycle#usage)](https://cdn-images-1.medium.com/max/2000/1*G7Kr9wxsOUkiahryW7y43w.png)

## 总结

当用户没有主动参与时，网页不应该消耗过多的资源。此外你的应用程序还应该了解系统所执行的管理任务。页面生命周期 API 介绍了一种简单的方式来让你的应用程序知道这些事件。

---

虽然它更多的是和高级用例相关，但我们可以通过了解它的功能来开发高效的网络应用。据此，我们可以为终端用户提供更好的体验。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

