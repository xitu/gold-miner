> * 原文地址：[Refactoring singleton usage in Swift](http://www.jessesquires.com/refactoring-singletons-in-swift/)
* 原文作者：[Jesse Squires](http://www.jessesquires.com/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# [Refactoring singleton usage in Swift](Refactoring singleton usage in Swift) #

## Tips for a cleaner, modular, and testable codebase 10 Feb 2017 ##

In software development, [singletons](https://en.wikipedia.org/wiki/Singleton_pattern) are widely [discouraged](https://www.objc.io/issues/13-architecture/singletons/) and [frowned upon](http://coliveira.net/software/day-19-avoid-singletons/) — but with good reason. They are difficult or impossible to test, and they entangle your codebase when used implicitly in other classes, making code reuse difficult. Most of the time, a singleton amounts to nothing more than a disguise for global, mutable state. Everyone knows at least knows *that* is a terrible idea. However, singletons are occasionally an unavoidable and necessary evil. How can we incorporate them into our code in a clean, modular, and testable way?

### Singletons everywhere ###

On Apple platforms, singletons are everywhere in the Cocoa and Cocoa Touch frameworks. There’s `UIApplication.shared`, `FileManager.default`, `NotificationCenter.default`, `UserDefaults.standard`, `URLSession.shared`, and others. The design pattern even has its own section in the [*Cocoa Core Competencies*](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/Singleton.html#//apple_ref/doc/uid/TP40008195-CH49-SW1) guide.

When you implicitly reference these — and your own — singletons, it increases the amount of effort it takes to change your code. It also makes it difficult or impossible to test your code, because there’s no way to change or mock those singletons from outside of the classes in which they are used. Here’s what you typically see in an iOS app:

```
class MyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let currentUser = CurrentUserManager.shared.user
        if currentUser != nil {
            // do something with current user
        }

        let mySetting = UserDefaults.standard.bool(forKey: "mySetting")
        if mySetting {
            // do something with setting
        }

        URLSession.shared.dataTask(with: URL(string: "http://someResource")!) { (data, response, error) in
            // handle response
        }
    }
}
```

This is what I mean by *implicit references* — you simply use the singleton directly in your class. We can do better. There is a lightweight, easy, and low impact way to improve this in Swift. Swift makes it elegant, too.

### Dependency injection ###

In short, the answer is [dependency injection](https://en.wikipedia.org/wiki/Dependency_injection). This principle says that you should design your classes and functions such that all inputs are explicit. If you refactor the snippet above to use dependency injection, it would look like this:

```
class MyViewController: UIViewController {

    let userManager: CurrentUserManager
    let defaults: UserDefaults
    let urlSession: URLSession

    init(userManager: CurrentUserManager, defaults: UserDefaults, urlSession: URLSession) {
        self.userManager = userManager
        self.defaults = defaults
        self.urlSession = urlSession
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let currentUser = userManager.user
        if currentUser != nil {
            // do something with current user
        }

        let mySetting = defaults.bool(forKey: "mySetting")
        if mySetting {
            // do something with setting
        }

        urlSession.dataTask(with: URL(string: "http://someResource")!) { (data, response, error) in
            // handle response
        }
    }
}

```

This class no longer implicitly (or explicitly) depends on any singletons. It explicitly depends on a `CurrentUserManager`, `UserDefaults`, and `URLSession` — but nothing about these dependencies indicates that they are singletons. This detail no longer matters, but the functionality remains unchanged. The view controller merely knows that instances of these objects exist. At the call site you can pass in the singletons. Again, this detail is irrelevant from the class’s perspective.

```
let controller = MyViewController(userManager: .shared, defaults: .standard, urlSession: .shared)

present(controller, animated: true, completion: nil)
```

Pro tip: Swift type inference works here. Instead of writing `URLSession.shared`, you can simply write `.shared`.

If you ever need to provide a *different*`userDefaults` — for example, if you need to [share data with App Groups](https://developer.apple.com/library/content/documentation/General/Conceptual/ExtensibilityPG/ExtensionScenarios.html#//apple_ref/doc/uid/TP40014214-CH21-SW6) — then it’s easy to change. In fact, you *do not* have to change any code in this class. Instead of passing in `UserDefaults.standard`, you pass in `UserDefaults(suiteName: "com.myApp")`.

Furthermore, in unit tests you can now pass in fakes or mocks of these classes. Real mocking isn’t possible in Swift, but there are [workarounds](/testing-without-ocmock/). It depends on how you want to structure your code. You could use a protocol for `CurrentUserManager`, which you could then “mock” in a test. You could provide a fake suite for `UserDefaults` for testing. You could make `URLSession` optional and pass `nil` in your tests.

### Refactoring hell ###

You are sold on this idea and now you want to disentangle and liberate your debt-stricken codebase. While dependency injection is ideal and gives you a more pure object model, it is often a struggle to achieve. Even more, code is rarely designed to accommodate this when it is first written.

What we refactored above is now more modular and testable — but there is a real problem. The initializer for `MyViewController` used to be empty (`init()`), but now it takes three parameters. Every single call site has to change. The clean and proper way to structure this would be to pass instances from the top down, or from the previous view controller to this one. This would require passing data from the root of your object graph to all the children. In iOS in particular, this can cause quite the headache as you pass data from view controller to view controller. Legacy codebases in particular will struggle to implement such a large change immediately.

The initializer for most classes (and especially view controllers) will need to change. Such a change becomes insurmountable as you realize that you literally have to refactor the entire app. Either everything will be broken, or only some classes will be updated for dependency injection while others will continue to reference singletons implicitly. This inconsistency could cause problems in the future.

Thus, a refactoring like this simply may not be feasible in a complex, large, legacy codebase — at least not at once, and not without regressions. Because of this, you could argue that you simply should not refactor and live with the debt. Then a few months or years down the road, you have to support multiple users — and now that `CurrentUserManager` is not going to work when you implement switching accounts. How do you cope with this?

There is a way forward, and a way to design your classes from the beginning to accommodate these kinds of changes for next time.

### Default parameter values ###

One of my favorite features of Swift is default parameter values. They are incredibly valuable and bring tons of flexibility to your code. With default parameters, you can address the issues mentioned above **without** going down the dependency injection rabbit hole and **without** introducing too much complexity in your codebase. Maybe your app really will only have a single user, so implementing all of this dependency injection nonsense is unnecessary overhead.

You can use the singletons as default parameters:

```
class MyViewController: UIViewController {

    init(userManager: CurrentUserManager = .shared, defaults: UserDefaults = .standard, urlSession: URLSession = .shared) {
        self.userManager = userManager
        self.defaults = defaults
        self.urlSession = urlSession
        super.init(nibName: nil, bundle: nil)
    }
}
```

Now, the initializer has not changed from the perspective of the call site. But there is a world of difference in the class itself, which is now using dependency injection and no longer referencing singletons.

```
let controller = MyViewController()

present(controller, animated: true, completion: nil)
```

What have you gained with this change? You can refactor every class to use this pattern without updating any call sites. Nothing has changed semantically, nor functionally. Yet, your classes are using dependency injection. They are merely using instances internally. You can test them as described above and maintain a flexible, modular API — all while the public interface remains unchanged. Essentially, you can continue working in your codebase as if nothing ever changed.

If and when the time comes to pass in custom, non-singleton parameters you can do that without changing any class. You only need to update the call sites. Furthermore, if you decide to implement full-fledged dependency injection and pass in every single dependency from the top downward, then you simply remove the default parameters and pass in the dependencies from above.

If needed, you can even opt-in or opt-out of any of the default values. In the following example, we provide custom `UserDefaults` but keep the default parameters for `CurrentUserManager` and `URLSession`.

```
let appGroupDefaults = UserDefaults(suiteName: "com.myApp")!

let controller = MyViewController(defaults: appGroupDefaults)

present(controller, animated: true, completion: nil)
```

### Conclusion ###

Swift makes this kind of “partial” dependency injection so effortless. By adding a new property and an initializer parameter with a default value to your class, you can make your code immensely more modular and testable — without having to refactor the world, nor completely buy in to full-fledged dependency injection. If you design your classes like this *from the beginning* then you will find yourself coded into a corner much less frequently — and when you *are* backed into a corner, it will be easier to escape.

You can apply these concepts and designs to all areas of your code beyond the simple examples here — classes, structs, enums, functions. Every function in Swift can take default parameter values. By taking the time to think ahead about what might change in the future, we can create types and functions that can effortlessly adapt to change.

Building and designing good software means writing code that is **easy to change, but difficult to break**. That’s the motivation behind dependency injection, and Swift’s default parameters can help you achieve this quickly, easily, and elegantly.
