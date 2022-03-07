> * 原文地址：[4 Lesser-Known Swift Features](https://betterprogramming.pub/4-lesser-known-swift-features-ddfbc9268aa9)
> * 原文作者：[Pavel Plotnikov](https://medium.com/@pavelplotnikov)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/4-lesser-known-swift-features.md](https://github.com/xitu/gold-miner/blob/master/article/2022/4-lesser-known-swift-features.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[Z招锦](https://github.com/zenblofe)

# 4 个鲜为人知的 Swift 特性

许多开发人员在使用标准技术时，通常都没有意识到在友好的语言和库之下隐藏的许多出色特性。这些特性对于一些读者来说可能已经非常熟悉了，但对我来说这是最近的一个小发现。

## 尾递归优化

大家都知道递归或许是一个不完美的实现方案，因为函数调用栈可能会溢出，导致段错误（segmentation fault）并崩溃。其中一种递归称为尾递归；这种递归的函数在自身末尾调用其自身。

```swift
func tailRecursion(n: Int) {
  guard n != 0 else { return }
  print(n)
  tailRecursion(n: n - 1)
}
```

与普通递归做对比：

```swift
func usualRecursion(n: Int) {
  if n > 0 {
    usualRecursion(n: n - 1)
  }
  print(n)
}
```

Swift 使用尾递归优化策略；在递归时，Swift 不会向内存中的调用栈添加方法调用，而是直接跳转到函数的开头。这样一来，栈内存的消耗将能显著地减少。

在之前的例子中，`usualRecursion(n: 300000)`  因段错误而崩溃了，但 `tailRecursion(n: 1000000)` 依然正常运行。

该测试是在我电脑上进行的；这些参数的结果在其他电脑上可能会有所不同。

你可以在生成的汇编代码中看到这个优化：

```bash
xcrun swiftc -O -S File.swift > main.asm
```

即使你不懂汇编语言，你也可以在  `main.asm` 文件里看到 `jne` 命令在尾递归时执行了，而普通递归则执行了标准的 `callq` 函数调用命令。

基于这种优化，我们可以得出结论 —— 尽可能的在函数中使用尾递归。

## 负数的存储

在许多的编程语言中，有符号数通常以一组比特的方式存储，第一位比特表示数的符号（0 为正数，1 为负数）。

其余的比特则表示该数的值。举例来说，一个字节的 00000001 表示 1，10000001 则表示 -1。

但在 Swift 里，存储系统针对快速运算进行了优化 —— 数字是以一种叫做二进制补码的方式进行存储。要想在这个系统中描述一个负数，你需要将这个数表示为二进制，然后按位取反并加 1。这里以数值 -15 作为例子：

* 将十进制数 15 以二进制表示：0001111
* 按位取反：1110000
* 加 1：1110001（如上所述，你需要加上一个 1 比特）

最终结果为 11110001。

如果我们想将 11110001 的比特表达形式转换为十进制格式则需要：

* 按位取反：0001110（舍弃最高位，因为它表示的是数值的符号）
* 加 1：0001111
* 转换为十进制：15
* 加上符号：-15

这种数的表达方式能让底层的算数运算更快。

```swift
// 获取负数内在表达形式的方式
String(UInt8(bitPattern: Int8(-15)), radix: 2)
```

## 相同函数，不同速度

Swift 提供不同的集合协议；这些协议经常共享一些函数。乍一看它们的运作模式相同，但实际上这些函数的操作可能因协议而异。

举例来说，Sequence 协议的 `suffix` 函数的时间复杂度为 O(n)，但相同的函数在 RandomAccessCollection 协议（继承自 Sequence 协议，符合此协议的结构包括常规的数组）。这种差异在数据量很大时将变得尤为明显。因此，我们在使用结构时应注意其所使用的协议。

```swift
// 定义数组
let array = 0...100_000

print("开始 array.suffix \(Date())")
// suffix(5) 的时间复杂度为 O(1)
array.suffix(5)
print("结束 array.suffix \(Date())")

// 定义序列
let seq = sequence(first: 0, next: { $0 < 100_000 ? $0 + 1 : nil })

print("开始 sequence.suffix \(Date())")
// suffix(5) 的时间复杂度为 O(n)；函数将遍历序列的每个元素
seq.suffix(5)
print("结束 sequence.suffix \(Date())")
```

## 字典里哈希冲突的解决方案

我们知道，将元素存储在字典里可能会引发冲突。不同元素的哈希值可能会相同；我们需要特别去解决这种情况（为此，键必须实现 `==` 操作）。

存储冲突的典型理论实现是将冲突的元素存储在一个链表里；这也称为分离链（separate chaining）。我们经常能听到这种方法，尤其是在面试时。

当你通过键搜索元素但字典里已有另一个与其哈希相同的键时，我们就会遇到以上的情况。经典的算法是遍历整个链表，测试元素是否相等，直到找到为止。这种方法相对来说很容易理解，但 Swift 采用另一种不同的实现方式。

简单来说，所有的数据都存储在一个数组中，并通过键索引值。如果冲突发生了，新的元素仍写入同一个数组里，但位置与发生冲突的元素偏移了一定距离。如果这个单元格已被占用，则检查相同距离之后的下一个单元格，以此类推。检查将环绕数组的末尾到其开头（一个逻辑上的闭环）。这种冲突的解决方法称为**线性开型寻址（Open Addressing with Linear Probing）**。在这个解决方案中，所有的元素都存储在一个共享空间里，我们不需要额外的内存来维持链表。

你可以在[这里](https://github.com/apple/swift/blob/main/stdlib/public/core/Dictionary.swift)看到具体实现。

## Swift 是开源的

你可能没有发觉，但 Swift 确实是一个开源项目。你可以参与标准库的实现并发表你的看法；说不定未来版本的 Swift 会实现它噢！你可以在这个链接中找到 Swift 中常见类型的实现：[https://github.com/apple/swift/tree/main/stdlib/public/core](https://github.com/apple/swift/tree/main/stdlib/public/core)。

此外，你也可以与社区携手开发一些库，其中包括 swift-markdown、swift-algorithms、swift-numerics、swift-collections、swift-atomics 等等。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
