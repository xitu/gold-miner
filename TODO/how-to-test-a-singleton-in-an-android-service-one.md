> * 原文地址：[How to test a singleton in an Android Service (1)?](http://www.songzhw.com/2016/09/30/how-to-test-a-singleton-in-an-android-service-one/)
* 原文作者：[songzhw](http://github.com/songzhw)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Newt0n](http://github.com/newt0n)
* 校对者：[Graning](https://github.com/Graning), [DeadLion](https://github.com/DeadLion)

# 如何测试 Android Service 里的 Singleton (1)

最近我遇到个大麻烦：如何测试服务里的单例模式？最终我解决了这个问题。而且我觉得整个解决问题的过程是一个绝好的向读者清楚的解释单元测试的机会。限于篇幅，本文是第一篇文章，后面我会再写一篇。

## 我们的服务

    // [PushService.java]
    public class PushService extends Service {
        public void onMessageReceived(String id, Bundle data){
            FooManager.getInstance().receivedMsg(data);
        }
    }

FooManager 是一个实例:

    // [FooManager.java]
    public class FooManager {
        private static FooManager instance = new FooManager();

        private FooManager(){}

        public static FooManager getInstance(){
            return instance;
        }

        public void receivedMsg(Bundle data){
        }
    }

我们应该怎么测试 PushService?

显然，我们想确保 `FooManager` 会调用 `receiveMsg()`，所以我们想要的应该是像下面这样：

    verify(fooManager).receiveMsg(data);

只要是了解 Mockito 的开发者都知道，当我们调用 `verify(fooManager)` 时必须使 `fooManager` 先成为一个模拟对象；否则，程序会抛出异常：`org.mockito.exception.misusing.NotAMockException`

所以我们得先模拟一个 FooManager 的实例。现在我把测试步骤分解成两个小的测试：

1. 模拟一个单例
2. 在服务里模拟一个单例

## 模拟单例(1)

### 第一步 : 用 Mockito 模拟 `FooManager` （失败）

首先写一个测试用例:

    public class FooManagerTest {
        @Test
        public void testSingleton(){
            FooManager mgr = Mockito.mock(FooManager.class);
            Mockito.when(FooManager.getInstance()).thenReturn(mgr);

            FooManager actual = FooManager.getInstance();
            assertEquals(mgr, actual);
        }
    }

运行这个用例时程序抛出了异常:

    org.mockito.exceptions.misusing.MissingMethodInvocationException:
    when() requires an argument which has to be 'a method call on a mock'.
    For example:
        when(mock.getArticles()).thenReturn(articles);
    Also, this error might show up because:
    1\. you stub either of: final/private/equals()/hashCode() methods.
       Those methods *cannot* be stubbed/verified.
       Mocking methods declared on non-public parent classes is not supported.
    2\. inside when() you don't call method on mock but on some other object.

这是因为 Mockito 不能模拟一个静态方法，在这个例子里就是 `getInstance()` 方法。

### 第二步 : 使用 PowerMock

还好我知道 PowerMock 可以模拟静态方法，所以我想换到 PowerMock 试试。

    @RunWith(PowerMockRunner.class)
    @PrepareForTest(FooManager.class)
    public class FooManagerTest {

        @Test
        public void testSingleton(){
            FooManager mgr = Mockito.mock(FooManager.class);
            PowerMockito.mockStatic(FooManager.class);
            Mockito.when(FooManager.getInstance()).thenReturn(mgr);

            FooManager actual = FooManager.getInstance();
            assertEquals(mgr, actual);
        }

    }

是的，我成功了。但必须要注意上面这些代码只有在你的项目是个纯 Java 项目而不是 Android 项目时才能成功。如果想要测试 Android 项目的代码，还会遇到一些其他的问题。

## 测试 Android 代码

### 第三步 : 用单元测试来测试 Android 代码

你也许会想到，因为 Android 项目也是用 Java 写的，所以应该也可以在 `$module$/src/test` 目录里写单元测试的用例。

但是真的可以么？我们来看一个用 JUnit Test 来测试 Android 库代码的例子。

        @Test
        public void testAndroidCode(){
            instance.setArgu(argu);

            instance.doSomething();
            verify(argu).isCalled();
        }

然而，你可能会遇到一个报错：
`java.lang.NoClassDefFoundError: org/apache/http/cookie/Cookie`

除此之外，也可能找不到其他的类，比如 `android/util/Log`, `android/content/Context` 等等。

之所以会报 `NoClassDefFoundError` 错误是因为 JUnit 运行在 JVM 环境，也就是说 JUnit 没有 Android 运行环境。

其实有一个官方的 Android 环境下的测试方案：[Instrumentation 测试](https://developer.android.com/training/testing/unit-testing/instrumented-unit-tests.html)。

但这并不是我们真正想要的。每次运行 Instrumentation 测试，都必须构建整个项目并把 APK 文件推送到手机设备或者模拟器里。所以，这样测试会很慢。并不像 JUnit 那样可以直接在电脑上运行（PC/Mac/Linux）而且并不需要 Android 运行环境。结果就是在电脑上运行 JUnit 测试会比 Instrumentation 测试快得多。

有没有一个方案既包含 Android 环境又能在电脑上运行还能快速的执行测试？当然有，不然我写这篇文章干嘛，答案就是 **Robolectric**！

### 第四步 : Robolectric

前面已经说过，在 Android 模拟器或者物理设备上运行测试是很慢的。构建、部署和启动应用通常要花费 1 分钟或者更久，这样没办法做 TDD（Test-driven development 测试驱动的开发）。

[Robolectric](http://robolectric.org/) 是一个让你可以直接在 IDE 里运行 Android 测试的框架。

[Robolectric](http://robolectric.org/) 做了什么？这有点复杂，不过可以简单的认为 Robolectric 封装了一个 Android.jar 文件在其内部。这样就拥有了 Android 运行环境，因此也就可以在电脑上运行 Android 代码的测试。

下面是一个 Robolectric 的例子：

    @RunWith(RobolectricTestRunner.class)
    public class MyActivityTest {

      @Test
      public void clickingButton_shouldChangeResultsViewText() throws Exception {
        MyActivity activity = Robolectric.setupActivity(MyActivity.class);

        Button button = (Button) activity.findViewById(R.id.button);
        TextView results = (TextView) activity.findViewById(R.id.results);

        button.performClick();
        assertThat(results.getText().toString()).isEqualTo("Robolectric Rocks!");
      }
    }

回到主题，在 Robolectric 的帮助下，我们终于可以直接在电脑环境里测试自己的服务，而且还很快。

### 结论 01

我介绍了如何使用 Robolectric 来快速的测试 Android 代码，以及如何在 Java 环境里模拟单例模式。

但我必须得提醒一下，目前我们仍然无法在 Android 环境里成功的模拟单例模式。我将在下一篇文章里讨论如何解决这个问题。

[如何测试 Android 服务里的单例模式（2）](https://github.com/xitu/gold-miner/blob/master/TODO/how-to-test-a-singleton-in-an-android-service-2.md)


