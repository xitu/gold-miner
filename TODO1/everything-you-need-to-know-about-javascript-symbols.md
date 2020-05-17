> * 原文地址：[Everything you need to know about JavaScript symbols](https://levelup.gitconnected.com/everything-you-need-to-know-about-javascript-symbols-24650a163038)
> * 原文作者：[Narek Ghevandiani](https://medium.com/@narghev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/everything-you-need-to-know-about-javascript-symbols.md](https://github.com/xitu/gold-miner/blob/master/TODO1/everything-you-need-to-know-about-javascript-symbols.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[Gesj-yean](https://github.com/Gesj-yean)，[X1ny](https://github.com/x1ny)

# 关于 JavaScript 中 Symbol 数据类型你需要了解的一切

![](https://cdn-images-1.medium.com/max/3684/1*13nRTbL0V3Idd3fDdKGkjQ.png)

**JavaScript 的 Symbol** 是一个相对较新的 JavaScript “特性”。它于 2015 年作为 [ES6](http://es6-features.org) 的一部分被引入。在这篇文章中，我将会讲到：

1. 究竟 JavaScript 中的 Symbol 是什么
2. 在语言中加入这种数据类型的动机
3. Symbol 数据类型是否成功地解决了它所要解决的问题？
4. 与其他语言中的 Symbol 数据类型的区别，例如 Ruby
5. JavaScript 中一些比较出名的 symbol
6. 这种数据类型的好处

## JavaScript 中的 Symbol

2015 年，Symbol 被添加到 JavaScript 中的原始数据类型中。它是 ES6 规范的一部分，它的唯一目的是作为**对象属性的唯一标识符**，也就是说，它可以作为对象中的**键**。你可以把 symbol **看作**是一个很大的数，每次创建一个 symbol 时，都会生成一个新的随机数（uuid）。你可以使用这个symbol（随机大数）作为对象中的键。

symbol 是通过调用 Symbol 函数创建的，该函数接受一个可选参数字符串，该字符串仅用于调试，并充当 symbol 的描述。Symbol 函数会返回唯一的 symbol 值。

![](https://cdn-images-1.medium.com/max/3880/1*CbM8A2Xj43EjYVz8Vmi_Og.png)

注意，Symbol 不是构造函数，**不能**用 **new** 调用。

![](https://cdn-images-1.medium.com/max/4656/1*9i7eeHcx4t-NCESG71aZbQ.png)

你还可以创建分配给**全局 symbol 注册表**的 symbol。**`Symbol.for()`** 和 **`Symbol.keyFor()`** 方法可以在全局 symbol 注册表中创建和读取 symbol。**`Symbol.for()`** 方法在全局 symbol 注册表中查找并根据是否找到 symbol 来检索或初始化 symbol。

![](https://cdn-images-1.medium.com/max/6984/1*IBCJQzFflSlnOAgMYNP4MA.png)

**`Symbol.keyFor()`** 方法会在全局 symbol 注册表查找 symbol，如果找到则返回其键，否则返回 `undefined`。而对于 **`Symbol.for()`** 方法，你可以将全局 symbol 注册表看作一个全局对象，其中键是传递给 **`Symbol.for()`** 的字符串，值是 symbol。

![](https://cdn-images-1.medium.com/max/5688/1*HZ06QgqZp3IQOpQ6LuYkkQ.png)

注册到全局的 symbol 对象不仅可以在所有范围内访问，甚至可以跨作用域访问。

## 在 Javascript 中加入这种数据类型的动机

添加这种数据类型的原因之一是为了在 JavaScript 中可以使用私有属性。在 Symbol 之前，私有性和不变性是通过闭包、代理和其他变通的方法来解决的。但是所有这些解决方案都过于冗长，需要大量的代码和逻辑才能实现。

因此，让我们看一下 Symbol 会如何解决该问题。从 Symbol 函数返回的每个 symbol 值都是唯一的，并且可用作对象属性标识符。这是 Symbol 的主要用途。

![](https://cdn-images-1.medium.com/max/4328/1*4aakLJrmi1vCnqPIncSFDw.png)

由于每个 symbol 都是唯一的，并且两个 symbol 之间不相等，所以如果当一个 symbol 用作属性标识符，并且在某个作用域内不可时用，那么这个属性则无法在该作用域中访问。

![](https://cdn-images-1.medium.com/max/4656/1*DOx36fH8NLbGYatdUKWG9w.png)

![](https://cdn-images-1.medium.com/max/4912/1*JoAxAJgflsM6tUEXSZ_sXQ.png)

可以使用 **`Symbol.for()`** 访问全局 symbol 注册表中定义的 symbol，参数相同，返回的 symbol 相同。

![](https://cdn-images-1.medium.com/max/4048/1*CaQbgutU-KYxLPOQm-7Ztw.png)

看起来 Symbol 很厉害是吧。它帮助我们创建了无法重复的唯一值，并使用它来**隐藏**属性。但是，它真的可以解决私有属性问题吗？

## symbol 能实现私有属性吗?

JavaScript 的 Symbol **没有** 实现属性私有化。你不能指望用 Symbol 来对使用者隐藏一些你的库中的内容。在 Object 类上定义了一个名为 **Object.getOwnPropertySymbols()** 的方法，该方法需要传入一个对象作为参数并返回参数对象的属性 symbol 数组，所以即使是 symbol 也都无法隐藏属性。

![](https://cdn-images-1.medium.com/max/7072/1*mzNkoGU403VrYTL0T2GBtw.png)

此外，如果将 symbol 分配给全局 symbol 注册表，这样全局都可以对 symbol 及其属性值访问。

## 计算机编程中的 Symbol

如果你熟悉其他编程语言，你可能会知道它们也有 symbol。事实上，即使数据类型的名称是相同的，它们之间也有相当大的差异。

现在让我们讨论一下编程中的 symbol。[维基百科](https://en.wikipedia.org/wiki/Symbol_(programming))中 symbol 的定义如下：

> 在计算机编程中 symbol 一般指的都是一种原始数据类型，它的实例具有唯一的可读性。

在 JavaScript 中，symbol 是一种基本的数据类型，虽然 JavaScript 不会强制你把实例变成易于阅读的，但你可以为 symbol 提供一个用于调试的描述属性。

看到这，我们应该知道 **JavaScript** 中的 symbol 和其他语言的 symbol 还是有区别的。让我们看一下 [**Ruby 语言中的 symbol**](https://ruby-doc.org/core-2.2.0/Symbol.html)。在 Ruby 中，Symbol 对象通常用于表示一些字符。它们通过冒号语法生成，也可以使用 **`to_sym`** 方法通过类型转换生成。

![](https://cdn-images-1.medium.com/max/5176/1*0u8FeH7Nn_fSmLWV2ixcLg.png)

或许你也注意到了，在 Ruby 中，我们绝不会将“创建的” symbol 分配给变量。如果我们在 Ruby 代码中使用（**创建**）了 symbol，则在程序的整个执行过程中，不管其创建上下文如何，symbol 将始终是相同的。

![](https://cdn-images-1.medium.com/max/5088/1*KbQyAg5yHC7KXSdBSWyR7Q.png)

而在 JavaScript 中，我们可以通过在全局 symbol 注册表中创建 symbol 来完成同样的操作。

两种语言中的 symbol 的一个主要区别是，在 Ruby 中，symbol 可以代替字符串使用，实际上在很多情况下， symbol 可以自动转换为字符串。在字符串对象上可用的方法在 symbol 上也可用，正如我们看到的，可以使用 **`to_sym`** 方法将字符串转换为 symbol。

我们已经了解了 JavaScript 添加 symbol 这种数据类型的原因和动机，现在让我们看看 symbol 在 Ruby 中的用途是什么。在 Ruby 中，我们可以将 symbol 视为不可变的字符串，仅此一项就带来了使用它们的许多优点。它们通常是用作对象属性标识符。

![](https://cdn-images-1.medium.com/max/4568/1*Fa2BNIGDEvDW9R_44uI97w.png)

symbol 也比字符串具有性能优势。每次使用字符串表示时，都会在内存中创建一个新对象，而 symbol 总是同一个对象的。

![](https://cdn-images-1.medium.com/max/4744/1*3qvoL8xoQD4H5As3u-j87g.png)

现在假设我们使用一个字符串作为属性标识符，并创建 100 个对象。在 Ruby 中，就不得不创建 100 个不同的字符串对象。如果使用 symbol 就可以避免上述这种情况。

关于 symbol 的另一个例子是状态显示。例如，对于函数来说，返回一个 symbol 是一种很好的做法，用（**:ok**，**:error**）来表示状态，以及结果.

在 [Rails](https://rubyonrails.org/) **（一个著名的 Ruby Web 应用框架）**中，几乎所有的 [HTTP 状态代码都可以与 symbol 一起使用](https://gist.github.com/mlanett/a31c340b132ddefa9cca)。你可以发送状态 **:ok**、**:internal_server_error** 或者 **:not_found**，Rails 将用正确的状态代码和消息替换它们。

综上所述，我们可以说，在所有的编程语言中，symbol 并不总是相同的，它们的目的也不尽相同。对于一个已经熟悉 Ruby symbol 的人来说，JavaScript symbol 及其动机着实让我有些困惑。

**注意：在某些编程语言中（[erlang](https://www.erlang.org/)、[elixir](https://elixir-lang.org/)）， symbol 也被称为 [atom](https://elixir-lang.org/getting-started/basic-types.html#atoms)。**

## JavaScript 中一些比较出名的 symbol

JavaScript 有一些内置的 symbol，允许开发者在 Javascript 还没引入 symbol 之前访问一些还没有暴露的属性。

以下是一些著名的 JavaScript symbol，用于 iteration、 Regexp 等。

#### Symbol.iterator

这个 symbol 允许开发人员访问对象的默认迭代器。它用于 **`for…of`**，其值应为 generator 函数。

![](https://cdn-images-1.medium.com/max/4224/1*pTFWK26OfUHMKysmg36Zlg.png)

![](https://cdn-images-1.medium.com/max/5520/1*qYvPQJVoT5tQKCjoQ5Hkuw.png)

> `function*() {}` 是用于定义 **generator 函数**的语法。generator 函数会返回 Generator 对象。

> `yield` 是用于暂停和恢复 generator 函数的关键字。

> 访问链接，了解更多关于 [generator 函数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/function*) 和 [yield](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/yield) 的信息.

对于异步迭代，有 **Symbol.asyncIterator**，它被用于 `**for await…of**` 循环。

#### Symbol.match

众所周知，诸如 **String.prototype.startsWith()，String.prototype.endsWith()** 这样的函数都会将字符串作为第一个参数。

![](https://cdn-images-1.medium.com/max/4656/1*ZQnSSyo2bD95Xo--mJDK3g.png)

让我们试着传递一个 regexp 而不是一个字符串给函数，我们会得到一个类型错误。

![](https://cdn-images-1.medium.com/max/6552/1*mVSJ9mZR6eiVxa_wt0piLw.png)

实际上，所发生的是，函数会专门检查所传递的参数是否为 regexp。但是，我们可以通过将对象的 **`Symbol.match`** 属性设置为 **false**或其他假值来表示该对象不会当作 regexp 使用。

![](https://cdn-images-1.medium.com/max/5256/1*bE28F0Oz0o5Sl6LGuHVR4Q.png)

**注意：说实话，我并不清楚这样写的意义所在。上面的代码是一个演示如何使用 `Symbol.match` 的示例。看起来像是 hack，如果这样使用会是有问题的，因为它会改变经常使用的语言本身功能的行为。所以，我想不出一个有任何实际的用例。**

## JavaScript 中 symbol 的用途

尽管 JavaScript 的 Symbol 并未得到广泛的使用，也无法解决私有属性的问题，但它还是有些用处的。

我们可以使用 Symbol 来定义对象上的一些**元数据**。例如，我们想要创建一个字典，我们将通过向对象添加单词和定义对来实现它，出于某些计算需求，我们想要跟踪字典中的单词数。在本例中，我们就可以将单词数视为元数据。对于用户来说，它并不是真正有价值的信息，用户在遍历对象时也不希望看到它。

![](https://cdn-images-1.medium.com/max/5088/1*sRYsDvC0c4-EQkaD-MIoww.png)

我们可以通过将单词计数属性保持为一个为 symbol 为键的对象来解决此问题。在这种情况下，我们避免了用户意外访问它的问题。

![](https://cdn-images-1.medium.com/max/5776/1*F6CB9NdXMu60kWx3TljHOA.png)

最常使用 symbol 的原因应该是解决属性名称冲突。有时，我们在迭代对象属性时获取并设置对象属性，或者我们使用动态值来访问属性 **（使用** obj[key] **的方式）** 。结果，意外地使我们不需要改变的属性发生了改变。因此我们可以通过使用 symbol 作为属性标识符来解决此问题。在这种情况下，我们永远无法在迭代对象或使用动态值时落在该键上。在迭代过程中这种情况也不会发生，因为我们在进行  **`for…in`** 时永远无法落在它们上。

![](https://cdn-images-1.medium.com/max/3184/1*yhZemW2nIYKx_CLHWP72-g.png)

动态值键的情况不会发生，因为一个 symbol 不等于其他任何值，除了它本身。

当然，还有一些众所周知的 symbol，比如 **`Symbol.iterator`** 以及 **`Symbol.asyncIterator`** 也很有趣。

![](https://cdn-images-1.medium.com/max/5448/1*ZkrQzQrm6Xf9LV_C9-KyZw.png)

我介绍了一些掌握 JavaScript 的 Symbol 所需的重要概念和实践。当然，同众所周知的其他语言的 “symbol” 一样，文章还有更多的内容需要涵盖，比如 symbol 跨作用域的例子，但是我将把这些有用的材料放在文末，这些内容将会涵盖 JavaScript Symbol 的其他部分。

#### 附加材料

- [JavaScript Symbol MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol)
- [ES6 Symbol tc39wiki](http://tc39wiki.calculist.org/es6/symbols/)
- [JS Symbols exploringjs.com](https://exploringjs.com/es6/ch_symbols.html)
- [JS Realms stackoverflow](https://stackoverflow.com/questions/49832187/how-to-understand-js-realms)
- [Symbol (programming) 维基百科](https://en.wikipedia.org/wiki/Symbol_(programming))
- [Ruby Symbols](https://ruby-doc.org/core-2.2.0/Symbol.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
