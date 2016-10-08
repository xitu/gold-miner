> * 原文地址：[How to test a singleton in an Android Service (2)?](http://www.songzhw.com/2016/10/03/how-to-test-a-singleton-in-an-android-service-2/)
* 原文作者：[songzhw](http://github.com/songzhw)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：





Last post introduce how to test a Singleton(**PowerMock**!), and how to unit test Android code (**Robolectric**!). Now we use a singleton in a Service class. And we would like to test it. So it should be easy, right?

### try 01: Combine PowerMock and Robolectric (1)

    // src/PushService
    // [PushService.java]
    public class PushService extends Service {
        public void onMessageReceived(String id, Bundle data){
            FooManager.getInstance().receivedMsg(data);
        }
    }

So I combine PowerMock and Robolectric and write a test case:

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

Sonn, I find a dilemma, I can use `@RunWith(RobolectricTestRunner.class)`, or I can use `@RunWith(PowerMockRunner.class)`. But I cannot use them both! Once I can use them both, it means that I can choose to use Robolectric or to use PowerMock, but I can not combine them.

### try 02: Combine PowerMock and Robolectric (2)

So I googled and wished to search a solution. Thank goodness, I did find a solution. This solution is posted by Robolectric, and the address is here: [https://github.com/robolectric/robolectric/wiki/Using-PowerMock](https://github.com/robolectric/robolectric/wiki/Using-PowerMock)

The post suggest me to add such head:

    @RunWith(RobolectricTestRunner.class)
    @Config(constants = BuildConfig.class, sdk = 21)
    @PowerMockIgnore({ "org.mockito.*", "org.robolectric.*", "android.*" })
    @PrepareForTest(Static.class)
    public class DeckardActivityTest {
        ...
    }

I did what the post said, and run the test. But the test failed again. This time, the error message is :

    com.thoughtworks.xstream.converters.ConversionException: Cannot convert type org.apache.tools.ant.Project to type org.apache.tools.ant.Project
    ---- Debugging information ----

So I contiued to search. This time I found an issue on [github.com/Robolectric](https://github.com/robolectric/robolectric/pull/2390) . In this issue, some people said:  

    Realistically we're not going to get to this till October, but we do
    welcome contributions if you want to take a stab at fixing it yourself.

    The best work around it to simply make your code testable then you don't
    need to mock statics

Now I understand there is no such solution for using PowerMock and Robolectric at the same time. The solution may be out in 2016 October, but now (2016, September) I have to test the singleton in Service. How should I do?

### try 03: decouple Singleton

Now we know the PowerMock + Robolectgric solution is a dead-end. So can we test the singleton in Service or not?

The asnwer is yes. Just like we said before, “singletons are considered bad because they make unit testing and debugging difficult. It tightly couple you to the exact type of the singleton object”. So we want to create an opportunity for us to inject the dependency, rather than tightly coupled initialization with the singleton instance.

Back to our example, if we use singleton, the code would look like:

    // [PushService.java]
    public class PushService extends Service {
        public void onMessageReceived(String id, Bundle data){
            FooManager.getInstance().receivedMsg(data);
        }
    }

To use dependency injection, we can rewirte the code like this:

    // [PushService.java]
    public class PushService extends Service {
        public FooManager fooManager;    

        public void onMessageReceived(String id, Bundle data){
            fooManager.receivedMsg(data);
        }
    }

In this example, FooManager is created outside of the service, which gives you an opportunity to inject/mock your own instance. So our test code would look like this:

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

Problem solved. So we decouple the initialization of an object from the Service. We did give the test case an access to mock a instance of Singleton class. This is very important, [To write testable code, we must separate object creation from the business logic.](http://codeahoy.com/2016/05/27/avoid-singletons-to-write-testable-code/)

## Conclusion 02

Singleton, by their nature, prevent decoupling by providing a global and a static way of creating and obtaining an instance of their classes. The solution to test a singleton is to separate the initialization from the business logic, like we did above.



