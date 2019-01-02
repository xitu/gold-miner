> * 原文地址：[Protocol Oriented Programming is Not a Silver Bullet](http://chris.eidhof.nl/post/protocol-oriented-programming/)
* 原文作者：[@chriseidhof](http://www.twitter.com/chriseidhof/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[Mark](https://github.com/marcmoore)，[Danny Lau](https://github.com/Danny1451)

#面向协议编程，灵丹妙药或是饮鸩止渴？

在 Swift 中，面向协议编程正值流行。许多 Swift  框架都自称是面向协议编程的，一些开源库甚至将其标榜为特点。而我认为，很多时候眼下的问题本可以用一种更简单的方法解决，但是在 Swift 中我们过度使用各种协议了。简言之：不要教条地使用（或避免）协议。

WWDC 2015（苹果电脑全球研发者大会，译者注）中最有影响力的一个分会场就是 [Swift 中的面向协议编程](https://developer.apple.com/videos/play/wwdc2015/408/)。会议表明（当然还有其他内容）你能够用一个面向协议的解决方案替换掉类的层次结构。面向协议的解决方案即一个协议定义和适用于该协议的类型，而类的层次结构即父类和子类的结构。面向协议的解决办法更简单灵活，比如，一个类只能有一个父类，但是一个类型却能适应多种协议。

我们来看看他们在 WWDC 会议上解决的那个问题。一系列的绘图命令都需要被渲染成图像，也要被记录到控制台。通过将绘图命令嵌入协议，任何描述图像的代码都可以用协议的方法来表达。协议扩展使得你能在基础功能上定义新的功能，每一个符合协议的类型都能够自由获取新的功能。

在上面的例子中，协议解决了在多个类型中间共享代码的难题。在 Swift 的标准库中，协议被大量用于集合，并解决了相同的问题。因为 `dropFirst` 是在 `Collection` 类型中定义的，所有的集合类型都能自由获取！同样的，太多集合相关的协议和类型，也会使得查找变得困难。这是协议的一个弊端，但在标准库这个例子中，还是优势更多一些。

现在，让我们从实践中得出真知。有一个网络服务的类，它通过 `URLSession` 从网络中加载实体（实际上，它并不真的加载内容，但是你会感觉是这样）：

```
    class Webservice {
        func loadUser() -> User? {
            let json = self.load(URL(string: "/users/current")!)
            return User(json: json)
        }

        func loadEpisode() -> Episode? {
            let json = self.load(URL(string: "/episodes/latest")!)
            return Episode(json: json)
        }

        private func load(_ url: URL) -> [AnyHashable:Any] {
            URLSession.shared.dataTask(with: url)

            // 略

            return [:] // 来自服务器的内容
        }
    }
```

以上的代码简短有效，直到我们想要测试 `loadUser` 和 `loadEpisode` 的时候，出现了问题。现在我们或者去掉  `load`，或者用依赖注入的方式传入一个模拟的 `URLSession`。我们也可以定义一个 `URLSession` 适用的协议，然后传入一个测试实例。但就此而言，有更简单的解决方法：我们能将变化的部分从 `Webservice` 中抽离出来，并且写入一个结构类型（我们在 [Swift Talk Episode 1](https://talk.objc.io/episodes/S01E01-networking) 和 [Advanced Swift](https://www.objc.io/books/advanced-swift/) 中对此有详细阐述）：

```
    struct Resource {
        let url: URL
        let parse: ([AnyHashable:Any]) -> A
    }

    class Webservice {
        let user = Resource(url: URL(string: "/users/current")!, parse: User.init)
        let episode = Resource(url: URL(string: "/episodes/latest")!, parse: Episode.init)

        private func load(resource: Resource) -> A {
            URLSession.shared.dataTask(with: resource.url)

            // 异步加载，解析 JSON 等等，仅作为实例，我们直接返回一个空的结果

            let json: [AnyHashable:Any] = [:] // 来自服务器的内容
            return resource.parse(json)
        }
    }
```

现在，我们能够测试 `user` 和 `episode` 而免于虚拟任何内容：他们是简单的结构类型的值。我们还是要测试 `load`，但是只有一个方法（而不是与资源一一对应）。现在，我们来添加一些协议。

为了不用 `parse` 函数，我们可以创建一个使用 JSON 初始化类型的协议。

```
    protocol FromJSON {
        init(json: [AnyHashable:Any])
    }

    struct Resource {
        let url: URL
    }

    class Webservice {
        let user = Resource(url: URL(string: "/users/current")!)
        let episode = Resource(url: URL(string: "/episodes/latest")!)

        private func load(resource: Resource) -> A {
            URLSession.shared.dataTask(with: resource.url)

            // 异步加载，解析 JSON 等等，仅作为实例，我们直接返回一个空的结果

            let json: [AnyHashable:Any] = [:] // should come from the server
            return A(json: json)
        }
    }
```

上面的代码或许看起来简单多了，但是没那么灵活了。比如，你要如何定义一个包含 `User` 值数组的资源呢？（在上文面向协议的例子中，这还无法实现，我们需要等到 Swift 4 或者 5 直到它才可能实现）协议让事情变得简单了，但是我认为它并不会为此付出代价，因为它极大地减少了我们创建 `Resource` 的方式。

虽然我们无法获取 `user` 和 `episode` 的 `Resource` 的类型值，但是我们能将 `Resource` 创建成拥有 `UserResource` 和 `EpisodeResource` 结构类型的协议。这可能会很流行，因为在面向协议编程中得到一个类型比得到一个值“感觉棒多了”：

```
    protocol Resource {
        associatedtype Result
        var url: URL { get }
        func parse(json: [AnyHashable:Any]) -> Result
    }

    struct UserResource: Resource {
        let url = URL(string: "/users/current")!
        func parse(json: [AnyHashable : Any]) -> User {
            return User(json: json)
        }
    }

    struct EpisodeResource: Resource {
        let url = URL(string: "/episodes/latest")!
        func parse(json: [AnyHashable : Any]) -> Episode {
            return Episode(json: json)
        }
    }

    class Webservice {
        private func load(resource: R) -> R.Result {
            URLSession.shared.dataTask(with: resource.url)

            // 异步加载，解析 JSON 等等，仅作为实例，我们直接返回一个空的结果

            let json: [AnyHashable:Any] = [:]
            return resource.parse(json: json)
        }
    }
```

但是我们批判性地来看，我们真正得到了什么？代码变得冗长、复杂、间接，而且由于关联类型我们很可能最终要定义一个 `AnyResource`。那么得到一个 `EpisodeResource` 结构比得到一个 `episodeResource` 值有什么益处么？他们都是全局定义，结构类型中命名是以大写字母开头，而值类型的命名是以小写字母开头，除了这，两者无异，而且你可以给它们都定义命名空间 （为了支持自动完成）。因此，得到一个值显然更简单、代码也更短。

网上还有许多的例子，比如我曾看到一个这样的协议：

```
    protocol URLStringConvertible {
        var urlString: String { get }
    }

    // 其中一段代码

    func sendRequest(urlString: URLStringConvertible, method: ...) {
        let string = urlString.urlString
    }
```

这有什么用吗？为什么不移除协议然后直接传入 `urlString` 呢？这明显简单多了。

又或者只有一个方法的协议：

```
    protocol RequestAdapter {
        func adapt(_ urlRequest: URLRequest) throws -> URLRequest
    }
```

这个观点略有争议：为什么不移除协议，然后再其他地方传入一个函数呢？这明显简单多了！（除非你的协议仅支持类，并且你想得到一个弱引用）。

我可以继续举例论证，但是我希望这个观点已经很明确了，在面向协议编程中，我们通常会有更简单的选择。抽象一点，协议仅仅是实现多态的代码的一种方式，其他很多方式也都可以实现：继承、泛型、值、函数等等。值（比如用 `String` 替代 `URLStringConvertible`）是最简单的方法；函数（比如用 `adapt` 替代 `RequestAdapter`）比值的方式复杂一点，但是仍然很简单；泛型（无约束）也比协议简单。但完整地说，协议通常比类的继承结构要简单。

给你一点启发性的建议，你应该仔细考虑你的协议是塑造数据模型还是行为模型。对数据来说，结构类型可能更简单一点。对复杂的行为来说（比如有多个方法的委托），协议通常会更简单。（标准库中的集合协议有点特殊：它们并不真的描述数据，而是在描述数据处理）

也就是说，尽管协议非常有用，但是不要为了面向协议而使用协议。首先检视你的问题，并且尽可能地尝试用最简单的方法解决。通过问题顺藤摸瓜找到解决办法，不要背道而驰。面向协议编程并没有好坏之分，跟其他的技术（函数编程、面向对象、依赖注入、类的继承）一样，它能解决一些问题，但我们不应盲目，要择其善者而从之。有时候使用协议，但通常还有更简单的方法。

### 更多内容

*   [http://www.thedotpost.com/2016/01/rob-napier-beyond-crusty-real-world-protocols](http://www.thedotpost.com/2016/01/rob-napier-beyond-crusty-real-world-protocols) (视频)
*   [http://www.gamedev.net/page/resources/_/technical/game-programming/haskell-game-object-design-or-how-functions-can-get-you-apples-r3204](http://www.gamedev.net/page/resources/_/technical/game-programming/haskell-game-object-design-or-how-functions-can-get-you-apples-r3204) (Haskell)