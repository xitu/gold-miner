> * 原文地址：[Android App Optimization Using ArrayMap and SparseArray](https://medium.com/@amitshekhar/android-app-optimization-using-arraymap-and-sparsearray-f2b4e2e3dc47#.w9iubhupn)
* 原文作者：[Amit Shekhar](https://medium.com/@amitshekhar)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jamweak](https://github.com/jamweak)
* 校对者：[Jacksonke](https://github.com/jacksonke), [Siegeout](https://github.com/siegeout)

# 如何通过 ArrayMap 和 SparseArray 优化 Android App


这篇文章会讲述为何要使用 **ArrayMap** 和 **SparseArray** 来优化 Android 应用，以及什么情形下适用。

当你需要存储**键 -> 值**这样的数据类型时，你脑海里想到的第一个数据类型应该是 **HashMap**。然后你开始肆无忌惮地到处使用它，而从不考虑它所带来的副作用。

当你使用 HashMap 时，你的 Android 集成开发环境 (Android Studio) 会给出警告，提示你使用 ArrayMap 来代替 HashMap，但通常被你忽视了。

Android 给你提供了 ArrayMap，你应该优先考虑使用它而不是 HashMap。

现在，让我们来理解 ArrayMap 的内部实现，以便探求在哪种场景下使用它，以及为什么这样做。

#### HashMap vs ArrayMap


HashMap 的位置在 _java.util.HashMap_ 包中。

ArrayMap 的位置在 _android.util.ArrayMap_ 和 _android.support.v4.util.ArrayMap_ 包中。

它存在于 support.v4 包中，以便兼容较低的 Android 版本。

[这里](https://www.youtube.com/watch?v=ORgucLTtTDI) 是直接出自 Android 开发者频道的 youtube 视频，强烈建议你看一下。

ArrayMap 是一种通用的键->值映射数据结构，它在设计上比传统的 HashMap 更多考虑内存优化。 它使用两个数组来存储数据——一个整型数组存储键的哈希值，另一个对象数组存储键/值对。这样既能避免为每个存入 map 中的键创建额外的对象，还能更积极地控制这些数组的长度的增加（因为增加长度只需拷贝数组中的键，而不是重新构建一个哈希表）。

需要注意的是，ArrayMap 并不适用于可能含有大量条目的数据类型。它通常比 HashMap 要慢，因为在查找时需要进行二分查找，增加或删除时，需要在数组中插入或删除键。对于一个最多含有几百条目的容器来说，它们的性能差异并不巨大，相差不到 50%。

#### HashMap

HashMap 基本上就是一个 HashMap.Entry 的数组（Entry 是 HashMap 的一个内部类）。更准确来说，Entry 类中包含以下字段：

*   一个非基本数据类型的 key
*   一个非基本数据类型的 value
*   保存对象的哈希值
*   指向下一个 Entry 的指针

当有键值对插入时，HashMap 会发生什么 ?

*   首先，键的哈希值被计算出来，然后这个值会赋给 Entry 类中对应的 hashCode 变量。
*   然后，使用这个哈希值找到它将要被存入的数组中“桶”的索引。
*   如果该位置的“桶”中已经有一个元素，那么新的元素会被插入到“桶”的头部，next 指向上一个元素——本质上使“桶”形成链表。

现在，当你用 key 去查询值时，时间复杂度是 O(1)。

虽然时间上 HashMap 更快，但同时它也花费了更多的内存空间。

缺点:

*   自动装箱的存在意味着每一次插入都会有额外的对象创建。这跟垃圾回收机制一样也会影响到内存的利用。
*   HashMap.Entry 对象本身是一层额外需要被创建以及被垃圾回收的对象。
*   “桶” 在 HashMap 每次被压缩或扩容的时候都会被重新安排。这个操作会随着对象数量的增长而变得开销极大。

在Android中，当涉及到快速响应的应用时，内存至关重要，因为持续地分发和释放内存会出发垃圾回收机制，这会拖慢应用运行。

**垃圾回收机制会影响应用性能表现**

垃圾回收时间段内，应用程序是不会运行的，最终应用使用上就显得卡顿。

#### ArrayMap

ArrayMap 使用2个数组。它的对象实例内部有用来存储对象的 Object[] mArray 和 存储哈希值的 int[] mHashes。当插入一个键值对时：

*   键/值被自动装箱。
*   键对象被插入到 mArray[] 数组中的下一个空闲位置。
*   值对象也会被插入到 mArray[] 数组中与键对象相邻的位置。
*   键的哈希值会被计算出来并被插入到 mHashes[] 数组中的下一个空闲位置。

对于查找一个 key :

*   键的哈希值先被计算出来
*   在 mHashes[] 数组中二分查找此哈希值。这表明查找的时间复杂度增加到了 O(logN)。
*   一旦得到了哈希值所对应的索引 index，键值对中的键就存储在 mArray[2*index] ，值存储在  mArray[2*index+1]。
*   这里的时间复杂度从 O(1) 上升到 O(logN)，但是内存效率提升了。当我们在 100 左右的数据量范围内尝试时，没有耗时的问题，察觉不到时间上的差异，但我们应用的内存效率获得了提高。
   
#### 推荐的数据结构:

*   **ArrayMap&lt;K,V> 替代 HashMap&lt;K,V>**
*   **ArraySet&lt;K,V> 替代 HashSet&lt;K,V>**
*   **SparseArray&lt;V> 替代 HashMap&lt;Integer,V>**
*   **SparseBooleanArray 替代 HashMap&lt;Integer,Boolean>**
*   **SparseIntArray 替代 HashMap&lt;Integer,Integer>**
*   **SparseLongArray 替代 HashMap&lt;Integer,Long>**
*   **LongSparseArray&lt;V> 替代 HashMap&lt;Long,V>**
