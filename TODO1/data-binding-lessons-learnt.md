> * 原文地址：[Data Binding — Lessons Learnt](https://medium.com/androiddevelopers/data-binding-lessons-learnt-4fd16576b719)
> * 原文作者：[Chris Banes](https://medium.com/@chrisbanes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/data-binding-lessons-learnt.md](https://github.com/xitu/gold-miner/blob/master/TODO1/data-binding-lessons-learnt.md)
> * 译者：
> * 校对者：

# Data Binding — Lessons Learnt

![Photo by [rawpixel](https://unsplash.com/photos/uQkwbaP0UrI?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/13000/1*eAr7ibH_sGkMk51fm7dZIg.jpeg)

The [Data Binding Library](https://developer.android.com/topic/libraries/data-binding/) (referred to as the ‘DB library’ for the rest of this post) offers a flexible and powerful way to bind data to your UIs, but to use an old cliché: ‘with great power comes great responsibility’. Just because you’re using data binding does not mean that you can avoid being a good UI citizen.

I’ve been using data binding on Android for the past few years and this post details some of the things which I’ve learnt along the way.

## Use the standard bindings when possible

[Custom binding adapters](https://developer.android.com/topic/libraries/data-binding/binding-adapters#custom-logic) are a great way to easily add custom functionality to Views. Like a lot of developers, I went a bit far with binding adapters and ended up with a class full of [15 adapters](https://github.com/chrisbanes/tivi/blob/5f785284b618002622781b44806fa469fc2b982e/app/src/main/java/app/tivi/ui/databinding/TiviBindingAdapters.kt) of varying quality.

The worst culprits were a number of adapters which generated formatted strings and set them on `TextViews`. The adapters were usually referenced in just one layout:

While this may look clever there are three big downsides:

1. **Organizing them is a pain**. Unless you’re exceptionally well organised, you’re likely to have one large file containing all of your adapter methods. The antithesis of cohesive and decoupled.

2. **You need to use instrumentation to test**. By definition, your binding adapters do not return a value, they take an input and then set properties on views. That means you have to use a instrumentation to test your custom logic, which makes testing slower and possibly harder to maintain.

3. **Custom binding adapter code is (usually) not optimal.** If you look at the built-in text binding [[here](https://android.googlesource.com/platform/frameworks/data-binding/+/master/extensions/baseAdapters/src/main/java/android/databinding/adapters/TextViewBindingAdapter.java#63)], you’ll see that it does a **lot** of checks to avoid calling [`TextView.setText()`](https://developer.android.com/reference/android/widget/TextView.html#setText(java.lang.CharSequence)), thus saving wasted layout passes. I fell into the trap of thinking that the DB Library would automagically optimise my view updates. And it does, **but only if** you use the built-in binding adapters which are carefully optimised.

Instead, abstract your methods logic into cohesive classes (I call these text creators), then pass them into the binding. From there you can call your text creator and use the built-in view bindings:

This way, we get all of the efficiency from the built-in binding, and we can quite easily unit test the code which creates our formatted strings.

## Make your custom binding adapters efficient

If you really need to use a custom adapter, because the functionality you want does not exist, then try to make it as efficient as possible. By that I mean to use all of the standard Android UI optimizations: avoid triggering measure/layout when at all possible.

This can be as simple as checking what the view is currently using vs. what you’re setting. Here’s a example where we re-implement the standard ImageView adapter for `android:drawable`:

Unfortunately views are not always able to expose state for what we need to check. Here’s an example which sets a toggling max-lines on TextView. It works toggling by changing a TextView’s `maxLines` property, along with a [delayed layout transition](https://developer.android.com/reference/androidx/transition/TransitionManager.html#beginDelayedTransition(android.view.ViewGroup)).

![Just so you get an idea of what it does](https://cdn-images-1.medium.com/max/2000/1*1EFkuX5VCoVr3tZ7OhUdYg.gif)

Previously the binding adapter was simple and always set the `maxLines` property, along with a click listener. TextView will always trigger a layout when `[setMaxLines()](https://developer.android.com/reference/android/widget/TextView.html#setMaxLines(int))` is called, which means that every time the binding adapter is run, a layout is triggered.

So let’s fix it. Since this functionality is completely separate to TextView (we’re just calling `setMaxLines()` with different values when clicked) we need to store the reference the current state. Luckily, the ‘DB Library’ provides a handy way for us to receive this in the binding adapter. By providing the parameter twice, the first parameters receives the **current** value, and the second parameter receives the **new** value.

So here we’re just comparing the **current** and **new**`collapsedMaxLines` values. If the value actually changes we call `setMaxLines()`, etc.

**Edit: Thanks to [Alexandre Gianquinto](undefined) for mentioning about the ‘double parameters’ functionality in the comments.**

## Be careful with what you’re providing as variables

I’ve been slowly re-architecting [Tivi](https://tivi.app) using something which is MVI-like, using the excellent [MvRx library](https://github.com/airbnb/MvRx) to formalise it. What that means in practice is that my fragment/view subscribes to a [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel), and receives ViewState instances. Those instances contain all of the state necessary to display the UI.

Here’s an example state class from Tivi ([link](https://github.com/chrisbanes/tivi/blob/master/app/src/main/java/app/tivi/showdetails/details/ShowDetailsViewState.kt)):

You can see that it’s just a simple data class which contains all of the things which the UI requires to show a details UI about a TV show.

Sounds like a perfect candidate to pass to our data binding instance, and let our binding expressions update the UI, right? Well yes, that does indeed work nicely, but there are a few things to be aware of, and it’s due to how the ‘DB Library’ works.

In data binding you declare inputs, via the `\<variable>` tag, and then write binding expressions referencing those variables on views (attributes). When any of the dependent variables change, the ‘DB Library’ will run your binding expressions (and thus updates views). This change-detection is a great optimization which you get for free.

So back to my scenario. My layouts ended up looking like this:

So I end up having a big global ViewState instance which contains the entire UI state, and as you can imagine these change quite **a lot**. Any small change in the UI state results in a brand new ViewState being generated and passed to our data binding instance.

So what’s the problem? Well since we only have one input variable, all of the binding expressions will reference that variable, which means that the ‘DB Library’ can no longer selectively chose which expressions to run. In practice this means that every time the variable changes (no matter how small) every binding expression is run.

**This problem isn’t related to MVI in particular, it’s just an artifact of combining state and using that with data binding.**

### So what can you do instead?

An alternative is to explicitly declare each variable from your ViewState in your layout, and then explicitly pass through the values from your combined state instance, like so:

This is obviously lot more code for you as the developer to maintain and keep in sync, but it does mean that the ‘DB Library’ can optimise which expressions are run. I would use this pattern if your UI state does not change very often (maybe a few times when created) and the number of variables is low.

Personally I’ve kept using a single variable in my layouts, passing in my ViewState instances, and relying on the fact that our view bindings do the right thing. This is why making our view bindings efficient is really important.

**Another thing to note is that Tivi is a heavy user of [RecyclerView](https://developer.android.com/guide/topics/ui/layout/recyclerview), with [Epoxy](https://github.com/airbnb/epoxy) + [Data Binding](https://github.com/airbnb/epoxy/wiki/Data-Binding-Support), meaning that there is an additional level of change calculation happening in [DiffUtil](https://developer.android.com/reference/androidx/recyclerview/widget/DiffUtil). So if your UIs are largely made up of RecyclerViews too, you’re getting a similar optimization for free anyway.**

## Small wins add up

Hopefully this post has highlighted some of the small things you can do to optimise your data binding implementations. Knowing a little of how the ‘DB Library’ works internally can go a long way in helping you make your data binding efficient, and increase the performance of your UIs.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
