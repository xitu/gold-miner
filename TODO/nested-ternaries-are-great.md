> * 原文地址：[Nested Ternaries are Great](https://medium.com/javascript-scene/nested-ternaries-are-great-361bddd0f340)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/nested-ternaries-are-great.md](https://github.com/xitu/gold-miner/blob/master/TODO/nested-ternaries-are-great.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[StarrieC](https://github.com/StarrierC) [goldEli](https://github.com/goldEli)

# 优秀的嵌套三元表达式（软件编写）（第十四部分）

![](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

（译注：该图是用 PS 将烟雾处理成方块状后得到的效果，参见 [flickr](https://www.flickr.com/photos/68397968@N07/11432696204)。）

> 这是 “软件编写” 系列文章的第十四部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科
>
> [< 上一篇](https://juejin.im/post/5a648ed0518825733201b818) | [<< 返回第一篇](https://medium.com/javascript-scene/composing-software-an-introduction-27b72500d6ea)

过去的经验会让你相信，嵌套三元表达式是不可读的，应当尽量避免。

> 经验有时候是愚蠢的。

真相其实是，**三元表达式通常比 if 语句更加简单**。人们不相信的原因有两个：

1. 他们更熟悉 if 语句。熟悉带来的偏见可能会让我们相信一些并不正确的事物，即便我们为真相提供了佐证。
2. 人们尝试像使用 if 语句那样去使用三元表达式。这样的代码是不能工作的，因为三元表达式是**表达式（expression）**，而非**语句（statement）**。

在我们深入细节之前，先为三元表达式做一个定义：

一个三元表达式是一个进行求值的条件表达式。它由一个条件判断，一个真值子句（truthy value，当条件为真时返回的值）和一个假值子句（falsy clause，当条件为假时返回的值）构成。

它们就像下面这样：

```js
(conditional)
  ? truthyClause
  : falsyClause
```

### 表达式 vs 语句

一些编程语言（包括 Smalltalk、Haskell 以及大多数函数式编程语言）都没有 if 语句。取而代之的是，`if` 表达式。

一个 if 表达式就是进行求值的条件表达式。它由一个条件判断，一个真值子句（truthy value，当条件为真时返回的值）和一个假值子句（falsy clause，当条件为假时返回的值）构成。

这个定义看起来是不是很熟悉？大多数函数式编程语言都使用**三元表达式**来表示 `if` 关键字。这是为什么呢？

一个表达式是一个求取单值的代码块。

一条语句则是一个不一定进行求值的代码段。在 JavaScript 中，一个 if 语句不会进行 **求值**。为了让 JavaScript 中的 if 语句有用，就**必须引起一个副作用（side-effect）或者是在 if 语句包裹的代码块中返回一个值**。

在函数式编程中，我们试图避免可变性以及其他的副作用。由于 JavaScript 中的 `if` 先天会带来可变性和副作用，所以包括我在内的一些函数式编程的拥趸会使用三元表达式来替换它。

三元表达式的思维模式与 if 语句有所不同，但如果你尝试实践几周，你也会自然而然的转到三元表达式。这可不只是因为它缩小了代码量，另一些优势你也将在后文中看到。

### 熟悉带来的偏见

我最常听到的关于三元表达式的抱怨就是 “难于阅读”。让我们通过一些代码范例来粉碎谣言：

```js
const withIf = ({
  conditionA, conditionB
}) => {
  if (conditionA) {
    if (conditionB) {
      return valueA;
    }
    return valueB;
  }
  return valueC;
};
```

注意到，这个版本中，通过嵌套的条件和可见的括号来分离真值和假值，这让真假值看起来失去了联系。这只是一个很简单的逻辑，但却需要花力气理解。

让我们再看看同样的逻辑，用三元表达式是怎么完成的：

```js
const withTernary = ({
  conditionA, conditionB
}) => (
  (!conditionA)
    ? valueC
    : (conditionB)
    ? valueA
    : valueB
);
```

这儿一些值得分享和讨论的点：

### 菊链法 vs 嵌套

>  译注：[菊链法（Daisy Chaining）](https://www.wikiwand.com/en/Daisy_chain_(electrical_engineering))，原意指多个设备按序或者围城一环进行连接。

首先，我们已经将嵌套铺平了。“嵌套的” 三元表达式有点用词不当，因为三元表达式很容易通过一条直线进行撰写，你完全不需要使用不同的缩进来嵌套它们。它们容易按照直线的顺序，自顶向下地进行阅读，一旦满足了某个真值或者假值就会立即返回。

如果你正确的书写了三元表达式，也就不需要解析任何的嵌套。沿着一条直线走，很难迷路。

我们应该称其为 “链式三元表达式” 而不是 “嵌套三元表达式”。

还有一点我想指出的就是，为了简化直线链接，我对顺序稍作了更改：如果你到达了三元表达式末尾，并且发现你需要写两条冒号子句（`:`）：

```js
// 译者补充这种情况
const withTernary = ({
  conditionA, conditionB
}) => (
  conditionA
    ? conditionB
    ? valueA
    : valueB
    : valueC
)
```

将最后一条子句提到链头，并且反转第一个条件判断逻辑来简化三元表达式的解析。现在，不再有任何困惑了！

值得注意的是，我们可以使用同样的手段来简化 if 语句：

```js
const withIf = ({
  conditionA, conditionB
}) => {
  if (!conditionA) return valueC;
  if (conditionB) {
    return valueA;
  }
  return valueB;
};
```

这好很多了，但是 `conditionB` 的关联子句被打破仍然是可见的，这还是会造成困惑。在维护代码期间，我已经看到过类似问题引起了逻辑上的 bug。即便逻辑被打平，这个版本的代码相较于三元表达式版本，还是稍显混乱。

### 语法混乱

`if` 版本的代码含有许多噪声：`if` 关键字 vs `?`，使用 `return` 来强制语句返回一个值、额外的分号、额外的括号等等。 不同于本文的例子，大多数 if 语句也改变了外部状态，这不仅增多了代码，还提高了代码复杂度。

这些额外代码带来的负面影响是我不喜欢用 if 的重要原因之一。在此之前，我已经讨论过，但在每个开发者都了然于胸前，我还是愿意不厌其烦地再唠叨一下：

#### 工作记忆

平均下来，人类大脑只有一小部分共享资源提供给对于离散的[存储在工作记忆中的量子](https://www.nature.com/articles/nn.3655)，并且每一个变量潜移默化地消费这些量子。当你添加更多的变量，你就会丧失对这些变量的含义的精确记忆能力。典型的，工作记忆模型涉及 4-7 个离散两字。超过这个数，错误率就会陡增。

与三元表达式相反，我们不得不将可变性和副作用融入 if 语句中，这通常会造成添加一些本不需要的变量进去。

#### 信噪比

简练的代码也会提高你代码的信噪比。这就像在听收音机 —— 如果收音机没有正确的调到某个频道，你就会听到许多干扰噪声，因此很难听到音乐。当你正确的调到某个频道，噪声就会远离，你听到的将是强烈的音乐信号。

代码也类似。表达式越精简，则越容易理解。一些代码给了我们有用的信息，一些则让我们云里雾里。如果你可以在不丢失所要传达的信息的前提下，缩减了代码量，你将会让代码更易于解析，也让其他的开发者更容易理解当中的意思。

#### 藏匿 Bug 的表面积

看一眼函数的前前后后。这就好像函数进行了节食，减去了成吨的体重。这是非常重要的，因为额外的代码就意味着更大的藏匿 Bug 的表面积，也就意味着更多的 bug。

> 更少的代码 = 更小的藏匿 bug 的表面积 = 更少的 bug。

#### 副作用与共享的可变状态

许多 if 语句不只进行了求值。它们也造成了副作用，或是改变了状态，倘若你想要知道 if 语句的完整影响，就需要知道 if 语句中的副作用的影响，对共享状态所有的变更历史等等。 

将你自己限制到返回一个值，能强制你遵循这个原则：切断依赖将以让你的程序更易于理解、调试、重构以及维护。

这确实就是三元表达式中我最喜欢的益处：

> 使用三元表达式将让你成为更好的开发者。

### 结论

由于所有的三元表达式都易于使用一个直线来自顶向下地分配，因此，称其为 “嵌套的三元表达式” 有点用词不当。取而代之的是，我们称其为 “链式三元表达式”。

相较于 if 语句，链式三元表达式有若干的优势：

* 它总是易于通过一条直线进行自顶向下的阅读和书写。只要你能沿着直线走，就能读懂链式三元表达式。
* 三元表达式减少了语法混乱。更少的代码 = 更小的藏匿 bug 的表面积 = 更少的 bug。
* 三元表达式不需要临时变量，这减少了工作记忆的负荷。
* 三元表达式有更好的信噪比。
* if 语句鼓励副作用和可变性。三元表达式则鼓励纯代码。
* 纯代码将我们的表达式和函数解耦，因此也将我们训练为更好的开发者。

### 在 EricElliottJS.com 上可以了解到更多

视频课程和函数式编程已经为  EricElliottJS.com 的网站成员准备好了。如果你还不是当中的一员，[现在就注册吧](https://ericelliottjs.com/)。

[![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)](https://ericelliottjs.com/product/lifetime-access-pass/)

* * *

**Eric Elliott** 是  [**“编写 JavaScript 应用”**](http://pjabook.com) （O’Reilly） 以及 [**“跟着 Eric Elliott 学 Javascript”**](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 **Adobe Systems**、**Zumba Fitness**、**The Wall Street Journal**、**ESPN** 和 **BBC** 等 , 也是很多机构的顶级艺术家，包括但不限于 **Usher**、**Frank Ocean** 以及 **Metallica**。

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
