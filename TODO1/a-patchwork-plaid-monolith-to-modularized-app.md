> * 原文地址：[Patchwork Plaid — A modularization story](https://medium.com/androiddevelopers/a-patchwork-plaid-monolith-to-modularized-app-60235d9f212e)
> * 原文作者：[Ben Weiss](https://medium.com/@keyboardsurfer?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-patchwork-plaid-monolith-to-modularized-app.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-patchwork-plaid-monolith-to-modularized-app.md)
> * 译者：
> * 校对者：

# 格子拼贴 — 关于模块化的故事

![](https://cdn-images-1.medium.com/max/800/0*7f6VI2TLc-P5iokR)

插图来自 [Virginia Poltrack](https://twitter.com/VPoltrack)

#### 我们为什么以及如何进行模块化，模块化后会发生什么？

这篇文章深入探讨了 [ Restitching Plaid ](https://medium.com/@crafty/restitching-plaid-9ca5588d3b0a) 模块化部分。

在这篇文章中，我将全面介绍如何将一个整体的、庞大的、普通的应用转化为一个模块化应用束。以下是我们已取得的成果：

* 整体体积减少超过60%
* 极大地增强代码健壮性
* 支持动态交付、按需打包代码

我们做的所有事情，都不会影响用户体验。

### Plaid 初印象

![](https://cdn-images-1.medium.com/max/800/1*vVUYtBjOkcvcX13SsMdqnA.gif)

导航 Plaid

Plaid 是一个具有令人感到愉悦的 UI 的应用。它的主屏幕显示的新闻来自多个来源。
这些新闻被点击后展示详情，从而出现分屏效果。
该应用同时具有搜索功能和一个关于模块。基于这些已经存在的特征，我们选择一些进行模块化。

新闻来源（Designer News 和 Dribbble）成为了它自己拥有的动态功能模块。关于和搜索特征同样被模块化为动态功能。

[动态功能](https://developer.android.com/studio/projects/dynamic-delivery)允许在不直接于基础应用包含代码情况下提供代码。正因为此，通过连续步骤可实现按需下载功能。

### 接下来介绍 Plaid 结构

如许多安卓应用一样，Plaid 最初是作为普通应用构建的单一模块。它的安装体积仅7MB一下。然而许多数据并未在运行时用到。

#### 代码结构

从代码角度来看，Plaid 基于包从而有明确边界定义。但随大量代码库的出现，这些边界会被跨越且依赖会潜入其中。模块化要求我们更加严格地限定这些边界，从而提高和改善代码分离。

#### 本地库

最大未用到的数据块来自 [Bypass](https://github.com/Uncodin/bypass)，一个我们用来在 Plaid 呈现标记的库。它包括用于多核 CPU 体系架构的本地库，这些本地库最终在普通应用占大约4MB左右。应用束允许仅交付设备架构所需的库，将所需体积减少1MB左右。

#### 可提取资源

许多应用使用栅格化资产。它们与密度有关且通常占应用文件体积很大一部分。应用可从配置应用中受益匪浅，配置应用中每个显示密度都被放在一个独立应用中，允许设备定制安装，也大大减少下载和体积。

Plaid 显示图形资源时，很大程度依赖于 [vector drawables](https://developer.android.com/guide/topics/graphics/vector-drawable-resources)。因这些与密度无关且已保存许多文件，故此处数据节省对我们并非太有影响。

### 拼贴起来

在模块化中，我们最初把 `./gradlew assemble` 替换为 `./gradlew bundle`。Gradle 现在将生成一个 [Android App Bundle](http://g.co/androidappbundle) (aab)，替换生成应用。一个安卓应用束需用到动态功能 Gradle 插件，我们稍后介绍。

#### 安卓应用束

相对单个应用，安卓应用束生成许多小的配置应用。这些应用可根据用户设备定制，从而在发送过程和磁盘上保存数据。应用束也是动态功能模块先决条件。

在 Google Play 上传应用束后，可生成配置应用。随着[应用束](http://g.co/androidappbundle)成为[开放规范](https://developer.android.com/guide/app-bundle#aab_format)，其它应用商店也可实现该交付机制。为 Google Play 生成并签署应用，应用必须注册到[由Google Play签名的应用程序](https://developer.android.com/studio/publish/app-signing)。

#### 优势

这种封装改变给我们带来了什么？

**Plaid 现在设备减少60%以上体积，等同大约4MB数据。**

这意味每一位用户都能为其它应用预留更多空间。
同时下载时间也因文件大小缩小而改善。

![](https://i.loli.net/2018/12/17/5c179ef2e5c9c.png)

无需修改任何一行代码即可实现这一大幅度改进。

### 实现模块化

我们为实现模块化所选的方法：

1. 将所有代码和资源块移动到核心模块中。
2. 识别可模块化功能。
3. 将相关代码和资源移动到功能模块中。

![](https://cdn-images-1.medium.com/max/800/1*3OniQxsZEShiTnQLyuBwtQ.png)

绿色：动态功能 | 深灰色：应用模块 | 浅灰色：库

上面图表向我们展示了 Plaid 模块化现状：

* `旁路模块`和外部`分享依赖`包含在核心模块当中
* `应用`依赖于`核心模块`
* 动态功能模块依赖于`应用`

#### 应用模块

`应用`模块基本上是现存的[应用](https://developer.android.com/studio/build/)，被用来创建应用束且向我们展示 Plaid。许多用来运行 Plaid 的代码没必要必须包含在该模块中，而是可移至其它任何地方。

#### Plaid 的`核心模块`

为开始重构，我们将所有代码和资源都移动至一个 [com.android.library](https://developer.android.com/studio/projects/android-library) 模块。进一步重构后，我们的`核心模块`仅包含各个功能模块间共享所需要代码和资源。这将使得更加清晰地分离依赖项。

#### 外部库

通过`旁路模块`将一个第三方依赖库包含在核心模块中。此外通过 gradle `api` 依赖关键字，将所有其它 gradle 依赖从`应用`移动至`核心模块`。

Gradle 依赖声明：api vs implementation_

通过 `api` 代替 `implementation` 可在整个程序中共享依赖项。这将减少每一个功能模块体积大小，因本例`核心模块`中依赖项仅需包含在单一模块中。此外还使我们的依赖关系更加易于维护，因为它们被声明在一个单一文件而非在多个 `build.gradle` 文件间传播。

#### 动态功能模块

上面我提到了我们识别的可被重构为 [com.android.dynamic-feature](https://developer.android.com/studio/projects/dynamic-delivery) 的模块。它们是：

```
:about
:designernews
:dribbble
:search
```

#### 动态功能介绍

一个动态功能模块本质上是一个 gradle 模块，可从基础应用模块被独立下载。它包含代码、资源、依赖，就如同其它 gradle 模块一样。虽然我们还没在 Plaid 中使用动态交付，但我们希望将来可减少最初下载体积。

### 伟大的功能改革

将所有东西都移动至核心模块后，我们将“关于”页面标记为具有最少依赖项的功能，故我们将其重构为一个新的`关于`模块。这包括 Activties、Views、代码仅用于该功能的内容。同样，我们把所有资源例如 drawables、strings 和动画移动至一个新模块。

我们对每个功能模块进行重复操作，有时需要分解依赖项。

最后，核心模块包含大部分共享代码和主要功能。由于主要功能仅显示于应用模块中，我们把相关代码和资源移回`应用`。

#### 功能结构剖析

编译后代码可在包中进行结构优化。强烈建议在将代码分解成不同编译单元前，将代码移动至与功能对应包中。幸运的是我们不用必须重构，因为 Plaid 已很好地对应了功能。

![](https://cdn-images-1.medium.com/max/800/1*kE8K32z6aVssAmdboGuloA.png)

功能和核心模块以及各自体系结构层级

正如我提到的，Plaid 许多功能都通过新闻源提供。它们由远程和本地 **data** 资源、**domain**、**UI** 这些层级组成。

数据源不但显示在主要功能提示中，也显示在与对应功能模块本身相关详情页中。域名层级在一个单一包中唯一。它必须分为两部分：一部分在应用中共享，另一部分仅用在一个功能模块中。

可复用部分被保存在核心模块，其它所有内容都在各自功能模块。数据层和大部分域名层至少与其它一个模块共享，并且同时也保存在核心模块。

#### 包变化

我们还对包名进行了优化，从而反映新的模块化结构体系。
仅与 `:dribbble` 相关代码从 `io.plaidapp` 移动至 `io.plaidapp.dribbble`。通过各自新的模块名称，这同样运用于每一个功能。

这意味着许多导包必须改变。

对资源进行模块化会产生一些问题，因为我们必须使用限定名称消除生成的 `R` 类歧义。例如，导入本地布局视图会导致调用 `R.id.library_image`，而在核心模块相同文件中使用一个 drawable 会导致

```
io.plaidapp.core.R.drawable.avatar_placeholder
```

我们使用 Kotlin 导入别名特性减轻了这一点，它允许我们如下导入核心 `R` 文件：

```
import io.plaidapp.core.R as coreR
```

允许将呼叫站点缩短为

```
coreR.drawable.avatar_placeholder
```

相较于每次都必须查看完整包名，这使得阅读代码变得简洁和灵活得多。

#### 资源移动准备

资源不同于代码，没有一个包结构。这使得通过功能划分它们变得异常困难。但是通过在你的代码中遵循一些约定，也未尝不可能。

通过 Plaid，文件在被用到的地方作为前缀。例如，资源仅用于以 `dribbble_` 为前缀的 `:dribbble`。

将来，一些包含多个模块资源的文件，例如 styles.xml 将在模块基础上进行结构化分组，并且每一个属性同时也作为前缀。

举个例子：在单块应用中，`strings.xml` 包含了整体所用大部分字符串。
在一个模块化应用内中，每一个功能模块仅包含对应模块本身字符串资源。
字符串在模块化前进行分组将更容易拆分文件。

像这样遵循约定，可以更快地、更容易地将资源转移至正确地方。这同样也有助于避免编译错误和运行时序错误。

### 过程挑战

同团队良好沟通，对使得一个重要的重构任务像这样易于管理而言，十分重要。传递计划变更并逐步实现这些变更将帮助我们合并冲突，并且将阻塞降到最低。

#### 善意提醒

本文前面依赖关系图表显示，动态功能模块了解应用模块。另一方面，应用模块不能轻易地从动态功能模块访问代码。但他们包含必须在某一时间执行的代码。

应用对功能模块没足够了解时访问代码，这将没办法在 `Intent(ACTION_VIEW, ActivityName::class.java)` 方法中通过它们的类名启动活动。
有多种方式启动活动。我们决定显示地指定组件名。

为实现它，我们在核心模块开发了 `AddressableActivity` 接口。

```
/**
 * An [android.app.Activity] that can be addressed by an intent.
 */
interface AddressableActivity {
    /**
     * The activity class name.
     */
    val className: String
}
```

使用这种方式，我们创建了一个函数来统一活动启动意图创建：

```
/**
 * Create an Intent with [Intent.ACTION_VIEW] to an [AddressableActivity].
 */
fun intentTo(addressableActivity: AddressableActivity): Intent {
    return Intent(Intent.ACTION_VIEW).setClassName(
            PACKAGE_NAME,
            addressableActivity.className)
}
```

最简单实现 `AddressableActivity` 方式为仅需一个显示类名作为一个字符串。通过 Plaid，每一个`活动`都通过该机制启动。对一些包含意图附加部分，必须通过应用各个组件传递到活动中。

如下文件查看我们的实现过程：

- [**AddressableActivity.kt**: Helpers to start activities in a modularized world._github.com](https://github.com/nickbutcher/plaid/blob/master/core/src/main/java/io/plaidapp/core/util/ActivityHelper.kt "https://github.com/nickbutcher/plaid/blob/master/core/src/main/java/io/plaidapp/core/util/ActivityHelper.kt")

#### Styleing 问题

相对于整个应用单一清单文件而言，现在对每一个动态功能模块，对清单文件进行了分离。
这些清单文件主要包含与它们组件实例化相关的一些信息，以及通过 `dist:` 标签反应的一些与它们交付类型相关的一些信息。
这意味着活动和服务都必须声明在包含有与组件对应的相关代码的功能模块中。

我们遇到了一个将样式模块化的问题；我们仅将一个功能使用的样式提取到与该功能相关的模块中，但是它们经常是通过隐式构建在核心模块之上。

![](https://cdn-images-1.medium.com/max/800/1*YJRNNNgg5JbRoe20l14Ffw.png)

PLaid 样式结构部分

这些样式通过模块清单文件以主题形式被提供给组件活动使用。

一旦我们将它们移动完毕，我们会遇到像这样编译时问题：

```
* What went wrong:

Execution failed for task ‘:app:processDebugResources’.
> Android resource linking failed
~/plaid/app/build/intermediates/merged_manifests/debug/AndroidManifest.xml:177: AAPT:
error: resource style/Plaid.Translucent.About (aka io.plaidapp:style/Plaid.Translucent.About) not found.
error: failed processing manifest.
```

清单文件合并视图将所有功能模块中清单文件合并到应用模块。合并失败将导致功能模块样式文件在指定时间对应用模块不可用。

为此，我们在核心模块样式文件中为每一样式如下创建一份空声明：

```
<! — Placeholders. Implementations in feature modules. →

<style name=”Plaid.Translucent.About” />
<style name=”Plaid.Translucent.DesignerNewsStory” />
<style name=”Plaid.Translucent.DesignerNewsLogin” />
<style name=”Plaid.Translucent.PostDesignerNewsStory” />
<style name=”Plaid.Translucent.Dribbble” />
<style name=”Plaid.Translucent.Dribbble.Shot” />
<style name=”Plaid.Translucent.Search” />
```

现在清单文件合并在合并过程中抓取样式，尽管样式的实际实现是通过功能模块样式引入。

另一种避免如上问题做法是保持样式文件声明在核心模块。但这仅作用于所有资源引用同时也在核心模块中情况。这就是我们为何决定通过上述方式的原因。

#### 动态功仪器测试

通过模块化，我们发现测试工具目前不能驻留在动态功能模块中，而是必须包含在应用模块中。对此我们将在即将发布的有关测试工作博客文章中进行详细介绍。

### 接下来还会发生什么？

#### 动态代码加载

我们通过应用束使用动态交付，但初次安装后不要通过 [Play Core Library](https://developer.android.com/guide/app-bundle/playcore) 下载这些文件。例如这将允许我们将默认未启用的新闻源（产品搜索）标记为仅在用户允许该新闻源后安装。

#### 进一步增加新闻源

通过模块化过程，我们保持考虑进一步增加新闻源可能性。分离清洁模块工作以及实现按需交付可能性使得这一点更加重要。

#### 模块精细化

我们在模块化 Plaid 方面取得很大进展。但仍有工作要做。产品搜索是一个新的新闻源，现在我们并未放到动态功能模块当中。同时一些已提取的功能模块中的功能可从核心模块中移除，然后直接集成到各自功能中。

### 为何我决定模块化 Plaid？

通过该过程，Plaid 现在是一个高度模块化应用。所有这些都不会改变用户体验。我们在日常开发中确实从这些努力中获得了一些益处。

#### 安装体积

PLaid 现在用户设备平均减少60%体积。
这使得安装更快，并且节省宝贵网络开销。

#### 编译时间

一个没有缓存的调试构建现在需**32秒而不是48秒**。
同时任务从50项增长到250项。

这样的时间节省，主要是由于增加并行构建以及由于模块化而避免编译。

将来，单个模块变化不需对所有单个模块进行编译，并且使得连续编译速度更快。

* 作为引用，这些是我构建 [before](https://github.com/nickbutcher/plaid/commit/9ae92ab39f631a75023b38c77a5cdcaa4b2489c5) 和 [after](https://github.com/nickbutcher/plaid/tree/f7ab6499c0ae35ae063d7fbb155027443d458b3a) timing 的一些提交。

#### 可维护性

我们在过程中分离可各种依赖项，这使得代码更加简洁。同时，副作用越来越小。我们的每个功能模块都可在越来越少交互下独立工作。但主要益处是我们必须解决的冲突合并越来越少。

### 结语

我们使得应用体积减少**超过60%**，完善了代码结构并且将 PLaid 模块化成动态功能模块以及增加了按需交付潜力。

整个过程，我们总是将应用保持在一个可随时发送给用户状态。您今天可直接切换你的应用发出一个应用束以节省安装体积。模块化需要一些时间，但鉴于上文所见好处，这是值得付出努力的，特别是考虑到动态交付。

**去查看** [**Plaid’s source code**](https://github.com/nickbutcher/plaid) **了解我们所有的变化和快乐模块化过程！**

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
