> * 原文链接 : [Bridging Existentials & Generics in Swift 2](http://blog.benjamin-encz.de/post/bridging-existentials-generics-swift-2/)
> * 原文作者 : [Benjamin Encz](http://blog.benjamin-encz.de/about)
> * 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者 : [Nicolas(Yifei) Li](https://github.com/yifili09) 
> * 校对者: [Gran](https://github.com/Graning), [MAYDAY1993](https://github.com/MAYDAY1993)

# Swift 2 中为实存类型和泛型搭桥牵线

我们又回到了讨论泛型的另一个章节，来讨论泛型，有其他类型的协议和在 `Swift 2` 中的其他类型的系统限制。这次我们会深入讨论一个有趣的变通方法，它是那个声名狼藉的 [jckarter](https://twitter.com/jckarter) 教会我的。我们也会讨论在未来的 `Swift` 版本中，这个变通方法通过增强型的实存类型就变得不必要了。

## `Swift` 中的实存类型

一般而言，实存类型允许我们去使用类型的需求来定义类型变量。我们可以在整个项目中使用这些类型变量，它可以不需要被知道背后是具体的哪个类型实现这些需求的。

在 `Swift 2` 中，只有使用 `protocol<>` 语法 ( [在 `Swift 3` 中会被 `&` 语法替换](https://github.com/apple/swift-evolution/blob/master/proposals/0095-any-as-existential.md) ) 才能定义一个实存类型。

通过定义一个方法函数，它需要使用一个实存类型参数，我们能在不知道参数的具体类型的情况下，使用实存类型中任意的一个:


```
    protocol Saveable {
        func save()
    }

    protocol Loadable {
        func load()
    }

    func doThing(thing: protocol<Saveable, Loadable>) {
        thing.save()
        thing.load()
    }
```


在许多实存类型的实现方式上，他们与泛型都很想象。为什么我们选择这个而不是其他？我的一个朋友 `Russ Bishop` 在他的博客上发布过一个文章，详细的讨论了实存类型和泛型 - [如果你对其中的细节好奇，你应该去读一读它](http://www.russbishop.net/swift-associated-types-cont) !

## 为实存类型和泛型搭桥牵线

在一个 [之前的博客文章中](http://blog.benjamin-encz.de/post/compile-time-vs-runtime-type-checking-swift/) 我指出了一些类型信息上的不一致性，泛型是静态的，它在编译的时候类型就确定了，实存类型在运行时候才能确定，这意味着类型的信息是动态的。

今天，我想把注意力都放在一个具体的例子上（虽然会很简单），我们在 `PlanGrid` 应用程序中遇到过。

作为我们的 `客户端-服务端` 同步过程的一部分，我们把从 `JSON` 解析出的内容持久化存储在我们的数据库中。我们通过泛型类数据访问这些对象来实现。数据访问对象有一个泛型类参数，它指定了这个将要被持久化保存的对象的类型。

在我们简单的例子中，我们需要去持久化保存 `Cat`, `Dog` 和 `Cow` 实例。


```
    protocol PersistedType {}

    // Types that will be persisted
    class Cat: PersistedType {}
    class Dog: PersistedType {}
    class Cow: PersistedType {}

    // DAO that provides a generic persistence mechanism
    class GenericDAO<ObjectType: PersistedType> {
        func save(objectType: ObjectType) {
            print("Saved \(objectType) in \(ObjectType.self) DAO")
        }
    }
```


在 `PlanGrid` 应用程序中，我们有一个协调点，它对我们泛型 `DAO(数据访问对象)` 所有特殊的实例都有一个引用。在同步过程中，我们遇到了一系列不同的类型，它们需要被准确的存储进泛型 `DAO(数据访问对象)` 类型。(比如，`cows` 应该被通过 `GenericDAO<Cow>` 来存储。)

考虑到一个不同实例的异构列表，基于我们遇到的对象类型，我们想自动的查询，调用 `DAO(数据访问对象)` 进行持久化存储。


```
    // A list of our generic data stores
    let genericDAOs: [Any] = [GenericDAO<Cat>(), GenericDAO<Dog>(), GenericDAO<Cow>()]

    // A list of instances we have parsed & need to persist
    let instances: [PersistedType] = [Cat(), Dog(), Cow()]
```


我们怎样实现一个有关迭代所有在 `实例` 中的元素并且保存他们进入泛型 `DAO(数据访问对象)`的循环，它有我们想要保存的匹配的类型参数。理论上，我们想按照以下内容实施(在 `Swift 2` 语法中是非法的):


```
    // `element` is an existential since we don't know the concrete type
    // we only know it conforms to the `PeristedType` protocol.
    for element in instances {
        // Invalid! Cannot use existential type as generic type parameter
        for case let dao as? GenericDAO<element.Self> in genericDAOs {
            dao.save(element)
        }
    }
```


一些潜在的，对 `Swfit` 未来的提高能让这个方法实现，但是目前，我们不能对实存类型进行动态的引用(`element.Self`) 和作为一个泛型类型参数来使用它。

## 变通方法

`.Self` 成员变量，引用到某个实存类型的具体类型并不在 `Swift 2` 中存在。然而，我们能通过协议和扩展协议，使用 `Self` 来访问这个具体的实存类型。 

使用这个聪明的反向控制，我们能配合 `PersistedType` 协议使用这个 `Self` 类型
(那些所有持久类实现的)，对我们的 `GenericDAO<T>` 动态的指定泛型类参数。

```
    extension PersistedType {

        // Pass in a list of all DAOs.
        func saveInCorrectDAO(potentialDAOs: [Any]) {
        	// Iterate until we find GenericDAO with type parameter that matches
        	// our existential type.
            for case let dao as GenericDAO<Self> in potentialDAOs {
                dao.save(self)
            }
        }

    }

    // ...

    for element in instances {
        element.saveInCorrectDAO(genericDAOs)
    }
```


通过这个协议的扩展，我们能成功使用这个底层的实存类型 (`Self`)，作为一个泛型类型的参数。虽然这个反向控制流根本不漂亮，但是这个变通方法非常有用，它很好的缩小了实存类型和泛型之间的隔阂。

## 前途是光明的

在许多其他重要的改进之间，[增强型的实存类型方案 **草稿**](https://github.com/austinzheng/swift-evolution/blob/az-existentials/proposals/XXXX-enhanced-existentials.md)  将会替代这个变通方法，通过允许通过 `.Self` 对底层的一个实存类型进行引用，并且让这个类型作为一个泛型类参数变得可能。

虽然这个增强型实存类型的方案仍然处于紧锣密鼓的开发中，但它仍旧值得一读。如果这是最后一个我们今天将讨论的方案，我们会缩小实存类型和泛型之间的隔阂。更重要的是，配合其他类型的协议一起工作将再也不是难事 - 可能这是自从 `Swift` 面世以来最重要的改进了。

对突破 `Swift` 的极限感兴趣么？ **[我们需要你！](http://grnh.se/8fcutd)**

**参考文献**:

*   [增强型实存类型 草稿 ( Enhanced Existentials Proposal Draft )](https://github.com/austinzheng/swift-evolution/blob/az-existentials/proposals/XXXX-enhanced-existentials.md) - 草稿方案，它正在被精雕细琢并且展示出很多对 `Swift` 的实存类型的巨大改进。
*   [泛型的声明 ( Generics Manifesto )](https://github.com/apple/swift/blob/c39da37525255d3bc141038ff567b4aca57d316e/docs/GenericsManifesto.md) - `Doug Gregor` 的最初的 `Swift` 实现 - 发展/演进 邮件中展示出了很多对 `Swift` 的泛型的潜在的改进(包括增强型实存类型)。
*   [有实存类型的抽象类型 ( Abstract Types Have Existential Type )](http://theory.stanford.edu/~jcm/papers/mitch-plotkin-88.pdf) - 这片文章是有关总结了在各种编程语言中，实现实存类型的想法。对我理解什么是实存类型最有关系的句子是: “实存类型提供了足够多的信息用于验证匹配条件 [...]，没有提供任何有关显示载体的信息或者实现如何操作的算法。”
