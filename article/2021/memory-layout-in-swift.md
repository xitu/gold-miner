> * 原文地址：[Memory layout in Swift](https://theswiftdev.com/memory-layout-in-swift/)
> * 原文作者：[Tibor Bödecs](https://theswiftdev.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/memory-layout-in-swift.md](https://github.com/xitu/gold-miner/blob/master/article/2021/memory-layout-in-swift.md)
> * 译者：[LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：[liyaxuanliyaxuan](https://github.com/liyaxuanliyaxuan),[PassionPenguin](https://github.com/PassionPenguin)

# Swift 中的内存布局

## Swift 中值类型的内存布局

内存就是是一串 \`1\` 和 \`0\`，简称为 [bits](https://en.wikipedia.org/wiki/Bit)（二进制位）。如果将比特流分成每 8 位一组，我们可以称这个新的单位为[字节](https://en.wikipedia.org/wiki/Byte)（8 位是一个字节，例如二进制 10010110 是十六进制 96）。我们还可以以[十六进制形式](https://en.wikipedia.org/wiki/Hexadecimal)可视化这些字节（例如 96 A6 6D 74 B2 4C 4A 15 等）。现在如果我们把这些可视化字节分成 8 组，我们会得到一个新的单位，成为[单词](https://en.wikipedia.org/wiki/Word_(computer_architecture))。

这种 64 位内存（即一个字代表 64 位）布局是我们现代 [x64](https://en.wikipedia.org/wiki/64-bit_computing) CPU 架构的基本基础。每个字都与一个虚拟内存地址相关联，该地址也由一个（[通常为 64 位](https://superuser.com/questions/1188364/what-is-the-size-of-an-address-of-a-variable-in-memory-on-a-64-bit-processor-in)）十六进制数表示。在 [x86-64](https://en.wikipedia.org/wiki/X86-64) 时代之前，[x32 ABI](https://en.wikipedia.org/wiki/X32_ABI) 使用 32 位长[地址](https://en.wikipedia.org/wiki/Byte_addressing)，其最大内存限制为 4GiB。幸运的是，我们正在使用 x64。💪

那么，我们如何在[虚拟内存](https://en.wikipedia.org/wiki/Virtual_memory)地址空间中存储数据类型呢？好吧，长话短说，我们为每种数据类型分配了适量的空间，并将值的十六进制表示形式写入内存。这是操作系统提供的魔法，它就是这样工作的。

我们也可以开始讨论[内存分段](https://en.wikipedia.org/wiki/Memory_segmentation)、分页和其他底层的东西，但老实说，我真的不知道这些东西是如何工作的。当我越来越深入地研究[这类底层内容](https://en.wikipedia.org/wiki/Low-level_programming_language)时，我学到了很多关于计算机如何在幕后工作的知识。

我想和大家分享一个我已知的很重要的点。这就是关于各种架构上的[内存访问](https://cs.stackexchange.com/questions/45083/cpu-reading-cycles)。例如，如果 CPU 的总线宽度为 32 位，则意味着 CPU 只能在 1 个读取周期内从内存中读取 32 位。现在，如果我们简单地将每个对象写入内存，而不进行适当的数据分离，可能会造成一些麻烦。

```
┌──────────────────────────┬──────┬───────────────────────────┐
│           ...            │  4b  │            ...            │
├──────────────────────────┴───┬──┴───────────────────────────┤
│            32 bytes          │            32 bytes          │
└──────────────────────────────┴──────────────────────────────┘
```

如你所见，如果内存数据未对齐，第一个读取周期只能读取 4 位数据对象的第一部分。需要 2 个读取周期才能从给定的内存空间取回我们的数据。这是非常低效且危险的，这就是为什么大多数操作系统不允许进行非对齐访问，同时也是程序立即崩溃的原因。那么，在 Swift 中的[内存布局](https://stevenpcurtis.medium.com/memorylayout-in-swift-c4e70bb32e3f)是什么样子呢？让我们使用内置的 [MemoryLayout](https://swiftdoc.org/v3.1/type/memorylayout/) 枚举类型快速浏览一下我们的数据类型。

```swift
print(MemoryLayout<Bool>.size)      // 1
print(MemoryLayout<Bool>.stride)    // 1
print(MemoryLayout<Bool>.alignment) // 1


print(MemoryLayout<Int>.size)       // 8
print(MemoryLayout<Int>.stride)     // 8
print(MemoryLayout<Int>.alignment)  // 8
```

如您所见，Swift 使用 1 个字节存储 Bool 值，而用（在 64 位系统上）使用 8 个字节存储 Int  类型。那么，[**size**、**stride**和**alignment**](https://swiftunboxed.com/internals/size-stride-alignment/)之间到底有什么不同呢？ 

 **alignment** 将告诉你需要多少内存（其值的倍数）才能将完全对齐的内容保存在内存缓冲区中。**size** 是实际存储该类型所需的字节数。 **stride** 会告诉你在缓冲区上两个元素之间的距离。如果你对这些非正式的定义一无所知，也不用担心，一会儿就会明白的。

```swift
struct Example {
    let foo: Int  // 8
    let bar: Bool // 1
}

print(MemoryLayout<Example>.size)      // 9
print(MemoryLayout<Example>.stride)    // 16
print(MemoryLayout<Example>.alignment) // 8
```

当构造新的数据类型时，在我们的例子中是一个结构体（类的工作方式有所不同），我们可以根据结构体中的属性的内存布局在计算整个结构体的内存布局。

```
┌─────────────────────────────────────┬─────────────────────────────────────┐
│         16 bytes stride (8x2)       │         16 bytes stride (8x2)       │
├──────────────────┬──────┬───────────┼──────────────────┬──────┬───────────┤
│       8 bytes    │  1b  │  7 bytes  │      8 bytes     │  1b  │  7 bytes  │
├──────────────────┴──────┼───────────┼──────────────────┴──────┼───────────┤
│   9 bytes size (8+1)    │  padding  │   9 bytes size (8+1)    │  padding  │
└─────────────────────────┴───────────┴─────────────────────────┴───────────┘
```

在 Swift 中，简单类型的 **alignment** 的大小与其 **size**  相同。如果将标准的 Swift 数据类型存储在一个连续的内存缓冲区中，则不需要填充，因此每一个 **stride** 都将与这些类型的 **alignment** 相等。

使用复合类型时，例如示例 `Example` 的结构体，将使用属性 **alignment** 的最大值（8）为该类型的[内存对齐值](https://stackoverflow.com/questions/47610995/alignment-vs-stride-in-swift)。 **size** 是属性的总和 (8 + 1)，**stride** 则可以通过将大小四舍五入到对齐的下一个倍数来计算。在任何情况下都是这样吗？嗯，不完全是...

```swift
struct Example {
    let bar: Bool // 1
    let foo: Int  // 8
}

print(MemoryLayout<Example>.size)      // 16
print(MemoryLayout<Example>.stride)    // 16
print(MemoryLayout<Example>.alignment) // 8
```

这里到底发生了什么事？为什么 **size** 会增加呢？ **size** 的增大变得有些棘手，因为如果填充位于存储的变量之间，那么它会增加我们类型的整体大小。你不能从 1 个字节开始，然后在它后面再加上 8 个字节，因为这样会使整数类型不对齐，所以你需要 1 个字节，然后是 7 个字节的填充，最后是 8 个字节来存储整数值。

```
┌─────────────────────────────────────┬─────────────────────────────────────┐
│        16 bytes stride (8x2)        │        16 bytes stride (8x2)        │
├──────────────────┬───────────┬──────┼──────────────────┬───────────┬──────┤
│     8 bytes      │  7 bytes  │  1b  │     8 bytes      │  7 bytes  │  1b  │
└──────────────────┼───────────┼──────┴──────────────────┼───────────┼──────┘
                   │  padding  │                         │  padding  │       
┌──────────────────┴───────────┴──────┬──────────────────┴───────────┴──────┐
│       16 bytes size (1+7+8)         │       16 bytes size (1+7+8)         │
└─────────────────────────────────────┴─────────────────────────────────────┘
```

这是第二个示例结构的大小值略有增加的主要原因。随意创建其他类型，并通过为其绘制内存布局来进行练习，你可以随时使用 Swift 在运行时打印内存布局来检查你的绘制是否正确。💡

> 整个问题在 [[swift unboxed]](https://swiftunboxed.com/internals/size-stride-alignment/) 博客上得到了很好的解释。我还想推荐 [Steven Curtis 的这篇文章](https://stevenpcurtis.medium.com/memorylayout-in-swift-c4e70bb32e3f)，以及这篇关于 [Unsafe Swift: A road to memory](https://medium.com/swlh/unsafe-swift-a-road-to-memory-15e7d7e701f9) 的好文章。这些文章对我理解 Swift 中的内存布局起了很大帮助。🙏

## Swift 中引用类型的内存布局

我在前面提到过，**类**的表现非常不同，这是因为它们是引用类型。让我将示例类型更改成一个类，看看内存布局会发生什么。

```swift
class Example {
    let bar: Bool = true // 1
    let foo: Int = 0 // 8
}

print(MemoryLayout<Example>.size)      // 8
print(MemoryLayout<Example>.stride)    // 8
print(MemoryLayout<Example>.alignment) // 8
```

什么，为什么？直到现在，我们都在谈论[栈](https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding)中保留的内存。**栈**内存是为静态内存分配而保留的，还有一个叫做**堆**的东西用于动态内存分配。我们可以简单地说，值类型（struct、Int、Bool、Float 等）存在于栈中，而引用类型（类）则在堆中分配，这并非 100% 正确。Swift 足够聪明，可以执行额外的内存优化，但为了“简单”，我们就到此为止。

你可能会问这样的问题： [为什么有一个栈和一个堆](https://stackoverflow.com/questions/7123936/why-is-there-a-stack-and-a-heap)？这是因为它们完全不同。栈可以更快，因为是使用 push/pop 操作进行内存分配的，但你只能向其中添加或从中删除项目。栈大小也是有限的，你遇到过栈溢出错误吗？堆允许随机的内存分配，但是你必须确保会释放你申请的内存。另一个缺点是分配过程会有一些开销，但除了 RAM 的物理容量外，没有大小限制。[栈和堆](https://www.guru99.com/stack-vs-heap.html)完全不同，但它们都是非常有用。👍

回到整体，这里的每个值（大小、步幅、对齐）都是 8 是如何得到？我们可以使用  `class_getInstanceSize` 方法计算[堆上对象的实际大小（以字节为单位）](https://stackoverflow.com/questions/40312123/get-the-size-in-bytes-of-an-object-on-the-heap)。一个类至少含有 16 字节的元数据（即仅使用 `class_getInstanceSize` 方法打印出空类的大小）加上其实例变量的计算值。

```swift
class Empty {}
print(class_getInstanceSize(Empty.self)) // 16

class Example {
    let bar: Bool = true // 1 + 7 padding
    let foo: Int = 0     // 8
}
print(class_getInstanceSize(Example.self)) // 32 (16 + 16)
```

类的内存布局始终为 8 字节，但它从堆中获取的实际大小则取决于实例变量类型。另外的 16 字节来则自[“is a”指针](https://stackoverflow.com/questions/10998984/isa-pointer-in-objective-c)和引用计数。如果你对 Objective-C 运行时有所了解，这听起来可能很熟悉，但是如果不了解，这里也不要太担心 ISA 指针。我们下次再谈这件事。😅

Swift 使用[自动引用计数 (ARC)](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html) 来跟踪和管理您的应用程序的内存使用情况。多亏了有 ARC，在大多数情况下，你不必操心于手动内存管理。你只需确保不会在类实例之间创建强的引用循环。而幸运的是，这些情况可以通过[弱引用或无主引用](https://docs.swift.org/swift-book/LanguageGuide/AutomaticReferenceCounting.html#ID52)轻松解决。 🔄

```swift
class Author {
    let name: String

    /// weak reference is required to break the cycle.
    weak var post: Post?

    init(name: String) { self.name = name }
    deinit { print("Author deinit") }
}

class Post {
    let title: String
    
    /// this can be a strong reference
    var author: Author?

    init(title: String) { self.title = title }
    deinit { print("Post deinit") }
}


var author: Author? = Author(name: "John Doe")
var post: Post? = Post(title: "Lorem ipsum dolor sit amet")

post?.author = author
author?.post = post

post = nil
author = nil

/// Post deinit
/// Author deinit
```

正如上面的示例中所表现的，如果我们不使用弱引用，那么对象之间将彼此强引用，形成循环引用，那么即使你将单个指针设置为 nil，它们也不会被释放（deinit 根本不会被调用）。这是一个非常基本的例子，但真正的问题是我什么时候需要使用 weak、unowned 或 strong？ 🤔

我不喜欢说“视情况而定”，所以我想为你指明正确的方向。如果你仔细查看有关[闭包](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)的官方文档，你会看到有哪些会捕获值：

* 全局函数是具有名称且不捕获任何值的闭包。
* 嵌套函数是具有名称的闭包，可以从其封闭函数中捕获值。
* 闭包表达式是用轻量级语法编写的未命名闭包，可以从其上下文中捕获值。

如你所见，[全局（静态函数）不会增加引用计数器](https://stackoverflow.com/questions/28951324/why-is-the-weak-self-reference-in-the-uiview-animation-closure-causing-a-compila/48420485)。另一方面，嵌套函数将捕获值，这同样适用于闭包表达式和未命名的闭包，但它稍微复杂一些。为了更多地了解闭包和值捕获，我推荐以下两篇文章：

* [你不（总是）需要 \[weak self\]](https://medium.com/flawless-app-stories/you-dont-always-need-weak-self-a778bec505ef)
* [Weak、strong、unowned，我的天呐！](https://krakendev.io/blog/weak-and-unowned-references-in-swift)

长话短说，循环引用很糟糕，但在大多数情况下，通过使用正确的关键字就可以避免它们。在幕后，ARC 做得很好，除了一些必须破坏引用循环的情况。Swift 被设计成[内存安全](https://docs.swift.org/swift-book/LanguageGuide/MemorySafety.html)的编程语言。该语言确保每个对象在可以使用它们之前都将被初始化，并且将自动释放不再被引用的内存中的对象。 还会检查数组索引是否有越界错误。这为我们提供了额外的安全层，除非是编写不安全的 Swift 代码…🤓

总之，简而言之，Swift 中的内存布局就是这样的。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
