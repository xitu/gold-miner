> * 原文地址：[Garbage Collection in Python](https://medium.com/better-programming/garbage-collection-in-python-6dca154ae1dd)
> * 原文作者：[Raivat Shah](https://medium.com/@raivat)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/garbage-collection-in-python.md](https://github.com/xitu/gold-miner/blob/master/article/2020/garbage-collection-in-python.md)
> * 译者：[chaingangway](https://github.com/chaingangway)
> * 校对者：[江不知](https://github.com/JalanJiang)、[PingHGao](https://github.com/PingHGao)

# Python 内存管理之垃圾回收

![Artwork created by [Katerina Limpitsouni](https://twitter.com/ninalimpi)](https://cdn-images-1.medium.com/max/2298/1*GPhtmRdktXK9Aldvyl02yw.png)

如果您已经编码过一段时间，那么您可能听说过**垃圾回收**。在本文中，我们将更深入地研究它的功能和原理。

## What 和 Why

在现实世界中，我们会清理掉一些东西 —— 例如旧笔记，不再需要的盒子 —— 将它们丢弃在垃圾桶或者回收箱中。因为存储的空间有限，所以我们要为其它重要的物品腾出存储空间。

同样地，在计算机中，空间 —— 也称为**内存**是重要且有限的资源。因此，垃圾回收器会收集不再需要的数据对象并将其丢弃。

垃圾回收可以是自动的也可以是手动的，它取决于不同的编程语言。在大多数高级语言（例如 Python 和 Java）中，它是自动的。因此，这些语言称为**垃圾回收语言**。其它语言（例如 C）不支持自动垃圾回收，程序员负责内存管理。

下面我们来看看垃圾回收的原理。

## How

垃圾回收原理中有一些不同的技术，但大多数垃圾回收语言（包括 Python）都使用**引用计数**。在引用计数中，我们记录对象的引用数，并在计数为 0 时丢弃对象。

对象的引用计数随着指向该对象的别名数量的变化而变化。给对象分配新名称或将其放置在列表或字典等容器中时，引用计数会增加。当使用 `del` 命令删除对象，引用超出范围或重新分配对象时，计数会减少。例如：

```python
sample = 100 # 创建 <100> 对象，引用计数 = 1。

sample_copy = sample # 引用计数 = 2. 

sample_list = [sample] # 引用计数 = 3.

del sample # 引用计数 = 2。注意这里不会影响 sample_copy 和 sample_list，因为它们直接指向 <100>。
sample_copy = 10 # 引用计数 = 1，因为变量重新分配了。

sample_list.clear() # 引用计数 = 0，当 list 清空后就不会存储指向 <100> 的变量了。
```

当引用计数下降到 `0` 时，对象会被立即回收。但是这样做有一个代价：我们需要为每个对象存储一个附加的整数值，以指示其引用计数（空间与时间的权衡）。

但是，引用计数系统中存在 **循环引用** 的问题。如果两个对象 A 和 B 互相引用，则它们的引用计数将会始终大于或等于 `1`。这种情况在列表、类和函数中很常见。例如，当对象引用自身时：

```python
x = []
x.append(x)
```

或者当对象相互引用时：

```python
a.attribute_1 = b
b.attribute_2 = a
```

垃圾回收器会定期找出循环引用并将其删除。这个过程会耗费昂贵的资源，所以它是定期执行的并且是可计划的。Python 中的垃圾回收器接口提供了一些方法，您可以用它们来探索执行垃圾回收的计划和阈值。

[**gc - 垃圾回收器接口 - Python 3.8.3rc1 文档**](https://docs.python.org/3.7/library/gc.html)

---

## 结论


希望本文能帮到你。
请进一步阅读以下参考资料：

- [**Python 中垃圾回收的原理是什么？**](https://www.tutorialspoint.com/How-does-garbage-collection-work-in-Python)
- [**Python 中的循环引用是什么？**](https://stackoverflow.com/questions/9910774/what-is-a-reference-cycle-in-python)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
