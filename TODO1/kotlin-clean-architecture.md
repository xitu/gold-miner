> * 原文地址：[Kotlin Clean Architecture](https://proandroiddev.com/kotlin-clean-architecture-1ad42fcd97fa)
> * 原文作者：[Rakshit jain](https://medium.com/@rjain.jain444)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-clean-architecture.md](https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-clean-architecture.md)
> * 译者：[JasonWu111](https://github.com/JasonWu1111)
> * 校对者：[yangxy81118](https://github.com/yangxy81118)

# Kotlin Clean 架构

![](https://cdn-images-1.medium.com/max/2000/0*sfCDEb571WD-7EfP.jpg)

强大的基础架构对于一个应用扩展和满足用户群体的期望来说是非常重要的。我有一个用新更新和优化的 API 结构来替换旧 API 的任务，为了整合这种更改，我一定程度地重写了整个应用。

为什么？因为代码与其响应的数据模型（data models）**深度耦合**。这次，我不想一遍又一遍地犯同样的错误。为了解决这个问题，我使用了 Clean 架构。在一开始会有点痛苦，但对于具有许多功能和 **SOLID** 方法的大型应用来说可能是最佳选择。让我们试着带着疑问去看架构的每个层面，然后分解成更简单的点。

* [**news-sample-app: 创建 GitHub 账号来为本应用的开发做贡献**](https://github.com/rakshit444/news-sample-app)

这个架构是由 Robert C. Martin（Uncle Bob）在 [clean code blog](http://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) 中于 2012 年提出的。

### 为什么是 Clean 架构？

1. 在不同层级中分离具有**特定职责**的代码，让其更容易做进一步修改。
2. 高度的**抽象**
3. 代码**解耦**
4. 轻松的代码**测试**

> “整洁的代码总是看起来像是由在意它的人来写的。”
>
> — Michael Feathers

### 有哪些层级？

![Dependency Flow](https://cdn-images-1.medium.com/max/2000/1*a5UQUjgYu5SZAbmkNELI_A.png)

**Domain 层：** 将执行独立于任何层级的业务逻辑，并且只是一个没有 Android 相关依赖的纯 kotlin 包。

**Data 层：** 通过实现 Domain 层的公开接口，将应用所需的数据分配给 Domain 层。

**Presentation 层：** 将包括 Domain 层和 Data 层，并且是 Android 特定的，用于执行 UI 逻辑。

### 什么是 Domain 层？

这将是三个层级中最通用的一个。它将 Presentation 层和 Data 层连接起来，并执行应用相关的业务逻辑。

![The domain layer structure of the application](https://cdn-images-1.medium.com/max/2000/1*m06XFPa5OTvOF6zGPC7Q0w.png)

### 用例

用例是应用逻辑执行程序。正如名称所示，每个功能都可以有其独立的用例。创建更加精细的用例可以被更频繁地复用。

```Kotlin
class GetNewsUseCase(private val transformer: FlowableRxTransformer<NewsSourcesEntity>,
                     private val repositories: NewsRepository): BaseFlowableUseCase<NewsSourcesEntity>(transformer){

    override fun createFlowable(data: Map<String, Any>?): Flowable<NewsSourcesEntity> {
        return repositories.getNews()
    }

    fun getNews(): Flowable<NewsSourcesEntity>{
        val data = HashMap<String, String>()
        return single(data)
    }
}
```

此用例返回的是可根据所需观察者进行修改的 Flowable 类型。它有两个参数。其中之一是 **transformers** 或 [ObservableTransformer](http://reactivex.io/RxJava/javadoc/io/reactivex/ObservableTransformer.html)，它控制执行逻辑的线程和另外的参数 **repository**，是 Data 层的接口。如果有任何的数据必须传递给 Data 层，则可以使用 HashMap。

### Repositories

它指定了由 Data 层实现的用例所需的功能。

### 什么是 Data 层？

该层级负责提供应用所需的数据。Data 层应该设计任何应用都可以重复使用而无需在其展示逻辑中进行修改的数据。

![The data layer structure of the application](https://cdn-images-1.medium.com/max/2000/1*KbdhwDpsxspHEz7QInpbhA.png)

**API** 提供远程网络实现。任何网络库都可以集成到这里，如 retrofit、volley 等。同样，**DB** 提供本地数据库实现。

```Kotlin
class NewsRepositoryImpl(private val remote: NewsRemoteImpl,
                         private val cache: NewsCacheImpl) : NewsRepository {

    override fun getLocalNews(): Flowable<NewsSourcesEntity> {
        return cache.getNews()
    }

    override fun getRemoteNews(): Flowable<NewsSourcesEntity> {
        return remote.getNews()
    }

    override fun getNews(): Flowable<NewsSourcesEntity> {
        val updateNewsFlowable = remote.getNews()
        return cache.getNews()
                .mergeWith(updateNewsFlowable.doOnNext{
                    remoteNews -> cache.saveArticles(remoteNews)
                })
    }
}
```

在 Repository 中，我们有本地、远程或任何类型的数据提供程序的实现，而上面的类 NewsRepositoryImpl.kt 实现了 Domain 层公开的接口。它充当 Data 层的单一访问点。

**什么是 Presentation 层？**

Presentation 层提供应用的 UI 实现。它不做别的事，只执行没有逻辑的指令。该层内部实现了 MVC、MVP、MVVM、MVI 等架构。所有的连接工作都在本层。

![The presentation layer structure of the application](https://cdn-images-1.medium.com/max/2000/1*4UH3LeLcGg8tjp1BmPm1jw.png)

**DI** 文件夹实现了在应用开始时注入所有的依赖项，如网络相关、View Models、用例等。可以使用 dagger、kodein、koin 或只使用服务定位器模式（service locator pattern）实现 Android 中的 DI。它只取决于应用本身，如对于复杂的应用，DI 可能非常有用。我选择 koin 只是因为它比 dagger 更容易理解和实现。

**为什么使用 ViewModels？**

根据 Android [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel) 文档：

> **以生命周期的方式存储和管理 UI 相关数据。它允许数据在配置更改（例如屏幕旋转）后继续存活。**

```Kotlin
class NewsViewModel(private val getNewsUseCase: GetNewsUseCase,
                    private val mapper: Mapper<NewsSourcesEntity, NewsSources>) : BaseViewModel() {

    companion object {
        private val TAG = "viewmodel"
    }

    var mNews = MutableLiveData<Data<NewsSources>>()

    fun fetchNews() {
        val disposable = getNewsUseCase.getNews()
                .flatMap { mapper.Flowable(it) }
                .subscribe({ response ->
                    Log.d(TAG, "On Next Called")
                    mNews.value = Data(responseType = Status.SUCCESSFUL, data = response)
                }, { error ->
                    Log.d(TAG, "On Error Called")
                    mNews.value = Data(responseType = Status.ERROR, error = Error(error.message))
                }, {
                    Log.d(TAG, "On Complete Called")
                })

        addDisposable(disposable)
    }

    fun getNewsLiveData() = mNews
}
```

因此，ViewModel 会保留有关配置更改的数据。在 MVP 中，Presenter 使用接口绑定到 view，这会变得难以测试，但在 ViewModel 中，由于架构感知组件（architectural aware components）而没有接口。

Base View Model 使用 [CompositeDisposable](http://reactivex.io/RxJava/javadoc/io/reactivex/disposables/CompositeDisposable.html) 来添加所有的 observables 对象，并在生命周期的 @OnCleared 中移除它们。

```Kotlin
data class Data<RequestData>(var responseType: Status, var data: RequestData? = null, var error: Error? = null)

enum class Status { SUCCESSFUL, ERROR, LOADING }
```

数据 wrapper 类作为辅助类用于 LiveData，以便 view 了解数据请求的状态，即它是否已开始、成功或任何有关数据的状态。

**如何连接所有的层级？**

每个层都有自己特定于该包的 **实体类（entities）**。Mapper 用于将一个层的实体类转换为另一个层的实体类。我们为每个层设置了不同的实体类，以便该层变得绝对独立，并且只将所需的数据传递给后续的层。

### 应用流程

![](https://cdn-images-1.medium.com/max/2516/1*a-AUcEVdyRJhIepo9JyJBw.png)

***

本文差不多要结束了，如果我错过了任何内容，请告诉我。让我总结一下：

> 基础架构定义了应用程序的一致性。诚然，选择什么架构也是基于应用来的，但是为什么不**提前**选择最合适的架构呢，如可扩展的，强大的，可测试的，这样你就不必在未来面对痛苦。

感谢阅读本文 :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
