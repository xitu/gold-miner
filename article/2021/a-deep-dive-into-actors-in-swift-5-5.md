> * 原文地址：[A Deep Dive Into Actors in Swift 5.5](https://betterprogramming.pub/a-deep-dive-into-actors-in-swift-5-5-8cc2fa004ded)
> * 原文作者：[Neel Bakshi](https://medium.com/@neelbakshi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/a-deep-dive-into-actors-in-swift-5-5.md](https://github.com/xitu/gold-miner/blob/master/article/2021/a-deep-dive-into-actors-in-swift-5-5.md)
> * 译者：
> * 校对者：

# A Deep Dive Into Actors in Swift 5.5

![Photo by [Ruud de Peijper](https://unsplash.com/@ruud_exploor?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral).](https://cdn-images-1.medium.com/max/10874/0*zTElctuiBFRNh0Uy)

With the new concurrency-related changes that are coming up with Swift 5.5, the language is making it even easier for us Swift devs to write concurrent code. There is a massive set of proposals that have been accepted into the 5.5 release, and there’s already a ton of new stuff being put out for us to learn and get accustomed to.

One of the new features that is going to come up in the new Swift release is the availability of a new primitive called the `actor`. So before we start using actors, let’s try to understand what they are and the changes that Swift is bringing forward to support this particular “Actor” model in the language.

The article is therefore going to be broken down into two major sections. In the first section, we will try to understand what actors are, what the underlying problem that they are trying to solve is, and how they solve it. Then we’ll get into how Swift exposes actors to us.

## Concurrency and the Actors Model

Concurrency and parallelism in programming are highly effective ways to make sure your program takes advantage of the advances in processor hardware and software to make sure your program runs at the best speed possible. Now with great power do come great responsibilities as well!

One of the biggest problems with concurrent systems is the problems of shared state. To be more specific, managing shared state often leads to two types of problems in a concurrent system:

1. Data races — When two or more threads try to access (with at least one access being a write) a single resource, thus causing data inconsistencies.
2. Race conditions — Due to the non-deterministic execution of a piece of code on a shared resource, the output turns out to be unpredictable in different scenarios. Basically, since the order of executions is not deterministic, it often leads to different outputs.

There is a [difference](https://blog.regehr.org/archives/490) between the two, but generally speaking, they occur because there is some kind of access to shared state. Also, it is generally much easier to detect data races but very hard to debug race conditions because the former can be reproduced, while the latter cannot reproduced every time.

Now there are different concurrency models out there that help us solve the data race problems (e.g. locks and mutexes, serialized access to shared data, etc.).

Swift tries to avoid this problem by encouraging us to use Value semantics (i.e. structs and enums) since they are generally easier to reason about in concurrent environments.

But even value semantics do not help in all cases (either because they do not make sense to be used in that context or due to incorrect implementation) and you eventually end up using some kind of synchronization mechanism like locks or serial queues. This is where this new Actor model comes in to help us.

The [Actor model](https://en.wikipedia.org/wiki/Actor_model) is a concurrency model where an `actor` is a new primitive structure that **holds and protects** local state by being the only one that can perform changes/mutations to it. Any outside member can just request the actor to act on its state and the actor will make sure that all of the accesses/change requests to its state are synchronized.

Actors have the following characteristics:

* Have their own isolated state.
* Can contain logic to change their own state.
* Can only communicate with other actors asynchronously (through their addresses).
* Can create other child actors (this point does not concern us a lot).

One of the best ELI5 explanations for the communication in the Actor model is as follows:

> “Imagine each actor is like an island and our code base is a world with islands. Now each island can talk to another island by sending it messages in a bottle. Each island knows where to send the message (i.e. the address of the other island) and that’s how communication between each island works.”

Although there’s a lot more to what the theory behind the Actor model states (I will attach different links at the bottom of the article), we’ll get into how this model actually translates to our world of Swift.

## Actors in Swift

Swift 5.5 introduces a new keyword called `actor`. Just like how you can define a `class` or a `struct`, now you can define an `actor`.

These actors can conform to protocols and function like any of the earlier primitives (except for inheritance, which is not currently supported). The only difference is that interactions between different actors happen asynchronously.

One of the most used examples while explaining concurrency is the example of depositing/withdrawing money from a bank account. So let’s go ahead and define a `BankAccount` actor:

```Swift
actor BankAccount {
  let id = UUID()
  private var balance: Double = 0.0
  
  func send(_ amount: Double, to destination: BankAccount) async throws {
      guard amount >= 0 else {
        throw Error.negativeAmountTransfer
      }
    
      if (amount > balance) {
        throw Error.insufficientFunds
      }
      else {
        self.balance -= amount
        await destination.deposit(amount) // if we try to do destination.balance += amount, the compiler will throw an error cause the `balance` variable can only be accessed via `self` reference
      }
  }
  
  func deposit(_ amount: Double) {
      guard amount >= 0 else {
        throw Error.negativeAmountTransfer
      }
      self.balance += amount
  }
}
```

In the example above, if `BankAccount` was defined as a `class` instead of an `actor`, the `balance` variable could be considered the unsafe “mutable state” of `BankAccount` that could end up in potential data race situations in a concurrent environment. But now that `BankAccount` has been defined as an `actor`, the `balance` variable is protected from data races. Let’s see how.

### Actor isolation

Now the data race protection above happens through a concept called **Actor isolation**. It’s just a term used to define a few rules as to how cross-actor members’ (both functions and properties) accesses should work. The rules are as follows:

1. An actor can read its own properties or call its functions on itself (i.e. using `self`) synchronously.
2. An actor can only update its own properties (and it may do so synchronously). This means that you can do property updates only using the `self` keyword. Trying to update another actor’s property will result in a compiler error.
3. Cross-actor property reads or function calls have to happen asynchronously using the `await` keyword. However, cross-actor reads for immutable properties can happen synchronously (the ones declared with `let`).

```Swift
// 1. You can do a a read/write access of your own properties both synchronously and asynchronously
extension BankAccount {
    func withdraw(amount: Double) async throws -> Double {
        guard amount <= self.balance else { // Sync read on `self.balance` ✅
            throw BankError.insufficientFunds
        }
        self.balance -= amount // Sync Update on `self.balance` ✅
        return amount
    }
}

// 2. You can do a read access of other actor properties asynchronously, again with the `await` keyword
func checkIfRich(_ acc: BankAccount) async -> Bool {
    return await acc.balance >= 1000 // ✅
}

// 3. You can only do write access via using the `self` keyword
func send(amount: Double, to acc: BankAccount) {
    await acc.balance += amount // ❌ , will throw a compiler error, saying actor properties can only be updated from within the actor
}

// 4. All cross actor function references need to happen asynchronously, therefore they need to be used with the `await` keyword
func send(money: Double, to acc: BankAccount) async {
    await acc.deposit(money) // ✅
}
```

### Actor re-entrancy

Function executions in actors are re-entrant. What I mean by re-entrancy is the fact that the runtime can re-enter the execution of a code at a suspension point and carry on your work from there. Let’s look at this with an example:

```Swift
actor BankAccount {
  // ....
  var isOpen = true
  
   func close() async throws -> Double {
        if isOpen {
            do {
                try await BankServer.requestToClose(self.id)
                if self.isOpen {
                    self.isOpen = false
                    return self.balance
                } else {
                    throw BankError.alreadyClosed
                }
            } catch {
                throw BankError.cannotClose
            }
        } else {
            throw BankError.alreadyClosed
        }
    }
}
```

Let’s say you were trying to close your bank account, and that requires you to communicate with your bank’s servers. The steps that we take are:

1. We check if the account `isOpen` or not. It doesn’t make sense to close an already closed account.
2. Communicate to the bank’s servers that the account is requesting to be closed (this step might take time).
3. Check if the account is still open. If the account is still open, close the account and return the balance. Otherwise, throw an error saying that while the network call was going on, another cancellation request was issued that probably already closed the account.

Re-entrancy in actors is defined by the fact that a function can be suspended midway for some time, while the thread that was performing the function performs some other tasks, and then resume the function from the suspension point.

For example, in this call to `close` the bank account, you can have your code “suspended” for some amount of time (while it’s communicating with the bank servers), have the same thread perform some other work, and then “resume” the work where it left off once you receive the response from the bank’s servers.

There’s a small yet important discussion to be had about line 8 where this “suspension” of work on the current thread takes place (i.e. the line on which an `await` call takes place).

Remember, every `await` call is a potential point of suspension in your code.

Until the bank servers respond, this thread can perform other pending work that our code has probably scheduled or some new work that our code requests. We may issue a call to `withdraw` money, `deposit` money, or another request for `cancellation`, and that’ll end up running on that thread.

Now once the bank server responds, the state of the actor may not be the same as before the suspension point. This is a very important point since you need to be cognizant of the fact that you cannot make assumptions about the state of your actor before and after the `await` function call.

This is the sole reason why I’ve re-checked whether the account is still open or not on line 9 (after the `await` call) because it is very possible that a second cancel call might have been issued and completed and the account has already been closed.

Therefore, you need to remember two things while you reason about actor re-entrancy:

* Always try to perform the mutation of state in synchronous code (avoid `async` function calls in functions where you’re changing internal state).
* If you have to perform `async` function calls within a function that changes state, do not make any assumptions about that state after the `await` completes.

## \@MainActor

Apple suggests calling all UI code on the main thread. So whenever we need to do heavy data processing or make a network call to fetch data to display our UI, we do so on background threads. Once this processing is done, we usually do the following:

```Swift
DispatchQueue.main.async {
    // Update your UI code
}
```

Swift 5.5 brings a new property wrapper in usage called the `@MainActor`. This annotation makes sure that any read and write access on properties annotated with this wrapper happens on the main thread (thus eliminating all the `DispatchQueue.main` calls).

You can annotate properties, functions, and class/struct definitions with this property wrapper.

UIKit classes (like `UILabel`, `UIView`, etc.) have already been marked with this property wrapper. Therefore, you can rest assured that they will always be accessed on the main thread.

The only catch here is that these members will only be accessed on the main thread while using the new `async/await` calls — not while using completion handlers. Here’s a piece of code that will help you understand it better:

```Swift
@MainActor class Person {
    var firstName: String
    var lastName: String
    
    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
    func tryToPrintNameOnMainThread() {
        print("Is Main Thread: \(Thread.isMainThread)")
        print("\(firstName) \(lastName)")
    }
}

let me = Person(firstName: "Neel", lastName: "Bakshi")
DispatchQueue.global().async {
    print("Currently on main thread: \(Thread.isMainThread)") // this will print Currently on main thread: false
    me.tryToPrintNameOnMainThread() // ❌ This will print Is Main Thread: false
}

asyncDetached {
    print("Currently on main thread: \(Thread.isMainThread)") // this will also print Currently on main thread: false
    await me.tryToPrintNameOnMainThread() // ✅ This will print Is Main Thread: true because this is being accessed via the await syntax
}
```

If you run this code snippet and put a breakpoint on line 11/12, you’ll see that the call from `DispatchQueue.global` will not be executed on the main thread, but the call from `asyncDetached` will be executed on the main thread.

## Conclusion

As you’ve seen, `actors` are definitely a much-needed addition to a modern language like Swift. I’m sure the entire system will keep evolving, and there might be a lot of upgrades to concurrency in Swift. With that said, the major points you need to take away from this article are the following:

* Actors are another method you can use to solve the data race problem that occurs in concurrent systems.
* Actors use the concept of actor isolation to help prevent data races.
* Even though actors help you with data races, there are still points of contention where race conditions might occur. Therefore, you should make sure you do not make any assumptions about the actor state whenever you introduce suspension points.
* Usage of `@MainActor` can help you access properties on the main thread without the `DispatchQueue.main` calls, but only using the new `async/await` call system.

### Links

* [SE-0303 Proposal](https://github.com/apple/swift-evolution/blob/main/proposals/0306-actors.md)
* [WWDC Talk on Actors](https://developer.apple.com/videos/play/wwdc2021/10133/)
* [WWDC Talk on the implementations of Actors](https://developer.apple.com/videos/play/wwdc2021/10254/)
* [Doug Gregor’s talk on Swift Concurrency — Swift By Sundell](https://www.swiftbysundell.com/podcast/99/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
