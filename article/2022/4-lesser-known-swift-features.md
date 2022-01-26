> * 原文地址：[4 Lesser-Known Swift Features](https://betterprogramming.pub/4-lesser-known-swift-features-ddfbc9268aa9)
> * 原文作者：[Pavel Plotnikov](https://medium.com/@pavelplotnikov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/4-lesser-known-swift-features.md](https://github.com/xitu/gold-miner/blob/master/article/2022/4-lesser-known-swift-features.md)
> * 译者：
> * 校对者：

# 4 Lesser-Known Swift Features

Many developers work with standard technologies and are often unaware of the many outstanding features hidden under friendly languages and libraries. These features may already be familiar for some readers, but it has been a small discovery lately for me.

## Tail Recursion Optimization

Many developers know that recursion might be an imperfect tool, as the function call stack can overflow uncontrollably and crash due to a Segmentation fault. One type of recursion is Tail Recursion, where a function calls itself at the end of the function itself.

```swift
func tailRecursion(n: Int) {
  guard n != 0 else { return }
  print(n)
  tailRecursion(n: n-1)
}
```

in contrast with usual recursion:

```swift
func usualRecursion(n: Int) {
  if n > 0 {
    usualRecursion(n: n-1)
  }
  print(n)
}
```

Swift uses Tail Recursion Optimization, which doesn’t add a method call to the call stack in memory but jumps to the beginning of the function. It consumes significantly less stack memory.

In the previous examples, `usualRecursion(n: 300000)` crashes with a “Segmentation fault”, while `tailRecursion(n: 1000000)` is running normally.

The experiments were performed on my computer; the results for these parameters may vary on other computers.
You can see the optimisation in the generated assembler code.

```bash
xcrun swiftc -O -S File.swift > main.asm
```

Even if you don’t know the assembly language, you can see it in the main.asm file that one of the ‘jamp’ command (functions starting with ‘j’) is executed for the tail recursion, while the standard callq function call command invokes the usual recursion.

Based on this optimization, we can conclude that if it is possible to recurse at the end of the function itself, then it is better to do just that.

## Storing Negative Numbers

In many programming languages, signed numbers are stored as a set of bits, where the first bit is the sign of a number (0 is a positive number, 1 is a negative number).

The remaining bits represent the value. For example, in a type that stores 1 byte 00000001 is the number 1, 10000001 is the number -1.

But in Swift, the storage system is optimized for fast operations, and numbers are stored in a method called two’s complement. To describe a negative number in this system, you need to write this number into a bit representation, then invert the bits and add 1. For example, if this number is -15:

* write out the bits of decimal 15: 0001111
* invert bits: 1110000
* add number 1: 1110001
* and, as already mentioned, at the beginning of the presentation, you need to add bit 1

The final result will be 11110001.

If we want to convert the bit representation of 11110001 to decimal format, then we need to

* invert bits: 0001110 (we should omit the first bit as it represents the sign of the number)
* add 1: 0001111
* convert to decimal format: 15
* and add a sign: -15

This representation of numbers allows performing arithmetic operations faster at a low level.

```swift
// The way to get inner representation of a negative number:
String(UInt8(bitPattern: Int8(-15)), radix: 2)
```

## One function can work at a different speed

Swift offers various collection protocols that often share the same functionality. At first glance, they work in the same way, but in reality, the operation of these functions can differ significantly depending on the protocol.

For example, the suffix function on the Sequence protocol works with O(n) complexity, while the same function on the RandomAccessCollection protocol (which inherits from Sequence; an example of a structure that conforms to this protocol is a regular Array) already works with complexity O(1). On large amounts of data, this difference will be clearly visible. Therefore, be mindful of the protocol you want to work with.

```swift
// define an array
let array = 0...100_000

print("start array suffix \(Date())")
// suffix(5) works O(1)
array.suffix(5)
print("end array suffix \(Date())")

// define a sequence
let seq = sequence(first: 0, next: { $0 < 100_000 ? $0 + 1 : nil})

print("start sequence suffix \(Date())")
// suffix(5) works O(n), iterates every element of the sequence
seq.suffix(5)
print("end sequence suffix \(Date())")
```

## Collision Resolve in Dictionary

As we know, storing elements in a Dictionary can be collisions. The hash values of different elements can match, which is a typical situation that is resolved especially (for this, the key element must implement the `==` operation).

A typical theoretical implementation of collision storage, which can be often heard, for example, in interviews with candidates, is when storage items are lined up in a Linked List, also called Separate Chaining.

When you search for an element by key, but the Dictionary already has other elements by hash, we will have the following situation. A typical algorithm traverses the linked list and tests for equality against elements until it encounters an equivalent one or checks all items with the same hash. This method is good and relatively simple to explain, but Swift has a different implementation in reality.

Simply speaking, all records are stored in a single array, accessed by a key hash. If a collision occurs, you should write a new element to the same array but at a certain distance from the item with which there was a collision. If this cell is also busy, check the next cell in the same distance, etc. These checks can wrap around the end of the array to the beginning of it (a logical ring). The name of the collision resolution method is Open Addressing with Linear Probing. In this solution, all items are stored in a shared space, and no additional memory is needed to keep the LinkedList running.

You can see the implementation [here](https://github.com/apple/swift/blob/main/stdlib/public/core/Dictionary.swift).

## Swift is Open Source

You may not be aware, but Swift is an open-source project that you can also contribute. You can participate in implementing the standard libraries and offer your ideas that may appear in the future with new versions of Swift. Implementation of Swift’s common types you can easily find in the link [https://github.com/apple/swift/tree/main/stdlib/public/core](https://github.com/apple/swift/tree/main/stdlib/public/core)

In addition, you can develop several libraries together with the community, among which are: swift-markdown, swift-algorithms, swift-numerics, swift-collections, swift-atomics.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
