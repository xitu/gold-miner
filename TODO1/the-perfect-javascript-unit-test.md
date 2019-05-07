> * 原文地址：[The perfect JavaScript unit test](https://javascriptplayground.com/the-perfect-javascript-unit-test/)
> * 原文作者：[javascriptplayground.com](https://javascriptplayground.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-perfect-javascript-unit-test.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-perfect-javascript-unit-test.md)
> * 译者：[Xuyuey](https://github.com/Xuyuey)
> * 校对者：

# 完美的 Javascript 单元测试

今天我们讨论的是如何编写完美的单元测试以及如何确保测试的可读性，可用性和可维护性。

我发现这里有一个共同的主题，那些告诉我单元测试没用的人，通常都在编写糟糕的单元测试。完全可以理解，特别对于那些刚刚接触单元测试的新手。写出很棒的单元测试**很难**，它需要你经常练习才可以。我们今天要讨论的所有事情都是通过很艰难的方式学到的; 坏单元测试的痛苦致使我为如何编写好的单元测试创​​建了自己的规则。我们今天要讨论的就是这些规则。

## 为什么糟糕的测试非常致命？

如果你拿到的程序代码很混乱，那么就会很难处理。但希望你的代码能有一些测试，它们可以帮到你。如果能有测试支持你，那么处理那种混乱的代码还 OK。测试可以帮助你消除不良代码的影响。

但是糟糕的测试没有任何代码可以帮你处理它们。你不能为你的测试再去编写测试。你也**可以**，但是接下来你就必须为你的测试的测试编写测试，一个无穷无尽的循环，没有人想要这样……

## 不良测试的特点

很难定义一组不良测试的特征，因为不良测试不符合我们即将要讨论的任何规则。

如果你曾经看过一个测试并且不知道它正在测试什么，或者你无法明显地发现它的断言，那就是一个糟糕的测试。如果一个测试拥有写得不好的描述（`it('works')` 是我最喜欢的），那它就是一个糟糕的测试。

如果**你发现测试没有用**，那么它也是一个糟糕的测试。测试的**全部目的**是提高你的生产力、工作流程和对代码库的信心。如果测试没有这样做（或者积极地让它变得更糟），那么它肯定是一个糟糕的测试。

我坚信糟糕的测试比没有测试**更糟糕**。

## 好的测试都有一个好名字

好消息是，一旦你习惯了测试，那些好的测试规则很容易记住，而且非常直观！

一个好的测试有一个**简洁、描述性**的名称。如果你不能想出一个简短的名字，那么最好选择清晰明确的名称而不是仅仅省下了每行的长度。

```
it('filters products based on the query-string filters', () => {})
```

你应该能够从描述中了解到测试的目的是什么。你有时会看到下面这种写法，基于要测试的方法名称给 `it` 测试命名：

```
it('#filterProductsByQueryString', () => {})
```

但这并没有帮助 —— 想象一下如果你刚刚接触这些代码，你还得费力找出这个函数到底有什么功能。在这种情况下，方法名称是非常具有描述性的，但是一个真正人类可读的字符串总是更好，前提是你能想出来一个。

为测试命名的另一个指导方针是：确保你可以在 `it` 开头读取到句子。所以，如果我正在阅读下面的测试，我会在脑海中读到一句话：

> “it filters products based on the query-string filters（它基于查询字符串过滤器过滤产品）”

```
it('filters products based on the query-string filters', () => {})
``` 

看看下面这个描述，即使这个描述非常有描述性，但是测试并不是用来执行这个操作的，所以这个描述会感觉非常别扭：

```
it('the query-string is used to filter products', () => {})
```

## 完美测试的三个步骤

当我们为测试起好了名字，我们就该开始关注测试主体了。一个好的测试每次都遵循相同的模式：

```
it('filters products based on the query-string filters', () => {
  // 第一步：初始化
  // 第二步：调用代码
  // 第三步：断言
})
```

让我们依次看看这些步骤。

## 初始化

任何单元测试的第一个阶段都是初始化：这是你按顺序获取测试数据的地方，也是模拟运行此测试可能需要的任何功能的地方。

```
it('filters products based on the query-string filters', () => {
  // 第一步：初始化
  const queryString = '?brand=Nike&size=M'

  const products = [
    { brand: 'Nike', size: 'L', type: 'sweater' },
    { brand: 'Adidas', size: 'M', type: 'tracksuit' },
    { brand: 'Nike', size: 'M', type: 't-shirt' },
  ]

  // 第二步：调用代码
  // 第三步：断言
})
```

初始化这步应该构建执行测试**所需的一切**。在上面的例子中，我创建了查询字符串和我将用于测试的产品列表。注意我为产品列表挑选的测试数据：我有一些故意与查询字符串不匹配的项目，以及一个完全匹配的项目。如果我只有与查询字符串匹配的项目，那么这个测试不能证明过滤是有效的。

## 调用代码

这步通常是最短的：你应该在这里调用需要测试的函数。第一步中你应该已经构造了测试数据，所以在这里你可以直接将它们作为变量传递给函数。

```
it('filters products based on the query-string filters', () => {
  // 第一步：初始化
  const queryString = '?brand=Nike&size=M'

  const products = [
    { brand: 'Nike', size: 'L', type: 'sweater' },
    { brand: 'Adidas', size: 'M', type: 'tracksuit' },
    { brand: 'Nike', size: 'M', type: 't-shirt' },
  ]

  // 第二步：调用代码
  const result = filterProductsByQueryString(products, queryString)

  // 第三步：断言
})
```

> 如果测试数据非常少，我可能会合并第一步和第二步，但大部分时间我都发现将它们明确地按步骤拆分非常有价值，值得多写几行。

## 断言

这是最好的一步！是你所有的努力得到回报的地方，我们在这里检查事情有没有按照我们期望的进行。

我称之为断言步骤，因为我们在这里做一些断言，但是现在我倾向于使用 Jest 和它的 `expect` 函数，所以如果你愿意的话你也可以称之为 “期望步骤”。

```
it('filters products based on the query-string filters', () => {
  // 第一步：初始化
  const queryString = '?brand=Nike&size=M'

  const products = [
    { brand: 'Nike', size: 'L', type: 'sweater' },
    { brand: 'Adidas', size: 'M', type: 'tracksuit' },
    { brand: 'Nike', size: 'M', type: 't-shirt' },
  ]

  // 第二步：调用代码
  const result = filterProductsByQueryString(products, queryString)

  // 第三步：断言
  expect(result).toEqual([{ brand: 'Nike', size: 'M', type: 't-shirt' }])
})
```

经过上面这些操作，现在我们有了一个完美的单元测试：

1.  它有一个描述性的名称，读起来非常清楚，简洁。
2.  它有一个明确的初始化阶段，我们在这里构建测试数据。
3.  调用步骤仅限于调用我们的函数并使用我们的测试数据。
4.  我们的断言非常明确，清楚地验证了我们正在测试的功能。

## 小改进

虽然实际上我不会在实际测试中包含 `// STEP ONE: SETUP` 这些注释，但是我发现在三个部分之间加上一个空行非常有用。所以，如果这个测试真的出现在我的代码库中，那么它应该是下面这样：

```
it('filters products based on the query-string filters', () => {
  const queryString = '?brand=Nike&size=M'
  const products = [
    { brand: 'Nike', size: 'L', type: 'sweater' },
    { brand: 'Adidas', size: 'M', type: 'tracksuit' },
    { brand: 'Nike', size: 'M', type: 't-shirt' },
  ]

  const result = filterProductsByQueryString(products, queryString)

  expect(result).toEqual([{ brand: 'Nike', size: 'M', type: 't-shirt' }])
})
```

如果我们正在构建一个包含产品的系统，我希望创建一种更简单的方法来创建这些产品。所以我构建了 [test-data-bot](https://github.com/jackfranklin/test-data-bot) 库，它可以轻松做到上面的事情。我不会深入介绍它的工作原理，但它可以让你轻松地创建**工厂（factories）**来构建测试数据。如果我们用了这个构建工具（`README` 有详细的说明），我们可以像下面这样重写测试：

```
it('filters products based on the query-string filters', () => {
  const queryString = '?brand=Nike&size=M'
  const productThatMatches = productFactory({ brand: 'Nike', size: 'M' })

  const products = [
    productFactory({ brand: 'Nike', size: 'L' }),
    productFactory({ brand: 'Adidas', size: 'M' }),
    productThatMatches,
  ]

  const result = filterProductsByQueryString(products, queryString)

  expect(result).toEqual([productThatMatches])
})
```

通过这样做，我们移除了所有与测试无关的产品的细节（注意 `type` 字段现在并不在我们的测试中），然后通过更新工厂，我们可以轻松地让测试数据和真实数据保持同步。

我还为我想要匹配的产品创建了一个常量，这样我们就可以在断言步骤中重用它。避免了重复的代码并使测试更加清晰 —— 命名为 `productThatMatches` 的测试数据本身就是一个强烈的暗示，告诉我们这就是期望函数返回的内容。

## 总结

如果你在编写测试的时候遵循了上面的规则，我相信你一定会发现你的测试更容易使用，而且对你的开发流程更有帮助。测试和其它任何事情一样：需要时间和练习。记住三个步骤：`setup`、`invoke` 和 `assert`，你一定可以写出完美的单元测试。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
