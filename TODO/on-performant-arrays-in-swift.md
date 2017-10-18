> * 原文地址：[On Performant Arrays in Swift](http://jordansmith.io/on-performant-arrays-in-swift/)
> * 原文作者：[JORDAN SMITH](http://jordansmith.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/on-performant-arrays-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO/on-performant-arrays-in-swift.md)
> * 译者：[jingzhilehuakai](https://github.com/jingzhilehuakai)
> * 校对者：

# Swift 上的高性能数组

对于日常应用开发，考虑数组性能是一件不会经常发生的事。如果你正在实现需要扩展的算法，也许高性能数组就能出现在你脑海中。对一个框架来说，也许你正在使用较低级的代码工作，在这种情况下，任何的性能缺陷都会产生复合效应。当它变得相关联的时候，了解一点我们拥有的选择也是很不错的。让我们来深入的了解一下 Swift 中的数组吧。

## 连续的数组

[`Array`](https://developer.apple.com/documentation/swift/array) 不是 Swift 唯一提供的数组类型。你可能已经注意到 [`ArraySlice`](https://developer.apple.com/documentation/swift/arrayslice) 类型，它将未复制的视图显示在另一个数组的段中。也被称作 [`ContiguousArray`](https://developer.apple.com/documentation/swift/contiguousarray) 类型。与名称不同，它其实是 Swift 中最简单的数组类型。它能比标准的数组具有更高的性能，即使没有，它提供与 `Array` 相同的性能水平。同时也暴露出相同的接口。所以，为什么不用 `ContiguousArray` 去替代 `Array` 呢？

```
let deliciousArray = ContiguousArray<String>(arrayLiteral: "🌮", "🥞", "🥖")
```

好吧，因为 Objective-C 的兼容性，`Array` 能无缝对接成一个 `NSArray`。在底层，一个 `Array` 实例只要它的元素类型是 class 或 Objective-C 兼容协议，就会将数组数据存储在 `NSArray` 中。只要不是这种情况（例如值类型的数组），这个数组就不会被 `NSArray` 支持，并且性能变得和 `ContiguousArray` 相当。

为了比较性能，我们运行了这样一个测试，向每个数组的实例中添加一百万个单独的引用类型，然后删除。这些引用类型会在开始计时前进行预构建，并且结果是在超过 100 次的运行后得到的平均值。下面的值是通过使用一种优化的编译器设置获得的。总的来说，你可以看到，如果数组性能是瓶颈的话，要是数组元素是一个引用类型或 `@objc` 类型，或许通过切换到 `ContiguousArray` 能让你获得约 2 倍的提升。

| **Array** | **ContiguousArray** |
| ---------- | ------------------ |
| 58.9 ms | 30.3 ms |

## Array Capacity

看起来 Swift 数组分配的内存与它的长度成正比。如果是这种情况，添加或删除一个元素将需要分配或释放内存，并对数组长度的每一个变化都造成性能损失。相反，提前分配最少的内存空间是更有意义的，这样就可以在不引起内存管理性能损失的情况下进行接下来的几个新增操作。这实际上是 Swift 所做的：以一种智能的方式进行内存分配，来让分配性能消耗保持在最低的水平。

尽管有智能内存分配，但分配内存最有效的方式是如果你知道数组应该被定义持有的容量。这样，只需要一个内存分配就可以了。 Swift 数组提供了定义和预留容量的能力，而且这样做可以实现较小的性能增益。


```
var healthyArray = ["🍉", "🥕"]
healthyArray.reserveCapacity(50)
```

运行另一个测试，再次向一个数组中添加和删除一百万个引用类型，产生以下的结果。该测试是针对连续数组有无预留内存容量的情况。

| **Without Reserved Capacity** | **With Reserved Capacity** |
| ------------------------------ | ------------------------- |
| 29.7 ms | 27.3 ms |

## C 类型数组

如果你想访问原始内存来支撑数组，你也可以这么做。对于标准的数组操作，它不应该提供太多的性能增益。对于非标准的情况，用这种方式访问或修改数据可能是有必要的，或者是对性能有益的。

```
var balancedDietArray = ["🥖", "🍩", "🍗"]
balancedDietArray.withUnsafeMutableBufferPointer { arrayPointer in
    arrayPointer[1] = "🍇"
}
```

---
如果你想了解更多关于 Swift 数组是如何工作的，可以在这里找到更多的内容：[Swift Array Design](https://github.com/apple/swift/blob/master/docs/Arrays.rst)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


