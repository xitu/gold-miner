> * 原文地址：[The Hidden Treasures of Object Composition](https://medium.com/javascript-scene/the-hidden-treasures-of-object-composition-60cd89480381)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-hidden-treasures-of-object-composition.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-hidden-treasures-of-object-composition.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[IridescentMia](https://github.com/iridescentmia) [PCAaron](https://github.com/PCAaron)

# 对象组合中的宝藏

![](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

（译注：该图是用 PS 将烟雾处理成方块状后得到的效果，参见 [flickr](https://www.flickr.com/photos/68397968@N07/11432696204)。）

> 这是 “软件编写” 系列文章的第十三部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科
> [< 上一篇](https://juejin.im/post/5a2d363e6fb9a0450b6652c8) | [<< 返回第一篇](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md)

> “通过对象的组合装配或者组合对象来获得更复杂的行为” ~ Gang of Four，[《设计模式：可复用面向对象软件的基础》](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612//ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=eejs-20&linkId=06ccc4a53e0a9e5ebd65ffeed9755744)
>
> “优先考虑对象组合而不是类继承。” ~ Gang of Four，[《设计模式：可复用面向对象软件的基础》](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612//ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=eejs-20&linkId=06ccc4a53e0a9e5ebd65ffeed9755744)

软件开发中最常见的错误之一就是对于类继承的过度使用。类继承是一个代码复用机制，实例对象和基类构成了 **是一个（is-a）**关系。如果你想要使用 is-a 关系来构建应用程序，你将陷入麻烦，因为在面向对象设计中，类继承是最紧的耦合形式，这种耦合会引起下面这些常见问题：

* 脆弱的基类问题
* 猩猩/香蕉问题
* 不得已的重复问题

类继承是通过从基类中抽象出一个可供子类继承或者重载的公共接口来实现复用的。**抽象**有两个重要的方面：

* **泛化（Generalization）**：该过程提取了服务于普遍用例的共享属性和行为。
* **具化（Specialization）**：该过程提供了一个被特殊用例需要的实现细节。

目前，有许多方式去完成泛化和具化。注入简单函数、高阶函数、以及**对象组合**都能很好地代替类继承。

不幸的是，对象组合非常容易被曲解，许多开发者都难于用对象组合的方式来思考问题。现在，是时候更深层次地探索这一主题了。

### 什么是对象组合？

> “在计算机科学中，一个组合数据类型或是复合数据类型是任意的一个可以通过编程语言原始数据类型或者其他数据类型构造而成的数据类型。构成一个复合类型的操作又称为组合。” ~ Wikipedia

形成对象组合疑云的原因之一是，任何将原始数据类型组装到一个复合对象的过程都是对象组合的一个形式，但是继承技术却经常与对象组合作对比，即便它们是全然不同的两件事。这种二义性的产生是由于对象组合的语法（grammer）和语义（semantic）间存在着一个差别。

当我们谈论到对象组合 vs 类继承时，我们并非在谈论一个具体的技术：我们是在谈论组件对象（component objects）间的**语义关联**和**耦合程度**。我们谈论的是**意义**而非**语法**，人们通常一叶障目而不见泰山，无法区别二者，并陷入到语法细节中去。

GoF 建议道 “优先使用对象组合而不是类继承”，这启示了我们将对象看作是更小，耦合更松的对象的组合，而不是大量从一个统一的基类继承而来。GoF 将紧耦合对象描述为 “它们形成了一个统一的系统，你无法在对其他类不知情或者不更改的情况下修改或者删除某个类。这让系统结构变得紧密，从而难于认知、修改及维护。”

### 三种不同形式的对象组合

在《设计模式中》，GoF 声称：“你将一次又一次的在设计模式中看到对象组合”，并且描述了不同类型的组合关系，包括有聚合（aggregation）和委托（delegation）。

《设计模式》的作者最初是使用 C++ 和 Smalltalk（Java 的前身）进行工作的。相较于 JavaScript，它们在运行时构建和改变对象关系要更加复杂，所以，GoF 在叙述对象组合时没用牵涉任何的实现细节也是可以理解的。然而，在 JavaScript 中，脱离动态对象扩展（也称为 **连接（concatenation）**）去讨论对象组合是不可能的。

相较于《设计模式》中对象组合的定义，出于对 JavaScript 适用性以及构造一个更清晰的泛化的考虑，我们会**稍做**发散。例如，我们不会要求聚合需要**隐式**控制子类对象的生命期。对于动态对象扩展的语言来说，这并不正确。

如果选择了一个错误的公理，会让我们在得出有用泛化时受到不必要的限制，强制我们为具有相同大意的特殊用例起一个名字。软件开发者不喜欢重复做不需要的事儿。

* **聚合（Aggregation）**：一个对象是由一个可枚举的子对象集合构成。换言之，一个对象可以**包含**其他对象。每个子对象都保留了它自己的引用，因此它可以在信息不丢失的情况下直接从聚合对象中解构出来。
* **连接（Concatenation）**：一个对象通过向现有对象增加属性而构成。属性可以一个个连接或者是从现有对象中拷贝。例如，jQuery 插件通过连接新的方法到 jQuery 委托原型 —— `jQuery.fn` 上而构建。
* **委托（Delegation）**：一个对象直接指向或者**委托**到另一个对象。例如，[Ivan Sutherland 的画板](https://www.youtube.com/watch?v=BKM3CmRqK2o) 中的实例都含有 “master” 的引用，其被委托来共享属性。Photoshop 中的 “smart objects” 则作为了委托到外部资源的局部代理。JavaScript 的原型（prototype）也是代理：数组实例的方法指向了内置的数组原型 `Array.prototype` 上的方法，对象实例的方法则指向了 `Object.prototype` 上，等等。

需要注意的是这三种对象组合形式并不是彼此**互斥的**。我们能够使用聚合来实现委托，在 JavaScript 中，类继承也是通过委托实现的。许多软件系统用了不止一种组合，例如 jQuery 插件使用了连接来扩展 jQuery 委托原型 —— `jQuery.fn`。当客户端代码调用插件上的方法，请求将会被委托给连接到 `jQuery.fn` 上的方法。

> 后文的代码实例中的将会共享下面这段初始化代码：

```javascript
const objs = [
  { a: 'a', b: 'ab' },
  { b: 'b' },
  { c: 'c', b: 'cb' }
];
```

### 聚合

聚合表示一个对象是由一个可枚举的子对象集合构成。一个聚合对象就是包含了其他对象的对象。聚合中的每一个子对象都保留了各自的引用，因此能够轻易地从聚合中解构出来。聚合对象可以表现为不同类型的数据结构。

#### 例子

* 数组（Arrays）
* 映射（Maps）
* 集合（Sets）
* 图（Graphs）
* 树（Trees）
* DOM 节点 (一个 DOM 节点能包含子节点)
* UI 组件(一个组件能包含子组件)

#### 何时使用

当集合中的成员需要共享相同的操作时（集合中的某个元素需要和其他元素共享同样的接口），可以考虑使用聚合，例如可迭代对象（iterables）、栈、队列、树、图、状态机或者是它们的组合。

#### 注意事项

聚合适用于为集合元素应用一个统一抽象，例如为集合中的每个成员应用一个将标量转换为向量的函数（如：`array.map(fn)`）等等。但是，如果有成百上千或者成千上万甚至上百万个子对象，那么流式处理更加高效。

#### 代码示例

数组聚合：

```javascript
const collection = (a, e) => a.concat([e]);
const a = objs.reduce(collection, []);
console.log( 
  'collection aggregation',
  a,
  a[1].b,
  a[2].c,
  `enumerable keys: ${ Object.keys(a) }`
);
```

这将生成：

```
collection aggregation
[{"a":"a","b":"ab"},{"b":"b"},{"c":"c","b":"cb"}]
b 
c
enumerable keys: 0,1,2
```

使用 pairs 进行的链表聚合：

```javascript
const pair = (a, b) => [b, a];
const l = objs.reduceRight(pair, []);
console.log(
  'linked list aggregation',
  l,
  `enumerable keys: ${ Object.keys(l) }`
);
/*
linked list aggregation
[
  {"a":"a","b":"ab"}, [
    {"b":"b"}, [
      {"c":"c","b":"cb"},
      []
    ]
  ]
]
enumerable keys: 0,1
*/
```

链表构成了其他数据结构或者聚合的基础，例如数组、字符串以及各种形态的树。可能还有其他类型的聚合，但我们在此不会对它们都进行深度探究。

### 连接

连接表示一个对象通过向现有对象增加属性而构成。

#### 例子

* jQuery 插件通过连接被添加到 `jQuery.fn`
* 状态 reducer（例如：Redux）
* 函数式 mixin

#### 何时使用

只要装配数据对象的过程是在运行时，就考虑使用连接，例如，合并 JSON 对象、从多个源中合并应用状态、以及不可变状态的更新（通过将新的数据混合到前一步状态）等等。

#### 注意事项

* 谨慎地改变现有对象。共享的可变状态是滋生 bug 的温床。
* 可以使用连接来模拟类继承和 is-a 关系。这也会面临和类继承一样的问题。多考虑组合小的、独立的对象，而不是从一个 “基础” 实例上继承属性，亦或使用差分继承（differential inheritance，译注：参看 [MDN - Differential inheritance in JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Differential_inheritance_in_JavaScript)）
* 注意隐式的内在组件依赖。
* 连接时的顺序能够解决属性名冲突：后进有效（last-in wins）。这一点对于默认值和重载行为很有帮助，但如果顺序无关的话，也会造成问题。

```javascript
const c = objs.reduce(concatenate, {});
const concatenate = (a, o) => ({...a, ...o});
console.log(
  'concatenation',
  c,
  `enumerable keys: ${ Object.keys(c) }`
);
// concatenation { a: 'a', b: 'cb', c: 'c' } enumerable keys: a,b,c
```

### 委托

委托表示一个对象直接指向或者**委托**到另一个对象。

#### 例子

* JavaScript 内置类型使用了委托来让内置方法调用原型链上的方法。例如，数组实例的方法指向了内置的数组原型 `Array.prototype` 上的方法，对象实例则指向了 `Object.prototype`，等等。
* jQuery 插件依赖了委托去让所有 jQuery 实例共享内置方法和插件方法。
* Ivan Sutherland 画板的 “masters” 则是动态委托（委托在被创建后仍会被修改）。对于委托对象的修改将立刻影响到所有对象实例。
* Photoshop 使用了被叫做 “smart objects” 的委托来引用被定义在不同文件的图像和资源。更改 smart objects 引用的对象（译注：例如修改被引用的图像）将影响所有 smart object 的实例。

#### 何时使用

* 节约内存：当存在许多对象实例时，委托对于在各个实例间共享相同属性或者方法将会很有用，避免了更多的内存分配。
* 动态更新大量实例：当对象的许多实例共享同一个状态时，这个状态需要动态更新，且该状态的更改能立即作用到每个实例时，也需要委托。例如 Ivan Sutherland 画板的 “master” 和 Photoshop 的 “smart objects”。

#### 注意事项

* 委托通常用来模拟 JavaScript 中的类继承（当然，现在有了 extends 关键字），但这实际上很少需要。
* 委托可以被用来精确模拟类继承的行为和限制。实际上，通过原型委托链，JavaScript 构建了基于静态委托模型的类继承，从而避免了 **is-a** 的思考方式。
* 在使用诸如 `Object.keys(instanceObj)` 这样公共枚举机制时，委托属性是不可枚举的。
* 委托是通过牺牲了属性检索性能来获得内存上的节约的，一些 JavaScript 引擎的优化会关闭动态委托（在创建后仍会改变的委托）。然而，即便在最慢的场景下，属性检索性能仍能有百万级的 ops —— 除非你正构建一个服务于对象操作或者图形程序的工具函数库，例如 RxJS 或是 three.js，否则对象属性检索都不会成为你的性能瓶颈。
* 需要区分实例状态和委托状态。（译注：类似于区分实例对象的自由属性和原型链上的属性）
* 在动态委托上共享状态不是实例安全的。对状态的改变将会作用到所有实例，这是滋生 bug 的温床。
* ES6 的类并没有创建动态委托。动态委托可能会在 Babel 编译后的代码中正常工作，但无法在真正的 ES6 环境下工作。

### 代码示例

```javascript
const delegate = (a, b) => Object.assign(Object.create(a), b);

const d = objs.reduceRight(delegate, {});

console.log(
  'delegation',
  d,
  `enumerable keys: ${ Object.keys(d) }`
);

// delegation { a: 'a', b: 'ab' } enumerable keys: a,b

console.log(d.b, d.c); // ab c
```

### 结论

我们已经学到了：

* 所有由其他对象或者原始类型对象构成的对象都是**复合对象**。
* 创建复合对象的过程叫做**组合**。
* 存在不同形式的组合。
* 当我们组合对象时，对象间关系和依赖的不同取决于对象是如何被组合的。
* **is-a** 关系（由类继承所构成的关系）在面向对象设计中是最紧的耦合，实践中应当尽量避免。
* GoF 建议我们通过组装若干小的特性以形成一个更大的整体来进行对象组合，而不是从一个单一的基类或者基础对象继承。“优先考虑对象组合而不是类继承”。
* 聚合将对象组合到一个可枚举的集合中，该集合的每个成员都保留有各自的引用，例如数组、DOM 树等等。


* 委托通过将对象的委托链连接到一起来进行对象组合，委托链上的对象直接指向另一个对象，或者将属性检索委托到了另一个对象，例如 `[].map` 委托到了 `Array.prototype.map()`
* 连接通过用新的属性扩展现有对象来进行对象组合，例如 `Object.assign(destination, a, b)`、`{...a, ...b}`。
* 不同类型的对象组合不是彼此互斥的。委托是聚合的一个子集，连接则可用来构造委托和聚合等等。

目前不只存在三种类型的对象组合。也可以通过 相识（acquaintance）或联合（association）来构建对象间松散、动态的关系，在这种关系下，对象被作为参数传递给了另一个对象（依赖注入）等等。

所有的软件开发都是组合。能够通过轻松、灵活的方式来组合对象，也存在脆弱而不牢靠的方式来组合对象。一些对象组合的形式构成了对象间松耦合的关系，一些则构成了紧耦合。

竭力寻找一种变更小的程序需求时只需要变更小部分代码实现的组合方式。代码应当清楚且明练地描述你的意图，并且记住：在你需要类继承时，其实有更好的方式替代它。

## 需要 JavaScript 进阶训练吗？

DevAnyWhere 能帮助你最快进阶你的 JavaScript 能力，如组合式软件编写，函数式编程一节 React：

- 直播课程
- 灵活的课时
- 一对一辅导
- 构建真正的应用产品

[![https://devanywhere.io/](https://user-gold-cdn.xitu.io/2017/12/10/160409bd95f267df?w=800&h=450&f=png&s=366761)](https://devanywhere.io/)

**Eric Elliott** 是  [**“编写 JavaScript 应用”**](http://pjabook.com) （O’Reilly） 以及 [**“跟着 Eric Elliott 学 Javascript”**](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 **Adobe Systems**、**Zumba Fitness**、**The Wall Street Journal**、**ESPN** 和 **BBC** 等 , 也是很多机构的顶级艺术家，包括但不限于 **Usher**、**Frank Ocean** 以及 **Metallica**。

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。_

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
