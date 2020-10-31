> * 原文地址：[JavaScript ES2021 Exciting Features](https://codeburst.io/exciting-features-of-javascript-es2021-es12-1de8adf6550b)
> * 原文作者：[Taran](https://medium.com/@taranpreet_94321)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/exciting-features-of-javascript-es2021-es12.md](https://github.com/xitu/gold-miner/blob/master/article/2020/exciting-features-of-javascript-es2021-es12.md)
> * 译者：
> * 校对者：

# JavaScript ES2021 Exciting Features

![](https://cdn-images-1.medium.com/max/2000/1*TK3lUqXrmh82x3Mjb3Oa0A.png)

Every year, JavaScript update adds new features. This year ES2020 or ES11 was released ([Read ES2020 features article](https://codeburst.io/javascript-es2020-is-here-360a8304b0e6)), with ES2021 or ES12 expected to be released in mid-2021.

New features that are added to JavaScript each year go through a four-stage process, with the fourth stage being the last one. In this article, I will discuss the features that have already reached stage four and are added to the Google Chrome V8 engine.

#### List of the new features discussed in this article

* String.prototype.replaceAll
* Promise.any
* Logical Operators and Assignment Expressions
* Numeric Separators
* Intl.ListFormat
* dateStyle and timeStyle options for Intl.DateTimeFormat

---

## String.prototype.replaceAll

In JavaScript, **replace()** method only replaces the first instance of a pattern in a string. If we want to replace all the matches of a pattern in a string, the only way to achieve that is by using global regexp.

The proposed method **replaceAll()** returns a new string with all matches of a pattern replaced by a replacement. The pattern can be a string or a regular expression, and the replacement can be a string or a function that gets executed for each match.

```JavaScript
let str = 'I use linux, I love linux'
str = str.replaceAll('linux', 'windows');

console.log(str)

/****  Output  ****/
// I use windows, I love windows

```

---

## Promise.any

ES2021 will introduce **Promise.any()** method which short-circuits and returns a value, as soon as it hits the first resolved promise from the list/array of promises **(as explained in Example 1a)**. If all the promises are rejected then it will throw an aggregated error message **(as illustrated in Example 1b)**.

It is different from **[Promise.race()](https://codeburst.io/javascript-promise-methods-introduction-cb0379e9dad)** as that method short-circuits once one of the given promises either resolves or rejects.

****Example 1a**: Even though a promise is rejected earlier than a resolved promise, **Promise.any()** will return the first resolved promise.**

```JavaScript
Promise.any([
  new Promise((resolve, reject) => setTimeout(reject, 200, 'Third')),
  new Promise((resolve, reject) => setTimeout(resolve, 1000, 'Second')),
  new Promise((resolve, reject) => setTimeout(resolve, 2000, 'First')),
])
.then(value => console.log(`Result: ${value}`))
.catch (err => console.log(err))

/****  Output  ****/
// Result: Second
```

****Example 1b**: When all the promises are rejected, AggregateError is thrown.**

```JavaScript
Promise.any([
  Promise.reject('Error 1'),
  Promise.reject('Error 2'),
  Promise.reject('Error 3')
])
.then(value => console.log(`Result: ${value}`))
.catch (err => console.log(err))

/****  Output  ****/
// AggregateError: All promises were rejected
```

---

## Logical Operators and Assignment Expressions

In JavaScript, there are many assignment operators and Logical operators like the following basic example:

```
// Assignment Operator Example
let num = 5
num+=10
console.log(num) // 15

// Logical Operator Example

let num1 = 6
let num2 = 3

console.log(num1 === 6 && num2 === 2) // false
console.log(num1 === 6 || num2 === 2) // true
```

With the new proposal, we will be able to combine logical operators and assignment operators. Below are some examples of &&, || and ?? operators:

#### Logical Assignment Operator with && operator

It assign RHS variable value to LHS variable, only if LHS value is truthy.

```JavaScript
// Logical Assignment Operator with && operator
let num1 = 5
let num2 = 10

num1 &&= num2

console.log(num1) // 10

// Line 5 can also be written as following ways
// 1. num1 && (num1 = num2)
// 2. if (num1) num1 = num2
```

#### Logical Assignment Operator with || operator

It assign RHS variable value to LHS variable, only if LHS value is falsy.

```JavaScript
// Logical Assignment Operator with || operator
let num1
let num2 = 10

num1 ||= num2

console.log(num1) // 10

// Line 5 can also be written as following ways
// 1. num1 || (num1 = num2)
// 2. if (!num1) num1 = num2
```

#### Logical Assignment Operator with ?? operator

[ES2020 ](https://codeburst.io/javascript-es2020-is-here-360a8304b0e6)has introduced the Nullish Coalescing operator, this operator can be combined with assignment operators as well. It assign RHS variable value to LHS variable, only if LHS is undefined or null only.

```JavaScript
// Logical Assignment Operator with ?? operator
let num1
let num2 = 10

num1 ??= num2
console.log(num1) // 10

num1 = false
num1 ??= num2
console.log(num1) // false

// Line 5 can also be written as following ways
// num1 ?? (num1 = num2)
```

---

## Numeric Separators

The introduction of Numeric Separators will make it easier to read numeric values by using the `_` (underscore) character to provide a separation between groups of digits. For example:

```JavaScript
let number = 100_000 

console.log(number)

/****  Output  ****/
// 100000
```

---

## Intl.ListFormat

The ListFormat Object takes two parameters, both of them are optional. First parameter is language (locale) and second parameter is an options object that has two properties — style and type.

```
new Intl.ListFormat([locales[, options]])
```

The Intl.ListFormat has a method called **format()**, which receives an array as an argument and format it in different ways that are language dependent.

Given below are some examples which has combination of different locales and options.

```JavaScript
const arr = ['Pen', 'Pencil', 'Paper']

let obj = new Intl.ListFormat('en', { style: 'short', type: 'conjunction' })
console.log(obj.format(arr)) 

/****  Output  ****/
// Pen, Pencil, & Paper


obj = new Intl.ListFormat('en', { style: 'long', type: 'conjunction' })
console.log(obj.format(arr)) 

/****  Output  ****/
// Pen, Pencil, and Paper


obj = new Intl.ListFormat('en', { style: 'narrow', type: 'conjunction' })
console.log(obj.format(arr)) 

/****  Output  ****/
// Pen, Pencil, Paper


// Passing in Italy language tag
obj = new Intl.ListFormat('it', { style: 'short', type: 'conjunction' })
console.log(obj.format(arr)) 

/****  Output  ****/
// Pen, Pencil e Paper


// Passing in German language tag
obj = new Intl.ListFormat('de', { style: 'long', type: 'conjunction' })
console.log(obj.format(arr)) 

/****  Output  ****/
// Pen, Pencil und Paper
```

---

## dateStyle and timeStyle options for Intl.DateTimeFormat

The Intl.DateTimeFormat object is a constructor for objects that enable language-sensitive date and time formatting. The proposed **dateStyle** and **timeStyle** options can be used to request a locale-specific date and time of a given length.

Some examples of different options and language(locale) are illustrated below:

```JavaScript
// Time only with short format
let o = new Intl.DateTimeFormat('en' , { timeStyle: 'short' })
console.log(o.format(Date.now()))
// 11:27 PM


// Time only with medium format
o = new Intl.DateTimeFormat('en' , { timeStyle: 'medium'})
console.log(o.format(Date.now()))
// 11:27:57 PM


// Time only with long format
o = new Intl.DateTimeFormat('en' , { timeStyle: 'long' })
console.log(o.format(Date.now()))
// 11:27:57 PM GMT+11


// Date only with short format
o = new Intl.DateTimeFormat('en' , { dateStyle: 'short'})
console.log(o.format(Date.now()))
// 10/6/20


// Date only with medium format
o = new Intl.DateTimeFormat('en' , { dateStyle: 'medium'})
console.log(o.format(Date.now()))
// Oct 6, 2020


// Date only with long format
o = new Intl.DateTimeFormat('en' , { dateStyle: 'long'})
console.log(o.format(Date.now()))
// October 6, 2020

```

**dateStyle** and **timeStyle** options used together with different language tags, as shown in the example below:

```JavaScript
let abc

// English language
abc = new Intl.DateTimeFormat('en' , { timeStyle: 'short', dateStyle: 'long'})
console.log(abc.format(Date.now()))
// October 6, 2020 at 11:40 PM


// Italian language
abc = new Intl.DateTimeFormat('it' , { timeStyle: 'short', dateStyle: 'long'})
console.log(abc.format(Date.now()))
// 6 ottobre 2020 23:40


// German language
abc = new Intl.DateTimeFormat('de' , { timeStyle: 'short', dateStyle: 'long'})
console.log(abc.format(Date.now()))
// 6. Oktober 2020 um 23:40
```

---

## Conclusion

As a developer, it is important to stay up to date with the new features of a language. If you have missed the ES2020 features update, I recommend that you read this article — [ES2020 has Arrived](https://codeburst.io/javascript-es2020-is-here-360a8304b0e6).

Thank you for reading, please comment below if there is a topic that you would like me to cover!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
