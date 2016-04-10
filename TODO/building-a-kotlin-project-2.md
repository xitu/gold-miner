>* 原文链接 : [Building a Kotlin project 2/2](http://www.cirorizzo.net/2016/03/04/building-a-kotlin-project-2/)
* 原文作者 : [CIRO RIZZO](https://github.com/cirorizzo)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态： 认领中


###### _Part 2_

In the previous [post<sup class="readableLinkFootnote">[1]</sup>](http://www.cirorizzo.net/building-a-kotlin-project/) we started a new project from scratch, and adjusted the `build.gradle` for the Kitten App purpose.

The next steps are going to be the programming of the elements of the app.

#### Data Model

One of the main features of the app is to retrieve data through Internet via the `http://thecatapi.com/`

> _The complete API call will be i.e. `http://thecatapi.com/api/images/get?format=xml&amp;results_per_page=10`_

The API sends back an `XML` file like this one

<div class="readableLargeImageContainer">![XML API](http://www.cirorizzo.net/content/images/2016/03/xxmlAPI.png.pagespeed.ic.CABTBWB1Ch.png)</div>

It needs to deserialize in order to get the `url` property containing the location of the Kitten image.

Kotlin has a very useful class called `data class` that is perfect for the purpose.

Let's starting to create a new class file in the `model.cats` package using right click on it and `New->Kotlin File/Class` and call it `Cats` and choose `Class` as kind.

In order to structure the class as the `XML` file received the `Cats.kt` will be as the following

    data class Cats(var data: Data? = null)

    data class Data(var images: ArrayList<Image>? = null)

    data class Image(var url: String? = "", var id: String? = "", var source_url: String? = "")

So far very simple...  
The same class in Java is much longer!

The Kotlin Data Class has several benefits, some of them are that the compiler generates `getter()`, `setter()` and `toString()` methods, and many more like `equals()` `hashCode()` and `copy()`. So it's the perfect class to use to deserialize data

#### API Call

There are many ways to retrieve data through the network, and different libraries to handle it. One of these libraries is the [Retrofit2<sup class="readableLinkFootnote">[2]</sup>](http://square.github.io/retrofit/) library from Square.  
This is a very powerful `HTTPClient` and easy to set up.

Let's start with the `interface` and create it under the `network` package.  
Call it `CatAPI` as shown

    interface CatAPI {
        @GET("/api/images/get?format=xml&amp;results_per_page=" + BuildConfig.MAX_IMAGES_PER_REQUEST)
        fun getCatImageURLs(): Observable<Cats>
    }

The `interface` will manage the `Get` request to the API Endpoint `/api/images/get?format=xml&amp;results_per_page=`.  
In this case the param `results_per_page` retrieve its numerical value from the constant defined in the `build.gradle` called `MAX_IMAGES_PER_REQUEST` that will have different values depending on the `buildTypes` used.

    buildTypes {
        debug {
            buildConfigField("int", "MAX_IMAGES_PER_REQUEST", "10")
            ...

> This method is very useful to have different value of constants in case we're using `debug` type or `release` one i.e. _especially in case you need to access to the debug API instead of the production one_

About the `interface CatAPI` is very interesting the function called to manage the callback from the API `fun getCatImageURLs(): Observable<Cats>`

So the next step is its implementation.  
Let's create a new class under the same package (`network`) and call it `CatAPINetwork` as this

    class CatAPINetwork {
        fun getExec(): Observable<Cats> {
            val retrofit = Retrofit.Builder()
                .baseUrl("http://thecatapi.com")
                .addConverterFactory(SimpleXmlConverterFactory.create())
                .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
                .build()

            val catAPI: CatAPI = retrofit.create(CatAPI::class.java)

            return catAPI.getCatImageURLs().
                subscribeOn(Schedulers.io()).
                observeOn(AndroidSchedulers.mainThread())
        }
    }

The `fun getExec(): Observable<Cats>` is implicitly `public` so that means available to be called by outside this class.

The line `.addConverterFactory(SimpleXmlConverterFactory.create())` indicates to use the `XML` converter to deserialize the result form the API call.

Then the `.addCallAdapterFactory(RxJavaCallAdapterFactory.create())` is the call adapter to use on the API Callback

The `return` lines referring to the `RxJava` `Observable`

    return catAPI.getCatImageURLs().
                subscribeOn(Schedulers.io()).
                observeOn(AndroidSchedulers.mainThread())

#### Presenter

The `Presenter` modules are in charge of managing the logic of the app and to bind data between the `View` and the `Model`.

In our case it will implement the method called by the `View` to retrieve the API data and send them to the `Adapter` in charge to show up.

In order to communicate with the `View` we're starting to create its `interface` called `MasterPresenter` under the package `presenter` as the followed

    interface MasterPresenter {
        fun connect(imagesAdapter: ImagesAdapter)
        fun getMasterRequest()
    }

The first function `fun connect(imagesAdapter: ImagesAdapter)` will be used to connect the `Adapter interface` to show data, and the `fun getMasterRequest()` will be the one to start the API request.

Let's the implementations in a new class under the same `presenter` package and call it `MasterPresenterImpl`

    class MasterPresenterImpl : MasterPresenter {
        lateinit private var imagesAdapter: ImagesAdapter

        override fun connect(imagesAdapter: ImagesAdapter) {
            this.imagesAdapter = imagesAdapter
        }

        override fun getMasterRequest() {
            imagesAdapter.setObservable(getObservableMasterRequest(CatAPINetwork()))
        }

        private fun getObservableMasterRequest(catAPINetwork: CatAPINetwork): Observable<Cats> {
            return catAPINetwork.getExec()
        }
    }

Interesting line at `lateinit private var imagesAdapter: ImagesAdapter` where Kotlin give us the chance to declare a Non-Nullable mutable object without initialization thanks to `lateinit` keyword. So it will be initialize at the first time it will be used at runtime; in our case on calling the `fun connect(imagesAdapter: ImagesAdapter)`.

The function `fun getMasterRequest()` is in charge of starting the API call, just set the `Observable` in order to be subscribed by the `Adapter` (i.e. `imagesAdapter`) after starts the `catAPINetwork.getExec()` that executes the API call

#### View section

In the `view` package are collected the classes to manage the UI.  
Basically are the `View` and the `Adapter` ones; in our case `MainActivity` and `ImagesAdapter`.

###### Layouts

Before starting with their implementation, let's go through the `Layout` designing.

<div class="readableLargeImageContainer float">![Kitten App](http://www.cirorizzo.net/content/images/2016/03/xkittenApp-1.png.pagespeed.ic.ulo4yWl6Cg.png)</div>

To design it we need basically of two elements the <mark>main container</mark> and the <mark>item container</mark>.

The <mark>main container</mark> is the element containing the list of the item and we're going to place it in the `activity_main.xml` contained in the `res->layout` folder of the project; this one has been automatically created during the initial phase of [Project Creation<sup class="readableLinkFootnote">[3]</sup>](http://www.cirorizzo.net/building-a-kotlin-project/).

For our app we need to inject in a `RecyclerView` component (a very powerful and optimized component for listing views).

The `activity_main.xml` will be like shown

    <?xml version="1.0" encoding="utf-8"?>
    <RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
        xmlns:tools="http://schemas.android.com/tools"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        tools:context=".view.MainActivity"
        android:gravity="center">

        <android.support.v7.widget.RecyclerView
            android:id="@+id/containerRecyclerView"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:scrollbars="vertical"
            android:layout_centerInParent="true" />
    </RelativeLayout>

The component `containerRecyclerView` represents the <mark>main container</mark> of the list of item

The `row_card_view.xml` is the <mark>item container</mark> of our list and basically it appears like this

    <?xml version="1.0" encoding="utf-8"?>
    <android.support.v7.widget.CardView
        xmlns:card_view="http://schemas.android.com/apk/res-auto"
        xmlns:android="http://schemas.android.com/apk/res/android"
        android:id="@+id/card_view"
        android:layout_gravity="center"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        card_view:cardCornerRadius="4dp"
        android:layout_margin="16dp"
        android:background="@android:color/transparent"
        android:layout_centerInParent="true"
        android:elevation="4dp">

        <RelativeLayout
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_centerInParent="true"
            android:gravity="center"
            android:foregroundGravity="center">

            <ImageView
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:id="@+id/imgVw_cat"
                android:padding="4dp"
                android:layout_centerInParent="true"
                android:scaleType="fitCenter"
                android:contentDescription="@string/cat_image" />
        </RelativeLayout>
    </android.support.v7.widget.CardView>

As you can see the item container is the `card_view` that basically is composed by a `RelativeLayout` containing an `ImageView` (`imgVw_cat`)

###### Adapter

Now we've got basic elements of the `Layout`, so let's move on implementing the `MainActivity` and the `Adapter`.

Starting on `Adapter` the first thing to create is its `interface` in order to be invoked by the previous `MasterPresenterImpl` so let's create a new file in the `view` package and called it `ImagesAdapter` and write it down like this

    interface ImagesAdapter {
        fun setObservable(observableCats: Observable<Cats>)
        fun unsubscribe()
    }

The function `setObservable(observableCats: Observable<Cats>)` is called by `MasterPresenterImpl` to set the `Observable` and give the `Adapter` to subscribe to it.

The `unsubscribe()` function will be invoked by the `MainActivity` to unsubscribe the `Adapter` from the `Observable` when the activity is destroyed.

Now let's implement them in a new class under the same package called `ImagesAdapterImpl` that appears like that

    class ImagesAdapterImpl : RecyclerView.Adapter<ImagesAdapterImpl.ImagesURLsDataHolder>(), ImagesAdapter {
        private val TAG = ImagesAdapterImpl::class.java.simpleName

        private var cats: Cats? = null
        private val subscriber: Subscriber<Cats> by lazy { getSubscribe() }

        override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ImagesURLsDataHolder {
            return ImagesURLsDataHolder(
                    LayoutInflater.from(parent.context).inflate(R.layout.row_card_view, parent, false))
        }

        override fun getItemCount(): Int {
            return cats?.data?.images?.size ?: 0
        }

        override fun onBindViewHolder(holder: ImagesURLsDataHolder, position: Int) {
            holder.bindImages(cats?.data?.images?.get(position)?.url ?: "")
        }

        private fun setData(cats: Cats?) {
            this.cats = cats
        }

        override fun setObservable(observableCats: Observable<Cats>) {
            observableCats.subscribe(subscriber)
        }

        override fun unsubscribe() {
            if (!subscriber.isUnsubscribed) {
                subscriber.unsubscribe()
            }
        }

        private fun getSubscribe(): Subscriber<Cats> {
            return object : Subscriber<Cats>() {
                override fun onCompleted() {
                    Log.d(TAG, "onCompleted")
                    notifyDataSetChanged()
                }

                override fun onNext(cats: Cats) {
                    Log.d(TAG, "onNextNew")
                    setData(cats)
                }

                override fun onError(e: Throwable) {
                    //TODO : Handle error here
                    Log.d(TAG, "" + e.message)
                }
            }
        }

        class ImagesURLsDataHolder(view: View) : RecyclerView.ViewHolder(view) {

            fun bindImages(imgURL: String) {
                Glide.with(itemView.context).
                        load(imgURL).
                        placeholder(R.mipmap.document_image_cancel).
                        diskCacheStrategy(DiskCacheStrategy.ALL).
                        centerCrop().
                        into(itemView.imgVw_cat)
            }
        }
    }

This is the class inflate the `row_card_view.xml`, basically the <mark>item container</mark> as you can see at function `onCreateViewHolder`

The function `getSubscribe()` provide to subscribe the `Adapter` to the `Observable` used at line `private val subscriber: Subscriber<Cats> by lazy { getSubscribe() }` where you can notice the `lazy` initialization, this is a way to declare an unmutable object (i.e. `subscriber`) and it'll be created through the function enclosed in the braces (i.e. `getSubscribe()`) at the first invocation at runtime.

> _The Subscriber and Observable concepts comes from [RxJava<sup class="readableLinkFootnote">[4]</sup>](https://github.com/ReactiveX/RxJava); We can dig deeper in some next posts_

At the end, a very interesting piece of code is the inner class called `ImagesURLsDataHolder` used to fill up the `imgVw_cat` using the `Glide` library, that helps to retrieve the image from the passed `URL` extracted by the API call. This part is wrapped in the function `bindImages(imgURL: String)` and invoked by the method `onBindViewHolder` in the same file.

###### Activity

Last but not least the the `Activity` (i.e. `MainActivity`)

    class MainActivity : AppCompatActivity() {
        private val imagesAdapterImpl: ImagesAdapterImpl by lazy { ImagesAdapterImpl() }

        private val masterPresenterImpl: MasterPresenterImpl
                by lazy {
                    MasterPresenterImpl()
                }

        override fun onCreate(savedInstanceState: Bundle?) {
            super.onCreate(savedInstanceState)
            setContentView(R.layout.activity_main)

            initRecyclerView()
            connectingToMasterPresenter()
            getURLs()
        }

        override fun onDestroy() {
            imagesAdapterImpl.unsubscribe()
            super.onDestroy()
        }

        private fun initRecyclerView() {
            containerRecyclerView.layoutManager = GridLayoutManager(this, 1)
            containerRecyclerView.adapter = imagesAdapterImpl
        }

        private fun connectingToMasterPresenter() {
            masterPresenterImpl.connect(imagesAdapterImpl)
        }

        private fun getURLs() {
            masterPresenterImpl.getMasterRequest()
        }
    }

Notice the functions

*   `initRecyclerView()`
*   `connectingToMasterPresenter()`
*   `getURLs()`

Respectively used to

*   initialize the <mark>main container</mark> (i.e. `RecyclerView`)
*   connecting the `MainActivity` to the `MasterPresenterImpl` and pass to it the `interface` of the `ImagesAdapterImpl` (aka `Adapter`)
*   `getURLs()` starts the API request to retrieve the `XML` data, and so executing the followed tasks (deserialize data, retrieving images through `Adapter`).

The Kitten App is now ready to run.  
In any case you can find the entire project on my Github Repository of the [KShow<sup class="readableLinkFootnote">[5]</sup>](https://github.com/cirorizzo/KShows) project.  
The same project has been written in Java as well [JShows<sup class="readableLinkFootnote">[6]</sup>](https://github.com/cirorizzo/JShows) so you can comparing them

