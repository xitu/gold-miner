> * 原文地址：[Dependency injection in a multi module project](https://medium.com/androiddevelopers/dependency-injection-in-a-multi-module-project-1a09511c14b7)
> * 原文作者：[Ben Weiss](https://medium.com/@keyboardsurfer)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/dependency-injection-in-a-multi-module-project.md](https://github.com/xitu/gold-miner/blob/master/TODO1/dependency-injection-in-a-multi-module-project.md)
> * 译者：[Mirosalva](https://github.com/Mirosalva)
> * 校对者：[JasonZ](https://github.com/JasonLinkinBright)，[wenny](https://github.com/xiaxiayang)

# 依赖注入在多模块工程中的应用

### Plaid 应用中引入一个 DI 框架过程中我们学到的东西

![插图来自 [Virginia Poltrack](https://twitter.com/vpoltrack)](https://cdn-images-1.medium.com/max/3200/0*yWf1DFEnYBWNmAvT)

总的来说，这不是一篇关于依赖注入的文章，也不是关于我们为什么选择库 X 而不是库 Y 的文章。
相反的，本文从依赖注入的角度介绍了我们对 [Plaid](https://github.com/nickbutcher/plaid) 进行模块化实践的主要成果。

## 我们的设置

在前面的文章中，我写过 Plaid 应用模块化的整体过程。
[**一款拼接应用 Plaid — 整体到模块化: 模块化 Plaid 应用的初衷、过程和结果**](https://medium.com/androiddevelopers/a-patchwork-plaid-monolith-to-modularized-app-60235d9f212e)

让我以鸟瞰图的形式快速回顾一下 Plaid 的样子。

我们有一个包含主启动 activity 的 `app` 模块，同时也有一些依赖 `app` 模块的动态功能模块（DFM）。每一个 DFM 都包含至少一个与所讨论功能相关的 activity、代码和资源。

`app` 模块依赖一个包含了共享的代码和资源以及第三方库的 `core` 模块。

![Plaid 的模块依赖图](https://cdn-images-1.medium.com/max/2000/0*VJS0y6-8fKBUHGhU)

在我们开始模块化操作和以 Dagger 为主介绍依赖注入之前，先来熟悉下 Plaid 的相关类和函数：

```
class DesignerNewsInjector {

    fun providesApi(...): DesignerNewsService { ... }

}
```

虽然这是一个非常好的解决方案，但我们还是手工编写了大量的样板代码。

在任何需要注入的地方，我们都需要在合适的时机调用底层函数，大多数情况下不是在对象初始化时就是在 onCreate 方法中。

## 依赖注入的简要介绍

依赖注入基本上意味着你不用在你需要的地方创建它们，而是在别的地方创建。然后这些对象的引用可以被传递到需要使用它们的类中。

这点可以通过自己编写或者集成某个依赖注入库来实现，我们选择了集成 Dagger 2。多亏了 Dagger，为了获取一个可以使用的已初始化的 service，我们所有要做的就是如下内容：

```
@Inject lateinit var service: DesignerNewsService
```

所有对 service 的依赖可以变成 provides 函数的传参。我们为依赖注入需求选择了 Dagger 意味着我们的依赖图在编译阶段会被创建。下面的章节中要记住这一点。

## 我们在 Plaid 应用中集成 Dagger 的方式

当我们决定引入 Dagger 到 Plaid 应用时，我们已经学到了宝贵的一课，尤其是对模块化。

> 不要试图一次就覆盖太多内容。

这意味着花一些时间研究清楚实现一个新功能的最小必要范围是有意义的。我们接下来要讨论的 MVP，即在团队内部审视我们是否在向着正确的方向前进。坚持这种做法可以防止我们进行太大而无法高效利用的变更。这也允许我们在整个代码库中逐步推出更改，与此同时每个人的任务也可持续进行。

在 Plaid 应用内我们使用已验证后的 `about` 功能模块作为 Dagger 的练习模块。这里我们可以添加 Dagger 而不会干扰到其他模块或负载。你可以在这里查看[初始提交](https://github.com/nickbutcher/plaid/commit/9310b6d4f100adff4e639456f58ac802b57d4b39)。

## 依赖图解

当为一个单块应用引入依赖注入库时，通常整个应用有个单一的依赖图。

![单块项目中的经典简化依赖图](https://cdn-images-1.medium.com/max/2000/1*wfFPurM3MIKdGjL66Ko7Yw.png)

这可以使组件间共享依赖。在一些库中，依赖可以被设置作用域来避免冲突，或者为被注入对象提供一种特殊的实现。

## 模块化的怪异之处

对一个模块化的应用，尤其是使用动态功能模块的应用这却不起作用。让我们仔细地研究下应用和动态功能模块如何彼此依赖。一个动态功能模块知道 application 模块的存在。application 模块大致知道动态功能模块的存在，但是不能直接执行该模块的代码。对于依赖注入，这意味着整体图必须被分解成片。

对一个模块化应用，简单的依赖图通常大致长成下面这样。

![模块具有清晰的边界并且被封装在一个 DFM 依赖图中](https://cdn-images-1.medium.com/max/2000/1*VpO72oXxUIoraT_Abj_eoA.png)

更具体的是，Plaid 中组件规划图看起来像这样。

![Plaid 的组件规划图](https://cdn-images-1.medium.com/max/2000/1*Ol8Cff81iw5JmqXWWnQ35A.png)

每个 DFM 都有它自己的组件，以组件所在的功能模块命名。`app` 模块中的 `HomeComponent` 组件就是如此。

还有一个包含共享依赖项的组件，它位于 `core` 库中并被称作 `CoreComponent`。`CoreComponent` 背后的主要思想是提供可被整个应用使用的对象。它结合了一些 Dagger 模块，这些模块位于 `core` 库并可以在整个应用中复用。

此外，由于依赖图具有方向性，因此只能通过以下方式共享 Dagger 组件：
DFM 图可以从 application 模块来访问 Dagger 组件。application 模块可以从它依赖的库中访问组件，但方向反过来则不行。

## 跨模块边界共享组件

为了共享 Dagger 组件，它们需要被整个应用访问到。在 Plaid 中我们决定使用 Application 类来让我们的 `CoreComponent` 变得可访问。

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

被实例化的 CoreComponent 组件现在可以从应用中任何具有 context 的地方来访问，通过调用 PlaidApplication.coreComponent(context) 的方式。

使用一个扩展函数可以使 this 更好地访问：

```
fun Activity.coreComponent() = PlaidApplication.coreComponent(this)
```

## 组件中的组件

为了把 `CoreComponent` 包含到另一个组件中，有必要在组件创建时提供它。让我们看一下在 [SearchComponent](https://github.com/nickbutcher/plaid/blob/master/search/src/main/java/io/plaidapp/search/dagger/SearchComponent.kt)` 中是如何做到的：

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

在生成的 `DaggerSearchComponent` 做初始化时我们像这样设置了 `CoreComponent`：

```
DaggerSearchComponent.builder()
  .coreComponent(activity.coreComponent())
  // modules
  .build()
.inject(activity)
```

这里的技巧是把 `CoreComponent` 设置为 `SearchComponent` 的一个依赖：

```
@Component(
    modules = [SearchModule::class],
    dependencies = [CoreComponent::class]
)
interface SearchComponent : BaseActivityComponent<SearchActivity>
```

`CoreComponent` 是 `SearchComponent` 的一个依赖。当 `CoreComponent` 像上面那样被引用为 `SearchComponent` 的一个组件依赖时，所有的 `CoreComponent` 方法可以在 `SearchComponent` 中使用，或者在其他 Dagger 组件中使用，就好像他们变成注解 `@Provides` 标记的方法。

![组件依赖与它们各自为 SearchActivity 提供实现方法的模块（绿色）](https://cdn-images-1.medium.com/max/2000/1*EQ12g7x545uJfb6Y0KjjUw.png)

这样做的一个好处是：在功能图中无需重复 `@Modules` ，却可以通过 `CoreComponent` 或其他与之绑定的模块来透明地提供出去。

例如，`CoreDataModule` 绑定在 `CoreComponent` 中，并提供 `Retrofit` 等。`Retrofit` 实例现在可以被任何与 `CoreComponent` 合并的组件访问到。

## 下一步要做什么

读完这篇文章，你可以看到模块化你的应用需要把依赖注入考虑进去。引入的功能模块边界通过分离的依赖图反映在依赖注入中。意识到这个限制可有助于为共享组件找到合适的位置。

你可以深入到代码中来查看我们如何使用 Dagger 解决 Plaid 中的依赖注入问题。

[`CoreComponent`](https://github.com/nickbutcher/plaid/blob/master/core/src/main/java/io/plaidapp/core/dagger/CoreComponent.kt) 是一个好的阅读开端，[`AboutComponent`](https://github.com/nickbutcher/plaid/blob/master/about/src/main/java/io/plaidapp/about/dagger/AboutComponent.kt) 也是，因为它没有太多的外部依赖。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
