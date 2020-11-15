> * 原文地址：[5 Useful Things The Spread Operator Can Do in JavaScript](https://medium.com/javascript-in-plain-english/5-useful-things-the-spread-operator-can-do-in-javascript-f0306358bc9c)
> * 原文作者：[Mehdi Aoussiad](https://medium.com/@mehdiouss315)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-useful-things-the-spread-operator-can-do-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-useful-things-the-spread-operator-can-do-in-javascript.md)
> * 译者：[Alfxjx](https://github.com/Alfxjx)
> * 校对者：[HayleyLL](https://github.com/HayleyLL)

# 对象展开运算符在 JavaScript 中的 5 大应用

![Image Created with ❤️️ By Mehdi Aoussiad.](https://cdn-images-1.medium.com/max/3980/1*IhLMLpHPrIWgtsBuh5Tueg.jpeg)

## 简介

对象展开运算符是最近 JavaScript 添加的一个很重要也很有用的新功能。对象展开运算符能够将一个可迭代的 JavaScript 的对象的值进行展开与扩展，它也可以在需要多重参数的时候让我们能够把数组和其他的表达式进行扩展。在多种情况下，对象展开运算符对于以简单的方式编写更好且干净的JavaScript代码非常有用。

在这篇简短的文章中，我们将探讨JavaScript中对象展开运算符`** {…} **`的一些用例。

## 1. 合并两个对象

我们可以在 JavaScript 中使用对象展开运算符来合并两个对象，看一看下面这个例子：

```JavaScript
let employee = { name:'Jhon',lastname:'Doe'};
const salary = { grade: 'A', basic: '$3000' };
const summary = {...employee, ...salary};
console.log(summary);
// Prints: {name: "Jhon", lastname: "Doe", grade: "A", basic: "$3000"}
```

这里的 `**employee**` 和 `**salary**` 对象被合并成了一个，并生成了一个包含了原来两个对象的键值对的新对象。

## 2. 合并数组

对象展开运算符的另一个优点是可以合并数组，或在一个数组的任意索引处插入另一个数组的所有元素。

对象展开的语法使得下面的操作变得异常的简单：

```JavaScript
let thisArray = ['sage', 'rosemary', 'parsley', 'thyme'];

let thatArray = ['basil', 'cilantro', ...thisArray, 'coriander'];
// thatArray now equals ['basil', 'cilantro', 'sage', 'rosemary', 'parsley', 'thyme', 'coriander']
```

通过使用对象展开运算符 `**{…}**` ，我们就能很容易的得到想要的数组。如果使用传统的方法，那么步骤将会变得更加的冗长与复杂。

## 3. 使用对象展开运算符复制数组

我们也可以使用对象展开运算符在 JavaScript 中将一个数组的内容复制到另外一个数组中。看一看下面的这个例子：

```JavaScript
const arr1 = ['JAN', 'FEB', 'MAR', 'APR', 'MAY'];
let arr2;
arr2 = [...arr1];
console.log(arr2); // Prints:[ 'JAN', 'FEB', 'MAR', 'APR', 'MAY' ]
```

如你所见，我们使用对象展开运算符将 `**arr1**` 的全部元素都复制到了另外的一个数组 `**arr2**` 中。

## 4. 计算数组中的最大值

下面的一段 ES5 代码使用 `**apply()**` 来计算得到了数组中的最大值：

```JavaScript
var arr = [6, 89, 3, 45];
var maximus = Math.max.apply(null, arr); // returns 89
```

使用对象展开运算符让这一段代码更易读且更容易维护。看一下下面这个例子：

```JavaScript
const arr = [6, 89, 3, 45];
const maximus = Math.max(...arr); // returns 89
```

`**...arr**` 返回了一个数组元素的集合，也就是说它**展开**了这个数组。

## 5. 将字符串转换成数组

我们可以使用对象展开运算符在 JavScript 中将一个英文单词（字符串）分割成数组，下面的例子展示了它是如何将一个英文单词转化成字母组成的数组的：

```JavaScript
const string = 'word';
const arr = [...string];
console.log(arr); // Prints: ["w", "o", "r", "d"]
```

有很多方法来实现这个功能，但是使用对象展开运算符，更容易写出干净的 JavaScript 代码。

## 结论

对象展开运算符是 JavaScript 中一种很有用的功能。它使用起来很方便，并且能够保持代码的整洁度，便于维护。

感谢阅读这篇文章，希望对您有所帮助。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
