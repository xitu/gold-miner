> * 原文地址：[6 of the Most Exciting ES6 Features in Node.js v6 LTS](https://nodesource.com/blog/six-of-the-most-exciting-es6-features-in-node-js-v6-lts?utm_source=nodeweekly&utm_medium=email)
* 原文作者：[Tierney Coren](https://nodesource.com/blog/author/bitandbang)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：

# 6 of the Most Exciting ES6 Features in Node.js v6 LTS

# Node.js v6 LTS 中最激动人心的六个 ES6 特性

With the release of [Node.js v6 LTS "Boron"](https://nodesource.com/blog/need-to-node-recap-introducing-node-js-v6-lts-boron), there were a suite of updates to Node.js core APIs and its dependencies. The update to V8, the JavaScript engine from Chromium that is at the root of Node.js, is important - it brings [almost complete](http://node.green) support for something that's near and dear to a lot of Node.js and JavaScript developer's hearts: ES6.

随着 [Node.js v6 LTS "Boron"](https://nodesource.com/blog/need-to-node-recap-introducing-node-js-v6-lts-boron) 的发布，Node.js 的核心 API 和依赖关系得到了全面的改进。基于 Chromium 的 JavaScript 引擎的 Node.js V8 的更新非常重要，它具备对 Node.js 和 JavaScript 开发者心灵相依的 ES6 的几乎全方位的支持。

With this article, we'll take a look at six of the best new ES6 features that are in the Node.js v6 LTS release.

这篇文章中，我们将一起了解 Node.js v6 LTS 版本中的六个最新的 ES6 特性。

## Setting defaults for function parameters

## 给函数设置默认参数

The new [default parameters feature](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Default_parameters) for functions enable a default value to be set for function arguments when the function is initially defined.

新的 [默认函数特性](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Default_parameters)让函数在初始化定义的时候能够设置一个默认的参数值。

The addition of default function parameters to ES6, and subsequently Node core, doesn’t necessarily add new functionality that couldn’t have been achieved previously. That said, they are first-class support for configurable argument values, which enables us build more consistent and less opinionated code, across the entire ecosystem.

ES6 中函数默认参数特性和随后节点核心内容的增加，并没有必然地增加以前没有实现的功能。也就是说，这些对自定义参数值的最高级的支持让我们在整个应用生态中能够写出更加协调一致的代码。

To get default values for function parameters previously, you would have had to do something along the lines of this:

以前为了设置函数默认参数，你必须这样做：

    function toThePower(val, exponent) {
      exponent = exponent || 2

      // ...

    }

Now, with the new default parameters feature, the parameters can be defined, and defaulted, like this:

现在利用新特性，可以这样定义参数并设置默认值：

    function toThePower(value, exponent = 2) {
      // 内部代码略
    }

    toThePower(1, undefined) // exponent 默认设置为 2

## Extracting Data from Arrays and Objects with Destructuring

## 用解构的方式提取数组和对象的数据

[Destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) of arrays and objects gives developers the ability to extract values from either, and then expose them as distinct variables. Destructuring has a wide variety of uses - including cases like where specific values are wanted from a larger set. It provides a method to get that value in a concise way from a built-in feature in the language itself.

[解构](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)数组和对象使得开发者能够从两者中获取值并将其以变量的形式展现。解构有着非常广泛的应用——包括需要从大集合中获取特定的值之类的情况，提供一种简单的方法能够在语言内置特征中获取值。

The destructuring object syntax is with curly braces (`{}`), and the destructuring array syntax is with square brackets (`[]`)

解构对象的语法要求用花括号（`{}`），解构数组的语法要求用方括号（`[]`）。

*   数组: `const [one, two] = [1, 2]`
*   对象: `const {a, b} = { a: ‘a’, b: ‘b’ }`
*   默认: `const {x = ‘x’, y} = { y: ‘y’ }`

## 解构实例 1：

    // 伪元素
    function returnsTuple() {
      return [name, data]
    }

    const [name, data] = returnsTuple()

## 解构实例 2：

    const threeValuesIn [,,,three, four, five] = my_array_of_10_elements

## 解构实例 3：

ES5 中获取对象值的方法:

    var person = {
      name: "Gumbo", 
      title: "Developer", 
      data: "yes" 
    }

    var name = person.name
    var title = person.title
    var data = person.data

ES6 中利用解构获取对象值的方法：

    const { name, title, data } = person

## Checking Array Values with Array#includes()

## 利用 Array#includes() 检查数组的值

The built-in [`.includes()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes) method for Arrays (protip: the # means it's a [prototype method](https://twitter.com/bitandbang/status/792113575804272640), and can be called on arrays) is a simple way to check a value against an array to see if it is included somewhere inside of that array. The method will return `true` if the array does indeed contain the specified value. Thankfully, you can now say goodbye to `array.indexOf(item) === -1` forever.

内置的 [`.includes()`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/includes) 数组方法（提示：# 表示这是一个[内置方法](https://twitter.com/bitandbang/status/792113575804272640), and can be called on arrays)，可以用于数组）能够非常简单地检查数组中是否包含某个值。如果属组中包含某个特定的值，该方法将会返回 `true`。庆幸吧，你可以和 `array.indexOf(item) === -1` 永别了。

    [1, 2].includes(1) // 返回 true

    [1, 2].includes(4) // 返回 false

[Rest parameters](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters) give functions the ability to collect additional arguments outside of the parameters that it has predefined. The contents of these arguments are then collected into an array. This allows a function to capture and parse additional arguments to enable some extended functionality, with far more options for optimization than previously available via the `arguments` object.

[多余参数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters) 使得函数能够获取预定义参数之外的参数，这些参数将会被收录在一个数组中。同时可以利用方法来获取并解析这些多余的参数，并且实现一些扩展功能，这要比之前通过 `arguments` 对象来处理具有更多的优选项。（类似于 PHP 中的可变参数函数，即传入的参数数目大于函数定义的参数数目，可以通过特定的函数获取这些参数并另作他用。译者注）

Rest parameters also work with arrow functions - this is fantastic, because arrow functions did not have the ability to get this previously as the `arguments` object does not exist within arrow functions.

多余函数同样适用于箭头函数——这简直棒极了，箭头函数之前并没有这种功能，因为箭头函数中不存在 `arguments` 对象。

    function concat(joiner, ...args) {

      // 参数实际上是一个数组

      return args.join(joiner)

    }

    concat(‘_’, 1, 2, 3) // 返回 ‘1_2_3’

## Expanding Arrays with the Spread Operator

## 用展开运算符展开数组

The [spread operator](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator) is a diverse tool that’s now native to JavaScript. It is a useful as a utility to expand an array into parameters for functions or array literals. One case where this is immensely useful, for example, is in cases where values are reused - the spread allows them to be stored and called with a much smaller footprint than previously needed.

[展开运算符](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator)是一款 JavaScript 中原生的多元化工具。它非常实用，可以将数组展开成函数的参数或者数组常量。举个例子，它的神通广大之处在于当你需要重复使用一些值的时候，展开运算会将其存储起来，并且调用的时候会比之前占用更少的内存。

Using the spread operator in function parameters:

在函数参数中使用展开运算符：

    const numbersArray = [1, 2, 3]
    coolFunction(...numbersArray)

    // same as
    coolFunction(1, 2, 3)

Using the spread operator in array literal parameters:

在数组常量中使用展开运算符：

    const arr1 = [1, 2]

    const arr2 = [...arr1, 3, 4]
    // arr2: [1, 2, 3, 4]

One interesting feature of the Spread operator is its interaction with Emoji. Wes Bos [shared](https://twitter.com/wesbos/status/769228067780825088) an interesting use for the spread operator that gives a very visual example of how it can be used - with Emoji. Here’s an example of that:

展开运算符还有一个有趣的特性，可以和 Emoji 交互。Wes Bos [shared](https://twitter.com/wesbos/status/769228067780825088) 了一个展开运算符的有趣的用法，一个非常形象的和 Emoji 的使用实例。其中一个例子：

![Emoji 鱼与 JavaScript 的展开运算符](https://images.contentful.com/hspc7zpa5cvq/2gYkLeavHOcAEaOyoqAqeq/498511fff19e56f1898aaa8e3d6d2a65/Emoji_and_the_JavaScript_Spread_Operator.png)

Note that neither Hyperterm nor Terminal.app (on an older OS X version) would actually render the new, compound Emoji correctly - it's an interesting example of how JavaScript and Node live on the edge.

提醒一下，Hyperterm 或者 Terminal.app （OS X 上的一个老版本）都不能正确显示新版的 Emoji —— 那只是一个 JavaScript 和 Node 用在一些边缘领域的有趣的例子而已。

## Naming of anonymous functions

## 给匿名函数命名

In ES6, anonymous functions receive a `name` property. This property is extremely useful when debugging issues with an application - for example, when you get a stack trace caused by an anonymous function, you will be able to get the `name` of that anonymous function.

ES6 中，匿名函数可以接受一个 `name` 属性，这个属性在调试问题中极其有用——比如，当你得到了一个匿名函数导致的堆栈轨迹时，你将能够的到该匿名函数的 `name` 值。

This is dramatically more helpful than recieving `anonymous` as part of the stack trace, as you would have in ES5 and before, as it gives a precise cause instead of a generic one.

相比于在 ES5 或之前的版本中你只能够得到堆栈轨迹的 `anonymous` 信息，ES6 的这个特性显得尤为引人注目，它给出了一个明确的原因，而不是泛泛而谈。

    var x = function() { }; 

    x.name // 返回 'x'

## One last thing…

## 写在最后

If you’d like to learn more about the changes to Node.js when the v6 release line became LTS, you can check out our blog post: [The 10 Key Features in Node.js v6 LTS Boron After You Upgrade](https://nodesource.com/blog/the-10-key-features-in-node-js-v6-lts-boron-after-you-upgrade).

如果你想学习 Node.js 在 v6 版本升级为长期支持版（LTS）中有哪些更多的改变，请查看我们的博文： [升级之后，Node.js v6 LTS 的十个关键特性](https://nodesource.com/blog/the-10-key-features-in-node-js-v6-lts-boron-after-you-upgrade)。

Otherwise, for more updates about Node, JavaScript, ES6, Electron, npm, yarn, and more, you should follow [@NodeSource](https://twitter.com/nodesource) on Twitter. We're always around and would love to hear from _you_!

或者，想获取更多 Node、JavaScript、ES6、Electron、npm、yarn 或者其他内容的更新，请关注[@NodeSource](https://twitter.com/nodesource) 的 Twitter。非常乐意收到您的消息，我们一直都在！