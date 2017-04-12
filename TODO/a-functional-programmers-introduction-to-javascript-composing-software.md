> * 原文地址：[A Functional Programmer’s Introduction to JavaScript (Composing Software)(part 3)](https://medium.com/javascript-scene/a-functional-programmers-introduction-to-javascript-composing-software-d670d14ede30)
> * 原文作者：[Eric Elliott](https://medium.com/@_ericelliott?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[sun](http://suncafe.cc)
> * 校对者：

# 函数式程序员的 JavaScript 简介 (软件构建系列) #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*uVpU7iruzXafhU2VLeH4lw.jpeg">

烟雾艺术模仿 — MattysFlicks — (CC BY 2.0)

> Note: This is part of the “Composing Software” series on learning functional programming and compositional software techniques in JavaScript ES6+ from the ground up. Stay tuned. There’s a lot more of this to come!
> [< Previous](https://medium.com/javascript-scene/why-learn-functional-programming-in-javascript-composing-software-ea13afc7a257#.ia0aq3fmb)  | [<< Start over at Part 1](https://medium.com/javascript-scene/the-rise-and-fall-and-rise-of-functional-programming-composable-software-c2d91b424c8c#.2dfd6n6qe)  | [Next >](https://medium.com/javascript-scene/higher-order-functions-composing-software-5365cf2cbe99#.egoxjg6x7)

对于不熟悉 JavaScript 或 ES6+ 的同学，这里做一个简短的介绍。无论你是 JavaScript 开发新手还是有经验的老兵，你都可能学到一些新东西。以下内容仅是毛羽鳞鬣，吊吊大家的兴致。如果想知道更多，还需深入学习。敬请期待吧。


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

表达式的值可以被赋予一个名称。执行此操作时，表达式首先被计算，取得的结果值被分配给该名称。对于这一点我们将使用 `const` 关键字。这不是唯一的方式，但这将是你使用最多的，所以目前我们就可以坚持使用 `const`。

```
const hello = 'Hello';
hello; // Hello
```

### var、let 和 const ###

JavaScript 支持另外两种变量声明关键字：`var`，还有 `let`。我喜欢根据选择的顺序来考虑它们。默认情况下，我选择最严格的声明方式：`const`。用 `const` 关键字声明的变量不能被重新赋值。最终值必须在声明时分配。这可能听起来很严格，但限制是一件好事。这是个标识在提醒你“赋给这个名称的值将不会改变”。它可以帮你全面了解这个名称的意义，而无需阅读整个函数或块级作用域。

有时，给变量重新赋值很有用。比如，如果你正在写一个手动的强制性迭代，而不是一个更具功能性的方法，你可以迭代一个用 `let` 赋值的计数器。

因为 `var` 能告诉你很少关于这个变量的信息，所以它是最无力的声明标识。自从开始用 ES6，我就再也没在实际软件项目中有意使用 `var` 作声明了。

注意一下，一个变量一旦用 `let` 或 `const` 声明，任何再次声明的尝试都将导致报错。如果你在 REPL（读取-求值-输出循环）环境中更喜欢多一些实验性和灵活性，那么建议你使用 `var` 声明变量，而不是 `const`。

本文将使用 const 来让您习惯于为实际程序中用 `const`，而出于试验的目的自由切换回 `var`。

### 数据类型 ###

目前为止我们见到了两种数据类型：数字和字符串。JavaScript 也有布尔值（`true` 或 `false`）、数组、对象等。稍后我们再看其他类型。

数组是一系列值的有序列表。可以把它比作一个能够装很多元素的盒子。这是一个数组字面量：

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

### Signatures ###

Functions have signatures, which consist of:

1. An *optional* function name.
2. A list of parameter types, in parentheses. The parameters may optionally be named.
3. The type of the return value.

Type signatures don’t need to be specified in JavaScript. The JavaScript engine will figure out the types at runtime. If you provide enough clues, the signature can also be inferred by developer tools such as IDEs (Integrated Development Environment) and [Tern.js](http://ternjs.net/)  using data flow analysis.

JavaScript lacks its own function signature notation, so there are a few competing standards: JSDoc has been very popular historically, but it’s awkwardly verbose, and nobody bothers to keep the doc comments up-to-date with the code, so many JS developers have stopped using it.

TypeScript and Flow are currently the big contenders. I’m not sure how to express everything I need in either of those, so I use [Rtype](https://github.com/ericelliott/rtype), for documentation purposes only. Some people fall back on Haskell’s curry-only [Hindley–Milner types](http://web.cs.wpi.edu/~cs4536/c12/milner-damas_principal_types.pdf) . I’d love to see a good notation system standardized for JavaScript, if only for documentation purposes, but I don’t think any of the current solutions are up to the task, at present. For now, squint and do your best to keep up with the weird type signatures which probably look slightly different from whatever you’re using.

```
functionName(param1: Type, param2: Type) => Type
```

The signature for double is:

```
double(x: n) => n
```

In spite of the fact that JavaScript doesn’t require signatures to be annotated, knowing what signatures *are* and what they *mean* will still be important in order to communicate efficiently about how functions are used, and how functions are composed. Most reusable function composition utilities require you to pass functions which share the same type signature.

### Default Parameter Values ###

JavaScript supports default parameter values. The following function works like an identity function (a function which returns the same value you pass in), unless you call it with `undefined`, or simply pass no argument at all -- then it returns zero, instead:

```
const orZero = (n = 0) => n;
```

To set a default, simply assign it to the parameter with the `=` operator in the function signature, as in `n = 0`, above. When you assign default values in this way, type inference tools such as [Tern.js](http://ternjs.net/) , Flow, or TypeScript can infer the type signature of your function automatically, even if you don't explicitly declare type annotations.

The result is that, with the right plugins installed in your editor or IDE, you’ll be able to see function signatures displayed inline as you’re typing function calls. You’ll also be able to understand how to use a function at a glance based on its call signature. Using default assignments wherever it makes sense can help you write more self-documenting code.

> Note: Parameters with defaults don’t count toward the function’s `.length` property, which will throw off utilities such as autocurry which depend on the `.length` value. Some curry utilities (such as `lodash/curry`) allow you to pass a custom arity to work around this limitation if you bump into it.

### Named Arguments ###

JavaScript functions can take object literals as arguments and use destructuring assignment in the parameter signature in order to achieve the equivalent of named arguments. Notice, you can also assign default values to parameters using the default parameter feature:

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

### Rest and Spread ###

A common feature of functions in JavaScript is the ability to gather together a group of remaining arguments in the functions signature using the rest operator: `...`

For example, the following function simply discards the first argument and returns the rest as an array:

```
const aTail = (head, ...tail) => tail;
aTail(1, 2, 3); // [2, 3]
```

Rest gathers individual elements together into an array. Spread does the opposite: it spreads the elements from an array to individual elements. Consider this:

```
const shiftToLast = (head, ...tail) => [...tail, head];
shiftToLast(1, 2, 3); // [2, 3, 1]
```

Arrays in JavaScript have an iterator that gets invoked when the spread operator is used. For each item in the array, the iterator delivers a value. In the expression, `[...tail, head]`, the iterator copies each element in order from the `tail` array into the new array created by the surrounding literal notation. Since the head is already an individual element, we just plop it onto the end of the array and we're done.

### Currying ###

Curry and partial application can be enabled by returning another function:

```
const highpass = cutoff => n => n >= cutoff;
const gt4 = highpass(4); // highpass() returns a new function
```

You don’t have to use arrow functions. JavaScript also has a `function` keyword. We're using arrow functions because the `function` keyword is a lot more typing. This is equivalent to the `highPass()` definition, above:

```
const highpass = function highpass(cutoff) {
  return function (n) {
    return n >= cutoff;
  };
};
```

The arrow in JavaScript roughly means “function”. There are some important differences in function behavior depending on which kind of function you use (`=>` lacks its own `this`, and can't be used as a constructor), but we'll get to those differences when we get there. For now, when you see `x => x`, think "a function that takes `x` and returns `x`". So you can read `const highpass = cutoff => n => n >= cutoff;` as:

`“highpass` is a function which takes `cutoff` and returns a function which takes `n` and returns the result of `n >= cutoff`".

Since `highpass()` returns a function, you can use it to create a more specialized function:

```
const gt4 = highpass(4);

gt4(6); // true
gt4(3); // false
```

Autocurry lets you curry functions automatically, for maximal flexibility. Say you have a function `add3()`:

```
const add3 = curry((a, b, c) => a + b + c);
```

With autocurry, you can use it in several different ways, and it will return the right thing depending on how many arguments you pass in:

```
add3(1, 2, 3); // 6
add3(1, 2)(3); // 6
add3(1)(2, 3); // 6
add3(1)(2)(3); // 6
```

Sorry Haskell fans, JavaScript lacks a built-in autocurry mechanism, but you can import one from Lodash:

```
$ npm install --save lodash
```

Then, in your modules:

```
import curry from 'lodash/curry';
```

Or, you can use the following magic spell:

```
// Tiny, recursive autocurry
const curry = (
  f, arr = []
) => (...args) => (
  a => a.length === f.length ?
    f(...a) :
    curry(f, a)
)([...arr, ...args]);
```

### Function Composition ###

Of course you can compose functions. Function composition is the process of passing the return value of one function as an argument to another function. In mathematical notation:

```
f . g
```

Which translates to this in JavaScript:

```
f(g(x))
```

It’s evaluated from the inside out:

1. `x` is evaluated
2. `g()` is applied to `x`
3. `f()` is applied to the return value of `g(x)`

For example:

```
const inc = n => n + 1;
inc(double(2)); // 5
```

The value `2` is passed into `double()`, which produces `4`. `4` is passed into `inc()` which evaluates to `5`.

You can pass any expression as an argument to a function. The expression will be evaluated before the function is applied:

```
inc(double(2) * double(2)); // 17
```

Since `double(2)` evaluates to `4`, you can read that as `inc(4 * 4)` which evaluates to `inc(16)` which then evaluates to `17`.

Function composition is central to functional programming. We’ll have a lot more on it later.

### Arrays ###

Arrays have some built-in methods. A method is a function associated with an object: usually a property of the associated object:

```
const arr = [1, 2, 3];
arr.map(double); // [2, 4, 6]
```

In this case, `arr` is the object, `.map()` is a property of the object with a function for a value. When you invoke it, the function gets applied to the arguments, as well as a special parameter called `this`, which gets automatically set when the method is invoked. The `this` value is how `.map()` gets access to the contents of the array.

Note that we’re passing the `double` function as a value into `map` rather than calling it. That's because `map` takes a function as an argument and applies it to each item in the array. It returns a new array containing the values returned by `double()`.

Note that the original `arr` value is unchanged:

```
arr; // [1, 2, 3]
```

### Method Chaining ###

You can also chain method calls. Method chaining is the process of directly calling a method on the return value of a function, without needing to refer to the return value by name:

```
const arr = [1, 2, 3];
arr.map(double).map(double); // [4, 8, 12]
```

A **predicate** is a function that returns a boolean value (`true` or `false`). The `.filter()` method takes a predicate and returns a new list, selecting only the items that pass the predicate (return `true`) to be included in the new list:

```
[2, 4, 6].filter(gt4); // [4, 6]
```

Frequently, you’ll want to select items from a list, and then map those items to a new list:

```
[2, 4, 6].filter(gt4).map(double); [8, 12]
```

Note: Later in this text, you’ll see a more efficient way to select and map at the same time using something called a *transducer*, but there are other things to explore first.

### Conclusion ###

If your head is spinning right now, don’t worry. We barely scratched the surface of a lot of things that deserve a lot more exploration and consideration. We’ll circle back and explore some of these topics in much more depth, soon.

[**Continued in “Higher Order Functions”…**](https://medium.com/javascript-scene/higher-order-functions-composing-software-5365cf2cbe99#.egoxjg6x7)

### Next Steps ###

Want to learn more about functional programming in JavaScript?

[Learn JavaScript with Eric Elliott](http://ericelliottjs.com/product/lifetime-access-pass/). If you’re not a member, you’re missing out!

[<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*3njisYUeHOdyLCGZ8czt_w.jpeg">
](https://ericelliottjs.com/product/lifetime-access-pass/)


***Eric Elliott*** is the author of [*“Programming JavaScript Applications”*](http://pjabook.com)  (O’Reilly), and [*“Learn JavaScript with Eric Elliott”*](http://ericelliottjs.com/product/lifetime-access-pass/) . He has contributed to software experiences for **Adobe Systems, Zumba Fitness, The Wall Street Journal, ESPN, BBC and top recording artists including Usher, Frank Ocean, Metallica**, and many more.

*He spends most of his time in the San Francisco Bay Area with the most beautiful woman in the world.*

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
