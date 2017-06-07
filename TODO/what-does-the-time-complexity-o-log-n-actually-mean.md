> * 原文地址：[What does the time complexity O(log n) actually mean?](https://hackernoon.com/what-does-the-time-complexity-o-log-n-actually-mean-45f94bb5bfbf)
> * 原文作者：[Maaz](https://hackernoon.com/@maazrk)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# What does the time complexity O(log n) actually mean?

![](https://cdn-images-1.medium.com/max/1000/1*IIKt9oYIhWsUQmsKoRZorQ.jpeg)

Knowing the complexity of algorithms beforehand is one thing, and other thing is knowing the reason behind it being like that.

Whether you’re a CS graduate or someone who wants to deal with optimization problems effectively, this is something that you must understand if you want to use your knowledge for solving actual problems.

Complexities like O(1) and O(n) are simple and straightforward. O(1) means an operation which is done to reach an element directly (like a dictionary or hash table), O(n) means first we would have to search it by checking n elements, but what could O(log n) possibly mean?

One place where you might have heard about O(log n) time complexity the first time is Binary search algorithm. So there must be some type of behavior that algorithm is showing to be given a complexity of log n. Let us see how it works.

Since binary search has a best case efficiency of O(1) and worst case (average case) efficiency of O(log n), we will look at an example of the worst case. Consider a sorted array of 16 elements.

For the worst case, let us say we want to search for the the number 13.

![](https://cdn-images-1.medium.com/max/800/1*2zmw8UA3Ju93DskOT2ja0A.png)

A sorted array of 16 elements

![](https://cdn-images-1.medium.com/max/800/1*dONXkX6pcZlJsW4pJT2a4w.jpeg)

Selecting the middle element as pivot (length / 2)

![](https://cdn-images-1.medium.com/max/800/1*ZGG_EHsm4F-4ESE4jH4Kqg.jpeg)

Since 13 is less than pivot, we remove the other half of the array

![](https://cdn-images-1.medium.com/max/800/1*ePal2Rfl88eRGFPnvXKFIw.jpeg)

Repeating the process for finding the middle element for every sub-array

![](https://cdn-images-1.medium.com/max/800/1*fJX4YoVfImQvQlWN4CRgsg.jpeg)

![](https://cdn-images-1.medium.com/max/800/1*1dJ8urBmYpKiGzyNZbwd8w.jpeg)

You can see that after every comparison with the middle term, our searching range gets divided into half of the current range.

So, for reaching one element from a set of 16 elements, we had to divide the array 4 times,

We can say that,

![](https://cdn-images-1.medium.com/max/800/1*4wH4sn6FBsAPnVHjIMdhTA.png)

Simplified Formula
Similarly, for n elements,

![](https://cdn-images-1.medium.com/max/800/1*b4wakMYiYlBXb99b-eYJ9w.png)

Generalization

![](https://cdn-images-1.medium.com/max/800/1*XwWCLuB2Zb0zQjSQo7wpbQ.png)

Separating the power for the numerator and denominator

![](https://cdn-images-1.medium.com/max/800/1*lHNSYMPysioxVc38BvokAw.png)

Multiplying both sides by 2^k
![](https://cdn-images-1.medium.com/max/800/1*y10tlmCach8Uefc3n3d5aA.png)
Final result
Now, let us look at the definition of logarithm, it says that

> A quantity representing the power to which a fixed number (the base) must be raised to produce a given number.

Which makes our equation into

![](https://cdn-images-1.medium.com/max/800/1*qVSjYPYo9t4QNoLP8FZFWw.png)
Logarithmic form
So the log n actually means something doesn’t it? A type of behavior nothing else can represent.

Well, i hope the idea of it is clear in your mind. When working in the field of computer science, it is always helpful to know such stuff (and is quite interesting too). Who knows, maybe you’re the one in your team who is able to find an optimized solution for a problem, just because you know what you’re dealing with. Good luck!

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
