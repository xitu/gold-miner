> * 原文地址：[How Can Swift Language Features Improve Testability?](http://qualitycoding.org/swift-testability/)
* 原文作者：[Jon Reid](http://qualitycoding.org/contact/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：





I learned how to write testable code in C++ and Objective-C. But what about Swift?

The features and the overall “feel” of a language can have a big impact on how we express our code. Many of you know this well, because you started Swift early, and are miles ahead of me. I’m delighted to play catch-up. Swift’s features are like new toys! …But how do they affect testability?

## Writing testable code

_Disclosure: The book link below is an affiliate link. If you buy anything, I earn a commission, at no extra cost to you._

The greatest challenge of unit testing is writing testable code. This usually means relearning how to write code in the first place! The book [Working Effectively with Legacy Code](http://www.amazon.com/gp/product/0131177052/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0131177052&linkCode=as2&tag=qualitycoding-20&linkId=CMFUKIQWYHGBBOSN) offers great tricks for taming code not written with testability in mind. Techniques like “Subclass and Override Method” work well with legacy code, so I initially used them for TDD as well.

But one day I asked myself, “Why am I _writing_ legacy code?”

In other words, the legacy code techniques are workarounds. Aren’t there ways to tame testability without resorting to workarounds?

That’s how I found my way to [Dependency Injection](http://qualitycoding.org/dependency-injection/). One purpose of Dependency Injection is to give a test complete control over the thing it’s testing.

Different language features can make dependency injection easier. _Constructor Injection_ is the preferred form of DI. It turns out Swift’s default parameter values can simplify Constructor Injection. (But what if you have a Swift closure property? And a default closure for it? Read on!)

## Review: Marvel API authentication using Objective-C

I first learned unit testing and TDD when writing C++. When I moved to Objective-C, it was a breath of fresh air! Both production code and test code were so much easier to write, and read.

Now I’m redoing my (woefully incomplete) [TDD sample app](http://qualitycoding.org/tdd-sample-archives/), this time in Swift. The Marvel Browser will be a simple app for exploring comic characters in the Marvel universe.

A big part of it has been learning how to communicate with the Marvel API. It started with a [spike solution in Objective-C](http://qualitycoding.org/spike-solution-techniques/). To turn the spike into TDD’d code, I had to tame two things in particular that can make unit testing difficult:

Rather than try to figure it all out in advance, I went ahead with Subclass and Override Method. That is, I scoped those two things into methods. Then a special subclass just for testing overrode those two methods.

It’s a legacy code technique, but it’s still not a bad way to get started. The trick is not to stay there.

How can we design things to be replaceable? I thought about using the [Strategy design pattern](https://en.wikipedia.org/wiki/Strategy_pattern), but decided to go with blocks instead. I turned those blocks into properties. This opened the door to Property Injection.

How can we provide the default block? I could have done this in the initializer, of course. But this would leave the initializer cluttered. Instead, I used lazy properties — not to defer their initialization, but just to move them out of init.

## Testing time-dependent code

As I started the Swift version, something about my initial Objective-C implementation bothered me. To keep things simple, the timestamp was a lazy property that froze the time when it was first accessed. Multiple calls to the same instance would yield the same result. I tried to hide this by using a convenience factory method.

J. B. Rainsberger has a great article on this very problem. Actually it’s about a more general problem: getting your abstractions right. But the case study is about time-dependent code. In [Beyond Mock Objects](http://blog.thecodewhisperer.com/permalink/beyond-mock-objects), he describes the example at a stage when it requires separate instances:

> I find it strange, too. I’ve simplified the dependency in one respect, and complicated it in another: clients have to instantiate a new controller on each request, or said differently, the controller has request scope. This sounds wrong.

I encourage you to study the article. Basically, instead of having the method in question _determine_ the timestamp, we can simply _pass_ the timestamp as a parameter. This is a classic use of Method Injection.

In Objective-C, this can be done by having cascading methods. This interface should be pretty clear:

    - (NSString *)URLParameters;
    - (NSString *)URLParametersWithTimestamp:(NSString *)timestamp;

    The first method calls the second, providing the timestamp value:

    - (NSString *)URLParameters
    {
        return [self URLParametersWithTimestamp:[self timestamp]];
    }

One complication: Swift doesn’t allow us to call another instance method to get the default value. So if you can, make it a type method instead. (If not, we can always fall back on cascading methods.)

## Swift default property values

When I use Property Injection in Objective-C, I usually set up a default value for that property. We can establish small properties in the initializer. But sometimes you don’t want code in your initializer that is otherwise unrelated. Or sometimes it’s not small — it’s a block. At such times, I tend to use the lazy property idiom in Objective-C.

Here’s how I did this for the block property that calculates the MD5 hash:

    - (NSString *(^)(NSString *))calculateMD5
    {
        if (!_calculateMD5)
        {
            _calculateMD5 = ^(NSString *str){
                /* Actual body goes here */
            };
        }
        return _calculateMD5;
    }

Wow, that’s so much simpler!

## Experimenting with closures

Here’s what my main test looked like at this point. It’s not bad:

     func testUrlParameters_ShouldHaveTimestampPublicKeyAndHashedConcatenation() {
            sut.privateKey = "Private"
            sut.publicKey = "Public"
            sut.md5 = { str in return "MD5" + str + "MD5" }

            let params = sut.urlParameters(timestamp: "Timestamp")

            XCTAssertEqual(params, "&ts=Timestamp&apikey=Public&hash=MD5TimestampPrivatePublicMD5")
        }

As you can see, I override the MD5 closure to keep the test understandable. The test demonstrates that the generated URL parameters are correct. You can see how the hashing is supposed to work.

But then I thought, why override a closure property? Why not pass the MD5 algorithm as a parameter instead? And if we make it the last parameter, then we can use _trailing closure_ syntax:

    func testUrlParameters_ShouldHaveTimestampPublicKeyAndHashedConcatenation() {
            sut.privateKey = "Private"
            sut.publicKey = "Public"

            let params = sut.urlParameters(timestamp: "Timestamp") { str in
                return "MD5" + str + "MD5"
            }

            XCTAssertEqual(params, "&ts=Timestamp&apikey=Public&hash=MD5TimestampPrivatePublicMD5")
        }

Is this easier to read? Honestly, I think it’s a little worse. I use blank lines to separate my tests into the “Three A’s” (Arrange, Act, Assert). I feel like this particular closure muddies the Act section. Also it no longer has a name, which makes it harder to tell what it’s faking.

But I had to try to find out!

## Testable Swift

Here’s what I’ve learned so far about how Swift makes it easier to write code that’s both testable and clean…

**Defaults:** Swift’s default values simplify a number of Dependency Injection techniques:

*   Constructor Injection: use default parameter values in initializer.
*   Property Injection: use default property values.
*   Method Injection: use default parameters values in any method.

**Closures:** The consistent syntax of Swift’s closures provides various places to introduce Seams.

*   Closure properties
*   Closure parameters
*   Refactoring is easier because the syntax doesn’t change wildly.
*   Because functions are closures, you can extract many closures to wherever you want. Why do everything in-line?

I don’t want to abuse closures. Chances are, there’s often an abstraction waiting to be discovered and pulled into a Strategy pattern. But every Seam is an opportunity for enhancing testability.

I’m still scratching the surface of Swift. I know from Joe Masilotti’s article [Better Unit Testing with Swift](http://masilotti.com/better-swift-unit-testing/) that protocols provide excellent Seams. But how do other language features affect testability? What about enums, or generics? To keep up with my ongoing adventures exploring Clean, Test-Driven Swift, [subscribe today](http://qualitycoding.org/subscribe/)!

**_What features of Swift have you used for greater testability? What features should I explore? Let me know in the comments below._**

### _Related_



