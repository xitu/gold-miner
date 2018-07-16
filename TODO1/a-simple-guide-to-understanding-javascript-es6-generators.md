> * 原文地址：[A Simple Guide to Understanding Javascript (ES6) Generators](https://medium.com/dailyjs/a-simple-guide-to-understanding-javascript-es6-Generators-d1c350551950)
> * 原文作者：[Rajesh Babu](https://medium.com/@rajeshdavid?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-simple-guide-to-understanding-javascript-es6-generators.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-simple-guide-to-understanding-javascript-es6-generators.md)
> * 译者：[ssshooter](https://github.com/ssshooter)
> * 校对者：[Zheng7426](https://github.com/Zheng7426) [hopsken](https://hopsken.com/)

# Javascript（ES6）Generator 入门

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

如果你在过去两到五年中一直在研究 JavaScript，那么肯定看过关于 **Generator** 和 **Iterator** 的文章。虽然 **Generator** 和 **Iterator** 本质上是相关的，但 Generator 似乎比 Iterator 更令人难以理解。

![](https://cdn-images-1.medium.com/max/800/1*bwQSEHpbaNHte95IW2kTCw.jpeg)

> **Iterator** 由 **Iterable** 对象（如 map，数组和字符串等）实现，我们能够使用 next() 迭代它们。Iterator 在 Generator，Observable 和 Spread 运算符中广泛使用。

> 如果你刚接触 Iterator，建议先阅读 [Guide to Iterators](https://codeburst.io/a-simple-guide-to-es6-iterators-in-javascript-with-examples-189d052c3d8e)。

可以使用内建的 Symbol.iterator 验证对象是否符合可迭代要求：

```
new Map([[1, 2]])[Symbol.iterator]() // MapIterator {1 => 2}
“hi”[Symbol.iterator]() // StringIterator {}
[‘1’][Symbol.iterator]() // Array Iterator {}
new Set([1, 2])[Symbol.iterator]() // SetIterator {1, 2}
```

第一次亮相于 ES6 的 Generator 在后续 JavaScript 版本的发布中并没有变化，所以 Generator 有可能在将来会继续保持现在的特性及用法，我们是绕不开它的。虽然 ES7 和 ES8 有一些小更新，但是改变幅度无法与 ES5 到 ES6 相提并论，可以说 ES6 使得 JavaScript 踏出了新的一步。

**读完本文，我相信你一定能充分理解 Generator 的原理**。如果你是专业人士，欢迎在回复中添加评论，一起改进这篇文章。为帮助大家理解代码，代码中已包含一定注释。

![](https://cdn-images-1.medium.com/max/800/1*ZrJKJqBsksWd-8uKM9OvgA.png)

### 介绍

众所周知，JavaScript 的函数都会一直运行到 **return 或函数结束**。但对于 Generator 函数，会一直运行到 **遇到 yield 或 return 或函数结束**。与一般函数不同，**Generator 函数**一旦被调用，就会返回一个 **Generator 对象**。这个对象拥有 **Generator Iterable**，可以使用 **next()** 方法或 **for…of** 循环迭代它。

> Generator 每次调用 next()，函数会一直运行到下一个 yield，然后暂停执行。

语法上他们的标志是一个星号 **\***，**function\* X** 和 **function \*X** 的效果相同。

Generator 函数返回 **Generator 对象。**要把 Generator 对象赋值到一个变量，才能方便地使用它的 **next()** 方法。** 如果没有把 Generator 分配给变量，对它调用 next() 总是只会运行到第一个 yield 表达式。**

Generator 函数中通常含有 **yield** 表达式。Generator 函数内的每个 **yield** 都是下一个执行循环开始之前的停止点。每个执行周期都通过 Generator 的 **next()** 方法触发。

每次调用 **next()**，**yield** 表达式都会返回包含以下参数的对象。

`{ value: 10, done: false } // 假设 yield 的值是 10`

*   **Value** —— **yield** 关键字右侧的值，可以是对函数的调用、对象等几乎任何东西。对于空的 yield，返回的是 **undefined**。
*   **Done** —— 表明 Generator 的状态，是否可以继续执行。完成时返回 true，意味着函数已经运行完毕。

**（如果你无法理解上面说的是什么，那下面的例子可能会让你理解得更清晰……）**

![](https://cdn-images-1.medium.com/max/800/1*YnOJNuFe-r9T7pO47mVYaw.png)

Generator 函数基础

> **注意：**在上面的例子中，直接访问 **Generator 函数**总是执行到第一个 yield。因此，你需要将 Generator 分配给变量才能正确迭代它。

### Generator 函数的生命周期

在深入理解之前，让我们快速浏览一下 Generator 函数的生命周期示意图：

![](https://cdn-images-1.medium.com/max/800/1*0pLkX6yrbV2r6_pZ10AIvQ.png)

Generator 函数的生命周期

每次运行到 **_yield_**，Generator 函数都会返回一个对象，该对象包含 yield 产生的值和当前 Generator 函数的状态。类似地，运行到 **_return_**，可以得到 return 的值，并且 **_done_** 的状态为 **_true_**。当 done 的状态为 true 时，意味着 Generator 函数已经运行完毕，后面的 yield 统统无效。

> return 后的一切代码都会被忽略，包括 **yield** 表达式。

**继续阅读深入理解上图。**

### 把 yield 赋值到一个变量

在的示例中，我们创建了一个带有 yield 的最基本的 Generator，并获得了预期的输出。在下面代码中，我们将整个 yield 表达式赋值到一个变量。

![](https://cdn-images-1.medium.com/max/800/1*zdJQlUaqIiD3eV0j0QzrZA.png)

把 yield 赋值到一个变量

> 把整个 yield 表达式传到变量的结果是什么？**Undefined …**

> 为什么会是 undefined？**从第二个 next() 开始，前一个 yield 会被替换为 next 函数的参数。因为例子中的 next 没有传入任何值，所以程序判定“前一个 yield 表达式”为 undefined**。

这是重点中的重点，下面的章节我们将详细介绍对 next() 传参的用法。

### 将参数传递给 next() 方法

参考上面的示意图，我们聊聊关于传参到 next 函数的事情。**这是整个 Generator 使用中最棘手的部分之一**。

思考以下代码，其中 yield 被赋给变量，但这次我们向 next() 传参。

看看控制台的输出，先思考一下，后面会有解释。

![](https://cdn-images-1.medium.com/max/800/1*aYCKrAkgSyfEeN9cswZzbA.png)

将参数传递给 next()

#### 说明：

1. 在调用 **next(20)** 的时候，第一个 yield 前的代码都被执行。因为前面已经没有 yield，传入的 20 毫无作用。输出 yield 的 value 为 i*10，也就是 100。因为执行到第一个 yield 停止，所以 **const j** 未被赋值。
2. 调用 **next(10)** 时，第一个 yield 的位置被替换为 10，相当于在返回第二个 yield 的 value 前，设置 **yield (i * 10) = 10**，所以 **j 为 50**。yield 的 value 为 **2 * 50 / 4 = 25**。
3. **next(5)** 用 5 替换第二个 yield，所以 k 为 5。继续执行 return 语句，返回最后的 yield value **(x + y + z) => (10 + 50 + 5) = 65**，并且 done 为 true。

> **这可能对初次接触 Generator 的读者有点超纲，但是给自己 5 分钟，多读几遍，就能清楚明白。**

### Yield 作为其他函数的参数

Yield 在 Generator 中还有大把的用法，我们接着看看下面的代码，这是 yield 的其中一个妙用，附带解释。

![](https://cdn-images-1.medium.com/max/800/1*Y6pwTwJ7stPZzAeCKBfv4Q.png)

Yield 作为其他函数的参数

#### 解释

1.  第一个 next() yield（生成） 的 value 为 undefined，因为 yield 表达式无值。
2.  第二个 next() 生成的 value 为被传入的 `'I am usless'`，这一步为函数调用准备了参数。
3.  第二个 next() 以 **undefined** 为参数调用了后面的函数。next() 没有接收参数，意味着**上一个 yield 表达式的值为 undefined**，所以函数打印出 **undefined** 并终止运行。

### 对函数调用使用 yield

除了返回普通的值，yield 还可以调用函数并返回他的值。看看下面的例子更好理解：

![](https://cdn-images-1.medium.com/max/800/1*zXpsq-hlqla3z3mZGWyTJw.png)

对函数调用使用 yield

上述代码返回了函数返回的对象作为 yield 的 value，然后把 **const user** 赋值为 **undefined**，结束运行。

### 对 Promise 使用 yield

对 promise 使用 yield 与对函数调用使用 yield 相似，它会返回一个 promise，我们以此进一步判定操作成功或失败。看看以下代码，了解它的使用方法：

![](https://cdn-images-1.medium.com/max/800/1*100c_wLxJHmcKtjZAYwJzw.png)

对 Promise 使用 yield

apiCall 将 promise 作为 yield value 返回，在 2 秒后 resolved 并打印出我们需要的值。

### `Yield*`

Yield 表达式的介绍就告一段落了，接着我们了解一下另一个表达式 `yield*`。`Yield*` 在 Generator 函数中使用时，会把迭代委托到下一个 Generator 函数。简单来说，会先同步完成 `Yield*` 表达式中的 Generator 函数，再继续运行外层函数。

让我们看看下面的代码和解释，以便更好地理解。此代码来自 MDN Web 文档。

![](https://cdn-images-1.medium.com/max/800/1*eMlOmBoi2XGCE3qwUIj3qA.png)

`Yield*` 基础

#### 解释

1.  调用第一个 next()，产生的值为1。
2.  第二个 next() 调用的是 `yield*` 表达式，这意味着我们要先完成 `yield*` 表达式指定的 Generator 函数，再继续运行当前 Generator 函数。
3.  你可以假设上面的代码被替换为如下代码：

```
function* g2() {
  yield 1;
  yield 2;
  yield 3;
  yield 4;
  yield 5;
}
```

> Generator 会按这个顺序运行结束。不过对于 `yield*` 和 return 的同时使用，我们需要特别注意，下一节将会提到。

### `Yield*` 与 Return

带 return 的 `yield*` 与一般 `yield*` 有点不同。当 `yield*` 与 return 语句一起使用时，`yield*` 被赋 return 的值，也就是整个 `yield*` function() 与其关联 Generator 函数的返回值相等。

让我们看看下面的代码和解释，以便更好理解。

![](https://cdn-images-1.medium.com/max/800/1*HxJtIuXhBnOMAK0cwVElsQ.png)

`Yield*` 与 Return

#### **说明**

1. 第一个 next()，直接进入 yield 1 并返回其值。
2. 第二个 next() 返回 2。
3. 第三个 next()，运行 **return 'foo'** 后紧接着，yield 返回 'the end'，其中 'foo' 被赋值到 **const result**。
4. 最后一个 next() 结束运行。

### **对内建 Iterable 对象使用 `Yield*`**

`yield*` 还有一个值得一提的用法，它可以遍历 iterable 对象，如 Array，String 和 Map。

一起看看实际运行结果。

![](https://cdn-images-1.medium.com/max/800/1*u6RQVCQBCqw5UsF3Kger1w.png)

对内建 Iterable 对象使用 `Yield*`

在代码中，`yield*` 遍历传入的每一个 iterable 对象，我觉得这段代码本身是不言自明的。

### 最佳实践

最重要的是，每个 iterator/Generator 都可以使用 **for…of** 遍历。与显式调用的 next() 类似，for…of 循环依据 **yield 关键字** 进入下一次迭代。这里是重点：它只会迭代到**最后一个 yield**，不会像 next() 那样处理 return 语句。

下面的代码可以验证以上描述。

![](https://cdn-images-1.medium.com/max/800/1*dDYt_xElLC7wjUDN7HfDJg.png)

Yield 与 for…of

> 最后 return 的值不会被打印，因为 for…of 循环只迭代到最后一个 yield。因此，作为最佳实践，尽量避免在 Generator 函数中使用 return 语句，原因在于当使用 for…of 语句进行迭代时，return 会影响函数的可重用性。

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

### 总结

我希望这涵盖了 Generator 函数的基本用法，希望这篇文章能让你更好地理解 Generator 在 JavaScript 中的工作方式。如果你喜欢本文，请点个赞吧 :)。

请关注我的 GitHub 账号获取更多 JavaScript 和全栈项目：

* [**rajeshdavidbabu (Rajesh Babu)**: rajeshdavidbabu has 11 repositories available. Follow their code on GitHub.](https://github.com/rajeshdavidbabu)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

