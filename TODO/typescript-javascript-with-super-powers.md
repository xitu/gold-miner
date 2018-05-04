> * 原文地址：[TypeScript — JavaScript with superpowers](https://medium.freecodecamp.org/typescript-javascript-with-super-powers-a333b0fcabc9)
> * 原文作者：[Indrek Lasn](https://medium.freecodecamp.org/@wesharehoodies?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/typescript-javascript-with-super-powers.md](https://github.com/xitu/gold-miner/blob/master/TODO/typescript-javascript-with-super-powers.md)
> * 译者：[jonjia](https://github.com/jonjia)
> * 校对者：[moods445](https://github.com/moods445) [goldEli](https://github.com/goldEli)

# TypeScript：拥有超能力的 JavaScript

![](https://cdn-images-1.medium.com/max/800/1*aOhXVPhLT8tZLYQu62HcPA.png)

JavasSript 很酷。但你知道什么更酷一点吗？TypeScript。

#### 你能看出这段代码有什么问题吗？

![](https://cdn-images-1.medium.com/max/600/1*IgMNDPa6Oq8De5f7Pvnmnw.png)

![](https://cdn-images-1.medium.com/max/600/1*TV6Dyfy3Bmul2JPC7eyKaQ.png)

TypeScript (上) 对比 ES6 (下)

**TypeScript 可以看出来。**看到那个红色的下划线了吗？这就是 TypeScript 给我们的错误提示。

你可能已经发现了这个问题（干的漂亮） — `toUpperCase()` 是 String 的方法，我们将一个整型作为参数传递过去，显然不能在整型上调用 `toUpperCase()` 方法。

我们通过声明 `nameToUpperCase()` 方法的参数只能为 `string` 类型来修复这个问题。

![](https://cdn-images-1.medium.com/max/800/1*N0xiNAjnnX3CijE82PpTjA.png)

棒棒哒！现在我们不用自己去记 `nameToUpperCase()` 的参数类型必须为 `string`，我们可以信任 TypeScript 去记住它。想象下，如果有成千上万个参数类型需要我们记住。太疯狂了吧！

还是有错误警告。为什么？因为我们还是传递了个整型参数！传递个 `string` 类型的参数就好了。

![](https://cdn-images-1.medium.com/max/800/1*4JtcPUxZ7NPyf5gxhPqs2Q.png)

注意 TypeScript 最终还是会被编译成 JavaScript (它只是 JavaScript 的一个超集，就像 C++ 和 C 的关系一样)。

以上就是 TypeScript 和类型检查强大的原因。

![](https://cdn-images-1.medium.com/max/800/1*AgAGlFdiYSiYKZLW9fNvuw.png)

TypeScript 上个月（译注：2018年1月）有 **10,327,953** 的下载量。

![](https://cdn-images-1.medium.com/max/1000/1*12nXNNgYHMLqWl7FWe4mwQ.png)

TypeScript vs Flow 下载量对比

让我们开始探索 TypeScript 的世界 — 在深入探究之前，先来了解下 TypeScript 究竟是什么以及为什么存在。

[TypeScript 于 2012 年 10 月 1 日正式开源。](https://en.wikipedia.org/wiki/TypeScript) 由 Microsoft 开发维护，[C#](https://en.wikipedia.org/wiki/C_Sharp_%28programming_language%29) 的首席架构师 [Anders Hejlsberg](https://en.wikipedia.org/wiki/Anders_Hejlsberg) 带领他的团队参与了 TypeScript 的开发。

[TypeScript](https://www.typescriptlang.org/) 在 GitHub 上完全开源，所以任何人都可以阅读它的 [源码](https://github.com/Microsoft/TypeScript) 并做出贡献。

![](https://cdn-images-1.medium.com/max/800/1*4DNoN1QejqOlOFNft6teuw.png)

TypeScript — JavaScript 的超集。

### 如何开始

实际上非常简单 — 我们只需要安装一个 NPM 包。打开你的终端，输入以下命令：

```

npm i -g typescript && mkdir typescript && cd typescript && tsc --init
```

再设置下 TypeScript 的配置文件就可以了。

![](https://cdn-images-1.medium.com/max/1000/1*0a1jcXX5gYTRnVCkgisYbQ.png)

我们只需要创建一个 `.ts` 文件，并告诉 TypeScript 编译器监视文件变化。

```
touch typescript.ts && tsc -w
```

**tsc **— TypeScript 编译器。

#### 最后一步

![](https://cdn-images-1.medium.com/max/1000/1*ervvuE5kcy2isO1zTDL_0w.png)

太好了 — 现在你可以跟着我们的示例一起练习。

我们在 `.ts` 文件中编写代码，编译后生成的 `.js` 文件是在浏览器中运行的代码。在这个例子中，我们不是用浏览器环境，我们使用 NodeJS 环境（所以 `.js` 是在 Node 环境中运行的）。

![](https://cdn-images-1.medium.com/max/800/1*6VLCkqegvidS5dJm-e7zSA.png)

JavaScript 有 7 种数据类型，其中 6 种是基础类型，剩下的被定义为 Object 类型。

#### **JavaScript 基础类型如下：**

*   **String**
*   **Number**
*   **Undefined**
*   **Null**
*   **Symbol**
*   **Boolean**

#### 剩下的都是 [**objects**](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object)

*   [函数是头等对象](https://en.wikipedia.org/wiki/Function_object#In_JavaScript)
*   [数组是特殊的对象](https://stackoverflow.com/a/5048482/5073961)
*   [原型是对象](http://raganwald.com/2015/06/10/mixins.html)

![](https://cdn-images-1.medium.com/max/800/1*9FeYC-4ZEsKAQ565pEdTqw.png)

TypeScript 支持与 JavaScript 相同的基础类型，此外还提供了一些额外的类型。

额外的类型是可选的，如果你不熟悉那些类型，你就可以不用。我发现使用 TypeScript 的好处就是：使用起来灵活方便。

### 额外的类型如下：

![](https://cdn-images-1.medium.com/max/800/1*QlcVGtDb2FVJjkQRIh6gLQ.png)

元组（tuple）就是组织好结构的数组，只是按照顺序定义好数组元素的类型

![](https://cdn-images-1.medium.com/max/800/1*tF_IxeUVobcsA2BiBbConA.png)

普通数组 vs 元组（组织好结构的数组）

如果你不遵守元组定义好的规则，TypeScript 会给我们发出错误警告。

![](https://cdn-images-1.medium.com/max/800/1*6LvBeYZZrPTaxNIBkzQKAQ.png)

元组定义了第一个元素是 `number` 类型，但赋值时并不是 `number` 类型，而是一个值为 `"Indrek"` 的 `string` 类型，所以编译结果会报错。

* * *

![](https://cdn-images-1.medium.com/max/800/1*Bto4sAfIzfV3EIyYS04JmA.png)

在 TypeScript 中，你需要定义函数返回值的类型。因为有很多没有 `return` 语句的函数。

![](https://cdn-images-1.medium.com/max/800/1*AboEEgZSSq9YvI-Y6KLBgA.png)

看一下我们是怎么声明参数和返回值类型的 — 它们的类型都是 `string`。

如果我们没有返回任何值会怎么样？下面例子的函数体中只有一条 `console.log` 语句。

![](https://cdn-images-1.medium.com/max/800/1*EI69g4tgKBUJYp6BZkignQ.png)

我们可以看到，编译结果提示我们：“嘿，你**明确**表示我们必须返回一个 `string` 类型，但你实际上没返回任何值。我就是告诉你，你没有遵守我们的规则。”

如果我们就是不想返回任何值该怎么办呢？比如我们的函数中有一个回调函数。在这种情况下就可以声明返回值的类型为`Void`。

![](https://cdn-images-1.medium.com/max/800/1*JJdm0IAG6MOvVwKh-XUS-w.png)

但有时候我们的函数确实有返回值，不管是隐式还是显式地，我们都不能将返回值的类型设置为 `Void`。

![](https://cdn-images-1.medium.com/max/800/1*LYPDIzRpqPZtg03qMz_5SQ.png)

* * *

![](https://cdn-images-1.medium.com/max/800/1*DHGUJYw9MdbnobyC1wf0Pg.png)

`any` 类型非常简单，如果我们要为还不清楚类型的变量指定一个类型的话，就可以指定为 `any`

比如下面的例子：

![](https://cdn-images-1.medium.com/max/800/1*aDKDyw7uN7cbA7QMjpm3GA.png)

可以看到我给 `person` 变量多次赋值，每次使用的值的类型都不同。第一次是 `string` 类型，然后是 `number`，最后是 `boolean`。我们无法确定这个变量的类型。

如果你使用第三方的库，你可能会不知道某些变量的类型。

让我们声明一个数组，你把从某个 API 获取到的数据存储到这个数组中。数组中的数据是随机的。它不会只包括 `string`、`number`，也不像元组那样有组织好的结构。`any` 类型就可以解决这个问题。

![](https://cdn-images-1.medium.com/max/800/1*nDGWiVcZHWXRPT3NMqHeuQ.png)

如果你知道数组的元素都是同一种类型，你可以使用下面的语法声明：

![](https://cdn-images-1.medium.com/max/800/1*AT2v5vHOq9_kuraL2E2hnA.png)

这篇文章的篇幅已经够长了，我们将在下一篇文章继续。我们还剩下 — `enum` — `never` — `null` — `undefined` 这些基础类型和类型断言需要讨论。

如果你想深入学习，可以阅读 TypeScript 的 [官方文档](https://www.typescriptlang.org/docs/handbook/basic-types.html)

由于好多人问我这篇文章中的图片使用的什么编辑器。我使用 **Visual Studio Code** 编辑器，配合 **Ayu Mirage** 主题和 **Source Code Pro** 字体。

你可以在我的 Medium 上发现更多有趣的文章。

- [**Indrek Lasn - Medium**: Read writing from Indrek Lasn on Medium. Merchant of happiness, founder @ https://vaulty.io, growth/engineering @… medium.com](https://medium.com/@wesharehoodies)

也可以关注我的 twitter。❤

- [**Indrek Lasn (@lasnindrek) | Twitter**: The latest Tweets from Indrek Lasn (@lasnindrek). business propositons: lasnindrek@gmail.com. Zurich, Switzerland twitter.com](https://twitter.com/lasnindrek)

感谢阅读！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
