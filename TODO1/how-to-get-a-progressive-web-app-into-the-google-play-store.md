> * 原文地址：[How to Get a Progressive Web App into the Google Play Store](https://css-tricks.com/how-to-get-a-progressive-web-app-into-the-google-play-store/)
> * 原文作者：[Mateusz Rybczonek](https://css-tricks.com/author/mateuszrybczonek/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-get-a-progressive-web-app-into-the-google-play-store.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-get-a-progressive-web-app-into-the-google-play-store.md)
> * 译者：
> * 校对者：

# How to Get a Progressive Web App into the Google Play Store

[PWA (Progressive Web Apps)](https://developers.google.com/web/progressive-web-apps/) have been with us for some time now. Yet, each time I try explaining it to clients, the same question pops up: "Will my users be able to install the app using app stores?" The answer has traditionally been no, but this changed with Chrome 72 which shipped a new feature called [TWA (Trusted Web Activities)](https://developers.google.com/web/updates/2019/02/using-twa).

> **Trusted Web Activities** are a new way to integrate your web-app content such as your PWA with yourAndroid app using a protocol based on Custom Tabs.

In this article, I will use [Netguru’s](https://www.netguru.com/) existing PWA ([Wordguru](https://wordguru.netguru.com/)) and explain step-by-step what needs to be done to make the application available and ready to be installed straight from the Google Play app store.

Some of the things we cover here may sound silly to any Android Developers out there, but this article is written from the perspective of a front-end developer, particularly one who has never used Android Studio or created an Android Application. Also, please do note that a lot of what we're covering here is still extremely experimental since it's limited to Chrome 72.

### Step 1: Set up a Trusted Web Activity

Setting up a TWA doesn’t require you to write any Java code, but you will need to have [Android Studio](https://developer.android.com/studio/). If you’ve developed iOS or Mac software before, this is a lot like Xcode in that it provides a nice development environment designed to streamline Android development. So, grab that and meet me back here.

#### Create a new TWA project in Android Studio

Did you get Android Studio? Well, I can’t actually hear or see you, so I’ll assume you did. Go ahead and crack it open, then click on "Start a new Android Studio project." From there, let’s choose the "Add No Activity" option, which allows us to configure the project.

The configuration is fairly straightforward, but it’s always good to know what is what:

* **Name** The name of the application (but I bet you knew that).
* **Package name:** An [identifier](https://developer.android.com/guide/topics/manifest/manifest-element#package) for Android applications on the [Play Store](https://play.google.com). It must be unique, so I suggest using the URL of the PWA in reverse order (e.g. `com.netguru.wordguru`).
* **Save location:** Where the project will exist locally.
* **Language:** This allows us to select a specific code language, but there’s no need for that since our app is already, you know, written. We can leave this at Java, which is the default selection.
* **Minimum API level:** This is the version of the Android API we’re working with and is required by the support library (which we’ll cover next). Let’s use API 19.

There are few checkboxes below these options. Those are irrelevant for us here, so leave them all unchecked, then move on to Finish.

![](https://css-tricks.com/wp-content/uploads/2019/04/s_B0873689EA50413EA11DE0E251C79D95AC091600D224AE9E30EBEB80DF5C9068_1550759941286_Screenshot2019-02-21at15.38.48.png)

#### Add TWA Support Library

A support library is required for TWAs. The good news is that we only need to modify two files to fill that requirement and the both live in the same project directory: `Gradle Scripts`. Both are named `build.gradle`, but we can distinguish which is which by looking at the description in the parenthesis.

![](https://css-tricks.com/wp-content/uploads/2019/04/play-02.jpg)

There’s a Git package manager called [JitPack](https://jitpack.io/) that’s made specifically for Android apps. It’s pretty robust, but the bottom line is that it makes publishing our web app a breeze. It is a paid service, but I’d say it’s worth the cost if this is your first time getting something into the Google Play store.

**Editor Note:** This isn’t a sponsored plug for JitPack. It’s worth calling out because this post is assuming little-to-no familiarity with Android Apps or submitting apps to Google Play and it has less friction for managing an Android App repo that connects directly to the store. That said, it’s totally not a requirement.

Once you’re in JitPack, let’s connect our project to it. Open up that `build.gradle (Project: Wordguru)` file we just looked at and tell it to look at JitPack for the app repository:

```javascript
allprojects {
  repositories {
    ...
    maven { url 'https://jitpack.io' }
    ...
  }
}
```

OK, now let’s open up that other `build.gradle` file. This is where we can add any required dependencies for the project and we do indeed have one:

```javascript
// build.gradle (Module: app)

dependencies {
  ...
  implementation 'com.github.GoogleChrome:custom-tabs-client:a0f7418972'
  ...
}
```

TWA library uses Java 8 features, so we’re going to need enable Java 8. To do that we need to add `compileOptions` to the same file:

```javascript
// build.gradle (Module: app)

android {
  ...
  compileOptions {
    sourceCompatibility JavaVersion.VERSION_1_8
    targetCompatibility JavaVersion.VERSION_1_8
  }
  ...
}
```

There are also variables called `manifestPlaceholders` that we’ll cover in the next section. For now, let’s add the following to define where the app is hosted, the default URL and the app name:

```javascript
// build.gradle (Module: app)

android {
  ...
  defaultConfig {
    ...
    manifestPlaceholders = [
      hostName: "wordguru.netguru.com",
      defaultUrl: "https://wordguru.netguru.com",
      launcherName: "Wordguru"
    ]
    ...
  }
  ...
}
```

#### Provide app details in the Android App Manifest

Every Android app has an [Android App Manifest](https://developer.android.com/guide/topics/manifest/manifest-intro) (`AndroidManifest.xml`) which provides essential details about the app, like the operating system it’s tied to, package information, device compatibility, and many other things that help Google Play display the app’s requirements.

The thing we’re really concerned with here is [Activity](https://developer.android.com/guide/topics/manifest/activity-element) (`<activity>`). This is what implements the user interface and is required for the "Activities" in "Trusted Web Activities."

Funny enough, we selected the "Add No Activity" option when setting up our project in Android Studio and that’s because our manifest is empty and contains only the application tag.

Let’s start by opening up the manfifest file. We’ll replace the existing `package` name with our own application ID and the `label` with the value from the `manifestPlaceholders` variables we defined in the previous section.

Then, we’re going to actually add the TWA activity by adding an `<activity>` tag inside the `<application>` tag.

```html
<manifest
  xmlns:android="http://schemas.android.com/apk/res/android"
  package="com.netguru.wordguru"> // highlight

  <application
    android:allowBackup="true"
    android:icon="@mipmap/ic_launcher"
    android:label="${launcherName}" // highlight
    android:supportsRtl="true"
    android:theme="@style/AppTheme">

    <activity
      android:name="android.support.customtabs.trusted.LauncherActivity"
      android:label="${launcherName}"> // highlight

      <meta-data
        android:name="android.support.customtabs.trusted.DEFAULT_URL"
        android:value="${defaultUrl}" /> // highlight

      
      <intent-filter>
        <action android:name="android.intent.action.MAIN" />
        <category android:name="android.intent.category.LAUNCHER" />
      </intent-filter>

      
      <intent-filter android:autoVerify="true">
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE"/>
        <data
          android:scheme="https"
          android:host="${hostName}"/> // highlight
      </intent-filter>
    </activity>
  </application>
</manifest>
```

And that, my friends, is Step 1. Let’s move on to Step 2.

### Step 2: Verify the relationship between the website and the app

TWAs require a connection between the Android application and the PWA. To do that, we use [Digital Asset Links](https://developers.google.com/digital-asset-links/v1/getting-started).

The connection must be set on both ends, where TWA is the application and PWA is the website.

To establish that connection we need to modify our `manifestPlaceholders` again. This time, we need to add an extra element called `assetStatements` that keeps the information about our PWA.

```javascript
// build.gradle (Module: app)

android {
  ...
  defaultConfig {
    ...
    manifestPlaceholders = [
      ...
      assetStatements: '[{ "relation": ["delegate_permission/common.handle_all_urls"], ' +
        '"target": {"namespace": "web", "site": "https://wordguru.netguru.com"}}]'
      ...
    ]
    ...
  }
  ...
}
```

Now, we need to add a new `meta-data` tag to our `application` tag. This will inform the Android application that we want to establish the connection with the application specified in the `manifestPlaceholders`.

```javascript
<manifest
  xmlns:android="http://schemas.android.com/apk/res/android"
  package="${packageId}">

  <application>
    ...
      <meta-data
        android:name="asset_statements"
        android:value="${assetStatements}" />
    ...
  </application>
</manifest>
```

That’s it! we just established the application to website relationship. Now let’s jump into the conversion of website to application.

To establish the connection in the opposite direction, we need to create a `.json` file that will be available in the app’s `/.well-known/assetlinks.json` path. The file can be created using a generator that’s built into Android Studio. See, I told you Android Studio helps streamline Android development!

We need three values to generate the file:

* **Hosting site domain:** This is our PWA URL (e.g. `https://wordguru.netguru.com/`).
* **App package name:** This is our TWA package name (e.g. `com.netguru.wordguru`).
* **App package fingerprint (SHA256):** This is a unique cryptographic hash that is generated based on Google Play Store keystore.

We already have first and second value. We can get the last one using Android Studio.

First we need to generate signed APK. In the Android Studio go to: Build → Generate Signed Bundle or APK → APK.

![](https://css-tricks.com/wp-content/uploads/2019/04/s_B0873689EA50413EA11DE0E251C79D95AC091600D224AE9E30EBEB80DF5C9068_1550496798628_Screenshot2019-02-18at14.33.09.png)

Next, use the existing keystore, if you already have one. If you need one, go to "Create new…" first.

Then let’s fill out the form. Be sure to remember the credentials as those are what the application will be signed with and they confirm your ownership of the application.

![](https://css-tricks.com/wp-content/uploads/2019/04/play-03.jpg)

This will create a keystore file that is required to generate the app package fingerprint (SHA256). **This file is extremely important** as it is works as a proof that you are the owner of the application. If this file is lost, you will not be able to do any further updates to your application in the store.

Next up, let’s select type of bundle. In this case, we’re choosing "release" because it gives us a production bundle. We also need to check the signature versions.

![](https://css-tricks.com/wp-content/uploads/2019/04/s_B0873689EA50413EA11DE0E251C79D95AC091600D224AE9E30EBEB80DF5C9068_1550496985643_Screenshot2019-02-18at14.36.03.png)

This will generate our APK that will be used later to create a release in Google Play store. After creating our keystore, we can use it to generate required app package fingerprint (the SHA256).

Let’s head back to Android Studio, and go to Tools → App Links Assistant. This will open a sidebar that shows the steps that are required to create a relationship between the application and website. We want to go to Step 3, "Declare Website Association" and fill in required data: `Site domain` and `Application ID`. Then, select the keystore file generated in the previous step.

![](https://css-tricks.com/wp-content/uploads/2019/04/s_B0873689EA50413EA11DE0E251C79D95AC091600D224AE9E30EBEB80DF5C9068_1550760222016_Screenshot2019-02-21at15.43.26.png)

After filling the form press "Generate Digital Asset Links file" which will generate our `assetlinks.json` file. If we open that up, it should look something like this:

```javascript
[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.netguru.wordguru",
    "sha256_cert_fingerprints": ["8A:F4:....:29:28"]
  }
}]
```

This is the file we need to make available in our app’s `/.well-known/assetlinks.json` path. I will not describe how to make it available on that path as it is too project-specific and outside the scope of this article.

We can test the relationship by clicking on the "Link and Verify" button. If all goes well, we get a confirmation with "Success!"

![](https://css-tricks.com/wp-content/uploads/2019/04/s_B0873689EA50413EA11DE0E251C79D95AC091600D224AE9E30EBEB80DF5C9068_1550497970710_9.png)

Yay! We’ve established a two-way relationship between our Android application and our PWA. It’s all downhill from here, so let’s drive it home.

### Step 3: Get required assets

Google Play requires a few assets to make sure the app is presented nicely in the store. Specifically, here’s what we need:

* **App Icons:** We need a variety of sizes, including 48x48, 72x72, 96x96, 144x144, 192x192… or we can use an [adaptive icon](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive).
* **High-res Icon:** This is a 512x512 PNG image that is used throughout the store.
* **Feature Graphic:** This is a 1024x500 JPG or 24-bit PNG (no alpha) banner that Google Play uses on the app details view.
* **Screenshots:** Google Play will use these to show off different views of the app that users can check out prior to downloading it.

![](https://css-tricks.com/wp-content/uploads/2019/04/play-05.jpg)

Having all those, we can proceed to the [Google Play Store developers console](https://play.google.com/apps/publish) and publish the application!

### Step 4: Publish to Google Play!

Let’s go to the last step and finally push our app to the store.

Using the APK that we generated earlier (which is located in the `AndroidStudioProjects` directory), we need to go to the [Google Play console](https://play.google.com/apps/publish/) to publish our application. I will not describe the process of publishing an application in the store as the wizard makes it pretty straightforward and we are provided step-by-step guidance throughout the process.

It may take few hours for the application to be reviewed and approved, but when it is, it will finally appear in the store.

If you can’t find the APK, you can create a new one by going to Build → Generate signed bundle / APK → Build APK, passing our existing keystore file and filling the alias and password that we used when we generated the keystore. After the APK is generated, a notice should appear and you can get to the file by clicking on the "Locate" link.

### Congrats, your app is in Google Play!

That’s it! We just pushed our PWA to the Google Play store. The process is not as intuitive as we would like it to be, but still, with a bit of effort it is definitely doable, and believe me, it gives that great filling at the end when you see your app displayed in the wild.

It is worth pointing out that this feature is still very much **early phase** and I would consider it **experimental** for some time. I would **not** recommend going with a production release of your application for now because this only works with Chrome 72 and above — any version before that will be able to install the app, but the app itself will crash instantly which is not the best user experience.

Also, the official release of `custom-tabs-client` does not support TWA yet. If you were wondering why we used raw GitHub link instead of the official library release, well, that’s why.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
