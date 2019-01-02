> * 原文地址：[TESTING MVP USING ESPRESSO AND MOCKITO](https://josiassena.com/testing-mvp-using-espresso-and-mockito/)
> * 原文作者：[Josias Sena](https://josiassena.com/about-me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[skyar2009](https://github.com/skyar2009)
> * 校对者：[lovexiaov](https://github.com/lovexiaov), [GangsterHyj](https://github.com/GangsterHyj)

# 使用 Espresso 和 Mockito 测试 MVP #

作为软件开发者，我们尽最大努力做正确的事情确保我们并非无能，并且让其他同事以及领导信任我们所写的代码。我们遵守最好的编程习惯、使用好的架构模式，但是有时发现要确切的测试我们所写的代码很难。

就个人而言，我发现一些开源项目的开发者非常善于打造令人惊叹的产品（可以打造任何你可以想象的应用），但是由于某些原因缺乏编写正确测试的能力，甚至一点都没有。

本文是关于如何对广泛应用的 MVP 架构模型进行单元测试的简单教程。

在开始前需要解释一下，本文假设你熟悉 MVP 模型并且之前使用过。本文不会介绍 MVP 模型，也不会介绍它的工作原理。同样，需要提一下的是我使用了一个我喜欢的 MVP 库 —— 由 [Hannes Dorfman](http://hannesdorfmann.com/) 编写的 [Mosby](https://github.com/sockeqwe/mosby)。为了方便起见，我使用了 view 绑定库 [ButterKnife](http://jakewharton.github.io/butterknife/)。

那么这个应用究竟长什么样呢？

这是一个非常简单的 Android 应用，它只做一件事：当点击按钮时隐藏或者显示一个 TextView。

这是应用起初的样子：

![Initial](https://i1.wp.com/www.andevcon.com/hubfs/EVENTS_ASSETS/ANDEVCON/Images/Article_Images/MVP%20Mockito/IVvsdac.png)

这是按钮点击后的样子：

![724E8fE.png](https://i2.wp.com/www.andevcon.com/hubfs/EVENTS_ASSETS/ANDEVCON/Images/Article_Images/MVP%20Mockito/724E8fE.png)

出于文章的需要，我们假设这是一个价值数百万的产品，并且它现在的样子将会持续很长时间。一旦发生变化，我们需要立刻知晓。

应用中有三部分内容：一个有应用名的蓝色工具栏，一个显示 “Hello World” 的 TextView，以及一个控制 TextView 显隐的按钮。

开始前需要做下说明，本文的所有代码都可以在[我的 GitHub ](https://github.com/josias1991/TestingMVP)找到；如果你不想阅读后文，可以放心去直接阅读源码。源码中的注释十分明确。

我们开始吧！

## **Espresso 测试** ##

我们首先对炫酷的 ToolBar 进行测试。毕竟是一个价值数百万的应用，我们需要确保它的正确性。

如下是测试 ToolBar 的完整代码。如果你看不懂这到底是什么鬼，也没关系，后面我们一起过一下。

``` java
@RunWith (AndroidJUnit4.class)
public class MainActivityTest {
 
    @Rule
    public ActivityTestRule activityTestRule =
            new ActivityTestRule&lt;&gt;(MainActivity.class);
 
    @Test
    public void testToolbarDesign() {
        onView(withId(R.id.toolbar)).check(matches(isDisplayed()));
 
        onView(withText(R.string.app_name)).check(matches(withParent(withId(R.id.toolbar))));
 
        onView(withId(R.id.toolbar)).check(matches(withToolbarBackGroundColor()));
    }
 
    private Matcher&lt;? super View&gt; withToolbarBackGroundColor() {
        return new BoundedMatcher&lt;View, View&gt;(View.class) {
            @Override
            public boolean matchesSafely(View view) {
                final ColorDrawable buttonColor = (ColorDrawable) view.getBackground();
 
                return ContextCompat
                        .getColor(activityTestRule.getActivity(), R.color.colorPrimary) ==
                        buttonColor.getColor();
            }
 
            @Override
            public void describeTo(Description description) {
            }
        };
    }
}
``` 

首先，我们需要告诉 JUnit 所执行测试的类型。对应于第一行代码（@runwith (AndroidJUnit4.class)）。它这样声明，“嘿，听着，我将在真机上使用 JUnit4 进行 Android 测试”。

那么 Android 测试到底是什么呢？Android 测试是在 Android 设备上而非电脑上的 [Java 虚拟机 (JVM)](https://en.wikipedia.org/wiki/Java_virtual_machine) 的测试。这就意味着 Android 设备需要连接到电脑以便运行测试。这就使得测试可以访问 Android 框架功能性 API。

测试代码存放在 androidTest 目录。

![android_test_directory](https://i0.wp.com/www.andevcon.com/hs-fs/hubfs/EVENTS_ASSETS/ANDEVCON/Images/Article_Images/MVP%20Mockito/gcpEaEX.png?w=442)

下面我们看一下 “ActivityTestRule”，如下 Android 文档做出了详细的介绍：

**“本规则针对单个 Activity 的功能性测试。测试的 Activity 会在 [Test](http://junit.org/javadoc/latest/org/junit/Test.html) 注释的测试以及 [Before](http://junit.sourceforge.net/javadoc/org/junit/Before.html) 注释的方法运行之前启动。会在测试完成以及 [After](http://junit.sourceforge.net/javadoc/org/junit/After.html) 注释的方法结束后停止。在测试期间可以直接对 Activity 进行操作。”**

本质上是说，“这是我要测试的 Activity”。

下面我们具体看下 testToolBarDesign() 方法具体做了什么。

### **测试 toolbar** ###

``` java    
onView(withId(R.id.toolbar)).check(matches(isDisplayed()));
```

这段测试代码是找到 ID 为 “R.id.toolbar” 的 view，然后检查它的可见性。如果本行代码执行失败，测试会立刻结束并不会进行其余的测试。

``` java    
onView(withText(R.string.app_name)).check(matches(withParent(withId(R.id.toolbar))));
```

这行是说，“嘿，让我们看看是否有文本内容为 R.string.app_name 的 textView ，并且看看它的父 View 的 id 是否为 R.id.toolbar”。

最后一行的测试更有趣一些。它是要确认 toolbar 的背景色是否和应用的首要颜色一致。

``` java
onView(withId(R.id.toolbar)).check(matches(withToolbarBackGroundColor()));
```

Espresso 没有提供直接的方式来做此校验，因此我们需要创建 [Matcher](https://developer.android.com/reference/android/support/test/espresso/matcher/package-summary.html)。Matcher 确切的说是我们前面使用的判断 view 属性是否与预期一致的工具。这里，我们需要匹配首要颜色是否与 toolbar 背景一致。

我们需要创建一个 [Matcher](https://developer.android.com/reference/android/support/test/espresso/matcher/BoundedMatcher.html) 并覆盖 matchesSafely() 方法。该方法里面的代码十分易懂。首先我们获取 toolbar 背景色，然后与应用首要颜色对比。如果相等，返回 true 否则返回 false。

### **测试 TextView 的隐藏/显示** ###

在讲代码之前，我需要说下代码有点长，但是十分易读。我对代码内容作了详细注释。

``` java

@RunWith (AndroidJUnit4.class)
public class MainActivityTest {
 
    @Rule
    public ActivityTestRule activityTestRule =
            new ActivityTestRule&lt;&gt;(MainActivity.class);
            
    // ...
 
    @Test
    public void testHideShowTextView() {
 
        // Check the TextView is displayed with the right text
        onView(withId(R.id.tv_to_show_hide)).check(matches(isDisplayed()));
        onView(withId(R.id.tv_to_show_hide)).check(matches(withText("Hello World!")));
 
        // Check the button is displayed with the right initial text
        onView(withId(R.id.btn_change_visibility)).check(matches(isDisplayed()));
        onView(withId(R.id.btn_change_visibility)).check(matches(withText("Hide")));
 
        // Click on the button
        onView(withId(R.id.btn_change_visibility)).perform(click());
 
        // Check that the TextView is now hidden
        onView(withId(R.id.tv_to_show_hide)).check(matches(not(isDisplayed())));
 
        // Check that the button has the proper text
        onView(withId(R.id.btn_change_visibility)).check(matches(withText("Show")));
 
        // Click on the button
        onView(withId(R.id.btn_change_visibility)).perform(click());
 
        // Check the TextView is displayed again with the right text
        onView(withId(R.id.tv_to_show_hide)).check(matches(isDisplayed()));
        onView(withId(R.id.tv_to_show_hide)).check(matches(withText("Hello World!")));
 
        // Check that the button has the proper text
        onView(withId(R.id.btn_change_visibility)).check(matches(isDisplayed()));
        onView(withId(R.id.btn_change_visibility)).check(matches(withText("Hide")));
    }
    
    // ...
}
```

这段代码主要功能是保证应用打开时，ID 为 “R.id.tv_to_show_hide” 的 TextView 处于显示状态，并且其显示内容为 “Hello World!”

然后检查按钮也是显示状态，并且其文案（默认）显示为 “Hide”。

接着点击按钮。点击按钮十分简单，如何实现的也十分易懂。这里我们对找到相应 ID 的 view 执行 .perform() (而非 “.check”)，并且在其内执行 click() 方法。perform() 方法实际是执行传入的操作。这里对应是 click() 操作。

因为点击了 “Hide” 按钮，我们需要验证 TextView 是否真的隐藏了。具体做法是在 disDisplayed() 方法前置一个 “not()”，并且按钮文案变为 “Show”。其实这就和 java 中的 “!=” 操作符一样。

``` java


@RunWith (AndroidJUnit4.class)
public class MainActivityTest {
    // ...
 
    @Test
    public void testHideShowTextView() {
    
        // ...
 
        // Check that the TextView is now hidden
        onView(withId(R.id.tv_to_show_hide)).check(matches(not(isDisplayed())));
 
        // Check that the button has the proper text
        onView(withId(R.id.btn_change_visibility)).check(matches(withText("Show")));
        
        // ...
    }
    
    // ...
}
``` 

后面的代码是前面代码的反转。再次点击按钮，验证 TextView 重新显示，并且按钮文案符合当前状态。

就这些。

如下是全部的 UI 测试代码：

``` java

@RunWith (AndroidJUnit4.class)
public class MainActivityTest {
 
    @Rule
    public ActivityTestRule activityTestRule =
            new ActivityTestRule&lt;&gt;(MainActivity.class);
 
    @Test
    public void testToolbarDesign() {
        onView(withId(R.id.toolbar)).check(matches(isDisplayed()));
 
        onView(withText(R.string.app_name)).check(matches(withParent(withId(R.id.toolbar))));
 
        onView(withId(R.id.toolbar)).check(matches(withToolbarBackGroundColor()));
    }
 
    @Test
    public void testHideShowTextView() {
 
        // Check the TextView is displayed with the right text
        onView(withId(R.id.tv_to_show_hide)).check(matches(isDisplayed()));
        onView(withId(R.id.tv_to_show_hide)).check(matches(withText("Hello World!")));
 
        // Check the button is displayed with the right initial text
        onView(withId(R.id.btn_change_visibility)).check(matches(isDisplayed()));
        onView(withId(R.id.btn_change_visibility)).check(matches(withText("Hide")));
 
        // Click on the button
        onView(withId(R.id.btn_change_visibility)).perform(click());
 
        // Check that the TextView is now hidden
        onView(withId(R.id.tv_to_show_hide)).check(matches(not(isDisplayed())));
 
        // Check that the button has the proper text
        onView(withId(R.id.btn_change_visibility)).check(matches(withText("Show")));
 
        // Click on the button
        onView(withId(R.id.btn_change_visibility)).perform(click());
 
        // Check the TextView is displayed again with the right text
        onView(withId(R.id.tv_to_show_hide)).check(matches(isDisplayed()));
        onView(withId(R.id.tv_to_show_hide)).check(matches(withText("Hello World!")));
 
        // Check that the button has the proper text
        onView(withId(R.id.btn_change_visibility)).check(matches(isDisplayed()));
        onView(withId(R.id.btn_change_visibility)).check(matches(withText("Hide")));
    }
 
    private Matcher&lt;? super View&gt; withToolbarBackGroundColor() {
        return new BoundedMatcher&lt;View, View&gt;(View.class) {
            @Override
            public boolean matchesSafely(View view) {
                final ColorDrawable buttonColor = (ColorDrawable) view.getBackground();
 
                return ContextCompat
                        .getColor(activityTestRule.getActivity(), R.color.colorPrimary) ==
                        buttonColor.getColor();
            }
 
            @Override
            public void describeTo(Description description) {
            }
        };
    }
}
```

## **单元测试** ##

单元测试最大特点是在本机的 JVM 环境上运行（与 Android 测试不同）。无需连接设备，测试跑的也更快。缺点就是无法访问 Android 框架 API。总之进行 UI 之外的测试时，尽量使用单元测试而非 Android/Instrumentation 测试。测试运行的越快越好。

下面我们看下单元测试的目录。单元测试的位置与 Android 测试不同。

![different_location](https://i1.wp.com/www.andevcon.com/hubfs/EVENTS_ASSETS/ANDEVCON/Images/Article_Images/MVP%20Mockito/mYBjN1x.png)

开始前我们先看下 presenter 以及关于 model 需要考虑的问题。

### **首先看下 presenter** ###

``` java

public class MainPresenterImpl extends MvpBasePresenter implements MainPresenter {
 
    @Override
    public void reverseViewVisibility(final View view) {
        if (view != null) {
            if (view.isShown()) {
                Utils.hideView(view);
 
                setButtonText("Show");
            } else {
                Utils.showView(view);
 
                setButtonText("Hide");
            }
        }
    }
 
    private void setButtonText(final String text) {
        if (isViewAttached()) {
            getView().setButtonText(text);
        }
    }
}
``` 

很简单。两个方法：一个检查 view 是否可见。如果可见就隐藏它，反之显示。之后将按钮的文案改为 “Hide” 或 “Show”。

reverseViewVisibility() 方法调用 “model” 对传入的 view 进行可见性设置。

### **下面看下 model** ###

``` java
public final class Utils {

    // ...

    public static void showView(View view) {
        if (view != null) {
            view.setVisibility(View.VISIBLE);
        }
    }

    public static void hideView(View view) {
        if (view != null) {
            view.setVisibility(View.GONE);
        }
    }
``` 

两个方法：showView(View) 和 hideView(View)。具体功能十分直观。检查 view 是否为 null，不为 null 则对其进行显隐设置。

现在我们对 presenter 和 model 都有所了解了，下面我们开始测试。毕竟这是一个数百万的产品，我们不能有任何错误。

我们首先测试 presenter。当使用 presenter （任何 presenter）时，我们需要确保 view 已与之关联。注意：我们并不测试 view。我们只需要确保 view 的绑定以便确认是否在正确的时间调用了正确的 view 方法。记住，这很重要。

这里我们使用 Mockito 进行测试，就像单元测试那样，我们需要告诉 Android，“嘿，我们需要使用 MockitoJUnitRunner 进行测试。”实际操作时在测试类的顶部添加 @RunWith (MockitoJUnitRunner.class) 即可。

从前面可知我们需要两个东西：一是模拟一个 View （因为 presenter 使用了 View 对象，对其进行显隐控制），另外一个是 presenter。

下面展示了如何使用 Mockito 进行模拟

``` java
@RunWith (MockitoJUnitRunner.class)
public class MainPresenterImplTest {
 
    MainPresenterImpl presenter;
 
    @Before
    public void setUp() throws Exception {
        presenter = new MainPResenterImpl();
        presenter.attachView(Mockito.mock(MainView));
    }
    
    // ...
}
```

我们要写的第一个测试是 “testReverseViewVisibilityFromVisibleToGone”。顾名思义，我们将要验证的是，当可见的 View 被传入 presenter 的 reverseViewVisibility() 方法时，presenter 能正确地设置 View 的可见性。

``` java
   @Test
    public void testReverseViewVisibilityFromVisibleToGone() throws Exception {
        final View view = Mockito.mock(View.class);
        when(view.isShown()).thenReturn(true);

        presenter.reverseViewVisibility(view);

        Mockito.verify(view, Mockito.atLeastOnce()).setVisibility(View.GONE);
        Mockito.verify(presenter.getView(), Mockito.atLeastOnce()).setButtonText(anyString());
    }
```

我们一起看下，这里具体做了什么？由于我们要测试的是 view 从可见到不可见的操作，我们需要 view 一开始是可见的，因此我们希望一开始调用 view 的 isShown() 方法返回是 true。接着，以模拟的 view 作为入参调用 presenter 的 reverseViewVisibility() 方法。现在我们需要确认 view 最近被调用的方法是 setVisibility()，并且设置为 GONE。然后，我们需要确认与 presenter 绑定的 view 的 setButtonText() 方法是否调用。并不难吧？

嗯，接着我们进行相反的测试。在继续阅读下面的代码之前，试着自己想一下怎么做。如何测试从隐藏到显示的情况？根据上面已知的信息思考一下。

代码实现如下：

``` java
    @Test
    public void testReverseViewVisibilityFromGoneToVisible() throws Exception {
        final View view = Mockito.mock(View.class);
        when(view.isShown()).thenReturn(false);

        presenter.reverseViewVisibility(view);

        Mockito.verify(view, Mockito.atLeastOnce()).setVisibility(View.VISIBLE);
        Mockito.verify(presenter.getView(), Mockito.atLeastOnce()).setButtonText(anyString());
    }
```


接着测试 “Model”。和前面一样，我们首先在类顶部添加注解 @RunWith (MockitoJUnitRunner.class) 。

``` java 
@RunWith(MockitoJUnitRunner.class)

publicclassUtilsTest{

    // ...

}
```
 

如前面所说，Utils 类首先检查 view 是否为 null。如果不为 null 将执行显隐操作，反之什么都不会做。

Utils 类的测试十分简单，因此我不再逐行解释，大家直接看代码即可。

``` java
@RunWith (MockitoJUnitRunner.class)
public class UtilsTest {

    @Test
    public void testShowView() throws Exception {
        final View view = Mockito.mock(View.class);

        Utils.showView(view);

        Mockito.verify(view).setVisibility(View.VISIBLE);
    }

    @Test
    public void testHideView() throws Exception {
        final View view = Mockito.mock(View.class);

        Utils.hideView(view);

        Mockito.verify(view).setVisibility(View.GONE);
    }

    @Test
    public void testShowViewWithNullView() throws Exception {
        Utils.showView(null);
    }

    @Test
    public void testHideViewWithNullView() throws Exception {
        Utils.hideView(null);
    }
}
```
 

我解释下 testShowViewWithNullView() 和 testHideViewWithNullView() 方法的作用。为什么要进行这些测试？试想下，我们不希望因为 view 为 null 时调用方法造成整个应用的崩溃。

我们看下 Utils 的 showView() 方法。如果不做 null 检查，当 view 为 null 时应用会抛出 NullPointerException 并崩溃。

``` java
public final class Utils {

    // ...
    
    public static void showView(View view) {
        if (view != null) {
            view.setVisibility(View.VISIBLE);
        }
    }
    
    // ...
}
```

另外一些情况下，我们需要应用抛出一个异常。我们如何测试一个异常？十分简单：只需要对 @Test 注解传递一个 expected 参数进行指定：

``` java
@RunWith (MockitoJUnitRunner.class)
public class UtilsTest {

    // ...

    @Test (expected = NullPointerException.class)
    public void testShowViewWithNullView() throws Exception {
        Utils.showView(null);
    }
}
```

如果没有异常抛出，该测试会失败。

再次提示，你可以在 [GitHub](https://github.com/josias1991/TestingMVP) 获取全部代码。

本文接近尾声，需要提醒大家的是：测试并不总是像本例这样简单，但也不意味着不会如此或不该如此。作为开发者，我们需要确保应用正确的运行。我们需要确保大家信任我们的代码。我已经持续这样做许多年了，你可能无法想象测试拯救了我多少次，甚至是像改变 view ID 这样最简单的事。

没有人是完美的，但是测试让我们趋近完美。保持编码，保持测试，直到永远！

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
