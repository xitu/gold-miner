> * 原文地址：[Locale changes and the AndroidViewModel antipattern](https://medium.com/androiddevelopers/locale-changes-and-the-androidviewmodel-antipattern-84eb677660d9)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/locale-changes-and-the-androidviewmodel-antipattern.md](https://github.com/xitu/gold-miner/blob/master/TODO1/locale-changes-and-the-androidviewmodel-antipattern.md)
> * 译者：
> * 校对者：

# Locale changes and the AndroidViewModel antipattern

> # TL;DR: Expose resource IDs from ViewModels to avoid showing obsolete data.

In a ViewModel, if you’re exposing data coming from resources (strings, drawables, colors…), you have to take into account that ViewModel objects ignore configuration changes such as **locale changes**. When the user changes their locale, activities are recreated but the ViewModel objects are not.

![**The localized string is not updated after a locale change**](https://cdn-images-1.medium.com/max/2000/0*kL5zW7zi_ImPUwHr)

`AndroidViewModel` is a subclass of `ViewModel` that is aware of the Application context. However, having access to a context can be dangerous if you’re not observing or reacting to the lifecycle of that context. **The recommended practice is to avoid dealing with objects that have a lifecycle in ViewModels.**

Let’s look at an example based on this issue in the tracker: **[Updating ViewModel on system locale change](https://issuetracker.google.com/issues/111961971).**

```Java
// Don't do this
public class MyViewModel extends AndroidViewModel {
    public final MutableLiveData<String> statusLabel = new MutableLiveData<>();
    
    public SampleViewModel(Application context) {
        super(context);
        statusLabel.setValue(context.getString(R.string.labelString));
    }
}

```

The problem is that the string is resolved in the constructor only once. **If there’s a locale change, the ViewModel won’t be recreated**. This will result in our app showing obsolete data and therefore being only partially localized.

As [Sergey](https://twitter.com/ZelenetS) points out in the [comments](https://issuetracker.google.com/issues/111961971#comment2) to the issue, the recommended approach is to **expose the ID of the resource you want to load and do so in the view**. As the view (activity, fragment, etc.) is lifecycle-aware it will be recreated after a configuration change so the resource will be reloaded correctly.

```Java
// Expose resource IDs instead
public class MyViewModel extends ViewModel {
    public final MutableLiveData<Int> statusLabel = new MutableLiveData<>();
    
    public SampleViewModel(Application context) {
        super(context);
        statusLabel.setValue(R.string.labelString);
    }
}

```

Even if you don’t plan to localize your app, it makes testing much easier and cleans up your ViewModel objects so there’s no reason not to future-proof.

We fixed this issue in the android-architecture repository in the [Java](https://github.com/googlesamples/android-architecture/pull/631) and [Kotlin](https://github.com/googlesamples/android-architecture/pull/635) branches and we offloaded resource loading to [the Data Binding layout](https://github.com/googlesamples/android-architecture/pull/635/files#diff-7eb5d85ec3ea4e05ecddb7dc8ae20aa1R62).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
