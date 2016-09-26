> * 原文地址：[Swift 3 migration pitfalls](http://codelle.com/blog/2016/9/swift-3-migration-pitfalls/)
* 原文作者：[ Emil Loer](http://codelle.com/contact/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[shliujing](https://github.com/shliujing) 
* 校对者：

[](http://codelle.com/blog/2016/9/swift-3-migration-pitfalls/)

万岁！Swift 3 发布了，让我们一起来迁移项目吧！在这篇文章中，我会向你阐述我的关于Swift 3语言的迁移经历，那是一个2万行的Swift项目。如果你对此感到好奇，这个项目其实是我实现的 Cassowary 线性约束求解算法 ，该算法最著名的是其通常被用于自动布局。但我将它用在了一些完全不同的事情上，我将会在以后的文章中说明。

### Swift 移植器

第一步是从Xcode中运行Swift移植器来对我的项目进行转换。移植器补充到了大多数需要改变的代码项，这节省了我很多的工作。有几件事情我不得不在这之后做出改变。最有趣的两项是权限变更（新的权限模型默认为使类`public`和方法`open`，但我想在大多数情况下，限制这一点）和一个我不得不重新的二进制搜索功能，原因是收集索引操作的工作方式的变更。虽然这并不是很麻烦。

### 什么也没有变

根据惯例来看，每次Swift发布的新版本，我的第一次编译尝试都会报错。在报错之前编译器日志会输出一个错误列表，之后我会根据列表解决错误，然后代码就可以正常运行了。

我必须修复哪些未被移植器捕捉到的，涉及两个语言之间变化所造成的变异错误，在下面两节我会高亮标注这些代码。

### 新的Ranges

第一类错误曾与语义改变`Range`结构做。在Swift3范围使用四个不同的结构可数/不可数范围和打开/关闭范围来区分现在表示。在Swift2打开和关闭的范围内使用相同的结构，所以如果你有一些代码，不得不在两种类型，这需要一些修改工作表示。

考虑这个有效的Swift2例如：


    func doSomething(with range: Range) {
        for number in range {
            ...
        }
    }

    doSomething(with: 0..<10) 
    doSomething(with:="" 0...10)="" 


在Swift2这会工作为半开放式和封闭式可数的范围。该迁移没有转换结构名称，因此迁移后这不工作了。在Swift3`Range`表示半开不可数范围。由于不可数范围不支持迭代我们必须改变这一点，这也将是很好，如果我们可以把它在两个半开放式和封闭式范围内工作。的解决方案是将输入转换为半开可数范围或使用泛型使它在两个工作。这使得利用这可数的范围内实现了`Sequence`协议的事实。

这里是一个Swift3版本的工作原理：


    func doSomething(for range: IterableRange) 
        where IterableRange: Sequence, IterableRange.Iterator.Element == Int {
        for number in range {
            ...
        }
    }

    doSomething(with: 0..<10) 
    doSomething(with:="" 0...10)="" 


### 元组转换

编译器抱怨的另一件事被命名为元组的转换。下面是一块有效Swift2代码：


    typealias Tuple = (foo: Int, bar: Int)

    let dict: [Int: Int] = [1: 100, 2: 200]

    for tuple: Tuple in dict {
        print("foo is \(tuple.foo) and bar is \(tuple.bar)")
    }


在迁移离开了这个代码不变，但是编译器抱怨for循环的类型转换为`Tuple`。当在该字典遍历可迭代的元素类型是`（关键：智力，值：智力）`和Swift2这是完全正常的，直接分配这具有相同的成员类型，但不同的名字命名的元组类型的变量。好了，不一样了！

虽然我认为这更严格的打字一般一个好主意，它确实意味着我们现在拥有的元组显式转换为我们的目标类型。我们可以替换为下面的代码循环使它重新工作：


    for tuple in dict {
        let tuple: Tuple = (foo: tuple.key, bar: tuple.value)
        print("foo is \(tuple.foo) and bar is \(tuple.bar)")
    }


当然，这是一个人为的例子，但如果你身边路过这个元组或任何可如果你使用语义有效的名称，而不是键/值，这只是相关的字典使代码更容易理解。

### PaintCode 与 Core Graphics

有些东西值得一提的是核芯显卡。Swift3引入了Core Foundation的样式引用的客观化，也就是说，好像他们是Swift的对象，而不是一组C函数，你现在可以使用它们。这是保持你的代码可读性很整洁。这一新功能是最常见核芯显卡电话。的迁移转化大多数这些调用的，但一些较少使用的功能（例如弧的绘图）不转换，并且必须手动完成。

在我的项目我做了很多使用PaintCode的。随着PaintCode的代码生成是出了名的不完全支持最新的雨燕语法（当前版本仍然会产生对雨燕2.3的警告，即使它是一个微不足道的问题来解决）我怕我的图形代码可能无法正常转换。幸运的是，神码在对我笑，因为没有其他问题进行了迁移后遇到。你可能还是希望从`open`知名度改为`internal`虽然从更多的编译器优化技术中受益。 （我有一个脚本，一些regexing做到这一点）

### 性能

总的来说，我注意到，在迁移后我的项目在编译时间上没有显著变化。我的基准单元测试显示，代码在字典重码方面有轻微的性能下降，但除此之外没有其他显著变化。但在其他方面没有什么显著。我的约束求解器仍然能够即可工作。 :)

### 最后的想法

总体而言，移植到Swift 3还是很容易的。迁移器帮助我解决了过程中的大部分变更，而剩下的那部分很容易修复。如果对你而言Swift 还有点新 ，那我和你的情况可能会不同，以至于你的项目里程也会有所差异。

最后提一个非常有用的小建议：请确保你的项目中，在算法部分有足够多的的单元测试（这从不是一个坏主意！）这样你就可以验证在迁移过程中是否有引入语义变化，而如果引入了变化，你也可以找到他们！

如果你喜欢这篇文章，请关注我的[Twitter]（https://twitter.com/codelleapps）或 [Facebook]（https://facebook.com/codelle.apps）。非常感谢！