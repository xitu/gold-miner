
> * 原文地址：[Composable Datatypes with Functions](https://medium.com/javascript-scene/composable-datatypes-with-functions-aec72db3b093)
> * 原文作者：[
Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/composable-datatypes-with-functions.md](https://github.com/xitu/gold-miner/blob/master/TODO/composable-datatypes-with-functions.md)
> * 译者：[yoyoyohamapi](https://github.com/yoyoyohamapi)
> * 校对者：[IridescentMia](https://github.com/IridescentMia) [lampui](https://github.com/lampui)

# 借助函数完成可组合的数据类型（软件编写）（第十部分）

![Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)](https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

（译注：该图是用 PS 将烟雾处理成方块状后得到的效果，参见 [flickr](https://www.flickr.com/photos/68397968@N07/11432696204)。）

> 注意：这是 “软件编写” 系列文章的第十部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科 [Composability](https://en.wikipedia.org/wiki/Composability)）。后续还有更多精彩内容，敬请期待！
> [<上一篇](https://medium.com/javascript-scene/why-composition-is-harder-with-classes-c3e627dcd0aa) | [<< 返回第一章](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md)

在 JavaScript 中，最简单的方式完成组合就是函数组合，并且一个函数只是一个你能够为之添加方法的对象。换言之，你可以这么做：

```js
const t = value => {
  const fn = () => value;
  fn.toString = () => `t(${ value })`;
  return fn;
};

const someValue = t(2);
console.log(
  someValue.toString() // "t(2)"
);
```

这是一个返回数字类型实例的工厂函数 `t`。但是要注意，这些实例不是简单的对象，它们是函数，并且是可组合的函数。假定我们使用 `t()` 来完成求和任务，那么当我们组合若干个函数 `t()` 来求和也就是合情合理的。 

首先，假定我们为 `t()` 确立了一些规则（`====` 意味着 “等于”）：

- `t(x)(t(0)) ==== t(x)`
- `t(x)(t(1)) ==== t(x + 1)`

在 JavaScript 中，你也可以通过我们创建好的 `.toString()` 方法进行比较：

- `t(x)(t(0)).toString() === t(x).toString()`
- `t(x)(t(1)).toString() === t(x + 1).toString()`

我们也能将上述代码翻译为一种简单的单元测试：

```js
const assert = {
  same: (actual, expected, msg) => {
    if (actual.toString() !== expected.toString()) {
      throw new Error(`NOT OK: ${ msg }
        Expected: ${ expected }
        Actual:   ${ actual }
      `);
    }
    console.log(`OK: ${ msg }`);
  }
};

{
  const msg = 'a value t(x) composed with t(0) ==== t(x)';
  const x = 20;
  const a = t(x)(t(0));
  const b = t(x);
  assert.same(a, b, msg);
}
{
  const msg = 'a value t(x) composed with t(1) ==== t(x + 1)';
  const x = 20;
  const a = t(x)(t(1));
  const b = t(x + 1);
  assert.same(a, b, msg);
}
```

起初，测试会失败：

```
NOT OK: a value t(x) composed with t(0) ==== t(x)
        Expected: t(20)
        Actual:   20
```

但是我们经过下面 3 步能让测试通过：

1. 将函数 `fn` 变为 `add` 函数，该函数返回 `t(value + n)` ，`n` 表示传入参数。
2. 为函数 `t` 添加一个 `.valueOf()` 方法，使得新的 `add()` 函数能够接受 `t()` 返回的实例作为参数。 `+` 运算符会使用 `n.valueOf()` 的结果作为第二个操作数。
3. 使用 `Object.assign()` 将 `toString()`，`.valueOf()` 方法分配给 `add()` 函数

将 1 至 3 步综合起来得到：

```js
const t = value => {
  const add = n => t(value + n);
  return Object.assign(add, {
    toString: () => `t(${ value })`,
    valueOf: () => value
  });
};
```

之后，测试便能通过：

```
"OK: a value t(x) composed with t(0) ==== t(x)"
"OK: a value t(x) composed with t(1) ==== t(x + 1)"
```

现在，你可以使用函数组合来组合 t() ，从而达到求和任务：

```js
// 自顶向下的函数组合：
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);
// 求和函数为 pipeline 传入需要的初始值
// curry 化的 pipeline 复用度更好，我们可以延迟传入任意的初始值
const sumT = (...fns) => pipe(...fns)(t(0));
sumT(
  t(2),
  t(4),
  t(-1)
).valueOf(); // 5
```

## 任何数据类型都适用

无论你的数据形态是什么样子的，只要它存在有意义的组合操作，上面的策略都能帮到你。对于列表或者字符串来说，组合能够完成连接操作。对于 DSP（数字信号处理）来说，组合完成的就是信号的求和。当然，其他的操作也能为你带来想要的结果。那么问题来了，哪种操作最能反映组合的观念？换言之，哪种操作能更受益于下面的代码组织方式：

```js
const result = compose(
  value1,
  value2,
  value3
);
```

## 可组合的货币

[Moneysafe](https://github.com/ericelliott/moneysafe) 是一个实现了这个可组合的、函数式数据类型风格的开源库。JavaScript 的 `Number` 类型无法精确地表示美分的计算：

```js
.1 + .2 === .3 // false
```

Moneysafe 通过将美元类型提升为美分类型解决了这个问题：

```
npm install --save moneysafe
```

之后：

```js
import { $ } from 'moneysafe';
$(.1) + $(.2) === $(.3).cents; // true
```

ledger 语法利用了 Moneysafe 将一般的值提升为可组合函数的优势。它暴露一个简单的、称之为 ledger 的函数组合套件：

```js
import { $ } from 'moneysafe';
import { $$, subtractPercent, addPercent } from 'moneysafe/ledger';
$$(
  $(40),
  $(60),
  // 减去折扣
  subtractPercent(20),
  // 上税
  addPercent(10)
).$; // 88
```

该函数的返回值类型是提升后 money 类型。该返回值暴露一个 `.$` getter 方法，这个 getter 能够将内部的浮点美分值四舍五入为美元。

该结果是执行 ledger 风格的金币计算一个直观反映。

## 测试一下你是否真的懂了

克隆 Moneysafe 仓库:

```
git clone git@github.com:ericelliott/moneysafe.git
```


执行安装过程：

```
npm install
```

运行单元测试，监控控制台输出。所有的用例都会通过：

```
npm run watch
```

打开一个新的终端，删除 moneysafe 的实现：

```
rm source/moneysafe.js && touch source/moneysafe.js
```

回到之前的终端窗口，你将会看到一个错误。

你现在的任务是利用单元测试输出及文档的帮助，从头实现 `moneysafe.js` 并通过所有测试。

[下一篇: JavaScript Monads 让一切变得简单 >](https://medium.com/javascript-scene/javascript-monads-made-simple-7856be57bfe8)

## 接下来

想学习更多 JavaScript 函数式编程吗？

[跟着 Eric Elliott 学 Javacript](http://ericelliottjs.com/product/lifetime-access-pass/)，机不可失时不再来！

[<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg">](https://ericelliottjs.com/product/lifetime-access-pass/)

**Eric Elliott** 是  [**“编写 JavaScript 应用”**](http://pjabook.com) （O’Reilly） 以及 [**“跟着 Eric Elliott 学 Javascript”**](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 **Adobe Systems**、**Zumba Fitness**、**The Wall Street Journal**、**ESPN** 和 **BBC** 等 , 也是很多机构的顶级艺术家，包括但不限于 **Usher**、**Frank Ocean** 以及 **Metallica**。

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
