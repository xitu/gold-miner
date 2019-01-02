
> * 原文地址：[Struct References](http://chris.eidhof.nl/post/references/)
> * 原文作者：[Chris Eidhof](https://twitter.com/chriseidhof/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/swift-struct-references.md](https://github.com/xitu/gold-miner/blob/master/TODO/swift-struct-references.md)
> * 译者：[Swants](https://swants.github.io)
> * 校对者：[ChenDongnan](https://github.com/ChenDongnan) [FlyOceanFish](https://github.com/FlyOceanFish) 

# 结构体指针

> 所有的代码都可以在 [gist](https://gist.github.com/chriseidhof/3423e722d1da4e8cce7cfdf85f026ef7) 上获取。

最近我打算为 Swift 的最新的 keypaths 找一个好的使用场景，这篇文章介绍了我意外获得的一个使用示例。这是我刚研究出来的，但还没实际应用在生产代码上的成果。也就是说，我只是觉得这个成果非常酷并想把它展示出来。

思考一个简单的通讯录应用，这个应用包含一个展示联系人的列表视图和展示联系人实例的详情视图控制器。如果把 `人` 定义成一个类的话，大概是这个样子：

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


我们的（假设）viewController  有一个通过初始化方法设置的 person 属性。这个类还有一个 `change` 方法来修改这个人的属性。

    final class PersonVC {
        var person: Person
        init(person: Person) {
            self.person = person
        }

        func change() {
            person.name = "New Name"
        }
    }


让我们思考下当 `Person` 初始化为一个对象后遇到的问题：

- 因为 `person` 是一个指针，其他部分的代码就可能修改它。这是非常实用的，因为这让消息传递成为了可能。而与此同时，我们需要保证我们可以一直监听的到这些改变（比如使用 KVO ），否则我们可能会遇到数据不同步的问题。但保证我们能够实时监听则是不容易实现的。
- 当地址发生变化时，收到通知就更难了。观察嵌套的对象属性则是最困难的。
- 如果我们需要给 `Person` 创建一个独立的本地 copy，我们就需要实现一些像 `NSCopying` 这样的东西， 这需要不少的工作量。甚至当我们决定这么做时，我们仍然不得不考虑是想要深拷贝（地址也被拷贝）还是浅拷贝（地址数组是独立的，但是里面的地址仍指向相同的对象）？
- 如果我们把 `Person` 当成 `AddressBook` 数组的元素，我们可能想要知道通讯录什么时候做了修改（比如说进行排序）。而想要知道你的对象图中的东西何时做了改变要么需要大量的样板，要么需要大量的观察。

如果 `Person` 和 `Address` 做成结构体的话，我们又会碰到不同的问题：

- 每个结构体都是独立的拷贝。这是有用的，因为我们知道它总是一致的，不会在我们手底下改变。然而，当我们在详情控制器 中对 `Person` 做了修改时。我们就需要一个方法来将这些改变反馈给列表视图（或者说通讯录列表）。而对于对象，这种情况会自动发生（通过在适当的位置修改 `Person` ）。
- 我们可以观察通讯录结构体的根地址，从而知道通讯录发生的任何变化。然而，我们还是不能很容易得观察到它内部属性的变化（比如：观察第一个人的名字）。

我现在提出的解决方案结合了两个方案的最大优势：

- 我们有可变的共享指针
- 因为底层数据是结构体，所以我们可以随时得到我们自己的独立拷贝
- 我们可以观察任何部分：无论在根级别，还是观察独立的属性（例如第一个人的名字）

我接下来会演示这个方案怎么使用，如何工作，最后再说说方案的局限性和问题。

让我们用结构体来创建一个通讯录。

    struct Address {
        var street: String
    }
    struct Person {
        var name: String
        var addresses: [Address]
    }

    typealias Addressbook = [Person]


现在我们可以使用我们的 `Ref` 类型（ `Reference` 的简称）。
我们用一个初始化的空数组来创建一个新的 `addressBook`。然后添加一个 `Person` 。接下来就是最酷的地方：通过使用下标我们可以获得指向第一个人的 **指针** ，接着是一个指向他们名字的 **指针** 。我们可以将指针指向的内容改为 `“New Name"` 来验证我们是否更改了原始的通讯录。

    let addressBook = Ref<Addressbook>(initialValue: [])
    addressBook.value.append(Person(name: "Test", addresses: []))
    let firstPerson: Ref<Person> = addressBook[0]
    let nameOfFirstPerson: Ref<String> = firstPerson[\.name]
    nameOfFirstPerson.value = "New Name"
    addressBook.value // shows [Person(name: "New Name", addresses: [])]


`firstPerson` 和 `nameOfFirstPerson` 类型可以被忽略，它们仅仅是为了增加代码可读性。

无论何时我们都可以对 `Person` 内容进行独立备份。一旦你做了拷贝，我们就可以使用 `myOwnCopy` ，并且不必实现 `NSCopying` 就能保证它的内容不会在我们手底下改变：

    var myOwnCopy: Person = firstPerson.value


我们可以监听任何 `Ref` 。就像 reactive 库一样，我们得到了一个可以控制观察者生命周期的一次性调用：

    var disposable: Any?
    disposable = addressBook.addObserver { newValue in
        print(newValue) // Prints the entire address book
    }

    disposable = nil // stop observing


我们也可以监听 `nameOfFirstPerson` 。在目前的实现中，无论什么时候通讯录中的任何改变都会触发监听，但以后的实现会有更多的功能。

    nameOfFirstPerson.addObserver { newValue in
        print(newValue) // Prints a string
    }


让我们返回我们的 `PersonVC` 。我们可以使用 `Ref` 作为他的实现。 这样 viewController 就可以收到每一次更改。在响应式编程中，信号通常是只读类型的（你只会收到发生了变化的信息），这时你就需要找到另一种回传信号的方法。 在 `Ref` 方案中，我们可以使用 `person.value` 进行回写：

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


这个 `PersonVC` 不知道 `Ref <Person> `是从哪里获得的：是从一个 person 数组，一个数据库或者其他地方。实际上，我们可以通过将我们的数组包装在 [`History` 结构体](http://chris.eidhof.nl/post/undo-history-in-swift/) 中来撤销对我们通讯录的支持。
这样我们就不再需要修改 `PersonVC`：

    let source: Ref<History<Addressbook>> = Ref(initialValue: History(initialValue: []))
    let addressBook: Ref<Addressbook> = source[\.value]
    addressBook.value.append(Person(name: "Test", addresses: []))
    addressBook[0].value.name = "New Name"
    print(addressBook[0].value)
    source.value.undo()
    print(addressBook[0].value)
    source.value.redo()


我们还可以为它添加其他的很多东西：缓存，[序列化](https://gist.github.com/chriseidhof/40fde6c2be5519d5bb341fc65b3029ad)，自动同步（比如只在子线程上修改和观察），但这都是之后的工作。

### 实现细节

我们来看看这个事情是如何实现的。我们首先从 `Ref` 类的定义开始。
`Ref` 包含一个获取值和一个设置值的方法，以及添加一个观察者的方法。它有一个需要三个参数的初始化方法：

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


现在我们可以添加一个可以观察单个结构体值的初始化方法。它创建了一个观察者和变量对应的字典。这样无论变量什么时候被修改了，所有的观察者都会被通知到。它使用上述定义的初始化方法，并传递给 `get`, `set`, 和 `addObserver`:

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


想一下我们现在已经有 `Person` 指针，为了拿到 `Person name`  属性的指针，我们需要一种方式来对 name 进行读写操作。而 `WritableKeyPath` 恰好可以做到。因此，我们可以在 `Ref` 中添加一个`subscript` 来创建可以指向 `Person` 某一部分的指针：

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


上面的代码有一点难于理解，但如果只是为了使用这个库，我们不需要真的弄明白它是怎么实现的。

也许某一天，Swift 中的 keypath 也会支持下标，但至少现在没有，接下来我们必须为集合添加另外一个下标。除了使用索引而不是 keypath ，它的实现几乎就跟上面的一样。

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


这就是全部实现了。上面代码使用了 Swift 大量新特性，但它仍保持在 100 行代码以下。如果没有 Swift 4 最新功能，这也基本不可能实现。它依赖于 keypaths ，通用下标，开放范围以及以前在 Swift 中提供的许多功能。

### 讨论

就如之前所提到的那样，这些仍处于研究中而不是生产级的代码。一旦我开始在一个真正的应用程序中使用它，我非常感兴趣想知道将来会遇到什么样问题。 下面就是其中一个让我感到困惑的代码段：：

    var twoPeople: Ref<Addressbook> = Ref(initialValue:
        [Person(name: "One", addresses: []),
         Person(name: "Two", addresses: [])])
    let p0 = twoPeople[0]
    twoPeople.value.removeFirst()
    print(p0.value) // what does this print?


我很有兴趣将它更进一步。我甚至可以想象的到，如果我为他添加队列支持，你就可以像下面那样使用：

    var source = Ref<Addressbook>(initialValue: [],
        queue: DispatchQueue(label: "private queue"))


我还能想象的到你可以用它和数据库搭配使用。这个 `Var` 将会让你同时支持读写操作，并订阅任何修改的通知：

    final class MyDatabase {
       func readPerson(id: Person.Id) -> Var<Person> {
       }
    }


我期待着听到您的评论和反馈，如果你需要更深入的理解它是如何工作的，试着自己去实现它（即便你已经看了代码）。顺便提一下，我们将会以它为主题开展两场 [Swift Talk](http://talk.objc.io/)。如果你对 Florian 和我从头开始构建这个项目感兴趣，就订阅它吧。

> 更新： 感谢 Egor Sobko 指出了一个微妙但却至关重要的错误:我为观察者发送的是 `initialValue` 而不是 `theValue`，已修改!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
