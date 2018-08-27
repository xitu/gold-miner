> * 原文链接: [Effective OkHttp](http://omgitsmgp.com/2015/12/02/effective-okhttp/)
* 原文作者 : [Michael Parker](http://omgitsmgp.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Brucezz](https://github.com/brucezz)
* 校对者: [iThreeKing](https://github.com/iThreeKing), [Adam Shen](https://github.com/shenxn), [Jaeger](https://github.com/laobie)

# 如何更高效地使用 okhttp

在为[可汗学院](https://www.khanacademy.org/)开发 [Android app](https://play.google.com/store/apps/details?id=org.khanacademy.android) 时，[OkHttp](http://square.github.io/okhttp/) 是一个很重要的开源库。虽然它的默认配置已经提供了很好的效果，但是我们还是采取了一些措施提高 OkHttp 的可用性和自我检查能力：

### 1\. 在文件系统中开启响应缓存

有些响应消息通过包含 `Cache-Control` HTTP 首部字段允许缓存，但是默认情况下，OkHttp 并不会缓存这些响应消息。因此你的客户端可能会因为不断请求相同的资源而浪费时间和带宽，而不是简单地读取一下首次响应消息的缓存副本。

为了在文件系统中开启响应缓存，需要配置一个 `com.squareup.okhttp.Cache` 实例，然后把它传递给 `OkHttpClient` 实例的 `setCache` 方法。你必须用一个表示目录的 `File` 对象和最大字节数来实例化 `Cache` 对象。那些能够缓存的响应消息会被写在指定的目录中。如果已缓存的响应消息导致目录内容超过了指定的大小，响应消息会按照最近最少使用（[LRU Policy](https://en.wikipedia.org/wiki/Cache_algorithms#LRU)）的策略被移除。

正如 [Jesse Wilson 所建议的](http://stackoverflow.com/a/32752861/400717)，我们将响应消息缓存在 `context.getCacheDir()` 的子文件夹中：


```java
// 缓存根目录，由这里推荐 -> http://stackoverflow.com/a/32752861/400717.
// 小心可能为空，参考下面两个链接
// https://groups.google.com/d/msg/android-developers/-694j87eXVU/YYs4b6kextwJ 和
// http://stackoverflow.com/q/4441849/400717.
final @Nullable File baseDir = context.getCacheDir();
if (baseDir != null) {
  final File cacheDir = new File(baseDir, "HttpResponseCache");
  okHttpClient.setCache(new Cache(cacheDir, HTTP_RESPONSE_DISK_CACHE_MAX_SIZE));
}
```

在可汗学院的应用中，我们指定了 `HTTP_RESPONSE_DISK_CACHE_MAX_SIZE` 的大小为 `10 * 1024 * 1024`，即 10MB。

### 2\. 集成 Stetho

[Stetho](http://facebook.github.io/stetho/) 是一个 Facebook 出品的超赞的开源库，它可以让你用 Chrome 的功能——[开发者工具](https://developers.google.com/web/tools/setup/workspace/setup-devtools) 来检查调试你的 Android 应用。

Stetho 不仅能够检查应用的 SQLite 数据库和视图层次，还可以检查 OkHttp 的每一条请求和响应消息：

![Image of Stetho](http://omgitsmgp.com/assets/images/posts/stetho-inspector-network.png)

这种自我检查方式（Introspection）有效地确保了服务器返回允许缓存资源的 HTTP 首部时，且核缓存资源存在时，不再发出任何请求。

开启 Stetho，只用简单地添加一个 `StethoInterceptor` 实例到网络拦截器（Network Interceptor）的列表中去：


```java
okHttpClient.networkInterceptors().add(new StethoInterceptor());
```


应用运行完毕之后，打开 Chrome 然后跳转到 `chrome://inspect`。设备、应用以及应用标识符信息会被陈列出来。直接点击“inspect”链接就可以打开开发者工具，然后切换到 Network 标签开始监测 OkHttp 发出的请求。

### 3\. 使用 Picasso 和 Retrofit

可能和我们一样，你使用 [Picasso](http://square.github.io/picasso/) 来加载网络图片，或者使用 [Retrofit](http://square.github.io/retrofit/) 来简化网络请求和解析响应消息。在默认情况下，如果你没有显式地指定一个 `OkHttpClient`，这些开源库会隐式地创建它们自己的 `OkHttpClient` 实例以供内部使用。以下代码来自于 Picasso 2.5.2 版本的 `OkHttpDownloader` 类：


```java
private static OkHttpClient defaultOkHttpClient() {
  OkHttpClient client = new OkHttpClient();
  client.setConnectTimeout(Utils.DEFAULT_CONNECT_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS);
  client.setReadTimeout(Utils.DEFAULT_READ_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS);
  client.setWriteTimeout(Utils.DEFAULT_WRITE_TIMEOUT_MILLIS, TimeUnit.MILLISECONDS);
  return client;
}
```

Retrofit 也有类似的工厂方法用来创建它自己的 `OkHttpClient`。

图片是应用中需要加载的最大的资源之一。Picasso 是严格地按照 LRU 策略在内存中维护它的图片缓存。如果客户端尝试用 Picasso 加载一张图片，并且 Picasso 没有在内存缓存中找到该图片，那么它会委托内部的 `OkHttpClient` 实例来加载该图片。在默认情况下，由于前面的 `defaultOkHttpClient` 方法没有在文件系统中配置响应缓存，该实例会一直从服务器加载图片。

自定义一个 `OkHttpClient` 实例，将从文件系统返回一个已缓存的响应消息这种情况考虑在内。没有一张图片直接从服务器加载。这在应用第一次加载时是尤为重要的。在这个时候，Picasso 的内存中的缓存是 [“冷”](http://stackoverflow.com/a/22756972/400717)的，它会频繁地委托 `OkHttpClient` 实例去加载图片。

这就需要构建一个用你的 `OkHttpClient` 配置的 `Picasso` 实例。如果你在代码中使用  `Picasso.with(context).load(...)` 来加载图片，你所使用的 `Picasso` 单例对象，是在  `with` 方法中用自己的 `OkHttpClient` 延迟加载和配置的。因此我们必须在第一次调用 `with` 方法之前指定自己的 `Picasso` 实例作为单例对象。

简单地把 `OkHttpClient` 实例包装到一个 `OkHttpDownloader` 对象中，然后传递给 `Picasso.Builder` 实例的 `downloader` 方法：

```java
final Picasso picasso = new Picasso.Builder(context)
    .downloader(new OkHttpDownloader(okHttpClient))
    .build();

//客户端应该在任何需要的时候来创建这个实例
//以防万一，替换掉那个单例对象
Picasso.setSingletonInstance(picasso);
```

在 Retrofit 1.9.x 中，通过 `RestAdapter` 使用你的 `OkHttpClient` 实例，把 `OkHttpClient` 实例包装到一个 `OkClient` 实例中，然后传递给 `RestAdapter.Builder` 实例的 `setClient` 方法：


    restAdapterBuilder.setClient(new OkClient(httpClient));


在 Retrofit 2.0 中，直接把 `OkHttpClient` 实例传递给 `Retrofit.Builder` 实例的 `client` 即可。 

在可汗学院的应用中，我们使用 [Dagger](http://google.github.io/dagger/) 来确保只有一个 `OkHttpClient` 实例，而且 Picasso 和 Retrofit 都会使用到它。我们为带 `@Singleton` 注解的 `OkHttpClient` 实例创建了一个 provider：

```java
@Provides
@Singleton
public OkHttpClient okHttpClient(final Context context, ...) {
  final OkHttpClient okHttpClient = new OkHttpClient();
  configureClient(okHttpClient, ...);
  return okHttpClient;
}
```

这个 `OkHttpClient` 实例随后通过 Dagger 注入到其他用来创建 `RestAdapter` 和 `Picasso` 实例的 provider 里。

### 4\. 设置用户代理拦截器（User-Agent Interceptor）

当客户端在每一次请求中都提供一个详细的 `User-Agent` 头部信息时，日志文件和分析数据提供了很有用的信息。默认情况下，OkHttp 的 `User-Agent` 值仅仅只有它的版本号。要设定你自己的 User-Agent，创建一个拦截器（Interceptor）然后替换掉默认值，参考 [StackOverflow 上的建议](http://stackoverflow.com/a/27840834/400717)：


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

使用任何你觉得有价值的信息，来创建 `User-Agent` 值，然后传递给 `UserAgentInterceptor` 的构造函数。我们使用了这些字段：

*   `os` 字段，值设置为 `Android`，明确表明这是一个 Android 设备
*   `Build.MODEL` 字段，即用户可见的终端产品的名称
*   `Build.BRAND` 字段，即消费者可见的跟产品或硬件相关的商标
*   `Build.VERSION.SDK_INT` 字段，即用户可见的 [Android] 框架版本号
*   `BuildConfig.APPLICATION_ID` 字段
*   `BuildConfig.VERSION_NAME` 字段
*   `BuildConfig.VERSION_CODE`字段

最后三个字段是根据我们的 Gradle 构建脚本中的 `applicationId`, `versionCode` 和 `versionName` 的值来确定的。了解更多信息请参考文档 [应用版本控制](http://developer.android.com/tools/publishing/versioning.html)，和 [使用 Gradle 配置你的 `applicationId`](http://tools.android.com/tech-docs/new-build-system/applicationid-vs-packagename)。

小提示：如果你的应用中用到了 `WebView`，你可以配置使用相同的 `User-Agent` 值，即之前创建的 `UserAgentInterceptor`：


```java
WebSettings settings = webView.getSettings();
settings.setUserAgentString(userAgentHeaderValue);
```

### 5\. 指定合理的超时

在 2.5.0 版本之前，OkHttp 请求默认永不超时。从 2.5.0 版本开始，如果建立了一个连接，或从连接读取下一个字节，或者向连接写入下一个字节，用时超过了10秒，请求就会超时。分别调用 `setConnectTimeout`，`setReadTimeout` 或 `setWriteTimeout` 方法可以重写那些默认值。

小提示：Picasso 和 Retrofit 为它们的默认 `OkHttpClient` 实例指定不同的超时时长。
默认情况下， Picasso 设定如下：

*   连接超时15秒
*   读取超时20秒
*   写入超时20秒

Retrofit 设定如下：

*   连接超时15秒
*   读取超时20秒
*   写入无超时

用你自己的 `OkHttpClient` 实例配置好 Picasso 和 Retrofit 之后，就能确保所有请求超时的一致性了。

### 结论

再次强调，OkHttp 的默认配置提供了显著的效果，但是采取以上的措施，可以提高 OkHttp 的可用性和自我检查能力，并且提升你的应用的质量。
