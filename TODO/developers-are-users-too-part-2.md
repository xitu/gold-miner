> * 原文地址：[Developers are users too — part 2: 5 More guidelines for a better UI and API usability](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-part-2.md](https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-part-2.md)
> * 译者：[tanglie1993](https://github.com/tanglie1993)
> * 校对者：[corresponding](https://github.com/corresponding)，[hanliuxin5](https://github.com/hanliuxin5)

# 开发者也是用户 - 第二部分：改善 UI 和 API 可用性的五条指导原则

我们对自己与之交互的所有东西的可用性都有相同的预期，包括 UI 和 API。所以，我们用于 UI 的指导原则也可以被转化到 API。我们在前一篇文章中已经看到了前面五条指导原则。现在，是时候看看剩下的了。

[**开发者也是用户 — 第一部分**
_改善 UI 和 API 可用性的五条指导原则_medium.com](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc)

### 6. 识别而不是回忆

**UI:** 识别出熟悉的事物所耗费的认知代价是最小的，并且它还能被上下文环境所触发。回忆意味着从记忆中取出细节，它需要多很多的时间。从一系列选项中选择，比根据记忆写出选项容易很多。一个使用常见 icon 的简单 UI 是基于识别的，一个命令行界面是基于回忆的。信息和功能应该被设计得明显，符合直觉并且容易使用。

![](https://cdn-images-1.medium.com/max/800/1*eHPxVsUoCufUaKTmMgleTg.png)

铅笔 icon 是一个表示编辑的符号，容易识别，与 app 无关。

#### 使名称清晰、易于理解

A **变量** 名称应该说明它代表什么，而不是如何使用： `isLoading`, `animationDurationMs`.

A **类** 名称应该是一个名词，说明它代表什么：`RoomDatabase`, `Field`.

A **方法** 名称应该是一个动词，说明它做什么：`query()`, `runInTransaction()`.

### 7. 使用的灵活性和效率

**UI:** 你的应用可能被没有经验和经验丰富的用户同时使用。创建一个 UI使其迎合这两种用户的需求，并让他们习惯常用的操作。据说，20% 的功能被 80% 的用户使用。你需要在简洁和功能之间权衡。找出你的 app 中的那 20%，然后把它们变得尽可能简单易用。使用 [逐步展现原则](https://www.nngroup.com/articles/progressive-disclosure/) ，让其他用户在次要的页面使用进阶功能。

![](https://cdn-images-1.medium.com/max/800/1*DenvAOded-MXjFI1v5iXFQ.png)

Wi-Fi 设置默认显示基本选项，但也包含进阶选项。它适合用户的需求。

#### 写有弹性的 API

用户应当能够使用 API 高效地完成任务，因此 API 需要有弹性。比如，在查询数据库时，Room 提供不同的返回值，允许用户进行同步查询，使用LiveData，或者如果他们喜欢的话，使用 RxJava2 中的 API。

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

#### 把相关的方法放在相关的类中

如果一个类和一个开发者写出的代码没有直接关系，那么他通常很难找到其中的某个方法。而且，通常包含大量有用方法的 Util 和 Helper 类会很难找到。在使用 Kotlin 时，解决这个问题的方案是使用 [扩展函数](https://kotlinlang.org/docs/reference/extensions.html)。

### 8. 美观和极简的设计

**UI:** UI 应当保持简单，只包含当时和用户相关的信息。不相关或很少使用的信息应当被删除或者移到其它屏幕，因为它们的存在使用户分心，并且减少了相关信息的重要性。

![](https://cdn-images-1.medium.com/max/800/1*HBsvBFRg_ueZvG5Qfmk3ZA.png)

[Pocket Casts](https://play.google.com/store/apps/details?id=au.com.shiftyjelly.pocketcasts&hl=en_GB) app 使用极简设计

这个播客 app 的集列表页面显示最少量的，和上下文相关的信息：如果用户没有下载某集，这一集的大小和下载页面是可见的；如果用户已经下载，就可以见到时长和播放按钮。同时，对于那些好奇的用户而言，详情页面包含所有这些信息，并且不止于此。

**API:** 用户们有一个目标：用你的 API 更快解决问题。所以把它们的路径做得尽可能短和直接。

#### 不要暴露内部 API 逻辑

**API:** 不必要地暴露 API 内部逻辑会让你的用户困惑，并降低你的 API 的可用性。不要暴露不必要的方法和类。

#### 不要让用户做任何 API 能够做的事情

**API:** 从 22.1.0 开始，Android Support Library 提供 `RecyclerView` 相关的一系列对象，使用户可以基于频繁改变的大型数据集创建 UI 元素。当列表改变时，`RecyclerView.Adapter` 需要被通知哪些数据被更新了。这使得开发者创造他们自己的用于比较列表的方法。在 25.1.0 版本的 Support Library, 这类反复出现的代码被 `[DiffUtil](https://developer.android.com/reference/android/support/v7/util/DiffUtil.html)` 类极大简化了。而且，`DiffUtil` 使用经过优化的算法，减少你需要写的代码量并且增强性能。

### 9. 帮助用户识别、诊断并摆脱错误

**UI:** 向你的用户提供有助于识别、诊断并摆脱错误的错误信息。好的错误信息明确指出有东西出错了，使用礼貌而易读的语言准确描述问题，包含有助于解决问题的建议。避免显示状态码或者异常类名称，用户不会知道如何处理这些信息的。

![](https://cdn-images-1.medium.com/max/800/1*oJ8PMLg3ayTfHR7dOFvGEA.png)

创建事件时的错误信息。 [来源](https://material.io/guidelines/patterns/errors.html#errors-user-input-errors)

在输入区域失去焦点时尽快显示错误信息，不要等到用户点击提交表单的按钮。更不要等到服务端传来错误信息。使用 TextView 的[功能](https://developer.android.com/reference/android/widget/TextView.html#setError%28java.lang.CharSequence%29) 来显示错误信息。如果你在创建一个事件表单，你要通过直接给 UI 控件设置限制的方法，防止用户创建发生在过去的事件。

#### 快速失败

**API:** 一个 bug 被报告得越早，它就会造成越少的损失。因此，失败的最好时机就是在编译期。例如，Room 会在编译期报告任何不正确的查询或者类注解。

如果你不能在编译期失败，最好尽快在运行时失败。

#### 异常应当用于指示异常的情况

**API:** 用户不应当使用在控制流中使用异常。异常应当仅用于例外情况，或者 API 的不正确使用。尽可能使用返回值来指示这些情况，因为捕获并处理异常几乎总是比测试返回值要慢。

例如，试图把 `null` 值插入一个有 `NON NULL` 限制的列中，就是一种异常的情况，会抛出 `SQLiteConstraintException`。

#### 抛出具体的异常。尽量使用已有的异常

**API:** 开发者知道 `IllegalStateException` 和 `IllegalArgumentException` 是什么意思，哪怕他们不知道你的 API 中发生了什么。通过抛出已有的异常来帮助你的 API 用户，使用尽量具体而不是笼统的异常，并好好填写错误信息。

在通过 `[createBitmap](https://developer.android.com/reference/android/graphics/Bitmap.html#createBitmap%28android.graphics.Bitmap,%20int,%20int,%20int,%20int%29)` 方法创建 `Bitmap` 时，你需要提供新 bitmap 的宽高等信息。如果你传入小于 0 的值作为参数，这个方法将会抛出 `IllegalArgumentException`。

#### 错误消息应当准确指示问题

**API:** 为 UI 写错误信息的指导原则，也适用于 API。提供细致的错误信息，以帮助用户修复他们的代码。

比如，在 Room 中，如果一个查找在主线程运行，用户将会获得 `java.lang.IllegalStateException: 不能在主线程访问数据库，因为它有可能把 UI 锁住较长的一段时间`。这表明查询被执行时的状态（在主线程）是不合法的。

### 10. 帮助和文档

**UI:** 你的用户应当能够不用文档使用你的应用。对于非常复杂或者领域专门化的 app，这也许是不可能的。所以，如果需要文档，确保它易于寻找、易于使用，并解答了常见的问题。

![](https://cdn-images-1.medium.com/max/800/1*uZnbab0y0Hv44odGp7AblQ.png)

诸如 “帮助” 或者 “发送反馈” 之类的元素通常在导航菜单底部

#### API 应当是自说明的

**API:** 好的方法、类和成员命名使 API 能够阐明自身的意义。但无论 API 多好，没有好的文档就无法被使用。这就是每个 public 的元素——方法，类，域，参数——应当用文档说明的原因。对于你，一个 API 开发者来说简单易见的东西，也许对于你的 API 用户来说就不那么容易和显然了。

#### 示例代码应该是模范代码

**API:** 示例代码有若干用途：他们帮助用户理解 API 的目的，用途，以及上下文。**代码片段** 用于解释如何使用基本的 API 功能。 **教程** 教用户关于 API 特定层面的知识。**代码示例** 是更加复杂的例子，通常是一整个应用。这三者之中，缺少代码示例会引起最严重的问题，因为开发者看不到整体图景——你所有的方法和类是如何协作的，以及它们是如何与系统协作的。

如果你的 API 流行起来了，有可能会有数以千计的开发者使用这些例子。他们将会成为如何使用你的 API 的例子。因此，你犯的每个错误都会让你自食其果。

* * *

这些年，我们学习了很多关于 UI 可用性的知识；我们知道用户们需要什么，以及他们在想什么。他们需要符合直觉、高效、正确的 UI，并且要能帮助他们用合适的方式完成特定任务。这些概念都不止于 UI，还适用于 API，因为开发者也是用户。所以，让我们通过可用的 API 帮助他们（也是帮助我们自己）吧。

> **API应当易用且不易滥用——它应该易于做简单的事，可能做复杂的事，不可能——至少难以——做错误的事** Joshua Bloch — [source](https://dl.acm.org/citation.cfm?id=1176622)

* * *

#### 参考文献

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

感谢 [Nick Butcher](https://medium.com/@crafty?source=post_page) 和 [Tao Dong](https://medium.com/@taodong?source=post_page).


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
