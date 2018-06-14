> * 原文地址：[REACTIVE APPS WITH MODEL-VIEW-INTENT - PART4 - INDEPENDENT UI COMPONENTS](http://hannesdorfmann.com/android/mosby3-mvi-4)
> * 原文作者：[Hannes Dorfmann](http://hannesdorfmann.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-4.md](https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-4.md)
> * 译者：[pcdack](https://github.com/pcdack)
> * 校对者：[hanliuxin5](https://github.com/hanliuxin5)

# 使用 MVI 开发响应式 APP — 第四部分 — 独立的UI组件

在这篇博客我们将讨论如何构建独立UI组件，并且要弄清楚为什么在我看来子类和父类关系充满着坏代码的味道。此外，我们将讨论为什么我认为这种关系是不必要的。

不时的出现诸如 Model-View-Intent，Model-View-Presenter 或 Model-View-ViewModel 之类的架构设计模式的一个问题是,Presenter(或ViewModels) 之间是如何通信的?甚至更具体一点，"子-Presenter"如何与它的"父-Presenter"进行沟通？

![wtf](http://hannesdorfmann.com/images/mvi-mosby3/wtf.jpg)

父子关系的组件充满着代码异味，因为它们表示了一种父类与子类的直接耦合，这就导致了代码很难阅读，很难维护，当需求发生变化会影响很多组件（尤其是在大型系统中几乎是不可能完成的任务）最后，同样重要的是，引入了很多很难预测甚至更难去复刻和调试的共享状态。

到现在为止还挺好的，但是我们假设信息必须从 Presenter A 流向 Presenter B:如何让不同的 Presenter 相互间通信？ **它们不通信**！什么样的场景才需要一个 Presenter 不得不与另一个 Presenter 通信？事件 X 发生了？Presenters 完全不用相互间通信，他们仅仅观察相同的 Model(或者精确到相同的业务逻辑)。这是它们如何得到关于变化的通知:从底层。

![Presenter-Businesslogic](http://hannesdorfmann.com/images/mvi-mosby3/mvp-business-logic.png)

无论何时一个事件X发生了(例如:一个用户点击了在View1上的按钮), 这个 Presenter 会让信息下沉到业务逻辑。既然其他的 Presenter 观察相同的业务逻辑, 他们从已经变化的业务逻辑（model 已经发生变化）里得到通知。

![Presenter-Businesslogic](http://hannesdorfmann.com/images/mvi-mosby3/mvp-business-logic2.png)

我们已经在[第一部分](https://juejin.im/post/5a52e4445188257334228b28)强调了一个很重要的原则（单向数据流）。

让我们用真实案例来实现上面的内容：在我们的电商 app 我们可以将任意一项商品放到购物车里。另外，这里还有一个页面，我们可以看到我们购物车的所有商品，并且我们一次性可以选择或者移除多个商品项。

![](https://i.loli.net/2018/03/02/5a98f0759859f.gif)

如果我们可以把这个大的页面分离成很多小的，独立的并且可复用的UI组件，那岂不是很酷？比如说一个 Toolbar，它显示被选择的 item 的数量,和一个用来显示购物车里的商品项列表的 RecyclerView。

```
<LinearLayout>
  <com.hannesdorfmann.SelectedCountToolbar
      android:id="@+id/selectedCountToolbar"
      android:layout_width="match_parent"
      android:layout_height="wrap_content"
      />

  <com.hannesdorfmann.ShoppingBasketRecyclerView
      android:id="@+id/shoppingBasketRecyclerView"
      android:layout_width="match_parent"
      android:layout_height="0dp"
      android:layout_weight="1"
      />
</LinearLayout>
```

但是如何使这些组件进行相互间通信呢？显然每个组件有它自己的 Presenter:**selectedCountPresenter**和**shoppingBasketPresenter**。这是父子关系吗？不，两者都仅仅观察同一个 Model(从相同的业务逻辑里获取更新):

![ShoppingCart-Businesslogic](http://hannesdorfmann.com/images/mvi-mosby3/shoppingcart-businesslogic.png)

```
public class SelectedCountPresenter
    extends MviBasePresenter<SelectedCountView, Integer> {

  private ShoppingCart shoppingCart;

  public SelectedCountPresenter(ShoppingCart shoppingCart) {
    this.shoppingCart = shoppingCart;
  }

  @Override protected void bindIntents() {
    subscribeViewState(shoppingCart.getSelectedItemsObservable(), SelectedCountView::render);
  }
}


class SelectedCountToolbar extends Toolbar implements SelectedCountView {

  ...

  @Override public void render(int selectedCount) {
   if (selectedCount == 0) {
     setVisibility(View.VISIBLE);
   } else {
       setVisibility(View.INVISIBLE);
   }
 }
}
```

**ShoppingBasketRecyclerView** 的代码看起来不错,有很多相同的地方，因此我忽略掉这些相同的地方了。然而，如果我们仔细观察 **selectedCountPresenter** 我们会注意到这个 Presenter 与 **shoppingcart** 耦合。我们想要使用这个 UI 组件可以在我们 App 的其他的页面使用，让这个组件变的可复用，我们需要移除这个依赖，这事实上是一个简单的重构:这个 Presenter 得到一个 **Observable<Integer>** 作为 Model 的构造函数取代原来的 ShoppingCart:

```
public class SelectedCountPresenter
    extends MviBasePresenter<SelectedCountView, Integer> {

  private Observable<Integer> selectedCountObservable;

  public SelectedCountPresenter(Observable<Integer> selectedCountObservable) {
    this.selectedCountObservable = selectedCountObservable;
  }

  @Override protected void bindIntents() {
    subscribeViewState(selectedCountObservable, SelectedCountToolbarView::render);
  }
}
```

就是这样，任何时候，当我们想要显示当前 item 选择数量的时候，我们可以用这个 SelectedCountToolbar 组件。这个组件在购物车，可以记物品项的数量。但是，这个 UI 控件也可以用在你 App 里完全不同的情景下。此外，这个 UI 控件可以放在一个独立库中，并且在其他的 app 中使用，比如一个能显示选择多少张照片的 app。

```
Observable<Integer> selectedCount = photoManager.getPhotos()
    .map(photos -> {
       int selected = 0;
       for (Photo item : photos) {
         if (item.isSelected()) selected++;
       }
       return selected;
    });

return new SelectedCountToolbarPresnter(selectedCount);
```

## 总结

这篇博客的目的是为了演示，父子关系通常来说是不需要的，并且可以避免，通过简单的观察你业务逻辑的相同部分。 不用 EventBus, 不需要从你的父 Activity/Fragment 中 findViewById(),不需要Presenter.getParentPresenter() 或者其他需要其他的解决办法。仅仅需要观察者模式。伴有 RxJava 的帮助，RxJava 是实现观察者模式的基础，我们可以很轻松的构建这样的响应式 UI 组件。

### 另外的思考

通过与 MVP 或者 MVVM 的对比，在 MVI 我们强制（用一种激进的方法）让业务逻辑驱动一定的组件状态。故在使用 MVI 上有经验的开发者总结出下面结论:

> 如果一个 view 状态是另一个组件的 model？如果 view 的状态在一个组件中发生了变化，这个变化是另一个组件的意图,那么如何处理？

例子:

```
Observable<Integer> selectedItemCountObservable =
        shoppingBasketPresenter
           .getViewStateObservable()
           .map(items -> {
              int selected = 0;
              for (ShoppingCartItem item : items) {
                if (item.isSelected()) selected++;
              }
              return selected;
            });

Observable<Boolean> doSomethingBecauseOtherComponentReadyIntent =
        shoppingBasketPresenter
          .getViewStateObservable()
          .filter(state -> state.isShowingData())
          .map(state -> true);

return new SelectedCountToolbarPresenter(
              selectedItemCountObservable,
              doSomethingBecauseOtherComponentReadyIntent);
```

乍一看这似乎是一种有效的方法，但它不是父子关系的变体吗？ 当然，这不是一个传统的分层父子关系，它更像是一个洋葱（内部的给外部状态），这似乎更好，但仍然是一个紧密耦合的关系，不是吗？我还没有下定决心，但我认为现在避免这种类似洋葱的关系更好。 如果您有不同的意见，请在下面留言。 我很想听听你的想法。

**这篇博客是“用 MVI 开发响应式App”的一部分。
下面是内容表:**

*   [Part 1: Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
*   [Part 2: View and Intent](http://hannesdorfmann.com/android/mosby3-mvi-2)
*   [Part 3: State Reducer](http://hannesdorfmann.com/android/mosby3-mvi-3)
*   [Part 4: Independent UI Components](http://hannesdorfmann.com/android/mosby3-mvi-4)
*   [Part 5: Debugging with ease](http://hannesdorfmann.com/android/mosby3-mvi-5)
*   [Part 6: Restoring State](http://hannesdorfmann.com/android/mosby3-mvi-6)
*   [Part 7: Timing (SingleLiveEvent problem)](http://hannesdorfmann.com/android/mosby3-mvi-7)

**这是这个系列博客的中译版：**
* [第一部分:Model](https://juejin.im/post/5a52e4445188257334228b28)
* [第二部分:View 和 Intent](https://juejin.im/post/5a587c06518825732f7eab86)
* [第三部分:状态折叠器](https://juejin.im/post/5a955c50f265da4e853d856a)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
