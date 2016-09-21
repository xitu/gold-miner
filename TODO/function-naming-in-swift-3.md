> * 原文地址：[Function Naming In Swift 3](http://inaka.net/blog/2016/09/16/function-naming-in-swift-3/)
* 原文作者：[Pablo Villar](https://twitter.com/volbap)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

Yesterday, I started to migrate [Jayme](http://inaka.net/blog/2016/05/09/meet-jayme/) to Swift 3\. It was my very first experience migrating Swift 2.2 code to Swift 3\. While it's been cumbersome, I have to admit it couldn't have turned out another way: Swift 3 is **very different** from older versions; most of the changes are **abrupt**, and take time to think of. The good part is that it's for our own sake: The more Swift 3 code I write, the happier I feel. 😃

There have been many, many decisions I had to take regarding changes in code. What's more, it's not just about translating the code, but also dividing the whole migration process into steps, and take it little by little, patiently. Changes in code is just **one** of those steps.

If you have already decided to start migrating your codebases, I recommend [this article](http://www.jessesquires.com/migrating-to-swift-3/) as a good kickstart.

Hopefully, in a near future, I'll write a blogpost about my experience, covering the whole process and wrapping up most of those decisions I've been facing. But for now, I will just focus on one of those, which I consider being the most important one so far: **How to write function signatures properly**.

## The Basics

Let's start by understanding that **function naming in Swift 3 behaves differently** than in Swift 2.

In Swift 2, the label for the **first** parameter of a function is implicitly omitted when you call the function, in order to follow the [good ol' Objective-C conventions](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/CodingGuidelines/Articles/NamingMethods.html) that we've been carrying since then:



    // Swift 2 
    func handleError(error: NSError) { }
    let error = NSError()
    handleError(error) // Looks like Objective-C



In Swift 3, instead, the first parameter label _can_ be omitted in a function call, but by default, it is **not**:



    // Swift 3
    func handleError(error: NSError) { }
    let error = NSError()
    handleError(error)  // Does not compile!
    // ⛔ Missing argument label 'error:' in call



So, the first fix would be:



    // Swift 3
    func handleError(error: NSError) { }
    let error = NSError()
    handleError(error: error)    
    // Had to write 'error' three times in a row!
    // My eyes already hurt 🙈



At this point, you can realize how tiresome and repetitive your code could become...

That said, you'll want to omit the first parameter label in the function call. But remember, in Swift 3, you have to be **explicit** about it:



    // Swift 3
    func handleError(_ error: NSError) { }
    // 🖐 Notice the underscore!
    let error = NSError()
    handleError(error)  // Same as in Swift 2



> This is the typical change that would occur to your functions when you run the Xcode migrator.

Notice the underscore in the function signature: It points out that the first parameter will **not** require a label when you call the function. This way, we can keep the function calling like in Swift 2.

Furthermore, you can realize that Swift 3 is more consistent and easier to understand when it comes to functions naming: **All parameter labels are treated the same**; there is no such thing as treating the first one differently.

This code will compile, but you still need to go a step further in order to stick to the [Swift 3 API design guidelines](https://swift.org/documentation/api-design-guidelines/).

> ☝️ A piece of advice: Read the [Swift 3 API design guidelines](https://swift.org/documentation/api-design-guidelines/) once and again. Every day in the morning, if necessary, until you get used to the new way of writing Swift code.

## One Step Further: Da Pruning

![Pruning](http://inaka.net/assets/img/jet-pruning.gif)

Observe how repetitive this line of code is:

    handleError(error)

In order to make it less repetitive and more concise, you can [**prune**](https://github.com/apple/swift-evolution/blob/master/proposals/0005-objective-c-name-translation.md#prune-redundant-type-names) the redundant type name from the function signature:



    // Swift 3
    func handle(_ error: NSError) { /* ... */ }
    let error = NSError()
    handle(error)   // Type name has been pruned
    // from function name, since it was redundant



This is shorter, clearer, more concise, and encourages developers to follow the [Swift 3 API design guidelines](https://swift.org/documentation/api-design-guidelines/) (yes, [**read them again**](https://swift.org/documentation/api-design-guidelines/), and [**again**](https://swift.org/documentation/api-design-guidelines/)!)

Notice that the function call is clear. We can know what the function parameter is expected to be because of two facts:

*   **We know its type**.
*   And also, **that type denotes exactly what the parameter is expected to represent** (an _error_, in this case, there is no doubt about it).

## It's Not Always A Matter Of Pruning

Now, it's time to **be careful**! ⚠️

There are lots of scenarios where the latter fact I mentioned above doesn't actually happen. In other words, the parameter's type **does not reflect** what the parameter itself is supposed to represent.

Consider the following example:



    // Swift 2
    func requestForPath(path: String) -> URLRequest {  }
    let request = requestForPath("local:80/users")



If you try to migrate that code to Swift 3, by following what we've learned so far, you will end up with something like this:



    // Swift 3
    func request(_ path: String) -> URLRequest {  }
    let request = request("local:80/users")



This is confusing and not really readable. Let's enhance it just a bit:



    // Swift 3
    func request(for path: String) -> URLRequest {  }
    let request = request(for: "local:80/users")



Now, while this is more readable, it doesn't solve the problem I mentioned above.

At the moment of calling this function, how can you know that what you need to pass in is a _path_? All you can know beforehand, because of Swift's static typing, is that the parameter is expected to be of `String` type, but there's no clue that you need to pass in a _path_ there.

There are plenty of these scenarios where the parameter type isn't meaningful to what it should represent, for instance:

*   A `String` not always represents a _path_.
*   An `Int` not always represents a _status code_.
*   A `[String: String]` not always represents an _HTTP header_.
*   And so on...

> ⚠️ My advice up to here: **Always take your pruning shears with caution!** ✄

Back to the code, a first approach to solve this issue could be appending the name of the parameter to the argument label, making it explicit in consequence:



    func request(forPath path: String) -> URLRequest {  }
    let request = request(forPath: "local:80/users")



This code is **clear**, **compiles** and does **follow the guidelines**. 🎉 Hooray!

![Hooray](http://inaka.net/assets/img/rick-hooray-confeti.gif)

> You can stop reading here, but hang on, the best part is yet to come...

Now, notice this wording in the _function declaration_:



    func request(forPath path: String) -> URLRequest {  }
    // The word 'path' appears twice



Even though this ain't evil, and in most scenarios this is still correct and will work out well, there's a way to avoid it.

More about this in the following section….

## The Trick You (Probably) Didn't Know

The idea is simple: Make the parameter type reflects its content, in order to be able to **prune with no mercy**.

![Prune with no mercy](http://inaka.net/assets/img/prune-with-no-mercy.gif)

What if I told you…?



    typealias Path = String      // To the rescue!

    func request(for path: Path) -> URLRequest {  }
    let request = request(for: "local:80/users")



In this case, your parameter's **type** and its **expected content** are coherent and in harmony, because the parameter's type was made **explicit** through defining `Path` as a type alias for `String`.

This way, your function is still intuitive, readable, unambiguous, yet non-repetitive.

Likewise, you can think of some other examples of type aliases that might help in other common scenarios:



    typealias Path = String
    typealias StatusCode = Int
    typealias HTTPHeader = [String: String]
    // etc...



These will allow you to write clearer code, as we just saw.

Nonetheless, extremes are not good: Type aliases add an extra layer of complexity to your code, even more if they are nested… So, don't abuse.🖐 While in some cases they can help you out very well, as we just see, sometimes they are actually unnecessary and will just make your code harder to follow. Always be disciplined.

## Conclusion

There are many scenarios you will stumble upon when naming functions in Swift 3.

Code snippets are worth _a billion_ words:



    func remove(at position: Index) -> Element {  }
    employees.remove(at: x)

    func remove(_ member: Element) -> Element?  {  }
    allViews.remove(cancelButton)

    func url(forPath path: String) -> URL {  }
    let url = url(forPath: "local:80/users")

    typealias Path = String // Alternative
    func url(for path: Path) -> URL {  }
    let url = url(for: "local:80/users")

    func entity(from dictionary: [String: Any]) -> Entity { /* ... */ }
    let entity = entity(from: ["id": "1", "name": "John"])

