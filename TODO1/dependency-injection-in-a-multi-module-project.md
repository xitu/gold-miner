> * 原文地址：[Dependency injection in a multi module project](https://medium.com/androiddevelopers/dependency-injection-in-a-multi-module-project-1a09511c14b7)
> * 原文作者：[Ben Weiss](https://medium.com/@keyboardsurfer)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dependency-injection-in-a-multi-module-project.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dependency-injection-in-a-multi-module-project.md)
> * 译者：
> * 校对者：

# Dependency injection in a multi module project

### What we learned from introducing a DI framework to Plaid

![Illustrated by [Virginia Poltrack](https://twitter.com/vpoltrack)](https://cdn-images-1.medium.com/max/3200/0*yWf1DFEnYBWNmAvT)

This is not an article about dependency injection in general or about why we picked library X over Y.
Instead this post covers key takeaways of our efforts to modularize [Plaid](https://github.com/nickbutcher/plaid) from a dependency injection perspective.

## Our setup

In a previous post I wrote about the overall modularization story of Plaid.
[**A patchwork Plaid — Monolith to modularized app: How and why we modularized Plaid and what’s to come**](https://medium.com/androiddevelopers/a-patchwork-plaid-monolith-to-modularized-app-60235d9f212e)

Let me quickly recap what Plaid looks like from a bird’s eye view.

We have an `app` module, which contains the main launcher activity. Also there are several dynamic feature modules (DFM) which depend on the `app` module. Each DFM contains at least one activity, code and resources related to only the feature in question.

The `app` module depends on a `core` module which contains shared code and resources as well as third party libraries.

![Plaid’s module dependency graph](https://cdn-images-1.medium.com/max/2000/0*VJS0y6-8fKBUHGhU)

Before we started modularizing and introducing Dagger as main actor for dependency injection, Plaid’s code had a couple of classes and functions like this:

```
class DesignerNewsInjector {

    fun providesApi(...): DesignerNewsService { ... }

}
```

While this is a perfectly fine solution, we were left with writing a lot of boilerplate and plumbing code by hand.

Wherever anything was required from the injector, we had to call the underlying function at the right point, in many cases either object initialization or `onCreate`.

## A very brief intro to dependency injection

Dependency injection basically means that you don’t create objects in the place you need them but rather create them somewhere else. Then references to these objects can get passed into classes where they are required.

This can be done either manually or with one of the many libraries out there. We chose Dagger 2. Thanks to Dagger, all we have to do to get a hold of an initialized service that’s ready to use is this:

```
@Inject lateinit var service: DesignerNewsService
```

All the dependencies of the service can be passed into the provides function as parameters. Having chosen Dagger for our dependency injection needs means that our dependency graphs are created at compile time. Bear this in mind for the following sections.

## Our approach to introducing Dagger to Plaid

At the time we decided to introduce Dagger into Plaid we had already learned a valuable lesson that is particularly true for modularization.

> Don’t try to cover too much ground at once.

This means that it’s worthwhile to spend some time figuring out the smallest scope necessary to implement a new feature. This MVP we then discussed within the team to see whether we’re moving in the right direction. Adhering to this practice prevents us from running off with changes that are too large to efficiently work with. This also allows us to gradually roll out changes throughout our code base while everyone else continued working on their tasks.

Within Plaid we used the already proven `about` feature module as playground for Dagger. Here we could add Dagger without interfering with other modules or workload. You can find the [initial commit](https://github.com/nickbutcher/plaid/commit/9310b6d4f100adff4e639456f58ac802b57d4b39) here.

## Dependency graphs

When introducing a dependency injection library to a monolithic application usually there’s one single dependency graph for the whole of the application.

![Classic simplified dependency graph in a monolithic project](https://cdn-images-1.medium.com/max/2000/1*wfFPurM3MIKdGjL66Ko7Yw.png)

This enables sharing dependencies between components. In some libraries dependencies can be scoped in order to avoid conflicts or provide a specific implementation to an injection target.

## Modular oddities

For a modularized app, especially for one using dynamic feature modules this doesn’t work though. Let’s take a closer look at how application and dynamic feature modules’ depend on one another. A dynamic feature module knows that an application module exists. The application module kind of knows that the dynamic feature module exists, but can’t directly execute code from within that module. For dependency injection, this means that the graph has to be broken into pieces.

For a modularized app the simplified dependency graph usually looks kind of like this.

![Modules have clear boundaries and are encapsulated within a DFM’s dependency graph](https://cdn-images-1.medium.com/max/2000/1*VpO72oXxUIoraT_Abj_eoA.png)

More concrete, within Plaid the component landscape looks like this.

![Plaid’s component landscape](https://cdn-images-1.medium.com/max/2000/1*Ol8Cff81iw5JmqXWWnQ35A.png)

Each DFM has its own component named after the feature module it sits in. As does the `app` module through `HomeComponent`.

There’s also a component containing shared dependencies. It sits within `core` and is called `CoreComponent`. The main idea behind `CoreComponent` is to provide objects that can be used throughout the app. It combines a couple of Dagger modules which sit within the `core` library and can be re-used throughout the app.

Also, since the graphs are directed there’s only one way to share Dagger components:
A DFM can access Dagger components from the application module. The application module can access components from libraries it depends on. But not the other way around.

## Sharing components across module boundaries

In order to share Dagger components, they need to be made accessible throughout the application. Within Plaid we decided to make our `CoreComponent` accessible via the Application class.

```
class PlaidApplication : Application() {

  private val coreComponent: CoreComponent by lazy {
    DaggerCoreComponent
      .builder()
      .markdownModule(MarkdownModule(resources.displayMetrics))
      .build()
  }

  companion object {

    @JvmStatic fun coreComponent(context: Context) =
      (context.applicationContext as PlaidApplication).coreComponent
  }
}
```

The instantiated core component can now be accessed from anywhere within the app where there’s a context available by calling PlaidApplication.coreComponent(context).

Using an extension function makes access to this even sweeter:

```
fun Activity.coreComponent() = PlaidApplication.coreComponent(this)
```

## Components in Components

To incorporate `CoreComponent` in another component it is necessary to provide it during component creation. Let’s see how this works within `[SearchComponent](https://github.com/nickbutcher/plaid/blob/master/search/src/main/java/io/plaidapp/search/dagger/SearchComponent.kt)`:

```
@Component(modules = [...], dependencies = [CoreComponent::class])
interface SearchComponent {

  @Component.Builder
  interface Builder {

    fun coreComponent(coreComponent: CoreComponent): Builder
    // modules
  }
}
```

During initialization of the generated `DaggerSearchComponent` we set `CoreComponent` like this:

```
DaggerSearchComponent.builder()
  .coreComponent(activity.coreComponent())
  // modules
  .build()
.inject(activity)
```

The trick here is to set `CoreComponent` as a dependency of `SearchComponent`.

```
@Component(
    modules = [SearchModule::class],
    dependencies = [CoreComponent::class]
)
interface SearchComponent : BaseActivityComponent<SearchActivity>
```

`CoreComponent` is a dependency of `SearchComponent`. When `CoreComponent` is included as a component dependency of `SearchComponent` like above, all of `CoreComponent’s` methods can be used in `SearchComponent` or other Dagger components as if they were `@Provides` methods.

![Component dependencies with their respective modules (in green) providing implementations to SearchActivity](https://cdn-images-1.medium.com/max/2000/1*EQ12g7x545uJfb6Y0KjjUw.png)

A benefit of this approach is that `@Modules` don’t have to be repeated throughout the feature graphs but can be transparently provided through `CoreComponent` or modules bound by it.

For example, `CoreDataModule` is bound in `CoreComponent` and provides `Retrofit` amongst others. That `Retrofit` instance can now be accessed in any component where`CoreComponent` is incorporated.

## What’s next

After reading this article you have seen that modularizing your app also has to take dependency injection into account. The introduced feature module boundaries are reflected in DI through separated dependency graphs. Being aware of these restrictions enables finding the right place for shared components.

You can dive into the code to see how we solved dependency injection using Dagger in Plaid.

`[CoreComponent](https://github.com/nickbutcher/plaid/blob/master/core/src/main/java/io/plaidapp/core/dagger/CoreComponent.kt)` is a good starting point, as is `[AboutComponent](https://github.com/nickbutcher/plaid/blob/master/about/src/main/java/io/plaidapp/about/dagger/AboutComponent.kt)` since it doesn’t have many external dependencies.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
