> * 原文地址：[Demystifying Java Lambda Expressions](https://betterprogramming.pub/demystifying-java-lambda-expressions-d122b4b23b70)
> * 原文作者：[Randal Kamradt Sr](https://medium.com/@rlkamradt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/demystifying-java-lambda-expressions.md](https://github.com/xitu/gold-miner/blob/master/article/2021/demystifying-java-lambda-expressions.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[Kimhooo](https://github.com/Kimhooo)，[1autodidact](https://github.com/1autodidact)

# 解密 Java Lambda 表达式

![](https://cdn-images-1.medium.com/max/3840/1*fKbNefOZMcHC3B-KMsy9kw.jpeg)

我似乎花了很多时间讲解 Java 中的函数式编程。其实并没有什么深奥难懂的东西。为了使用某些函数的功能，你需要在函数中嵌套定义函数。为什么那样做？当你使用面向对象的方式进行开发，你已经使用了函数式编程的方法，只不过是以一种受控的方式使用。Java 中的多态就是通过保存若干个可以在子类中重写的函数实现的。这样，该类的其他函数可以调用被重写的函数，即使外部函数没有被重写，它的行为也发生了改变。

我们来举个多态的例子，并将它转换为使用 lambda 表达式的函数。代码如下：

```Java
@Slf4j
public class Application {
    static abstract class Pet {
        public abstract String vocalize();
        public void disturb() { log.info(vocalize()); }
    }
    static class Dog extends Pet {
        public String vocalize() { return "bark"; }
    }
    static class Cat extends Pet {
        public String vocalize() { return "meow"; }
    }
    public static void main(String [] args)  {
        Pet cat = new Cat();
        Pet dog = new Dog();
        cat.disturb();
        dog.disturb();
    }
}
```

这是非常经典的面向对象的例子，即 `Dog` 类和 `Cat` 类继承实现 `Pet` 类的例子。听起来很熟悉？在这个再简单不过的例子中，如果你执行 disturb() 方法，程序会如何运行？结果是：猫和狗各自发出自己的叫声。

但是，如果你需要一条蛇，该怎么办？你需要新建一个类，如果需要 1000 个类呢？每个类都需要模板文件。如果 `Pet` 接口只有一个简单的方法，Java 也会把它看作一个函数。我把 `Pet`移出 `disturb` 接口（可能它起初不在这里，它不是 `Pet` 的属性）。如下所示：

```Java
@Slf4j
public class Application {
    interface Pet {
        String vocalize();
    }
    static void disturbPet(Pet p) {
        log.info(p.vocalize());
    }
    public static void main(String [] args)  {
        Pet cat = () -> "meow";
        Pet dog = () -> "bark";
        Pet snake = () -> "hiss";
        disturbPet(cat);
        disturbPet(dog);
        disturbPet(snake);
    }
}
```

这种古怪的语法 `() -> something` 令人大吃一惊。但是，它只是定义了一个函数，这个函数没有输入参数，有返回对象。由于 `Pet` 接口只有一个方法，开发者就可以通过这种方式来调用方法。从技术角度来看，它实现了 `Pet` 接口，重写了 `vocalize` 函数。但对于我们的讨论的主题来说，它是一个可以嵌入其他函数的函数。

由于 `Supplier` 接口可以替代 `Pet` 接口，这段代码还可以进一步精简。如下所示：

```Java
@Slf4j
public class Application {
    static void disturbPet(Supplier<String> petVocalization) {
        log.info(petVocalization.get());
    }
    public static void main(String [] args)  {
        disturbPet(() -> "meow");
        disturbPet(() -> "bark");
        disturbPet(() -> "hiss");
    }
}
```

由于`Supplier` 是一个公共接口，它位于 `java.util.function` 包中。

这些 lambda 函数看起来像是我们凭空捏造的。但在它们的背后，我们是在利用单一函数去实现接口，并提供单一函数的具体实现。

我们来讨论另一个公共函数 `Consumer`。它把某个值作为输入参数，没有返回值，本质上是消费了这个值。如果你已经使用了列表或流对象的 `forEach` 方法，在这里你可以用 `Consumer`。我们会收集所有的宠物的叫声，存入一个列表，再逐个调用。如下所示：

```Java
@Slf4j
public class Application {
    static void disturbPet(Supplier<String> petVocalization) {
        log.info(petVocalization.get());
    }
    public static void main(String [] args)  {
        List<Supplier<String>> yourPetVocalizations = List.of(
                () -> "bark",
                () -> "meow",
                () -> "hiss");
        yourPetVocalizations.forEach(v -> disturbPet(v));
    }
}
```

现在，如果你添加一只鸟，只需要在列表中加入 `() -> “chirp”`。注意：表达式 `v -> disturbPet(v)` 中第一个 v 两边不加括号。对包含单一参数的 lambda 表达式而言，括号可以不加。

OK，我展示的例子并不直观。我的目的是从多态函数入手，引入 lambda 表达式的相关内容。何时可以实际使用 lambda 表达式？有一些例子，它们具有通用性，应当反复研究。这些例子也被纳入了 Stream 类库中。

这个例子比较直观，我会获取一系列的文件，删除那些不以点作为开头的文件，并获取文件名和文件大小。首先需要从当前目录获取文件数组，并将它转为 `Stream` 类型。我们可以使用 `File` 类实现：

```Java
File dir = new File(".");
Stream s = Arrays.stream(dir.listFiles());
```

由于目录也是文件对象，我们可以对它执行某些文件对象的操作。同时，“.”表示一个目录，我们也可以调用 `listFiles` 方法。但它会返回一个数组，所以应当使用流来处理，我们需要使用 `Arrays.stream` 方法将数组转为流对象。

现在，我们删除以点开头的文件，将 `File` 对象转为一个由其名称和大小组成的字符串，按字母顺序排列，并写入日志。

```Java
public class Application {
    public static void main(String [] args)  {
        File dir = new File(".");
        Arrays.stream(dir.listFiles())
                .filter(f -> f.isFile())
                .filter(f -> !f.getName().startsWith("."))
                .map(f -> f.getName() + " " + f.length())
                .sorted()
                .forEach(s -> log.info(s));
    }
}
```

处理 lambda 表达式的两个新方法是 `filter` 和 `map`。`filter` 方法相当于 `Predicate` 类型，`map` 方法相当于 `Function` 类型，它们都属于 `java.util.function` 包。它们都提供了通用的操作对象的方法，`Predicate` 用于测试对象的某些特征，`Function` 用于对象之间的转换。

注意：我也考虑了一个文件的情况。如何处理目录？如果使用递归到目录中会如何？怎样使用流对象处理它？有一种特殊的 map，它可以把一个内部流对象添加到外部流对象中。这意味着什么？我们来看下面的例子：

```Java
public static Stream<File> getFiles(File file) {
     return Arrays.stream(file.listFiles())
             .filter(f -> !f.getName().startsWith("."))
             .flatMap(f -> {
                if(f.isDirectory()) {
                    return getFiles(f);
                } else {
                    return Stream.of(f);
                }
             });

 }
```

如你所见，如果文件对象是一个目录，`flatMap` 方法中使用的 lambda 表达式执行了递归，如果不是，就返回文件对象本身。`flatMap` 方法的 lambda 表达式的返回值必须是某个流对象。所以在单一文件的情况下，我们需要使用 `Stream.of()` 实现返回值类型的匹配。也应该注意到，lambda 表达式包含于花括号内，所以如果需要返回某个对象，应该添加 return 语句。

为了使用 `getFiles` 方法，我们可以把它加入 main 方法。

```Java
public static void main(String [] args)  {
        File dir = new File(".");
        getFiles(dir)
                .map(f -> f.getAbsolutePath()
                     .substring(dir.getAbsolutePath().length())
                     + " " + f.length())
                .sorted()
                .forEach(s -> log.info(s));
    }
```

在没有全路径的情况下，我们必须通过某些机制获取文件名中的相对路径。但是现在，不需要这么复杂了。

把其他函数作为参数的函数一般称为 **高阶函数**。我们已经了解了几种高阶函数：`forEach`, `filter`, `map` 和 `flatMap`。它们中的每一个都代表了一种以不同于参数和返回值的抽象方式操作对象的方法。我们使用 lambda，就是要进行明确的操作。利用这种方式，我们还可以把多个操作串联于一系列对象上，以便得到需要的结果。

我希望本文能向读者揭示 lambda 函数的神秘面纱。我想，当第一次引入这个话题，它本身就有些吓人。当然，它是从 Alonzo Church 的 lambda 演算借用过来的，但这又是另一个故事了。现在，你应该了解：使用这种简单的语法，函数也可以凭空产生。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
