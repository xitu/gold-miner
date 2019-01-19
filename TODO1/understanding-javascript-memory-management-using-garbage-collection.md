> * 原文地址：[Understanding JavaScript Memory Management using Garbage Collection](https://medium.com/front-end-weekly/understanding-javascript-memory-management-using-garbage-collection-35ed4954a67f)
> * 原文作者：[Kewal Kothari](https://medium.com/@kewal.kothari)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-javascript-memory-management-using-garbage-collection.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-javascript-memory-management-using-garbage-collection.md)
> * 译者：[wuzhengyan2015](https://github.com/wuzhengyan2015)
> * 校对者：

# 通过垃圾回收机制理解 JavaScript 内存管理

![](https://cdn-images-1.medium.com/max/800/0*US4yPDoZAq8_44_H)

照片来自 [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral) 上的 [Dlanor S](https://unsplash.com/@dlanor_s?utm_source=medium&utm_medium=referral)

内存管理的主要目标是在请求时为系统动态地分配内存，然后释放那些不再使用的对象的内存。像 C、C++ 这样的语言有基本的内存分配函数，如 ``malloc()``， 而一些高级语言计算机体系结构（如JavaScript）包含垃圾回收器来完成这项工作。它跟踪内存分配并识别这些分配的内存是否不再使用，如果是就自动释放。但是这种算法不能完全决定内存是否仍被需要。因此，对于程序员来说，理解并决定一段特定的代码是否需要内存是非常重要的。让我们了解一下 JavaScript 中的垃圾收集是如何工作的：

#### 垃圾回收

JavaScript 引擎的垃圾回收器基本上是寻找从内存中删除的无法访问的对象。这里我想解释两种垃圾回收算法，如下所示：

*   引用计数垃圾回收
*   标记清除算法

#### 引用计数垃圾回收

这是一个简单的垃圾回收算法。这个算法寻找那些没有被引用的对象。如果一个对象没有被引用，那么该对象就可以被垃圾回收。

```
var obj1 = {
    property1: {
         subproperty1: 20
     }
};
```

如上例所示，让我们创建一个对象以理解这个算法。这里 `obj1` 引用了一个对象，其中的 `property1` 属性也引用了一个对象。由于 `obj1` 具有对象的引用，因此这个对象不会被垃圾回收。

```
var obj2 = obj1;

obj1 = "some random text"
```

现在，`obj2` 也引用了被 `obj1` 引用的同一个对象，但后来 `obj1` 被更新为了 `"some random text"`，这导致 `obj2` 具有对该对象的唯一引用。

```
var obj_property1 = obj2.property1;
```

现在 `obj_property1` 指向 `obj2.property1`，它引用了一个对象。因此该对象有两个引用，如下所示：

1.  作为 `obj2` 的属性
2.  在变量 `obj_property1` 中

```
obj2 = "some random text"
```

通过更新为 `"some random text"` 来取消 `obj2` 对对象的引用。因此，之前拥有的这个对象似乎没有引用了，并且可以被垃圾回收了。但是，由于 `obj_property1` 具有 `obj2.property1` 的引用，所以这可能是错误的。

```
obj_property1 = null;
```

当我们把 `obj_property1` 引用删除，现在最初 `obj1` 指向的对象没有引用了。所以现在它可以被垃圾回收。

#### 这个算法在哪里失败了?

```
function example() {
     var obj1 = {
         property1 : {
              subproperty1: 20
         }
     };
     var obj2 = obj1.property1;
     obj2.property1 = obj1;
     return 'some random text'
}

example();
```

这里引用计数算法在函数调用之后不会从内存中删除 `obj1` 和 `obj2` ，因为两个对象都是相互引用的。

* * *

#### 标记清除算法

这个算法查找从根开始无法访问的对象，这个根是 JavaScript 的全局对象。该算法克服了引用计数算法的局限性。没有引用的对象是不可访问的，反之亦然。

```
var obj1 = {
     property1: 35
}
```

![](https://cdn-images-1.medium.com/max/800/1*d-1V74jWR6gqkBxHhlom4A.png)

如上所示，我们可以看到创建的对象 `obj1` 如何从 ROOT 中访问到的。

```
obj1 = null
```

![](https://cdn-images-1.medium.com/max/800/1*Qc2ts7uiKU69rxLF5mYWcw.png)

现在，当我们将 `obj1` 的值设置为 `null` 时，该对象从根开始无法被访问，因此它可以被垃圾回收。

该算法从根开始，遍历所有其他对象，同时标记它们。它进一步遍历被遍历的对象并标记它们。这个过程一直持续到算法在标记所有已遍历的节点时没有子节点或任何可遍历的路径。现在垃圾回收器会忽略所有可访问对象，因为它们在遍历时被标记。因此，所有未标记的对象显然都是从根节点开始无法访问的，这使得它们可以被垃圾回收，稍后通过删除这些对象释放内存。让我们通过下面的例子来试着理解一下：

![](https://cdn-images-1.medium.com/max/800/1*xndeuwtgCays2lrx2OKoMQ.png)

如上所示，这就是对象结构的样子。我们可以注意到无法从根目录访问的对象，但是让我们尝试了解在这种情况下标记清除算法是如何工作的。

![](https://cdn-images-1.medium.com/max/800/1*TRr31SbiGWjPHnOwC1oB3w.png)

算法开始标记那些从根开始遍历到的对象。上面的图片中，我们可以注意到在对象上标记的绿色圆圈。这样它就可以将对象标识为可从根开始可以访问到。

![](https://cdn-images-1.medium.com/max/800/1*oRCgCwBeCTfS457p43_hPg.png)

那些未标记的对象事无法从根开始被访问到。因此，他们利用被垃圾回收。

#### 局限性

对象必须显式地设置为不可访问。

> 自 2012 年以来，JavaScript 引擎已经使用此算法来代替引用计数垃圾回收。

谢谢阅读。

* * *

#### 进一步阅读：

- [**V8 之旅: 垃圾回收**： 在前几篇文章中，我们深入研究了 V8 JavaScript 引擎的实现。我们讨论了...](http://jayconrod.com/posts/55/a-tour-of-v8-garbage-collection "http://jayconrod.com/posts/55/a-tour-of-v8-garbage-collection")

- [**thlorenz/v8-perf**: ⏱️ v8 相关的注释和资源以及Node.js性能 - thlorenz/v8-perf](https://github.com/thlorenz/v8-perf/blob/master/gc.md "https://github.com/thlorenz/v8-perf/blob/master/gc.md")

- [**内存管理**：像 C 这样的底层语言具有手动内存管理基础，如 malloc() 和 free()。 相反...](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Memory_Management "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Memory_Management")

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
