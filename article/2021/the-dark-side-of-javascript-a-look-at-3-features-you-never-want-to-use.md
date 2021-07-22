> * 原文地址：[The Dark Side of Javascript: A Look at 3 Features You Never Want to Use](https://blog.bitsrc.io/the-dark-side-of-javascript-a-look-at-3-features-you-never-want-to-use-83b6f0b3804b)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-dark-side-of-javascript-a-look-at-3-features-you-never-want-to-use.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-dark-side-of-javascript-a-look-at-3-features-you-never-want-to-use.md)
> * 译者：[Z招锦](https://github.com/zenblofe)
> * 校对者：[CarlosChen](https://github.com/CarlosChenN)、[finalwhy](https://github.com/finalwhy)

# 简述 JavaScript 三个不应使用的功能

![Image by [Free-Photos](https://pixabay.com/photos/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1081873) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=1081873)](https://cdn-images-1.medium.com/max/3840/1*kSqZcIr9JLkFQgqwe4LEOQ.jpeg)

JavaScript 已经存在了相当长的一段时间（大约 26 年），在这段时间里，该语言已经有了很大的发展。

这种演变大多是有目的，特别是在最新的迭代中，开发者社区已经设法影响了其中的一些变化，使 JavaScript 成为一种非常灵活和好用的语言。

然而，在这些年的演变过程中，可以说仍有一些残余的过时功能，这些功能还没有被拿掉，但确实没有任何用途（或者更确切地说，在原本的用途方面效率不高）。

以下三个 JavaScript 特性，即使它们在运行时仍然可用，但你应避免去使用它们。

## void 操作符

你可能在某一时刻看到过 void 操作符的存在。在过去，每当你点击一个链接，而这个链接将触发一个 JavaScript 函数时，你会添加 `href="javascript:void(0)"` 以确保默认行为（即页面跳转）不会触发。

但这究竟是什么意思呢？

`void` 操作符是一种在 JavaScript 中生成 `undefined` 值的方法。没错，它能接受任何表达式，并且每次都返回 `undefined`。

我知道你在想什么：为什么不直接使用已经存在的 `undefined` 关键字呢？嗯，正如你看到的，在 ECMAScript 5 之前，`undefined` 关键字并不是一个常量值。是的，你可以定义 `undefined`，如果你再想一想，这不就是我们曾经想做的事情吗？

当然，这样做是没有意义的，这就是为什么最终它被重新定义为一个常量值，且不可更改。然而，因为早前你是可以改变它的，所以 `void` 会允许你访问 `undefined`，即使这个常量不再起作用。

事实上，一个很好的方法是通过创建你自己的 IIFEs 来重新定义只属于你的命名空间的常量，避免与第三方库的任何问题，其中一个参数确实是 `undefined`，像这样：

```JavaScript
(function (window, undefined) {
  // 你这里的逻辑，可以把 undefined 当作预期
})(window, void(0))
```

当然，今天的 `void` 操作符仍然有它的用途，但它是非必要的。例如，在现在的 JavaScript 中，最好的用例是帮助避免单行箭头函数的非预期返回。

你可能知道，一个单行箭头函数将返回该行的结果，即使你没有显式使用 `return` 语句。

```JavaScript
const double = x => x * 2; // 返回 X 乘以 2 的结果

const callAfunction = () => myFunction(); // 返回 myFunction 所返回的结果，即使我不想这样做
```

这两个函数都会返回一些东西。显然，对于 `double` 函数来说，你希望它返回一个值，但另一个可能不是，你可能只是想用它调用另一个函数（即 `myFunction()`），但你对其结果值不感兴趣。因此你可以这样做：

```JavaScript
const callAfunction = () => void myFunction(); // 返回 myFunction 所返回的结果，即使我不想这样做
```

而这将立即覆盖返回值，并确保你的调用只返回 `undefined`。

对我来说，这种行为提供了一个最小的好处，使 `void` 在这个时代的 JavaScript 中毫无用处。

我建议你避免使用它，让它保持一个废弃的状态。

## With 语句

这个是 JavaScript 自带的结构之一，但你可能从未听说过它，因为它并没有被真正推广。事实上，即使是 MDN 官方文档也不鼓励你使用它，因为它可能导致非常混乱的代码。

`with` 语句允许扩展给定语句的作用域链。换句话说，它允许你将一个表达式注入到给定语句的作用域，理想情况下，可以简化所述语句。

下面是一个示例，这样你就会明白我想说什么：

```JavaScript
function greet(user) {
  
  with(user) {
    console.log(`Hello there ${name}, how are you and your ${kids.length} kids today?`)
  }
}

greet({
  name: "Fernando",
  kids: ["Brian", "Andrew"]
})
```

注意 `greet` 函数中 `with` 语句的魔力。这是一个基本的示例，表明了表达式的 `happy path`。但是，让我们看另一个情况，事情变得有点复杂：

```JavaScript
function greet(user, message) {
  with(user) {
    console.log(`Hey ${name}, here is a message for you: ${message}`)
  }
}

// happy path
greet({
  name: "Fernando"
}, "You got 2 emails")

// kinda sad path
greet({
  name: "Fernando",
  message: "Unrelated message"
}, "you got email")
```

你认为这种执行方式的输出结果会是什么？

```
Hey Fernando, here is a message for you: You got 2 emails
Hey Fernando, here is a message for you: Unrelated message
```

由于你在传入的对象中添加了一个同名属性，你无意间覆盖了函数的第二个参数。我想补充的是，这完全是正常的，因为人们永远不会期望两者处于同一个作用域级别。然而，多亏了 `with`，我们把这两个作用域都混在了一起，但结果并不理想。

这都是为了说明要避免使用 `with`，虽然它可能看起来是节省代码量的好方法，但你的代码很快会变得非常复杂，这会对别人（或两周后的你）去理解你的代码造成心智负担。

## Labels 标签

如果你学习编程足够早（像我一样），你就经历过其他语言（如 C 语言）中对 `go-to` 语句的憎恨。那太糟糕了，那是一个在当年很有意义的功能，但最终随着同一问题的更新的解决方案，这种功能变得如此过时和糟糕，以至于变成了一种反模式。

因此 JavaScript 不得不去实现它。

`Go-to` 语句是一种方式，让你在代码的任何地方放置一个标记，然后从其他地方跳到那里。你可以跳到一个函数的中间，或者跳到一个 `IF` 语句里面，它就像一个神奇的入口，可以跳到你代码中的任何地方。我相信你可以看到这可能是一个问题，它的力量太大，灵活性太强，我们当然会错过使用它的机会。

然而，JavaScript 实现了一个类似的，但不完全相同的结构：`labels` 标签。

JavaScript 中的标签语句是一个你放在语句前的标记，然后你可以 `break` 或 `continue`。请注意，没有更多的 `go-to`，这是一个很好的优势。

你可以这样写：

```JavaScript
label1: {
  console.log(1)
  let condition = true
  if(condition) {
  	break label1
  }
  console.log(2)
}
console.log("end")
```

而输出结果将是：

```
1
end
```

当然，这个例子看起来非常像一个 `if..else` 语句。而且你完全可以说，它看起来并不那么糟糕。然而，你打破了代码的正常流程，跳过了语句。如果你就是希望如此，那么使用 `if..else` 带来的心智负担会小很多。

当我们把标签与循环和 `continue` 语句的相互作用包括在内时，`labels` 标签的问题就变得更明显了。

```JavaScript
let i, j;

loop1:
for(i = 0; i < 10; i++) {
  loop2:
  for(j = 0; j < 10; j++) {

    if(j == 3 && i == 2) {
      continue loop2;
    }
    console.log({i, j})
    if(j % 2 == 0) {
      continue loop1;
    }
  }
}
```

你能在头脑中运行上述代码并告诉我具体的输出结果吗？这并非不可能，但要花点时间。上面的脚本会打印：

```
{ i: 0, j: 0 }
{ i: 1, j: 0 }
{ i: 2, j: 0 }
{ i: 3, j: 0 }
{ i: 4, j: 0 }
{ i: 5, j: 0 }
{ i: 6, j: 0 }
{ i: 7, j: 0 }
{ i: 8, j: 0 }
{ i: 9, j: 0 }
```

从本质上讲，第二个 `if` 在 `0` 的时候评估为 `true`，所以 `continue` 语句影响了外循环，导致它移动到下一个索引值，这反过来又重置了内循环，导致它回到 `0`，同样的事情不断发生，重复了 `10` 次。第一个 `if`，如果你想知道的话，从来没有评估为 `true`，因为 `j` 从来没有达到 `0` 以外的任何值。

`labels` 标签可能是棘手的小家伙，即使你能正确地使用它们，并且从解释器的角度来看，它们也很有意义，但你应该为人类而不是为机器写代码。别人会来读它（甚至是三周后的你），当他们看到标签的那一刻，他们会永远恨你。当然，他们会花更多的时间来理解你代码的基本流程，但这在目前是次要问题。

## 本文总结

请不要误会，我喜欢 JavaScript 这门语言，自从 `18` 年前我开始从事网络开发工作以来，我一直在以不同的方式与它互动。我见证了这门语言的发展，就像一坛好酒，随着时间的推移而变得更好。然而，如果我说这门语言中没有一些我不喜欢的黑暗角落，那是假的。而这三个功能恰好表明了这一点。

好消息是，在我多年的经验中，我还没有看到 `with` 或标签（`Label`）被实施并部署到生产中。这并不是说没有这样的情况，只是我从未见过，这让我觉得没有多少代码审查会让它们通过。

你有没有看到这些功能在现代 JavaScript 中被使用？

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
