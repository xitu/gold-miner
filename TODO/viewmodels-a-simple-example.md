> * 原文地址：[ViewModels : A Simple Example](https://medium.com/google-developers/viewmodels-a-simple-example-ed5ac416317e)
> * 原文作者：[Lyla Fujiwara](https://medium.com/@lylalyla?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/viewmodels-a-simple-example.md](https://github.com/xitu/gold-miner/blob/master/TODO/viewmodels-a-simple-example.md)
> * 译者：[huanglizhuo](https://github.com/huanglizhuo)
> * 校对者：[chuanxing](https://github.com/zhaochuanxing) [miguoer](https://github.com/miguoer)

# ViewModels 简单入门

### 简介

两年前，我在做 [给 Android 入门的课程](https://www.udacity.com/course/android-development-for-beginners--ud837)，教零基础学生开发 Android App。其中有一部分是教学生构建一个简单 App 叫做 [Court-Counter](https://github.com/udacity/Court-Counter).

Court-Counter 是一个只有几个按钮来修改篮球比赛分数的 App。最终的App有一个bug，如果你旋转手机，当前保存的分数会莫名归零。

![](https://cdn-images-1.medium.com/max/800/1*kZ5CiWnpSC0-aQeModzpNA.gif)

这是什么原因呢？因为旋转设备会导致 App 中一些 [**配置发生改变**](https://developer.android.com/guide/topics/manifest/activity-element.html#config) ，比如键盘是否可用，变更设备语言等。这些配置的改变都会导致 Activity 被销毁重建。

这种表现可以让我们在做一些特殊处理，比如设备旋转时变更为横向特定布局。 然而对于新手（有时候老鸟也是）工程师来说，这可能会让他们头疼。

在 Google I/O 2017，Android Framework团队推出了一套 Architecture Components 的工具集，其中一个处理设备旋转的问题。

[**ViewModel**](https://developer.android.com/reference/android/arch/lifecycle/ViewModel.html) 类旨在以有生命周期的方式保存和管理与UI相关的数据。 这使得数据可以在屏幕旋转等配置变化的情况下不丢失。

这篇文章是详细探索ViewModel系列文章中的第一篇。 在这篇文章中，我会：

- 解释ViewModel满足的基本需求
- 通过更改 Court-Counter 代码以使用 ViewModel 解决旋转问题
- 仔细审视 ViewModel 和 UI 组件的关联

### 潜在的问题

潜在的挑战是  [Android Activity 生命周期](https://developer.android.com/guide/components/activities/activity-lifecycle.html) 中有很多状态，并且由于配置更改，单个Activity可能会多次循环进入这些不同的状态。

![](https://cdn-images-1.medium.com/max/800/1*CGGROXWhl8dTko1GdDeFsA.png)

Activity 会经历所有这些状态，也可能需要把暂时的用户界面数据存储在内存中。这里将把临时UI数据定义为UI所需的数据。例子中包括用户输入的数据，运行时生成的数据或者是数据库加载的数据。这些数据可以是bitmap， RecyclerView 所需的对象列表等等，在这个例子中，是指篮球得分。

以前你可能用过 [onRetainNonConfigurationInstance](https://developer.android.com/reference/android/app/Activity.html#onRetainNonConfigurationInstance%28%29) 方法在配置更改期间保存和恢复数据。但是，如果你的数据不需要知道或管理 Activity 所处的生命周期状态，这样写会不会导致代码过于冗杂？如果 Activity 中有一个像scoreTeamA 这样的变量，虽然与 Activity 生命周期紧密相连，但又存储在Activity之外的地方呢？**这就是 ViewModel 类的目的**。

 在下面的图表中，可以看到一个 Activity 的生命周期，该 Activity 经历了一次旋转，最后被 finish 掉。 ViewModel 的生命周期显示在关联的Activity生命周期旁边。注意，ViewModels 可以很简单的用与Fragments 和 Activities,，这里称他们为 UI 控制器。本示例着重于 Activities。

![](https://cdn-images-1.medium.com/max/800/1*3Kr2-5HE0TLZ4eqq8UQCkQ.png)

ViewModel从你首次请求创建ViewModel（通常在onCreate的Activity）时就存在，直到Activity完成并销毁。Activity 的生命周期中，onCreate可能会被调用多次，比如当应用程序被旋转时，但 ViewModel 会一直存在，不会被重建。

### 一个简单的例子

分三步骤来设置和使用ViewModel：

1. 通过创建一个扩展 ViewModel 类来从UI控制器中分离出你的数据
2. 建立你的 ViewModel 和UI控制器之间的通信
3. 在 UI 控制器中使用你的 ViewModel

#### 第一步: 创建 ViewModel 类

一般来讲，需要为每个界面都创建一个ViewModel类。这个ViewModel类将保存与该屏相关的所有数据，提供 getter 和 setter。这样就将数据与 UI 显示逻辑分开了，UI逻辑在Activities 或 Fragments中，数据保存在 ViewModel 中。好了，接下来为 Court-Counter 中的一个屏创建ViewModel类：

```
public class ScoreViewModel extends ViewModel {
   // Tracks the score for Team A
   public int scoreTeamA = 0;

   // Tracks the score for Team B
   public int scoreTeamB = 0;
}
```

为了简洁，这里我采用了公共成员存储在ScoreViewModel.java中，也可以选择用 getter 和 setter 来更好地封装数据。

#### 第二步:关联UI控制器和ViewModel

你的UI控制器（Activity或Fragment）需要访问你的ViewModel。这样，UI控制器就可以在UI交互发生时显示和更新数据，例如按下按钮以增加 Court-Counter 中的分数。

ViewModels不应该持有 Activities ，Fragments  或者 [**Context**](https://developer.android.com/reference/android/content/Context.html) 的引用。

此外，ViewModels也不应包含包含对UI控制器（如Views）引用的元素，因为这将创建对Context的间接引用。

之所以不这样做是因为，ViewModel 比 UI控制器生命周期长，比如你旋转一个Activity三次，会得到三个不同的Activity实例，但ViewModel只有一个。

基于这一点，我们来创建 UI控制器/ ViewMode l的关联。在UI控制器中将 ViewModel 创建为一个成员变量。然后在 onCreate中这样调用：

```
ViewModelProviders.of(<Your UI controller>).get(<Your ViewModel>.class)
```

在 Court-Counter 例子中，会是这样：

```
@Override
protected void onCreate(Bundle savedInstanceState) {
   super.onCreate(savedInstanceState);
   setContentView(R.layout.activity_main);
   mViewModel = ViewModelProviders.of(this).get(ScoreViewModel.class);
   // Other setup code below...
}
```

**注意:** 这里对 “no contexts in ViewModels” 规则有个例外。有时候你可能会需要一个 [**Application context**](https://developer.android.com/reference/android/content/Context.html#getApplicationContext%28%29)(as opposed to an Activity context) 调用系统服务。这种情况下在 ViewModel 中持有 Application context 是没问题的，因为 Application context 是存在于 App 整个生命周期的，这点与 Activity context 不同， Activity context  只存在与 Activity 的生命周期。事实上，如果你需要 Application context，最好继承 [**AndroidViewModel**](https://developer.android.com/reference/android/arch/lifecycle/AndroidViewModel.html) ，这是一个持有 Application 引用的 ViewModel。

#### 第三步:在 UI 控制器中使用 ViewModel

要访问或更改UI数据，可以使用ViewModel中的数据。下面是一个新的 onCreate 方法的示例，以及一个增加 team A 分数的方法：

```
// The finished onCreate method
@Override
protected void onCreate(Bundle savedInstanceState) {
   super.onCreate(savedInstanceState);
   setContentView(R.layout.activity_main);
   mViewModel = ViewModelProviders.of(this).get(ScoreViewModel.class);
   displayForTeamA(mViewModel.scoreTeamA);
   displayForTeamB(mViewModel.scoreTeamB);
}

// An example of both reading and writing to the ViewModel
public void addOneForTeamA(View v) {
   mViewModel.scoreTeamA = mViewModel.scoreTeamA + 1;
   displayForTeamA(mViewModel.scoreTeamA);
}
```

**tips:** ViewModel 也可以很好地与另一个架构组件  [LiveData](https://developer.android.com/reference/android/arch/lifecycle/LiveData.html) 一起工作，在这个系列中我不会深入探索。使用LiveData 的额外好处是它是可观察的：它可以在数据改变时触发UI更新。可以在[这里](https://developer.android.com/topic/libraries/architecture/livedata.html)了解更多关于LiveData的信息。

### 进一步审视 `ViewModelsProviders.of`

第一次调用  [ViewModelProviders.of](https://developer.android.com/reference/android/arch/lifecycle/ViewModelProviders.html#of%28android.support.v4.app.Fragment%29)  方法是在 MainActivity 中，创建了一个新的 ViewModel 实例。每次调用 `onCreate` 方法都会再次调用这个方法。它会返回之前 Court-Counter MainActivity 中创建的 ViewModel。 这就是它持有数据的方式。

只有给 UI controller 提供正确的UI控制器作为参数才可以。切记不要在 ViewModel 内存储 UI 控制器，ViewModel 会在后台跟踪 UI 控制器实例和 ViewModel 之间的关联。

```
ViewModelProviders._of_(**<THIS ARGUMENT>**).get(ScoreViewModel.**class**);
```

这可以让你有一个应用程序，打开同一个 Activity or Fragment 的不同实例，但具有显示不同的 ViewModel 信息。让我们想象一下，如果我们扩展 Court-Counter 程序，使其可以支持不同的篮球比赛得分。比赛呈现在列表里，然后点击列表中的比赛就会开启一屏与 MainActivity 一样的画面，后面我就叫它 GameScoreActivity。

对于你打开的每一个不同的比赛画面，在 onCreate 中关联ViewModel和GameScoreActivity 后，它将创建不同的 ViewModel 实例。旋转其中一个屏幕，则保持与同一个ViewModel的连接。

![](https://cdn-images-1.medium.com/max/800/1*uQ6XDm4Ga14SJWlCb27rkg.png)

所有这些逻辑都是通过调用 `ViewModelProviders.of(<Your UI controller>).get(<Your ViewModel>.class)` 实现的。 你只需要传递正确的UI 控制器实例就好。

**最后的思考**：ViewModel非常好的把你的UI控制器代码与UI的数据分离出来。 这就是说，它并不是能完成数据持久化和保存App 状态的工作。 在下一篇文章中，我将探讨Activity生命周期与ViewModels之间的微妙交互，以及 ViewModel 与 onSaveInstanceState 进行比较。

### 结论和进一步的学习

在这篇文章中，我探索了新的ViewModel类的基础知识。关键要点是：

- ViewModel类旨在一个连续的生命周期中保存和管理与UI相关的数据。这使得数据可以在屏幕旋转等配置变化的情况下得以保存。
- ViewModels将UI实现与 App 数据分离开来。
- 一般来说，如果某屏应用中有瞬态数据，则应该为该屏的数据创建一个单独的ViewModel。
- ViewModel的生命周期从关联的UI控制器首次创建时开始，直到完全销毁。
- 不要将UI控制器或 Context 直接或间接存储在ViewModel中。这包括在ViewModel中存储 View。对UI控制器的直接或间接引用违背了从数据中分离UI的目的，并可能导致内存泄漏。
- ViewModel对象通常会存储LiveData对象，您可以在 [这里](https://developer.android.com/topic/libraries/architecture/livedata.html)了解更多。
- [ViewModelProviders.of](https://developer.android.com/reference/android/arch/lifecycle/ViewModelProviders.html#of%28android.support.v4.app.Fragment%29)  方法通过作为参数传入的 UI控制器与 ViewModel 进行关联。

想要了解更多 ViewModel 化的好处? 可以进一步阅读下面文章:

*   [Instructions for adding the gradle dependencies](https://developer.android.com/topic/libraries/architecture/adding-components.html)
*   [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel.html) documentation
*   Guided ViewModel practice with the [Lifecycles Codelab](https://codelabs.developers.google.com/codelabs/android-lifecycles/#0)

架构组件是根据大家的反馈创建的。 如果你对 ViewModel 或任何架构组件有任何疑问或意见，请查看我们的  [反馈页面](https://developer.android.com/topic/libraries/architecture/feedback.html).。 有关这个系列的问题或建议？ 发表评论！

感谢 [Mark Lu](https://medium.com/@marklu_44193?source=post_page), [Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_page), 以及 [Daniel Galpin](https://medium.com/@dagalpin?source=post_page).

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
