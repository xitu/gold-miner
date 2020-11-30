> * 原文地址：[Android Networking in 2019 — Retrofit with Kotlin’s Coroutines](https://android.jlelse.eu/android-networking-in-2019-retrofit-with-kotlins-coroutines-aefe82c4d777)
> * 原文作者：[Navendra Jha](https://medium.com/@navendra)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/android-networking-in-2019-retrofit-with-kotlins-coroutines.md](https://github.com/xitu/gold-miner/blob/master/TODO1/android-networking-in-2019-retrofit-with-kotlins-coroutines.md)
> * 译者：[feximin](https://github.com/Feximin)

# 2019 年的 Android 网络 —— Retrofit 与 Kotlin 协程

2018 年，Android 圈发生了许多翻天覆地的变化，尤其是在 Android 网络方面。稳定版本的 Kotlin 协程的发布极大地推动了 Android 在处理多线程方面从 RxJava 到 Kotlin 协程的发展。
本文中，我们将讨论在 Android 中使用 [Retrofit2](https://square.github.io/retrofit/) 和 [Kotlin 协程](https://kotlinlang.org/docs/reference/coroutines-overview.html) 进行网络 API 调用。我们将调用 [TMDB API](https://developers.themoviedb.org/3) 来获取热门电影列表。

![](https://cdn-images-1.medium.com/max/2000/1*un0xtxGU3IEh8KBXcAXGQA.png)

### 概念我都懂，给我看代码！！

如果你在 Android 网络方面有经验并且在使用 Retrofit 之前进行过网络调用，但可能使用的是 RxJava 而不是 Kotlin 协程，并且你只想看看实现方式，[请查看 Github 上的 readme 文件](https://github.com/navi25/RetrofitKotlinDeferred/)。

### Android 网络简述

简而言之，Android 网络或者任何网络的工作方式如下：

* **请求** —— 使用正确的头信息向一个 URL（终端）发出一个 HTTP 请求，如有需要，通常会携带授权的 Key。
* **响应** —— 请求会返回错误或者成功的响应。在成功的情况下，响应会包含终端的内容（通常是 JSON 格式）。
* **解析和存储** —— 解析 JSON 并获取所需的值，然后将其存入数据类中。

Android 中，我们使用：

* [Okhttp](http://square.github.io/okhttp/) —— 用于创建具有合适头信息的 HTTP 请求。
* [Retrofit](https://square.github.io/retrofit/) —— 发送请求。
* [Moshi](https://github.com/square/moshi)/ [GSON](https://github.com/google/gson) —— 解析 JSON 数据。
* [Kotlin 协程](https://kotlinlang.org/docs/reference/coroutines-overview.html) —— 用于发出非阻塞（主线程）的网络请求。
* [Picasso](http://square.github.io/picasso/) / [Glide](https://bumptech.github.io/glide/) —— 下载网络图片并将其设置给 ImageView。

显然这些只是一些热门的库，也有其他类似的库。此外这些库都是由 [Square 公司](https://en.wikipedia.org/wiki/Square,_Inc) 的牛人开发的。点击 [Square 团队的开源项目](http://square.github.io/) 查看更多。

## 开始吧

Movie Database（TMDb）API 包含所有热门的、即将上映的、正在上映的电影和电视节目列表。这也是最流行的 API 之一。

TMDB API 需要 API 密钥才能请求。为此：

* 在 [TMDB](https://www.themoviedb.org/) 建一个账号
* [按照这里的步骤注册一个 API 密钥](https://developers.themoviedb.org/3/getting-started/introduction)。

### 在版本控制系统中隐藏 API 密钥（可选但推荐）

获取 API 密钥后，按照下述步骤将其在 VCS 中隐藏。

* 将你的密钥添加到根目录下的 **local.properties** 文件中。
* 在 **build.gradle** 中用代码来访问密钥。
* 之后在程序中通过 **BuildConfig** 就可以使用密钥了。

```Gradle
//In local.properties
tmdb_api_key = "xxxxxxxxxxxxxxxxxxxxxxxxxx"

//In build.gradle (Module: app)
buildTypes.each {
        Properties properties = new Properties()
        properties.load(project.rootProject.file("local.properties").newDataInputStream())
        def tmdbApiKey = properties.getProperty("tmdb_api_key", "")

        it.buildConfigField 'String', "TMDB_API_KEY", tmdbApiKey
        
        it.resValue 'string', "api_key", tmdbApiKey

}

//In your Constants File
var tmdbApiKey = BuildConfig.TMDB_API_KEY
```

## 设置项目

为了设置项目，我们首先会将所有必需的依赖项添加到 **build.gradle (Module: app)** 文件中：

```Gradle
// build.gradle(Module: app)
dependencies {

    def moshiVersion="1.8.0"
    def retrofit2_version = "2.5.0"
    def okhttp3_version = "3.12.0"
    def kotlinCoroutineVersion = "1.0.1"
    def picassoVersion = "2.71828"

     
    //Moshi
    implementation "com.squareup.moshi:moshi-kotlin:$moshiVersion"
    kapt "com.squareup.moshi:moshi-kotlin-codegen:$moshiVersion"

    //Retrofit2
    implementation "com.squareup.retrofit2:retrofit:$retrofit2_version"
    implementation "com.squareup.retrofit2:converter-moshi:$retrofit2_version"
    implementation "com.jakewharton.retrofit:retrofit2-kotlin-coroutines-adapter:0.9.2"

    //Okhttp3
    implementation "com.squareup.okhttp3:okhttp:$okhttp3_version"
    implementation 'com.squareup.okhttp3:logging-interceptor:3.11.0'
    
     //Picasso for Image Loading
    implementation ("com.squareup.picasso:picasso:$picassoVersion"){
        exclude group: "com.android.support"
    }

    //Kotlin Coroutines
    implementation "org.jetbrains.kotlinx:kotlinx-coroutines-android:$kotlinCoroutineVersion"
    implementation "org.jetbrains.kotlinx:kotlinx-coroutines-core:$kotlinCoroutineVersion"

   
}
```

### 现在创建我们的 TmdbAPI 服务

```Kotlin
//ApiFactory to create TMDB Api
object Apifactory{
  
    //Creating Auth Interceptor to add api_key query in front of all the requests.
    private val authInterceptor = Interceptor {chain->
            val newUrl = chain.request().url()
                    .newBuilder()
                    .addQueryParameter("api_key", AppConstants.tmdbApiKey)
                    .build()

            val newRequest = chain.request()
                    .newBuilder()
                    .url(newUrl)
                    .build()

            chain.proceed(newRequest)
        }
  
   //OkhttpClient for building http request url
    private val tmdbClient = OkHttpClient().newBuilder()
                                .addInterceptor(authInterceptor)
                                .build()


  
    fun retrofit() : Retrofit = Retrofit.Builder()
                .client(tmdbClient)
                .baseUrl("https://api.themoviedb.org/3/")
                .addConverterFactory(MoshiConverterFactory.create())
                .addCallAdapterFactory(CoroutineCallAdapterFactory())
                .build()   

  
   val tmdbApi : TmdbApi = retrofit().create(TmdbApi::class.java)

}
```

看一下我们在 ApiFactory.kt 文件中做了什么。

* 首先，我们创建了一个用以给所有请求添加 api_key 参数的网络拦截器，名为 **authInterceptor**。
* 然后我们用 OkHttp 创建了一个网络客户端，并添加了 authInterceptor。
* 接下来，我们用 Retrofit 将所有内容连接起来构建 Http 请求的构造器和处理器。此处我们加入了之前创建好的网络客户端、基础 URL、一个转换器和一个适配器工厂。
  首先是 MoshiConverter，用以辅助 JSON 解析并将响应的 JSON 转化为 Kotlin 数据类，如有需要，可进行选择性解析。
第二个是 CoroutineCallAdaptor，它的类型是 Retorofit2 中的 `CallAdapter.Factory`，用于处理 [Kotlin 协程中的](https://kotlinlang.org/docs/reference/coroutines.html) `Deferred`。
* 最后，我们只需将 **TmdbApi 类（下节中创建）** 的一个引用传入之前建好的 retrofit 类中就可以创建我们的 tmdbApi。

### 探索 Tmdb API

调用 **/movie/popular** 接口我们得到了如下响应。该响应中返回了 **results**，这是一个 movie 对象的数组。这正是我们关注的地方。

```JSON
{
  "page": 1,
  "total_results": 19848,
  "total_pages": 993,
  "results": [
    {
      "vote_count": 2109,
      "id": 297802,
      "video": false,
      "vote_average": 6.9,
      "title": "Aquaman",
      "popularity": 497.334,
      "poster_path": "/5Kg76ldv7VxeX9YlcQXiowHgdX6.jpg",
      "original_language": "en",
      "original_title": "Aquaman",
      "genre_ids": [
        28,
        14,
        878,
        12
      ],
      "backdrop_path": "/5A2bMlLfJrAfX9bqAibOL2gCruF.jpg",
      "adult": false,
      "overview": "Arthur Curry learns that he is the heir to the underwater kingdom of Atlantis, and must step forward to lead his people and be a hero to the world.",
      "release_date": "2018-12-07"
    },
    {
      "vote_count": 625,
      "id": 424783,
      "video": false,
      "vote_average": 6.6,
      "title": "Bumblebee",
      "popularity": 316.098,
      "poster_path": "/fw02ONlDhrYjTSZV8XO6hhU3ds3.jpg",
      "original_language": "en",
      "original_title": "Bumblebee",
      "genre_ids": [
        28,
        12,
        878
      ],
      "backdrop_path": "/8bZ7guF94ZyCzi7MLHzXz6E5Lv8.jpg",
      "adult": false,
      "overview": "On the run in the year 1987, Bumblebee finds refuge in a junkyard in a small Californian beach town. Charlie, on the cusp of turning 18 and trying to find her place in the world, discovers Bumblebee, battle-scarred and broken.  When Charlie revives him, she quickly learns this is no ordinary yellow VW bug.",
      "release_date": "2018-12-15"
    }
  ]
}
```

因此现在我们可以根据该 JSON 创建我们的 Movie 数据类和 MovieResponse 类。

```Kotlin
// Data Model for TMDB Movie item
data class TmdbMovie(
    val id: Int,
    val vote_average: Double,
    val title: String,
    val overview: String,
    val adult: Boolean
)

// Data Model for the Response returned from the TMDB Api
data class TmdbMovieResponse(
    val results: List<TmdbMovie>
)

//A retrofit Network Interface for the Api
interface TmdbApi{
    @GET("movie/popular")
    fun getPopularMovie(): Deferred<Response<TmdbMovieResponse>>
}
```


**TmdbApi 接口：**

创建了数据类后，我们创建 TmdbApi 接口，在前面的小节中我们已经将其引用添加至 retrofit 构建器中。在该接口中，我们添加了所有必需的 API 调用，如有必要，可以给这些调用添加任意参数。例如，为了能够根据 id 获取一部电影，我们在接口中添加了如下方法：

```Kotlin
interface TmdbApi{

    @GET("movie/popular")
    fun getPopularMovies() : Deferred<Response<TmdbMovieResponse>>

    @GET("movie/{id}")      
    fun getMovieById(@Path("id") id:Int): Deferred<Response<Movie>>

}
```

## 最后，进行网络调用

接着，我们最终发出一个用以获取所需数据的请求，我们可以在 DataRepository 或者 ViewModel 或者直接在 Activity 中进行此调用。

#### 密封 Result 类

这是用来处理网络响应的类。它可能成功返回所需的数据，也可能发生异常而出错。

```Kotlin
sealed class Result<out T: Any> {
    data class Success<out T : Any>(val data: T) : Result<T>()
    data class Error(val exception: Exception) : Result<Nothing>()
}
```

#### 构建用来处理 safeApiCall 调用的 BaseRepository

```Kotlin
open class BaseRepository{

    suspend fun <T : Any> safeApiCall(call: suspend () -> Response<T>, errorMessage: String): T? {

        val result : Result<T> = safeApiResult(call,errorMessage)
        var data : T? = null

        when(result) {
            is Result.Success ->
                data = result.data
            is Result.Error -> {
                Log.d("1.DataRepository", "$errorMessage & Exception - ${result.exception}")
            }
        }


        return data

    }

    private suspend fun <T: Any> safeApiResult(call: suspend ()-> Response<T>, errorMessage: String) : Result<T>{
        val response = call.invoke()
        if(response.isSuccessful) return Result.Success(response.body()!!)

        return Result.Error(IOException("Error Occurred during getting safe Api result, Custom ERROR - $errorMessage"))
    }
}
```

#### 构建 MovieRepository

```Kotlin
class MovieRepository(private val api : TmdbApi) : BaseRepository() {
  
    fun getPopularMovies() : MutableList<TmdbMovie>?{
      
      //safeApiCall is defined in BaseRepository.kt (https://gist.github.com/navi25/67176730f5595b3f1fb5095062a92f15)
      val movieResponse = safeApiCall(
           call = {api.getPopularMovie().await()},
           errorMessage = "Error Fetching Popular Movies"
      )
      
      return movieResponse?.results.toMutableList();
    
    }

}
```

#### 创建 ViewModel 来获取数据

```Kotlin
class TmdbViewModel : ViewModel(){
  
    private val parentJob = Job()

    private val coroutineContext: CoroutineContext
        get() = parentJob + Dispatchers.Default

    private val scope = CoroutineScope(coroutineContext)

    private val repository : MovieRepository = MovieRepository(ApiFactory.tmdbApi)
    

    val popularMoviesLiveData = MutableLiveData<MutableList<ParentShowList>>()

    fun fetchMovies(){
        scope.launch {
            val popularMovies = repository.getPopularMovies()
            popularMoviesLiveData.postValue(popularMovies)
        }
    }


    fun cancelAllRequests() = coroutineContext.cancel()

}
```

#### 在 Activity 中使用 ViewModel 更新 UI

```Kotlin
class MovieActivity : AppCompatActivity(){
    
    private lateinit var tmdbViewModel: TmdbViewModel
  
     override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_movie)
       
        tmdbViewModel = ViewModelProviders.of(this).get(TmdbViewModel::class.java)
       
        tmdbViewModel.fetchMovies()
       
        tmdbViewModel.popularMovies.observe(this, Observer {
            
            //TODO - Your Update UI Logic
        })
       
     }
  
}
```

本文是 Android 中一个基础但却全面的产品级别的 API 调用的介绍。[更多示例，请访问此处](https://github.com/navi25/RetrofitKotlinDeferred)。

祝编程愉快！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
