> * 原文地址：[Towards Godless Android Development: How and Why I Kill God Objects](https://www.philosophicalhacker.com/post/towards-godless-android-development-how-and-why-i-kill-god-objects/)
* 原文作者：[Philosophical Hacker](https://www.philosophicalhacker.com)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Danny Lau](https://github.com/Danny1451) 
* 校对者：[skyar2009](https://github.com/skyar2009) , [tanglie](https://github.com/tanglie1993)

![](https://www.philosophicalhacker.com/images/nietzsche.jpg)

# 面向无神论安卓开发：如何和为什么要干掉上帝对象

> 上帝已死... Context 也已经死了。
> 
> –Friedrich Nietszche （或许吧）

不像其他领域中的无神论，面向对象编程中的无神论无可争议地是没毛病的。有些人可能希望学校里有上帝或者政府里有上帝，但是其他条件相同的情况下，没有人真正愿意在他们的编程过程中存在着上帝。

特别是在安卓开发中，我们都知道有一个让我们又爱又恨的上帝: `Context` 。<sup>[\[1\]](#note1)</sup>  这篇文章是关于我为什么要和如何把我的应用中的 `Context` 消灭的，其原因和方法同样也适用于 “杀死“ 其他领域的上帝。

### 为什么我要干掉 Context

虽然 `Context` 是上帝对象，我也知道使用上帝对象有很多不好的地方，但是这并不是我想要移除 Context 的主要原因。事实上，在开始 `TDD` 之后很自然而然地就要想要去干掉 `Context` 了。为什么呢？因为在我们进行 TDD 的时候，主要是忙着进行着一厢情愿的活动：我们为测试的对象写了很多我们想要的接口。Freeman 和 Pryce 这么说道：

> 我们倾向于通过写一个测试来开始，假设它已经有对应的实现了，然后添加任何需要来让它生效 - 这就是 Abelson 和 Sussman 所说的 “一厢情愿的编程” 。<sup>[\[2\]](#note2)</sup>

如果我们仔细地考虑下这种方式，它和[我们不应该构造我们没有的虚拟对象](https://www.philosophicalhacker.com/post/how-we-misuse-mocks-for-android-tests/)的思想很相似，最后，我们既有用该对象的问题域表示的依赖，又有一个适配层。Freeman 和 Pryce 又说过：

> 如果我们不想模拟外部的 API，那我们怎么能测试那些驱动他的代码呢？我们将使用 TDD 在对象的问题域中给其所需要的服务设计接口，而不是直接用外部的库。<sup>[\[3\]](#note3)</sup>


当在测试中第一次给我的对象写这个理想接口时，我发现其实没有一个的类是真正需要 `Context` 的。我的对象们真正需要的是一个获取本地字符串，或者是持久化存储键值对的方法，而这些我们通常都是间接通过 Context 对象来获取的。

当我传入一个与被测试对象的角色关系很清晰的对象，而不是传一个 `Context` 时，我就能够更容易地去理解我的类。

下面是一个例子，假设你需要实现下面的内容：

> 当用户使用 app 三次之后展示一个 “评分弹窗”。用户可以选择给 app 评分，要求下次提醒再评分，或者拒绝评分。如果用户选择了评分，就把他们引导到 Google play store 并且下次不再展示。如果用户选择下次提醒评分，三天之后再次显示弹窗。如果用户拒绝评分的话，那就再也不展示弹窗。

这个功能可能让我们有点小紧张，那就先让[恐惧驱动我们写个测试](https://www.philosophicalhacker.com/post/what-should-we-unit-test/)。

```
@RunWith(MockitoJUnitRunner.class)
public class AppRaterPresenterTests {

  @Mock AskAppRateView askAppRateView;
  @Mock AppUsageStore appUsageStore;

  @Test public void showsRateDialogIfUsedThreeTimes() throws Exception {  

    AskAppRatePresenter askAppRatePresenter = new AskAppRatePresenter(appUsageStore);
    when(appUsageStore.getNumberOfUsages()).thenReturn(3);

    askAppRatePresenter.onAttach(askAppRateView);

    verify(askAppRateView).displayAsk();
  }
}
```
   
在我写这个测试和给 `AskAppRatePresenter` 写理想接口的时候，我不会去考虑应用使用次数是怎么存储的。它们应该是通过 `SharedPreferences` 或者数据库或者是 realm 或者其他方式来存储的，因此，我没有将 `AskAppRatePresenter` 设计成需要 Context 对象。我关心的只有 `AskAppRatePresenter` 有一个获得应用使用次数的方法而已。<sup>[\[4\]](#note4)</sup>

这一步确实让我后面看代码更加容易一点。如果看到 Context 已经被注入到对象里了，我可能真的不知道它是用来做什么的。它是个上帝对象，能够用来干任何事情。但是如果我看到了一个 AppUsageStore 被传进去了，那我就能进一步知道这个 AskAppRatePresenter 是干什么的。<sup>[\[5\]](#note5)</sup>

### 我怎么样干掉 Context

一旦我们写了测试和失败用例，我们可以开始实现我们需要传进去的参数。很明显，在实现里面我们需要一个 `Context` ，但是它是一个 AskAppRatePresenter 不需要知道的细节。这里有两个公认的方式去实现，一种是把 `Context` 传入 AppUsageStore 的构造方法里，这样就能从 `SharedPreferences` 获取存储的信息。

```
class SharedPreferencesAppUsageStore implements AppUsageStore {
    private final SharedPreferences sharedPreferences;

    SharedPreferencesAppUsageStore(Context context) {
      sharedPreferences = context.getSharedPreferences("usage", Context.MODE_PRIVATE);
    }

    @Override public int getNumberOfUsages() {
      return sharedPreferences.getInt("numusages", 0);
    }
  }
}
```

另外一个方法是让使用这个 presenter 的 Activity 去继承 `AppUsageStore` 的接口，然后传一个 Activity 的引用到 `AskAppRatePresenter` 的构造方法中。

```
public class MainActivity extends Activity implements AppUsageStore, AskAppRateView {

    @Override protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      AskAppRatePresenter askAppRatePresenter = new AskAppRatePresenter(this);
      askAppRatePresenter.onAttach(this);
    }

    @Override public int getNumberOfUsages() {
      return getSharedPreferences("usage", Context.MODE_PRIVATE)
          .getInt("usage", 0);
    }
}
```

所以，干掉 `Context` - 或者其他类似的上帝对象 - 的通用方法如下所示：

1. 创造一个代表你真正想从 Context 中获取的内容的接口。
2. 创造一个继承这个接口的类；这个类可能已经是一个 Context 了 （比如：Activity ）
3. 把这个类注入到你的类里面。

### 结论


如果你能够坚持遵循上述的准则，那么所有你感兴趣的代码实际上都不会和 Context 有交互。所有与 `Context` 交互都将在适配层中实现。当你领悟到这一点时，你就能够专心在你感兴趣的代码上 ，并不会因为任何与上帝有关接口而影响你去理解你的代码。

### 注释:

 <a name="note1"></a> 1. `Context` 是一个上帝对象。我们都知道[上帝对象是反设计模式](https://en.wikipedia.org/wiki/God_object), 也许 `Context` 看上去就是一个错误。但是我不这么认为，因为第一，在我[上一篇文章](https://github.com/xitu/gold-miner/blob/master/TODO/why-android-testing-is-so-hard-historical-edition.md)指出的， Android 刚开始的时候非常看重性能，整洁的抽象在那个时候可能是一种消耗计算机性能的奢侈浪费，并不能被接受。第二点，根据 Diane Hackborne 的想法，app 组件被精确定位为和 Android OS 的进行特定交互作用的。他们不是你的典型对象因为他们是由框架实例化的并且他们是庞大的 Android SDK 的一个入口。这两个论点证明了 context 设计成一个上帝对象可能不是一个坏的点子。

 <a name="note2"></a> 2. Steve Freeman 和 Nat Pryce, **测试驱动的面向对象软件开发**, 141.

 <a name="note3"></a> 3. Ibid., 121-122

 <a name="note4"></a> 4. 有趣的是，通过 TDD, 我们无意中就走进了遵循[接口分离原则](https://en.wikipedia.org/wiki/Interface_segregation_principle)的代码中去了。

 <a name="note5"></a> 5. 这说明注入对象的复杂度和我们去理解被注入的类的难易程度是成反相关的。换句话说，一个类的依赖越复杂，那么理解这个类的本身含义就越难。
