> * 原文地址：[Native Splash Screen in Flutter Using Lottie](https://medium.com/swlh/native-splash-screen-in-flutter-using-lottie-121ce2b9b0a4)
> * 原文作者：[AbedElaziz Shehadeh](https://medium.com/@elaziz-shehadeh)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/native-splash-screen-in-flutter-using-lottie.md](https://github.com/xitu/gold-miner/blob/master/article/2021/native-splash-screen-in-flutter-using-lottie.md)
> * 译者：
> * 校对者：

# Native Splash Screen in Flutter Using Lottie

![](https://cdn-images-1.medium.com/max/2400/1*4vlkTJCWbP2Kh2vyK9BdEw.png)

Adding an animated splash screen directly in Flutter using dart code is possible, however, the way Flutter application starts as a FlutterActivity or a FlutterViewController in Android and iOS adds a few seconds before Flutter actually draws its first frame. Therefore, having a splash screen natively will start the animation the moment the app launches, resulting in a better user experience.

It is worth mentioning that adding a static image as a splash screen is fairly easy and well documented at Flutter’s official [documentation](https://flutter.dev/docs/development/ui/advanced/splash-screen), where you can simply add your images in Android’s drawable and iOS assets then use them in **styles.xml** in Android and **LaunchScreen.storyboard** in iOS. However, I could not find many resources on how to achieve that for an animated splash screen using Lottie for instance, and that’s what I am gonna explain in this article.

## Why Lottie?

[Lottie](https://airbnb.io/lottie/#/) is a library with support for multiple platforms including Android and iOS that parses [Adobe After Effects](http://www.adobe.com/products/aftereffects.html) animations exported as json with [Bodymovin](https://github.com/airbnb/lottie-web) and renders them natively. That means the animation is created by designers and exported as a **json** file with no additional efforts by the developers. In this tutorial, I will be using a free sample file created by LottieFiles and can be found at this [link](https://lottiefiles.com/38237-thanksgiving-cornucopia). So let’s get started.

Create a new flutter project, and follow these steps;

## Android

1. Start by adding Lottie dependency to your project’s `build.gradle` file found at /android/app/: (I added constraint layout dependency as well)

```
dependencies {
   ...
   implementation "com.airbnb.android:lottie:3.5.0"
   implementation "com.android.support.constraint:constraint-layout:2.0.4"
   ...
}
```

2. In `AndroidManifest.xml` remove meta data tag with the name io.flutter.embedding.android.SplashScreenDrawable and replace `LaunchTheme` under activity tag with `NormalTheme` so your the file will look like the following;

```XML
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.abedelazizshe.flutter_lottie_splash_app">
    <!-- io.flutter.app.FlutterApplication is an android.app.Application that
         calls FlutterMain.startInitialization(this); in its onCreate method.
         In most cases you can leave this as-is, but you if you want to provide
         additional functionality it is fine to subclass or reimplement
         FlutterApplication and put your custom class here. -->
    <application
        android:name="io.flutter.app.FlutterApplication"
        android:label="flutter_lottie_splash_app"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:launchMode="singleTop"
            android:theme="@style/NormalTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

You can remove `LaunchTheme` from /android/app/res/values/styles.xml as you will not need it any more.

3. Create a `raw` directory under /android/app/res/values and copy the .json file, whether you created your own or downloaded a free sample from the link above. In this tutorial, it’s named `splash_screen.json` .

4. In order to use the .json file and display the animation view, we need to create a splash view class with its layout. Under /android/app/res, create a new directory called `layout` (if it does not exist) and then create a new resource file called `splash_view.xml` . Open the xml file and ensure it looks like the following;

```XML
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <com.airbnb.lottie.LottieAnimationView
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        app:layout_constraintBottom_toBottomOf="parent"
        app:layout_constraintStart_toStartOf="parent"
        app:layout_constraintTop_toTopOf="parent"
        app:lottie_autoPlay="true"
        app:lottie_rawRes="@raw/splash_screen"
        app:lottie_loop="false"
        app:lottie_speed="1.00" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

For this demo, I set the animation to auto play, with a speed of 1.0. And I don’t want it to loop. You can play with the different values as you wish. The most important part is `app:lottie_rawRes` that indicates we want to use the json file we added in `raw` directory. Now, we need to create the splash view class. You can do that by going to /android/app/src/main/kotlin/YOUR-PACKAGE-NAME/ and create a new kotlin class. Call it `SplashView` then ensure it looks like the following;

```Kotlin
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import io.flutter.embedding.android.SplashScreen

class SplashView : SplashScreen {
    override fun createSplashView(context: Context, savedInstanceState: Bundle?): View? =
            LayoutInflater.from(context).inflate(R.layout.splash_view, null, false)

    override fun transitionToFlutter(onTransitionComplete: Runnable) {
        onTransitionComplete.run()
    }
}
```

As you can see, this view is inflatting `splash_view` layout. The final step is to let `MainActivity` know about our custom splash view.

5. Go to /android/app/src/main/kotlin/YOUR-PACKAGE-NAME/ and click on `MainActivity.kt` . FlutterActivity provides a method called `provideSplashScreen` and we just need to implement it as follows;

```Kotlin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.SplashScreen

class MainActivity: FlutterActivity() {

    override fun provideSplashScreen(): SplashScreen? = SplashView()
}
```

The project directory should look like this now;

![Android project directory](https://cdn-images-1.medium.com/max/2000/1*kj2sZaD-YWBgNaEXYAwqbg.png)

That’s all for Android. Just run the app and you should see the animated screen at app launch.

![Animated Splash screen — Android](https://cdn-images-1.medium.com/max/2000/1*EDVg6zpUrwJ39ppvlN7nTA.gif)

## iOS

Let’s add the splash screen in iOS now.

1. Open the project with xcode by navigating to the directory where your project is located, click on ios folder and double click on `Runner.xcworkspace` .
2. Click on `Main.storyboard` , you will see the layout editor with one screen visible. We need to add a new ViewController which will be our Splash screen. You can do that by clicking on the `+` sign at the top right, a popup will appear, search for View Controller and drag it to the editor as the following screenshot shows;

![Add a new view controller](https://cdn-images-1.medium.com/max/7108/1*L9EKQQFnxtozE_xgcpVkfw.png)

3. When step 2 is done, you will see 2 screens. Choose the new view controller and click on `attributes inspector` then check `is initial view controller` .

![Set splash view controller as initial view controller](https://cdn-images-1.medium.com/max/3826/1*TzWohD3MyARxjm7Vetmzow.png)

4. We need to add Lottie dependency to /ios/podFile;

```
pod 'lottie-ios'
```

So the file will look like this;

```
#platform :ios, '9.0' 

target 'Runner' do  
   use_frameworks!  
  
   pod 'lottie-ios' 

end
```

Then run; (Ensure you are in ios directory, if not, run `cd ios` from the root of your flutter project)

```
pod install
```

5. Drag and drop the .json file under /ios/Runner/ (select the **Copy** items **if needed** option), whether you created your own or downloaded a free sample from the link above. In this tutorial, it’s named `splash_screen.json` .

6. With the dependency and the splash_screen.json file already added, we can create our splash view controller that will handle showing the animation and then navigating to Flutter’s application. In /ios/Runner/, create a new swift file, call it `SplashViewController` . Before writing anything in the class, we should modify `AppDelegate.swift` to create a FlutterEngine. If we skip this step, we will not be able to navigate to FlutterViewController after the animated splash screen completes its animation.

```Swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    lazy var flutterEngine = FlutterEngine(name: "MyApp")
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Runs the default Dart entrypoint with a default Flutter route.
        flutterEngine.run()
        // Used to connect plugins (only if you have plugins with iOS platform code).
        GeneratedPluginRegistrant.register(with: self.flutterEngine)

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

So we created a FlutterEngine called MyApp (You can choose any name you want), and in `application` ‘s didFinishLaunchingWithOptions, we should run the engine and register the plugins with the engine. Note that the default code isGeneratePluginRegistrant.register(with: self) . Ensure that it is registered with `self.flutterEngine` instead.

7. With that done, now we can prepare `SplashViewController` to show the animation and then navigates to Flutter’s View Controller.

```Swift
import UIKit
import Lottie

public class SplashViewController: UIViewController {
    
    private var animationView: AnimationView?
    
    public override func viewDidAppear(_ animated: Bool) {
        animationView = .init(name: "splash_screen")
        animationView!.frame = view.bounds
        animationView!.contentMode = .scaleAspectFit
        animationView!.loopMode = .playOnce
        animationView!.animationSpeed = 1.00
        view.addSubview(animationView!)
        animationView!.play{ (finished) in
            self.startFlutterApp()
        }
    }
    
    func startFlutterApp() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let flutterEngine = appDelegate.flutterEngine
        let flutterViewController =
            FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        
        flutterViewController.modalPresentationStyle = .custom
        flutterViewController.modalTransitionStyle = .crossDissolve
        
        present(flutterViewController, animated: true, completion: nil)
        
    }
}
```

In `viewDidAppear` we initialise the animation view with the added `splash_screen.json` file. You can play around the settings such as loopMode, animationSpeed, etc. When the animation is done, we start the flutter app.

In order to get `FlutterViewController` , we MUST get an instance of the FlutterEngine we created and ran at AppDelegate.swift.

```
let appDelegate = UIApplication.shared.delegate as! AppDelegate        let flutterEngine = appDelegate.flutterEngine
        
let flutterViewController = FlutterViewController(engine:    flutterEngine, nibName: nil, bundle: nil)
```

Then `present(completion:)` is used to start the view controller.

8. It’s time now to link the ViewController created at step 2 with the `SplashViewController` class. That can be done by clicking on Main.storyboard and selecting the new ViewController, then from `identity inspector` choose `SplashViewController` as the screenshot shows;

![Link with SplashViewController](https://cdn-images-1.medium.com/max/7152/1*ghXXOoQqELmNTc4wrbxoJQ.png)

9. The final step is to set the main interface for Main.storyboard instead of `LauncherScreen.storyboard` . To achieve that, click on Runner, select `General` tab, under `deployment info` , set `Main interface` to **Main** from the dropdown menu as the screenshot shows;

![Set main interface to MAIN](https://cdn-images-1.medium.com/max/3274/1*KQV8lIB3aRfA_AHtTNXi4g.png)

Build and run the app, you should be able to see the animated splash screen.

![](https://cdn-images-1.medium.com/max/2000/1*bdfeeBtOIHW_1A0MfdjnZQ.gif)

That’s all, you have animated splash screens now for both Android and iOS apps. For the full source code and the demo app:

[**AbedElazizShe/flutter_lottie_splash_app**](https://github.com/AbedElazizShe/flutter_lottie_splash_app)

Please leave a comment if you have any question or if there is a better way to achieve that.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
