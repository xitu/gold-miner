> * 原文地址：[How Slow is Python?](https://levelup.gitconnected.com/how-slow-is-python-6f2fc1fbfbaa)
> * 原文作者：[Doug Foo](https://medium.com/@doug-foo)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/how-slow-is-python.md](https://github.com/xitu/gold-miner/blob/master/article/2022/how-slow-is-python.md)
> * 译者：
> * 校对者：

# How Slow is Python?

![Photo by [Alex Blăjan](https://unsplash.com/@alexb?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/13886/0*kOjDXNW1V5aQYWmI)

We all know it is slower than C, Java, Rust, but just how slow?

Just as I started thinking about this article, my feed produces a joker post “Python isn’t actually slow” — I read it even though I knew it was not true and was just clickbait. When it comes to Python you are dealing with a snail, and while you can train the heck out of a snail you cannot escape its fundamental genetics (unlike Ethan Hawke in the classic movie Gattaca).

## Benchmarking

I started writing a few simple benchmarks to cross-test in C, Rust, Java, and Python. I think the main categories to evaluate:

* Managing memory pressure (object creation/destruction)
* String processing like JSON
* Loops and compute-intensive operations

For reference, there is a great [GitHub project](https://github.com/kostya/benchmarks) evaluating performance across a dozen+ languages. The summary table is included below, and if C++ is a baseline of 1, then Python is a whopping 227x slower on the [brainf test](https://gist.github.com/roachhd/dce54bec8ba55fb17d3a) (which is a pretty interesting **Turing Machine** interpreter).

![Courtesy of github project by [Kostya M](https://github.com/kostya/benchmarks)](https://cdn-images-1.medium.com/max/2000/1*1YFqFHxz77sbFp-v_8k7Ow.png)

I wound up writing super basic snippet tests because I realize I forgot how to program in most of these languages. I had to reset my ambition to match my feeble skills...

![© Doug Foo Labs](https://cdn-images-1.medium.com/max/3450/1*sc0AvOEI6nBMLr0a_iyCMg.png)

## Insights from test results

**I’ll link to my GitHub for the really hacky tests in the References section. I hope the naming is self-explanatory.**

These are my takeaways across languages:

1. **Python File I/O is comparably fast** since the limiting factor is disk
2. **Python is unusually slow at recursion**, doing a recursive Fibonacci gets infeasibly slow at just fib(30)
3. **Python function calls are slow** — contributing to the recursion issue
4. **Java w/o JIT optimization** can be really slow, even slower than Python for some things
5. **Java native String** + is still deathly slow (100x), using StringBuilder makes it reasonably fast, but slower than Python
6. **Java w/ JIT is quite fast** these days, almost not worth using C anymore…
7. **Rust is really fast**, could be faster if I knew how to code in it better…

The 200x slower benchmark hasn’t been proven in my small kit, but obviously, a few extra function calls and recursions and you’ll easily get there.

## So why is Python slow?

Most things are obvious but let me list them:

1. Python is **interpreted** and while byte-compiled it is not really optimized
2. It is **garbage collected**, but it primarily uses reference counting so it is a bit faster or at least more deterministic than Java
3. By default it has **no JIT compiler** — seems to be critical for an interpreted language (**PyPy** uses this to give it a 10x boost)
4. Being an **untyped dynamic language** has its slow points (and makes it harder to build a JIT)
5. Implementation of **function calls are unusually slow** (perhaps some stack frame allocation complexity?)

Note we did not even test multithreaded or multi-programming since we all know Python has the **GIL (Global Interpreter Lock)** issue as well.

## How to optimize Python

There are a few tricks to speed Python, but most aren’t that great.

1. Use multi-processing to spawn off workers (but beware you will be limited by the GIL )
2. Write native C code and link it to Python
3. Use native Python functions (which are written in the runtime in C)
4. 1-liner list comprehensions seem to be performance-optimized so they aren’t just cool tricks it seems

I honestly did not see a lot of great tips… some of the tips were like “use O(n) and O(n-log n) algorithms instead of O(n²)” … perhaps the first tip should be to **study some computer science**?

---

## References

1. Making Python fast— [https://github.com/ajcr/ajcr.github.io/blob/master/_posts/2016-04-01-fast-inverse-square-root-python.md](https://www.kdnuggets.com/2021/06/make-python-code-run-incredibly-fast.html)
2. Python Slowness — [https://medium.com/analytics-vidhya/is-python-really-very-slow-2-major-problems-to-know-which-makes-python-very-slow-9e92653265ea](https://towardsdatascience.com/why-is-python-so-slow-and-how-to-speed-it-up-485b5a84154e)
3. Why is Python Slow — [https://hackernoon.com/why-is-python-so-slow-e5074b6fe55b](https://hackernoon.com/why-is-python-so-slow-e5074b6fe55b)
4. GitHub of hack test1.* sample s— [https://github.com/dougfoo/medium](https://github.com/dougfoo/medium)
5. Lack of ByteCode optimization in Python — [https://nullprogram.com/blog/2019/02/24/](https://nullprogram.com/blog/2019/02/24/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
