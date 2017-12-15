> * 原文地址：[New Android Injector with Dagger 2 — part 1](https://medium.com/@iammert/new-android-injector-with-dagger-2-part-1-8baa60152abe)
> * 原文作者：[Mert Şimşek](https://medium.com/@iammert?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-1.md)
> * 译者：[MummyDing](https://github.com/MummyDing)
> * 校对者：

# Android Injector 和 Dagger 2  详解(一)

![](https://cdn-images-1.medium.com/max/2000/1*mUOY8duji6LKT9dKFpDvoA.jpeg)

- [New Android Injector with Dagger 2 — part 1](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-1.md)
- [New Android Injector with Dagger 2 — part 2](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-2.md)

Dagger 2.10 新增了 Android Support 和 Android Compiler 两大模块。对我们来说，本次改动非常之大，所有 Android 开发者都应尽快地将目光投向这个新的 Android 依赖注入框架。

在我开始介绍新的 AndroidInjector 类以及 Dagger 2.11 库之前，如果你对 Dagger 2 还不熟悉甚至之前根本没用过，那我强烈建议你先去看看 Dagger 入门指南，弄清楚什么是依赖注入。 为什么这么说呢？ 因为 Android Dagger 涉及到大量注解，学起来会比较吃力。在我看来，学Android Dagger 之前你最好先去学学 Dagger 2 和依赖注入。这里有一篇关于依赖注入的入门文章 [Blog 1](https://blog.mindorks.com/introduction-to-dagger-2-using-dependency-injection-in-android-part-1-223289c2a01b) 以及一篇关于 Dagger 2 的文章 [Blog 2](https://blog.mindorks.com/introduction-to-dagger-2-using-dependency-injection-in-android-part-2-b55857911bcd) 。

### 老用法

Dagger 2.10 之前，Dagger 2 是这样用的：

```java
((MyApplication) getApplication())        
.getAppComponent()        
.myActivity(new MyActivityModule(userId))       
.build()        
.inject(this);
```

这会有什么问题呢？ 我们想用依赖注入，但是依赖注入的核心原则是什么？

> **一个类不应该关心它是如何被注入的**

因此我们必须把这些 Builder 方法和 Module 实例创建部分去掉

### **示例工程**

我创建的[示例工程](https://github.com/iammert/dagger-android-injection/tree/master) 中没做什么，我想让它尽可能地简单。它里面包含 MainActivity 和 DetailActivity， 这两个Activity 都注入到了相应的Presenter实现类并且请求了网络接口(并不是真的发起了HTTP请求, 我只是写了一个**假方法**)。

### 准备工作

在 build.gradle中加入以下依赖：

```
compile 'com.google.dagger:dagger:2.11-rc2'
annotationProcessor 'com.google.dagger:dagger-compiler:2.11-rc2'
compile 'com.google.dagger:dagger-android-support:2.11-rc2'
```

### **工程包结构**

![](https://cdn-images-1.medium.com/max/600/1*DxXk2aFznom6sWQWwsjUpg.png)

AppComponent 类的头部添加了**@Component** 注解，Application 类利用 AppComponent 构建了一张图。当 AppComponent 构建 Module 的时候，我们将得到一张拥有所有相关实例的图。举个例子，当 App Module 提供了 ApiService，我们在构建带有App Module的 Component 时将会拥有 ApiService 实例。

If we want to attach our activity to dagger graph to get instances from ancestor, we simply create a **@Subcomponent** for it. In this case, DetailActivityComponent and MainActivityComponent classes are marked with **@Subcomponent** annotation. Then, last step we have to take, we need to tell ancestor about subcomponent info. So all subcomponents have to be known by its ancestor.

Don’t worry. I will explain @Subcomponent, @Component and what DispatchActivity means. I just wanted to give a warm welcome to you by component/subcomponent.

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

**@Component:** Component is a graph. We build a component. Component will provide injected instances by using **modules**.

**@Component.Builder:** We might want to bind some instance to Component. In this case we can create an interface with _@Component.Builder_ annotation and add whatever method we want to add to builder. In my case I wanted to add Application to my _AppComponent_.

> Note: If you want to create a **Builder** for your **Component**, your **Builder** interface has to has a **build();** method which returns your **Component**.

#### Inject Into AppComponent

```
DaggerAppComponent
        ._builder_()
        **.application(this)**
        .build()
        .inject(this);
```

As you see from code, we can bind our application instance to our Dagger graph.

I think we understood the concept behind @Component.Builder and @Component. Now I want to give skeleton structure of our project.

### Component/Module Skeleton

We can think apps in three layer while using Dagger.

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

Android apps have one application class. That is why we have one application component. This component is responsible for providing application scope instances (eg. OkHttp, Database, SharedPrefs.). This Component is root of our dagger graph. Application component is providing 3 module in our app.

* **AndroidInjectionModule** : We didn’t create this. It is an internal class in Dagger 2.10\. Provides our activities and fragments with given module.
* **ActivityBuilder** : We created this module. This is a given module to dagger. We map all our activities here. And Dagger know our activities in compile time. In our app we have Main and Detail activity. So we map both activities here.

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

* **AppModule:** We provide retrofit, okhttp, persistence db, shared pref etc here. There is an important detail here. We have to add our subcomponents to AppModule. So our dagger graph will undestand that.

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

We have 2 activity here. MainActivity and DetailActivity. They both have module and they both have component. But they are subcomponents like we define in AppModule above.

* **MainActivityComponent:** This component is just a bridge to MainActivityModule. But here is an important change here. We don’t add inject() and build() method to this component. MainActivityComponent has these methods from ancestor class. AndroidInjector class is new dagger-android class which exist in dagger-android framework.

```
@Subcomponent(modules = MainActivityModule.class)
public interface MainActivityComponent extends AndroidInjector<MainActivity>{
    @Subcomponent.Builder
    abstract class Builder extends AndroidInjector.Builder<MainActivity>{}
}
```

* **MainActivityModule:** This module provides main activity related instances (eg. MainActivityPresenter). Did you see provideMainView() method takes MainActivity as parameter? Yes. We create our MainActivityComponent with our <MainActivity> class. So dagger will attach our activity to it’s graph. So we can use it because it is on the graph.

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

We can create DetailActivityComponent and DetailActivityModule just like MainActivityComponent/MainActivityModule. I will skip this for that reason.

#### Fragment Components

Let say we have couple fragments in our DetailActivity. What will we do in that case? Actually it is not hard to guess. Lets think our Activity and Application relationship. Application knows Activities with a mapping module(ActivityBuilder in my sample). And we add our activities to AppModule as subcomponent.

Same relationship between Activity and its Fragments. We will create a FragmentBuilder module and add as module to DetailActivityComponent.

Now we can create DetailFragmentComponent and DetailFragmentModule just like we did in MainActivityComponent and MainActivityModule.

### DispatchingAndroidInjector<T>

Last thing we have to do is injecting into Injector. What is the reason of This injector. I want to give you simplified code because It explains itself.

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

Application has activities. That is why we implement **_HasActivityInjector_** interface. So Activities have fragments? Do I mean that we have to implement HasFragmentInjector in our activities? Yes! That’s exactly what I mean.

```
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

If you don’t have child fragment and don’t inject anything in your fragments, then you don’t need to implement **_HasSupportFragmentInjector._ **But in our case we want to create DetailFragment in our DetailActivity.

### AndroidInjection.inject(this)

Why is all jobs for? Because Activity and Fragment should not know about how it is injected. So how do we inject now?

In Activity

```
@Override
protected void onCreate(Bundle savedInstanceState) {
 **AndroidInjection._inject_(this);**
    super.onCreate(savedInstanceState);
}
```

In Fragment

```
@Override
public void onAttach(Context context) {
    **AndroidSupportInjection._inject_(this);
   ** super.onAttach(context);
}
```

Yes! Congratulations. It is all done.

I know it is a bit complicated. And I think learning curve is really hard. But we have reached our goal. Now, Our classes don’t know about how it is injected. We can inject into our provided instances by using _@Inject_ annotation in our UI elements.

You can find this project on my github page. And I suggest you to check dagger 2 official doc.

[**iammert/dagger-android-injection**
_dagger-android-injection - Sample project explains Dependency Injection in Android using dagger-android framework._github.com](https://github.com/iammert/dagger-android-injection/tree/master)

[**Dagger ‡ _A fast dependency injector for Android and Java._**
A fast dependency injector for Android and Java.google.github.io](https://google.github.io/dagger//users-guide.html)

In part 2 , I want to simplify android-dagger injection by using some new annotation which is provided by dagger. But I wanted to show you pure version before I simplify it.

Part 2 is ready [here](https://medium.com/@iammert/new-android-injector-with-dagger-2-part-2-4af05fd783d0).

Thanks for reading. Happy coding.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
