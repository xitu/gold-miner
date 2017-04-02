> * 原文地址：[Dependency Injection with Dagger 2](https://github.com/codepath/android_guides/wiki/Dependency-Injection-with-Dagger-2)
> * 原文作者：[CodePath](https://github.com/codepath)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： 
> * 校对者：

# 用 Dagger 2 实现依赖注入

## 概要 

很多 Android 应用依赖于一些含有其它依赖的对象。例如，一个 Twitter API 客户端可能需要通过 [Retrofit](https://github.com/codepath/android_guides/wiki/Consuming-APIs-with-Retrofit) 之类的网络库被构建。要使用这个库，你可能还需要添加 [Gson](https://github.com/codepath/android_guides/wiki/Leveraging-the-Gson-Library) 这样的解析库。另外，实现认证或缓存的库可能需要使用 [shared preferences](https://github.com/codepath/android_guides/wiki/Storing-and-Accessing-SharedPreferences)或其它通用存储方式。这就需要先把它们实例化，并创建一个隐含的依赖链。

如果你不熟悉依赖注入，看看[这个](https://www.youtube.com/watch?v=IKD2-MAkXyQ) 短视频。

Dagger 2 为你解析这些依赖，并生成把它们绑定在一起的代码。也有很多其它的 Java 依赖注入框架，但它们中很多个是有缺陷的，比如依赖 XML，需要在运行时验证依赖，或者在起始时造成性能负担。 [Dagger 2](http://google.github.io/dagger/) 纯粹依赖于 Java [annotation processors](https://www.youtube.com/watch?v=dOcs-NKK-RA) 以及编译时检查来分析并验证依赖。它被认为是目前最高效的依赖注入框架之一。

### 优点

这是使用 Dagger 2 的一系列其它优势：

 * **简化共享实例访问**。就像 [ButterKnife](https://github.com/codepath/android_guides/wiki/Reducing-View-Boilerplate-with-Butterknife) 库简化了引用View， event handler 和 resources 的方式一样，Dagger 2 提供了一个简单的方式获取对共享对象的引用。例如，一旦我们在 Dagger 中声明了  `MyTwitterApiClient` 或 `SharedPreferences` 的单例，就可以用一个简单的 `@Inject` 标注来声明域：

```java
public class MainActivity extends Activity {
   @Inject MyTwitterApiClient mTwitterApiClient;
   @Inject SharedPreferences sharedPreferences;

   public void onCreate(Bundle savedInstance) {
       // assign singleton instances to fields
       InjectorClass.inject(this);
   } 
```

 * **容易配置复杂的依赖**。 对象创建是有隐含顺序的。Dagger 2 浏览依赖图，并且[生成易于理解和追踪的代码](https://github.com/codepath/android_guides/wiki/Dependency-Injection-with-Dagger-2#code-generation)。而且，它可以节约大量的样板代码，使你不再需要手写，手动获取引用并把它们传递给其他对象作为依赖。它也简化了重构，因为你可以聚焦于构建模块本身，而不是它们被创建的顺序。

 * **更简单的单元和集成测试**  因为依赖图是为我们创建的，我们可以轻易换出用于创建网络响应的模块，并模拟这种行为。

 * **实例范围** 你不仅可以轻易地管理持续整个应用生命周期的实例，也可以利用 Dagger 2 来定义生命周期更短（比如和一个用户 session 或 Activity 生命周期相绑定）的实例。 

### 设置

默认的 Android Studio 不把生成的 Dagger 2 代码视作合法的类，因为它们通常并不被加入 source 路径。但引入 `android-apt` 插件后，它会把这些文件加入 IDE classpath，从而提供更好的可见性。

确保[升级](https://github.com/codepath/android_guides/wiki/Getting-Started-with-Gradle#upgrading-gradle) 到最迟的 Gradle 版本以使用最新的 `annotationProcessor` 语法: 

```gradle
dependencies {
    // apt command comes from the android-apt plugin
    compile "com.google.dagger:dagger:2.9"
    annotationProcessor "com.google.dagger:dagger-compiler:2.9"
    provided 'javax.annotation:jsr250-api:1.0'
}
```

注意 `provided` 关键词是指只在编译时需要的依赖。Dagger 编译器生成了用于生成依赖图的类，而这个依赖图是在你的源代码中定义的。这些类在编译过程中被添加到你的IDE classpath。`annotationProcessor` 关键字可以被 Android Gradle 插件理解。它不把这些类添加到 classpath 中，而只是把它们用于处理注解。这可以避免不小心引用它们。

### 创建单例
![Dagger 注入概要](https://raw.githubusercontent.com/codepath/android_guides/master/images/dagger_general.png)

最简单的例子是用 Dagger 2 集中管理所有的单例。假设你不用任何依赖注入框架，在你的 Twitter 客户端中写下类似这些的东西：

```java
OkHttpClient client = new OkHttpClient();

// Enable caching for OkHttp
int cacheSize = 10 * 1024 * 1024; // 10 MiB
Cache cache = new Cache(getApplication().getCacheDir(), cacheSize);
client.setCache(cache);

// Used for caching authentication tokens
SharedPreferences sharedPrefeences = PreferenceManager.getDefaultSharedPreferences(this);

// Instantiate Gson
Gson gson = new GsonBuilder().create();
GsonConverterFactory converterFactory = GsonConverterFactory.create(gson);

// Build Retrofit
Retrofit retrofit = new Retrofit.Builder()
                                .baseUrl("https://api.github.com")
                                .addConverterFactory(converterFactory)
                                .client(client)  // custom client
                                .build();
```

#### 声明你的单例

你需要通过创建 Dagger 2 **模块**定义哪些对象应该作为依赖链的一部分。例如，假设我们想要创建一个 `Retrofit` 单例，使它绑定到应用生命周期，对所有的 Activity 和 Fragment 都可用，我们首先需要使 Dagger 意识到他可以提供 `Retrofit` 的实例。

因为需要设置缓存，我们需要一个 Application context。我们的第一个 Dagger 模块，`AppModule.java`，被用于提供这个依赖。我们将定义一个 `@Provides` 注解，标注带有 `Application` 的构造方法:

```java
@Module
public class AppModule {

    Application mApplication;

    public AppModule(Application application) {
        mApplication = application;
    }

    @Provides
    @Singleton
    Application providesApplication() {
        return mApplication;
    }
}
```

我们创建了一个名为 `NetModule.java` 的类，并用 `@Module` 来通知 Dagger，在这里查找提供实例的方法。

返回实例的方法也应当用 `@Provides` 标注。`Singleton` 标注通知 Dagger 编译器，实例在应用中只应被创建一次。在下面的例子中，我们把 `SharedPreferences`, `Gson`, `Cache`, `OkHttpClient`, 和 `Retrofit` 设置为在依赖列表中可用的类型。

```java
@Module
public class NetModule {

    String mBaseUrl;
    
    // Constructor needs one parameter to instantiate.  
    public NetModule(String baseUrl) {
        this.mBaseUrl = baseUrl;
    }

    // Dagger will only look for methods annotated with @Provides
    @Provides
    @Singleton
    // Application reference must come from AppModule.class
    SharedPreferences providesSharedPreferences(Application application) {
        return PreferenceManager.getDefaultSharedPreferences(application);
    }

    @Provides
    @Singleton
    Cache provideOkHttpCache(Application application) { 
        int cacheSize = 10 * 1024 * 1024; // 10 MiB
        Cache cache = new Cache(application.getCacheDir(), cacheSize);
        return cache;
    }

   @Provides 
   @Singleton
   Gson provideGson() {  
       GsonBuilder gsonBuilder = new GsonBuilder();
       gsonBuilder.setFieldNamingPolicy(FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES);
       return gsonBuilder.create();
   }

   @Provides
   @Singleton
   OkHttpClient provideOkHttpClient(Cache cache) {
      OkHttpClient client = new OkHttpClient();
      client.setCache(cache);
      return client;
   }

   @Provides
   @Singleton
   Retrofit provideRetrofit(Gson gson, OkHttpClient okHttpClient) {
      Retrofit retrofit = new Retrofit.Builder()
                .addConverterFactory(GsonConverterFactory.create(gson))
                .baseUrl(mBaseUrl)
                .client(okHttpClient)
                .build();
        return retrofit;
    }
}
```

注意，方法名称（比如 `provideGson()`, `provideRetrofit()` 等）是没关系的，可以任意设置。`@Provides` 被用于把这个实例化和其它同类的模块联系起来。`@Singleton` 标注用于通知 Dagger，它在整个应用的生命周期中只被初始化一次。

一个 `Retrofit` 实例依赖于一个 `Gson` 和一个 `OkHttpClient` 实例，所以我们可以在同一个类中定义两个方法，来提供这两种实例。`@Provides` 标注和方法中的这两个参数将使 Dagger 意识到，构建一个 `Retrofit` 实例 需要依赖 `Gson` 和 `OkHttpClient`。

#### 定义注入目标

Dagger 使你的 activity, fragment, 或 service 中的域可以通过 `@Inject` 注解和调用 `inject()` 方法被赋值。调用 `inject()` 将会使得 Dagger 2 在依赖图中寻找合适类型的单例。如果找到了一个，它就把引用赋值给对应的域。例如，在下面的例子中，它会尝试找到一个返回`MyTwitterApiClient` 和`SharedPreferences` 类型的 provider：

```java
public class MainActivity extends Activity {
   @Inject MyTwitterApiClient mTwitterApiClient;
   @Inject SharedPreferences sharedPreferences;

  public void onCreate(Bundle savedInstance) {
       // assign singleton instances to fields
       InjectorClass.inject(this);
   } 
```

Dagger 2 中使用的注入者类被称为 **component**。它把先前定义的单例的引用传给 activity, service 或 fragment。我们需要用 `@Component` 来注解这个类。注意，需要被注入的 activity, service 或 fragment 需要在这里使用 `inject()` 方法注入： 


```java
@Singleton
@Component(modules={AppModule.class, NetModule.class})
public interface NetComponent {
   void inject(MainActivity activity);
   // void inject(MyFragment fragment);
   // void inject(MyService service);
}
```

**注意** 基类不能被作为注入的目标。Dagger 2 依赖于强类型的类，所以你必须指定哪些类会被定义。（有一些[建议](https://blog.gouline.net/2015/05/04/dagger-2-even-sharper-less-square/) 帮助你绕开这个问题，但这样做的话，代码可能会变得更复杂，更难以追踪。）

#### 生成代码

Dagger 2 的一个重要特点是它会为标注 `@Component` 的接口生成类的代码。你可以使用带有 `Dagger` (比如 `DaggerTwitterApiComponent.java`) 前缀的类来为依赖图提供实例，并用它来完成用 `@Inject` 注解的域的注入。 参见[[setup guide|Dependency-Injection-with-Dagger-2#setup]]。

### 实例化组件

我们应该在一个 `Application` 类中完成这些工作，因为这些实例应当在 application 的整个周期中只被声明一次：

```java
public class MyApp extends Application {

    private NetComponent mNetComponent;

    @Override
    public void onCreate() {
        super.onCreate();
        
        // Dagger%COMPONENT_NAME%
        mNetComponent = DaggerNetComponent.builder()
                // list of modules that are part of this component need to be created here too
                .appModule(new AppModule(this)) // This also corresponds to the name of your module: %component_name%Module
                .netModule(new NetModule("https://api.github.com"))
                .build();

        // If a Dagger 2 component does not have any constructor arguments for any of its modules,
        // then we can use .create() as a shortcut instead:
        //  mNetComponent = com.codepath.dagger.components.DaggerNetComponent.create();
    }

    public NetComponent getNetComponent() {
       return mNetComponent;
    }
}
```

如果你不能引用 Dagger 组件，rebuild 整个项目 (在 Android Studio 中，选择 _Build > Rebuild Project_)。

因为我们在覆盖默认的 `Application` 类，我们同样需要修改应用的 `name` 以启动 `MyApp`。这样，你的 application 将会使用这个 application 类来处理最初的实例化。

```xml
<application
      android:allowBackup="true"
      android:name=".MyApp">
```

在我们的 activity 中，我们只需要获取这些 components 的引用，并调用 `inject()`。

```java
public class MyActivity extends Activity {
  @Inject OkHttpClient mOkHttpClient;
  @Inject SharedPreferences sharedPreferences;

  public void onCreate(Bundle savedInstance) {
        // assign singleton instances to fields
        // We need to cast to `MyApp` in order to get the right method
        ((MyApp) getApplication()).getNetComponent().inject(this);
    } 
```
 
### 限定词类型

![Dagger Qualifiers](https://raw.githubusercontent.com/codepath/android_guides/master/images/dagger_qualifiers.png)

如果我们需要同一类型的两个不同对象，我们可以使用 `@Named` 限定词注解。 你需要定义你如何提供单例 (用 `@Provides` 注解)，以及你从哪里注入它们(用 `@Inject` 注解):

```java
@Provides @Named("cached")
@Singleton
OkHttpClient provideOkHttpClient(Cache cache) {
    OkHttpClient client = new OkHttpClient();
    client.setCache(cache);
    return client;
}

@Provides @Named("non_cached") @Singleton
OkHttpClient provideOkHttpClient() {
    OkHttpClient client = new OkHttpClient();
    return client;
}
```

注入同样需要这些 named 注解：

```java
@Inject @Named("cached") OkHttpClient client;
@Inject @Named("non_cached") OkHttpClient client2;
```

`@Named` 是一个被 Dagger 预先定义的限定语，但你也可以创建你自己的限定语注解：

```java
@Qualifier
@Documented
@Retention(RUNTIME)
public @interface DefaultPreferences {
}
```

### 作用域
![Dagger 作用域](https://raw.githubusercontent.com/codepath/android_guides/master/images/dagger_scopes.png)

在 Dagger 2 中，你可以通过自定义作用域来定义组件应当如何封装。例如，你可以创建一个只持续 activity 或 fragment 整个生命周期的作用域。你也可以创建一个对应一个用户认证 session 的作用域。 你可以定义任意数量的自定义作用域注解，只要你把它们声明为 public `@interface`：
```java
@Scope
@Documented
@Retention(value=RetentionPolicy.RUNTIME)
public @interface MyActivityScope
{
}
```

虽然 Dagger 2 在运行时不依赖注解，把 `RetentionPolicy` 设置为 RUNTIME 对于将来检查你的 module 将是很有用的。

### 依赖组件和子组件

利用作用域，我们可以创建 **依赖组件** 或 **子组件**。上面的例子中，我们使用了 `@Singleton` 注解，它持续了整个应用的生命周期。我们也依赖了一个主要的 Dagger 组件。  

如果我们不需要组件总是存在于内存中（例如，和 activity 或 fragment 生命周期绑定，或在用户登录时绑定），我们可以创建依赖组件和子组件。它们各自提供了一种封装你的代码的方式。我们将在下一节中看到如何使用它们。

在使用这种方法时，有若干问题要注意：

  * **依赖组件需要父组件显式指定哪些依赖可以在下游注入，而子组件不需要** 对父组件而言，你需要通过指定类型和方法来向下游组件暴露这些依赖：

```java
// parent component
@Singleton
@Component(modules={AppModule.class, NetModule.class})
public interface NetComponent {
    // remove injection methods if downstream modules will perform injection

    // downstream components need these exposed
    // the method name does not matter, only the return type
    Retrofit retrofit(); 
    OkHttpClient okHttpClient();
    SharedPreferences sharedPreferences();
}
```

   如果你忘记加入这一行，你将有可能看到一个关于注入目标缺失的错误。就像 private/public 变量的管理方式一样，使用一个 parent 组件可以更显式地控制，也可保证更好的封装。使用子组件使得依赖注入更容易管理，但封装得更差。
   
   
  * **两个依赖组件不能使用同一个作用域** 例如，两个组件不能都用 `@Singleton` 注解设置定义域。这个限制的原因在 [这里](https://github.com/google/dagger/issues/107#issuecomment-71073298) 有所说明。依赖组件需要定义它们自己的作用域。

  * **Dagger 2 also enables the ability to create scoped instances, the responsibility rests on you to create and delete references that are consistent with the intended behavior.**  Dagger 2 does not know anything about the underlying implementation.  See this Stack Overflow [discussion](http://stackoverflow.com/questions/28411352/what-determines-the-lifecycle-of-a-component-object-graph-in-dagger-2) for more details.

#### 依赖组件

![Dagger 组件依赖](https://raw.githubusercontent.com/codepath/android_guides/master/images/dagger_dependency.png)

For instance, if we wish to use a component created for the entire lifecycle of a user session signed into the application, we can define our own `UserScope` interface:

```java
import java.lang.annotation.Retention;
import javax.inject.Scope;

@Scope
public @interface UserScope {
}
```

Next, we define the parent component:

```java
  @Singleton
  @Component(modules={AppModule.class, NetModule.class})
  public interface NetComponent {
      // downstream components need these exposed with the return type
      // method name does not really matter
      Retrofit retrofit();
  }
```

We can then define a child component:

```java
@UserScope // using the previously defined scope, note that @Singleton will not work
@Component(dependencies = NetComponent.class, modules = GitHubModule.class)
public interface GitHubComponent {
    void inject(MainActivity activity);
}
```

Let's assume this GitHub module simply returns back an API interface to the GitHub API:

```java

@Module
public class GitHubModule {

    public interface GitHubApiInterface {
      @GET("/org/{orgName}/repos")
      Call<ArrayList<Repository>> getRepository(@Path("orgName") String orgName);
    }

    @Provides
    @UserScope // needs to be consistent with the component scope
    public GitHubApiInterface providesGitHubInterface(Retrofit retrofit) {
        return retrofit.create(GitHubApiInterface.class);
    }
}
```

In order for this `GitHubModule.java` to get access to the `Retrofit` instance, we need explicitly define them in the upstream component.  If the downstream modules will be performing the injection, they should also be removed from the upstream components too:

```java
@Singleton
@Component(modules={AppModule.class, NetModule.class})
public interface NetComponent {
    // remove injection methods if downstream modules will perform injection

    // downstream components need these exposed
    Retrofit retrofit();
    OkHttpClient okHttpClient();
    SharedPreferences sharedPreferences();
}
```

The final step is to use the `GitHubComponent` to perform the instantiation.  This time, we first need to build the `NetComponent` and pass it into the constructor of the `DaggerGitHubComponent` builder:

```java
NetComponent mNetComponent = DaggerNetComponent.builder()
                .appModule(new AppModule(this))
                .netModule(new NetModule("https://api.github.com"))
                .build();

GitHubComponent gitHubComponent = DaggerGitHubComponent.builder()
                .netComponent(mNetComponent)
                .gitHubModule(new GitHubModule())
                .build();
```

See [this example code](https://github.com/codepath/dagger2-example) for a working example.

#### Subcomponents
![Dagger subcomponents](https://raw.githubusercontent.com/codepath/android_guides/master/images/dagger_subcomponent.png)

Using subcomponents is another way to extend the object graph of a component.  Like components with dependencies, subcomponents have their own life-cycle and can be garbage collected when all references to the subcomponent are gone, and have the same scope restrictions.  One advantage in using this approach is that you do not need to define all the downstream components.  

Another major difference is that subcomponents simply need to be declared in the parent component.

Here's an example of using a subcomponent for an activity.  We annotate the class with a custom scope and the `@Subcomponent` annotation: 

```java
@MyActivityScope
@Subcomponent(modules={ MyActivityModule.class })
public interface MyActivitySubComponent {
    @Named("my_list") ArrayAdapter myListAdapter();
}
```

The module that will be used is defined below:

```java
@Module
public class MyActivityModule {
    private final MyActivity activity;

    // must be instantiated with an activity
    public MyActivityModule(MyActivity activity) { this.activity = activity; }
   
    @Provides @MyActivityScope @Named("my_list")
    public ArrayAdapter providesMyListAdapter() {
        return new ArrayAdapter<String>(activity, android.R.layout.my_list);
    }
    ...
}
```

Finally, in the **parent component**, we will define a factory method with the return value of the component and the dependencies needed to instantiate it:

```java
@Singleton
@Component(modules={ ... })
public interface MyApplicationComponent {
    // injection targets here

    // factory method to instantiate the subcomponent defined here (passing in the module instance)
    MyActivitySubComponent newMyActivitySubcomponent(MyActivityModule activityModule);
}
```

In the above example, a new instance of the subcomponent will be created every time that the `newMyActivitySubcomponent()` is called.  To use the submodule to inject an activity:

```java
public class MyActivity extends Activity {
  @Inject ArrayAdapter arrayAdapter;

  public void onCreate(Bundle savedInstance) {
        // assign singleton instances to fields
        // We need to cast to `MyApp` in order to get the right method
        ((MyApp) getApplication()).getApplicationComponent())
            .newMyActivitySubcomponent(new MyActivityModule(this))
            .inject(this);
    } 
}
```

#### Subcomponent Builders
*Available starting in v2.7*

![Dagger subcomponent builders](https://raw.githubusercontent.com/codepath/android_guides/master/images/subcomponent_builders.png)

Subcomponent builders allow the creator of the subcomponent to be de-coupled from the parent component, by removing the need to have a subcomponent factory method declared on that parent component.  

```java
@MyActivityScope
@Subcomponent(modules={ MyActivityModule.class })
public interface MyActivitySubComponent {
    ...
    @Subcomponent.Builder
    interface Builder extends SubcomponentBuilder<MyActivitySubComponent> {
        Builder activityModule(MyActivityModule module);
    }
}

public interface SubcomponentBuilder<V> {
    V build();
}
```

The subcomponent is declared as an inner interface in the subcomponent interface and it must include a `build()` method which the return type matching the subcomponent.  It's convenient to declare a base interface with this method, like `SubcomponentBuilder` above.  This new **builder must be added to the parent component graph** using a "binder" module with a "subcomponents" parameter:

```java
@Module(subcomponents={ MyActivitySubComponent.class })
public abstract class ApplicationBinders {
    // Provide the builder to be included in a mapping used for creating the builders.
    @Binds @IntoMap @SubcomponentKey(MyActivitySubComponent.Builder.class)
    public abstract SubcomponentBuilder myActivity(MyActivitySubComponent.Builder impl);
}

@Component(modules={..., ApplicationBinders.class})
public interface ApplicationComponent {
    // Returns a map with all the builders mapped by their class.
    Map<Class<?>, Provider<SubcomponentBuilder>> subcomponentBuilders();
}

// Needed only to to create the above mapping
@MapKey @Target({ElementType.METHOD}) @Retention(RetentionPolicy.RUNTIME)
public @interface SubcomponentKey {
    Class<?> value();
}
```

Once the builders are made available in the component graph, the activity can use it to create its subcomponent:

```java
public class MyActivity extends Activity {
  @Inject ArrayAdapter arrayAdapter;

  public void onCreate(Bundle savedInstance) {
        // assign singleton instances to fields
        // We need to cast to `MyApp` in order to get the right method
        MyActivitySubcomponent.Builder builder = (MyActivitySubcomponent.Builder)
            ((MyApp) getApplication()).getApplicationComponent())
            .subcomponentBuilders()
            .get(MyActivitySubcomponent.Builder.class)
            .get();
        builder.activityModule(new MyActivityModule(this)).build().inject(this);
    } 
}
```

## ProGuard

Dagger 2 should work out of box without ProGuard, but if you start seeing `library class dagger.producers.monitoring.internal.Monitors$1 extends or implements program class javax.inject.Provider`, make sure your Gradle configuration uses the `annotationProcessor` declaration instead of `provided`. 

## Troubleshooting

* If you are upgrading Dagger 2 versions (i.e. from v2.0 to v2.5), some of the generated code has changed.  If you are incorporating Dagger code that was generated with older versions, you may see `MemberInjector` and `actual and former argument lists different in length` errors.  Make sure to clean the entire project and verify that you have upgraded all versions to use the consistent version of Dagger 2.

## References

* [Dagger 2 Github Page](http://google.github.io/dagger/)
* [Sample project using Dagger 2](https://github.com/vinc3m1/nowdothis)
* [Vince Mi's Codepath Meetup Dagger 2 Slides](https://docs.google.com/presentation/d/1bkctcKjbLlpiI0Nj9v0QpCcNIiZBhVsJsJp1dgU5n98/)
* <http://code.tutsplus.com/tutorials/dependency-injection-with-dagger-2-on-android--cms-23345>
* [Jake Wharton's Devoxx Dagger 2 Slides](https://speakerdeck.com/jakewharton/dependency-injection-with-dagger-2-devoxx-2014)
* [Jake Wharton's Devoxx Dagger 2 Talk](https://www.parleys.com/tutorial/5471cdd1e4b065ebcfa1d557/)
* [Dagger 2 Google Developers Talk](https://www.youtube.com/watch?v=oK_XtfXPkqw)
* [Dagger 1 to Dagger 2](http://frogermcs.github.io/dagger-1-to-2-migration/)
* [Tasting Dagger 2 on Android](http://fernandocejas.com/2015/04/11/tasting-dagger-2-on-android/)
* [Dagger 2 Testing with Mockito](http://blog.sqisland.com/2015/04/dagger-2-espresso-2-mockito.html#sthash.IMzjLiVu.dpuf)
* [Snorkeling with Dagger 2](https://github.com/konmik/konmik.github.io/wiki/Snorkeling-with-Dagger-2) 
* [Dependency Injection in Java](https://www.objc.io/issues/11-android/dependency-injection-in-java/)
* [Component Dependency vs. Submodules in Dagger 2](http://jellybeanssir.blogspot.de/2015/05/component-dependency-vs-submodules-in.html)
* [Dagger 2 Component Scopes Test](https://github.com/joesteele/dagger2-component-scopes-test)
* [Advanced Dagger Talk](http://www.slideshare.net/nakhimovich/advanced-dagger-talk-from-360anDev)

---
> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
