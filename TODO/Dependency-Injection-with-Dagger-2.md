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

注意，方法名称（比如 `provideGson()`, `provideRetrofit()` 等）是没关系的，可以任意设置。 用 `@Provides` decorator is used to associate this instantiation with any other modules of the same type.  The `@Singleton` annotation is used to declare to Dagger to be only initialized only once during the entire lifecycle of the application.  

A `Retrofit` instance depends both on a `Gson` and `OkHttpClient` instance, so we can define another method within the same class that takes these two types.  The `@Provides` annotation and these two parameters in the method will cause Dagger to recognize that there is a dependency on `Gson` and `OkHttpClient` to build a `Retrofit` instance.

#### Define injection targets

Dagger provides a way for the fields in your activities, fragments, or services to be assigned references simply by annotating the fields with an `@Inject` annotation and calling an `inject()` method.  Calling `inject()` will cause Dagger 2 to locate the singletons in the dependency graph to try to find a matching return type.  If it finds one, it assigns the references to the respective fields. For instance, in the example below, it will attempt to find a provider that returns `MyTwitterApiClient` and a `SharedPreferences` type:

```java
public class MainActivity extends Activity {
   @Inject MyTwitterApiClient mTwitterApiClient;
   @Inject SharedPreferences sharedPreferences;

  public void onCreate(Bundle savedInstance) {
       // assign singleton instances to fields
       InjectorClass.inject(this);
   } 
```

The injector class used in Dagger 2 is called a **component**.  It assigns references in our activities, services, or fragments to have access to singletons we earlier defined.  We will need to annotate this class with a `@Component` declaration. Note that the activities, services, or fragments that can be added should be declared in this class with individual `inject()` methods: 


```java
@Singleton
@Component(modules={AppModule.class, NetModule.class})
public interface NetComponent {
   void inject(MainActivity activity);
   // void inject(MyFragment fragment);
   // void inject(MyService service);
}
```

**Note** that base classes are not sufficient as injection targets.  Dagger 2 relies on strongly typed classes, so you must specify explicitly which ones should be defined.   (There are [suggestions](https://blog.gouline.net/2015/05/04/dagger-2-even-sharper-less-square/) to workaround the issue, but the code to do so may be more complicated to trace than simply defining them.)

#### Code generation

An important aspect of Dagger 2 is that the library generates code for classes annotated with the `@Component` interface.  You can use a class prefixed with `Dagger` (i.e. `DaggerTwitterApiComponent.java`) that will be responsible for instantiating an instance of our dependency graph and using it to perform the injection work for fields annotated with `@Inject`.  See the [[setup guide|Dependency-Injection-with-Dagger-2#setup]].
### Instantiating the component

We should do all this work within an `Application` class since these instances should be declared only once throughout the entire lifespan of the application:

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

Make sure to rebuild the project (in Android Studio, select _Build > Rebuild Project_) if you cannot reference the Dagger component.

Because we are overriding the default `Application` class, we also modify the application  `name` to launch `MyApp`.  This way your application will use this application class to handle the initial instantiation.

```xml
<application
      android:allowBackup="true"
      android:name=".MyApp">
```

Within our activity, we simply need to get access to these components and call `inject()`.  

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
 
### Qualified types
![Dagger Qualifiers](https://raw.githubusercontent.com/codepath/android_guides/master/images/dagger_qualifiers.png)

If we need two different objects of the same return type, we can use the `@Named` qualifier annotation.  You will define it both where you provide the singletons (`@Provides` annotation), and where you inject them (`@Inject` annotations):

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

Injection will also require these named annotations too:

```java
@Inject @Named("cached") OkHttpClient client;
@Inject @Named("non_cached") OkHttpClient client2;
```

`@Named` is a qualifier that is pre-defined by dagger, but you can create your own qualifier annotations as well:

```java
@Qualifier
@Documented
@Retention(RUNTIME)
public @interface DefaultPreferences {
}
```

### Scopes
![Dagger Scopes](https://raw.githubusercontent.com/codepath/android_guides/master/images/dagger_scopes.png)

In Dagger 2, you can define how components should be encapsulated by defining custom scopes.  For instance, you can create a scope that only lasts the duration of an activity or fragment lifecycle.  You can create a scope that maps only to a user authenticated session.  You can define any number of custom scope annotations in your application by declaring them as a public `@interface`:

```java
@Scope
@Documented
@Retention(value=RetentionPolicy.RUNTIME)
public @interface MyActivityScope
{
}
```

Even though Dagger 2 does not rely on the annotation at runtime, keeping the `RetentionPolicy` at RUNTIME is useful in allowing you to inspect your modules later.

### Dependent Components vs. Subcomponents

Leveraging scopes allows us to create either **dependent components** or **subcomponents**.  The example above showed that we used the `@Singleton` notation that lasted the entire lifecycle of the application. We also relied on one major Dagger component.  

If we wish to have multiple components that do not need to remain in memory all the time (i.e. components that are tied to the lifecycle of an activity or fragment, or even tied to when a user is signed-in), we can create dependent components or subcomponents.  In either case, each provide a way of encapsulating your code. We'll see how to use both in the next section. 

There are several considerations when using these approaches:

  * **Dependent components require the parent component to explicitly list out what dependencies can be injected downstream, while subcomponents do not.**   For parent components, you would need to expose to the downstream component by specifying the type and a method:

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

   If you forget to add this line, you will likely to see an error about an injection target missing.  Similar to how private/public variables are managed, using a parent component allows more explicit control and better encapsulation, but using subcomponents makes dependency injection easier to manage at the expense of less encapsulation. 

  * **Two dependent components cannot share the same scope.**  For instance, two components cannot both be scoped to a `@Singleton` annotation.  This restriction is imposed because of reasons described [here](https://github.com/google/dagger/issues/107#issuecomment-71073298).  Dependent components need to define their own scope.

  * **While Dagger 2 also enables the ability to create scoped instances, the responsibility rests on you to create and delete references that are consistent with the intended behavior.**  Dagger 2 does not know anything about the underlying implementation.  See this Stack Overflow [discussion](http://stackoverflow.com/questions/28411352/what-determines-the-lifecycle-of-a-component-object-graph-in-dagger-2) for more details.

#### Dependent Components

![Dagger Component Dependencies](https://raw.githubusercontent.com/codepath/android_guides/master/images/dagger_dependency.png)

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
