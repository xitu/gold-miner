> * 原文地址：[Applications of Some of The Famous Algorithms](https://levelup.gitconnected.com/applications-of-some-of-the-famous-algorithms-cdaecee58ed1)
> * 原文作者：[Shubham Pathania](https://medium.com/@spathania08)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/applications-of-some-of-the-famous-algorithms.md](https://github.com/xitu/gold-miner/blob/master/article/2020/applications-of-some-of-the-famous-algorithms.md)
> * 译者：
> * 校对者：

# Applications of Some of The Famous Algorithms

![Photo by [Kaleidico](https://unsplash.com/@kaleidico?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10804/0*d-YSolz0sbA5uAkw)

#### Do you know the practical use cases behind learning these algorithms?

During my college days, I started learning programming by practicing most of the famous algorithms. I never tried to understand how these algorithms can be helpful in the real world. There must be some reason why we start learning them, right?

As a software developer, I used many of these algorithms today in my projects. It is interesting to find a practical implementation behind those algorithms that I once learning for the sake of getting a job.

In this article, I am going to share some of the practical scenarios where we use some of these algorithms. Beginners can find it interesting to relate while learning, whereas it might refresh the memory of experienced programmers.

---

Let’s take a closer look.

## Fibonacci Sequence

Almost every developer has gone through the algorithm for the Fibonacci series. The [Fibonacci Sequence](https://en.wikipedia.org/wiki/Fibonacci_number) is the series of numbers: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, and 55 on to infinity.

Have you ever wondered what could be the possible scenario in our world where we can utilize this algorithm?

The sequence has a series of interesting properties. The sum of any two consecutive numbers equals the next highest number. Coincidentally, it works as a nearly-accurate converter between miles and kilometers.

Consider any number in the Fibonacci sequence as miles. The next number in the sequence is approximately that same distance in kilometers. For example, 8 miles is about 13 kilometers. 13 miles is about the same as 21 kilometers.

Among many of the features of Fibonacci sequences, investors have harnessed their power to predict **stock prices**. The most popular Fibonacci-based investment system is the [Elliot Wave Theory](https://elitecurrensea.com/education/elliott-wave-patterns-fibonacci-relationships-core-reference-guide/).

## Palindrome Algorithm

This is another common algorithm that is recursively asked in interviews. A palindrome is a string that reads the same forward and backward. For example — radar, toot, and madam.

Now many of us believe what could be the possible practical implementation of this algorithm besides testing logical ability, but there’s more to it. It is useful in [DNA sequence processing](https://pubmed.ncbi.nlm.nih.gov/11700586/).

Today, more DNA sequences are becoming available. The information about DNA sequences is stored in molecular biology databases. The size and importance of these databases will be bigger in the future. Therefore this information must be stored or communicated efficiently.

CTW (Context Tree Weighting Method) can compress DNA sequences less than two bits per symbol. Two characteristic structures of DNA sequences are known. One is called Palindromes or reverse complements, and the other structure is approximate repeats.

Before encoding the next symbol, the algorithm searches an approximate repeat and palindrome using hash and dynamic programming. If there is a palindrome or an approximate repeat with enough length, then our algorithm represents it with length and distance.

## Binary Search Algorithm

It is also known as half-interval search, logarithmic search, or binary chop, is a search algorithm that finds the position of a target value within a sorted array.

The method is to compare the middle element with the targeted value (key element) if they are unequal. The half in which the target cannot lie is eliminated, and the search continues on the remaining half until it is successful or the remaining half is empty.

This seems to be a quite effective method since it escapes the redundancy of going over every element and instead narrows down the searching range efficiently.

Every programmer is taught that binary search is a good and fast way to search an ordered list of data. There are many textbook examples of using binary search, but where do we actually use it in real life?

One practical application to this algorithm is validating user credentials in an application. You might have seen how applications with millions of users validate your credential within a fraction of seconds. That’s all possible due to the binary search.

Binary search is used **everywhere**. Take any sorted collection from any language library (Java, .NET, C++ STL, and so on), and they all will use (or have the option to use) binary search to find values.

## Merge Sort Algorithm

Merge sort is a sorting technique based on the **divide and conquer** technique. It works on two basic principles:

* Sorting a smaller list is faster than sorting a larger list.
* Combining two sorted sublists is faster than two unsorted lists.

Merge sort is used mostly undersize constraints.

In any e-commerce website, we usually have a section — **You might like**. They have maintained an array for all the user accounts. Whichever has the least number of inversion with our array of choices, they start recommending what they have bought or like.

This is one of the most common implementations of merge sort in today’s world.

## Armstrong Number

A number is called an Armstrong number if the sum of cubes of digits of a number is equal to the number itself.

For example, 153 is an Armstrong number as −

```
153 = (1)3 + (5)3 + (3)3
153 = 1 + 125 + 27
153 = 153
```

There is no direct implementation of Armstrong number in real-world applications, but it is extensively used in security algorithms for data encryption and decryption.

---

Here’s a [link to a paper](https://www.ijitee.org/download/volume-1-issue-1/) where using Armstrong numbers for wireless sensor networks are discussed. They have used Armstrong number-based security algorithm in which a 128-bit key is generated using the Armstrong number and which is used in the [AES algorithm](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard) for data encryption and decryption.

## Final thoughts

We have seen practical use cases of some of the most commonly seen programming algorithms. Many of us have already worked on them as a beginner without much awareness of their real-world applications.

---

It is a good approach to understand the benefits before learning something, as it will help us to understand the algorithm better. There are several other algorithms that we use in our day-to-day life. I would leave that up to you to find out their practical use cases.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
