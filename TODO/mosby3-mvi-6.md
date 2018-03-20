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

这是一个简单的情况。我们仅仅需要保持我们的由新状态触发的 RxJava 流随着时间推移，独立与安卓组件的生命周期（例如，Acitivity，Fragment 或 ViewGroups）。例如，Mosby（作者写的一个库） 的 **MviBasePresenter** 建立在一个 RxJava 流内部通过使用 **PublishSubject** 来管理 view 的意图，和通过 **BehaviorSubject** 去渲染状态到 view 上。我已经在[第二部分](http://hannesdorfmann.com/android/mosby3-mvi-2)结尾处描述这些实现细节。最重要的一点是 MviBasePresenter 是独立与 view 生命周期的一个组件，因此一个 view 可以在 Presenter 中被分离和附着。在 Mosby 中只有当 view 永久销毁 Presenter 才会被“摧毁”（垃圾回收）。 这仅仅是 Mosby 的实现细节。你的 MVI 实现可能和这个完全不一样。最重要的是这种组件比如 Presenter 需要独立与 view 的生命周期。因为这样它能够简单的处理 view 的附着和分离事件，无论何时 view 需要重新附着到 Presenter 我们只需简单的调用 **view.render(previousState)** (因此 Mosby 用内部 BehaviorSubject 来处理)。这仅仅是如何解决屏幕方向的一种解决方案。它也可以工作在返回栈导航中，例如，Fragment 在返回栈中，我们如果从返回栈中返回，我们可以简单的再次调用 view.render(previousState) 并且，view 也会显示正确的状态。 事实上，状态就算没有 view 附着也可以被改变。因为 Presenter 的独立与生命周期，并且保持 RxJava 状态流在内存中。想象接收一个改变数据（状态的一部分）的通知，没有 view 附着。无论何时 view 被重新附着，最后的状态（包括从通知中更新的数据）都会交给 view 去渲染。

## 持久化状态

这种场景在单项数据流模式比如 MVI 的情况下也非常简单。让我们讨论，我们想让我们的状态或者我们的 view（例如 Activity）不仅仅在内存中存活，而且也能绕过进程死亡。通常的在 Android 一个被用来存储状态的是 **Activity.onSaveInstanceState(Bundle bundle)** 去保存状态。对比 MVP 或者 MVVM 你不使用 Model 来代表状态 (看 [第一部分](http://hannesdorfmann.com/android/mosby3-mvi-1)) 在 MVI 你的 view 有一个 render（状态）
方法，这让保持最后一个状态变得容易。因此，显然易见的是打包和存储状态到一个 bundle 下面，并且事后恢复它,例如:

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

我知道你已经掌握了要点。请注意在 onCreate() 方法中我们不能直接调用 view.render(state)，取而代之，我们应该让初始化状态下沉到状态管理的地方:状态折叠器([看第三部分](http://hannesdorfmann.com/android/mosby3-mvi-3))在这里我们用 **.scan(initialState，reducerFunction)**。

## 结论

随着单向数据流和一个 Model 代表一种状态，很多与状态相关的事情，变得相对于其他的模式更加简单。然而，通常在我的 APP 中，我不会持久化状态到 bundle 有以下两点原因：第一， Bundle 有大小限制，因此你不能存很大的状态在 bundle中（另外，你需要存储状态到文件，或者，存储到对象存储例如 Realm）。第二，我们仅仅讨论如何去序列化和反序列化，但是，这不一定与恢复状态相同。

例子：让我们假设我们有一个 LCE(Loading-Content-Error) 的 view，这个 view当加载数据的和项列表的时候，用来显示一个加载指示器。 因此，这个状态应当是 **MyViewState.LOADING**。让我们假设加载需要消耗一定的时间，就在加载时候， Activity 进程也被杀掉了(例如，因为其他应用程序占据了前台，像电话 app因为女票的电话而占据了前台)。如果我们就像上面描述的一样，当 Acitivity 被重新创建的时候，反序列化它。我们的状态折叠器，会仅仅调用 view.render (MyViewState.LOADING)。到目前为止都是正确的**但是**，我们事实上不应该再次调用加载数据（例如，开启一个 http 请求）这是盲目的使用反序列化状态。

正如你所见, 序列化与反序列化状态，并不同于状态恢复。状态恢复也许需要一些添加步骤来减少复杂性（使用 MVI 实现比其他的架构模式更加简单，到目前为止，我一直在用）。当 view 被重新创建的时候，反序列化状态包含了一些过期数据。因此，你需要想尽办法更新数据。在大多数 app 中，我通过努力找到了一种更简单和更加友好的方法，仅仅保持状态到内存中。并且当进程死亡的时候，开启一个空的初始化状态就像 app 第一次启动一样。理想情况下一个 app 有缓存和离线支持，因此当进程死亡，重新加载数据是很快的。

这最终导致一个共同的信念。我与其他的安卓开发者有过争论:如果用缓存或存储，我有一个组件，独立与安卓组件的生命周期，并且，我不得不去写这些固定组件的代码，而且 MVI 是个荒谬的东西，对么？ 大多数这些安卓开发者推荐 Mike Nakhimovich 发表的[Presenter 不是为了持久化](https://hackernoon.com/presenters-are-not-for-persisting-f537a2cc7962)这篇文章用来介绍 [NyTimes Store](https://github.com/NYTimes/Store),一个数据加载和缓存库。不幸的是，这些这些开发者不理解**加载数据和缓存不是状态管理**。例如，如果我不得不从两个缓存或存储中加载数据？

最后,像 NyTimes 缓冲库帮助我们处理进程死亡了么？很显然没有，因为进程死亡随时可能发生。解决这个问题。我们仅仅能做的是乞求安卓操作系统不要杀死我们的 app 进程，因为我们依旧需要做一些工作通过安卓的 service （这个组件也是独立于其他安卓组件的生命周期）或者我们现在用 rxjava 来取代 service，我们可以这样么？我们讨论关于安卓的 service，rxjava 和 MVI 在下一部分。敬请期待(๑˙ー˙๑)。

警告: 我认为我们需要服务。

**这篇博客是 "用 MVI 开发响应式App"中的一片博客。下面是内容表:**

*   [Part 1: Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
*   [Part 2: View and Intent](http://hannesdorfmann.com/android/mosby3-mvi-2)
*   [Part 3: State Reducer](http://hannesdorfmann.com/android/mosby3-mvi-3)
*   [Part 4: Independent UI Components](http://hannesdorfmann.com/android/mosby3-mvi-4)
*   [Part 5: Debugging with ease](http://hannesdorfmann.com/android/mosby3-mvi-5)
*   [Part 6: Restoring State](http://hannesdorfmann.com/android/mosby3-mvi-6)
*   [Part 7: Timing (SingleLiveEvent problem)](http://hannesdorfmann.com/android/mosby3-mvi-7)


**这是中文翻译:**
* [第一部分：Model](https://juejin.im/post/5a52e4445188257334228b28)
* [第二部分:View 和 Intent](https://juejin.im/post/5a587c06518825732f7eab86)
* [第三部分:状态折叠器](https://juejin.im/post/5a955c50f265da4e853d856a)
* [第四部分:独立 UI 组件开发](https://juejin.im/post/5a9debfbf265da23830a6230)
* [第五部分 — 简单的调试](https://juejin.im/post/5aafa3e851882555627d1842)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
