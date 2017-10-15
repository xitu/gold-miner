> * 原文地址：[On Performant Arrays in Swift](http://jordansmith.io/on-performant-arrays-in-swift/)
> * 原文作者：[JORDAN SMITH](http://jordansmith.io/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/on-performant-arrays-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO/on-performant-arrays-in-swift.md)
> * 译者：
> * 校对者：

# On Performant Arrays in Swift

For everyday app development, it’s not often that array performance is something you’re thinking about. Perhaps if you’re implementing an algorithm that needs to scale well, performant arrays might be on your mind. Maybe you’re working on lower level code, in a framework say, where any performance deficits will have a compounding effect. For the occasions that it does become relevant, it’s nice to know a little more about the options we have. Let’s take a deeper dive into arrays in Swift.

## Contiguous Arrays

[`Array`](https://developer.apple.com/documentation/swift/array) isn’t the only array type that Swift provides. You might have noticed the [`ArraySlice`](https://developer.apple.com/documentation/swift/arrayslice) type, which presents an un-copied view into a segment from another array. There’s also a type called [`ContiguousArray`](https://developer.apple.com/documentation/swift/contiguousarray). Unlike the name suggests, it’s actually the most simple array type in Swift. It can be more performant than a standard array, and even when it’s not, it provides the same level of performance as `Array`. It exposes the same interface too. So why the heck doesn’t `ContiguousArray` take the place of `Array`?

```
let deliciousArray = ContiguousArray<String>(arrayLiteral: "🌮", "🥞", "🥖")
```

Well, `Array` can be toll-free bridged to an `NSArray`, for Objective-C compatibility. Under the hood, an `Array` instance will store array data in an `NSArray`, as long as the element type is a class or Objective-C compatible protocol. Whenever this is not the case (e.g. for an array of value types), the array is not backed by an `NSArray`, and the performance becomes equivalent with `ContiguousArray`.

To compare performance, a test was run where one million individual reference types were added and then removed to an instance of each array. The references were pre-constructed before the timing started, and results were averaged over 100 runs. The following values were obtained using an optimised compiler setting. Overall, you can see that if array performance is a bottleneck, you might gain something on the order of a 2x improvement by switching to a `ContiguousArray`, if the elements are a reference or `@objc` type.

| **Array** | **ContiguousArray** |
| ---------- | ------------------ |
| 58.9 ms | 30.3 ms |

## Array Capacity

It might appear that the memory allocated by a Swift array is proportional to its length. If this was the case, adding or removing an element would require allocating or deallocating memory, and incur a performance penalty for every change in array size. Instead, it would make more sense to allocate at least some space in advance, allowing the next few additions to happen without incurring a memory management performance penalty. This is in fact what Swift does: memory allocations occur in an intelligent fashion, to keep the allocation performance cost to a minimum.

Despite intelligent memory allocation, the most efficient way to allocate memory is if you know the capacity the array should be defined to hold. This way, only a single memory allocation is needed. Swift arrays provide the ability to define and reserve capacity on the fly, and this can be done for a small performance gain.

```
var healthyArray = ["🍉", "🥕"]
healthyArray.reserveCapacity(50)
```

Running another test, again adding and removing one million reference types to an array produces the following results. The test was run against a contiguous array and an identical array with a reserved memory capacity.

| **Without Reserved Capacity** | **With Reserved Capacity** |
| ------------------------------ | ------------------------- |
| 29.7 ms | 27.3 ms |

## C Style Arrays

If you’d like to access the raw memory underpinning the array, you can do this too. For standard array operations, it shouldn’t provide much of a performance gain. For non standard cases, accessing or mutating the data this way may be necessary, or beneficial to performance.

```
var balancedDietArray = ["🥖", "🍩", "🍗"]
balancedDietArray.withUnsafeMutableBufferPointer { arrayPointer in
    arrayPointer[1] = "🍇"
}
```

---

If you’re interested in learning more about how Swift arrays work, you can find out more here: [Swift Array Design](https://github.com/apple/swift/blob/master/docs/Arrays.rst).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
