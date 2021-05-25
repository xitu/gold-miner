> * 原文地址：[The Road to Kotlin 1.5](https://www.infoq.com/news/2021/03/the-road-to-kotlin-1-5/)
> * 原文作者：[Michael-Redlich](Michael-Redlich)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-road-to-kotlin-1-5.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-road-to-kotlin-1-5.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[Kimhooo](https://github.com/Kimhooo), [PassionPenguin](https://github.com/PassionPenguin), [PingHGao](https://github.com/PingHGao)

# 走向 Kotlin 1.5

JetBrains 已经[发布了 Kotlin 1.4.30](https://blog.jetbrains.com/kotlin/2021/02/kotlin-1-4-30-released/)，此版本包含一些实验性功能，为其将要发布的 1.5 稳定版本作铺垫，这将是 Kotlin 发展史上的一个[里程碑](https://blog.jetbrains.com/kotlin/2021/03/kotlin-1-5-0-m2-released-ensure-smooth-migration-to-kotlin-1-5-0/)。由于这是 1.4.x 系列最后一个版本，这些新功能包括：JVM 后端 IR 编译器、对 Java [record 关键字](https://kotlinlang.org/docs/whatsnew1430.html#jvm-records-support)和 [sealed interface](https://kotlinlang.org/docs/whatsnew1430.html#sealed-interfaces) 的支持，以及对 [Kotlin Gradle Plugin](https://kotlinlang.org/docs/gradle.html) 的支持。JetBrains 鼓励 Kotlin 技术社区成员在应用程序中使用 1.4.30 版本，对这些新功能进行测试，特别是 [JVM 后端 IR 编译器](https://kotlinlang.org/docs/whatsnew1430.html#jvm-ir-compiler-backend-reaches-beta)，进而通过 [YouTrack](https://youtrack.jetbrains.com/issues) 反馈遇到的 BUG。

现在还处于 beta 阶段的 JVM 后端 IR 编译器用于分析源码，它跟前端编译器形成互补，在 Kotlin 1.5 中它将是默认的编译器。它由三个独立的后端组件构成：[Kotlin/JVM](https://kotlinlang.org/docs/whatsnew1430.html#kotlin-jvm), [Kotlin/JS](https://kotlinlang.org/docs/js-overview.html) 和 [Kotlin/Native](https://kotlinlang.org/docs/native-overview.html)。前两者是由 JetBrains 独立开发的，它们将跟 Kotlin/Native 共同构成新的 JVM IR 基础架构。

后端的变化包括：呈现于原来的后端的一些 [Bug 的修复](https://youtrack.jetbrains.com/issues/KT?q=%23fixed-in-jvm-ir%20sort%20by:%20votes&_ga=2.221556248.1626189385.1614553347-1788185777.1610805116)和用于改进性能的新特性。用于构建 Android UI 的新工具箱和 [Jetpack Compose](https://developer.android.com/jetpack/compose) 将只适用于新的后端。

JetBrains 的市场主管 [Alina Grebenkina](https://www.linkedin.com/in/alina-grebenkina-19756346/) 讲述了三个后端组件合并的[好处](https://blog.jetbrains.com/kotlin/2021/02/the-jvm-backend-is-in-beta-let-s-make-it-stable-together/)，他还写道：

> 后端逻辑中有很多功能是共享的，并且有统一的管道，所以对于任何需求，都可以一次性完成大多数特性、优化和 Bug 的修复工作。
> 
> 统一的后端基础架构使编译器能跨平台使用。它有助于接通管道以及添加某些定制的处理和转换，并且是自动化、适用于一切需求的。

随着 [Java 16 的发布](https://www.infoq.com/news/2021/03/java16-released/)的同时，Kotlin 也支持一种新数据类型 ———— [**`record`**](https://cr.openjdk.java.net/~briangoetz/amber/datum.html)，因此 Kotlin 与 Java 可以互操作。Java 中的 **`record`** 类型在 Kotlin 中可以使用 **`@JvmRecord`** 注解来声明：

```java
@JvmRecord
data class User(val name: String, val age: Int) 
```

编译器必须设置 **`-Xjvm-enable-preview`** 和 **`-language-version 1.5`**，用于测试这一新特性。

Kotlin 中的密封接口是对密封类的补充，它可以创建更灵活的[密封类层次结构](https://kotlinlang.org/docs/whatsnew1430.html#package-wide-sealed-class-hierarchies)。这样，派生类可以继承多个密封接口：

```kotlin
sealed interface Fillable {
    fun fill()
}

sealed interface Polygon {
    val vertices: List<Point>
}

class Rectangle(override val vertices: List<Point>): Fillable, Polygon {
    override fun fill() {
        /*...*/
    }
}
```

为了提高构建效率，Kotlin Gradle 插件如今实现了跟 [Gradle configuration cache](https://docs.gradle.org/current/userguide/configuration_cache.html) 的兼容，这是一个未普遍使用的 Gradle 特性，它的功能是通过缓存配置阶段的结果并在后续构建中重用它来加快构建速度。参考下面的例子：

```bash
$ gradle --configuration-cache help
Calculating task graph as no configuration cache is available for tasks: help
...
BUILD SUCCESSFUL in 4s
1 actionable task: 1 executed
Configuration cache entry stored.
```

再次执行相同的命令，将输出：

```bash
$ gradle --configuration-cache help
Reusing configuration cache.
...
BUILD SUCCESSFUL in 500ms
1 actionable task: 1 executed
Configuration cache entry reused.
```

注意两次构建分别花费的时间。该插件需要 Gradle 5.4 或更高的版本的支持。欲了解更多与配置缓存有关的信息，可以访问 [Gradle 官方文档](https://docs.gradle.org/current/userguide/configuration_cache.html#config_cache:usage)。

去年秋季，JetBrains 宣布将发布新版的 [release cadence](https://blog.jetbrains.com/kotlin/2020/10/new-release-cadence-for-kotlin-and-the-intellij-kotlin-plugin/)，从而实现每隔六个月发布一个新的 Kotlin 版本。 

关于本次新版发布的更多信息，可查看 Kotlin 文档中的[亮点](https://kotlinlang.org/docs/whatsnew1430.html)章节。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
