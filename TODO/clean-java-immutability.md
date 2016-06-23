>* 原文链接 : [Clean Java immutability](http://blog.alexsimo.com/clean-java-immutability/)
* 原文作者 : [Alexandru Simonescu](http://blog.alexsimo.com/clean-java-immutability/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


An immutable class is just a simple class whose instances cannot be modified. You provide all field values when creating the instance and they cannot be changed for the lifetime of the object. As you may probably know, Java already has some **immutable** types as _String_ (string concatenations is not efficient, remember?), _BigInteger_, _BigDecimal_.

Some good reasons to design immutable classes:

*   Easier to design, implement and use.
*   Less prone to errors.
*   More secure. Can be freely shared.
*   Are inherently thread-safe; they require no synchronization.

This brief blog post aims to give you an overview of different approaches to build and auto generate immutable classes on Java in a cleaner way. It will talk about two popular libraries focused on generating code: **Immutables** and **AutoValue**, also a bit of **Guava’s** immutables collections.

It’s not a comparative between them, as i think they are both great and it’s you who must choose the one who better adapts to your codebase and needs.

## Plain java immutables

To make your classes immutable, you should follow some basic steps:

*   **The class cant’t be extended.** Making the class _final_ should do the job, this way you prevent malicious subclassing that can alter his state.
*   **All fields are final.** As setting your fields as _final_ you will need to pass all the values through constructor or create a _builder pattern_.
*   **Make fields private.** I think it doesn’t need more explanation, if _public_ you can still access and change fields values.

Let’s see how a immutable class will look in Java:



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



All fields are **private and final**, as also the class, and there aren’t any mutations methods.

In case we need a method that returns instance of same class, you should always return a new instance. Imagine our **Autobot** class has a method called _fusion(Autobot)_ where it takes another _Autobot_ instance and makes a fusion between then.



    public Autobot fusion(Autobot autobot) {
      return new Autobot(name.concat(autobot.name()));  
    }



In the remaining article you will find some nice time saving tools for auto generating immutables structures. Why using code generators? Because it will save you time; are well tested; no magic involved, just generated code at buildtime; and you’ll be more happy.

> **Android**: For the next auto generation libraries, you will need configured the [APT](https://bitbucket.org/hvisser/android-apt) _(annotation processor tool)_ in Android Studio.

## Immutables library

Above you can see how to build an immutable class in plain Java. It really doesn’t require to write lot of code, but sometimes you have many fields, or maybe you’re using a **Builder pattern** and you’ll have to write lot of boilerplate code. That seems a perfect job for code generation tools!

Now let’s see how would we create an immutable class using [Immutables](http://immutables.github.io/) library.



    import org.immutables.value.Value;

    @Value.Immutable public abstract class Decepticon {

      public abstract String name();

      public abstract String fullname();

      public abstract Boolean leader();

      public abstract String group();
    }



Using the **@Immutable** annotation and a properly configured IDE, the library will build an immutable extension of the class. In case of **Immutables** it ads the **Immutable[NameOfClass]** prefix by default, but it let’s you configure the [generation style](http://immutables.github.io/style.html).



    ImmutableDecepticon decepticon = ImmutableDecepticon.builder()
            .name("Megatron")
            .fullname("Megatron Galvatron")
            .group("Decepticons")
            .leader(true)
            .build();



For the above **Decepticon** class, it generated a **280 lines immutable extension class** with also some very useful methods as _copyOf(Decepticon)_, _toString()_, _hashCode()_, _equals()_, and a nice **fluent builder** as you can see above.

A nice feature is that you can also declare you immutable type as **interfaces**.

That leds you to multiple extension between interfaces, simulating kind of multiple inheritance:



    @Value.Immutable public interface Transformer extends Autobot, Decepticon {
      // it will generate and fields extended from Autobot and Decepticon
    }



There are lot of more cool and useful features, if we don’t want a builder pattern we can simply indicate **Immutables** to generate a **constructor** with the fields we annotate.



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



Ah! **Immutables** it even supports Guava’s _Optional<t>_ type!</t>

## AutoValue library

**AutoValue** is a library built by the guys at Google and forms part of **Auto** project. A collection of source code generators for Java like **AutoFactory, AutoService** and some common utilities for writing code generators.

The key point as above, is simple. You write an **abstract class and AutoValue implements it**.

Same example class as above will be written like this:



    import com.google.auto.value.AutoValue;

    @AutoValue abstract class Autobot {

      abstract String name();

      abstract String fullname();

      abstract Boolean leader();

      abstract String group();
    }



After building the project, **AutoValue** would have auto generated the **AutoValue_Autobot** class.



    AutoValue_Autobot autobot =
            new AutoValue_Autobot("Bumblebee", "Bumblebee Autobot", false, "Autobot");



That’s nice but the usage of third party library as **AutoValue** shouldn’t be visible in your code. There’s a way to leave it cleaner and API invisible.



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



Now the creation of _Autobot_ instances becomes more API transparent.



    Autobot auto = Autobot.create("Bumblebee", "Bumblebee Autobot", false, "Autobot");



If you open the generated class, as Immutables library, it also generated **equals(), toString()** and **hashCode()** methods for you, it even does some parameters validation.



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



Builders can also be generated, perhaps it involves a bit more writing as **Immutables** but you may contrast benefits of both libraries and choose which one to use.

The usage of the _builder patterns_, in my opinion, makes your code more readable and clean.



    Decepticon decepticon = Decepticon.builder()
        .name("Kakuryu")
        .fullname("Kakuryu Decepticon")
        .leader(false)
        .group("Decepticons")
        .build();



Another great AutoValue feature are **extensions**, you can build your own extensions, i won’t explain here how to do it, out there are lot of interesting articles, like Jake’s Wharton [AutoValue Extensions](http://jakewharton.com/auto-value-extensions-ny-android-meetup/).

## Guava

**Guava** also offers lot of help while working with immutables classes, the difference is that **Guava won’t generate code for you**. It will just give you some immutable collections.

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



    public static final ImmutableSet<string> COLOR_NAMES = ImmutableSet.of(
      "red",
      "orange",
      "yellow",
      "green",
      "blue",
      "purple");

      final ImmutableSet<bar> bars = ImmutableSet.copyOf(bars); // defensive copy!



If interested in Guava, i gave an introductory talk called [“Cleaner code with Guava”](https://speakerdeck.com/alexsimo/cleaner-code-with-guava-v2), it also has an example repository.

### Interesting links

*   [Google’s AutoValue](https://github.com/google/auto/blob/master/value/userguide/index.md)
*   [Google’s Guava](https://github.com/google/guava)
*   [Immutables official](http://immutables.github.io/i)
*   [Power Use of Value Objects in DDD](https://www.infoq.com/presentations/Value-Objects-Dan-Bergh-Johnsson)
*   [Simple made easy](https://www.infoq.com/presentations/Simple-Made-Easy)

