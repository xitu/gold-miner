> * 原文地址：[Top 10 Java Language Features](https://foojay.io/today/top-10-java-language-features/)
> * 原文作者：[A N M Bazlur Rahman](https://foojay.io/today/author/bazlur-rahman/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2022/top-10-java-language-features.md](https://github.com/xitu/gold-miner/blob/master/article/2022/top-10-java-language-features.md)
> * 译者：
> * 校对者：

# Top 10 Java Language Features

Every programming language provides ways to express our ideas and then translate them into reality.

Some are unique to that particular language and some are common to many other programming languages.

In this article, I will explore ten Java programming features used frequently by developers in their day-to-day programming jobs.

## Collection’s Factory Method

Collections are the most frequently used feature in our daily coding. They are used as a container where we store objects and pass them along.

Collections are also used to sort, search, and iterate objects, making the programmer's life easier. It provides a few basic interfaces, such as List, Set, Map, etc., and multiple implementations.

The traditional way of creating `Collections` and `Maps` may look verbose to many developers.

That’s why Java 9 introduced a few very concise factory methods.

**List:**

`List countries = List.of("Bangladesh", "Canada", "United States", "Tuvalu"); `

**Set:**

`Set countries = Set.of("Bangladesh", "Canada", "United States", "Tuvalu"); `

**Map:**

```java
Map<String, Integer> countriesByPopulation = Map.of("Bangladesh", 164_689_383,
                                                    "Canada", 37_742_154,
                                                    "United States", 331_002_651,
                                                    "Tuvalu", 11_792);
```

  

These are very convenient when we want to create immutable containers. However, if we're going to create mutable collections, the traditional approach is advised.

If you want to learn more about the collection framework, please visit here: [The collection framework](https://dev.java/learn/the-collections-framework/).

## Local Type Inference

Java 10 introduced type inference for local variables, which is super convenient for developers.

Traditionally, Java is a strongly typed language, and developers have to specify types twice while declaring and initializing an object. It seems tedious. Look at the following example:

`Map<String, Map<String, Integer>> properties = new HashMap<>();`

We specified the type of information on both sides in the above statement. If we define it in one place, our eyes can easily interpret that this has to be a `Map` type. The Java language has matured enough, and the Java compiler should be smart enough to understand that. The Local Type Inference does precisely that.  
The above code can now be written as follows:

`var properties = new HashMap<String, Map<String, Integer>>(); `

Now we have to write and type once. The above code may not look a lot less bad. However, it makes it a lot shorter when we call a method and store the result in a variable. Example:

`var properties = getProperties();`

Similarly,

`var countries = Set.of("Bangladesh", "Canada", "United States", "Tuvalu"); `

Although this seems like a handy feature, there is some criticism as well. Some developers would argue that this may reduce readability, which is more important than this little convenience.

To learn more about it, visit: 

* [Open JDK Lvti-Faq](https://openjdk.java.net/projects/amber/guides/lvti-faq)
* [Open JDK Lvti-style-guide](https://openjdk.java.net/projects/amber/guides/lvti-style-guide)

## Enhanced Switch Expressions

The traditional switch statement has been in Java from the beginning, which resembled C and C++. It was OK, but as the language evolved, it hasn’t offered us any improvement until Java 14. It certainly has some limitations as well. The most infamous was the [fall-through](https://docs.oracle.com/javase/tutorial/java/nutsandbolts/switch.html.):

To tackle the issue, we use break statements, which are pretty much boilerplate code. However, Java 14 introduced a new way of looking at this switch statement, and it offers many more rich features.

We no longer need to add break statements; it solves the fall-through problem. On top of that, a switch statement can return a value, which means we can use it as an expression and assign it to a variable.

```java
int day = 5;
String result = switch (day) {
    case 1, 2, 3, 4, 5 -> "Weekday";
    case 6, 7 -> "Weekend";
    default -> "Unexpected value: " + day;
};
```

* Read more about it: [Branching with Switch Expressions](https://dev.java/learn/branching-with-switch-expressions/).

## Records

Although records are relatively new features in Java, released in Java 16, many developers find it super helpful to create immutable objects.

Often we need data career objects in our program to hold or pass values from one method to another. For example, a class to carry x, y, and z coordinates, which we would write as follows.

```java
package ca.bazlur.playground;

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

  

The class seems super verbose and has little to do with our whole intention. This entire code can be replaced with the following code -

```java
package ca.bazlur.playground;

public record Point(int x, int y, int z) {
}
```

* Read more about records here: [Java record semantics](https://nipafx.dev/java-record-semantics/).

## Optional

A method is a contract: we put thought into it when defining one. We specify parameters with their type and also a return type. We expect it to behave according to the contract when we invoke a method. If it doesn’t, it’s a violation of the contract.

However, we often get null from a method instead of a value of the specified type. This is a violation. An invoker cannot know upfront unless it invokes it. To tackle this violation, the invoker usually tests the value with an if condition, whether this value is null or not. Example:

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

Look at the above code. The `findName()` method is supposed to return a `String` value, but it returns null. The invoker now has to check nulls first to deal with it. If an invokes forgets to do so, they will end up getting `NullPointerException` which is not expected behavior.

On the other hand, if the method signature would specify the possibility of not being able to return the value, it would solve all the confusion. And that’s where `Optional` comes into play.

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

Now we have rewritten the `findName()` method with Optional, which specified the possibility of not returning any value, and we can deal with it. That gives an upfront warning to the programmers and fixes the violation.

* [Read more about Optional](https://dzone.com/articles/optional-in-java).

## Java Date Time API

Every developer is confused with date-time calculation to some degree. This isn’t an overstatement. This was mainly due to not having a good Java API for dealing with Dates and times in Java for a long time.

However, the problem no longer exists because Java 8 brings an excellent API set in **java.time** package that solves all the date and time-related issues.

**The java.time** package provides many interfaces and classes that solve most problems dealing with date and time, including timezone (which is crazy complex at some point). However, primarily, we use the following classes -

* LocalDate
* LocalTime
* LocalDateTime
* Duration
* Period
* ZonedDateTime etc.

These classes are designed to have all the methods that are commonly needed. e.g.

```java
import java.time.LocalDate;
import java.time.Month;

public class Playground3 {
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

Similarly, LocalTime has all the methods required for calculating time.

```java
LocalTime time = LocalTime.of(20, 30);
int hour = time.getHour(); 
int minute = time.getMinute(); 
time = time.withSecond(6); 
time = time.plusMinutes(3);
```

We can combine both of them:

```java
LocalDateTime dateTime1 = LocalDateTime.of(2022, Month.APRIL, 4, 20, 30);
LocalDateTime dateTime2 = LocalDateTime.of(date, time);
```

How do we include timezone:

```java
ZoneId zone = ZoneId.of("Canada/Eastern");
LocalDate localDate = LocalDate.of(2022, Month.APRIL, 4);
ZonedDateTime zonedDateTime = date.atStartOfDay(zone);
```

* [Read more about Java Date Time](https://docs.oracle.com/javase/tutorial/datetime/TOC.html).

## Helpful NullPointerException

Every developer hates the Null Pointer Exception. It becomes challenging when StackTrace doesn’t provide helpful information. To demonstrate the problem, let’s see an example:

```java
package com.bazlur;

public class Main {

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

   //getter
   //setter
}

class Name {
    private String firstName;
    private String lastName;

    public Name(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;
    }

   //getter
   //setter
}
```

Look at the main method of the above code. We can see that we will get a null pointer exception. If we run and compile the code with pre-Java 14, we will get the following StackTrace:

```
Exception in thread "main" java.lang.NullPointerException
at com.bazlur.Main.getLengthOfUsersName(Main.java:11)
at com.bazlur.Main.main(Main.java:7)
```

This stack trace is okay, but it does not have much information about where and why this NullPointerException happened.

However, in Java 14 and onward, we get much more information in the stack trace, which is super convenient. In Java 14, we will get:

```
Exception in thread "main" java.lang.NullPointerException: Cannot invoke "ca.bazlur.playground.User.getName()" because "user" is null
at ca.bazlur.playground.Main.getLengthOfUsersName(Main.java:12)
at ca.bazlur.playground.Main.main(Main.java:8)
```

* [Read more about it](https://openjdk.java.net/jeps/358).

## CompletableFuture

We write programs line by line, and typically they get executed line by line. However, there are times when we want relatively parallel execution to make the program faster. To accomplish that, we usually consult the Java Thread.

Well, Java thread programming is not always about parallel programming. Instead, it gives us a way to compose multiple independent units of a program to be executed independently to make progress along with others, and often they run asynchronously.

However, thread programming and its intricacies seem dreadful. Most junior and intermediate developers struggle with it. That’s why Java 8 brings a more straightforward API that lets us accomplish a portion of the program run asynchronously. Let’s see an example:

Let’s assume we have to call three REST APIs and then combine the results. We can call them one by one. If each of them takes around 200 milliseconds, then the total time to fetch all of them would take 600 milliseconds.

What if we could run them in parallel? As modern CPUs have multicores in them, they can easily handle three rest calls on three different CPUs. Using the CompletableFuture, we can easily accomplish that.

```java
package ca.bazlur.playground;

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

* [Read more: Asynchronous programming in Java with CompletableFuture](https://www.linkedin.com/pulse/asynchronous-programming-java-completablefuture-aliaksandr-liakh/).

## Lambda Expression

Lambda Expression is probably the most powerful feature in the Java language. It reshaped the way we write code. A Lambda expression is like an anonymous function that can take arguments and return a value.

We can assign the function to a variable and pass it to a method as arguments, and a method can return it. It has a body. The only difference from a method is that it doesn’t have a name.

The expressions are short and concise. It usually doesn’t contain much boilerplate code. Let’s see an example:

We want to list all the files in a directory with the.java extension.

```java
var directory = new File("./src/main/java/ca/bazlur/playground");
String[] list = directory.list(new FilenameFilter() {
    @Override
    public boolean accept(File dir, String name) {
        return name.endsWith(".java");
    }
});
```

If you carefully look at the piece of the code, we passed an anonymous inner class to the method `list()`. In the inner class, we put the logic to filter out the files.

Essentially, we are interested in this piece of logic, not the boilerplate around the logic.

The lambda expression, in fact, allows us to remove all the boilerplate, and we can write the code that we care about. Example:

```java
var directory = new File("./src/main/java/ca/bazlur/playground");
String[] list = directory.list((dir, name) -> name.endsWith(“.java"));
```

Well, I have just shown you one example here, but there are plenty of other benefits of the lambda expression.

* [Read more about Lambda expressions](https://dev.java/learn/lambda-expressions/).

## Stream API

> "Lambda Expressions are the gateway drug to Java 8, but Streams are the real addiction."  
> - Venkat Subramaniam.

In our day-to-day programming jobs, one common task we do frequently is to process a collection of data. There are a few common operations, such as filtering, converting, and collecting the result.

Before Java 8, these sorts of operations were inherently imperative. We had to write code for our intention (aka what we wanted to achieve) and how we wanted it.

With the invention of the Lambda expression and stream API, we can now write out data processing functionality rather declaratively. We only specify our intention, but we don’t have to write down how we get the result. Let’s see an example:

We have a list of books, and we want to find all the Java books’ names comma-separated and sorted.

```java
public static String getJavaBooks(List<Book> books) {
    return books.stream()
            .filter(book -> Objects.equals(book.language(), "Java"))
            .sorted(Comparator.comparing(Book::price))
            .map(Book::name)
            .collect(Collectors.joining(", "));
}
```

The above code is simple, readable, and concise. The alternative imperative code would be-

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

Although both methods return the same value, we see the difference clearly.[ Learn more about stream API](https://dev.java/learn/the-stream-api/). That’s all for today. Cheers!

Learn more about stream API:

- [https://dev.java/learn/the-stream-api/](https://dev.java/learn/the-stream-api/)
- [https://jenkov.com/tutorials/java-functional-programming/streams.html](https://jenkov.com/tutorials/java-functional-programming/streams.html)

That’s all for today. Cheers!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
