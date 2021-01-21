> * 原文地址：[A Beginner’s Guide to Memoization with JavaScript](https://blog.bitsrc.io/a-beginners-guide-to-memoization-with-javascript-59d9c818f4c8)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-beginners-guide-to-memoization-with-javascript.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-beginners-guide-to-memoization-with-javascript.md)
> * 译者：
> * 校对者：

# A Beginner’s Guide to Memoization with JavaScript

![Photo by [Tamanna Rumee](https://unsplash.com/@tamanna_rumee?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10944/0*ppVRXfrCk7iBldw8)

One of the best things about being a software developer is that you never stop learning. There is always something to learn especially with something like JavaScript. When our applications become complex, the need for speed becomes a major deal-breaker. Performance optimization becomes a necessity when our application code grows in scale. Memoization is a concept that helps you build efficient applications even when the complexity is higher. The concept of memoization is very much associated with pure functions and functional programming in JavaScript.

**You must keep in mind that memoization is merely a concept and is not dependent on JavaScript or any specific programming language. We will be looking at memoization from JavaScript’s perspective in this article.**

## What is Memoization?

By [definition](https://www.cs.cmu.edu/~rwh/introsml/techniques/memoization.htm), Memoization is a programming technique for caching the results of previous expensive computations so that they can be quickly retrieved without repeated effort when the same inputs are passed.

If you break this definition down further, you will notice that there are three main points.

* **caching the results** — cache is a temporary data storage that enables faster data access in the future.
* **expensive computations** — this refers to computations or process which are expensive. By the term “expensive”, it is meant that these processes consume a lot of memory or take a lot of time, both of which are precious in the world of computing.
* **when the same inputs are passed** — This is a straightforward statement. But this statement confirms the connection between memoization and pure functions as stated before. The fundamental concept of pure functions is that the result returned is always the same as the associated input argument.

With the help of our divide and conquer approach, we should have a basic understanding of memoization by now. If you still didn’t understand, don’t worry, I’ve got you covered.

## When and Why Should You Memoize Your Functions?

#### Why?

Let’s start with the why. Memoization can immensely help you improve the performance of your expensive function calls. When a function receives input and returns an output after heavy computation, this return value can be cached. If the same inputs are received again, it is logical to return the same outputs rather than do the computations from scratch.

There are several resources online that discuss performance improvements due to memoization. You can have a look at the resources at the end of this article to know more.

#### When?

Memoizing functions is only possible when your functions are pure. If your function returns different outputs for the same inputs, then there is no use memoizing it. Have a look at the code below.

Even though the input is the same, the output is different each time the function is called. Memoizing a function like this is useless.

Furthermore, there are several instances where you can memoize your functions.

* They are recursive functions with input values being repeated.
* The function calls are expensive

## Key Takeaways

![Photo by [Matthew Cabret](https://unsplash.com/@majinmdub?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8320/0*m5L_0XBWVSlIUumn)

There are three main points you should keep in mind about memoization. Memoization will not exist without the below concepts.

* **Pure functions** — although I did mention this earlier, it is essential for a function to be pure in order to be memoized.
* **Higher-order functions** —these functions return another function that can be invoked later.
* **Closures** — the cache that exists within the function can remember its values thanks to closures and higher-order functions.

You will see these concepts in action in the example down below.

## Memoization in Action

A commonly used example for memoization would be the calculation of the factorials. Let’s have a look.

In the above example, the calculations are done every time. In the second call of the `factorial(100)` the whole process is repeated. If we had implemented memoization, there is no such need to run the calculations again as we would have the return value of `factorial(100)` stored in the cache.

Let’s have a look at the above example implemented with memoization.

In the above example, you can clearly see that the cache values are referred to, whenever required. This allows you to skip certain calculations as their values have been calculated previously.

If you closely look at the call, you can see that the calculation of `factorial(50)` is pretty quick as there is no computation involved. This is due to the value of `factorial(50)` already being computed and cached in the `factorial(60)` execution.

You can play around with this example over [here](https://jsfiddle.net/2u7rofyp/1/).

#### Things to note about the above example

You can clearly see that the above factorial function is a **pure function** as it always returns the same output value for the same input. You can also note that the memoize function is a **higher-order function** in the above example as it returns a function that can be invoked later and also uses the function passed in as an argument. Furthermore, it can also be noted that due to the higher-order function being used, a **closure** is created that allows for the cache object to be accessed by the inner function.

We can now see how a function can be memoized with three important concepts being applied to it.

## Caching vs Memoization

You might start wondering about the difference between caching and memoization. Well, in fact, caching can be possible in various ways like HTTP cache, image cache, etc. But memoization is more concerned with a specific type of caching, **caching return values of a function**.

**You must also note that I have already mentioned the key takeaways of memoization. Therefore caching is only a part of memoization, not memoization itself.**

## Libraries for Memoization

There are several libraries that help you memoize your functions but they differ from one another with the way the memoization is implemented.

* Moize
* Lodash
* Underscore
* Memoize Immutable and more.

You can have a look at all the libraries and their features in this [stack overflow answer](https://stackoverflow.com/a/61402805) by Venryx.

## Should You Always Memoize Your Functions?

**TLDR; No**

Although memoization increases your performance by a huge margin, there is something else you should keep in mind. The cache **stores** the values, implying that there is data being stored. If your function inputs vary with a huge range, then your cache will become larger and larger. Typically, memoized functions have a space complexity of O(n). But there are algorithms that can improve the space complexity of memoized functions.

It is very important for you to understand that you have to balance between two important resources - time and space. Although memoization reduces the time complexity of a function, it increases the space complexity on the other hand.

Therefore, I believe that it is suitable to implement memoization when the input range is fixed and it can be assured that they will be often repetitive.

----

Thank you for reading and happy coding

**Resources**

- [Article by Philip](https://scotch.io/tutorials/understanding-memoization-in-javascript)
- [Article by Codesmith](https://codeburst.io/understanding-memoization-in-3-minutes-2e58daf33a19)
- [Article by Divyanshu](https://www.freecodecamp.org/news/understanding-memoize-in-javascript-51d07d19430e/)
- [Lecture Notes — Carnegie Mellon University](https://www.cs.cmu.edu/~rwh/introsml/techniques/memoization.htm)
- [MDN Docs](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
