
> * 原文地址：[Embracing Java 8 language features](https://jeroenmols.com/blog/2017/07/21/java8language/)
> * 原文作者：[Jeroen Mols](https://jeroenmols.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/embracing-java-8-language-features.md](https://github.com/xitu/gold-miner/blob/master/TODO/embracing-java-8-language-features.md)
> * 译者：[tanglie1993](https://github.com/tanglie1993)
> * 校对者：

# 拥抱 Java 8 语言特性

近年来，Android 开发者一直被限制在 Java 6 的特性中。虽然 RetroLambda 或者实验性的 Jack toolchain 会有一定帮助，来自 Google 官方的适当支持却一直缺失。

终于， Android Studio 3.0 带来了（已经向后移植！）对大多数 Java 8 特性的支持。继续阅读，你将看到其中的原理，以及升级的理由。

## 引入 Java 8 特性

虽然 Android Studio 已经支持 [Jack toolchain](https://developer.android.com/guide/platform/j8-jack.html) 中的大量特性，从 Android Studio 3.0 开始，它们会在默认的工具链中被支持。

首先，确保你已经把以下内容从你的主要 `build.gradle` 中移除，从而关闭了 Jack:

```
android {
  ...
  defaultConfig {
    ...
    // Remove the jackOptions if they exist
    jackOptions {
      enabled true
    }
  }
}
```

然后加入以下的配置：

```
android {
  ...
  compileOptions {
    sourceCompatibility JavaVersion.VERSION_1_8
    targetCompatibility JavaVersion.VERSION_1_8
  }
}
```

并且确保你在根 `build.gradle` 文件中有最新的 Gradle 插件：

```
buildscript {
  ...
  dependencies {
    classpath 'com.android.tools.build:gradle:3.0.0-alpha7'
  }
}
```

恭喜，你现在可以在所有的 API 层级上使用大多数的 Java 8 特性了！

> 注意：如果你在从 [RetroLambda](https://github.com/evant/gradle-retrolambda) 迁移过来，官方文档有一个更加全面的 [迁移指南](https://developer.android.com/studio/write/java8-support.html#migrate)。

## 有关 Lambda

在 Java 6 中，向另一个类传入监听器的代码是相当冗长的。典型的情况是，你需要向 `View` 添加一个 `OnClickListener`：

```
button.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View view) {
        doSomething();
    }
});
```

Lambda 可以把它剧烈简化到下面这样：

```
button.setOnClickListener(view -> doSomething());
```

注意：几乎全部模板代码都被删除了：没有访问控制修饰符，没有返回值，也没有方法名称！

Lambda 究竟是怎么工作的呢？

它们使语法糖，当你有一个只有一个方法的接口时，它们可以减少创建匿名类的需要。我们把这些接口称为功能接口，`OnClickListener` 就是一个例子：

```
// 只有一个方法的功能接口
public interface OnClickListener {
    void onClick(View view);
}
```

基本上 lambda 包括三个部分：

```
button.setOnClickListener((view) -> {doSomething()});
```

1. 括号 `()` 中所有方法参数的声明
2. 一个箭头 `->`
3. 括号 `{}` 中需要执行的代码

注意：在很多情况下，甚至 `()` 和 `{}` 这样的括号也可以被移除。更多细节，参见 [官方文档](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)。

## 方法引用

回忆一下 lambda 表达式为功能接口删除了大量样板代码的情形。当 lambda 调用了已经有一个名字的方法时，方法引用把这个概念更推进了一步， Method references take that concept one step further when the lambda calls a method that already has a name.

In the following example:

```
button.setOnClickListener(view -> doSomething(view));
```

All the lambda does is redirecting the work to an existing `doSomething()` method. In such a case, a method reference simplifies things further to:

```
button.setOnClickListener(this::doSomething);
```

Note that the referenced method must take exactly the same parameters as the functional interface:

```
// functional interface
public interface OnClickListener {
    void onClick(View view);
}

// referenced method: must take View as argument, because onClick() does
private void doSomething(View view) {
    // do something here
}
```

So how do method references work?

They are again syntactic sugar to simplify a lambda expression that invokes an existing method. They can reference to:

| static methods | MyClass::doSomething |
| instance method of object | myObject::doSomething |
| constructor | MyClass:: new |
| instance method of any argument type | String::compare |

For more examples about this have a look at the [official documentation](https://docs.oracle.com/javase/tutorial/java/javaOO/methodreferences.html).

## Default interface Methods

Default methods make it possible to add new methods to an interface without breaking all classes that implement that interface.

Imagine if you have a `MyView` interface that is implemented by a `MyFragment` (typical MVP scenario):

```
public interface MyView {
    void showProgressbar();
}

public class MyFragment implements MyView {

    @Override
    public void showProgressbar() {

    }
}
```

When you now want to add an extra method to `MyView` your code will no longer compile, until `MyFragment` also implements that new method. This is annoying, and can be even problematic when many classes are implementing said interface.

Therefore Java 8 now allows you to define default methods that provide a standard implementation:

```
public interface MyView {
    void showProgressbar();
    default void hideProgressbar() {
        // do something here
    }
}
```

So how do default methods work?

Just define a method with the `default` keyword in the interface and provide an actual default method body.

To learn more about this feature, have a look at the [official documentation](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html).

## How to get started

While this all might seem a bit overwhelming, Android Studio actually offers amazing quick fixes once you enable Java 8 features.

Just use `alt/option` + `enter` to convert a functional interface to a lamba or a lambda to a method reference.

![Java 8 language quick fixes](https://jeroenmols.com/img/blog/java8language/androidstudioconversion.gif)

This is a great way to get familiar with these new features and allows you to write code like you’re used to. After enough quick fixes by Android Studio you’ll learn in what cases a lambda or method reference would be possible and start writing them yourself.

## Supported features

While not all Java 8 features have been backported yet, Android Studio 3.0 offers plenty more features:

- [static interface methods](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html)
- [type annotations](https://docs.oracle.com/javase/tutorial/java/annotations/type_annotations.html)
- [repeating annotations](https://docs.oracle.com/javase/tutorial/java/annotations/repeating.html)
- [try with resources](https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html) (all versions, no longer min SDK 19)
- Java 8 APIs (e.g. stream) -> min SDK 24

## Wrap-up

Thanks to Java 8 features, a lot of code can be simplified into lambda’s or method references. Android Studio auto convert is the easiest way to start learning these features.

If you’ve made it this far, you should probably follow me on [Twitter](https://twitter.com/molsjeroen). Feel free leave a comment below!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
