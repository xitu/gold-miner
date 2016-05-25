>* 原文链接 : [Getting started with JRebel for Android](https://medium.com/@shelajev/getting-started-with-jrebel-for-android-426633cde736#.dtldka9ua)
* 原文作者 : [Oleg Šelajev](https://medium.com/@shelajev)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Android development is great so long as your project stays relatively small. As the functionality of your project grows you’ll find that your build times follow suit. This puts you in the position where you spend most of your time figuring how to make your build run faster rather than adding more value to your actual app.

The internet is packed full with suggestions of how to squeeze the most out of your Gradle builds. There are some great posts on this, including, “[Making Gradle builds faster](http://zeroturnaround.com/rebellabs/making-gradle-builds-faster/)”. Although you can win back seconds and maybe even minutes, yet some bottlenecks will still remain in your build. For example having annotation based dependency injections are nice to have for a cleaner architecture, but it has an impact on your build time.

One thing you can try is [JRebel for Android](https://zeroturnaround.com/software/jrebel-for-android/?utm_source=medium&utm_medium=getting-started-jra-post&utm_campaign=medium). It takes a different approach by not introducing a new apk after each change. Instead apk gets installed once and delta packages are shipped over to the device or emulator and are applied during runtime. This logic is nothing new and has been present in the Java EE/SE with JRebel for more than 8 years.

Let’s take the Google IO 2015 app and see how the JRebel for Android setup works as well as how it can save you valuable time.

### Installing JRebel for Android

[JRebel for Android](https://zeroturnaround.com/software/jrebel-for-android/?utm_source=medium&utm_medium=getting-started-jra-post&utm_campaign=medium) is available as a plugin for Android Studio. You can download it directly from the IDE by navigating to _Plugins > Browse Repositories_ and searching for “JRebel for Android”.

![](http://ww4.sinaimg.cn/large/a490147fgw1f3y7px3ajhj20hs0fzmzm.jpg)

If for some reason you can’t access the public maven repositories you can download it directly from the JetBrains homepage. After which you need to install via the _Plugins > Install plugin from disk…_ route.

Once the plugin is installed, you’ll need to restart Android Studio, as usual after a plugin installation. After restart, you need to provide your name and email to get your free 21 day trial of JRebel for Android.

### Running my application with JRebel for Android

Now the plugin is installed, you just need to click the _Run with JRebel for Android_ button, which will always build a new apk if changes are detected between the previous installation. _Run with JRebel for Android_ is the same as the _Run_ action in Android Studio. So you’ll be faced with the same run flow, where you first need to pick a device and then apk is built and installed on that device etc.

To update your code and resources, JRebel for Android needs to process the project’s classes and embed an agent to the application. JRebel for Android will only run with a debuggable flavor, so your release apk is never affected. In addition no changes are required to your project. For a detailed overview of how JRebel for Android works, read this [under the hood post](http://zeroturnaround.com/rebellabs/under-the-hood-of-jrebel-for-android/).

So pressing _Run with JRebel for Android_ on the Google IO 2015 application would result in the following:

![](http://ww1.sinaimg.cn/large/a490147fgw1f3y7qkkn2jj20hs0b60ud.jpg)

### Applying changes with JRebel for Android

The _Apply changes_ button is the key when using JRebel for Android, it will do the least amount of work possible to make your changes and updates visible on your device. If you didn’t use _Run with JRebel for Android_ to install the application yet, _Apply changes_ will take care of the installation on your behalf.

Now let’s make a simple functional change to the application. For each session taking present in GoogleIO you can send feedback. We’ll add one additional element to the question, an input for your name and we’ll use the value from that input in a Toast thanking you for providing feedback.

**Step 1:** Add an EditText component to the _session_feedback_fragment.xml_

    <FrameLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content">
        <EditText
            android:id="@+id/name_input"
            android:layout_width="match_parent"
            android:layout_height="wrap_content"/>
    </FrameLayout>

![](http://ww3.sinaimg.cn/large/a490147fgw1f3y7qzqpp4j20ja0zaq5o.jpg)

**Step 2:** Fix the paddings

    <FrameLayout
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:paddingLeft="@dimen/padding_normal"
        android:paddingStart="@dimen/padding_normal"
        android:paddingRight="@dimen/padding_normal"
        android:paddingEnd="@dimen/padding_normal"
        android:paddingTop="@dimen/spacing_micro"
        android:paddingBottom="@dimen/padding_normal">

![](http://ww1.sinaimg.cn/large/a490147fgw1f3y7rcrfolj20jk0ziacq.jpg)

**Step 3:** Add a hint

    <EditText
        android:id="@+id/name_input"
        android:layout_width="match_parent"
        android:layout_height="wrap_content"
        android:hint="@string/name_hint"/>

![](http://ww1.sinaimg.cn/large/a490147fgw1f3y7romijnj20j80zgdij.jpg)

During all of these changes we have remained on the same screen on our device throughout. After each _Apply change_ [Activity.recreate()](https://developer.android.com/reference/android/app/Activity.html#recreate%28%29) is invoked by JRebel for Android. So your top most activity will go through the same callbacks as you would if you rotated your device from portrait to landscape, for example.

So far we’ve only performed resource changes, so let’s change some Java code as well.

**Step 4:** Show a toast in _SessionFeedbackFragment.sumbitFeedback()_

    EditText nameInput = (EditText) 

    getView().findViewById(R.id.name_input);

    Toast.makeText(getActivity(), "Thanks for the feedback " + 

    nameInput.getEditableText().toString(), Toast.LENGTH_SHORT).show();

![](http://ww4.sinaimg.cn/large/a490147fgw1f3y7s07qioj20je0zi0wr.jpg)

### Application restart vs Activity restart

Not all changes will trigger an [Activity.recreate()](https://developer.android.com/reference/android/app/Activity.html#recreate%28%29) invocation. Should you change something in the AndroidManifest, a new apk has to be built and an incremental install will be performed. In this case the application will be restarted. Application restart will also be done if you replace a superclass or change interfaces that the class is implementing. Here is a full breakdown of activity vs application restart:

![](http://ww1.sinaimg.cn/large/a490147fgw1f3y7sb4pmdj20gq07kabk.jpg)

### Why should I try JRebel for Android?

There are loads of reasons! Here are some of the most persuasive reasons as to why you should give it a go:

*   Reduce the time it takes to see your changes on the device
*   Polishing UI and getting that pixel perfect result no longer takes hours because of long build times
*   No need to change anything in your project to make JRebel for Android work
*   Use debugger and update code and resources at the same time! That’s right [JRebel for Android](https://zeroturnaround.com/software/jrebel-for-android/?utm_source=medium&utm_medium=getting-started-jra-post&utm_campaign=medium) comes with full debugger support!

