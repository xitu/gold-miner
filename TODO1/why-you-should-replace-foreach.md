> * 原文地址：[Why you should replace forEach with map and filter in JavaScript](https://gofore.com/en/why-you-should-replace-foreach/)
> * 原文作者：[Roope Hakulinen](https://disqus.com/by/roopehakulinen/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-replace-foreach.md](https://github.com/xitu/gold-miner/blob/master/TODO1/why-you-should-replace-foreach.md)
> * 译者：[zhmhhu](https://github.com/zhmhhu)
> * 校对者：[CoderMing](https://github.com/CoderMing), [diliburong](https://github.com/diliburong)

# 在 JavaScript 中 为什么你应当使用 map 和 filter 来替代 forEach

> 当你需要将一个数组或一部分数组复制到一个新数组时，首选 `map` 和 `filter`，而不是 `forEach`。

咨询工作对我来说最大的好处之一是我可以看到无数的项目。这些项目有大有小，使用的编程语言和开发人员能力差异很大。尽管我认为有很多模式都应该放弃使用，但 JavaScript 语言中的这种模式尤其要弃用：使用 forEach 创建新数组。该模式实际上非常简单，看起来像这样：

```
const kids = [];
people.forEach(person => {
  if (person.age < 15) {
    kids.push({ id: person.id, name: person.name });
  }
});
```

这段代码的意思是，处理一个包含所有人的数组，以找出每个年龄小于 15 岁的人。然后选择 person 对象中的其中几个字段作为 'kids' 对象，并将其复制到 kids 数组中。

虽然这是有效的，但这是非常必要的（参见[编程范例](https://en.wikipedia.org/wiki/Programming_paradigm)）编码方式。你可能有所怀疑，这有什么不对？要理解这一点，让我们首先熟悉两个朋友 `map` 和 `filter`。

## `map` 和 `filter`

 在 2015 年，`map` 和 `filter` 作为 ES6 特性集的一部分被引入 JavaScript。它们是数组的方法，允许在 JavaScript 中进行更多函数式编程。像在函数式编程世界中一样，这两种方法都没有改变原始数组。相反，它们都返回一个新数组。它们都接受函数类型的单个参数。然后在原始数组中的每一项上调用此函数以生成结果数组。让我们看看这些方法的作用：

*   `map`：每项调用函数处理后的值存放到返回的新数组中。
*   `filter`：每项调用函数处理后的值决定该项是否应该放在方法返回的新数组中。

在同一个团体中他们也有第三个朋友，但较少使用。这位朋友的名字是 [`reduce`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/reduce)。

以下是可以查看实际操作结果的简单示例：

```
const numbers = [1, 2, 3, 4, 5];
const doubled = numbers.map(number => number * 2); // [2, 4, 6, 8, 10]
const even = numbers.filter(number => number % 2 === 0); // [2, 4]
```

既然我们知道 `map` 和 `filter` 会做什么，让我们接下来看一个我希望前面的示例应当如何编写的例子：

```
const kids = people
  .filter(person => person.age < 15)
  .map(person => ({ id: person.id, name: person.name }));
```

如果您想知道 `map` 中使用的 lambda 的语法，请参阅此 [Stack Overflow answer](https://stackoverflow.com/a/28770578/1744702) 以获取解释。

那么这个实现究竟有什么好处：

*  关注点分离：过滤和更改数据格式是两个独立的问题，使用单独的方法可以分离关注点。
*  可测试性：为实现这两个目的，一个简单的、[纯函数](https://en.wikipedia.org/wiki/Pure_function)的方法可以轻松地针对各种行为进行单元测试。值得注意的是，初始实现并不像它依赖于其范围 （`kids` 数组）之外的某些状态那样纯粹。
*  可读性：由于这些方法具有过滤数据或更改数据格式的明确目的，因此很容易看出正在进行何种操作。特别是因为有那些同类功能的函数，如 `reduce`。
*  异步编程：`forEach` 和 `async`/`await` 不能很好地协同工作。另一方面，`map` 提供了一个能够结合 promises 和 `async`/`await` 的有效模式。在下一篇博文中有关于此问题的更多信息。

另一个值得注意的地方是，当你想引起副作用时（例如更改全局状态），不应当使用 `map`。特别是在不使用或存储 `map` 方法的返回值的情况下。

## 结论

`map` 和 `filter` 的使用提供了许多好处，例如关注点分离、可测试性、可读性和对异步编程的支持。因此，对我来说这是一个明智的选择。然而，我经常遇到使用 `forEach` 的开发人员。虽然函数式编程可能令人害怕，这些方法有也具有来自该世界的某些特征，对它们并不用害怕。在[响应式编程](https://en.wikipedia.org/wiki/Reactive_programming)中，`map` 和 `filter` 也被大量使用，感谢 [RxJS](http：//reactivex.io/rxjs/) 的贡献，响应式编程现在越来越多地在 JavaScript 世界中使用。因此，下次你要写一个 `forEach` 时，首先要考虑其他方法。但要注意，它们可能会永久改变您的编码方式。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
