> * 原文地址：[New Android Injector with Dagger 2 — part 1](https://medium.com/@iammert/new-android-injector-with-dagger-2-part-1-8baa60152abe)
> * 原文作者：[Mert Şimşek](https://medium.com/@iammert?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-1.md)
> * 译者：[MummyDing](https://github.com/MummyDing)
> * 校对者：[LeviDing](https://github.com/leviding)

# 全新 Android 注入器：Dagger 2（一）

![](https://cdn-images-1.medium.com/max/2000/1*mUOY8duji6LKT9dKFpDvoA.jpeg)

- [New Android Injector with Dagger 2 — part 1](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-1.md)
- [New Android Injector with Dagger 2 — part 2](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-2.md)
- [New Android Injector with Dagger 2 — part 3](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-3.md)

Dagger 2.10 新增了 Android Support 和 Android Compiler 两大模块。对我们来说，本次改动非常之大，所有 Android 开发者都应尽早尝试使用这个新的 Android 依赖注入框架。

在我开始介绍新的 AndroidInjector 类以及 Dagger 2.11 库之前，如果你对 Dagger 2 还不熟悉甚至之前根本没用过，那我强烈建议你先去看看 Dagger 入门指南，弄清楚什么是依赖注入。为什么这么说呢？因为 Android Dagger 涉及到大量注解，学起来会比较吃力。在我看来，学 Android Dagger 之前你最好先去学学 Dagger 2 和依赖注入。这里有一篇关于依赖注入的入门文章 [Blog 1](https://blog.mindorks.com/introduction-to-dagger-2-using-dependency-injection-in-android-part-1-223289c2a01b) 以及一篇关于 Dagger 2 的文章 [Blog 2](https://blog.mindorks.com/introduction-to-dagger-2-using-dependency-injection-in-android-part-2-b55857911bcd)。

### 老用法

Dagger 2.10 之前，Dagger 2 是这样用的：

```java
((MyApplication) getApplication())        
.getAppComponent()        
.myActivity(new MyActivityModule(userId))       
.build()        
.inject(this);
```

这会有什么问题呢？我们想用依赖注入，但是依赖注入的核心原则是什么？

> **一个类不应该关心它是如何被注入的**

因此我们必须把这些 Builder 方法和 Module 实例创建部分去掉。

### **示例工程**

我创建的[示例工程](https://github.com/iammert/dagger-android-injection/tree/master)中没做什么，我想让它尽可能地简单。它里面仅包含 `MainActivity` 和 `DetailActivity` 两个 Activity，它们都注入到了相应的 Presenter 实现类并且请求了网络接口（并不是真的发起了 HTTP 请求，我只是写了一个**假方法**）。

### 准备工作

在 build.gradle 中加入以下依赖：

```
compile 'com.google.dagger:dagger:2.11-rc2'
annotationProcessor 'com.google.dagger:dagger-compiler:2.11-rc2'
compile 'com.google.dagger:dagger-android-support:2.11-rc2'
```

### **工程包结构**

![](https://cdn-images-1.medium.com/max/600/1*DxXk2aFznom6sWQWwsjUpg.png)

`Application` 类利用 `AppComponent` 构建了一张图谱。`AppComponent` 类的头部都被加上 **@Component** 注解，当 `AppComponent` 利用它的 Module 进行构建的时候，我们将得到一张拥有所有所需实例对象的图谱。举个例子，当 App Module 提供了` ApiService`，我们在构建拥有 App Module 的 Component 时将会得到 `ApiService` 实例对象。

如果我们想将 Activity 加入到 Dagger 图谱中从而能够直接从父 Compponent 直接获取所需实例，我们只需简单地将 Activity 加上 **@Subcomponent** 注解即可。在我们的示例中，`DetailActivityComponent` 和 `MainActivityComponent` 类都被加上了 **@Subcomponent** 注解。最后我们还有一个必需步骤，我们需要告诉父 Component 相关的子 Component 信息，因此所有的根 Compponent 都能知道它所有的子 Component。

先别着急，我后面会解释 **@Subcomponent**，**@Component** 以及 `DispatchActivity` 都是什么的。现在只是想让你对 **@Component** 和 **@Subcomponent** 有一个大概了解。

#### **@Component and @Component.Builder**

```
**@Component**(modules = {
        AndroidInjectionModule.class,
        AppModule.class,
        ActivityBuilder.class})
public interface AppComponent {

    **@Component.Builder**
    interface Builder {
        **@BindsInstance** _Builder application(Application application);_
        _AppComponent build();_
    }

    void inject(AndroidSampleApp app);
}
```

**@Component：**Component 是一个图谱。当我们构建一个 Component时，Component 将利用 **Module** 提供被注入的实例对象。

**@Component.Builder：**我们可能需要绑定一些实例对象到 Component 中，这种情况我们可以通过创建一个带 **@Component.Builder** 注解的接口，然后就可以向 builder 中任意添加我们想要的方法。在我的示例中，我想将 `Application` 加入到 `AppComponent`中。

> 注意：如果你想为你的 **Component** 创建一个 Builder，那你的 Builder 接口中需要有一个返回类型为你所创建的 Component 的 `builder()` 方法。

#### 注入 AppComponent

```
DaggerAppComponent
        ._builder_()
        **.application(this)**
        .build()
        .inject(this);
```

从上面的代码可以看出，我们将 Application 实例绑定到了 Dagger 图谱中。

我想大家已经对 **@Component.Builder** 和 **@Component** 有了一定的认识，下面我想说说工程的结构。

### Component/Module 结构

使用 Dagger 的时候我们可以将 App 分为三层：

* Application Component
* Activity Components
* Fragment Components

#### **Application Component**

```
@Component(modules = {
        AndroidInjectionModule.class,
        AppModule.class,
        ActivityBuilder.class})
public interface AppComponent {

    @Component.Builder
    interface Builder {
        @BindsInstance Builder application(Application application);
        AppComponent build();
    }

    void inject(AndroidSampleApp app);
}
```

每个 Android 应用都有一个 `Application` 类，这就是为什么我也有一个 **Application Component** 的原因。这个 Component 表示是为应用层面提供实例的 （例如 OkHttp, Database, SharedPrefs）。这个 Component 是 Dagger 图谱的根，在我们的应用中 **Application Component** 提供了三个 **Module**。

* **AndroidInjectionModule**：这个类不是我们写的，它是 Dagger 2.10 中的一个内部类，通过给定的 **Module** 为我们提供了 Activity 和 Fragment。
* **ActivityBuilder**：我们自己创建的 **Module**，这个 **Module** 是给 Dagger 用的，我们将所有的 Activity 映射都放在了这里。Dagger 在编译期间能获取到所有的 Activity，我们的 App 中有 MainActivity 和 DetailActivity 两个 Activity，因此我将这两个 Activity 都放在这里。

```
@Module
public abstract class ActivityBuilder {

    @Binds
    @IntoMap
    @ActivityKey(MainActivity.class)
    abstract AndroidInjector.Factory<? extends Activity> bindMainActivity(MainActivityComponent.Builder builder);

    @Binds
    @IntoMap
    @ActivityKey(DetailActivity.class)
    abstract AndroidInjector.Factory<? extends Activity> bindDetailActivity(DetailActivityComponent.Builder builder);

}
```

* **AppModule**：我们在这里提供了 retrofit、okhttp、持久化数据库、SharedPrefs。其中有一个很重要的细节，我们必须将子 **Component** 加入到 AppModule 中，这样 Dagger 图谱才能识别。

```
@Module(subcomponents = {
        MainActivityComponent.class,
        DetailActivityComponent.class})
public class AppModule {

    @Provides
    @Singleton
    Context provideContext(Application application) {
        return application;
    }

}
```

#### Activity Components

我们有两个 Activity：`MainActivity` and `DetailActivity`。它们都拥有自己的 **Module** 和 **Component**，但是它们与我在上面 `AppModule` 中定义的一样，也是子 **Component**。

* **MainActivityComponent**：这个 **Component** 是连接 MainActivityModule 的桥梁，但是有一个很关键的不同点就是不需要在 **Component** 中添加 inject() 和 build() 方法。MainActivityComponent 会从父类中集成这些方法。AndroidInjector 类是 dagger-android 框架中新增的。

```
@Subcomponent(modules = MainActivityModule.class)
public interface MainActivityComponent extends AndroidInjector<MainActivity>{
    @Subcomponent.Builder
    abstract class Builder extends AndroidInjector.Builder<MainActivity>{}
}
```

* **MainActivityModule**：这个 **Module** 为 `MainActivity` 提供了相关实例对象（例如 `MainActivityPresenter`）。你注意到 provideMainView() 方法将 MainActivity 作为参数了吗？没错，我们利用 MainActivityComponent 创建了我们所需的对象。因此 Dagger 将我们的 Activity 加入到 图谱中并因此能使用它。

```
@Module
public class MainActivityModule {

    @Provides
    MainView provideMainView(MainActivity mainActivity){
        return mainActivity;
    }

    @Provides
    MainPresenter provideMainPresenter(MainView mainView, ApiService apiService){
        return new MainPresenterImpl(mainView, apiService);
    }
}
```

同样的，我们可以像创建 `MainActivityComponent` 和 `MainActivityModule` 一样创建 `DetailActivityComponent` 和 `DetailActivityModule`，因此具体步骤就略过了。

#### Fragment Components

如果在 `DetailActivity` 中有两个 Fragment，那我们应该怎么办呢？实际上这一点都不难想到。先想想 Activity 和 Application 之间的关系，Application 通过映射的 Module（在我的示例中就是ActivityBuilder）知道所有的 Activity，并且将所有的 Activity 作为子 Component 加入到 AppModule 中。

Activity 和 Fragment 也是如此，首先创建一个 FragmentBuilder Module 加入到 DetailActivityComponent 中。

现在我们就可以像之前创建 `MainActivityComponent` 和 `MainActivityModule` 一样来创建 `DetailFragmentComponent` 和 `DetailFragmentModule`了。

### DispatchingAndroidInjector<T>

最后我们需要做的便是注入到注入器中。注入器的作用是什么？我想用一段简单的代码解释下。

```
public class AndroidSampleApp extends Application implements HasActivityInjector {

    @Inject
    DispatchingAndroidInjector<Activity> activityDispatchingAndroidInjector;

    @Override
    public void onCreate() {
        super.onCreate();
        //simplified
    }

    @Override
    public DispatchingAndroidInjector<Activity> activityInjector() {
        return activityDispatchingAndroidInjector;
    }
}
```

Application 拥有很多 Activity，这就是我们实现 **_HasActivityInjector_** 接口的原因。那 Activity 有多个 Fragment 呢？意思是我们需要在 Activity 中实现 HasFragmentInjector 接口吗？没错，我就是这个意思！

```java
public class DetailActivity extends AppCompatActivity implements HasSupportFragmentInjector {

    @Inject
    DispatchingAndroidInjector<Fragment> fragmentDispatchingAndroidInjector;

    //simplified
  
    @Override
    public AndroidInjector<Fragment> supportFragmentInjector() {
        return fragmentDispatchingAndroidInjector;
    }
}
```

如果你没有子 Fragment 你不需要注入任何东西到 Fragment，那你也不需要实现 **_HasSupportFragmentInjector_** 接口了。但是在我们的示例中需要在 `DetailActivity` 创建一个 `DetailFragment`。

### AndroidInjection.inject(this)

做这些都是为了什么？这是因为 Activity 和 Fragment 都不应该是如何被注入的，那我们应该如何注入呢？

在 Activity 中：

```
@Override
protected void onCreate(Bundle savedInstanceState) {
 **AndroidInjection._inject_(this);**
    super.onCreate(savedInstanceState);
}
```

在 Fragment 中：

```
@Override
public void onAttach(Context context) {
    **AndroidSupportInjection._inject_(this);
   ** super.onAttach(context);
}
```

没错，恭喜你，所有工作都完成了！

我知道这有点复杂，学习曲线很陡峭，但是我们还是达到目的了。现在，我们的类是不知道如何被注入的。我们可以将所需实例对象通过 **_@Inject_ annotation** 注解注入到我们的 UI 元素。

你可以在我的 GitHub 主页找到这个工程，我建议你对照着 Dagger 2 的官方文档看。

[**iammert/dagger-android-injection** 
_dagger-android-injection - Sample project explains Dependency Injection in Android using dagger-android framework._github.com](https://github.com/iammert/dagger-android-injection/tree/master)

[**Dagger ‡ _A fast dependency injector for Android and Java._**
A fast dependency injector for Android and Java.google.github.io](https://google.github.io/dagger//users-guide.html)

在第二部分，我想利用 Dagger 提供的新注解来简化 android-dagger 注入，但是在简化之前我想先给大家看看它原来的样子。

第二部分在[这里](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-2.md)了。

感谢阅读，祝你编码愉快！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
