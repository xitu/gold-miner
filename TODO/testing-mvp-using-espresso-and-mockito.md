> * 原文地址：[TESTING MVP USING ESPRESSO AND MOCKITO](https://josiassena.com/testing-mvp-using-espresso-and-mockito/)
> * 原文作者：[Josias Sena](https://josiassena.com/about-me/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Testing MVP using Espresso and Mockito #

As software developers, we try our best to do what is right and make sure that we are not incompetent, and try to have others and our employers trust in the code we write. We all try to follow best practices and apply good architecture patterns, but sometimes many of us find it difficult to actually test what we code.

Personally, I have seen a few open-source projects where the developers are great at building awesome products—and can build any application you can think of—but for some reason lack at writing the proper tests, if any at all.

This here is another simplified tutorial on how to unit test the “oh so amazing” MVP architecture pattern that many of us try to follow.

Before I continue, I want to mention that I assume you are familiar with the MVP pattern, and have used it before. I will not go over the MVP pattern at all, and I will not explain how it works. With that in mind, I’d like to mention ahead of time that I am using one of my favorite libraries for MVPs created by a guy named [Hannes Dorfman](http://hannesdorfmann.com/) called [Mosby](https://github.com/sockeqwe/mosby). For simplicity’s sake, I am also using the view binding library called [ButterKnife](http://jakewharton.github.io/butterknife/).

So what is this application we will be looking at?

It is a very simple Android app, and it does one thing and one thing only: It hides and displays a TextView with the click of a button. That’s it.

Here’s how the app looks initially:

![Initial](https://i1.wp.com/www.andevcon.com/hubfs/EVENTS_ASSETS/ANDEVCON/Images/Article_Images/MVP%20Mockito/IVvsdac.png)

Here’s how it looks when the button is clicked:

![724E8fE.png](https://i2.wp.com/www.andevcon.com/hubfs/EVENTS_ASSETS/ANDEVCON/Images/Article_Images/MVP%20Mockito/724E8fE.png)

For the sake of this article, let’s imagine that this is a multi-million-dollar product, and that the way it is now is the way it should be for a very long time. And if it were to ever change, we should be notified immediately.

So we have three things in this app: a blue toolbar with the app name, a text view that displays “Hello World,” and a button that hides/shows the TextView.

Before I start, I would like to mention that you can find all of the code for this article on  [my GitHub](https://github.com/josias1991/TestingMVP); if you do not want to read any of my rambling, please feel free to skip the rest of the post and go straight to the code. Comments will be added for clarity.

Now, lets get testing!

## **The Espresso tests** ##

The first thing we want to test is our awesome ToolBar design. I mean, it is a million-dollar app after all; we need to make sure it stays that way!

So first, here’s the complete code used to test the TooBar design. If you have no idea what is going on here, don’t worry: We will walk through it together.

```
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

First things first: We need to tell JUnit what sort of test we are running. This is what the first line does (@RunWith (AndroidJUnit4.class)). It says. “Hey, listen, I want to run an Android test that uses JUnit4 on an actual connected device.”

So what exactly is an Android test? An Android test is a test that runs on the device instead of locally on the [Java Virtual Machine (JVM)](https://en.wikipedia.org/wiki/Java_virtual_machine) on your computer. This means that a device needs to be connected to your computer in order to run the test. This gives the test code access to functional Android framework APIs.

These tests go in the androidTest directory.

![android_test_directory](https://i0.wp.com/www.andevcon.com/hs-fs/hubfs/EVENTS_ASSETS/ANDEVCON/Images/Article_Images/MVP%20Mockito/gcpEaEX.png?w=442)

Next lets take a look at this thing called an “ActivityTestRule”. Since the android documentation explains it really well, here it is:

*“This rule provides functional testing of a single activity. The activity under test will be launched before each test annotated with [Test](http://junit.org/javadoc/latest/org/junit/Test.html) and before methods annotated with [Before](http://junit.sourceforge.net/javadoc/org/junit/Before.html). It will be terminated after the test is completed and methods annotated with [After](http://junit.sourceforge.net/javadoc/org/junit/After.html) are finished. During the duration of the test you will be able to manipulate your Activity directly.”*

This basically says, “This is the activity I want to run my test.”

Lets get in to the testToolbarDesign() method and see what the hell is going on.

### **Testing the toolbar** ###

```    onView(withId(R.id.toolbar)).check(matches(isDisplayed()));
```

What this test does is find a view with the ID that matches “R.id.toolbar,” then checks to make sure that this view is visible/displayed. If this line were to fail, the test would end right there and wouldn’t even bother with the rest.

```    onView(withText(R.string.app_name)).check(matches(withParent(withId(R.id.toolbar))));
```

This one says “Hey, lets see if there is some text that equals ‘R.string.app_name’ and has a parent whose id is R.id.toolbar.”

The last line in this test is a bit more involved. So basically what it is trying to do is to make sure that the background of the toolbar is equal to the app’s primary color.

```
onView(withId(R.id.toolbar)).check(matches(withToolbarBackGroundColor()));
```

So by default, Espresso does not provide a straightforward way to do this, so we need to create what is called a [Matcher](https://developer.android.com/reference/android/support/test/espresso/matcher/package-summary.html). A Matcher is exactly what we have been using previously to match some view property to another. In this case, we want to match the primary color to the toolbars background.

What we do is we create a [Matcher](https://developer.android.com/reference/android/support/test/espresso/matcher/BoundedMatcher.html) and override the matchesSafely() method. The code inside this method is pretty easy to understand. First we get the toolbar’s background, then we compare it to the app’s primary color. If it is equal, it returns true; false otherwise.

### **Test TextView hides/shows properly** ###

Ok, before I show any code, I just want to mention that this code is a bit more verbose, but pretty straightforward to read. I have added some comments to show what exactly is going on.

```

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

The gist of this code is that it is making sure that when the app opens, the TextView with ID “R.id.tv_to_show_hide” is displayed, and the text displayed on the TextView says “Hello World!”

Then we check that the button is also displayed properly, and that the text on the button (by default) is set to “Hide”.

Next we click on the button. A click on a button is very straightforward, and it is very easy to read how it is done. This time instead of calling “.check” after we find a view by ID, we call .perform(), and inside the perform() method, we pass in click(). The perform() method says “Please do the following action,” and then “performs” whatever action is passed in. In our case it is a click() action.

Since the “Hide” button was clicked, we need to make sure the TextView is actually hidden now. We do this by adding a “not()” in front of the isDisplayed() method we used previously, and the button text has been changed to “Show”. This is the same as doing “!=” in plain ol’ java.

```


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

The code after these lines is the reverse of what we did before. We click the button again, make sure the TextView is visible again, and make sure that the button text has changed to successfully to match the situation.

And that’s it!

Here is the full UI test code:

```

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

## **The Unit Tests** ##

The great thing about unit tests—as opposed to Android tests—is that they run locally on your machine on the JVM. No need to have a device attached, and the tests run so much faster. The downside is that they do not have access to functional Android framework APIs. Overall, when testing anything other then UI you should try your best to write unit tests instead of Android/Instrumentation tests. The faster the tests, the better.

Lets start with the directory of the unit tests. The unit tests go in a different location then the Android tests did.

![different_location](https://i1.wp.com/www.andevcon.com/hubfs/EVENTS_ASSETS/ANDEVCON/Images/Article_Images/MVP%20Mockito/mYBjN1x.png)

Before moving on lets take a look at our presenter and what we are going to consider our model for this tutorial.

### *Lets start with the presenter* ###

```

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

Simple enough. We have two methods: One checks to see if the view is visible. If it is, hide it, otherwise show it. Once this is done, we call into our view and say “Hey, change the button text to either ‘Hide’ or ‘Show’.”

Our reverseViewVisibility() method calls into what we call (for this tutorial at least) our “model” to set the proper visibility on the view passed in.

### *Lets take a look at our model.* ###

```
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

There are two methods: showView(View) and hideView(View). What these methods do is very straightforward and self-explanatory. We check if the view is null; if not, we either hide it or show it.

Great, now that we are familiar with both our presenter and our “model,” lets go ahead and test them. After all, this is a multi-million-dollar product, and we cannot have anything go wrong.

Let start start testing our presenter first. When it comes to a presenter—ANY presenter—we need to make sure that the view is attached to the presenter. Note: We are NOT testing the view. We just need to make sure that the view is attached so that we can verify the proper view methods are being made in the right time. Keep this in mind as this is very important.

We will be using Mockito to run our tests, so just like we did with our unit tests, we ned to tell Android, “Hey, we want to run these tests with the MockitoJUnitRunner.” To do so we add the @RunWith (MockitoJUnitRunner.class) annotation on top of our test class.

So we know two things right from the start: We need a mocked View because our presenter uses a View Object to hide or show it, and we also need our presenter.

This is how we mock using Mockito

```
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

The first actual test we want to write is called “testReverseViewVisibilityFromVisibleToGone”. As the name says, we are going to make sure that the presenter sets the proper visibility when the view passed in to the reverseViewVisibility() method is visible.

```
   @Test
    public void testReverseViewVisibilityFromVisibleToGone() throws Exception {
        final View view = Mockito.mock(View.class);
        when(view.isShown()).thenReturn(true);

        presenter.reverseViewVisibility(view);

        Mockito.verify(view, Mockito.atLeastOnce()).setVisibility(View.GONE);
        Mockito.verify(presenter.getView(), Mockito.atLeastOnce()).setButtonText(anyString());
    }
```

Let’s step through this together. What is actually going on here? Well, when the isShown() method is called on the view that is passed in to the presenter, we want to say yes, the view is shown, because we are testing from visible to gone, so we need to start at visible. Then, we call the presenters reverseViewVisibility() method by passing in the mocked view. Now we need to verify that the mocked views .setVisibility() was called at least once, and it was set to View.GONE. Afterwards, we need to verify that the presenters view setButtonText() method was called. Not that hard right?

Alright, lets do the opposite. Before moving on and looking at the next piece of code, take some time to figure it out yourself. How would we test going from hidden to visible? Think about what you already know.

Here’s the code:

```
    @Test
    public void testReverseViewVisibilityFromGoneToVisible() throws Exception {
        final View view = Mockito.mock(View.class);
        when(view.isShown()).thenReturn(false);

        presenter.reverseViewVisibility(view);

        Mockito.verify(view, Mockito.atLeastOnce()).setVisibility(View.VISIBLE);
        Mockito.verify(presenter.getView(), Mockito.atLeastOnce()).setButtonText(anyString());
    }
```


Lets move on to testing our “Model.” As before, we start by adding the @RunWith (MockitoJUnitRunner.class) annotation on top of our class.

``` 
@RunWith(MockitoJUnitRunner.class)

publicclassUtilsTest{

    // ...

}
```
 

As mentioned previously, our Utils class first checks if the view is not null. If not, a visibility is applied, otherwise nothing is done.

The tests for this class are very easy, so I am just going to put the whole thing here without stepping through it line by line.

```
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
 

I’ll explain what is going on in the testShowViewWithNullView() and testHideViewWithNullView() methods. Why would we want to test something like this? Well if we think about it for a second, we do not want our method calls to crash the entire application because the view was null.

Lets take a look at the Utils showView() method. If we remove the null check, the app will throw a NullPointerException and would crash.

```
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

In other scenarios we may want the app to actually throw an exception. How would we test an exception? Its actually very easy: You would just pass in an expected param to the @Test annotation like so:

```
@RunWith (MockitoJUnitRunner.class)
public class UtilsTest {

    // ...

    @Test (expected = NullPointerException.class)
    public void testShowViewWithNullView() throws Exception {
        Utils.showView(null);
    }
}
```

If no exception is thrown, the test would fail.

Again, you can find all of the code on [GitHub](https://github.com/josias1991/TestingMVP).

Now that we are at the end of the post, I want to mention something to you guys: Testing will not always be as straightforward as it was in this example, but it doesn’t mean it can’t, and shouldn’t be done. As software developers, we need to make sure that our applications work properly and as expected. We need to make sure others trust our code. I have been doing this for many years and you couldn’t imagine how many times tests have saved me, even for the simplest thing such as changing a view ID.

No one is perfect, but tests help us get a step closer. Keep on coding, keep on testing and until next time!

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
