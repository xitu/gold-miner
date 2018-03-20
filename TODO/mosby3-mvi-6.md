> * 原文地址：[REACTIVE APPS WITH MODEL-VIEW-INTENT - PART6 - RESTORING STATE](http://hannesdorfmann.com/android/mosby3-mvi-6)
> * 原文作者：[Hannes Dorfmann](http://hannesdorfmann.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-6.md](https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-6.md)
> * 译者：
> * 校对者：

# 使用MVI编写响应式APP—第六部分—状态恢复

在前面博客中，我们讨论了 Model-View-Intent （MVI）和单项数据流的重要性。这极大的简化了状态恢复。这如何做到和为什么能够做到咧？我们将在这篇博客讨论。

我们在这篇博客中将要关注两种场景: 在内存中恢复状态（例如屏幕的方向发生改变）和恢复一个“持续状态”（从先前存储在 Activity.onSaveInstanceState() 的 Bundle 中恢复）。

## 在内存中

这是一个简单的情况。我们仅仅需要保持我们的由新状态触发的 RxJava 流随着时间推移，独立与安卓组件的生命周期（例如，Acitivity，Fragment 或 ViewGroups）。例如，Mosby（作者写的一个库） 的 **MviBasePresenter** 建立在一个 RxJava 流内部通过使用 **PublishSubject** 来管理 view 的意图，和通过 **BehaviorSubject** 去渲染状态到 view 上。我已经在[第二部分](http://hannesdorfmann.com/android/mosby3-mvi-2)结尾处描述这些实现细节。。最重要的一点是 MviBasePresenter 是独立与 view 生命周期的一个组件，因此一个 view 可以在 Presenter 中被分离和附着。在 Mosby 中只有当 view 永久销毁 Presenter 才会被“摧毁”（垃圾回收）。 这仅仅是 Mosby 的实现细节。你的 MVI 实现可能和这个完全不一样。最重要的是这种组件比如 Presenter 需要独立与 view 的生命周期。因为这样它能够简单的处理 view 的附着和分离事件，无论何时 view 需要重新附着到 Presenter 我们只需简单的调用 **view.render(previousState)** (因此 Mosby 用内部 BehaviorSubject 来处理)。这仅仅是如何解决屏幕方向的一种解决方案。它也可以工作在返回栈导航中，例如，Fragment 在返回栈中，我们如果从返回栈中返回，我们可以简单的再次调用 view.render(previousState) 并且，view 也会显示正确的状态。 事实上，状态就算没有 view 附着也可以被改变。因为 Presenter 的独立与生命周期，并且保持 RxJava 状态流在内存中。想象接收一个改变数据（状态的一部分）的通知，没有 view 附着。无论何时 view 被重新附着，最后的状态（包括从通知中更新的数据）都会交给 view 去渲染。

## 持久化状态

这种场景在单项数据流模式比如 MVI 的情况下也非常简单。让我们讨论，我们想让我们的状态或者我们的 view（例如 Activity）不仅仅在内存中存活，而且也能绕过进程死亡。通常的在 Android 一个被用来存储状态的是 **Activity.onSaveInstanceState(Bundle bundle)** 去保存状态。对比 MVP 或者 MVVM 你不使用 Model 来代表状态 (看 [第一部分](http://hannesdorfmann.com/android/mosby3-mvi-1)) 在 MVI 你的 view 有一个 render（状态）
方法，这让保持最后一个状态变得容易。因此，显然易见的是打包和存储状态到一个 bundle 下面，并且事后恢复它像:

```
class MyActivity extends Activity implements MyView {

  private final static KEY_STATE = "MyStateKey";
  private MyViewState lastState;

  @Override
  public void render(MyState state) {
    lastState = state;
    ... // update UI widgets
  }

  @Override
  public void onSaveInstanceState(Bundle out){
    out.putParcelable(KEY_STATE, lastState);
  }

  @Override
  public void onCreate(Bundle saved){
    super.onCreate(saved);
    MyViewState initialState = null;
    if (saved != null){
      initialState = saved.getParcelable(KEY_STATE);
    }

    presenter = new MyPresenter( new MyStateReducer(initialState) ); // With dagger: new MyDaggerModule(initialState)
  }
  ...
}
```

I think you get the point. Please note that in onCreate() we are not calling view.render(initialState) directly but rather we let the initial state sink down to where state management takes place: the state reducer ([see Part 3](http://hannesdorfmann.com/android/mosby3-mvi-3)) where we use it with **.scan(initialState, reducerFunction)**.

## Conclusion

With a unidirectional data flow and a Model that represents State a lot of state related things are much simpler to implement compared to other patterns. However, usually I don’t persist state into a bundle in my apps for two reasons: First, Bundle has a size limit, so you can’t put arbitrary large state into a bundle (alternatively you could save state into a file or an object store like Realm). Second, we only have discussed how to serialize and deserialize state but that is not necessarily the same as restoring state.

For Example: Let’s assume we have a LCE (Loading-Content-Error) View that displays a loading indicator while loading data and a list of items once the data (items) is loaded. So the state would be like **MyViewState.LOADING**. Let’s assume that loading takes some time and that the Activity process gets killed while loading (i.e. because another app has come into foreground like phone app because of an incoming call). If we just serialize MyViewState.LOADING and deserialize it after Activity has been recreated as described above, our state reducer would just call view.render(MyViewState.LOADING) which is correct so far **BUT** we would actually never invoke loading data again (i.e. start http request) just by using the deserialized state blindly.

As you can see, serializing and deserializing state is not the same as state restoration which may requires some additional steps that increases complexity (still simpler to implement with MVI than with any other architectural pattern I have used so far). Also deserialized state containing some data might be outdated when View gets recreated so that you might have to refresh (load data) anyway. In most of the apps I have worked on I found it much simpler and more user friendly to keep state in memory only and after process death start with a empty initial state as if the app would start the first time. Ideally an app has a cache and offline support so that loading data after process death is fast.

That ultimately leads to a common belief I have had some hard debates about with other android developers: If I use a cache or store, I already have such a component that lives outside of the android component lifecycle and I don’t have to do all that retaining components stuff and MVI nonsense at all, right? Most of the time those android devs are referring to Mike Nakhimovich post [Presenters are not for persisting](https://hackernoon.com/presenters-are-not-for-persisting-f537a2cc7962) where he introduced [NyTimes Store](https://github.com/NYTimes/Store), a data loading and caching library. Unfortunatley, those developers don’t understand that **loading data and caching is NOT state management**. For example what if I have to load data from 2 stores or caches?

Finally, does caching libraries like NyTimes Store help us to deal with process death? Obviously not because process death can happen at any time. Deal with it. The only thing we can do is to beg android operating system not to kill our apps process because we still have some work to do by using android services (which is also such a component that lives outside of other android components lifecycles) or don’t we need android services anymore these days with RxJava, do we? We will talk about android services, RxJava and MVI in the next part. Stay tuned.

Spoiler alert: I think we do need services.

**This post is part of the blog post series "Reactive Apps with Model-View-Intent". Here is the Table of Content:**

*   [Part 1: Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
*   [Part 2: View and Intent](http://hannesdorfmann.com/android/mosby3-mvi-2)
*   [Part 3: State Reducer](http://hannesdorfmann.com/android/mosby3-mvi-3)
*   [Part 4: Independent UI Components](http://hannesdorfmann.com/android/mosby3-mvi-4)
*   [Part 5: Debugging with ease](http://hannesdorfmann.com/android/mosby3-mvi-5)
*   [Part 6: Restoring State](http://hannesdorfmann.com/android/mosby3-mvi-6)
*   [Part 7: Timing (SingleLiveEvent problem)](http://hannesdorfmann.com/android/mosby3-mvi-7)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
