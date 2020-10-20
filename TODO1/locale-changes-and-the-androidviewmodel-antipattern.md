> * 原文地址：[Locale changes and the AndroidViewModel antipattern](https://medium.com/androiddevelopers/locale-changes-and-the-androidviewmodel-antipattern-84eb677660d9)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/locale-changes-and-the-androidviewmodel-antipattern.md](https://github.com/xitu/gold-miner/blob/master/TODO1/locale-changes-and-the-androidviewmodel-antipattern.md)
> * 译者：[solerji](https://github.com/solerji)

# 区域设置更改和 AndroidViewModel 反面模式

> TL;DR：从视图模型中公开资源 ID 以避免显示废弃的数据。

在 ViewModel 中，如果要公开来自资源（字符串、可绘制文件、颜色……）的数据，则必须着重考虑 ViewModel 对象而忽视配置更改，例如**区域设置更改**。当用户更改其区域设置时，活动将重新被创建，但不创建 ViewModel 对象。

![**本地化字符串在区域设置更改后不更新**](https://cdn-images-1.medium.com/max/2000/0*kL5zW7zi_ImPUwHr)

`AndroidViewModel` 是已知应用程序上下文的 `ViewModel` 的子类。然而，如果您没有注意到或没有对上下文的生命周期做出反应，访问上下文可能是危险的。**建议的做法是避免处理在 ViewModels 中具有生命周期的对象。**

让我们看看跟踪器中基于此问题的示例：**[在系统区域设置更改时更新 ViewModel ](https://issuetracker.google.com/issues/111961971)。**

```Java
// 别这么做
public class MyViewModel extends AndroidViewModel {
    public final MutableLiveData<String> statusLabel = new MutableLiveData<>();
    
    public SampleViewModel(Application context) {
        super(context);
        statusLabel.setValue(context.getString(R.string.labelString));
    }
}
```

问题的关键是字符串在构造器中只解释一次。**如果有区域设置更改，则不会重新创建视图模型**。这将导致我们的应用程序显示废弃的数据，因此只能部分本地化。

正如 [Sergey](https://twitter.com/ZelenetS) 在评论中指出的那样 [comments](https://issuetracker.google.com/issues/111961971#comment2)，推荐的方法是**公开要加载的资源的 ID ，并在视图中这样做**。由于视图（活动、片段等）具有生命周期意识，因此它将在配置更改后重新创建，以便正确地重新加载资源。

```Java
// 显示资源ID
public class MyViewModel extends ViewModel {
    public final MutableLiveData<Int> statusLabel = new MutableLiveData<>();
    
    public SampleViewModel(Application context) {
        super(context);
        statusLabel.setValue(R.string.labelString);
    }
}
```

即使你不打算本地化你的应用程序，它也会使测试变得更容易并且清空你的 ViewModel 对象，因此没有理由不去考虑它的前瞻性。

我们在以 Java 为基础的 Android 架构存储库中解决了这个问题 [Java](https://github.com/googlesamples/android-architecture/pull/631) 以及在[Kotlin](https://github.com/googlesamples/android-architecture/pull/635) 分支上。我们也把资源转移到 [数据绑定布局](https://github.com/googlesamples/android-architecture/pull/635/files#diff-7eb5d85ec3ea4e05ecddb7dc8ae20aa1R62)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
