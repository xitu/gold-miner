> * 原文地址：[An Analysis of Hash Map Implementations in Popular Languages](https://rcoh.me/posts/hash-map-analysis/)
> * 原文作者：[Russell Cohen](https://rcoh.me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/hash-map-analysis.md](https://github.com/xitu/gold-miner/blob/master/article/2022/hash-map-analysis.md)
> * 译者：[wangxuanni](https://github.com/wangxuanni)
> * 校对者：[Quincy_Ye](https://github.com/Quincy-Ye)，[CompetitiveLin](https://github.com/CompetitiveLin)

# 分析哈希表在主流语言中的实现

在现实世界的开发中，很少有数据结构比哈希表更常见。几乎每一个主流的编程都会在标准库中实现或内置到运行时中。然而现在还没有一个最佳、一致的实现策略，所以主流的编程语言在实现上大相径庭！我对 Go、Python、Ruby、Java、C#、C++ 和 Scala 中的哈希表实现进行了调查，比较和对比它们的实现方式。

**注意：本文的其余部分假定您了解哈希表如何工作以及实现它们的最常见方案的知识。** 如您需要重温， [维基百科](https://en.wikipedia.org/wiki/Hash_table)提供了一个相当易读的解释。除了基础知识之外，关于[链表](https://en.wikipedia.org/wiki/Hash_table#Separate_chaining)和[开放寻址法](https://en.wikipedia.org/wiki/Hash_table#Open_addressing) 也提供足够的背景知识。

对于每一个哈希表我会比较：

* **方案**：哈希表是怎么处理碰撞的？有什么选择策略的优化？
* **增长率**：当哈希表扩容时，会增大多少？
* **负载因子**：哈希表多满才会触发扩容？ ( `num_keys/slots ` 的占比）

要记住的一些词汇：

* **扰动函数**: 下面许多哈希表的大小永远是 2 的幂。因此 `n % (i**2)` 相当于没有使用高位的比特。为了解决这个问题，哈希表通过异或或简单的数字加法将哈希码的某些部分与自身结合起来。以确保不会丢失来自高位比特的影响。
* **逻辑删除**：在开放寻址法中，当一个元素被删除时，它必须被标记为已删除而不是实际物理删除。这样一来，搜索处于链中更下游的元素时，会在命中“逻辑删除”时继续。

尽管所有的实现都有很大不同，但仍然存在某些共同点：

* 开放寻址法（Python、Ruby、C++）和链表法（Java、Scala、Go）的表现大致相同。
* 在调查的语言中没有像 [cuckoo hashing](https://en.wikipedia.org/wiki/Cuckoo_hashing) 这样“奇特的”的实现，尽管大多数实现包括不同程度的优化，使代码看起来很复杂。
* 大多数语言都试图通过在过程中的某个时刻混合低位和高位来向哈希码添加熵。因为这些语言的原始类型包含低熵的散列函数，所以这是必要的。
* 增长至少 2 倍。大多数保证大小始终是 2 的幂。

关于细节：

## Python (CPython)

[源代码](https://github.com/python/cpython/blob/master/Objects/dictobject.c) [注释](https://github.com/python/cpython/blob/master/Objects/dictnotes.txt)

**方案:** 自定义开放寻址序列。这个序列是

```
next = ((5*prev) + 1 + perturb) % TABLE_SIZE
```

`perturb` 最初是哈希码。 对于链中的每个连续元素， `perturb = perturb >> 5`。如果 perturb 从 2^32 开始，它将影响链表中的前 7 个元素。这很有趣，因为它不是每个人都在学校学习过线性或二次探测。

**增长率：** 至少两倍，并且大小永远是 2 的平方。在没有删除的情况下，大小会翻倍。由于是逻辑删除的（见上文对逻辑删除的解释），我们有可能有很长的链表而实际大小不满足负载因子。增长率是 `NUM_ITEMS*2+capacity/2`.[^1]  通过考虑哈希表的大小，确保在触发扩容时哈希表始终增长。

**负载因子：** 0.66

其他注意事项：

* 尽管 Ruby 使用不同的扰动策略，但它们都使用相同的底层探测方案 `next = (prev * 5) + 1 mod TABLE_SIZE)`
* 实现键是 unicode 字符串 [^2] 的特殊情况哈希表。这样做的动机来自于这样一个事实，即 Python 内部许多都依赖于带有 unicode 键的字典（例如，查找局部变量）[^3]
    * 只有字符串键，键直接存储到数组中，指向值的指针存储在单独的数组中。这启用了一些优化，并且意味着在读取键时不需要指针取消引用。
    * 对于非字符串键，键值对一起存储在一个结构中，并使这些结构位于一个数组中。
* 因 Python 中的整数 hash(i) == i 表现不佳的哈希函数，关注和大量调整了扰动策略。
* 根据经验调整了很多魔法数[^4]
* 在 `3.3.0`.[^1]，增长率从 `used*4` 变为 `used*2` 

## Ruby

[源代码](https://github.com/ruby/ruby/blob/trunk/st.c) [注释](https://github.com/ruby/ruby/blob/trunk/st.c#L1-L96)

**方案放寻址法：** 开放寻址法使用`j = ((5*j) + 1 + perturb) mod TABLE_SIZE` 。这与 Python 结构大体相同，但它们使用的扰动策略有些不同。

**增长率：** 2x。插槽数始终是 2 的幂。

**负载因子：** 0.5

其他注意事项：

* 旧实现使用链表。据说新实现快 40%[^5]
* Entries 数组（用于快速迭代）从 bins 数组中拆分出来用于哈希查找
* 小的数组没有使用 bin，而是使用了线性扫描。
* Ruby 尝试了二次规划（你可以在编译时打开它`#define QUADRATIC_PROBE`），但实践中速度较慢。[^6]

## Java

**方案：** 链表，当链表的长度大于 8 时，链表转换为 TreeMap 。这种转换在以下情况下最有帮助：

* K 实现 `Comparable<>` 接口
* 哈希码与表的大小取模时发生碰撞，但哈希码与表的大小不相等

**增长率：** 2x。插槽数始终是 2 的幂。

**负载因子：** 0.75

其他注意事项：

* 由于 Java 哈希表的大小始终为 2 的幂，因此当使用 hash_code % tablesize 时，高位比特没有派上用场，直到哈希表为 2^32 。为了解决这个问题，Java 将哈希码与自身进行异或运算，右移 16 位。这确保了高位比特具有一定的影响。 `int h = key.hashCode(); h = h ^ h >>> 16;`
* 当扩容时，元素会进入两个位置之一， `k` 或者 `k+oldSize`。这是每次扩容两倍的便利之处。
* 代码真的很难理解，主要是因为树和链表之间相互转化。

## Scala

### 不变的哈希表

[源代码](https://github.com/scala/scala/blob/2.12.x/src/library/scala/collection/immutable/HashMap.scala) Scala 中的大多数哈希表是不可变，所以我将首先讨论它。

**方案:** 链表哈希树。哈希树是一种递归数据结构（因此树是朝向下的）。[Scala 文档](http://docs.scala-lang.org/overviews/collections/concrete-immutable-collection-classes.html#hash-tries)提供了一个不错的解释。如需更深入的了解，[Phil Bagwell 的论文](https://infoscience.epfl.ch/record/64398/files/idealhashtrees.pdf)是极好的资源。我将提供一个简短的总结：

对于大小为 0 到 4 的哈希表，它使用硬编码哈希表。对于较大的哈希表，它使用哈希树。哈希树的每层都考虑哈希码的一些位子集。当插入或检索时，使用位的下一个子集作为参数，递归的去树的分支里匹配比特位。Scala 哈希树的实现有 32 个分支因子，因此每一层考虑哈希码的是 5 个字节（2^5 = 32）。由于哈希码在 Java / Scala 是 32 位的整数，这意味着如果所有的哈希码是唯一的，哈希树将存储  2^32 个元素而不会发生冲突。

如果散列码相同，则使用链表，包含在[`HashMapCollision`](https://github.com/scala/scala/blob/2.12.x/src/library/scala/collection/immutable/HashMap.scala#L239)数据结构中。

Scala 还提供了一个可变的哈希表。由于它缺乏那些我看过语言们的优化，因此它是唯一一个看起来简单明了的。

### 可变的哈希表

[源代码](https://github.com/scala/scala/blob/2.12.x/src/library/scala/collection/mutable/HashTable.scala)

**方案：** 使用链表链接

**增长率：** 2x

**负载因子：** 0.75

其他注意事项：

* 这是我最初期望的哈希表的样子，它小于 500 行，核心代码小于 100 行，它简单明了，不复杂并且易于阅读。
* 与许多其他实现一样，它试图通过一些混合来增加传入哈希码的熵：

```
var h: Int = hcode + ~(hcode << 9)
h = h ^ (h >>> 14)
h = h + (h << 4)
h ^ (h >>> 10)
```

## Golang

[源代码](https://github.com/golang/go/blob/master/src/runtime/hashmap.go)

**方案:** 进行了一些优化的链表。链表由桶组成。每个桶有 8 个槽。一旦所有 8 个槽都被用完，溢出桶将链接到第一个桶。在连续内存中存储 8 个键值对减少了读取和写入哈希表时的内存访问量和内存分配量。

**增长率：** 2x。当发生大量删除时，分配一个相同大小的哈希表来对未使用的桶进行垃圾收集。

**负载因子**：6.5 ！不是 6.5%，而是 6.5 倍。这意味着平均而言，当每个桶有 6.5 个元素时，哈希表将调整大小。这与其他所有使用小于 1 的负载因子的哈希表实现形成了鲜明对比。

注意事项：

* 在其他所有实现里，从旧数组往新数组拷贝的元素工作是在单个插入触发的扩容时。在 Golang 里，往新数组里移动元素的扩容操作是在越来越多键被添加的时逐步完成的！对于每个新增/更新的元素， 2 个键会被从旧数组移到新数组去，确保没有任何一次写入会引起 `O(n)` 性能。一旦全部的键都从旧数组[`撤走`](https://github.com/golang/go/blob/fbfc203/src/runtime/hashmap.go#L1006)，就数组会被重新再分配。
  
* 2 个条件可以触发扩容。
1. 元素的数量 >= 数组大小的 6.5 倍，新的数组和老的数组同一样大小。
2. 桶的数量太大了。

在 #2 的条件下，新分配的数组是和老数组同样大小的。这个看起来没有意义的行为来自于这个[提交](https://github.com/golang/go/commit/9980b70cb460f27907a003674ab1b9bea24a847c)。在删除的情况下，分配并且缓慢移动到新数组意味着我们将垃圾回收老的桶，而不是缓慢的去渗漏它们。他们选择这种方法来确保迭代器继续正常工作。
    

## C#

[源代码](https://github.com/dotnet/coreclr/blob/master/src/mscorlib/shared/System/Collections/Generic/Dictionary.cs)

**方案:** 链表

**增长率:** >2x。新大小是大于旧大小 2 倍的最小素数。

**负载因子:** 1

注意事项：

* 虽然它使用链表，但它以一种巧妙的方式进行，哈希表存储了 2 个数组。
  
1. 一个整数数组，当寻找在哈希表里面的某个 K 时，用哈希码去取模这个数组的长度，查看它在数组 #1 的下标。
2. 一个 Entry 数组，每一个 Entry 存储的一个键，一个值和同一数组中另一个 Entry 的索引。

```
private struct Entry
{
  public TKey key;        // Key of entry
  public TValue value;    // Value of entry
  public int next;        // Index of next entry, -1 if last
                          // (or only) item in chain
}
```


这里的巧妙之处在于，当我们需要去把这些条目链接在一起，我们不需要分配链表，它们已经预分配好了。此外，它们已经在一块连续的内存中，这提高了缓存的局部性。

## C++ (GCC STL)

**我原本把这一块完全搞错了，并且看的是一个错误的源代码，谢谢这位 reddit 的用户 [u/raevnos](https://www.reddit.com/user/raevnos) 让我弄清楚**

[源代码](https://github.com/gcc-mirror/gcc/blob/846deaf01bfe46e0db44402858ab1b7ee43f4023/libstdc++-v3/include/std/unordered_map) which `#includes` [实际上的源代码](https://github.com/gcc-mirror/gcc/blob/master/libstdc%2B%2B-v3/include/bits/hashtable.h)

**方案:** 链表

**增长率:** >2x。新大小是大于旧大小 2 倍的最小素数。

**负载因子:** 1

注意事项：

* C++ 标准库没有实现，但是标准库看起来要求是链表。如 [stack overflow 回答里说的那样](https://stackoverflow.com/questions/31112852/how-stdunordered-map-is-implemented)。 [往 spec 增加哈希表](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2003/n1456.html)的提案排除看直接把开放寻址法实现 c++ 标准库哈希表。
* 增长行为类似于 C#
* 表大小始终是质数。[^7] 这让我很吃惊，因为我认为 C++ 会尝试对齐 2 的幂来帮助 malloc。
* C++ 标准库是很难读懂 ;-)

### 总结

我发现在生产语言中使用的哈希表有这么多不同的实现很有意思。Ruby 从链表到开放寻址法的转变特别有趣，因为它显然在基准测试上有了相当大的改进。为 Java 或 Go 编写一个开放寻址的哈希表并比较性能将会很有趣。

[^1]: https://github.com/python/cpython/blob/60c3d35/Objects/dictobject.c#L398-L408
[^2]: https://github.com/python/cpython/blob/60c3d35/Objects/dictobject.c#L54-L63
[^3]: 也许你会惊讶，启动 Python 解释器并运行几个与字典无关的命令会导致大约 100 次字典查找
[^4]: https://github.com/python/cpython/blob/master/Objects/dictnotes.txt#L70
[^5]: https://github.com/ruby/ruby/blob/fc939f6/st.c#L93-L94
[^6]: https://github.com/ruby/ruby/blob/fc939f6/st.c#L842-L845FF
[^7]: https://github.com/gcc-mirror/gcc/blob/master/libstdc%2B%2B-v3/include/bits/unordered_map.h#L53

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
