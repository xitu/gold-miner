> * 原文地址：[Composing Software: An Introduction](https://medium.com/javascript-scene/composing-software-an-introduction-27b72500d6ea)
> * 原文作者：[Eric Elliott](Eric Elliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/composing-software-an-introduction.md](https://github.com/xitu/gold-miner/blob/master/TODO1/composing-software-an-introduction.md)
> * 译者：[Sam](https://github.com/xutaogit)
> * 校对者：[Mcskiller](https://github.com/Mcskiller), [CoderMing](https://github.com/CoderMing)

# 程序构建系列教程简介

![](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)

> 注意：这是关于从头开始使用 JavaScript ES6+ 学习函数式编程和组合软件技术的 “Composing Software” 系列介绍。还有更多关于这方面的内容！
> [**下一篇 >**](https://github.com/xitu/gold-miner/blob/master/TODO1/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md)

> 组合：“将部分或元素结合成整体的行为。” —— Dictionary.com

在我的高中第一堂编程课中，我被告知软件开发是“把复杂问题分解成更小的问题，然后构建简单的解决方案以得出复杂问题最终的解决方案的行为。”

我一生中最大的遗憾之一就是没能很早认识到这堂课的重要性。我太晚才了解到软件设计的本质。

我面试过数百名开发者。从这些对话中我了解到自己不是唯一(处于这种情况)的。极少工作软件开发者能很好地抓住软件开发的本质。他们不了解我们在使用的最重要工具，或者不知道如何充分利用它们。所有人都一直在努力回答软件开发领域中这一个或两个最重要的问题：

*   什么是函数组合？
*   什么是对象组合？

问题是你不能因为仅仅没有意识它就躲避构建。你依然需要这样做 —— 虽然你做的很糟糕。你编写了带有更多 bug 的代码，让其他开发者很难理解。这是很大的问题，代价也很大。我们花费更多时间来维护软件而不是从头开始创建软件，我们的这些 bug 会影响全球数十亿人。

现今整个世界都运行在软件上。每一辆新车都是一台在车轮上的小型超级计算机，软件设计的问题会导致真正的事故并且造成真正的生命损失。2013 年，一个陪审团发现 Toyota 的软件团队犯了[“全然无视”的罪名](http://www.safetyresearch.net/blog/articles/toyota-unintended-acceleration-and-big-bowl-%E2%80%9Cspaghetti%E2%80%9D-code)，因为事故调查显示它们有着 10,000 个全局变量的面条代码。

[黑客和政府存储漏洞](https://www.technologyreview.com/s/607875/should-the-government-keep-stockpiling-software-bugs/)为了监视人民，盗取信用卡，利用计算资源做分布式拒绝服务(DDoS)攻击，破解密码，甚至[操纵选举](https://www.technologyreview.com/s/604138/the-fbi-shut-down-a-huge-botnet-but-there-are-plenty-more-left/)。

我们必须做得更好才行。

### 你每天都在构建软件

如果你是一个软件开发者，不管你知不知道，你每天都会编写函数和数据结构。你可以有意识地（并且更好地）做到这一点，或者你可能疯狂的复制粘贴意外地做到这一点。

软件开发的过程是把大问题拆分成更小的问题，构建解决这些小问题的组件，然后把这些组件组合在一起形成完整的应用程序。

### 函数组合

函数组合是将一个函数应用于另一个函数输出结果的过程。在代数中，给出了两个函数，`f` 和 `g`，`(f ∘ g)(x) = f(g(x))`。圆圈是组合运算符。它通常发音为“复合（composed with）”或者“跟随（after）”。你可以像这样大声的念出来：“`f`复合 `g` 等价于 `f` 是 `g` 关于 `x` 的函数”或者“`f` 跟随 `g` 等价于 `f` 是 `g` 关于 `x` 的函数”。我们说 `f` 跟随 `g` 是因为先求解 `g`，然后它的输出作为 `f` 的执行参数。

每次你像这样编写代码时，你都在组合函数：


```
const g = n => n + 1;
const f = n => n * 2;

const doStuff = x => {
  const afterG = g(x);
  const afterF = f(afterG);
  return afterF;
};

doStuff(20); // 42
```

每次你编写一个 Promise 链，你都在组合函数：

```
const g = n => n + 1;
const f = n => n * 2;

const wait = time => new Promise(
  (resolve, reject) => setTimeout(
    resolve,
    time
  )
);

wait(300)
  .then(() => 20)
  .then(g)
  .then(f)
  .then(value => console.log(value)) // 42
;
```

同样，每次你进行链式数组方法调用，lodash 库的方法，observables（RxJS 等等）时，你在组合函数。如果你进行链式调用，你都在进行组合。如果你把函数返回值传递到另一个函数中，你在进行组合。如果你顺序的调用两个方法，你使用 `this` 作为输入数据进行组合。

> 如果你在进行链式（调用），你便是在进行（函数）构建。

当你有意识地组合函数时，你会做得更好。

有意识地的组合使用函数，我们可以把 `daStuff()` 函数改进成简单的一行（代码）：

```
const g = n => n + 1;
const f = n => n * 2;

const doStuffBetter = x => f(g(x));

doStuffBetter(20); // 42
```

这种形式的一个常见异议是调试起来比较困难。举个例子，使用函数组合我们该如何编写这些内容？

```
const doStuff = x => {
  const afterG = g(x);
  console.log(`after g: ${ afterG }`);
  const afterF = f(afterG);
  console.log(`after f: ${ afterF }`);
  return afterF;
};

doStuff(20); // =>
/*
"after g: 21"
"after f: 42"
*/
```

首先，让我们抽象出 “after f” 和 “after g”，定义一个名为 `trace()` 的小功能：

```
const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};
```

现在我们可以像这样使用它：

```
const doStuff = x => {
  const afterG = g(x);
  trace('after g')(afterG);
  const afterF = f(afterG);
  trace('after f')(afterF);
  return afterF;
};

doStuff(20); // =>
/*
"after g: 21"
"after f: 42"
*/
```

像 Lodash 和 Ramda 这些流行的函数式编程库里包含了更容易使用函数组合的实用程序。你可以像这样重写上面的函数：

```
import pipe from 'lodash/fp/flow';

const doStuffBetter = pipe(
  g,
  trace('after g'),
  f,
  trace('after f')
);

doStuffBetter(20); // =>
/*
"after g: 21"
"after f: 42"
*/
```

如果你想在不导入内容的情况下尝试这些代码，你可以像这样定义 pipe：

```
// pipe(...fns: [...Function]) => x => y
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);
```

如果你不理解它是怎么工作的也别担心。稍后我们将会更详尽的探索函数组合。事实上，它是如此的重要，你会在整个文档中看到它多次被定义和显示。目的是帮助你熟悉它，知道它的定义和用法是自动的。让你成为组合家族的一份子。

`pipe()` 创建一个函数的管道（pepeline），把一个函数的输出作为另一个函数的输入。当你使用 `pipe()`（和它的孪生方法 `compose()`）时，你不需要中间变量。在不提及参数的情况下编写的函数成为**无值风格。**为此，你将调用一个返回新函数的函数，而不是显示的声明该函数。这意味着你不需要`function`关键字或者箭头语法（`=>`）。

无值风格可能会占用太多，但很好的一点是，那些中间变量给你的函数增加了不必要的复杂性。

降低复杂度有几个好处：

#### 工作记忆

在人类大脑[工作记忆](http://www.nature.com/neuro/journal/v17/n3/fig_tab/nn.3655_F2.html)里平均只有很少共享资源用于离散量子，并且每个变量可能消耗其中一个量子。随着你添加更多的变量，我们准确回忆起每个变量含义的能力会降低。工作记忆模型通常涵盖 4-7 个离散量子。超过这些数字的话，（处理问题的）错误率急剧增加。

使用管道（pipe）模式，我们消除了三个变量 —— 为处理其他事情释放了将近一半可用的工作记忆。这显著降低了我们的认知负担。相比于一般人，软件开发者更倾向于将数据分块到工作记忆中，但并不是说会削弱保护的重要性。

#### 信噪比

简洁的代码也可以提高你的代码信噪比。这就像收听收音机 —— 当收音机没有调到正确的电台时，会有很多干扰的噪音，并且很难听到音乐。当你调到正确的电台，噪音没有了，然后你得到更强的音乐信号。

代码也是一样的。更简洁的代码表达式可以增强理解力。有些代码给我们提供有用的信息，而有些代码只是占用空间。如果你可以减少使用代码的量而不减少传输的含义，那么你将使代码更易于解析并且对于要阅读代码的其他人来说也更好理解。

#### bug 的覆盖面

看看之前和之后的功能。看起来函数做了缩减并且减轻了很多代码量。这很重要，因为额外的代码意味着 bug 有额外的覆盖面区域隐藏，这意味着更多的 bug 会隐藏其中。

> **更少的代码 = 更少的错误覆盖面积 = 更少的 bug。**

### 组合对象

> “在类继承上支持对象组合”，Gang of Four 说，“[设计模式：可重用面向对象软件的元素](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612/ref=as_li_ss_tl?ie=UTF8&qid=1494993475&sr=8-1&keywords=design+patterns&linkCode=ll1&tag=eejs-20&linkId=6c553f16325f3939e5abadd4ee04e8b4)。”

> “在计算机科学中，复合数据类型或组合数据类型是可以使用编程语言原始数据类型和其他复合类型构建的任何数据类型。[…] 构建复合类型的行为称为组合。“ —— 维基百科

这些是原始值：

```
const firstName = 'Claude';
const lastName = 'Debussy';
```

这是一个复合值：

```
const fullName = {
  firstName,
  lastName
};
```

同样，所有 Arrays、Sets、Maps、WeakMaps 和 TypedArrays 等都是复合数据类型。每次你构建任何非原始数据结构的时候，你都在执行某种对象组合。

请注意，Gang of Four 定义了一种称为**复合模式**的模式，它是一种特定类型的递归对象组合，允许你以相同的方式处理单个组件和聚合组合。有些开发者可能会感到困惑，认为复合模式是对象组合的唯一形式。不要混淆。有很多不同种类的对象组合。

Gang of Four 继续说道，“你将会看到对象组合在设计模式中一次又一次地被应用”，然后他们列出了三种对象组合关系，包括**委托**（在状态，策略和观察者模式中使用），**结识**（当一个对象通过引用知道另一个对象时，通常是作为一个参数传递：一个 uses-a 关系，例如，一个网络请求处理程序可能会传递一个对记录器的引用来记录请求 —— 请求处理程序**使用**一个记录器），和**聚合**（当子对象形成父对象一部分时：一个 has-a 关系，例如，DOM 子节点是 DOM 节点中的组件元素 —— DOM 节点**拥有**子节点）。

类继承可以用在构建复合对象，但这是一种充满限制性和脆弱性的方法。当 Gang of Four 说“在类继承上支持对象组合”时，他们建议你使用灵活的方式来构建复合对象，而不是使用刚性的，紧密耦合的类继承方法。

我们将使用“[计算机科学中的分类方法：与拓扑相关的方面](https://www.amazon.com/Categorical-Methods-Computer-Science-Topology/dp/0387517227/ref=as_li_ss_tl?ie=UTF8&qid=1495077930&sr=8-3&keywords=Categorical+Methods+in+Computer+Science:+With+Aspects+from+Topology&linkCode=ll1&tag=eejs-20&linkId=095afed5272832b74357f63b41410cb7)”（1989）中对象组成更一般的定义：

> ”通过将对象放在一起形成复合对象，使得后者中的每一个都是‘前者’的一部分。“

另一个很好的参考是“通过复合设计可靠的软件”，Glenford J Myers，1975年。这两本书都已经绝版了，但如果你想在对象组成技术的主题上进行更深入的探索，你仍然可以在亚马逊或者 eBay 上找到卖家。

**类继承只是一种复合对象结构。**所有类生成复合对象，但不是所有的复合对象都是由类或者类继承生成的。“在类继承上支持对象组合”意味着你应该从小组件部分构建复合对象，而不是在类层次上从祖先继承所有属性。后者在面向对象设计中引起大量众所周知的问题：

* **强耦合问题：**因为子类依赖于父类的实现，类继承是面向对象设计中最紧密的耦合。
* **脆弱的基类问题：**由于强耦合，对基类的更改可能会破坏大量的后代类 —— 可能在第三方管理的代码中。作者可能会破坏掉他们不知道的代码。
* **不灵活的层次结构问题：**对于单一的祖先分类法，给定足够的时间和改进，所有的类分类法最终都是错误的新用例。
* **必要性重复问题：**由于层次结构不灵活，新的用例通常是通过复制而不是扩展来实现，从而导致类似的类意外地的发散。一旦复制开始，就不清楚或者为什么哪个新类应该从哪个类开始。
* **大猩猩/香蕉问题：**”...面向对象语言的问题在于它们自身带有所有隐含的环境。你想要的是一根香蕉，但你得到的是拿着香蕉的大猩猩和整个丛林。“ —— Joe Armstrong，["工作中的编码员"](http://www.amazon.com/gp/product/1430219483?ie=UTF8&camp=213733&creative=393185&creativeASIN=1430219483&linkCode=shr&tag=eejs-20&linkId=3MNWRRZU3C4Q4BDN)。

JavaScript 中最常见的对象组合形式称为**对象链接**（又称混合组合）。它像冰淇淋一样。你从一个对象（如香草冰淇淋）开始，然后混合你想要的功能。加入一些坚果，焦糖，巧克力漩涡，然后你会结出坚果焦糖巧克力漩涡冰淇淋。

使用类继承构建复合：

```
class Foo {
  constructor () {
    this.a = 'a'
  }
}

class Bar extends Foo {
  constructor (options) {
    super(options);
    this.b = 'b'
  }
}

const myBar = new Bar(); // {a: 'a', b: 'b'}
```

使用混合组合构建复合：

```
const a = {
  a: 'a'
};

const b = {
  b: 'b'
};

const c = {...a, ...b}; // {a: 'a', b: 'b'}
```

我们稍后将更加深入的探索其他对象组合风格。目前，你的理解应该是：

1.  有很多种方法可以做到这一点（复合）。
2.  有些方法比其他方式更好。
3.  你希望选择为手头的任务选择最简单，最灵活的解决方案。

### 总结

这不是关于函数式编程（FP）和面向对象编程（OOP）的比较，或者一种语言和另一种语言的对比。组件可以采用函数，数据结构，类等形式...不同的编程语言为组件提供不同的原子元素。Java 提供类，Haskell 提供函数等等...但无论你喜欢什么语言和范式，归结到底，你都无法摆脱编写函数和数据结构。

我们将讨论很多关于函数式编程的知识，因为函数是用 JavaScript 编写的最简单的东西，并且函数式编程社区投入了大量时间和精力来形式化函数组合技术。

我们不会做的是说函数式编程比面向对象编程更好，或者你必须择其一。把 OOP 和 FP 做比较是一个错误的想法。就我近些年看到的每个真正的 JavaScript 应用都广泛混合使用 FP 和 OOP。

我们将使用对象组合来生成用于函数式编程的数据类型，以及用于为 OOP 生成对象的函数式编程。

**无论你如何编写软件，都应该把它写得更好。**

> 软件开发的本质是组合。

不了解组合的软件开发人员就像不知道螺栓和钉子的房屋建筑师。在没有组合意识的情况下构建软件就像一个房屋建筑师把墙壁用胶带和强力胶水捆绑在一起。

是时候简化了，简化的最好方法就是了解本质。问题是，业内几乎没有人能够很好的掌握到最本质元素。就软件行业来说，作为一个开发者这算失败的。但从行业的角度来看我们有责任更好的培训开发人员。我们必须改进。我们需要承担责任。从经济到医疗设备，今天所有的一切都运行在软件上。在我们星球上没有人类生活的角落不受到软件质量影响的。我们需要知道我们在做什么。

是时候学习如何编写软件了。

[继续“函数式编程的兴衰与崛起”](https://medium.com/javascript-scene/the-rise-and-fall-and-rise-of-functional-programming-composable-software-c2d91b424c8c)

### 在 EricElliottJS.com 上了解更多信息

[有关函数和对象组成的视频课程](https://ericelliottjs.com/premium-content/)可供 EricElliottJS.com 的成员使用。如果你不是成员，[请立即注册](https://ericelliottjs.com/)。

[![](https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg)](https://ericelliottjs.com/product/lifetime-access-pass/)

* * *

**_Eric Elliott_ 是 “[JavaScript 应用程序编程](http://pjabook.com)”（O'Reilly）和“[和 Eric Elliott 一起学习 JavaScript](http://ericelliottjs.com/product/lifetime-access-pass/)”的作者。他为 Adobe Systems、Zumba Fitness、华尔街日报、ESPN、BBC 以及包括 Usher、Frank Ocean 和 Metallica 等在内的很多顶级录音艺术家的软件体验做出了贡献**。

**他与世界上最美丽的女人在任何地方远程工作。**

感谢 [JS_Cheerleader](https://medium.com/@JS_Cheerleader?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
