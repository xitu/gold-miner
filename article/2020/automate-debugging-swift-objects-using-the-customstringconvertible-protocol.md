> * 原文地址：[Automate Debugging Swift Objects Using the CustomStringConvertible Protocol](https://levelup.gitconnected.com/automate-debugging-swift-objects-using-the-customstringconvertible-protocol-c01fff74380f)
> * 原文作者：[Zafar Ivaev](https://medium.com/@z.ivaev)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/automate-debugging-swift-objects-using-the-customstringconvertible-protocol.md](https://github.com/xitu/gold-miner/blob/master/article/2020/automate-debugging-swift-objects-using-the-customstringconvertible-protocol.md)
> * 译者：
> * 校对者：

# Automate Debugging Swift Objects Using the CustomStringConvertible Protocol

#### A handy extension to copy and paste in your app

![Photo by [freddie marriage](https://unsplash.com/@fredmarriage?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/13020/0*MRWdAuXtqP-xHZ1g)

In this article, we will learn how we can easily automate debugging Swift objects using a handy `CustomStringConvertible` protocol conformance in an extension.

The source code of the extension is available at the bottom of the article.

Without further ado, let’s get started.

## Let’s Start

If you have ever conformed to the [CustomStringConvertible protocol](https://medium.com/better-programming/what-is-the-customstringconvertible-protocol-in-swift-4b7ddbc5785b), then this code looks very familiar to you:

![](https://cdn-images-1.medium.com/max/2616/1*duJMrNJX7UNHfeNAJsilpA.png)

If you have only two objects to debug, then it’s fine. But if you have many, creating similar looking `description` properties for each object is going to be time consuming.

For that reason, we can automate the process by creating an extension on the protocol so you will only need to conform to `CustomStringConvertible` and the extension will do the heavy lifting for you.

Here is that extension:

![](https://cdn-images-1.medium.com/max/2880/1*7ak0-HzI9z6JHBCssGlc_A.png)

Here is what it does:

* Create a string showing the type of an object
* Create a `Mirror` that is a representation of the object’s properties.
* Iterate over the properties of the object and append the name and value of each property to the string.
* Return the finished string

As a result, the only thing you will now have to do is simply conform to the `CustomStringConvertible`, no `description` property is needed:

![](https://cdn-images-1.medium.com/max/2248/1*LgHI5JvH5492uvHr4oIWbg.png)

Now, if we initialize a `Message` with an `Author`, then print it, we will see the following:

![](https://cdn-images-1.medium.com/max/2820/1*fLwdEKRDBCwqS1HUTA4PJA.png)

Great! We have successfully automated debugging Swift objects.

---

Sometimes you may want to provide a custom extension for each specific type. For example, your goal may be to print `Codable` objects in one way and others differently. By using a generic constraint (`where Self: Codable`) it is easier than ever:

![](https://cdn-images-1.medium.com/max/2880/1*g1m9bmS3SGSiblSs4aknjA.png)

Now this extension will work only for `Codable` objects.

## Resources

The source code of the extension is available in a [Gist](https://gist.github.com/zafarivaev/e2d8ccf89e5cf8f72c68d1858f527e12).

## Wrapping Up

Want to learn more about cool Swift tricks? Check out my other stories below:

* [5 Useful Swift Extensions to Use in Your iOS App](https://medium.com/better-programming/5-useful-swift-extensions-to-use-in-your-ios-app-f54a817ea9a9)
* [What is the ExpressibleByIntegerLiteral Protocol in Swift?](https://medium.com/cleansoftware/what-is-the-expressiblebyintegerliteral-protocol-in-swift-e71ad4a37a96)
* [Create a UILabel With Dynamic Font Size in Swift 5](https://levelup.gitconnected.com/create-a-uilabel-with-dynamic-font-size-in-swift-5-f49ccc26dc5f)
* [2 Ways to Make Protocol Methods Optional in Swift](https://medium.com/better-programming/2-ways-to-make-protocol-methods-optional-in-swift-f032836a343b)
* [How to Screenshot Your iOS App’s UI in Swift](https://medium.com/better-programming/how-to-screenshot-your-ios-apps-ui-in-swift-5c054a9226a5)

Thanks for reading!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
