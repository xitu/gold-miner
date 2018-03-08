> * 原文地址：[function.caller considered harmful](https://medium.com/@bmeurer/function-caller-considered-harmful-45f06916c907)
> * 原文作者：[Benedikt Meurer](https://medium.com/@bmeurer?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/function-caller-considered-harmful.md](https://github.com/xitu/gold-miner/blob/master/TODO/function-caller-considered-harmful.md)
> * 译者：[yankwan](https://github.com/yankwan)
> * 校对者：[Starriers](https://github.com/Starriers)

# function.caller 被认为是有害的

今天我收到来自微软的 Patrick Kettner 提的这个问题，然而我发现这个问题是我已经回答过的，只不每次的问题稍有不同而已。

![Snipaste_2018-03-05_14-09-37.png](https://i.loli.net/2018/03/05/5a9cdf3029af2.png)

最终我发现是自己在第一次看到这个问题的时候理解错了这个问题，并且当别人在 Twitter 上回应的时候我也没有足够重视这个问题。

![Snipaste_2018-03-05_14-10-35.png](https://i.loli.net/2018/03/05/5a9cdf5faff49.png)

最后 Patrick 又提醒我一次，我才发现引起他兴趣的并不是 arguments.caller，而是函数对象的 "caller" 这个神秘的属性 ——— 准确来说是非严格模式下的函数对象。

JavaScript 在历史上曾提供了一个有魔力的 foo.caller 属性，它可以返回调用 foo 函数的引用。使用该属性存在着众多问题，例如它可能会因跨域调用产生安全问题、它在复杂的 JavaScript 引擎中实现的不够充分、它难以维护和测试、诸如对闭包的内联插入，逃逸分析和标量替换的优化都变得不可行，甚至在调用 "caller" 的属性访问器时，这些优化在返回的调用函数中也无法实现。

* * *

很多不可思议的事在非严格模式函数中都被限制了。严格模式下函数通过 [AddRestrictedFunctionProperties](https://tc39.github.io/ecma262/#sec-addrestrictedfunctionproperties) 定义 "caller" 的访问器，当访问该属性的时候会抛出一个类型错误。

![](https://cdn-images-1.medium.com/max/800/1*c_2sPWSdvAKKPq1Lz9BD7A.png)

对于非严格模式的函数，目前 EcmaScript 规格中的定义也是非常模糊的，基本上对它没有做任何的规范限制。在章节 [16.2 禁止扩展](https://tc39.github.io/ecma262/#sec-forbidden-extensions)中说到：

> 如果扩展非严格模式或内置函数对象的时候，将对象自己的属性命名为 "caller" ，并且它的值通过 [[Get]] 或者 [[GetOwnProperty]] 定义的话，这种情况下必须保证不是严格模式。如果它是作为一个访问器属性，通过 [[Get]] 属性获取它的值将会返回调用它的函数，那么这个时候不会返回严格模式下的函数。

所以在非严格模式函数下的 "caller" 属性，或多或少完全实现了既定的行为。唯一的限制是如果有 yield 一个变量，那么这个变量一定不是严格模式下的函数。所以在非严格模式下，给 "caller" 赋一个默认值 42 是一个合理做法。显然实现中并没有这么做 —— 尽管有把这个添加到 V8 中的想法，同时现在也极不建议大家使用 foo.caller。

* * *

这是我们目前如何在 V8 中实现这些（有误导性的）特性 —— 也正是如何在 Chrome 和 Node.js 中运行的。"caller" 这个属性在非严格模式函数中是一个特殊的访问器，其实现方法 [FunctionCallerGetter](https://cs.chromium.org/chromium/src/v8/src/accessors.cc?type=cs&l=1044) 在 accessors.cc 源码文件中实现，同时在该文件实现的还有核心的逻辑方法 [FindCaller](https://cs.chromium.org/chromium/src/v8/src/accessors.cc?type=cs&l=1000)。要理解下面这些规则可以说是比较困难的，但这就是当你在非严格模式下访问 foo.caller时我们底层代码所做的事： 

1.  首先找到函数 foo 的最近一次的调用，例如 foo 的最后一次还没返回给调用方的调用。
2.  如果当前 foo 不存在被调用的情况，则立即返回 null。
3.  如果处于正被调用的情况，我们通过查看非用户层的 JavaScript 代码的调用情况，找到它的上级调。
4.  如果通过上述规则没有找到上级调用，我们直接返回 null。
5.  如果能找到上级调用，如果它是严格模式的函数或者是我们不需要访问的 ——  例如来自不同域的函数 —— 这种情况下我们也返回 null。
6.  否则的话，我们则返回上级调用的闭包。

这里给出了一个它们如何工作的简单例子：

![](https://cdn-images-1.medium.com/max/800/1*ulOC-6Xuiy9FGDKk19ge0A.png)

现在你对 foo.caller 是怎么工作已经有了一个基本的了解，这里我强烈建议你不要再使用它。正如上述所说的，它基本上是一个不能保证完全实现的特性。我们目前仍然会提供支持，但对于 arguments.caller，正如在 [crbug.com/691710](https://bugs.chromium.org/p/chromium/issues/detail?id=691710) 提到的一样，我们可能在某个时间会移除它 —— 因为我们希望能够对闭包做逃逸分析和标量替换 —— 所以不要依赖它 —— 同时显然其他 JavaScript 引擎或许根本不支持这种特性。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
