>* 原文链接 : [Building a Kotlin project 2/2](http://www.cirorizzo.net/2016/03/04/building-a-kotlin-project-2/)
* 原文作者 : [CIRO RIZZO](https://github.com/cirorizzo)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Jing KE](https://github.com/jingkecn)
* 校对者: [lizhuo](https://github.com/huanglizhuo), [DianaZhou](https://github.com/DianaZhou)

# 创建一个基于 Kotlin 的 Android 项目（下集）

###### _第 2 部分_

在先前的[文章](http://gold.xitu.io/entry/56e3fdc3df0eea0054c7c61f)中，我们从零开始新建了一个项目，并且为小猫咪应用调整了 `build.gradle`。

接下来就是针对应用的基础部分编写代码了。

#### 数据模型

此应用的一个主要特征是通过网络从 `http://thecatapi.com/` 中解析数据。

> _完整的 API 如此调用：`http://thecatapi.com/api/images/get?format=xml&amp;results_per_page=10`_

API 返回一个 `XML` 文件，如下：

![XML API](http://www.cirorizzo.net/content/images/2016/03/xxmlAPI.png.pagespeed.ic.CABTBWB1Ch.png)

它需要反序列化数据来获取包含小猫咪图片位置的 `url` 属性。

Kotlin 有一个非常有用的数据类（`data class`）可以完美实现此目的。

右击 `model.cats` 包 (package) 开始新建一个类文件并且选择  `New -> Kotlin File/Class` 然后将其命名为 `Cats` 并选择 `Class` 作为文件类型。

为像接收到的 `XML` 文件那样构造类，`Cats.kt` 文件将如下所示：

    data class Cats(var data: Data? = null)

    data class Data(var images: ArrayList<Image>? = null)

    data class Image(var url: String? = "", var id: String? = "", var source_url: String? = "")

目前还非常简单……

但同样的类在 Java 中长多了！

Kotlin 中的数据类有几个好处，例如由编译器生成 `getter()`、`setter()` 以及 `toString()` 方法，还有更多的像 `equals()`、`hashCode()` 以及 `copy()` 这些。所以使用它反序列化数据甚是完美。

#### API 调用

通过网络解析数据有很多种方法，也有各种第三方库可以应付。其中就有 Square 的 [Retrofit2<sup class="readableLinkFootnote"></sup>](http://square.github.io/retrofit/) 

这是一个非常强大的 `HTTPClient` 并且安装简单。

我们从 `interface` 开始，先在 `network` 包下创建之。
 
称其为 `CatAPI`，如下所示：

    interface CatAPI {
        @GET("/api/images/get?format=xml&amp;results_per_page=" + BuildConfig.MAX_IMAGES_PER_REQUEST)
        fun getCatImageURLs(): Observable<Cats>
    }

`interface` 会完成对 API 端 `/api/images/get?format=xml&amp;results_per_page=` 的 `Get` 请求。
 
本例中 `results_per_page` 参数从 `build.gradle` 中定义的 `MAX_IMAGES_PER_REQUEST` 常量获取数值，该常量的不同取值取决于使用的 `buildTypes`。

    buildTypes {
        debug {
            buildConfigField("int", "MAX_IMAGES_PER_REQUEST", "10")
            ...

> 此方式对常量在像 `debug` 或 `release` 情景下的不同取值极其有用，
_尤其是在需要从线上 API 切换到测试 API 的时候_。

关于 `interface CatAPI` 有一个关键点，那就是用来实现从 API 回调的函数 `fun getCatImageURLs(): Observable<Cats>`。

所以下一步便是其实现。
 
同在 `network` 包下，新建一个类并将其命名为 `CatAPINetwork`，如下：

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

`fun getExec(): Observable<Cats>` 为隐式 `public`，这意味着它可以在此类以外被调用。

`.addConverterFactory(SimpleXmlConverterFactory.create())` 这一行表明使用 `XML` 转换器来反序列化调用 API 的结果。

接着 `.addCallAdapterFactory(RxJavaCallAdapterFactory.create())` 是用于 API 回调的调用适配器。

`return` 行返回 `RxJava` 的 `Observable` 对象：

    return catAPI.getCatImageURLs().
                subscribeOn(Schedulers.io()).
                observeOn(AndroidSchedulers.mainThread())

#### Presenter

`Presenter` 模块负责完成应用的逻辑部分并在 `View` 和 `Model` 之间实现数据绑定。

本例会实现 `View` 调用以解析 API 数据的方法并将其送至负责展示的 `Adapter`。

为与 `View` 通信，我们先在 `presenter` 包中创建其 `interface` 然后将其命名为 `MasterPresenter`，如下所示：

    interface MasterPresenter {
        fun connect(imagesAdapter: ImagesAdapter)
        fun getMasterRequest()
    }

第一个函数 `fun connect(imagesAdapter: ImagesAdapter)` 用来连接 `Adapter interface` 以显示数据，并且由 `fun getMasterRequest()` 启动 API 请求。

我们将这些实现置于 `presenter` 包的一个新类中并将其命名为 `MasterPresenterImpl`：

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

值得注意的是，在 `lateinit private var imagesAdapter: ImagesAdapter` 一行中，Kotlin 允许我们使用 `lateinit` 关键字在未初始化的情况下声明一个非空可变的对象。它将会在运行时第一次使用它的时候被初始化，比如在本例中会调用 `fun connect(imagesAdapter: ImagesAdapter)`。

`fun getMasterRequest()` 函数负责启用 API 调用，只设置 `Observable` 以便 `Adapter`  (例如 `imagesAdapter`)在启用执行 API 调用的 `catAPINetwork.getExec()` 函数后“订阅”之。

#### View 部分

实现 UI 的类均集中于 `view` 包中。

基本上都是 `View` 和 `Adapter` 这些；本例中是 `MainActivity` 和 `ImagesAdapter`。

###### Layouts

开始实现之前，我们先来研究一下布局 ( `Layout` ) 设计。

![Kitten App](http://www.cirorizzo.net/content/images/2016/03/xkittenApp-1.png.pagespeed.ic.ulo4yWl6Cg.png)

为实现此设计我们大体上需要<mark>主容器</mark>和<mark> item 容器</mark>这两个基本组件。

主容器包含 item 列表，且我们会将其置于项目 `res -> layout`  文件夹的 `activity_main.xml` 中；此文件已在[创建项目<sup class="readableLinkFootnote"></sup>](http://www.cirorizzo.net/building-a-kotlin-project/)的初始价段自动生成。

我们需要将应用装进一个`RecyclerView` 组件中（一个非常强大并且改良过的列表视图组件）。

`activity_main.xml` 如下所示：

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

`containerRecyclerView` 组件代表 item 列表<mark>主容器</mark>

`row_card_view.xml` 是列表的 <mark>item 容器</mark>，大体上像这样：

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

如你所见，item 容器正是主要由一个包含 `ImageView` (`imgVw_cat`) 的 `RelativeLayout` 组成的 `card_view`。

###### Adapter

现在已经有了 `Layout` 的基本部分，那么接下来我们继续实现 `MainActivity` 和 `Adapter`。

从 `Adapter` 开始首先要创建其 `interface` 以被前面的 `MasterPresenterImpl` 调用，所以我们在 `view` 包中新建一个文件并将其命名为 `ImagesAdapter`，然后内容如下：

    interface ImagesAdapter {
        fun setObservable(observableCats: Observable<Cats>)
        fun unsubscribe()
    }

`setObservable(observableCats: Observable<Cats>)` 函数被 `MasterPresenterImpl` 调用来设置 `Observable` 以及让 `Adapter` “订阅”。

`unsubscribe()` 函数会被 `MainActivity` 调用以在 activity 被销毁的时候“退订” `Adapter`。

现在我们在同一个包下一个新建的类中实现它们，称其为 `ImagesAdapterImpl`，如下：

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

这是填充 `row_card_view.xml` 的类，基本上就是 `onCreateViewHolder` 函数的 <mark>item 容器</mark>。

在 `private val subscriber: Subscriber<Cats> by lazy { getSubscribe() }` 一行中，`getSubscribe()` 函数为 `Adapter` “订阅”用到的 `Observable`，这里你会看到 `lazy` 初始化，这是一种声明一个不可变对象的方法（比如 `subscriber`）并且会在运行时首次调用时创建于函数体内（例如 `getSubscribe()`）。

> _Subscriber 和 Observable 概念来源于 [RxJava<sup class="readableLinkFootnote"></sup>](https://github.com/ReactiveX/RxJava)；我们今后会深入讨论。_

最后值得注意的还有使用 `Glide` 库来填充 `imgVw_cat` 的名为 `ImagesURLsDataHolder` 的内部类 (inner class) ，这有助于从调用 API 取得的传递 `URL` 获取图片。这部分包含在 `bindImages(imgURL: String)` 函数中并且由统一文件中的 `onBindViewHolder` 方法调用。

###### Activity

最后同样重要的便是 `Activity`（例如 `MainActivity`）：

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

注意到以下函数：

*   `initRecyclerView()`
*   `connectingToMasterPresenter()`
*   `getURLs()`

分别用于：

*    初始化<mark>主容器</mark>（例如 `RecyclerView`）
*    将 `MasterPresenterImpl` 连接至 `MainActivity` 并传至 `ImagesAdapterImpl`（又称 `Adapter`） 的 `interface`
*    `getURLs()` 启动 API 请求以获取 `XML` 数据，然后执行任务（反序列化数据，通过 `Adapter` 获取图片）。

至此小猫咪应用已经准备就绪。

你可以在我 Github 仓库中找到 [KShow<sup class="readableLinkFootnote"></sup>](https://github.com/cirorizzo/KShows) 完整的项目。

该项目也有 Java 的实现：[JShows<sup class="readableLinkFootnote"></sup>](https://github.com/cirorizzo/JShows)，以便对比。
