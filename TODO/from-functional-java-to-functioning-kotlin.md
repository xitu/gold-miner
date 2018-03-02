> * 原文地址：[From functional Java to functioning Kotlin](https://medium.com/google-developers/from-functional-java-to-functioning-kotlin-a4874a4a7a5)
> * 原文作者：[Benjamin Baxter](https://medium.com/@benbaxter?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/from-functional-java-to-functioning-kotlin.md](https://github.com/xitu/gold-miner/blob/master/TODO/from-functional-java-to-functioning-kotlin.md)
> * 译者：[huanglizhuo](https://github.com/huanglizhuo)
> * 校对者：[atuooo](https://github.com/atuooo)，[hanliuxin5](https://github.com/hanliuxin5)

# 函数式 Java 到函数式 Kotlin 的转换

## 将 @FunctionalInterface 转换到 Kotlin 中

Java 8 中引入了新的注解 [@FunctionalInterface](https://docs.oracle.com/javase/8/docs/api/java/lang/FunctionalInterface.html)。目的是为创建一个带有非默认方法的接口，这样这个接口就可以将函数模拟成面向对象语言中的一等公民。比如，[Comparable](https://docs.oracle.com/javase/8/docs/api/java/lang/Comparable.html) 就是只带有一个 [compareTo](https://docs.oracle.com/javase/8/docs/api/java/lang/Comparable.html#compareTo-T-) 方法的 `@FunctionalInterface`。

回调在函数式接口中很常见。想象一下下面的场景，我们想要进行一些异步操作，稍后将结果返回给调用的客户端。在 Java 中，我们可以创建一个下面这样的类：

```
public class MyAwesomeAsyncService {
   
    @FunctionalInterface
    public interface AwesomeCallback {
        void onResult(Result result);
    }
    private final AwesomeCallback callback;
   
    public MyAwesomeAsyncService(AwesomeCallback callback) {
        this.callback = callback;
    }
    public void doWork() {
        ...
        callback.onResult(result);
    }
}
```

我们使用了有一个方法的回调接口，调用者只需实现它即可。

然而 Android Studio 附带的 Kotlin 转换器对 `@FunctionalInterface` 注解的转换并不是最优的。

```
class MyAwesomeAsyncService(private val callback: AwesomeCallback) {
   
    @FunctionalInterface
    interface AwesomeCallback {
        fun onResult(result: Result)
    }
    fun doWork() {
        ...
        callback.onResult(result)
    }
}
```

转换结果是创建了一个一对一个转换接口，但这可以进一步优化吗？
在 Kotlin 中有个 [SAM（Single Abstract Method）单个抽象方法](https://kotlinlang.org/docs/reference/java-interop.html#sam-conversions)概念。这正是 Java 8 中 `@FunctionalInterface` 的注解，但在文档中却没有创建 SAM 的例子，只讲了如何使用 SAM。

在构造函数中把接口转换为函数后，`@FunctionalInterface` 部分的样板代码从 96 个字符减少到 38 个字符，这可是减少了 40%。


```
class MyAwesomeAsyncService(private val onResult: (Result) -> Unit) {
    
    fun doWork() {
        ...
        onResult(result)
    }
}
```

前后对比过后，你就会体会到 Kotlin 中这些语法糖是多么的好用。

![](https://cdn-images-1.medium.com/max/800/1*E8Kf0zST9OFFPYJGmjBiPw.png)

上面的图片是 Java 转换为 Kotlin 的对比。

如果你也在使用 Kotlin 改造或者编写项目，欢迎在我的 [Twitter](https://twitter.com/benjamintravels) 下面评论交流你使用 Kotlin 中踩坑填坑经历。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
