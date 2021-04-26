> * 原文地址：[The Road to Kotlin 1.5](https://www.infoq.com/news/2021/03/the-road-to-kotlin-1-5/)
> * 原文作者：[Michael-Redlich](Michael-Redlich)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-road-to-kotlin-1-5.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-road-to-kotlin-1-5.md)
> * 译者：
> * 校对者：

# The Road to Kotlin 1.5

JetBrains has [released](https://blog.jetbrains.com/kotlin/2021/02/kotlin-1-4-30-released/) Kotlin 1.4.30 with new experimental features that are planned to be stable for Kotlin 1.5, currently in [milestone release](https://blog.jetbrains.com/kotlin/2021/03/kotlin-1-5-0-m2-released-ensure-smooth-migration-to-kotlin-1-5-0/) and scheduled for GA release mid-2021. Considered the last incremental version of Kotlin 1.4.x, these new features include: a new JVM internal representation (IR) compiler backend, support for Java [records](https://kotlinlang.org/docs/whatsnew1430.html#jvm-records-support) and [sealed interfaces](https://kotlinlang.org/docs/whatsnew1430.html#sealed-interfaces), and configuration cache support for the [Kotlin Gradle Plugin](https://kotlinlang.org/docs/gradle.html). JetBrains is [encouraging](https://blog.jetbrains.com/kotlin/2021/02/the-jvm-backend-is-in-beta-let-s-make-it-stable-together/) the Kotlin community to test these new features, especially the new [JVM IR backend](https://kotlinlang.org/docs/whatsnew1430.html#jvm-ir-compiler-backend-reaches-beta), in their applications using Kotlin 1.4.30 and report any bugs using their [YouTrack](https://youtrack.jetbrains.com/issues) issue tracker.

Complementing the compiler frontend, responsible for analyzing the source code, the new JVM IR backend, currently in beta, will be the default compiler in Kotlin 1.5. It is composed of three separate backends: [Kotlin/JVM](https://kotlinlang.org/docs/whatsnew1430.html#kotlin-jvm), [Kotlin/JS](https://kotlinlang.org/docs/js-overview.html) and [Kotlin/Native](https://kotlinlang.org/docs/native-overview.html). The first two, having been developed independently, will be integrated into the new JVM IR infrastructure within Kotlin/Native.

Changes with the new backend include: a number of [bug fixes](https://youtrack.jetbrains.com/issues/KT?q=%23fixed-in-jvm-ir%20sort%20by:%20votes&_ga=2.221556248.1626189385.1614553347-1788185777.1610805116) that were present in the old backend and the development of new language features to improve performance. Android's new toolkit for building UIs, [Jetpack Compose](https://developer.android.com/jetpack/compose), will only work with the new backend.

[Alina Grebenkina](https://www.linkedin.com/in/alina-grebenkina-19756346/), marketing lead at JetBrains, discussing the [advantages](https://blog.jetbrains.com/kotlin/2021/02/the-jvm-backend-is-in-beta-let-s-make-it-stable-together/) of consolidating the three backends, writes:

> We will share a lot of the backend logic and have a unified pipeline to allow most of the features, optimizations, and bug fixes to be done only once for all targets.
> 
> Having a common backend infrastructure opens the door for more multi-platform compiler extensions. It makes it possible to plug into the pipeline and add some custom processing and/or transformations that will automatically work across all targets.

With the [release of Java 16](https://www.infoq.com/news/2021/03/java16-released/), Kotlin has provided support for the new **`[record](https://cr.openjdk.java.net/~briangoetz/amber/datum.html)`** data type to maintain interoperability between Kotlin and Java. A Java **`record`** data type may be declared in Kotlin using the new **`@JvmRecord`** annotation:

```java
@JvmRecord
data class User(val name: String, val age: Int) 
```

Compiler options **`-Xjvm-enable-preview`** and **`-language-version 1.5`** must be used to experiment with this new feature.

Sealed interfaces were designed to complement sealed classes to create a more flexible [sealed class hierarchy](https://kotlinlang.org/docs/whatsnew1430.html#package-wide-sealed-class-hierarchies). It is also possible for a derived class to inherit from more than one sealed interface:

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

To improve the build performance, the Kotlin Gradle plugin is now compatible with the [Gradle configuration cache](https://docs.gradle.org/current/userguide/configuration_cache.html), an incubating Gradle feature that improves build times by caching the result of the configuration phase and reusing it for subsequent builds. Consider the following example:

```bash
$ gradle --configuration-cache help
Calculating task graph as no configuration cache is available for tasks: help
...
BUILD SUCCESSFUL in 4s
1 actionable task: 1 executed
Configuration cache entry stored.
```

Executing the same command again will produce:

```bash
$ gradle --configuration-cache help
Reusing configuration cache.
...
BUILD SUCCESSFUL in 500ms
1 actionable task: 1 executed
Configuration cache entry reused.
```

Notice the difference in build times. The plugin works with Gradle 5.4+ and more details on how to use the configuration cache may be found in the Gradle [documentation](https://docs.gradle.org/current/userguide/configuration_cache.html#config_cache:usage).

Last fall, JetBrains announced they will be following a new [release cadence](https://blog.jetbrains.com/kotlin/2020/10/new-release-cadence-for-kotlin-and-the-intellij-kotlin-plugin/) to provide an updated version of Kotlin every six months.

Further details about this latest release may be found in the [what's new](https://kotlinlang.org/docs/whatsnew1430.html) section of the Kotlin documentation.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
