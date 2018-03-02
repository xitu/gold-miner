> * 原文地址：[REACTIVE APPS WITH MODEL-VIEW-INTENT - PART4 - INDEPENDENT UI COMPONENTS](http://hannesdorfmann.com/android/mosby3-mvi-4)
> * 原文作者：[Hannes Dorfmann](http://hannesdorfmann.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-4.md](https://github.com/xitu/gold-miner/blob/master/TODO/mosby3-mvi-4.md)
> * 译者：
> * 校对者：

# REACTIVE APPS WITH MODEL-VIEW-INTENT - PART4 - INDEPENDENT UI COMPONENTS

In this blog post we will discuss how to build independent UI components and clarify why Parent-Child relations are a code smell in my opinion. Furthermore, we will discuss why I think such relations are needless.

One question that arises from time to time with architectural design patterns such as Model-View-Intent, Model-View-Presenter or Model-View-ViewModel is how do Presenters (or ViewModels) communicate with each other? Or even more specific: How does a “Child-Presenter” communicate with its “Parent-Presenter”?

![wtf](http://hannesdorfmann.com/images/mvi-mosby3/wtf.jpg)

From my point of view such Parent-Child relations are a code smell, because they introduce a direct coupling between both Parent and Child, which leads to code that is hard to read, hard to maintain, where changing requirement affects a lot of components (hence it’s a virtually impossible task in large systems) and last but not least introduces shared state that is hard to predict and even harder to reproduce and debug.

So far so good, but somehow the information must flow from Presenter A to Presenter B: How does a Presenter communicate with another Presenter? **They don’t!** What would a Presenter have to tell another Presenter? _Event X_ has happened? Presenters don’t have to talk to each other, they just observe the same Model (or the same part of the business logic to be precise). That’s how they get notified about changes: from the underlying layer.

![Presenter-Businesslogic](http://hannesdorfmann.com/images/mvi-mosby3/mvp-business-logic.png)

Whenever an _Event X_ happens (i.e. a user clicked on a button in View 1), the Presenter lets that information sink down to the business logic. Since the other Presenters are observing the same business logic, they get notified by the business logic that something has changed (model has been updated).

![Presenter-Businesslogic](http://hannesdorfmann.com/images/mvi-mosby3/mvp-business-logic2.png)

We have already discussed the importance of this principle (unidirectional data flow) in the [first part](http://hannesdorfmann.com/android/mosby3-mvi-1).

Let’s implement this for a real world example: In our shopping app we can put items into the shopping basket. Additionally, there is a screen where we can see the content of our basket and we can select and remove multiple items at once.

<iframe width="894" height="503" src="https://www.youtube.com/embed/ZvnceMj8NoY" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

Wouldn’t it be cool if we could split that big screen into multiple smaller, independent and reusable UI components. Let’s say a Toolbar, that displays the number of items that are selected, and a RecyclerView that actually displays the list of items in the shopping basket.

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

But how do these components communicate with each other? Obviously each component has its own Presenter: **SelectedCountPresenter** and **ShoppingBasketPresenter**. Is that a Parent-Child relation? No, both are just observing the same Model (updated from the same business logic):

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

The code for **ShoppingBasketRecyclerView** looks pretty much the same and therefore we skip that here. However, if we take a closer look at **SelectedCountPresenter** we notice that this Presenter is coupled to **ShoppingCart**. We would like to use the UI component also on other screens in our app. To make that component reusable we have to remove this dependency, which is actually an easy refactoring: The presenter gets an **Observable<Integer>** as Model through the constructor instead of ShoppingCart:

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

Et voilà, we are able to use the SelectedCountToolbar component whenever we have to display the number of items currently selected. That can be the number of items in ShoppingCart but this UI component could also be used in an entirely different context and screen in your app. Moreover, this UI component could be put into a standalone library and used in another app like a photos app to display the number of selected photos.

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

## Conclusion

The aim of this blog post is to demonstrate that a Parent-Child relation is usually not needed at all and can be avoided by simply observing the same part of your business logic. No EventBus, no findViewById() from a parent Activity / Fragment, no presenter.getParentPresenter() or other workarounds are required. Just the observer pattern. With the help of RxJava, which basically implements the observer pattern, we are able to build such reactive UI components easily.

### Additional thoughts

In contrast to MVP or MVVM in MVI we are forced (in a positive way) that business logic drives the state of a certain component. Hence developers with more experience in MVI could come to the following conclusion:

> What if such a view state is the model of another component? What if a view state change of one component is an intent for another component?

Example:

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

At first glance this seems like a valid approach, but isn’t it a variant of a Parent-Child relation? Sure, it’s not a traditional hierarchical Parent-Child relation, it’s more like an onion (the inner one offers a state to the outer one) which seems to be better, but still, a tightly coupled relation, isn’t it? I haven’t made up my mind but I think avoiding this onion-like relation is better for now. If you have a different opinion please leave a comment below. I would love to hear your thoughts.

**This post is part of the blog post series "Reactive Apps with Model-View-Intent".
Here is the Table of Content:**

*   [Part 1: Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
*   [Part 2: View and Intent](http://hannesdorfmann.com/android/mosby3-mvi-2)
*   [Part 3: State Reducer](http://hannesdorfmann.com/android/mosby3-mvi-3)
*   [Part 4: Independent UI Components](http://hannesdorfmann.com/android/mosby3-mvi-4)
*   [Part 5: Debugging with ease](http://hannesdorfmann.com/android/mosby3-mvi-5)
*   [Part 6: Restoring State](http://hannesdorfmann.com/android/mosby3-mvi-6)
*   [Part 7: Timing (SingleLiveEvent problem)](http://hannesdorfmann.com/android/mosby3-mvi-7)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
