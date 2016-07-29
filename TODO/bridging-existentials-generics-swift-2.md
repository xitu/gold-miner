>* 原文链接 : [Bridging Existentials & Generics in Swift 2](http://blog.benjamin-encz.de/post/bridging-existentials-generics-swift-2/)
* 原文作者 : [Benjamin Encz](http://blog.benjamin-encz.de/about)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


We are back to another episode of discussing generics, protocols with associated types and some type system limitations in Swift 2\. This time we will dive into an interesting workaround that the infamous [jckarter](https://twitter.com/jckarter) has taught me. We will also discuss how this workaround might become unnecessary through enhanced existential support in future Swift versions. But what are existentials anyway?

## Existentials in Swift

Generally speaking existentials allow us to define type variables using type requirements. We can use these type variables throughout our program without knowing which concrete underlying type implements the requirements.

In Swift 2 the only way to define an existential type is using the `protocol<>` syntax ([which will be replaced with the `&` syntax in Swift 3](https://github.com/apple/swift-evolution/blob/master/proposals/0095-any-as-existential.md)).

By defining e.g. a function that takes an existential argument, we are able to use any members of the existential type without knowing which concrete type was passed to the function:



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



In many ways existentials are very similar to generics. Why would we choose one over the other? My friend Russ Bishop has covered this in detail in a blog post on existentials & generics - [if you’re curious about the details you should go read it](http://www.russbishop.net/swift-associated-types-cont)!

## Bridging Between Existentials and Generics

In an [earlier blog post](http://blog.benjamin-encz.de/post/compile-time-vs-runtime-type-checking-swift/) I pointed out some incompatibilities between type information that is statically known at compile time (Generics) and type information that is dynamically available at runtime (Existentials).

Today I want to focus on a concrete (though simplified) example that we have encountered in the PlanGrid app.

As part of our client-server synchronization process we persist objects that we have parsed from JSON in our database. We do that via a generic data access object. The data access object has a generic type parameter that specifies the type of object that is going to be persisted.

In our simplified examples we are going to persist `Cat`, `Dog` and `Cow` instances.



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



In the PlanGrid app we have a coordination point that has a reference to all specialized instances of our generic DAO. During the synchronization process we encounter a variety of different types that need be stored in the correct instance of the generic DAO type (e.g. cows should be stored via an instance of `GenericDAO<Cow>`).

Given a heterogenous list of different instances that can be persisted we want to automatically find & call the DAO based on the type of object we encounter.



    // A list of our generic data stores
    let genericDAOs: [Any] = [GenericDAO<Cat>(), GenericDAO<Dog>(), GenericDAO<Cow>()]

    // A list of instances we have parsed & need to persist
    let instances: [PersistedType] = [Cat(), Dog(), Cow()]



How can we implement a loop that iterates over all elements in `instances` and stores them in the generic DAO that has the matching type parameter for the object we want to store? Ideally we would want to do something like the following (which is syntactically invalid in Swift 2):



    // `element` is an existential since we don't know the concrete type
    // we only know it conforms to the `PeristedType` protocol.
    for element in instances {
        // Invalid! Cannot use existential type as generic type parameter
        for case let dao as? GenericDAO<element.Self> in genericDAOs {
            dao.save(element)
        }
    }



Some potential, future improvements to Swift could make this possible, but for now we cannot dynamically refer to the type of the existential (`element.Self`) and use it as a generic type parameter.

## The Workaround

The `.Self` member, which would refer to the concrete type of the existential doesn’t exist in Swift 2\. However, we can access the concrete type of the existential using `Self` from within protocols & protocol extensions.

Using a clever inversion of control we can use that `Self` type from within the `PersistedType` protocol (which all persisted types implement) to dynamically specify the generic type parameter of our `GenericDAO<T>`:



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



From within the protocol extension we can successfully use the underlying type of the existential (`Self`) as a generic type parameter. Even though the inverted control flow is anything but beautiful, this workaround can be useful to bridge the gap between existentials and generics.

## The Future is Bright

Among many other critical improvements, the changes suggested by the [enhanced existential proposal **draft**](https://github.com/austinzheng/swift-evolution/blob/az-existentials/proposals/XXXX-enhanced-existentials.md) would eliminate this workaround by allowing to refer to the underlying type of an existential via `.Self` and making it possible to use that type as a generic type parameter.

Even though the enhanced existential proposal is still under active development it is well worth a read. If it the final implementation will cover what is in the proposal draft today, we will be able to seemingly bridge between existentials and generics. More importantly working with protocols with associated types would no longer be a painful experience - probably the most significant improvement to Swift since its inception?

Interested in pushing the limits of Swift? **[we’re hiring](http://grnh.se/8fcutd)**.

**References**:

*   [Enhanced Existentials Proposal Draft](https://github.com/austinzheng/swift-evolution/blob/az-existentials/proposals/XXXX-enhanced-existentials.md) - Proposal draft that is slowly taking shape and outlines drastic improvements to Swift’s existential support.
*   [Generics Manifesto](https://github.com/apple/swift/blob/c39da37525255d3bc141038ff567b4aca57d316e/docs/GenericsManifesto.md) - Doug Gregor’s original swift-evolution email that outlines various potential improvements to Swift’s generics (including enhanced existentials).
*   [Abstract Types Have Existential Type](http://theory.stanford.edu/~jcm/papers/mitch-plotkin-88.pdf) - The paper that formalized the idea of existential types in programming languages. Most relevant quote for my understanding of existentials: “Existential types provide just enough information to verify the matching condition […], without providing any information about the representation of the carrier or the algorithms used to implement the operations.“.
