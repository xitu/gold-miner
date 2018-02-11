> * 原文地址：[Avoiding force unwrapping in Swift unit tests](https://www.swiftbysundell.com/posts/avoiding-force-unwrapping-in-swift-unit-tests)
> * 原文作者：[John](https://twitter.com/johnsundell)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/avoiding-force-unwrapping-in-swift-unit-tests.md](https://github.com/xitu/gold-miner/blob/master/TODO/avoiding-force-unwrapping-in-swift-unit-tests.md)
> * 译者：
> * 校对者：

# Avoiding force unwrapping in Swift unit tests

While force unwrapping (using `!`) is an important Swift feature that would be hard to work without (especially when interacting with Objective-C APIs), it also circumvents some of the other features that make Swift so great. Like we took a look at in _["Handling non-optional optionals in Swift"](https://www.swiftbysundell.com/posts/handling-non-optional-optionals-in-swift)_, using force unwrapping when dealing with optionals that are actually _required_ by a program's logic can lead to really tricky situations & crashes.

So avoiding force unwrapping (when possible) can help us build apps that are more stable and give us better error messages when something does go wrong, but what about when writing tests? Dealing with optionals and unknown types in a safe way can require quite a lot of code, so the question is whether we want to do all that additional work when writing tests as well? That is what we'll take a look at this week - let's dive in!

## Tests vs Production Code

When working with tests, we often make a clear distinction between our _testing code_ and our _production code_. While it's important to keep both of those two code bases separate (we don't want to accidentally ship our mocks as part of our App Store build 😅), it's not necessarily a distinction we should use when talking about _code quality_.

If you think about it, what are some of the reasons that we want to have a high quality standard for the code that ships to our users?

* We want our app to be stable and run smoothly for our users.
* We want to make our app easy to maintain and easy to modify in the future.
* We want to make it easy to onboard new people onto our team.

Now, if we instead think about our tests, what are some of the things that we want to _avoid_?

* Tests that are unstable, flaky and hard to debug.
* Tests that are time consuming to maintain and update when new features get added to our app.
* Tests that are hard to understand for new people that join our team.

You might see where I'm going with this 😉.

For the longest time I used to treat testing code as something I just quickly put together because someone told me I had to write tests. I didn't care much about their quality, because I saw them as a chore that I actually didn't want to do in the first place. However, once I started seeing first hand how much quicker I could verify my code, and how much more confident I became that by code was _actually working_ - my attitude towards tests started changing.

So these days I do believe that it's important that we hold our testing code to the same high standards as our shipping production code. Since our test suite is something we have to constantly work with, update and maintain, we should make it _easy to do so_.

## The problem with force unwrapping

So what does all of this have to do with force unwrapping in Swift? 🤔

While force unwrapping is necessary sometimes, it's easy to make it a _"go-to solution"_ when writing tests. Let's take a look at an example in which we're writing a test to verify that the login mechanism of a `UserService` works as expected:

```
class UserServiceTests: XCTestCase {
    func testLoggingIn() {
        // Setup a mock to always return a successful response 
        // for the login endpoint
        let networkManager = NetworkManagerMock()
        networkManager.mockResponse(forEndpoint: .login, with: [
            "name": "John",
            "age": 30
        ])

        // Setup a service and login
        let service = UserService(networkManager: networkManager)
        service.login(withUsername: "john", password: "password")

        // Now we want to make assertions based on the logged in user,
        // which is an optional, so we force unwrap it
        let user = service.loggedInUser!
        XCTAssertEqual(user.name, "John")
        XCTAssertEqual(user.age, 30)
    }
}
```

As you can see above, we force unwrap our service's `loggedInUser` before making assertions on it. While doing something like the above is not necessarily _wrong_, it can lead to some problems down the line if this test starts failing for some reason.

Let's say someone (_and remember, "someone" can always mean "your future self"_ 😉) makes a change in the networking code, which causes the above test to start to break. If that happens, the only error message that will be available will be this:

```
Fatal error: Unexpectedly found nil while unwrapping an Optional value
```

While that may not be a big problem when working locally in Xcode (since the error will be displayed inline - at least most of the time 🙃), it can become quite problematic if it starts happening when running Continuous Integration for the project. The above error message might appear within a big "wall of text", which can make it really hard to figure out where it came from. Further, it will **prevent any subsequent tests from being executed** (since the test process will crash), which can make it really slow and annoying to work on a fix.

## Guard and XCTFail

One potential solution to the above problem is to simply use the `guard` statement to gracefully unwrap the optional in question, and call `XCTFail()` if it fails, like this:

```
guard let user = service.loggedInUser else {
    XCTFail("Expected a user to be logged in at this point")
    return
}
```

While doing the above is a valid approach in some situations, I really recommend avoiding it - since it adds control flow to your tests. For stability & predictability, you usually want tests to follow a simple **given, when, then** structure, and adding control flow can really make tests harder to read. If you're really unlucky control flow can also be a source of false positives (more on that in a future post).

## Sticking with optionals

Another approach is to let optionals remain optional. For some use cases that totally works, including our `UserManager` example. Since we are performing assertions against the logged in user's `name` and `age`, we will automatically get an error if any of those properties is `nil`. If we also throw in an additional `XCTAssertNotNil` check against the user itself, we'll have a pretty solid test with great diagnostics.

```
let user = service.loggedInUser
XCTAssertNotNil(user, "Expected a user to be logged in at this point")
XCTAssertEqual(user?.name, "John")
XCTAssertEqual(user?.age, 30)
```

Now if our test starts failing, we'll get the following information:

```
XCTAssertNotNil failed - Expected a user to be logged in at this point
XCTAssertEqual failed: ("nil") is not equal to ("Optional("John")")
XCTAssertEqual failed: ("nil") is not equal to ("Optional(30)")
```

That makes it a **lot** easier to understand what went wrong and what we need to do in order to debug and fix the issue 🎉.

## Throwing tests

A third option that's really useful in some situations is to replace APIs that return optionals with throwing ones. The beauty of throwing APIs in Swift is that they can super easily be used as optional ones when needed, so in many cases you are not sacrificing any usability by opting for the throwing approach. For example, let's say we have a `EndpointURLFactory` that creates URLs for certain endpoints in our app, that currently returns an optional:

```
class EndpointURLFactory {
    func makeURL(for endpoint: Endpoint) -> URL? {
        ...
    }
}
```

Let's now convert it into a throwing API instead, like this:

```
class EndpointURLFactory {
    func makeURL(for endpoint: Endpoint) throws -> URL {
        ...
    }
}
```

All we need to do when we still want an optional URL is to call it with `try?`:

```
let loginEndpoint = try? urlFactory.makeURL(for: .login)
```

The big advantage doing the above gives us in terms of testing, is that we can now simply use `try` in our tests and get handling of invalid values completely for free by the XCTest runner. It's a bit of a hidden gem, but Swift tests can actually be throwing functions, check this out:

```
class EndpointURLFactoryTests: XCTestCase {
    func testSearchURLContainsQuery() throws {
        let factory = EndpointURLFactory()
        let query = "Swift"

        // Since our test function is throwing, we can simply use 'try' here
        let url = try factory.makeURL(for: .search(query))
        XCTAssertTrue(url.absoluteString.contains(query))
    }
}
```

No optionals, no force unwrapping, and excellent diagnostics in case something starts failing 👍.

## Requiring optionals

However, not all APIs can be converted from returning optionals to throwing. But it turns out there's a pretty nice way we can get the same benefits as when testing throwing APIs when writing tests containing optionals as well.

Let's go back to the first `UserManager` example. What if instead of having to either force unwrap `loggedInUser`, or treat it as an optional, we could simply do this:

```
let user = try require(service.loggedInUser)
XCTAssertEqual(user.name, "John")
XCTAssertEqual(user.age, 30)
```

That would be pretty cool! 😎 That way we could get rid of a lot of force unwrapping, but at the same time not make our tests harder to write, or harder to follow. So what do we need to do in order to achieve the above? It's pretty simple, all we need to do is to add an extension on `XCTestCase`, that lets us evaluate any optional expression and either return a non-optional value or throw an error, like this:

```
extension XCTestCase {
    // We conform to LocalizedError in order to be able to output
    // a nice error message.
    private struct RequireError<T>: LocalizedError {
        let file: StaticString
        let line: UInt

        // It's important to implement this property, otherwise we won't
        // get a nice error message in the logs if our tests start to fail.
        var errorDescription: String? {
            return "😱 Required value of type \(T.self) was nil at line \(line) in file \(file)."
        }
    }

    // Using file and line lets us automatically capture where
    // the expression took place in our source code.
    func require<T>(_ expression: @autoclosure () -> T?,
                    file: StaticString = #file,
                    line: UInt = #line) throws -> T {
        guard let value = expression() else {
            throw RequireError<T>(file: file, line: line)
        }

        return value
    }
}
```

Now, with the above, if our `UserManager` login test starts failing, we'll get a super nice error message that gives us the exact location of the failure:

```
[UserServiceTests testLoggingIn] : failed: caught error: 😱 Required value of type User was nil at line 97 in file UserServiceTests.swift.
```

_You might recognize this technique from my micro framework [Require](https://github.com/johnsundell/require), which adds a require() method on all optionals to improve the diagnostics of unavoidable force unwraps._

## Conclusion

Treating your test code with the same amount of care as your app code can feel awkward at first, but can make it a lot easier to maintain tests in the long run - both when working on something on your own, or in a big team. Enabling good diagnostics and error messages is a major part of that, so using some of the techniques from this post you can hopefully avoid lots of tricky problems in the future.

The only time I always use force unwrapped optionals in test code is when setting up properties in test cases. Since these will always be created in `setUp` and removed in `tearDown`, I don't think it's worth having them as true optionals. Like always, you have to take a look at your own code and apply your own preferences, to see what tradeoffs you think are worth making.

What do you think? Will you apply some of the techniques from this post in your test code, or do you already use something similar? Let me know, along with any questions, comments or feedback you might have - either here in the comments section below or ping me on [Twitter @johnsundell](https://twitter.com/johnsundell).

Thanks for reading! 🚀


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
