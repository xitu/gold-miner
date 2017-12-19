> * 原文地址：[New Android Injector with Dagger 2 — part 3](https://android.jlelse.eu/new-android-injector-with-dagger-2-part-3-fe3924df6a89)
> * 原文作者：[Mert Şimşek](https://android.jlelse.eu/@iammert?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/.md](https://github.com/xitu/gold-miner/blob/master/TODO/.md)
> * 译者：
> * 校对者：

# New Android Injector with Dagger 2 — part 3

If you didn’t read part 1 and part 2, I suggest you to read them first. You can find links at the bottom.

#### TLDR;

You can use **DaggerActivity**, **DaggerFragment**, **DaggerApplication** to reduce boilerplate in your Activity/Fragment/Application.

Also you can use **AndroidInjector<T>** in your dagger components to reduce boilerplate too.

### DaggerAppCompatActivity and DaggerFragment

Remember that we call **AndroidInjection.inject()** every activity or fragment that we wanted to use dagger. And also, If you want to use Injection in your fragment, you should also implement **HasSupportFragmentInject** interface and override fragment **injector** in your activity.

Recently, I moved that code to my base activity and base fragment. Why should I need to declare that for every single activity? I think moving them to base class is acceptable.

Then I see some classes in dagger project while researching, **DaggerAppCompatActivity** and **DaggerFragment**. These classes does exactly what I did. Android loves inheritance. So we can pretend it like we love that too 😛

Let’s see what is happening inside these library classes.

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

DaggerAppCompatActivity

Nothing different actually. We can reduce boilerplate code in our activity by extending our activity from **DaggerAppCompatActivity**.

Our **DetailActivity** class was like following;

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

Let’s extend it from **DaggerAppCompatActivity** and remove **HasSupportFragmentInjector** and overrided method from our activity.

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

Now, It is better.

### DaggerApplication, AndroidInjector, AndroidSupportInjectionModule

Let’s see what else we can do to reduce boilerplate code. **AndroidInjector** helps us to simplify our **App Component**. You can check **AndroidInjector** documentation from [here](https://google.github.io/dagger/api/2.10/dagger/android/AndroidInjector.html).

Let’s see our app component and application class.

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

**_build()_** and **_seedInstance()_** is already defined in **_AndroidInjector.Builder_ **class. So we can get rid of them and extend our _Builder_ from **_AndroidInjection.Builder<Application>_**.

And also, _AndroidInjector_ interface has **_inject()_** method in it. So we can remove _inject()_ method and extend our _AppComponent_ interface from **_AndroidInjector<Application>_**

So, our updated and boilerplate-reduced AppComponent interface will be look like following

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

Did you realise that we changed our modules too. I removed **_AndroidInjectionModule.class_** in component modules and added **_AndroidSupportInjectionModule.class_**. This is added because we used support Fragment. _AndroidInjectionModule_ binds your _app.Fragment_ to dagger. But If you want to use injection in _v4.fragment_ then you should add _AndroidSupportInjectionModule.class_ to your AppComponent modules.

We changed to way we inject into our AppComponent. So let’s see what is changed in our Application class.

Just like in the DaggerActivity and DaggerFragment, we also need to extend our Application class from DaggerApplication.

Our Application class was look like following;

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

We changed it to..

```
public class AndroidSampleApp extends DaggerApplication {

    @Override
    protected AndroidInjector<? extends AndroidSampleApp> applicationInjector() {
        return DaggerAppComponent.builder().create(this);
    }
}
```

### Source

You can find this simplified implementation as a branch in [my github page](http://github.com/iammert). I am not merging that into master because I want to show the old school way to use dagger in every branch. So readers can follow up a road from old-school way to simplified way.

- [**iammert/dagger-android-injection**
dagger-android-injection - Sample project explains Dependency Injection in Android using dagger-android framework.](https://github.com/iammert/dagger-android-injection)

- [**New Android Injector with Dagger 2 — part 1**
Dagger 2.10 released with android support module and android compiler. I think this was a huge change for us and all…](https://medium.com/@iammert/new-android-injector-with-dagger-2-part-1-8baa60152abe)

- [**New Android Injector with Dagger 2 — part 2**
I tried to explain dagger-android injection in my previous blogpost. I got some review and people say that it is too…](https://medium.com/@iammert/new-android-injector-with-dagger-2-part-2-4af05fd783d0)

### PS.

I am not saying this is the “best practice”. This is just the way I implement dagger to my projects. So You can keep your dagger implementation as is. Maybe you don’t want to put some third party implementation to your application class hierarchy. It is up to the developer. I am open for any suggestion and please don’t hesitate to comment!


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
