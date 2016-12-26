* 原文地址：[ Effective Java for Android (cheatsheet) ](https://medium.com/rocknnull/effective-java-for-android-cheatsheet-bf4e3433889a#.hmlqxkmzh)
* 原文作者：[ Netcyrax ]( https://medium.com/@netcyrax)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jamweak](https://github.com/jamweak)
* 校对者：[jacksonke](https://github.com/jacksonke)，[phxnirvana](https://github.com/phxnirvana)

# Android 中的 Effective Java(速查表)

[Effective Java](https://www.amazon.co.uk/Effective-Java-Second-Joshua-Bloch/dp/0321356683) 是一本被广泛认可的著作，它指明了在写 Java 代码时兼顾**可维护性**与**效率**的方式。Android 也是使用 Java 来开发的，这意味着前书中的**所有**建议仍旧可用，真的是这样吗？并不尽然。[某些](https://news.ycombinator.com/item?id=12893118)[同学](https://www.reddit.com/r/androiddev/comments/4smncj/is_this_true/) 认为书中的“大部分”建议都不适用于 Android 开发，但我认为并不是这样。我承认书中的部分建议确实不适用，因为并非所有 Java 特性都有针对 Android 优化（比如说[枚举](https://developer.android.com/topic/performance/memory.html#Abstractions)，序列化等等），或者是因为移动设备的局限 （例如 [Dalvik](https://en.wikipedia.org/wiki/Dalvik_%28software%29) /[ART](https://en.wikipedia.org/wiki/Android_Runtime) ）。 不管怎样，书中的**大部分**规范是稍微修改下甚至不修改就可以直接用的，以便构建更鲁棒，简洁且更可维护的代码库。

本文试图聚焦于原书中我认为在 Android 开发时最重要的一些条目。对于那些读过此书的人，本文也许能帮助你回忆起这些条目，对于那些（还）没有读过的人，本文能够让他们品尝到一丝原书的韵味。

#### 强制不可实例化

如果你不希望一个对象通过关键字 *new* 来创建，那么强制让它的**构造方法私有**。这尤其对一些只包含静态方法的工具类有用。
```
class MovieUtils {
  private MovieUtils() {}

    static String titleAndYear(Movie movie) {
        [...]
    }
}

```

#### 静态工厂方法

不要使用 new 关键字和构造方法创建对象，而应当使用静态工厂方法（和私有构造方法）。这些工厂方法具有名字，不需要每次返回一个新的对象实例，它们可以依据需求返回不同的子类型对象。
```
class Movie {
    [...]
    public static Movie create(String title) {
        return new Movie(title);
    }
}

```

#### 创建者模式

当对象的构造方法参数不小于 3 个时，可以考虑创建者模式。这可能需要更多行的代码，但拓展性和可读性会很好。如果你正创建一个实体类，考虑使用  [AutoValue](https://medium.com/rocknnull/no-more-value-classes-boilerplate-the-power-of-autovalue-bbaf36cf8bbe#.cazel3w3g) 。

```
class Movie {
    static Builder newBuilder() {
        return new Builder();
    }
    static class Builder {
        String title;
        Builder withTitle(String title) {
            this.title = title;
            return this;
        }
        Movie build() {
            return new Movie(title);
        }
    }

    private Movie(String title) {
    [...]
    }
}
// Use like this:
Movie matrix = Movie.newBuilder().withTitle("The Matrix").build();

```

#### 避免可变性

不可变性是指对象在其整个生命周期内一直保持不变。应将对象中所有必要的数据在其创建时就赋值。这个做法有许多好处，比如简洁化，线程安全以及可共享性等。

```
class Movie {
    [...]
    Movie sequel() {
        return Movie.create(this.title + " 2");
    }
}
// Use like this:
Movie toyStory = Movie.create("Toy Story");
Movie toyStory2 = toyStory.sequel();

```

很难将所有的类都设为不可变类，如果是这样的话，尽可能多地让你的类变成不可变类（例如私有化常量以及不可继承类）。在移动设备中创建对象代价更高，因此不要滥用它。

#### 静态成员类

如果你定义了一个不依赖外部类的内部类，不要忘记将其定义为静态的。否则将会导致每一个内部类对象都会持有对外部类的引用。

```
class Movie {
    [...]
  static class MovieAward {
        [...]
    }
}

```

#### 泛型 (几乎) 无处不在

Java 提供了类型检查，我们应当对此感激（看看 JS ）。尽量避免使用无类型或 Object 类型。泛型机制，大多数情况下保障了编译时的类型检查。

```
// 不要这样做
List movies = Lists.newArrayList();
movies.add("Hello!");
[...]
String movie = (String) movies.get(0);

// 这样做
List<String> movies = Lists.newArrayList();
movies.add("Hello!");
[...]
String movie = movies.get(0);

```

不要忘记你能在方法中对参数和返回值使用泛型

```
// 不要这样做
List sort(List input) {
    [...]
}

// 这样做
<T> List<T> sort(List<T> input) {
    [...]
}

```

想更灵活的话，你可以使用 [bounded wildcards](http://stackoverflow.com/questions/2723397/what-is-pecs-producer-extends-consumer-super) 来扩展你接受类型的范围。

```
// 从集合中读取 Stuff - 使用 "extends"
void readList(List<? extends Movie> movieList) {
    for (Movie movie : movieList) {
        System.out.print(movie.getTitle());
        [...]
    }
}

// 向集合中写入 Stuff - 使用 "super"
void writeList(List<? super Movie> movieList) {
    movieList.add(Movie.create("Se7en"));
    [...]
}

```

#### 返回空值

当你方法的返回类型为 list/collecion 时，返回空值时要避免返回 *null*。返回一个空的集合类型，这会使得你**简化接口**（没有必要写文档来声明方法返回值为 null）并且**避免空指针异常**。就返回那个集合的空值，而不是再创建一个。

```
List<Movie> latestMovies() {
    if (db.query().isEmpty()) {
        return Collections.emptyList();
    }
    [...]
}

```

不要用 “+” 来连接 String

必须要拼接一系列字符串时，可能会使用 + 连字符。永远不要用它来拼接大量字符串，这样的性能真的很差，考虑使用 StringBuilder 来代替。

```
String latestMovieOneLiner(List<Movie> movies) {
StringBuilder sb = new StringBuilder();
    for (Movie movie : movies) {
        sb.append(movie);
    }
    return sb.toString();
}

```

#### Recoverable exceptions

我个人不喜欢抛出异常来指示错误，但是如果你这样做，确保这个异常被检查，确保这个**异常被捕获到**。

```
List<Movie> latestMovies() throws MoviesNotFoundException {
    if (db.query().isEmpty()) {
throw new MoviesNotFoundException();
    }
    [...]
}

```

### 结论

这份列表绝不是书中给出建议的完整列表，也不是全书完整深入陈述的浓缩，这篇文章更像是一些有用建议的速查表 :)
