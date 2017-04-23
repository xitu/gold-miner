> * 原文地址：[Testing Views in Isolation with Espresso](https://www.novoda.com/blog/testing-views-in-isolation-with-espresso/)
> * 原文作者：[Ataul Munim](https://www.novoda.com/blog/author/ataulm/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：
> * 校对者：

# Testing Views in Isolation with Espresso #
        

In this post, we'll show you how and why you should use Espresso to test your custom Views on an Android device.

You can use Espresso to test entire screens or flows at once. These tests launch an Activity and perform actions as a user would, including waiting for data to load or navigating to other screens.

They're useful because you need end-to-end tests to validate common user flows. These automated tests should run at regular intervals, enabling you to spend manual QA time performing exploratory tests.

That said, these aren’t tests that you can run frequently. Running the whole suite can take hours (imagine a suite that includes verifying offline sync for media content), so you might choose to run them at night.

It's difficult because these types of tests incorporate multiple points of potential failure. Ideally when a single test fails, you want it to fail because of a single logical assertion.

Most (or a lot) of the regressions you can introduce are in the UI. They might be subtle so we don't notice them when adding new features, but eagle-eyed QA teams often do.

It's such a waste of time.

## What can you do? ##

Let's look at using Espresso to test that you have correctly bound data to Views.

At Novoda, the Views we write are mostly extensions of existing View and ViewGroup classes on Android. They typically only expose one or two extra methods, which are used to bind callbacks and the data object/view model, like this:

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

They group logical parts of the UI together and often encompass naming conventions from the business domain. You will rarely see ‘raw’ Android Views in Activity layouts in our work at Novoda.

Let’s write these View tests in a BDD style, like "given MovieItemView is bound to Edward Scissorhands, then title is set as Edward Scissorhands" or "given MovieItemView is bound to Edward Scissorhands, when clicking on view, then onClick(Edward Scissorhands) is called", etc.

## Couldn't you have caught these regressions with unit tests? ##

Why do you need Espresso to run these tests if you’re using a presentation pattern like MVP or MVVM, which can be unit-tested?

First, let’s go over the presentation flow and describe what you can test to see how the Espresso tests can augment it.

- Presenters subscribe to data producers that send events
- Events can be of type `loading`, `idle` or `error`, and may or may not contain data to display
- Presenters will forward these events to "displayers" (“View” in MVP) using methods like `display(List<Movie>)`, `displayCachedDataWhileLoading(List<Movie>)` or `displayEmptyScreen()`, etc.
- The implementation of displayers will show/hide Android Views and do things like `moviesView.bind(List<Movie>)`

You can unit-test the presenters completely, verifying that the correct methods on the displayers are called with the correct arguments.

Can you test the displayers in the same way? Yes, you can mock the Android Views and verify you're calling the correct methods on them. It won't be at the correct granularity though:

- your displayer could create or update the adapter of a RecyclerView or ViewPager, but this gives you no assurances of what the item/page is displaying
- Android Views are setup in code with attributes inflated from XML (layouts and styles); verifying method calls isn't enough to assert what's displayed

## Setting up for the tests ##

Let’s use the [`espresso-support`](https://github.com/novoda/spikes/tree/master/espresso-support) library to get started.

Add the dependencies to your build.gradle file (available from JCenter):

```
debugCompile 'com.novoda:espresso-support-extras:0.0.3'  
androidTestCompile 'com.novoda:espresso-support:0.0.3'
```

The `extras` artifact includes the `ViewActivity`, which needs to be part of your app under test. You can use this Activity to hold a single View, which you can test with Espresso.

The core artifact (containing custom test rules) only needs to be included as part of your `androidTest` dependencies.

The `ViewTestRule` is used in a similar way to the `ActivityTestRule`. Instead of passing the Activity class that you want to launch, you should pass the layout file containing the View you want to test:

```
@RunWith(AndroidJUnit4.class)publicclassMovieItemViewTest{  
  @Rule
  public ViewTestRule<MovieItemView> viewTestRule=newViewTestRule<>(R.layout.test_movie_item_view);
  ...
```

You can specify the View type for the root of the layout with `ViewTestRule<MovieItemView>`.

The `ViewTestRule` extends `ActivityTestRule<ViewActivity>`, so it'll always open `ViewActivity`. `getActivityIntent()` is overridden so you can pass `R.layout.test_movie_item_view` to `ViewActivity` as an Intent extra.

You can use Mockito in your tests to substitute for the callbacks:

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

ViewTestRule has a method `bindViewUsing(Binder)`, which gives you a reference to the View so you can interact with it. While you could access the View directly with `viewTestRule.getView()`, you want to ensure any interaction with the View is performed on the main thread, not the test thread.

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

## Ready to test ##

Apps only really do two things, from the user's point of view:

- they display information
- they respond to user actions

To write tests for these two cases, you can start by asserting that the correct information is displayed using standard Espresso ViewMatchers and ViewAssertions:

```
@Test
public void titleSetToMovieName() {  
  onView(withId(R.id.movie_item_text_name))
      .check(matches(withText(EDWARD_SCISSORHANDS.name)));
}
```

Next, you should make sure that the user actions correspond to the correct event being fired, with the correct arguments:

```
@Test
public void clickMovieItemView() {  
  onView(withClassName(is(MovieItemView.class.getName())))
      .perform(click());

  verify(movieItemListener)
      .onClick(eq(EDWARD_SCISSORHANDS));
}
```

That's it, I hope you find this useful.

In a future post, I'll cover using Espresso to test your Views for TalkBack support.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
