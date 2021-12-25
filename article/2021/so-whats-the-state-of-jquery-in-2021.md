> * 原文地址：[What is the State of jQuery in 2021?](https://javascript.plainenglish.io/jquery-7be2b63d720e)
> * 原文作者：[Louis Petrik](https://medium.com/@louispetrik)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/so-whats-the-state-of-jquery-in-2021.md](https://github.com/xitu/gold-miner/blob/master/article/2021/so-whats-the-state-of-jquery-in-2021.md)
> * 译者：[Badd](https://juejin.cn/user/1134351730353207)
> * 校对者：[nia3y](https://github.com/nia3y)，[zaviertang](https://github.com/zaviertang)

# 2021 年，jQuery 过得还好吗？

![来自：[pixabay.com](https://pixabay.com/de/photos/technologie-computer-code-1283624/)](https://cdn-images-1.medium.com/max/3840/1*Tc90FhOr8U4x04kzqguVuA.jpeg)

通常来说，人们怀旧的对象都是老照片、老歌或者老地方。
而我的怀旧，则是过了这么多年、经历了这么多项目，我仍然在用 jQuery。这个 JavaScript 库于 2006 年问世，其历史比 React、Vue 甚至是 Angular.js 还要悠久。

jQuery 一度曾在 JavaScript 世界里风头无两。有了它，我们开发起动态 Web 应用来更加得心应手。特别是操作 DOM 和发起网络请求时，jQuery 的使用方式更加直观明了。

那么现在这款经典的 JavaScript 库状况如何？它有什么更新？谁仍在使用它？它的人气是高是低？下文会给你答案。

## 那么，jQuery 有什么更新吗？

我做了一番功课：我翻到了 2016 年的 jQuery 官方博客，去看看都有什么更新记录在案。

答案是：实话实说，几乎纹丝没动。确实，jQuery 3 带来了许多更新，但其中没有一个是值得一提的。没有一个更新能与前几年 React.js 引入 Hooks 那样的里程碑相提并论。

还有一些次要的更新，是支持了在 jQuery 对象上使用 for-of 循环。而在内部实现中，jQuery 现在还使用了 `requestAnimationFrame()` 来运行动画。

除此之外，就再也没有重大更新了。原因很简单：jQuery 早已经进化到了充分够用的程度了。

## 还有公司在用 jQuery 吗？

说起技术选型，行业大厂们总是起着引领潮流的重要作用。一旦那些有话语权的开发者团队选用了某项技术，就会给该技术带来很大的优先选择权重。即使 jQuery 在逐渐走向没落，但它在 Web 领域仍然是举足轻重的角色。

[Wappalyzer 的分析报告](https://www.wappalyzer.com/technologies/javascript-libraries)显示，在所有的使用了 JavaScript 库的网站中，jQuery 仍然占据着超过 34% 之大的比例。

![图片来自：[Wappalyzer](https://www.wappalyzer.com/technologies/javascript-libraries)](https://cdn-images-1.medium.com/max/2410/1*TOg5oguzp81TxE6AWYNk0w.png)

当然了，这份数据我们看看就好 —— 我们并不能仅凭着有成千上万的网站仍在使用 jQuery 这一点，就武断地认为它一定是合适的选择。另外，jQuery 也成为了其他库的必要依赖。

Bootstrap 就是 jQuery 的用武之地之一。此前，这个 CSS 框架一直在使用 jQuery 进行所有的 DOM 操作。直到 Bootstrap 5，jQuery 才被停用了。

现在我们来看看 jQuery 在各个公司中的使用情况：在互联网上，我发现许多公司都声称在使用 jQuery。然而，技术栈在持续更新，我们要弄明白的是，jQuery 到底是在什么地方被用到的。

事实上，Stack Overflow 仍在使用 jQuery。使用 jQuery 的公司还包括：

* Wellsfargo.com
* Microsoft.com
* Salesforce.com

没错，即使是 Microsoft 也是其中一员。但就算是这样，这些公司的技术栈也不具有完全的参考价值。即使是这样的大厂，他们的网站开发人员也有可能误引用了不必要的库，或者没时间去优化。

## 如果 jQuery 死了，原因也不是我们所想的那样

我不喜欢用「死」来形容技术。毕竟，技术行业又不是医院，抢救无效就宣告死亡。但你确实得承认，jQuery 已经远不如以前流行，特别是最近五年里：

![图片来自[trends.google.com](https://trends.google.de/trends/explore?date=today%205-y&q=jquery)](https://cdn-images-1.medium.com/max/2306/1*Avjfb5ifyoBK0FGVccZ5Yw.png)

但原因是什么呢？很多人也许会认为，是因为像 React、Vue 以及 Angular 这样的框架和库大行其道。但这确实不是真正原因。那些流行的框架和 jQuery 走的路线完全不同。没错，它们都是致力于让 Web 应用的开发更加便捷的。但是，二者之间确实有着极大的差异。

那些框架走的都是组件化、数据绑定、状态管理以及单页面应用的路线。而 jQuery 呢，则像是纯 JavaScript 的一种方言，在下面的例子中你就会有切实体会：

```js
let el = document.getElementById('contents'); 

// jQuery 方式：
let el = $('#contents');
```

就算是 React、Vue 或 Angular 这类框架，也不是处处都适用。在那些无需重型框架就能开发出来的网站中，jQuery 仍然可以是非常得力的助手。

杀死 jQuery 的不是框架。

杀死 jQuery 的，是 JavaScript 本身。

单单 `document.querySelector()` 这一个函数，就让 jQuery 的众多拥趸倒戈投奔原生 JavaScript。（我自己也是因为 `$()` 这个非常实用的语法而经常使用 jQuery。）

JavaScript 的进化，让访问 DOM 变得更加容易。即使是 jQuery 的拿手好戏 —— 网络请求，在 JavaScript 中也愈发直观易用。

## 也许是我们错误估量了 jQuery 对性能的影响

毋庸置疑，各种库对于网站性能的影响不总是正向的。特别是当库的体积很大的时候，网站的加载时间也被延长了。但 jQuery 只有 30 kb，也谈不上笨重。我们可以拿 Vue、React.js 和 Angular 压缩后的 npm 包来做个对比：

* `vue`：22 kb
* `react-dom` + `react`：41 kb
* `angular`：62 kb

注意：这还只是框架包的体积。整个应用的生产包还要更大！所以在加载时间这个方面，jQuery 的表现十分优秀。

#### 那渲染（Render）性能方面呢？

大型框架们总喜欢争夺最佳性能的王冠。基准测试的内容通常总是大型表格的渲染，或者瞬时上千次状态更新。在这类实验中，各个框架已经拉开了距离 —— 而原生 JavaScript 则是妥妥地完虐了它们。

但说实话，这些基准测试通常没有太大意义。特别是对于那些称不上是「应用」的网站，它们只是用来展示内容的，库的渲染性能只是空谈。用户根本不会注意到一个下拉列表使用了一个「渲染缓慢」的库。

## 结语

我并不认同继续使用 jQuery 是个错误。这个库在许多场景中仍然是非常有帮助的，特别是当你能精通它的时候。当然了，现代 JavaScript 也值得你给个机会尝试尝试。

如果你想把 Web 应用的性能优化到极致，那 jQuery 爱莫能助。你完全可以省下这 30 kb 的代码体积，用纯 JavaScript 实现一切，而不必担心会缺少诸如可复用组件或者 MVVM 等这类「哲学色彩」。

jQuery 从始至终都更适合那些重内容而非功能的网站。而在更复杂的 Web 应用中，React 之辈的组件化哲学则是个很好的切入点。

感谢阅读！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
