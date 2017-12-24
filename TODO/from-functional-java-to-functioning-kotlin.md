> * 原文地址：[From functional Java to functioning Kotlin](https://medium.com/google-developers/from-functional-java-to-functioning-kotlin-a4874a4a7a5)
> * 原文作者：[Benjamin Baxter](https://medium.com/@benbaxter?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/from-functional-java-to-functioning-kotlin.md](https://github.com/xitu/gold-miner/blob/master/TODO/from-functional-java-to-functioning-kotlin.md)
> * 译者：
> * 校对者：

# From functional Java to functioning Kotlin

## Converting @FunctionalInterface to Kotlin

Java 8 introduced a new annotation called `[@FunctionalInterface](https://docs.oracle.com/javase/8/docs/api/java/lang/FunctionalInterface.html)`. It’s purpose is to be able to create an interface with one non-default method so that the interface can simulate functions being first class citizens in an Object Oriented language. For example, `[Comparable](https://docs.oracle.com/javase/8/docs/api/java/lang/Comparable.html)` is a `@FunctionalInterface` with one method, `[compareTo(T o)](https://docs.oracle.com/javase/8/docs/api/java/lang/Comparable.html#compareTo-T-)`.

Callbacks are a really common case for functional interfaces. Imaging the following scenario where we want to perform some asynchronous work and return the results back to the client at a later time. In Java, we would have a class that looks like the following:

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

We use a callback interface that has one method that the client code needs to implement.

While using the Kotlin converter in Android Studio, the converter did not optimize converting the `@FunctionalInterface`.

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

The converter created an interface for a one to one conversion, but could this be optimized further? In Kotlin there is a concept called [SAM or Single Abstract Method](https://kotlinlang.org/docs/reference/java-interop.html#sam-conversions). This is exactly what a `@FunctionalInterface` is in Java 8 but the section in the docs to not have an example of how to create a SAM, only how to use a SAM.

After converting the interface into a function in the constructor, the boilerplate code around the `@FunctionalInterface` shank from 96 characters to 38 characters. That’s a reduction of 40%!

```
class MyAwesomeAsyncService(private val onResult: (Result) -> Unit) {
    
    fun doWork() {
        ...
        onResult(result)
    }
}
```

When examining the before and after, you can see how the code melts away into syntactic sugar with Kotlin.

![](https://cdn-images-1.medium.com/max/800/1*E8Kf0zST9OFFPYJGmjBiPw.png)

The before and after converting Java to Kotlin

If you are converting a project or writing in Kotlin, I would love to hear about what you stumbled upon and learned. If you would like to continue the discussion, leave a comment or talk to me on [Twitter](https://twitter.com/benjamintravels).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
