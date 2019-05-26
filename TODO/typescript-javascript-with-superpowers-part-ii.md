> * 原文地址：[TypeScript — JavaScript with superpowers — Part II](https://medium.com/@wesharehoodies/typescript-javascript-with-superpowers-part-ii-69a6bd2c6842)
> * 原文作者：[Indrek Lasn](https://medium.com/@wesharehoodies?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/typescript-javascript-with-superpowers-part-ii.md](https://github.com/xitu/gold-miner/blob/master/TODO/typescript-javascript-with-superpowers-part-ii.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[Usey95](https://github.com/Usey95) [anxsec](https://github.com/anxsec)

# TypeScript：拥有超能力的 JavaScript（下）

![](https://cdn-images-1.medium.com/max/800/1*ijxYcfk-rHyfAWLq6bPr1Q.png)

**欢迎回来，继前文 [[译] TypeScript：拥有超能力的 JavaScript (上)](https://juejin.im/post/5aa89d5bf265da239a5f7f44) 之后，本周带来下篇。**

![](https://cdn-images-1.medium.com/max/800/1*lrVNbYOEn_ni9NNRTY0r7w.png)

使用枚举（enum）可以更清晰地组合一组数据。

下面我们来看看如何构造一个枚举类型：

![](https://cdn-images-1.medium.com/max/800/1*4qFIKpovAtDdkA0HkrqEVw.png)

你可以通过下面的方法从枚举中取值：

![](https://cdn-images-1.medium.com/max/800/1*KaoKC7ZCuXwLPR_1ntY9SQ.png)

但这样返回的是这个值的整数索引，和数组一样，枚举类型的索引也是从 `0` 开始的。

那我们怎么获取到 `"Indrek"` 呢？

![](https://cdn-images-1.medium.com/max/800/1*ymUuAzpdwzeMc3522yb0MA.png)

注意看我们怎么获取到字符串的值。

![](https://cdn-images-1.medium.com/max/800/1*XnRIFhuCMpJFp8CmVUnf3g.png)

还有一个很好的例子是使用枚举存储应用的状态。

![](https://cdn-images-1.medium.com/max/800/1*nOLoMIf6YLl0XbFoPWeHmw.png)

如果你想了解更多关于枚举（enum）的知识，[stackoverflow 上的这个回答](https://stackoverflow.com/a/28818850/5073961) 探讨了更多关于枚举的细节。

* * *

![](https://cdn-images-1.medium.com/max/800/1*DKPVSnf7PVjrdDY_Fvz6EQ.png)

假设我们请求某个 API，获取了一些数据。我们总是期望成功获取数据 — 但如果我们无法获取到数据会怎样呢？

是时候返回 `never` 类型了，比如下面这种特殊使用场景：

![](https://cdn-images-1.medium.com/max/800/1*lkfWaSP6G8YfqWjoFWqh4w.png)

<center>注意我们传递的 message 参数</center>

我们可以在另外的方法中调用 `error` 方法（回调）

![](https://cdn-images-1.medium.com/max/800/1*oZ4Ya3w5ypd6BM3AeF1nRA.png)

因为我们推断返回值的类型是 `never`，所以我们声明返回值的类型为 `never`，而不是 `void`。

* * *

![](https://cdn-images-1.medium.com/max/800/1*bgzesRZpes2KJYFRWRgFkw.png)

*   **null** — 没有任何值。
*   **undefined** — 变量被声明了，但没有赋值。

它们本身的类型用处不是很大。

![](https://cdn-images-1.medium.com/max/800/1*PwsNVPPzy7qav43uRHKBRg.png)

默认情况下 `null` 和 `undefined` 是所有类型的子类型。就是说你可以把 `null` 和 `undefined` 赋值给 `number` 类型的变量。

![](https://cdn-images-1.medium.com/max/800/1*q6FsoxR0Qou54lG040J2KQ.jpeg)

[图片来自 stackoverflow](https://stackoverflow.com/a/44388246/5073961)

关于 `null` 和 `undefined`，Axel Rauschmayer 博士写过 [一篇非常棒的文章](http://2ality.com/2013/04/quirk-undefined.html)。

* * *

![](https://cdn-images-1.medium.com/max/800/1*x3Y773t23Pc1VlhYWXB0TQ.png)

类型断言通常会发生在你清楚地知道一个实体具有比它现有类型更确切的类型。

它在运行时没有影响，只会在编译阶段起作用。TypeScript 会假设你 — 程序员，已经进行了必要的检查。

下面是一个简单示例：

![](https://cdn-images-1.medium.com/max/800/1*LGa_fcmyWZSCzduOKqHgpw.png)

尖括号 `<>` 语法与 [JSX](https://reactjs.org/docs/jsx-in-depth.html) 用法冲突，所以我们只能使用 `as` 语法进行断言。

![](https://cdn-images-1.medium.com/max/800/1*GgrkjRVkPhwu7hHAacWwaQ.png)

[关于类型断言的更多内容](https://basarat.gitbooks.io/typescript/docs/types/type-assertion.html)

#### 一些更酷的东西

*   [接口](https://basarat.gitbooks.io/typescript/docs/types/interfaces.html)
*   [绝对类型](https://github.com/DefinitelyTyped/DefinitelyTyped)
*   [联合类型](https://basarat.gitbooks.io/typescript/docs/types/discriminated-unions.html)
*   [类](https://www.typescriptlang.org/docs/handbook/classes.html)
*   [一些很棒的 TypeScript 项目](https://github.com/dzharii/awesome-typescript)

现在 — 用 TypeScript 来构造些有趣的东西吧！📙

感谢阅读，希望你有所收获！

你可以关注我的 [Twitter](https://twitter.com/lasnindrek)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
