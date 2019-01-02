> * 原文链接 : [Top 5 Android libraries every Android developer should know about - v. 2015](https://infinum.co/the-capsized-eight/articles/top-five-android-libraries-every-android-developer-should-know-about-v2015)
* 原文作者 : [Infinum](https://infinum.co/the-capsized-eight/author/ivan-kust)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Kassadin](https://github.com/kassadin)
* 校对者: [xiuweikang](https://github.com/xiuweikang) [lihb](https://github.com/lihb)
* 状态 : 

# 2015 年度 Android 开发者必备的 5 个开源库

在2014年6月，我们发表了一篇关于[5 个顶级 Android 开源库](https://infinum.co/the-capsized-eight/articles/top-5-android-libraries-every-android-developer-should-know-about)的文章，我们一直在用，并且相信每个 Android 开发者都应该了解这些开源库。从那之后，Android 方面已经发生了很多变化，所以我们写了这篇文章，我们最喜欢的5个开源库的更新版。

下面是更新列表:

![Top 5 Android libraries](https://s3.amazonaws.com/infinum.web.production/repository_items/files/000/000/308/original/top_5_android_libraries.png?1402486321)

## 1\. [Retrofit](https://github.com/square/retrofit/tree/version-one)

当涉及到实现 REST APIs 时，Retrofit 仍是我们的最爱。

他们的网站上写着: “Retrofit 将 REST API 转换为 Java 接口。”是的，还有其他解决方案，但是 Retrofit 已经被证明是在一个项目中管理 API 调用最优雅、最方便的解决方案。使用注解添加请求方法和相对地址使得代码干净简单。

通过注解，你可以轻松地添加请求体，操作 URL 或请求头并添加查询参数。

为方法添加返回类型会使该方法同步执行，然而添加Callback（回调）会使之异步执行，完成后回调 success 或 failure 方法。

```java
public interface RetrofitInterface {

    // 异步带回调
    @GET("/api/user")
    User getUser(@Query("user_id") int userId, Callback<User> callback);

    // 同步
    @POST("/api/user/register")
    User registerUser(@Body User user);
}


// 例子
RetrofitInterface retrofitInterface = new RestAdapter.Builder()
            .setEndpoint(API.API_URL).build().create(RetrofitInterface.class);

// 获取 id 为 2048 的用户
retrofitInterface.getUser(2048, new Callback<User>() {
    @Override
    public void success(User user, Response response) {

    }

    @Override
    public void failure(RetrofitError retrofitError) {

    }
});
```

Retrofit 默认使用 [Gson](https://code.google.com/p/google-gson/)，所以不需要手动解析 JSON。当然其他的转换器也是支持的。

现在 Retrofit 2.0 正在活跃地开发着，仍然是 beta，但你可以从[这里](http://square.github.io/retrofit/)获取到。从 Retrofit 1.9 开始，很多的东西都被砍了，也有一些重大的变化比如使用新的调用接口取代回调。

## 2\. [DBFlow](https://github.com/Raizlabs/DBFlow)

如果你正准备在你的项目中存储任意复杂的数据，你应该使用 DBFlow。正如他们的 GitHub 上所说，这是“一个速度极快，功能强大，而且非常简单的 Android 数据库 ORM 库，为你编写数据库代码”。

一些简单的栗子:

```java
// Query a List
new Select().from(SomeTable.class).queryList();
new Select().from(SomeTable.class).where(conditions).queryList();

// Query Single Model
new Select().from(SomeTable.class).querySingle();
new Select().from(SomeTable.class).where(conditions).querySingle();

// Query a Table List and Cursor List
new Select().from(SomeTable.class).where(conditions).queryTableList();
new Select().from(SomeTable.class).where(conditions).queryCursorList();

// SELECT methods
new Select().distinct().from(table).queryList();
new Select().all().from(table).queryList();
new Select().avg(SomeTable$Table.SALARY).from(SomeTable.class).queryList();
new Select().method(SomeTable$Table.SALARY, "MAX").from(SomeTable.class).queryList();

```

DBFlow 是一个不错的 ORM，这将消除大量用于处理数据库的样板代码。虽然 Android 也有其他的 ORM 方案，但对我们来说 DBFlow 已被证明是最好的解决方案。

## 3\. [Glide](https://github.com/bumptech/glide)

Glide 是一个用于加载图片的库。当前备选方案有 [Universal Image Loader](https://github.com/nostra13/Android-Universal-Image-Loader) 和 [Picasso](https://github.com/square/picasso)；但是，以我来看，Glide 是当前的最佳选择。

下面是一个简单的例子，关于如何使用 Glide 从 URL 加载图片到 ImageView。

```java
ImageView imageView = (ImageView) findViewById(R.id.my_image_view);

Glide.with(this).load("http://goo.gl/gEgYUd").into(imageView);

```


## 4\. [Butterknife](http://jakewharton.github.io/butterknife/)

一个用于将 Android 视图绑定到属性和方法的库（例如，绑定一个 view 的 OnClick 事件到一个方法）。较之前版本而言，基本功能没有变化，但可选项增加了。栗子：

```java
class ExampleActivity extends Activity {
  @Bind(R.id.title) TextView title;
  @Bind(R.id.subtitle) TextView subtitle;
  @Bind(R.id.footer) TextView footer;

  @Override public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.simple_activity);
    ButterKnife.bind(this);
    // TODO Use fields...
  }
}

```


## 5\. [Dagger 2](http://google.github.io/dagger/)

自从我们迁移到 MVP 架构，我们就开始了广泛使用依赖注入。Dagger 2 是著名的依赖注入库 Dagger 的继承者，我们强烈推荐它。

一个主要的改进就是生成的注入代码不再依赖反射，这使得调试容易了许多。

Dagger 为您创建类的实例，并满足他们的依赖。这依赖于 javax.inject.Inject 注解，以确定哪些构造函数或字段应被视为依赖。以著名的咖啡机(CoffeeMaker)为例:

> 译者注：Dagger 和 Dagger 2 的官方文档里都是使用这个例子，所以著名…

```java
class Thermosiphon implements Pump {
  private final Heater heater;

  @Inject
  Thermosiphon(Heater heater) {
    this.heater = heater;
  }

  ...
}
```

直接注入到字段的栗子：

```java
class CoffeeMaker {
  @Inject Heater heater;
  @Inject Pump pump;

  ...
}

```

通过 modules 和 @Proivides 注解提供依赖(Dependencies)：

```java
@Module
class DripCoffeeModule {
  @Provides Heater provideHeater() {
    return new ElectricHeater();
  }

  @Provides Pump providePump(Thermosiphon pump) {
    return pump;
  }
}

```

关于依赖注入本身，如果想获取更多信息，请查看 Dagger 2 主页或 [talk about Dagger 2 by Gregory Kick](https://www.youtube.com/watch?v=oK_XtfXPkqw)。

### 附加链接

[Android 周报](http://androidweekly.net/) 仍然是学习 Android 库最好的资源之一。这是关于Android开发的每周时事资讯。

此外，下面是 Android 行业经常发关于 Android 开发文章的大咖们：

[Jake Wharton](https://twitter.com/JakeWharton) [Chris Banes](https://twitter.com/chrisbanes) [Cyril Mottier](https://twitter.com/cyrilmottier) [Mark Murphy](https://twitter.com/commonsguy) [Mark Allison](https://twitter.com/MarkIAllison) [Reto Meier](https://twitter.com/retomeier)
