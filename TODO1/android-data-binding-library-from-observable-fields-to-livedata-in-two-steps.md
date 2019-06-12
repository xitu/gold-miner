> * 原文地址：[Android Data Binding Library — From Observable Fields to LiveData in two steps](https://medium.com/androiddevelopers/android-data-binding-library-from-observable-fields-to-livedata-in-two-steps-690a384218f2)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/android-data-binding-library-from-observable-fields-to-livedata-in-two-steps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/android-data-binding-library-from-observable-fields-to-livedata-in-two-steps.md)
> * 译者：
> * 校对者：

# Android Data Binding Library — From Observable Fields to LiveData in two steps

![Illustration by [Virginia Poltrack](https://twitter.com/vpoltrack)](https://cdn-images-1.medium.com/max/8418/1*QhbnhjTMT9gTIP36Lo7-mQ.png)

One of the most important features of Data Binding is [**observability**](https://developer.android.com/topic/libraries/data-binding/observability). It allows you to bind data and UI elements so that when the data changes, the pertinent elements are updated on screen.

Plain primitives and Strings are **not** observable **by default** so if you use them in your Data Binding layouts, their values will be used when the binding is created but subsequent changes to them will be ignored.

To make objects observable, we included in the [Data Binding Library](https://developer.android.com/topic/libraries/data-binding/) a series of observable classes: `ObservableBoolean` , `ObservableInt`, `ObservableDouble`… and the generic , `ObservableField<T>`. We’ll call these **Observable Fields** from now on.

Some years later, as part of the first wave of [Architecture Components](https://developer.android.com/topic/libraries/architecture), we released [**LiveData**](https://developer.android.com/topic/libraries/architecture/livedata), which is **another** observable. It was an obvious candidate to be compatible with Data Binding, so we added this capability.

[LiveData](https://developer.android.com/topic/libraries/architecture/livedata) is lifecycle-aware but this is not a huge advantage with respect to Observable Fields because Data Binding already checks when the view is active. However, **LiveData supports [Transformations](https://developer.android.com/reference/android/arch/lifecycle/Transformations), and many Architecture Components, like [Room](https://developer.android.com/topic/libraries/architecture/room) and [WorkManager](https://developer.android.com/reference/androidx/work/WorkManager), support LiveData**.

**For these reasons, it’s recommended to migrate to LiveData.** You only need two simple steps to do so.

## Step 1: Replace Observable Fields with LiveData

If you are using Observable Fields directly in your data binding layout, simply replace `ObservableSomething` (or `ObservableField<Something>`) with `LiveData<Something>`.

Before:

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

After:

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

Alternatively, if you’re exposing observables from a [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel) (the preferred approach) or a presenter or controller, you don’t need to change your layout. Just replace those `ObservableField`s with `LiveData` in the ViewModel.

Before:

```Kotlin
class MyViewModel : ViewModel() {
    val name = ObservableField<String>("Ada")
}

```

After:

```Kotlin
class MyViewModel : ViewModel() {
    private val _name = MutableLiveData<String>().apply { value = "Ada" }

    val name: LiveData<String> = _name // Expose the immutable version of the LiveData
}

```

## Step 2 — Set the lifecycle owner for the LiveData

Binding classes have a method called `setLifecycleOwner` that must be called when observing LiveData from a data binding layout.

Before:

```Kotlin
val binding = DataBindingUtil.setContentView<TheGeneratedBinding>(
    this,
    R.layout.activity_data_binding
)

binding.name = myLiveData // or myViewModel
```

After:

```Kotlin
val binding = DataBindingUtil.setContentView<TheGeneratedBinding>(
    this,
    R.layout.activity_data_binding
)

binding.lifecycleOwner = this // Use viewLifecycleOwner for fragments

binding.name = myLiveData // or myViewModel

```

> **Note: If you’re setting the content for a fragment, it is recommended to use `fragment.viewLifecycleOwner` (instead of the fragment’s lifecycle) to deal with potential detached fragments.**

---

Now you can use your [LiveData](https://developer.android.com/topic/libraries/architecture/livedata) objects with [Transformations](https://developer.android.com/reference/android/arch/lifecycle/Transformations) and [MediatorLiveData](https://developer.android.com/reference/android/arch/lifecycle/MediatorLiveData). If you’re not familiar with these features, check out this [recording of “Fun with LiveData”, from the Android Dev Summit 2018](https://www.youtube.com/watch?v=2rO4r-JOQtA).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
