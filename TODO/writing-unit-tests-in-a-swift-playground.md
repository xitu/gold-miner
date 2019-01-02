> * 原文地址：[Writing unit tests in Swift playgrounds](https://www.swiftbysundell.com/posts/writing-unit-tests-in-a-swift-playground)
> * 原文作者：[John](https://twitter.com/johnsundell)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/writing-unit-tests-in-a-swift-playground.md](https://github.com/xitu/gold-miner/blob/master/TODO/writing-unit-tests-in-a-swift-playground.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[94haox](https://github.com/94haox)

# 在 Swift playground 中编写单元测试

Swift playground 对于[试用新的 framework](https://github.com/johnsundell/testdrive)、[探索语言的新特性](https://github.com/ole/whats-new-in-swift-4)来说十分有用。它提供的实时反馈能让你快速尝试新的想法与解决方案，大大提高生产力。

自 Swift 问世以来，无论是设计 framework API，还是给 app 开发新功能，我一直在不停地使用 playground，希望找到将它整合进工作流的办法。

本周，让我们来了解如何将 Swift playground 应用于编写单元测试，以及如何让 [TDD - 测试驱动开发](https://en.wikipedia.org/wiki/Test-driven_development)（ish）工作流变得更加顺畅。

## 基础

实际上在 playground 编写测试与编写 test target 基本一致。你可以先导入 `XCTest`，然后创建测试用例，例如：

```swift
import Foundation
import XCTest

class UserManagerTests: XCTestCase {
    var manager: UserManager!

    override func setUp() {
        super.setUp()
        manager = UserManager()
    }

    func testLoggingIn() {
        XCTAssertNil(manager.user)

        let user = User(id: 7, name: "John")
        manager.login(user: user)
        XCTAssertEqual(manager.user, user)
    }
}
```

## 如何访问你的代码

不过，如果你还没有实现直接在 playground 中测试的代码，那么在刚开始时访问代码可能会有点麻烦。你必须根据代码的来源（ app 还是 framework ），而选择不同的方式来访问将要测试的代码

**测试 app 代码**

由于可以在编写 playground 时不直接导入 app target，因此可以使用下面的几种方法测试 app 代码：

**1) 复制代码** 这大概是最简单的方法了。将想测试的代码复制至 playground 运行，最后再拷回去。这个方法简单粗暴。

**2) 复制文件** 如果你不想直接将要测试的代码放到 playground 中，也可以将需要的源文件复制到 playground 的 `Sources` 目录中（使用 `⌘ + 0` 显示 organizer，然后将文件拖进去）。接下来同上，在运行测试之后再将改变后的文件拷回覆盖源文件。

**3) 创建 framework target** 如果你讨厌复制文件，你也可以创建一个包含需要测试代码的 framework。在 Xcode 中创建一个新的 framework（或使用 [**SwiftPlate**](https://github.com/johnsundell/swiftplate) 创建一个跨平台 framework），接着按照下面的步骤操作。

**测试 framework 代码**

你可以通过以下操作将任意 framework 加入 playground：

* 将 framework 的 Xcode 工程拖入 playground 的 organizer 中。
* 系统将提示你将 playground 保存为一个工作区，照做即可（请注意不要将 playground 的内部工作区覆盖掉，而应该在 playground 文件夹外去创建一个新的工作区）。
* 打开此工作区。
* 选择你的 framework 的 scheme，对其进行构建。
* 现在，可以 `import` 你的 framework，开始编码了！

如果你希望自动执行上述操作，可以使用我写的脚本 - [**Playground**](https://github.com/johnsundell/playground)，它能让你通过一行命令完成上述除了 framework 的构建与 import 之外的所有操作：

```bash
$ playground -d /Path/To/Framework/Project.xcodeproj
```

## 运行测试

现在已经可以访问需要测试的代码了，并且我们还为其编写好了一个测试用例。现在试着运行这个测试用例！
 🚀

在一般的 test target 中，你一般会使用 `⌘ + U` 来运行你的测试；但在 playground 中，我希望 Xcode 能自动运行测试（以获得舒爽的实时反馈）。最简单的实现方式就是为你的测试用例运行 `defaultTestSuite`，如下所示：

```swift
UserManagerTests.defaultTestSuite().run()
```

执行上面的操作会运行测试，并将测试结果转储至控制台（可使用 `⌘ + ⇧ + C` 呼出）。这样做虽然没问题，但很容易错过错误信息。为此，可以创建一个测试观察者（test observer），在测试发生错误时触发一个断言失败（assertionFailure）错误：

```swift
class TestObserver: NSObject, XCTestObservation {
    func testCase(_ testCase: XCTestCase,
                  didFailWithDescription description: String,
                  inFile filePath: String?,
                  atLine lineNumber: UInt) {
        assertionFailure(description, line: lineNumber)
    }
}

let testObserver = TestObserver()
XCTestObservationCenter.shared().addTestObserver(testObserver)
```

在开始测试出现失败时，我们将看到编辑器提示一个行内错误 🎉

**如果你用的是 Swift 4，需要将上面的代码改成下面这样：**

```swift
class TestObserver: NSObject, XCTestObservation {
    func testCase(_ testCase: XCTestCase,
                  didFailWithDescription description: String,
                  inFile filePath: String?,
                  atLine lineNumber: Int) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
UserManagerTests.defaultTestSuite.run()
```

## 总结

虽然需要额外做一些设置，但我还是很喜欢使用 Swift playground 进行单元测试。我觉得这样通过快速的反馈并轻松进行修改，更加接近理想中的[红绿重构](http://blog.cleancoder.com/uncle-bob/2014/12/17/TheCyclesOfTDD.html)。这也可以构建更健壮的测试与更高的测试覆盖率。

我个人倾向于为正在开发的 app 与 framework 准备好一个 playground，以便更轻松地深入调试。此外，我还倾向于围绕 framework 构建 app，这样只需简单将代码引入 playground 就能开始编码。我会在之后的博文中讨论这些结构与设置的细节。

你怎么看？你是否准备使用 playground 进行单元测试？或者你是否在尝试其它方法？请通过评论或 Twitter [@johnsundell](https://twitter.com/johnsundell) 让作者知道你的意见、问题与反馈。

感谢您的阅读 🚀


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

