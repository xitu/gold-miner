> * 原文地址：[Lazy Sequences in Swift And How They Work](https://swiftrocks.com/lazy-sequences-in-swift-and-how-they-work.html)
> * 原文作者：[Bruno Rocha](https://bit.ly/2IY5F4Y)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-sequences-in-swift-and-how-they-work.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-sequences-in-swift-and-how-they-work.md)
> * 译者：
> * 校对者：

Usage of high-order functions like `map` and `filter` are very common in Swift projects, as they are simple algorithms that allow you to convert extensive ideas into simple one-liners. Unfortunately, they don't solve every issue - at least not in their default implementations. High-order functions are _eager_: they use the closure immediately and return a new array, regardless if you need an early return or only going to use specific elements. When performance is important, you might be cornered into writing specialized helper methods to avoid the _eager_ nature of high-orders:

```
let addresses = getFirstThreeAddresses(withIdentifier: "HOME")
func getFirstThreeAddresses(withIdentifier identifier: String) -> [Address] {
    //Not using .filter{}.prefix(3) because we need an early return
    var addresses = [Address]()
    for address in allAddresses where address.identifier == identifier {
        addresses.append(address)
        if addresses.count == 3 {
            break
        }
    }
    return addresses
}
```

Fortunately, Swift has a way to use high-order functions while still keeping the improved performance of the helper methods - Lazy versions of the Swift Standard Library `Sequences` and `Collections` can be accessed through the `lazy` property.

These lazy variations work just like their regular counterparts, but with one twist: they have custom implementations of methods like `map` and `filter` in order to make them work **lazily** - meaning that the actual computations will only happen **where and when you need them.**

```
let allNumbers = Array(1...1000)
let normalMap = allNumbers.map { $0 * 2 } // The entire Sequence will be mapped, regardless of what you need to do.
let lazyMap = allNumbers.lazy.map { $0 * 2 } // Nothing happens here.
print(lazyMap[0]) // Prints 2, but everything else is still untouched!
```

While somewhat scary at first, they allow you to reduce most `for` loops with early returns into one-liners. For example, here's how it compares to other methods when used to find the first element that fulfills a predicate:

```
// allAddresses in an [Address] with 10000 elements, and a "HOME" address is placed at the beginning
let address = allAddresses.filter { $0.identifier == "HOME" }.first // ~0.15 seconds

// Versus

func firstAddress(withIdentifier identifier: String) -> Address? {
    // Nowadays you can use the Standard Library's first(where:) method,
    // but lets pretend that doesn't exist.
    for address in allAddresses where address.identifier == identifier {
        return address
    }
    return nil
}

let address = firstAddress(withIdentifier: "HOME") // Instant

// Versus

let address = allAddresses.lazy.filter { $0.identifier == "HOME" }.first // Also instant with much less code!
```

Besides writing shorter code, they can also be very useful for delaying operations in general to make your code easier to read. Let's say you have a shopping app which displays offer incentives from a local database if the user's taking too long to finish a purchase:

```
let offerViews = offersJson.compactMap { database.load(offer: $0) }.map(OfferView.init) // O(n)
var currentOffer = -1

func displayNextOffer() {
    guard currentOffer + 1 < offerViews.count else {
        return
    }
    currentOffer += 1
    offerViews[currentOffer].display(atViewController: self)
}
```

While this solution works, it has a major flaw: I am eagerly mapping the entire offer json into `OfferViews`, even though there's no guarantee that the user will see any of these offers. This isn't really an issue if `offerJson` is a small array, but with large data sets, pulling all the offers from a database can quickly become a problem.

You can map only the necessary `OfferViews` by moving the parsing logic to `displayNextOffer()`, but your code quality might become harder to understand since you now have to keep the raw offer data around:

```
let offersJson: [[String: Any]] = //
var currentOffer = -1

func displayNextOffer() {
    guard currentOffer + 1 < offerViews.count else {
        return
    }
    currentOffer += 1
    guard let offer = database.load(offer: offersJson[currentOffer]) else {
        return
    }
    let offerView = OfferView(offer: offer)
    offerView.display(atViewController: self)
}
```

By using `lazy`, the current `offerView` will only be mapped when the array position is accessed in `displayNextOffer()`, keeping the reading quality of the first implementation with the performance of the second one!

```
let offerViews = offersJson.lazy.compactMap { database.load(offer: $0) }.map(OfferView.init) // Nothing happens here!
var currentOffer = -1

func displayNextOffer() {
    guard currentOffer + 1 < offerViews.count else {
        return
    }
    currentOffer += 1
    offerViews[currentOffer].display(atViewController: self) // Mapping only happens here, for the desired element only.
}
```

Note, however, that Lazy Sequences have no caching. This means that if `offerViews[0]` is accessed twice, **the entire mapping process will also happen twice.** If you need to access elements more than once, move them to a regular array.

## Why this works?

While they look like magic when used, the internal implementation of Lazy Sequences aren't as complicated as it looks.

If we print the type of our second example, we can see that even though our lazily mapped `Collection` works like a regular `Collection`, we are dealing with different types:

```
let lazyMap = Array(1...1000).lazy.map { $0 * 2 }
print(lazyMap) // LazyMapCollection<Array<Int>, Int>
let lazyMap = Array(1...1000).lazy.filter { $0 % 2 == 0 }.map { $0 * 2 }
print(lazyMap) // LazyMapCollection<LazyFilterCollection<Array<Int>>, Int>
//In this case, the first generic argument is the inner Collection of the lazy operation, while the second one is the transformation function of the map operation.
```

Looking at Swift's source code, we can see that the non-eagerness comes from the fact that these methods don't actually do anything besides return a new type:

(I'll be using `LazySequence` code examples instead of `LazyCollections` ones because they are much simpler in nature. If you don't know how regular `Sequences` work, [take a look at this Apple page.](https://developer.apple.com/documentation/swift/sequence))

```
extension LazySequenceProtocol {
    /// Returns a `LazyMapSequence` over this `Sequence`.  The elements of
    /// the result are computed lazily, each time they are read, by
    /// calling `transform` function on a base element.
    @inlinable
    public func map<U>(_ transform: @escaping (Elements.Element) -> U) -> LazyMapSequence<Self.Elements, U> {
        return LazyMapSequence(_base: self.elements, transform: transform)
    }
}
```

The magic comes from the internal implementation of these specialized types. If we take a look at `LazyMapSequence` and `LazyFilterSequence`, for example, we can see that they are nothing more than regular `Sequences` that stores an operation and applies their counterpart eager functions only when iterated:

```
// _base is the original Sequence
extension LazyMapSequence.Iterator: IteratorProtocol, Sequence {
    @inlinable
    public mutating func next() -> Element? {
        return _base.next().map(_transform)
    }
}
```

```
extension LazyFilterSequence.Iterator: IteratorProtocol, Sequence {
    @inlinable
    public mutating func next() -> Element? {
        while let n = _base.next() {
            if _predicate(n) {
                return n
            }
        }
        return nil
    }
}
```

## `LazyCollection` Performance Traps

If would be nice if the article ended here, but it's important to know that Lazy Sequences have flaws - specifically when the underlying type is a `Collection`.

In the opening example, our method gets the first three addresses that fulfill a certain predicate. By chaining lazy operations together, this can also be reduced to an one-liner:

```
let homeAddresses = allAddresses.lazy.filter { $0.identifier == "HOME" }.prefix(3)
```

However, look how this specific example performs when compared to the eager counterpart:

```
allAddresses.filter { $0.identifier == "HOME" }.prefix(3) // ~0.11 secs
Array(allAddresses.lazy.filter { $0.identifier == "HOME" }.prefix(3)) // ~0.22 secs
```

Even though the `lazy` version stops as soon as the three addresses are found, it performs twice as bad as the eager one!

The unfortunate reason comes from the subtle differences between `Sequences` and `Collections`. While prefixing a `Sequence` is as simple as moving the desired elements to a separate `Array`, slicing operations on `Collections` require knowing the `end` index of the desired slice:

```
public func prefix(_ maxLength: Int) -> SubSequence {
    _precondition(maxLength >= 0, "Can't take a prefix of negative length from a collection")
    let end = index(startIndex, offsetBy: maxLength, limitedBy: endIndex) ?? endIndex
    return self[startIndex..<end]
}

@inlinable
public subscript(bounds: Range<Index>) -> Slice<Self> {
    _failEarlyRangeCheck(bounds, bounds: startIndex..<endIndex)
    return Slice(base: self, bounds: bounds)
}
```

The problem is that in `Collection` lingo, an `endIndex` isn't the index of the last element, but the index **after** the last element (`index(startIndex, offsetBy: maxLength)`). For our lazy `filter`, this means that in order to slice the first three home addresses, we must find **four** of them - which may not even exist.

The documentation of [certain lazy types](https://github.com/apple/swift/blob/master/stdlib/public/core/PrefixWhile.swift#L106) states this issue:

```
/// - Note: The performance of accessing `endIndex`, `last`, any methods that
///   depend on `endIndex`, or moving an index depends on how many elements
///   satisfy the predicate at the start of the collection, and may not offer
///   the usual performance given by the `Collection` protocol. Be aware,
///   therefore, that general operations on `${Self}` instances may not have
///   the documented complexity.
public struct LazyPrefixWhileCollection<Base: Collection> {
```

To make it worse, since a `Slice` is a mere window to the original `Collection`, the casting to `Array` will invoke functions that call the lazy filtered `Collection`'s `count` properties - but since the `lazy.filter(_:)` operation doesn't conform to `RandomAccessCollection`, `count` can only be found by iterating the entire `Collection` \- again.

Due to the Lazy Sequence's lack of caching, this results in the entire filtering/slicing process happening **again**. Thus, if the fourth element doesn't exist or is too far from the third one, the `lazy` version will perform twice as worse as the original one.

The good news is that this can be avoided - if you're not sure your lazy operation will run in reasonable time, you can guarantee it by treating the result as a `Sequence`. This has the downside of losing the reverse-iteration capabilities of a `BidirectionalCollection`, but guarantees that forward operations will be fast again.

```
let sequence: AnySequence = allAddresses.lazy.filter { $0.identifier == "HOME" }.prefix(3)
let result = Array(sequence) // ~0.004 secs!
```

## Conclusion

Usage of `lazy` objects can allow you to write high-performance complicated things very quickly - at the cost of requiring some understanding of Swift internals to prevent major issues. Like all features, they have great advantages with equal downsides, and in this case knowledge of the main differences between `Sequences` and `Collections` is required to extract the best of them. Once mastered, mapping specific elements becomes very simple and intuitive.

Follow me on my Twitter - [@rockthebruno](https://twitter.com/rockthebruno), and let me know of any suggestions and corrections you want to share.

## References and Good reads

[Filter.swift](https://github.com/apple/swift/blob/master/stdlib/public/core/Filter.swift)
[SR-4164](https://bugs.swift.org/browse/SR-4164)
[LazyPrefixWhileCollection](https://developer.apple.com/documentation/swift/lazyprefixwhilecollection)
[LazySequenceProtocol](https://developer.apple.com/documentation/swift/lazysequenceprotocol)
[Sequence](https://developer.apple.com/documentation/swift/sequence)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
