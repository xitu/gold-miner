> * 原文地址：[Functors & Categories](https://medium.com/javascript-scene/functors-categories-61e031bac53f)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[avocadowang](https://github.com/avocadowang) [Aladdin-ADD](https://github.com/Aladdin-ADD)

# Functor 与 Category （软件编写）（第六部分）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg">

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0) （译注：该图是用 PS 将烟雾处理成方块状后得到的效果，参见 [flickr](https://www.flickr.com/photos/68397968@N07/11432696204)。））

> 注意：这是 “软件编写” 系列文章的第六部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科 [Composability](https://en.wikipedia.org/wiki/Composability)）。后续还有更多精彩内容，敬请期待！
> [<上一篇](https://github.com/xitu/gold-miner/blob/master/TODO/reduce-composing-software.md) | [<< 返回第一章](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md)

所谓 **functor（函子）**，是能够对其进行 map 操作的对象。换言之，**functor** 可以被认为是一个容器，该容器容纳了一个值，并且暴露了一个接口（译注：即 map 接口），该接口使得外界的函数能够获取容器中的值。所以当你见到 **functor**，别被其来自范畴学的名字唬住，简单把他当做个 *“mappable”* 对象就行。

**“functor”** 一词源于范畴学。在范畴学中，一个 functor 代表了两个范畴（category）间的映射。简单说来，一个 **范畴** 是一系列事物的分组，这里的 “事物” 可以指代一切的值。对于编码来说，一个 functor 通常代表了一个具有 `.map()` 方法的对象，该方法能够将某一集合映射到另一集合。

上文说到，一个 functor 可以被看做是一个容器，比如我们将其看做是一个盒子，盒子里面容纳了一些事物，或者空空如也，最重要的是，盒子暴露了一个 mapping（映射）接口。在 JavaScript 中，数组对象就是 functor 的绝佳例子（译注：`[1,2,3].map(x => x + 1)`），但是，其他类型的对象，只要能够被 map 操作，也可以算作是 functor，这些对象包括了单值对象（single valued-objects）、流（streams）、树（trees）、对象（objects）等等。

对于如数组和流等其他这样的集合（collections）来说，`.map()` 方法指的是，在集合上进行迭代操作，在此过程中，应用一个预先指定的函数对每次迭代到的值进行处理。但是，不是所有的 functor 都可以被迭代。

在 JavaScript 中，数组和 Promise 对象都是 **functor**（Promise 对象虽然没有 `.map()` 方法，但其 `.then()` 方法也遵从 functor 的定律），除此之外，非常多的第三方库也能够将各种各样的一般事物给转换成 functor（译注：大名鼎鼎的 [Bluebird](https://github.com/petkaantonov/bluebird/) 就能将异步过程封装为 Promise functor）。

在 Haskell 中，functor 类型被定义为如下形式：

```
fmap :: (a -> b) -> f a -> f b
```

fmap 接受一个函数参数，该函数接受一个参数 `a`，并返回一个 `b`，最终，fmap 完成了从 `f a` 到 `f b` 的映射。`f a` 及 `f b` 可以被读作 “一个 `a` 的 functor” 和“一个 `b` 的 functor”，亦即 `f a` 这个容器容纳了 `a`，`f b` 这个容器容纳了 `b`。

使用一个 functor 是非常简单的，仅需要调用 `map()` 方法即可：

```
const f = [1, 2, 3];
f.map(double); // [2, 4, 6]
```

### Functor 定律 ###

一个范畴含有两个基本的定律：

1. 同一性（Identity）
2. 组合性（Composition）

由于 functor 是两个范畴间的映射，其就必须遵守同一性和组合性，二者也构成了 functor 的基本定律。

### 同一性 ###

如果你将函数（`x => x`）传入 `f.map()`，对任意的一个 functor `f`，`f.map(x => x) == f`。

```
const f = [1, 2, 3];
f.map(x => x); // [1, 2, 3]
```

### 组合性 ###

functor 还必须具有组合性：`F.map(x => f(g(x))) == F.map(g).map(f)`

函数组合是将一个函数的输出作为另一个函数输入的过程。例如，给定一个值 `x`及函数 `f` 和函数 `g`，函数的组合就是 `(f ∘ g)(x)`（通常简写为 `f ∘ g`，简写形式已经暗示了 `(x)`），其意味着 `f(g(x))`。

很多函数式编程的术语都源于范畴学，而范畴学的实质即是组合。初看范畴学，就像初次进行高台跳水或者乘坐过山车，慌张，恐惧，但是并不难完成。你只需明确下面几个范畴学基础要点：

- 一个范畴（category）是一个容纳了一系列对象及对象间箭头（`->`）的集合。
- 箭头只是形式上的描述，实际上，箭头代表了态射（morphismms）。在编程中，态射可以被认为是函数。
- 对于任何被箭头相连接的对象，如 `a -> b -> c`，必须存在一个 `a -> c ` 的组合。
- 所有的箭头表示都代表了组合（即便这个对象间的组合只是一个同一（identity）箭头：`a->c`）。所有的对象都存在一个同一箭头，即存在同一态射（`a -> a`）。

如果你有一个函数 `g`，该函数接受一个参数 `a` 并且返回一个 `b`，另一个函数 `f` 接受一个 `b` 并返回一个 `c`。那么，必然存在一个函数 `h`，其代表了 `f` 及 `g` 的组合。而 `a -> c` 的组合，就是 `f ∘ g`（读作`f` **紧接着** `g`），进而，也就是 `h(x) = f(g(x))`。函数组合的方向是由右向左的，这也就是就是 `f ∘ g` 常被叫做 `f` **紧接着** `g` 的原因。

函数组合是满足结合律的，这就意味着你在组合多个函数时，免去了添加括号的烦恼：

```
h∘(g∘f) = (h∘g)∘f = h∘g∘f
```

让我们再看一眼 JavaScript 中组合律：

给定一个 functor，`F`：

```
const F = [1, 2, 3];
```

下面的两段是等效的：

```
F.map(x => f(g(x)));

// 等效于......

F.map(g).map(f);
```

> 译注：functor 中函数组合的结合率可以被理解为：对 functor 中保存的值使用组合后的函数进行 map，等效于先后对该值用不同的函数进行 map。

### Endofunctors（自函子） ###

一个 endofunctor（自函子）是一个能将一个范畴映射回相同范畴的 functor。

一个 functor 能够完成任意范畴间映射: `F a -> F b`

一个 endofunctor 能够完成相同范畴间的映射：`F a -> F a`

在这里，`F` 代表了一个 **functor 类型**，而 `a` 代表了一个范畴变量（意味着其能够代表任意的范畴，无论是一个集合，还是一个包含了某一数据类型所有可能取值的范畴）。

而一个 monad 则是一个 endofunctor，先记住下面这句话：

> “monad 是 endofunctor 范畴的 monoids（幺半群），有什么问题？”（译注：这句话的出处在该系列第一篇已有提及）

现在，我们希望第一篇提及的这句话能在之后多一点意义，monoids（幺半群）及 monad 将在之后作介绍。

### 自定义一个 Functor ###

下面将展示一个简单的 functor 例子：

```
const Identity = value => ({
  map: fn => Identity(fn(value))
});
```

显然，其满足了 functor 定律：

```
// trace() 是一个简单的工具函数来帮助审查内容
// 内容
const trace = x => {
  console.log(x);
  return x;
};

const u = Identity(2);

// 同一性
u.map(trace);             // 2
u.map(x => x).map(trace); // 2

const f = n => n + 1;
const g = n => n * 2;

// 组合性
const r1 = u.map(x => f(g(x)));
const r2 = u.map(g).map(f);

r1.map(trace); // 5
r2.map(trace); // 5
```

现在，你可以对存在该 functor 中的任何数据类型进行 map 操作，就像你对一个数组进行 map 时那样。这简直太美妙了。

上面的代码片展示了 JavaScript 中 functor 的简单实现，但是其缺失了 JavaScript 中常见数据类型的一些特性。现在我们逐个添加它们。首先，我们会想到，假如能够直接通过 + 操作符操作我们的 functor 是不是很好，就像我们在数值或者字符串对象间使用 `+` 号那样。

为了使该想法变现，我们首先要为该 functor 对象添加 `.valueOf()` 方法  —— 这可被看作是提供了一个便捷的渠道来将值从 functor 盒子中取出。

```
const Identity = value => ({
  map: fn => Identity(fn(value)),

  valueOf: () => value,
});

const ints = (Identity(2) + Identity(4));
trace(ints); // 6

const hi = (Identity('h') + Identity('i'));
trace(hi); // "hi"
```

现在代码更漂亮了。但是如果我们还想要在控制台审查 `Identity` 实例呢？如果控制台能够输出 `"Identity(value)"` 就太好了，为此，我们只需要添加一个 `.toString()` 方法即可（译注：亦即重载原型链上原有的 `.toString()` 方法）：

```
toString: () => `Identity(${value})`,
```

代码又有所进步。现在，我们可能也想 functor 能够满足标准的 JavaScript 迭代协议（译注：[MDN - 迭代协议](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Iteration_protocols)）。为此，我们可以为 `Identity` 添加一个自定义的迭代器：

```
  [Symbol.iterator]: () => {
    let first = true;
    return ({
      next: () => {
        if (first) {
          first = false;
          return ({
            done: false,
            value
          });
        }
        return ({
          done: true
        });
      }
    });
  },
```

现在，我们的 functor 还能这样工作:

```
// [Symbol.iterator] enables standard JS iterations:
const arr = [6, 7, ...Identity(8)];
trace(arr); // [6, 7, 8]
```

假如你想借助 `Identity(n)` 来返回包含了 `n+1`，`n+2` 等等的 Identity 数组，这非常容易：

```
const fRange = (
  start,
  end
) => Array.from(
  {length: end - start + 1},
  (x, i) => Identity(i + start)
);
```

> 译注：[MDN -- Array.from()](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array/from)

但是，如果你想上面的操作方式能够应用于任何 functor，该怎么办？假如我们规定了每种数据类型对应的实例必须有一个关于其构造函数的引用，那么你可以这样改造之前的逻辑：

```
const fRange = (
  start,
  end
) => Array.from(
  {length: end - start + 1},

  // 将 `Identity` 变更为 `start.constructor`
  (x, i) => start.constructor(i + start)
);

const range = fRange(Identity(2), 4);
range.map(x => x.map(trace)); // 2, 3, 4
```

假如你还想知道一个值是否在一个 functor 中，又怎么办？我们可以为 `Identity` 添加一个静态方法 `.is()` 来进行检测，另外，我们也顺便添加了一个静态的 `.toString()` 方法来告知这个 functor 的种类：

```
Object.assign(Identity, {
  toString: () => 'Identity',
  is: x => typeof x.map === 'function'
});
```


现在，我们整合一下上面的代码片:

```
const Identity = value => ({
  map: fn => Identity(fn(value)),

  valueOf: () => value,

  toString: () => `Identity(${value})`,

  [Symbol.iterator]: () => {
    let first = true;
    return ({
      next: () => {
        if (first) {
          first = false;
          return ({
            done: false,
            value
          });
        }
        return ({
          done: true
        });
      }
    });
  },

  constructor: Identity
});

Object.assign(Identity, {
  toString: () => 'Identity',
  is: x => typeof x.map === 'function'
});
```

注意，无论是 functor，还是 endofunctor，不一定需要上述那么多的条条框框。以上工作只是为了我们在使用 functor 时更加便捷，而非必须。一个 functor 的所有需求只是一个满足了 functor 定律 `.map()` 接口。

### 为什么要使用 functor? ###

说 functor 多么多么好不是没有理由的。最重要的一点是，functor 作为一种抽象，能让开发者以同一种方式实现大量有用的，能够操纵任何数据类型的事物。例如，如果你想要在 functor 中值不为 `null` 或者不为 `undefined` 前提下，构建一串地链式操作：

```
// 创建一个 predicte
const exists = x => (x.valueOf() !== undefined && x.valueOf() !== null);

const ifExists = x => ({
  map: fn => exists(x) ? x.map(fn) : x
});

const add1 = n => n + 1;
const double = n => n * 2;

// undefined
ifExists(Identity(undefined)).map(trace);
// null
ifExists(Identity(null)).map(trace);

// 42
ifExists(Identity(20))
  .map(add1)
  .map(double)
  .map(trace)
;
```

函数式编程一直探讨的是将各个小的函数进行组合，以创建出更高层次的抽象。假如你想要一个更通用的，能够工作在任何 functor 上的 `map()` 方法，那么你可以通过参数的部分应用（译注：即 [偏函数](https://en.wikipedia.org/wiki/Partial_application)）来完成。

你可以使用自己喜欢的 curry 化方法（译注：Underscore，Lodash，Ramda 等第三方库都提供了 curry 化一个函数的方法），或者使用下面这个之前篇章提到的，基于 ES6 的，充满魅力的 curry 化方法来实现参数的部分应用：

```
const curry = (
  f, arr = []
) => (...args) => (
  a => a.length === f.length ?
    f(...a) :
    curry(f, a)
)([...arr, ...args]);
```

现在，我们可以自定义 `map()` 方法:

```
const map = curry((fn, F) => F.map(fn));

const double = n => n * 2;

const mdouble = map(double);
mdouble(Identity(4)).map(trace); // 8
```

### 总结 ###

functor 是能够对其进行 map 操作的对象。更进一步地，一个 functor 能够将一个范畴映射到另一个范畴。一个 functor 甚至可以将某一范畴映射回相同范畴（例如 endofunctor）。

一个范畴是一个容纳了对象和对象间箭头的集合。箭头代表了态射（也可理解为函数或者组合）。一个范畴中的每个对象都具有一个同一态射（`x -> x`）。对于任何链接起来的对象 `A -> B -> C`，必存在一个 `A -> C` 的组合。

总之，functor 是一个极佳的高阶抽象，能然你创建各种各样的通用函数来操作任何的数据类型。

**未完待续……**

### 接下来 ###

想学习更多 JavaScript 函数式编程吗？

[跟着 Eric Elliott 学 Javacript](http://ericelliottjs.com/product/lifetime-access-pass/)，机不可失时不再来！

[<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg">](https://ericelliottjs.com/product/lifetime-access-pass/)

**Eric Elliott** 是  [**“编写 JavaScript 应用”**](http://pjabook.com) （O’Reilly） 以及 [**“跟着 Eric Elliott 学 Javascript”**](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 **Adobe Systems**、**Zumba Fitness**、**The Wall Street Journal**、**ESPN** 和 **BBC** 等 , 也是很多机构的顶级艺术家，包括但不限于 **Usher**、**Frank Ocean** 以及 **Metallica**。

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
