> * 原文地址：[Testing Views in Isolation with Espresso](https://www.novoda.com/blog/testing-views-in-isolation-with-espresso/)
> * 原文作者：本文已获原作者 [Ataul Munim](https://twitter.com/ataulm) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[yazhi1992](https://github.com/yazhi1992)
> * 校对者：[lovexiaov](https://github.com/lovexiaov), [Phoenix](https://github.com/wbinarytree)

# 使用 Espresso 隔离测试视图 #

在这篇文章里，我将会告诉你为何并且如何使用 Espresso 在 Android 设备上测试你的自定义视图。

你可以使用 Espresso 来一次性测试所有界面或流程。这些测试用例会启动某个页面，并像用户一般执行操作，包括等待数据的加载或跳转到其他页面。

这样做是非常有用的，因为你需要端到端的测试用例来验证常见的用户使用流程。这些自动化测试应该定期地执行，从而可以节约手工 QA 的时间来进行探索性测试。

即便如此，这些不是可以频繁运行的测试。运行一整套可能会花费数小时的时间（想象一下验证媒体内容的脱机同步），所以你可以选择在夜间运行它们。

这很困难，因为这些类型的测试包含了多个潜在的故障点。理想情况是，当某个测试失败时，你会希望它是由于单个逻辑断言而导致的。

大多数（或者说很多）可以引入的回归测试点都在 UI 上。这些问题很可能是十分细微的，以至于我们在添加新特性时并不会注意到，但是敏锐的 QA 团队却往往可以。

这样就浪费太多时间了。

## 你能做些什么？ ##

让我们来看下如何使用 Espresso 来测试正确地绑定了数据的视图。

在 Novoda 里，我们编写的大多数视图都是继承自 Android 已有的 View 和 ViewGroup 类。这些视图一般只会暴露了一到两个方法用来绑定回调函数和数据对象/视图模型，如下所示：

```
public class MovieItemView extends RelativeLayout {  
  private TextView titleTextView;
  private Callback callback;

  public void attach(Callback callback) {
    this.callback = callback;
  }

  public void bind(Movie movie) {
    titleTextView.setText(movie.name());
    setOnClickListener(new OnClickListener() {
      @Override 
      public void onClick(View v) {
        callback.onClick(movie);
      }
    });
  }
}
```

他们将 UI 的逻辑部分组合在一起，并且通常还包含来自业务领域的命名规范。在
 Novoda 的页面布局中你很少会看到“原始”的 Android 视图。

让我们使用 BDD 风格来编写这些视图测试，比如“当 MovieItemView 被绑定到 Edward Scissorhands 上，标题就被设置成 Edward Scissorhands”或者“MovieItemView 被绑定到 Edward Scissorhands 上，当点击视图时，onClick(Edward Scissorhands) 就会被调用”，等等。（译者注：BDD（Behaviour Driven Development），倾向于断言被测对象的行为特征而非输入输出。一个典型的 BDD 的测试用例包活完整的三段式上下文，测试大多可以翻译为 `Given-When-Then` 的格式，即某种场景下，发生了事件，导致了什么结果。）

## 难道不能使用单元测试来捕获这些问题吗？ ##

如果你正在使用像 MVP 或者 MVVM 这样可被单元测试的表现模式，为什么还需要 Espresso 来运行这些测试呢？

首先，让我们来看一下展示信息的流程并且描述一下目前所能做的测试，然后再看看使用 Espresso 测试能多做些什么。

- Presenters 订阅发送事件的数据生成器

- 事件可以处于`加载中`，`空闲`或`错误`状态，并且可能带有要展示的数据

- Presenters 将使用 `display(List<Movie>)`，`displayCachedDataWhileLoading(List<Movie>)` 或 `displayEmptyScreen()` 等方法将这些事件转发给“displayers”（MVP 中的“View”）。

- displayers 的具体实现类将显示/隐藏 Android 视图，并执行诸如 `moviesView.bind(List<Movie>)` 之类的操作

你可以对 presenters 进行单元测试，验证是否调用了 displayers 正确的方法并且带有正确的参数。

你可以用相同的方式测试 displayers 吗？是的，你是可以模拟 Android 视图，并验证是否调用了正确的方法。但这样的粒度并不是我们想要的：

- displayer 可能确实构建或更新了 RecyclerView 或 ViewPager 适配器，但这并不代表显示了正确的内容。

- Android 视图是通过在代码中加载 XML（布局和样式）设置的；验证方法的调用不足以断言显示的内容是否正确

## 设置测试用例 ## 

就从使用 [`espresso-support`](https://github.com/novoda/spikes/tree/master/espresso-support) 这个库开始吧。

在你的 build.gradle（JCenter 可用）里添加依赖

```
debugCompile 'com.novoda:espresso-support-extras:0.0.3'  
androidTestCompile 'com.novoda:espresso-support:0.0.3'
```

`extras` 依赖包中包含了 `ViewActivity`，在测试时需要将其添加到你的应用中。你可以在该 Activity 持有想要使用 Espresso 测试的单一视图。

核心部分（包含自定义测试规则）只需要作为 `androidTest` 依赖中的一部分。

`ViewTestRule` 使用方法与 `ActivityTestRule` 类似。只不过是将传递的参数从想要启动的 Activity 类替换成了包含你想要测试的视图的布局文件：

```
@RunWith(AndroidJUnit4.class)publicclassMovieItemViewTest{  
  @Rule
  public ViewTestRule<MovieItemView> viewTestRule=newViewTestRule<>(R.layout.test_movie_item_view);
  ...
```

你可以使用 `ViewTestRule<MovieItemView>` 指定根布局的视图类型。

`ViewTestRule` 继承了 `ActivityTestRule<ViewActivity>`，所以它总会打开 `ViewActivity`。 `getActivityIntent()` 被重写了，所以你可以将 `R.layout.test_movie_item_view` 作为 Intent 的附加数据传递给 `ViewActivity`。

你可以在测试中使用 Mockito 代替回调函数。

```
@Rule
public MockitoRule mockitoRule = MockitoJUnit.rule();

@Mock
MovieItemView.Listener movieItemListener;

@Before
publicvoidsetUp(){  
  MovieItemView view = viewTestRule.getView();
  view.attachListener(movieItemListener);
  ...
 }
```

ViewTestRule 有一个 `bindViewUsing(Binder)` 方法，该方法会返回视图的引用，以便你与之进行交互。当你使用 `viewTestRule.getView()` 直接访问视图时，你会希望与视图的所有交互都是在主线程上执行的，而非测试线程。

```
@Before
public void setUp() {  
  MovieItemView view = viewTestRule.getView();
  view.attachListener(movieItemListener);
  viewTestRule.bindViewUsing(new ViewTestRule.Binder<MovieItemView>() {
    @Override
    public void bind(MovieItemView view) {
      view.bind(EDWARD_SCISSORHANDS);
    }
  });
}
```

## 准备测试 ## 

从用户的角度上来看，应用其实只做了两件事情：

- 展示信息

- 响应用户的操作

要为这两种情况编写测试，你可以先从使用标准的 Espresso ViewMatchers 和 ViewAssertions 语句断言是否显示正确的信息开始：

```
@Test
public void titleSetToMovieName() {  
  onView(withId(R.id.movie_item_text_name))
      .check(matches(withText(EDWARD_SCISSORHANDS.name)));
}
```

接着，你应该确保用户的操作触发了正确的点击事件，并且具有正确的参数：

```
@Test
public void clickMovieItemView() {  
  onView(withClassName(is(MovieItemView.class.getName())))
      .perform(click());

  verify(movieItemListener)
      .onClick(eq(EDWARD_SCISSORHANDS));
}
```

到这里就完成了，希望这些知识对你有用。

在接下来的文章里，我会介绍如何使用 Espresso 测试视图时支持 TalkBack 服务（译者注：Talkback 是一款由谷歌官方开发的系统工具软件，它的定位是帮助盲人或者有视力障碍的用户提供语言辅助）。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
