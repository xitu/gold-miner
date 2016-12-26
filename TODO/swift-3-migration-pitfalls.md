> * 原文地址：[Swift 3 migration pitfalls](http://codelle.com/blog/2016/9/swift-3-migration-pitfalls/)
* 原文作者：[ Emil Loer](http://codelle.com/contact/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[shliujing](https://github.com/shliujing)
* 校对者：[Danny1451](https://github.com/Danny1451), [Tina92](https://github.com/Tina92)

# 迁移到 Swift 3，这些陷阱在等你

[](http://codelle.com/blog/2016/9/swift-3-migration-pitfalls/)

万岁！Swift 3 发布了，让我们一起来移植项目吧！在这篇文章中，我会你分享我的项目迁移到 Swift 3的经历，那是一个 2 万行的 Swift 项目。如果你对此感到好奇，这个项目其实是我实现的 Cassowary 线性约束求解算法，该算法最著名之处在于其通常被用于页面的自动布局。但我将它用在了一些完全不同的事情上，我将会在以后的文章中说明。
 
### Swift 移植器

第一步是从 Xcode 中运行 Swift 移植器来对我的项目进行转换。移植器帮助我定位了大部分必须修改的地方，这节省了我很多的工作。而有几件事情我不得不在这之后做出修改，虽然这并不是很麻烦。在我必须重写的功能中，最有趣的是权限变更（新的权限模型默认为使类 `public` 和方法 `open`，但我想在大多数情况下限制这一点）和二进制搜索功能，起因是收集索引操作的工作方式的变更。

### 什么也没有变

根据惯例来看，每次 Swift 发布的新版本，我尝试的第一次编译都会报错。在报错之前编译器日志会输出一个错误列表，之后我会根据列表解决错误，然后代码就可以正常运行了。

我必须修复那些未被移植器捕捉到的，涉及两个语言之间变化所造成的编译错误，在下面两节我会高亮标注这些代码。

### 新的 Range

第一类必须解决的错误源于新的 `Range` 结构所带来的语义变更。现在 Swift 3 的 ranges 是由 4 个不同的结构体来重新代表，可数/不可数的范围和开放式/封闭式的范围。而在 Swift 2 中，开放式和封闭式范围使用相同的结构体，所以如果你有一些代码同时使用了这两种范围，那么你需要做一些修改工作。

下面是一个有效的 Swift 2 例子：


    func doSomething(with range: Range) {
        for number in range {
            ...
        }
    }

    doSomething(with: 0..<10) 
    doSomething(with:="" 0...10)="" 


在 Swift 2 中，上面的代码在半开放式和封闭式的可计数范围是生效的。移植器没有转换该结构名称，因此在项目移植后这部分代码不生效。在 Swift 3 中， `Range` 表示半开放不可计数式范围。由于不可计数式范围不支持迭代，所以我们必须改变这一点，而如果我们使它可以在半开放式和封闭式范围都能生效，这将会非常棒。解决方案是通过将输入转换为半开放可计数式范围或使用泛型使它在两种范围下都生效。事实上，这是利用了可计数式范围来实现 `Sequence` 协议。

这是一段可运行的 Swift 3 版本代码：


    func doSomething(for range: IterableRange) 
        where IterableRange: Sequence, IterableRange.Iterator.Element == Int {
        for number in range {
            ...
        }
    }

    doSomething(with: 0..<10) 
    doSomething(with:="" 0...10)="" 


### 元组转换

另一类编译器报错的原因是元组转换。下面是一段有效的 Swift 2 代码：


    typealias Tuple = (foo: Int, bar: Int)

    let dict: [Int: Int] = [1: 100, 2: 200]

    for tuple: Tuple in dict {
        print("foo is \(tuple.foo) and bar is \(tuple.bar)")
    }


移植器保留了这段代码的原貌，可编译器会报 for 循环的类型强制转换为 `Tuple` 的错误。在使用`(key: Int, value: Int)`这个元素类型来遍历上面这个字典的时候，Swift 2 环境下完全可以直接把它分配另给一个拥有相同成员类型但是不同成员名的变量。现在可好，再也不支持这个特性了！

虽然我认为严格的类型控制在通常情况下是很好的，这意味着现在我们需要将元组显式转换为目标类型。我们可以通过使用以下 语句来替换循环代码，使代码重新生效运行：


    for tuple in dict {
        let tuple: Tuple = (foo: tuple.key, bar: tuple.value)
        print("foo is \(tuple.foo) and bar is \(tuple.bar)")
    }


当然，这是一个特别修正过的例子，但是如果你要传递这个元组的值或者你想通过使用基于语义的有效的名称，而不是键/值对的方式，来使得相关的字典使代码更容易理解，那就最好了。

### PaintCode 与 Core Graphics

其他类值得一提的错误有 Core Graphics。Swift 3 引入了 Core Foundation-style 对象调用机制，也就是说现在你可以将其当做Swift对象来使用，而不是一组 C 函数。这可以让你的代码很整洁且保持可读性。这一新特性最常见于 Core Graphics 调用。移植器会转换大多数这些调用，但一些较少使用的函数（例如：Arc、Drawing）则不会被转换，所以你必须手动完成这部分的转换工作。

在我的项目中，我使用了大量的 PaintCode。而 PaintCode 的代码生成是出了名的不完全支持最新的 Swift 语法（当前版本仍然会产生对 Swift 2.3 的警告，即使它是一个需要解决的微不足道的问题）我真害怕我的图形代码可能无法正常地转换。幸运地的是上帝眷顾了我，因为移植后的代码并没有出现额外的问题。你可能还是想把代码的可见度从 `open` 变为 `internal`，尽管这能从编译器优化技术中受益更多。 （我有一个脚本，已经可以通过一些正则方式解决这个问题）

### 性能

总的来说，我注意到的是，在移植后我的项目在编译时间上没有显著变化。我的基准单元测试显示，在重度使用 dictionary 的代码中性能有些下降，除此之外没有其他显著变化。我的约束求解器仍然可以快速的生效。:)

### 最后的想法

总体而言，移植到 Swift 3 还是很容易的。移植器帮助我解决了过程中的大部分变更，而剩下的那部分也很容易修复。如果你对 Swift 还有点陌生 ，那我和你的情况可能会不同，所以你的项目迁移过程也会和我所描述的有所差异。

最后提一个非常有用的小建议：请确保你的项目中，在算法部分有足够多的的单元测试（这从不是一个坏主意！）这样你就可以验证在移植过程中是否有引入语义变化，而如果引入了变化，你也可以找到他们！

如果你喜欢这篇文章，请关注我的 [Twitter](https://twitter.com/codelleapps) 或 [Facebook](https://facebook.com/codelle.apps)。非常感谢！
