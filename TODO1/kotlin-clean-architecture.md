> * 原文地址：[Kotlin Clean Architecture](https://proandroiddev.com/kotlin-clean-architecture-1ad42fcd97fa)
> * 原文作者：[Rakshit jain](https://medium.com/@rjain.jain444)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-clean-architecture.md](https://github.com/xitu/gold-miner/blob/master/TODO1/kotlin-clean-architecture.md)
> * 译者：
> * 校对者：

# Kotlin Clean Architecture

![](https://cdn-images-1.medium.com/max/2000/0*sfCDEb571WD-7EfP.jpg)

A strong base architecture is extremely important for an app to scale and meet the expectation of the user base. I got a task of replacement of API with new updated and optimized API structure. For integrating this kind of change made me kind of rewrite the whole app.

Why? Because the code was **deeply coupled** with response data models. At this time, I didn’t want to make the same mistakes over and over again. For resolving this problem, Clean architecture came to the rescue. It is a bit pain in the starting but might be the best option for a large app with many feature and **SOLID** approach. Let’s just try by questioning every aspect of architecture and break down into simpler bits.

* [**news-sample-app: Contribute to news-sample-app development by creating an account on GitHub.**](https://github.com/rakshit444/news-sample-app)

This architecture was proposed in 2012 by Robert C. Martin(Uncle Bob) in [clean code blog](http://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

### Why the cleaner approach?

1. Separation of code in different layers with **assigned responsibilities** making it easier for further modification.
2. High level of **abstraction**
3. **Loose coupling** between the code
4. **Testing** of code is painless

> “Clean code always looks like it was written by someone who cares.”
>
> — Michael Feathers

### What are the Layers?

![Dependency Flow](https://cdn-images-1.medium.com/max/2000/1*a5UQUjgYu5SZAbmkNELI_A.png)

**Domain layer:** Would execute business logic which is independent of any layer and is just a pure kotlin package with no android specific dependency.

**Data layer:** Would dispense the required data for the application to the domain layer by implementing interface exposed by the domain

**Presentation layer:** Would include both domain and data layer and is android specific which executes the UI logic.

### What is Domain Layer?

This will be the most generic layer of the three. It will connect the presentation layer with the data layer. This is the layer where app-related business logic will be executed.

![The domain layer structure of the application](https://cdn-images-1.medium.com/max/2000/1*m06XFPa5OTvOF6zGPC7Q0w.png)

### UseCases

Use cases are the application logic executor. As the name depicts each functionality can have its separate use case. With more granularity of the use case creation, it can be reused more often.

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

This use case returns Flowable which can be modified according to the required observer. There are two parameters to it. One of them is **transformers** or [ObservableTransformer](http://reactivex.io/RxJava/javadoc/io/reactivex/ObservableTransformer.html) which control what thread to execute the logic and the other parameter **repository**, is the interface for the data layer. If any data has to be passed to the data layer then HashMap can be used.

### Repositories

It specifies the functionalities required by the use cases which is implemented by the data layer.

### What is Data Layer?

This layer is responsible for providing the data required by the application. Data layer should be designed such data it can be re-used by any application without modification in their presentation logic.

![The data layer structure of the application](https://cdn-images-1.medium.com/max/2000/1*KbdhwDpsxspHEz7QInpbhA.png)

**API** provides remote networking implementation. Any networking library can be integrated into this like retrofit, volley etc. Similarly, **DB** provides local database implementation.

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

In Repository, we have an implementation of the local, remote or any kind of data provider and above class NewsRepositoryImpl.kt implements the interface exposed by the domain layer. It acts as a single point of access to the data layer.

**What is the presentation layer?**

The presentation layer provides the UI implementation of the application. It is the dumb layer which only performs instruction with no logic in it. This layer internally implements architecture like MVC, MVP, MVVM, MVI etc. This is the layer where everything connects.

![The presentation layer structure of the application](https://cdn-images-1.medium.com/max/2000/1*4UH3LeLcGg8tjp1BmPm1jw.png)

**DI** folder provides the injection all the dependencies at the start of an app like network related, View Models, Use Cases etc. DI in android can be implemented with dagger, kodein, koin or by just using the service locator pattern. It just depends upon the application like for complex app di can be pretty helpful. I chose koin just because it was much easy to understand and implement than dagger.

**Why using ViewModels?**

As per the android documentation [ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel):

> **Store and manage UI-related data in a lifecycle conscious way. It allows data to survive configuration changes such as screen rotations.**

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

So, ViewModel retains the data on configuration change. In MVP, Presenter was bind to the view with the interface which makes it difficult to test but in ViewModel, there is no interface because of the architectural aware components.

Base View Model is using [CompositeDisposable](http://reactivex.io/RxJava/javadoc/io/reactivex/disposables/CompositeDisposable.html) for adding all the observables and removing all them on @OnCleared of the lifecycle.

```Kotlin
data class Data<RequestData>(var responseType: Status, var data: RequestData? = null, var error: Error? = null)

enum class Status { SUCCESSFUL, ERROR, LOADING }
```

A data wrapper class is used onto the LiveData as a helper class so that view gets to know about the status of the request i.e if it has been started, successful or any concerned state about the data.

**How all the layers are connected?**

Each layer has its own **entities** which are specific to that package. Mapper is used for conversion of one layer entities to another. We are having different entities for each layer so that the layer becomes purely independent and only the required data gets passed to the subsequent layer.

### Application Flow

![](https://cdn-images-1.medium.com/max/2516/1*a-AUcEVdyRJhIepo9JyJBw.png)

***

This would be the end of the post, Let me know if I missed anything. Let me conclude by:

> Base architecture defines the solidarity of the app and yes, It depends upon the app for the appropriate architecture BUT why not just pick the most apt architecture** ahead of time **which could be scalable, robust, testable so that you don’t have to take pain in future.

Thanks for reading :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
