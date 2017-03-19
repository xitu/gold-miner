* 原文地址：[What Unit Tests are Trying to Tell us About Activities Pt 2](https://www.philosophicalhacker.com/post/what-unit-tests-are-trying-to-tell-us-about-activities-pt-2/)
* 原文作者：[Matt Dupree](https://twitter.com/philosohacker)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# What Unit Tests are Trying to Tell us About Activities Pt 2 #


`Activity`s and `Fragment`s, perhaps by [some strange historical accidents](/post/why-android-testing-is-so-hard-historical-edition/), have been seen as *the optimal* building blocks upon which we can build our Android applications for much of the time that Android has been around. Let’s call this idea – the idea that `Activity`s and `Fragment`s are the best building blocks for our apps – “android-centric” architecture.

This series of posts is about the connection between the testability of android-centric architecture and the other problems that are now leading Android developers to reject it; it’s about how our unit tests are trying to tell us that `Activity`s and `Fragment`s don’t make the best building blocks for our apps because they force us to write code with *tight coupling* and *low cohesion*.

In this second part of [the series](/post/what-unit-tests-are-trying-to-tell-us-about-activities-pt1/), through an examination of the Session Detail screen in the Google I/O sample app, I show how using `Activity`’s and `Fragment`s as building blocks makes our code hard to test and show that our failure to unit test tell us that our target class has low-cohesion.

### The Google I/O Session Detail Example ###

When I’m working on a project, I try to start by [testing the code that scares me the most](/post/what-should-we-unit-test/). Large classes scare me. The largest class in the Google I/O app is the `SessionDetailFragment`. Large methods scare me too, and the largest method of this large class is `displaySessionData`. Here’s a screenshot of what this monster class displays:

![](https://www.philosophicalhacker.com/images/session-detail.png)

Here’s the scary `displaySessionData` method. This isn’t something you’re supposed to *easily* understand; that’s what makes it scary. Gaze upon it with fear and trembling for a moment before we move on:

```
private void displaySessionData(final SessionDetailModel data) {
  mTitle.setText(data.getSessionTitle());
  mSubtitle.setText(data.getSessionSubtitle());
  try {
    AppIndex.AppIndexApi.start(mClient, getActionForTitle(data.getSessionTitle()));
  } catch (Throwable e) {
    // Nothing to do if indexing fails.
  }

  if (data.shouldShowHeaderImage()) {
    mImageLoader.loadImage(data.getPhotoUrl(), mPhotoView);
  } else {
    mPhotoViewContainer.setVisibility(View.GONE);
    ViewCompat.setFitsSystemWindows(mAppBar, false);
    // This is hacky but the collapsing toolbar requires a minimum height to enable
    // the status bar scrim feature; set 1px. When there is no image, this would leave
    // a 1px gap so we offset with a negative margin.
    ((ViewGroup.MarginLayoutParams) mCollapsingToolbar.getLayoutParams()).topMargin = -1;
  }

  tryExecuteDeferredUiOperations();

  // Handle Keynote as a special case, where the user cannot remove it
  // from the schedule (it is auto added to schedule on sync)
  mShowFab = (AccountUtils.hasActiveAccount(getContext()) && !data.isKeynote());
  mAddScheduleFab.setVisibility(mShowFab ? View.VISIBLE : View.INVISIBLE);

  displayTags(data);

  if (!data.isKeynote()) {
    showInScheduleDeferred(data.isInSchedule());
  }

  if (!TextUtils.isEmpty(data.getSessionAbstract())) {
    UIUtils.setTextMaybeHtml(mAbstract, data.getSessionAbstract());
    mAbstract.setVisibility(View.VISIBLE);
  } else {
    mAbstract.setVisibility(View.GONE);
  }

  // Build requirements section
  final View requirementsBlock = getActivity().findViewById(R.id.session_requirements_block);
  final String sessionRequirements = data.getRequirements();
  if (!TextUtils.isEmpty(sessionRequirements)) {
    UIUtils.setTextMaybeHtml(mRequirements, sessionRequirements);
    requirementsBlock.setVisibility(View.VISIBLE);
  } else {
    requirementsBlock.setVisibility(View.GONE);
  }

  final ViewGroup relatedVideosBlock =
      (ViewGroup) getActivity().findViewById(R.id.related_videos_block);
  relatedVideosBlock.setVisibility(View.GONE);

  updateEmptyView(data);

  updateTimeBasedUi(data);

  if (data.getLiveStreamVideoWatched()) {
    mPhotoView.setColorFilter(getContext().getResources().getColor(R.color.played_video_tint));
    mWatchVideo.setText(getString(R.string.session_replay));
  }

  if (data.hasLiveStream()) {
    mWatchVideo.setOnClickListener(new View.OnClickListener() {
      @Override public void onClick(View v) {
        String videoId =
            YouTubeUtils.getVideoIdFromSessionData(data.getYouTubeUrl(), data.getLiveStreamId());
        YouTubeUtils.showYouTubeVideo(videoId, getActivity());
      }
    });
  }

  fireAnalyticsScreenView(data.getSessionTitle());

  mTimeHintUpdaterRunnable = new Runnable() {
    @Override public void run() {
      if (getActivity() == null) {
        // Do not post a delayed message if the activity is detached.
        return;
      }
      updateTimeBasedUi(data);
      mHandler.postDelayed(mTimeHintUpdaterRunnable,
          SessionDetailConstants.TIME_HINT_UPDATE_INTERVAL);
    }
  };
  mHandler.postDelayed(mTimeHintUpdaterRunnable,
      SessionDetailConstants.TIME_HINT_UPDATE_INTERVAL);

  if (!mHasEnterTransition) {
    // No enter transition so update UI manually
    enterTransitionFinished();
  }

  if (BuildConfig.ENABLE_EXTENDED_SESSION_URL && data.shouldShowExtendedSessionLink()) {
    mExtendedSessionUrl = data.getExtendedSessionUrl();
    if (!TextUtils.isEmpty(mExtendedSessionUrl)) {
      mExtended.setText(R.string.description_extended);
      mExtended.setVisibility(View.VISIBLE);

      mExtended.setClickable(true);
      mExtended.setOnClickListener(new View.OnClickListener() {
        @Override public void onClick(final View v) {
          sendUserAction(SessionDetailUserActionEnum.EXTENDED, null);
        }
      });
    }
  }
}
```

I know that was scary, but pull yourself together. Let’s zoom in on these few lines in particular:

```
private void displaySessionData(final SessionDetailModel data) {
  //...

  // Handle Keynote as a special case, where the user cannot remove it
  // from the schedule (it is auto added to schedule on sync)
  mShowFab =  (AccountUtils.hasActiveAccount(getContext()) && !data.isKeynote());
  mAddScheduleFab.setVisibility(mShowFab ? View.VISIBLE : View.INVISIBLE);

  //...

  if (!data.isKeynote()) {
    showInScheduleDeferred(data.isInSchedule());
  }

  //...
}
```

Interesting. It looks like we’ve stumbled upon a business rule:

> A Conference attendee cannot remove the keynote session from their schedule.

Looks like there’s presentation-logic related to this rule as well: If we’re displaying the keynote session, don’t bother providing an affordance to add or remove it from the schedule. Otherwise, go ahead and provide said affordance. Oh…and also, if the session is in the attendee’s schedule, go ahead and show it.

That method name, `showInScheduleDeferred` actually turns out to be a lie. Even if you call it, you won’t see a FAB to add or remove a non-keynote session from their calendar. Lying methods are even scarier than long ones. The reason you won’t see a the FAB is another business rule:

> A Conference attendee cannot add or remove sessions that have already passed.

That code lives in `updateTimeBasedUi`:

```
private void updateTimeBasedUi(SessionDetailModel data) {
  //...
  // If the session is done, hide the FAB, and show the "Give feedback" card.
  if (data.isSessionReadyForFeedback()) {
    mShowFab = false;
    mAddScheduleFab.setVisibility(View.GONE);
    if (!data.hasFeedback()
        && data.isInScheduleWhenSessionFirstLoaded()
        && !sDismissedFeedbackCard.contains(data.getSessionId())) {
      showGiveFeedbackCard(data);
    }
  }
}
```

If you look at a session’s details before the conference starts, you’ll actually see the “add to schedule” FAB:

![Add to schedule fab is visible now](https://www.philosophicalhacker.com/images/session-detail-with-fab.png)

So, we’ve actually got a fairly complicated business rule here:

> A conference attendee can only add or remove a session from their schedule if that session is not the keynote and if that session hasn’t already passed.

Of course, we want our presentation-logic to reflect this rule, which means we only want to give the attendees an affordance to add or remove a session in accordance with this rule. It’d be silly if we showed the FAB and when the user tapped it, the app said – perhaps with a `Dialog` or a `Toast,` “Nope! You can’t remove the keynote session!”

### A Failed Attempt to Test ###

Let’s see if we can write a few tests for this presentation logic. Remember, as we said [last time](/post/what-unit-tests-are-trying-to-tell-us-about-activities-pt1/), the idea here is that tests tell us something about our design. If the class is easy to unit test, its well designed. When I write this unit test, I’ll write what I think is the easiest way to unit test this functionality. The more I have to change my ideal easy test, the most suspicious I become of the class I’m testing.

```
public class SessionDetailFragmentTest {

  @Test public void displayDataOnlyProvidesAddRemoveSessionAffordanceIfSessionIsNotKeynote() throws Exception {
    // Arrange
    SessionDetailFragment sessionDetailFragment = new SessionDetailFragment();
    final SessionDetailModel sessionDetailModel = mock(SessionDetailModel.class);
    when(sessionDetailModel.isKeynote()).thenReturn(true);
    // Act
    sessionDetailFragment.displayData(sessionDetailModel,
        SessionDetailModel.SessionDetailQueryEnum.SESSIONS);
    // Assert
    final View addScheduleButton =
        sessionDetailFragment.getView().findViewById(R.id.add_schedule_button);
    assertTrue(addScheduleButton.getVisibility() == View.INVISIBLE);
  }
}

```

This is the easiest test I can think of. There’s already some trouble here since `displaySessionData` is a private method, so we have to test it indirectly through the public `SessionDetailFragment.displayData` method. Not too shabby though. Unfortunately, when we run it. Here’s what we get:

```
java.lang.NullPointerException
	at com.google.samples.apps.iosched.session.SessionDetailFragment.displaySessionData(SessionDetailFragment.java:396)
	at com.google.samples.apps.iosched.session.SessionDetailFragment.displayData(SessionDetailFragment.java:292)
	at com.google.samples.apps.iosched.session.SessionDetailFragmentTest.displayDataOnlyProvidesAddRemoveSessionAffordanceIfSessionIsNotKeynote(SessionDetailFragmentTest.java:19)
```

The test is complaining that `SessionDetailFragment.mTitleView` is null. Ugh. The error is annoying because `SessionDetailFragment.mTitleView`*nothing to do with this test*. Looks like I’ll have to add a call to `onActivityCreated` to make sure those `View`s get instantiated:

```
@Test public void displayDataOnlyProvidesAddRemoveSessionAffordanceIfSessionIsNotKeynote()
      throws Exception {
    // Arrange
    SessionDetailFragment sessionDetailFragment = new SessionDetailFragment();
    final SessionDetailModel sessionDetailModel = mock(SessionDetailModel.class);
    when(sessionDetailModel.isKeynote()).thenReturn(false);
    // Act
    sessionDetailFragment.onActivityCreated(null);
    sessionDetailFragment.displayData(sessionDetailModel,
        SessionDetailModel.SessionDetailQueryEnum.SESSIONS);
    // Assert
    final View addScheduleButton =
        sessionDetailFragment.getView().findViewById(R.id.add_schedule_button);
    assertTrue(addScheduleButton.getVisibility() == View.INVISIBLE);
  }

```

When we run this test, we get another error:

```
java.lang.NullPointerException
	at com.google.samples.apps.iosched.session.SessionDetailFragment.initPresenter(SessionDetailFragment.java:260)
	at com.google.samples.apps.iosched.session.SessionDetailFragment.onActivityCreated(SessionDetailFragment.java:177)
	at com.google.samples.apps.iosched.session.SessionDetailFragmentTest.displayDataOnlyProvidesAddRemoveSessionAffordanceIfSessionIsNotKeynote(SessionDetailFragmentTest.java:20)
```

This time, the complaint basically boils down to the fact that `getActivity()` returns null. At this point, we might decide to call `onAttach` and pass in a dummy `Activity` to get around this. Or, we might realize that even if we did do this, there’s going to be a lot of things we have to do to get this test setup *that have nothing to do with testing the behavior we’re interested in.*

At this point, we might tempted give up and go use roboelectric. [I’ve said before](/post/why-i-dont-use-roboletric/) that using roboelectric feels like exactly the wrong thing to do here. The test is trying to tell us something about our code. We don’t need to change the way we test. We need to change the way we code.

So, before giving up, let’s think for a second about what’s happening. We’re interested in testing a small piece of behavior, and the way our class is designed is forcing us to care about a bunch of other objects *that have nothing to do with the behavior we’re testing.* What this means is that our class has low cohesion. Our class has a bunch of functionality and objects that have little to do with each other. This is what makes it difficult to complete the arrange step in our unit test; its what makes it difficult to get our object into a state where we can actually run our test.

As we know, however, low cohesion, isn’t just about testability. Classes that have low cohesion are difficult to understand and change. This test that we’ve tried and failed to write is reinforcing something that we already know intuitively: the 900+ line `SessionDetailFragment` is a monster and it needs to be refactored.

Perhaps more controversially, when we listen to the tests and follow their suggestions by writing them first, I think we’ll eventually find that we don’t even really want a `Fragment` here at all. In fact, I think we’ll find that its rare that a `Fragment` is the ideal building block we want to use for our functionality. One claim at a time though. Let’s wrap this post up. We’ll get to the juicy controversy in due time.

### Conclusion ###

We’ve just seen how writing a test for a class can tell us that the target class suffers from low cohesion. The `SessionDetailFragment` may be a particularly obvious case of a low-cohesion class, but TDD can also help us identify more subtle cases of classes that lack cohesion. In this case, the target class was a `Fragment`, but if you write tests for a while, you’ll find that the same thing is true for `Activity`s.

In the next post, we’ll look at how the difficulty of testing this class shows us another insight: that `SessionDetailFragment` is tightly coupled. We’ll also test drive this same functionality and show how the resulting design is more cohesive and loosely coupled.

### We're hiring mid-senior Android developers at [Unikey](http://www.unikey.com/). Email me if you want to work for a Startup in the smart lock space in Orlando ###

#### kmatthew[dot]dupree[at][google'semailservice][dot]com ####

