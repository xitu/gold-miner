> * 原文地址：[LiveData with SnackBar, Navigation and other events (the SingleLiveEvent case)](https://medium.com/google-developers/livedata-with-snackbar-navigation-and-other-events-the-singleliveevent-case-ac2622673150)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/livedata-with-snackbar-navigation-and-other-events-the-singleliveevent-case.md](https://github.com/xitu/gold-miner/blob/master/TODO1/livedata-with-snackbar-navigation-and-other-events-the-singleliveevent-case.md)
> * 译者：
> * 校对者：

## LiveData with SnackBar, Navigation and other events (the SingleLiveEvent case)

A convenient way for a view (activity or fragment) to communicate with a ViewModel is to use `[LiveData](https://developer.android.com/topic/libraries/architecture/livedata)` observables. The view subscribes to changes in LiveData and reacts to them. This works well for data that is displayed in a screen continuously.

![](https://cdn-images-1.medium.com/max/800/1*vbhP6Sw61MAK335gEubwHA.png)

**However, some data should be consumed only once,** like a Snackbar message, a navigation event or a dialog trigger.

![](https://cdn-images-1.medium.com/max/800/1*WwhYg9sscdYQgLvC3xks4g.png)

Instead of trying to solve this with libraries or extensions to the Architecture Components, it should be faced as a design problem. **We recommend you treat your events as part of your state**. In this article we show some common mistakes and recommended approaches.

### ❌ Bad: 1. Using LiveData for events

This approach holds a Snackbar message or a navigation signal directly inside a LiveData object. Although in principle it seems like a regular LiveData object can be used for this, it presents some problems.

In a master/detail app, here is the master’s ViewModel:

```
// Don't use this for events
class ListViewModel : ViewModel {
    private val _navigateToDetails = MutableLiveData<Boolean>()

    val navigateToDetails : LiveData<Boolean>
        get() = _navigateToDetails


    fun userClicksOnButton() {
        _navigateToDetails.value = true
    }
}
```

In the View (activity or fragment):

```
myViewModel.navigateToDetails.observe(this, Observer {
    if (it) startActivity(DetailsActivity...)
})
```

The problem with this approach is that the value in `_navigateToDetails` stays true for a long time and it’s not possible to go back to the first screen. Step by step:

1.  The user clicks the button so the Details Activity starts
2.  The user presses back, coming back to the master activity
3.  The observers become active again, after being inactive while activity was in the back stack
4.  The value is still `true` so the Details activity is incorrectly started again

A solution would be to fire the navigation from the ViewModel and immediately set the flag to false:

```
fun userClicksOnButton() {
    _navigateToDetails.value = true
    _navigateToDetails.value = false // Don't do this
}
```

However, one important thing to remember is that LiveData holds values but doesn’t guarantee to emit every value that it receives. For example: a value can be set when no observers are active, so a new one will just replace it. Also, setting values from different threads could lead to race conditions that would only generate one call to the observers.

But the main problem with this approach is that **it’s hard to understand and plain ugly**. How do we make sure the value is reset after the navigation event has happened?

### **❌ Better: 2. Using LiveData for events, resetting event values in observer**

With this approach you add a way to indicate from the View that you already handled the event and that it should be reset.

#### Usage

With a small change to our observers we might have a solution for this:

```
listViewModel.navigateToDetails.observe(this, Observer {
    if (it) {
        myViewModel.navigateToDetailsHandled()
        startActivity(DetailsActivity...)
    }
})
```

Adding the new method in the ViewModel as follows:

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

#### Issues

The problem with this approach is that there’s some boilerplate (one new method in the ViewModel per event) and it’s error prone; it’s easy to forget the call to the ViewModel from the observer.

### **✔️ OK: Use SingleLiveEvent**

The [SingleLiveEvent](https://github.com/googlesamples/android-architecture/blob/dev-todo-mvvm-live/todoapp/app/src/main/java/com/example/android/architecture/blueprints/todoapp/SingleLiveEvent.java) class was created for a sample as a solution that worked for that particular scenario. It is a LiveData that will only send an update once.

#### Usage

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

#### Issues

The problem with SingleLiveEvent is that it’s restricted to one observer. If you inadvertently add more than one, only one will be called and there’s no guarantee of which one.

![](https://cdn-images-1.medium.com/max/800/1*TLeVFNJwRpXCeS7NaF1EaA.png)

### **✔️ Recommended: Use an Event wrapper**

In this approach you manage explicitly whether the event has been handled or not, reducing mistakes.

#### Usage

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

The advantage of this approach is that the user needs to specify the intention by using `getContentIfNotHandled()` or `peekContent()`. This method models the events as part of the state: they’re now simply a message that has been consumed or not.

![](https://cdn-images-1.medium.com/max/800/1*b0z9Flj04zVW_UGsDPQyOA.png)

With an Event wrapper, you can add multiple observers to a single-use event

* * *

In summary: **design events as part of your state**. Use your own [Event](https://gist.github.com/JoseAlcerreca/5b661f1800e1e654f07cc54fe87441af) wrapper in LiveData observables and customize it to fit your needs.

Bonus! Use this [EventObserver](https://gist.github.com/JoseAlcerreca/e0bba240d9b3cffa258777f12e5c0ae9) to remove some repetitive code if you end up having lots of events.

Thanks to [Don Turner](https://medium.com/@donturner?source=post_page), [Nick Butcher](https://medium.com/@crafty?source=post_page), and [Chris Banes](https://medium.com/@chrisbanes?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
