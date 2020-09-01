> * 原文地址：[The limits of knowledge](https://towardsdatascience.com/the-limits-of-knowledge-b59be67fd50a)
> * 原文作者：[Samuel Flender](https://medium.com/@samuel.flender)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/the-limits-of-knowledge.md](https://github.com/xitu/gold-miner/blob/master/article/2020/the-limits-of-knowledge.md)
> * 译者：
> * 校对者：

# The limits of knowledge

![Crater Lake in Oregon (image source: Sebastien Goldberg, [Unsplash](https://unsplash.com/photos/L1Xqp235CYk))](https://cdn-images-1.medium.com/max/9678/0*CpmVADktVXeu5Jk2)

> Gödel, Turing, and the science of what we can and cannot know

In the seventeenth century, German mathematician Gottfried Leibnitz proposed a machine that could read any mathematical statement as input and determine whether it is true or false, based on the axioms of Mathematics. But is every statement decidable like that? Or are the limits to what we can know? This question has become known as the **Entscheidungsproblem** (decision problem).

Two centuries later, another German mathematician, David Hilbert, declared optimistically that the answer to the Entscheidungsproblem had to be, yes, we can and will know the answer to any mathematical question. In an address in 1930 in German town Königsberg he famously said,

> Wir müssen wissen — wir werden wissen. (‘We must know — we will know.’)

But will we?

#### The limits of Mathematics

Hilbert’s optimism turned out to be short-lived. In the same year, Austrian Mathematician Kurt Gödel demonstrated that there are limits to our knowledge in Mathematics by proving his famous **incompleteness theorem**.

Here’s a simplified way to understand Gödel’s theorem. Consider the following statement.

**Statement S: This statement is not provable.**

Now, suppose that within the context of Mathematics we could prove S to be true. But then, the statement S itself would be false, leading to an inconsistency. Okay, then let’s assume the opposite, that we cannot prove S within the context of Mathematics. But that would mean that S itself is true, and that Mathematics contains at least one statement that is true but cannot be shown to be true. Hence, Mathematics must be either inconsistent or incomplete. If we assume it to be consistent (statements cannot be true and false at the same time), this only leaves the conclusion that Mathematics is incomplete, i.e., there are true statements that simply cannot be shown to be true.

Gödel’s mathematical proof of the incompleteness theorem, which is much more complicated than I outlined here, fundamentally changed the view advertised by Hilbert that complete knowledge is feasible (“**wir werden wissen**”). In other words, if we assume Mathematics to be consistent, we are bound to discover true statements that are not provable.

For example, consider the Goldbach conjecture, according to which every even number is the sum of two primes:

6 = 3 + 3
8 = 3 + 5
10 = 3 + 7 
12 = 7 + 5, and so on.

No one has yet found a counter-example, and there might be none, if the conjecture is true. Because of Gödel we know that there are true statements out there that have no proof, but unfortunately, there is no way to identify these statements. The Goldbach conjecture might be one of them, and if it is, then attempt of finding a proof would be a waste of time.

![Kurt Gödel (left) and AlanTuring (right) (image source: [Cantor’s Paradise](https://medium.com/cantors-paradise/a-computability-proof-of-g%C3%B6dels-first-incompleteness-theorem-2d685899117c))](https://cdn-images-1.medium.com/max/5760/1*OEtkquO--eZVJAIt_dGvTA.jpeg)

#### The limits of computation

Alan Turing was a graduate student at Cambridge University when he first learned about Gödel’s incompleteness theorem. During that time, Turing was working on formulating the mathematical design of machines that could process any input and compute a result, similar to what Leibnitz had envisioned centuries earlier. These conceptualized machines are today known as **Turing machines**, and turned out to be the blueprint for the modern digital computer. In simple terms, a Turing machine can be likened to a modern computer program.

Turing was working on the so-called **halting problem**, which can be posed as follows:

**Can there be a program that can determine whether another program will halt (finish execution) or not (loop forever)?**

Turing proved that the answer to the halting problem is “No”, such a program cannot exist. Similar to Gödel’s work, his proof is a ‘proof by contradiction’. Assume that there exists a program **halts()** that determines whether a given program will halt or not. But then we can also construct the following program:

```python
def g():
    if halts(g):
        loop_forever()
    return
```

See what’s happening here? If g holds, g doesn’t hold, and if g doesn’t hold, g holds. Either way, we have a contradiction. **Hence, the program halts() cannot exist.**

While Gödel proved that Mathematics is incomplete, Turing proved that Computer Science is in some sense ‘incomplete’, too. Certain programs simply cannot exist. This is not just a theoretical curiosity: the halting problem has many practical implications in Computer Science today. For instance, if we want a compiler to find the fastest possible machine code for a given program, we are actually trying to solve the halting problem — and we already know that the problem is not solvable.

![A complicated protein structure — predicting how proteins fold is an NP-problem. (image source: [Nature](https://www.nature.com/articles/d41586-019-01357-6))](https://cdn-images-1.medium.com/max/2000/1*CZyv_a9CKoOQ1gzAliYdEQ.jpeg)

#### Practical limits of knowledge: the P vs NP problem

By showing that there are problems that are fundamentally not solvable, Gödel and Turing demonstrated that there are theoretical limits to what we can ever know. But in addition, there are other problems that we could solve in theory, but not in practice because it simply takes too long to compute the solution. This is where we get into the distinction between **P-problems and NP-problems.**

P-problems are problems that that can be solved in ‘reasonable time’, where reasonable in this context means ‘polynomial’ (hence the P). The computational complexity of finding a solution to these problems grows with some power of the size of the input to the problem. Think multiplication or sorting problems.

NP-problems on the other hand are problems that cannot be solved in reasonable time. NP stands for non-deterministic polynomial, meaning that a solution can be confirmed, but not found, with polynomial computational complexity. The complexity of finding a solution for NP-problems is exponential instead of polynomial, which makes an enormous practical difference. Examples for NP-problems are optimal scheduling, predicting how proteins fold, encrypting messages, solving Sudoku puzzles, optimal packing (a.k.a. the knapsack problem), or optimal routing (a.k.a. the traveling salesman problem). Some problems, such as finding the discrete Fourier transform of a function, start out in NP, but ultimately end up in P because of the development of new, clever algorithms that simplify the solution.

One of the biggest unanswered questions in Computer Science today is the P vs NP question: Is P equal to NP, or not? In other words, for all problems for which we can **confirm** a solution in reasonable time, can we also **find** a solution in reasonable time?

The P vs NP question is so important that it is included in the list of the ‘[Millenium prize problems](https://www.claymath.org/millennium-problems)’, and you’ll win one Million dollars if you find the answer. It is hard to overstate the significance of the problem: a world in which P=NP would be fundamentally different from a world in which P≠NP. If P=NP, then we could say with certainty that there is a much faster way to solve Sudoku puzzles, or to predict how proteins fold, we just have not found that method yet. Needless to say, knowing how proteins fold could have all sorts of real-world implications, like understanding Alzheimer’s disease or curing cancer.

Most scientists today believe that P does not equal NP, but will we ever know for sure? The P vs NP question itself might be similar to Hilbert’s Entscheidungsproblem or Turing’s Halting problem: **there might simply be no answer to the question.**

#### Resources and further reading

* Complexity, a guided tour (by Melanie Mitchell)
* P vs NP and the Complexity Zoo ([video](https://www.youtube.com/watch?v=YX40hbAHx3s))
* Gödel’s Incompleteness Theorem ([video](https://www.youtube.com/watch?v=O4ndIDcDSGc))

If you liked this article, also check out the following:

- [How to be less wrong - A Bayesian’s guide to predicting the future with limited data](https://towardsdatascience.com/how-to-be-less-wrong-5d6632a08f)
- [Trajectories Formed by Chance - Random walks in physics, finance, and in our lives](https://medium.com/swlh/trajectories-formed-by-chance-bc96c8e236a5)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
