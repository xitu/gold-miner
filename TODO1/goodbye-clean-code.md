> * 原文地址：[Goodbye, Clean Code](https://overreacted.io/goodbye-clean-code/)
> * 原文作者：[Dan Abramov](https://mobile.twitter.com/dan_abramov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/goodbye-clean-code.md](https://github.com/xitu/gold-miner/blob/master/TODO1/goodbye-clean-code.md)
> * 译者：[zh1an](https://github.com/zh1an)
> * 校对者：[ahabhgk](https://github.com/ahabhgk), [febrainqu](https://github.com/febrainqu)

# 再见，整洁的代码

那是一个深夜。

我同事刚刚合并了他们已经写了整整一周的代码。我们在做图形编辑画布，并且他们实现了调整形状大小的方法，比如矩形或者椭圆形在它们的边缘拖拽小按钮。

代码生效了。

但是它单调且重复。每个形状（例如矩形或者椭圆形）都有一组不同按钮，并且往不同的方向拖拽每个按钮都会通过不同的方式来影响着形状的位置和大小。如果用户按住 Shift 按键，我们还应该需要在调整大小时呈现其属性。这也有一大堆数学计算。

代码看起来就像这样：

```jsx
let Rectangle = {
  resizeTopLeft(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
  resizeTopRight(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
  resizeBottomLeft(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
  resizeBottomRight(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
};

let Oval = {
  resizeLeft(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
  resizeRight(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
  resizeTop(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
  resizeBottom(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
};

let Header = {
  resizeLeft(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
  resizeRight(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },  
}

let TextBlock = {
  resizeTopLeft(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
  resizeTopRight(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
  resizeBottomLeft(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
  resizeBottomRight(position, size, preserveAspect, dx, dy) {
    // 10 行重复的数学计算
  },
};
```

这种重复的数学计算着实让我恼火。

它并不**整洁**。

大多数的重复都在相似的方向之间。例如，`Oval.resizeLeft()` 跟 `Header.resizeLeft()` 相似。这是因为他们两个在左边的拖拽处理基本是类似的。

另外一个相似点就是介于那些相同形状之间的方法之间。例如，`Oval.resizeLeft()` 和另外一个 `Oval` 的方法类似。这是因为他们所有的处理椭圆形的方式类似。在 `Rectangle`、`Header` 和 `TextBlock` 之间有一些也是重复的，因为它们都是矩形。

我有一个想法。

我们可以**移除所有的重复**，把代码组织成这样：

```jsx
let Directions = {
  top(...) {
    // 5 行唯一的数学计算
  },
  left(...) {
    // 5 行唯一的数学计算
  },
  bottom(...) {
    // 5 行唯一的数学计算
  },
  right(...) {
    // 5 行唯一的数学计算
  },
};

let Shapes = {
  Oval(...) {
    // 5 行唯一的数学计算
  },
  Rectangle(...) {
    // 5 行唯一的数学计算
  },
}
```

然后组合它们的行为：

```jsx
let {top, bottom, left, right} = Directions;

function createHandle(directions) {
  // 20 行代码
}

let fourCorners = [
  createHandle([top, left]),
  createHandle([top, right]),
  createHandle([bottom, left]),
  createHandle([bottom, right]),
];
let fourSides = [
  createHandle([top]),
  createHandle([left]),
  createHandle([right]),
  createHandle([bottom]),
];
let twoSides = [
  createHandle([left]),
  createHandle([right]),
];

function createBox(shape, handles) {
  // 20 行代码
}

let Rectangle = createBox(Shapes.Rectangle, fourCorners);
let Oval = createBox(Shapes.Oval, fourSides);
let Header = createBox(Shapes.Rectangle, twoSides);
let TextBox = createBox(Shapes.Rectangle, fourCorners);
```

这是所有代码的一半，并且那些重复的也消失无踪啦！如此的整洁。如果我们想要改变一个特殊方向或者形状的表现，我们只需要修改一个地方的代码而不是修改所有地方。

当时的确是很晚啦（我忘乎所以了）。我将我重构的代码合并到  `master`，然后就去睡觉了，并且非常骄傲我竟然解开了我同事那杂乱无章的代码。

## [](#the-next-morning)第二天

…… 但事与愿违。

我的上司叫我单独聊，很礼貌地要求我撤回我的更改。我惊呆了。老代码那么乱而我的如此的整洁！

我勉强的服从了，直到多年以后我才知道他们是对的。

## [](#its-a-phase)这是一个阶段

痴迷于“代码的整洁之道”并且移除重复是我们大多数必经的一个阶段。当我们对代码不自信时，很容易将我们的自我价值感和专业自豪感附加到可以衡量的事物上，一组严格的 lint 规则、命名规则、文件结构和没有重复。

你不能使移除重复自动化，但是它**的确**随着练习变得更容易。通常情况下你都可以分辨出在每次更改之后它是更少了还是更多了。结果，移除重复感觉就像是改善代码的一种指标。更糟糕的是，它与人们的认同感交织在一起：“我就是写整洁代码的那个人”。这比任何一种自我欺骗都有效。

一旦我们学习了如何去创建 [abstractions（抽象）](https://www.sandimetz.com/blog/2016/1/20/the-wrong-abstraction)，就很容易掌握这种技能，当我们看到重复的代码时，就会从中抽出抽象层。经过几年编码之后，如果我们随处随地看到重复性代码，那么，抽象就是我们新的超能力。如果某个人告诉我们抽象是优点，我们也会认同。并且我们开始判断其他人会不会崇拜这种“整洁”能力。

我现在知道，我的“重构”在两个方面是致命的：

* 第一，我没有跟代码作者讨论。我在没有他们参与的情况下重写了代码并且检出。甚至，假如它“的确”是一种改进（现在我再也不相信了），这种方式也是很可怕的。一个健康的工程师团队不断地**建立信任**。在没有讨论的情况下重写你队友的代码对你在代码库上的有效协作的能力是一个巨大的打击。
* 第二，天下没有免费的午餐。我的代码通过更改需求来减少重复，然而这并不是个很好的交易。例如，在之后我们需要很多的针对不同的形状的不同的句柄的特殊情况和行为，我们的抽象不得不变得异常的复杂才能负担的起，而对于原始的“杂乱无章的”版本，这样的更改就像蛋糕一样简单。

我要说你应该写“脏”代码吗？不，我建议你对“整洁”或“脏”代码的意思进行深思。你有反抗的感觉吗？或是正直？或是漂亮？或是优雅？对于具体的工程结果来说，你如何准确的命名这些品质？它们有多准确地表达这种代码编写或者[修改](/optimized-for-change/)方式？

我当然没有对这些事情进行过深思熟虑。我对代码的**外观**进行了很多的思考，但并考虑它在压测团队中会如何进化。

编码是一段旅程。考虑从你的第一行代码到你现在的位置有多远。我觉得很高兴看到第一次如何提取一个函数或者重构一个类，它能使错中复杂的代码变得简单。如果你对自己的技术感到自豪，并且很容易做到代码的整洁。那就试试。

但是不要停滞不前，沾沾自喜。不要成为整洁代码的狂热者。整洁代码不是目标。它只是尝试使我们处理的复杂系统获得某种意义。它只是在你还不能确定更改会对代码库有怎样的影响时给出指引，这使一种防御机制。

让整洁代码指引你。**然后，随它去吧。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
