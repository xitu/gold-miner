> * 原文地址：[Garbage Collection in Python](https://medium.com/better-programming/garbage-collection-in-python-6dca154ae1dd)
> * 原文作者：[Raivat Shah](https://medium.com/@raivat)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/garbage-collection-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/garbage-collection-in-python.md)
> * 译者：
> * 校对者：

# Garbage Collection in Python

![Artwork created by [Katerina Limpitsouni](https://twitter.com/ninalimpi)](https://cdn-images-1.medium.com/max/2298/1*GPhtmRdktXK9Aldvyl02yw.png)

If you’ve been programming for a while, you’ve probably heard about **garbage collection.** Let’s delve deeper into what it is and how it works.

## What and Why

In the real world, we clear out things — e.g., old notes, boxes that we no longer need — and discard them in a garbage/recycling can. Space is limited, and we want to make space for other essential items we want to store.

Similarly, in computers, space — aka **memory —** is an important and finite resource. Thus, a garbage collector collects data objects that are no longer needed and discards them.

Depending on the language, garbage collection can be an automatic or a manual process. In most high-level languages, such as Python and Java, it’s automated. Thus, these languages are called **garbage-collected languages.** Other languages, such as C, don’t support automatic garbage collection, and the programmer is responsible for memory management.

Now, let’s see how garbage collection works.

## How

There are some techniques, but most garbage-collected languages, including Python, use **reference counting.** In reference counting, we track the number of references to an object and discard an object when the count is `0`.

An object’s reference count changes as the number of aliases pointing to it changes. The count increases when it’s assigned a new name or placed in a container such as a list or dictionary. The count decreases when it’s deleted with the `del` command, it’s reference is out of scope, or it’s reassigned. For example:

```python
sample = 100 # Creates object <100>. Ref count = 1 

sample_copy = sample # Ref count = 2. 

sample_list = [sample] # Ref count = 3.

del sample # Ref count = 2. Note that this doesn't affect sample_copy and sample_list as they directly point to <100>. 

sample_copy = 10 # Ref count = 1 as alias was reassigned.

sample_list.clear() # Ref count = 0 as list is cleared and doesn't store the alias pointing to <100>. 
```

Reference counting can immediately reclaim objects when the reference count goes down to `0`. However, there’s a cost to this: We need to store an additional integer value for each object to indicate its reference count (a space-versus-time trade-off).

However, a problem with reference counting is the notion of **reference cycles.** If two objects, A and B, reference each other, they’re essentially in a bubble where the reference count will always be greater than or equal to `1`. This is common in lists, classes, and functions. For example, when an object refers to itself:

```python
x = []
x.append(x)
```

Or when objects cyclically refer to each other:

```python
a.attribute_1 = b
b.attribute_2 = a
```

The garbage collector periodically looks out for reference cycles and removes them. Since this an expensive process in terms of resources, this is done periodically and is scheduled. The Python Garbage Collector interface provides methods to explore the schedule and the threshold at which the garbage collection is performed.

[**gc - Garbage Collector interface - Python 3.8.3rc1 documentation**](https://docs.python.org/3.7/library/gc.html)

---

## Conclusion

I hope this article helped you.

References and further reading:

- [**How does garbage collection work in Python?**](https://www.tutorialspoint.com/How-does-garbage-collection-work-in-Python)
- [**What is a reference cycle in python?**](https://stackoverflow.com/questions/9910774/what-is-a-reference-cycle-in-python)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
