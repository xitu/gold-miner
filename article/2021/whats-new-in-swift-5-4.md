> * 原文地址：[What’s New in Swift 5.4?](https://medium.com/better-programming/whats-new-in-swift-5-4-88949071d538)
> * 原文作者：[Can Balkaya](https://medium.com/@canbalkaya)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/whats-new-in-swift-5-4.md](https://github.com/xitu/gold-miner/blob/master/article/2021/whats-new-in-swift-5-4.md)
> * 译者：
> * 校对者：

# What’s New in Swift 5.4?

#### Multiple variadic parameters, extended implicit member syntax, result builders, and more

![Photo by the author.](https://cdn-images-1.medium.com/max/3840/1*HfwBHnUJOzl56qCflMVQ1w.png)

Swift 5.4 brings us a lot which is why I like it. In this article, we learn what is new in Swift 5.4.

Note: You can [download this article’s example project and sources](https://github.com/Unobliging/What-s-New-in-Swift-5.4-) on GitHub. To open and edit these files, you have to use Xcode 12.5 beta. You can download Xcode 12.5 beta [here](https://developer.apple.com/download/). Instead of downloading Xcode 12.5 beta, you can download Swift 5.4 directly [here](https://swift.org/download/).

---

## The Most Important Improvement😄

As anyone who has created an Xcode project or playground file before will know, when you create a new playground or a new Xcode project, the following value will be written on this project:

```Swift
var str = "Hello, playground"
```

The name of this value has changed with Swift 5.4 as follows:

```Swift
var greeting = "Hello, playground"
```

Yes, I think this is the interesting and funny part of Swift 5.4.

Now we can look at improvements that really work!

---

## Multiple Variadic Parameters

In Swift 5.4, we can use multiple variadic parameters on functions, methods, subscripts, and initializers. Before Swift 5.4, we had just one variadic parameter, like the code below:

```Swift
func method(singleVariadicParameter: String) {}
```

Now, we can write multiple variadic parameters like the code below:

```Swift
func method(multipleVariadicParameter: String...) {}
```

We can call the function we wrote above, but of course, we can only write one `String` element if we want. Here’s the code:

```Swift
method(multipleVariadicParameter: "Can", "Steve", "Bill")
```

Multiple variadic parameters work just like arrays. Of course, when calling a value in a parameter, it is necessary to check beforehand if that value exists or not; otherwise, it will be wrong and crash. Here’s the code:

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

---

## Result Builders

Since SwiftUI came out, result builders are so important in Swift. Now, it is much more important with the new improvements.

Can we create dozens of strings with a function that outputs a `String`? If we use result builders, the answer is yes!

We can define new result builders by defining new structs with `@resultBuilder`. The methods and properties you will define must be `static`.

Back to our example of transforming `String` elements into a single `String` element. With the result builder below, we can join `String` elements written under them. The code is as follows:

```Swift
@resultBuilder
struct StringBuilder {
    static func buildBlock(_ strings: String...) -> String {
	strings.joined(separator: "\n")
    }
}
```

Let’s use the following code to describe it:

```Swift
let stringBlock = StringBuilder.buildBlock(
    "It really inspires the",
    "creative individual",
    "to break free and start",
	"something different."
)

print(stringBlock)
```

We had to use the `buildBlock` method directly when defining a value. Therefore, we had to put a comma at the end of each `String` element. Instead, we can use the `StringBuilder` in a function to do the same thing without using commas. Here’s the code:

```Swift
@StringBuilder func makeSentence() -> String {
    "It really inspires the"
    "creative individual"
    "to break free and start"
	"something different."
}

print(makeSentence())
```

What we have done with result builders so far may not mean much for you, but if we use result builders a little more effectively, you will understand their power better. For example, with two new methods that we will add to our result builder, we can use conditions to generate `String` elements using our result builder. The code is as follows:

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

As you can see, by creating an `if` loop, we can change the `String` element according to the boolean value. Here’s the result:

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

There are many things that can be done with result builders. You can find them out by trying.

---

## Extended Implicit Member Syntax

When defining an element inside a modifier, we no longer need to specify the main type of that element. So, you can chain together more than one member property or function without adding the type at the beginning, like this below:

```Swift
.transition(.scale.move(…))
```

After Swift 5.4, we have to write this code block below for the same result. Here’s the line of code:

```Swift
.transition(AnyTransistion.scale.move(…))
```

---

## Functions Support Same Names

Sometimes, you want to write functions with the same name. At least I wanted to do it. With Swift 5.4, we can do that.

For example, if we create functions with the same names — and these functions have the same parameter name — our code will work if we define these parameters with different object types.

You can try to write these below:

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

---

#### Conclusion

I hope you found this article helpful. There are new reports that Swift 6.0 may be released. I will also write an article on this subject.

Thank you for reading.

---

If you want to meet me or have questions about iOS development etc. you can have a one-on-one meeting with me [here](https://superpeer.com/canbalkya).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
