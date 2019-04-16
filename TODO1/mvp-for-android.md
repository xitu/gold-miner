> * 原文地址：[MVP for Android: how to organize the presentation layer](https://antonioleiva.com/mvp-android/)
> * 原文作者：[Antonio Leiva](https://antonioleiva.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mvp-for-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mvp-for-android.md)
> * 译者：[Moosphon](https://github.com/Moosphan)
> * 校对者：[https://github.com/gs666](gs666), [https://github.com/Qiuk17](Qiuk17)

# Android 中的 MVP：如何使 Presenter 层系统化？

![](https://antonioleiva.com/wp-content/uploads/2014/04/mvp-android.jpg)

MVP（Model View Presenter）模式是 **著名的 MVC（Model View Controller）的衍生物**，并且是 Android 应用程序中管理表示层的最流行的模式之一。

这篇文章首次发表于 2014 年 4 月，从那以后就一直备受欢迎。所以我决定更新它来解决人们心中的大部分疑虑，并将代码转换为 [Kotlin](https://antonioleiva.com/kotlin) 语言形式。

自那时起，架构模式发生了重大变化，例如[带有架构组件的 MVVM](https://antonioleiva.com/architecture-components-kotlin/)，但 MVP 仍然有效并且是一个值得考虑的选择。

## 什么是 MVP 模式？

MVP 模式将 **Presenter 层从逻辑中分离出来**，这样一来，就把所有关于 UI 如何工作与我们在屏幕上如何表示它分离了开来。理想情况下，MVP 模式将实现相同的逻辑可能具有完全不同且可交替的界面。

要明确的第一件事是 MVP **本身不是一个架构**，它只负责表示层。这是一个有争议的说法，所以我想更深入地解释一下。

你可能会发现 MVP 被定义为架构模式，因为它可以成为你的应用程序架构的一部分。但你不应当这样认为，因为去掉 MVP 之后，你的架构依旧是完整的。**MVP 仅仅塑造表示层**，但如果你需要灵活且可扩展的应用程序，那么其余层仍需要良好的体系架构。

完整架构体系的一个示例可以是 [Clean Architecture](https://fernandocejas.com/2015/07/18/architecting-android-the-evolution/)，但还有许多其他选择。

在任何情况下，在你从未使用 MVP 的架构中去使用它总是件好事。

## 为什么要使用 MVP？

在 Android 开发中，我们遇到一个严峻的问题：Activity 高度耦合了用户界面和数据存取机制。我们可以找到像 CursorAdapter 这样的极端例子，它将作为视图层一部分的 Adapter 和 属于数据访问层级的 Cursor 混合到了一起。

**为了能够轻松地扩展和维护一个应用，我们需要使用可以相互分离的体系架构**。如果我们不再从数据库获取数据，而是从 web 服务器获取，那么我接下来该怎么办呢？我们可能就要重新编写整个视图层了。

MVP 使视图独立于我们的数据源而存在。我们需要将应用程序划分为至少三个不同的层次，以便我们可以独立地测试它们。通过 MVP，我们可以将大部分有关业务逻辑的处理从 Activity 中移除，以便我们可以在不使用 Instrumentation Test 的情况下对其进行测试。

## 如何实现 Android 当中的 MVP？

好吧，这就是它开始产生分歧的地方。MVP 有很多变种，每个人都可以根据自己的需求和自己感觉更加舒适的方式来调整模式。这主要取决于我们委托给 Presenter 的任务数量。

到底是该由 View 层来负责启用或禁用一个进度条，还是该由 Presenter 来负责呢？又该由谁来决定 Action Bar 应该做出什么行为呢？这就是艰难决定的开始。我将展示我通常情况下是如何处理这种情况的，但我希望这篇文章更是一个适合讨论的地方，而不是严格的约束 MVP 该如何应用，因为根本没有“标准”的方式来实现它。

对于本文，我已经实现了一个非常简单的示例，[你可以在我的 Github 找到](https://github.com/antoniolg/androidmvp) 一个登录页面和主页面。为了简单起见，本文中的代码是使用 Kotlin 实现的，但你也可以在[仓库](https://github.com/antoniolg/androidmvp)中查看使用 Java 8 编写的代码。

### Model 层

在具有完整分层体系结构的应用程序中，这里的 Model 仅仅是通往领域层或业务逻辑层的大门。如果我们使用 [鲍勃大叔的 clean architecture 架构](http://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html "New Window to Clean Architecture")，这里的 Model 可能是一个实现了一个用例的 Interactor（交互器）。但就本文而言，将 Model 看做是一个给 View 层显示数据的提供者就足够了。

如果你检查代码，你将看到我创建了两个带有人为延迟操作的 Interactor 来模拟对服务器的请求情况。其中一个 Interactor 的结构：

```
class LoginInteractor {

    ...

    fun login(username: String, password: String, listener: OnLoginFinishedListener) {
        // Mock login. I'm creating a handler to delay the answer a couple of seconds
        postDelayed(2000) {
            when {
                username.isEmpty() -> listener.onUsernameError()
                password.isEmpty() -> listener.onPasswordError()
                else -> listener.onSuccess()
            }
        }
    }
}
```

这是一个简单的方法，它接收用户名和密码，并进行一些验证操作。

### View 层

View 层通常是由一个 Activity（也可以是一个 Fragment，一个 View，这取决于 App 的结构），它包含了一个对 Presenter 的引用。理想情况下，Presenter 是通过依赖注入的方式提供的（比如 [Dagger](http://square.github.io/dagger/ "New window Dagger")），但如果你没有使用这类工具，也可以直接创建一个 Presenter 对象。View 需要做的唯一一件事就是：当有用户操作发生时（比如一个按钮被点击了），就调用 Presenter 中的相应方法。

由于 View 必须与 Presenter 层无关，因此它就需要实现一个接口。下面是示例中使用到的接口：

```
interface LoginView {
    fun showProgress()
    fun hideProgress()
    fun setUsernameError()
    fun setPasswordError()
    fun navigateToHome()
}
```

接口中有一些有效的方法来显示或隐藏进度条，显示错误信息，跳转到下一个页面等等。正如上面所提到的，有很多方式去实现这些功能，但我更喜欢罗列出最简单直观的方法。

然后，Activity 可以实现这些方法。这里我向你展示了一些用法，以便你对其用法有所了解：

```
class LoginActivity : AppCompatActivity(), LoginView {
    ...

    override fun showProgress() {
        progress.visibility = View.VISIBLE
    }

    override fun hideProgress() {
        progress.visibility = View.GONE
    }

    override fun setUsernameError() {
        username.error = getString(R.string.username_error)
    }
}
```

但是如果你还记得，我还告诉过你，View 层使用 Presenter 来通知用户交互操作。下面就是它的用法：

```
class LoginActivity : AppCompatActivity(), LoginView {

    private val presenter = LoginPresenter(this, LoginInteractor())

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)

        button.setOnClickListener { validateCredentials() }
    }

    private fun validateCredentials() {
        presenter.validateCredentials(username.text.toString(), password.text.toString())
    }

    override fun onDestroy() {
        presenter.onDestroy()
        super.onDestroy()
    }
    ...
}
```

Presenter 被定义为 Activity 的属性，当点击按钮时，它会调用 `validateCredentials()`方法，该方法将会通知 Presenter。

 `onDestroy()` 方法亦是如此。我们稍后将会看到为什么在这种情况下需要通知 Presenter。

### Presenter 层

Presenter 充当着 **View 层和 Model 层的中间人**。它从 Model 层获取收据并将格式化后数据返回给 View 层。

此外，与典型的 MVC 模式不同的是，Presenter 决定了当你在与 View 层交互时会做何响应。因此，它将为用户每个可执行的操作提供一种方法。我们在 View 层中看到了它，这里是代码实现：

```
class LoginPresenter(var loginView: LoginView?, val loginInteractor: LoginInteractor) :
    LoginInteractor.OnLoginFinishedListener {

    fun validateCredentials(username: String, password: String) {
        loginView?.showProgress()
        loginInteractor.login(username, password, this)
    }
    ...
}
```

**MVP 模式存在一些风险**，常常被我们忽略的最重要的问题是 Presenter 永远依附在 View 上面。并且 View 层一般为 Activity，这就意味着：

*   我们可能会由于长时间的运行的任务而导致 Activity 的泄漏
*   我们可能会在 Activity 已经被销毁的情况下去更新视图

首先，倘若你能够保证能够在合理的时间内完成你的后台任务，我将不会过于担心。将你的 Activity 泄漏 5-10 秒会让你的 App 变得很糟糕，并且解决方案通常很复杂。

第二点反而更让人担心。想象一下，你花费 10 秒钟时间向服务器发送一个请求，但用户却在 5 秒钟后关闭了 Activity。当回调方法正在被调用并且 **UI 被更新时，App 将会崩溃，因为 Activity 正在销毁中**。

为了解决这个问题，我们可以在 Activity 中调用 `onDestroy()` 方法并清除 View：

```
fun onDestroy() {
    loginView = null
}
```

这样我们就可以避免在任务结束时间与活动销毁时间不一致的情况下调用 Activity 了。

## 总结

在 Android 中将用户界面层与逻辑层分离并不简单，但 MVP 模式可以更加轻易地防止我们的 Activity 最终沦为高度耦合的、包含了成百上千行代码的类。在大型应用开发过程中，将代码管理好是很有必要的。否则，对代码的维护和扩展都会变得很困难。

如今，还有其他的代替方案比如 MVVM，我将会创作新的文章来对 MVVM 和 MVP 做比较，并帮助开发者迁移。所以请继续关注我的博客！

请记住 [这个仓库](https://github.com/antoniolg/androidmvp)，你可以在这查看 MVP 在 Kotlin 和 Java 中的代码示例。

如果你想要了解更多关于 Kotlin 方面的内容，可以查看我的 [Kotlin for Android Developers 这本书](https://antonioleiva.com/book) 中的 [sample 应用](https://github.com/antoniolg/Kotlin-for-Android-Developers)，或者观看 [在线课程](https://antonioleiva.com/online-course)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
