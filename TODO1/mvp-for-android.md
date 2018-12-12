> * 原文地址：[MVP for Android: how to organize the presentation layer](https://antonioleiva.com/mvp-android/)
> * 原文作者：[Antonio Leiva](https://antonioleiva.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/mvp-for-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/mvp-for-android.md)
> * 译者：
> * 校对者：

# MVP for Android: how to organize the presentation layer

![](https://antonioleiva.com/wp-content/uploads/2014/04/mvp-android.jpg)

MVP (Model View Presenter) pattern is a **derivative from the well known MVC** (Model View Controller), and one of the most popular patterns to organize the presentation layer in Android Applications.

This article was first published in April 2014, and been the most popular since then. So I’ve decided to update it solving most of the doubts people had, and also convert the code to [Kotlin](https://antonioleiva.com/kotlin).

There have been breaking changes about architectural patterns since then, such as [MVVM with architecture components](https://antonioleiva.com/architecture-components-kotlin/), but MVP is still valid and an option to take into account.

## What is MVP?

The MVP pattern allows **separating the presentation layer from the logic** so that everything about how the UI works is agnostic from how we represent it on screen. Ideally, the MVP pattern would achieve that the same logic might have completely different and interchangeable views.

The first thing to clarify is that MVP **is not an architecture by itself**, it’s only responsible for the presentation layer. This has been a controversial assessment, so I want to explain it a bit deeper.

You may find that MVP is defined as an architectural pattern because it can become part of the architecture of your App, but don’t consider that just because you are using MVP, your architecture is complete. **MVP only models the presentation layer**, but the rest of layers will still require a good architecture if you want a flexible and scalable App.

An example of a complete architecture could be [Clean Architecture](https://fernandocejas.com/2015/07/18/architecting-android-the-evolution/), though there are many other options.

In any case, it is always better to use it for your architecture that not using it at all.

## Why use MVP?

In Android, we have a problem arising from the fact that Android activities are closely coupled to both UI and data access mechanisms. We can find extreme examples such as CursorAdapter, which mixes adapters, which are part of the view, with cursors, something that should be relegated to the depths of data access layer.

**For an application to be easily extensible and maintainable, we need to define well-separated layers**. What do we do tomorrow if, instead of retrieving the same data from a database, we need to do it from a web service? We would have to redo our entire view.

MVP makes views independent from our data source. We divide the application into at least three different layers, which lets us test them independently. With MVP **we take most of the logic out from the activities so that we can test it** without using instrumentation tests.

## How to implement MVP for Android

Well, this is where it all starts to become more diffuse. There are many variations of MVP and everyone can adjust the pattern to their needs and the way they feel more comfortable. It varies depending basically on the number of responsibilities that we delegate to the presenter.

Is the view responsible to enable or disable a progress bar, or should it be done by the presenter? And who decides which actions should be shown in the Action Bar? That’s where the tough decisions begin. I will show how I usually work, but I want this article to be more a place for discussion rather than strict guidelines on how to apply MVP, because up to there is no “standard” way to implement it.

For this article, I’ve implemented a very simple example that [you may find on my Github](https://github.com/antoniolg/androidmvp) with a login screen and a main screen. For simplicity purposes, the code in the article is in Kotlin, but you can also check the code in Java 8 in [the repository](https://github.com/antoniolg/androidmvp).

### The model

In an application with a complete layered architecture, this model would only be the gateway to the domain layer or business logic. If we were using [Uncle Bob’s clean architecture](http://blog.8thlight.com/uncle-bob/2012/08/13/the-clean-architecture.html "New Window to Clean Architecture"), the model would probably be an interactor that implements a use case. But for the purpose of this article, it is enough to see it as the provider of the data we want to display in the view.

If you check the code, you will see that I’ve created two mock interactors with artificial delays to simulate requests to a server. The structure of one of this interactors:

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

It’s a simple function that receives the username and the password, and does some validation.

### The View

The view, usually implemented by an Activity (it may be a Fragment, a View… depending on how the app is structured), will contain a reference to the presenter. The presenter will be ideally provided by a dependency injector such as [Dagger](http://square.github.io/dagger/ "New window Dagger"), but in case you don’t use something like this, it will be responsible for creating the presenter object. The only thing that the view will do is **calling a presenter method every time there is a user action** (a button click for example).

As the presenter must be view agnostic, it uses an interface that needs to be implemented. Here’s the interface that the example uses:

```
interface LoginView {
    fun showProgress()
    fun hideProgress()
    fun setUsernameError()
    fun setPasswordError()
    fun navigateToHome()
}
```

It has some utility methods to show and hide progress, show errors, navigate to the next screen… As mentioned above, there are many ways to do this, but I prefer to show the simplest one.

Then, the activity can implement those methods. Here I show you some, so that you get an idea:

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

But if you remember, I also told you that the view uses the presenter to notify about user interactions. This is how it’s used:

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

The presenter is defined as a property for the activity, and when the button is clicked, it calls `validateCredentials()`, which will notify the presenter.

Same happens with `onDestroy()`. We’ll see later why it needs to notify in that case.

### The presenter

The presenter is responsible to act as **the middleman between view and model**. It retrieves data from the model and returns it formatted to the view

Also, unlike the typical MVC, it decides what happens when you interact with the view. So it will have a method for each possible action the user can do. We saw it in the view, but here’s the implementation:

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

**MVP has some risks**, and the most important we use to forget is that the presenter is attached to the view forever. And the view is an activity, which means that:

*   We can leak the activity with long-running tasks
*   We can try to update activities that have already died

For the first point, if you can ensure that your background tasks finish in a reasonable amount of time, I wouldn’t worry much. Leaking an activity 5-10 seconds won’t make your App much worse, and the solutions to this are usually complex.

The second point is more worrying. Imagine you send a request to a server that takes 10 seconds, but the user closes the activity after 5 seconds. By the time the callback is called and the **UI is updated, it will crash because the activity is finishing**.

To solve this, we call the `onDestroy()` method that cleans the view:

```
fun onDestroy() {
    loginView = null
}
```

That way we avoid calling the activity in an inconsistent state.

## Conclusion

Separating interface from logic in Android is not easy, but the MVP pattern makes it easier to prevent our activities end up degrading into very coupled classes consisting of hundreds or even thousands of lines. In large Apps, it is essential to organize our code well. Otherwise, it becomes impossible to maintain and extend.

Nowadays, there are other alternatives like MVVM, and I will create new articles comparing them and helping with the migration. So keep tuned!

Remember [you have the repository](https://github.com/antoniolg/androidmvp), where you can take a look at the code in both Kotlin and Java

And if you want to learn more about Kotlin, check the [sample App](https://github.com/antoniolg/Kotlin-for-Android-Developers) of my [Kotlin for Android Developers book](https://antonioleiva.com/book), or take a look at the [online course](https://antonioleiva.com/online-course).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
