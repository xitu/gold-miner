> * 原文地址：[Developers are users too — part 1: 5 Guidelines for a better UI and API usability](https://medium.com/google-developers/developers-are-users-too-part-1-c753483a50dc)
> * 原文作者：[Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-part-1.md)
> * 译者：[lsvih](https://github.com/lsvih)
> * 校对者：[tanglie1993](https://github.com/tanglie1993), [hanliuxin5](https://github.com/hanliuxin5)

# 开发者也是用户 — 第一部分：构建更具可用性的 UI 与 API 的 5 个方针

![](https://cdn-images-1.medium.com/max/2000/1*OUzDeiHZ1Dfe2grlecdC1g.png)

在前一篇文章中，我们探讨了 UI 可用性与 API 可用性的重要性，并说明了 UI 可用性原则可以应用于 API。下面是前文链接：

[**开发者也是用户 - 简介**
_可用性 - 学于 UI，用于 API_](https://github.com/xitu/gold-miner/blob/master/TODO/developers-are-users-too-introduction.md)

在本文中，我们将具体讨论前 5 条可用性方针：

1. 系统状态的可见性
2. 让系统符合真实世界
3. 为用户提供自由的操作方式
4. 一致性与标准
5. 预防错误的发生

### 1. 系统状态的可见性

> 系统应当在合理的时间，通过合适的反馈，让用户了解它正在做什么。

**UI：**当用户进行一项需要耗费较长时间的操作时，应告知用户操作的进度。例如，在加载图片时显示一个进度条，在上传下载文件时显示百分比。应当让用户知道正在让他们等待的是什么，需要花多长时间。

![](https://cdn-images-1.medium.com/max/800/1*uyWN73Fvr91jvuw9AfrUTQ.gif)

上图：告知用户当前状态。[图片来源](https://material.io/guidelines/components/progress-activity.html#progress-activity-types-of-indicators)

**API：**API 应当提供某种可以查询当前状态的方式。例如，[`AnimatedVectorDrawable`](https://developer.android.com/reference/android/graphics/drawable/AnimatedVectorDrawable.html) 类提供了一个方法来检查动画是否正在运行：

```
boolean isAnimationRunning = avd.isRunning();
```

API 可以采用回调机制来给出反馈，让 API 用户知道对象在何时改变了状态 —— 类似于动画开始与结束时的通知。例如，[`AnimatedVectorDrawable`](https://developer.android.com/reference/android/graphics/drawable/AnimatedVectorDrawable.html) 对象可以 [registering](https://developer.android.com/reference/android/graphics/drawable/AnimatedVectorDrawable.html#registerAnimationCallback%28android.graphics.drawable.Animatable2.AnimationCallback%29) 一个 [`AnimationCallback`](https://developer.android.com/reference/android/graphics/drawable/Animatable2.html#registerAnimationCallback%28android.graphics.drawable.Animatable2.AnimationCallback%29) 来完成上述操作。

### 2. 让系统符合真实世界

> 应用程序应当“说”用户的语言，使用用户熟悉的短语和概念，而不应该使用面向系统的术语。

![](https://cdn-images-1.medium.com/max/800/0*wSpL4tOdQ80XTC-B.)

上图：使用用户熟悉的概念。[图片来源](https://material.io/guidelines/style/writing.html#writing-language)

#### 类与方法的命名应符合用户的预期

**API：**当在一个新的 API 中查找类时，用户可能无从下手，因而依赖之前使用类似 API 的经验，或者依赖在 API 领域通用的观念。例如，当使用 Glide 或者 Picasso 下载并展示图片时，用户很可能会去查找名为“load”或“download”的方法。

### 3. 为用户提供自由的操作方式

> 为用户提供撤销操作的机会。

**UI：**某些用户发起的操作可能含有歧义，例如“删除”或“存档”邮件。此时应显示一条消息让用户确认，并允许用户撤销此操作。

![](https://cdn-images-1.medium.com/max/800/1*6ZgbBYTkeyh-LrA96T8Nuw.png)

上图：允许用户撤销当前操作。[图片来源](http://Elements%20like%20“Help”%20and%20“Send%20feedback”%20are%20usually%20placed%20at%20the%20bottom%20of%20the%20navigation%20drawer.)

#### API 应允许中断或重置操作，并能简单地将 API 恢复到正常状态

**API：**例如，Retrofit 提供了一个 [Call#cancel](https://square.github.io/retrofit/2.x/retrofit/retrofit2/Call.html#cancel--) 的方法，此方法会尝试取消飞行模式下的 call 调用，以及取消还未被 execute 执行的 call 调用，让其之后也不再会执行。此外，如果你在使用 NotificationManager，你会发现既可以创建通知也可以取消[（cancel）](https://developer.android.com/reference/android/app/NotificationManager.html#cancel%28int%29)通知。

### 4. 一致性与标准

> 你的应用程序的用户不应该去思考不同的文本、情景或者操作是否有着同样的意义。

**UI：**与你的 app 进行交互的用户在此之前已经通过与其它 app 交互得到了训练，他们会希望各个应用的可交互元素的样式与行为都相同。如果偏离了这些惯例，那么用户就会更容易出错。

因此，UI 需要与平台保持一致，并使用用户熟悉的 UI 控件，以方便用户快速识别并使用它们。此外，一致性应当贯穿你的整个应用。在 app 的不同界面中，使用相同的文字与图表来表示相同的东西。例如，在你的 app 中用户可以修改多个元素，那么请使用相同的修改图标。

![](https://cdn-images-1.medium.com/max/800/0*ioWpCsAMsI7gRHxo.)

上图：对话框应该与平台保持一致。[图片来源](https://material.io/guidelines/usability/accessibility.html#accessibility-implementation)

**API：**所有的 API 设计都应遵循一致性原则。

#### 各个方法应保持命名的一致性

请参考下面的例子。假设我们有一个 interface 暴露了两个设置不同类型 observer 的方法：

```
public interface MyInterface {
    
    void registerContentObserver(ContentObserver observer);
    void addDataSetObserver(DataSetObserver observer);
}
```

使用它的用户可能会思考：`register…Observer` 和 `add…Observer` 究竟有什么区别呢？是否一个方法一次接受一个 observer，另一个方法一次可以接受多个 observer 呢？开发者要么去认真阅读文档，要么去查找 interface 的实现，来研究两个方法的行为是否相同。

```
private List<ContentObserver> contentObservers;
private List<DataSetObserver> dataSetObservers;
public void registerContentObserver(ContentObserver observer) {
    contentObservers.add(observer);
}
public void addDataSetObserver(DataSetObserver observer){
    dataSetObservers.add(observer);
}
```

因此，请为做同样事情的方法进行 **相同的命名**。

可以在命名时考虑使用**反义词**，例如：get - set，add - remove，subscribe - unsubscribe，show - dismiss。

#### 各个方法应保持参数顺序的一致性

在重载方法时，需要确保在新旧方法中都存在的参数的顺序保持一致。否则，你的 API 用户将要花更多的时间来理解重载与被重载方法的区别。

```
void setNotificationUri( ContentResolver cr,
                         Uri notifyUri);
void setNotificationUri( Uri notifyUri,
                         ContentResolver cr,
                         int userHandle);
```

#### 避免在函数中使用连续的、同类型的参数

虽然在 Android Studio 中，使用连续的多个相同类型的参数是件简单的事情，但是这样做很容易导致参数顺序出错，并且很难找到这种错误。参数的顺序应当尽可能与参数的逻辑顺序一致。

![](https://cdn-images-1.medium.com/max/800/0*2oT4UN19rU1q_aJI.)

当这些参数的类型都相同时，用户很容易犯错。例如上图中 county 和 country 就弄反了。

为了解决这种问题，你可以使用建造者模式，或者应用 Kotlin 的 [命名参数（named parameters）](https://kotlinlang.org/docs/reference/functions.html)。

#### 方法的参数应不大于 4 个

参数越多，意味着方法越复杂。用户需要理解每个参数在方法中起到的作用以及与其它参数的关系，也就是说每增加一个参数都会导致方法的复杂度呈指数形式增加。当一个方法的参数超过 4 个时，就可以考虑将其中一些参数封装在其它类中或使用构造器了。

#### 返回值会影响方法的复杂度

当一个方法返回某个值时，开发者需要知道这个值代表着什么，如何存储它等。如果不需要用到这个值，那么它也不应当对方法的复杂度造成影响。

例如，当向数据库插入一个元素时，Room 既可以返回 `Long` 也可以返回 `void`。如用户需要使用返回值时，首先需要了解此返回值的意义，以及如何存储它。而在不需要返回值时，用户可以使用 void 类型方法。

```
@Insert
Long insertData(Data data);
@Insert
void insertData(Data data);
```

因此，你应当允许 API 用户自己决定是否需要返回值。如果你正在开发一个基于代码生成器的库，应该允许其生成返回多种可选类型的方法。

### 5. 预防错误的发生

> 创建防范于未然的设计。

**UI：**用户经常会一心多用，因此你应当防止用户在无意识下造成的错误，减少用户“翻车”的机会。比方说你可以在毁灭性操作前弹框要求确认，或者提供正确的缺省值。

比如，Google Photos 应用会弹出一个确认框来确保你删除相册不是误操作；而 Inbox 的“邮件稍后提醒”功能仅需一键操作。

![](https://cdn-images-1.medium.com/max/800/1*qLkM_Zm1bR15IgbFZiKMRQ.png)

上图：Google Photo 在毁灭性操作前弹出确认框；Inbox 在暂停收件操作时提供方便选择的缺省值。

#### API 应该引导用户正确地使用 API。尽可能使用缺省值。

API 应当易于使用，且能防止误用。通过提供缺省值可以帮助用户正确使用 API。例如，当创建 Room 数据库时，有一个缺省值可以确保在升级数据库版本时数据不丢失。由于数据库版本对用户来说是透明的，又因为升级时数据会保持，所以使用 Room 的应用程序对用户来说易用性更好。

与此同时，Room 也提供了一个方法 [`fallbackToDestructiveMigration`](https://developer.android.com/reference/android/arch/persistence/room/RoomDatabase.Builder.html#fallbackToDestructiveMigration%28%29) 用于改变这种行为，如果没有提供迁移方法，那么在数据库版本改变时会销毁并重新创建数据库。

* * *


深入了解另外 5 条原则请访问：
[让用户认知，而不是回忆](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#b705)
[弹性、高效的使用方式](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#0709)
[优雅、极简的设计](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#3033)
[帮助用户认识、判断、改正错误](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#d40e)
[提供帮助与文档](https://medium.com/google-developers/developers-are-users-too-part-2-96e03fe17535#e86b)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

