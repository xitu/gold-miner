
> * 原文地址：[Struct References](http://chris.eidhof.nl/post/references/)
> * 原文作者：[Chris Eidhof](https://twitter.com/chriseidhof/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/swift-struct-references.md](https://github.com/xitu/gold-miner/blob/master/TODO/swift-struct-references.md)
> * 译者：
> * 校对者：

# Struct References

> The full code for this is available as a [gist](https://gist.github.com/chriseidhof/3423e722d1da4e8cce7cfdf85f026ef7).

Recently I was trying to find a good use for Swift’s new keypaths. This post shows one example that accidentally came up. This is something I’ve researched, and not something I’ve used in production code. That said, I think it’s very cool and I’d like to show it.

Consider a simple address book application. It contains a table view with people, and a detail view controller which shows a `Person` instance. If `Person` were defined as a class, it’d look like this:

    class Person {
        var name: String
        var addresses: [Address]
        init(name: String, addresses: [Address]) {
            self.name = name
            self.addresses = addresses
        }
    }

    class Address {
        var street: String
        init(street: String) {
            self.street = street
        }
    }


The definition for our (fake) view controller has a single person property, which gets passed in through the initializer. It also has a `change` method which changes a property of the person.

    final class PersonVC {
        var person: Person
        init(person: Person) {
            self.person = person
        }

        func change() {
            person.name = "New Name"
        }
    }


Let’s consider the problems with `Person` being an object:

- Because `person` is a reference, a different part of the code might change it. This is very useful as it allows communication. At the same time, we need to make sure that we stay notified of those changes (for example, through KVO) otherwise we might be displaying data that’s out of sync. Making sure we stay notified is not straightforward.
- Getting notified when `addresses` change is even harder. Observing nested properties that are objects is difficult.
- If we need an independent local copy of `Person`, we’d need to implement something like `NSCopying`. This is quite a bit of work. Even when we have that, we still have to think: do we want a deep copy (e.g. should the addresses also be copied) or a shallow copy (the `addresses` array is independent, but the addresses inside still point to the same objects)?
- If we think of `Person` as being in an array inside `AddressBook`, we might want to know when the address book changes (for example, to serialize it). Knowing when something inside your object graph changes either requires a lot of boilerplate, or a lot of observing.

If `Person` and `Address` were structs, we’d have different issues:

- Each struct is an independent copy. This is useful, because we know it’s always consistent and can’t change underneath us. However, after we change a `Person` in the detail view controller, we’d need a way to communicate those changes back to the table view (or to the address book). With objects, this happens /automatically (by changing the `Person` in place).
- We can observe the root address book struct, and know of any changes that happen within. Still, we can’t easily observe parts of it (e.g. observe the first person’s name).

The solution that I present combines the best of both worlds:

- We have mutable shared references
- The underlying data is structs, so we can always get our own independent copy
- We can observe any part: either at the root level, or observe individual properties (e.g. the first person’s name)

I’ll first show how to use it, then how it works and finally discuss some of the limitations and gotchas.

Let’s create an address book using structs:

    struct Address {
        var street: String
    }
    struct Person {
        var name: String
        var addresses: [Address]
    }

    typealias Addressbook = [Person]


Now we can use our `Ref` type (short for `Reference`). We create a new `addressBook` reference with an initial empty array. Then we append a `Person`. Now for the cool part: by using subscripts, we can get a *reference* to the first person, and then a *reference* to their name. We can change the value of the reference to `"New Name"` and verify that we’ve changed the original address book:

    let addressBook = Ref<Addressbook>(initialValue: [])
    addressBook.value.append(Person(name: "Test", addresses: []))
    let firstPerson: Ref<Person> = addressBook[0]
    let nameOfFirstPerson: Ref<String> = firstPerson[\.name]
    nameOfFirstPerson.value = "New Name"
    addressBook.value // shows [Person(name: "New Name", addresses: [])]


The types for `firstPerson` and `nameOfFirstPerson` can be omitted, they’re just there for readability.

If at any point we want to get our own independent value of `Person`, we can do that. From there on, we can work with `myOwnCopy` and be sure it’s not changed from underneath us. No need to implement `NSCopying`:

    var myOwnCopy: Person = firstPerson.value


We can observe any `Ref`. Just like with reactive libraries, we get a disposable back which controls the lifetime of an observer:

    var disposable: Any?
    disposable = addressBook.addObserver { newValue in
        print(newValue) // Prints the entire address book
    }

    disposable = nil // stop observing


We can also observe `nameOfFirstPerson`. In the current implementation, this gets triggered anytime anything changes in the address book, but more about that later.

    nameOfFirstPerson.addObserver { newValue in
        print(newValue) // Prints a string
    }


Let’s go back to our `PersonVC`. We can change its implementation to use a `Ref`. The view controller can now subscribe to changes. In reactive programming, a signal is typically read-only (you only receive changes), and you need to figure another way to communicate back. In the `Ref` approach, we can write back using `person.value`:

    final class PersonVC {
        let person: Ref<Person>
        var disposeBag: Any?
        init(person: Ref<Person>) {
            self.person = person
            disposeBag = person.addObserver { newValue in
                print("update view for new person value: \(newValue)")
            }
        }

        func change() {
            person.value.name = "New Name"
        }
    }


The `PersonVC` doesn’t know where the `Ref<Person>` comes from: a person array, a database, or somewhere else. In fact, we can add undo support to our address book by wrapping our array inside a [`History` struct](http://chris.eidhof.nl/post/undo-history-in-swift/), and we don’t need to change the `PersonVC`:

    let source: Ref<History<Addressbook>> = Ref(initialValue: History(initialValue: []))
    let addressBook: Ref<Addressbook> = source[\.value]
    addressBook.value.append(Person(name: "Test", addresses: []))
    addressBook[0].value.name = "New Name"
    print(addressBook[0].value)
    source.value.undo()
    print(addressBook[0].value)
    source.value.redo()


There’s a lot of other things we could add to this: caching, [serialization](https://gist.github.com/chriseidhof/40fde6c2be5519d5bb341fc65b3029ad), automatic synchronization (e.g. only modify and observe on a private queue), but that’s future work.

### Implementation Details

Let’s look at how this thing is implemented. We’ll start by defining the `Ref` class. A `Ref` consists of a way to get and set a value, and a way to add an observer. It has an initializer that asks for just those three things:

    final class Ref<A> {
        typealias Observer = (A) -> ()

        private let _get: () -> A
        private let _set: (A) -> ()
        private let _addObserver: (@escaping Observer) -> Disposable

        var value: A {
            get {
                return _get()
            }
            set {
                _set(newValue)
            }
        }

        init(get: @escaping () -> A, set: @escaping (A) -> (), addObserver: @escaping (@escaping Observer) -> Disposable) {
            _get = get
            _set = set
            _addObserver = addObserver
        }

        func addObserver(observer: @escaping Observer) -> Disposable {
            return _addObserver(observer)
        }
    }


We can now add an initializer that observers a single struct value. It creates a dictionary of observers and a variable. Whenever the variable changes, all observers get notified. It uses the initializer defined above and passes on `get`, `set`, and `addObserver`:

    extension Ref {
        convenience init(initialValue: A) {
            var observers: [Int: Observer] = [:]
            var theValue = initialValue {
                didSet { observers.values.forEach { $0(theValue) } }
            }
            var freshId = (Int.min...).makeIterator()
            let get = { theValue }
            let set = { newValue in theValue = newValue }
            let addObserver = { (newObserver: @escaping Observer) -> Disposable in
                let id = freshId.next()!
                observers[id] = newObserver
                return Disposable {
                    observers[id] = nil
                }
            }
            self.init(get: get, set: set, addObserver: addObserver)
        }
    }


Let’s consider we have `Person` reference. In order to get a reference to its `name` property, we need a way to both read and write the name. A `WritableKeyPath` provides just that. We can thus add a `subscript` to `Ref` that creates a reference to part of the `Person`:

    extension Ref {
        subscript<B>(keyPath: WritableKeyPath<A,B>) -> Ref<B> {
            let parent = self
            return Ref<B>(get: { parent._get()[keyPath: keyPath] }, set: {
                var oldValue = parent.value
                oldValue[keyPath: keyPath] = $0
                parent._set(oldValue)
            }, addObserver: { observer in
                parent.addObserver { observer($0[keyPath: keyPath]) }
            })
        }
    }


The code above is a bit hard to read, but in order to use the library, you don’t really need to understand how it’s implemented.

One day, keypaths in Swift will also support subscripts, but until then, we’ll have to add another subscript for collections. The implementation is almost the same as above, except that we use indices rather than keypaths:

    extension Ref where A: MutableCollection {
        subscript(index: A.Index) -> Ref<A.Element> {
            return Ref<A.Element>(get: { self._get()[index] }, set: { newValue in
                var old = self.value
                old[index] = newValue
                self._set(old)
            }, addObserver: { observer in
                    self.addObserver { observer($0[index]) }
            })
        }
    }


That’s all there is to it. The code uses a lot of advanced Swift features, but it’s under a hundred lines. It wouldn’t be possible without all the new Swift 4 additions: it relies on keypaths, generic subscripts, open-ended ranges, and a lot of features that were previously available in Swift.

### Discussion

As stated before, this is research code, not production-level code. I’m very interested to see where and how this breaks once I start using it in a real app. Here’s a snippet that had some very counter-intuitive behavior for me:

    var twoPeople: Ref<Addressbook> = Ref(initialValue:
        [Person(name: "One", addresses: []),
         Person(name: "Two", addresses: [])])
    let p0 = twoPeople[0]
    twoPeople.value.removeFirst()
    print(p0.value) // what does this print?


I’d be really interested in pushing this further. I can imagine adding support for queues, so that you can do something like:

    var source = Ref<Addressbook>(initialValue: [],
        queue: DispatchQueue(label: "private queue"))


I can also imagine that you could use this with a database. The `Var` would allow you to both read and write, as well as subscribe to any notifications:

    final class MyDatabase {
       func readPerson(id: Person.Id) -> Var<Person> {
       }
    }


I’d love to hear comments and feedback. If you want to get a deeper understanding of how this works, try implementing it yourself (even after you’ve had a look at the code). By the way, we’ll also make two [Swift Talk](http://talk.objc.io/) episodes about this. If you’re interested in Florian and me building this from scratch, please subscribe there.

> Update: thanks to Egor Sobko for pointing out a subtle but crucial mistake: I was sending the observers `initialValue` rather than `theValue`. Fixed!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
