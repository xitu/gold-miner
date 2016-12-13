> * 原文地址：[Yammer iOS App ported to Swift 3](https://medium.com/@yammereng/yammer-ios-app-ported-to-swift-3-e3496525add1)
* 原文作者：[Engineering Yammer](https://medium.com/@yammereng)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Danny Lau](https://github.com/Danny1451)
* 校对者：[冯志浩](https://github.com/fengzhihao123) ， [Gocy](https://github.com/Gocy015)


# Yammer iOS 版移植到 Swift3





随着九月下旬 Xocde 8 的发布，Swift 3 已经成为了开发 iOS 和 Mac OS 应用的默认版本。

作为一个 iOS 商店，我们必须制定一个迁移工程，在保持与项目中 Objective-C 部分良好交互的前提下，把基础代码从 2.3 版本迁移到 3.0 版本。

第一步是决定我们是否要移植到 Swift 3 。在之前我们没有别的选择，只能咬着牙上。但是这次 Xcode 8 提供了一个 [build flag](https://developer.apple.com/swift/blog/?id=36) 能够让你使用旧版本的 Swift 。这表明旧特性只对版本改变有意义。根据 [发行说明](https://developer.apple.com/library/prerelease/content/releasenotes/DeveloperTools/RN-Xcode/Introduction.html) Xcode 8.2 预计是最后一个能够支持 Swift 2.3 的版本。

另一个让我们考虑反对迁移的原因是大量的 [改变](https://buildingvts.com/a-mostly-comprehensive-list-of-swift-3-0-and-2-3-changes-193b904bb5b1#.z9w2usfdx) 。Swift 团队和社区非常的活跃，而且 Swift 3 也展示出了作为一个年轻语言的发展潜力。不幸的是，这个版本 [不具有 ABI 的兼容性](http://thread.gmane.org/gmane.comp.lang.swift.evolution/17276) ，意味着1年之后 Swift 4 着陆的时候，我们又要进行一次类似的迁移。现在不迁移的话，因为要同时迁移 3 和 4 的特性，到时候就是两倍的工作量了。当然不一定是真的，也许 Swift 4 的改变和 Swift 3 在相同的范围内呢，而且久而久之，Xcode 提供的迁移工具也会变得更加好用更加值得信赖。 

不管怎么样，不出意料地，我们选择了迁移。

一旦我们决定开始迁移了，必须制定一个计划。把迁移工作模块化很明显是几乎不可能的。Xcode 只能允许编译一个 Swift 的版本，因此一旦迁移之球开始滚动，所有的改动需要同时合并到主干上。这就导致了一系列的逻辑问题：从禁止团队修改任何 Swift 文件，到后来出现大量 pull request 。同事也许会很感谢你的努力但是他们无论如何都会恨你的。我们最终决定建立一个笔记，团队中的任何人可以都把他们正在工作的类文件添加进去，通过这样我们就可以暂时把这些文件放在一旁，等到迁移之前再尝试将它们合并。这个工作一般来说不会轻松，尤其是你接下来的工作都要靠编译错误来指引的情况下。

也就是说，还是有更好的方法的。在 Target 中移除大部分你的类，然后 [将它们构建成单独的模块](https://twitter.com/cocoaphony/status/794988795208802305) 。这个方式可以使不同版本的 Swift 共存。但是，我不相信这是一个完全不痛苦的过程。我也不是真的知道，因为我们没有选择这个方式。

一旦准备好了，我们启动了 Xcode 的迁移工具（_Edit->Convert->to Current Swift Syntax_）然后看到生成了大量的不同点。我们通过分析每个文件中的每个不同点，对那些看上去不是很正确的进行笔记和制定草稿（在后面的列表中更多）。

和预想中的一样，在将项目迁移并能够成功编译的路上，迁移工具只能帮你做一半左右的工作。下一步是打开问题导航栏一个个的去解决警告和错误（是的，包括警告因为我们不是动物）。大部分的问题都会有个方便的解决提示，一般情况下它都是正确的解决方案，有时候最好重排或者重写代码，这样能够显得更清晰。迁移是一个重新审视和定义整个代码库中的某些实现的绝佳机会，特别是当这门语言才刚刚出现在大众视野中的时候。

在你进行的过程中，错误列表会不断的上下波动。通过全局的搜索替换可以很容易的找到能够区块修复的地方。最后代码终于可以编译和运行了，测试用例也终于能够编译，运行和通过了。能够通过测试用例是最第一个重要的里程碑了。目前为止的每个改动都应该尽可能的小。记下那些看上去奇怪的地方，在所有测试用例没通过之前都不要去动它们。

随着测试用例的通过，我们现在可以把注意力集中在已经收集的那些任务和笔记列表上了。这些代码都是正确可运行的，但却非常辣眼睛。（不要打开右侧的责任面版，说不定这个代码就是你自己写的！）

下面，是我们在迁移工程中记录的东西，有些每个人可能都会遇到，另外一些可能只在我们的代码库中间出现。

*   **fileprivate 转成 private**。这个迁移要把你所有的 `private` 声明改成 `fileprivate` 。这个不是必须要更正的因为有些确实是私有的。我们把所有 `fileprivate` 替换回了 `private` ，然后重新过了一遍错误，打开源码片段来检查哪些是真正需要的。
*   **NSIndexPath 转成 IndexPath**。有些改了但是有些没有，自己去探索吧！另一方面有些是需要改变的是我们的内部 api 。
*   **UIControlState().normal 转成 UIControlState()**。这个可选的默认值配置在 init 构造函数里面可以是空的。没有 `.normal` 看上去生动，所以我们所有都替换了。例外一个值得注意的是 `UIViewAnimationOptions()` 我们替换成了 `.curveEaseInOut` 。
*   **Enum 中的枚举转成小写**。有些枚举变成了首字母小写，有些不会。所以，我们手动做了这部分改动。这个迁移工具会把那些有敏感词冲突的单词，比如 `default` 通过使用逆向大小写来处理。
*   **你真的是可选的?** 有些 API 改变了，采用了可选类型。如果这个一个内部的 Objective-C API 的话，确保你的可空标识是被正确设置了。
*   **Objective-C 可空标识符**。在 Swift 3 中，每个导入的没有可空标识符的 Objective-C 类都会被强制解包到可选。
最快的解决方法是每个地方都用 `if let` 或者 `gurad let`，但是在这么做之前，在 Objective-C 这边做个检查。
*   **Optional 可比性**。因为一些 API 中的可选性的改变，并且事实上也有许多 Objective-C 的 API 的改变（见上面），迁移工具会为泛型的可选类型生成一些比较函数（ `func < (lhs: T?, rhs: T?) -> Bool` ），这是一个坏的点子，很可能你的逻辑需要改变，一些代码也要删除。
*   **NSNumber!**。Swift 3 不再会自动桥接 number 到 `NSNumber` 了（或者相似的其他 NS 类），但是在大部分的例子中，这个是不需要强制的。把它们都检查一遍。
*   **DispatchQueue**。我喜欢这个新的 DispatchQueue 语法，但是迁移工具把一些转换搞混了。并且代码中的每一个 `dispatchAfter` 必须检查一遍方式重复转换到纳秒。因为大部分的 API 会用秒级的延迟，我们通过 `NSEC_PER_SEC` 来执行乘法加倍的操作，而迁移工具会使用这个逻辑并且通过 `NSEC_PER_SEC` 来分割，这种解决方法不够漂亮。
*   **NSNotification.Name**。现在 `NotificationCenter` 不再通过 `String` 而是 `NSNotification.Name` 来添加 observer 。迁移工具会把原来的量常量包装在一个 `Notification.name` 中，然而我们更倾向于把 `Notification.name` 赋给一个 let 变量来隐藏常量的逻辑。
*   **NSRange 转变 Range**.大部分的字符串 API 现在使用 `Range` 来替换 `NSRange` 。现在通过使用 literal ranges (0..<9) 更加容易操作它们。总的来说，ranges 在 Swift 中改变了很多，每个人在使用它的时候都崩溃过。重新检查一下它们，你的代码库值得这个变换！
*   **_ 第一个参数**。Swift 3 命名规范改变来暗指着函数的第一个参数，大部分你的 api 和 api 调用都会自动改变，有些则不会。更糟糕的是，有些建议的 api 改动导致你的函数变得难以阅读。想用 `NS_SWIFT_NAME` 作为那些 Objective-C 的名字是不够 Swift 化的。
*   **Objective-C 类属性**。许多类的调用在 Swift 中现在通过类属性的方式来实现之前的类方法(除了: _ `UIColor.red`)。在你的 Objective-C 中 你可以把一个 get 方法转换为一个 [静态属性]((http://useyourloaf.com/blog/objective-c-class-properties/)) ，它会在两个环境下生效。
*   **Any 和 AnyObject**。Objective-C 中的 id 类型现在不再由 Anyobject 而是由 Any 来代替了。这个转换相当容易地就能解决但是也可能导致一些行的误导， [阅读](http://kuczborski.com/2014/07/29/any-vs-anyobject/) 和理解它们的不同之处。
*   **权限控制**。我们已经讨论过 `private` 和 `filePrivate` 了。同样值得去重新检查一下 `open`， `public` 和 `internal` 。这是另外一个要在团队内部要达成一致协议的重要事情。

**结论**

迁移约 180 个 Swift 文件的过程花了两个人两周的时间。我们选择结对迁移(**我这么称呼它!**)是因为这样的条件下有特别的好处。
当这个项目的重点少部分在代码逻辑，而更多的在确保没有由于打字错误，重命名操作符和重排导致的新的bug时，有四只眼睛而不是两只眼睛就显得重要的多了。当你眼前的东西逻辑不通或是意义不明时，多一双手和一台笔记本来检查原始的代码会变得非常方便。总的来说，这样能让一个本来没什么乐趣的任务变得令人享受。不过当所有事情都失败的时候，至少你还能切换回去。感谢 Mannie([@mannietags](https://twitter.com/mannietags)) 的陪伴和忍耐。

由于工作流的本质是编译错误主导的，有时候想要将特定的操作合成连续的提交是很困难的。为了这个目标，回滚分支并且重新提交每一个逻辑模块，这样做至少可以让你的操作历史变得更好。这个可以延伸到来构建一个瀑布分支来创造小的 PR 。它们很明显稍后必须被合并到小瀑布中，或者你可以一开始就做好这部分工作。

迁移对把你的代码提高到更高的水平来说是个有效的方法。它通过更新代码版本来实现这一目的，同时这也是一次发现代码中不规范或过时编码的一个好机会。把这些发现和更新记录下来并加入你们的团队编码规范之中（如果你还没有这个规范，现在就开始写吧）。这么做主要有两个原因，其一是可以供将来加入团队的人进行参考。二来是可以将更新/创造过程中的思路展示出来。就像一个普通的迁移 PR 或许非常无趣，没有什么吸引力，而一个有着许多更新、同时还有描述这些变化的动机的说明的 PR，对团队中的其它成员就更容易跟进和理解了.

_Francesco Frison 是 Yammer 的一名 iOS 工程师。_ [_@cescofry_](https://twitter.com/cescofry)





