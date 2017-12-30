> * 原文地址：[When and how to use Value and Reference Types in Swift](https://khawerkhaliq.com/blog/swift-value-types-reference-types/)
> * 原文作者：[KHAWER KHALIQ](https://khawerkhaliq.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/swift-value-types-reference-types.md](https://github.com/xitu/gold-miner/blob/master/TODO/swift-value-types-reference-types.md)
> * 译者：
> * 校对者：

# When and how to use Value and Reference Types in Swift

In this post, we will explore the semantic differences between value and reference types, some of the defining characteristics of values and key benefits of using value types in Swift. We will then look at when to use value and reference types when designing applications.

## Value and reference types in Swift

Swift is a multi-paradigm programming language. It has classes, which are the building blocks of object-oriented programming. Classes in Swift can define properties and methods, specify initializers, conform to protocols, support inheritance and enable polymorphism. Swift is also a protocol-oriented programming language, with feature-rich protocols and structs, enabling abstraction and polymorphism without using inheritance. In Swift, functions are first-class types which can be assigned to variables, passed into other functions as arguments and returned from other functions. Swift thus also lends itself to functional programming.

The biggest difference that programmers coming from many object-oriented languages to Swift notice is the rich functionality offered by structs. Swift structs can define properties and methods, specify initializers and conform to protocols. With the exception of inheritance, whatever you can do with a class, you can also do with a struct. This triggers the question of when and how to use structs and classes. In a more general sense, it is a question of when and how to use value types and reference types in Swift.

Just for the sake of completeness, structs are not the only value types in Swift. Enums and tuples are also value types. Similarly, classes are not the only reference types. Functions are also reference types. Functions, enums and tuples, however, are more specialized in how and when they are used. The debate about value and reference types in Swift centres mostly around structs and classes. This is the primary focus of this post and the terms value type and reference type will be used interchangeably with the terms struct and class respectively.

Let’s start with some first principles, the difference between value and reference semantics.

## Value vs. reference semantics

With value semantics, a variable and the data assigned to the variable are logically unified. Since variables exist on the stack, value types in Swift are said to be stack-allocated. To be precise, all value type instances will not always be on the stack. Some may exist only in CPU registers while others may actually be allocated on the heap. In a logical sense though, value type instances can be thought of as being _contained_ in the variables to which they are assigned. There is a one-to-one relationship between the variable and the data. The value held by a variable cannot be manipulated independently of the variable.

With reference semantics, on the other hand, the variable and the data are distinct. Reference type instances are allocated on the heap and the variable contains only a reference to the location in memory where the data is stored. It is possible and quite common for there to be multiple variables with references to the same instance. Any of these references can be used to manipulate the instance.

This has implications for what happens when a value or reference type instance is assigned to a new variable or passed into a function. Since a value type instance can have only one owner, the instance is copied and the copy is assigned to the new variable or passed into the function. Each copy can be amended without affecting the others. With reference types, only the reference gets copied and the new variable or the function gets the new reference to the same instance. If a reference type instance is amended using any of the references, it will affect all other owners as they hold references to the same instance.

Let’s look at some code to see this in action.

```
struct CatStruct {
    var name: String
}

let a = CatStruct(name: "Whiskers")
var b = a
b.name = "Fluffy"

print(a.name)   // Whiskers
print(b.name)   // Fluffy
```

We define a struct to represent a cat, with a `name` property. We create a `CatStruct` instance, assign it to a variable, then assign this variable to a new variable and modify the `name` property using this new variable. Since structs have value semantics, the act of assignment to the new variable results in the instance being copied and we get two separate `CatStruct` instances with different names.

Now, let’s do the same using a class:

```
class CatClass {
    init(name: String) {
        self.name = name
    }

    var name: String
}

let x = CatClass(name: "Whiskers")
let y = x
y.name = "Fluffy"

print(x.name)   // Fluffy
print(y.name)   // Fluffy
```

In this case, modifying the `name` property using the new variable modifies the `name` property for the first variable as well. This is because classes have reference semantics and the act of assignment to the new variable does not create a new instance. Both variables hold references to the same instance. This leads to **implicit data sharing**, which can have implications for how and when reference types should be used.

## Different notions of Mutability

To understand the difference between mutability in value and reference types, we have to distinguish between **variable mutability** and **instance mutability**.

As already noted, value type instances and the variables they are assigned to are logically unified. Therefore, if a variable is immutable, it makes the instance it holds immutable regardless of whether the instance has mutable properties or mutating methods. Only when a value type instance is assigned to a mutable variable does instance mutability come into play.

With reference types, the instance and the variable it is assigned to are distinct and so is their mutability. When we declare a variable holding a reference to a class instance as immutable, what we are ensuring is that the reference this variable holds will never change, i.e., it will always point to the same instance. Mutable properties of the instance can still by modified using this or any other reference to the instance. To make a class instance immutable, all its stored properties must be immutable.

In the code we just saw, it is okay to declare `a` which holds the first `CatStruct` instance as a `let` constant since its value is never modified. `b` must be declared as a `var` since we have modified its `name` property and thus its value. For `CatClass`, both `x`and `y` are declared as `let` constants, yet we were able to modify the value of the `name` property.

## Defining characteristics of values

To gain a better understanding of when and how to use value types, we need to look at some of the defining characteristics of values:

1. **Attribute-based equality:** Any two values of the same type whose corresponding attributes are equal can always be considered equal. Consider a `Money` type that represents monetary amounts with attributes for the currency and the amount. If we create an instance representing 5 US dollars, it will be equal to any other instance representing 5 US Dollars.
2. **Lack of Identity or lifecycle:** A value does not have inherent identity. It is defined only by the values of its attributes. This is true for simple values like the number 2 or the string “Swift”. It is equally true for more complex values. A value also does not have a lifecycle through which state changes need to be preserved. It can be created, destroyed or recreated at any time. An instance of `Money` representing 5 US dollars is equal to any other instance representing 5 US dollars regardless of when or how the two instances were created.
3. **Substitutability:** Not having a distinct identity or lifecycle gives value types substitutability, which means that any instance can be freely substituted for another provided the two instances are equal, i.e., they pass the test of attribute-based equality. Going back to our `Money` type example, once we create an instance representing 5 US dollars, the application is free to create or discard copies of this instance as it sees fit. Any time we are handed an instance representing 5 US dollars, it is immaterial whether it is the same instance that we had created earlier. All we care about are the values of the attributes.

## Advantages of using value types

#### 1. Efficiency

Reference type instances are allocated on the heap, which is more expensive than stack allocation. In order to ensure that the allocated memory is freed up when a reference type instance is no longer required, there is a need to keep a count of all active references to every reference type instance and deallocate instances when there are no more references to them. Value types do not suffer from this overhead, leading to efficient instance creation and copying. Copies of value types are said to be _cheap_ because value type instances can be copied in constant time.

Swift implements built-in extensible data structures such as `String`, `Array`, `Dictionary`, etc., as value types. However, these cannot be allocated on the stack because their size is not known at compile time. To be able to use heap allocation efficiently and maintain value semantics, Swift uses an optimization technique called **copy-on-write**. What this means is that while each copied instance is a copy in the logical sense, an actual copy on the heap is made only when a copied instance is mutated. Until then, all logical copies continue to point to the same underlying instance. This provides better performance characteristics because fewer copies are made and, when copying does take place, it involves a fixed number of reference counting operations. This performance optimization can be also be used, where required, for custom value types.

#### 2. Predictable code

With a reference type, any part of the code that holds a reference to an instance cannot be certain about what that instance contains since it can be modified using any other reference. Since value type instances are copied on assignment with no implicit data sharing, we don’t need to think about unintended consequences of an action taken in one part of the code affecting the behavior of others. Moreover, when we see a variable declared as a `let` constant holding a value type instance, we can be sure that the value can never be modified regardless of how the value type is defined. This provides strong guarantees and fine-grained control over how certain parts of the code will behave, making code easier to reason about and more predictable.

One could argue that code could be written such that each time a reference type instance is handed to a new owner, a copy is created. But that would lead to a lot of defensive copying, which would be quite inefficient since copying a reference type involves significant overhead. If the reference type instance being copied has properties which are also reference type instances and we want to avoid any implicit data sharing, a **deep copy** would have to be created every time, which would make the performance characteristics even worse. We could also try to address the issue of shared state and mutability by making all reference types immutable. But this would still involve a lot of inefficient copying and not being able to mutate the state of a reference type would pretty much defeat the purpose of using reference types.

#### 3. Thread safety

Value type instances can be used in a multi-threaded environment without having to worry about one thread mutating the state of an instance being used by another. Since there are no race conditions or deadlocks, there is no need to implement synchronization mechanisms. Writing multi-threaded code with value types thus becomes simpler, safer and more efficient.

#### 4. No memory leaks

Swift uses automatic reference counting and deallocates a reference type instance when there are no references to it. This addresses the issue of memory leaks during the normal course of events. However, there can still be memory leaks through strong reference cycles, where two class instances hold strong references to each other and prevent each other from being deallocated. The same thing can happen when there is a strong reference cycle between a class instance and a closure, which are also reference types in Swift. Since value types have no references, the question of memory leaks does not arise.

#### 5. Easier testability

Because a reference type maintains state over its lifecycle, unit testing reference types often involves using mocking frameworks to observe the effects of various method calls on the state and behavior of the object under test. Moreover, since behaviour of reference type instances can change with changes in state, setup code is usually required to get the object under test in the correct state. With value types, all that matters is the value of the attributes. All we need to do, therefore, is to create a new value with the same attributes as the expected value and compare them for equality.

## Designing applications with value and reference types

Value and reference types should not be seen as somehow competing with each other. They have different semantics and behaviour, which make them suitable for different purposes. The goal should be to understand and leverage the interplay of value and reference semantics to combine value and reference types in a way that best satisfies the goals of the application.

#### 1. Reference types to model entities with identity

Most real-world domains have entities that must maintain identity and preserve state over their lifecycles. Such entities should be modeled using classes.

Consider a payroll application that uses an `Employee` type to represent members of staff. For simplicity, let’s assume we store the first and last name of each employee. There could be two or more `Employee` instances with the same first and last names, but this does not make them equal, as these instances represent distinct employees in the real world.

If we assign an `Employee` class instance to a new variable or pass it into a function, the new reference will point to the same instance. This will ensure, for instance, that if we use one reference to record the number of hours worked by the employee in one module of the application, when another module of the application computes the monthly pay, it will use the same instance that has the correct number of hours worked. Similarly, if we update the residential address of an employee in one place, all references we have to that employee will reflect the correct address because they are references to the same instance.

Trying to use a struct to model an employee will lead to errors and inconsistencies in the application since each time an `Employee` instance is assigned to a new variable or passed into a function, it will be copied. Different parts of the program will end up with their own separate instances and state changes made in one part will not reflect in the others.

#### 2. Value types to encapsulate state and expose behaviour

While entities in the domain that have identity and a lifecycle should be modeled using classes, value types should be used to encapsulate their state, express relevant business rules and expose behaviour.

Let us take our `Employee` type. Let’s assume we need to maintain information about each employee’s personal data, compensation and performance. We can create value types `PersonalData`, `Compensation` and `Performance` to bring together related elements of state, business rules and behaviour. This keeps the class from getting bloated as it is directly responsible only for maintaining identity, while value type instances it holds take care of various elements of that state and related behaviour.

This also fits nicely with the **Single Responsibility Principle**. Rather than the `Employee` type having to implement methods to expose various aspects of behaviour, client code that is interested in an employee’s performance, for instance, can be handed an instance of the `Performance` type. Because we are dealing with value types, we do not have to worry about implicit data sharing and client mode making changes behind our back which would affect the state of our `Employee` instance.

This approach can also encourage more code to be written in a multi-threaded fashion. Copies of value type instances representing various elements of the state of a reference type instance can freely be handed over to processes running on different threads without the need for synchronization. This can lead to performance gains and increasing responsiveness of interactive applications.

#### 3. The importance of context

It is important to bear in mind that sometimes the choice between a value and reference type is driven by the context. Application development is not an exercise in modeling the real world in an absolute sense but rather about modeling specific aspects of the problem domain to satisfy the given use cases. The same real-world entity could, therefore, require value or reference semantics in the context of the application depending on what role the entity plays in the relevant problem domain.

Consider the `CatStruct` and `CatClass` types introduced earlier. Which one would we rather use to model our pet cat? Since the instance we create would represent an actual cat, we should use a class. When we hand over our cat to the vet to get vaccinated, for instance, we would not want the vet to vaccinate a copy of the cat, which is what would happen if we used a struct. If, however, we are designing an application dealing with dietary habits of pet cats, we should use a struct as we would be dealing with cats in a general sense and not looking to identify a specific cat. For such an application, our `CatStruct` will not have a `name` property but will likely have properties for the types of food consumed, number of servings per day, etc.

Earlier, we used the `Money` type as an example of a concept best modeled as a value. This is true in the context of a banking, financial or other application where we are concerned with just the attributes of money, i.e., how much and in what currency. If, however, we are building an application to control the printing, distribution and eventual disposal of physical currency, we need to think about each currency note as an entity with a unique identity and lifecycle.

Similarly, for an application developed for a tire manufacturer, each tire would likely be an entity with a unique identity and lifecycle, which would extend beyond the point of sale to track returns, warranty claims, etc. However, a company manufacturing cars would probably see tires for their attributes and may not want to keep track of which individual tire is used in which car, although they would see the cars they manufacture as having unique identities and lifecycles.

#### 4. The _attribute-based equality_ test

Value types have no inherent identity to distinguish once instances of a type from another. The only way to compare them is to compare their attributes. In fact, the concept of attribute-based equality is so fundamental to value types that it can be used a guide when deciding whether a particular type should be a value type or a reference type. If two instances of a type cannot be compared for equality based solely on their attributes, then we are likely dealing with some element of identity. This usually means that either the type should be a reference type or it should be split to separate the value and reference semantics.

In practice, this means that we should be able to compare any two instances of a given value type using the Swift `==` operator. It follows that all value types must conform to the `Equatable` protocol.

#### 5. Combining value and reference types

As already noted, it is quite normal and in fact desirable for reference types to have properties that are instances of value types to encapsulate state, express business rules and expose behaviour. These value types can be passed around in an efficient manner without having to worry about unintended consequences, thread safety, etc. But should a value type hold instances of reference types? This should generally be avoided because use of reference type properties on value types can negate the performance and other advantages of value types by introducing heap allocation, reference counting and implicit data sharing. In fact, it may cause the value type to lose its attribute-based equality, lack of identity and substitutability. It is important, therefore, to respect these boundaries and not to combine value and reference semantics in a way that will compromise the integrity of either.

There are various ways to describe how value and reference types can work together in real-world applications. As [Andy Matuschak](https://twitter.com/andy_matuschak) put it in [this blog post](https://www.objc.io/issues/16-swift/swift-classes-vs-structs/): Think of objects as a thin, imperative layer above the predictable, pure value layer. In the References section of Andy’s post is a link to [this talk](https://www.destroyallsoftware.com/talks/boundaries) by [Gary Bernhardt](https://twitter.com/garybernhardt), where he proposes a way of building systems using what he calls a functional core and an imperative shell. The functional core is composed of pure values, domain logic and business rules. It is easy to reason about, facilitates concurrency and simplifies testing because it is isolated from external dependencies by the imperative shell, which preserves state and connects to the world of user interfaces, persistence mechanisms, networks, etc.

## The Swift Standard Library and the Cocoa frameworks

The Swift Standard Library is composed predominantly of value types. All basic built-in types and collections have been implemented as structs. The frameworks that form part of Cocoa, however, are composed mostly of classes. Some of this is required because classes are the appropriate way to model view controllers, user interface elements, network connections, file handlers, etc.

But Cocoa also has a number of classes in the Foundation framework that would rather be value types but exist as reference types because they are written in Objective-C. This is where the Swift Foundation overlay comes in, providing bridged value types for a growing number of Objective-C reference types. For more details on bridged types and how Swift interoperates with Cocoa frameworks, see [this page in the Apple developer library](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/WorkingWithCocoaDataTypes.html#//apple_ref/doc/uid/TP40014216-CH6-ID61).

## Conclusion

Swift provides powerful and efficient value types that can be used to make parts of our code more efficient, predictable and thread-safe. This requires understanding the differences between value and reference semantics to be able to combine value and reference types in a way that best satisfies the goals of the application.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
