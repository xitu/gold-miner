> * 原文地址：[Curry and Function Composition](https://medium.com/javascript-scene/curry-and-function-composition-2c208d774983)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/curry-and-function-composition.md](https://github.com/xitu/gold-miner/blob/master/TODO1/curry-and-function-composition.md)
> * 译者：[子非](https://www.github.com/CoolRice)
> * 校对者：[wuzhengyan2015](https://github.com/wuzhengyan2015), [TTtuntuntutu](https://github.com/TTtuntuntutu)

# 柯里化与函数组合

![](https://cdn-images-1.medium.com/max/2000/1*uVpU7iruzXafhU2VLeH4lw.jpeg)

烟雾艺术从方块到烟雾 — MattysFlicks — (CC BY 2.0)

> 注意：此篇文章是“组合软件”系列的一部分，这个系列的目的是从头在 JavaScript ES6+ 环境下学习函数式编程和组合软件技术。敬请关注。我们会讲述大量关于这方面的知识！
> [< 上一篇](https://github.com/xitu/gold-miner/blob/master/TODO1/the-forgotten-history-of-oop.md) | [<< 第一篇](https://github.com/xitu/gold-miner/blob/a9a689ee3df732ea0c9e88207ad6cf0a10ad7d4b/TODO1/composing-software-an-introduction.md)

随着在主流 JavaScript 中函数式编程戏剧般地兴起，在许多应用中柯里化函数变得普遍起来。理解它们是什么、如何运作和怎样有效地运用非常重要。

### 什么是柯里化函数？

柯里化函数是一种由需要接受多个参数的函数转化为**一次只接受一个**参数的函数。如果一个函数需要 3 个参数，那柯里化后的函数会接受一个参数并返回一个函数来接受下一个参数，这个函数返回的函数去传入第三个参数。最后一个函数会返回应用了所有参数的函数结果。

你可以用更多或更少数量的参数来做同样的事。例如有两个数字，`a` 和 `b` 的柯里化形式会返回 `a` 与 `b` 之和。

```
// add = a => b => Number
const add = a => b => a + b;
```

为了使用它，我们必须使用函数应用语法应用到这两个函数上。在 JavaScript 中，函数后的括号 `()` 触发函数调用。当函数返回另一个函数，被返回的函数可以通过一对额外的括号被立即调用：

```
const result = add(2)(3); // => 5
```

首先，函数接受参数 `a` 并**返回一个新的函数**，新函数接受 `b` 返回 `a` 与 `b` 之和。**一次接受一个参数**。如果函数有更多参数，它会简单地继续返回新函数直到所有的参数都被提供，这时应用完成。

`add` 函数接受一个参数，然后返回自己的 **偏函数应用**，`a` 固定在偏函数应用的闭包作用域中。**闭包**指函数绑定其语法作用域。闭包在创建函数运行时被创建。固定意味着在闭包绑定的作用域内变量被赋值。

上例中的括号代表的函数调用过程：使用 `2` 做参数调用 `add`，返回偏函数应用并且 `a` 的值固定为 `2`。我们不会将返回值赋值给变量或以其他方式使用它，而是通过在括号中将 `3` 传递给它来立即调用返回函数，从而完成应用并返回 `5`。

### 什么是偏函数应用（Partial Application）？

**偏函数应用**是指使用一个函数并将其应用一个或多个参数，但不是全部参数。换句话说，它是一种在闭包作用域中已拥有一些**固定**参数的函数。**偏函数应用**是拥有部分固定参数的函数。

### 它们之间的不同之处?

偏函数应用可以根据需要一次接受多或少的参数。而柯里化函数**总是**返回一元函数：函数总是接受**一个参数**。

所有的柯里化函数都返回偏函数应用，但不是所有的偏函数应用都是柯里化函数的结果。

柯里化函数的一元需求是一个重要特性。

### 什么是无点风格（point-free style）？

无点风格是一种编程风格，其函数定义不会关联函数的参数。让我们来看 JavaScript 中的函数定义：

```
function foo (/* 这里定义参数*/) {
  // ...
}

const foo = (/* 这里定义参数 */) => // ...

const foo = function (/* 这里定义参数 */) {
  // ...
}
```

你如何能在 JavaScript 中定义不关联参数的函数？我们不能使用 `function` 关键字，也不能使用箭头函数（`=>`），因为这些都要求正式的参数声明。所以我们要做的是调用一个会返回函数的函数。

使用无点风格创建一个函数，该方法会把你传入的任何数字加一。记住，我们已经有一个叫 `add` 的函数，它需要一个数字做参数，并且无论你传入了什么值都会返回一个第一个参数固定的偏函数。我们可以使用这种方法创建一个叫 `inc()` 的新函数。

```
// inc = n => Number
// 把任何数字加一。
const inc = add(1);

inc(3); // => 4
```

作为一种泛化和专用机制，这很有趣。返回的函数不过是更加通用的 `add()` 函数的一种**专用版**。我们可以按需要使用 `add()` 来创建许多专用版本。

```
const inc10 = add(10);
const inc20 = add(20);

inc10(3); // => 13
inc20(3); // => 23
```

当然，所有这些都有它们自己的闭包作用域（闭包在函数创建时被创建 —— 在 `add()` 被调用时），所以原来 `inc()` 可以保持功能：

```
inc(3) // 4
```

当我们调用 `add(1)` 来创建 `inc()` 时，`add()` 中的 `a` 参数在返回的函数中固定为 `1`，这个返回的函数赋值给`inc`。

当我们调用 `inc(3)` 时，`add()` 中的 `b` 参数被参数 `3` 替换，函数结束，返回 `1` 与 `3` 之和。

所有的柯里化函数都是高阶形式函数，它允许你为了专门用途创建原函数的专用版本。

### 为什么要把函数柯里化？

柯里化函数在函数组合中极其有用。

在代数学中，假设有两个函数，`f` 和 `g`：

```
f: a -> b
g: b -> c
```

你可以把这两个函数组合来创建一个新函数 `h`，从 `a` 直接得到 `c`：

```
// 代数定义，从 Haskell 借鉴了组合操作符 `.`

h: a -> c
h = f . g = f(g(x))
```

在 JavaScript 中:

```
const g = n => n + 1;
const f = n => n * 2;

const h = x => f(g(x));

h(20); //=> 42
```

代数定义：

```
f . g = f(g(x))
```

可以被转换成 JavaScript：

```
const compose = (f, g) => f(g(x));
```

但这只能一次组合两个函数。在代数中，有可能这么写：

```
g . f . h
```

我们可以随意把任意多个函数组合成一个函数。换句换说，`compose()` 在函数中创建了一个管道，把一个函数的输出与下一个函数的输入连接起来。

我经常以这种方法来写：

```
const compose = (...fns) => x => fns.reduceRight((y, f) => f(y), x);
```

此版本使用任意多个函数并返回一个需要初始值的函数，然后使用 `reduceRight()` 从右到左遍历每一个函数，即 `fns` 中的 `f`，并把它变成累积值 `y`。函数中累加器的计算值 `y` 就是函数 `compose()` 的返回值。

现在我们可以这样组合：

```
const g = n => n + 1;
const f = n => n * 2;

// 使用 `compose(f, g)` 替换 `x => f(g(x))` `
const h = compose(f, g);

h(20); //=> 42
```

### 跟踪（Trace）

函数组合使用无点风格创建非常简洁易懂的代码，不过若想简单的调试则要花点功夫。如果你想检查函数间的值？你可以使用一种方便的工具 `trace()`。它需要柯里化函数的形式：

```
const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};
```

现在我们来检查管道：

```
const compose = (...fns) => x => fns.reduceRight((y, f) => f(y), x);

const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

/*
注意：函数应用的顺序是从下到上：
*/

const h = compose(
  trace('after f'),
  f,
  trace('after g'),
  g
);

h(20);
/*
after g: 21
after f: 42
*/
```

`compose()` 是非常有用的工具，但当我们需要组合多于两个函数时，从上到下的顺序会更方便我们阅读。我们可以通过反转被调用函数的顺序来做到。这里有另一个名为 `pipe` 的组合工具，它反转了组合的顺序：

```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);
```

现在我们可以这样写上面的代码：

```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

/*
现在函数应用的顺序是从上到下：
*/
const h = pipe(
  g,
  trace('after g'),
  f,
  trace('after f'),
);

h(20);
/*
after g: 21
after f: 42
*/
```

### 结合柯里化和函数组合

即便不在函数组合的范畴中讲，柯里化无疑也是一种非常有用的抽象，我们可以运用到专用函数。例如，柯里化版本的 `map` 可以被专用化来做很多不同的事情：

```
const map = fn => mappable => mappable.map(fn);

const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);
const log = (...args) => console.log(...args);

const arr = [1, 2, 3, 4];
const isEven = n => n % 2 === 0;

const stripe = n => isEven(n) ? 'dark' : 'light';
const stripeAll = map(stripe);
const striped = stripeAll(arr);
log(striped);
// => ["light", "dark", "light", "dark"]

const double = n => n * 2;
const doubleAll = map(double);
const doubled = doubleAll(arr);
log(doubled);
// => [2, 4, 6, 8]
```

但是柯里化函数的真正能力是它们可以简化函数组合。一个函数可以接受任意数量的输入，但是只返回一个输出。为了使函数可组合，输出类型必须与期望输入类型统一：

```
f: a => b
g:      b => c
h: a    =>   c
```

如果上面的函数 `g` 期望两个参数，`f` 的输出就会和 `g` 的输入不一致：

```
f: a => b
g:     (x, b) => c
h: a    =>   c
```

在这种情况下如何把 `x` 传入 `g`，答案是**把 `g` 柯里化**。

记住柯里化函数的定义：一种由需要多个参数的函数转化为**一次只接受一个**参数的函数，并且通过使用第一个参数并返回一系列函数直到所有的参数都已被收集。

上述定义的关键词是“一次传入一个参数”。对于函数组合来说柯里化函数如此方便的原因是它们把需要多个参数的函数变成了只需要一个参数的函数，允许它们适配函数组合管道。拿前面的 `trace()` 函数为例：

```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

const h = pipe(
  g,
  trace('after g'),
  f,
  trace('after f'),
);

h(20);
/*
after g: 21
after f: 42
*/
```

`trace()` 定义两个参数，但是每次只取一个参数，允许我们专用化行内函数。如果 `trace()` 没有被柯里化，就不能这样使用它。我们就必须这样写管道函数：
```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = (label, value) => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

const h = pipe(
  g,
  // trace() 不在是无点风格，并引入 `x` 作为中间变量。
  x => trace('after g', x),
  f,
  x => trace('after f', x),
);

h(20);
```

但是单纯的柯里化函数仍然不够。你还需要保证函数期望的参数以按正确的顺序来专用化它们。再看一遍我们柯里化 `trace()` 时发生了什么，不过这次我们反转参数的顺序：

```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = value => label => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

const h = pipe(
  g,
  // trace() 不能为无点风格，因为期望的参数顺序错误
  x => trace(x)('after g'),
  f,
  x => trace(x)('after f'),
);

h(20);
```

如果有必要，你可以使用 `flip` 方法来解决这个问题，它简单地反转了两个参数的顺序：

```
const flip = fn => a => b => fn(b)(a);
```

现在我们可以创建 `flippedTrace()` 函数：

```
const flippedTrace = flip(trace);
```

并这样使用它：

```
const flip = fn => a => b => fn(b)(a);
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = value => label => {
  console.log(`${ label }: ${ value }`);
  return value;
};
const flippedTrace = flip(trace);

const g = n => n + 1;
const f = n => n * 2;

const h = pipe(
  g,
  flippedTrace('after g'),
  f,
  flippedTrace('after f'),
);

h(20);
```

不过更好的方式是在开始就写出正确的函数。有时这种风格被称为“数据置后”，这意味着你需要首先传入专用化参数，并在最后传入参数执行函数。这里展示了原始的函数形式：

```
const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};
```

`trace()` 每次应用 `label` 时会创建专用版本的跟踪函数，它会在管道中用到，管道中 `label` 在 `trace` 返回的偏函数应用中是固定的。所以：

```
const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};

