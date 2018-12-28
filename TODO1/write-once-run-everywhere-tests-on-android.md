> * 原文地址：[Write Once, Run Everywhere Tests on Android](https://medium.com/androiddevelopers/write-once-run-everywhere-tests-on-android-88adb2ba20c5)
> * 原文作者：[Jonathan Gerrish](https://medium.com/@jongerrish?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/write-once-run-everywhere-tests-on-android.md](https://github.com/xitu/gold-miner/blob/master/TODO1/write-once-run-everywhere-tests-on-android.md)
> * 译者：[Rickon](https://github.com/gs666)
> * 校对者：

# Android 上一次编写，到处测试

![](https://cdn-images-1.medium.com/max/800/1*xNQHxXBX-1RQCPM3LYa3wA.png)

在今年的 Google I/O 大会上，我们启动了 AndroidX Test，作为 [Jetpack](https://developer.android.com/jetpack/) 的一部分。今天，我们很高兴地宣布[v1.0.0](https://developer.android.com/training/testing/release-notes)最终版本和 Robolectric v4.0 一起发布。作为 1.0.0 版本的一部分，所有 AndroidX Test 现在都是[开源的](https://github.com/android/android-test)。

AndroidX Test 提供了跨测试环境的通用测试 APIs，包括仪器测试和 Robolectric 测试。它包括现有的 Android JUnit 4 支持，Espresso视图交互库和几个新的密钥测试 APIs。这些APIs可用于在真实和虚拟设备上进行仪器测试。从 Robolectric 4.0 开始，它们也可用于本地 JVM 测试。

考虑以下使用情形，我们启动登录屏幕，输入正确的用户名和密码，并确保进入主屏幕。

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

让我们逐步完成测试：

1.  我们使用新的 [ActivityScenario](https://developer.android.com/reference/androidx/test/core/app/ActivityScenario) API 来启动 LoginActivity。它将会创建个 activity 并进入用户可以看到并能够输入的 resumed 状态。ActivityScenario 处理与系统的所有同步，并为你应测试的常见场景提供支持，例如你的应用如何处理被系统销毁和重建。

2.  我们使用 Espresso 视图交互库将文本输入到两个文本字段中，然后点击 UI 中的按钮。与 ActivityScenario 类似，Espresso 为你处理多线程和同步，并提供可读且流畅的 API 以创建测试。

3.  我们使用新的 [Intents.getIntents()](https://developer.android.com/reference/androidx/test/espresso/intent/Intents.html#getIntents%28%29) Espresso API 来返回捕获的 intent 的列表。然后，我们使用 IntentSubject.assertThat() 验证捕获的意图，这是新的 Android Truth 扩展的一部分。这个 Android Truth 扩展提供了一个富有表现力和可读性的 API 来验证基本 Android 框架对象的状态。

这个测试可以在使用 Robolectric 或任何真实或虚拟设备的本地 JVM 上运行。

要在Android设备上运行它，请将它与以下依赖项一起放在“androidTest”源根目录中：

```
androidTestImplementation(“androidx.test:runner:1.1.0”)
androidTestImplementation(“androidx.test.ext:junit:1.0.0”)
androidTestImplementation(“androidx.test.espresso:espresso-intents:3.1.0”)
androidTestImplementation(“androidx.test.espresso:espresso-core:3.1.0”)
androidTestImplementation(“androidx.test.ext:truth:1.0.0”)
```

在真实或虚拟设备上运行可让你确信你的代码可以正确地与 Android 系统进行交互。但是，随着测试用例数量的增加，你开始牺牲测试执行时间。你可能决定只在真正的设备上运行少量较大的测试，同时在模拟器上运行大量较小的单元测试，比如 Robolectric，它可以在本地 JVM 上更快地运行测试。

要使用 Robolectric 模拟器在本地 JVM 上运行测试，请将测试放在“test”资源根目录中，将以下代码添加到 gradle.build：

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

模拟器和仪器之间测试 apis 的统一提供了许多令人兴奋的可能性！我们在 Google I / O 上发布的Nitrogen 项目将允许你在运行时环境之间无缝地切换测试。这意味着你将能够针对新的 AndroidX Test APIs 进行测试，并在本地JVM、真实或虚拟设备或甚至基于云的测试平台（如 Firebase 测试实验室）上运行它们。我们非常高兴有机会为开发人员提供有关其应用程序质量的快速、准确和可操作的反馈。

最后，我们很高兴的宣布所有的 AndroidX 组件是完全[开源](https://github.com/android/android-test)的，我们期待着你的贡献。

### 了解更多

文档：[https://developer.android.com/testing](https://developer.android.com/testing)

版本注释：

*   AndroidX Test: [https://developer.android.com/training/testing/release-notes](https://developer.android.com/training/testing/release-notes)
*   Robolectric: [https://github.com/robolectric/robolectric/releases/](https://github.com/robolectric/robolectric/releases/)

Robolectric: [https://github.com/robolectric/robolectric](https://github.com/robolectric/robolectric)

AndroidX Test: [https://github.com/android/android-test](https://github.com/android/android-test)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
