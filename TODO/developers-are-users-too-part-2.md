> * 原文地址：[Developers are users too — part 2: 5 More guidelines for a better UI and API usability](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-part-2.md)
> * 译者：[tanglie1993](https://github.com/tanglie1993)
> * 校对者：

# 开发者也是用户 - 第二部分：改善 UI 和 API 可用性的五条指导原则

我们对自己与之交互的所有东西的可用性都有相同的预期，包括 UI 和 API。所以，我们用于 UI 的指导原则也可以被翻译到 API。我们在前一篇文章中已经看到了五条指导原则。现在，是时候看看剩下的了。

[**开发者也是用户 — 第一部分**
_5 Guidelines for a better UI and API usability_medium.com](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc)

### 6. 识别而不是回忆

**UI:** 识别类似的东西所需要的精力是最少的，它可以通过上下文自动触发。回忆意味着从记忆中取出细节，它需要多很多的时间。从一系列选项中选择，比根据记忆写出选项容易很多。一个使用常见 icon 的简单 UI 是基于识别的，一个命令行界面是基于回忆的。信息和功能应该可见，符合直觉并且容易使用。

![](https://cdn-images-1.medium.com/max/800/1*eHPxVsUoCufUaKTmMgleTg.png)

铅笔 icon 是一个表示编辑的符号，容易识别，与 app 无关。

#### 使名称清晰、易于理解

A **变量** 名称应该说明它代表什么，而不是如何使用： `isLoading`, `animationDurationMs`.

A **类** 名称应该是一个名词，说明它代表什么：`RoomDatabase`, `Field`.

A **方法** 名称应该是一个动词，说明它做什么：`query()`, `runInTransaction()`.

### 7. 使用的灵活性和效率

**UI:** 你的应用可能被没有经验和经验丰富的用户同时使用。创建一个 UI使其迎合这两种用户的需求，并让他们习惯常用的操作。据说，20% 的功能被 80% 的用户使用。你需要在简洁和功能之间权衡。找出你的 app 中的那 20%，然后把它们变得尽可能简单易用。使用 [逐步展现原则](https://www.nngroup.com/articles/progressive-disclosure/) ，以允许你的用户在次要的页面使用进阶功能。

![](https://cdn-images-1.medium.com/max/800/1*DenvAOded-MXjFI1v5iXFQ.png)

Wi-Fi 设置默认显示基本选项，但也包含进阶选项。它适合用户的需求。

#### 写有弹性的 API

用户应当能够使用 API 高效地完成任务，API 需要有弹性。比如，在查询数据库时，Room 提供不同的返回值，允许用户进行同步查询，使用LiveData，或者如果他们喜欢的话，使用 RxJava2 中的 API。

```
@Query(“SELECT * FROM Users”)
// synchronous
List<User> getUsers();
// asynchronously
Single<List<User>> getUsers();
Maybe<List<User>> getUsers();
// asynchronously via observable queries
Flowable<List<User>> getUsers();
LiveData<List<User>> getUsers();
```

#### Put related methods in related classes

Methods placed in a class that has no direct relation to the code that the developer has already written are hard to find. Even more, “Util” or “Helper” classes that tend to group a lot of useful methods can be hard to find. When using Kotlin, the solution for this is to use [extension functions](https://kotlinlang.org/docs/reference/extensions.html).

### 8. Aesthetic and minimalist design

**UI:** The UI should be kept simple, containing only the information relevant for the user at that time. Irrelevant or rarely needed information should be removed or moved to other screens since their presence distracts the user and decreases the importance of the information that is indeed relevant.

![](https://cdn-images-1.medium.com/max/800/1*HBsvBFRg_ueZvG5Qfmk3ZA.png)

[Pocket Casts](https://play.google.com/store/apps/details?id=au.com.shiftyjelly.pocketcasts&hl=en_GB) app uses a minimalist design

In the episode lists screen, this podcast app shows minimum, contextual and relevant amount of information: if the user hasn’t downloaded an episode, the download size and the download button are visible; if the user has downloaded it — the duration and a play button. At the same time, all of these and more are present in the details screen for the curious user.

**API:** API users have one goal: to solve their problem faster with the help of your API. So make their path as short and direct as possible.

#### Don’t expose internal API logic

**API:** Unnecessarily exposing internal API logic can confuse the user and lead to bad usability. Don’t expose methods and classes that are not needed

#### Don’t make the user do anything that the API could do

**API:** Starting with 22.1.0, the Android Support Library provides the `RecyclerView` suite of objects to enable creation of UI elements based on large data sets or data that changes frequently. Whenever the list changes, the `RecyclerView.Adapter` needs to be notified with the data that was updated. That lead to developers creating their own solutions for computing the differences between lists. In the 25.1.0 version of the Support Library, this boilerplate was drastically reduced by the `[DiffUtil](https://developer.android.com/reference/android/support/v7/util/DiffUtil.html)` class. Moreover, `DiffUtil` uses an optimized algorithm, reducing the amount of code you need to write and increasing performance.

### 9. Help users recognize, diagnose and recover from errors

**UI:** Provide your app’s users with error messages that help them recognize, diagnose and recover from errors. Good error messages contain a clear indication that something has gone wrong, with a precise description of the problem in polite and human readable language, containing constructive advice on how to fix the problem. Avoid showing a status code or an Exception class name. The user won’t know what to do with that information.

![](https://cdn-images-1.medium.com/max/800/1*oJ8PMLg3ayTfHR7dOFvGEA.png)

Error messages when creating an event. [Source](https://material.io/guidelines/patterns/errors.html#errors-user-input-errors)

Show an error on an input field as soon as it’s defocused, don’t wait until the user presses a button to submit the entire form, or, even worse, wait for the errors to come from the backend. Use the TextView’s [capabilities](https://developer.android.com/reference/android/widget/TextView.html#setError%28java.lang.CharSequence%29) to display an error message. If you’re creating an event form for example, prevent your users from creating events in the past by setting constraints directly to the UI widgets.

#### Fail fast

**API:** The sooner a bug is reported, the less damage it will do. Therefore, the best time to fail is at compile time. For example, Room will report any problems with incorrect queries or wrongly annotated classes at compile time.

If you can’t fail at compile time, then try to fail at run time as soon as possible.

#### Exceptions should indicate exceptional conditions

**API:** Users shouldn’t be using exceptions for control flow. Exceptions should only be used for exceptional conditions or incorrect API usages. Use return values to indicate this, where possible. Catching and handling exceptions is almost always slower than than testing a return value.

For example, trying to insert a `null` value in a column that has a `NON NULL` constraint is an exceptional condition and leads to an `SQLiteConstraintException` being thrown.

#### Throw specific exceptions. Prefer already existing exceptions

**API:** Developers already know what `IllegalStateException` or `IllegalArgumentException` mean, even if they don’t know the reason this happened in your API. Help your API users by throwing existing exceptions, preferring more specific exceptions to general ones, with a good error message.

When creating a new `Bitmap` via `[createBitmap](https://developer.android.com/reference/android/graphics/Bitmap.html#createBitmap%28android.graphics.Bitmap,%20int,%20int,%20int,%20int%29)` method, you need to provide elements like the width and the height of the new bitmap. If you’re providing values <= 0 as arguments, then the method will throw an `IllegalArgumentException`.

#### Error messages should precisely indicate the problem

**API:** The same guidelines for writing error messages for the UI apply to the API also. Provide detailed messages that will help your users fix their code.

For example, in Room, if a query is run on the main thread, the user will get a `java.lang.IllegalStateException: Cannot access database on the main thread since it may potentially lock the UI for a long period of time`. This indicates that the state in which the query is being executed (main thread) is illegal for this action.

### 10. Help and documentation

**UI:** Your users should be able to use your application without any documentation. For complex or very domain-specific apps, this might not be possible so, if documentation is needed, make sure it’s easy to find, easy to search, and that it answers common questions.

![](https://cdn-images-1.medium.com/max/800/1*uZnbab0y0Hv44odGp7AblQ.png)

Elements like “Help” and “Send feedback” are usually placed at the bottom of the navigation drawer

#### API should be self documenting

**API:** Good naming of methods, classes and members makes an API self documenting. But no matter how good an API is, it won’t be used without a good documentation. This is why every public element — method, class, field, parameter — should be documented. Whatever is easy and obvious for you, as an API developer, might not be as easy and obvious for your API users.

#### Example code should be exemplary

**API:** The code examples have several roles: they help the users understand the purpose of the API, the usage, and also the usage context. **Code snippets** are intended to demonstrate how to access the basic API functionality. **Tutorials** teach developers a specific aspect of the API. **Code samples** are more complex examples, usually an entire application. Of these three, the biggest problems appear when you don’t have code samples because developers are missing the bigger picture — how all of your classes and methods work together and how they should work together with the system.

If your API becomes popular, chances are you will have thousands of developers using those examples and those samples will become the model of how your API should be used. Therefore, every mistake you make will come back to bite you.

* * *

We’ve learned a lot along the years about the usability of user interfaces; we know what our users need and how they think. They want UIs that are intuitive, efficient, correct, that help them do a specific task, in an appropriate way. All of these concepts go beyond UIs and are applied to APIs also, because developers are users too. So let’s help them (and us) and build usable APIs.

> _APIs should be easy to use and hard to misuse — it should be easy to do simple things, possible to do complex things and impossible, or at least difficult, to do wrong things._ Joshua Bloch — [source](https://dl.acm.org/citation.cfm?id=1176622)

* * *

#### References

* [10 Usability Heuristics for User Interface Design](https://www.nngroup.com/articles/ten-usability-heuristics/)
* [http://www.apiusability.org/](http://www.apiusability.org/)
* Myers, B. A., & Stylos, J. (2016). Improving API usability. _Communications of the ACM_, 59(6), 62–69. [PDF](http://www.cs.cmu.edu/~NatProg/papers/API_Usability_Article_submitted.pdf)
* Bloch, J. (2006). How to design a good API and why it matters. _Companion to the 21st ACM SIGPLAN symposium on Object-oriented programming systems, languages, and applications_. ACM. [PDF](https://dl.acm.org/citation.cfm?id=1176622)
* Ellis, B., Stylos, J., & Myers, B. (2007). The factory pattern in API design: A usability evaluation. _Proceedings of the 29th international conference on Software Engineering_. IEEE Computer Society. [PDF](https://www.cs.cmu.edu/afs/cs.cmu.edu/Web/People/NatProg/papers/Ellis2007FactoryUsability.pdf)
* Robillard, M. P. (2009). What makes APIs hard to learn? Answers from developers. _Software, IEEE_, _26_(6), 27–34. [PDF](http://cs.mcgill.ca/~martin/papers/software2009a.pdf)
* Scheller, T., & Kühn, E. (2015). Automated measurement of API usability: The API Concepts Framework. _Information and Software Technology_, _61_, 145–162. [PDF](http://www.researchgate.net/profile/Eva_Kuehn/publication/272027830_Automated_measurement_of_API_usability_The_API_Concepts_Framework/links/55056eff0cf24cee3a047a21.pdf)
* [Preventing User Errors: Avoiding Conscious Mistakes](https://www.nngroup.com/articles/user-mistakes/)
* [Error Message Guidelines](https://www.nngroup.com/articles/error-message-guidelines/)
* [Material Design Patterns and Guidelines](https://material.io/)

Thanks to [Nick Butcher](https://medium.com/@crafty?source=post_page) and [Tao Dong](https://medium.com/@taodong?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
