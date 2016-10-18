>* 原文链接 : [Clean Java immutability](http://blog.alexsimo.com/clean-java-immutability/)
* 原文作者 : [Alexandru Simonescu](http://blog.alexsimo.com/clean-java-immutability/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [buccoji] (https://github.com/buccoji)
* 校对者: [WuHaojie] (https://github.com/a-voyager), [jamweak] (https://github.com/jamweak)

# Java 不可变类的整洁之道

当一个普通类 (class) 的实例不能被修改时，我们便称之为「不可变类」(immutable class)。这样的类在实例化时便需要提供其所有的值，而在之后的运行中便绝不可更改。比如大家可能都知道的 Java 中已有的一些**不可变**类型，_String_ (string 的字符串联很没效率，对吧), _BigInteger_, 和 BigDecimal_。

设计一个不可变类有如下的好处：

*   更简明的设计、实现、和使用
*   更不容易出错
*   更安全，因此可以轻松分享
*   线程安全，无需同步锁

本篇短文希望能够帮助你通过各种不同的方法在 Java 中更简洁地创建和生成不可变类。我们会谈到两种最常见代码生成库：**Immutables** 和 **AutoValue**，以及 **Guava’s** 中的一些不可变集合 (collection)。

我个人认为这两种库各有千秋，所以本文并不会去比较这两者。你应当根据自己的代码库和实际需求来决定选择更适合你的那一个。

## 普通 Java 不可变类

将一个类变为「不可变」类有以下几项基本步骤：

*   **不可继承** 为类添加 _final_ 修饰即可，这样可预防恶意代码通过继承来改变该类的任何状态。
*   **所有类变量都不可更改.** 将变量全都设置为 final 时，所有的值都需要通过在构造函数中便传入，或者另建立一个*生成器模式* (builder pattern)。
*   **将所有类变量都设置为私有 (private).** 显然，如果仍然设置为公共 (public)，这些类变量的值都有可能被读取和修改。

在 Java 中使用不可变类:



    public final class Autobot {

      private final String name;
      private final String fullname;
      private final Boolean leader;
      private final String group;

      public Autobot(String name, String fullname, Boolean leader, String group) {
        this.name = name;
        this.fullname = fullname;
        this.leader = leader;
        this.group = group;
      }

      public String name() {
        return name;
      }

      public String fullname() {
        return fullname;
      }

      public Boolean leader() {
        return leader;
      }

      public String group() {
        return group;
      }
    }



所有类值都是 **private 和 final**，类本身也是 *final*，且没有任何可变函数。

当需要一个能返回某类实例的函数时，则一定要返回一个全新的实例。假设此处的 **Autobot** 类有一个 _fusion(Autobot)_ 函数，且传入给它另一个 _Autobot_ 的话，它便会融合这两个 Autobot。


    public Autobot fusion(Autobot autobot) {
      return new Autobot(name.concat(autobot.name()));  
    }



本文将会提供一些能够帮助你节省时间的不可变类结构自动生成工具。之所以需要代码自动生成，是因为它省时，且通过了周全的测试，其中也没有难懂的部分，只是在建构时便自动生成，何乐而不为呢。

> **Android**: 以下自动生成库需要在 Android Studio 中设置此处的 *注释处理工具* (annotation processor tool
) [APT](https://bitbucket.org/hvisser/android-apt)。

## Immutables 库

以上代码示范了如何在单纯 Java 环境下建造一个不可变类。虽然需要真正去写的代码并不多，但当代码中有许多类变量或代码本身采用的是*生成器模式*时，模版代码 (boilerplate code) 的书写量便会大增，而这不正好是代码生成工具擅长的！

以下将示范如何通过 [Immutables](http://immutables.github.io/) 库来生成不可变类：


    import org.immutables.value.Value;

    @Value.Immutable public abstract class Decepticon {

      public abstract String name();

      public abstract String fullname();

      public abstract Boolean leader();

      public abstract String group();
    }



通过在设置好的 IDE 中添加 **@Immutable** 注释后，Immutables 库便会为该类自动添加不可变拓展。**Immutable[类名]** 将会作为缺省前缀自动添加，不过你也可以自己设置其他的[生成方式](http://immutables.github.io/style.html)。

    ImmutableDecepticon decepticon = ImmutableDecepticon.builder()
            .name("Megatron")
            .fullname("Megatron Galvatron")
            .group("Decepticons")
            .leader(true)
            .build();



以上这个 **Deception** 类将会生成 **280 行的不可变拓展类**，且提供一些非常实用的函数，例如 _copyOf(Deception)_，_toString()_，_hashCode()_，_equals()，以及一个好用且**流畅的**生成器 (builder)。

不仅如此，不可变型还可以声明为**接口**。

这样便可以在接口之间实现多个拓展，以达到仿多重继承的效果：


    @Value.Immutable public interface Transformer extends Autobot, Decepticon {
      // it will generate and fields extended from Autobot and Decepticon
    }



还有其他一些有趣实用的特点，例如如果我们不想用生成器模式时，只要通过 **Immutables** 注解那些类变量来标记**构造函数**即可。


    import org.immutables.value.Value;

    @Value.Immutable public interface Car {

      enum MotorType {
        DIESEL,
        GAS
      }

      @Value.Parameter String manufacturer();

      @Value.Parameter MotorType motorType();
    }

    // create instance
    ImmutableCar car = new ImmutableCar("Nissan", Car.MotorType.GAS);



更重要的是! **Immutables** 甚至支持 Guava’s 的 _Optional<t>_ 类型!</t>

## AutoValue 库

**AutoValue** 是由 Google 的员工所创建，且是 **Auto** 计划的一部分。它包括了许多 Java 自动生成的源代码，例如 **AutoFactory, AutoService** 和其他一些常用的代码生成工具。

简而言之，你可以**只写抽象类，让 AutoValue 帮你实现它**。

之前同样的例子便可以修改为：


    import com.google.auto.value.AutoValue;

    @AutoValue abstract class Autobot {

      abstract String name();

      abstract String fullname();

      abstract Boolean leader();

      abstract String group();
    }



编译后，**AutoValue** 就会自动生成一个 **AutoValue_Autobot** 类。



    AutoValue_Autobot autobot =
            new AutoValue_Autobot("Bumblebee", "Bumblebee Autobot", false, "Autobot");



虽然效果很好，但也应该避免在自己的代码中显示 **AutoValue** 这样的第三方代码库。以下方法可以让代码更简明易懂，且隐藏 API。



    import com.google.auto.value.AutoValue;

    @AutoValue abstract class Autobot {

      public static Autobot create(String name, String fullname, Boolean leader, String group) {
        return new AutoValue_Autobot(name, fullname, leader, group);
      }

      abstract String name();

      abstract String fullname();

      abstract Boolean leader();

      abstract String group();
    }



这样的话，创建 _Autobot_ 时便能更好的隐藏 API。



    Autobot auto = Autobot.create("Bumblebee", "Bumblebee Autobot", false, "Autobot");



如同 Immutables 库，当我们查看生成后的类时会发现，它也同样自动生成了 **equals(), toString()** 和 **hashCode()** 函数，甚至还有参数验证。


    import com.google.auto.value.AutoValue;

    @AutoValue abstract class Decepticon {

      abstract String name();

      abstract String fullname();

      abstract Boolean leader();

      abstract String group();

      static Builder builder() {
        return new AutoValue_Decepticon.Builder();
      }

      @AutoValue.Builder abstract static class Builder {
        abstract Builder name(String name);

        abstract Builder fullname(String fullname);

        abstract Builder leader(Boolean leader);

        abstract Builder group(String group);

        abstract Decepticon build();
      }
    }



同样，你也可以生成 builder，虽然如果採用 **Immuables** 可能会需要写一点额外的代码，不过你可以对比一下两者的优点来决定採用哪一个。

我个人认为*生成器模式*会让代码更干净易读：


    Decepticon decepticon = Decepticon.builder()
        .name("Kakuryu")
        .fullname("Kakuryu Decepticon")
        .leader(false)
        .group("Decepticons")
        .build();



AutoValue的另一个强大功能是它的各种**拓展**，你可以创建一个自己的拓展。本文难以赘述这个功能，但是有很多其他不错的文章你可以参考，例如 Jake’s Wharton 的 [AutoValue Extensions](http://jakewharton.com/auto-value-extensions-ny-android-meetup/).

## Guava

也可以提供许多不可变类的帮助，不同之处在于 **Guava 不会为你生成代码**，它只是提供一些不可变的集合：

*   ImmutableList
*   ImmutableSet
*   ImmutableSortedSet
*   ImmutableMap
*   ImmutableSortedMap
*   ImmutableMultiset
*   ImmutableSortedMultiset
*   ImmutableMultimap
*   ImmutableListMultimap
*   ImmutableSetMultimap
*   ImmutableBiMap
*   ImmutableClassToInstanceMap
*   ImmutableTable

The usage is based on static classes, iterators and helpers.
以上都是静态的类、迭代器 (iterator)、或工具类(helper)。



    public static final ImmutableSet<string> COLOR_NAMES = ImmutableSet.of(
      "red",
      "orange",
      "yellow",
      "green",
      "blue",
      "purple");

      final ImmutableSet<bar> bars = ImmutableSet.copyOf(bars); // 防御性复制!



如果你对 Guava 有兴趣，可以参考我的一个相关演讲，名为 [“Guava 的简洁代码之道”](https://speakerdeck.com/alexsimo/cleaner-code-with-guava-v2)，它也有示例代码库。

### 相关链接

*   [Google 的 AutoValue](https://github.com/google/auto/blob/master/value/userguide/index.md)
*   [Google 的 Guava](https://github.com/google/guava)
*   [Immutables 官方代码库](http://immutables.github.io/i)
*   [DDD 中值对象的强大用处](https://www.infoq.com/presentations/Value-Objects-Dan-Bergh-Johnsson)
*   [简即是便](https://www.infoq.com/presentations/Simple-Made-Easy)

