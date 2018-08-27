* 原文地址：[What Unit Tests are Trying to Tell us About Activities Pt 2](https://www.philosophicalhacker.com/post/what-unit-tests-are-trying-to-tell-us-about-activities-pt-2/)
* 原文作者：[Matt Dupree](https://twitter.com/philosohacker)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[tanglie1993](https://github.com/tanglie1993)
* 校对者：[yunshuipiao](https://github.com/yunshuipiao), [zhaochuanxing](https://github.com/zhaochuanxing)

# 单元测试试图告诉我们关于 Activity 的什么事情：第二部分 #

`Activity` 和?`Fragment`，可能是因为一些[奇怪的历史巧合](https://juejin.im/entry/58ac5b3b570c35006bc9e52c)，从 Android 推出之时起就被视为构建 Android 应用的**最佳**构件。我们把这种想法称为“android-centric”架构。

本系列博文是关于 android-centric 架构的可测试性和其它问题之间的联系的，而这些问题正导致 Android 开发者们排斥这种架构。它们同时也试图通过单元测试告诉我们：`Activity` 和 `Fragment` 不是应用的最佳构件，因为它们迫使我们写出**高耦合**和**低内聚**的代码。

在本[系列文章](https://juejin.im/entry/58bc1d51128fe1006447531e)的第二部分，对 Google I/O 示例 app 会话详情页的单元测试表明，将 `Activity` 和 `Fragment` 当作组件，会使代码难以测试。测试失败同时也揭示，目标类是低内聚的。

### The Google I/O 会话细节例子 ###

当我在开发一个项目时，我尝试从[最让我害怕的代码](https://www.philosophicalhacker.com/post/what-should-we-unit-test/)开始测试。大型类让我害怕。Google I/O 应用的最大的类是 `SessionDetailFragment`。长的方法也让我害怕，而这个大型类中最长的方法是 `displaySessionData`。这是这个巨大的类显示的内容的截图:

![](https://www.philosophicalhacker.com/images/session-detail.png)

这是吓人的 `displaySessionData` 方法。这不是人们通常可以**容易**地理解的东西；这正是它可怕的原因。在继续之前，用惊恐的目光看它一眼，并恐惧地颤抖一下：

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

我知道这很可怕。但振作起来。让我们把目光聚焦在这几行代码上：

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

很有趣。看起来我们遇到了一条业务规则：

> 与会者不能把主题演讲环节从日程中删除。

看起来这条规则有一条对应的展示逻辑：如果我们在展示主题演讲环节，我们将不提供把它添加到日程中，或从日程中删除的功能。否则，我们就提供上述功能。哦……而且，如果这个环节是在与会者的日程中，把它显示出来。

这个方法名，`showInScheduleDeferred` 实际上是一个谎言。哪怕你调用了它，你也不会看见一个添加或删除非主题演讲环节的 FAB。撒谎的方法比长方法更可怕。你不会看见 FAB 的原因是另一条业务规则：

> 与会者不能添加或删除已经过去的环节。

这些代码在 `updateTimeBasedUi`中：

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

如果你在会议开始前看一看该环节的细节，你将会看见“添加到日程”的 FAB：

![“添加到日程” FAB 现在可见](https://www.philosophicalhacker.com/images/session-detail-with-fab.png)

所以，我们现在得到了一条相当复杂的业务规则：

> 只有在一个环节不是主题演讲环节，并且它还没有过去时，与会者才可以在日程中添加或删除这个环节。

当然，我们希望我们的显示逻辑反映这条规则。这意味着我们只在和这条规则一致的情况下添加或删除一个环节。如果我们显示了一个 FAB，用户点击了它，但是应用却说——或许是用一个 `Dialog` 或者一个 `Toast` —— “不！你不能移除主题演讲环节！”，那就太傻了。

### 失败的测试尝试 ###

我们看看是否能为这个展示逻辑写几个测试。记住，我[上一次](https://juejin.im/entry/58bc1d51128fe1006447531e)曾说，我的想法是：测试将会告诉我们一些关于设计的事情。如果一个类易于测试，它就设计得好。当我在写测试时，我将以我认为的最简单的方式去写。我在最简单的基础上修改得越多，我就越怀疑正在测试的类。
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

这是我能想到的最简单的测试。现在已经有了一些问题，因为 `displaySessionData` 是一个 private 方法，所以我们必须通过public `SessionDetailFragment.displayData` 方法间接测试它。看起来不那么傻逼。不幸的是，我们运行它时，将会得到这个结果：

```
java.lang.NullPointerException
	at com.google.samples.apps.iosched.session.SessionDetailFragment.displaySessionData(SessionDetailFragment.java:396)
	at com.google.samples.apps.iosched.session.SessionDetailFragment.displayData(SessionDetailFragment.java:292)
	at com.google.samples.apps.iosched.session.SessionDetailFragmentTest.displayDataOnlyProvidesAddRemoveSessionAffordanceIfSessionIsNotKeynote(SessionDetailFragmentTest.java:19)
```

这个测试抱怨说 `SessionDetailFragment.mTitleView` 是 null。唉。这个错误很烦人，因为  `SessionDetailFragment.mTitleView` **和这个测试没有关系**。看起来我必须增加一个 `onActivityCreated` 方法来确定这些 `View` 被初始化了：

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

如果我们运行这个测试，会得到另一个错误：

```
java.lang.NullPointerException
	at com.google.samples.apps.iosched.session.SessionDetailFragment.initPresenter(SessionDetailFragment.java:260)
	at com.google.samples.apps.iosched.session.SessionDetailFragment.onActivityCreated(SessionDetailFragment.java:177)
	at com.google.samples.apps.iosched.session.SessionDetailFragmentTest.displayDataOnlyProvidesAddRemoveSessionAffordanceIfSessionIsNotKeynote(SessionDetailFragmentTest.java:20)
```

这一次，这个抱怨基本上可以归结于 `getActivity()` 返回 null。现在，我们也许会调用 `onAttach` 并传入一个哑 `Activity` 来避免这种情况。或者，我们也许会发现，哪怕我们这样做了，也还要做很多别的事来设置这个测试。这些事情**和我们感兴趣的内容没有任何关系**。

到这一步，我们也许会放弃，并选择 roboelectric。[我曾经说过](https://www.philosophicalhacker.com/post/why-i-dont-use-roboletric/)，我感觉使用 roboelectric 是一个错的选择。测试正试图告诉我们一些关于代码的事情。我们不需要修改我们测试的方式。我们需要修改编码的方式。


在放弃之前，先考虑一下正在发生的事情。我们对测试一小段行为感兴趣，但类设计的方式迫使我们关心很多**和我们测试的内容没有关系**的其他对象。这意味着我们的代码是低内聚的，我们的类有很多互相没有太大关系的方法和对象。这使得完成测试的设置步骤非常复杂；这也使得让我们的对象难以进入可以真正运行测试的状态。

据我们所知，低内聚并不只关于可测试性。低内聚的类难以理解和改变。这个我们尝试了但没有写出来的测试，印证了我们已经本能地知道的事情：超过 900 行的 `SessionDetailFragment` 是一个巨兽，它需要被重构。


也许更有争议的是，如果我们听从测试的建议，并首先把它们写出来，我认为我们将最终发现我们根本不需要一个 `Fragment` 。事实上，我认为，我们很少会发现 `Fragment` 是理想的用于实现功能的组件。一次只讨论一个观点吧。先完成这篇帖子。我们将会在合适的时间回到这个有趣的争论的。



### 总结 ###



我们刚刚看见，为类写一个测试可以告诉我们：目标类是低内聚的。`SessionDetailFragment` 可能是一个特别明显的低内聚类的例子，但 TDD 可以帮助我们发现更加隐蔽的低内聚类。在本文中，目标类是一个 `Fragment`，但如果你坚持写一段时间的测试，你会发现同样的事情对 `Activity` 也成立。


在下一篇帖子中，我们将看一看测试的难度如何给我们提供新的见解：`SessionDetailFragment` 是高耦合的。我们将测试驱动同样的功能，并展示所得的设计是怎样高内聚和低耦合的。


