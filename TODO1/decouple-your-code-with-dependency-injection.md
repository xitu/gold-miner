> * 原文地址：[Decouple Your Code With Dependency Injection](https://medium.com/better-programming/decouple-your-code-with-dependency-injection-d893ae9edcf8)
> * 原文作者：[Ben Weidig](https://medium.com/@benweidig)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/decouple-your-code-with-dependency-injection.md](https://github.com/xitu/gold-miner/blob/master/TODO1/decouple-your-code-with-dependency-injection.md)
> * 译者：[江不知](https://juejin.im/user/5ae03306f265da0b702592d1)
> * 校对者：[GJXAIOU](https://github.com/GJXAIOU), [司徒公子](https://github.com/stuchilde)

# 用依赖注入解耦你的代码

> 无需第三方框架

![[Icons8 团队](https://unsplash.com/@icons8?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 摄于 [Unsplash](https://unsplash.com/s/photos/ingredients?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/12032/1*PfS1KYIt9IIDZTIyIIfMsQ.jpeg)

没有多少组件是能够独立存在而不依赖于其它组件的。除了创建紧密耦合的组件，我们还可以利用**依赖注入**（DI）来改善 [关注点的分离](https://en.wikipedia.org/wiki/Separation_of_concerns)。

这篇文章将会脱离第三方框架向你介绍依赖注入的核心概念。所有的示例代码都将使用 Java，但所介绍的一般原则也适用于其它任何语言。

---

## 示例：数据处理器

为了让如何使用依赖注入更加形象化，我们将从一个简单的类型开始：

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
* 紧密绑定到显式实现类型

是时候改进它了！

---

## 依赖注入

[**《敏捷开发的艺术》**](https://www.amazon.com/Art-Agile-Development-Pragmatic-Software/dp/0596527675) 的作者 James Shore [很好地指出](https://www.jamesshore.com/Blog/Dependency-Injection-Demystified.html)：

> **「依赖注入听起来复杂，实际上它的概念却十分简单。」**

依赖注入的概念实际上非常简单：为组件提供完成其工作所需的一切。

通常，这意味着通过从外部提供组件的依赖关系来解耦组件，而非直接在组件内创建依赖，让组件间过度耦合。

我们可以通过多种方式为实例提供必要的依赖关系：

* 构造函数注入
* 属性注入
* 方法注入

#### 构造函数注入

构造函数注入，或称基于初始化器的依赖注入，意味着在实例初始化期间提供所有必需的依赖项，将其作为构造函数的参数：

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

* 易于替换：`DbManager` 和 `Calculator` 不再被具体的实现所束缚，现在可以模拟单元测试了。
* 已经初始化并且「准备就绪」：我们不必担心依赖项所需要的任何子依赖项（例如，数据库文件名、[有效数字（译者注）](https://zh.wikipedia.org/wiki/%E6%9C%89%E6%95%88%E6%95%B0%E5%AD%97)等），也不必担心它们可在初始化期间发生崩溃的可能性。
* 强制要求：调用方确切地知道创建 `DataProcessor` 的所需内容。
* 不变性：依赖关系始终如初。

尽管构造函数注入是许多依赖注入框架的首选方法，但它也有明显的缺点。其中最大的缺点是：必须在初始化时提供所有依赖项。

有时，我们无法自己初始化一个组件，或者在某个时刻我们无法提供组件的所有依赖关系。或者我们需要使用另外一个构造函数。一旦设置了依赖项，我们就无法再改变它们了。

但是我们可以使用其它注入类型来缓解这些问题。

#### 属性注入

有时，我们无法访问类型实际的初始化方法，只能访问一个已经初始化的实例。或者在初始化时，所需要的依赖关系并不像之后那样明确。

在这些情况下，我们可以使用**属性注入**而不是依赖于构造函数：

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

即使我们将依赖项与构造函数注入与/或属性注入分离，我们也仍然只有一个选择。如果在某些情况下我们需要另一个 `Calculator` 该怎么办呢？

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

通过混合使用不同的注入类型来提供一个默认的 `Calculator`，这样可以获得更大的灵活性：

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

每种依赖注入类型都有自己的优点，并没有一种「正确的方法」。具体的选择完全取决于你的实际需求和情况。

#### 构造函数注入

构造函数注入是我的最爱，它也常受依赖注入框架的青睐。

它清楚地告诉我们创建特定组件所需的所有依赖关系，并且这些依赖不是可选的，这些依赖关系在整个组件中应该都是必需的。

#### 属性注入

属性注入更适合可选参数，例如监听或委托。又或是我们无法在初始化时提供依赖关系。

其它编程语言，例如 Swift，大量使用了带属性的 [委托模式](https://en.wikipedia.org/wiki/Delegation_pattern)。因此，使用属性注入将使其它语言的开发人员更熟悉我们的代码。

#### 方法注入

如果在每次调用时依赖项可能不同，那么使用方法注入最好不过了。方法注入进一步解耦组件，它使方法本身持有依赖项，而非整个组件。

请记住，这不是非此即彼。我们可以根据需要自由组合各种注入类型。

## 控制反转容器

这些简单的依赖注入实现可以覆盖很多用例。依赖注入是很好的解耦工具，但事实上我们仍然需要在某些时候创建依赖项。

但随着应用程序和代码库的增长，我们可能还需要一个更完整的解决方案来简化依赖注入的创建和组装过程。

**控制反转**（IoC）是 [控制流](https://en.wikipedia.org/wiki/Control_flow) 的抽象原理。依赖注入是控制反转的具体实现之一。

**控制反转容器**是一种特殊类型的对象，它知道如何实例化和配置其它对象，它也知道如何帮助你执行依赖注入。

有些容器可以通过反射来检测关系，而另一些必须手动配置。有些容器基于运行时，而有些则在编译时生成所需要的所有代码。

比较所有容器的不同之处超出了本文的讨论范围，但是让我通过一个小示例来更好地理解这个概念。

#### 示例: Dagger 2

[Dagger](https://dagger.dev/) 是一个轻量级、编译时进行依赖注入的框架。我们需要创建一个 `Module`，它就知道如何构建我们的依赖项，稍后我们只要添加 `@Inject` 注释就可以注入这个 `Module`。

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

`@Singleton` 确保只能创建一个依赖项的实例。

要注入依赖项，我们只需要将 `@Inject` 添加到构造函数、字段或方法中。

```Java
public class DataProcessor {

    @Inject
    DbManager manager;
    
    @Inject
    Calculator calculator;

    // ...
}
```

这些仅仅是一些基础知识，乍一看不可能会给人留下深刻的印象。但是控制反转容器和框架不仅解耦了组件，也让创建依赖关系的灵活性得以最大化。

由于提供了高级特性，创建过程的可配置性变得更强，并且支持了使用依赖项的新方法。

#### 高级特性

这些特性在不同类型的控制反转容器和底层语言之间差异很大，比如：

* [代理模式](https://en.wikipedia.org/wiki/Proxy_pattern) 和延迟加载。
* 生命周期（例如：单例模式与每个线程一个实例）。
* 自动绑定。
* 单一类型的多种实现。
* 循环依赖。

这些特性是控制反转容器真正的能力。你可能会认为诸如「循环依赖」这样的特性并非好的主意，确实如此。

但是，如果由于遗留代码或是过去不可更改的错误设计而需要这种奇怪的代码构造，那么我们现在有能力可以这样做。

## 总结

我们应该根据抽象（例如接口）而不是具体的实现来设计代码，这样可以帮助我们减少代码耦合。

接口必须提供我们代码所需要的唯一信息，我们不能对实际实现情况做任何假设。

> **「程序应当依赖抽象，而非具体的实现」**
> —— Robert C. Martin (2000), 《设计原则与设计模式》

依赖注入是通过解耦组件来实现这一点的好办法。它使我们能够编写更简洁明了、更易于维护和重构的代码。

选择三种依赖注入类型中的哪种很大程度上取决于环境和需求，但是我们也可以混合使用三种类型使收益最大化。

控制反转容器有时几乎以一种神奇的方式通过简化组件创建过程来提供另一种便利的布局。

我们应该处处使用它吗？当然不是。

就像其它模式和概念一样，我们应该在适当的时候应用它们，而不是能用则用。

永远不要把自己局限在一种做事的方式上。也许 [工厂模式](https://en.wikipedia.org/wiki/Factory_method_pattern) 甚至是广为厌恶的 [单例模式](https://en.wikipedia.org/wiki/Singleton_pattern) 是能够满足你需求的更好的解决方案。

---

## 资料

* [控制反转容器与依赖注入模式](https://www.martinfowler.com/articles/injection.html) (Martin Fowler)
* [依赖反转原则](https://en.wikipedia.org/wiki/Dependency_inversion_principle)（维基百科）
* [控制反转](https://en.wikipedia.org/wiki/Inversion_of_control)（维基百科）

---

## 控制反转容器

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
