> * 原文地址：[JavaScript ES2021 Exciting Features](https://codeburst.io/exciting-features-of-javascript-es2021-es12-1de8adf6550b)
> * 原文作者：[Taran](https://medium.com/@taranpreet_94321)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/exciting-features-of-javascript-es2021-es12.md](https://github.com/xitu/gold-miner/blob/master/article/2020/exciting-features-of-javascript-es2021-es12.md)
> * 译者：[tonylua](https://github.com/tonylua)
> * 校对者：[samyu2000](https://github.com/samyu2000), [@HurryOwen](https://github.com/HurryOwen)

# JavaScript ES2021 中激动人心的特性

![](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b62ca0ebbcd0499fa895e95e85e68bc7~tplv-k3u1fbpfcp-watermark.image)

每年，JavaScript 都会增添新的特性。今年的 ES2020 或称 ES11 业已发布 ([参阅这篇 ES2020 特性的文章](https://codeburst.io/javascript-es2020-is-here-360a8304b0e6))，而 ES2021 或者说是 ES12 预计将于 2021 年中旬发布。

每年被增添到 JavaScript 中的特性都会经历一个四阶段的过程，第四阶段也就是最终的一个。在本文中，我将讨论已经到达第四阶段并已被增添到 Google Chrome V8 引擎中的特性。

#### 本文讨论新特性的列表

* String.prototype.replaceAll
* Promise.any
* 逻辑操作符和赋值表达式
* 数值分隔符
* Intl.ListFormat
* Intl.DateTimeFormat 的 dateStyle 和 timeStyle 选项 

## String.prototype.replaceAll

在 JavaScript 中，**replace()** 方法仅替换一个字符串中某模式（pattern）的首个实例。如果我们要替换一个字符串中某模式的所有匹配项，唯一的方法就是使用有全局标记的正则。

拟议的方法 **replaceAll()** 会返回一个新字符串，该字符串中用一个替换项替换了原字符串中所有匹配了某模式的部分。模式可以是一个字符串或一个正则表达式，而替换项可以是一个字符串或一个应用于每个匹配项的函数。

```JavaScript
let str = 'I use linux, I love linux'
str = str.replaceAll('linux', 'windows');

console.log(str)

/****  输出  ****/
// I use windows, I love windows
```

## Promise.any

ES2021 将引入 **Promise.any()** 方法，一旦该方法从 promise 列表或数组中命中首个 resolve 的 promise **（正如 Example 1a 中所解释的那样）**，就会短路并返回一个值。如果所有 promise 都被 reject ，该方法则将抛出一个聚合的错误信息 **（在 Example 1b 里有所展示）**。

其区别于 **[Promise.race()](https://codeburst.io/javascript-promise-methods-introduction-cb0379e9dad)** 之处在于，后者在某个 promise 率先 resolve 或 reject 后都会短路。

****Example 1a**: 尽管某个 promise 的 reject 早于另一个 promise 的 resolve，**Promise.any()** 仍将返回那个首先 resolve 的 promise。**

```JavaScript
Promise.any([
  new Promise((resolve, reject) => setTimeout(reject, 200, 'Third')),
  new Promise((resolve, reject) => setTimeout(resolve, 1000, 'Second')),
  new Promise((resolve, reject) => setTimeout(resolve, 2000, 'First')),
])
.then(value => console.log(`Result: ${value}`))
.catch (err => console.log(err))

/****  输出  ****/
// Result: Second
```

****Example 1b**: 当所有 promise 都被 reject 后，AggregateError 即被抛出。**

```JavaScript
Promise.any([
  Promise.reject('Error 1'),
  Promise.reject('Error 2'),
  Promise.reject('Error 3')
])
.then(value => console.log(`Result: ${value}`))
.catch (err => console.log(err))

/****  输出  ****/
// AggregateError: All promises were rejected
```

## 逻辑操作符和赋值表达式

在 JavaScript 中，有许多赋值表达式和逻辑操作符，如下所示：

```js
// 赋值表达式例子
let num = 5
num+=10
console.log(num) // 15

// 逻辑操作符例子

let num1 = 6
let num2 = 3

console.log(num1 === 6 && num2 === 2) // false
console.log(num1 === 6 || num2 === 2) // true
```

在新提案里，我们将有能力结合逻辑操作符和赋值表达式。下面是一些 `&&`、 `||` 和 `??` 的例子：

#### `&&` 逻辑赋值操作符

该操作符用来在仅当左侧（译注：原文为 LHS，即 Left-hand Side）变量为真值（truthy）时，才将右侧（RHS）变量赋值给左侧变量。

```JavaScript
// `&&` 逻辑赋值操作符
let num1 = 5
let num2 = 10

num1 &&= num2

console.log(num1) // 10

// 行 5 也可写作以下方式
// 1. num1 && (num1 = num2)
// 2. if (num1) num1 = num2
```

#### `||` 逻辑赋值操作符

该操作符用来在仅当左侧变量为虚值（falsy）时，才将右侧变量赋值给左侧变量。

```JavaScript
// `||` 逻辑赋值操作符
let num1
let num2 = 10

num1 ||= num2

console.log(num1) // 10

// 行 5 也可写作以下方式
// 1. num1 || (num1 = num2)
// 2. if (!num1) num1 = num2
```

#### `??` 逻辑赋值操作符

[ES2020](https://codeburst.io/javascript-es2020-is-here-360a8304b0e6) 已经引入了空值合并操作符（Nullish Coalescing operator，即 `??`），该操作符亦可与赋值表达式结合。在仅当左侧变量为 undefined 或 null 时，该操作符才将右侧变量赋值给左侧变量。

```JavaScript
// `??` 逻辑赋值操作符
let num1
let num2 = 10

num1 ??= num2
console.log(num1) // 10

num1 = false
num1 ??= num2
console.log(num1) // false

// 行 5 也可写作以下方式
// num1 ?? (num1 = num2)
```

## 数值分隔符

数字分隔符（Numeric Separators）的引入将通过使用 `_`（下划线）符号在数字分组间提供一个隔离以便于阅读数值。例如：

```JavaScript
let number = 100_000 

console.log(number)

/****  输出  ****/
// 100000
```

## Intl.ListFormat

ListFormat 对象的构造方法有两个参数，皆为可选。首个参数是一个语言标识（locale），而第二个参数是一个选项对象 -- 包含了 style 和 type 两个属性。


```JavaScript
new Intl.ListFormat([locales[, options]])
```

Intl.ListFormat 有一个叫做 **format()** 的方法，接受一个数组作为参数，并因 locale 和选项而异以相应的方式格式化该参数数组。

以下给出的是一些结合了不同 locale 和选项的例子。

```JavaScript
const arr = ['Pen', 'Pencil', 'Paper']

let obj = new Intl.ListFormat('en', { style: 'short', type: 'conjunction' })
console.log(obj.format(arr)) 

/****  输出  ****/
// Pen, Pencil, & Paper


obj = new Intl.ListFormat('en', { style: 'long', type: 'conjunction' })
console.log(obj.format(arr)) 

/****  输出  ****/
// Pen, Pencil, and Paper


obj = new Intl.ListFormat('en', { style: 'narrow', type: 'conjunction' })
console.log(obj.format(arr)) 

/****  输出  ****/
// Pen, Pencil, Paper


// 传入意大利语标识
obj = new Intl.ListFormat('it', { style: 'short', type: 'conjunction' })
console.log(obj.format(arr)) 

/****  输出  ****/
// Pen, Pencil e Paper


// 传入德语标识
obj = new Intl.ListFormat('de', { style: 'long', type: 'conjunction' })
console.log(obj.format(arr)) 

/****  输出  ****/
// Pen, Pencil und Paper
```

## Intl.DateTimeFormat 的 dateStyle 和 timeStyle 选项

Intl.DateTimeFormat 对象是一个支持语言敏感日期和时间格式化的构造器。拟议的 **dateStyle** 和 **timeStyle** 选项可被用于获取一个 locale 特有的日期和给定长度的时间。

一些不同选项和语言（locale）的例子展示在此：

```JavaScript
// 短格式的时间
let o = new Intl.DateTimeFormat('en' , { timeStyle: 'short' })
console.log(o.format(Date.now()))
// 11:27 PM


// 中等格式的时间
o = new Intl.DateTimeFormat('en' , { timeStyle: 'medium'})
console.log(o.format(Date.now()))
// 11:27:57 PM


// 长格式的时间
o = new Intl.DateTimeFormat('en' , { timeStyle: 'long' })
console.log(o.format(Date.now()))
// 11:27:57 PM GMT+11


// 短格式的日期
o = new Intl.DateTimeFormat('en' , { dateStyle: 'short'})
console.log(o.format(Date.now()))
// 10/6/20


// 中等格式的日期
o = new Intl.DateTimeFormat('en' , { dateStyle: 'medium'})
console.log(o.format(Date.now()))
// Oct 6, 2020


// 长格式的日期
o = new Intl.DateTimeFormat('en' , { dateStyle: 'long'})
console.log(o.format(Date.now()))
// October 6, 2020
```

**dateStyle** 和 **timeStyle** 选项共用并结合不同语言标识的例子，如下所示：

```JavaScript
let abc

// 英语
abc = new Intl.DateTimeFormat('en' , { timeStyle: 'short', dateStyle: 'long'})
console.log(abc.format(Date.now()))
// October 6, 2020 at 11:40 PM


// 意大利语
abc = new Intl.DateTimeFormat('it' , { timeStyle: 'short', dateStyle: 'long'})
console.log(abc.format(Date.now()))
// 6 ottobre 2020 23:40


// 德语
abc = new Intl.DateTimeFormat('de' , { timeStyle: 'short', dateStyle: 'long'})
console.log(abc.format(Date.now()))
// 6. Oktober 2020 um 23:40
```

## 总结

作为一个开发者，追踪一门语言的新特性很重要。若你错过了 ES2020 中更新的特性，我推荐你阅读这篇文章 -— [ES2020 已至](https://codeburst.io/javascript-es2020-is-here-360a8304b0e6)。

感谢你的阅读，如果你有感兴趣的主题，请在下方评论！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
