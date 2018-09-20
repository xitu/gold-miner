> * 原文地址：[Lazy Sequences in Swift And How They Work](https://swiftrocks.com/lazy-sequences-in-swift-and-how-they-work.html)
> * 原文作者：[Bruno Rocha](https://bit.ly/2IY5F4Y)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-sequences-in-swift-and-how-they-work.md](https://github.com/xitu/gold-miner/blob/master/TODO1/lazy-sequences-in-swift-and-how-they-work.md)
> * 译者：[RickeyBoy](https://github.com/RickeyBoy)
> * 校对者：

使用 `map` 和 `filter` 这样的高阶函数在 Swift 项目中非常常见，因为它们是简单的算法，能让你将复杂的想法转化为简单的单行函数。不幸的是，它们没能解决所有的问题 -- 至少在它们的默认实现中没能解决。高阶函数是非常**急迫**的：它们使用闭包立即返回一个新的数组，不论你是否需要提前返回或者只是使用其中特定的元素。当性能很重要时，你可能被逼着写一些具体的辅助方法来避免高阶函数**急迫**的这个性质。

```
let addresses = getFirstThreeAddresses(withIdentifier: "HOME")
func getFirstThreeAddresses(withIdentifier identifier: String) -> [Address] {
    // 不使用 .filter{}.prefix(3)，因为我们需要提前返回
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

幸运的是，Swift 有办法在使用高阶函数的同时保持其高性能和辅助函数 -- Swift 标准库 `Sequences` 和 `Collections` 的惰性执行版本可以通过 `lazy` 关键词获取到。

这些变化后的惰性版本使用起来就和普通情况一样，仅有一处改变：它们拥有像 `map` 和 `filter` 一样自定义实现的方法来保证它们的**惰性** -- 这意味着实际上只有在**你需要它们的时候**才会进行运算。

```
let allNumbers = Array(1...1000)
let normalMap = allNumbers.map { $0 * 2 } // 不论你是需要做什么，这段映射都会被执行完
let lazyMap = allNumbers.lazy.map { $0 * 2 } // 在这里什么都不会发生
print(lazyMap[0]) // 打印 2, 但其他不涉及的部分都不会发生
```

虽然一开始看着有点吓人，但它们允许你减少大多数的 `for` 循环，取代以能够提前返回的单行函数。例如，当用于查找满足断言的第一个元素时，这是它与其他方法的比较：

```
// 在 [Address] 数组中有 10000 个 Address 元素, 和一个位于最开头的 "HOME" address 元素
let address = allAddresses.filter { $0.identifier == "HOME" }.first // ~0.15 秒

// 对比

func firstAddress(withIdentifier identifier: String) -> Address? {
    // 现在你可以使用标准库的 first(where:) 方法，
    // 但让我们现在假装它不存在
    for address in allAddresses where address.identifier == identifier {
        return address
    }
    return nil
}

let address = firstAddress(withIdentifier: "HOME") // 立刻

// 对比

let address = allAddresses.lazy.filter { $0.identifier == "HOME" }.first // 同样立刻返回，并且代码更少！
```

除了写的代码更少之外，它们也对总体上惰性操作非常有帮助，能让你的代码更易阅读。假设你有一个购物应用，如果用户花费太长时间完成购买，则会显示来自本地数据库的优惠：

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

当这个解决办法生效时，它有一个主要的问题：我急迫地将全部要展示的 json 内容都映射到了 `OfferViews`，即便用户并不一定会看完这所有的选项。这并不是一个问题如果内容 `offerJson` 只是一个小型的数组，但如果数据量巨大时，一次性将所有内容从数据库取出立刻就成为一个问题了。

你可以通过将解析逻辑移动到 `displayNextOffer()`，实现仅仅映射需要的 `OfferViews`，但你的代码质量可能因为保留了原始数据而变得难以理解：

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

通过使用 `lazy`，当前的 `offerView` 将只会在被 `displayNextOffer()` 使用到时映射数组相对应的位置，这样既保证了代码可读性又保证了代码性能！

```
let offerViews = offersJson.lazy.compactMap { database.load(offer: $0) }.map(OfferView.init) // 这里什么都没发生！
var currentOffer = -1

func displayNextOffer() {
    guard currentOffer + 1 < offerViews.count else {
        return
    }
    currentOffer += 1
    offerViews[currentOffer].display(atViewController: self) // 只在这里发生了映射，且只有需要的元素
}
```

不过注意，惰性序列将不会有缓存。这意味着如果使用了 `offerViews[0]` 两次，**全部映射过程也都将被执行两次**。如果你要多次获取某些元素，那么就把他们放到普通的数组之中吧。


## 这如何生效？

虽然它们在使用时看起来很神奇，但延迟序列的内部实现并不像它看起来那么复杂。

如果我们打印第二个例子的类型，我们可以看到，即使我们惰性映射的 `Collection` 就像普通的 `Collection` 一样，我们也处理的是不同的类型：

```
let lazyMap = Array(1...1000).lazy.map { $0 * 2 }
print(lazyMap) // LazyMapCollection<Array<Int>, Int>
let lazyMap = Array(1...1000).lazy.filter { $0 % 2 == 0 }.map { $0 * 2 }
print(lazyMap) // LazyMapCollection<LazyFilterCollection<Array<Int>>, Int>
// 在这种情况下，第一个泛型参数是惰性操作内部的 Collection，而第二个参数是 map 操作的转换函数。
```

看看 Swift 的源代码，我们可以通过这样一个事实，看到其非急迫性，即这些方法除了返回一个新类型之外，实际上并没有做任何事情：

(我将使用 `LazySequence` 而不是 `LazyCollections` 的代码作为例子， 因为他们在特性上十分相似。 如果你不理解 `Sequences` 如何工作， [那么看一下 Apple 的这篇文章吧。](https://developer.apple.com/documentation/swift/sequence))

```
extension LazySequenceProtocol {
    /// 返回一个 `LazyMapSequence` 类型来替代 `Sequence`。
    /// 结果每次被 `transform` 方法读取一个基础元素，
    /// 它们都将会被惰性计算。
    @inlinable
    public func map<U>(_ transform: @escaping (Elements.Element) -> U) -> LazyMapSequence<Self.Elements, U> {
        return LazyMapSequence(_base: self.elements, transform: transform)
    }
}
```

这样的神奇来自这些独特类型的内部实现。例如，如果我们看一下 `LazyMapSequence` 和 `LazyFilterSequence`，我们可以看到它们只不过是常规的 `Sequences`，它存储一个操作并仅在迭代时应用它们的对应的立刻生效的方法：

```
// _base 是原始的 sequence
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

## `LazyCollection`  的性能困境

如果文章在这里结束的话会很好，但重要的是要知道惰性序列其实是有缺陷 -- 特别是当底层类型是 `Collection` 时。

在最开始的例子中，我们的方法获得了满足某个条件的前三个地址。通过将惰性操作链接在一起，这也可以简化为单行函数：

```
let homeAddresses = allAddresses.lazy.filter { $0.identifier == "HOME" }.prefix(3)
```

但是，看看这个特定的例子与直接执行相比表现如何：

```
allAddresses.filter { $0.identifier == "HOME" }.prefix(3) // ~0.11 secs
Array(allAddresses.lazy.filter { $0.identifier == "HOME" }.prefix(3)) // ~0.22 secs
```

即使找到三个地址后 `lazy` 版本就会立刻停止，但它的执行速度却反而是急迫版本的两倍！

不幸的原因来自于 `Sequences` 和 `Collections` 之间的细微差别。截取 `Sequence` 的头部元素就像将所需元素移动到单独的 `Array` 一样简单，但对 `Collections` 的切片操作却需要知道所需切片的 `结束位` 的索引：

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

问题是在 `Collection` 相关术语中，`endIndex` 不是最后一个元素的索引，而是最后一个元素（`index（startIndex，offsetBy：maxLength）`）**之后**的索引。对于我们的惰性 `filter` 函数来说，这意味着为了切割获得前三个家庭地址，我们必须找到**四个**家庭地址 -- 它们甚至可能不存在。

这篇文档 [certain lazy types](https://github.com/apple/swift/blob/master/stdlib/public/core/PrefixWhile.swift#L106) 说明了这个问题：

```
/// - 注意：获取 `endIndex`、获取 `last`、
///   任何依赖 `endIndex` 的方法或者是
///   依赖于 collection 头部符合条件的元素个数进行移动的方法，
///   都可能无法匹配 `Collection` 协议保证的性能。
///   因此要知道，对于 `${Self}` 实例的普通操作
///   可能并不只有文档上描述的复杂度。
public struct LazyPrefixWhileCollection<Base: Collection> {
```

更糟糕的是，因为一个 `Slice` 只是原始 `Collection` 的一个窗口，所以将它转换为`Array` 需要调用使用了惰性 filter 方法的 `Collection` 的 `count` 属性的函数 -- 但是因为 `lazy.filter（_ :)` 操作不符合 `RandomAccessCollection` 协议，`count`只能通过遍历整个 `Collection` 来找到。

由于 Lazy Sequence 缺少缓存，这导致整个过滤/切片过程**再次**发生。因此，如果第四个元素不存在或者与第三个元素相距太远，那么 `lazy` 版本的执行速度将比原始版本差两倍。

好消息是这种情况可以被避免 -- 如果你不确定你的惰性操作是否会在合理的时间内运行，你可以通过将结果视为 `Sequence` 来保证效率。虽然这样失去 `BidirectionalCollection` 所具有的反向遍历功能，但保证了前向操作将再次快速。

```
let sequence: AnySequence = allAddresses.lazy.filter { $0.identifier == "HOME" }.prefix(3)
let result = Array(sequence) // ~0.004 秒!
```

## Conclusion

使用 `lazy` 对象可以让你快速编写高性能、复杂的东西 -- 代价是需要了解 Swift 内部机制以防止出现重大问题。像所有功能一样，它们有巨大的优点也有等同的缺点，在这种情况下，需要了解 `Sequences` 和 `Collections` 之间的主要区别，汲取它们中的最佳功能来使用。一旦掌握，映射得到特定元素，将变得非常简单和直观。

在 Twitter 上关注我 -- [@rockthebruno](https://twitter.com/rockthebruno)，如果你想分享任何的更正或者建议，请告知我。

## 参考文献和优秀文章

[Filter.swift](https://github.com/apple/swift/blob/master/stdlib/public/core/Filter.swift)
[SR-4164](https://bugs.swift.org/browse/SR-4164)
[LazyPrefixWhileCollection](https://developer.apple.com/documentation/swift/lazyprefixwhilecollection)
[LazySequenceProtocol](https://developer.apple.com/documentation/swift/lazysequenceprotocol)
[Sequence](https://developer.apple.com/documentation/swift/sequence)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
