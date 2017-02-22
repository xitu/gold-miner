> * 原文地址：[Towards Godless Android Development: How and Why I Kill God Objects](https://www.philosophicalhacker.com/post/towards-godless-android-development-how-and-why-i-kill-god-objects/)
* 原文作者：[Philosophical Hacker](https://www.philosophicalhacker.com)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者： 
* 校对者：

![](https://www.philosophicalhacker.com/images/nietzsche.jpg)

# Towards Godless Android Development: How and Why I Kill God Objects

> God is dead…and also Context is dead.
> 
> –Friedrich Nietszche (probably)

Godlessness in the context of OO-programming – unlike godlessness in a broader context – is *uncontroversially* a good thing. Some may want gods in school or gods in government, but – all other things being equal – no one really wants gods in their programs.

In android development specifically, we have a god that we all know and love to hate: `Context`.1 This post is about why and how I kill off the `Context` god in my apps. The reasons and methods for killing off `Context` can of course be applied to other kinds of “god-slaying.”

### Why I Kill Context

Although `Context` is a god object and I understand that there are disadvantages of working with god objects, this isn’t the main reason I started killing off contexts. Killing `Context` is actually something that happened pretty naturally as a result of doing TDD. To see how this could happen, remember that when we’re doing TDD, we’re engaged in an exercise of wishful thinking: we’re writing the interfaces that we want to exist for the objects we’re testing. Here’s Freeman and Pryce on this:

> We like to start by writing a test as if its implementation already exists, and then filling in whatever is needed to make it work—what Abelson and Sussman call “programming by wishful thinking”2

If we take this way of thinking seriously, a way of thinking that’s closely related to the idea that [we shouldn’t mock types we don’t own](/post/how-we-misuse-mocks-for-android-tests/), we wind up with dependencies for our objects that are expressed in the domain of that object, on the one hand, and an adapter layer, on the other. Again, here’s Freeman and Pryce:

> If we don’t want to mock an external API, how can we test the code that drives it? We will have used TDD to design interfaces for the services our objects need—which will be defined in terms of our objects’ domain, not the external library.3

When I write the ideal interface for my objects first in a test, I find that none of my classes ever really want a `Context`. What my objects really want is a way to get localized strings or a way to get a persistent key-value store, things that we usually obtain indirectly through a `Context`.

When I pass in an object that clearly describes that object’s role with respect to the object being tested instead of passing in a `Context`, it makes it easier for me to understand my class.

Here’s an example. Let’s say you need to implement the following:

> Show a “rate dialog” to a user if they’ve used the app three times. The user can opt to rate the app, request to be reminded to rate the app, or decline to rate the app. If the user opts to rate the app, take them to the google play store and don’t show the rate dialog again. If the user opts to be reminded to rate the app, reshow the dialog after three days have passed. If the user declines to rate the app, never show the dialog again.

This functionality might make us a little nervous, so we let [fear drive us to write a test first](/post/what-should-we-unit-test/).

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
   
When I’m writing this test and designing my ideal interface for `AskAppRatePresenter`, I’m *not* thinking about *how* the number of app usages are stored. They could be stored through `SharedPreferences` or through a database or through realm or… Because of this, I don’t make the `AskAppRatePresenter` ask for a `Context`. All I really care about is that the `AskAppRatePresenter` has a way of getting the number of times the app has been used.4

This actually makes it easier for me to read the code later. If I see that a `Context` is being injected into an object, I don’t really have any strong idea what it might be used for. Its a god. It could be used for any number of things. However, if I see that a `AppUsageStore` is being passed in, then I’ll be much further towards understanding what the `AskAppRatePresenter` does.5

### How I Kill Context

Once we have the test written and failing, we can start to implement what we need to make it pass. Obviously, we’ll need a `Context` in the implementation, but that can be a detail that the `AskAppRatePresenter` doesn’t know about. There are two pretty obvious ways of doing this. One is to use a `Context` passed into the constructor to get the `SharedPreferences` that stores the info we retrieve from a `AppUsageStore`:

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

The other way is to make the `Activity` that hosts the presenter implement the `AppUsageStore` interface and pass a reference to the `Activity` into `AskAppRatePresenter`’s constructor:

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

So, the general recipe for killing a `Context` – or other gods in general – is as follows:

1. Create an interface that represents what your class really wants from a `Context`.
2. Create a class that implements this interface; that class may already be a `Context` (e.g., an `Activity`)
3. Inject that class into your class.

### Conclusion

If you follow the above recipe consistently, none of your interesting code will actually interact with a `Context`. That’ll all happen in an adapter layer. When you get to this point, you’ll be able to do work on your interesting code without having any gods interfere with your ability to understand your code.

### Notes:

1. `Context` is a god object. We all know that [god objects are an anti-pattern](https://en.wikipedia.org/wiki/God_object), so it might seem like `Context` was a mistake. But that’s not obvious to me. Here’s why. First, as I pointed out in [my last post](/post/why-android-testing-is-so-hard-historical-edition/), performance was a huge concern in the early days of Android. Neat abstractions are a computational luxury that may not have been affordable at the time. Second, according to Diane Hackborne, app components are most accurately described as specific interactions with the Android OS. These aren’t your typical objects because they are instantiated by the framework and they are the entry point to a large portion of the Android SDK. These two circumstances suggest that making context a god may not have been a bad choice.

2. Steve Freeman and Nat Pryce, *Growing Object Oriented Software Guided by Tests*, 141.

3. Ibid., 121-122

4. Interestingly, through doing TDD, we’ve stumbled into code that follows [the interface segregation principle](https://en.wikipedia.org/wiki/Interface_segregation_principle).

5. This suggests that there’s an inverse relationship between the complexity of an injected class and ease with which we can understand the class being injected. In other words, the more complicated a class’s dependencies are, the harder it is to understand the class itself.
