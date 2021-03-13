> * 原文地址：[Lists and Tuples in Python](https://medium.com/python-in-plain-english/python-lists-and-tuples-760d45ebeaa8)
> * 原文作者：[Mayur Jain](https://medium.com/@mayur-ds)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/python-lists-and-tuples.md](https://github.com/xitu/gold-miner/blob/master/article/2021/python-lists-and-tuples.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[zenblo](https://github.com/zenblo)、[lsvih](https://github.com/lsvih)

# Python 中的列表和元组

要编写一个高效的程序，我们需要了解两件事事：**首先是程序的输入内容是什么，其次是我们应该如何选择最合适的数据结构来处理该输入。**

在这篇博文中，我们将会在与 **dict**、**set** 等其他数据结构的比较中了解数据结构 **List** 和 **Tuple** 以及它可以有效处理的输入内容。

列表和元组属于一类称为**数组**的数据结构。数组是元素的集合，而这些元素的顺序或位置与元素本身一样重要。因为定义数组时我们给定了位置或索引，所以找到元素需要的时间复杂度为 O(1)。

> 列表是一个动态数组，我们可以在其中修改和调整存储在其中的数据的大小。
> 元组是一个静态数组，其元素是固定且不可变的。元组由 Python 运行时缓存，这意味着我们不需要在每次我们需要使用一个元组的时候 Python 不需要与内核对话来获得保留这个元组的内存。

在计算机系统中，存储器是一系列编号的分配存储块，每个分配存储块都可以容纳一个数字。Python 通过引用将数据存储在这些分配存储块中。这意味着数字本身只是指向或引用了我们实际关心的数据。

![**一个存储了长度为 6 的数组系统内存布局**](https://cdn-images-1.medium.com/max/2664/1*r3B7WgUsBJeYQmExYERwig.png)

当创建列表或元组时，我们需要分配一个系统存储块，该块的每个部分都使用整数指针进行引用。为了查找列表中的任何特定元素，我们应该知道分配存储块的编号和所需的元素。

例如，假设我们有一个从**分配存储块编号** **S** 开始的数组，要找到该数组中的第 5 个元素，我们可以直接搜索分配存储块编号 **S + 5** ，同样类推到数组中的 i 元素。但是，如果分配存储块编号不适用于给定的数组，那么我们需要在整个数组中执行元素搜索，时间复杂度会随着数组大小的增加而增加。此搜索也称为**线性搜索**。最坏的情况是 O(n)，其中 n 是列表中元素的总数。如果列表已排序，则可以使用其他有效的搜索算法来搜索数组中的元素如二分法。

为了进行搜索和排序，Python 内置了 **__eq__**、**__lt__** 等比较方法，并且 Python 中的列表内置有 TimSort 的内置排序算法，而它的最佳情况是 O(n)，最坏的情况是 O(nlog n)。

排序完成后，我们可以进行二分法，一个平均复杂度为 O(log n) 的排序方法。它是通过查看列表的中间并将此值与所需值进行比较来实现查找的。如果中点的值小于我们的期望值，程序就会去比较列表的右半部分，然后继续像这样将列表不断缩小，直到找到该值或知道该值不会出现在已排序列表中为止。我们不需要像线性搜索那样需要读取列表中的所有值。相反，我们仅读取其中的一小部分。

注意：我们可以使用 Python 标准库中的 **bisect** 模块，该模块可以将元素添加到列表中、并保持排序顺序。

**LISTS 列表**

List 是一个动态数组，所以它可以使用调整大小操作，且它也支持动态更改。

如果有一个大小为 N 的列表 A，如果将新项目附加到列表 A，则 Python 会创建一个足够容纳 N 个元素以及更多元素的新列表。即，Python 中的列表的创建，不是分配能够容纳 N + 1 个元素的数组，而是分配能够容纳 M 个元素（ M > N ）的数组。当 Python 复制旧列表到新列表的时候，它会随即删除或销毁旧列表。我们建议在首次分配时请求额外的空间，以减少后续分配的次数 —— 出于内存复制的消耗系统资源之大，列表元素的增加会严重影响程序运行速度。

**List 的分配方程**

```python
M = (N >> 3) + (3 if N < 9 else 6)
```

![列表的 "过度" 分配](https://cdn-images-1.medium.com/max/2134/1*mYYlsNHqfxdvdSUUmlSARQ.png)

该图显示列表尺寸与额外元素的关系。例如，如果使用创建了一个包含 8000 个元素的列表，Python 将返回一个能够容纳大约 8,600 个元素的列表，也就是会多分配 600 个元素的空间！

![**追加元素对列表理解的记忆和时间的影响**](https://cdn-images-1.medium.com/max/2000/1*Tb-UGxpj6tL93pKUo8EXUg.png)

当我们构建了一个列表并且添加元素时候，我们使用了 2.7 倍的内存。与创建列表相比，添加元素时候分配给列表的额外空间要大得多。

**TUPLES 元组**

元组是静态的，也就是说，一旦创建了元组，与列表不同，我们再也无法对其进行修改或调整其大小。

**特性 1：静态性**

```python
>>> t = (1, 2, 3, 4)
>>> t[0] = 5
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: 'tuple' object does not support item assignment
```

**特性 2：可连接性**

```python
>>> t1 = (1, 2, 3, 4)
>>> t2 = (5, 6, 7, 8)
>>> t1 + t2
(1, 2, 3, 4, 5, 6, 7, 8)
```

现在，如果我们考虑将连接操作与列表的 `append` 操作放在一起，一起使用，那么有趣的是，元组连接所花费的时间将会是 O(n)，而列表所花费的时间为 O(1)。因为列表是追加元素的，所以列表中只要有多余的空间即可。对于元组，每当将一个新元素连接到现有元组时，它就会在不同的内存位置上创建一个新的元组，从而使连接花费 O(n) 时间（因为对于元组来说没有直接添加元素的方法可用）。

元组被认为是轻量的 —— 与列表不同，元组仅占用数据所需的内存。所以说，**如果数据是静态的，我们建议大家去使用元组。**

使用元组的另一个好处是**资源回收** —— Python 是支持垃圾回收的，这意味着，当我们不再使用某个变量的时候，它将释放其内存，并将其返回给系统，以便将该内存分配给其他应用程序或变量。对于元组，如果不再使用元组空间，Python 会保留它的内存，并且如果将来需要该大小的内存，则 Python 不会去向系统寻求新的内存，而是直接分配自己保留下来的内存 —— 极大程度上避免了向系统再度调用内存块，节省了时间，优化了资源的配置。

**List 和 Tuple 的实例**

```python
>>> %timeit l = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
95 ns ± 1.87 ns per loop (mean ± std. dev. of 7 runs, 10000000 loops each)

>>> %timeit t = (0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
12.5 ns ± 0.199 ns per loop (mean ± std. dev. of 7 runs, 100000000 loops each)
```

列表和元组都有优点和缺点，但是重要的是要牢记它们的特性 —— 例如列表中的过度分配以及元组中的静态和缓存资源，同时将其用作可能的数据结构。

希望你会喜欢阅读本文！

**参考资料**

[High Performance Python book](https://www.oreilly.com/library/view/high-performance-python/9781449361747/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
