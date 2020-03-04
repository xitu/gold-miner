> * 原文地址：[Stop Using === Everywhere](https://medium.com/better-programming/stop-using-everywhere-fd025342132d)
> * 原文作者：[Seifeldin Mahjoub](https://medium.com/@seif.sayed)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/stop-using-everywhere.md](https://github.com/xitu/gold-miner/blob/master/TODO1/stop-using-everywhere.md)
> * 译者：[Zavier](https://github.com/zaviertang)
> * 校对者：[Chorer](https://github.com/Chorer)、[Long Xiong](https://github.com/xionglong58)

# 停止在任何地方使用 `===`

#### 这是一个不同寻常的观点，让我们来探讨一下吧！

![Photo by [JC Gellidon](https://unsplash.com/@jcgellidon?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/stop?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/8480/1*ofXvrzbMMofNyhgXuY7dYw.jpeg)

大多数的开发者总是更青睐于使用 `===` 来代替 `==`，这是为什么呢？

我在网上看到的大多数教程都是认为：JavaScript 的强制转换机制太复杂而不能正确地预知结果，所以建议使用 `===`。

网上不少教程提出的信息和观点都是错误的。除此之外，许多 lint 规则和知名网站也固执地偏好于使用 `===`。

这些都导致很多程序员不把它当作语法的一部分去深入理解它，而只是把它当作一个语法缺陷。

这里我会举两个使用 `==` 的例子，来支持我的观点。

---

## 1. 空值判断

```JavaScript
if (x == null)

vs

if (x === undefined || x === null)
```

---

## 2. 读取用户输入

```JavaScript
let userInput = document.getElementById('amount');
let amount = 999;
if (amount == userInput)
vs
if (amout === Number(userInput))
```

在这篇文章中，我们将会通过一些常见的例子，来深入分析它们的区别、理解强制转换机制，最终形成一个指导方案来帮助我们决定是使用 `===` 还是 `==`。

---

## 介绍

在 JavaScript 中，有两种操作符可以帮助我们进行相等判断。

1. `=== ` —— 严格相等操作符（三等号）。
2. `==` —— 标准相等操作符（双等号）。

我一直在使用 `===`，因为我被告知，它比 `==` 更好、更优越。我根本不需要去考虑原因，作为一个懒惰的人，我觉得很方便。

直到我看了[《你不知道的 JS》](https://github.com/getify/You-Dont-Know-JS)的作者 [Kyle](https://medium.com/@getify)（Twitter:[@getfiy](https://twitter.com/getify)）在 [Frontend Masters](https://medium.com/@FrontendMasters) 上写的文章“Deep JavaScript Foundations”。

作为一名专业的程序员，我没有深入思考我每天工作中使用的这些操作符，这一事实激励着我去传播相关意识以及鼓励人们更多地去深入理解并关注我们自己编写的代码。

---

## 阅读文档

知道答案在哪里也许是重要的。它不在 Mozilla 的网站上，不在 W3schools 网站上，也不在那些声称 `=== ` 比 `==` 更好的文章中，当然它也不在这篇文章中。

它在 **JavaScript 规范** 中，那里有关于 JavaScript 如何工作的文档。[**ECMAScript®2020语言规范**](https://tc39.es/ecma262/#sec-abstract-equalcomparison)

---

## 纠正认知

#### 1. == 只做值的判断 (宽松的)

如果我们看一下文档，从定义上就可以清楚地看到，`==` 做的第一件事实际上是类型检查。

![](https://cdn-images-1.medium.com/max/2596/1*vtLIMvTkIe-4RlSEmzoiSA.png)

#### 2. === 同时检查类型和值 (严格的)

在这里，我们同样可以看到，`===` 先检查类型，如果类型不同，则根本不检查值是否相同。

![](https://cdn-images-1.medium.com/max/2692/1*Z3tOiO0nvNEtbfGVck1B8A.png)

所以，双等号 `==` 和三重等号 `===` 的区别在于我们是否允许强制转换。

---

## JavaScript 强制类型转换

强制类型转换是任何编程语言的基础之一。对于动态类型语言（如 JavaScript），这更为重要，因为如果类型发生了变化，编译器并不会报错。

理解强制转换意味着我们能够去解释 JavaScript 代码的运行原理，因此，为我们提供了更多的可扩展性和更少的错误。

#### 显式转换

类型转换可以在调用下面其中一种方法时显式地发生，从而强制改变变量的类型：

`Boolean()`, `Number()`, `BigInt()`, `String()`, `Object()`

例如:

```JavaScript
let x = 'foo';

typeof x // string

x = Boolean('foo')

typeof x // boolean
```

#### 隐式转换

在 JavaScript 中，变量是弱类型的，所以这意味着它们可以自动转换（隐式转换）。比如我们在当前上下文中使用算术运算 `+ / - *` 时，或者是使用 `==` 时。

```JavaScript
2 / '3' // '3' coerced to  3
new Date() + 1 //  coerced to a string of date that ends with 1
if(x) // x is coerced to boolean
1 == true // true coerced to number 1
1 == 'true' // 'true' coreced to NaN
`this ${variable} will be coreced to string`
```

隐式转换是一把双刃剑，合理使用可以增加代码的可读性，减少冗长。如果使用不当或被误解，人们经常会咆哮并指责这是 JavaScript 语法缺陷。

---

## 相等判断算法

#### 标准相等操作符 ==

1. 如果 X 和 Y 类型相同 —— 执行 `===`；
2. 如果 X 和 Y 一个是 `null` 一个是 `undefined` —— 返回`true`；
3. 如果一个是 number 类型，则把另一个也强制转换为 number 类型；
4. 如果一个是对象，则强制转换为原始类型；
5. 其它情况，返回 `false`。

#### 严格相等操作符 ===

1. 类型不同 —— 返回`false`；
2. 类型相同 —— 比较值是否相同（都为 `NaN` 时返回 `false`）；
3. `-0 === +0` —— 返回`true`。

---

## 常见例子

#### 1. 类型相同 （大多数情况）

如果类型相同，则 `===` 与 `==` **完全相同**。因此，您应该使用语义性更强的那个。

```JavaScript
1 == 1 // true                ......        1 === 1 // true

'foo' == 'foo' // true        ......       'foo' === 'foo' //true
```

“我更喜欢使用 `===`，以防类型不同。”

这不是一个逻辑上的错误，它就像我们会按两次保存按钮，不断地刷新网页。但是，为了以防万一，我们并不会在代码中重复调用同一个方法，不是吗？

#### 2. 类型不同 （常见的）

首先，我想提醒大家，不同的类型**并不意味着未知的**类型。

不知道变量的类型说明您的代码中有一个比使用 `===` 还是 `==` 更严重的问题。

了解变量的类型会对代码有更深入的理解，这将帮助您减少错误和开发更可靠的程序。

在我们有几种可能类型的情况下，通过理解强制转换机制，我们可以选择是否进行强制转换，进而决定使用 `===` 还是 `==`。

假设可能是 `number` 或者 `string` 类型。

请记住，这个算法更愿意比较 `number` 类型，因此它将尝试使用 [`toNumber()`](https://tc39.es/ecma262/#sec-tonumber) 方法。

```JavaScript
let foo = 2;
let bar = 32; // number 或者 string

foo == bar // 如果 bar 是 string 类型，它将会被强制转换为 number 类型。

foo === Number(bar) // 原理类似

foo === bar // 如果 bar 是 string 类型，则总是返回 false
```

#### 3. null 和 undefined

当使用 `==` 时，`null` 和 `undefined` 是相等的。

```JavaScript
let foo = null
let bar = undefined; 

foo == bar // true

foo === bar // false
```

#### 4. 非原始类型 [Objects, Arrays]

不应该使用 `==` 或 `===` 来比较对象和数组等非原始类型。

---

## 指导方案

1. 能使用 `==` 时尽量使用 `==`；
2. 知道变量类型时，或者您需要转换变量类型时，使用 `==`；
3. 知道变量类型总比不知道好；
4. 不知道变量类型时不要使用 `==`；
5. 知道变量的类型时，`==` 和 `===` 就是一样的；
6. 当类型不相同时，使用 `===` 是无意义的；
7. 而当类型相同时，使用 `===` 是没必要的；

---

## 避免使用 `==` 的情况

在没有真正理解 JavaScript 中 `falsy` 值之前，某些情况下应避免使用 `==`。

```JavaScript
== 后面是 0 或者 "" 或者 "   "

== 后面是非原始类型

== true  或者  == false
```

---

## 总结

根据我的经验，到目前为止，我编码时总是会知道要处理的变量的类型，如果不知道，我就使用 `typeof` 来判断。

以下是给看到文末的读者最后的 4 点建议：

1. 如果您无法知道变量的类型，那么使用 `===` 是唯一合理的选择；
2. 不知道变量的类型可能意味着您不够理解代码，也许您需要重构；
3. 了解变量的类型有助于编写出更好的程序；
4. 如果变量的类型已知，则最好使用 `==`，否则只能使用 `===`。

感谢您的阅读，我希望这篇文章能够帮助您加深对 JavaScript 的理解。我建议您可以去看看**你不知道的 JS** 系列，因为它对 JavaScript 这门语言有很深度的分析。[**You-Dont-Know-JS**](https://github.com/getify/You-Dont-Know-JS)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
