> * 原文地址：[New Features In Python 3.10 You Should Know](https://python.plainenglish.io/new-features-in-python-3-10-you-should-know-18aab7ebc911)
> * 原文作者：[Tola Ore-Aruwaji](https://medium.com/@thecraftman)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/new-features-in-python-3-10-you-should-know.md](https://github.com/xitu/gold-miner/blob/master/article/2022/new-features-in-python-3-10-you-should-know.md)
> * 译者：
> * 校对者：

# New Features In Python 3.10 You Should Know

![](https://cdn-images-1.medium.com/max/3838/1*gcuS-mdPrHGeHLZHfacbUg.jpeg)

**Hello all and welcome back to another post. In this post, we will be looking at all the important changes in Python 3.10.**

The new version brings some great new features and improvements. Let’s check them out.

## Structural Pattern Matching

![](https://cdn-images-1.medium.com/max/2000/1*KAPJdxfXRc-EIza11iPcSA.png)

This lets you map variables against a set of different possible values like the switch case in other languages. You can use this feature with the match statement and case statements of patterns with associated actions.

In this example, notice how you can combine several literals in a single pattern using the pipe operator but you can match it not only against a simple value but also match against patterns of values which can be a tuple or a class.

![](https://cdn-images-1.medium.com/max/2000/1*3t1DQqu4Xl5kdgmhjUYzmA.png)

Pattern matching is the most interesting new feature and I can see it has been used in many different scenarios.

## Parenthesized Context Managers

![](https://cdn-images-1.medium.com/max/2000/1*ZsR8sWRgOwRVU8jQYICLWQ.png)

Now you can use enclosing parenthesis around context managers when you use them with the statement. This allows formatting a long collection of context managers in multiple lines.

## Strict argument for zip function

![](https://cdn-images-1.medium.com/max/2000/1*oJNMeoq2Q5vWmYcbIOhhKw.png)

An optional strict boolean keyword was added to the zip method to ensure all iterables have the same length. Zip cerates one single iterator that aggregates elements from multiple iterables. The default behavior is to stop when the end of the shorter iterable is reached. In the example above, it will combine the first two elements and discard the third name.

## Improved Error messages

This is another improvement I find really helpful. Many of the error messages have improved not only delivering more precise information about the error but also more precise information about where the error actually occurs.

For example, in this code with a missing parenthesis, the old error was just an invalid syntax message, not even with the correct line number.

![](https://cdn-images-1.medium.com/max/2000/1*fMuajdCWcyJjUOJhtQ3VBg.png)

Now, we can see the correct line number, correct position, and the good error description.

![](https://cdn-images-1.medium.com/max/2000/1*s1eC1iVuXEIdTBIfX3SV5w.png)

## New typing features

The typing module provides runtime support for typing and got a few additions in Python 3.10 a new type union operator was introduced which enables the syntax **x pipe y.** This provides a cleaner way of expressing either `type x` or `type y` instead of using `typing.union`

![](https://cdn-images-1.medium.com/max/2000/1*Q5cvcYoyKneH6MK9OIswAQ.png)

Additionally, this new syntax is also accepted as the second argument to its instance and the subclass. Now the typing module has a special value type `alias` that lets you declare type aliases more explicitly. This is useful for type checkers to distinguish between type aliases and ordinary assignments.

## Updates and Deprecations

Python now requires Open SSL 111 or newer. Older versions are no longer supported. This affects the **hash lib, hmac, and SS**L module and modernizes one of C Python’s key dependencies. Also, the entire disk-utils package is deprecated and will be removed in Python 3.12.

![](https://cdn-images-1.medium.com/max/2000/1*grIH2jt1WZzDMV7i2oLGCA.png)

## Improvements

![](https://cdn-images-1.medium.com/max/2000/1*YsQU3mf0oXIl1kHzj_T9NQ.png)

No new modules are added but a lot of modules have been improved. Here is a brief list of the most improved ones.

## Optimizations

![](https://cdn-images-1.medium.com/max/2000/1*FCjAgP7lsTVK0NmqyK9xAQ.png)

Multiple optimizations were implemented to make Python faster, the most important ones are the constructors for string, bytes, and byte array are now faster around 30–40% for small objects and the run pi module now imports fewer modules.

Python 3.10 brings many great new features, optimizations, and improvements. The most interesting one is the pattern matching feature and I also like the improved error messages a lot.

**Let me know in the comments which new feature you like the most and if you plan to upgrade to the new version anytime soon or if you are already using it.**

## Gracias

Enjoyed the read? Leave some ‘claps’ below so others can find this post. 🙂

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
