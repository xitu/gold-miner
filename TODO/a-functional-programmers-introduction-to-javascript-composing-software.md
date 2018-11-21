> * 原文地址：[A Functional Programmer’s Introduction to JavaScript (Composing Software)(part 3)](https://medium.com/javascript-scene/a-functional-programmers-introduction-to-javascript-composing-software-d670d14ede30)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[sunui](http://suncafe.cc)
> * 校对者：[Aladdin-ADD](https://github.com/Aladdin-ADD)、[avocadowang](https://github.com/avocadowang)

# [第三篇] 函数式程序员的 JavaScript 简介（软件编写）

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg">

烟雾艺术魔方 — MattysFlicks — (CC BY 2.0)

> 注意：这是“软件编写”系列文章的第三部分，该系列主要阐述如何在 JavaScript ES6+ 中从零开始学习函数式编程和组合化软件（compositional software）技术（译注：关于软件可组合性的概念，参见维基百科 [Composability](https://en.wikipedia.org/wiki/Composability)）。后续还有更多精彩内容，敬请期待！
> [< 上一篇](https://github.com/gy134340/gold-miner/blob/69bca85e75f4b99b33c193c21f577db93622ee8b/TODO/why-learn-functional-programming-in-javascript-composing-software.md)  | [<<第一篇](https://github.com/xitu/gold-miner/blob/master/TODO/the-rise-and-fall-and-rise-of-functional-programming-composable-software.md)  | [下一篇 >](https://github.com/xitu/gold-miner/blob/master/TODO/higher-order-functions-composing-software.md)

对于不熟悉 JavaScript 或 ES6+ 的同学，这里做一个简短的介绍。无论你是 JavaScript 开发新手还是有经验的老兵，你都可能学到一些新东西。以下内容仅是浅尝辄止，吊吊大家的兴致。如果想知道更多，还需深入学习。敬请期待吧。


学习编程最好的方法就是动手编程。我建议您使用交互式 JavaScript 编程环境（如 [CodePen](https://codepen.io/) 或 [Babel REPL](https://babeljs.io/repl/)）。

或者，您也可以使用 Node 或浏览器控制台 REPL。

### 表达式和值 ###

表达式是可以求得数据值的代码块。

下面这些都是 JavaScript 中合法的表达式：

```
7;

7 + 1; // 8

7 * 2; // 14

'Hello'; // Hello
```

表达式的值可以被赋予一个名称。执行此操作时，表达式首先被计算，取得的结果值被赋值给该名称。对于这一点我们将使用 `const` 关键字。这不是唯一的方式，但这将是你使用最多的，所以目前我们就可以坚持使用 `const`。

```
const hello = 'Hello';
hello; // Hello
```

### var、let 和 const ###

JavaScript 支持另外两种变量声明关键字：`var`，还有 `let`。我喜欢根据选择的顺序来考虑它们。默认情况下，我选择最严格的声明方式：`const`。用 `const` 关键字声明的变量不能被重新赋值。最终值必须在声明时分配。这可能听起来很严格，但限制是一件好事。这是个标识在提醒你“赋给这个名称的值将不会改变”。它可以帮你全面了解这个名称的意义，而无需阅读整个函数或块级作用域。

有时，给变量重新赋值很有用。比如，如果你正在写一个手动的强制性迭代，而不是一个更具功能性的方法，你可以迭代一个用 `let` 赋值的计数器。

因为 `var` 能告诉你很少关于这个变量的信息，所以它是最无力的声明标识。自从开始用 ES6，我就再也没在实际软件项目中有意使用 `var` 作声明了。

注意一下，一个变量一旦用 `let` 或 `const` 声明，任何再次声明的尝试都将导致报错。如果你在 REPL（读取-求值-输出循环）环境中更喜欢多一些实验性和灵活性，那么建议你使用 `var` 声明变量，与 `let` 和 `const` 不同，使用 `var` 重新声明变量是合法的。

本文将使用 const 来让您习惯于为实际程序中用 `const`，而出于试验的目的自由切换回 `var`。

### 数据类型 ###

目前为止我们见到了两种数据类型：数字和字符串。JavaScript 也有布尔值（`true` 或 `false`）、数组、对象等。稍后我们再看其他类型。

数组是一系列值的有序列表。可以把它比作一个能够装很多元素的容器。这是一个数组字面量：

```
[1, 2, 3];
```

当然，它也是一个可被赋予名称的表达式：

```
const arr = [1, 2, 3];
```

在 JavaScript 中，对象是一系列键值对的集合。它也有字面量：

```
{
  key: 'value'
}
```

当然，你也可以给对象赋予名称：

```
const foo = {
  bar: 'bar'
}
```

如果你想将现有变量赋值给同名的对象属性，这有个捷径。你可以仅输入变量名，而不用同时提供一个键和一个值：

```
const a = 'a';
const oldA = { a: a }; // 长而冗余的写法
const oA = { a }; // 短小精悍！
```

为了好玩而已，让我们再来一次：

```
const b = 'b';
const oB = { b };
```

对象可以轻松合并到新的对象中：

```
const c = {...oA, ...oB}; // { a: 'a', b: 'b' }
```

这些点是对象扩展运算符。它迭代 `oA` 的属性并分配到新的对象中，`oB` 也是一样，在新对象中已经存在的键都会被重写。在撰写本文时，对象扩展是一个新的试验特性，可能还没有被所有主流浏览器支持，但如果你那不能用，还可以用 `Object.assign()` 替代：

```
const d = Object.assign({}, oA, oB); // { a: 'a', b: 'b' }
```

这个 `Object.assign()` 的例子代码很少，如果你想合并很多对象，它甚至可以节省一些打字。注意当你使用 `Object.assign()` 时，你必须传一个目标对象作为第一个参数。它就是那个源对象的属性将被复制过去的对象。如果你忘了传，第一个参数传递的对象将被改变。

以我的经验，改变一个已经存在的对象而不创建一个新的对象常常引发 bug。至少至少，它很容易出错。要小心使用 `Object.assign()`。

### 解构 ###

对象和数组都支持解构，这意味着你可以从中提取值分配给命过名的变量：

```
const [t, u] = ['a', 'b'];
t; // 'a'
u; // 'b'

const blep = {
  blop: 'blop'
};

// 下面等同于：
// const blop = blep.blop;
const { blop } = blep;
blop; // 'blop'
```

和上面数组的例子类似，你可以一次解构多次分配。下面这行你在大量的 Redux 项目中都能见到。

```
const { type, payload } = action;
```

下面是它在一个 reducer（后面的话题再详细说） 的上下文中的使用方法。

```
const myReducer = (state = {}, action = {}) => {
  const { type, payload } = action;
  switch (type) {
    case 'FOO': return Object.assign({}, state, payload);
    default: return state;
  }
};
```

如果不想为新绑定使用不同的名称，你可以分配一个新名称：

```
const { blop: bloop } = blep;
bloop; // 'blop'
```

读作：把 `blep.blop` 分配给 `bloop`。

### 比较运算符和三元表达式 ###

你可以用严格的相等操作符（有时称为“三等于”）来比较数据值：

```
3 + 1 === 4; // true
```

还有另外一种宽松的相等操作符。它正式地被称为“等于”运算符。非正式地可以叫“双等于”。双等于有一两个有效的用例，但大多数时候默认使用 `===` 操作符是更好的选择。


其它比较操作符有:

- `>` 大于
- `<` 小于
- `>=` 大于或等于
- `<=` 小于或等于
- `!=` 不等于
- `!==` 严格不等于
- `&&` 逻辑与
- `||` 逻辑或

三元表达式是一个可以让你使用一个比较器来问问题的表达式，运算出的不同答案取决于表达式是否为真:

```
14 - 7 === 7 ? 'Yep!' : 'Nope.'; // Yep!
```

### 函数 ###

JavaScript 支持函数表达式，函数可以这样分配名称：

```
const double = x => x * 2;
```

这和数学表达式 `f(x) = 2x` 是一个意思。大声说出来，这个函数读作 `x` 的 `f` 等于 `2x`。这个函数只有当你用一个具体的 `x` 的值应用它的时候才有意思。在其它方程式里面你写 `f(2)`，就等同于 `4`。

换种说话就是 `f(2) = 4`。您可以将数学函数视为从输入到输出的映射。这个例子里 `f(x)` 是输入数值 `x` 到相应的输出数值的映射，等于输入数值和 `2` 的乘积。

在 JavaScript 中，函数表达式的值是函数本身：

```
double; // [Function: double]
```

你可以使用 `.toString()` 方法看到这个函数的定义。

```
double.toString(); // 'x => x * 2'
```

如果要将函数应用于某些参数，则必须使用函数调用来调用它。函数调用会接收参数并且计算一个返回值。

你可以使用 `<functionName>(argument1, argument2, ...rest)` 调用一个函数。比如调用我们的 double 函数，就加一对括号并传进去一个值：

```
double(2); // 4
```

和一些函数式语言不同，这对括号是有意义的。没有它们，函数将不会被调用。

```
double 4; // SyntaxError: Unexpected number
```

### 签名 ###

函数的签名可以包含以下内容：

1. 一个 **可选的** 函数名。
2. 在括号里的一组参数。 参数的命名是可选的。
3. 返回值的类型。

JavaScript 的签名无需指定类型。JavaScript 引擎将会在运行时断定类型。如果你提供足够的线索，签名信息也可以通过开发工具推断出来，比如一些 IDE（集成开发环境）和使用数据流分析的 [Tern.js](http://ternjs.net/)。

JavaScript 缺少它自己的函数签名语法，所以有几个竞争标准：JSDoc 在历史上非常流行，但它太过笨拙臃肿，没有人会不厌其烦地维护更新文档与代码同步，所以很多 JS 开发者都弃坑了。

TypeScript 和 Flow 是目前的大竞争者。这二者都不能让我确定地知道怎么表达我需要的一切，所以我使用 [Rtype](https://github.com/ericelliott/rtype)，仅仅用于写文档。一些人倒退回 Haskell 的 curry-only [Hindley–Milner 类型系统](http://web.cs.wpi.edu/~cs4536/c12/milner-damas_principal_types.pdf)。如果仅用于文档，我很乐意看到 JavaScript 能有一个好的标记系统标准，但目前为止，我觉得当前的解决方案没有能胜任这个任务的。现在，怪异的类型标记即使和你在用的不尽相同，也就将就先用着吧。

```
functionName(param1: Type, param2: Type) => Type
```

double 函数的签名是：

```
double(x: n) => n
```

尽管事实上 JavaScript 不需要注释签名，知道何为签名和它意味着什么依然很重要，它有助于你高效地交流函数是如何使用和如何构建的。大多数可重复使用的函数构建工具都需要你传入同样类型签名的函数。

### 默认参数值 ###

JavaScript 支持默认参数值。下面这个函数类似一个恒等函数（以你传入参数为返回值的函数），一旦你用 `undefined` 调用它，或者根本不传入参数——它就会返回 0，来替代：

```
const orZero = (n = 0) => n;
```

如上，若想设置默认值，只需在传入参数时带上 `=` 操作符，比如 `n = 0`。当你用这种方式传入默认值，像 [Tern.js](http://ternjs.net/)、Flow、或者 TypeScript 这些类型检测工具可以自行推断函数的类型签名，甚至你不需要刻意声明类型注解。

结果就是这样，在你的编辑器或者 IDE 中安装正确的插件，在你输入函数调用时，你可以看见内联显示的函数签名。依据它的调用签名，函数的使用方法也一目了然。无论起不起作用，使用默认值可以让你写出更具可读性的代码。

> 注意： 使用默认值的参数不会增加函数的 `.length` 属性，比如使用依赖 `.length` 值的自动柯里化会抛出不可用异常。如果你碰上它，一些柯里化工具（比如 `lodash/curry`）允许你传入自定义参数来绕开这个限制。

### 命名参数 ###

JavaScript 函数可以传入对象字面量作为参数，并且使用对象解构来分配参数标识，这样做可以达到命名参数的同样效果。注意，你也可以使用默认参数特性传入默认值。

```
const createUser = ({
  name = 'Anonymous',
  avatarThumbnail = '/avatars/anonymous.png'
}) => ({
  name,
  avatarThumbnail
});

const george = createUser({
  name: 'George',
  avatarThumbnail: 'avatars/shades-emoji.png'
});

george;
/*
{
  name: 'George',
  avatarThumbnail: 'avatars/shades-emoji.png'
}
*/
```

### 剩余和展开 ###

JavaScript 中函数共有的一个特性是可以在函数参数中使用剩余操作符 `...` 来将一组剩余的参数聚集到一起。

例如下面这个函数简单地丢弃第一个参数，返回其余的参数：

```
const aTail = (head, ...tail) => tail;
aTail(1, 2, 3); // [2, 3]
```

剩余参数将各个元素组成一个数组。而展开操作恰恰相反：它将一个数组中的元素扩展为独立元素。研究一下这个：

```
const shiftToLast = (head, ...tail) => [...tail, head];
shiftToLast(1, 2, 3); // [2, 3, 1]
```

JavaScript 数组在使用扩展操作符的时候会调用一个迭代器，对于数组中的每一个元素，迭代器都会传递一个值。在 `[...tail, head]` 表达式中，迭代器按顺序从 `tail` 数组中拷贝到一个刚刚创建的新的数组。之前 head 已经是一个独立元素了，我们只需把它放到数组的末端，就完成了。

### 柯里化 ###

可以通过返回另一个函数来实现柯里化（Curry）和偏应用（partial application）：

```
const highpass = cutoff => n => n >= cutoff;
const gt4 = highpass(4); // highpass() 返回了一个新函数
```

你可以不使用箭头函数。JavaScript 也有一个 `function` 关键字。我们使用箭头函数是因为 `function` 关键字需要打更多的字。
这种写法和上面的 `highPass()` 定义是一样的：

```
const highpass = function highpass(cutoff) {
  return function (n) {
    return n >= cutoff;
  };
};
```

JavaScript 中箭头的大致意义就是“函数”。使用不同种的方式声明，函数行为会有一些重要的不同点（`=>` 缺少了它自己的 `this` ，不能作为构造函数），但当我们遇见那就知道不同之处了。现在，当你看见 `x => x`，想到的是 “一个携带 `x` 并且返回 `x` 的函数”。所以 `const highpass = cutoff => n => n >= cutoff;` 可以这样读：

“`highpass` 是一个携带 `cutoff` 返回一个携带 `n` 并返回结果 `n >= cutoff` 的函数的函数”

既然 `highpass()` 返回一个函数，你可以使用它创建一个更独特的函数：

```
const gt4 = highpass(4);

gt4(6); // true
gt4(3); // false
```

自动柯里化函数，有利于获得最大的灵活性。比如你有一个函数 `add3()`:

```
const add3 = curry((a, b, c) => a + b + c);
```

使用自动柯里化，你可以有很多种不同方法使用它，它将根据你传入多少个参数返回正确结果：

```
add3(1, 2, 3); // 6
add3(1, 2)(3); // 6
add3(1)(2, 3); // 6
add3(1)(2)(3); // 6
```

令 Haskell 粉遗憾的是，JavaScript 没有内置自动柯里化机制，但你可以从 Lodash 引入：

```
$ npm install --save lodash
```

然后在你的模块里:

```
import curry from 'lodash/curry';
```

或者你可以使用下面这个魔性写法:

```
// 精简的递归自动柯里化
const curry = (
  f, arr = []
) => (...args) => (
  a => a.length === f.length ?
    f(...a) :
    curry(f, a)
)([...arr, ...args]);
```

### 函数组合 ###

当然你能够开始组合函数了。组合函数是传入一个函数的返回值作为参数给另一个函数的过程。用数学符号标识：

```
f . g
```

翻译成 JavaScript:

```
f(g(x))
```

这是从内到外地求值：

1. `x` 是被求数值
2. `g()` 应用给 `x`
3. `f()` 应用给 `g(x)` 的返回值

例如:

```
const inc = n => n + 1;
inc(double(2)); // 5
```

数值 `2` 被传入 `double()`，求得 `4`。 `4` 被传入 `inc()` 求得 `5`。

你可以给函数传入任何表达式作为参数。表达式在函数应用之前被计算:

```
inc(double(2) * double(2)); // 17
```

既然 `double(2)` 求得 `4`，你可以读作 `inc(4 * 4)`，然后计算得 `inc(16)`，然后求得 `17`。

函数组合是函数式编程的核心。我们后面还会介绍很多。

### 数组 ###

数组有一些内置方法。方法是指对象关联的函数，通常是这个对象的属性：

```
const arr = [1, 2, 3];
arr.map(double); // [2, 4, 6]
```

这个例子里，`arr` 是对象，`.map()` 是一个以函数为值的对象属性。当你调用它，这个函数会被应用给参数，和一个特别的参数叫做 `this`，`this` 在方法被调用之时自动设置。这个 `this` 的存在使 `.map()` 能够访问数组的内容。

注意我们传递给 `map` 的是 `double` 函数而不是直接调用。因为 `map` 携带一个函数作为参数并将函数应用给数组的每一个元素。它返回一个包含了 `double()` 返回值的新的数组。

注意原始的 `arr` 值没有改变：

```
arr; // [1, 2, 3]
```

### 方法链 ###

你也可以链式调用方法。方法链是指在函数返回值上直接调用方法的过程，在此期间不需要给返回值命名：

```
const arr = [1, 2, 3];
arr.map(double).map(double); // [4, 8, 12]
```

返回布尔值（`true` 或 `false`）的函数叫做 **断言**（predicate）。`.filter()` 方法携带断言并返回一个新的数组，新数组中只包含传入断言函数（返回 `true`）的元素：

```
[2, 4, 6].filter(gt4); // [4, 6]
```

你常常会想要从一个列表选择一些元素，然后把这些元素序列化到一个新列表中：

```
[2, 4, 6].filter(gt4).map(double); [8, 12]
```

注意：后面的文章你将看到使用叫做 **transducer** 东西更高效地同时选择元素并序列化，不过这之前还有一些其他东西要了解。

### 总结 ###

如果你现在有点发懵，不必担心。我们仅仅概览了一下很多事情的表面，它们尚需大量的解释和总结。很快我们就会回过头来，深入探讨其中的一些话题。

[**继续阅读 “高阶函数”…**](https://github.com/xitu/gold-miner/blob/master/TODO/higher-order-functions-composing-software.md)

### 接下来 ###

想要学习更多 JavaScript 函数式编程知识？

[和 Eric Elliott 一起学习 JavaScript](http://ericelliottjs.com/product/lifetime-access-pass/)。 如果你不是其中一员，千万别错过！

[<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg">
](https://ericelliottjs.com/product/lifetime-access-pass/)


***Eric Elliott*** 是 [*“JavaScript 应用程序设计”*](http://pjabook.com)  (O’Reilly) 以及 [*“和 Eric Elliott 一起学习 JavaScript”*](http://ericelliottjs.com/product/lifetime-access-pass/) 的作者。 曾就职于 **Adobe Systems、Zumba Fitness、The Wall Street Journal、ESPN、BBC and top recording artists including Usher、Frank Ocean、Metallica** 等公司，具有丰富的软件实践经验。

**他大多数时间在 San Francisco By Area ，和世界上最美丽的姑娘在一起。**

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
