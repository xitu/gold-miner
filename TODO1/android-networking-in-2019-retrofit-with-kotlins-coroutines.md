> * 原文地址：[Android Networking in 2019 — Retrofit with Kotlin’s Coroutines](https://android.jlelse.eu/android-networking-in-2019-retrofit-with-kotlins-coroutines-aefe82c4d777)
> * 原文作者：[Navendra Jha](https://medium.com/@navendra)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/android-networking-in-2019-retrofit-with-kotlins-coroutines.md](https://github.com/xitu/gold-miner/blob/master/TODO1/android-networking-in-2019-retrofit-with-kotlins-coroutines.md)
> * 译者：
> * 校对者：

# 2019 年的 Android 网络 —— Retrofit 与 Kotlin 协程

The year 2018 saw a lot of big changes in the Android World, especially in terms of Android Networking. The launch of a stable version of Kotlin Coroutines fueled a lot of movement from RxJava to Kotlin Coroutines for handling multithreading in Android.  
In this article, we will be talking about making Networking API calls in Android using [Retrofit2](https://square.github.io/retrofit/) and [Kotlin Coroutines](https://kotlinlang.org/docs/reference/coroutines-overview.html). We will be making a networking call to [TMDB API](https://developers.themoviedb.org/3) to fetch popular movies.2018 年，Android 圈发生了许多翻天覆地的变化，尤其是在 Android 网络方面。稳定版本的 Kotlin 协程的发布推动了自 RxJava 到 Kotlin 协程这些用以处理 Android 多线程方式的巨大发展。
本文中，我们将讨论在 Android 中使用 [Retrofit2](https://square.github.io/retrofit/) 和 [Kotlin 协程](https://kotlinlang.org/docs/reference/coroutines-overview.html) 进行网络 API 调用。我们会调用 [TMDB API](https://developers.themoviedb.org/3) 来获取热门电影。

![](https://cdn-images-1.medium.com/max/2000/1*un0xtxGU3IEh8KBXcAXGQA.png)

#### 概念我都懂，给我看代码！！

If you are experienced with Android Networking and have made networking calls before using Retrofit but probably with other libraries viz RxJava, instead of Kotlin Coroutines and just want to check out the implementation, [check out this code readme on Github.](https://github.com/navi25/RetrofitKotlinDeferred/)---如果你对 Android 网络有经验并且在使用 Retrofit 之前进行过网络调用，但可能使用的是 RxJava 而不是 Kotlin 协程，如果你只想看看实现方式，[请查看 Github 上的 readme 文件。](https://github.com/navi25/RetrofitKotlinDeferred/)

#### Android 网络简述Android Networking in Nutshell

In a nutshell, android networking or any networking works in the following way:简而言之，Android 网络或者任何网络的工作方式如下：

* **Request—** Make an HTTP request to an URL (called as endpoint) with proper headers generally with Authorisation Key if required.**请求——** 使用正确的头信息向一个 URL（终端）发出一个 HTTP 请求，如有需要，通常会携带授权的 Key 。
* **Response —** The Request will return a response which can be error or success. In the case of success, the response will contain the contents of the endpoint (generally they are in JSON format) **响应——** 请求会返回错误或者成功的响应。在成功的情况下，响应会包含终端的内容（通常是 JSON 格式）。
* **Parse & Store —** We will parse this JSON and get the required values and store them in our data class. **解析和存储** 解析 JSON 并获取所需的值，然后将其存入数据类中。

In Android, we use — Android 中，我们使用：

* [Okhttp](http://square.github.io/okhttp/) — For creating an HTTP request with all the proper headers. [Okhttp](http://square.github.io/okhttp/)——用于创建具有合适头信息的 HTTP 请求。
* [Retrofit](https://square.github.io/retrofit/) — For making the request[Retrofit](https://square.github.io/retrofit/)——发送请求
* [Moshi ](https://github.com/square/moshi)/ [GSON ](https://github.com/google/gson)— For parsing the JSON data[Moshi ](https://github.com/square/moshi)/ [GSON ](https://github.com/google/gson)——解析 JSON 数据
* [Kotlin Coroutines](https://kotlinlang.org/docs/reference/coroutines-overview.html) — For making non-blocking (main thread) network requests.[Kotlin 协程](https://kotlinlang.org/docs/reference/coroutines-overview.html)——
* [Picasso](http://square.github.io/picasso/) / [Glide](https://bumptech.github.io/glide/)— For downloading an image from the internet and setting it into an ImageView.[Picasso](http://square.github.io/picasso/) / [Glide](https://bumptech.github.io/glide/)——下载网络图片并将其设置给 ImageView。

Obviously, these are just some of the popular libraries but there are others too. Also, most of these libraries are developed by awesome folks at [Square Inc.](https://en.wikipedia.org/wiki/Square,_Inc.) Check out this for more [open source project by the Square Team](http://square.github.io/).显然这些只是一些热门的库，也有其他类似的库。此外这些库都是由 [Square 公司](https://en.wikipedia.org/wiki/Square,_Inc) 的牛人开发的。点击 [Square 团队的开源项目](http://square.github.io/) 查看更多。

## Let's get started开始吧

The Movie Database (TMDb) API contains a list of all popular, upcoming, latest, now showing movies and tv shows. This is one of the most popular API to play with too. Movie Database（TMDb）API 包含所有热门的、即将上映的、正在上映的电影和电视节目列表。这也是最流行的 API 之一。

TMDB API requires an API key to make requests. For that:-
TMDB API 需要 API 密钥才能请求。为此：

* Make an account at [TMDB](https://www.themoviedb.org/)
* 在 [TMDB](https://www.themoviedb.org/) 建一个账号
* [Follow steps described here to register for an API key](https://developers.themoviedb.org/3/getting-started/introduction).
* [按照这里的步骤注册一个 API 密钥](https://developers.themoviedb.org/3/getting-started/introduction)。

#### Hiding API key in Version Control (Optional but Recommended)
#### 在版本控制系统中隐藏 API 密钥（可选但推荐）

Once you have the API key, do the following steps to hide it in VCS.
获取 API 密钥后，按照下述步骤将其在 VCS 中隐藏。

* Add your key in **local.properties** present in the root folder.
* 将你的密钥添加到根目录下的 **local.properties** 文件中。
* Get access to the key in **build.gradle** programmatically
* 在 **build.gradle** 中用代码来访问密钥。
* Then the key is available to you in the program though **BuildConfig**.
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

## Setting up the Project
## 设置项目

For setting up the project, we will first add all the required dependencies in **build.gradle (Module: app):-**
为了设置项目，我们首先会将所有必需的依赖项添加到 **build.gradle（Module: app）** 文件中：

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

#### Now let’s create our TmdbAPI service
#### 然后创建我们的 TmdbAPI 服务

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

Let’s see what we are doing here in ApiFactory.kt.
让我们看看我们在 ApiFactory.kt 文件中做了什么。

* First, we are creating a Network Interceptor to add api_key in all the request as **authInterceptor.**
* 首先，我们创建了一个用以给所有请求添加 api_key 参数的网络拦截器，名为 **authInterceptor** 。
* Then we are creating a networking client using OkHttp and add our authInterceptor.
* 然后我们用 OkHttp 创建了一个网络客户端，并添加我们的 authInterceptor
* Next, we join everything together to create our HTTP Request builder and handler using Retrofit. Here we add our previously created networking client, base URL, and add a converter and an adapter factory.
* 接下来，我们用 Retrofit 将所有内容连接起来构建 Http 请求的构造器和处理器。此处我们加入了之前创建好的网络客户端、基础 URL、一个转换器和一个适配器工厂。
First is MoshiConverter which assist in JSON parsing and converts Response JSON into Kotlin data class with selective parsing if required.
首先是 MoshiConverter，用以辅助 JSON 解析并将响应的 JSON 转化为 Kotlin 数据类，如有需要，可以进行选择性解析。
The second one is CoroutineCallAdaptor which is aRetrofit2 `CallAdapter.Factory` for [Kotlin coroutine's](https://kotlinlang.org/docs/reference/coroutines.html) `Deferred`.
第二个是 CoroutineCallAdaptor，它是 Retorofit2 中 `CallAdapter.Factory` 的类型，用于  [Kotlin 协程的](https://kotlinlang.org/docs/reference/coroutines.html) `Deferred`
* Finally, we simply create our tmdbApi by passing a reference of **TmdbApi class (This is created in the next section)** to the previously created retrofit class.
* 最后，我们只需将 **TmdbApi 类（下节中创建）** 的一个引用传入之前建好的 retrofit 类中就可以创建我们的 tmdbApi。

#### Exploring the Tmdb API
#### 了解 Tmdb API
We get the following response for **/movie/popular** endpoint. The response returns **results** which is an array of movie object. This is a point of interest for us.
调用 **/movie/popular** 接口我们得到了如下响应。该响应中返回了 **results**，这是一个 movie 对象的数组。这正是我们感兴趣的一点。

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

So now let’s create our Movie data class and MovieResponse class as per the json.

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

**TmdbApi interface**  
After creating data classes, we create TmdbApi interface whose reference we added in the retrofit builder in the earlier section. In this interface, we add all the required API calls with any query parameter if necessary. For example, for getting a movie by id we will add the following method to our interface:

```Kotlin
interface TmdbApi{

    @GET("movie/popular")
    fun getPopularMovies() : Deferred<Response<TmdbMovieResponse>>

    @GET("movie/{id}")      
    fun getMovieById(@Path("id") id:Int): Deferred<Response<Movie>>

}
```

## Finally making a Networking Call

Next, we finally make a networking call to get the required data, we can make this call in DataRepository or in ViewModel or directly in Activity too.

#### Sealed Result Class

Class to handle Network response. It either can be Success with the required data or Error with an exception.

```Kotlin
sealed class Result<out T: Any> {
    data class Success<out T : Any>(val data: T) : Result<T>()
    data class Error(val exception: Exception) : Result<Nothing>()
}
```

#### Building BaseRepository to handle safeApiCall

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

#### Building MovieRepository

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

#### Creating the View Model to fetch data

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

#### Using ViewModel in Activity to Update UI

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

This is a basic introductory but full production level API calls on Android. [For more examples, visit here.](https://github.com/navi25/RetrofitKotlinDeferred)

Happy Coding!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
