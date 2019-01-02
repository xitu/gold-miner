> * 原文地址：[Write Once, Run Everywhere Tests on Android](https://medium.com/androiddevelopers/write-once-run-everywhere-tests-on-android-88adb2ba20c5)
> * 原文作者：[Jonathan Gerrish](https://medium.com/@jongerrish?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/write-once-run-everywhere-tests-on-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/write-once-run-everywhere-tests-on-android.md)
> * 译者：
> * 校对者：

# Write Once, Run Everywhere Tests on Android

![](https://cdn-images-1.medium.com/max/800/1*xNQHxXBX-1RQCPM3LYa3wA.png)

At Google I/O this year, we launched AndroidX Test, part of [Jetpack](https://developer.android.com/jetpack/). Today we’re happy to announce the release of [v1.0.0](https://developer.android.com/training/testing/release-notes) Final alongside Robolectric v4.0. As part of the 1.0.0 release, all of AndroidX Test is now [open source](https://github.com/android/android-test).

AndroidX Test provides common test APIs across test environments including instrumentation and Robolectric tests. It includes the existing Android JUnit 4 support, the Espresso view interaction library, and several new key testing APIs. These APIs are available for instrumentation tests on real and virtual devices. As of Robolectric 4.0, they are available for local JVM tests, too.

Consider the following use case where we launch the login screen, enter a valid username and password, and make sure we’re taken to the home screen.

```
@RunWith(AndroidJUnit4::class)
class LoginActivityTest {

  @Test fun successfulLogin() {
    // GIVEN
    val scenario = 
        ActivityScenario.launch(LoginActivity::class.java)

    // WHEN
    onView(withId(R.id.user_name)).perform(typeText(“test_user”))
    onView(withId(R.id.password))
        .perform(typeText(“correct_password”))
    onView(withId(R.id.button)).perform(click())

    // THEN
    assertThat(getIntents().first())
        .hasComponentClass(HomeActivity::class.java)
 }
}
```

Lets step through the test:

1.  We use the new [ActivityScenario](https://developer.android.com/reference/androidx/test/core/app/ActivityScenario) API to launch the LoginActivity. This creates the activity and brings it to the resumed state, where it is visible to the user and ready for input. ActivityScenario handles all the synchronization with the system and provides support for common scenarios you should be testing such as how your app handles being destroyed and recreated by the system.

2.  We use the Espresso view interaction library to enter text into two text fields and click a button in the UI. Similar to ActivityScenario, Espresso handles multi-threading and synchronization for you and surfaces a readable and fluent API to author tests with.

3.  We use the new [Intents.getIntents()](https://developer.android.com/reference/androidx/test/espresso/intent/Intents.html#getIntents%28%29) Espresso API that returns a list of captured intents. We then verify the captured intents using IntentSubject.assertThat(), part of the new Android Truth extensions. The Android Truth extension provides an expressive and readable API to validate states of fundamental Android framework objects.

This test can run on a local JVM using Robolectric or any physical or virtual device.

To run it on an Android device, place it in your “androidTest” source root along with the following dependencies:

```
androidTestImplementation(“androidx.test:runner:1.1.0”)
androidTestImplementation(“androidx.test.ext:junit:1.0.0”)
androidTestImplementation(“androidx.test.espresso:espresso-intents:3.1.0”)
androidTestImplementation(“androidx.test.espresso:espresso-core:3.1.0”)
androidTestImplementation(“androidx.test.ext:truth:1.0.0”)
```

Running on a physical or virtual device gives you confidence that your code interacts with the Android system correctly. As you scale up the number of test cases, however, you start to sacrifice test execution time. You may decide to only run a few larger tests on a real device while running a large number of smaller unit tests on a simulator, such as Robolectric, which can run tests more quickly on a local JVM.

To run the tests on a local JVM using the Robolectric simulator place the test in the “test” source root, adding the following lines to your gradle.build:

```
testImplementation(“androidx.test:runner:1.1.0”)
testImplementation(“androidx.test.ext:junit:1.0.0”)
testImplementation(“androidx.test.espresso:espresso-intents:3.1.0”)
testImplementation(“androidx.test.espresso:espresso-core:3.1.0”)
testImplementation(“androidx.test.ext:truth:1.0.0”)
testImplementation (“org.robolectric:robolectric:4.0”)

android {
    testOptions.unitTests.includeAndroidResources = true
}
```

The unification of testing apis between simulators and instrumentation opens up a lot of exciting possibilities! Project Nitrogen, which we also announced at Google I/O, will allow you to seamlessly move tests between runtime environments. This means that you will be able to take tests written against the new AndroidX Test APIs and run them on a local JVM, real or virtual device, or even a cloud based testing platform such as Firebase Test Lab. We are very excited by the opportunities this will provide developers to get fast, accurate, and actionable feedback on the quality of their applications.

Finally, we are happy to announce that all AndroidX components are fully [open sourced](https://github.com/android/android-test) and we look forward to welcoming your contributions.

### Read more

Documentation: [https://developer.android.com/testing](https://developer.android.com/testing)

Release notes:

*   AndroidX Test: [https://developer.android.com/training/testing/release-notes](https://developer.android.com/training/testing/release-notes)
*   Robolectric: [https://github.com/robolectric/robolectric/releases/](https://github.com/robolectric/robolectric/releases/)

Robolectric: [https://github.com/robolectric/robolectric](https://github.com/robolectric/robolectric)

AndroidX Test: [https://github.com/android/android-test](https://github.com/android/android-test)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
