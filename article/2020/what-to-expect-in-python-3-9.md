> * 原文地址：[What to Expect in Python 3.9](https://levelup.gitconnected.com/what-to-expect-in-python-3-9-206b486ec2a4)
> * 原文作者：[Juan Cruz Martinez](https://medium.com/@bajcmartinez)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/what-to-expect-in-python-3-9.md](https://github.com/xitu/gold-miner/blob/master/article/2020/what-to-expect-in-python-3-9.md)
> * 译者：
> * 校对者：

# What to Expect in Python 3.9

![Photo by [Ankush Minda](https://unsplash.com/@an_ku_sh?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/release?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/2400/1*3o3fDm_d8ZeNdSdpdaa7mA.jpeg)

Python 3.9 is expected to release on Monday, 05 October 2020. Prior to releasing the official version, the developers had planned to release six alpha, five beta preview, and two release candidates.

At the time of writing this article, the first candidate was recently released on 11 August. Now, we are anxiously waiting for the second release candidate which will probably be available from 14 September.

So, you might be wondering what’s new in Python 3.9. Right?

There are some significant changes that will dictate the way Python programs work. Most importantly, in this recent version, you will get a new parser that is based on **Parsing Expression Grammar (PEG)**. Similarly, merge `|` and update `|=` **Union Operators** are added to [dict](https://docs.python.org/3.9/library/stdtypes.html#dict).

Let’s have a more in-depth look at all the upcoming features and improvements of Python 3.9.

## New Parser Based on PEG

Unlike the older LL(1) parser, the new one has some key differences that make it more flexible and future proof. Basically in LL(1), the Python developers had used several “hacks” to avoid its limitations. In turn, it affects the flexibility of adding new language features.

The major difference between PEG and a context-free-grammar based parsers (e.g. **LL(1)**) is that in PEG the choice operator is ordered.

Let’s suppose we write this `rule: A | B | C`.

Now, in the case of LL(1) parser, it will generate constructions to conclude which one from A, B, or C must be expanded. On the other hand, PEG will try to check whether the first alternative (e.g. A) succeeds or not. It will continue to the next alternative only when `A` doesn’t succeed. In simple words, PEG will check the alternatives in the order in which they are written.

## Support for the IANA Time Zone

In real-world applications, users usually require only three types of time zones.

1. UTC
2. The local time zone of the system
3. IANA time zones

Now, if are already familiar with previous versions of Python then you might know that Python 3.2 introduced a class `datetime.timezone`. Basically, its main purpose was to provide support for UTC.

In true sense, the local time zone is still not available. But, in version 3.0 of Python, the developers changed the semantics of naïve time zones to support “local time” operations.

In Python 3.9, they are going to add support for the IANA time zone database. Most of the time, this database is also referred to as “tz” or the Olson database. So, don’t get confused with these terms.

All of the IANA time zone functionality is packed inside the [zoneinfo](https://docs.python.org/3.9/library/zoneinfo.html) module. This database is very popular and widely distributed in Unix-like operating systems. But, remember that Windows uses a completely different method for handling the time zones.

## Added Union Operators

In previous versions of Python, it’s not very efficient to merge or update two dicts. That’s why the developers are now introducing Union Operators like `|` for merging and `|=` for updating the dicts.

For example, earlier when we use `d1.update(d2)` then it also modifies `d1`. So, to fix it, we have to implement a small “hack” something like `e = d1.copy(); e.update(d2)`.

Actually, here we are creating a new temporary variable to hold the value. But, this solution is not very efficient. That’s the main reason behind adding those new Union Operators.

## Introducing removeprefix() and removesuffix()

Have you ever feel the need for some functions that can easily remove prefix or suffix from a given string?

Now, you might say that there are already some functions like `str.lstrip([chars])` and `str.rstrip([chars])` that can do this. But, this is where the confusion starts. Actually, these functions work with a set of characters instead of a substring.

So, there is definitely a need for some separate functions that can remove the substring from the beginning or end of the string.

Another reason for providing built-in support for `removeprefix()` and `removesuffix()` is that application developers usually write this functionality on their own to enhance their productivity. But, in most cases, they make mistakes while handling empty strings. So, a built-in solution can be very helpful for real-world apps.

## Type Hinting Generics In Standard Collections

Did you ever notice the duplicate collection hierarchy in the `typing` module?

For example, you can either use `typing.List` or the built-in `list`. So, in Python 3.9, the core development team has decided to add support for generics syntax in the `typing` module. The syntax can now be used in all standard collections that are available in this module.

The major plus point of this feature is that now user can easily annotate their code. It even helps the instructors to teach Python in a better way.

## Added graphlib module

In graphs, a topological order plays an important role to identify the flow of jobs. Meaning that it follows a linear order to tell which task will run before the other.

The `graphlib` module enables us to perform a topological sort or order of a graph. It is mostly used with hashable nodes.

## Modules That Are Enhance in Python 3.9

In my opinion, the major effort took place while improving the existing modules. You can evaluate this with the fact that a massive list of 35 modules is updated to optimize the Python programming language.

Some of the most significant changes happened inside `gc`, `http`, `imaplib`, `ipaddress`, `math`, `os`, `pydoc`, `random`, `signal`, `socket`, `time`, and `sys` modules.

## Features Deprecated

Around 16 features are deprecated in Python version 3.9. You can get detailed information from the [official Python 3.9 announcement](https://docs.python.org/3.9/whatsnew/3.9.html#deprecated). Here, I’ll try to give you a brief overview of the most important things that are deprecated.

If you have ever worked with `random` module then you probably know that it can accept any hashable type as a seed value. This can have unintended consequences because there is no guarantee whether the hash value is deterministic or not. That’s why the developers decided to only accept None, int, float, str, bytes, and bytearray as the seed value.

Also, from now onwards you must specify the `mode` argument to open a `GzipFile` file for writing.

## What’s Removed?

A total of 21 features that were deprecated in previous versions of Python are now completely dropped from the language. You may have a look at the complete list on [Python’s website](https://docs.python.org/3.9/whatsnew/3.9.html#removed).

---

Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
