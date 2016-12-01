> * 原文地址：[Protocol Oriented Programming is Not a Silver Bullet](http://chris.eidhof.nl/post/protocol-oriented-programming/)
* 原文作者：[@chriseidhof](http://www.twitter.com/chriseidhof/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Protocol Oriented Programming is Not a Silver Bullet


In Swift, protocol-oriented programming is in fashion. There’s a lot of Swift code out there that’s “protocol-oriented”, some open-source libraries even state it as a feature. I think protocols are heavily overused in Swift, and oftentimes the problem at hand can be solved in a much simpler way. In short: don’t be dogmatic about using (or avoiding) protocols.

One of the most influential sessions at WWDC 2015 was called [Protocol-Oriented Programming in Swift](https://developer.apple.com/videos/play/wwdc2015/408/). It shows (among other things) that you can replace a class hierarchy (that is, a superclass and some subclasses) with a protocol-oriented solution (that is, a protocol and some types that conform to the protocol). The protocol-oriented solution is simpler, and more flexible. For example, a class can only have a single superclass, yet a type can conform to many protocols.

Let’s look at the problem they solved in the WWDC talk. A series of drawing commands needed to be rendered as a graphic, as well as logged to the console. By putting the drawing commands in a protocol, any code that describes a drawing could be phrased in terms of the protocol’s methods. Protocol extensions allow you to define new drawing functionality in terms of the protocol’s base functionality, and every type that conforms gets the new functionality for free.

In the example above, protocols solve the problem of sharing code between multiple types. In Swift’s Standard Library, protocols are heavily used for collections, and they solve exactly the same problem. Because `dropFirst` is defined on the `Collection` type, all the collection types get this for free! At the same time, there are so many collection-related protocols and types, that it can be hard to find things. That’s one drawback of protocols, yet the advantages easily outweigh the disadvantages in the case of the Standard Library.

Now, let’s work our way through an example. Here, we have a Webservice class. It loads entities from the network using `URLSession`. (It doesn’t actually load things, but you get the idea):

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
            // etc.
            return [:] // should come from the server
        }
    }

The code above is short and works fine. There is no problem, until we want to test `loadUser` and `loadEpisode`. Now we either have to stub `load`, or pass in a mock `URLSession` using dependency injection. We could also define a protocol that `URLSession` conforms to and then pass in a test instance. However, in this case, the solution is much simpler: we can pull the changing parts out of the `Webservice` and into a struct (we also cover this in [Swift Talk Episode 1](https://talk.objc.io/episodes/S01E01-networking) and in [Advanced Swift](https://www.objc.io/books/advanced-swift/)):

    struct Resource {
        let url: URL
        let parse: ([AnyHashable:Any]) -> A
    }

    class Webservice {
        let user = Resource(url: URL(string: "/users/current")!, parse: User.init)
        let episode = Resource(url: URL(string: "/episodes/latest")!, parse: Episode.init)

        private func load(resource: Resource) -> A {
            URLSession.shared.dataTask(with: resource.url)
            // load asynchronously, parse the JSON, etc. For the sake of the example, we directly return an empty result.
            let json: [AnyHashable:Any] = [:] // should come from the server
            return resource.parse(json)
        }
    }

Now, we can test `user` and `episode` without having to mock anything: they’re simple struct values. We still have to test `load`, but that’s only one method (instead of for each resource). Now let’s add some protocols.

Instead of the `parse` function, we could create a protocol for types that can be initialized from JSON.

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
            // load asynchronously, parse the JSON, etc. For the sake of the example, we directly return an empty result.
            let json: [AnyHashable:Any] = [:] // should come from the server
            return A(json: json)
        }
    }

The code above might look simpler, but it’s also way less flexible. For example, how would you define a resource that has an array of `User` values? (In the protocol-oriented example above, that’s not yet possible, and we’ll have to wait for Swift 4 or 5 until this is expressible). The protocol makes things simpler, but I think it doesn’t pay for itself, because it dramatically decreases the ways in which we can create a `Resource`.

Instead of having the `user` and `episode` as `Resource` values, we could also make `Resource` a protocol and have `UserResource` and `EpisodeResource` structs. This seems to be a popular thing to do, because having a type instead of a value “just feels right”:

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
            // load asynchronously, parse the JSON, etc. For the sake of the example, we directly return an empty result.
            let json: [AnyHashable:Any] = [:]
            return resource.parse(json: json)
        }
    }

But if we look at it critically, what did we really gain? The code became longer, more complex and less direct. And because of the associated type, we’ll probably end up defining an `AnyResource` eventually. Is there any benefit to having an `EpisodeResource` struct instead of an `episodeResource` value? They are both global definitions. For the struct, the name starts with an uppercase letter, and for the value, a lowercase letter. Other than that, there really isn’t any advantage. You can both namespace them (for autocompletion). So in this case, having a value is definitely simpler and shorter.

There are many other examples I’ve seen in code around the internet. For example, I’ve seen a protocol like this:

    protocol URLStringConvertible {
        var urlString: String { get }
    }

    // Somewhere later

    func sendRequest(urlString: URLStringConvertible, method: ...) {
        let string = urlString.urlString
    }

What does this buy you? Why not simply remove the protocol and pass in the `urlString` directly? Much simpler. Or a protocol with a single method:

    protocol RequestAdapter {
        func adapt(_ urlRequest: URLRequest) throws -> URLRequest
    }

A bit more controversial: why not simply remove the protocol, and pass in a function somewhere? Much simpler. (Unless your protocol is a class-only protocol and you want a weak reference it).

I can keep showing examples, but I hope the point is clear. Often, there are simpler choices. More abstractly, protocols are just one way to achieve polymorphic code. There are many other ways: subclassing, generics, values, functions, and so on. Values (e.g. a `String` instead of a `URLStringConvertible`) are the simplest way. Functions (e.g. `adapt` instead of `RequestAdapter`) are a bit more complex than values, but are still simple. Generics (without any constraints) are simpler than protocols. And to be complete, protocols are often simpler than class hierarchies.

A useful heuristic might be to think about whether your protocol models data or behavior. For data, a struct is probably easier. For complex behavior (e.g. a delegate with multiple methods), a protocol is often easier. (The standard library’s collection protocols are a bit special: they don’t really describe data, but rather, they describe data manipulation.)

That said, protocols can be very useful. But don’t start with a protocol just for the sake of protocol-oriented programming. Start by looking at your problem, and try to solve it in the simplest way possible. Let the problem drive the solution, not the other way around. Protocol-oriented programming isn’t inherently good or bad. Just like any other technique (functional programming, OO, dependency injection, subclassing) it can be used to solve a problem, and we should try to pick the right tool for the job. Sometimes that’s a protocol, but often, there’s a simpler way.

### More

*   [http://www.thedotpost.com/2016/01/rob-napier-beyond-crusty-real-world-protocols](http://www.thedotpost.com/2016/01/rob-napier-beyond-crusty-real-world-protocols) (video)
*   [http://www.gamedev.net/page/resources/_/technical/game-programming/haskell-game-object-design-or-how-functions-can-get-you-apples-r3204](http://www.gamedev.net/page/resources/_/technical/game-programming/haskell-game-object-design-or-how-functions-can-get-you-apples-r3204) (Haskell)

