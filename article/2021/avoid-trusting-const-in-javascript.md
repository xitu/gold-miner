> * 原文地址：[Avoid trusting const in JavaScript](https://medium.com/front-end-weekly/avoid-trusting-const-in-javascript-69c1c0b59942)
> * 原文作者：[rahuulmiishra](https://rahuulmiishra.medium.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/avoid-trusting-const-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/avoid-trusting-const-in-javascript.md)
> * 译者：[jaredliw](https://github.com/jaredliw/)
> * 校对者：[kimberlyohq](https://github.com/kimberlyohq)

![](https://miro.medium.com/max/1400/1*iT9aLA6A823qTKMa4jF3Xw.jpeg)

# 不要信任 JavaScript 里的 `const`

Hello world！🌏

在 JavaScript 应用中，我们常常会声明常量。这些常量可以是字符串、对象、数组亦或是布林值。这样能避免我们的组件被大量的“魔法值”污染。

当常量值是**对象**或是**数组**时，事情就有点不妙了。让我们看看将对象和数组设为常量时会面临什么问题：

以下这几个代码片段演示了将 **`const`** 用于对象和数组时所产生的问题。

![](https://miro.medium.com/max/1400/1*SSrNp4tvzDNwdznCyB5J8Q.png)

![](https://miro.medium.com/max/1400/1*b184e2M6cG67X8uTUhh3mA.png)

![](https://miro.medium.com/max/1400/1*h0AbFC4Xqp9RvkV2pyWLCg.png)

基本上，`const` 只添加了不能重新赋值变量的**限制**。

在以上的代码，我并**没有重新赋值变量**，我只更改了对象中的值；基于 JavaScript 的可变性概念，这是合法的。[阅读更多](https://rahuulmiishra.medium.com/immutability-in-javascript-892129a41497)

**`const` 不能保证数据不变性。**

我们有两种方法来避免修改对象和数组。

## 1. 使用 `Object.freeze()` ❄️

`Object.freeze()` 的作用：
a. 它能确保对象不能被修改。
b. 冻结对象后，我们不能修改或添加属性。

**禁止添加 + 禁止修改**

![](https://miro.medium.com/max/1096/1*L9Za0baN7NLlqQ1gGH_bgQ.png)

## 2. 使用 `Object.seal()` 🔒

如果我们将一个对象密封起来，虽然我们不能添加新的属性，但我们能修改现有属性中的值。

**禁止添加，但允许修改**

![](https://miro.medium.com/max/1400/1*P2EXj8JPvqaWFwLG-MioBg.png)

**何时使用 `.seal()` 和 `.freeze()` 方法？** 😃

- 当一个大团队共用一个代码库且你不想冒着配置值被修改的风险时，你可以选择密封或冻结对象。
- 对于高危常量，例如用户角色、根 URL 等，我们可以使用冻结。

**性能优势：** 🚀

- 遍历密封/冻结的对象比遍历普通对象快。[Stack Overflow —— 封锁 JavaScript 对象对性能有什么好处吗？](https://stackoverflow.com/questions/8435080/any-performance-benefit-to-locking-down-javascript-objects)

`Object.seal()` 和 `Object.freeze()` 只是**浅**密封/冻结；这意味着只有表层的值被密封/冻结了，我们仍然可以修改数组里的对象。

**解决方案：**我们需要自己实现这个方法；也就是遍历对象/数组，将每层的值单独密封/冻结。

[MDN 文档中提到的深度冻结的代码](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
