> * 原文地址：[Demystifying Java Lambda Expressions](https://betterprogramming.pub/demystifying-java-lambda-expressions-d122b4b23b70)
> * 原文作者：[Randal Kamradt Sr](https://medium.com/@rlkamradt)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/demystifying-java-lambda-expressions.md](https://github.com/xitu/gold-miner/blob/master/article/2021/demystifying-java-lambda-expressions.md)
> * 译者：
> * 校对者：

# Demystifying Java Lambda Expressions

#### Conjuring functions from thin air

![Image by [Anja🤗#helpinghands #solidarity#stays healthy🙏](https://pixabay.com/users/cocoparisienne-127419/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=739165) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=739165)](https://cdn-images-1.medium.com/max/3840/1*fKbNefOZMcHC3B-KMsy9kw.jpeg)

I seem to spend a lot of time explaining Java functional programming. Really, there’s no magic here. You pass functions into functions to adapt their behavior. Why would you want to do that? If you’re using object-oriented development, you’re already doing it but in a very controlled fashion. Java’s polymorphism is implemented by keeping a list of functions that can be replaced by sub-classing. Then other functions of that class might call a function that has been overridden, and thus its behavior is changed even though the outer function wasn’t itself overridden.

Let’s take an example of polymorphism and translate that into functions as lambda expressions. Here’s an example:

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

This is pretty classic object orientation, a `Dog` and `Cat` type that implements a `Pet` type. Sound familiar? In this extremely simple example, if you disturb your pet, what does it do? A dog barks and a cat meows.

But what if you wanted a snake, too? You’d have to create a new class. What if you wanted a thousand types? That’s a lot of boilerplate for each one. If the `Pet` interface only has a single method, Java can treat it like a function. I’m going to move the `disturb` method out of the `Pet` interface (it probably didn’t belong there in the first place, as it’s not a property of the pet). Here’s what it looks like:

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

It’s this odd syntax, `() -> something`, that throws some people for a loop. But all that it does is define a function that takes no parameters and returns something. And since the `Pet` interface only has a single method, that is how you invoke the function you created. Technically, it implements the type `Pet` overriding the `vocalize` function. But for the purposes of our discussion, it is a function that can be passed into another function.

You could reduce this even further since the `Pet` interface can be replaced with a `Supplier` interface that “supplies” the vocalization. Here’s what that looks like:

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

The `Supplier` type is provided in the `java.util.function` package because it’s such a common type of function.

These lambda functions make it look like we’re creating a function out of thin air. But behind the scenes, we’re implementing an interface with a single method and providing the implementation of the single method.

Let’s take another common function, the `Consumer`. A `Consumer` function takes a value as a parameter and returns nothing, basically consuming the value. If you’ve ever used the `forEach` method of a list or stream, you’ve used a `Consumer`. We’re going to collect up all of your pet’s vocalizations into a list and then invoke each. Here’s what it looks like:

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

Now, if you add a bird to your menagerie, you need only add `() -> “chirp”` to the list. Notice that I didn’t put parentheses around the v in the `v -> disturbPet(v)` lambda. For single-parameter lambdas, the parentheses are optional.

OK, my example is pretty contrived. I just wanted to walk from the polymorphic functions through to the lambda functions. When would you actually use lambda expressions? There are a few examples that are very common and worth going over. These are used as part of the streams library.

As an example that’s a little less contrived, I’ll get a list of files, remove the ones that don’t start with a dot, and get the name and size of the file. The first chore is to get the array of files from the current directory and turn that into a `Stream` type. We can do that with the `File` type:

```
File dir = new File(".");
Stream s = Arrays.stream(dir.listFiles());
```

Since a directory is a file, we can operate on it with the `File` type. We also know that “.” is a directory, so we can call `listFiles` on it. But it returns an array, so to use streams to manipulate it, we have to use the `Arrays.stream` function to turn the array into a `Stream`.

Now, let’s remove the files that start with a dot, transform the `File` type to a string with the name and size, sort it in alphabetical order, and log it.

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

The two new functions that take lambda expressions are `filter` and `map`. The `filter` function takes a `Predicate` type and the `map` function takes a (don’t laugh) `Function` function, both of which are part of `java.util.function` package. Both provide very common operations that you can do on an object, `Predicate` testing some aspect of the object and `Function` transforming it from one thing to another. Both take an object as a parameter, but the `Predicate` returns a boolean and the `Function` returns another object.

Notice that I also checked that the item was a file. What should we do with directories? How about if we recurse into the directories? How would you do that with streams? There is a special type of map that adds an inner stream (a subdirectory) into an outer stream. What exactly does that mean? Take a look at this example:

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

As you can see, the lambda use in the `flatMap` method will recurse if the file in question is a directory and will return the file itself if it’s not. The lambda for the `flatMap` must return a `Stream` of something. So in the case of the single file, we have to wrap it with `Stream.of()` to match the return type of the recursive call of `getFiles()`. Also notice that the lambda is contained within curly braces, so it has to have a return statement if it’s expected to return something.

In order to use this `getFiles` function, we can add it to the main method:

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

We have to go through some machinations to get the relative path into the file name without the full path. But hey, it works.

Functions that take functions as parameters are often called **high-order functions**. We have seen several high-order functions: `forEach`, `filter`, `map`, and `flatMap`. Each represents a very common way of operating on an object in an abstract way differentiated by the parameters and return values. We use lambdas to provide the definite operation to be performed. In this way, we can chain operations on sequences of objects to get the desired outcome.

I hope this has taken some of the mystery out of the lambda function. I think when I was first introduced to it, the name itself was intimidating. Of course, it was borrowed from Alonzo Church’s lambda calculus, but that’s another story. For now, all you need to know is that functions can be conjured from thin air with just a simple syntax.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
