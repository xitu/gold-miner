> * 原文地址：[Top 10 Java Language Features](https://foojay.io/today/top-10-java-language-features/)
> * 原文作者：[A N M Bazlur Rahman](https://foojay.io/today/author/bazlur-rahman/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/top-10-java-language-features.md](https://github.com/xitu/gold-miner/blob/master/article/2022/top-10-java-language-features.md)
> * 译者：[jaredliw](https://github.com/jaredliw)
> * 校对者：[Quincy-Ye](https://github.com/Quincy-Ye)

# 十大 Java 语言特性

每种编程语言都提供了表达我们的想法并将其转化为现实的方式。

其中一些特性是某些语言独有的，而另一些特性则是大多数语言相通的。

在本文中，我们将探讨开发人员在日常编程工作中经常使用的十个 Java 语言特性。

## `Collection` 的工厂方法

`Collection` 是我们每天写代码中最常用到的特性。它用于作为一种储存和传递多个对象的容器。

`Collection` 也能用于排序、搜索和遍历对象，让我们的工作更轻松些。它提供了几个基本的接口，如 `List`、`Set`、`Map` 等。

对于很多开发者来说，传统的创建 `Map` 的方法可能看起来很冗长。

正因如此，Java 9 引入了一些非常简洁的工厂方法。

**List：**

```java
List countries = List.of("Bangladesh", "Canada", "United States", "Tuvalu");
```

**Set：**

```java
Set countries = Set.of("Bangladesh", "Canada", "United States", "Tuvalu");
```

**Map: **

```java
Map<String, Integer> countriesByPopulation = Map.of("Bangladesh", 164_689_383,
                                                    "Canada", 37_742_154,
                                                    "United States", 331_002_651,
                                                    "Tuvalu", 11_792);
```

当我们想要创建不可变容器时，这些方法非常方便。但是，如果是可变集合，我还是建议使用传统的方法。

如果你想要了解更多关于集合框架的内容，请访问：[Java 官方教程 —— 集合框架](https://dev.java/learn/the-collections-framework/)。

## 局部变量类型推断

Java 10 引入了局部变量类型推断（LVTI）。这对开发者来说真的非常方便！

传统上，Java 是一种强类型语言，开发人员在声明和初始化对象时必须两次指定类型。这似乎很乏味。看看下面的例子：

```java
Map<String, Map<String, Integer>> properties = new HashMap<>();
```

在上方代码的中，我们在语句的左右两边都指明了变量类型。如果我们在一个地方定义它，我们很容易理解这必须是一个 `Map` 类型。Java 语言已经很成熟了，编译器应该足够智能地去识别这一点。LVTI 特性做的正是这一点。上方的代码可以这样写：

```java
var properties = new HashMap<String, Map<String, Integer>>(); 
```

现在我们只需要写一次类型了。这似乎也没好太多。但是，当我们调用方法并将结果存储在变量中时，它会缩短很多。例如：

```java
var properties = getProperties();
```

类似地，

```java
var countries = Set.of("Bangladesh", "Canada", "United States", "Tuvalu");
```

虽然这看起来是个方便的特性，但它也备受诟病。一些开发者认为：LVTI 可能会降低可读性，这可比那一点点的便利重要得多。

更多资讯请看：

* [Open JDK —— LVTI 常问问题](https://openjdk.java.net/projects/amber/guides/lvti-faq)
* [Open JDK —— LVTI 编码风格指南](https://openjdk.java.net/projects/amber/guides/lvti-style-guide)

## 增强的 `switch` 语句

传统的 `switch` 语句从一开始就存在了，类似于 C 和 C++。过去，它没啥问题，但随着语言的发展，在 Java 14 发布之前，它一直都没有什么改进。`switch` 语句也确实一直存在一些局限性，其中最臭名昭著的就属[穿透问题](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/switch.html)

为了解决这个问题，我们需要使用许多的 `break` 语句，它们几乎成为了模板代码。然而，Java 14 引入了一个看待 `switch` 语句的方式，并提供了更丰富的功能。

我们不再需要添加 `break` 语句，新特性解决了穿透问题。最重要的是，`switch` 语句可以返回值了。这意味着我们可以将 `switch` 语句作为一个表达式并赋值给变量。

```java
int day = 5;
String result = switch (day) {
    case 1, 2, 3, 4, 5 -> "Weekday";
    case 6, 7 -> "Weekend";
    default -> "Unexpected value: " + day;
};
```

* 阅读更多：[Java 官方教程 —— 分支结构与 `switch` 表达式](https://dev.java/learn/branching-with-switch-expressions/)。

## `Record` 类

尽管 `Record` 类是 Java 中相对较新的功能（在 Java 16 中发布），但许多开发人员发现在创建不可变的 `Record` 对象非常有用。

通常，我们需要在程序中使用数据载体对象来保存或将值从一种方法传递到另一种方法。举例来说，一个带有 x、y、z 轴数据的类可以这么写：

```java
import java.util.Objects;

public final class Point {
    private final int x;
    private final int y;
    private final int z;

    public Point(int x, int y, int z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    public int x() {
        return x;
    }

    public int y() {
        return y;
    }

    public int z() {
        return z;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (Point) obj;
        return this.x == that.x &&
                this.y == that.y &&
                this.z == that.z;
    }

    @Override
    public int hashCode() {
        return Objects.hash(x, y, z);
    }

    @Override
    public String toString() {
        return "Point[" +
                "x=" + x + ", " +
                "y=" + y + ", " +
                "z=" + z + ']';
    }
}
```

整个类看起来超级冗长且和我们的想实现的东西关系不大。可以将上面的代码改成下面的写法：

```java
public record Point(int x, int y, int z) {
}
```

* 阅读更多有关记录类的资讯: [niparfx 的部落格 —— Java `Record` 类语义](https://nipafx.dev/java-record-semantics/)。

## `Optional` 类

方法是一种约定：在定义方法时我们需要考虑到这一点。我们指定了一个方法的参数以及返回类型。当我们调用它时，我们期望它按照约定行事。如果没有，它则违反了约定。

然而，我们经常从一个方法中得到返回值 `null`，而不是先前所指定的类型。这是一种打破规矩的行为。调用者不能预先知道，除非它调用了该方法。为了解决这个问题，调用者通常用一个 `if` 条件来测试返回值是否为 `null`。例子：

```java
public class Playground {

    public static void main(String[] args) {
        String name = findName();
        if (name != null) {
            System.out.println("Length of the name : " + name.length());
        }
    }

    public static String findName() {
        return null;
    }
}
```

瞧瞧上面的代码。`findName()` 方法应该返回一个 `String` 值，但它却返回了 `null`。调用者现在必须先检查空值后再处理这个值。如果调用者忘记那么做了，它可能会得到一个预料之外的 `NullPointerException` 异常。

另一方面，如果方法签名能说明方法有不返回值的可能性，所有的困惑将迎刃而解。这正是 `Optional` 类发挥作用的地方。

```java
import java.util.Optional;

public class Playground {

    public static void main(String[] args) {
        Optional<String> optionalName = findName();
        optionalName.ifPresent(name -> {
            System.out.println("Length of the name : " + name.length());
        });
    }

    public static Optional<String> findName() {
        return Optional.empty();
    }
}
```

现在我们用 `Optional` 类重写了 `findName()` 方法，说明了方法有不返回任何值的可能性。这给了程序员一个预先的警告，并解决了违反约定的问题。

* [阅读更多有关 `Optional` 类的内容](https://dzone.com/articles/optional-in-java)。

## 日期和时间的 API

每个开发人员都在某种程度上对日期和时间计算感到困惑。我所说的并不夸张。这主要是由于长期以来没有一个好的 Java API 来处理日期和时间。

然而，这个问题已经不复存在，因为 Java 8 在 **java.time** 包中带来了一套优秀的 API，解决了所有与日期和时间有关的问题。

**java.time** 包提供了许多的接口和类，解决了大多数处理日期和时间的问题，包括时区（在某些时候，这东西是令人抓狂的复杂）。其中常用的类有：

* `LocalDate`
* `LocalTime`
* `LocalDateTime`
* `Duration`
* `Period`
* `ZonedDateTime `等等

这些类囊括了所有常用的方法，例如：

```java
import java.time.LocalDate;
import java.time.Month;

public class Playground {
    
    public static void main(String[] args) {
        LocalDate date = LocalDate.of(2022, Month.APRIL, 4);
        System.out.println("year = " + date.getYear());
        System.out.println("month = " + date.getMonth());
        System.out.println("DayOfMonth = " + date.getDayOfMonth());
        System.out.println("DayOfWeek = " + date.getDayOfWeek());
        System.out.println("isLeapYear = " + date.isLeapYear());
    }
}
```

同样地，`LocalTime` 也有所有用于计算时间的方法。

```java
LocalTime time = LocalTime.of(20, 30);
int hour = time.getHour(); 
int minute = time.getMinute(); 
time = time.withSecond(6); 
time = time.plusMinutes(3);
```

我们可以将两者组合起来使用：

```java
LocalDateTime dateTime1 = LocalDateTime.of(2022, Month.APRIL, 4, 20, 30);
LocalDateTime dateTime2 = LocalDateTime.of(date, time);
```

如何加上时区：

```java
ZoneId zone = ZoneId.of("Canada/Eastern");
LocalDate localDate = LocalDate.of(2022, Month.APRIL, 4);
ZonedDateTime zonedDateTime = date.atStartOfDay(zone);
```

* [阅读更多有关 Java 日期和时间的内容](https://docs.oracle.com/javase/tutorial/datetime/TOC.html)。

## 增强 `NullPointerException` 的错误信息

每个开发者都痛恨空指针异常。当栈追踪没有提供任何有用的信息时，事情就变得更有挑战性了。为了演示这个问题，让我们来看一段代码：

```java
package com.bazlur;

public class Playground {

    public static void main(String[] args) {
        User user = null;
        getLengthOfUsersName(user);
    }

    public static void getLengthOfUsersName(User user) {
        System.out.println("Length of first name: " + user.getName().getFirstName());
    }
}

class User {
    private Name name;
    private String email;

    public User(Name name, String email) {
        this.name = name;
        this.email = email;
    }

   // getter
   // setter
}

class Name {
    private String firstName;
    private String lastName;

    public Name(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
    }

   // getter
   // setter
}
```

看看上方代码中的 `main()` 方法。我们可以预测到我们会得到一个空指针异常。如果我们在 Java 14 之前的环境中编译及运行这段代码，我们会得到下面这段栈追踪：

```
Exception in thread "main" java.lang.NullPointerException
at com.bazlur.Main.getLengthOfUsersName(Main.java:11)
at com.bazlur.Main.main(Main.java:7)
```

这个栈追踪没什么问题，但它并没有告诉我们 `NullPointerException` 发生的位置和原因。

然而，在 Java 14 及更高的版本中，我们会在栈追踪中得到更多的信息，非常方便。

```
Exception in thread "main" java.lang.NullPointerException: Cannot invoke "ca.bazlur.playground.User.getName()" because "user" is null
at ca.bazlur.playground.Main.getLengthOfUsersName(Main.java:12)
at ca.bazlur.playground.Main.main(Main.java:8)
```

* [阅读更多](https://openjdk.java.net/jeps/358)。

## `CompletableFuture`

我们一行行地编写代码，程序一行行地执行它们。然而，有些时候，我们希望它相对并行地执行，使得程序能快一些。为了达到这个目的，我们通常会考虑使用 Java 线程。

Java 线程编程并不总是与并行编程有关。相反，它提供了一种方法，使程序的多个单元能独立执行，与其他单元同时进展。不仅如此，它们通常是异步运行的。

可是，线程编程及其错综复杂的问题似乎很可怕。大多数开发人员都为此而挣扎。这就是为什么 Java 8 带来了一个更直接的 API，让我们完成部分程序的异步运行。让我们看一个例子。

假设我们要调用三个 REST API，然后把结果组合起来。我们可以逐个调用它们。如果它们每个都需要 200 毫秒左右，那么获取所有结果的总时间就是 600 毫秒。

如果我们并行地运行它们呢？由于现代的 CPU 有多个核，它可以很容易地在不同的核上处理三个 REST 调用。使用 `CompletableFuture`，我们可以很轻易地完成这个任务。

```java
import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

public class SocialMediaService {
    
    public static void main(String[] args) throws ExecutionException, InterruptedException {
        var service = new SocialMediaService();

        var start = Instant.now();
        var posts = service.fetchAllPost().get();
        var duration = Duration.between(start, Instant.now());

        System.out.println("Total time taken: " + duration.toMillis());
    }

    public CompletableFuture<List<String>> fetchAllPost() {
        var facebook = CompletableFuture.supplyAsync(this::fetchPostFromFacebook);
        var linkedIn = CompletableFuture.supplyAsync(this::fetchPostFromLinkedIn);
        var twitter = CompletableFuture.supplyAsync(this::fetchPostFromTwitter);

        var futures = List.of(facebook, linkedIn, twitter);

        return CompletableFuture.allOf(futures.toArray(futures.toArray(new CompletableFuture[0])))
                .thenApply(future -> futures.stream()
                        .map(CompletableFuture::join)
                        .toList());
    }
    private String fetchPostFromTwitter() {
        sleep(200);
        return "Twitter";
    }

    private String fetchPostFromLinkedIn() {
        sleep(200);
        return "LinkedIn";
    }

    private String fetchPostFromFacebook() {
        sleep(200);
        return "Facebook";
    }

    private void sleep(int millis) {
        try {
            TimeUnit.MILLISECONDS.sleep(millis);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }
    }
}
```

* [阅读更多：Java 异步编程与 `CompletableFuture`](https://www.linkedin.com/pulse/asynchronous-programming-java-completablefuture-aliaksandr-liakh/)。

## lambda 表达式

lambda 表达式或许是 Java 语言中最强大的特性。它重塑了我们编写代码的方式。一个 lambda 表达式是一个接受参数并返回值的匿名函数。

我们可以将函数赋值给一个变量，也可以将其作为参数传递给方法。lambda 表达式有函数体，和方法唯一的差别是它没有名字。

lambda 表达式短小精悍，通常不需要样板代码。让我们看一个例子：

我们想要列出所有扩展名是 `.java` 的文件。

```java
var directory = new File("./src/main/java/ca/bazlur/playground");
String[] list = directory.list(new FilenameFilter() {
    @Override
    public boolean accept(File dir, String name) {
        return name.endsWith(".java");
    }
});
```

仔细看看上方的代码，我们将一个匿名内部类传给了 `list()` 方法。在内部类中，我们编写了过滤文件的逻辑。

本质上，我们只对这段逻辑感兴趣，而不是那些样板代码。

lambda 表达式能让我们移除所有的样板代码，我们只需把重心放在主要的逻辑上。例子：

```java
var directory = new File("./src/main/java/ca/bazlur/playground");
String[] list = directory.list((dir, name) -> name.endsWith(".java"));
```

我这里只展示了其中一个示例，但 lambda 表达式还有很多其他的好处。

* [阅读更多有关 lambda 表达式的内容](https://dev.java/learn/lambda-expressions/)。

## Stream API

> “在 Java 8 中，lambda 表达式只是药引子，Stream API 才是真正的处方。” —— Venkat Subramaniam

在日常的编程工作中，我们经常需要做的一项任务是处理一组组的数据。一些常见的操作有：过滤、转换和收集结果。

在 Java 8 之前，这些操作一直以来都是命令式的。我们需要表示清楚我们的意图（也就是我们想达成的东西）和方式。

随着 lambda 表达式和 Stream API 的引入，我们可以以声明的形式来编写数据处理的代码。我们只需指明意图，而不必编写如何得到结果。让我们看个例子：

我们有一个书籍列表。我们想要找到所有 Java 书籍的名称，排序，并用逗号分隔。

```java
public static String getJavaBooks(List<Book> books) {
    return books.stream()
            .filter(book -> Objects.equals(book.language(), "Java"))
            .sorted(Comparator.comparing(Book::price))
            .map(Book::name)
            .collect(Collectors.joining(", "));
}
```

上方的代码简单、易读还简洁。另一种命令式的写法是：

```java
public static String getJavaBooksImperatively(List<Book> books) {
    var filteredBook = new ArrayList<Book>();
    for (Book book : books) {
        if (Objects.equals(book.language(), "Java")){
            filteredBook.add(book);
        }
    }
    filteredBook.sort(new Comparator<Book>() {
        @Override
        public int compare(Book o1, Book o2) {
            return Integer.compare(o1.price(), o2.price());
        }
    });

    var joiner = new StringJoiner(",");
    for (Book book : filteredBook) {
        joiner.add(book.name());
    }
    
    return joiner.toString();
}
```

虽然两个方法都返回了相同的值，但两者之间的差别是显而易见的。

学习更多有关流 API：

- [Java 官方教程 —— Stream API](https://dev.java/learn/the-stream-api/)
- [jenkov 教程 —— Java Stream API](https://jenkov.com/tutorials/java-functional-programming/streams.html)

这就是今天的全部内容。拜拜！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。