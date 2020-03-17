> * 原文地址：[Decouple Your Code With Dependency Injection](https://medium.com/better-programming/decouple-your-code-with-dependency-injection-d893ae9edcf8)
> * 原文作者：[Ben Weidig](https://medium.com/@benweidig)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/decouple-your-code-with-dependency-injection.md](https://github.com/xitu/gold-miner/blob/master/TODO1/decouple-your-code-with-dependency-injection.md)
> * 译者：[江不知](http://jalan.space)
> * 校对者：

# 用依赖注入来解耦你的代码

> 无需第三方框架

![[Icons8 团队](https://unsplash.com/@icons8?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 摄于 [Unsplash](https://unsplash.com/s/photos/ingredients?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/12032/1*PfS1KYIt9IIDZTIyIIfMsQ.jpeg)

没有多少组件是不依赖于其它组件而独立存在的。除了创建紧密耦合的组件，我们还可以利用**依赖注入**（DI）来改善[关注点的分离](https://en.wikipedia.org/wiki/Separation_of_concerns)。

这篇文章将会脱离第三方框架向你介绍依赖注入的核心概念。文中使用 Java 书写所有代码示例，但所介绍的一般原则也适用于其它任何语言。

---

## 示例：数据处理器

To better visualize how to use dependency injection**,** we start with a simple type:
为了更好地看清如何使用依赖注入，我们从一个简单的类型开始：

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

`DataProcessor` 有两个依赖项：`DbManager` 和 `Calculator`。直接在我们的类型中创建它们有几个明显的缺点：

* 调用构造函数时可能发生崩溃
* 构造函数签名可能会改变
* 需要和显式实现类型紧密绑定

是时候改进它了！

---

## 依赖注入

[**《敏捷开发的艺术》**](https://www.amazon.com/Art-Agile-Development-Pragmatic-Software/dp/0596527675) 的作者 James Shore [很好地指出](https://www.jamesshore.com/Blog/Dependency-Injection-Demystified.html)：

> **“Dependency injection is a 25-dollar term for a 5-cent concept.”**

这个概念实际上非常简单：为组件提供完成其工作所需的一切。

通常，这意味着通过从外部提供组件的依赖关系来结偶组件，而非直接在组件内创建依赖，让组件间过度耦合。

我们可以通过多种方式为实例提供必要的依赖关系：

* 构造函数注入
* 属性注入
* 方法注入

#### 构造函数注入

构造函数注入，或称机遇初始化器的依赖注入，意味着在实例初始化期间提供所有必需的依赖项作为构造函数的参数：

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

由于这一简单的改变，我们可以弥补大多数最开始的缺点：

* 易于替换：`DbManager` 和 `Calculator` 不再绑定到具体的实例，现在可以模拟单元测试了。
* 已经初始化并且「准备就绪」：我们不必担心依赖项所需要的任何子依赖项（例如，数据库文件名、有效数字等），也不必担心它们可在初始化期间发生崩溃的可能性。
* 强制要求：调用方确切地知道创建 `DataProcessor` 的所需内容。
* 不变性：依赖关系始终如初。

尽管构造函数注入是许多依赖注入框架的首选方法，但它也有明显的缺点。其中最大的缺点是：必须在初始化时提供所有依赖项。

有时，我们无法自己初始化一个组件，或者在某个时刻我们无法提供所有的依赖关系。或者我们需要使用另外一个构造函数。一旦设置了依赖项，它们就无法再改变了。

但是我们可以使用其它注入类型来减少这些问题带来的影响。

#### 属性注入

Sometimes we don’t have access to the actual initialization of type, and only have an already initialized instance. Or the needed dependency is not explicitly known at initialization as it would be later on.
有时，我们无法访问类型的实际初始化（？），只能访问一个已经初始化的实例。或者在初始化时，所需要的依赖关系并不像之后那样明确。

在这些情况下，我们可以使用**属性注入**代替构造函数注入：

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

我们不再需要构造函数了，在初始化后我们可以随时提供依赖项。但这种注入方式也有缺点：**易变性**。

在初始化后，我们不再保证 `DataProcessor` 是「随时可用」的。能够随意更改依赖关系可能会给我们带来更大的灵活性，但同时也会带来运行时检查过多的缺点。

现在，我们必须在访问依赖项时处理出现 `NullPointerException` 的可能性。

#### 方法注入

Even though we decoupled the dependencies with constructor injection and/or property injection, by doing so, we still only have a single choice. What if we need another `Calculator` in some situations?
即使我们将依赖项与构造函数注入与/或属性注入分离，我们也仍然只有一个选择。

We don’t want to add additional properties or constructor arguments for a second `Calculator`, because there might be a third one needed in the future. And changing the property every time before we call `calc(...)` isn't feasible either, and will most likely lead to bugs using the wrong one.
我们不想为第二个 `Calculator` 类添加额外的属性或构造函数参数，因为将来可能会出现第三个这样的类。而且在每次调用 `calc(...)` 前更改属性也不可行，并且很可能因为使用错误的属性而导致 bug。

更好的方法是参数化调用方法本身及其依赖项：

```Java
public class DataProcessor {

    // ...

    public BigDecimal calc(Calculator calculator, BigDecimal input) {
        return calculator.expensiveCalculation(input);
    }
}
```

现在，`calc(...)` 的调用者负责提供一个合适的 `Calculator` 实例，并且 `DataProcessor` 类与之完全分离。

通过混合使用不同的注入类型来提供一个默认的 `Calculator` 可以获得更大的灵活性：

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

调用者**可以**提供另一种类型的 `Calculator`，但这不是**必须**的。我们仍然有一个解耦的、随时可用的 `DataProcessor`，它能够适应特定的场景。

## 选择哪种注入方式？

每种注入类型都有自己的优点，没有一种「正确的选择」。对注入方式的选择完全取决于你的实际需求和情况。

#### 构造函数注入

构造函数注入是我的最爱，它也常受 DI 框架的青睐。

它清楚地告诉我们创建特定组件所需的所有依赖关系，并且这些依赖不是可选的，整个组件中都需要这些依赖项。

#### 属性注入

属性注入更适合可选参数，例如监听或委托。又或是我们无法在初始化时提供依赖关系。

其它编程语言，例如 Swift，大量使用了带属性的 [委托模式](https://en.wikipedia.org/wiki/Delegation_pattern)。因此，使用属性注入将使其它语言的开发人员更熟悉我们的代码。

#### 方法注入

如果在每次调用时依赖项可能不同，那么使用方法注入最好不过了。方法注入进一步解耦组件，它使方法本身持有依赖项，而非整个组件。

请记住，这不是非此即彼。我们可以根据需要自由组合各种注入类型。

## 控制反转容器

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

#### 高级特性

The features vary widely between the different kinds of IoC containers and the underlying languages, like:

* [Proxy pattern](https://en.wikipedia.org/wiki/Proxy_pattern) and lazy-loading.
* Lifecycle scopes (e.g., singleton vs. one per thread).
* Auto-wiring.
* Multiple implementations for a single type.
* Circular dependencies.

These features are the real power of IoC containers. You might think features like “circular dependencies” are not a good idea. And you’re right.

But if we actually need such weird code constructs due to legacy code, or unchangeable bad design decisions in the past, we now have the power to do so.

## 总结

We should design our code against abstractions, like interfaces, and not concrete implementations, to reduce adhesion.

The only information our code should need must be available in the interface, we can’t assume anything about the actual implementation.

> **“One should depend upon abstractions, [not] concretions.” 
> **— Robert C. Martin (2000), Design Principles and Design Patterns

Dependency injection is a great way to do that by decoupling our components. It allows us to write cleaner and more concise code that’s easier to maintain and refactor.

Which of the three dependency injection types to choose depends much on the circumstances and requirements, but we can also mix the types to maximize the benefit.

IoC containers can provide another layout of convenience by simplifying the component creation process, sometimes in an almost magical way.

Should we use it everywhere? Of course not.

Just like other patterns and concepts, we should apply them if appropriate, not only because we can.

Never restrict yourself to a single way of doing things. Maybe the [factory pattern](https://en.wikipedia.org/wiki/Factory_method_pattern) or even the widely-loathed [singleton pattern](https://en.wikipedia.org/wiki/Singleton_pattern) might be a better solution for your requirements.

---

## 资料

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
