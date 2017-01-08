> * 原文地址：[Get Started With Retrofit 2 HTTP Client](https://code.tutsplus.com/tutorials/getting-started-with-retrofit-2--cms-27792)
* 原文作者：[Chike Mgbemena](https://tutsplus.com/authors/chike-mgbemena)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Zhiw](https://github.com/Zhiw)
* 校对者：[PhxNirvana](https://github.com/phxnirvana)，[Draftbk](https://github.com/draftbk)


# 网络请求框架 Retrofit 2 使用入门

![Final product image](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/final_image/gt5.JPG)

你将要创造什么

## Retrofit 是什么？

[Retrofit](https://square.github.io/retrofit/) 是一个用于 Android 和 Java 平台的类型安全的网络请求框架。Retrofit 通过将 API 抽象成 Java 接口而让我们连接到 REST web 服务变得很轻松。在这个教程里，我会向你介绍如何使用这个 Android 上最受欢迎和经常推荐的网络请求库之一。

这个强大的库可以很简单的把返回的 JSON 或者 XML 数据解析成简单 Java 对象（POJO）。`GET`, `POST`, `PUT`, `PATCH`, 和 `DELETE` 这些请求都可以执行。

和大多数开源软件一样，Retrofit 也是建立在一些强大的库和工具基础上的。Retrofit 背后用了同一个开发团队的 [OkHttp](http://square.github.io/okhttp/) 来处理网络请求。而且 Retrofit 不再内置 JSON 转换器来将 JSON 装换为 Java 对象。取而代之的是提供以下 JSON 转换器来处理：

- Gson: `com.squareup.retrofit:converter-gson`
- Jackson: `com.squareup.retrofit:converter-jackson`
- Moshi: `com.squareup.retrofit:converter-moshi`

对于 [Protocol Buffers](https://developers.google.com/protocol-buffers/), Retrofit 提供了:

- Protobuf:  `com.squareup.retrofit2:converter-protobuf`

- Wire:  `com.squareup.retrofit2:converter-wire`

对于 XML 解析, Retrofit 提供了:

- Simple Framework:  `com.squareup.retrofit2:converter-simpleframework`

## 那么我们为什么要用 Retrofit 呢？

开发一个自己的用于请求 REST API 的类型安全的网络请求库是一件很痛苦的事情：你需要处理很多功能，比如建立连接，处理缓存，重连接失败请求，线程，响应数据的解析，错误处理等等。从另一方面来说，Retrofit 是一个有优秀的计划，文档和测试并且经过考验的库，它会帮你节省你的宝贵时间以及不让你那么头痛。

在这个教程里，我会构建一个简单的应用，根据 [Stack Exchange](https://api.stackexchange.com/docs) API 查询上面最近的回答，从而来教你如何使用 Retrofit 2 来处理网络请求。我们会指明 `/answers` 这样一个路径，然后拼接到 base URL [https://api.stackexchange.com/2.2](https://api.stackexchange.com/2.2)/ 上执行一个 `GET` 请求——然后我们会得到响应结果并且显示到 RecyclerView 上。我还会向你展示如何利用 RxJava 来轻松地管理状态和数据流。

## 1.创建一个 Android Studio 工程

打开 Android Studio，创建一个新工程，然后创建一个命名为 `MainActivity` 的空白 Activity。
![Create a new empty activity](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/image/a2.png)

## 2. 添加依赖

创建一个新的工程后，在你的 `build.gradle` 文件里面添加以下依赖。这些依赖包括 RecyclerView，Retrofit 库，还有 Google 出品的将 JSON 装换为 POJO（简单 Java 对象）的 Gson 库，以及 Retrofit 的 Gson。

    // Retrofit
    compile 'com.squareup.retrofit2:retrofit:2.1.0'

    // JSON Parsing
    compile 'com.google.code.gson:gson:2.6.1'
    compile 'com.squareup.retrofit2:converter-gson:2.1.0'

    // recyclerview
    compile 'com.android.support:recyclerview-v7:25.0.1'


不要忘记同步（sync）工程来下载这些库。

## 3. 添加网络权限

要执行网络操作，我们需要在应用的清单文件 **AndroidManifest.xml** 里面声明网络权限。

    <?xml version="1.0" encoding="utf-8"?>
    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
              package="com.chikeandroid.retrofittutorial">

        <uses-permission android:name="android.permission.INTERNET" />

        <application
                android:allowBackup="true"
                android:icon="@mipmap/ic_launcher"
                android:label="@string/app_name"
                android:supportsRtl="true"
                android:theme="@style/AppTheme">
            <activity android:name=".MainActivity">
                <intent-filter>
                    <action android:name="android.intent.action.MAIN"/>

                    <category android:name="android.intent.category.LAUNCHER"/>
                </intent-filter>
            </activity>
        </application>

    </manifest>


## 4.自动生成 Java 对象

我们利用一个非常有用的工具来帮我们将返回的 JSON 数据自动生成 Java 对象：[jsonschema2pojo](http://www.jsonschema2pojo.org/)。

### 取得示例的 JSON 数据

复制粘贴 [https://api.stackexchange.com/2.2/answers?order=desc&sort=activity&site=stackoverflow](https://api.stackexchange.com/2.2/answers?order=desc&sort=activity&site=stackoverflow) 到你的浏览器地址栏，或者如果你熟悉的话，你可以使用 [Postman](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop?hl=en) 这个工具。然后点击 **Enter** —— 它将会根据那个地址执行一个 GET 请求，你会看到返回的是一个 JSON 对象数组，下面的截图是使用了 Postman 的 JSON 响应结果。

![API response to GET request](https://cms-assets.tutsplus.com/uploads/users/769/posts/27792/image/1.jpg)

```
   {
      "items": [
        {
          "owner": {
            "reputation": 1,
            "user_id": 6540831,
            "user_type": "registered",
            "profile_image": "https://www.gravatar.com/avatar/6a468ce8a8ff42c17923a6009ab77723?s=128&d=identicon&r=PG&f=1",
            "display_name": "bobolafrite",
            "link": "http://stackoverflow.com/users/6540831/bobolafrite"
          },
          "is_accepted": false,
          "score": 0,
          "last_activity_date": 1480862271,
          "creation_date": 1480862271,
          "answer_id": 40959732,
          "question_id": 35931342
        },
        {
          "owner": {
            "reputation": 629,
            "user_id": 3054722,
            "user_type": "registered",
            "profile_image": "https://www.gravatar.com/avatar/0cf65651ae9a3ba2858ef0d0a7dbf900?s=128&d=identicon&r=PG&f=1",
            "display_name": "jeremy-denis",
            "link": "http://stackoverflow.com/users/3054722/jeremy-denis"
          },
          "is_accepted": false,
          "score": 0,
          "last_activity_date": 1480862260,
          "creation_date": 1480862260,
          "answer_id": 40959731,
          "question_id": 40959661
        },
        ...
      ],
      "has_more": true,
      "backoff": 10,
      "quota_max": 300,
      "quota_remaining": 241
    }
```

从你的浏览器或者 Postman 复制 JSON 响应结果。

### 将 JSON 数据映射到 Java 对象


现在访问 [jsonschema2pojo](http://www.jsonschema2pojo.org/)，然后粘贴 JSON 响应结果到输入框。

选择 Source Type 为 **JSON**，Annotation Style 为 **Gson**，然后取消勾选 **Allow additional properties**。

![](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/image/u99.jpg)


然后点击 **Preview** 按钮来生成 Java 对象。

![](https://cms-assets.tutsplus.com/uploads/users/769/posts/27792/image/kpo09.jpg)

你可能想知道在生成的代码里面， `@SerializedName` 和 `@Expose` 是干什么的。别着急，我会一一解释的。

Gson 使用 `@SerializedName` 注解来将 JSON 的 key 映射到我们类的变量。为了与 Java 对类成员属性的驼峰命名方法保持一致，不建议在变量中使用下划线将单词分开。`@SerializeName` 就是两者的翻译官。

    @SerializedName("quota_remaining")
    @Expose
    private Integer quotaRemaining;


在上面的示例中，我们告诉 Gson 我们的 JSON 的 key `quota_remaining` 应该被映射到 Java 变量 `quotaRemaining`上。如果两个值是一样的，即如果我们的 JSON 的 key 和 Java 变量一样是 `quotaRemaining`，那么就没有必要为变量设置 `@SerializedName` 注解，Gson 会自己搞定。

`@Expose` 注解表明在 JSON 序列化或反序列化的时候，该成员应该暴露给 Gson。

### 将数据模型导入 Android Studio

现在让我们回到 Android Studio。新建一个 **data** 的子包，在 data 里面再新建一个 **model** 的包。在 model 包里面，新建一个 Owner 的 Java 类。
然后将 jsonschema2pojo 生成的 `Owner` 类复制粘贴到刚才新建的 `Owner` 类文件里面。

    import com.google.gson.annotations.Expose;
    import com.google.gson.annotations.SerializedName;

    public class Owner {

        @SerializedName("reputation")
        @Expose
        private Integer reputation;
        @SerializedName("user_id")
        @Expose
        private Integer userId;
        @SerializedName("user_type")
        @Expose
        private String userType;
        @SerializedName("profile_image")
        @Expose
        private String profileImage;
        @SerializedName("display_name")
        @Expose
        private String displayName;
        @SerializedName("link")
        @Expose
        private String link;
        @SerializedName("accept_rate")
        @Expose
        private Integer acceptRate;


        public Integer getReputation() {
            return reputation;
        }

        public void setReputation(Integer reputation) {
            this.reputation = reputation;
        }

        public Integer getUserId() {
            return userId;
        }

        public void setUserId(Integer userId) {
            this.userId = userId;
        }

        public String getUserType() {
            return userType;
        }

        public void setUserType(String userType) {
            this.userType = userType;
        }

        public String getProfileImage() {
            return profileImage;
        }

        public void setProfileImage(String profileImage) {
            this.profileImage = profileImage;
        }

        public String getDisplayName() {
            return displayName;
        }

        public void setDisplayName(String displayName) {
            this.displayName = displayName;
        }

        public String getLink() {
            return link;
        }

        public void setLink(String link) {
            this.link = link;
        }

        public Integer getAcceptRate() {
            return acceptRate;
        }

        public void setAcceptRate(Integer acceptRate) {
            this.acceptRate = acceptRate;
        }
    }


利用同样的方法从 jsonschema2pojo 复制过来，新建一个 `Item` 类。

    import com.google.gson.annotations.Expose;
    import com.google.gson.annotations.SerializedName;

    public class Item {

        @SerializedName("owner")
        @Expose
        private Owner owner;
        @SerializedName("is_accepted")
        @Expose
        private Boolean isAccepted;
        @SerializedName("score")
        @Expose
        private Integer score;
        @SerializedName("last_activity_date")
        @Expose
        private Integer lastActivityDate;
        @SerializedName("creation_date")
        @Expose
        private Integer creationDate;
        @SerializedName("answer_id")
        @Expose
        private Integer answerId;
        @SerializedName("question_id")
        @Expose
        private Integer questionId;
        @SerializedName("last_edit_date")
        @Expose
        private Integer lastEditDate;

        public Owner getOwner() {
            return owner;
        }

        public void setOwner(Owner owner) {
            this.owner = owner;
        }

        public Boolean getIsAccepted() {
            return isAccepted;
        }

        public void setIsAccepted(Boolean isAccepted) {
            this.isAccepted = isAccepted;
        }

        public Integer getScore() {
            return score;
        }

        public void setScore(Integer score) {
            this.score = score;
        }

        public Integer getLastActivityDate() {
            return lastActivityDate;
        }

        public void setLastActivityDate(Integer lastActivityDate) {
            this.lastActivityDate = lastActivityDate;
        }

        public Integer getCreationDate() {
            return creationDate;
        }

        public void setCreationDate(Integer creationDate) {
            this.creationDate = creationDate;
        }

        public Integer getAnswerId() {
            return answerId;
        }

        public void setAnswerId(Integer answerId) {
            this.answerId = answerId;
        }

        public Integer getQuestionId() {
            return questionId;
        }

        public void setQuestionId(Integer questionId) {
            this.questionId = questionId;
        }

        public Integer getLastEditDate() {
            return lastEditDate;
        }

        public void setLastEditDate(Integer lastEditDate) {
            this.lastEditDate = lastEditDate;
        }
    }


最后，为返回的 StackOverflow 回答新建一个 `SOAnswersResponse` 类。注意在 jsonschema2pojo 里面类名是 `Example`，别忘记把类名改成 `SOAnswersResponse`。

    import com.google.gson.annotations.Expose;
    import com.google.gson.annotations.SerializedName;

    import java.util.List;

    public class SOAnswersResponse {

        @SerializedName("items")
        @Expose
        private List<Item> items = null;
        @SerializedName("has_more")
        @Expose
        private Boolean hasMore;
        @SerializedName("backoff")
        @Expose
        private Integer backoff;
        @SerializedName("quota_max")
        @Expose
        private Integer quotaMax;
        @SerializedName("quota_remaining")
        @Expose
        private Integer quotaRemaining;

        public List<Item> getItems() {
            return items;
        }

        public void setItems(List<Item> items) {
            this.items = items;
        }

        public Boolean getHasMore() {
            return hasMore;
        }

        public void setHasMore(Boolean hasMore) {
            this.hasMore = hasMore;
        }

        public Integer getBackoff() {
            return backoff;
        }

        public void setBackoff(Integer backoff) {
            this.backoff = backoff;
        }

        public Integer getQuotaMax() {
            return quotaMax;
        }

        public void setQuotaMax(Integer quotaMax) {
            this.quotaMax = quotaMax;
        }

        public Integer getQuotaRemaining() {
            return quotaRemaining;
        }

        public void setQuotaRemaining(Integer quotaRemaining) {
            this.quotaRemaining = quotaRemaining;
        }
    }


## 5. 创建 Retrofit 实例

为了使用 Retrofit 向 REST API 发送一个网络请求，我们需要用 [`Retrofit.Builder`](http://square.github.io/retrofit/2.x/retrofit/retrofit2/Retrofit.Builder.html) 类来创建一个实例，并且配置一个 base URL。


在 `data` 包里面新建一个 `remote` 的包，然后在 `remote` 包里面新建一个 `RetrofitClient` 类。这个类会创建一个 Retrofit 的单例。Retrofit 需要一个 base URL 来创建实例。所以我们在调用 `RetrofitClient.getClient(String baseUrl)` 时会传入一个 URL 参数。参见 13 行，这个 URL 用于构建 Retrofit 的实例。参见 14 行，我们也需要指明一个我们需要的 JSON converter（Gson）。

    import retrofit2.Retrofit;
    import retrofit2.converter.gson.GsonConverterFactory;

    public class RetrofitClient {

        private static Retrofit retrofit = null;

        public static Retrofit getClient(String baseUrl) {
            if (retrofit==null) {
                retrofit = new Retrofit.Builder()
                        .baseUrl(baseUrl)
                        .addConverterFactory(GsonConverterFactory.create())
                        .build();
            }
            return retrofit;
        }
    }


## 6.创建 API 接口

在 remote 包里面，创建一个 `SOService` 接口，这个接口包含了我们将会用到用于执行网络请求的方法，比如 `GET`, `POST`, `PUT`, `PATCH`, 以及 `DELETE`。在该教程里面，我们将执行一个 `GET` 请求。

    import com.chikeandroid.retrofittutorial.data.model.SOAnswersResponse;

    import java.util.List;

    import retrofit2.Call;
    import retrofit2.http.GET;

    public interface SOService {

       @GET("/answers?order=desc&sort=activity&site=stackoverflow")
       Call<List<SOAnswersResponse>> getAnswers();

       @GET("/answers?order=desc&sort=activity&site=stackoverflow")
       Call<List<SOAnswersResponse>> getAnswers(@Query("tagged") String tags);
    }


`GET` 注解明确的定义了当该方法调用的时候会执行一个 `GET` 请求。接口里每一个方法都必须有一个 HTTP 注解，用于提供请求方法和相对的 `URL`。Retrofit 内置了 5 种注解：`@GET`, `@POST`, `@PUT`, `@DELETE`, 和 `@HEAD`。

在第二个方法定义中，我们添加一个 query 参数用于从服务端过滤数据。Retrofit 提供了 `@Query("key")` 注解，这样就不用在地址里面直接写了。key 的值代表了 URL 里参数的名字。Retrofit 会把他们添加到 URL 里面。比如说，如果我们把 `android` 作为参数传递给 `getAnswers(String tags)` 方法，完整的 URL 将会是：


    https://api.stackexchange.com/2.2/answers?order=desc&sort=activity&site=stackoverflow&tagged=android

接口方法的参数有以下注解：

||||
|---|---|---|
|@Path|替换 API 地址中的变量|
|@Query|通过注解的名字指明 query 参数的名字|
|@Body|POST 请求的请求体|
|@Header|通过注解的参数值指明 header|


## 7.创建 API 工具类

现在我们要新建一个工具类。我们命名为 `ApiUtils`。该类设置了一个 base URL 常量，并且通过静态方法 `getSOService()` 为应用提供 `SOService` 接口。

    public class ApiUtils {

        public static final String BASE_URL = "https://api.stackexchange.com/2.2/";

        public static SOService getSOService() {
            return RetrofitClient.getClient(BASE_URL).create(SOService.class);
        }
    }


## 8.显示到 RecyclerView

既然结果要显示到 [RecyclerView](https://code.tutsplus.com/tutorials/getting-started-with-recyclerview-and-cardview-on-android--cms-23465) 上面，我们需要一个 adpter。以下是 `AnswersAdapter` 类的代码片段。

    public class AnswersAdapter extends RecyclerView.Adapter<AnswersAdapter.ViewHolder> {

        private List<Item> mItems;
        private Context mContext;
        private PostItemListener mItemListener;

        public class ViewHolder extends RecyclerView.ViewHolder implements View.OnClickListener{

            public TextView titleTv;
            PostItemListener mItemListener;

            public ViewHolder(View itemView, PostItemListener postItemListener) {
                super(itemView);
                titleTv = (TextView) itemView.findViewById(android.R.id.text1);

                this.mItemListener = postItemListener;
                itemView.setOnClickListener(this);
            }

            @Override
            public void onClick(View view) {
                Item item = getItem(getAdapterPosition());
                this.mItemListener.onPostClick(item.getAnswerId());

                notifyDataSetChanged();
            }
        }

        public AnswersAdapter(Context context, List<Item> posts, PostItemListener itemListener) {
            mItems = posts;
            mContext = context;
            mItemListener = itemListener;
        }

        @Override
        public AnswersAdapter.ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {

            Context context = parent.getContext();
            LayoutInflater inflater = LayoutInflater.from(context);

            View postView = inflater.inflate(android.R.layout.simple_list_item_1, parent, false);

            ViewHolder viewHolder = new ViewHolder(postView, this.mItemListener);
            return viewHolder;
        }

        @Override
        public void onBindViewHolder(AnswersAdapter.ViewHolder holder, int position) {

            Item item = mItems.get(position);
            TextView textView = holder.titleTv;
            textView.setText(item.getOwner().getDisplayName());
        }

        @Override
        public int getItemCount() {
            return mItems.size();
        }

        public void updateAnswers(List<Item> items) {
            mItems = items;
            notifyDataSetChanged();
        }

        private Item getItem(int adapterPosition) {
            return mItems.get(adapterPosition);
        }

        public interface PostItemListener {
            void onPostClick(long id);
        }
    }

## 9.执行请求

在 `MainActivity` 的 `onCreate()` 方法内部，我们初始化 `SOService` 的实例（参见第 9 行），RecyclerView 以及 adapter。最后我们调用 `loadAnswers()` 方法。

     private AnswersAdapter mAdapter;
        private RecyclerView mRecyclerView;
        private SOService mService;

        @Override
        protected void onCreate (Bundle savedInstanceState)  {
            super.onCreate( savedInstanceState );
            setContentView(R.layout.activity_main );
            mService = ApiUtils.getSOService();
            mRecyclerView = (RecyclerView) findViewById(R.id.rv_answers);
            mAdapter = new AnswersAdapter(this, new ArrayList<Item>(0), new AnswersAdapter.PostItemListener() {

                @Override
                public void onPostClick(long id) {
                    Toast.makeText(MainActivity.this, "Post id is" + id, Toast.LENGTH_SHORT).show();
                }
            });

            RecyclerView.LayoutManager layoutManager = new LinearLayoutManager(this);
            mRecyclerView.setLayoutManager(layoutManager);
            mRecyclerView.setAdapter(mAdapter);
            mRecyclerView.setHasFixedSize(true);
            RecyclerView.ItemDecoration itemDecoration = new DividerItemDecoration(this, DividerItemDecoration.VERTICAL_LIST);
            mRecyclerView.addItemDecoration(itemDecoration);

            loadAnswers();
        }
  

`loadAnswers()` 方法通过调用 `enqueue()` 方法来进行网络请求。当响应结果返回的时候，Retrofit 会帮我们把 JSON 数据解析成一个包含 Java 对象的 list（这是通过 `GsonConverter` 实现的）。

    public void loadAnswers() {
        mService.getAnswers().enqueue(new Callback<SOAnswersResponse>() {
        @Override
        public void onResponse(Call<SOAnswersResponse> call, Response<SOAnswersResponse> response) {

            if(response.isSuccessful()) {
                mAdapter.updateAnswers(response.body().getItems());
                Log.d("MainActivity", "posts loaded from API");
            }else {
                int statusCode  = response.code();
                // handle request errors depending on status code
            }
        }

        @Override
        public void onFailure(Call<SOAnswersResponse> call, Throwable t) {
           showErrorMessage();
            Log.d("MainActivity", "error loading from API");

        }
    });
    }

## 10. 理解 `enqueue()`

`enqueue()` 会发送一个异步请求，当响应结果返回的时候通过回调通知应用。因为是异步请求，所以 Retrofit 将在后台线程处理，这样就不会让 UI 主线程堵塞或者受到影响。

要使用 `enqueue()`，你必须实现这两个回调方法：

- `onResponse()`
- `onFailure()`

只有在请求有响应结果的时候才会调用其中一个方法。

- `onResponse()`：接收到 HTTP 响应时调用。该方法会在响应结果能够被正确地处理的时候调用，即使服务器返回了一个错误信息。所以如果你收到了一个 404 或者 500 的状态码，这个方法还是会调用。为了拿到状态码以便后续的处理，你可以使用 `response.code()` 方法。你也可以使用 `isSuccessful()` 来确定返回的状态码是否在 200-300 范围内，该范围的状态码也表示响应成功。
- `onFailure()`：在与服务器通信的时候发生网络异常或者在处理请求或响应的时候发生异常的时候调用。

要执行同步请求，你可以使用 `execute()` 方法。要注意同步请求在主线程会阻塞用户的任何操作。所以不要在主线程执行同步请求，要在后台线程执行。

## 11.测试应用

现在你可以运行应用了。

![Sample results from StackOverflow](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/image/gt5.JPG)

## 12. 结合 RxJava

如果你是 RxJava 的粉丝，你可以通过 RxJava 很简单的实现 Retrofit。RxJava 在 Retrofit 1 中是默认整合的，但是在 Retrofit 2 中需要额外添加依赖。Retrofit 附带了一个默认的 adapter 用于执行 `Call` 实例，所以你可以通过 RxJava 的 `CallAdapter` 来改变 Retrofit 的执行流程。

### **第一步**

添加依赖。

    compile 'io.reactivex:rxjava:1.1.6'
    compile 'io.reactivex:rxandroid:1.2.1'
    compile 'com.squareup.retrofit2:adapter-rxjava:2.1.0'

### **第二步**

在创建新的 Retrofit 实例的时候添加一个新的 CallAdapter `RxJavaCallAdapterFactory.create()`。

    public static Retrofit getClient(String baseUrl) {
        if (retrofit==null) {
            retrofit = new Retrofit.Builder()
                    .baseUrl(baseUrl)
                    .addCallAdapterFactory(RxJavaCallAdapterFactory.create())
                    .addConverterFactory(GsonConverterFactory.create())
                    .build();
        }
        return retrofit;
    }


### **第三步**

当我们执行请求时，我们的匿名 subscriber 会响应 observable 发射的事件流，在本例中，就是 `SOAnswersResponse`。当 subscriber 收到任何发射事件的时候，就会调用 `onNext()` 方法，然后传递到我们的 adapter。

    @Override
    public void loadAnswers() {
        mService.getAnswers().subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread())
                .subscribe(new Subscriber<SOAnswersResponse>() {
                    @Override
                    public void onCompleted() {

                    }

                    @Override
                    public void onError(Throwable e) {

                    }

                    @Override
                    public void onNext(SOAnswersResponse soAnswersResponse) {
                        mAdapter.updateAnswers(soAnswersResponse.getItems());
                    }
                });
    }


查看 Ashraff Hathibelagal 的 [Getting Started With ReactiveX on Android](https://code.tutsplus.com/tutorials/getting-started-with-reactivex-on-android--cms-24387) 以了解更多关于 RxJava 和 RxAndroid 的内容。

## 总结

在该教程里，你已经了解了使用 Retrofit 的理由以及方法。我也解释了如何将 RxJava 结合 Retrofit 使用。在我的下一篇文章中，我将为你展示如何执行 `POST`, `PUT`, 和 `DELETE` 请求，如何发送 `Form-Urlencoded` 数据，以及如何取消请求。

要了解更多关于 Retrofit 的内容，请参考 [官方文档](https://square.github.io/retrofit/2.x/retrofit/)。同时，请查看我们其他一些关于 Android 应用开发的课程和教程。
