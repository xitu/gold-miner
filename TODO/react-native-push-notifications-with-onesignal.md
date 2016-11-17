> * 原文地址：[React Native Push Notifications with OneSignal](https://medium.com/differential/react-native-push-notifications-with-onesignal-9db6a7d75e1e#.ji9dbcxv7)
* 原文作者：[Spencer Carli](https://medium.com/@spencer_carli)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[xiaoheiai4719](https://github.com/xiaoheiai4719)
* 校对者：[Romeo0906](https://github.com/Romeo0906) [XHShirley](https://github.com/XHShirley)

# React Native 使用OneSignal 进行推送












我开始的时候打算做一系列全方位的关于如何设置远程推送视频，但是，不幸的是。我低估了自己从拔智齿到恢复所需要的时间。



但是，这并不是什么借口。这是一系列的关于如何在 ReactNative 上通过使用 [OneSignal](https://onesignal.com/) 设置推送的教程，[OneSignal](https://onesignal.com/) 是一个提供跨平台的服务商。这是一篇非常长的但是值得阅读的教程，即使你不使用 OneSinagal，大部分的内容也是适用于你的(基础的配置)。让我们开始吧。


#### 创建 React Native App

首先你需要一个 React Native app，已经存在的项目或者新的项目都可以。我们这里将使用一个新的项目。从下面的命令开始：


    react-native init OneSignalExample


_我们需要知道这点才能继续做下去_：推送只能在真机上使用，在模拟器上是无法工作的。我使用了一台未解锁的 [refurbished Nexus 5](https://www.amazon.com/gp/product/B017RMREL6/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B017RMREL6&linkCode=as2&tag=handlebarlabs-20&linkId=4b8388a4f02af44c275fab434156cf7e) 还有一部 [iPhone 6](https://www.amazon.com/gp/product/B00YD547Q6/ref=as_li_tl?ie=UTF8&tag=handlebarlabs-20&camp=1789&creative=9325&linkCode=as2&creativeASIN=B00YD547Q6&linkId=5b16710a735bff80c55cc47dbdb4e38b) 用来测试


在下面的两个链接中 你可以获取到关于你的设备的一些指导。


*   [关于iOS的介绍](https://facebook.github.io/react-native/docs/running-on-device-ios.html#accessing-the-development-server-from-device)
*   [关于安卓的介绍](https://facebook.github.io/react-native/docs/running-on-device-android.html)


#### 创建OneSignal帐号&创建App


接下来你要前往 [OneSignal](https://onesignal.com/) 注册一个账号，在这个阶段你将按照提示设置你的 app。





![](https://cdn-images-1.medium.com/max/1600/1*ryHYP7U61oq4FLQLUlIP3Q.png)





现在，在你需要签署一个协议。下面将会是最复杂的部分。我先从 iOS 开始，之后再说 Android。





![](https://cdn-images-1.medium.com/max/1600/1*dwqHBst3MqHQdxLhnctB5Q.png)



#### 创建 iOS 推送证书


你大概应该在屏幕上看到这样的东西...






![](https://cdn-images-1.medium.com/max/1600/1*LISUO4JrSeF5nIG0-0Ng-Q.png)




你可能想直接点击 save 去创建你的 .p12 文件(下面我们马上会讲)但是我们实际上 [在苹果开发者中心创建了我们自己的app](https://developer.apple.com/account/ios/identifier/bundle)。


如果你从没有做过上面的事情的话。需要注意的是你需要设置一个不冲突的 App ID 才能使推送正常工作。






![](https://cdn-images-1.medium.com/max/1600/1*2_XW-DWIQ6opwobXUqd6AQ.png)



你将要赋予这个 app 推送消息的能力




![](https://cdn-images-1.medium.com/max/1600/1*Tx8psBSrgTk42YDNU3MUMA.png)



既然我们已经创建证书了。我们可以继续使用 OneSignal 有一个叫做 [**The Provisionator**](https://onesignal.com/provisionator) 的工具帮助我们处理下面的事情。


> 如果你对这个工具获取到你的App账号的使用权感到不安。你可以 [手动的创建证书。](https://documentation.onesignal.com/docs/generate-an-ios-push-certificate#section-option-b-create-certificate-request-manually) 


**高级技巧：如果你的账号开启了二次身份验证。为了使用 [**The Provisionator**](https://onesignal.com/provisionator)。你需要关闭它。为了保持账号的安全我通常会在使用前和使用后去更改密码。所以尽情的使用它。**

现在让我们使用这个工具获取到我们的证书。

登陆你的账号并确保选择正确的 team。






![](https://cdn-images-1.medium.com/max/1600/1*P-xYHCA3bMlTZLzkPU_dww.png)




点击 “Next”，等待一会，你会看到下面的样子。





![](https://cdn-images-1.medium.com/max/1600/1*H8s98ARR75NDEyIQ3SYaJg.png)




接着把这些文件下载下来。记住你的 p12 的密码。现在我们可以回到 OneSignal 。上传我们的文件。





![](https://cdn-images-1.medium.com/max/1600/1*wXNjx9oZB5JTO7_Y4YZdjA.png)



这就是如何设置 iOS，现在这边的事情可以告一段落。下面让我们开始设置安卓（这比较简单我发誓）。

#### 生成 Google Server API Key

对于Android如果要是使用 Google 设置 OnesSiganl，我们需要来到 OneSignal 里面的 App 设置界面，然后点击设置。
![](https://cdn-images-1.medium.com/max/1600/1*wRzI1Z49dEjr8zD0Z1FKvA.png)


现在可以看到我们需要一个Google Server API Key 和一个 Google Project Number。下面我们开始获取这两个东西。






![](https://cdn-images-1.medium.com/max/1600/1*57f7XJz6dPW0la6DiHNy3Q.png)





你需要前往 [谷歌服务中心](https://developers.google.com/mobile/add?platform=android&cntapi=gcm) 去做下面的事情。名字不重要，只讲得通的就可以。如果你为已有的 app 进行设置的话，请确保你选择正确的 app。





![](https://cdn-images-1.medium.com/max/1600/1*nY1t8G4tXgN8EYAmQ_TzoA.png)



我喜欢让 iOS 和 Android 保持一致。

然后允许云推送






![](https://cdn-images-1.medium.com/max/1600/1*_oC5p_mTw3-4VplRMpvdKg.png)




一旦允许之后，你就可以获取到你的 API 和你的项目 ID(也叫Sender ID),把这些填在 OneSignal 上。




![](https://cdn-images-1.medium.com/max/1600/1*J_VTqlOM6KCrJYgo6iaGvA.png)



哈哈！OneSinal 上已经设置好了。我们现在把这些东西集成在 app 里面了。


#### 安装 _react-native-onesignal_



OneSignal 在 npm 上有一个包，[react-native-onesignal](https://github.com/geektimecoil/react-native-onesignal#installation) ，可以让你在项目的集成变的非常容易。安装这个包是并不容易的，但是一旦你安装了，你就不需要再做第二遍了。我希望未来的一天它可以与 rnpm/react-native 集成在一起。这样我可以写很少的本地化代码了。但是在此之前 我们必须一步一步的配置。现在 在你的根目录下面运行下面的代码安装包文件。




    npm install react-native-onesignal --save


进入到 Objective-C/Java！

#### 配置 iOS


在我深入之前，我想说，这些基本上是我重新组织了一下 [官方文档](https://github.com/geektimecoil/react-native-onesignal#ios-installation) ，所以如果你遇到问题。请去官方文档看一下。让我们开始配置我们的 app。


首先你应该安装 OneSiganl 的 iOS SDK，可以通过 [CocoaPods](http://guides.cocoapods.org/using/getting-started.html) 进行安装。你应该确保你的 cocopods 为最新版本。可以通过下面的命令进行检查。

    pod --version


如果不是最新版本，你可以通过下面的命令进行升级。

    sudo gem install cocoapods --pre

现在，在你的 React Native 项目中，进入到 iOS 目录下面。初始化一个 PodFile 文件。

    cd ios/ && pod init

你应该添加 OneSiganl 的 pod 在文件中。看起来应该像这样。

    # Uncomment the next line to define a global platform for your project
    # platform :ios, '9.0'

    target 'OneSignalExample' do
      # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
      # use_frameworks!

      # Pods for OneSignalExample
      pod 'OneSignal', '~> 1.13.3'

    end



我移除了测试目录。我不需要他们并且他们导致了一个错误。


现在。回到命令行并在 **ios/** directory 目录底下运行下面的命令。

    pod install


在我们使用 CocoaPods 后，**.xcworkspace** 文件会被生成。从此以后你应该使用这个文件运行你的 app。


> 高级技巧: 确保添加一个 npm 脚本在你的 app 里面，用它打开你的 iOS 工程文件. [像这样](https://gist.github.com/spencercarli/7cc7ec369fd4d8778021a6d92cea05dd)。

现在让我们在Xcode里面设置我们的功能






![](https://cdn-images-1.medium.com/max/1600/1*WXAWsJBNClxskPcnDLOlXw.png)



下面我们需要在项目工程中添加 RCTOneSignal.xcodeproj。可以在 **/node_modules/react-native-onesignal/ios** 这个目录下面找到。






![](https://cdn-images-1.medium.com/max/1600/1*PRAjGOX1DgWJnFyxeKNFTw.png)







![](https://cdn-images-1.medium.com/max/1600/1*tFjVSuDQTCOohUGBapjRnw.png)



确保 “Copy items if needed” 没有被选中。


现在我们需要添加 **libRCTOneSignal.a** 在静态库中，可以在 Build Phases tab 下面找到。只是把它从左边拖到目录中就可以了。






![](https://cdn-images-1.medium.com/max/1600/1*FYUp6hU5exQmSGvichRzSQ.png)







![](https://cdn-images-1.medium.com/max/1600/1*c7TioyoM1Lx-YPiVbKzpQA.gif)







好的。跳转到 Build Settings 搜索“Header Search Paths”，双击value，然后点击“+” ，添加 **$(SRCROOT)/../node_modules/react-native-onesignal** 然后设置为 “recursive”。





![](https://cdn-images-1.medium.com/max/1600/1*QKeUfjrXUVSBoRLSrjBSmQ.png)




现在我们需要在 **ios/APP_NAME/AppDelegate.m** 写一些代码。


首先你需要 **#import “RCTOneSignal.h”** 声明 oneSignal。


    import "AppDelegate.h"

    #import "RCTBundleURLProvider.h"
    #import "RCTRootView.h"
    #import "RCTOneSignal.h"

    @implementation AppDelegate
    @synthesize oneSignal = _oneSignal;

    // ...







还是在 AppDelegate.m 里面 你需要配置 oneSignal。这是我在下面添加的第一行代码。确保你在 “YOUR_ONESIGNAL_APP_ID” 填写了正确的 ID。这样我们就可以接收到推送了。

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



[这里是全部的文件。](https://gist.github.com/spencercarli/ec6f1a64b499b8ccef312c8838a33c95)

您可以通过应用设置>密钥& ID 找到您的 OneSignal 应用 ID。






![](https://cdn-images-1.medium.com/max/1600/1*yNJH2BmKboc9XwauvFcx9Q.png)



跳转到 AppDelegate.h 并添加 **＃import ** 和 ** @ property（strong，nonatomic）RCTOneSignal * oneSignal; **

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


现在我们要试着运行。你可能需要做一些处理。

确保将您的BundleID设置为您在设置应用时使用的BundleID。





![](https://cdn-images-1.medium.com/max/1600/1*E3L9e7SmfYnyqn-DcbfAaQ.png)






然后，我们需要确保我们 [创建的描述文件]（https://developer.apple.com/account/ios/profile/），它将与我们之前设置的推送证书配合使用。 如果你已遵循这些说明，则可能需要创建 AdHoc。





![](https://cdn-images-1.medium.com/max/1600/1*Z3DgmL_MOxCEqO_wTi78uw.png)




然后选择正确的 app。






![](https://cdn-images-1.medium.com/max/1600/1*PdLBQ5nsXzUw8bPzXr-3Tw.png)




然后选择你的证书和应包括在 AdHoc 分发中的设备。 如果你需要添加设备 [ Apple 开发者网站上面的介绍]（https://developer.apple.com/account/ios/device/）。 需要找出你的 UDID？ [找到我的 UDID]（http://whatsmyudid.com/）。


然后创建你的证书并且下载下来。当下载完成之后，双击安装证书。





![](https://cdn-images-1.medium.com/max/1600/1*CsHNUIgk5gWrws1x2kNegA.png)




然后选择你刚刚创建的证书。






![](https://cdn-images-1.medium.com/max/1600/1*zbWgZF_kgg8TUfL9Tsir2g.png)




好的，现在尝试编译一下。祈祷吧，如果能正常工作，那么恭喜你！





![](https://cdn-images-1.medium.com/max/1600/1*3e1SZvE7qPIcPz-OSusWtg.gif)



如果你做完了上面的事情，那么现在我们来讲讲如何设置安卓。

#### [配置 Android](https://github.com/geektimecoil/react-native-onesignal#android-installation)


现在设置 Android！在我们开始之前，我需要提醒大家，这些指令假设React Native的版本 > = v0.29。 如果您仍然是早期版本 [请按照这里去做]（https://github.com/geektimecoil/react-native-onesignal#rn--029）。 好的，让我们开始...（它比 iOS 容易）

首先，我们需要为 AndroidManifest.xml 添加一些必要的权限，可以在**android / app / src / main / AndroidManifest.xml.**


    

        ...
         

        

        <application
          ...
          android:launchMode="singleTop" 
        >
          ...
        

    

[获取完整的文件](https://gist.github.com/spencercarli/b5e40be6d2e843d843c633def1ffacf2)

现在我们跳过 **gradle-wrapper.properties**，在 **android / gradle / wrapper / gradle-wrapper.properties** 以改变我们的 **distributionUrl**。 它应该最终看起来像这样（我们需要 gradle 2.10）


    distributionBase=GRADLE_USER_HOME
    distributionPath=wrapper/dists
    zipStoreBase=GRADLE_USER_HOME
    zipStorePath=wrapper/dists
    distributionUrl=https://services.gradle.org/distributions/gradle-2.10-all.zip

现在我们告诉Android应用程序关于 OneSignal包在 **settings.gradle **（** android / settings.gradle）。**


    nclude ':react-native-onesignal'
    project(':react-native-onesignal').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-onesignal/android')

我们还想更新在 **android / build.gradle - ** 第8行中使用的 gradle 版本。

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


注意我们现在更新的文件，它跟我们刚才更新的文件不一样。 我们需要告诉 OneSignal 我们的应用信息。 请务必使用自己的值。在 **android / app / build.gradle** **upgrade _buildToolsVersion** 到 **23.0.2** 中，添加我们的 Key（请参阅代码片段），并将该包作为 Android 应用程序的依赖项添加。

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


请记住，您想要更改 **YOUR_ONESIGNAL_ID** （用于iOS的相同）和 **YOUR_GOOGLE_PROJECT_NUMBER** （这是你先前生成并添加到OneSignal里面的那个）。



[以下是完整文件，仅供参考](https://gist.github.com/spencercarli/b8e61d29fe1c1ab1798a3b7861177db5)。
差不多就这样了！最后我们需要做的事更改_MainApplication.java_(_android/app/src/main/java/com/YOUR_APP_NAME/MainApplication.java_)。你需要注意第 15 行和 29 行。


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

这很顺利，不是么？我会等你编译你的程序。






![](https://cdn-images-1.medium.com/max/1600/1*3ld_cBA83pnFiwIdvmuq7w.gif)



非常棒。让我们来使用神奇的远程推送吧。

#### Android 用法 & iOS 用法

首先我们需要创建一个新的 **App.js** 在我们项目的根目录中—这样我们可以在 iOS 和 Android 上写相同的代码。复制粘贴下面的代码在你的文件中。

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

然后将 **index.ios.js** 和 **index.android.js** 更改为以下（因此我们使用我们刚刚创建的 App 文件）。


    import { AppRegistry } from 'react-native';
    import App from './App';

    AppRegistry.registerComponent('OneSignalExample', () => App);

好吧，现在我们可以继续，真正的配置 OneSignal 为我们工作。准备好了么？仅仅两行代码（是的，只有两行）。首先我们导入包，然后我们调用 configure 方法。

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

必须注意的是空的object是必须的在配置中。 [这里是全部的文件](https://gist.github.com/spencercarli/3f430c7b5d3f3603371e52beb2377866) 。

然后，我们可以在 iOS 和 Android 上刷新或启动我们的应用程序。 如果一切都按预期工作，你应该在 OneSignal 的仪表板上看到类似的东西。







![](https://cdn-images-1.medium.com/max/1600/1*5zB7dz--07hxIptHv4oHaw.png)





> 记住 你需要一个真实的 [iOS](https://www.amazon.com/gp/product/B00YD547Q6/ref=as_li_tl?ie=UTF8&tag=handlebarlabs-20&camp=1789&creative=9325&linkCode=as2&creativeASIN=B00YD547Q6&linkId=5b16710a735bff80c55cc47dbdb4e38b) [Android](https://www.amazon.com/gp/product/B017RMREL6/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B017RMREL6&linkCode=as2&tag=handlebarlabs-20&linkId=4b8388a4f02af44c275fab434156cf7e) 去测试。





继续，把机器锁屏，来到OneSiganl的仪表盘发送一条消息。





![](https://cdn-images-1.medium.com/max/1600/1*fz1lQ7HoNCl5LCqrZv4_MA.png)





我现在暂且不为你一一介绍 OneSiganl 上可用的选项，但是你可以做很多事情通过仪表盘，你还可以通过其 [REST API](https://documentation.onesignal.com/reference) 与服务进行交互，以便您可以通过编程方式发送通知。 无论如何，如果一切正常，你应该得到你的设备上的通知！




![](https://cdn-images-1.medium.com/max/1600/1*_ztwFmCwSVYWO_lf1nyMtg.jpeg)



现在这是很基本的，你可以通过 OneSignal 做很多事情，其中一些我将在下面介绍。
#### [iOS] 仅在需要时请求通知权限


当需要的时候请求推送的权限，是被 Apple 所鼓励的（我找不到文档的说明，但是确实是存在的）。所以，与其说在 app 启动的时候请求权限不如当他们进行一些操作后。这样它们就可以理解你为啥去请求权限。这样的话是建立在用户信任的基础上的，让我们设置一下。




首先我们要做的是禁用自动注册，我们将在 **AppDelegate.m** 文件中执行。 记的之前写的 **self.oneSignal**？ 我们会再次用到它。


    self.oneSignal = [[RCTOneSignal alloc] initWithLaunchOptions:launchOptions
                                                           appId:@"YOUR_ONESIGNAL_APP_ID"
                                                           autoRegister:false]; // added this


所以一旦当我们这样写的话，它就不会自动的去请求权限了。我们需要手动的去请求权限。OneSignal 可以让我们非常容易的做这些事情，在 **App.js** 我们会添加一个按钮去请求权限（仅仅在 iOS 上）。我们将使用 **registerForPushNotifications** 函数来这样做。在请求权限后，它会处理好一切的事情。
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

[完整的文件](https://gist.github.com/spencercarli/2541f85684282a3827ec4740db96533e)



如果你之前在你的手机上运行过 app，你需要把他删除并且重新装一下，这样你就可以让请求推送的提示再次出现了。





![](https://cdn-images-1.medium.com/max/1600/1*S6z4KXAe3W1TD1clPjnTWg.gif)



#### App 内的推送



因此，假设你希望在用户使用 app 的过程中收到通知，并且希望向他们展示。 使用 OneSignal，您可以通过设置轻松地向他们显示


    OneSignal.enableInAppAlertNotification(true);

在你的 App.js 文件。 当用户在你的应用中时，将会显示你的通知。简单有用，对吧？我是这么想的。






* * *




这就是我今天介绍的所有东西。，它如一个洪水猛兽般强大，想看到更多的关于适用 OneSiganl 进行推送的东西么？可以反馈或者推荐这篇文章让我知道。我是非常赏识你这样做的。在下面自由的提问吧－可能会比较棘手。



[全部的代码在GitHub。](https://github.com/spencercarli/react-native-onesignal-example)



>这个帖子是一个更大的目标的是让更多的人知道React Native。 有兴趣了解更多吗？ [欢迎注册我的邮箱服务]（http://eepurl.com/bXLcvT），我保证提供有及多的油价值的 React 的知识！


帖子中的一些链接是推广链接，如果你从他们那里买东西，我可以赚一些佣金。




