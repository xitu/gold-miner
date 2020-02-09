> * 原文地址：[Stop Using === Everywhere](https://medium.com/better-programming/stop-using-everywhere-fd025342132d)
> * 原文作者：[Seifeldin Mahjoub](https://medium.com/@seif.sayed)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/stop-using-everywhere.md](https://github.com/xitu/gold-miner/blob/master/TODO1/stop-using-everywhere.md)
> * 译者：
> * 校对者：

# Stop Using === Everywhere

#### An unpopular opinion, let’s take a look

![Photo by [JC Gellidon](https://unsplash.com/@jcgellidon?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/stop?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/8480/1*ofXvrzbMMofNyhgXuY7dYw.jpeg)

Many developers always use `===` in favor of `==` but why?

Most of the tutorials I have seen online suggest that it’s too complicated to predict how JavaScript coercions work and therefore advise to always `===`.

There are several tutorials supporting incorrect information and myths on the internet. In addition to that, many linting rules and popular websites are opinionated towards always preferring `===`.

These all lead to lots of programmers excluding part of the language and treating it as a defect instead of expanding their understanding.

Here are two use cases where it’s better to use `==` to illustrate the point.

---

## 1. Testing for Empty Values

```
if (x == null)

vs

if (x === undefined || x === null)
```

---

## 2. Reading Input From a User

```JavaScript
let userInput = document.getElementById('amount');
let amount = 999;
if (amount == userInput)
vs
if (amout === Number(userInput))
```

In this article, we will dive deep into understanding this topic by discovering the differences, understanding coercion, looking at some popular use cases, and, finally, having a guideline to help us make the decision.

---

## Introduction

In Javascript, equality is done by two operators.

1. `=== `— Strict equality comparison a.k.a. triple equals.
2. `==`— Abstract equality comparison a.k.a. double equals.

I have always been using `===`since I was informed that it is better and superior to the `==` and that I didn’t have to think about it at all, which, as a lazy person, I found very convenient.

This was until I watched “Deep JavaScript Foundations” on [Frontend Masters](undefined) by [Kyle](undefined) or [@getfiy](https://twitter.com/getify) author of [**You Don’t Know JS**](https://github.com/getify/You-Dont-Know-JS).

The fact that as a professional programmer, I didn’t think deeply about one of the operators I use every day at work motivated me to spread awareness and encourage people to understand more and be mindful of the code we write.

---

## Where Is the Source of Truth

It’s important to know where the truth is. It’s not on Mozilla’s, W3schools, not in the hundred articles that claim `===` is better than `==`, and it’s definitely not in this one.

It's in the ****JavaScript specifications, where you can find the documentation on how JavaScript works.
[**ECMAScript® 2020 Language Specification**
**Edit description**tc39.es](https://tc39.es/ecma262/#sec-abstract-equality-comparison)

---

## Busting the Myths

#### 1. == checks for values only (loose)

If we look at the specification, it’s very clear from the definition that the first thing the algorithm does is, in fact, check for the type.

![](https://cdn-images-1.medium.com/max/2596/1*vtLIMvTkIe-4RlSEmzoiSA.png)

#### 2. === Checks for values and types (strict)

Here we can likewise see from the specification that it checks the types, and if they are different, it does not examine the value at all.

![](https://cdn-images-1.medium.com/max/2692/1*Z3tOiO0nvNEtbfGVck1B8A.png)

The real difference between double equals and triple equals is whether we allow coercion.

---

## Coercion in JavaScript

Coercion or typecasting is one of the fundamentals of any programming language. This is even more crucial for a language that is dynamically typed such as JavaScript as the compiler won’t yell at you if types change.

Understanding coercion means that we are able to interpret our code the same way JavaScript does and, therefore, gives us more extensibility and minimizes mistakes.

#### Explicit coercion

Coercion can occur explicitly when the programmer calls one of these methods and thus forces the type of the variable to change.

Boolean(), Number(), BigInt(), String(), Object()

Example:

```
let x = 'foo';

typeof x // string

x = Boolean('foo')

typeof x // boolean
```

#### Implicit coercion

In JavaScript, variables are weakly typed, so this means that they can be converted automatically (implicit coercion). This is usually the case when we use arithmetic operations `+ / — *` , surrounding context, or use `==`.

```JavaScript
2 / '3' // '3' coerced to  3
new Date() + 1 //  coerced to a string of date that ends with 1
if(x) // x is coerced to boolean
1 == true // true coerced to number 1
1 == 'true' // 'true' coreced to NaN
`this ${variable} will be coreced to string
```

Implicit coercion is a double-edged sword, used sensibly it can increase readability and decrease verbosity. Misused or misunderstood, you have a formula for disappointments, people ranting and blaming JavaScript.

---

## Equality Algorithms in a Nutshell

#### Abstract equality comparison ==

1. If both X and Y are the same types — perform the `===`.
2. If X is `null` and Y is `undefined` or the other way around — `true`.
3. If one is a number, coerce the other to a number.
4. If one is an object, coerces to primitive.
5. Return `false`.

#### Strict equality comparison ===

1. If types don’t match — `false`.
2. If types match — compare value, return false for NaN.
3. -0 — true.

---

## Popular Use Cases

#### 1. Same type (most of the cases)

If the types are the same then the `===` is **exactly the same as** `==`. Therefore, you should use the more semantic one.

```
1 == 1 // true                ......        1 === 1 // true

'foo' == 'foo' // true        ......       'foo' === 'foo' //true
```

“I prefer to use `===` just in case the types are different.”

This is not a logical argument, it’s like pressing save twice, refreshing five times. We do not call a method twice in code just in case, do we?

#### 2. Different types (primitives)

First of all, I want to bring to your attention that different ****types do not mean **unknown**** **types.

Not knowing the types indicates that there is a bigger problem in your code than just using `===` vs. `==`.

Knowing the types shows a deeper understanding of the code which will result in fewer bugs and more reliable software.

In the case that we have several possible types, by understanding coercion, we can now choose to coerce or not and hence use `===` or `==`.

Let’s say that we have the possibility of a number or a string.

Remember that the algorithm prefers numbers so it will try to use `[toNumber()](https://tc39.es/ecma262/#sec-tonumber)`.

```
let foo = 2;
let bar = 32; // number or string

foo == bar // if bar is string it will be coreced to number

foo === Number(bar) // doing basically the same

foo === bar // would always fail if bar comes as string
```

#### 3. null and undefined

`null` and `undefined` are both equal to each other when using the `==`.

```
let foo = null
let bar = undefined; 

foo == bar // true

foo === bar // false
```

#### 4. Nonprimitive [Objects, Arrays]

Comparing nonprimitives such as objects and arrays should not be done using `==` or `===`.

---

## Guidelines for Making Decisions

1. Prefer `==` in all cases where it can be used.
2. `==` with known types, optionally when you want to cast the types.
3. Knowing types is better than not knowing.
4. Don't use `==` if you don’t know the types.
5. If you know the types, `==` is `===`.
6. `===` is pointless when types don’t match.
7. `===` is unnecessary when types match.

---

## Reasons to Avoid ==

There are some cases where one should not use `==` without really understanding falsy values in JavaScript.

```
== with 0 or "" or "   "

== with non primtives

== true  or  == false
```

---

## Summary

In my experience, so far, I have always known the type of the variable I’m dealing with, and if I don’t, I use `typeof` to only allow the ones I expect.

Here are four points for people who scrolled to the end of the post.

1. If you can’t or won’t know the types, using `===` is the only reasonable choice.
2. Not knowing the types likely means you don’t understand the code, try to refactor your code.
3. Knowing the types leads to better code.
4. If types are known, `==` is best otherwise fall back to `===`.

Thanks for reading, I hope that this article has helped you deepen your understanding of JavaScript. I would suggest that you check the **You Don’t Know JS** series as it’s a mine full of in-depth knowledge.
[**getify/You-Dont-Know-JS**
**A book series on JavaScript. @YDKJS on twitter. Contribute to getify/You-Dont-Know-JS development by creating an…**github.com](https://github.com/getify/You-Dont-Know-JS)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
