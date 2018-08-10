> * 原文地址：[Practical ProGuard rules examples](https://medium.com/google-developers/practical-proguard-rules-examples-5640a3907dc9)
> * 原文作者：[Wojtek Kaliciński](https://medium.com/@wkalicinski?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/practical-proguard-rules-examples.md](https://github.com/xitu/gold-miner/blob/master/TODO1/practical-proguard-rules-examples.md)
> * 译者：[Derek](https://github.com/derekdick)
> * 校对者：

# 实用 ProGuard 规则示例

我在之前的文章中解释了 [为什么每个人都应该将 ProGuard 用于他们的 Android 应用](https://medium.com/google-developers/troubleshooting-proguard-issues-on-android-bce9de4f8a74)、怎么启用它以及在使用中可能面临的错误种类。这其中涉及很多理论，因为我认为理解基本原理以准备好处理任何潜在问题非常重要。

我还在一篇单独的文章中谈到了 [为 Instant App 构建配置 ProGuard](https://medium.com/google-developers/enabling-proguard-in-an-android-instant-app-fbd4fc014518) 的非常具体的问题。

在这里，我想谈 ProGuard 规则在中型样例应用上的实用示例：出自 [Nick Butcher](https://medium.com/@crafty) 的 [Plaid](https://github.com/nickbutcher/plaid).

### 从 Plaid 中吸取的教训

Plaid 实际上是研究 ProGuard 问题的一个很好的主题，因为它包含使用注解处理与代码生成、反射、Java资源加载和原生代码（JNI）的第三方库的混合体。我提取并记录下了一些适用于其他应用的实用建议：

### 数据类

```
public class User {
  String name;
  int age;
  ...
}
```

每个应用可能都有某种数据类（也被称为 DMOs，模型等，取决于上下文以及它们处在应用架构中的位置）。关于数据对象的事实是，通常在某些时候他们将被加载或保存（序列化）到某些其他介质中，例如网络（HTTP 请求）、数据库（通过 ORM）、磁盘上的 JSON 文件或 Firebase数据存储。

许多简化序列化与反序列化这些字段的工具依赖于反射。GSON、Retrofit、Firebase —— 他们都检查数据类的字段名并把它们转换成另一种表现形式（例如：`{“name”: “Sue”, “age”: 28}`），用于传输或存储。它们将数据读入 Java 对象时也是同理 —— 它们看到键值对 `“name”:”John”` 并尝试通过查找 `String name` 字段将其应用到 Java 对象上。

**结论**：我们不能让 ProGuard 重命名或删除这些数据类的任何字段，因为它们必须与序列化的格式匹配。最好给整个类添加一个 `@Keep` 注解或者给所有模型添加通配符规则：

```
-keep class io.plaidapp.data.api.dribbble.model.** { *; }
```

> **警告**：在测试你的应用是否容易受到这个问题的影响是可能会出错。例如，如果你在版本 N 的应用程序中将一个对象序列化成 JSON 并将其保存到磁盘而没有使用适当的 keep 规则，那么保存的数据可能看起来像这样：`{“a”: “Sue”, “b”: 28}`。因为 ProGuard 将你的字段重命名为 `a` 和 `b`，所以一切看起来似乎都有效，数据也会被正确地保存和加载。

> 然而，当你再一次构建你的应用并发布版本 N+1 的应用时，ProGuard 可能会决定将你的字段重命名为某些其他的，比如 `c` 和 `d`。因此，之前保存的数据将无法加载。

> 首先你**必须**确保你有适当的 keep 规则。

### 从原生层调用的 Java 代码（JNI）

Android 的 [默认 ProGuard 文件](https://developer.android.com/studio/build/shrink-code.html#shrink-code)（你应该总是包括它们，它们有一些非常有用的规则）已经包含了针对在原生层**实现**的方法的规则（`-keepclasseswithmembernames class * { native <methods>; }`）。遗憾的是，没有一种全能的方法可以保留从反方向调用的代码：从 JNI 到 Java。

利用 JNI，完全有可能从 C / C++ 代码中构造 JVM 对象或者找到并调用 JVM 句柄的方法，而且事实上，[Plaid 的一个库就是这样](https://github.com/Uncodin/bypass/blob/master/platform/android/library/jni/bypass.cpp#L61)。

**结论**：因为 ProGuard 只能审查 Java 类，所以它不会知道任何在原生代码中发生的使用。我们必须通过 `@Keep` 注解或 `-keep` 规则来显示地保留这些类和成员的使用。

```
-keep, includedescriptorclasses
            class in.uncod.android.bypass.Document { *; }
-keep, includedescriptorclasses
            class in.uncod.android.bypass.Element { *; }
```

### 从 JAR/APK 打开资源

Android 有其自己的资源系统，通常不会有 ProGuard 的问题。然而，在普通的 Java 中有另一种[直接从 JAR 文件加载资源的机制](https://docs.oracle.com/javase/8/docs/technotes/guides/lang/resources.html)并且即使被编译到 Android 应用中，某些第三方库可能也会使用这种机制（在这种情况下，它们将尝试从 APK 加载）。

问题是通常这些类会在自己的包名下寻找资源（这将转换为 JAR 或 APK 中的文件路径）。ProGuard 可能在混淆时重命名包名，因此在编译之后可能会发生类及其资源文件不再位于最终 APK 中的同一包内。

要以这种方式识别加载资源，你可以在你的代码和任何你依赖的第三方库中查找 `Class.getResourceAsStream / getResource` 和 `ClassLoader.getResourceAsStream / getResource` 的调用。

**结论**：我们应该保留任何使用这种机制从 APK 加载资源的类的名字。

在 Plaid 中，实际上有两个 —— 一个在 **OKHttp** 库中，另一个在 **Jsoup** 库中：

```
-keepnames class okhttp3.internal.publicsuffix.PublicSuffixDatabase
-keepnames class org.jsoup.nodes.Entities
```

### 如何为第三方库制定规则

在理想的世界里，每个你使用的依赖都会在 AAR 中提供他们所需要的 ProGuard 规则。有时他们会忘记这样做或只发布 JAR，这些 JAR 没有标准的方式来提供 ProGuard 规则。

在这种情况下，在开始调试应用和制定规则之前，记得查看文档。一些库的作者提供推荐的 ProGuard 规则（例如在 Plaid 中使用的 Retrofit），这可以为你节省大量时间，并让你免受挫折。遗憾的是，很多库都不会这样（例如这篇文章中提到的 Jsoup 和 Bypass 的情况）。另请注意，在某些情况下，随库提供的配置只能在禁用优化的条件下起作用，因此如果你开启了优化，那么你可能踏入了未知领域。

那么当库没有提供规则时，如何制定规则呢？
我只能给你一些提示：

1.  阅读构建输出和 logcat！
2.  构建警告会告诉你添加哪些 `-dontwarn` 规则
3.  `ClassNotFoundException`、`MethodNotFoundException` 和 `FieldNotFoundException` 会告诉你添加哪些 `-keep` 规则

> 当你使用了 ProGuard 的应用崩溃时，你应该庆幸 —— 你将有一个开始调查的地方 :)

> 最糟糕的一类调试问题是你的应用工作了，但是例如屏幕没有显示或没有从网络加载数据。

> 在这里你需要去考虑我在本文中描述的一些场景并动手实践，甚至扎入第三方库的代码中并理解它可能失败的原因，例如当它使用反射、拦截或 JNI时。

### 调试与堆栈跟踪

ProGuard will by default remove many code attributes and hidden metadata that are not required for program execution . Some of those are actually useful to the developer — for example, you might want to retain source file names and line numbers for stack traces to make debugging easier:

```
-keepattributes SourceFile, LineNumberTable
```

> You should also remember to [save the ProGuard mappings files produced when you build a release version and upload them to Play](https://developer.android.com/studio/build/shrink-code.html#decode-stack-trace) to get de-obfuscated stack traces from any crashes experienced by your users.

If you are going to attach a debugger to step through method code in a ProGuarded build of your app, you should also keep the following attributes to retain some debug information about local variables (you only need this line in your `debug` build type):

```
-keepattributes LocalVariableTable, LocalVariableTypeTable
```

### Minified debug build type

The default build types are configured such that _debug_ doesn’t run ProGuard. That makes sense, because we want to iterate and compile fast when developing, but still want the release build to use ProGuard to be as small and optimized as possible.

But in order to fully test and debug any ProGuard problems, it’s good to set up a separate, minified debug build like this:

```
buildTypes {
  debugMini {
    initWith debug
    minifyEnabled true
    shrinkResources true
    proguardFiles getDefaultProguardFile('proguard-android.txt'),
                  'proguard-rules.pro'
    matchingFallbacks = ['debug']
  }
}
```

With this build type, you’ll be able to [connect the debugger](https://developer.android.com/studio/debug/index.html), [run UI tests](https://developer.android.com/training/testing/ui-testing/espresso-testing.html) (also on a CI server) or [monkey test](https://developer.android.com/studio/test/monkey.html) your app for possible problems on a build that’s as close to your release build as possible.

**结论**：When you use ProGuard you should always QA your release builds thoroughly, either by having end-to-end tests or manually going through all screens in your app to see if anything is missing or crashing.

### Runtime annotations, type introspection

ProGuard will by default remove all annotations and even some surplus type information from your code. For some libraries that’s not a problem — those that process annotations and generate code at compile time (such as _Dagger 2_ or _Glide_ and many more) might not need these annotations later on when the program runs.

There is another class of tools that actually inspect annotations or look at type information of parameters and exceptions at runtime. Retrofit for example does this by intercepting your method calls by using a `Proxy` object, then looking at annotations and type information to decide what to put or read from the HTTP request.

**结论**：Sometimes it’s required to retain type information and annotations that are read at runtime, as opposed to compile time. You can check out the [attributes list in the ProGuard manual](https://www.guardsquare.com/en/proguard/manual/attributes).

```
-keepattributes *Annotation*, Signature, Exception
```

> If you’re using the default Android ProGuard configuration file (`_getDefaultProguardFile('proguard-android.txt')_`), the first two options — Annotations and Signature — are specified for you. If you’re not using the default you have to make sure to add them yourself (it also doesn’t hurt to just duplicate them if you know they’re a requirement for your app).

### 将所有内容移至默认包

默认情况下，ProGuard 配置中不会添加 [`-repackageclasses`](https://www.guardsquare.com/en/proguard/manual/usage#repackageclasses) 选项。 If you are already obfuscating your code and have fixed any problems with proper keep rules, you can add this option to further reduce DEX size. It works by moving all classes to the default (root) package, essentially freeing up the space taken up by strings like “_com.example.myapp.somepackage_”.

```
-repackageclasses
```

### ProGuard 优化

正如我之前提到的，ProGuard 可以为你做三件事：As I mentioned before, ProGuard can do 3 things for you:

1.  它摆脱了未使用的代码，
2.  重命名标识符从而使代码更小，
3.  对整个程序进行优化。

在我看来，每个人都应该尝试并配置他们的构建来使1. 和 2. 工作。

为了解锁 3.（额外的优化），你必须使用其他默认的 ProGuard 配置文件。在你的 `build.gradle` 中，将 `proguard-android.txt` 参数改为 `proguard-android-optimize.txt`：

```
release {
  minifyEnabled true
  proguardFiles
      getDefaultProguardFile('proguard-android-optimize.txt'),
      'proguard-rules.pro'
}
```

This will make your release build slower, but will potentially make your app run faster and reduce code size even further, thanks to optimizations such as method inlining, class merging and more aggressive code removal. Be prepared however, that it might introduce new and difficult to diagnose bugs, so use it with caution and if anything isn’t working, be sure to disable certain optimizations or disable the use of the optimizing config altogether.

In the case of Plaid, ProGuard optimizations interfered with how Retrofit uses Proxy objects without concrete implementations, and stripped away some method parameters that were actually required. I had to add this line to my config:

```
-optimizations !method/removal/parameter
```

You can find a [list of possible optimizations and how to disable them in the ProGuard manual](https://www.guardsquare.com/en/proguard/manual/optimizations).

### 何时使用 `@Keep` 和 `-keep`

`@Keep` support is actually implemented as a bunch of `-keep` rules in the default Android ProGuard rules file, so they’re essentially equivalent. Specifying `-keep` rules is more flexible as it offers wildcards, you can also use different variants which do slightly different things (`-keepnames`, `-keepclasseswithmembers` [and more](https://www.guardsquare.com/en/proguard/manual/usage#keepoverview)).

Whenever a simple “keep this class” or “keep this method” rule is needed though, I actually prefer the simplicity of adding a`@Keep` annotation on the class or member, as it stays close to the code, almost like documentation.

If some other developer coming after me wants to refactor the code, they will know immediately that a class/member marked with `@Keep` requires special handling, without having to remember to consult the ProGuard configuration and risking breaking something. Also most code refactorings in the IDE should retain the `@Keep` annotation with the class automatically.

### Plaid 统计信息

这有一些来自 Plaid 的统计信息，它们展示了我通过使用 ProGuard 删除了多少代码。在有更多依赖和更大 DEX 的更复杂的应用上，节省的可能更多。

![](https://cdn-images-1.medium.com/max/1600/1*SMf2Q7j5sL_iu3bcsiLBYw.png)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
