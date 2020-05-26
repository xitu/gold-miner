> *   原文地址：[Higher Order Functions (Composing Software)(part 4)](https://medium.com/javascript-scene/higher-order-functions-composing-software-5365cf2cbe99)
> *   原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> *   译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> *   译者：[reid3290](https://github.com/reid3290)
> *   校对者：[Aladdin-ADD](https://github.com/Aladdin-ADD)、[avocadowang](https://github.com/avocadowang)

# [第四篇] 高阶函数（软件编写）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg">

Smoke Art Cubes to Smoke — MattysFlicks — (CC BY 2.0)（译注：该图是用 PS 将烟雾处理成方块状后得到的效果，参见 [flickr](https://www.flickr.com/photos/68397968@N07/11432696204)。）
> 注意：这是“软件编写”系列文章的第四部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科 [Composability](https://en.wikipedia.org/wiki/Composability)）。后续还有更多精彩内容，敬请期待！
> [< 上一篇](https://github.com/xitu/gold-miner/blob/master/TODO/a-functional-programmers-introduction-to-javascript-composing-software.md) | [<< 第一篇](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md)  | [下一篇 >](https://github.com/xitu/gold-miner/blob/master/TODO/reduce-composing-software.md)

**高阶函数**是一种接收一个函数作为输入或输出一个函数的函数（译注：参见维基百科[高阶函数](https://zh.wikipedia.org/wiki/%E9%AB%98%E9%98%B6%E5%87%BD%E6%95%B0)），这是和一阶函数截然不同的。

之前我们看到的 `.map()` 和 `.filter()` 都是高阶函数 —— 它们都接受一个函数作为参数，

先来看个一阶函数的例子，该函数会将单词数组中 4 个字母的单词过滤掉：

```
const censor = words => {
  const filtered = [];
  for (let i = 0, { length } = words; i < length; i++) {
    const word = words[i];
    if (word.length !== 4) filtered.push(word);
  }
  return filtered;
};

censor(['oops', 'gasp', 'shout', 'sun']);
// [ 'shout', 'sun' ]
```

如果又要选择出所有以 's' 开头的单词呢？可以再定义一个函数：

```
const startsWithS = words => {
  const filtered = [];
  for (let i = 0, { length } = words; i < length; i++) {
    const word = words[i];
    if (word.startsWith('s')) filtered.push(word);
  }
  return filtered;
};

startsWithS(['oops', 'gasp', 'shout', 'sun']);
// [ 'shout', 'sun' ]
```

显然可以看出这里面有很多重复的代码，这两个函数的主体是相同的 —— 都是遍历一个数组并根据给定的条件进行过滤。这便形成了一种特定的模式，可以从中抽象出更为通用的解决方案。

不难看出， “遍历”和“过滤”都是亟待抽象出来的，以便分享和复用到其他所有类似的函数中去。毕竟，从数组中选取某些特定元素是很常见的需求。

幸运的是，函数是 JavaScript 中的一等公民，就像数字、字符串和对象一样，函数可以：

- 像变量一样赋值给其他变量
- 作为对象的属性值
- 作为参数进行传递
- 作为函数的返回值

函数基本上可以像其他任何数据类型一样被使用，这点使得“抽象”容易了许多。例如，可以定义一种函数，将遍历数组并累计出一个返回值的过程抽象出来，该函数接收一个函数作为参数来决定具体的**累计**过程，不妨将此函数称为 **reducer**：

```
const reduce = (reducer, initial, arr) => {
  // 共享的
  let acc = initial;
  for (let i = 0, length = arr.length; i < length; i++) {

    // 独特的
    acc = reducer(acc, arr[i]);

  // 又是共享的
  }
  return acc;
};

reduce((acc, curr) => acc + curr, 0, [1,2,3]); // 6
```

该 `reduce()` 接受 3 个参数：一个 reducer 函数、一个累计的初始值和一个用于遍历的数组。对数组中的每个元素都会调用 reducer，传入累计器和当前数组元素，返回值又会赋给累计器。对数组中的所有元素都执行过 reducer 之后，返回最终的累计结果。

在用例中，调用 `reduce` 并传给它 3 个参数：`reducer` 函数、初始值 0 以及需要遍历的数组。其中 `reducer` 函数以累计器和当前数组元素为参数，返回累计后的结果。

如此将遍历和累计的过程抽象出来之后，便可实现更为通用的 `filter()` 函数：

```
 const filter = (
  fn, arr
) => reduce((acc, curr) => fn(curr) ?
  acc.concat([curr]) :
  acc, [], arr
);
```

在此 `filter()` 函数中，除了以参数形式传进来的 `fn()` 函数以外，所有代码都是可复用的。其中 `fn()` 参数被称为**断言（predicate）** —— 返回一个布尔值的函数。

将当前值传给 `fn()`，如果 `fn(curr)` 返回 `true`，则将 `curr` 添加到结果数组中并返回之；否则，直接返回当前数组。

现在便可借助 `filter()` 函数来实现过滤 4 字母单词的 `censor()` 函数：

```
const censor = words => filter(
  word => word.length !== 4,
  words
);
```

喔！将所有公共代码抽象出来之后，`censor()` 函数便十分简洁了。

`startsWithS()` 也是如此：

```
 const startsWithS = words => filter(
  word => word.startsWith('s'),
  words
);
```

 你若稍加留意便会发现 JavaScript 其实已经为我们做了这些抽象，即 `Array.prototype` 的相关方法，例如 `.reduce()`、`.filter()`、`.map()` 等等。

 高阶函数也常常被用于对不同数据类型的操作进行抽象。例如，`.filter()` 函数不一定非得作用于字符串数组。只需传入一个能够处理不同数据类型的函数，`.filter()` 便能过滤数字了。还记得 `highpass` 的例子吗？

```
const highpass = cutoff => n => n >= cutoff;
const gt3 = highpass(3);
[1, 2, 3, 4].filter(gt3); // [3, 4];
```

换言之，高阶函数可以用来实现函数的多态性。如你所见，相对于一阶函数而言，高阶函数的复用性和通用性更好。一般来讲，在实际编码中会组合使用高阶函数和一些非常简单的一阶函数。

[**再续 “Reduce” >**](https://github.com/xitu/gold-miner/blob/master/TODO/reduce-composing-software.md)

### 接下来 ###

想学习更多 JavaScript 函数式编程吗？

[跟着 Eric Elliott 学 Javacript](http://ericelliottjs.com/product/lifetime-access-pass/)，机不可失时不再来！

[<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg">](https://ericelliottjs.com/product/lifetime-access-pass/)

**Eric Elliott** 是  [**“编写 JavaScript 应用”**](http://pjabook.com) （O’Reilly） 以及 [**“跟着 Eric Elliott 学 Javascript”**](http://ericelliottjs.com/product/lifetime-access-pass/) 两书的作者。他为许多公司和组织作过贡献，例如 **Adobe Systems**、**Zumba Fitness**、**The Wall Street Journal**、**ESPN** 和 **BBC**等 , 也是很多机构的顶级艺术家，包括但不限于 **Usher**、**Frank Ocean** 以及 **Metallica**。

大多数时间，他都在 San Francisco Bay Area，同这世上最美丽的女子在一起。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
