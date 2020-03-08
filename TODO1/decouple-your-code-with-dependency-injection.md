> * 原文地址：[Decouple Your Code With Dependency Injection](https://medium.com/better-programming/decouple-your-code-with-dependency-injection-d893ae9edcf8)
> * 原文作者：[Ben Weidig](https://medium.com/@benweidig)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/decouple-your-code-with-dependency-injection.md](https://github.com/xitu/gold-miner/blob/master/TODO1/decouple-your-code-with-dependency-injection.md)
> * 译者：
> * 校对者：

# Decouple Your Code With Dependency Injection

> No third-party frameworks required

![Photo by [Icons8 Team](https://unsplash.com/@icons8?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/ingredients?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/12032/1*PfS1KYIt9IIDZTIyIIfMsQ.jpeg)

Not many components live on their own, without any dependencies on others. Instead of creating tightly coupled components, we can improve the [separation of concerns](https://en.wikipedia.org/wiki/Separation_of_concerns) by utilizing **dependency injection** (DI).

This article will introduce you to the core concept of dependency injection, without the need for third-party frameworks. All code examples will be in Java, but the general principles apply to any other language, too.

---

## Example: DataProcessor

To better visualize how to use dependency injection**,** we start with a simple type:

```Java
public class DataProcessor {

    private final DbManager manager = new SqliteDbManager("db.sqlite");
    private final Calculator calculator = new HighPrecisionCalculator(5);

    public void processData() {
        this.manager.processData();
    }

    public BigDecimal calc(BigDecimal input) {
        return this.calculator.expensiveCalculation(input);
    }
}
```

The `DataProcessor` has two dependencies: `DbManager` and `Calculator`. Creating them directly in our type has several apparent disadvantages:

* The constructor calls can crash.
* Constructor signatures might change.
* Tightly bound to explicit implementation type.

It’s time to improve it!

---

## Dependency Injection

James Shore, the author of [**The Art of Agile Development**](https://www.amazon.com/Art-Agile-Development-Pragmatic-Software/dp/0596527675), [put it quite nicely](https://www.jamesshore.com/Blog/Dependency-Injection-Demystified.html):

> **“Dependency injection is a 25-dollar term for a 5-cent concept.”**

The concept is actually really simple: Giving a component all the things it needs to do its job.

In general, it means decoupling components by providing their dependencies from the outside, instead of creating them directly, which would create adhesion.

There are different ways how we can provide an instance with its necessary dependencies:

* Constructor injection
* Property injection
* Method injection

#### Constructor injection

Constructor, or initializer-based dependency injection, means providing all required dependencies during the initialization of an instance, as constructor arguments:

```Java
public class DataProcessor {

    private final DbManager manager;
    private final Calculator calculator;

    public DataProcessor(DbManager manager, Calculator calculator) {
        this.manager = manager;
        this.calculator = calculator;
    }

    // ...
}
```

Thanks to this simple change, we can offset most of the initial disadvantages:

* Easily replaceable: `DbManager` and `Calculator` are no longer bound to the concrete implementations, and are now mockable for unit-testing.
* Already initialized and “ready-to-go”: We don’t need to worry about any sub-dependencies required by our dependencies (e.g., database filename, significant digits), or that they might crash during initialization.
* Mandatory requirements: The caller knows exactly what’s needed to create a `DataProcessor`.
* Immutability: Dependencies are still final.

Even though constructor injection is the preferred way of many DI frameworks, it has its obvious disadvantages, too. The most significant one is that all dependencies must be provided at initialization.

Sometimes, we don’t initialize a component ourselves or we aren’t able to provide all dependencies at that point. Or we need to use another constructor. And once the dependencies are set, they can’t be changed.

But we can mitigate these problems by using one of the other injection types.

#### Property injection

Sometimes we don’t have access to the actual initialization of type, and only have an already initialized instance. Or the needed dependency is not explicitly known at initialization as it would be later on.

In these cases, instead of relying on a constructor, we can use **property injection**:

```Java
public class DataProcessor {

    public DbManager manager = null;
    public Calculator calculator = null;

    // ...

    public void processData() {
        // WARNING: Possible NPE
        this.manager.processData();
    }

    public BigDecimal calc(BigDecimal input) {
        // WARNING: Possible NPE
        return this.calculator.expensiveCalculation(input);
    }
}
```

No constructor is needed anymore, we can provide the dependencies at any time after initialization. But this way of injection also comes with drawbacks: **Mutability**.

Our `DataProcessor` is no longer guaranteed to be “ready-to-go” after initialization. Being able to change the dependencies at will might give us more flexibility, but also the disadvantage of more runtime-checks.

We now have to deal with the possibility of a `NullPointerException` when accessing the dependencies.

#### Method injection

Even though we decoupled the dependencies with constructor injection and/or property injection, by doing so, we still only have a single choice. What if we need another `Calculator` in some situations?

We don’t want to add additional properties or constructor arguments for a second `Calculator`, because there might be a third one needed in the future. And changing the property every time before we call `calc(...)` isn't feasible either, and will most likely lead to bugs using the wrong one.

A better way is to parameterize the method call itself with its dependency:

```Java
public class DataProcessor {

    // ...

    public BigDecimal calc(Calculator calculator, BigDecimal input) {
        return calculator.expensiveCalculation(input);
    }
}
```

Now the caller of `calc(...)` is responsible for providing an appropriate `Calculator` instance, and `DataProcessor` is completely decoupled from it.

Even more flexibility can be gained by mixing different types of injection, and providing a default `Calculator`:

```Java
public class DataProcessor {

    // ...

    private final Calculator defaultCalculator;
    
    public DataProcessor(Calculator calculator) {
        this.defaultCalculator = calculator;
    }

    // ...

    public BigDecimal calc(Calculator calculator, BigDecimal input) {
        return Optional.ofNullable(calculator)
                       .orElse(this.calculator)
                       .expensiveCalculation(input);
    }
}
```

The caller **could** provide a different kind of `Calculator`, but it doesn’t **have to**. We still have a decoupled, ready-to-go `DataProcessor`, with the ability to adapt to specific scenarios.

## Which Injection Type to Choose?

Every type of dependency injection has its own merits, and there isn’t a “right way”. It all depends on your actual requirements and the circumstances.

#### Constructor injection

Constructor injection is my favorite, and often preferred by DI frameworks.

It clearly tells us all the dependencies needed to create a specific component, and that they are not optional. Those dependencies should be required throughout the component.

#### Property injection

Property injection matches better for optional parameters, like listeners or delegates. Or if we can’t provide the dependencies at initialization time.

Some other languages, like Swift, make heavy use of the [delegation pattern](https://en.wikipedia.org/wiki/Delegation_pattern) with properties. So, using it will make our code more familiar to other developers.

#### Method injection

Method injection is a perfect match if the dependency might not be the same for every call. It will decouple the component even more because now, just the method itself has a dependency, not the whole component.

Remember that it’s not either-or. We can freely mix the different types where it’s appropriate.

## Inversion of Control Containers

We can cover a lot of use cases with these simple implementations of dependency injection. It’s an excellent tool for decoupling, but we actually still need to create the dependencies at some point.

But as our applications and codebases grow, we might need a more complete solution that simplifies the creation and assembling process, too.

**Inversion of control** (IoC) is an abstract principle of the [flow of control](https://en.wikipedia.org/wiki/Control_flow). And dependency injection is one of its more concrete implementations.

An **IoC container** is a special kind of object that knows how to instantiate and configure other objects, including doing the dependency injection for you.

Some containers can detect relationships via reflection, others have to be configured manually. Some are runtime-based, others generate all the code needed at compile-time.

Comparing all the different options is beyond the scope of this article, but let’s check out a small example to get a better understanding of the concept.

#### Example: Dagger 2

[Dagger](https://dagger.dev/) is a lightweight, compile-time dependency injection framework. We need to create a `Module` that knows how to build our dependencies, that later can be injected by merely adding an `@Inject` annotation:

```Java
@Module
public class InjectionModule {

    @Provides
    @Singleton
    static DbManager provideManager() {
        return manager;
    }

    @Provides
    @Singleton
    static Calculator provideCalculator() {
        return new HighPrecisionCalculator(5);
    }
}
```

The `@Singleton` ensures that only one instance of a dependency will be created.

To get injected with a dependency, we simply add `@Inject` to a constructor, field, or method:

```Java
public class DataProcessor {

    @Inject
    DbManager manager;
    
    @Inject
    Calculator calculator;

    // ...
}
```

These are just the absolute basics, and might not seem impressive at first. But IoC containers and frameworks allow us to not just decouple our component, but also to maximize the flexibility of dependency creation.

The creation process becomes more configurable and enables new ways of using the dependencies, thanks to the advanced features provided.

#### Advanced features

The features vary widely between the different kinds of IoC containers and the underlying languages, like:

* [Proxy pattern](https://en.wikipedia.org/wiki/Proxy_pattern) and lazy-loading.
* Lifecycle scopes (e.g., singleton vs. one per thread).
* Auto-wiring.
* Multiple implementations for a single type.
* Circular dependencies.

These features are the real power of IoC containers. You might think features like “circular dependencies” are not a good idea. And you’re right.

But if we actually need such weird code constructs due to legacy code, or unchangeable bad design decisions in the past, we now have the power to do so.

## Conclusion

We should design our code against abstractions, like interfaces, and not concrete implementations, to reduce adhesion.

The only information our code should need must be available in the interface, we can’t assume anything about the actual implementation.

> # **“One should depend upon abstractions, [not] concretions.” 
> # **— Robert C. Martin (2000), Design Principles and Design Patterns

Dependency injection is a great way to do that by decoupling our components. It allows us to write cleaner and more concise code that’s easier to maintain and refactor.

Which of the three dependency injection types to choose depends much on the circumstances and requirements, but we can also mix the types to maximize the benefit.

IoC containers can provide another layout of convenience by simplifying the component creation process, sometimes in an almost magical way.

Should we use it everywhere? Of course not.

Just like other patterns and concepts, we should apply them if appropriate, not only because we can.

Never restrict yourself to a single way of doing things. Maybe the [factory pattern](https://en.wikipedia.org/wiki/Factory_method_pattern) or even the widely-loathed [singleton pattern](https://en.wikipedia.org/wiki/Singleton_pattern) might be a better solution for your requirements.

---

## Resources

* [Inversion of Control Containers and the Dependency Injection pattern](https://www.martinfowler.com/articles/injection.html) (Martin Fowler)
* [Dependency Inversion Principle](https://en.wikipedia.org/wiki/Dependency_inversion_principle) (Wikipedia)
* [Inversion of Control](https://en.wikipedia.org/wiki/Inversion_of_control) (Wikipedia)

---

## IoC Containers

#### Java

* [Dagger](https://dagger.dev/)
* [Spring](https://docs.spring.io/spring-framework/docs/current/spring-framework-reference/core.html#beans-introduction)
* [Tapestry](https://tapestry.apache.org/ioc.html)

#### Kotlin

* [Koin](https://insert-koin.io/)

#### Swift

* [Dip](https://github.com/AliSoftware/Dip)
* [Swinject](https://github.com/Swinject/Swinject)

#### C#

* [Autofac](https://autofac.org/)
* [Castle Windsor](http://www.castleproject.org/projects/windsor/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
