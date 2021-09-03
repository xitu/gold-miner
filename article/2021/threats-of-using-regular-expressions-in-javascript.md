> * 原文地址：[Threats of Using Regular Expressions in JavaScript](https://blog.bitsrc.io/threats-of-using-regular-expressions-in-javascript-28ddccf5224c)
> * 原文作者：[Dulanka Karunasena](https://medium.com/@dulanka)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/threats-of-using-regular-expressions-in-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/threats-of-using-regular-expressions-in-javascript.md)
> * 译者：
> * 校对者：

# Threats of Using Regular Expressions in JavaScript

#### How to Avoid Catastrophic Backtracking and ReDos Attacks

![](https://cdn-images-1.medium.com/max/5760/1*5MYzlcICu2hhNjrtRCjb3A.jpeg)

Regular expressions or regex are widely used in web development for pattern matching and validation purposes. However, using them in practice comes with several security and performance risks that could open doors for attackers.

So, in this article, I will discuss two fundamental issues you need to be aware of before using regular expressions in JavaScript.

---

## Catastrophic Backtracking

There are two regular expression algorithms out there,

* **Deterministic Finite Automaton (DFA)** — Checks a character in a string only once.
* **Nondeterministic Finite Automaton (NFA) —** Checks a character multiple times until the best match is found.

JavaScript uses the NFA approach in its regex engine, and this NFA behavior causes catastrophic backtracking.

To get a better understanding, let’s consider the following regex.

```
/(g|i+)+t/
```

This regex seems simple. But don’t underestimate, it can cost you a lot 😯. So first, let’s understand the meaning behind this regex.

* **(g|i+) —** This is a group that checks if a given string starts with '**g'** or one or more occurrences of '**i'**.
* The next '**+'** will check for one or more appearances of the previous group.
* The string should end with the letter '**t.'**

The following texts will evaluate as valid under the above regex.

```
git
giit
gggt
gigiggt
igggt
```

Now let’s check the time taken to execute the above regex on a valid string. I will use the `console.time()` method.

![Valid text](https://cdn-images-1.medium.com/max/2000/1*f6jb5c3Y3nsF6W1SsZucRw.png)

Here we can see that the execution is pretty fast, even though the string is a bit long.

> But you will be surprised when you see the time taken to validate an invalid text.

In the below example, the string ends with a **‘v’** which is invalid according to the regex. Therefore, It took around 429 milliseconds, approximately 400 times slower than the execution time taken to check a valid string.

![Invalid text](https://cdn-images-1.medium.com/max/2000/1*zKduT1538LwOWj0x5g9Y7g.png)

> The main reason for this performance difference is the NFA algorithm used by JavaScript.

JavaScript Regex engine validates a sequence of characters on its first successful validation attempt and continues. If it fails at any particular position, it will backtrack to a previous position and find an alternative path.

When backtracking becomes too complex, the algorithm will consume more computational power, resulting in **catastrophic backtracking**.

> **Note:** To understand the complexity of backtracking, you can visit [regex101.com](https://regex101.com/) and test your regex. regex101.com indicates that ten steps are needed to validate `giiiit` using the above-discussed regex, while it took 189 steps to validate `giiiiv`.

---

## ReDos on a NodeJS Environment

> ReDos attackers use catastrophic backtracking to exploit NodeJS servers.

Since JavaScript is single-threaded, ReDos attacks can exhaust the event loop causing the server to hang until the request is completed.

I will use the Moment.js library to demonstrate this since there is a well-known ReDos vulnerability in Moment.js versions below 2.15.2.

```js
var moment = require('moment');
moment.locale("be");
moment().format("D                               MMN MMMM");
```

In this example, the date format has 40 characters with 31 additional spaces. Due to catastrophic backtracking, additional space will double the execution time and it took more than 4 minutes to run in my local environment.

![](https://cdn-images-1.medium.com/max/2000/1*YUOV_B0E8SHaL_6ys3cDhQ.png)

The reason for this issue was the overuse of the '+' operator inside the regex /D[oD]?(\[[^\[\]]*\]|\s+)+MMMM?/ that caused this vulnerability. Luckily the issue was fixed on later versions after it was raised by [Snyk](https://snyk.io/) (a vulnerability tracking tool).

## How to Avoid Regex Vulnerabilities

#### 1. Writing simple regex

Catastrophic backtracking occurs inside regexes that have at least three characters with two or more occurrences of the *, +, } characters close to each other.

So, if you can simplify your regex and avoid the above pattern, you can avoid catastrophic backtracking as well.

#### 2. Use validation libraries

For the most commonly used validation tasks, we can use third-party libraries like [validator.js](https://www.npmjs.com/package/validator) or [express-validator](https://www.npmjs.com/package/express-validator).

We can depend on them as a large community backs them.

#### 3. Use regex analyzers

You can craft your own regex without any vulnerabilities using tools like [safe-regex](https://www.npmjs.com/package/safe-regex) and [rxxr2](https://www.cs.bham.ac.uk/~hxt/research/rxxr2/). They will check your regex for vulnerabilities and return its validity.

```js
var safe = require('safe-regex');

var regex = /(g|i+)+t/;
console.log(safe(regex)); //false
```

#### 4. Avoid using Node’s default regex engine

Since Node’s default regex engine is vulnerable to ReDos attacks, we can avoid using it and switch to alternatives like google’s [re2](https://www.npmjs.com/package/re2) engine. It ensures that regexes are safe against ReDos attacks, and usage is almost similar to the default Node regex engine.

```js
var RE2 = require('re2');

var re = new RE2(/(g|i+)+t/);
var result = 'giiiiiiiiiiiiiiiiiiit'.search(re);
console.log(result); //false
```

This will evaluate to `false` because the regular expression is vulnerable to catastrophic backtracking.

## Key Takeaways

Catastrophic backtracking is the most common issue in regular expressions. It not only affects application performance but also opens the door to ReDos attackers to exploit NodeJs servers.

In this article, we discussed how catastrophic backtracking and ReDos attacks work and how we can avoid those vulnerabilities.

I hope this article will help you protect your application against such attacks, and don’t forget to share your thoughts in the comments section.

Thank you for Reading !!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
