
> * 原文地址：[Embracing Java 8 language features](https://jeroenmols.com/blog/2017/07/21/java8language/)
> * 原文作者：[Jeroen Mols](https://jeroenmols.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/embracing-java-8-language-features.md](https://github.com/xitu/gold-miner/blob/master/TODO/embracing-java-8-language-features.md)
> * 译者：[tanglie1993](https://github.com/tanglie1993)
> * 校对者：[lileizhenshuai](https://github.com/lileizhenshuai), [DeadLion](https://github.com/DeadLion)

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

> 注意：如果你要从 [RetroLambda](https://github.com/evant/gradle-retrolambda) 迁移过来，官方文档有一个更加全面的 [迁移指南](https://developer.android.com/studio/write/java8-support.html#migrate)。

## 有关 Lambda 表达式

在 Java 6 中，向另一个类传入监听器的代码是相当冗长的。典型的情况是，你需要向 `View` 添加一个 `OnClickListener`：

```
button.setOnClickListener(new View.OnClickListener() {
    @Override
    public void onClick(View view) {
        doSomething();
    }
});
```

Lambda 表达式可以把它显著地简化成下面这样：

```
button.setOnClickListener(view -> doSomething());
```

注意：几乎全部模板代码都被删除了：没有访问控制修饰符，没有返回值，也没有方法名称！

Lambda 表达式究竟是怎么工作的呢？

它们是语法糖，当你有一个只有一个方法的接口时，它们可以减少创建匿名类的需要。我们把这些接口称为功能接口，`OnClickListener` 就是一个例子：

```
// 只有一个方法的功能接口
public interface OnClickListener {
    void onClick(View view);
}
```

基本上 lambda 表达式包括三个部分：

```
button.setOnClickListener((view) -> {doSomething()});
```

1. 括号 `()` 中所有方法参数的声明
2. 一个箭头 `->`
3. 括号 `{}` 中需要执行的代码

注意：在很多情况下，甚至 `()` 和 `{}` 这样的括号也可以被移除。更多细节，参见 [官方文档](https://docs.oracle.com/javase/tutorial/java/javaOO/lambdaexpressions.html)。

## 方法引用

回忆一下 lambda 表达式为功能接口删除了大量样板代码的情形。当 lambda 表达式调用了一个已经有名字的方法时，方法引用把这个概念更推进了一步。

在下面的例子中：

```
button.setOnClickListener(view -> doSomething(view));
```

Lambda 只是把要做的所有事情重定向到已有的 `doSomething()` 方法。在这种情况下，方法引用把事情简化到：

```
button.setOnClickListener(this::doSomething);
```

注意，被引用的方法必须和功能接口接收相同的参数：

```
// 功能接口
public interface OnClickListener {
    void onClick(View view);
}

// 被引用的方法：必须接收 View 作为参数，因为 onClick() 会这样做：
private void doSomething(View view) {
    // do something here
}
```

那么，方法引用是如何工作的呢？

它们同样是语法糖，可以简化调用了现有方法的 lambda 表达式。他们可以引用：

| | |
| - | - |
| 静态方法 | MyClass::doSomething |
| 对象的实例方法 | myObject::doSomething |
| 构造方法 | MyClass:: new |
| 任何参数类型的实例方法 | String::compare |

如果你需要更多关于这个的实例，请查看 [官方文档](https://docs.oracle.com/javase/tutorial/java/javaOO/methodreferences.html)。

## 默认接口方法

默认方法使你可以在不破坏实现一个接口的所有的类的情况下，向该接口中加入新的方法。

假设你有一个 `MyView` 接口，它被一个 `MyFragment` 实现（典型 MVP 场景）：

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

如果你现在想要向 MyView 中加入一个额外的方法，你的代码将不再能够编译，直到 `MyFragment` 同样实现了这个新方法。这很烦人，并且如果很多类都实现这个接口的话，可能会引发新的问题。

因此 Java 8 允许你定义带有标准实现的默认方法：

```
public interface MyView {
    void showProgressbar();
    default void hideProgressbar() {
        // do something here
    }
}
```

那么默认方法是如何工作的呢？

在接口中定义一个带有 `default` 关键字的方法，并提供一个真实的默认方法体。

要学习关于这个特性的更多知识，请查看 [官方文档](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html)。

## 如何开始

虽然这看起来有些吓人，但是一旦你打开了 Java 8 特性，Android Studio 就提供了非常好用的快速修复功能。

只要使用 `alt/option` + `enter` 就可以把功能接口转化为一个 lambda 表达式，或把 lambda 转为方法引用。

![Java 8 语言的快速修复功能](https://jeroenmols.com/img/blog/java8language/androidstudioconversion.gif)

这是一种熟悉新特性的好办法，它使你可以按照自己习惯的方式写代码。在使用 Android Studio 的快速修复功能足够多次之后，你将学会 lambda 表达式和方法引用有哪些使用场景，并开始自己写它们。

## 支持的特性

虽然并不是所有的 Java 8 特性都已经被向后移植，但是Android Studio 3.0 提供了很多其他的特性：

- [静态接口方法](https://docs.oracle.com/javase/tutorial/java/IandI/defaultmethods.html)
- [类型注解](https://docs.oracle.com/javase/tutorial/java/annotations/type_annotations.html)
- [重复标记](https://docs.oracle.com/javase/tutorial/java/annotations/repeating.html)
- [针对资源的 try 语句](https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html) (所有版本，最低版本不再是 SDK 19)
- Java 8 APIs (e.g. stream) -> min SDK 24

## 收尾

Java 8 特性使得很多代码可以被简化为 lambda 表达式或方法引用。 Android Studio 自动转化是最简单的开始学习这些特性的方式。

如果你已经读到这里了，你很可能应该在 [Twitter](https://twitter.com/molsjeroen) 上关注我。欢迎评论！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
