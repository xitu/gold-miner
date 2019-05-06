> * 原文地址：[The Forbidden @inline Attribute in Swift](https://swiftrocks.com/the-forbidden-inline-attribute-in-swift.html)
> * 原文作者：[Bruno Rocha](https://github.com/rockbruno)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-forbidden-inline-attribute-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-forbidden-inline-attribute-in-swift.md)
> * 译者：
> * 校对者：

# The Forbidden @inline Attribute in Swift

The `@inline` attribute is one of those obscure things in Swift - it's nowhere to be found in Apple's docs, doesn't help you write cleaner code and has no purpose but to help the compiler make optimization decisions, but it's related to a pretty important aspect of your app's performance.

In programming, **function inlining** is a compiler optimization technique that removes the overhead of calling certain methods by directly replacing calls to them with the method's contents, basically pretending that the method never existed in first place. This provides a great performance boost.

For example, consider the following code:

```swift
func calculateAndPrintSomething() {
    var num = 1
    num *= 10
    num /= 5
    print("My number: \(num)")
}

print("I'm going to do print some number")
calculateAndPrintSomething()
print("Done!")
```

Assuming that `calculateAndPrintSomething()` isn't used anywhere else, it's clear that the method doesn't need to exist in the compiled binary - it's purpose is purely to make the code easier to read.

With function inlining, the Swift compiler can remove the overhead of calling an useless method by replacing it with it's contents:

```swift
//The compiled binary version of the above example
print("I'm going to do print some number")
var num = 1
num *= 10
num /= 5
print("My number: \(num)")
print("Done!")
```

Based on your optimization level, this is done automatically by the Swift compiler - favoring inlining if optimizing for speed (`-O`), or favoring **not** inlining if optimizing for binary size (`-Osize`), since inlining a long method that is called in several places would result in duplicated code, and a larger binary.

Even though the compiler can make its own inlining decisions, the `@inline` attribute can be used in Swift to **force** its decision. It can be used in two ways:

`@inline(__always)`: Signals the compiler to always inline the method, if possible.

`@inline(never)`: Signals the compiler to never inline the method.

Now, you might be asking: **When the hell is doing this a good idea?**

According to the Apple engineers, the answer is basically [never.](https://lists.swift.org/pipermail/swift-users/Week-of-Mon-20170227/004886.html) Even though the attribute is available for public use and widely used in the Swift source code, it is not officially supported for public use. It was simply never meant to be publicly available, and to quote Jordan Rose: **the underscores are there for a reason.** Many known and unknown issues can arise if you use it.

But since the attribute can be used publicly, I've decided that for the sake of learning something new I would experiment with it - and I've actually found cases where the attribute can be useful in iOS projects.

The compiler will make its inlining decisions based on your project's optimization settings, but there are cases where you could want a method to go **against** the optimization setting. In these cases, `@inline` can be used to achieve the user's goals.

For example, when optimizing for speed, it seems like the compiler will have a tendence to inline even methods that are not short, resulting in increased binary sizes. In this case, `@inline(never)` can be used to prevent the inlining of a specific widely-used-long method while still focusing on fast binaries.

Another more practical example is that you might want a method to be hidden from possible hackers for containing some sort of sensitive info, regardless if it will make your code slower or bigger. You can try to make the code harder to understand or use some obfuscation tool like [SwiftShield](https://github.com/rockbruno/swiftshield), but `@inline(__always)` can achieve this without hurting your code. I've detailed this example below.

## Using `@inline(__always)` to obfuscate Premium content

Let's pretend we have a music player in our app and some actions are premium-only. The `isUserSubscribed(_:)` method validates the user subscription and returns a boolean stating if the user is subscribed or not:

```swift
func isUserSubscribed() -> Bool {
    //Some very complex validation
    return true
}

func play(song: Song) {
	if isUserSubscribed() {
        //Play the song
    } else {
        //Ask user to subscribe
    }
}
```

This works great for our code, but look what happens if I disassemble this app and search for the `play(_:)` method's assembly:

![](https://i.imgur.com/3kqUFaF.png)

If I was a hacker trying to crack this app's subscription, glancing at the `play(_:)` method was all I had to do to realize that a boolean called `isUserSubscribed(_:)` is controlling the app's subscription.

I can now unlock the app's entire premium content by merely finding `isUserSubscribed(_:)` and forcing it to return `true`:

![](https://i.imgur.com/JMjdAMS.png)

In this case, likely because the method is widely used around the app, the compiler decided to not inline it. This naive decision created a security flaw that allowed the app to be quickly reverse-engineered.

Now look what happens when `@inline(__always)` is applied to `isUserSubscribed(_:)`:

```swift
@inline(__always) func isUserSubscribed() -> Bool {
    //Some very complex validation
    return true
}

func play(song: Song) {
	if isUserSubscribed() {
        //Play the song
    } else {
        //Ask user to subscribe
    }
}
```

![](https://i.imgur.com/JwkToz8.png)

The same `play(_:)` method's assembly now contains no obvious reference to a subscription! The method call got completely replaced by the "complex validation" that happened inside of it, making the assembly look more cryptic and the subscription significantly harder to be cracked.

As a bonus, since every call to `isUserSubscribed(_:)` got replaced by the validation, there is no single way to unlock the app's entire subscription - a hacker would now have to crack every single method that does the validation. Of course, this also means that our binary got larger as we now have duplicated code everywhere.

Be aware that using `@inline(__always)` doesn't guarantee that the compiler will actually inline your method. The rules for it are unknown, and there are some cases where inlining is impossible, such as when dynamic dispatching can't be avoided.

## What else?

Since `@inline` is not officially supported, you should really never use it in a real project and use this article only for the sake of learning something new.

However, I found it to be very useful and hope Apple decides to officially support it some day. If you are interested in more obscure Swift things, check out [Swift's Source Code.](https://github.com/apple/swift)

Follow me on my Twitter - [@rockthebruno](https://twitter.com/rockthebruno), and let me know of any suggestions and corrections you want to share.

## References and Good reads

- [Inline Functions](https://en.wikipedia.org/wiki/Inline_function)  
- [[swift-users] @inline Thread](https://lists.swift.org/pipermail/swift-users/Week-of-Mon-20170227/004883.html)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
