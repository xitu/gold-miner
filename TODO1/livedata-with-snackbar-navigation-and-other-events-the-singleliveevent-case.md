> * 原文地址：[LiveData with SnackBar, Navigation and other events (the SingleLiveEvent case)](https://medium.com/google-developers/livedata-with-snackbar-navigation-and-other-events-the-singleliveevent-case-ac2622673150)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/livedata-with-snackbar-navigation-and-other-events-the-singleliveevent-case.md](https://github.com/xitu/gold-miner/blob/master/TODO1/livedata-with-snackbar-navigation-and-other-events-the-singleliveevent-case.md)
> * 译者：[wzasd](github.com/wzasd)
> * 校对者：[LeeSniper](github.com/LeeSniper)

## 在 SnackBar，Navigation 和其他事件中使用 LiveData（SingleLiveEvent 案例）
视图层（Activity 或者 Fragment）与 ViewModel 层进行通讯的一种便捷的方式就是使用 [`LiveData`](https://developer.android.com/topic/libraries/architecture/livedata) 来进行观察。这个视图层订阅 Livedata 的数据变化并对其变化做出反应。这适用于连续不断显示在屏幕的数据。


![](https://cdn-images-1.medium.com/max/800/1*vbhP6Sw61MAK335gEubwHA.png)

**但是，有一些数据只会消费一次**，就像是 Snackbar 消息，导航事件或者对话框。

![](https://cdn-images-1.medium.com/max/800/1*WwhYg9sscdYQgLvC3xks4g.png)

这应该被视为设计问题，而不是试图通过架构组件的库或者扩展来解决这个问题。**我们建议您将您的事件视为您的状态的一部分**。在本文中，我们将展示一些常见的错误方法，以及推荐的方式。

### ❌ 错误：1. 使用 LiveData 来解决事件

这种方法来直接的在 LiveData 对象的内部持有 Snackbar 消息或者导航信息。尽管原则上看起来像是普通的 LiveData 对象可以用在这里，但是会出现一些问题。

在一个主/从应用程序中，这里是主 ViewModel：

```
// 不要使用这个事件
class ListViewModel : ViewModel {
    private val _navigateToDetails = MutableLiveData<Boolean>()

    val navigateToDetails : LiveData<Boolean>
        get() = _navigateToDetails


    fun userClicksOnButton() {
        _navigateToDetails.value = true
    }
}
```

在视图层（Activity 或者 Fragment）：

```
myViewModel.navigateToDetails.observe(this, Observer {
    if (it) startActivity(DetailsActivity...)
})
```

这种方法的问题是 `_navigateToDetails` 中的值会长时间保持为真，并且无法返回到第一个屏幕。一步一步进行分析：

1.  用户点击按钮 Details Activity 启动。
2.  用户用户按下返回，回到主 Activity。
3.  观察者在 Activity 处于回退栈时从非监听状态再次变成监听状态。
4.  但是该值仍然为 “真”，因此 Detail Activity 启动出错。

解决方法是从 ViewModel 中将导航的标志点击后立刻设为 false;

```
fun userClicksOnButton() {
    _navigateToDetails.value = true
    _navigateToDetails.value = false // Don't do this
}
```

但是，需要记住的一件很重要的事就是 LiveData 储存这个值，但是不保证发出它接受到的每个值。例如：当没有观察者处于监听状态时，可以设置一个值，因此新的值将会替换它。此外，从不同线程设置值的时候可能会导致资源竞争，只会向观察者发出一次改变信号。

但是这种方法的主要问题是**难以理解和不简洁**。在导航事件发生后，我们如何确保值被重置呢？

### **❌ 可能更好一些：2. 使用 LiveData 进行事件处理，在观察者中重置事件的初始值**

通过这种方法，您可以添加一种方法来从视图中支出您已经处理了该事件，并且重置该事件。

#### 用法

对我们的观察者进行一些小改动，我们就有了这样的解决方案：

```
listViewModel.navigateToDetails.observe(this, Observer {
    if (it) {
        myViewModel.navigateToDetailsHandled()
        startActivity(DetailsActivity...)
    }
})
```

像下面这样在 ViewModel 中添加新的方法：

```
class ListViewModel : ViewModel {
    private val _navigateToDetails = MutableLiveData<Boolean>()

    val navigateToDetails : LiveData<Boolean>
        get() = _navigateToDetails


    fun userClicksOnButton() {
        _navigateToDetails.value = true
    }

    fun navigateToDetailsHandled() {
        _navigateToDetails.value = false
    }
}
```

#### 问题

这种方法的问题是有一些死板（每个事件在 ViewModel 中有一个新的方法），并且很容易出错，观察者很容易忘记调用这个 ViewModel 的方法。

### **✔️ 正确解决方法: 使用 SingleLiveEvent**

这个 [SingleLiveEvent](https://github.com/googlesamples/android-architecture/blob/dev-todo-mvvm-live/todoapp/app/src/main/java/com/example/android/architecture/blueprints/todoapp/SingleLiveEvent.java) 类是为了适用于特定场景的解决方法。这是一个只会发送一次更新的 LiveData。

#### 用法

```
class ListViewModel : ViewModel {
    private val _navigateToDetails = SingleLiveEvent<Any>()

    val navigateToDetails : LiveData<Any>
        get() = _navigateToDetails


    fun userClicksOnButton() {
        _navigateToDetails.call()
    }
}
```

```
myViewModel.navigateToDetails.observe(this, Observer {
    startActivity(DetailsActivity...)
})
```

#### 问题

SingleLiveEvent 的问题在于它仅限于一个观察者。如果您无意中添加了多个，则只会调用一个，并且不能保证哪一个。

![](https://cdn-images-1.medium.com/max/800/1*TLeVFNJwRpXCeS7NaF1EaA.png)

### **✔️ 推荐: 使用事件包装器**

在这种方法中，您可以明确地管理事件是否已经被处理，从而减少错误。

#### 用法

```
/**
 * Used as a wrapper for data that is exposed via a LiveData that represents an event.
 */
open class Event<out T>(private val content: T) {

    var hasBeenHandled = false
        private set // Allow external read but not write

    /**
     * Returns the content and prevents its use again.
     */
    fun getContentIfNotHandled(): T? {
        return if (hasBeenHandled) {
            null
        } else {
            hasBeenHandled = true
            content
        }
    }

    /**
     * Returns the content, even if it's already been handled.
     */
    fun peekContent(): T = content
}
```

```
class ListViewModel : ViewModel {
    private val _navigateToDetails = MutableLiveData<Event<String>>()

    val navigateToDetails : LiveData<Event<String>>
        get() = _navigateToDetails


    fun userClicksOnButton(itemId: String) {
        _navigateToDetails.value = Event(itemId)  // Trigger the event by setting a new Event as a new value
    }
}
```

```
myViewModel.navigateToDetails.observe(this, Observer {
    it.getContentIfNotHandled()?.let { // Only proceed if the event has never been handled
        startActivity(DetailsActivity...)
    }
})
```

这种方法的优点在于用户使用 `getContentIfNotHandled()` 或者 `peekContent()` 来指定意图。这个方法将事件建模为状态的一部分：他们现在只是一个消耗或者不消耗的消息。

![](https://cdn-images-1.medium.com/max/800/1*b0z9Flj04zVW_UGsDPQyOA.png)

使用事件包装器，您可以将多个观察者添加到一次性事件中。

* * *

总之：**把事件设计成你的状态的一部分**。使用您自己的[事件](https://gist.github.com/JoseAlcerreca/5b661f1800e1e654f07cc54fe87441af)包装器并根据您的需求进行定制。

银弹！若您最终发生大量事件，请使用这个 [EventObserver](https://gist.github.com/JoseAlcerreca/e0bba240d9b3cffa258777f12e5c0ae9) 可以删除很多无用的代码。

感谢 [Don Turner](https://medium.com/@donturner?source=post_page)，[Nick Butcher](https://medium.com/@crafty?source=post_page)，和 [Chris Banes](https://medium.com/@chrisbanes?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
