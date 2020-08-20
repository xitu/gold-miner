> * 原文地址：[Optimization in Python — Interning](https://towardsdatascience.com/optimization-in-python-interning-805be5e9fd3e)
> * 原文作者：[Chetan Ambi](https://medium.com/@chetan.ambi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/optimization-in-python-interning.md](https://github.com/xitu/gold-miner/blob/master/article/2020/optimization-in-python-interning.md)
> * 译者：
> * 校对者：

# Optimization in Python — Interning

![Photo by [George Stewart](https://unsplash.com/@_stewart_) on [Unsplash](https://unsplash.com/photos/D8gtlT7j1v4)](https://cdn-images-1.medium.com/max/2000/0*TVH3cYeJ4s6F-4F3)

There are different Python implementations out there such as **CPython**, **Jython**, **IronPython**, etc. The optimization techniques we are going to discuss in this article are related to **CPython** which is standard Python implementation.

## Interning

**Interning is re-using the objects on-demand** instead of creating the new objects. What does this mean? Let’s try to understand Integer and String interning with examples.

**is** — this is used to compare the memory location of two python objects.
**id** — this returns memory location in base-10.

#### Integer interning

At startup, Python pre-loads/caches a list of integers into the memory. These are in the range `-5 to +256`. Any time when we try to create an integer object within this range, Python automatically refer to these objects in the memory instead of creating new integer objects.

The reason behind this optimization strategy is simple that integers in the `-5 to 256` are used more often. So it makes sense to store them in the main memory. So, Python pre-loads them in the memory at the startup so that speed and memory are optimized.

**Example 1:**

In this example, both `a` and `b` are assigned to value 100. Since it is within the range `-5 to +256`, Python uses interning so that `b` will also reference the same memory location instead of creating another integer object with value 100.

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*2bCl5cSdmLdcdcu4SJ7yZA.png)

As we can see from the code below, both `a` and `b` are referencing the same object in the memory. Python will not create a new object but instead references to `a`’s memory location. This is all due to integer interning.

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*KXOVe2gvDFXx-yEbYwWoiA.png)

**Example 2:**

In this example, both `a` and `b` are assigned with value 1000. Since it is outside the range -5 to +256, Python will create two integer objects. So both a and b will be stored in different locations in the memory.

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*1xhLqtk8pxzLbzJESmv9MQ.png)

As we can see from the code below, both `a` and `b` are stored in different locations in the memory.

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*qzdvHUE2Bl6sjegrGX_pJg.png)

#### String interning

Like integers, some of the strings also get interned. Generally, any string that satisfies the identifier naming convention will get interned. Sometimes there will be exceptions. So, don’t rely on it.

**Example 1:**

The string “Data” is a valid identifier, Python interns the string so both the variables will point to the same memory locations.

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*TwabGuCDNvtJZF4Z--hxfQ.png)

**Example 2:**

The string “Data Science” is not a valid identifier. Hence string interning is not applied here so both a and b will point to two different memory locations.

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*75_mJbYlq-pIEpRtzyxVXQ.png)

> All the above examples are from Google Colab which has Python version 3.6.9

In Python 3.6, any valid string with length ≥ 20 will get interned. But in Python 3.7, this has been changed to 4096. So as I mentioned earlier, these things will keep changing for different Python versions.

Since not all strings are interned, Python provides the option force the string to be interned using `sys.intern()`. This should not be used unless there is a need. Refer the sample code below.

![Image by Author](https://cdn-images-1.medium.com/max/2000/1*XlY1DoTzGDFaLSdYa1MaIw.png)

## Why string interning is important?

Let’s assume that you have an application where a lot of string operations are happening. If we were to use `equality operator ==` for comparing long strings Python tries to compare it character by character and obviously it will take some time. But if these long strings can be interned then we know that they point to the same memory location. In such a case we can use `is` keyword for comparing memory locations as it works much faster.

## Conclusion

Hope that you have understood the concept of interning in Python. Follow me if you would like to read more such articles on Python and Data Science.

If you are interested in understanding **Mutability and Immutability in Python**, please [**click here**](https://towardsdatascience.com/mutability-immutability-in-python-b698bc592cbc) to read my article.

---

Thank you so much for taking out time to read this article. You can reach me at [https://www.linkedin.com/in/chetanambi/](https://www.linkedin.com/in/chetanambi/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
