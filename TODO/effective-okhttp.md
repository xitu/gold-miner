> * 原文链接: [Effective OkHttp](http://omgitsmgp.com/2015/12/02/effective-okhttp/)
* 原文作者 : [Michael Parker](http://omgitsmgp.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者: 
* 状态 :  待定

[OkHttp](http://square.github.io/okhttp/) was an invaluable library when developing the [Android app](https://play.google.com/store/apps/details?id=org.khanacademy.android) for [Khan Academy](https://www.khanacademy.org/). While its default configuration offers significant utility, below are some steps we took for increasing the resourcefulness and introspective power of OkHttp:
OkHttp是一个在开发可汗学院Android APP过程中非常重要的依赖库。它的默认的配置为我们提供了非常重要实用功能，下面一些步骤我们可以让Okhttp提供更多功能使用灵活和内省能力。

### 1\. Enable response caching on the filesystem
1. 启用文件系统上的响应缓存

By default, OkHttp does not cache responses that permit caching by including such a HTTP `Cache-Control` header. Therefore your client may be wasting time and bandwidth by requesting the same resource again and again, as opposed to simply reading a cached copy after the initial response.
默认情况下，Okhttp不支持响应缓存，包括HTTP Cache-Control头允许缓存响应。因此，客户端通过一次又一次的请求相同的资源浪费时间和带宽。而不是简单地读取初始响应后缓存的副本。
To enable caching of responses on the filesystem, configure a `com.squareup.okhttp.Cache` instance and pass it to the `setCache` method of your `OkHttpClient` instance. You must instantiate the `Cache` with a `File` representing a directory, and a maximum size in bytes. Responses that can be cached are written to the given directory. If the caching of a response causes the directory contents to exceed the given size, responses are evicted while adhering to a [LRU policy](https://en.wikipedia.org/wiki/Cache_algorithms#LRU).
要在文件系统中启用响应缓存，需要配置com.squareup.okhttp.Cache实例，并把它传递给你的OkHttpClient实例的setCache方法。你必须初始化缓存与存放目录的文件，并以字节为单位的最大值。

响应返回数据可以写入给定目录文件，如果一个响应的缓存超过了给定的大小。我们可以采取LRU policy。


As [recommended by Jesse Wilson](http://stackoverflow.com/a/32752861/400717), we cache responses in a subdirectory of `context.getCacheDir()`:
我们可以在stackoverflow查看Jesse Wilson的回复。我们可以通过context.getCacheDir()在子目录中缓存我们的响应：

```java
// Base directory recommended by http://stackoverflow.com/a/32752861/400717.
// Guard against null, which is possible according to
// https://groups.google.com/d/msg/android-developers/-694j87eXVU/YYs4b6kextwJ and
// http://stackoverflow.com/q/4441849/400717.
final @Nullable File baseDir = context.getCacheDir();
if (baseDir != null) {
  final File cacheDir = new File(baseDir, "HttpResponseCache");
  okHttpClient.setCache(new Cache(cacheDir, HTTP_RESPONSE_DISK_CACHE_MAX_SIZE));
}
```

In the Khan Academy application, we specify `HTTP_RESPONSE_DISK_CACHE_MAX_SIZE` as `10 * 1024 * 1024`, or 10 MB.
在可汗学院的程序中我们指定 HTTP_RESPONSE_DISK_CACHE_MAX_SIZE as 10 * 1024 * 1024, or 10 MB的大小

### 2\. Integrate with Stetho
2. 集成Stetho
[Stetho](http://facebook.github.io/stetho/) is a lovely library by Facebook that allows you to inspect your Android application using the [Chrome Developer Tools](https://developers.google.com/web/tools/setup/workspace/setup-devtools) feature of Chrome.
Stetho是Facebook的一个可爱的库，可以使用Chrome浏览器的Chrome开发人员工具功能来检查你的Andr​​oid应用程序。
In addition to allowing you to inspect the SQLite databases and view hierarchies of your application, Stetho allows you to inspect each request and response made by OkHttp:
Stetho除了允许你检查你的应用程序的SQLite数据库，还可以查看View的层次结构。允许你检查由OkHttp发起的每个请求和响应：
![Image of Stetho](http://omgitsmgp.com/assets/images/posts/stetho-inspector-network.png)

This introspection is very useful for ensuring that the server is returning the HTTP headers that permit caching of resources, as well as verifying that no requests are made when cached resources should exist.
To enable Stetho, simply add a `StethoInterceptor` instance to the list of network interceptors:
这种自省机制是确保服务器返回允许资源缓存的HTTP头是非常有用的，以及验证没有请求时，保证缓存的资源存在。
要想使用Stetho，只需添加一个StethoInterceptor实例的网络拦截器列表：

```java
okHttpClient.networkInterceptors().add(new StethoInterceptor());
```


Then, after running your application, open Chrome and navigate to `chrome://inspect`. The device and application identifier of the application should be listed. Visit its “inspect” link to open the Developer Tools, and then open the Network tab to begin monitoring requests by OkHttp.
然后，运行应用程序，打开浏览器后，输入chrome://inspect。然后你就会看到应用程序的设备和标识符的列表。然后鼠标右键选择inspect 打开开发者工具，然后打开新的tab，开始监控OkHttp请求。
### 3\. Use your client with Picasso and Retrofit
3. 使用Picasso 和 Retrofit
If you are like us, you might use [Picasso](http://square.github.io/picasso/) to load images over the network, or use [Retrofit](http://square.github.io/retrofit/) to simplify issuing requests and decoding responses. By default, these libraries will implicitly create their own `OkHttpClient` for internal use if you do not explicitly specify one. From the `OkHttpDownloader` class of version 2.5.2 of Picasso:
你可能使用过Picasso来加载网络图片，或者使用Retrofit来简化发出请求和解码响应。这些第三方库将隐式地创建自己的OkHttpClient供内部使用，如果你不明确指定一个。

Picasso version 2.5.2的OkHttpDownloader类：

```java
private static OkHttpClient defaultOkHttpClient() {
  OkHttpClient client = new OkHttpClient();
  client.setConnectTimeout(Utils.DEFAULT_CONNECT_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS);
  client.setReadTimeout(Utils.DEFAULT_READ_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS);
  client.setWriteTimeout(Utils.DEFAULT_WRITE_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS);
  return client;
}
```


Retrofit has a similar factory method for creating its own `OkHttpClient`.

Images are some of the largest resources that your application will load. While Picasso maintains its own LRU cache for images, it is strictly in-memory. If the client attempts to load an image using Picasso, and Picasso does not find that image in its in-memory cache, then it will delegate loading that image to its internal `OkHttpClient` instance. And by default that instance will always load the image from the server, as the `defaultOkHttpClient` method above does not configure it with a response cache on the filesystem.


Specifying your own `OkHttpClient` instance allows for returning a cached response from the filesystem. No image is loaded from the server. This is especially important after the app is first launched. At this time Picasso’s in-memory cache is [cold](http://stackoverflow.com/a/22756972/400717), and so it will delegate loading images to the `OkHttpClient` instance frequently.

This requires building a `Picasso` instance that is configured with your `OkHttpClient`. If you are loading images by using `Picasso.with(context).load(...)` in your code, then you are using the `Picasso` singleton instance, which is lazily instantiated and configured with its own `OkHttpClient` by method `with`. Therefore we must assign our own `Picasso` instance as the singleton before the first call to `with`.

To do this, simply wrap the `OkHttpClient` instance in an `OkHttpDownloader`, and pass that to the `downloader` method of your `Picasso.Builder` instance:
Retrofit也有类似的工厂方法来创建自己的OkHttpClient。
图片一般在应用程序中需要加载的比较大的资源。尽管Picasso自己维护它的LRU机制来缓存图片，在内存中严格执行。如果客户端尝试使用Picasso来加载图片。Picasso会找不到其在内存中缓存图像，然后将委托加载该图片到它的内部OkHttpClient实例。并且默认情况下该实例将始终从服务器加载图片资源。
作为defaultOkHttpClient的方法不能与上面提到的文件系统中的响应缓存配置结合起来。
指定你自己的OkHttpClient实例允许返回数据从文件系统缓存响应，图片不会从服务器加载。这是非常重要的在程序第一次启动以后。这个时候Picasso的内存缓存是冷的。所以它会频繁的委托OkHttpClient实例去加载图片。
这就需要构建配置了您Picasso 的OkHttpClient实例，如果你在你的代码中使用Picasso.with(context).load(...)
加载图片，你是用的是Picasso的单例模式。这是通过with方法懒汉模式地实例化并配置自己的OkHttpClient。因此，我们必须使我们自己的Picasso实例在单例之前通过wiht方法调用。
实现这个，可以简单的将OkHttpClient实例封装在OkHttpDownloader中，然后传递给Picasso.Builder 实例的downloader方法。


```java
final Picasso picasso = new Picasso.Builder(context)
    .downloader(new OkHttpDownloader(okHttpClient))
    .build();

// The client should inject this instance whenever it is needed, but replace the singleton
// instance just in case.
Picasso.setSingletonInstance(picasso);
```


To use your `OkHttpClient` instance with a `RestAdapter` in Retrofit 1.9.x, wrap the `OkHttpClient` in an `OkClient` instance, and pass that to the `setClient` method of your `RestAdapter.Builder` instance:
在Retrofit中要使用OkHttpClient实例，需要改造1.9.x的一个RestAdapter，需要将OkHttpClient封装OkClient的实例中。然后把它传递给RestAdapter.Builder实例的setClient方法。


    restAdapterBuilder.setClient(new OkClient(httpClient));



In Retrofit 2.0, simply pass the `OkHttpClient` instance to the `client` method of your `Retrofit.Builder` instance.

In the Khan Academy application, we leverage [Dagger](http://google.github.io/dagger/) to ensure that we have only one `OkHttpClient` instance, and that it is used by both Picasso and Retrofit. We create a provider for the `OkHttpClient` instance with the `@Singleton` annotation:
在 Retrofit 2.0中只需要简单的将OkHttpClient传递给Retrofit.Builder实例的client方法。

在可汗学院的APP中我们通过Dagger依赖注入来确保我们只有一个OkHttpClient的实例。这种方法同样也适用于Picasso和Retrofit我们提供了一个为OkHttpClient实例提供单例模式的注解示例：

```java
@Provides
@Singleton
public OkHttpClient okHttpClient(final Context context, ...) {
  final OkHttpClient okHttpClient = new OkHttpClient();
  configureClient(okHttpClient, ...);
  return okHttpClient;
}
```


This `OkHttpClient` is then injected with Dagger into the other providers that create our `RestAdapter` and `Picasso` instances.
OkHttpClient将会通过Dagger的注解创建一个实例提供给我们的Picasso和Retrofit。

### 4\. Specify a user agent interceptor
4.指定一个用户代理拦截器
Log files and analytics are much more informative when clients provide a detailed `User-Agent` header value in every request. By default, OkHttp includes a `User-Agent` value that specifies only the version of OkHttp. To specify your own user agent, first create an interceptor that replaces the value, [following this suggestion on StackOverflow](http://stackoverflow.com/a/27840834/400717):

日志文件和分析为我们提供了更多有用的信息，当客户在每个请求提供详细的User-Agent header值的时候。默认情况下，Okhttp包含User-Agent值只有在特定的Okhttp版本中。为了指定我们自己的user agent。首先创建拦截器的替换值，我们可以看stackoverflow的建议。
```java
public final class UserAgentInterceptor implements Interceptor {
  private static final String USER_AGENT_HEADER_NAME = "User-Agent";
  private final String userAgentHeaderValue;

  public UserAgentInterceptor(String userAgentHeaderValue) {
    this.userAgentHeaderValue = Preconditions.checkNotNull(userAgentHeaderValue);
  }

  @Override
  public Response intercept(Chain chain) throws IOException {
    final Request originalRequest = chain.request();
    final Request requestWithUserAgent = originalRequest.newBuilder()
        .removeHeader(USER_AGENT_HEADER_NAME)
        .addHeader(USER_AGENT_HEADER_NAME, userAgentHeaderValue)
        .build();
    return chain.proceed(requestWithUserAgent);
  }
}
```


To construct the `User-Agent` header value that is passed into the constructor of `UserAgentInterceptor`, use whatever values you would find informative. We use:

*   an `os` value of `Android` to clearly communicate that this is an Android device
*   `Build.MODEL`, or the “end-user-visible name for the end product”
*   `Build.BRAND`, or the “consumer-visible brand with which the product/hardware will be associated”
*   `Build.VERSION.SDK_INT`, or the “user-visible SDK version of the [Android] framework”
*   `BuildConfig.APPLICATION_ID`
*   `BuildConfig.VERSION_NAME`
*   `BuildConfig.VERSION_CODE`

The last three values are specified by the `applicationId`, `versionCode`, and `versionName` values in our Gradle build script. For more information, consult the documents on [versioning your applications](http://developer.android.com/tools/publishing/versioning.html), and on [configuring your `applicationId` with Gradle](http://tools.android.com/tech-docs/new-build-system/applicationid-vs-packagename).

Note that if your application uses a `WebView`, you can configure it to use the same `User-Agent` header value that you constructed the `UserAgentInterceptor` with:
为了创建User-Agent header值人然后传递给UserAgentInterceptor的构造器，使用你得到的任何信息。

我们可以使用：

android 的系统信息可以清晰的传递出这是一台android 设备
Build.MODEL 或者“制造商提供的用户可见最终可见的名称”
Build.BRAND或者“消费者可见的品牌与产品/硬件相关信息”
Build.VERSION.SDK_INT或者“消费者可见的Android提供的SDK版本号”
BuildConfig.APPLICATION_ID
BuildConfig.VERSION_NAME
BuildConfig.VERSION_CODE
最后三个值由的applicationID，VERSIONCODE和VERSIONNAME的值在我们的Gradle build脚本中

了解更多信息可以查看versioning your applications和configuring your applicationId with Gradle

请注意，如果您的应用程序使用的是WebView，您可以配置使用相同的User-Agent header值，你可以通过下面方法创建UserAgentInterceptor：

```java
WebSettings settings = webView.getSettings();
settings.setUserAgentString(userAgentHeaderValue);
```


### 5\. Specify reasonable timeouts
5.指定合理的超时
Before version 2.5.0, OkHttp requests defaulted to never timing out. Starting with version 2.5.0, a request times out if establishing a connection, reading the next byte from a connection, or writing the next byte to a connection takes more than 10 seconds to complete. Doing nothing more than updating to version 2.5.0 revealed bugs in our own code, simply because we began exercising certain error paths for the first time. To override these default values, invoke `setConnectTimeout`, `setReadTimeout` or `setWriteTimeout` respectively.

Note that Picasso and Retrofit specify different timeout values for their default `OkHttpClient` instances. By default, Picasso specifies:

*   A connect timeout of 15 seconds.
*   A read timeout of 20 seconds.
*   A write timeout of 20 seconds.

Whereas Retrofit specifies:

*   A connect timeout of 15 seconds.
*   A read timeout of 20 seconds.
*   No write timeout.

By configuring Picasso and Retrofit with your own `OkHttpClient` instance, you can ensure consistent timeouts by all requests.
2.5.0版本之前，OkHttp请求默认为永不超时。2.5.0版本开始如果建立连接请求超时，如果从连接读取下一个字节或写入的下一个字节到连接，花费超过10秒，就终止。这样做需要更新到2.5.0版本我们就不需要在我们的代码中修改bug。原因很简单是我因为我们第一次使用的时候使用了错误的路径。

要覆盖这些默认值，可以分别调用setConnectTimeout，setReadTimeout或setWriteTimeout。
需要注意的是Picasso和Retrofit为OkHttpClient实例指定不同的超时值时，默认情况下，Picasso指定：

连接超过15秒.
读取超过20秒
写入超过20秒
而Retrofit指定：

连接超过15秒.
读取超过20秒
没有写入超时
通过配置Picasso和Retrofit自己的OkHttpClient实例你可以确保所有的请求超时是一致的
### Conclusion
总结：
Again, the default configuration of OkHttp offers significant utility. By adopting the steps above, you can increase its resourcefulness and introspective power, and improve the quality of your application.
Okhttp默认的配置为我们提供了非常重要实用功能。通过采用上述步骤，你可以增加它的灵活性和内省的能力并提高应用程序的质量。
