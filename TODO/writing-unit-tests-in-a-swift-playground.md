> * 原文地址：[Writing unit tests in Swift playgrounds](https://www.swiftbysundell.com/posts/writing-unit-tests-in-a-swift-playground)
> * 原文作者：[John](https://twitter.com/johnsundell)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/writing-unit-tests-in-a-swift-playground.md](https://github.com/xitu/gold-miner/blob/master/TODO/writing-unit-tests-in-a-swift-playground.md)
> * 译者：
> * 校对者：

# Writing unit tests in Swift playgrounds

Swift playgrounds are awesome for things like [trying out new frameworks](https://github.com/johnsundell/testdrive) and [exploring new language features](https://github.com/ole/whats-new-in-swift-4). The instant feedback they give you can really provide a huge productivity boost and enable you to try out new ideas and solutions quickly.

I’ve been using playgrounds non-stop ever since Swift came out and I’m always looking for ways to incorporate them into my workflows, whether that be designing the API for a new framework I’m working on, or building a new feature for an app.

This week, let’s take a look at how Swift playgrounds can be used for writing unit tests, and how it can make a [TDD](https://en.wikipedia.org/wiki/Test-driven_development)(ish) workflow a lot more smooth.

## The basics

Writing the actual tests in a playground is pretty much exactly the same as writing them as part of a test target. You start by importing `XCTest` and then you create your test case, like this:

```
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

## Getting access to your code

However, if you’re not also implementing the code you’re testing directly in the playground, getting access to it can be a bit tricky at first. Depending on whether you’re testing code from an app or a framework, you have to take slightly different paths.

**Testing app code**

Playgrounds can (at the time of writing) not directly import application targets. So if you want to test app code, you’ll have to use one of the following workarounds:

**1) Copy the code.** This is by far the easiest way, simply copy the code you want to test into your playground. Work on it, and once you’re done, copy it back. Crude, but effective.

**2) Copy the files.** If you don’t want to put the code you’re testing directly in the playground, you can copy the source files you need into the playground’s `Sources` folder (show it by revealing the organizer by pressing `⌘ + 0`, and then drag your files into it). Same thing as above, work on your tests, and once you’re done copy the changes back to the original source files.

**3) Create a framework target.** If you’re not a big fan of duplicating files, you can create a framework target that includes the source files you’re looking to test. Create a new framework target in Xcode (or use [**SwiftPlate**](https://github.com/johnsundell/swiftplate) to generate a cross-platform framework), then follow the instructions below.

**Testing framework code**

You can add any framework to a playground by doing the following:

* Drag the framework’s Xcode project into the playground’s organizer.
* You will be prompted to save the playground as a workspace. Do that (note that you don’t want to overwrite the playground’s internal workspace, but rather create a new one outside of the playground folder 😅).
* Open the workspace.
* Select your framework’s scheme and build it.
* You can now `import` your framework and start coding!

If you want to automate the above, I’ve written a script called [**Playground**](https://github.com/johnsundell/playground), which lets you do all of the above (except building and importing the framework) using a single command on the command line:

```
$ playground -d /Path/To/Framework/Project.xcodeproj
```

## Running your tests

OK, so we now have access to the code we want to test, and we have written a test case for it. Now, let’s get that test case running! 🚀

In a normal test target, you normally press `⌘ + U` to run your tests, but in a playground we want them to run automatically (to get that sweet sweet instant feedback). The easiest way to make this happen is to simply run the `defaultTestSuite` for your test case, like this:

```
UserManagerTests.defaultTestSuite().run()
```

Doing the above will run your tests and dump the results to the console (that you can bring up using `⌘ + ⇧ + C`), which is nice - but it’s easy to miss failures this way. To solve that problem, we can create a test observer that triggers an assertion failure in case of a test failure:

```
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

We will now see an error inline in the editor whenever a test starts failing 🎉

_If you’re using Swift 4, the above code looks like this instead:_

```
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

## Conclusion

Even though it requires some setup, I really like using Swift playgrounds for unit testing 👍. By getting quick feedback and have easy access to making changes, I find myself able to get closer to the idealistic [“red-green-refactor”](http://blog.cleancoder.com/uncle-bob/2014/12/17/TheCyclesOfTDD.html) TDD workflow without jumping through too many hoops, which usually leads to stronger tests and a higher test coverage.

I tend to keep a playground ready in a workspace containing the apps and frameworks that I’m currently working on, so that it’s easy for me to dive in. I also tend to structure my apps quite heavily around frameworks, so that it’s easy for me to simply import them into the playground and start coding. I’ll discuss these kind of structures and setups in more detail in an upcoming blog post.

What do you think? Do you already use playgrounds for unit testing, or is it something you’re going to try? Let me know, along with any comments, feedback or questions that you may have either here in the comments section below, or on Twitter [@johnsundell](https://twitter.com/johnsundell).

Thanks for reading 🚀


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
