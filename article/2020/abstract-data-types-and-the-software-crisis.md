> * 原文地址：[Abstract Data Types and the Software Crisis](https://medium.com/javascript-scene/abstract-data-types-and-the-software-crisis-671ea7fc72e7)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/abstract-data-types-and-the-software-crisis.md](https://github.com/xitu/gold-miner/blob/master/article/2020/abstract-data-types-and-the-software-crisis.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[leexgh](https://github.com/leexgh)、[landiy](https://github.com/landiy)、[lsvih](https://github.com/lsvih)

# 抽象数据类型与软件危机

![Image: [MattysFlicks — Smoke Art — Cubes to Smoke](https://www.flickr.com/photos/68397968@N07/11432696204) ([CC BY 2.0](https://creativecommons.org/licenses/by/2.0/))](https://cdn-images-1.medium.com/max/4096/1*DSu4IJYOeNzJbQIip9oTVg.jpeg)

> **注：** 这是《组合软件》系列的一部分[（现在是一本书！）](https://leanpub.com/composingsoftware)。从基础开始学 JavaScript ES6+ 函数式编程和组合软件技术。敬请关注，未完待续！
[购买此书](https://leanpub.com/composingsoftware) | [索引](https://medium.com/javascript-scene/composing-software-the-book-f31c77fc3ddc) | [\< 上一篇](https://medium.com/javascript-scene/abstraction-composition-cb2849d5bdd6) | [下一篇 >](https://medium.com/javascript-scene/functors-categories-61e031bac53f)

## 抽象数据类型

> **不要与以下内容混淆：**
>
> **代数数据类型**（有时缩写为 ADT 或 AlgDT）。代数数据类型是指编程语言中的复杂类型（例如 Rust、Haskell、F＃），这些类型表现出的特性之一是具有特定的代数结构，例如，积（product）与和（sum）类型。
>
> **代数结构。** 代数结构是从抽象代数研究和应用而来的，抽象代数与 ADT 一样，通常也使用代数公理来进行描述，但它的应用范围却远不止计算机和代码。有些代数结构是不能在软件中完全地建模的。相比之下，抽象数据类型可以作为规范和指南来正式验证软件运行。

抽象数据类型（ADT）是由公理定义的抽象概念，这些公理表示数据和对该数据的操作。ADT 的定义，不在具体实例的范畴内，也不指代实现中具体的数据类型、结构或算法。相反，ADTs 对数据类型的定义，仅仅是根据数据类型的操作，和这些操作必须遵循的公理来的。

## 常见数据类型示例

* 链表（List）
* 栈（Stack）
* 队列（Queue）
* 集合（Set）
* 映射（Map）
* 流（Stream）

ADT 可以代表对任何类型的数据的任何一组操作。换句话说，所有可能的 ADT 的穷举列表是无限的，其原因与所有可能的英语句子的穷举列表是无限的类似。ADT 是对未指定数据的一组操作的抽象概念，而不是对某特定组的具体数据的操作。一个常见的误解是，许多大学课程和数据结构教科书中讲述的 ADT 的具体示例就是 ADT。许多这样的课程和书籍将数据结构标记为“ADT”，然后跳过 ADT 并以具体的术语来描述数据结构，而从未使学生接触到数据类型的实际抽象表示。**这就糟了！**

ADT 可以表达许多有用的代数结构，包括半群，monoid，函子，单子等。[Fantasyland 规范](https://github.com/fantasyland/fantasy-land)就是一个很实用的目录，里面的代数结构均使用ADT描述，旨在鼓励 JavaScript 中的互操作实现。可以使用提供的公理来验证库构建器的实现。

## 为什么要使用 ADT？

抽象数据类型非常有用，因为它们为我们提供了一种以数学上合理且明确的方式来正式定义可重用模块的方法。这使我们可以共享一种通用语言，以引用大量有用的软件构建块词汇：学习和牢记这种理念，对我们畅游在不同领域、框架，甚至编程语言之间都会大有帮助。

## ADT 的发展历史

在 1960 年代和 1970 年代初，许多程序员和计算机科学研究人员对软件危机感兴趣。正如 Edsger Dijkstra 在他的图灵奖演讲中所说的那样：

> “软件危机的主要原因是机器变得功能强大了几个数量级！坦率地说：只要没有机器，编程就完全没有问题。当我们有几台不够强大的计算机时，编程是一个小问题，当我们有了非常强大的计算机时，编程也成为了一个同等非常严重的问题。”

他所指的问题是软件非常复杂。NASA 的阿波罗登月舱和制导系统的印刷版大约是文件柜的高度。如此大量的代码，想象一下试图阅读和理解其中的每一行代码的困难程度。

现代软件要复杂几个数量级。Facebook 在 2015 年大约有 [6200 万行代码](https://www.informationisbeautiful.net/visualizations/million-lines-of-code/)。如果每页打印 50 行，则将填满 124 万页。如果堆叠这些页面，则每英尺或 688 英尺可获得约 1800 页。这比撰写本文时所在的旧金山最高住宅大楼[千禧塔](https://en.wikipedia.org/wiki/Millennium_Tower_(San_Francisco))还要高。

管理软件复杂性是几乎每个软件开发人员都面临的主要挑战之一。在 1960 年代和 1970 年代，他们没有我们今天认为理所当然的程序语言、模式或工具。诸如 linters、intellisense 甚至静态分析工具之类的东西也尚未发明出来。

许多软件工程师指出，他们在大多数情况下构建硬件就可以正常工作。但是，软件通常是错综复杂且易出错的。软件通常是：

* 超预算
* 延期
* 漏洞
* 缺乏需求
* 维护困难

要是你构思模块化的软件，那你应该无需了解整个系统即可知道如何使系统的一部分正常工作。该软件设计原理被称为局部性。为了实现局部性，您需要可以独立于系统其余部分理解的模块。您应该能够清楚地描述**模块**，而无需过多说明其实现。这就是 ADT 解决的问题。

从 1960 年代一直延续到今天，提高软件模块化的状态是一个核心问题。考虑到这些问题，包括 Barbara Liskov（即面向对象五大设计原则 S.O.L.I.D 中的 L - "Liskov 替换原则" 中的Liskov本人），Alan Kay，Bertrand Meyer 和其他计算机科学传奇人物一起致力于描述和指定各种工具来实现软件的模块化。分别包括 ADT、面向对象程序设计和契约式设计。

ADT 源自 Liskov 和她的学生在 1974 年至 1975 年之间使用 [CLU 编程语言](https://en.wikipedia.org/wiki/CLU_(programming_language))所做的工作。它们极大地促进了软件模块规范的发展（这是我们用来描述允许软件模块进行接口交互的语言）。软件接口形式上可验证的一致性，使我们向软件模块化和互通性又迈出了一大步。

Liskov 于 2008 年因其在数据抽象，容错和分布式计算方面的工作而获得了图灵奖。ADT 在这一成就中发挥了重要作用，如今，几乎每所大学计算机科学课程中都包含了 ADT。

软件危机从未完全解决，任何专业开发人员都应该熟悉上述许多问题，但是学习如何使用诸如对象、模块和 ADT 之类的工具肯定会有所帮助。

## ADT 的技术规范

可以使用几个标准来判断 ADT 规范的适用性。我称这些标准为 **FAMED**，但我只是发明了助记符。原始标准由 Liskov 和 Zilles 在 1975 年著名的论文[《数据抽象的规范技术》](http://csg.csail.mit.edu/CSGArchives/memos/Memo-117.pdf)中发表。

* **正式。** 规范必须是正式的。规范中每个元素的含义必须定义得足够详细，以使目标受众有相当大的机会从规范中构建符合的实现。对于规范中的每个公理，必须有在代码中实现的代数证明。
* **通用。** ADT 应该广泛适用。ADT 通常应可用于许多不同的具体用例。在代码的特定部分中以特定语言描述特定的实现，这样的 ADT 可能过分具体了。相反，ADT 最适合描述公共数据结构、库组件、模块、编程语言功能等的行为。例如，用 ADT 描述堆栈的操作，或用 ADT 描述 promise 的表现。
* **最小化。** ADT 规范应最小化。规范应该包括行为中有趣且广泛适用的部分，仅此而已。每种行为都应准确无误地加以描述，但应尽可能少地具体描述。大多数 ADT 规范应使用少量公理来证明。
* **可扩展。** ADT 应该是可扩展的。需求的微小变化应该只会导致规范的微小变化。
* **声明式的。** 声明性规范描述的是是什么，而不是怎么做。ADT 应定义事物是什么，以及输入和输出之间的关系映射，而不是创建数据结构的步骤，或每个操作必须执行的具体步骤。

好的 ADT 应该具备以下几点：

* **通俗易懂的描述。** 如果 ADT 没有附带一些易于理解的描述，它们可能会非常简洁。自然语言描述与代数定义相结合，可以相互检查，以清除规范中的任何错误或读者对其理解的歧义。
* **定义。** 明确定义本规范中使用的任何术语，以避免产生歧义。
* **抽象特征。** 描述预期的输入和输出，而不将其链接到具体的类型或数据结构。
* **公理。** 公理不变量的代数定义常常证明了某实现已符合了规范要求。

## 堆栈 ADT 示例

堆栈是后进先出（LIFO）的项目，它允许用户通过将新项目推入堆栈顶部或从堆栈顶部弹出最近推送的项目来与堆栈进行交互。

堆栈通常用于解析、排序和数据整理算法中。

## 堆栈定义

* `a`：任意类型
* `b`：任意类型
* `item`：任意类型
* `stack()`：空堆栈
* `stack(a)`：含有一个元素 `a`
* `[item, stack]`：`item` 和 `stack` 成对出现

## 抽象签名

#### 构造函数

该栈操作接受任意数量的项目，并返回这些项目的堆栈。通常，构造函数的抽象签名是根据自身定义的。请不要将此与递归函数混淆。

* stack(...items) => stack(...items)

#### 堆栈操作（返回堆栈的操作）

* push(item, stack()) => stack(item)
* `pop(stack) => [item, stack]`

## 公理

堆栈公理主要处理堆栈和项目标识，堆栈项目的顺序以及堆栈为空时的弹出行为。

#### 特性

入栈和出栈操作没有副作用，如果做入栈操作并立即从同一堆栈进行出栈操作，则堆栈应处于入栈之前的状态。

```js
pop(push(a, stack())) = [a, stack()]
```

* 给定：推入 `a` 进堆栈并立即从堆栈中弹出。
* 结果：返回一对 `a` 和 `stack()`。

#### 顺序

从堆栈中弹出应该遵循以下顺序：后进先出（LIFO）。

```js
pop(push(b, push(a, stack()))) = [b, stack(a)]
```

* 给定：推入 `a` 进堆栈，然后推入 `b` 进堆栈，然后从堆栈弹出。
* 结果：返回一对 `b` 和 `stack()`。

#### 空栈

从空堆栈弹出会导致未定义的项目值。具体来说，可以用 Maybe（item），Nothing 或 Either 定义。在 JavaScript 中，习惯使用 `undefined`，从空堆栈弹出不会更改堆栈。

```js
pop(stack()) = [undefined, stack()]
```

* 给定：从空堆栈弹出。
* 结果：返回一对 undefined 和 `stack()`。

## 具体实现

抽象数据类型可以有许多具体的实现，可以使用不同的语言，库，框架等。这是上述堆栈 ADT 的一种实现，使用封装的对象以及该对象上的纯函数：

```js
const stack = (...items) => ({
  push: item => stack(...items, item),
  pop: () => {
    // 创建项目列表
    const newItems = [...items];

    // 从列表中移除最后一项
    // 把它赋给变量
    const [item] = newItems.splice(-1);

    // 成对返回
    return [item, stack(...newItems)];
  },
  // 可以在 assert 函数中比较堆栈
  toString: () => `stack(${ items.join(',') })`
});

const push = (item, stack) => stack.push(item);
const pop = stack => stack.pop();
```

另一个以纯函数的形式是在 JavaScript 现有数组类型上实现堆栈操作：

```js
const stack = (...elements) => [...elements];

const push = (a, stack) => stack.concat([a]);

const pop = stack => {
  const newStack = stack.slice(0);
  const item = newStack.pop();
  return [item, newStack];
};
```

两种版本均满足以下公理证明：

```js
// 一个简单的 assert 函数
// 将显示公理测试结果
// 若不满足公理，则会抛出描述性错误
const assert = ({given, should, actual, expected}) => {
  const stringify = value => Array.isArray(value) ?
    `[${ value.map(stringify).join(',') }]` :
    `${ value }`;

  const actualString = stringify(actual);
  const expectedString = stringify(expected);

  if (actualString === expectedString) {
    console.log(`OK:
      given: ${ given }
      should: ${ should }
      actual: ${ actualString }
      expected: ${ expectedString }
    `);
  } else {
    throw new Error(`NOT OK:
      given ${ given }
      should ${ should }
      actual: ${ actualString }
      expected: ${ expectedString }
    `);
  }
};

// 传递具体值给函数
const a = 'a';
const b = 'b';

// 证明
assert({
  given: 'push `a` to the stack and immediately pop from the stack',
  should: 'return a pair of `a` and `stack()`',
  actual: pop(push(a, stack())),
  expected: [a, stack()]
})

assert({
  given: 'push `a` to the stack, then push `b` to the stack, then pop from the stack',
  should: 'return a pair of `b` and `stack(a)`.',
  actual: pop(push(b, push(a, stack()))),
  expected: [b, stack(a)]
});

assert({
  given: 'pop from an empty stack',
  should: 'return a pair of undefined, stack()',
  actual: pop(stack()),
  expected: [undefined, stack()]
});
```

## 结论

* **抽象数据类型（ADT）** 是由公理定义的抽象概念，公理表示一些数据和对该数据的操作集合。
* **抽象数据类型专注于是什么而不是怎么做**（它们以声明性的方式定义，并且未指定算法或数据结构）。
* **常见示例**包括列表，堆栈，集合等。
* ADT 为我们提供了一种以数学上合理，准确和明确的方式正式定义可重用模块的方法。
* ADTs 是由 Liskov 和学生在 1970 年代使用 CLU 编程语言编写的。
* **ADT 应该是 FAMED 的。** 正式的，广泛适用的，最小的，可扩展的和声明性的。
* **ADT 应该包含** 人类可读的描述，定义，抽象签名以及可正式验证的公理。

> **温馨提示：** 如果不确定是否应该封装函数，请问自己是否要将其包含在组件的 ADT 中。请记住，ADT 应该是最小的，因此，如果它不是必需的，与其他操作缺乏凝聚力，或者其规范可能会改变，则对其进行封装。

## 词汇表

* **公理**在数学上是正确的陈述，必须成立。
* **从数学上讲，** 合理的含义是每个术语在数学上都有很好的定义，因此可以根据它们写出明确且可证明的事实陈述。

## 下一步

[EricElliottJS.com](https://ericelliottjs.com/) 提供了几小时的视频课程和有关此类主题的互动练习。如果您喜欢此内容，请考虑加入。

---

**埃里克·埃利奥特（Eric Elliott）** 是技术产品和平台顾问，是[“组合软件系列”](https://slack-redir.net/link?url=https%3A%2F%2Fleanpub.com%2Fcomposingsoftware)的作者，是 [EricElliottJS.com](https://slack-redir.net/link?url=http%3A%2F%2FEricElliottJS.com) 和 [DevAnywhere.io](https://slack-redir.net/link?url=http%3A%2F%2FDevAnywhere.io) 的共同创始人，也是开发团队的指导者。他为 **Adobe 系统，Zumba Fitness，《华尔街日报》，ESPN，BBC 和顶级录音艺术家（包括 Usher，Frank Ocean，Metallica 等）** 的软件开发做出了贡献。

**他与世界上最美丽的女人一起过着清静悠闲的隐居生活。**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
