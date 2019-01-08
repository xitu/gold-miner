> * 原文地址：[Lenses: Composable Getters and Setters for Functional Programming](https://medium.com/javascript-scene/lenses-b85976cb0534)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lenses-composable-getters-and-setterssfor-functional-programming.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lenses-composable-getters-and-setterssfor-functional-programming.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：

# Lenses：可组合函数式编程的 Getter 和 Setter

![](https://cdn-images-1.medium.com/max/2000/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

烟雾艺术立方 -- MattysFlicks --（CC BY 2.0）

> **注意：**本篇是[**“Composing Software” 这本书**](https://leanpub.com/composingsoftware)的一部分，它将以系列博客的形式展开新生。它涵盖了 JavaScript（ES6+）函数式编程和可组合软件技术的最基础的知识。
> [_< 前情回顾_](https://github.com/xitu/gold-miner/blob/master/TODO1/transducers-efficient-data-processing-pipelines-in-javascript.md) _|_ [_<< 从第一部分开始_](https://juejin.im/post/5c0dd214518825444758453a)

lens 是一对可组合的 getter 和 setter 纯函数，它会关注对象内部的一个特殊字段，并且会遵从一系列名为 lens 法则的公理。将对象视为**整体**，字段视为**局部**。getter 以对象整体作为参数，然后返回 lens 所关注的对象的一部分。

```
// view = whole => part
```

setter 则以对象整体作为参数，以及一个需要设置的值，然后返回一个新的对象整体，这个对象的特定部分已经更新。和一个简单设置对象成员字段的值的函数不同，Lens 的 setter 是纯函数：

```
// set = whole => part => whole
```

> **注意：**在本篇中，我们将在代码示例中使用一些原生的 lenses，这样是为了对总体概念有更深入的了解。而对于生产环境下的代码，你则应该看看像 Ramda 这样的经过充分测试的库。不同的 lens 库的 API 也不同，比起本篇给出的例子，更有可能用可组合性更强、更优雅的方法来描述 lenses。

假设你有一个元组数组（tuple array），代表了一个包含 `x`，`y` 和 `z`三点的坐标：

```
[x, y, z]
```

为了能分别获取或者设置每个字段，你可以创建三个 lenses。每个轴一个。你可以手动创建关注每个字段的 getter：

```
const getX = ([x]) => x;
const getY = ([x, y]) => y;
const getZ = ([x, y, z]) => z;

console.log(
  getZ([10, 10, 100]) // 100
);
```

同样，相应的 setter 也许会像这样：

```
const setY = ([x, _, z]) => y => ([x, y, z]);

console.log(
  setY([10, 10, 10])(999) // [10, 999, 10]
);
```

### 为什么选择 Lenses？

状态依赖是软件中耦合性的常见来源。很多组件会依赖于共享状态的结构，所以如果你需要改变状态的结构，你就必须修改很多处的逻辑。

Lenses 让你能够把状态的结构抽象，让它隐藏在 getters 和 setter 之后。为代码引入 lens，而不是丢弃你的那些涉及深入到特定对象结构的代码库的代码。如果后续你需要修改状态结构，你可以使用 lens 来做，并且不需要修改任何依赖于 lens 的代码。

这遵循了需求的小变化将只需要系统的小变化的原则。

### 背景

在 1985 年，[“Structure and Interpretation of Computer Programs”](https://www.amazon.com/Structure-Interpretation-Computer-Programs-Engineering/dp/0262510871/ref=as_li_ss_tl?ie=UTF8&linkCode=ll1&tag=eejs-20&linkId=9fac31d60f8b9b60f63f71ab716694bc) 描述了用于分离对象结构与使用对象的代码的方法的 getter 和 setter 对（下文中称为 `put` 和 `get`）。文章描述了如何创建通用的选择器，它们访问复杂变量，但却不依赖变量的表示方式。这种分离特性非常有用，因为它打破了对状态结构的依赖。这些 getter 和 setter 对有点像这几十年来一直存在于关系数据库中的引用查询。

Lenses 把 getter 和 setter 对做得更加通用，更有可组合性，从而更加延伸了这个概念。在 Edward Kmett 发布了为 Haskell 写的 Lens 库后，它们更加普及。他是受到了推论出了遍历表达了迭代模式的 Jeremy Gibbons 和 Bruno C. d. S. Oliveira，Luke Palmer 的 “accessors”，Twan van Laarhoven 以及 Russell O’Connor 的影响。

> **注意：**一个很容易犯的错误是，将函数式 lens 的现代观念和 Anamorphisms 等同，Anamorphisms 基于 Erik Meijer，Maarten Fokkinga 和 Ross Paterson 1991 年发表的 [“使用 Bananas，Lenses，Envelopes 和 Barbed Wire 的函数式编程”](http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.41.125)。“函数意义上的术语 ‘lens’ 指的是它看起来是整体的一部分。在递归结构意义上的术语 ‘lens’ 指的是 `[(` and `)]`，它在语法上看起来有些像凹透镜。**太长，请不用读**。它们之间并没有任何关系。” ~ [Edward Kmett on Stack Overflow](https://stackoverflow.com/questions/17198072/how-is-anamorphism-related-to-lens)

### Lens 法则

lens 法则其实是代数公理，它们确保 lens 能良好运行。

1.  `view(lens, set(lens, a, store)) ≡ a` -- 如果你将一组值设置到一个 store 里，并且马上通过 lens 看到了值，你将能获取到这个被设置的值。
2.  `set(lens, b, set(lens, a, store)) ≡ set(lens, b, store)` -- 如果你为 `a` 设置了一个 lens 值，然后马上为 `b` 设置 lens 值，那么和你只设置了 `b` 的值的结果是一样的。
3.  `set(lens, view(lens, store), store) ≡ store` -- 如果你从 store 中获取 lens 值，然后马上将这个值再设置回 store 里，这个值就等于没有修改过。

在我们深入代码示例之前，记住，如果你在生产环境中使用 lenses，你应该使用经过充分测试的 lens 库。在 JavaScript 语言中，我知道的最好的是 Ramda。目前，为了更好的学习，我们先跳过这部分，自己写一些原生的 lenses。

```
// 纯函数 view 和 set，它们可以配合任何 lens 一起使用：
const view = (lens, store) => lens.view(store);
const set = (lens, value, store) => lens.set(value, store);

// 一个将 prop 作为参数，返回 naive 的函数
// 通过 lens 存取这个 prop。
const lensProp = prop => ({
  view: store => store[prop],
  // 这部分代码是原生的，它只能为对象服务
  set: (value, store) => ({
    ...store,
    [prop]: value
  })
});

// 一个 store 对象的例子。一个可以使用 lens 访问的对象
// 通常被称为 “store” 对象
const fooStore = {
  a: 'foo',
  b: 'bar'
};

const aLens = lensProp('a');
const bLens = lensProp('b');

// 使用`view()` 方法来解构 lens 中的属性 `a` 和 `b`。
const a = view(aLens, fooStore);
const b = view(bLens, fooStore);
console.log(a, b); // 'foo' 'bar'

// 使用 `aLens` 来设置 store 中的值：
const bazStore = set(aLens, 'baz', fooStore);

// 查看新设置的值。
console.log( view(aLens, bazStore) ); // 'baz'
```

我们来证实下这些函数的 lens 法则：

```
const store = fooStore;

{
  // `view(lens, set(lens, value, store))` = `value`
  // 如果你把某个值存入 store，
  // 然后马上通过 lens 查看这个值，
  // 你将会获取那个你刚刚存入的值
  const lens = lensProp('a');
  const value = 'baz';

  const a = value;
  const b = view(lens, set(lens, value, store));

  console.log(a, b); // 'baz' 'baz'
}

{
  // set(lens, b, set(lens, a, store)) = set(lens, b, store)
  // 如果你将一个 lens 值存入了 `a` 然后马上又存入 `b`，
  // 那么和你直接存入 `b` 是一样的
  const lens = lensProp('a');

  const a = 'bar';
  const b = 'baz';

  const r1 = set(lens, b, set(lens, a, store));
  const r2 = set(lens, b, store);
  
  console.log(r1, r2); // {a: "baz", b: "bar"} {a: "baz", b: "bar"}
}

{
  // `set(lens, view(lens, store), store)` = `store`
  // 如果你从 store 中获取到一个 lens 值，然后马上把这个值
  // 存回到 store，那么这个值不变
  const lens = lensProp('a');

  const r1 = set(lens, view(lens, store), store);
  const r2 = store;
  
  console.log(r1, r2); // {a: "foo", b: "bar"} {a: "foo", b: "bar"}
}
```

### 编写 Lenses

Lenses 是可组合的。当你组合 lenses 的时候，得到的结果将会深入对象的字段，穿过所有对象中字段可能的组合路径。我们将从 Ramda 引入功能全面的 `lensProp` 来做说明：

```
import { compose, lensProp, view } from 'ramda';

const lensProps = [
  'foo',
  'bar',
  1
];

const lenses = lensProps.map(lensProp);
const truth = compose(...lenses);

const obj = {
  foo: {
    bar: [false, true]
  }
};

console.log(
  view(truth, obj)
);
```

棒极了，但是其实还有很多使用 lenses 的组合值得我们注意。让我们继续深入。

### Over

在任何仿函数数据类型的情况下，应用源自 `a => b` 的函数都是可能的。我们已经论述了，这个仿函数映射是**可组合的。**类似的，我们可以在 lens 中对关注的值应用某个函数。通常情况下，这个值是同类型的，也是一个源于 `a => a` 的函数。lens 映射的这个操作在 JavaScript 库中一般被称为 “over”。我们可以像这样创建它：

```
// over = (lens, f: a => a, store) => store
const over = (lens, f, store) => set(lens, f(view(lens, store)), store);

const uppercase = x => x.toUpperCase();

console.log(
  over(aLens, uppercase, store) // { a: "FOO", b: "bar" }
);
```

Setter 遵守了仿函数规则：

```
{ // 如果你通过 lens 映射特定函数
  // store 不变
  const id = x => x;
  const lens = aLens;
  const a = over(lens, id, store);
  const b = store;

  console.log(a, b);
}
```

对于可组合的示例，我们将使用一个 over 的 auto-curried 版本：

```
import { curry } from 'ramda';

const over = curry(
  (lens, f, store) => set(lens, f(view(lens, store)), store)
);
```

很容易看出，over 操作下的 lenses 依旧遵循仿函数可组合规则：

```
{ // over(lens, f) after over(lens g)
  // 和 over(lens, compose(f, g)) 是一样的
  const lens = aLens;

  const store = {
    a: 20
  };

  const g = n => n + 1;
  const f = n => n * 2;

  const a = compose(
    over(lens, f),
    over(lens, g)
  );

  const b = over(lens, compose(f, g));

  console.log(
    a(store), // {a: 42}
    b(store)  // {a: 42}
  );
}
```

我们目前只基本了解了 lenses 的的皮毛，但是对于你继续开始学习已经足够了。如果想获取更多细节，Edward Kmett 在这个话题讨论了很多，很多人也写了许多深度的探索。

* * *

**Eric Elliott** 是一名分布式系统专家，也是书籍 [“Composing Software”](https://leanpub.com/composingsoftware) 和 [“Programming JavaScript Applications”](https://ericelliottjs.com/product/programming-javascript-applications-ebook/) 的作者。作为 [DevAnywhere.io](https://devanywhere.io/) 的合作创始人，他教给开发人员远程工作的技能，并鼓励他们找到工作和生活的平衡。他构建加密项目并鼓励开发团队使用它，并且为 **Adobe Systems，****Zumba Fitness，****The Wall Street Journal，****ESPN，****BBC，**和包括 **Usher，Frank Ocean，Metallica 等很多顶级音乐艺术家** 等等提供开发经验。

**他喜欢生活在偏远的地方，他身边有世界上最美的女人。**

感谢 [JS_Cheerleader](https://medium.com/@JS_Cheerleader?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
