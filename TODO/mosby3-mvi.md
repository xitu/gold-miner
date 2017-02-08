> * 原文地址：[Reactive Apps with Model-View-Intent - Part1 - Model](http://hannesdorfmann.com/android/mosby3-mvi-1)
* 原文作者：[Hannes Dorfmann](http://hannesdorfmann.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[XHShirley](https://github.com/XHShirley)
* 校对者：[yazhi1992](https://github.com/yazhi1992)，[DeadLion](https://github.com/DeadLion)

# Model-View-Intent 模式下的响应式应用 － 第一部分 － Model（模型） #

当我想明白原来我的模型类一直被我用错了，一大堆以前我遇到的安卓平台相关的问题就都消失了。更重要的是，我终于使用RxJava和模型-视图-意图模型来构建响应式应用了，因为我从来没成功过，尽管我已经构建过很多响应式应用，但与我马上要在博客上写的这一系列不是一个等级的。在第一部分，我想讲讲模型以及为什么模型这么重要。

我说“我的模型类一直被我用错了”是什么意思呢？其实，有很多架构模式可以把视图和模型分开。最受欢迎的几种（至少在安卓开发中）是模型－视图－控制器（MVC），模型－视图－提供器（MVP）以及模型－视图－视图模型（MVVM）。通过观察这些模式的名字，不知道你有没有注意到什么。它们都说到了“模型”。我发现大多数情况下我根本就没有用到模型。

例子：从后台加载一份人员列表。一个“传统的” MVP 实现看起来就像下面这样：

```
class PersonsPresenter extends Presenter<PersonsView> {

  public void load(){
    getView().showLoading(true); // 在屏幕上显示进度条
    backend.loadPersons(new Callback(){
      public void onSuccess(List<Person> persons){
        getView().showPersons(persons); // 在屏幕上显示一份人员名单      
      }

      public void onError(Throwable error){
        getView().showError(error); // 在屏幕上显示一个错误信息      
      }
      
    });
  }
}
```

但是，哪里或者哪个是所谓的“模型”呢？是后台吗？当然不是，那个是业务逻辑。那是名单吗？也不是，那个只是我们的视图显示的一部分，跟加载指示器或错误信息一样。那么，到底哪个是“模型”呢？

在我看来，这里应该有个“模型”类像下面这样：

```
class PersonsModel {
  // 在真实的应用中，属性是私有的
  // 并且会有 getter 方法去获取他们
  final boolean loading;
  final List<Person> persons;
  final Throwable error;

  public(boolean loading, List<Person> persons, Throwable error){
    this.loading = loading;
    this.persons = persons;
    this.error = error;
  }
}
```

然后，Presenter（提供器）可以像这样实现：

```
class PersonsPresenter extends Presenter<PersonsView> {

  public void load(){
    getView().render( new PersonsModel(true, null, null) ); // 显示一个进度条

    backend.loadPersons(new Callback(){
      public void onSuccess(List<Person> persons){
        getView().render( new PersonsModel(false, persons, null) ); // 显示一份人员名单
      }

      public void onError(Throwable error){
          getView().render( new PersonsModel(false, null, error) ); // 显示一个错误信息
      }
    });
  }
}
```

现在，视图有一个模型可以显示在屏幕上。这并不是什么新的概念。Trygve Reenskaug 所定义的最原始的 MVC 有相近的概念：视图观察模型的改变。不幸的是，MVC 这个名词一直被误用于描述很多不同于 Reenskaug 在 1979 年所定义的模式。例如，后端开发者使用 MVC 架构，iOS 使用 VieController。但在 Android 里 MVC 到底意味着什么呢？Activity 是控制器吗？那么 ClickListener 是什么呢？如今，大家对于 MVC 这个名词有很大的误解并且被误用，已经曲解了 Reenskaug 的原意。让我们先不急着讨论 MVC，这可能会让我们偏离正轨。

我们回到我最初的论点。一个“模型”解决了很多我们在安卓开发中常遇到并头疼的问题。

1. 状态问题

2. 屏幕方向的改变

3. 返回栈导航

4. 进程死亡

5. 不可变的单向数据流

6. 可调试且可复现的状态

7. 易测性


让我们一起讨论这几点问题，看看是在 MVP 和 MVVM 模式下，这些问题是如何用“传统”的实现来解决，最后“Model（模型）”是怎么帮助我们绕过通常的陷阱。

## 1. 状态问题 ##

响应式应用 － 真是一个时髦的词语。我用这个词来表达一个应用通过 UI 来响应状态的改变。啊，对，我们有另外一个词：“State（状态）”。什么是 “State” 呢？其实，通常我们把 “State” 描述为我们在屏幕上的所见，比如视图显示进度条时表示“正在加载的状态”。关键在于：我们的前端开发者趋于关注 UI。这并不一定是一件坏事因为最终用户是否会使用我们的应用是由 UI 的好坏决定，而这也决定了一个应用的成败。但是，看一下上面简单的 MVP 例子（没有用到 PersonsModel 的那个）。在这里，UI 的状态是与 Presenter（提供器）协作的，因为显示器会告诉视图需要显示什么。同样地，这也适用于 MVVM。在这篇博客里，我想要区别两种 MVVM 实现：第一种使用安卓的数据绑定，第二种使用 RxJava。在使用数据绑定的 MVVM 模式中，状态直接放在 ViewModel（视图模型）中：

```
class PersonsViewModel {
  ObservableBoolean loading;
  // ……为了提高代码可读性，此处省略其他字段
  public void load(){

    loading.set(true);

    backend.loadPersons(new Callback(){
      public void onSuccess(List<Person> persons){
      loading.set(false);
      // ……其他类似人员名单的东西      
      }

      public void onError(Throwable error){
        loading.set(false);
        // ……其他类似错误信息的东西
      }
    });
  }
}
```

在使用 RxJava 的 MVVM 模式中，我们不使用数据绑定引擎，但是我们绑定 Observable 对象到视图里的 UI 部件上。

```
class RxPersonsViewModel {
  private PublishSubject<Boolean> loading;
  private PublishSubject<List<Person> persons;
  private PublishSubject loadPersonsCommand;

  public RxPersonsViewModel(){
    loadPersonsCommand.flatMap(ignored -> backend.loadPersons())
      .doOnSubscribe(ignored -> loading.onNext(true))
      .doOnTerminate(ignored -> loading.onNext(false))
      .subscribe(persons)
      // 也可能有其它不同的实现
  }

  // 在视图中订阅 (如 Activity / Fragment)
  public Observable<Boolean> loading(){
    return loading;
  }

  // 在视图中订阅 (如 Activity / Fragment)
  public Observable<List<Person>> persons(){
    return persons;
  }

  // 当这个行为被触发时（调用 onNext（）），我们加载人员名单
  public PublishSubject loadPersonsCommand(){
    return loadPersonsCommand;
  }
}
```

当然，这些代码片段并不完美。你的实现也可能看起来完全不同。然而重点在于，在 MVP 和 MVVM 模式下，状态是由 Presenter（提供器）或是 ViewModel（视图模型）驱动。

我们由此可以发现：

1. 业务逻辑有自己的状态，Presenter（提供器）（或是 ViewModel（视图模型））有自己的状态（并且你尝试同步业务逻辑和 Presenter（提供器）两者间的状态，使它们一致），并且 View（视图）可能也有自己的状态（比如，你直接在视图中设置了可见性，或者安卓本身在重建时从绑定中恢复状态）。

2. Presenter（提供器）（或是 ViewModel（视图模型））有很多任意的输入（View (视图）触发一个动作，由 Presenter（提供器）处理）是可以的，但同时，Presenter（提供器）也有很多输出（或者说在 MVP 中 view.showLoading() 或 view.showError() 的输出方式，以及 ViewModel（视图模型）提供的多种 Observable 对象）。这就会导致
当View（视图）,Presenter（提供器）和业务逻辑三者在不同线程工作时的状态冲突。

[![](https://i.ytimg.com/vi_webp/zCwESjEpNdk/maxresdefault.webp)](https://www.youtube.com/embed/zCwESjEpNdk)

最好的情况是，状态冲突只导致了一些可见的问题，例如同时显示了加载指示器（“加载状态”）和错误指示器（“错误状态”）：

而在最坏的情况下，你会收到像 Crashlytics 这样的崩溃反馈工具的严重缺陷报告。并且你将无法重现它而很可能无法修复。

但假如我们有且仅有一个，由下（业务逻辑饿）至上（视图）的可信状态来源呢？实际上，在这篇博客开头提到“Model（模型）”的时候，我们就已经看到了一个相似的概念。

```
class PersonsModel {
  // 在真实的应用中，属性是私有的
  // 并且会有 getter 方法去获取他们
  final boolean loading;
  final List<Person> persons;
  final Throwable error;

  public(boolean loading, List<Person> persons, Throwable error){
    this.loading = loading;
    this.persons = persons;
    this.error = error;
  }
}
```

猜猜怎么着？**模型反应状态**。一旦我们理解了这个，我们就可以解决（同时也可以从源头上避免）很多和状态相关的问题，并且，我的 Presenter（提供器）只有一个输出：**getView().render(PersonsModel)**。这个反应了一个简单的数学函数, **f(x) = y**（也可能是由多个输入的函数的如 f(a,b,c)，但只有一个输出）。可能不是每个人都喜欢数学，但是数学家不知道这样的代码缺陷在哪里，而软件工程师知道。

理解“Model（模型）”并知道如何正确实现它是非常关键的，因为 Model（模型）最后可以解决“状态问题”。

## 2. 屏幕方向的改变 ##

在安卓中，屏幕方向改变是一个具有挑战性的问题。最简单的方法是忽略它，在每次屏幕方向改变的时候重新加载所有东西。这绝对是一个有效的解决方法。大多数情况下，你的应用也离线工作，所以数据从本地数据库或者其他本地缓存而来。所以，当屏幕方向改变后，加载数据非常快。但是，我个人不喜欢看到加载指示器，尽管它只显示几毫秒，因为我认为这不是流畅的用户体验。所以人们（包括我自己）开始使用保留提供器（Presenter）的MVP。即使视图（View）在屏幕方向改变时被分离（和销毁），然而提供器（Presenter）还在内存中，视图（View）可以重新被附着到Presenter上。

同样的概念适用于使用 RxJava 的 MVVM 模式，但是我们要记住，一旦 View（视图）取消订阅 ViewModel（视图模型），可观察的流就会被销毁。你可以对这个主题做些功课作为例子。在使用数据绑定的 MVVM 模式中，ViewModel（视图模型）是通过数据绑定引擎直接绑定在 View（视图）上的。为了避免内存泄漏，我们必须在屏幕方向变化时销毁 ViewModel（视图模型）。

但是，保留 Presenter（提供器） (或 ViewModel（视图模型）)却有个问题：我们如何在屏幕方向变化之前同步视图的状态，使 View（视图）and Presenter (提供器）状态一致。我写了一个 MVP 库叫 [Mosby](https://github.com/sockeqwe/mosby)。它有一个名为 ViewState 的功能，可以使你的业务逻辑与视图状态同步。[Moxy](https://github.com/Arello-Mobile/Moxy) 是另外一个 MVP 库，实现了一种很有趣的方式：通过使用commands（命令）来重现屏幕旋转后视图的状态。

![moxy](http://hannesdorfmann.com/images/mvi-mosby3/moxy.gif)

图片源自 https://github.com/Arello-Mobile/Moxy

我非常确定有其它的方法可以解决视图的状态问题。我们退一步总结那些库想要解决的问题：他们想要解决我们已经讨论过的状态问题。

所以，再一次，用一个“Model（模型）”来反映当前的“状态”，并且用一个方法来“显示” “Model（模型）”解决了这个问题，这跟调用**getView().render(PersonsModel)** 一样简单（当把 View（视图）重新附在 Presenter（提供器）上时使用最近一次的模型）。

## 3. 返回栈导航 ##

当视图不再被使用以后，Presenter（提供器）(或 ViewModel（视图模型）)需要被保留吗？举个例子，如果 Fragment(视图) 已经被另外一个 Fragment 替换因为用户已经导航到别的屏幕上了，那么 Presenter（提供器）就没有视图附着在上面了。如果没有视图附着，显然地，Presenter（提供器）并不能更新来自业务逻辑最新的数据。但如果用户回来会怎么样呢？（即按下返回按钮弹出返回栈）重新加载数据或者重用当前的Presenter（提供器）？这更像是个哲学问题。通常来说，一旦用户返回到前一个屏幕（弹出返回栈），他希望从他离开的地方继续操作。这就是在2中讨论的“恢复视图状态问题”。所以，这个解决方案非常直截了当：使用一个 “Model（模型）”来表示状态，当我们从返回栈回来时，我们只要调用 **getView().render(PersonsModel)** 展示视图。

## 4. 进程死亡 ##

我觉得这是一个安卓开发中的误区：进程死亡是一件坏事情，而且在进程死亡后我们需要库来帮助我们恢复状态（还有 Presenters（提供器） 或者  ViewModels（视图模型））。首先，进程死亡的原因只有一个：安卓运行系统需要提供更多的资源给别的应用或为了节省电量。但是当你的应用在前台运行并且被应用用户使用，这将不会发生。所以，不要试图与平台的规则抗争了。如果你真的有一些需要长时间在后台运行的工作，用 **Service**。因为它是唯一的途径，告诉运行系统你的应用还需要“使用”。

如果进程死亡发生了，安卓会提供一些回调类似 **onSaveInstanceState()** 保存状态。这里又提到状态了。我们应不应该把视图信息保存到 Bundle 里？同样，Presenter（提供器）有没有它自己的状态需要我们保存到 Bundle 里的呢？那业务逻辑状态呢？我们已经了解到：正如在第1，第2和第3点中形容的，我们只需要一个模型累来反映整个状态。这样的话，保存模型到 Bundle 里以及之后恢复它就会很简单了。

但是，我个人认为，大多数时候，重载整个屏幕就像打开第一个应用一样比保存状态更好。试想，NewsReader 应用展示了新闻列表。当我们的应用被杀掉而我们保存了状态。6个小时后用户重新打开我们的应用，状态恢复，我们的应用可能显示的是过时的内容。在这种情境下，不保存模型／状态，而只是重新加载数据也许更合适。

## 5. 不可变的单向数据流 ##

我不准备讲不可变性的优势，因为已经有太多[资源](https://www.quora.com/What-are-the-advantages-and-disadvantages-of-immutable-data-structures)是讨论这个话题的。我们想要不可变的模型（展示状态）。为什么？因为我们想要单一的信息源。我们不希望应用的其它部件在我们传递模型对象的时候修改我们的模型／状态。让我们想象一下，我们准备写一个“计数器”安卓应用。它有增加和减少两个按钮，并且能在 TextView 中显示当前计数器的值。如果我们的模型（在这个例子中是计数器的值－一个整型数）是不可变的，我们怎么改变计数器呢？这个问题问得好。我们并不通过每一次按钮单击直接操控 TextView。观察到：第一，我们的视图应该有 **view.render(…)** 方法。第二，我们的模型是不可变的，所以模型不可能直接被改变。第三，只有一个可信源：业务逻辑。我们让单击事件降低到业务逻辑里。业务逻辑知道当前的模型（也就是有一个当前模型的私有字段）并且会创造一个有增长／降低的数字的新模型。

![Counter](http://hannesdorfmann.com/images/mvi-mosby3/counter.png)

这样我们就建立起了一个单向数据流，而业务逻辑就是这个单一可信源。它创建了不可变的模型实例。但是这看起来对一个简单的计数器过于复杂了。是的，计数器不过是一个简单的应用。大部分的应用从简单开始，但是很快就会变得复杂。我认为单一的数据流河不可变的模型是非常必要的，甚至是对一个简单的应用。它能保证应用在复杂度增长时维持简单（从开发者的角度看）。

## 6. 可调试且可复现的状态 ##

另外，单一的数据流让我们的应用易于调试。下一次，当我们从 Crashlytics 拿到一个崩溃日志，我们能简单复现并修复问题，因为所有需要的信息都附在崩溃日志上，这不是很棒吗？当然，我们所需要的所有信息是当前的模型和用户造成崩溃的行为（也就是单击减少按钮）。这些就是我们复现崩溃所需要的所有东西。而且，那些信息非常容易记录到崩溃日志中。如果不是单一数据流（比如，有人误用 EventBugs 并且把 CounterModels 传得到处都是）和不可变性（我们将没办法确定到底是谁修改了模型），就不会那么简单。

## 7. 易测性 ##


“传统的” MVP 或者 MVVM 改进了应用的易测性。MVC 也是可测的：从来没有人说过我们需要把所有的业务逻辑放进 activity。通过用模型反映状态，我们可以简化单元测试代码，因为只需要检查 **assertEquals(expectedModel, model)**。这消除了很多我们本来需要模拟的对象。另外，这样就移除了很多调用 **Mockito.verify(view, times(1)).showFoo()** 方法的验证测试。最后，测试代码的可读性会更高，也更容易理解和维护，因为我们不需要处理真实代码里的实现细节。

# 结论 #

这一系列博客的第一部分我们讨论了很多理论的东西。我们真的需要一个博客专门说模型吗？我觉得理解模型是非常重要和基本的，它能帮助我们避免难对付的问题。模型并不等于业务逻辑。而是业务逻辑（也就是应用里的用例）生产模型。在第二部分，当我们最后构建好 Model-View-Intent（模型-视图-意图模型）模式的响应式应用后，我们可以看到理论上的模型是怎么实现的。我们马上要构建的示例应用是一个虚拟线上商店。关于你在第二部分想知道的东西，这里有一个短的预告片。敬请期待。

[![](https://i.ytimg.com/vi_webp/rmR9mV1Dsqk/maxresdefault.webp)](https://www.youtube.com/embed/rmR9mV1Dsqk)
