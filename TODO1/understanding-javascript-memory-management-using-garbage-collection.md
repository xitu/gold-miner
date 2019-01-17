> * 原文地址：[Understanding JavaScript Memory Management using Garbage Collection](https://medium.com/front-end-weekly/understanding-javascript-memory-management-using-garbage-collection-35ed4954a67f)
> * 原文作者：[Kewal Kothari](https://medium.com/@kewal.kothari)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-javascript-memory-management-using-garbage-collection.md](https://github.com/xitu/gold-miner/blob/master/TODO1/understanding-javascript-memory-management-using-garbage-collection.md)
> * 译者：
> * 校对者：

# Understanding JavaScript Memory Management using Garbage Collection

![](https://cdn-images-1.medium.com/max/800/0*US4yPDoZAq8_44_H)

Photo by [Dlanor S](https://unsplash.com/@dlanor_s?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com/?utm_source=medium&utm_medium=referral)

The primary goal of memory management is to offer the system dynamically allocated memory when requested for and later free that memory containing objects that are no longer in use. Languages like C, C++ have primitive functions for memory allocation like `malloc()` where some high level language computer architectures ( like JavaScript ) include garbage collector to do this job. It tracks the memory allocation and identifies if the allocated memory is no longer used, it is then freed automatically. But such algorithms cannot completely decide if the memory is required or not. Therefore, it is very important for the programmer to understand and decide if a particular piece of code needs memory or not. Let’s understand how does the garbage collection works in JavaScript:

#### Garbage Collection

The JavaScript Engine’s Garbage collector basically looks out for unreachable objects which are removed from the memory. There are two garbage collection algorithms that I would like to explain which are as follows:

*   Reference-counting garbage collection
*   Mark-and-sweep algorithm

#### Reference-counting garbage collection

This is a naïve garbage collection algorithm. This algorithm looks out for those objects which have no references left. An object becomes eligible for garbage collection if it has no references attached to it.

```
var obj1 = {
    property1: {
         subproperty1: 20
     }
};
```

Let’s create an object as shown in the above example to understand this algorithm. Here `obj1` has an object in which its `property1` holds further one object. As the `obj1` has the reference to the object, nothing is eligible for garbage collection.

```
var obj2 = obj1;

obj1 = "some random text"
```

Now, `obj2` also has the reference to the same object that was referred by `obj1` but later `obj1` was updated with `"some random text"` which lead to `obj2` having the unique reference to that object.

```
var obj_property1 = obj2.property1;
```

Now `obj_property1` refers to `obj2.property1` which also holds an object. Therefore that object has two references which are as follows:

1.  As a property of `obj2`
2.  In the variable `obj_property1`

```
obj2 = "some random text"
```

`obj2` has been unreferenced by updating `"some random text"`. Therefore it might seem that the object it held before has no references to it and can be garbage collected. But that might be wrong to say as `obj_property1`has the reference of `obj2.property1`. Therefore it won’t be garbage collected.

```
obj_property1 = null;
```

Now the object which was originally in `obj1` has no references left as we removed the reference from `obj_property1`. So now it can be garbage collected.

#### Where does this algorithm fail?

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

Here the reference counting algorithm does not remove `obj1` and `obj2` from the memory after the function call, since both the objects are referenced by each other.

* * *

#### Mark-and-Sweep Algorithm

This algorithm looks out for objects which are unreachable from the root which is the JavaScript’s global object. This algorithm overcomes the limitations of Reference-counting algorithm. As an object with no references would be unreachable but not vice-versa.

```
var obj1 = {
     property1: 35
}
```

![](https://cdn-images-1.medium.com/max/800/1*d-1V74jWR6gqkBxHhlom4A.png)

As shown above, we can see how the created object `obj1` becomes reachable from the ROOT.

```
obj1 = null
```

![](https://cdn-images-1.medium.com/max/800/1*Qc2ts7uiKU69rxLF5mYWcw.png)

Now when we set the value of `obj1`to `null` the object is no more reachable from the ROOT and hence it is garbage collected.

This algorithm starts from the root and traverses down to all other objects while marking them . It further traverses through the traversed objects and marks them. This process continues till the algorithm has no child nodes or any path left to traverse while marking all the nodes that have been traversed. Now the garbage collector ignores all the reachable objects as they were marked while traversing. So all the objects that were not marked were clearly unreachable to the root which makes them eligible for garbage collection and later the memory is freed by removing those objects. Let’s try and understand by looking at the following instance:

![](https://cdn-images-1.medium.com/max/800/1*xndeuwtgCays2lrx2OKoMQ.png)

As shown above, this is how an object structure would look like. We can notice the objects which are not reachable from the root but let’s try to understand how would Mark-and-Sweep algorithm work in this case.

![](https://cdn-images-1.medium.com/max/800/1*TRr31SbiGWjPHnOwC1oB3w.png)

Algorithm starts marking the objects which it traverses starting from the root. In the above image we can notice the green circles which are marked on the objects. So that it identifies the objects as reachable from the root.

![](https://cdn-images-1.medium.com/max/800/1*oRCgCwBeCTfS457p43_hPg.png)

The objects which are not marked are unreachable from the root. Therefore, they are garbage collected.

#### Limitation

Objects have to be made explicitly unreachable.

> Since 2012, JavaScript Engine’s have adapted this algorithm over Reference-counting garbage collection.

Thanks for reading.

* * *

#### Further Readings:

- [**A tour of V8: Garbage Collection**: In the last few articles, we dived deep into the implementation of the V8 JavaScript engine. We discussed the...](http://jayconrod.com/posts/55/a-tour-of-v8-garbage-collection "http://jayconrod.com/posts/55/a-tour-of-v8-garbage-collection")

- [**thlorenz/v8-perf**: ⏱️ Notes and resources related to v8 and thus Node.js performance - thlorenz/v8-perf](https://github.com/thlorenz/v8-perf/blob/master/gc.md "https://github.com/thlorenz/v8-perf/blob/master/gc.md")

- [**Memory Management**: Low-level languages like C, have manual memory management primitives such as malloc() and free(). In contrast...](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Memory_Management "https://developer.mozilla.org/en-US/docs/Web/JavaScript/Memory_Management")

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
