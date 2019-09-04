> * 原文地址：[How to improve your data structures, algorithms, and problem-solving skills](https://medium.com/@fabianterh/how-to-improve-your-data-structures-algorithms-and-problem-solving-skills-af50971cba60)
> * 原文作者：[Fabian Terh](https://medium.com/@fabianterh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-improve-your-data-structures-algorithms-and-problem-solving-skills.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-improve-your-data-structures-algorithms-and-problem-solving-skills.md)
> * 译者：
> * 校对者：

# How to improve your data structures, algorithms, and problem-solving skills

![Source: [Arafat Khan](undefined)](https://cdn-images-1.medium.com/max/3000/1*Dyu63sMUVL-gYEZISOE2BQ.jpeg)

This post draws on my personal experiences and challenges over the past term at school, which I entered with hardly any knowledge of DSA (data structures and algorithms) and problem-solving strategies. As a self-taught programmer, I was a lot more familiar and comfortable with general programming, such as object-oriented programming, than with the problem-solving skills required in DSA questions.

This post reflects my journey throughout the term and the resources I turned to in order to quickly improve my data structures, algorithms, and problem-solving skills.

## Problem: You know the theory, but you get stuck on practical applications

I faced this issue early in the term when **I didn’t know what I didn’t know**, which is a particularly pernicious problem. I understood the theory well enough — for instance, what a linked list was, how it worked, its various operations and their time complexities, the ADTs (abstract data types) it supported, and how the ADT operations were implemented.

But because I didn’t know what I didn’t know, I couldn’t identify gaps in my understanding of its **practical applications** in problem-solving.

#### The different types of questions

An example of a data structures question: describe how you would insert a node in a linked list and state the time complexity.

And here’s an algorithms question: search for an element in a rotated sorted array and state the time complexity.

Finally, a problem-solving question, which I consider to be at a “higher level” than the previous two, might briefly describe a scenario, and list the requirements of the problem. In an exam it might ask for a description of the solution. In competitive programming it might require you to submit working code without explicitly providing any data structures or algorithms. In other words, you are expected to apply the most applicable data structures and algorithms to solve the problem as efficiently as possible.

## How can you improve your data structures, algorithms, and problem-solving skills?

I primarily use three websites for practice: [HackerRank](https://www.hackerrank.com), [LeetCode](https://leetcode.com), and [Kattis](https://open.kattis.com). They are largely similar, especially the first two, but not identical. I find that each site has a slightly different focus, each of which is immensely helpful in its own way.

I would loosely categorize the skills required for problem-solving into:

1. knowledge of data structures
2. knowledge of algorithms
3. knowledge of the application of data structures and algorithms

The first two could be considered the “primitives,” or building blocks, that go into the third, which is about knowing what to apply for a particular scenario.

#### Knowledge of data structures

In this respect, I found HackerRank to be a valuable resource. It has a [section dedicated to data structures](https://www.hackerrank.com/domains/data-structures), which you can filter by type, such as arrays, linked lists, (balanced) trees, heaps, and so forth.

The questions are not so much about problem-solving as they are about working with data structures. For instance:

1. arrays: [array rotation](https://www.hackerrank.com/challenges/array-left-rotation/problem), [array manipulation](https://www.hackerrank.com/challenges/crush/problem)
2. linked lists: [reversing a linked list](https://www.hackerrank.com/challenges/reverse-a-linked-list/problem), [cycle detection](https://www.hackerrank.com/challenges/detect-whether-a-linked-list-contains-a-cycle/problem)
3. trees: [node swapping](https://www.hackerrank.com/challenges/swap-nodes-algo/problem), [BST validation](https://www.hackerrank.com/challenges/is-binary-search-tree/problem)

You get the idea. Some of the questions might not ever be directly applicable in problem-solving. But they are great for conceptual understanding, which is **extremely important**** **in any case.

HackerRank does not have freely accessible “model solutions,” although the discussions section is usually full of hints, clues, and even working code snippets. I have found those to be adequate so far, although you might have to step through the code a line at a time in an IDE to really understand something.

#### Knowledge of algorithms

HackerRank also has an [algorithms section](https://www.hackerrank.com/domains/algorithms), although I prefer [LeetCode](https://leetcode.com/problemset/all/) for this. I found LeetCode’s variety of problems to be a lot wider, and I really like that a lot of problems have solutions with explanations and even time complexities.

A great starting point would be LeetCode’s [top 100 liked questions](https://leetcode.com/problemset/top-100-liked-questions/). Some questions which I thought were great:

* [Accounts merge](https://leetcode.com/problems/accounts-merge/)
* [Longest continuous increasing subsequence](https://leetcode.com/problems/longest-continuous-increasing-subsequence/)
* [Searching in a rotated sorted array](https://leetcode.com/problems/search-in-rotated-sorted-array/)

Unlike data structures questions, the focus here isn’t so much about working with or manipulating data structures, but rather, how to **do something**. For instance, the “accounts merge” problem is primarily on the application of standard UFDS algorithms. The “searching in a rotated sorted array” problem presents a twist on binary search. And sometimes you learn an entirely new problem-solving technique. For example, the “[sliding window](https://www.geeksforgeeks.org/window-sliding-technique/)” solution for the “longest continuous increasing subsequence” problem.

#### Knowledge of the application of data structures and algorithms

Finally, I use Kattis to improve my general problem-solving skills. The [Kattis Problem Archive](https://open.kattis.com/) has a bunch of programming problems from various sources, such as competitive programming competitions, around the world.

Kattis can be incredibly frustrating because there are no official solutions or a discussion forum, (unlike HackerRank and LeetCode). Also, test cases are private. I have a handful of pending Kattis problems which I can’t solve — not because I don’t know the solution, but because I can’t figure out the bug.

It’s my least favorite site among the three for practicing and learning, and I didn’t spend a lot of time on it.

## Other resources

[Geeksforgeeks](https://www.geeksforgeeks.org) is another very valuable resource for learning about data structures and algorithms. I like how it provides code snippets in various languages, usuallyC++, Java, and Python, which you can copy and paste into your IDE to step through line-by-line.

Finally, there is trusty old Google, which would lead you to GeeksForGeeks most of the time, and Youtube, for visual explanations.

## Conclusion

At the end of the day, however, there are no shortcuts. You just have to dive into it head-first — start writing code, debugging code, and reading other people’s correct code to figure out where, how, and why you went wrong. It’s tough, but you get better with each attempt, and it gets easier as you get better.

I’m nowhere near the level of competency I want to be, but I’ve definitely come a long way since I started. :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
