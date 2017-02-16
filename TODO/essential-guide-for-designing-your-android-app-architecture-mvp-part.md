> * 原文地址：[Essential Guide For Designing Your Android App Architecture: MVP: Part 1](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-1-74efaf1cda40#.3lyk8t57x)
* 原文作者：[Janishar Ali](https://blog.mindorks.com/@janishar.ali?source=post_header_lockup)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[jifaxu](https://github.com/jifaxu)
* 校对者：[Zhiw](https://github.com/Zhiw), [tanglie1993](https://github.com/tanglie1993)

# Android MVP 架构必要知识：第一部分


<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*__cBFEIb0Zi8QswpC1YK0w.png">

> 扎实的基础是成功的保证。

Android 框架并没有主张用哪种方式去设计你的应用程序更好。这让我们有更多的选择但也让架构设计更加困难。

**我曾经考虑过这样一个问题，在实现我的应用时，我能不能写尽量少的 Activity 呢**

在写 Android 的这些年，我意识到如果你解决问题和实现功能时只考虑了当时的情况是远远不够的。你的应用会经历很多轮的迭代，功能也会随之增删。如果你没能设计好架构，在迭代的过程中你的程序将会被破坏。这就是为什么我一定要在每一行代码中严格遵守我的架构设计原则。

> 到目前为止，MVP 中展示出的理念是我见过最优秀的。

**MVP 是什么，我们又为什么要学习它**

让我们开始这一部分。我们中的大多数都是从 Activity 来创建一个 Android 工程的，在这个过程中我们会思考如何去获取数据。Activity 的代码量随着时间不断的增长，直至成为一个没法重用的组件的集合。然后我们开始将这些组件打包，Activity 便可以通过这些组件暴露的接口使用它们。我们甚至对此感到引以为傲并开始将这些代码尽可能的细分。然后我们就会发现自己陷没在组件的海洋里，它们互相依赖，难以使用。之后我们又要考虑可测试性，发现原来的代码写测试还安全点。我们感到这些错综复杂的代码已经紧紧的和 Android API 结合在了一起，这阻碍了我们去进行 JVM 测试和设计简单的测试用例。这就是传统的 MVC 模式中将 Activity 或 Fragment 当做 Controller 来用时的情况。

所以，我们定了一些规定，如果你认真遵守就可以解决上面提到的大多数问题。这些原则，我们叫它 MVP(Model-View-Presenter) 设计模式。

**MVP 设计模式是什么**

MVP 设计模式是为了解耦代码以实现重用性和可测试性。它依据职责划分应用的组件，我们称之为关注点分离。

**MVP 将一个应用分成了三个基础部分。**

1. **Model**：负责处理应用的数据部分。

2. **View**：负责将带有数据的视图显示在屏幕上。

3. **Presenter**：连接 Model 和 View 的桥梁，它也负责操控 View。

**MVP 为上述组件规定了一些基础规则，如下所示：**

1. View 的唯一职责就是根据 Presenter 的指示绘制 UI。它在这个程序里应该是“哑”的。

2. View 将所有的用户交互委派给它的 Presenter。

3. View 永远不与 Model 直接交互。

4. Presenter 负责接受 View 对 Model 的请求，并且在特定的情况下控制 View。

5. Model 负责从服务器、数据库和文件系统获取数据。

> 上述原则可以以多种方式实现。每个开发者都有自己的实现方式。这些都是一些常见的小修改。

> 力量越大，责任越大。

**现在，我会根据前文所说的介绍 MVP 原则。**

1. Activity，Fragment 和 自定义视图是应用的 View 部分。

2. 每一个 View 都有一个单独的 Presenter。

3. View 通过一个接口与 Presenter 通信，反之亦然。

4. Model 被分为几类：ApiHelper, PreferenceHelper, DatabaseHelper 和 FileHelper。这些都是用来帮助实现用来连接各种 model 的 DataManager 的。

5. Presenter 通过接口和 DataManager 交互。

6. DataManager 只在被调用的时候提供服务。

7. Presenter 不访问任何 Android API。

**这些信息现在可以在任何和 Android MVP 有关的博客里找到。那么这篇文章的目的是什么？**

> 写这篇文章的目的是解决一个 MVP 中非常重要的挑战。**如何在一个完整的项目中真正地实现它**

MVP 在单 Activity 的例子中看起来很简单。但是当我们尝试将一个应用的所有组件联系起来时就有些困难了。

> 如果你想深入探索优雅代码的世界，那么就认真学习这篇文章。这不是一篇快餐文，所以投入进来，不要分心。

### 让我们先绘制简单的架构蓝图。###

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/2000/1*etZ8borFvbwOOlChGCZq1A.png">

当你开发软件时，首先考虑的就是架构。一个精心设计的架构会减少很多重复的工作并且提供很好的扩展性。现在的大多数的工程都是有一个团队来开发的，所以可读性和模块化是一个架构最重要的部分。我们重度依赖第三方库并且在由于用例，bug和支持问题频繁地更换第三方库。所以我们的架构应该是即插即用的。类的接口可以实现这样的目的。

上面所描绘的 Android 架构的蓝图包含了 MVP 的所有特征。

> 下面的内容刚开始看可能会有些晦涩，但是如果你看了下一篇文章的例子，就能很清楚地理解这些概念了。

> 知识属于那些渴望它的人。

让我们理解这个架构草图的每一部分。

- **View**：绘制 UI 并接受用户的操作。Activity，Fragment和自定义视图属于这一部分。

- **MvpView**：一种接口，被 View 实现。它包括暴露给 Presenter 的方法。

- **Presenter**：它是决定 View 行为的纯 Java 类（不访问任何 Android API）。它接受从 View 传来的用户操作，并根据业务逻辑进行响应，最终指挥 View 进行特定的行为。它也从 DataManager 获取必要的数据。

- **MvpPresenter**：被 Presenter 实现的接口。包括提供给 View 的方法。

- **AppDbHelper**：数据库管理类，负责所有和数据库有关的操作。

- 被 AppDbHelper 实现的接口，包括提供给应用的方法。这一层对 DbHelper 的任何特定实现进行了解耦，这使得 AppDbHelper 成为了一个即插即用的单元。

- **AppPreferenceHelper**：类似于 AppDbHelper，只不过提供的是对于 SharedPreferences 的读写操作。

- **PreferenceHelper**：类似于 DbHelper 的接口，被 AppPreferenceHelper 实现。

- **AppApiHelper**：管理网络 API 请求及其数据处理。

- **ApiHelper**：类似于 DbHelper 的接口，被 AppApiHelper 实现。

- **DataManager**：被 AppDataManager 实现的接口。包括所有数据处理操作。理想情况下，它负责委派所有 Helper 的服务。所以 DataManager 继承 DbHelper，PreferenceHelper 和 ApiHelper。

- **AppDataManager**：它是应用中所有数据操作的结合点。DbHelper，PreferenceHelper 和 ApiHelper 只为 DataManager 提供服务。它负责委派任务给指定的 Helper。

**现在我们对于各种组件和它们的职责都熟悉了。我们马上将制定组件间的交互规则。**

- Application 类实例化 AppDbHelper（通过 DbHelper 引用），AppPreferenceHelper（通过 PreferenceHelper 引用），AppApiHelper（通过 ApiHelper 引用）以及最终的 AppDataManager（通过 DataManager 引用）。

- View 组件实例化它的 Presenter 并通过 MvpPresenter 引用。 

- Presenter 通过参数接受 View 组件，并用 MvpView 引用，Presenter 也接受 DataManager。

- DataManager 是单例。

**这些是在应用中实现 MVP 的基础引导。**

> 就像一个外科医生在实际动手之前是没法完全掌握手术流程的。我们也不能完全理解这些想法和方案直到我们真正去实现它。

在下一部分，我们将探索一个真实的应用例子，希望能够很好地理解和掌握这些概念。

[这是这篇文章第二部分的链接：](https://github.com/xitu/gold-miner/blob/master/TODO/essential-guide-for-designing-your-android-app-architecture-mvp-part-2.md) 

[**Essential Guide For Designing Your Android App Architecture: MVP: Part 2**](https://blog.mindorks.com/essential-guide-for-designing-your-android-app-architecture-mvp-part-2-b2ac6f3f9637)

**感谢您阅读这篇文章，如果你觉得这篇文章对你有帮助，别忘了点下面的 ❤ 。这会帮助更多人从这篇文章中学到知识.**

获取更多编程知识，在 Medium 上关注[**我**](https://medium.com/@janishar.ali)（要不顺便也关注下[译者](https://gold.xitu.io/user/57d6814f67f3560057e7b12b)吧 =.=），这样你就能在新文章发布的第一时间收到通知了。

Coder’s Rock :)
