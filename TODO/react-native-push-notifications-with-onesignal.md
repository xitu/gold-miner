> * 原文地址：[React Native Push Notifications with OneSignal](https://medium.com/differential/react-native-push-notifications-with-onesignal-9db6a7d75e1e#.ji9dbcxv7)
* 原文作者：[Spencer Carli](https://medium.com/@spencer_carli)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# React Native Push Notifications with OneSignal












I had initially planned to make a comprehensive multi-part video series on setting up remote push notifications but, unfortunately, I underestimated the time it would take for me to recover from getting my wisdom teeth removed.

But that’s no excuse. Here’s a tutorial on how to set up push notifications in React Native (both iOS and Android) with [OneSignal](https://onesignal.com/), a service that provides free push notification delivery for multiple platforms. This is a pretty long tutorial but it’s worth it. Even if you don’t use OneSignal, much of this will apply to you (general configuration). Let’s get to it.

#### Create React Native App

First thing you’ll need is a React Native app. Maybe that’s your existing app or maybe it’s a new one. We’ll start with a new one. From the command line:

    react-native init OneSignalExample

_Something to note going forward:_ push notifications only work on a real device, they won’t work on a simulator. I use an unlocked [refurbished Nexus 5](https://www.amazon.com/gp/product/B017RMREL6/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B017RMREL6&linkCode=as2&tag=handlebarlabs-20&linkId=4b8388a4f02af44c275fab434156cf7e) and an [iPhone 6](https://www.amazon.com/gp/product/B00YD547Q6/ref=as_li_tl?ie=UTF8&tag=handlebarlabs-20&camp=1789&creative=9325&linkCode=as2&creativeASIN=B00YD547Q6&linkId=5b16710a735bff80c55cc47dbdb4e38b) for testing.

You can access instructions for running on your device at the following links.

*   [Instructions for iOS](https://facebook.github.io/react-native/docs/running-on-device-ios.html#accessing-the-development-server-from-device)
*   [Instructions for Android](https://facebook.github.io/react-native/docs/running-on-device-android.html)

#### Create OneSignal Account & Create App

Next you’ll want to head over to [OneSignal](https://onesignal.com/) and sign up for an account. At that point you’ll be prompted to set up your app.







![](https://cdn-images-1.medium.com/max/1600/1*ryHYP7U61oq4FLQLUlIP3Q.png)



Now we’ll be asked to configure a platform. This is going to be the most complex part. I’m going to start off with iOS and configure Android later — details on how to do that outlined below.







![](https://cdn-images-1.medium.com/max/1600/1*dwqHBst3MqHQdxLhnctB5Q.png)



#### Generate iOS Push Certificate

So you’re probably sitting at a screen that looks a lot like this…







![](https://cdn-images-1.medium.com/max/1600/1*LISUO4JrSeF5nIG0-0Ng-Q.png)



You may be wanting to jump right into creating your .p12 file (we’ll cover that in a moment) but we’ve got to actually [create our app within the Apple Developer portal](https://developer.apple.com/account/ios/identifier/bundle).

Now if you’ve never done this before it’s important to note that you’ll need to set an Explicit App ID for push notifications to work.







![](https://cdn-images-1.medium.com/max/1600/1*2_XW-DWIQ6opwobXUqd6AQ.png)



You’re also going to want to enable push notifications for this app.







![](https://cdn-images-1.medium.com/max/1600/1*Tx8psBSrgTk42YDNU3MUMA.png)



Now that we’re done with that we can move over to actually creating the provisioning profile. OneSignal has a tool called [_The Provisionator_](https://onesignal.com/provisionator) that will help with this process.

> If you’re uncomfortable using giving this tool access to your Apple account you can [create the profile manually.](https://documentation.onesignal.com/docs/generate-an-ios-push-certificate#section-option-b-create-certificate-request-manually)

_Protip: If you’ve got two-factor authentication turned on for your account you’ll need to turn it off in order to use_ [_The Provisionator_](https://onesignal.com/provisionator)_. Feel free to change your password before/after using it — that’s what I did to aid in keeping my account secure._

Okay, now that we’re past those notes let’s actually use this tool and get our profile.

You’ll want to sign into your account and make sure you choose the proper team.







![](https://cdn-images-1.medium.com/max/1600/1*P-xYHCA3bMlTZLzkPU_dww.png)



Upon pressing “Next”, and waiting a few seconds, you’ll see something like this







![](https://cdn-images-1.medium.com/max/1600/1*H8s98ARR75NDEyIQ3SYaJg.png)



Go ahead and download those files and remember the password for the p12 file. Then we can head back to OneSignal and upload our file…







![](https://cdn-images-1.medium.com/max/1600/1*wXNjx9oZB5JTO7_Y4YZdjA.png)



And that’s it, for now! We’ll just close out this modal and come back to the React Native side of things in a moment. Now let’s configure Android (it’s easier, I promise).

#### Generate Google Server API Key

To set up OneSignal with Google we need to go to our App Settings (within OneSignal) and click “Configure” for Android.

![](https://cdn-images-1.medium.com/max/1600/1*wRzI1Z49dEjr8zD0Z1FKvA.png)

We then see that we’ll need a Google Server API Key and a Google Project Number. Let’s get both of those…







![](https://cdn-images-1.medium.com/max/1600/1*57f7XJz6dPW0la6DiHNy3Q.png)



You’ll need to go to the [Google Services Wizard](https://developers.google.com/mobile/add?platform=android&cntapi=gcm) to do this — the names aren’t important. Just choose things that make sense OR if you’re setting this up with an existing app, make sure you choose the right app.







![](https://cdn-images-1.medium.com/max/1600/1*nY1t8G4tXgN8EYAmQ_TzoA.png)



I like to keep things consistent between iOS and Android

Then enable Cloud Messaging







![](https://cdn-images-1.medium.com/max/1600/1*_oC5p_mTw3-4VplRMpvdKg.png)



Once enabled you’ll have access to your API key and your project ID (called Sender ID). Bring these over to OneSignal.







![](https://cdn-images-1.medium.com/max/1600/1*J_VTqlOM6KCrJYgo6iaGvA.png)



Woohoo! Platforms are set up. Now we can actually work on integrating this with our app.

#### Install _react-native-onesignal_

OneSignal has a package on npm, [react-native-onesignal](https://github.com/geektimecoil/react-native-onesignal#installation), that makes integrating with your platform super easy. It’s not the easiest to install but once it’s done you don’t have to do it again :) I’m hoping in the future that they integrate with rnpm/_react-native link_ so that we can minimize diving into native code but until then we must. For now, from your project root, run the following to install the package.

    npm install react-native-onesignal --save

Into the Objective-C/Java!

#### Configure iOS

Before I dive in here I want to say that this is basically just me rehashing the [official instructions](https://github.com/geektimecoil/react-native-onesignal#ios-installation) so if you run into issues be sure to check those out as well. With that, let’s jump into our app and start configuring things.

First thing we have to do is install the OneSignal iOS SDK — which is available via [CocoaPods](http://guides.cocoapods.org/using/getting-started.html). You’ll want to make sure you’ve got at least version _1.1.0_. You can check that by running

    pod --version

If it’s outdated you can update with

    sudo gem install cocoapods --pre

Now, from within your React Native project, you’ll want to to move to your _ios/_ directory and initialize a PodFile.

    cd ios/ && pod init

You then want to add the OneSignal pod to the file. It should look something like this

    # Uncomment the next line to define a global platform for your project
    # platform :ios, '9.0'

    target 'OneSignalExample' do
      # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
      # use_frameworks!

      # Pods for OneSignalExample
      pod 'OneSignal', '~> 1.13.3'

    end



I removed the tests since I don’t need them and they were causing an error.

Now, back at the command line and still in the _ios/_ directory, run

    pod install

Since we’re using CocoaPods a _.xcworkspace_ file will be generated. You’ll want to run the app using that from now on.

> Protip: To make sure you always do that add an npm script to your app and use that to open the ios project. [Like this one](https://gist.github.com/spencercarli/7cc7ec369fd4d8778021a6d92cea05dd).

Now let’s configure our capabilities within Xcode







![](https://cdn-images-1.medium.com/max/1600/1*WXAWsJBNClxskPcnDLOlXw.png)



Next we need to add the RCTOneSignal.xcodeproj to our Libraries folder. That can be found in _/node_modules/react-native-onesignal/ios._







![](https://cdn-images-1.medium.com/max/1600/1*PRAjGOX1DgWJnFyxeKNFTw.png)







![](https://cdn-images-1.medium.com/max/1600/1*tFjVSuDQTCOohUGBapjRnw.png)



Make sure “Copy items if needed” is NOT checked.

Now we have to add _libRCTOneSignal.a_ to Link Binary with Libraries, which can be found under the Build Phases tab. Just drag it from the left to that section.







![](https://cdn-images-1.medium.com/max/1600/1*FYUp6hU5exQmSGvichRzSQ.png)







![](https://cdn-images-1.medium.com/max/1600/1*c7TioyoM1Lx-YPiVbKzpQA.gif)





Okay, jump over to the Build Settings tab and search for “Header Search Paths”, double click the value, then click the “+” sign. Then add _$(SRCROOT)/../node_modules/react-native-onesignal_ and set it to “recursive”.







![](https://cdn-images-1.medium.com/max/1600/1*QKeUfjrXUVSBoRLSrjBSmQ.png)



Now to our app! We’ll need to make some changes to _ios/APP_NAME/AppDelegate.m._

First _#import “RCTOneSignal.h”._ Then we need to synthesize oneSignal.

    import "AppDelegate.h"

    #import "RCTBundleURLProvider.h"
    #import "RCTRootView.h"
    #import "RCTOneSignal.h"

    @implementation AppDelegate
    @synthesize oneSignal = _oneSignal;

    // ...

Still in your AppDelegate.m you need to setup oneSignal, that’s the first section of code I added below. Make sure to swap “YOUR_ONESIGNAL_APP_ID” with the right ID. The last part is so that you can receive notifications.

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







![](https://cdn-images-1.medium.com/max/1600/1*yNJH2BmKboc9XwauvFcx9Q.png)



Jump over to AppDelegate.h and add _#import _and _@property (strong, nonatomic) RCTOneSignal* oneSignal;_

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

Make sure to set your Bundle Identifier to the one you set up when you made the app.







![](https://cdn-images-1.medium.com/max/1600/1*E3L9e7SmfYnyqn-DcbfAaQ.png)



Then we need to make sure we [create a provisioning profile](https://developer.apple.com/account/ios/profile/) that will work with the push certificate we set up earlier. You’ll likely need to create an AdHoc one if you’ve been following these instructions exactly.







![](https://cdn-images-1.medium.com/max/1600/1*Z3DgmL_MOxCEqO_wTi78uw.png)



Then choose the correct app.







![](https://cdn-images-1.medium.com/max/1600/1*PdLBQ5nsXzUw8bPzXr-3Tw.png)



Then choose your certificate and the devices that should be included for the AdHoc distribution. If you need to add devices [you can do so on the Apple dev portal](https://developer.apple.com/account/ios/device/). Need to find out your UDID? [Use this resource](http://whatsmyudid.com/).

Then create your profile and download it. Once it’s downloaded. Double click it so that it’s installed.







![](https://cdn-images-1.medium.com/max/1600/1*CsHNUIgk5gWrws1x2kNegA.png)



Then in Xcode you’ll want to choose that profile in the Provisioning Profile section.







![](https://cdn-images-1.medium.com/max/1600/1*zbWgZF_kgg8TUfL9Tsir2g.png)



Okay… now… try to compile it. Cross your fingers. If it worked, congrats!







![](https://cdn-images-1.medium.com/max/1600/1*3e1SZvE7qPIcPz-OSusWtg.gif)



If not make sure you followed all the steps above. Now for Android.

#### [Configure Android](https://github.com/geektimecoil/react-native-onesignal#android-installation)

Now to set up Android! Before we get started I need to note that these instructions assume >= v0.29 of React Native. If you’re still on an earlier version [follow these instructions](https://github.com/geektimecoil/react-native-onesignal#rn--029). With that, let’s begin… (it’s easier than iOS)

First we need to add some necessary permissions to AndroidManifest.xml, which can be found at _android/app/src/main/AndroidManifest.xml._

    

        ...
         

        

        <application
          ...
          android:launchMode="singleTop" 
        >
          ...
        

    

[Access the full file.](https://gist.github.com/spencercarli/b5e40be6d2e843d843c633def1ffacf2)

Now we bounce over to _gradle-wrapper.properties_, accessible at _android/gradle/wrapper/gradle-wrapper.properties_ to change our _distributionUrl_. It should end up looking like this (we need gradle 2.10)

    distributionBase=GRADLE_USER_HOME
    distributionPath=wrapper/dists
    zipStoreBase=GRADLE_USER_HOME
    zipStorePath=wrapper/dists
    distributionUrl=https://services.gradle.org/distributions/gradle-2.10-all.zip

Now we tell the Android app about the OneSignal package in _settings.gradle_(_android/settings.gradle)._

    nclude ':react-native-onesignal'
    project(':react-native-onesignal').projectDir = new File(rootProject.projectDir, '../node_modules/react-native-onesignal/android')

We also want to update the gradle version we’re using in _android/build.gradle — _check out line 8.

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

[The full file is available also if you want to reference it](https://gist.github.com/spencercarli/b8e61d29fe1c1ab1798a3b7861177db5). The changes made occur at line 87, line 98, and line 135.

Just about there! Last thing we need to do is modify _MainApplication.java_(_android/app/src/main/java/com/YOUR_APP_NAME/MainApplication.java_). Line 15 and 29 are the ones you’ll be interested in.

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







![](https://cdn-images-1.medium.com/max/1600/1*3ld_cBA83pnFiwIdvmuq7w.gif)



Good? Good, great. Let’s use these fancy remote notifications now.

#### Android Usage & iOS Usage

First thing we want to do is create a new _App.js_ file in the root of our project — this way we can write the same code for both iOS and Android. Go ahead and copy and paste the following.

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

    import { AppRegistry } from 'react-native';
    import App from './App';

    AppRegistry.registerComponent('OneSignalExample', () => App);

Okay, now we can go ahead and actually configure OneSignal to work for us. Ready? It’s just two lines (yeah all that for two lines). First we import the package then we call the configure method.

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

We can then go ahead and refresh or start our app on both iOS and Android. If everything worked as expected you should see something like this on your OneSignal dashboard.







![](https://cdn-images-1.medium.com/max/1600/1*5zB7dz--07hxIptHv4oHaw.png)



> Remember, you need a [real](https://www.amazon.com/gp/product/B00YD547Q6/ref=as_li_tl?ie=UTF8&tag=handlebarlabs-20&camp=1789&creative=9325&linkCode=as2&creativeASIN=B00YD547Q6&linkId=5b16710a735bff80c55cc47dbdb4e38b) [device](https://www.amazon.com/gp/product/B017RMREL6/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B017RMREL6&linkCode=as2&tag=handlebarlabs-20&linkId=4b8388a4f02af44c275fab434156cf7e) to test this.

Go ahead and lock the device and jump over to OneSignal’s dashboard and send a message.







![](https://cdn-images-1.medium.com/max/1600/1*fz1lQ7HoNCl5LCqrZv4_MA.png)



I won’t go over all the options available to you through OneSignal (right now) but there is quite a lot you can do through the dashboard. You can also interact with the service via their [REST API](https://documentation.onesignal.com/reference) so you can programmatically send notifications. Anyways, if everything worked out correctly you should have gotten notifications on your device!







![](https://cdn-images-1.medium.com/max/1600/1*_ztwFmCwSVYWO_lf1nyMtg.jpeg)



Now that’s pretty basic and you can do a lot more with OneSignal and push notifications in general, some of which I’ll cover below.

#### [iOS] Request notification permission only when needed

One pattern that is encouraged by Apple (I can’t find the docs stating this but they do exist) is to request permission to send push notifications when it’s needed. So, rather than requesting permission as soon as the app boots (the default) you wait until the user takes some action so that they would understand why you’re requesting permission. This builds confidence with your user so let’s set that up.

First thing we have to do is disable auto registration, which we’ll do in the _AppDelegate.m_ file. Remember that _self.oneSignal_ from earlier? We’ll be touching that again.

    self.oneSignal = [[RCTOneSignal alloc] initWithLaunchOptions:launchOptions
                                                           appId:@"YOUR_ONESIGNAL_APP_ID"
                                                           autoRegister:false]; // added this

So once we do that it won’t ask permission — we have to do that manually. OneSignal makes that easy for us. Over in the _App.js_ file we’ll add a button (only on iOS) to request permission. We’re going to use the _registerForPushNotifications_ function to do so. After requesting permission it will do everything necessary to register the device with OneSignal.

    ender() {
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

If you previously ran the app on your phone you may have to delete it and reinstall so that you’re prompted to enable notifications again.







![](https://cdn-images-1.medium.com/max/1600/1*S6z4KXAe3W1TD1clPjnTWg.gif)



#### In App Notification

So let’s say your user gets a notification while they’re in the app and you want to show them that. With OneSignal you can easily show that to them by setting

    OneSignal.enableInAppAlertNotification(true);

in your App.js file. This will show a modal with your notification in it while the user is in your app. Simple and useful, right? I thought so.







* * *







I think that’s all for me today. This was a monster to write. Want to see more on Push Notifications via OneSignal? Let me know by r**esponding to and recommending this article.** I would really appreciate it! Feel free to ask questions below — this can be tricky.

[Full source is on GitHub.](https://github.com/spencercarli/react-native-onesignal-example)

> This post is a part of a larger goal to educate as many people as possible about React Native. Interested in learning more? [Sign up for my email list](http://eepurl.com/bXLcvT) and I promise to deliver a ton of valuable React Native knowledge!

Some of the links in the post are affiliate links and I may earn a small commission if you buy something from them.





