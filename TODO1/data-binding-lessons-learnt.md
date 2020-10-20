> * 原文地址：[Data Binding — Lessons Learnt](https://medium.com/androiddevelopers/data-binding-lessons-learnt-4fd16576b719)
> * 原文作者：[Chris Banes](https://medium.com/@chrisbanes)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/data-binding-lessons-learnt.md](https://github.com/xitu/gold-miner/blob/master/TODO1/data-binding-lessons-learnt.md)
> * 译者：[Mirosalva](https://github.com/Mirosalva)
> * 校对者：[DevMcryYu](https://github.com/DevMcryYu)

# Data Binding 库使用的经验教训

![由 [Unsplash](https://unsplash.com/?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 平台的用户 [rawpixel](https://unsplash.com/photos/uQkwbaP0UrI?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) 拍摄](https://cdn-images-1.medium.com/max/13000/1*eAr7ibH_sGkMk51fm7dZIg.jpeg)

[Data Binding 库](https://developer.android.com/topic/libraries/data-binding/)（下文中以『DB 库』词语来指代）提供了一个灵活强大的方式来绑定数据到 UI 界面。但是要用一句陈词滥调：『能力越大，责任越大』，仅仅是使用数据绑定，并不意味着你可以避免成为一个优秀 UI 开发者。

过去的几年我一直在 Android 开发中使用 data binding 库，本文会写出我这一路上了解到的与它有关的一些内容细节。

## 尽可能使用 bindings 

[自定义 binding adapter](https://developer.android.com/topic/libraries/data-binding/binding-adapters#custom-logic) 是一种给 View 控件轻松提供自定义功能的好方法。和许多开发者一样，我对 binding adapter 研究得稍微深入，最终总结出一套包含 [15 种不同用途的适配器](https://github.com/chrisbanes/tivi/blob/5f785284b618002622781b44806fa469fc2b982e/app/src/main/java/app/tivi/ui/databinding/TiviBindingAdapters.kt)的类集。

最糟糕的实践是这类适配器，它们生成格式化的字符串并设置到 `TextViews` 控件，这些适配器通常仅在同一个布局文件中使用：

虽然这可能看起来很聪明，但是有三大缺点：

1. **优化它们的过程太痛苦**。除非你把代码组织得非常好，否则你可能会有一个包含所有适配器方法的大文件，这与代码内聚和解耦原则相违背。

2. **你需要使用 instrumentation 工具来做测试**。根据定义，你的 binding adapter 不会有返回值，它们接收一个输入参数后设置 view 的属性。这就意味着你必须使用 instrumentation 来测试你的自定义逻辑，这样会使得测试变得既缓慢又难以维护。

3. **自定义 binding adapter 代码（通常）不是最佳选项**。如果你查看内建文本绑定[[参考这里](https://android.googlesource.com/platform/frameworks/data-binding/+/master/extensions/baseAdapters/src/main/java/android/databinding/adapters/TextViewBindingAdapter.java#63)]，你将会看到已经做了许多检查来避免调用 [`TextView.setText()`](https://developer.android.com/reference/android/widget/TextView.html#setText(java.lang.CharSequence))，这样就节省了被浪费的布局检测。我觉得自己陷入了这样的思维困境：DB 库将会自动优化我的 view 更新。它确实可以做到，但**仅限于**你使用被谨慎优化的内建 binding adapter的情况。

相反的，把你的方法的逻辑抽象为内聚类（我称之为文本创建者类），然后将它们传递给 binding。这样你就可以调用你的文本创建者类并使用内建 view binding：

这样我们可以从内建的绑定操作过程中提高效率，并且我们可以非常轻松地对创建格式化字符串的代码进行单元测试。

## 让你的自定义 binding 适配器变得高效

如果你确实需要使用自定义适配器，因为你所需的功能不存在，请尽量使其变得高效。我的意思是使用所有标准的 Android UI 优化：尽可能避免触发测量/布局操作。

这可以像检查当前使用的视图以及你设置的内容一样简单。这里有一个我们为 `android:drawable` 重新实现了标准 ImageView adapter 的样例：

遗憾的是，视图并不总是能够显示我们需要检查的状态。这里有一个在 TextView 上设置切换最大行的示例。它通过改变 TextView 的 `maxLines` 属性以及一个[延时布局转换](https://developer.android.com/reference/androidx/transition/TransitionManager.html#beginDelayedTransition)(android.view.ViewGroup)来实现切换。

![这样你就可以了解它的作用](https://cdn-images-1.medium.com/max/2000/1*1EFkuX5VCoVr3tZ7OhUdYg.gif)

之前 binding adapter 比较简单并且总是设置了 `maxLines` 属性和一个点击监听对象。TextView 在 [`setMaxLines()`](https://developer.android.com/reference/android/widget/TextView.html#setMaxLines(int)) 被调用后总会触发一次布局，这就意味着每次 binding adapter 启动，一次布局就会被触发。

让我们改变这个情况。由于此功能与 TextView 是完全分开的（我们只是在单击时使用不同的值调用 `setMaxLines()`），我们需要将引用存储为当前状态。幸运的是，『DB 库』为我们提供了一个手工方式去在 binding adapter 中接收状态。通过提供参数两次：第一个参数接收**当前**值，第二个参数接收**新**值。

所以这里我们只需比较**当前的**和**新的** `collapsedMaxLines` 值。如果值实际发生了改变，我们才去调用 `setMaxLines()` 等方法。

**编辑按: 感谢 Alexandre Gianquinto 在评论中提到『double parameters』功能。**

## 谨慎对待你提供的变量

我一直在慢慢的重新设计 [Tivi](https://tivi.app)，使用类似 MVI 的东西，使用优秀的 [MvRx 库](https://github.com/airbnb/MvRx)来使它变得规范化。这在实践中意味着我的 fragment/view 订阅到 [ViewModel](https://developer.android.com/reference/androidx/lifecycle/ViewModel)对象，并且接收 ViewStates 的实例。这些实例包含所有用于显示 UI 的必要状态。

这是一个展示 Tivi（[链接](https://github.com/chrisbanes/tivi/blob/master/app/src/main/java/app/tivi/showdetails/details/ShowDetailsViewState.kt)）中类的样例：

你可以看到它仅仅是一个简单的数据类，包含了 UI 需要在一个 TV 秀界面上显示的所有细节 UI 元素。

听起来像是传递我们的 data binding 实例对象的完美选项，让我们的 binding 表达式来去更新 UI，对吧？好吧这确实有效，但是有一些需要注意的地方，这是由于『DB 库』的工作机制。

在 data binding 中你通过 `<variable>` 标签声明了输入，然后在书写 binding 表达式时在 view 属性处引用了这些输入变量。当任何被依赖的变量发生变化，『DB 库』都会运行你的 binding 表达式（接着会更新 view）。这个变化检测就是你可以免费获取的很棒的优化。

所以回到我的场景，我的布局最终看起来是这样的：

所以我最终获取一个包含所有 UI 状态的全局 ViewState 实例，并且你可以想象出这些状态**经常**会发生变化。UI 状态的任何轻微变化都会产生一个全新的 ViewState，并被传递到我们的 data binding 实例。

所以问题是什么？由于我们只有一个输入变量，所有的 binding 表达式将会引用变量，这就意味着『DB 库』将无法自由选择运行哪个表达式。在实际过程中，这意味着每次变量变化（不管多小的变化）发生时所有的 binding 表达式都会运行。

**这个问题与 MVI 这点无关，特别是它只是组合状态的 artifact，与data binding 结合在一起使用。**

### 那么你能怎么做呢？

有种替代方法是在布局中显式声明 ViewState 中的每个变量，然后显式传递组合状态实例中的值，如下所示：

这显然会使开发人员维护和同步更多的代码，但它确实意味着『DB 库』可以优化去运行哪些表达式。如果你的 UI 状态不经常变化（可能在创建时有一些次）并且变量数量较少时，我会推荐使用此模式。

我个人一直在布局中使用单个变量，传入我的 ViewState 实例，并依赖于我们的视图绑定合理地运行。这就是为什么让视图绑定变得高效非常重要。

**另一个需要注意的是 Tivi 是 [RecyclerView](https://developer.android.com/guide/topics/ui/layout/recyclerview) 的重度使用者，还有 [Epoxy](https://github.com/airbnb/epoxy) 和 [Data Binding](https://github.com/airbnb/epoxy/wiki/Data-Binding-Support)，意思就是在 [DiffUtil](https://developer.android.com/reference/androidx/recyclerview/widget/DiffUtil) 中会额外有一些变化相关的计算发生。所以如果你的 UI 也有大量的 RecyclerView 组成，你可以类似上文描述不费事地获取计算这方面的优化。**

## 小步迭代

希望这篇文章强调了一些可以优化数据绑定实现方案中的一些小事。了解『DB 库』的内部机制可以帮助你提高数据绑定效率，并提高你的 UI 性能。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