const traceAfterG = trace('after g');
```

...等同于：

```
const traceAfterG = value => {
  const label = 'after g';
  console.log(`${ label }: ${ value }`);
  return value;
};
```

如果我们把 `trace('after g')` 换成 `traceAfterG`，就等同于下面：

```
const pipe = (...fns) => x => fns.reduce((y, f) => f(y), x);

const trace = label => value => {
  console.log(`${ label }: ${ value }`);
  return value;
};

// 柯里化版本的 trace() 能让我们避免这种代码...
const traceAfterG = value => {
  const label = 'after g';
  console.log(`${ label }: ${ value }`);
  return value;
};

const g = n => n + 1;
const f = n => n * 2;

const h = pipe(
  g,
  traceAfterG,
  f,
  trace('after f'),
);

h(20);
```

### 总结

**柯里化函数**是一种把接受多参数的函数变为接受单一参数的函数，通过使用第一个参数并返回使用余下参数的一系列函数，直到所有的参数都被使用，并且函数应用结束，此时结果就会被返回。

**偏函数应用**是一种已经应用一些但非全部参数的函数。函数已经应用的参数被称为**固定参数（Fixed Parameters）**。

**无点风格**是一种不需要引用参数的函数定义风格。一般来说，无点函数通过调用返回函数的函数来创建，例如柯里化函数。

**柯里化函数对于函数组合非常有用**，因为由于函数组合的需要，你可以把 n 元函数轻松地转换成一元函数形式：管道内的函数必须是单一参数。

**数据置后函数**对于函数组合来说非常方便，因为它们可以轻松地被用在无点风格中。

### 下一步

[EricElliottJS.com](https://ericelliottjs.com/) 的会员可以看到此话题的完全指南视频。会员可以访问 [ES6 Curry & Composition 课程](https://ericelliottjs.com/premium-content/es6-curry-composition/)。

* * *

**Eric Elliott 是 [Programming JavaScript Applications(O’Reilly)](http://pjabook.com) 的作者，并且是软件导师制平台 [DevAnywhere.io](https://devanywhere.io/) 的合作创始人。他拥有为 Adobe Systems、Zumba Fitness、The Wall Street Journal、ESPN、BBC 和顶尖音乐艺术家包括 Usher、Frank Ocean、Metallica 等工作的经验。**

**他有着世界上最漂亮的女人陪着他在世界各地远程工作。**

感谢 [JS_Cheerleader](https://medium.com/@JS_Cheerleader?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
