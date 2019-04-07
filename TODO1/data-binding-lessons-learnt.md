> * 原文地址：[Data Binding — Lessons Learnt](https://medium.com/androiddevelopers/data-binding-lessons-learnt-4fd16576b719)
> * 原文作者：[Chris Banes](https://medium.com/@chrisbanes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/data-binding-lessons-learnt.md](https://github.com/xitu/gold-miner/blob/master/TODO1/data-binding-lessons-learnt.md)
> * 译者：[Mirosalva](https://github.com/Mirosalva)
> * 校对者：

# Data Binding 库使用的经验教训

![由 [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 平台的用户 [rawpixel](https://unsplash.com/photos/uQkwbaP0UrI?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 拍摄](https://cdn-images-1.medium.com/max/13000/1*eAr7ibH_sGkMk51fm7dZIg.jpeg)

[Data Binding 库](https://developer.android.com/topic/libraries/data-binding/) (下文中以『DB 库』词语来指代) 提供了一个灵活强大的方式来绑定数据到 UI 界面。但是要用一句陈词滥调：『能力越大，责任越大』，仅仅是使用数据绑定，并不意味着你可以避免成为一个优秀 UI 开发者。

过去的几年我一直在 Android 开发中使用 data binding 库，本文会写出我这一路上了解到的与它有关的一些内容细节。

## 尽可能使用 bindings 

[自定义 binding adapter](https://developer.android.com/topic/libraries/data-binding/binding-adapters#custom-logic) 是一种给 View 控件轻松提供自定义功能的好方法。和许多开发者一样，我对 binding adapter 研究得稍微深入，最终总结出一套包含不同质量的[15 种适配器](https://github.com/chrisbanes/tivi/blob/5f785284b618002622781b44806fa469fc2b982e/app/src/main/java/app/tivi/ui/databinding/TiviBindingAdapters.kt)的类集。

最糟糕的实践是这类适配器，它们生成格式化的字符串并设置到 `TextViews` 控件，这些适配器通常仅在同一个布局文件中使用：

虽然这可能看起来很聪明，但是有三大缺点：

1. **优化它们的过程太痛苦**。 Unless you’re exceptionally well organised, you’re likely to have one large file containing all of your adapter methods. The antithesis of cohesive and decoupled.

2. **你需要使用 instrumentation 工具来做测试**。 By definition, your binding adapters do not return a value, they take an input and then set properties on views. That means you have to use a instrumentation to test your custom logic, which makes testing slower and possibly harder to maintain.

3. **自定义 binding adapter 代码（通常）不是最佳选项。** If you look at the built-in text binding [[here](https://android.googlesource.com/platform/frameworks/data-binding/+/master/extensions/baseAdapters/src/main/java/android/databinding/adapters/TextViewBindingAdapter.java#63)], you’ll see that it does a **lot** of checks to avoid calling [`TextView.setText()`](https://developer.android.com/reference/android/widget/TextView.html#setText(java.lang.CharSequence)), thus saving wasted layout passes. I fell into the trap of thinking that the DB Library would automagically optimise my view updates. And it does, **but only if** you use the built-in binding adapters which are carefully optimised.

Instead, abstract your methods logic into cohesive classes (I call these text creators), then pass them into the binding. From there you can call your text creator and use the built-in view bindings:

这样我们可以从内建的绑定操作过程中提高效率，并且我们可以非常轻松地对创建格式化字符串的代码进行单元测试。

## 让你的自定义 binding 适配器变得高效

如果你确实需要使用自定义适配器，因为你所需的功能不存在，请尽量使其变得高效。我的意思是使用所有标准的 Android UI 优化：尽可能避免触发测量/布局操作。

这可以像检查当前使用的视图以及你设置的内容一样简单。这里有一个我们为 `android:drawable` 重新实现了标准 ImageView adapter 的样例：

遗憾的是，视图并不总是能够显示我们需要检查的状态。这里有一个在 TextView 上设置切换最大行的示例。它通过改变 TextView 的 `maxLines` 属性以及一个[延时布局转换](https://developer.android.com/reference/androidx/transition/TransitionManager.html#beginDelayedTransition(android.view.ViewGroup)来实现切换。

![这样你就可以了解它的作用](https://cdn-images-1.medium.com/max/2000/1*1EFkuX5VCoVr3tZ7OhUdYg.gif)

之前 binding adapter 比较简单并且总是设置了 `maxLines` 属性和一个点击监听对象。TextView 在 `[setMaxLines()](https://developer.android.com/reference/android/widget/TextView.html#setMaxLines(int))` 被调用后总会触发一次布局，这就意味着每次 binding adapter 启动，一次布局就会被触发。

让我们改变这个情况。由于此功能与TextView 是完全分开的（我们只是在单击时使用不同的值调用 `setMaxLines（）`），我们需要将引用存储为当前状态。幸运的是，『DB 库』为我们提供了一个手工方式去在 binding adapter 中接收状态。通过提供参数两次：第一个参数接收**当前**值，第二个参数接收**新**值。

所以这里我们只需比较**当前的**和**新的** `collapsedMaxLines` 值。如果值实际发生了改变，我们才去调用 `setMaxLines()` 等方法。

**编辑按: 感谢 [Alexandre Gianquinto](undefined) 在评论中提到『double parameters』功能。**

## 谨慎对待你提供的变量

我一直在慢慢的重新设计 [Tivi](https://tivi.app)，使用类似 MVI 的东西，使用优秀的 [MvRx 库](https://github.com/airbnb/MvRx)来使它变得规范化。这在实践中意味着我的 fragment/view 订阅到 [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel)对象，并且接收 ViewStates 的实例。这些实例包含所有用于显示 UI 的必要状态。

这是一个展示 Tivi（[链接](https://github.com/chrisbanes/tivi/blob/master/app/src/main/java/app/tivi/showdetails/details/ShowDetailsViewState.kt)）中类的样例：

你可以看到它仅仅是一个简单的数据类，包含了 UI 需要在一个 TV 秀界面上显示的所有细节 UI 元素。

Sounds like a perfect candidate to pass to our data binding instance, and let our binding expressions update the UI, right? Well yes, that does indeed work nicely, but there are a few things to be aware of, and it’s due to how the ‘DB Library’ works.

In data binding you declare inputs, via the `\<variable>` tag, and then write binding expressions referencing those variables on views (attributes). When any of the dependent variables change, the ‘DB Library’ will run your binding expressions (and thus updates views). This change-detection is a great optimization which you get for free.

So back to my scenario. My layouts ended up looking like this:

So I end up having a big global ViewState instance which contains the entire UI state, and as you can imagine these change quite **a lot**. Any small change in the UI state results in a brand new ViewState being generated and passed to our data binding instance.

So what’s the problem? Well since we only have one input variable, all of the binding expressions will reference that variable, which means that the ‘DB Library’ can no longer selectively chose which expressions to run. In practice this means that every time the variable changes (no matter how small) every binding expression is run.

**This problem isn’t related to MVI in particular, it’s just an artifact of combining state and using that with data binding.**

### 那么你能做什么的呢？

An alternative is to explicitly declare each variable from your ViewState in your layout, and then explicitly pass through the values from your combined state instance, like so:

This is obviously lot more code for you as the developer to maintain and keep in sync, but it does mean that the ‘DB Library’ can optimise which expressions are run. I would use this pattern if your UI state does not change very often (maybe a few times when created) and the number of variables is low.

Personally I’ve kept using a single variable in my layouts, passing in my ViewState instances, and relying on the fact that our view bindings do the right thing. This is why making our view bindings efficient is really important.

**Another thing to note is that Tivi is a heavy user of [RecyclerView](https://developer.android.com/guide/topics/ui/layout/recyclerview), with [Epoxy](https://github.com/airbnb/epoxy) + [Data Binding](https://github.com/airbnb/epoxy/wiki/Data-Binding-Support), meaning that there is an additional level of change calculation happening in [DiffUtil](https://developer.android.com/reference/androidx/recyclerview/widget/DiffUtil). So if your UIs are largely made up of RecyclerViews too, you’re getting a similar optimization for free anyway.**

## 小步迭代

希望这篇文章强调了一些可以优化数据绑定实现方案中的一些小事。 了解『DB 库』的内部机制可以帮助你提高数据绑定效率，并提高 你的 UI 性能。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
