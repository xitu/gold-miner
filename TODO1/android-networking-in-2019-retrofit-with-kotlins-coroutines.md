> * 原文地址：[Android Networking in 2019 — Retrofit with Kotlin’s Coroutines](https://android.jlelse.eu/android-networking-in-2019-retrofit-with-kotlins-coroutines-aefe82c4d777)
> * 原文作者：[Navendra Jha](https://medium.com/@navendra)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/android-networking-in-2019-retrofit-with-kotlins-coroutines.md](https://github.com/xitu/gold-miner/blob/master/TODO1/android-networking-in-2019-retrofit-with-kotlins-coroutines.md)
> * 译者：
> * 校对者：

# Android Networking in 2019 — Retrofit with Kotlin’s Coroutines

The year 2018 saw a lot of big changes in the Android World, especially in terms of Android Networking. The launch of a stable version of Kotlin Coroutines fueled a lot of movement from RxJava to Kotlin Coroutines for handling multithreading in Android.  
In this article, we will be talking about making Networking API calls in Android using [Retrofit2](https://square.github.io/retrofit/) and [Kotlin Coroutines](https://kotlinlang.org/docs/reference/coroutines-overview.html). We will be making a networking call to [TMDB API](https://developers.themoviedb.org/3) to fetch popular movies.

![](https://cdn-images-1.medium.com/max/2000/1*un0xtxGU3IEh8KBXcAXGQA.png)

#### I know all these concepts, Show me the code!!

If you are experienced with Android Networking and have made networking calls before using Retrofit but probably with other libraries viz RxJava, instead of Kotlin Coroutines and just want to check out the implementation, [check out this code readme on Github.](https://github.com/navi25/RetrofitKotlinDeferred/)

#### Android Networking in Nutshell

In a nutshell, android networking or any networking works in the following way:

* **Request—** Make an HTTP request to an URL (called as endpoint) with proper headers generally with Authorisation Key if required.
* **Response —** The Request will return a response which can be error or success. In the case of success, the response will contain the contents of the endpoint (generally they are in JSON format)
* **Parse & Store —** We will parse this JSON and get the required values and store them in our data class.

In Android, we use —

* [Okhttp](http://square.github.io/okhttp/) — For creating an HTTP request with all the proper headers.
* [Retrofit](https://square.github.io/retrofit/) — For making the request
* [Moshi ](https://github.com/square/moshi)/ [GSON ](https://github.com/google/gson)— For parsing the JSON data
* [Kotlin Coroutines](https://kotlinlang.org/docs/reference/coroutines-overview.html) — For making non-blocking (main thread) network requests.
* [Picasso](http://square.github.io/picasso/) / [Glide](https://bumptech.github.io/glide/)— For downloading an image from the internet and setting it into an ImageView.

Obviously, these are just some of the popular libraries but there are others too. Also, most of these libraries are developed by awesome folks at [Square Inc.](https://en.wikipedia.org/wiki/Square,_Inc.) Check out this for more [open source project by the Square Team](http://square.github.io/).

## Let's get started

The Movie Database (TMDb) API contains a list of all popular, upcoming, latest, now showing movies and tv shows. This is one of the most popular API to play with too.

TMDB API requires an API key to make requests. For that:-

* Make an account at [TMDB](https://www.themoviedb.org/)
* [Follow steps described here to register for an API key](https://developers.themoviedb.org/3/getting-started/introduction).

#### Hiding API key in Version Control (Optional but Recommended)

Once you have the API key, do the following steps to hide it in VCS.

* Add your key in **local.properties** present in the root folder.
* Get access to the key in **build.gradle** programmatically.
* Then the key is available to you in the program though **BuildConfig**.

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

For setting up the project, we will first add all the required dependencies in **build.gradle (Module: app):-**

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

* First, we are creating a Network Interceptor to add api_key in all the request as **authInterceptor.**
* Then we are creating a networking client using OkHttp and add our authInterceptor.
* Next, we join everything together to create our HTTP Request builder and handler using Retrofit. Here we add our previously created networking client, base URL, and add a converter and an adapter factory. 
First is MoshiConverter which assist in JSON parsing and converts Response JSON into Kotlin data class with selective parsing if required.
The second one is CoroutineCallAdaptor which is aRetrofit2 `CallAdapter.Factory` for [Kotlin coroutine's](https://kotlinlang.org/docs/reference/coroutines.html) `Deferred`.
* Finally, we simply create our tmdbApi by passing a reference of **TmdbApi class (This is created in the next section)** to the previously created retrofit class.

#### Exploring the Tmdb API

We get the following response for **/movie/popular** endpoint. The response returns **results** which is an array of movie object. This is a point of interest for us.

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
