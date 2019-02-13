> * 原文地址：[The Android Dev Summit 2018 app (instant app takeaways + open source)](https://medium.com/androiddevelopers/the-android-dev-summit-2018-app-instant-app-takeaways-open-source-e5b590f78f38)
> * 原文作者：[Jose Alcérreca](https://medium.com/@JoseAlcerreca)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-android-dev-summit-2018-app-instant-app-takeaways-open-source.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-android-dev-summit-2018-app-instant-app-takeaways-open-source.md)
> * 译者：
> * 校对者：

# The Android Dev Summit 2018 app (instant app takeaways + open source)

Takeaways from creating the Android Dev Summit app and releasing an app bundle with instant experience.

The [Android Dev Summit](https://developer.android.com/dev-summit/) app was released for attendees and remote viewers of the summit, held on November 7th and 8th in Mountain View, California.

![](https://cdn-images-1.medium.com/max/2000/1*F12l55pOjn7vPiXBrbklCg.png)

_Android Dev Summit app_

### IO-Sched -> ADS-Sched

The Android Dev Summit app ([adssched](https://github.com/google/iosched/tree/adssched)) was based on the Google I/O app (iosched) which is an open source project [available on Github](https://github.com/google/iosched/). Some features that were not needed were removed, such as:

*   **Reservations** [[main commit](https://github.com/google/iosched/commit/65a5eb2d61bdd7507148db4d3b32a34f85a9e422)]. This feature was deeply coupled with every layer of the application and brought a lot of complexity to the data repository. In the I/O app, we used an endpoint that would indicate if a user was a registered attendee. Non-attendees had a different user experience. In addsched, all users are the same, making the business logic much simpler.
*   **Map** screen [[commit](https://github.com/google/iosched/commit/36c1e942379fcfac9181dcac58db434ebcdbb532)\]. The conference only had two tracks so a map wasn’t needed. This freed up a spot in the bottom navigation allowing us to promote the agenda to a top level destination.

We also added some new features:

*   **Notifications** [[commit](https://github.com/google/iosched/commit/a13dcdae7e2bee6c287549ef4674a84b78f2218c)]. Uses AlarmManager to set reminders 5 minutes before the start time of the starred items.
*   **Instant app** [[commit](https://github.com/google/iosched/commit/07092236185425bb5e10c5b5629377ed9dcc6e10)]. Building an instant app from an Android Studio project is extremely easy now. We used flavors to generate two different bundles (installed/instant). This is a requirement now but in the future you’ll be able to upload a single bundle.

### Instant app stats

This is the first time we’ve released a conference app as an instant app and we were curious to see how many people would use this model.

![](https://cdn-images-1.medium.com/max/1600/1*neTrUNi4qRnDiTPMmEEfeQ.png)

_Installed app usage vs Instant experience usage [Oct 30th — Nov 15th]_

About 25% out of the instant users (15% of total users) **made the jump to the installed app**:

![](https://cdn-images-1.medium.com/max/1600/1*KomG5B1oxInVkNwXPZkc4w.png)

_Instant experience usage + Installed app usage_

#### Adoption:

*   When the app was [announced](https://android-developers.googleblog.com/2018/10/the-android-dev-summit-app-is-live-get.html), a week before the conference, we saw around **40% of users via the instant experience**. It was accessible from search results and the _try now_ button on Play.

![](https://cdn-images-1.medium.com/max/1600/1*MLOghqlxxrXtgc38JTcW6A.png)

[The “try now” button](https://play.google.com/store/apps/details?id=com.google.samples.apps.adssched) opens the instant experience

*   During the conference the figure **went down to 30%**, probably due to availability of notifications.
*   It’s also interesting that there were less installations and more instant app users after the conference ended. Users seemed to understand that notifications are the only difference between the two.

Before releasing an instant app, follow [this guide to set analytics up](https://developer.android.com/topic/google-play-instant/guides/analytics) and also add events for the instant-to-installed flow (which sadly we didn’t!).

### Takeaways of adding an instant experience

Things that worked well:

*   The **authentication** mechanism required no modifications. [Firebase Auth](https://firebase.google.com/docs/auth/) and Google Smart Lock for Passwords took care of everything so signing into the instant experience was very smooth.
*   Users that **searched** for the summit on their Android phone found the instant app.

![](https://cdn-images-1.medium.com/max/1600/1*YbmaVwK6kxnXdyf8dJ8C2g.png)

_Google Search results for the summit showing the instant app_

*   The **flow to install the app** from the instant app is handled by Google Play seamlessly.

![](https://cdn-images-1.medium.com/max/1600/1*79wg9dJRlV4ulAaTkp4f1Q.gif)

_Google Play’s instant->installed flow_

Things that could have been better:

*   An **issue** with activity-alias discovery prevented the app from appearing on the launchers after the instant app launch. It showed up in the _recents_ screen, but it was [far from ideal](https://twitter.com/lehtimaeki/status/1058077669076729857). Due to time constraints we weren’t able to ship [the bug fix](https://github.com/google/iosched/commit/d5f1fdbfdb9d6c49a256fdaad52a9ea73392c71e) in time.
*   **Notifications** are not directly available from instant apps. However, you can send push notifications via Play Services (currently in [beta](https://docs.google.com/forms/d/e/1FAIpQLSeu5yabEoJNXfTIugoqqhAqI6HMu2ebpLhyHuWZ2D85s4rRLw/viewform)). As this requires back-end code we decided to showcase the instant->installed flow using notifications. It’s the only difference between the two flavors.

### Open sourcing adssched

IOSched was always meant to be a sample (hence the package name) to learn from and be used as a base for other conference apps. However, I/O has certain requirements that complicate the adaptation to a regular conference app, like the reservation system.

The Android Dev Summit is similar in size and requirements to other conferences making it a **much better fit to be forked** and reused. A new version just requires a Firebase project (we recommend using a second staging project, linked to the Debug build type) and a place to host the [conference data JSON file](https://github.com/google/iosched/blob/adssched/shared/src/main/resources/conference_data_2018.json), whose format is straightforward.

➡ [https://github.com/google/iosched/tree/adssched](https://github.com/google/iosched/tree/adssched)

If you need help creating a fork for your conference, feel free to open an issue on the [Github project](https://github.com/google/iosched).

* * *

This instant experiment was a success and **produced very interesting data**, but our use case was quite simple given that the full app was small enough, we only had a single instant entry point, and the user base was limited. We can’t wait to see where developers take instant apps and what the community builds with adssched!

_Credits:_ [_Ben Weiss_](https://medium.com/@keyboardsurfer) _(adssched’s instant app feature owner),_ [_Nick Butcher_](https://medium.com/@crafty) _(creator of magical GIFs)_

Thanks to [Nick Butcher](https://medium.com/@crafty?source=post_page) and [Ben Weiss](https://medium.com/@keyboardsurfer?source=post_page).

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
