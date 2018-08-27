> * 原文地址：[How to test a singleton in an Android Service (2)?](http://www.songzhw.com/2016/10/03/how-to-test-a-singleton-in-an-android-service-2/)
* 原文作者：[songzhw](http://github.com/songzhw)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Newt0n](https://github.com/newt0n)
* 校对者：[Graning](https://github.com/Graning), [hackerkevin](https://github.com/hackerkevin)

# 如何测试 Android Service 里的 Singleton (2)

上一篇文章介绍了如何测试单例模式（**PowerMock**!），还有如何对 Android 代码做单元测试（**Robolectric**!）。现在我们想要测试一个 Service 中的单例应该会很容易了吧？

### 第一次尝试: 结合 PowerMock 和 Robolectric (1)

    // src/PushService
    // [PushService.java]
    public class PushService extends Service {
        public void onMessageReceived(String id, Bundle data){
            FooManager.getInstance().receivedMsg(data);
        }
    }

我试着结合 PowerMock 和 Robolectric 然后写了个测试用例：

    // test/PushServiceTest
    @RunWith(RobolectricTestRunner.class)
    // @RunWith(PowerMockRunner.class)
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

很快，我就发现陷入了两难。即可以用 `@RunWith(RobolectricTestRunner.class)` 也可以用 `@RunWith(PowerMockRunner.class)`，但不能两个一起用！一旦可以同时使用这两个语句，意味着可以随意选择使用 Robolectric 或者 PowerMock，但我没办法结合他们。

### 第二次尝试: 结合 PowerMock 和 Robolectric (2)

我尝试着 Google 可行的解决方案，谢天谢地竟然让我找到了一个。这个方案由 Robolectric 发布在：[https://github.com/robolectric/robolectric/wiki/Using-PowerMock](https://github.com/robolectric/robolectric/wiki/Using-PowerMock)

这篇文章建议我们添加如下语句:

    @RunWith(RobolectricTestRunner.class)
    @Config(constants = BuildConfig.class, sdk = 21)
    @PowerMockIgnore({ "org.mockito.*", "org.robolectric.*", "android.*" })
    @PrepareForTest(Static.class)
    public class DeckardActivityTest {
        ...
    }

我按照文章说的做了，然后试着运行测试，但还是失败了。这一次的报错信息是：

    com.thoughtworks.xstream.converters.ConversionException: Cannot convert type org.apache.tools.ant.Project to type org.apache.tools.ant.Project
    ---- Debugging information ----

然后我接着 Google，这一次我找到了一个 Github 上的 Issue [github.com/Robolectric](https://github.com/robolectric/robolectric/pull/2390)。在这个 Issue 里有人提到：

    很遗憾我们在 10 月以前都没法实现整合 Powermock，但如果有人愿意帮忙修复这个问题我们也非常欢迎。

    最好的解决当务之急的办法就是让你的代码变得可测试，这样就不用去模拟静态方法了。

现在我意识到目前还没有能够同时使用 PowerMock 和 Robolectric 的方案。可能在 10 月（2016年）的时候会有，但现在（2016 年 9 月）我必须测试服务里的单例，怎么才能做到？

### 第三次尝试: 解耦单例

现在我们知道 PowerMock + Robolectric 的方案已经没有希望了，那我们还能不能测试服务里的单例？

还是有办法的，就像前面说的『单例模式被认为是不够好的，因为它使得单元测试和调试变得困难。它需要明确的指定单例对象的类型以至于耦合度过高。』。所以我们希望能创造个实现依赖注入的机会，而不是紧耦合的用具体的单例对象来初始化。

回到我们的例子，如果使用单例，代码应该是这样：

    // [PushService.java]
    public class PushService extends Service {
        public void onMessageReceived(String id, Bundle data){
            FooManager.getInstance().receivedMsg(data);
        }
    }

而使用依赖注入，重写后的代码应该是这样：

    // [PushService.java]
    public class PushService extends Service {
        public FooManager fooManager;    

        public void onMessageReceived(String id, Bundle data){
            fooManager.receivedMsg(data);
        }
    }

在这个例子里，`FooManager` 在服务的外层被创建，这样就有了注入或模拟我们自己的实例的机会。这样一来我们的测试代码可以这样写：

    @RunWith(RobolectricTestRunner.class)  // Use Robolectric to test Service with JUnit
    @Config(constants = BuildConfig.class, sdk = 21) 
    public class PushServiceTest {
        @Test
        public void testReceivedMessage_Singleton(){
            FooManager mgr = mock(FooManager.class);
            service.fooManager = mgr;
            service.onMessageReceived("23", data);
            verify(service.fooManager).receivedMsg(data);
        }
    }

问题解决了。我们对在服务里初始化对象做了解耦，做到了让测试用例可以模拟单例类的实例，这一点非常重要，[为了写出可测试的代码, 必须把对象的实例化和业务逻辑分开。](http://codeahoy.com/2016/05/27/avoid-singletons-to-write-testable-code/)

## 结论 02

单例模式，由于提供了一个全局的静态方法来创建和获取类的实例，自然阻止了解耦。而我们上面所做的，就是通过把实例化和业务逻辑分开，从而实现了一个单例模式的测试方案。



