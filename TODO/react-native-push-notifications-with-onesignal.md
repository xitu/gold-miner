> * 原文地址：[React Native Push Notifications with OneSignal](https://medium.com/differential/react-native-push-notifications-with-onesignal-9db6a7d75e1e#.ji9dbcxv7)
* 原文作者：[Spencer Carli](https://medium.com/@spencer_carli)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# React Native Push Notifications with OneSignal
# React Native 使用OneSignal 进行推送












I had initially planned to make a comprehensive multi-part video series on setting up remote push notifications but, unfortunately, I underestimated the time it would take for me to recover from getting my wisdom teeth removed.
我开始的时候打算做一系列全方位的关于如何设置远程推送视频，但是，不幸的是。我低估了自己从拔智齿到恢复所需要的时间。


But that’s no excuse. Here’s a tutorial on how to set up push notifications in React Native (both iOS and Android) with [OneSignal](https://onesignal.com/), a service that provides free push notification delivery for multiple platforms. This is a pretty long tutorial but it’s worth it. Even if you don’t use OneSignal, much of this will apply to you (general configuration). Let’s get to it.
但是，这并不是什么借口。这是一系列的关于如何在ReactNative上通过使用[OneSignal](https://onesignal.com/)设置推送的教程。[OneSignal](https://onesignal.com/)一个提供跨平台的推送交付服务的服务商。这是一篇非常长的但是值得阅读的教程。即使你不使用OneSinagal。大部分的内容也是适用于你的(基础的配置)。让我们开始吧。

#### Create React Native App
#### 创建 React Native App
First thing you’ll need is a React Native app. Maybe that’s your existing app or maybe it’s a new one. We’ll start with a new one. From the command line:
首先你需要一个React Native app 也须是已经存在的工程也许是一个新的项目。我们这里将使用一个新的项目。从下面的命令开始：


    react-native init OneSignalExample


    react-native init OneSignalExample

 	

_Something to note going forward:_ push notifications only work on a real device, they won’t work on a simulator. I use an unlocked [refurbished Nexus 5](https://www.amazon.com/gp/product/B017RMREL6/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B017RMREL6&linkCode=as2&tag=handlebarlabs-20&linkId=4b8388a4f02af44c275fab434156cf7e) and an [iPhone 6](https://www.amazon.com/gp/product/B00YD547Q6/ref=as_li_tl?ie=UTF8&tag=handlebarlabs-20&camp=1789&creative=9325&linkCode=as2&creativeASIN=B00YD547Q6&linkId=5b16710a735bff80c55cc47dbdb4e38b) for testing.

再继续走下去之前需要提到的是：推送只能在真机上使用，在模拟器上是无法工作的。我使用了一台未解锁的[refurbished Nexus 5](https://www.amazon.com/gp/product/B017RMREL6/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B017RMREL6&linkCode=as2&tag=handlebarlabs-20&linkId=4b8388a4f02af44c275fab434156cf7e)还有一部[iPhone 6](https://www.amazon.com/gp/product/B00YD547Q6/ref=as_li_tl?ie=UTF8&tag=handlebarlabs-20&camp=1789&creative=9325&linkCode=as2&creativeASIN=B00YD547Q6&linkId=5b16710a735bff80c55cc47dbdb4e38b)用来测试


You can access instructions for running on your device at the following links.
在下面的两个链接中 你可以获取到在你的设备上运行的指令。


*   [Instructions for iOS](https://facebook.github.io/react-native/docs/running-on-device-ios.html#accessing-the-development-server-from-device)
*   [关于iOS的介绍](https://facebook.github.io/react-native/docs/running-on-device-ios.html#accessing-the-development-server-from-device)
*   [Instructions for Android](https://facebook.github.io/react-native/docs/running-on-device-android.html)
*   [关于安卓的介绍](https://facebook.github.io/react-native/docs/running-on-device-android.html)

#### Create OneSignal Account & Create App

#### 创建OneSignal帐号&创建App

Next you’ll want to head over to [OneSignal](https://onesignal.com/) and sign up for an account. At that point you’ll be prompted to set up your app.

下面你肯定想前往[OneSignal](https://onesignal.com/)注册一个账号，在这个阶段你将按照提示设置你的app。





![](https://cdn-images-1.medium.com/max/1600/1*ryHYP7U61oq4FLQLUlIP3Q.png)



Now we’ll be asked to configure a platform. This is going to be the most complex part. I’m going to start off with iOS and configure Android later — details on how to do that outlined below.

现在，在你需要签署一个协议。下面将会是最复杂的部分。我将从如何去处理iOS开始，然后会介绍一下安卓。





![](https://cdn-images-1.medium.com/max/1600/1*dwqHBst3MqHQdxLhnctB5Q.png)



#### Generate iOS Push Certificate
#### 创建iOS 推送证书

So you’re probably sitting at a screen that looks a lot like this…

这么 你大概应该在屏幕上看到这样的东西...






![](https://cdn-images-1.medium.com/max/1600/1*LISUO4JrSeF5nIG0-0Ng-Q.png)



You may be wanting to jump right into creating your .p12 file (we’ll cover that in a moment) but we’ve got to actually [create our app within the Apple Developer portal](https://developer.apple.com/account/ios/identifier/bundle).
你可能想直接点击save去创建你的.p12文件(我们会简单的一笔略过)但是我们实际上[在苹果开发者中心创建了我们自己的app](https://developer.apple.com/account/ios/identifier/bundle)。


Now if you’ve never done this before it’s important to note that you’ll need to set an Explicit App ID for push notifications to work.
如果你从没有做过上面的事情的话。需要注意的是你需要设置一个不冲突的App ID才能使推送正常工作。






![](https://cdn-images-1.medium.com/max/1600/1*2_XW-DWIQ6opwobXUqd6AQ.png)



You’re also going to want to enable push notifications for this app.
允许你的app 使用推送。






![](https://cdn-images-1.medium.com/max/1600/1*Tx8psBSrgTk42YDNU3MUMA.png)



Now that we’re done with that we can move over to actually creating the provisioning profile. OneSignal has a tool called [_The Provisionator_](https://onesignal.com/provisionator) that will help with this process.
现在 我们可以创建证书了。OneSignal 有一个叫做[_The Provisionator_](https://onesignal.com/provisionator)的工具可以帮助我们处理。


> If you’re uncomfortable using giving this tool access to your Apple account you can [create the profile manually.](https://documentation.onesignal.com/docs/generate-an-ios-push-certificate#section-option-b-create-certificate-request-manually)
> 如果你对这个工具获取到你的App账号的使用权感到不安。你可以[手动的创建证书。](https://documentation.onesignal.com/docs/generate-an-ios-push-certificate#section-option-b-create-certificate-request-manually)

_Protip: If you’ve got two-factor authentication turned on for your account you’ll need to turn it off in order to use_ [_The Provisionator_](https://onesignal.com/provisionator)_. Feel free to change your password before/after using it — that’s what I did to aid in keeping my account secure._
高级技巧：如果你的账号开启了二次身份验证。为了使用[_The Provisionator_](https://onesignal.com/provisionator)_。你需要关闭它。为了保持账号的安全我通常会在使用前和使用后去更改密码。所以放轻松的使用它。

Okay, now that we’re past those notes let’s actually use this tool and get our profile.
现在让我们使用这个工具获取到我们的证书。

You’ll want to sign into your account and make sure you choose the proper team.
登陆你的账号确保选择正确的team。






![](https://cdn-images-1.medium.com/max/1600/1*P-xYHCA3bMlTZLzkPU_dww.png)



Upon pressing “Next”, and waiting a few seconds, you’ll see something like this

点击“next”，等待一会，你会看到下面的样子。





![](https://cdn-images-1.medium.com/max/1600/1*H8s98ARR75NDEyIQ3SYaJg.png)



Go ahead and download those files and remember the password for the p12 file. Then we can head back to OneSignal and upload our file…

继续下去，把这些文件下载下来。记住你的p12的密码。现在 我们可以回到 OneSignal。上传我们的文件。





![](https://cdn-images-1.medium.com/max/1600/1*wXNjx9oZB5JTO7_Y4YZdjA.png)



And that’s it, for now! We’ll just close out this modal and come back to the React Native side of things in a moment. Now let’s configure Android (it’s easier, I promise).
这就是如何设置iOS，现在这边的事情可以告一段落。让我们来到另一边。我们来设置安卓(这是我早些时候承诺过的)。

#### Generate Google Server API Key
#### 生成 Google Server API Key
To set up OneSignal with Google we need to go to our App Settings (within OneSignal) and click “Configure” for Android.
如果要是使用Google设置OnesSiganl，我们需要来到OneSignal里面的App设置界面，然后点击设置。
![](https://cdn-images-1.medium.com/max/1600/1*wRzI1Z49dEjr8zD0Z1FKvA.png)

We then see that we’ll need a Google Server API Key and a Google Project Number. Let’s get both of those…
现在可以看到 我们需要一个Google Server API Key 和一个 Google Project Number。






![](https://cdn-images-1.medium.com/max/1600/1*57f7XJz6dPW0la6DiHNy3Q.png)



You’ll need to go to the [Google Services Wizard](https://developers.google.com/mobile/add?platform=android&cntapi=gcm) to do this — the names aren’t important. Just choose things that make sense OR if you’re setting this up with an existing app, make sure you choose the right app.

你需要前往[谷歌服务中心](https://developers.google.com/mobile/add?platform=android&cntapi=gcm)去做下面的事情。名字不重要，只讲得通的就可以。如果你为已有的app进行设置的话，请确保你选择正确的app。





![](https://cdn-images-1.medium.com/max/1600/1*nY1t8G4tXgN8EYAmQ_TzoA.png)



I like to keep things consistent between iOS and Android
我喜欢让iOS 和 Android 保持一致

Then enable Cloud Messaging
然后允许云推送






![](https://cdn-images-1.medium.com/max/1600/1*_oC5p_mTw3-4VplRMpvdKg.png)



Once enabled you’ll have access to your API key and your project ID (called Sender ID). Bring these over to OneSignal.

一旦允许之后，你就可以获取到你的API 和你的项目ID(也叫Sender ID),把这些填在OneSiganl上。




![](https://cdn-images-1.medium.com/max/1600/1*J_VTqlOM6KCrJYgo6iaGvA.png)



Woohoo! Platforms are set up. Now we can actually work on integrating this with our app.
哈哈！ OneSinal上已经设置好了。我们现在把这些东西集成在app里面了。

#### Install _react-native-onesignal_
#### 安装 _react-native-onesignal_


OneSignal has a package on npm, [react-native-onesignal](https://github.com/geektimecoil/react-native-onesignal#installation), that makes integrating with your platform super easy. It’s not the easiest to install but once it’s done you don’t have to do it again :) I’m hoping in the future that they integrate with rnpm/_react-native link_ so that we can minimize diving into native code but until then we must. For now, from your project root, run the following to install the package.
OneSignal 在npm上有一个包，[react-native-onesignal](https://github.com/geektimecoil/react-native-onesignal#installation)，可以让你在项目的集成变的非常容易。并不需要在一开始的时候就导入包。但是一旦包导入了。你就不需要再做第二遍了。我希望未来的一天它可以与rnpm/_react-native集成在一起。这样我可以写很少的本地化代码了。但是在此之前 我们必须一步一步的配置。现在 在你的根目录下面运行下面的代码安装包文件。




    npm install react-native-onesignal --save

Into the Objective-C/Java!
进入到 Objective-C/Java！
#### Configure iOS
#### 配置 iOS

Before I dive in here I want to say that this is basically just me rehashing the [official instructions](https://github.com/geektimecoil/react-native-onesignal#ios-installation) so if you run into issues be sure to check those out as well. With that, let’s jump into our app and start configuring things
在我深入之前，我想说，这些基本上是我重新组织了一下[官方文档](https://github.com/geektimecoil/react-native-onesignal#ios-installation)，所以如果你遇到问题。请去官方文档看一下。让我们开始配置我们的app。

First thing we have to do is install the OneSignal iOS SDK — which is available via [CocoaPods](http://guides.cocoapods.org/using/getting-started.html). You’ll want to make sure you’ve got at least version _1.1.0_. You can check that by running
首先你应该安装 OneSiganl的iOS SDK，可以通过[CocoaPods](http://guides.cocoapods.org/using/getting-started.html)进行安装。你应该确保你的cocopods为最新版本。可以通过下面的命令进行检查。

    pod --version

If it’s outdated you can update with
如果不是最新版本，你可以通过下面的命令进行升级。

    sudo gem install cocoapods --pre

Now, from within your React Native project, you’ll want to to move to your _ios/_ directory and initialize a PodFile.
现在，在你的React Native项目中，进入到iOS目录下面。初始化一个PodFile文件。

    cd ios/ && pod init

You then want to add the OneSignal pod to the file. It should look something like this
你应该添加OneSiganl的源在文件中。看起来应该像这样。

    # Uncomment the next line to define a global platform for your project
    # platform :ios, '9.0'

    target 'OneSignalExample' do
      # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
      # use_frameworks!

      # Pods for OneSignalExample
      pod 'OneSignal', '~> 1.13.3'

    end



I removed the tests since I don’t need them and they were causing an error.
我移除了测试目录。我不需要他们并且他们产生了一个错误。

Now, back at the command line and still in the _ios/_ directory, run
现在。回到命令行并在_ios/_ directory目录底下运行下面的命令。

    pod install

Since we’re using CocoaPods a _.xcworkspace_ file will be generated. You’ll want to run the app using that from now on.
在我们使用CocoaPods后，_.xcworkspace_文件会被生成。从此以后你应该使用这个文件运行你的app。

> Protip: To make sure you always do that add an npm script to your app and use that to open the ios project. [Like this one](https://gist.github.com/spencercarli/7cc7ec369fd4d8778021a6d92cea05dd).
> 高级技巧: 确保添加一个npm 脚本在你的app里面，用它打开你的iOS工程文件. [像这样](https://gist.github.com/spencercarli/7cc7ec369fd4d8778021a6d92cea05dd).

Now let’s configure our capabilities within Xcode
现在让我们在Xcode里面设置我们的功能






![](https://cdn-images-1.medium.com/max/1600/1*WXAWsJBNClxskPcnDLOlXw.png)



Next we need to add the RCTOneSignal.xcodeproj to our Libraries folder. That can be found in _/node_modules/react-native-onesignal/ios._
下面我们需要添加RCTOneSignal.xcodeproj在我们的工程里面。可以在_/node_modules/react-native-onesignal/ios._这个目录下面找到。






![](https://cdn-images-1.medium.com/max/1600/1*PRAjGOX1DgWJnFyxeKNFTw.png)







![](https://cdn-images-1.medium.com/max/1600/1*tFjVSuDQTCOohUGBapjRnw.png)



Make sure “Copy items if needed” is NOT checked.
确保“Copy items if needed”没有被选中。

Now we have to add _libRCTOneSignal.a_ to Link Binary with Libraries, which can be found under the Build Phases tab. Just drag it from the left to that section.
现在我们需要添加_libRCTOneSignal.a_在库中，可以在Build Phases tab下面找到。只是把它从左边拖到目录中就可以了。






![](https://cdn-images-1.medium.com/max/1600/1*FYUp6hU5exQmSGvichRzSQ.png)







![](https://cdn-images-1.medium.com/max/1600/1*c7TioyoM1Lx-YPiVbKzpQA.gif)





Okay, jump over to the Build Settings tab and search for “Header Search Paths”, double click the value, then click the “+” sign. Then add _$(SRCROOT)/../node_modules/react-native-onesignal_ and set it to “recursive”.

好的。跳转到 Build Settings 搜索“Header Search Paths”，双击value，然后点击“+” ，添加_$(SRCROOT)/../node_modules/react-native-onesignal_然后设置为“recursive”。





![](https://cdn-images-1.medium.com/max/1600/1*QKeUfjrXUVSBoRLSrjBSmQ.png)



Now to our app! We’ll need to make some changes to _ios/APP_NAME/AppDelegate.m._
现在我们需要在_ios/APP_NAME/AppDelegate.m._写一些代码。

First _#import “RCTOneSignal.h”._ Then we need to synthesize oneSignal.
首先你需要_#import “RCTOneSignal.h”._ 然后你需要synthesize oneSignal。


    import "AppDelegate.h"

    #import "RCTBundleURLProvider.h"
    #import "RCTRootView.h"
    #import "RCTOneSignal.h"

    @implementation AppDelegate
    @synthesize oneSignal = _oneSignal;

    // ...






Still in your AppDelegate.m you need to setup oneSignal, that’s the first section of code I added below. Make sure to swap “YOUR_ONESIGNAL_APP_ID” with the right ID. The last part is so that you can receive notifications.
还是在AppDelegate.m里面 你需要配置oneSiganl。这是我在下面添加的第一行代码。确保你在“YOUR_ONESIGNAL_APP_ID” 填写了正确的ID。这样我们就可以接收到推送了。

    // ...

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
      NSURL *jsCodeLocation;

      self.oneSignal = [[RCTOneSignal alloc] initWithLaunchOptions:launchOptions
                                                           appId:@"YOUR_ONESIGNAL_APP_ID"];

      // ...
    }

    // Required for the notification event.
    - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification {
        [RCTOneSignal didReceiveRemoteNotification:notification];
    }



[Here is the full file in case you want to check against it.](https://gist.github.com/spencercarli/ec6f1a64b499b8ccef312c8838a33c95)

You can find your OneSignal App ID via App Settings > Keys & IDs
您可以通过应用设置>密钥&ID找到您的OneSignal应用ID






![](https://cdn-images-1.medium.com/max/1600/1*yNJH2BmKboc9XwauvFcx9Q.png)



Jump over to AppDelegate.h and add _#import _and _@property (strong, nonatomic) RCTOneSignal* oneSignal;_
跳转到AppDelegate.h并添加_＃import _和 _ @ property（strong，nonatomic）RCTOneSignal * oneSignal; _

    /**
     * Copyright (c) 2015-present, Facebook, Inc.
     * All rights reserved.
     *
     * This source code is licensed under the BSD-style license found in the
     * LICENSE file in the root directory of this source tree. An additional grant
     * of patent rights can be found in the PATENTS file in the same directory.
     */

    #import 
    #import  /* <--- Add this */

    @interface AppDelegate : UIResponder 

    @property (nonatomic, strong) UIWindow *window;
    @property (strong, nonatomic) RCTOneSignal* oneSignal; /* <--- Add this */

    @end

Now we’ll want to try and get this to run. You might have to do a few more things here.
现在我们想尝试让它运行。 你可能需要检查确认检查一些配置。
Make sure to set your Bundle Identifier to the one you set up when you made the app.
确保将您的BundleID设置为您在设置应用时使用的BundleID。





![](https://cdn-images-1.medium.com/max/1600/1*E3L9e7SmfYnyqn-DcbfAaQ.png)



Then we need to make sure we [create a provisioning profile](https://developer.apple.com/account/ios/profile/) that will work with the push certificate we set up earlier. You’ll likely need to create an AdHoc one if you’ve been following these instructions exactly.


然后，我们需要确保我们[创建的描述文件]（https://developer.apple.com/account/ios/profile/），它将与我们之前设置的推送证书配合使用。 如果你已遵循这些说明，则可能需要创建AdHoc。





![](https://cdn-images-1.medium.com/max/1600/1*Z3DgmL_MOxCEqO_wTi78uw.png)



Then choose the correct app.
然后选择正确的app。






![](https://cdn-images-1.medium.com/max/1600/1*PdLBQ5nsXzUw8bPzXr-3Tw.png)



Then choose your certificate and the devices that should be included for the AdHoc distribution. If you need to add devices [you can do so on the Apple dev portal](https://developer.apple.com/account/ios/device/). Need to find out your UDID? [Use this resource](http://whatsmyudid.com/).
然后选择你的证书和应包括在AdHoc分发中的设备。 如果你需要添加设备[Apple开发者网站上面的介绍]（https://developer.apple.com/account/ios/device/）。 需要找出你的UDID？ [找到我的UDID]（http://whatsmyudid.com/）。

Then create your profile and download it. Once it’s downloaded. Double click it so that it’s installed.

然后创建你的证实并且下载下来。当下载完成之后，双击安装证书。





![](https://cdn-images-1.medium.com/max/1600/1*CsHNUIgk5gWrws1x2kNegA.png)



Then in Xcode you’ll want to choose that profile in the Provisioning Profile section.
然后再证书选择的地方选择你刚刚创建的证书。






![](https://cdn-images-1.medium.com/max/1600/1*zbWgZF_kgg8TUfL9Tsir2g.png)



Okay… now… try to compile it. Cross your fingers. If it worked, congrats!

好的，现在 尝试编译一下。祈祷吧。如果能正常工作。那么恭喜你！





![](https://cdn-images-1.medium.com/max/1600/1*3e1SZvE7qPIcPz-OSusWtg.gif)



If not make sure you followed all the steps above. Now for Android.
如果你做完了上面的事情，那么现在我们来讲讲如何设置安卓。

#### [Configure Android](https://github.com/geektimecoil/react-native-onesignal#android-installation)
#### [配置 Android](https://github.com/geektimecoil/react-native-onesignal#android-installation)

Now to set up Android! Before we get started I need to note that these instructions assume >= v0.29 of React Native. If you’re still on an earlier version [follow these instructions](https://github.com/geektimecoil/react-native-onesignal#rn--029). With that, let’s begin… (it’s easier than iOS)
现在设置Android！ 在我们开始之前，我需要提醒大家，这些指令假设React Native的版本> = v0.29。 如果您仍然是早期版本[请按照这里去做]（https://github.com/geektimecoil/react-native-onesignal#rn--029）。 好的，让我们开始...（它比iOS容易）

First we need to add some necessary permissions to AndroidManifest.xml, which can be found at _android/app/src/main/AndroidManifest.xml._
首先，我们需要为AndroidManifest.xml添加一些必要的权限，可以在_android / app / src / main / AndroidManifest.xml._


    

        ...
         

        

        <application
          ...
          android:launchMode="singleTop" 
        >
          ...
        

    

[Access the full file.](https://gist.github.com/spencercarli/b5e40be6d2e843d843c633def1ffacf2)
[获取完整的文件](https://gist.github.com/spencercarli/b5e40be6d2e843d843c633def1ffacf2)


Now we bounce over to _gradle-wrapper.properties_, accessible at _android/gradle/wrapper/gradle-wrapper.properties_ to change our _distributionUrl_. It should end up looking like this (we need gradle 2.10)
现在我们跳过_gradle-wrapper.properties_，在_android / gradle / wrapper / gradle-wrapper.properties_以改变我们的_distributionUrl_。 它应该最终看起来像这样（我们需要gradle 2.10）


    distributionBase=GRADLE_USER_HOME
    distributionPath=wrapper/dists
    zipStoreBase=GRADLE_USER_HOME
    zipStorePath=wrapper/dists
    distributionUrl=https://services.gradle.org/distributions/gradle-2.10-all.zip

Now we tell the Android app about the OneSignal package in _settings.gradle_(_android/settings.gradle)._
现在我们告诉Android应用程序关于OneSignal包在_settings.gradle _（_ android / settings.gradle）._


    nclude ':react-native-onesignal'
    project(':react-native-onesignal').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-onesignal/android')

We also want to update the gradle version we’re using in _android/build.gradle — _check out line 8.
我们还想更新在_android / build.gradle - _check第8行中使用的gradle版本。

    // Top-level build file where you can add configuration options common to all sub-projects/modules.

    buildscript {
        repositories {
            jcenter()
        }
        dependencies {
            classpath 'com.android.tools.build:gradle:2.1.0' // HEY LOOK HERE!

            // NOTE: Do not place your application dependencies here; they belong
            // in the individual module build.gradle files
        }
    }

    allprojects {
        repositories {
            mavenLocal()
            jcenter()
            maven {
                // All of React Native (JS, Obj-C sources, Android binaries) is installed from npm
                url "$rootDir/../node_modules/react-native/android"
            }
        }
    }

Note the file that we’re updating now, it’s NOT the same one we just did. We need to tell OneSignal about our app information. Make sure to use your own values for this. In _android/app/build.gradle_ upgrade _buildToolsVersion_ to _23.0.2_., add our keys (see code snippet), and add the package as a dependency of our Android app.
注意我们现在更新的文件，它不是我们刚刚做的。 我们需要告诉OneSignal我们的应用信息。 请务必使用自己的值。 在_android / app / build.gradle_ upgrade _buildToolsVersion_到_23.0.2_中，添加我们的Key（请参阅代码片段），并将该包作为Android应用程序的依赖项添加。

    android {
        ...
        buildToolsVersion "23.0.2" // UPGRADE
        ...
        defaultConfig {
            ...
            manifestPlaceholders = [manifestApplicationId: "${applicationId}",
                                    onesignal_app_id: "YOUR_ONESIGNAL_ID",
                                    onesignal_google_project_number: "YOUR_GOOGLE_PROJECT_NUMBER"]
        }
    }

    dependencies {
        ...
        compile project(':react-native-onesignal')
    }

Remember, you want to change _YOUR_ONESIGNAL_ID_ (same one used for iOS) and _YOUR_GOOGLE_PROJECT_NUMBER_ (this is the one you generated and added to the OneSignal dashboard earlier)_._
请记住，您想要更改_YOUR_ONESIGNAL_ID_（用于iOS的相同）和_YOUR_GOOGLE_PROJECT_NUMBER_（这是您先前生成并添加到OneSignal里面的那个）_._

[The full file is available also if you want to reference it](https://gist.github.com/spencercarli/b8e61d29fe1c1ab1798a3b7861177db5). The changes made occur at line 87, line 98, and line 135.

[下面是完整的文件如果你想要参考的话](https://gist.github.com/spencercarli/b8e61d29fe1c1ab1798a3b7861177db5). The changes made occur at line 87, line 98, and line 135.
Just about there! Last thing we need to do is modify _MainApplication.java_(_android/app/src/main/java/com/YOUR_APP_NAME/MainApplication.java_). Line 15 and 29 are the ones you’ll be interested in.
差不多就这样了！最后我们需要做的事更改_MainApplication.java_(_android/app/src/main/java/com/YOUR_APP_NAME/MainApplication.java_)。在第15行和29行。是你所需要关心的。


    package com.onesignalexample;

    import android.app.Application;
    import android.util.Log;

    import com.facebook.react.ReactApplication;
    import com.facebook.react.ReactInstanceManager;
    import com.facebook.react.ReactNativeHost;
    import com.facebook.react.ReactPackage;
    import com.facebook.react.shell.MainReactPackage;

    import java.util.Arrays;
    import java.util.List;

    import com.geektime.reactnativeonesignal.ReactNativeOneSignalPackage;  // ADD THIS

    public class MainApplication extends Application implements ReactApplication {

      private final ReactNativeHost mReactNativeHost = new ReactNativeHost(this) {
        @Override
        protected boolean getUseDeveloperSupport() {
          return BuildConfig.DEBUG;
        }

        @Override
        protected List getPackages() {
          return Arrays.asList(
              new MainReactPackage(),
              new ReactNativeOneSignalPackage() // Add this line, and don't forget the comma on the previous line
          );
        }
      };

      @Override
      public ReactNativeHost getReactNativeHost() {
          return mReactNativeHost;
      }
    }

Hey that was pretty smooth, wasn’t it? Go ahead and make sure your app compiles, I’ll wait.
这很顺利，不是么？我会等你编译你的程序。






![](https://cdn-images-1.medium.com/max/1600/1*3ld_cBA83pnFiwIdvmuq7w.gif)



Good? Good, great. Let’s use these fancy remote notifications now.
非常棒。让我们来使用神奇的远程推送吧。

#### Android Usage & iOS Usage
#### Android 用法 & iOS 用法

First thing we want to do is create a new _App.js_ file in the root of our project — this way we can write the same code for both iOS and Android. Go ahead and copy and paste the following.
首先我们需要创建一个新的 _App.js_在我们项目的根目录中—这样我们可以写相同的代码可以跑在iOS和Android上。复制粘贴下面的代码在你的文件中。

    import React, { Component } from 'react';
    import {
      StyleSheet,
      Text,
      View,
      Platform,
    } from 'react-native';

    class App extends Component {
      render() {
        return (
          
            
              Welcome to the OneSignal Example!
            
            
              Using {Platform.OS}? Cool.
            
          
        );
      }
    }

    const styles = StyleSheet.create({
      container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
      },
      welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
      },
      instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
      },
    });

    export default App;

And then change both _index.ios.js_ and _index.android.js_ to the following (so we use the App file we just made).
然后将_index.ios.js_和_index.android.js_更改为以下（因此我们使用我们刚刚创建的App文件）。


    import { AppRegistry } from 'react-native';
    import App from './App';

    AppRegistry.registerComponent('OneSignalExample', () => App);

Okay, now we can go ahead and actually configure OneSignal to work for us. Ready? It’s just two lines (yeah all that for two lines). First we import the package then we call the configure method.
好吧，现在我们可以继续，真正的配置OneSignal为我们工作。 准备好了么？ 仅仅两行代码（是的，只有两行）。 首先我们导入包，然后我们调用configure方法。

    ...
    import OneSignal from 'react-native-onesignal';

    class App extends Component {
      componentDidMount() {
        OneSignal.configure({});
      }

      ...
    }

    ...

    export default App;

Note that the empty object in configure is required. [Here’s the full file](https://gist.github.com/spencercarli/3f430c7b5d3f3603371e52beb2377866).
必须注意的是空的object是必须的在配置中。 [这里是全部的文件](https://gist.github.com/spencercarli/3f430c7b5d3f3603371e52beb2377866)。

We can then go ahead and refresh or start our app on both iOS and Android. If everything worked as expected you should see something like this on your OneSignal dashboard.
然后，我们可以在iOS和Android上刷新或启动我们的应用程序。 如果一切都按预期工作，你应该在OneSignal的仪表板上看到类似的东西。







![](https://cdn-images-1.medium.com/max/1600/1*5zB7dz--07hxIptHv4oHaw.png)



> Remember, you need a [real](https://www.amazon.com/gp/product/B00YD547Q6/ref=as_li_tl?ie=UTF8&tag=handlebarlabs-20&camp=1789&creative=9325&linkCode=as2&creativeASIN=B00YD547Q6&linkId=5b16710a735bff80c55cc47dbdb4e38b) [device](https://www.amazon.com/gp/product/B017RMREL6/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B017RMREL6&linkCode=as2&tag=handlebarlabs-20&linkId=4b8388a4f02af44c275fab434156cf7e) to test this.

> 记住 你需要一个真实的[iOS](https://www.amazon.com/gp/product/B00YD547Q6/ref=as_li_tl?ie=UTF8&tag=handlebarlabs-20&camp=1789&creative=9325&linkCode=as2&creativeASIN=B00YD547Q6&linkId=5b16710a735bff80c55cc47dbdb4e38b) [Android](https://www.amazon.com/gp/product/B017RMREL6/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B017RMREL6&linkCode=as2&tag=handlebarlabs-20&linkId=4b8388a4f02af44c275fab434156cf7e) 去测试。




Go ahead and lock the device and jump over to OneSignal’s dashboard and send a message.

继续走下去，把机器锁屏，来到OneSiganl的仪表盘发送一条消息。





![](https://cdn-images-1.medium.com/max/1600/1*fz1lQ7HoNCl5LCqrZv4_MA.png)



I won’t go over all the options available to you through OneSignal (right now) but there is quite a lot you can do through the dashboard. You can also interact with the service via their [REST API](https://documentation.onesignal.com/reference) so you can programmatically send notifications. Anyways, if everything worked out correctly you should have gotten notifications on your device!

我不会为你一一介绍OneSiganl上的选项（现在），但是你可以做很多事情通过仪表盘，你还可以通过其[REST API]（https://documentation.onesignal.com/reference）与服务进行交互，以便您可以通过编程方式发送通知。 无论如何，如果一切正常，你应该得到你的设备上的通知！




![](https://cdn-images-1.medium.com/max/1600/1*_ztwFmCwSVYWO_lf1nyMtg.jpeg)



Now that’s pretty basic and you can do a lot more with OneSignal and push notifications in general, some of which I’ll cover below.
现在这是很基本的，你可以通过OneSignal做很多事情，其中一些我将在下面介绍。
#### [iOS] Request notification permission only when needed
#### [iOS] 仅在需要时请求通知权限


One pattern that is encouraged by Apple (I can’t find the docs stating this but they do exist) is to request permission to send push notifications when it’s needed. So, rather than requesting permission as soon as the app boots (the default) you wait until the user takes some action so that they would understand why you’re requesting permission. This builds confidence with your user so let’s set that up.
单例模式是被Apple所鼓励的（我找不到文档的说明，但是确实是存在的）当需要的时候请求推送的权限。所以，与其说在app启动的时候请求权限不如当他们进行一些操作后。这样它们就可以理解你为啥去请求权限。这样的话是建立在用户信任的基础上的，让我们设置一下。



First thing we have to do is disable auto registration, which we’ll do in the _AppDelegate.m_ file. Remember that _self.oneSignal_ from earlier? We’ll be touching that again.
首先我们要做的是禁用自动注册，我们将在_AppDelegate.m_文件中执行。 记的之前写的_self.oneSignal_？ 我们会用它做一些文章。


    self.oneSignal = [[RCTOneSignal alloc] initWithLaunchOptions:launchOptions
                                                           appId:@"YOUR_ONESIGNAL_APP_ID"
                                                           autoRegister:false]; // added this

So once we do that it won’t ask permission — we have to do that manually. OneSignal makes that easy for us. Over in the _App.js_ file we’ll add a button (only on iOS) to request permission. We’re going to use the _registerForPushNotifications_ function to do so. After requesting permission it will do everything necessary to register the device with OneSignal.
所以一旦当我们这样写的话，它就不会自动的去请求权限了。我们需要手动的去请求权限。OneSignal可以让我们非常容易的做这些事情，在_App.js_ 我们会添加一个按钮去请求权限（仅仅在iOS上）。我们将使用_registerForPushNotifications_函数来这样做。 在请求权限后，它会处理好一切的事情。
    render() {
        return (
          
            ...
            {Platform.OS === 'ios' ?
               OneSignal.registerForPushNotifications()}
                style={{ padding: 20, backgroundColor: '#3B5998' }}
              >
                Request Push Notification Permission
              
            : null}
          
        );
      }

[Full file.](https://gist.github.com/spencercarli/2541f85684282a3827ec4740db96533e)
[完整的文件](https://gist.github.com/spencercarli/2541f85684282a3827ec4740db96533e)


If you previously ran the app on your phone you may have to delete it and reinstall so that you’re prompted to enable notifications again.

如果你之前在你的手机上运行过app，你需要把他删除并且重新装一下，这样你就可以让请求推送的提示再次出现了。





![](https://cdn-images-1.medium.com/max/1600/1*S6z4KXAe3W1TD1clPjnTWg.gif)



#### In App Notification
#### App 内的推送


So let’s say your user gets a notification while they’re in the app and you want to show them that. With OneSignal you can easily show that to them by setting
因此，假设你希望在用户使用app的过程中收到通知，并且希望向他们展示。 使用OneSignal，您可以通过设置轻松地向他们显示


    OneSignal.enableInAppAlertNotification(true);

in your App.js file. This will show a modal with your notification in it while the user is in your app. Simple and useful, right? I thought so.
在你的App.js文件。 当用户在你的应用中时，将会显示你的通知。 简单有用，对吧？ 我是这么想的。






* * *




I think that’s all for me today. This was a monster to write. Want to see more on Push Notifications via OneSignal? Let me know by r**esponding to and recommending this article.** I would really appreciate it! Feel free to ask questions below — this can be tricky.
这就是我今天介绍的所有东西。这是一个怪物写的，想看到更多的关于适用OneSiganl进行推送的东西么？可以反馈或者推荐这篇文章让我知道。我是非常赏识你这样做的。在下面自由的提问吧－可以提一下比较机智的问题。



[Full source is on GitHub.](https://github.com/spencercarli/react-native-onesignal-example)
[全部的代码在GitHub.](https://github.com/spencercarli/react-native-onesignal-example)



> This post is a part of a larger goal to educate as many people as possible about React Native. Interested in learning more? [Sign up for my email list](http://eepurl.com/bXLcvT) and I promise to deliver a ton of valuable React Native knowledge!

>这个帖子是一个更大的目标的是让更多的人知道React Native。 有兴趣了解更多吗？ [注册我的电子邮件列表]（http://eepurl.com/bXLcvT），我保证提供成吨的React的知识！


Some of the links in the post are affiliate links and I may earn a small commission if you buy something from them.
帖子中的一些链接是推广链接，如果你从他们那里买东西，我可以赚一些佣金。




