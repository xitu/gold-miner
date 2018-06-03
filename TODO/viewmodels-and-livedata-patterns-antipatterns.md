> * 原文地址：[ViewModels and LiveData: Patterns + AntiPatterns](https://medium.com/google-developers/viewmodels-and-livedata-patterns-antipatterns-21efaef74a54)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/viewmodels-and-livedata-patterns-antipatterns.md](https://github.com/xitu/gold-miner/blob/master/TODO/viewmodels-and-livedata-patterns-antipatterns.md)
> * 译者：[boileryao](https://github.com/boileryao)
> * 校对者：[Zhiw](https://github.com/Zhiw)  [miguoer](https://github.com/miguoer)

# ViewModel 和 LiveData：为设计模式打 Call 还是唱反调？

## View 层和 ViewModel 层

### 分离职责

![](https://cdn-images-1.medium.com/max/800/1*I9WPcnpGNuI4CjxxrkP0-g.png)

*用 Architecture Components 构建的 APP 中实体的典型交互* 

理想情况下，ViewModel 不应该知道任何关于 Android 的事情（如Activity、Fragment）。 这样会大大改善可测试性，有利于模块化，并且能够减少内存泄漏的风险。一个通用的法则是，你的 ViewModel 中没有导入像 `android.*`这样的包（像 `android.arch.*` 这样的除外)。这个经验也同样适用于 MVP 模式中的 Presenter 。

> ❌ 不要让 ViewModel（或Presenter）直接使用 Android 框架内的类

条件语句、循环和一般的判定等语句应该在 ViewModel 或者应用程序的其他层中完成，而不是在 Activity 或 Fragment 里。视图层通常是没有经过单元测试的（除非你用上了  [Robolectric](http://robolectric.org/)），所以在里面写的代码越少越好。View 应该仅仅负责展示数据以及发送各种事件给 ViewModel 或 Presenter。这被称为 [ Passive _View_](https://martinfowler.com/eaaDev/PassiveScreen.html) 模式。（忧郁的 View，哈哈哈）

> ✅ 保持 Activity 和 Fragment 中的逻辑代码最小化

### ViewModel 中的 View 引用

[ViewModel](https://developer.android.com/topic/libraries/architecture/viewmodel.html) 的生命周期跟 Activity 和 Fragment 不一样。当 ViewModel 正在工作的时候，一个 Activity 可能处于自己 [生命周期](https://developer.android.com/guide/components/activities/activity-lifecycle.html) 的任何状态。 Activity 和 Fragment 可以被销毁并且重新创建， ViewModel 将对此一无所知。

![](https://cdn-images-1.medium.com/max/800/1*86RjXnTJucJMkW4Xi4kUlA.png)

ViewModel 对配置的重新加载（比如屏幕旋转）具有“抗性” ↑

把视图层（Activity 或 Fragment）的引用传递给 ViewModel 是有 **相当大的风险** 的。假设 ViewModel 从网络请求数据，然后由于某些问题，数据返回的时候已经沧海桑田了。这时候，ViewModel 引用的视图层可能已经被销毁或者不可见了。这将产生内存泄漏甚至引起崩溃。

> ❌ 避免在 ViewModel 里持有视图层的引用

推荐使用**观察者模式**作为 ViewModel 层和 View 层的通信方式，可以使用 LiveData 或者其他库中的 Observable 对象作为被观察者。

### 观察者模式

![](https://cdn-images-1.medium.com/max/800/1*hjvCDY_2W4PpK7HQoHsS2Q.png)

一个很方便的设计 Android 应用中的展示层的方法是让视图层（Activity 或 Fragment）去观察 ViewModel 的变化。由于 ViewModel 对 Android 一无所知，它也就不知道 Android 是多么频繁的干掉视图层的小伙伴。这样有几个好处：

1. ViewModel 在配置重新加载（比如屏幕旋转）的时候是不会变化的，所以没有必要从外部（比如网络和数据库）重新获取数据。
2. 当耗时操作结束后，ViewModel 中的“被观察者”被更新，无论这些数据**当前**有没有观察者。这样不会有尝试直接更新不存在的视图的情况，也就不会有 `NullPointerException`。
3. ViewModel 不持有视图层的引用，这大大减少了内存泄漏的风险。

```
private void subscribeToModel() {
  // Observe product data
  viewModel.getObservableProduct().observe(this, new Observer<Product>() {
      @Override
      public void onChanged(@Nullable Product product) {
        mTitle.setText(product.title);
      }
  });
}
```

Activity / Fragment 中的一个典型“订阅”案例。

> ✅ 让 UI 观察数据的变化，而不是直接向 UI 推送数据

## 臃肿的 ViewModel

能减轻你的担心的主意一定是个好主意。如果你的 ViewModel 里代码太多、承担了太多职责，试着去：

* 将一些代码移到一个和 ViewModel 具有相同生命周期的 Presenter。让 Presenter 来跟应用的其他部分进行沟通并更新 ViewModel 中持有的 LiveData。
* 添加一个 Domain 层，使用 [Clean Architecture](https://8thlight.com/blog/uncle-bob/2012/08/13/the-clean-architecture.html) 架构。 这个架构很方便测试和维护，同时它也有助于快速的脱离主线程。 [Architecture Blueprints](https://github.com/googlesamples/android-architecture) 里面有关于 Clean Architecture 的示例。

> ✅ 把代码职责分散出去。如果需要的话，加上一个 Domain 层。

## 使用数据仓库（Data Repository）

就像 [Guide to App Architecture（应用架构指南）](https://developer.android.com/topic/libraries/architecture/guide.html) 里说的那样，大多数 APP 有多个数据源，比如：

1. 远程：网络、云端
2. 本地：数据库、文件
3. 内存中的缓存

在应用中放一个数据层是一个好主意，数据层完全不关心展示层（`MVP` 中的 `P`）。由于保持缓存和数据库与网络同步的算法通常很琐碎复杂，所以建议为每个仓库创建一个类作为处理同步的单一入口。

如果是许多种并且差别很大的数据模型，考虑使用多个数据仓库。

> ✅  添加数据仓库作为数据访问的单一入口。

## 关于数据状态

考虑一下这种情况：你正在观察一个 ViewModel 暴露出来的 LiveData，它包含了一个待显示数据的列表。视图层该如何区分被加载的数据，网络错误和空列表呢？

* 你可以从 ViewModel 中暴露出一个 `LiveData<MyDataState>` 。 `MyDataState` 可能包含数据是正在加载还是已经加载成功、失败的信息。

![](https://cdn-images-1.medium.com/max/800/1*Hj8ChdU7pakjcM3kxj_Fzg.png)

可以将类中有状态和其他元数据（比如错误信息）的数据封装到一个类。参见示例代码中的 [Resource](https://developer.android.com/topic/libraries/architecture/guide.html#addendum) 类。

> ✅ 使用一个包装类或者 LiveData 来暴露状态信息。

## 保存 Activity 的状态

Activity 的状态是指在 Activity 消失时重新创建屏幕内容所需的信息，Activity 消失意味着被销毁或进程被终止。旋转屏幕是最明显的情况，我们已经在 ViewModel 部分提到了。保存在 ViewModel 的状态是安全的。

但是，你可能需要在其他 ViewModel 也消失的场景中恢复状态。例如，当操作系统因资源不足杀死进程时。

为了高效地保存和恢复 UI 状态，组合使用 `onSaveInstanceState()` 和 ViewModel。

这里有个示例：[ViewModels: Persistence, onSaveInstanceState(), Restoring UI State and Loaders](https://medium.com/google-developers/viewmodels-persistence-onsaveinstancestate-restoring-ui-state-and-loaders-fc7cc4a6c090)

## 事件

我们管只发生一次的操作叫做事件。 ViewModels 暴露数据，但对于事件怎么样呢？例如，导航事件或显示 Snackbar 消息等应该仅被执行一次的操作。

事件的概念并不能和 LiveData 存取数据的方式完美匹配。来看下面这个从 ViewModel 中取出来的字段：

```
LiveData<String> snackbarMessage = new MutableLiveData<>();
```

一个 Activity 开始观察这个字段，ViewModel 完成了一个操作，所以需要更新消息：

```
snackbarMessage.setValue("Item saved!");
```

显然，Activity 接收到这个值后会显示出来一个 SnackBar。

但是，如果用户旋转手机，则新的 Activity 被创建并开始观察这个字段。当对 LiveData 的观察开始时，Activity 会立即收到已经使用过的值，这将导致消息再次显示！

在示例中，我们继承 LiveData 创建一个叫做 [SingleLiveEvent](https://github.com/googlesamples/android-architecture/blob/dev-todo-mvvm-live/todoapp/app/src/main/java/com/example/android/architecture/blueprints/todoapp/SingleLiveEvent.java) 的类来解决这个问题。它仅仅发送发生在订阅后的更新，要注意的是这个类只支持一个观察者。

> ✅ 使用像 [SingleLiveEvent](https://github.com/googlesamples/android-architecture/blob/dev-todo-mvvm-live/todoapp/app/src/main/java/com/example/android/architecture/blueprints/todoapp/SingleLiveEvent.java) 这样的 observable 来处理导航栏或者 SnackBar 显示消息这样的情况

## ViewModels 的泄漏问题

响应式范例在 Android 中运行良好，它允许在 UI 和应用程序的其他层之间建立方便的联系。 LiveData 是这个架构的关键组件，因此通常你的 Activity 和 Fragment 会观察 LiveData 实例。

ViewModel 如何与其他组件进行通信取决于你，但要注意泄漏问题和边界情况。看下面这个图，其中 Presenter 层使用观察者模式，数据层使用回调：

![](https://cdn-images-1.medium.com/max/800/1*0BaDp6eyWAEkUwmprKC9Rg.png)

*UI 中的观察者模式和数据层中的回凋*

如果用户退出 APP，视图就消失了所以 ViewModel 也没有观察者了。如果数据仓库是个单例或者是和 Application 的生命周期绑定的，**这个数据仓库在进程被杀掉之前都不会被销毁**。这只会发生在系统需要资源或用户手动杀死应用程序时，如果数据仓库在 ViewModel 中持有对回调的引用，ViewModel 将发生暂时的内存泄漏。

![](https://cdn-images-1.medium.com/max/800/1*OYyXV-qPtgmAlbDjI640KA.png)

*Activity 已经被销毁了但是 ViewModel 还在苟且*

如果是一个轻量级 ViewModel 或可以保证操作快速完成，这个泄漏并不是什么大问题。但是，情况并不总是这样。理想情况下，ViewModels 在没有任何观察者的情况下不应该持有 ViewModel 的引用：

![](https://cdn-images-1.medium.com/max/800/1*y1Zimc4SFMentSLsk6VCcQ.png)

实现这种机制有很多方法：

* **通过 ViewModel.onCleared()** 可以通知数据仓库丢掉对 ViewModel 的回凋。
* 在数据仓库中可以使用 **WeakReference** 或者直接使用 **Event Bus**（二者都很容易被误用甚至可能会带来坏处）。
* 使用 LiveData 在数据仓库和 ViewModel 中通信。就像 View 和 ViewModel 之间那样。

> ✅ 考虑边界情况，泄漏以及长时间的操作会对架构中的实例带来哪些影响。

> ❌ 不要将保存原始状态和数据相关的逻辑放在 ViewModel 中。任何从 ViewModel 所做的调用都可能是数据相关的。

## 数据仓库中的 LiveData

为了避免泄露 ViewModel 和回调地狱（嵌套的回凋形成的“箭头”代码），可以像这样观察数据仓库：

![](https://cdn-images-1.medium.com/max/800/1*Ptw2Z3PyvOKCamvRHQsyCQ.png)

当 ViewModel 被移除或者视图的生命周期结束，订阅被清除：

![](https://cdn-images-1.medium.com/max/800/1*y1Zimc4SFMentSLsk6VCcQ.png)

如果尝试这种方法，有个问题：如果无法访问 LifecycleOwner ，如何从 ViewModel 中订阅数据仓库呢？ 使用 [Transformations](https://developer.android.com/topic/libraries/architecture/livedata.html#transformations_of_livedata) 是个很简单的解决方法。 `Transformations.switchMap` 允许你创建响应其他 LiveData 实例的改变的 LiveData ，它还允许在调用链上传递观察者的生命周期信息：

```
LiveData<Repo> repo = Transformations.switchMap(repoIdLiveData, repoId -> {
        if (repoId.isEmpty()) {
            return AbsentLiveData.create();
        }
        return repository.loadRepo(repoId);
    }
);
```

在这个例子中，当触发器得到一个更新时，该函数被调用并且结果被分发到下游。 当一个 Activity 观察到`repo` 时，相同的 LifecycleOwner 将用于 `repository.loadRepo(id)` 调用。

> ✅  当需要在 [ViewModel](https://developer.android.com/reference/android/arch/lifecycle/ViewModel.html) 中需要 [Lifecycle](https://developer.android.com/reference/android/arch/lifecycle/Lifecycle.html) 对象时，使用 [Transformation](https://developer.android.com/topic/libraries/architecture/livedata.html#transformations_of_livedata) 可能是个好办法。

## 继承 LiveData

LiveData 最常见的用例是在 ViewModel 中使用 `MutableLiveData` 并且将它们暴露为 `LiveData` 来保证观察者不会改变他们。

如果你需要更多功能，扩展 LiveData 会让你知道什么时候有活跃的观察者。例如，当想要开始监听位置或传感器服务时，这将很有用。

```
public class MyLiveData extends LiveData<MyData> {

    public MyLiveData(Context context) {
        // Initialize service
    }

    @Override
    protected void onActive() {
        // Start listening
    }

    @Override
    protected void onInactive() {
        // Stop listening
    }
}
```

### 什么时候不该继承 LiveData

使用 `onActive()` 来启动加载数据的服务是可以的，但是如果你没有一个很好的理由这样做的话就不要这样做，没有必要非得等到 LiveData 开始被观察才加载数据。一些通用的模式是这样的：

* 为 ViewModel 添加 `start()` 方法，并尽早调用这个方法。 (参见[Blueprints example](https://github.com/googlesamples/android-architecture/blob/dev-todo-mvvm-live/todoapp/app/src/main/java/com/example/android/architecture/blueprints/todoapp/addedittask/AddEditTaskFragment.java#L64) )
* 设置一个控制启动加载的属性 (参见 [GithubBrowserExample](https://github.com/googlesamples/android-architecture-components/blob/master/GithubBrowserSample/app/src/main/java/com/android/example/github/ui/repo/RepoFragment.java#L81) ）

> ❌ 通常不用拓展 LiveData。可以让 Activity 或 Fragment 告诉 ViewModel 什么时候开始加载数据。

[^是否需要关于 Architecture Component 的其他任何主题的指导（或意见）？留下评论！]:  

感谢 [Lyla Fujiwara](https://medium.com/@lylalyla?source=post_page)、[Daniel Galpin](https://medium.com/@dagalpin?source=post_page)、[Wojtek Kaliciński](https://medium.com/@wkalicinski?source=post_page) 和 [Florina Muntenescu](https://medium.com/@florina.muntenescu?source=post_page)。

----

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
