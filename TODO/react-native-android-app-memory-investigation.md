> * 原文地址：[React Native Android App Memory Investigation](https://shift.infinite.red/react-native-android-app-memory-investigation-55695625da9c#.a1m35m6jb)
* 原文作者：[Leon Kim](https://shift.infinite.red/@blackgoat)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# React Native Android App Memory Investigation


### Images not loading on my old Android phone?

While working on a React Native app not long ago, I noticed something odd. I could not see any images on the next screens, only colors and text on Android. Whereas, there was no problem on iOS.

I blamed my old Android phone which I had recently set up for testing React Native Android projects. I went so far as to install a custom rom (based on AOSP 5.1.1) for running React Native on a higher Android version, and to get rid of all the useless Samsung apps. However, I couldn’t see any images except on the first screen of a sample project. I just threw the phone back in my drawer.

A couple of days later, my friend posted that images were not loading on a certain screen of a React Native Android app. Hmm… that’s pretty bizarre… oh wait, I think I have seen something like that…

Oh, it was not just my phone.

### It’s… hard to explain.

The source code is straightforward. There are no tricks or external libraries for displaying images. I started off by running the app on GenyMotion and Android Virtual Device(AVD) with different Android versions:

*   **My phone**: I could only see the images that were on the first screen
*   **GenyMotion (API 21, API 22)**: Problem with some  nodes
*   **AVD (API 21, API 22, API 23)**: No problem!?

I thought the chances are that the issue was only happening on specific devices or Android API versions but apparently it wasn’t. In another words, I had to take pretty much all the other possibilities into account. This was becoming a big headache.

### My life-long enemy: memory

This app has many images to display as cell backgrounds and they aren’t small. (400~800kb) Despite that, it should be bearable, but one thing slightly suspicious was that the images are fetched by remote URI.

I started wondering what the memory structure looked like, especially heap space since the images from remote will be assigned dynamically. I started tracking down memory usage.

### You want some eye-candy memory inspector?

Years ago, I used to use this to check memory usage:

    adb shell dumpsys meminfo

I love console applications, but this is not so eye-friendly when it comes to visualizing memory usage.







![](https://cdn-images-1.medium.com/max/1600/1*Z1SdG8xVPb_35zd5EfgfFw.png)



You don’t want these, do you?

If you use it when you’re hungover on a Saturday morning, it’s a nightmare. (Not that I did, though ![😉](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f609.png)) I needed something to make running the garbage collector easy.

The easiest (and free!) inspector is **Android Device Monitor**. If you have Android Studio, you already have it. Open it up with these steps:

1.  Run React Native app normally (**_react-native run-android_**)
2.  Run **Android Studio**
3.  On the menu, click **Tools → Android → Enable ADB Integration**
4.  Click **Tools → Android → Android Device Monitor**
5.  When Android Device Monitor shows up, click **Monitor → Preferences**
6.  On the dialog, in **Android** → **DDMS**, check these two options:

*   Heap updates enabled by default
*   Thread updates enable by default (optional)







![](https://cdn-images-1.medium.com/max/1600/1*mut35zka6GU77s5tup4CWQ.png)



Then you will see a screen like this (**System Information tab**):







![](https://cdn-images-1.medium.com/max/1600/1*sr3QA9GwDxRtB-m1Pp87Tw.png)



If you see this screen:







![](https://cdn-images-1.medium.com/max/1600/1*JLsrnmcD_L_W_m4Uocz2Fg.png)



Run this to make your development server accessible for the device.

    adb reverse tcp:8081 tcp:8081

This could happen if you run your app from Android Studio while the app has already been started by **_react-native run-android_**.







![](https://cdn-images-1.medium.com/max/1600/1*Gu7-0W6EWPeUiqXQakPR9Q.png)



Select your app on the Devices tab on the left. Now you’re ready to check out your app’s memory.

### Increase the heap size

I saw something weird was going on while I was running Android Device Monitor and navigating through the screens.



![](https://cdn-images-1.medium.com/max/1600/1*kNdaXpsYjMpleztZhynlMg.png)



It was the **Heap Size** which wasn’t going over about 124MB, even though it was already about 124MB on the first screen. Then garbage collector ran:

    I/art(27035): Background partial concurrent mark sweep GC freed 1584(69KB) AllocSpace objects, 2(30KB) LOS objects, 12% free, 108MB/124MB, paused 3.874ms total 182.718ms

My question was, **_“Why is the heap size so small?”_**

Recommended **dalvik.vm.heapsize** in **ART Java Heap Parameter** for Android 5.0.0 is **384MB**:







![](https://cdn-images-1.medium.com/max/1600/1*BZIbKcLYirq99SnSslHf7g.png)



source: [https://01.org/android-ia/user-guides/android-memory-tuning-android-5.0-and-5.1](https://01.org/android-ia/user-guides/android-memory-tuning-android-5.0-and-5.1)

I even pulled my phone’s build property and checked (**_adb -d pull /system/build.prop_**) the heap size was **_256MB_**.







![](https://cdn-images-1.medium.com/max/1600/1*ZVE8sitPIMpwPK_eUaqFAQ.png)



Then I figured out how to set a larger heap size. Just add this line in: ****in **AndroidManifest.xml**

    <application
          android:name=".MainApplication"
          android:allowBackup="true"
          android:label="@string/app_name"
          android:icon="@mipmap/ic_launcher"
          android:theme="@style/AppTheme"
          android:largeHeap="true">

This is the result when I enabled largeHeap:



![](https://cdn-images-1.medium.com/max/1600/1*rCj-PMfAZC8Giv5T55ZxTQ.png)



That’s it. Yes. Only one dang line. _What a bummer!_

The reason that none of AVD instances (API 21 ~23) have a problem with displaying images was the emulator is smarter. It increases heap size when it needs, although it warns about setting heap size.

    emulator: WARNING: Setting VM heap size to 384MB

### One step further – How to check for memory leaks

The issue I solved above was not exactly an application memory problem, but the configuration. If your app has a deeper memory problem, here is a way to check if your app is leaking memory with **Memory Analyzer** based on Eclipse RCP.

It doesn’t require Eclipse so you can just download the standalone version. Download and install it: [http://www.eclipse.org/mat/downloads.php](http://www.eclipse.org/mat/downloads.php)

1.  Click **Cause GC** to run garbage collector.







![](https://cdn-images-1.medium.com/max/1600/1*mot94k1pAcMQV6_s3NklUQ.png)



2\. Click **Dump HPROF file** button to capture memory profile dump.







![](https://cdn-images-1.medium.com/max/1600/1*bQZOyBQ-UyBFogTU_y1wiA.png)



3\. Convert the Android-specific dump file so that our Memory Analyzer can read. (You need **platform-tools** from Android SDK)

    hprof-conv com.leak_sample.hprof com.leak_sample_converted.hprof

4\. Run Memory Analyzer and open the converted hprof file. Then Select **Leak Suspects Report** (You can cancel and choose this later).







![](https://cdn-images-1.medium.com/max/1600/1*Ww9lPbEwUbJB_j6UHfuKOA.png)



5\. Ta-da!







![](https://cdn-images-1.medium.com/max/1600/1*ggBpH13Lc3Z9xHBPnutK9A.png)



### Memory leak example

Let’s assume there’s an Android native module for your React Native app. It has a singleton class setting a listener that calls onUpdate() with creating a String array[10,000,000]. (I know it’s a meaningless class but let’s focus on what we want to see. Be simple.)

Unfortunately, you forgot to clear the listener onDestroy(), which will cause a memory leak every time when you rotate the screen. And you’re wondering why your app dies unexpectedly.

Here’s the screen of Memory Analyzer after following the 5 steps above:







![](https://cdn-images-1.medium.com/max/1600/1*5HWTSNwMZixtrzGJAd1b0g.png)



As you can see, **LetsLeak** class consumed a pretty big portion of memory. Note that it’s a _suspect_ not an _actual cause_.

Let’s move onto **Dominator Tree**.







![](https://cdn-images-1.medium.com/max/1600/1*xupGI0OuvK5FI8tKR0_fvQ.png)



You can see sorted lists of memory usage on **Top Consumers**, but in this case there’s only one problem suspect, Dominator Tree is a better option to see the details.







![](https://cdn-images-1.medium.com/max/1600/1*wzmNiy_kvV5I3ZJdh8tOXQ.png)



On **Dominator Tree**, Shallow Heap means references for objects, and Retained Heap stands for actual size of all objects contained.

On **Inspector**, you see the big size of array that you created. You might think, _“Okay, I’ve created a String array in the singleton class, but why is the retained heap so big? There should be only one…”_ Then you would realize that you didn’t release the memory; a pretty common mistake when using a singleton.

### Conclusion

A good combination of Android Device Monitor and Memory Analyzer can monitor threads and profile memory which could be used to investigate any kind of memory issue on Android. React Native Android is not an exception.

Like the memory leak example above, a single object holding a bigger heap size than you would expect, is rather easy to catch. However, it’s tough when it comes to tracking down real apps. Using these tools could be a big help without a doubt.

### About Leon

Leon Kim is a software engineer at [Infinite Red](http://infinite.red/) who works from the Far East, South Korea. He studied [image processing and pattern recognition](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3222545/) in graduate school, developed a [prison guard robot](http://www.reuters.com/video/2012/04/12/robo-guard-on-patrol-in-south-korean-pri?videoId=233213268) as a part of a government research project, and has diverse system development backgrounds across LTE IPsec Security Gateway, Signaling System 7 MTP3 layer and pharmaceutical automation. He loves working as a web and mobile app developer with the amazing folks at [Infinite Red](http://infinite.red/) and enjoys having Korean BBQ with friends every Friday night. (불금!)

Have questions? Comments? I’m [@leonskim on Twitter](https://twitter.com/leonskim) Or visit us at [**Infinite Red**](http://infinite.red/)**.**

