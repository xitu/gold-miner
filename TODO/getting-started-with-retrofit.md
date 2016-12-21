> * 原文地址：[Get Started With Retrofit 2 HTTP Client](https://code.tutsplus.com/tutorials/getting-started-with-retrofit-2--cms-27792)
* 原文作者：[Chike Mgbemena](https://tutsplus.com/authors/chike-mgbemena)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


# Get Started With Retrofit 2 HTTP Client

![Final product image](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/final_image/gt5.JPG)

What You'll Be Creating

## What Is Retrofit?

[Retrofit](https://square.github.io/retrofit/) is a type-safe HTTP client for Android and Java. Retrofit makes it easy to connect to a REST web service by translating the API into Java interfaces. In this tutorial, I'll show you how to use one of most popular and often-recommended HTTP libraries available for Android. 

This powerful library makes it easy to consume JSON or XML data which is then parsed into Plain Old Java Objects (POJOs). `GET`, `POST`, `PUT`, `PATCH`, and `DELETE` requests can all be executed. 

Like most open-source software, Retrofit was built on top of some other powerful libraries and tools. Behind the scenes, Retrofit makes use of [OkHttp](http://square.github.io/okhttp/) (from the same developer) to handle network requests. Also, Retrofit does not have a built-in any JSON converter to parse from JSON to Java objects. Instead it ships support for the following JSON converter libraries to handle that: 

- Gson: `com.squareup.retrofit:converter-gson`
- Jackson: `com.squareup.retrofit:converter-jackson`
- Moshi: `com.squareup.retrofit:converter-moshi`

For [Protocol Buffers](https://developers.google.com/protocol-buffers/), Retrofit supports:

- Protobuf:  `com.squareup.retrofit2:converter-protobuf`

- Wire:  `com.squareup.retrofit2:converter-wire`

And for XML, Retrofit supports:

- Simple Framework:  `com.squareup.retrofit2:converter-simpleframework`

## So Why Use Retrofit?

Developing your own type-safe HTTP library to interface with a REST API can be a real pain: you have to handle many functionalities such as making connections, caching, retrying failed requests, threading, response parsing, error handling, and more. Retrofit, on the other hand, is very well planned, documented, and tested—a battle-tested library that will save you a lot of precious time and headaches.

In this tutorial, I will explain how to use Retrofit 2 to handle network requests by building a simple app to query recent answers from the [Stack Exchange](https://api.stackexchange.com/docs) API. We'll perform `GET` requests by specifying an endpoint—`/answers`, appended to the base URL [https://api.stackexchange.com/2.2](https://api.stackexchange.com/2.2)/—then get the results and display them in a recycler view. I will also show you how to do this with RxJava for easy management of the flow of state and data.

## 1. Create an Android Studio Project

Fire up Android Studio and create a new project with an empty activity called `MainActivity`.
![Create a new empty activity](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/image/a2.png)
## 2. Declaring Dependencies

After creating a new project, declare the following dependencies in your `build.gradle`. The dependencies include a recycler view, the Retrofit library, and also Google's Gson library to convert JSON to POJO (Plain Old Java Objects) as well as Retrofit's Gson integration. 

    // Retrofit
    compile 'com.squareup.retrofit2:retrofit:2.1.0'
    
    // JSON Parsing
    compile 'com.google.code.gson:gson:2.6.1'
    compile 'com.squareup.retrofit2:converter-gson:2.1.0'
    
    // recyclerview 
    compile 'com.android.support:recyclerview-v7:25.0.1'
    

Don't forget to sync the project to download these libraries. 

## 3. Adding Internet Permission

To perform network operations, we need to include the `INTERNET` permission in the application manifest: **AndroidManifest.xml**.

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

We are going to create our models automatically from our JSON response data by leveraging a very useful tool: [jsonschema2pojo](http://www.jsonschema2pojo.org/). 

### Get the Sample JSON Data

Copy and paste [https://api.stackexchange.com/2.2/answers?
order=desc&sort=activity&site=stackoverflow](https://api.stackexchange.com/2.2/answers?order=desc&amp;sort=activity&amp;site=stackoverflow) in your browser's address bar (or you could use [Postman](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop?hl=en) if you are familiar with that tool). Then press **Enter**—this will execute a GET request on the given endpoint. What you will see in response is an array of JSON objects. The screenshot below is the JSON response using Postman.

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

### Map the JSON Data to Java

Now visit  [jsonschema2pojo](http://www.jsonschema2pojo.org/) and paste the JSON response into the input box.

Select a source type of **JSON**, annotation style of **Gson**, and uncheck **Allow additional properties**. 

![](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/image/u99.jpg)

Then click the **Preview** button to generate the Java objects. 

![](https://cms-assets.tutsplus.com/uploads/users/769/posts/27792/image/kpo09.jpg)

You might be wondering what the `@SerializedName` and `@Expose` annotations do in this generated code. Don't worry, I'll explain it all!

The `@SerializedName` annotation is needed for Gson to map the JSON keys with our fields. In keeping with Java's camelCase naming convention for class member properties, it is not recommended to use underscores to separate words in a variable. `@SerializedName` helps translate between the two.

    @SerializedName("quota_remaining")
    @Expose
    private Integer quotaRemaining;

In the example above, we are telling Gson that our JSON key `quota_remaining` should be mapped to the Java field `quotaRemaining`.  If both of these values were the same, i.e. if our JSON key was `quotaRemaining` just like the Java field, then there would be no need for the `@SerializedName` annotation on the field because Gson would map them automatically.

The `@Expose` annotation indicates that this member should be exposed for JSON serialization or deserialization. 

### Import Data Models to Android Studio

Now let's go back to Android Studio. Create a new sub-package inside the main package and name it **data**. Inside the newly created data package, create another package and name it **model**. Inside the model package, create a new Java class and name it `Owner`. Now copy the `Owner` class that was generated by jsonschema2pojo and paste it inside the `Owner` class you created. 

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

To issue network requests to a REST API with Retrofit, we need to create an instance using the [`Retrofit.Builder`](http://square.github.io/retrofit/2.x/retrofit/retrofit2/Retrofit.Builder.html) class and configure it with a base URL. 

Create a new sub-package package inside the `data` package and name it `remote`. Now inside `remote`, create a Java class and name it `RetrofitClient`. This class will create a singleton of Retrofit. Retrofit needs a base URL to build its instance, so we will pass a URL when calling `RetrofitClient.getClient(String baseUrl)`. This URL will then be used to build the instance in line 13. We are also specifying the JSON converter we need (Gson) in line 14. 

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

Inside the remote package, create an interface and call it `SOService`. This interface contains methods we are going to use to execute HTTP requests such as `GET`, `POST`, `PUT`, `PATCH`, and `DELETE`. For this tutorial, we are going to execute a `GET` request. 

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

In the second method definition, we added a query parameter for us to filter the data from the server. Retrofit has the `@Query("key")` annotation to use instead of hard-coding it in the endpoint. The key value represents the parameter name in the URL. It will be added to the URL by Retrofit. For example, if we pass the value `"android"` as an argument to the `getAnswers(String tags)` method, the full URL will be:

    https://api.stackexchange.com/2.2/answers?order=desc&sort=activity&site=stackoverflow&tagged=android

Parameters of the interface methods can have the following annotations:

||||
|---|---|---|
|@Path|variable substitution for the API endpoint|
|@Query|specifies the query key name with the value of the annotated parameter|
|@Body|payload for the POST call|
|@Header|specifies the header with the value of the annotated parameter|

## 7. Creating the API Utils

Now are going to create a utility class. We'll name it `ApiUtils`. This class will have the base URL as a static variable and also provide the `SOService` interface to our application through the `getSOService()` static method.

    public class ApiUtils {
    
        public static final String BASE_URL = "https://api.stackexchange.com/2.2/";
    
        public static SOService getSOService() {
            return RetrofitClient.getClient(BASE_URL).create(SOService.class);
        }
    }
    

## 8. Display to a RecyclerView

Since the results will be displayed in a [recycler view](https://code.tutsplus.com/tutorials/getting-started-with-recyclerview-and-cardview-on-android--cms-23465), we need an adapter. The following code snippet shows the `AnswersAdapter` class.

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

Inside the `onCreate()` method of the `MainActivity`, we initialize an instance of the `SOService` interface (line 9), the recycler view, and also the adapter. Finally, we call the `loadAnswers()` method. 

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

`enqueue()` asynchronously sends the request and notifies your app with a callback when a response comes back. Since this request is asynchronous, Retrofit handles it on a background thread so that the main UI thread isn't blocked or interfered with.

To use `enqueue()`, you have to implement two callback methods:

- `onResponse()`
- `onFailure()`

Only one of these methods will be called in response to a given request. 

- `onResponse()`: invoked for a received HTTP response. This method is called for a response that can be correctly handled even if the server returns an error message. So if you get a status code of 404 or 500, this method will still be called. To get the status code in order for you to handle situations based on them, you can use the method `response.code()`. You can also use the `isSuccessful()` method to find out if the status code is in the range 200-300, indicating success.
- `onFailure()`: invoked when a network exception occurred communicating to the server or when an unexpected exception occurred handling the request or processing the response. 

To perform a synchronous request, you can use the `execute()` method. Be aware that synchronous methods on the main/UI thread will block any user action. So don't execute synchronous methods on Android's main/UI thread! Instead, run them on a background thread.

## 11. Testing the App

You can now run the app. 

![Sample results from StackOverflow](https://cms-assets.tutsplus.com/uploads/users/1499/posts/27792/image/gt5.JPG)

## 12. RxJava Integration

If you are a fan of RxJava, you can easily implement Retrofit with RxJava. In Retrofit 1 it was integrated by default, but in Retrofit 2 you need to include some extra dependencies. Retrofit ships with a default adapter for executing `Call` instances. So you can change Retrofit's execution mechanism to include RxJava by including the RxJava `CallAdapter`. 

### **Step 1**

Add the dependencies.

    compile 'io.reactivex:rxjava:1.1.6'
    compile 'io.reactivex:rxandroid:1.2.1'
    compile 'com.squareup.retrofit2:adapter-rxjava:2.1.0'

### **Step 2**

Add the new CallAdapter `RxJavaCallAdapterFactory.create()` when building a Retrofit instance.  

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

When making the requests, our anonymous subscriber responds to the observable's stream which emits events, in our case `SOAnswersResponse`. The `onNext` method is then called when our subscriber receives any event emitted which is then passed to our adapter. 

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

## Conclusion

In this tutorial, you learned about Retrofit: why you should use it and how. I also explained how to add RxJava integration with Retrofit. In my next post, I'll show you how to perform `POST`, `PUT`, and `DELETE`, how to send `Form-Urlencoded` data, and how to cancel requests. 

To learn more about Retrofit, do refer to the [official documentation](https://square.github.io/retrofit/2.x/retrofit/). And in the meantime, check out some of our other courses and tutorials on Android app development.

