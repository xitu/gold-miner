> * 原文地址：[The Forbidden @inline Attribute in Swift](https://swiftrocks.com/the-forbidden-inline-attribute-in-swift.html)
> * 原文作者：[Bruno Rocha](https://github.com/rockbruno)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-forbidden-inline-attribute-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-forbidden-inline-attribute-in-swift.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：[CLOXnu](https://github.com/cloxnu)

# Swift 里的强制 @inline 注解

Swift 中的 `@inline` 注解是一个含糊不清的东西，你在 Apple 的文档中是找不到它的，它并不能帮助你编写更清晰的代码，也没有任何目的性，它的存在只是为了帮助编译器做出优化的决策，但它同时也与你的 App 的性能的有很大关系。

在编程中，**函数内联** 是一种编译器优化技术，它通过使用方法的内容替换直接调用该方法，就相当于假装该方法并不存在一样，这种做法在很大程度上优化了性能。

例如，请看一下代码：

```swift
func calculateAndPrintSomething() {
    var num = 1
    num *= 10
    num /= 5
    print("我的数字：\(num)")
}

print("准备打印一些数字")
calculateAndPrintSomething()
print("完成")
```

假设 `calculateAndPrintSomething()` 没有在其他任何地方使用过，很明显该方法不需要存在于编译后的二进制文件中，它存在的目的只是为了使你更加易于阅读。

通过使用函数内联，Swift 编译器可以通过将调用这个方法替换为调用它里面的具体内容，从而消除那些不必要的开销：

```swift
// 上面的示例转化为编译后二进制版本
print("准备打印一些数字")
var num = 1
num *= 10
num /= 5
print("我的数字：\(num)")
print("完成")
```

基于你选择的优化级别，这个过程由 Swift 编译器自动完成的，通过支持内联来优化速度（`-O`），或者 **不** 进行内联来优化二进制包的大小（`-Osize`），因为内联一个经常调用且内容很多的方法会导致大量的重复代码和更大的二进制包。

尽管编译器可以自己进行内联，不过你还是可以 Swift 中使用 `@inline` 注解来 **强制** 内联，它有两种用法：

`@inline(__always)`：如果可以的话，指示编译器始终内联方法。

`@inline(never)`：指示编译器永不内联方法。

现在你可能会问：**到底怎么选择呢？**

根据苹果工程师的说法，答案基本上是 [never](https://lists.swift.org/pipermail/swift-users/Week-of-Mon-20170227/004886.html)。尽管该属性可用于公共或广泛使用的 Swift 源代码，但它还没有正式支持公共使用。它从来没有打算过要公开，Jordan Rose 也曾说到：**设定它不被公开是有原因的。** 如果你要使用它，可能会出现许多已知和未知的问题。

但由于该属性可以公开使用，为了学习新的东西，我会去尝试一下它，而且我实际上发现了这个注解在 iOS 项目中一些很实用的地方。

编译器将根据项目的优化设置做出内联决策，但在某些情况下，你可能需要一种方法来手动决策。这时 `@inline` 就可以帮助到你。

例如，在优化速度时，似乎编译器会对一些内容并不是很短的方法进行内联，从而导致二进制大小增加。在这种情况下，`@inline(never)` 可用于防止这个，同时保证二进制文件的速度。

另一个更实际的例子是，你可能想防止黑客接触到一个包含某种敏感信息的方法，它是否会使代码变慢或包变大都无关紧要。你肯定会尝试混淆你的代码来使代码更难理解，或者可以选择混淆工具，例如 [SwiftShield](https://github.com/rockbruno/swiftshield)，但 `@inline(__always)` 可以轻松实现这一点而同时不会损害你的代码，我将在下面详细介绍了这个例子：

## 使用 `@inline(__always)` 来混淆订阅的部分

假设我们的 App 中有一个音乐播放器，其中部分操作只有开通了高级版才能使用。`isUserSubscribed(_:)` 方法可以返回一个布尔值以查看用户是否订阅了高级版：

```swift
func isUserSubscribed() -> Bool {
    // 一些很复杂的验证逻辑
    return true
}

func play(song: Song) {
	if isUserSubscribed() {
        // 播放歌曲
    } else {
        // 让用户订阅
    }
}
```

这对我们的代码非常重要，但如果我们把这个 App 进行反编译并搜索 `play(_:)` 方法的程序集会发生什么：

![](https://i.imgur.com/3kqUFaF.png)

如果我是一个黑客试图破解这个 App 的订阅，看看 `play(_:)` 方法我就知道 `isUserSubscribed(_:)` 返回的布尔值控制着 App 的订阅。

我现在可以通过仅查找 `isUserSubscribed(_:)` 并强制它返回 `true` 就可以解锁 App 的全部高级内容：

![](https://i.imgur.com/JMjdAMS.png)

在这种情况下，可能因为该方法在 App 里广泛使用，所以编译器决定不内联它。这种决定就造成了一个安全漏洞，使得 App 能够很容易地被逆向工程破解。

现在看看给 `isUserSubscribed(_ :)` 添加了 `@inline(__always)` 后会发生什么：

```swift
@inline(__always) func isUserSubscribed() -> Bool {
    // 一些很复杂的验证逻辑
    return true
}

func play(song: Song) {
	if isUserSubscribed() {
        // 播放歌曲
    } else {
        // 让用户订阅
    }
}
```

![](https://i.imgur.com/JwkToz8.png)

同样的 `play(_:)` 方法里现在不包括对订阅状态的判断。这个方法调用完全被其内部的 “复杂的验证” 所取代，这样反编译后看起来变得更加复杂，订阅也更加难以破解。

好处是，由于每次调用 `isUserSubscribed(_:)` 都被复杂的验证取代，因此就没有一种方法可以解锁应用程序的整个订阅，黑客现在必须破解每一个进行验证的方法。当然，多处的重复的代码也意味着我们的二进制文件会变得更大。

请注意，使用 `@inline(__always)` 并不能保证编译器会真正内联你的方法。它的规则是未知的，例如在无法避免动态派发的情况下就无法进行内联。

## 还有什么？

由于 `@inline` 没有得到官方支持，你真的不应该在实际的项目中使用它，这篇文章使用它的目的只是为了学习新东西。

但是我确实发现它非常有用，希望 Apple 决定在某一天正式支持它。如果你对 Swift 中一些模糊的概念感兴趣，请查看 [Swift 的源代码](https://github.com/apple/swift)。

你可以在 Twitter 上关注我 [@rockthebruno](https://twitter.com/rockthebruno)，如果你有任何建议也欢迎分享。

## 参考文献和一些好的读物

- [内联函数](https://en.wikipedia.org/wiki/Inline_function)
- [[swift-users] @inline Thread](https://lists.swift.org/pipermail/swift-users/Week-of-Mon-20170227/004883.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
