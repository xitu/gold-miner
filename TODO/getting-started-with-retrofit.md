> * 原文地址：[Get Started With Retrofit 2 HTTP Client](https://code.tutsplus.com/tutorials/getting-started-with-retrofit-2--cms-27792)
* 原文作者：[Chike Mgbemena](https://tutsplus.com/authors/chike-mgbemena)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Zhiw](https://github.com/Zhiw)
* 校对者：


# Get Started With Retrofit 2 HTTP Client
# 网络请求框架 Retrofit 2 使用详解

![Final product image](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/final_image/gt5.JPG)

What You'll Be Creating

你将要创造什么

## What Is Retrofit?
## Retrofit 是什么？

[Retrofit](https://square.github.io/retrofit/) is a type-safe HTTP client for Android and Java. Retrofit makes it easy to connect to a REST web service by translating the API into Java interfaces. In this tutorial, I'll show you how to use one of most popular and often-recommended HTTP libraries available for Android.

[Retrofit](https://square.github.io/retrofit/) 是一个用于 Android 和 Java 平台的类型安全的网络请求框架。Retrofit 通过将 API 抽象成 Java 接口而让我们连接到 REST web 服务变得很轻松。在这个教程里，我会向你介绍如何使用这个 Android 上最受欢迎和经常推荐的网络请求库之一。


This powerful library makes it easy to consume JSON or XML data which is then parsed into Plain Old Java Objects (POJOs). `GET`, `POST`, `PUT`, `PATCH`, and `DELETE` requests can all be executed.

这个强大的库可以很简单的把返回的 JSON 或者 XML 数据解析成简单 Java 对象（POJOs）。`GET`, `POST`, `PUT`, `PATCH`, 和 `DELETE` 这些请求都可以执行。

Like most open-source software, Retrofit was built on top of some other powerful libraries and tools. Behind the scenes, Retrofit makes use of [OkHttp](http://square.github.io/okhttp/) (from the same developer) to handle network requests. Also, Retrofit does not have a built-in any JSON converter to parse from JSON to Java objects. Instead it ships support for the following JSON converter libraries to handle that:

和大多数开源软件一样，Retrofit 也是建立在一些强大的库和工具基础上的。Retrofit 背后用了同一个开发者的 [OkHttp](http://square.github.io/okhttp/) 来处理网络请求。而且 Retrofit 不再内置 JSON converter 来将 JSON 装换为 Java 对象。取而代之的是提供以下 JSON converter 来处理：

- Gson: `com.squareup.retrofit:converter-gson`
- Jackson: `com.squareup.retrofit:converter-jackson`
- Moshi: `com.squareup.retrofit:converter-moshi`

For [Protocol Buffers](https://developers.google.com/protocol-buffers/), Retrofit supports:

对于 [Protocol Buffers](https://developers.google.com/protocol-buffers/), Retrofit 提供了:

- Protobuf:  `com.squareup.retrofit2:converter-protobuf`

- Wire:  `com.squareup.retrofit2:converter-wire`

And for XML, Retrofit supports:

对于 XML 解析, Retrofit 提供了:

- Simple Framework:  `com.squareup.retrofit2:converter-simpleframework`

## So Why Use Retrofit?

## 那么我们为什么要用 Retrofit 呢？

Developing your own type-safe HTTP library to interface with a REST API can be a real pain: you have to handle many functionalities such as making connections, caching, retrying failed requests, threading, response parsing, error handling, and more. Retrofit, on the other hand, is very well planned, documented, and tested—a battle-tested library that will save you a lot of precious time and headaches.

开发一个自己的用于请求 REST API 的类型安全的网络请求库是一件很痛苦的事情：你需要处理很多功能，比如建立连接，处理缓存，重连接失败请求，线程，响应数据的解析，错误处理等等。从另一方面来说，Retrofit 是一个有优秀的计划，文档和测试并且经过考验的库，它会帮你节省你的宝贵时间以及不让你那么头痛。

In this tutorial, I will explain how to use Retrofit 2 to handle network requests by building a simple app to query recent answers from the [Stack Exchange](https://api.stackexchange.com/docs) API. We'll perform `GET` requests by specifying an endpoint—`/answers`, appended to the base URL [https://api.stackexchange.com/2.2](https://api.stackexchange.com/2.2)/—then get the results and display them in a recycler view. I will also show you how to do this with RxJava for easy management of the flow of state and data.

在这个教程里，我会构建一个简单的应用，根据 [Stack Exchange](https://api.stackexchange.com/docs) API 查询上面最近的回答，从而来教你如何使用 Retrofit 2 来处理网络请求。我们会指明 `/answers` 这样一个路径，然后拼接到 base URL [https://api.stackexchange.com/2.2](https://api.stackexchange.com/2.2)/ 上执行一个 `GET` 请求——然后我们会得到响应结果并且显示到 recycler view 上。我还会向你展示如何利用 RxJava 来轻松地管理状态和数据流。

## 1. Create an Android Studio Project

## 1.创建一个 Android Studio 工程

Fire up Android Studio and create a new project with an empty activity called `MainActivity`.

打开 Android Studio，创建一个新工程，然后创建一个命名为 `MainActivity` 的空白 Activity。
![Create a new empty activity](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/image/a2.png)
## 2. Declaring Dependencies

## 2. 添加依赖

After creating a new project, declare the following dependencies in your `build.gradle`. The dependencies include a recycler view, the Retrofit library, and also Google's Gson library to convert JSON to POJO (Plain Old Java Objects) as well as Retrofit's Gson integration.

创建一个新的工程后，在你的 `build.gradle` 文件里面添加以下依赖。这些依赖包括 recycler view，Retrofit 库，还有 Google 出品的将 JSON 装换为 POJO（简单 Java 对象）的 Gson 库，以及 Retrofit 的 Gson。

    // Retrofit
    compile 'com.squareup.retrofit2:retrofit:2.1.0'

    // JSON Parsing
    compile 'com.google.code.gson:gson:2.6.1'
    compile 'com.squareup.retrofit2:converter-gson:2.1.0'

    // recyclerview
    compile 'com.android.support:recyclerview-v7:25.0.1'


Don't forget to sync the project to download these libraries.

不要忘记同步工程来下载这些库。

## 3. Adding Internet Permission

## 3. 添加网络权限

To perform network operations, we need to include the `INTERNET` permission in the application manifest: **AndroidManifest.xml**.

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

## 4. Generating Models Automatically

## 4.自动生成 Java 对象

We are going to create our models automatically from our JSON response data by leveraging a very useful tool: [jsonschema2pojo](http://www.jsonschema2pojo.org/).

我们利用一个非常有用的工具来帮我们将返回的 JSON 数据自动生成 Java 对象：[jsonschema2pojo](http://www.jsonschema2pojo.org/)。

### Get the Sample JSON Data

### 取得示例的 JSON 数据


Copy and paste [https://api.stackexchange.com/2.2/answers?
order=desc&sort=activity&site=stackoverflow](https://api.stackexchange.com/2.2/answers?order=desc&amp;sort=activity&amp;site=stackoverflow) in your browser's address bar (or you could use [Postman](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop?hl=en) if you are familiar with that tool). Then press **Enter**—this will execute a GET request on the given endpoint. What you will see in response is an array of JSON objects. The screenshot below is the JSON response using Postman.

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

Copy this JSON response either from your browser or Postman.

从你的浏览器或者 Postman 复制 JSON 响应结果。

### Map the JSON Data to Java

### 将 JSON 数据映射到 Java 对象

Now visit  [jsonschema2pojo](http://www.jsonschema2pojo.org/) and paste the JSON response into the input box.

现在访问 [jsonschema2pojo](http://www.jsonschema2pojo.org/)，然后粘贴 JSON 响应结果到输入框。

Select a source type of **JSON**, annotation style of **Gson**, and uncheck **Allow additional properties**.

选择 Source Type 为 **JSON**，Annotation Style 为 **Gson**，然后取消勾选 **Allow additional properties**。

![](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/image/u99.jpg)

Then click the **Preview** button to generate the Java objects.

然后点击 **Preview** 按钮来生成 Java 对象。

![](https://cms-assets.tutsplus.com/uploads/users/769/posts/27792/image/kpo09.jpg)

You might be wondering what the `@SerializedName` and `@Expose` annotations do in this generated code. Don't worry, I'll explain it all!

你可能想知道在生成的代码里面， `@SerializedName` 和 `@Expose` 是干什么的。别着急，我会一一解释的。

The `@SerializedName` annotation is needed for Gson to map the JSON keys with our fields. In keeping with Java's camelCase naming convention for class member properties, it is not recommended to use underscores to separate words in a variable. `@SerializedName` helps translate between the two.

Gson 使用 `@SerializedName` 注解来将 JSON 的 key 映射到我们类的变量。为了与 Java 对类成员属性的驼峰命名方法保持一致，不建议在变量中使用下划线将单词分开。`@SerializeName` 就是作为两者的翻译官。

    @SerializedName("quota_remaining")
    @Expose
    private Integer quotaRemaining;

In the example above, we are telling Gson that our JSON key `quota_remaining` should be mapped to the Java field `quotaRemaining`.  If both of these values were the same, i.e. if our JSON key was `quotaRemaining` just like the Java field, then there would be no need for the `@SerializedName` annotation on the field because Gson would map them automatically.

在上面的示例中，我们告诉 Gson 我们的 JSON 的 key `quota_remaining` 应该被映射到 Java 变量 `quotaRemaining`上。如果两个值是一样的，即如果我们的 JSON 的 key 和 Java 变量一样是 `quotaRemaining`，那么就没有必要为变量设置 `@SerializedName` 注解，Gson 会自己搞定。

The `@Expose` annotation indicates that this member should be exposed for JSON serialization or deserialization.

`@Expose` 注解表明在 JSON 序列化或反序列化的时候，该成员是否暴露给 Gson。

### Import Data Models to Android Studio

### 将数据模型导入 Android Studio

Now let's go back to Android Studio. Create a new sub-package inside the main package and name it **data**. Inside the newly created data package, create another package and name it **model**. Inside the model package, create a new Java class and name it `Owner`. Now copy the `Owner` class that was generated by jsonschema2pojo and paste it inside the `Owner` class you created.

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

Do the same thing for a new `Item` class, copied from jsonschema2pojo.

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

Finally, create a class named `SOAnswersResponse` for the returned StackOverflow answers. You'll find the code for this class in jsonschema2pojo as `Example`. Make sure you update the class name to `SOAnswersResponse` wherever it occurs.

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

## 5. Creating the Retrofit Instance

## 5. 创建 Retrofit 实例

To issue network requests to a REST API with Retrofit, we need to create an instance using the [`Retrofit.Builder`](http://square.github.io/retrofit/2.x/retrofit/retrofit2/Retrofit.Builder.html) class and configure it with a base URL.

为了使用 Retrofit 向 REST API 发送一个网络请求，我们需要用 [`Retrofit.Builder`](http://square.github.io/retrofit/2.x/retrofit/retrofit2/Retrofit.Builder.html) 类来创建一个实例，并且配置一个 base URL。

Create a new sub-package package inside the `data` package and name it `remote`. Now inside `remote`, create a Java class and name it `RetrofitClient`. This class will create a singleton of Retrofit. Retrofit needs a base URL to build its instance, so we will pass a URL when calling `RetrofitClient.getClient(String baseUrl)`. This URL will then be used to build the instance in line 13. We are also specifying the JSON converter we need (Gson) in line 14.

在 `data` 包里面新建一个 `remote` 的包，然后在 `remote` 包里面新建一个 `RetrofitClient` 类。这个类会创建一个 Retrofit 的单例。Retrofit 需要一个 base URL 来创建实例。所以我们在调用 `RetrofitClient.getClient(String baseUrl)` 时会传入一个 URL 参数。参见 13 行，这个 URL 用于构建 Retrofit 的实例。参见14行，我们也需要指明一个我们需要的 JSON converter（Gson）。

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


## 6. Creating the API Interface

## 6.创建 API 接口

Inside the remote package, create an interface and call it `SOService`. This interface contains methods we are going to use to execute HTTP requests such as `GET`, `POST`, `PUT`, `PATCH`, and `DELETE`. For this tutorial, we are going to execute a `GET` request.

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


The `@GET` annotation explicitly defines that `GET` request which will be executed once the method gets called. Every method in this interface must have an HTTP annotation that provides the request method and relative URL. There are five built-in annotations available: `@GET`, `@POST`, `@PUT`, `@DELETE`, and `@HEAD`.

`GET` 注解明确的定义了当该方法调用的时候会执行一个 `GET` 请求。接口里每一个方法都必须有一个 HTTP 注解，用于提供请求方法和相对的 `URL`。Retrofit 内置了5种注解：`@GET`, `@POST`, `@PUT`, `@DELETE`, 和 `@HEAD`。

In the second method definition, we added a query parameter for us to filter the data from the server. Retrofit has the `@Query("key")` annotation to use instead of hard-coding it in the endpoint. The key value represents the parameter name in the URL. It will be added to the URL by Retrofit. For example, if we pass the value `"android"` as an argument to the `getAnswers(String tags)` method, the full URL will be:

在第二个方法定义中，我们添加一个 query 参数用于从服务端过滤数据。Retrofit 提供了 `@Query("key")` 注解，这样就不用在地址里面直接写了。key 的值代表了 URL 里参数的名字。Retrofit 会把他们添加到 URL 里面。比如说，如果我们把 `android` 作为参数传递给 `getAnswers(String tags)` 方法，完整的 URL 将会是：


    https://api.stackexchange.com/2.2/answers?order=desc&sort=activity&site=stackoverflow&tagged=android

Parameters of the interface methods can have the following annotations:

接口方法的参数支持以下注解：

||||
|---|---|---|
|@Path|variable substitution for the API endpoint|
|@Query|specifies the query key name with the value of the annotated parameter|
|@Body|payload for the POST call|
|@Header|specifies the header with the value of the annotated parameter|

||||
|---|---|---|
|@Path|替换 API 地址中的变量|
|@Query|通过注解的名字指明 query 参数的名字|
|@Body|POST 请求的请求体|
|@Header|通过注解的参数值指明 header|

## 7. Creating the API Utils

## 7.创建 API 工具类

Now are going to create a utility class. We'll name it `ApiUtils`. This class will have the base URL as a static variable and also provide the `SOService` interface to our application through the `getSOService()` static method.

现在我们要新建一个工具类。我们命名为 `ApiUtils`。该类设置了一个 base URL 常量，并且通过静态方法 `getSOService()` 为应用提供 `SOService` 接口。

    public class ApiUtils {

        public static final String BASE_URL = "https://api.stackexchange.com/2.2/";

        public static SOService getSOService() {
            return RetrofitClient.getClient(BASE_URL).create(SOService.class);
        }
    }


## 8. Display to a RecyclerView

## 8.显示到 RecyclerView

Since the results will be displayed in a [recycler view](https://code.tutsplus.com/tutorials/getting-started-with-recyclerview-and-cardview-on-android--cms-23465), we need an adapter. The following code snippet shows the `AnswersAdapter` class.

我们需要一个 adapter 来将结果将显示到 [recycler view](https://code.tutsplus.com/tutorials/getting-started-with-recyclerview-and-cardview-on-android--cms-23465) 上面。以下是 `AnswersAdapter` 类的代码片段。

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

## 9. Executing the Request

## 9.执行请求

Inside the `onCreate()` method of the `MainActivity`, we initialize an instance of the `SOService` interface (line 9), the recycler view, and also the adapter. Finally, we call the `loadAnswers()` method.

在 `MainActivity` 的 `onCreate()` 方法内部，我们初始化 `SOService` 的实例（参见第 9 行），recycler view 以及 adapter。最后我们调用 `loadAnswers()` 方法。

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

The `loadAnswers()` method makes a network request by calling `enqueue()`. When the response comes back, Retrofit helps us to parse the JSON response to a list of Java objects. (This is made possible by using `GsonConverter`.)  

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

## 10. Understanding `enqueue()`

## 10. 理解 `enqueue()`

`enqueue()` asynchronously sends the request and notifies your app with a callback when a response comes back. Since this request is asynchronous, Retrofit handles it on a background thread so that the main UI thread isn't blocked or interfered with.

`enqueue()` 会发送一个异步请求，当响应结果返回的时候通过回调通知应用。因为是异步请求，所以 Retrofit 将在后台线程处理，这样就不会让 UI 主线程堵塞或者受到影响。

To use `enqueue()`, you have to implement two callback methods:

要使用 `enqueue()`，你必须实现这两个回调方法：

- `onResponse()`
- `onFailure()`

Only one of these methods will be called in response to a given request.

只有在请求有响应结果的时候才会调用其中一个方法。

- `onResponse()`: invoked for a received HTTP response. This method is called for a response that can be correctly handled even if the server returns an error message. So if you get a status code of 404 or 500, this method will still be called. To get the status code in order for you to handle situations based on them, you can use the method `response.code()`. You can also use the `isSuccessful()` method to find out if the status code is in the range 200-300, indicating success.
- `onFailure()`: invoked when a network exception occurred communicating to the server or when an unexpected exception occurred handling the request or processing the response.

- `onResponse()`：接收到 HTTP 响应时调用。该方法会在响应结果能够被正确地处理的时候调用，即使服务器返回了一个错误信息。所以如果你收到了一个 404 或者 500 的状态码，这个方法还是会调用。为了拿到状态码以便后续的处理，你可以使用 `response.code()` 方法。你也可以使用 `isSuccessful()` 来确定返回的状态码是否在 200-300 范围内，该范围的状态码也表示响应成功。
- `onFailure()`：在与服务器通信的时候发生网络异常或者在处理请求或响应的时候发生异常的时候调用。

To perform a synchronous request, you can use the `execute()` method. Be aware that synchronous methods on the main/UI thread will block any user action. So don't execute synchronous methods on Android's main/UI thread! Instead, run them on a background thread.

要执行同步请求，你可以使用 `execute()` 方法。要注意同步请求在主线程会阻塞用户的任何操作。所以不要在主线程执行同步请求，要在后台线程执行。

## 11. Testing the App

## 11.测试应用

You can now run the app.

现在你可以运行应用了。

![Sample results from StackOverflow](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/image/gt5.JPG)

## 12. RxJava Integration

## 12. 结合 RxJava

If you are a fan of RxJava, you can easily implement Retrofit with RxJava. In Retrofit 1 it was integrated by default, but in Retrofit 2 you need to include some extra dependencies. Retrofit ships with a default adapter for executing `Call` instances. So you can change Retrofit's execution mechanism to include RxJava by including the RxJava `CallAdapter`.

如果你是 RxJava 的粉丝，你可以通过 RxJava 很简单的实现 Retrofit。RxJava 在 Retrofit 1 中是默认整合的，但是在 Retrofit 2 中需要额外添加依赖。Retrofit 附带了一个默认的 adapter 用于执行 `Call()` 实例，所以你可以通过 RxJava 的 `CallAdapter` 来改变 Retrofit 的执行流程。

### **Step 1**

### **第一步**

Add the dependencies.

添加依赖。

    compile 'io.reactivex:rxjava:1.1.6'
    compile 'io.reactivex:rxandroid:1.2.1'
    compile 'com.squareup.retrofit2:adapter-rxjava:2.1.0'

### **Step 2**

### **第二步**

Add the new CallAdapter `RxJavaCallAdapterFactory.create()` when building a Retrofit instance.  

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

### **Step 3**

### **第三步**

When making the requests, our anonymous subscriber responds to the observable's stream which emits events, in our case `SOAnswersResponse`. The `onNext` method is then called when our subscriber receives any event emitted which is then passed to our adapter.

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

Check out [Getting Started With ReactiveX on Android](https://code.tutsplus.com/tutorials/getting-started-with-reactivex-on-android--cms-24387) by Ashraff Hathibelagal to learn more about RxJava and RxAndroid.

查看 Ashraff Hathibelagal 的 [Getting Started With ReactiveX on Android](https://code.tutsplus.com/tutorials/getting-started-with-reactivex-on-android--cms-24387) 以了解更多关于 RxJava 和 RxAndroid 的内容。

## Conclusion

## 总结

In this tutorial, you learned about Retrofit: why you should use it and how. I also explained how to add RxJava integration with Retrofit. In my next post, I'll show you how to perform `POST`, `PUT`, and `DELETE`, how to send `Form-Urlencoded` data, and how to cancel requests.

在该教程里，你已经了解了使用 Retrofit 的原因以及方法。我也解释了如何将 RxJava 结合 Retrofit 使用。在我的下一篇文章中，我将为你展示如何执行 `POST`, `PUT`, 和 `DELETE` 请求，如何发送 `Form-Urlencoded` 数据，以及如何取消请求。

To learn more about Retrofit, do refer to the [official documentation](https://square.github.io/retrofit/2.x/retrofit/). And in the meantime, check out some of our other courses and tutorials on Android app development.

要了解更多关于 Retrofit 的内容，请参考 [official documentation](https://square.github.io/retrofit/2.x/retrofit/)。同时，请查看我们其他一些关于 Android 应用开发的课程和教程。
