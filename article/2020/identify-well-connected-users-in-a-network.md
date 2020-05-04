> * 原文地址：[Identify well-connected Users in a Network](https://towardsdatascience.com/identify-well-connected-users-in-a-social-network-19ea8dd50b16)
> * 原文作者：[Guenter Roehrich](https://medium.com/@GuenterRoehrich)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/identify-well-connected-users-in-a-network.md](https://github.com/xitu/gold-miner/blob/master/article/2020/identify-well-connected-users-in-a-network.md)
> * 译者：
> * 校对者：

# Identify well-connected Users in a Network

This publication is primarily about how to use an undirected graph and Scipy’s Sparse Matrix implementation (COO) to store data and analyse user connections.

![“Connections“ — Photo by [NASA](https://unsplash.com/@nasa?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/13292/0*Ry3dSWy5ckRtkTHY)

I recently figured one of my former employers had a similar-to-Facebook social network in place, hence there is a huge amount of data that could not wait to be analysed. It’s quite developed and also used a lot so I decided to get into the relationship data in a bit more detail.

While browsing the web I found a way to make “counting connection quality” a feasible and fun task. The key word is counting triangles. This seems to be sound method to find well connected users through examining how many relations they share with a third person. To make this a bit more tangible, lets do a brief example.

> **Person A knows Person B, Person B knows Person C**. Simple and no triangle, hence not what we are looking for.
>
> **Person A knows Person B**, **Person B knows Person C** and **Person C knows Person A**. Well, this is exactly what we are looking for, because we here see, that these three people share a max of 2 connections within this constellation. Hence, a maximum of connections.

![An undirected example graph](https://cdn-images-1.medium.com/max/2000/1*d4TCH2_ayplfLN2EUAtxLg.png)

An interesting hands-on about counting triangles in a matrix in a paper published by [Carnegie Mellon University](http://www.math.cmu.edu/~ctsourak/tsourICDM08.pdf) [1]. This paper is already providing very understandable pseudo code snippets — however, we will look into another approach later on. Charalampos E. Tsourakakis (Carnegie Mellon University) proposed an extensively tested and accurate method (95%+) to count the triangles in a network through “the sum of cubes of eigenvalues”.

![“EigenTriangle” by C. E. Tsourakikis](https://cdn-images-1.medium.com/max/2000/1*IA7JteyZb7Na8iA2sc269w.png)

In regular English wording, we are calculating the total number of triangles in an undirected graph, where lambda expresses i eigenvalues. To obtain the number of triangles, we require the sum of cubes of eigenvalues. Please note the division by 6. This can be derived from three nodes that are involved by a triangle, and as we are counting each triangle as 2, we need to multiply the denominator — we will find this ‘magic 6’ again further below.

If you are one of those ‘Eigen-people’ (joke originated from MIT Prof. Gilbert Strang [2]) I am pretty sure the above equation looks interesting to you. According to Tsourakakis, we are required to provide data in the form stated below. The given pseudo and Python code require the calculation/creation of an adjacency matrix, a tolerance level (if you apply this on our tiny example from earlier, the tolerance of \< 1e-5 is fine) and the calculation of all i Lambdas:

![Charalampos E. Tsourakakis: Fast Counting of Triangles in Large Real Networks (Source)](https://cdn-images-1.medium.com/max/2000/1*6-camzK0rSQJy9T963QmRQ.png)

This is a quite straightforward task for your computer program:

So, what we now see there is a total of 3 triangles in our graph example, which is a perfect match to what we could see in our chart. There are the three triangles **(0,1,2)**, **(1,3,4)** and **(1,3,7)**, hence users **0,1,2,3,4,7** seem fairly well connected compared to users **5** or **6**.

---

Now let’s move on to a more random problem where we have not tweaked the data before, in order to observe a specific output. For this purpose, let’s create an artificial sparse dataset. I have chosen a simple random sample from a dataset of possible 20 users — in reality this is of course a lot more, therefore we will consider a sparse matrix that is addressed through coordinates, although this would not be necessary for our artificial dataset.

Now we can examine our random data — please note we will also stick to our first smaller example for the proof that this process works. In the above line we created some random connections. If we observed (8,7) and (16,8) we would hope for another (16,7) pair in order to obtain a triangle. Note that user cannot be friends with themselves!

What the **random** function created is the following — on the first sight, I assume we can work with that (duplicates are fine, self-references should be avoided):

```
[[2, 3], [18, 3], [14, 10], [2, 10], [3, 12], [10, 11], [19, 16], [7, 2], [6, 0], [14, 9], [11, 5], [12, 3], [19, 8], [9, 0], [4, 18], [12, 19], [10, 4], [3, 2], [16, 6], [7, 3], [2, 18], [10, 11], [8, 18], [2, 10], [19, 1], [17, 3], [13, 4], [2, 0], [17, 2], [4, 0], [1, 17]]
```

When first checking for the mode values in the two coordinates X and Y, we get the values **{2, 3, 7, 17}** that co-occur with the mode. The query referred to find these values is simple, we just check whether each list’s element[0] or [1] equals our mode **(X == 2) | (Y == 2)**. As we intended to store sparse data in a respective data structure, let’s move on with a sparse matrix. For this purpose, I created a quick snipped that will support your understanding.

It may now seem likely that triangles occur for the set given before. In order to count triangles on a larger scale for a specific row (where every row represents **X[index_number]** ) — and this is now different to our first approach where we counted overall triangles! — we require another equation to evaluate this result.

I was not able to tackle this problem for quite some time, but when doing some exercises I found a very good solution set out by much appreciated Prof. Richard Vuduc [3] (UC Berkeley, Georgia Tech). For the task of finding triangles I borrowed a linear algebraic approach which I could learn from Prof. Vuduc in one of his brilliant notebooks.

First, we create a dot product of the matrix (where M and M.T are always equivalent). This will count all connections from one user to another. As we will see, there are also some “over counts”. These will disappear, when the dot product is eventually “masked” with a pairwise multiplication of the initial matrix M.

**What an elegant solution!**

```py
M = (m.dot(m)) * m # dot & pairwise multiplication
```

In a last step, and eventually we are able to obtain the users that are fairly well connected, we will count triangles per user. Please note that any given number cannot be considered as “there are n triangles for person m”, but the results can be ordered, which will allow you to identify best or least connected users.

As already assumed from the mode value obtained, connections with user 2 were most likely to result in a triangle, this can also be observed in our example data. High triangle values are highlighted with an asterisk:

```
user:  0 	Triangle value:  [[66.]]
user:  1 	Triangle value:  [[26.]]
user:  2 	Triangle value:  [[187.]] *
user:  3 	Triangle value:  [[167.]] *
user:  4 	Triangle value:  [[69.]]
user:  5 	Triangle value:  [[13.]]
user:  6 	Triangle value:  [[22.]]
user:  7 	Triangle value:  [[70.]]
user:  8 	Triangle value:  [[30.]]
user:  9 	Triangle value:  [[24.]]
user:  10 	Triangle value:  [[127.]] *
user:  11 	Triangle value:  [[59.]]
user:  12 	Triangle value:  [[71.]]
user:  13 	Triangle value:  [[15.]]
user:  14 	Triangle value:  [[34.]]
user:  15 	Triangle value:  [[0.]]
user:  16 	Triangle value:  [[15.]]
user:  17 	Triangle value:  [[77.]]
user:  18 	Triangle value:  [[93.]]
user:  19 	Triangle value:  [[39.]]
```

What we can derive from this example: Values that are related to a triangle do have a relatively high value, however we also need to consider that additional **simple connections will also increase our overall value**. This can especially be observed in the cases **10** and **17** which are both non-triangles and triangles.

---

As I mentioned earlier, we will again have a look at our starting example, just to make sure our results are plausible. As user 1 is part of 3 overall triangles, we would of course expect this user to have the highest score. The result of the exact same steps, applied to our first small data set confirms our expectation and shows the following:

```
user:  0 	Triangle value:  2
user:  1 	Triangle value:  6
user:  2 	Triangle value:  2
user:  3 	Triangle value:  4
user:  4 	Triangle value:  2
user:  5 	Triangle value:  0
user:  6 	Triangle value:  0
user:  7 	Triangle value:  2
```

---

I hope I could provide you with a small but useful example of how to identify connected items in an undirected graph and use sparse matrices to store and process the data. I would love to hear, how you applied this logic to other topics. See you next time 🔲

---

[1] Charalampos E. Tsourakakis, Fast Counting of Triangles in Large Real Networks: Algorithms and Laws

[2] Prof. Gilbert Strang, MIT, https://www.youtube.com/watch?v=cdZnhQjJu4I

[3] Prof. Richard Vuduc, CSE 6040, https://cse6040.gatech.edu/fa17/details/

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
