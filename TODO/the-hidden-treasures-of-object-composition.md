> * 原文地址：[The Hidden Treasures of Object Composition](https://medium.com/javascript-scene/the-hidden-treasures-of-object-composition-60cd89480381)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/the-hidden-treasures-of-object-composition.md](https://github.com/xitu/gold-miner/blob/master/TODO/the-hidden-treasures-of-object-composition.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：

# 对象组合中的宝藏

![](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

（译注：该图是用 PS 将烟雾处理成方块状后得到的效果，参见 [flickr](https://www.flickr.com/photos/68397968@N07/11432696204)。）

> 这是 “软件编写” 系列文章的第十一部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科
> [< 上一篇](https://juejin.im/post/5a2d363e6fb9a0450b6652c8) | [<< 返回第一篇](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md)

> “通过对象的组合装配或者组合对象来获得更复杂的行为” ~ Gang of Four，[《设计模式：可复用面向对象软件的基础》](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612//ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=eejs-20&linkId=06ccc4a53e0a9e5ebd65ffeed9755744)
>
> “优先考虑对象组合而不是类继承。” ~ Gang of Four，[《设计模式：可复用面向对象软件的基础》](https://www.amazon.com/Design-Patterns-Elements-Reusable-Object-Oriented/dp/0201633612//ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=eejs-20&linkId=06ccc4a53e0a9e5ebd65ffeed9755744)

软件开发中最常见的错误之一就是对于类继承的过度使用。类继承是一个代码复用机制，实例对象和基类构成了 **是一个（is-a）**关系。如果你想要使用 is-a 关系来构建应用程序，你将陷入麻烦，因为在面向对象设计中，类继承是最紧的耦合形式，这种耦合会引起下面这些常见问题：

* 脆弱的基类问题
* 猩猩/香蕉问题
* 不得已的重复问题

类继承是通过从基类中抽象出一个可供子类继承或者重载的公共接口来实现复用的。**抽象**有两个重要的方面：

* **泛化（Generalization）**：该过程提取了服务于一般用例的共享属性和行为。
* **具化（Specialization）**：该过程提供了一个被特殊用例需要的实现细节。

目前，在代码中有许多能够完成泛化和具化的方式。注入简单函数、高阶函数、以及**对象组合**都能很好地代替类继承。

不幸的是，对象组合非常容易被曲解，许多开发者都难于用对象组合的方式来思考。现在是时候更深层次地探索这一主题了。

### 什么是对象组合？

> “在计算机科学中，一个组合数据类型或是复合数据类型是任意的一个可以通过编程语言原始数据类型或者其他数据类型构造而成的数据类型。构成一个复合类型的操作又称为组合。” ~ Wikipedia

造成对象组合疑云的原因之一就是，任何将原始数据类型组装到一个复合对象的过程都是是对象组合的一个形式，但是继承技术却经常与对象组合作对比，即便它们是全然不同的两件事。这种二义性的产生是由于对象组合的语法（grammer）和语义（semantic）间存在着一个差别。

当我们谈论到对象组合 vs 类继承时，我们并非在谈论一个具体的技术：我们是在谈论组件对象（component objects）间的**语义关联**和**耦合程度**。我们谈论的是**意义**而非**语法**，人们通常一叶障目而不见泰山，无法区别二者，并陷入到语法细节中去。

GoF 建议道 “优先使用对象组合而不是类继承”，这启示了我们将对象看作是更小，耦合更松的对象的组合，而不是大量从一个统一的基类继承而来。GoF 将紧耦合对象描述为 “它们形成了一个统一的系统，你无法在对其他类不知情或者不更改的情况下修改或者删除某个类。该系统结构变得紧密，从而难于认知、修改及维护。”

### 三种不同形式的对象组合

在《设计模式中》，GoF 声称：“你讲一次又一次的在设计模式中看到对象组合”，并且描述了不同类型的组合关系，包括有聚合（aggregation）和委托（delegation）。

《设计模式》的作者最初是使用 C++ 和 Smalltalk（Java 的前身）进行工作的。相较于 JavaScript，他们在运行时构建和改变对象关系要更加复杂，所以，GoF 在叙述对象组合时没用牵涉任何的实现细节也是可以理解的。然而，在 JavaScript 中，脱离动态对象扩展（也称为 **连接（concatenation）**）去讨论对象组合是不可能的。

相较于《设计模式》中对于对象组合的定义，出于对 JavaScript 适用性以及构造一个更清晰的泛化的考虑，我们会**稍有**发散。例如，我们不会要求聚合需要**隐式**控制子类对象的生命期。对于动态对象扩展的语言来说，这并不正确。

选择一个错误的公理会将会让我们在得出有用泛化是受到不必要的限制，强制我们去对相同泛化思路的特殊用例起一个名字。软件开发者不喜欢重复做不需要的事儿。

* **聚合（Aggregation）**：一个对象是由一个可枚举的子对象集合构成。换言之，一个对象可以**包含**其他对象。每个子对象都保留了它自己的引用，因此它可以在信息不丢失的情况下直接从聚合对象中解构出来。
* **连接（Concatenation）**：一个对象通过向现有对象增加属性而构成。属性可以一个个连接或者是从现有对象中拷贝。例如，jQuery 插件通过连接新的方法到 jQuery 委托原型 —— `jQuery.fn` 上而构建。
* **委托（Delegation）**：一个对象直接指向或者**委托**到另一个对象。例如，[Ivan Sutherland 的画板](https://www.youtube.com/watch?v=BKM3CmRqK2o) 中的实例都含有 “master” 的引用，其被委托来共享属性。Photoshop 中的 “smart objects” z额作为了委托到外部资源的局部代理。JavaScript 的原型（prototype）也是代理：数组实例的方法指向了内置的数组原型 `Array.prototype` 上的方法，对象实例则指向了 `Object.prototype`，等等。

需要注意的是这三种对象组合形式并不是彼此**互斥的**。我们能够使用聚合来实现委托，在 JavaScript 中，类继承也是通过委托实现的。许多软件系统用了不止一种组合，例如 jQuery 插件使用了连接来扩展 jQuery 委托原型 —— `jQuery.fn`。当客户端代码调用插件上的方法，请求将会被委托给连接到 `jQuery.fn` 上的方法。

> 后文的代码实例中的将会共享下面这段初始化代码：

```javascript
const objs = [
  { a: 'a', b: 'ab' },
  { b: 'b' },
  { c: 'c', b: 'cb' }
];
```

### Aggregation

Aggregation is when an object is formed from an enumerable collection of subobjects. An aggregate is an object which _contains_ other objects. Each subobject in an aggregation retains its own reference identity, and could be losslessly destructured from the aggregate. Aggregates can be represented in a wide variety of structures.

#### Examples

* Arrays
* Maps
* Sets
* Graphs
* Trees
* DOM nodes (a DOM node may _contain_ child nodes)
* UI components (a component may _contain_ child components)

#### When to use

Whenever there are collections of objects which need to share common operations, such as iterables, stacks, queues, trees, graphs, state machines, or the composite pattern (when you want a single item to share the same interface as many items).

#### Considerations

Aggregations are great for applying universal abstractions, such as applying a function to each member of an aggregate (e.g., `array.map(fn)`), transforming vectors as if they're single values, and so on. If there are potentially hundreds of thousands or millions of subobjects, however, stream processing may be more efficient.

#### Code examples

Array aggregation:

```
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

This will produce:

```
collection aggregation[{"a":"a","b":"ab"},{"b":"b"},{"c":"c","b":"cb"}]b cenumerable keys: 0,1,2
```

Linked list aggregation using pairs:

```
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

Linked lists form the basis of lots of other data structures and aggregations, such as arrays, strings, and various kinds of trees. There are many other possible kinds of aggregation. We won’t cover them all in-depth here.

### Concatenation

Concatenation is when an object is formed by adding new properties to an existing object.

#### Examples

* Plugins are added to `jQuery.fn` via concatenation
* State reducers (e.g., Redux)
* Functional mixins

When to use: Any time it would be useful to progressively assemble data structures at runtime, e.g., merging JSON objects, hydrating application state from multiple sources, creating updates to immutable state (by merging previous state with new data), etc…

#### Considerations

* Be careful mutating existing objects. Shared mutable state is a recipe for many bugs.
* It’s possible to mimic class hierarchies and is-a relations with concatenation. The same problems apply. Think in terms of composing small, independent objects rather than inheriting props from a “base” instance and applying differential inheritance.
* Beware of implicit inter-component dependencies.
* Property name collisions are resolved by concatenation order: last-in wins. This is useful for defaults/overrides behavior, but can be problematic if the order shouldn’t matter.

```
const c = objs.reduce(concatenate, {});
const concatenate = (a, o) => ({...a, ...o});
console.log(
  'concatenation',
  c,
  `enumerable keys: ${ Object.keys(c) }`
);
// concatenation { a: 'a', b: 'cb', c: 'c' } enumerable keys: a,b,c
```

### Delegation

Delegation is when an object forwards or _delegates to_ another object.

#### Examples

* JavaScript’s built-in types use delegation to forward built-in method calls up the prototype chain. e.g., `[].map()` delegates to `Array.prototype.map()`, `obj.hasOwnProperty()` delegates to `Object.prototype.hasOwnProperty()` and so on.
* jQuery plugins rely on delegation to share built-in and plugin methods among all jQuery object instances.
* Sketchpad’s “masters” were dynamic delegates. Modifications to the delegate would be reflected instantly in all of the object instances.
* Photoshop uses delegates called “smart objects” to refer to images and resources defined in separate files. Changes to the object that smart objects refer to are reflected in all instances of the smart object.

#### When to use

1. Conserve memory: Any time there may be potentially many instances of an object and it would be useful to share identical properties or methods among each instance which would otherwise require allocating more memory.
2. Dynamically update many instances: Any time many instances of an object need to share identical state which may need to be updated dynamically and changes instantaneously reflected in every instance, e.g., Sketchpad’s “masters” or Photoshop’s “smart objects”.

#### Considerations

* Delegation is commonly used to imitate class inheritance in JavaScript (wired up by the `extends` keyword), but is very rarely actually needed.
* Delegation can be used to exactly mimic the behavior and limitations of class inheritance. In fact, class inheritance in JavaScript is built on top of static delegates via the prototype delegation chain. Avoid _is-a_ thinking.
* Delegate props are non-enumerable using common mechanisms such as `Object.keys(instanceObj)`.
* Delegation saves memory at the cost of property lookup performance, and some JS engine optimizations get turned off for dynamic delegates (delegates that change after they’ve been created). However, even in the slowest case, property lookup performance is measured in millions of ops per second — chances are good that this is not your bottleneck unless you’re building a utility library for object operations or graphics programming, e.g., RxJS or three.js.
* Need to differentiate between instance state, and delegate state.
* Shared state on dynamic delegates is not instance safe. Changes are shared between all instances. Shared state on dynamic delegates is commonly (but not always) a bug.
* ES6 classes don’t create dynamic delegates in ES6\. They may seem to work in Babel, but will fail hard in real ES6 environments.

### Code example

```
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

### Conclusion

We have learned:

* All objects made from other objects and language primitives are _composite objects_.
* The act of creating a composite object is known as _composition_.
* There are different kinds of object composition.
* The relationships and dependencies we form when we compose objects differ depending on how objects are composed.
* _Is-a relations_ (the kind formed by class inheritance) are the tightest form of coupling in OO design, and should generally be avoided when its practical.
* The Gang of Four admonishes us to compose objects by assembling smaller features to form a larger whole, rather than inheriting from a monolithic base class or base object. “Favor object composition over class inheritance.”
* Aggregation composes objects into enumerable collections where each member of the collection retains its own identity, e.g., arrays, DOM tree, etc…
* Delegation composes objects by linking together an object delegation chain where an object forwards or delegates property lookups to another object. e.g., `[].map()` delegates to `Array.prototype.map()`
* Concatenation composes objects by extending an existing object with new properties, e.g., `Object.assign(destination, a, b)`, `{...a, ...b}`.
* The definitions of different kinds of object composition are not mutually exclusive. Delegation is a subset of aggregation, concatenation can be used to form delegates and aggregates, and so on…

These are not the only three kinds of object composition. It’s also possible to form loose, dynamic relationships between objects through acquaintance/association relationships where objects are passed as parameters to other objects (dependency injection), and so on.

All software development is composition. There are easy, flexible ways to compose objects, and brittle, arthritic ways. Some forms of object composition form loosely coupled relations between objects, and others form very tight coupling.

Look for ways to compose where a small change to program requirements would require only a small change to the code implementation. Express your intention clearly and concisely, and remember: If you think you need class inheritance, chances are very good that there’s a better way to do it.

### Need advanced JavaScript training for your team?

DevAnywhere is the fastest way to level up to advanced JavaScript skills with composable software, functional programming and React:

* 1:1 mentorship
* Live group lessons
* Flexible hours
* Build a mentorship culture on your team

![](https://cdn-images-1.medium.com/max/800/1*pskrI-ZjRX_Y0I0zZqVTcQ.png)

[https://devanywhere.io/](https://devanywhere.io/)

**_Eric Elliott_** _is the author of_ [_“Programming JavaScript Applications”_](http://pjabook.com) _(O’Reilly), and cofounder of_ [_DevAnywhere.io_](https://devanywhere.io/)_. He has contributed to software experiences for_ **_Adobe Systems_**_,_ **_Zumba Fitness_**_,_ **_The Wall Street Journal_**_,_ **_ESPN_**_,_ **_BBC_**_, and top recording artists including_ **_Usher_**_,_ **_Frank Ocean_**_,_ **_Metallica_**_, and many more._

_He works anywhere he wants with the most beautiful woman in the world._

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
