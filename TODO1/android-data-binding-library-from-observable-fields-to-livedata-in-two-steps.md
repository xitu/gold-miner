> * 原文地址：[Android Data Binding Library — From Observable Fields to LiveData in two steps](https://medium.com/androiddevelopers/android-data-binding-library-from-observable-fields-to-livedata-in-two-steps-690a384218f2)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/android-data-binding-library-from-observable-fields-to-livedata-in-two-steps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/android-data-binding-library-from-observable-fields-to-livedata-in-two-steps.md)
> * 译者：[Rickon](https://github.com/gs666)

# Android 数据绑定库 — 从可观察域到 LiveData 仅需两步

![Illustration by [Virginia Poltrack](https://twitter.com/vpoltrack)](https://cdn-images-1.medium.com/max/8418/1*QhbnhjTMT9gTIP36Lo7-mQ.png)

数据绑定最重要的特性之一是[**可观察性**](https://developer.android.com/topic/libraries/data-binding/observability)。你可以用它绑定数据和 UI 元素，以便在数据更改时，相关元素在屏幕上更新。

**默认情况下**，普通基元和字符串是**不**可被观察的，因此如果在数据绑定布局中使用它们，则在创建绑定时将使用它们的值，但对它们的后续更改会被忽略。

为了使对象可被观察，我们的[数据绑定库](https://developer.android.com/topic/libraries/data-binding/)中包含了一系列可被观察的类：`ObservableBoolean`、`ObservableInt`、`ObservableDouble` 和范型：`ObservableField<T>`。从现在开始，我们称这些为**可观察域**。

几年后，作为第一波[架构组件](https://developer.android.com/topic/libraries/architecture)的一部分，我们发布了 [**LiveData**](https://developer.android.com/topic/libraries/architecture/livedata)，这**又**是一个可被观察的。这是与数据绑定兼容的候选，因此我们添加了此功能。

[LiveData](https://developer.android.com/topic/libraries/architecture/livedata) 是可以感知生命周期的，对于可观察域而言，这并不是一个很大的优势，因为数据绑定库已经检查了视图何时处于活动状态。但是，**LiveData 支持 [Transformations](https://developer.android.com/reference/android/arch/lifecycle/Transformations) 和很多架构组件，比如 [Room](https://developer.android.com/topic/libraries/architecture/room) 和 [WorkManager](https://developer.android.com/reference/androidx/work/WorkManager)。**

**出于这些原因，建议你迁移到 LiveData。**你只需要两步即可完成。

## 第一步：使用 LiveData 代替可观察域

如果你直接在数据绑定布局中使用可观察域，只需使用 `LiveData<Something>` 替换 `ObservableSomething`（或 `ObservableField<Something>`）。

修改前：

```XML
<data>
    <import type="android.databinding.ObservableField"/>
    <variable 
        name="name" 
        type="ObservableField&lt;String>" />
</data>
…
<TextView
    android:text="@{name}"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"/>

```

> **Remember that `%lt;` is not a typo. You have to escape the `<` character inside XML layouts.**

修改后：

```XML
<data>
        <import type="android.arch.lifecycle.LiveData" />
        <variable
            name="name"
            type="LiveData&lt;String>" />
</data>
…
<TextView
    android:text="@{name}"
    android:layout_width="wrap_content"
    android:layout_height="wrap_content"/>

```

或者，如果你从 [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel)（首选方法）或一个 presenter 层或控制器暴露可观察对象，则无需更改布局。只需在 ViewModel 中用 `LiveData` 替换那些 `ObservableField`。

修改前：

```Kotlin
class MyViewModel : ViewModel() {
    val name = ObservableField<String>("Ada")
}

```

修改后：

```Kotlin
class MyViewModel : ViewModel() {
    private val _name = MutableLiveData<String>().apply { value = "Ada" }

    val name: LiveData<String> = _name // Expose the immutable version of the LiveData
}

```

## 第二步：设置 LiveData 的生命周期所有者

绑定类有一个名为 `setLifecycleOwner` 的方法，在从数据绑定布局中观察 LiveData 时必须调用该方法。

修改前：

```Kotlin
val binding = DataBindingUtil.setContentView<TheGeneratedBinding>(
    this,
    R.layout.activity_data_binding
)

binding.name = myLiveData // or myViewModel
```

修改后：

```Kotlin
val binding = DataBindingUtil.setContentView<TheGeneratedBinding>(
    this,
    R.layout.activity_data_binding
)

binding.lifecycleOwner = this // Use viewLifecycleOwner for fragments

binding.name = myLiveData // or myViewModel

```

> 注意：如果要设置 fragment 的内容，建议使用 `fragment.viewLifecycleOwner`（而不是 fragment 的生命周期）来处理潜在的分离的 fragments。

---

现在你可以使用你的带有 [Transformations](https://developer.android.com/reference/android/arch/lifecycle/Transformations) 和 [MediatorLiveData](https://developer.android.com/reference/android/arch/lifecycle/MediatorLiveData) 的 [LiveData](https://developer.android.com/topic/libraries/architecture/livedata) 对象。如果你不熟悉这些功能，可以参阅 [“Fun with LiveData” 录像，来自 2018 Android 开发者大会](https://www.youtube.com/watch?v=2rO4r-JOQtA)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
