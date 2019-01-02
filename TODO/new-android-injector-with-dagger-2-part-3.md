> * 原文地址：[New Android Injector with Dagger 2 — part 3](https://android.jlelse.eu/new-android-injector-with-dagger-2-part-3-fe3924df6a89)
> * 原文作者：[Mert Şimşek](https://android.jlelse.eu/@iammert?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-3.md](https://github.com/xitu/gold-miner/blob/master/TODO/new-android-injector-with-dagger-2-part-3.md)
> * 译者：[woitaylor](https://github.com/woitaylor)
> * 校对者：[corresponding](https://github.com/corresponding) [shengye102](https://github.com/shengye102)

# 全新 Android 注入器 : Dagger 2（三）

如果你还没有阅读（一）和（二），我建议你先阅读它们。


- [全新 Android 注入器 : Dagger 2 （一）](https://juejin.im/post/5a39f26df265da4324809685)
- [全新 Android 注入器 : Dagger 2 （二）](https://juejin.im/post/5a3a1883f265da4321542fc1)

#### 概要

你可以使用 `DaggerActivity`，`DaggerFragment`，`DaggerApplication` 来减少 `Activity/Fragment/Application` 类里面的模板代码。

同样的，在 `dagger` 的 `component` 中，你也可以通过 `AndroidInjector<T>` 去减少模板代码。

### DaggerAppCompatActivity and DaggerFragment

在使用 `dagger` 的 `fragment` 或者 `activity` 中要记得调用 `AndroidInjection.inject()` 方法。
同样的，如果你想要在 `v4` 包里面的 `fragment` 中使用 `Injection`，你应该让你的 `activity` 实现 `HasSupportFragmentInject` 接口并且重写 `fragmentInjector` 方法。

最近，我把这些相关代码移到 `BaseActivity` 和 `BaseFragment`。因为与其在每个 `activity` 中声明这些，还不如把共同的代码放到基类里面。

于是我在研究 `dagger` 项目的时候发现 `DaggerAppCompatActivity` 、`DaggerFragment` 这些类正好是我所需要的。如果说 `Android` 喜欢继承，那么我们也可以假装喜欢继承 😛

让我们看看这些类做了些神马。

```
@Beta
public abstract class DaggerAppCompatActivity extends AppCompatActivity
    implements HasFragmentInjector, HasSupportFragmentInjector {

  @Inject DispatchingAndroidInjector<Fragment> supportFragmentInjector;
  @Inject DispatchingAndroidInjector<android.app.Fragment> frameworkFragmentInjector;

  @Override
  protected void onCreate(@Nullable Bundle savedInstanceState) {
    AndroidInjection.inject(this);
    super.onCreate(savedInstanceState);
  }

  @Override
  public AndroidInjector<Fragment> supportFragmentInjector() {
    return supportFragmentInjector;
  }

  @Override
  public AndroidInjector<android.app.Fragment> fragmentInjector() {
    return frameworkFragmentInjector;
  }
}
```

从上面的代码可以看出 `DaggerAppCompatActivity` 跟我们自己写的 `Activity` 并没有多大的区别，所以可以让我们的 `Activity` 以继承 `DaggerAppCompatActivity` 的方式来减少模板代码。

`DetailActivity` 类如下：

```
public class DetailActivity extends AppCompatActivity implements HasSupportFragmentInjector, DetailView {

    @Inject
    DispatchingAndroidInjector<Fragment> fragmentDispatchingAndroidInjector;

    @Inject
    DetailPresenter detailPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        AndroidInjection.inject(this);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);
    }

    @Override
    public void onDetailLoaded() {}

    @Override
    public AndroidInjector<Fragment> supportFragmentInjector() {
        return fragmentDispatchingAndroidInjector;
    }
}
```

让我们的 `DetailActivity` 继承 `DaggerAppCompatActivity` 类，这样我们就不用让 `DetailActivity` 类实现 `HasSupportFragmentInjector` 接口以及重写方法了。

```
public class DetailActivity extends DaggerAppCompatActivity implements DetailView {

    @Inject
    DetailPresenter detailPresenter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_detail);
    }

    @Override
    public void onDetailLoaded() {}
}
```

现在，是不是更简洁了。

### DaggerApplication, AndroidInjector, AndroidSupportInjectionModule

看看还有哪些办法能够减少模板代码。我发现 `AndroidInjector` 能够帮助简化 `AppComponent`。你可以通过阅读 `AndroidInjector` 相关[文档](https://google.github.io/dagger/api/2.10/dagger/android/AndroidInjector.html)来获取相关信息。

下面是 `AppComponent` 类的代码。

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

`build()` 和 `seedInstance()` 方法已经在 `AndroidInjector.Builder` 抽象类中定义了，所以我们的 `Builder` 类可以通过继承 `AndroidInjection.Builder<Application>` 来去掉上面代码中 `application()` 和 `build()` 这两个方法。

同样的，`AndroidInjector` 接口中已经有 `inject()` 方法了。所以我们可以通过继承 `AndroidInjector<Application>` 接口（接口是可以继承接口的）来删除 `inject()` 方法。

那么我们简化后的 `AppComponent` 接口的代码如下：

```
@Component(modules = {
        AndroidSupportInjectionModule.class,
        AppModule.class,
        ActivityBuilder.class})
interface AppComponent extends AndroidInjector<AndroidSampleApp> {
    @Component.Builder
    abstract class Builder extends AndroidInjector.Builder<AndroidSampleApp> {}
}
```

你有没有意识到我们的 `modules` 属性也改变了？我从 `@Component` 注解的 `modules` 属性中移除了 `AndroidInjectionModule.class` 并且添加了 `AndroidSupportInjectionModule.class`。这是因为我们使用的是支持库（v4库）的 `Fragment`。而 `AndroidInjectionModule` 是用来绑定 `app` 包的 `Fragment` 到 `dagger`。所以如果你想在 `v4.fragment` 中使用注入，那么你应该在你的 `AppComponent modules` 中添加 `AndroidSupportInjectionModule.class`。

我们改变了 `AppComponent` 的注入方式。那么 `Application` 类需要做什么改变。

跟 `DaggerActivity` 和 `DaggerFragment` 一样，我们也让 `Application` 类继承 `DaggerApplication` 类。

之前的 `Application` 类的代码如下：

```
public class AndroidSampleApp extends Application implements HasActivityInjector {

    @Inject
    DispatchingAndroidInjector<Activity> activityDispatchingAndroidInjector;

    @Override
    public void onCreate() {
        super.onCreate();
        DaggerAppComponent
                .builder()
                .application(this)
                .build()
                .inject(this);
    }

    @Override
    public DispatchingAndroidInjector<Activity> activityInjector() {
        return activityDispatchingAndroidInjector;
    }
}
```

修改后代码如下:

```
public class AndroidSampleApp extends DaggerApplication {

    @Override
    protected AndroidInjector<? extends AndroidSampleApp> applicationInjector() {
        return DaggerAppComponent.builder().create(this);
    }
}
```

### 源码

你可以从我的 [GitHub](http://github.com/iammert) 上获取修改后的源码。我没有把这些代码 `merge` 到主分支上，是因为我想在各个分支中保存 `dagger` 使用方式的历史记录。这样读者们就能够知道我是如何一步步简化 `dagger` 的使用方式。

- [Demo](https://github.com/iammert/dagger-android-injection)

### PS.

我并不是说这是 `dagger` 的最优美的实践方式。这只是我在自己项目中使用 `dagger` 的方式。如果喜欢的话，你也可以在自己的项目中这样使用。如果你实在不想让自己的 `Application` 类继承第三方的 `Application` 类就别这样使用，你高兴就好。最后，如果你们有更好的建议还请多多指教。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
