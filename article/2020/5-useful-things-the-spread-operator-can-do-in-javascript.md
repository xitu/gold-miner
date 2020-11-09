> * 原文地址：[5 Useful Things The Spread Operator Can Do in JavaScript](https://medium.com/javascript-in-plain-english/5-useful-things-the-spread-operator-can-do-in-javascript-f0306358bc9c)
> * 原文作者：[Mehdi Aoussiad](https://medium.com/@mehdiouss315)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/5-useful-things-the-spread-operator-can-do-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2020/5-useful-things-the-spread-operator-can-do-in-javascript.md)
> * 译者：
> * 校对者：

# 5 Useful Things The Spread Operator Can Do in JavaScript

![Image Created with ❤️️ By Mehdi Aoussiad.](https://cdn-images-1.medium.com/max/3980/1*IhLMLpHPrIWgtsBuh5Tueg.jpeg)

## Introduction

The spread operator is one of the important and useful features that has been added to JavaScript. It basically spreads or expands the value of an iterable object in JavaScript. It also allows us to expand arrays and other expressions in places where multiple parameters or elements are expected. There are multiple scenarios where the spread operator can be very useful to write a better and clean JavaScript code in an easy way.

In this short article, we will explore some use cases of the spread operator `**{…}** `in JavaScript.

## 1. Combine Two Objects

We can merge two objects using the spread operator in JavaScript. Have a look at the example below:

```JavaScript
let employee = { name:'Jhon',lastname:'Doe'};
const salary = { grade: 'A', basic: '$3000' };
const summary = {...employee, ...salary};
console.log(summary);
// Prints: {name: "Jhon", lastname: "Doe", grade: "A", basic: "$3000"}
```

Here `**employee**` and `**salary**` objects are merged together and that produces a new object with merged key-value pairs.

## 2. Combine Arrays

Another advantage of the spread operator is the ability to combine arrays, or to insert all the elements of one array into another, at any index.

The Spread syntax makes the following operation extremely simple:

```JavaScript
let thisArray = ['sage', 'rosemary', 'parsley', 'thyme'];

let thatArray = ['basil', 'cilantro', ...thisArray, 'coriander'];
// thatArray now equals ['basil', 'cilantro', 'sage', 'rosemary', 'parsley', 'thyme', 'coriander']
```

Using the spread operator `**{…}**` , we have just achieved what we wanted in a simple way. That would have been more complex and more verbose if we had used traditional methods.

## 3. Copying Arrays Using the Spread Operator

We can also copy the content of an array in JavaScript to another array using the spread operator. You can have a look at the example below:

```JavaScript
const arr1 = ['JAN', 'FEB', 'MAR', 'APR', 'MAY'];
let arr2;
arr2 = [...arr1];
console.log(arr2); // Prints:[ 'JAN', 'FEB', 'MAR', 'APR', 'MAY' ]
```

As you can see, we have copied all contents of `**arr1**` into another array `**arr2**` using the spread operator.

## 4. Get the Maximum Value of an Array

The ES5 code below uses `**apply()**` to compute the maximum value in an array:

```JavaScript
var arr = [6, 89, 3, 45];
var maximus = Math.max.apply(null, arr); // returns 89
```

The spread operator makes this syntax much better to read and maintain. Have a look at the example below:

```JavaScript
const arr = [6, 89, 3, 45];
const maximus = Math.max(...arr); // returns 89
```

The `**...arr**` returns an unpacked array. In other words, it **spreads** the array.

## 5. Convert a String to an Array

We can split a word(string) into an array of characters using the spread operator in JavaScript. The following example converts a string to an array of characters:

```JavaScript
const string = 'word';
const arr = [...string];
console.log(arr); // Prints: ["w", "o", "r", "d"]
```

There are many ways to do that, but the spread operator makes it easier with a clean JavaScript code.

## Conclusion

The spread operator is one of the useful features in JavaScript. It is easy to use and it also keeps our code clean, and easy to maintain.

Thank you for reading this article, I hope you found it useful.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
