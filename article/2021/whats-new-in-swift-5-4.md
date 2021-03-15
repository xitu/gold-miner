> * 原文地址：[What’s New in Swift 5.4?](https://medium.com/better-programming/whats-new-in-swift-5-4-88949071d538)
> * 原文作者：[Can Balkaya](https://medium.com/@canbalkaya)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/whats-new-in-swift-5-4.md](https://github.com/xitu/gold-miner/blob/master/article/2021/whats-new-in-swift-5-4.md)
> * 译者：[LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：[PassionPenguin](https://github.com/PassionPenguin),[flying-yogurt](https://github.com/flying-yogurt)

# Swift 5.4 的新特性

> 多个可变参数，拓展的隐式成员语法，Result 构建器，等等......

![图源作者](https://cdn-images-1.medium.com/max/3840/1*HfwBHnUJOzl56qCflMVQ1w.png)

Swift 5.4 带来了许多改变，而这也是我喜欢它的原因。在本文中，我们将了解 Swift 5.4 的新特性。

> 注意：你可以在 GitHub 上下载 [本文的示例项目和源代码](https://github.com/Unobliging/What-s-New-in-Swift-5.4-) 。要打开和编辑这些文件，你需要使用 Xcode 12.5 beta 版或更高级。你可以点击这里下载 [Xcode 12.5 beta 版]((https://developer.apple.com/download/))，或者你也可以选择直接下载 [Swift 5.4]((https://swift.org/download/))。

## 最重要的改进 😄

正如任何之前创建过 Xcode 项目或 playground 文件的人所知道的一样，当你创建一个新的 playground 或 Xcode 项目时，下面的值会被写入到这个项目中：

```Swift
var str = "Hello, playground"
```

在 Swift 5.4 中，其值的名称更改如下：

```Swift
var greeting = "Hello, playground"
```

是的，这就是我认为 Swift 5.4 中最有趣的部分。

现在我们可以看看那些真正的改进了！

## 多个可变参数

在 Swift 5.4 中，我们可以在函数、方法、下标和初始化器中可以使用多个可变参数。而在此之前，就只能有一个可变参数，就跟下面的代码一样：

```Swift
func method(singleVariadicParameter: String) {}
```

现在，我们可以像下面的代码那样编写多个可变参数：

```Swift
func method(multipleVariadicParameter: String..., secondMultipleVariadicParameter: String...) {}
```

我们可以这样调用上面所写的函数，同样，如果我们想的话，我们可以只传入一个字符串元素。下面的是示例代码：

```Swift
method(multipleVariadicParameter: "Can", "Steve", "Bill", secondmultipleVariadicParameter: "Tim", "Craig")
```

多个可变参数的工作原理与数组类似。当然，在调用参数中的值时，必须事先检查该值是否存在；否则，它将出错并崩溃。代码如下：

```Swift
func chooseSecondPerson(persons: String...) -> String {
    let index = 1
    if persons.count > index {
        return persons[index]
    } else {
        return "There is no second person."
    }
}
```

## Result 构建器

自从 SwiftUI 问世以来，Result 构建器在 Swift 中起着非常重要的作用。现在，随着新的改进，它变得更加重要。

我们能用一个输出单个字符串的函数创建几十个字符串吗？如果我们使用 Result 构建器，那么答案是，当然可以！

我们可以通过使用 `@resultBuilder` 定义新的结构来定义新的 Result 构建器。你要定义的方法和属性必须是 `static` 的。

回到我们将多个 `String` 转换为单个 `String` 的例子。使用下面的 Result 构建器，我们可以顺序链接多个 `String` 元素。代码如下：

```Swift
@resultBuilder
struct StringBuilder {
    static func buildBlock(_ strings: String...) -> String {
	strings.joined(separator: "\n")
    }
}
```

让我们用以下代码来调用它：

```Swift
let stringBlock = StringBuilder.buildBlock(
    "It really inspires the",
    "creative individual",
    "to break free and start",
	"something different."
)

print(stringBlock)
```

在定义值时，我们只应当直接使用 `buildBlock` 方法。因此，在每个 `String` 的末尾，我们都需要添加一个逗号。不过，如果在函数中使用 `StringBuilder` 来完成同样的需求，那么逗号不再被需要。代码如下：

```Swift
@StringBuilder func makeSentence() -> String {
    "It really inspires the"
    "creative individual"
    "to break free and start"
	"something different."
}

print(makeSentence())
```

目前为止，我们用 Result 构建器所作的工作对你来说可能没有什么意义。但如果我们更有效地使用 Result 构建器，你将更好地理解它们的强大之处。例如，有了这两个将添加到 Result 构建器中的新方法，我们可以使用 Result 构建器来有条件的生成字符串。代码如下：

```Swift
@resultBuilder
struct ConditionalStringBuilder {
    static func buildBlock(_ parts: String...) -> String {
        parts.joined(separator: "\n")
    }

    static func buildEither(first component: String) -> String {
        return component
    }

    static func buildEither(second component: String) -> String {
        return component
    }
}
```

如您所见，通过创建一个 `if` 循环，我们可以根据布尔值更改 `String` 元素。结果如下：

```Swift
@ConditionalStringBuilder func makeSentence() -> String {
    "It really inspires the"
    "creative individual"
    "to break free and start"

    if Bool.random() {
        "something different."
    } else {
        "thinking different."
    }
}

print(makeSentence())
```

当然啦！你还可以自己尝试使用 Result 构建器来完成许许多多有趣的事情，而不仅仅拘泥于上面的例子。

---

## 拓展的隐式成员语法

在修饰符内定义元素时，我们不再需要指定该元素的主要类型。因此，你可以将多个成员属性或函数链接在一起，而无需在开头添加类型，如下所示：

```Swift
.transition(.scale.move(…))
```

在 Swift 5.4 发布之前，若想得到相同的结果，我们只能这样写：

```Swift
.transition(AnyTransistion.scale.move(…))
```

## 支持同名函数

有时候，你会希望编写同名函数 —— 至少我是这么希望的。在 Swift 5.4 中，我们可以编写同名函数了。

比如说，如果我们创建具有相同名称的函数 —— 这些函数具有相同的形参名称 —— 只要我们用不同的对象类型来定义这些形参，那么我们的代码就会生效。

你可以试着这样写：

```Swift
struct iPhone {}
struct iPad {}
struct Mac {}

func setUpAppleProducts() {
    func setUp(product: iPhone) {
        print("iPhone is bought")
    }
    
    func setUp(product: iPad) {
        print("iPad is bought")
    }
    
    func setUp(product: Mac) {
        print("Mac is bought")
    }
    
    setUp(product: iPhone())
    setUp(product: iPad())
    setUp(product: Mac())
}
```

## 结论

希望这篇文章能对你有帮助。有报道称 Swift 6.0 可能即将发布。到时候我还会写一篇新文章来说明 Swift 6.0 的新功能。

感谢你的阅读。

---

如果你想和我见面，或者有关于 iOS 开发等方面的问题，你可以在[这里](https://superpeer.com/canbalkya)与我进行一对一的交流。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
