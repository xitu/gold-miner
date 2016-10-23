> * 原文地址：[Exploring Firebase on Android & iOS: Remote Config](https://medium.com/@hitherejoe/exploring-firebase-on-android-ios-remote-config-3e1407b088f6#.hb0blxber)
* 原文作者：[Joe Birch](https://medium.com/@hitherejoe)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jamweak](https://github.com/jamweak)
* 校对者：

# 探索 Firebase 在 Android 和 iOS 的使用: 远程配置


远程配置是 Firebase 套件的一个特性，它允许我们在没有发布任何更新到 Google Play 或 Apple Store 的情况下，改变我们应用的外观及体验。 它的工作原理是通过允许我们预先定义一些存于应用内部的参数，然后通过 firebase 的控制台修改这些参数。随后这些参数可以对所有用户激活，或是仅针对某些特定的用户激活。


这个强大的特性使得我们有能力进行立即更新、短期改变或是在用户中尝试某些新的特性。让我们来深入学习一下什么是远程配置，为何要使用以及怎样使用它，这不仅给我们带来方便，也使得用户收益。🚀


不要忘记查看下我们这个系列的前一篇文章：

*   [**探索 Firebase 在 Android 和 iOS 的使用: 分析**](https://medium.com/exploring-android/exploring-firebase-on-android-ios-analytics-8484b61a21ba#.dgyq5cpoq)

我也正在筹划一本完整的电子书，它可以当做集成 firebase 特性的实际指导教程。这本书会详细介绍 firebase 新特性的每一个方面。对于远程配置而言，在书中我们将深入分析 firebase 控制台，在应用中集成 firebase 从而真正使用它。点击下面的图片订阅本书的发布消息！🙂


![](https://cdn-images-1.medium.com/max/2000/1*adPhI66a3h5h3uX8G0eA1A.png)


### 我们能使用 Firebase 的远程配置做什么?

简而言之，远程配置的作用大体上就是能使我们针对用户立即发布应用更新。无论是我们想修改我们应用在某些窗口下的颜色主题、某些特定的布局或是增加广告/运营宣传等——这完全可以通过修改服务器端的参数来做到，而不用发布一个新的版本。

我们甚至能针对某部分用户来完成更新，这使得我们能根据用户段、应用版本号、Firebase 分析中的受众群里、用户的语言等等来完成更新。因此，我们掌握了很大的灵活性，可以决定谁能看到这些更新修改。除了这些，我们还可以使用远程配置来针对 Firebase 分析中随机指定的目标做 A/B 测试，甚至是在应用加入新组件时，某些特性的替换。

远程配置带给我们:

*   无需发版，快速简洁地更新我们的应用。例如，我们能够针对我们面对的特定情况，轻松地为某些用户替换一个组件的重新打包
*   我们能轻松地对片段进行设定，让其在应用中的行为或者式样针对其用户/设备的不同而不同。例如，我们可能会针对欧中的用户替换一个组件，而美国的用户则可能使用另外一个。
*   根据以上，我们能使用远程配置进行 A/B 测试，在决定发布针对全部用户的版本之前，预先针对一部分用户试用我们的新版本应用。

### 远程配置的工作流程

远程配置主要是使用在应用内部定义的一些值来确定你对应用的配置。随后使用 firebease 的控制台来远程改变这些值，这将针对定义好的用户群，其应用配置被改变。远程配置只需四步简单的配置即可使用：

![](https://cdn-images-1.medium.com/max/1760/1*SXNQ6ctxBmtbjCAMIgkgeg.png) ![](https://cdn-images-1.medium.com/max/1760/1*NCvGAEVq7Pl8qHfs3bX4DQ.png) ![](https://cdn-images-1.medium.com/max/1760/1*m8-3ewgI5cX3NdrJPInd_w.png) ![](https://cdn-images-1.medium.com/max/1760/1*SQAXrF83xkWMCSl0onqRnw.png)

### 参数, 配置和场景

在远程配置中我们定义了叫做**参数**的键值对，这些**参数**被用作定义应用中使用的配置值——例如组件颜色，视图中待显示的图形，甚至是表征用户或设备的属性值，这个属性决定组件是否该被显示出来。

为了覆盖参数没有设置或者不能从服务器端配置的情形，我们也提供了应用中的默认值。

这个键值对提供了在应用中可以改变**什么**参数（键, 标识符），以及**怎样**改变我们要更新到应用中的配置（值，配置）。

*   **键** — 键是一个字符串，用来定义参数的标识符
*   **值** — 值可以是其它任何数据类型，用来表示被定义参数的值

#### 场景

场景是一系列条件的集合，我们可以通过它来匹配特定的应用实例——例如，我们可能希望仅仅针对女性用户修改配置或是针对不想付费的用户。如果指定的所有条件都被某个场景满足，配置也会为此部分的应用实例改变。

**场景值** 本身也是被一个键值对表示，它由以下组成：
*   **场景** — 值将要被应用到的待匹配场景
*   **value** — 如果场景被匹配，将要生效的值

我们可以在远程配置的设置过程中对每个参数使用多个**场景值**。这允许我们声明多个条件，必须满足这些条件，参数值才会被应用到应用实例中。


#### 优先级

如果我们确实有多个场景值设置，那么我们的应用该怎样确定该使用哪一个值？其实，远程配置使用一系列条件集合来确定从远程配置服务器取得哪些值，这也适用于确定哪些值该被用于应用实例中。

当我们从服务器请求场景值时，需要确定应用实例是否满足所有的条件都被满足。如果仅有一个场景被匹配，那么仅仅会返回它的场景值。另一方面，如果多个场景被匹配，那么最高地位的值（基本上是远程配置清单中最上面的那个）将会被返回。然而，如果没有场景被匹配，那么服务器中定义的默认值会被返回。**注意**如果这个默认值没有被定义，那么将不会有值被返回。

因此我们必须在我们的应用内以及远程配置控制台中定义这些值——远程配置 SDK 怎样知道哪个值将被使用？下面就轮到一系列优先级规则登场了。服务器端和客户端都定义了一系列规则——服务器需要决定哪些值将被返回，之后一旦应用接收到了服务器返回的这些值，它必须知道是否该使用它们或是使用在应用自身定义的一些值。这些定义的规则像是这样的：

![](https://cdn-images-1.medium.com/max/2000/1*5Gh8GREOVauLT4YWDHbd2w.png)


开始时，服务器端需要查看当前的配置值。如果我们有定义的场景值，那么具有最高优先级（在 firebase 控制台的配置清单的最上端）的值将被返回。如果没有匹配的场景值，将返回服务器端配置的默认值——假设这个默认值存在。

在客户端这边，如果我们接收到来自服务器的一个值，那么这个值就是要被用在应用中的那个。然而，如果没有值返回，这时如果客户端有默认值的话就会使用默认值。如果两个值都不存在，那么客户端将会使用默认数据类型的的负向值（例如 0、false、null 等等）。

### 远程配置架构

现在我们知道了一点关于远程配置以及怎样使用它的知识，接下来，理解应用端、Firebase API、以及服务器端的通信操作流程是很重要的。在下面的图表中，展示了整个通信流程：



![](https://cdn-images-1.medium.com/max/2000/1*g0_e840r5v3wTL_UyzU96A.png)



从这个表中你能看到远程配置架构主要包括三个核心部分，分别是：

**应用** — 运行在设备中的应用实例。它通过一个 FirebaseRemoteConfig 类的实例直接与 Firebase 库通信。

**Firebase 库** — Firebase 库为我们处理所有的困难工作。它存储默认值，获取服务器端的远程值（也会为我们存储下来），还持有当前正在使用的值（一旦我们使用获取的值之后）。我们不必担心存储或是哪个值可用，我们只需使用库中提供的方法，其它的事情交给它处理。

**服务端** — 服务器端持有所有远程配置的值，我们通过 firebase 控制台来定义它们。

所有的这些是怎样联系到一起的？

*   开始时，我们的应用获取到远程配置类的实例后开始通信，从远程获取配置值。如果还不存在这样的实例，远程配置库会创建它。初始创建实例时，所有的参数（获取的，正在使用的以及默认值）都是空值。
*   现在我们的应用以及获取到远程配置的实例，它能够为我们的参数设置一些默认值。如果应用试图在这些值被设定之前获取它们，那么远程库将会返回它们的默认值集合。
*   此时此刻，我们的应用现在能自由地使用一些远程配置库的操作了。在最初，应用可以使用获取方法从服务器端获取远程配置参数。这个调用会被远程配置库初始化，而后当有值返回时，远程配置实例会存储这个值。当有值返回时，这个调用并不会立即改变我们应用的外观和行为——我们必须等待这些值被取出之后才能做出反应。
*   在我们使用这些获取的参数之前，应用需要使用远程配置库中当前正被使用的值。当调用这个方法时，这些从远程获取的值会被拷贝到库中覆盖那些正在被使用的值。
*   一旦值被使用，应用就可以使用获取方法去获取远程配置库中的其它类型的值了。

### 远程配置的实现

至此我们了解了一些远程配置的工作原理，接下来让我们看一下如何在应用中实现远程控制。下面这个章节包括三个部分：

*   在 Android 中设置远程配置，设置默认值和获取远程配置值。
*   在 iOS 中设置远程配置，设置默认值和获取远程配置值。
*   最后，在服务器端通过 firebase 控制台设定远程配置值以及场景值。

### 在 Android 中实现远程配置

在这个部分，我们将会覆盖怎样在 Android 应用中完全配置使用远程配置。让我们开始吧！


**添加远程配置依赖**

我们需要从在**build.gradle**文件中添加远程配置库的依赖开始。 鉴于我们只用到 Firebase 套件中的远程配置库，我们可以用以下方式添加依赖：

    compile 'com.google.firebase:firebase-config:9.6.0'

一旦完成，我们就可以在应用全局使用 FirebaseRemoteConfig 类的实例了：

    FirebaseRemoteConfig firebaseRemoteConfig = 
                                     FirebaseRemoteConfig.getInstance();

如果你正在使用依赖注入，那么你可以简化获得这个类的方式，这里有一个使用 Dagger 2 的例子：

    @Provides
                                     FirebaseRemoteConfig providesFirebaseRemoteConfig() {
        return FirebaseRemoteConfig.getInstance(activity);
        }

#### 设置应用中的默认值

接下来我们需要为应用中的一些配置值设定默认值，这是因为：

*   我们可能需要在还没有从服务器获取到配置值之前访问配置值。
*   服务器端可能不存在任何配置值
*   设备可能处于不能访问服务器端的状态——比如，离线状态。

可以通过使用 [Map](https://developer.android.com/reference/java/util/Map.html) 或者 XML 文件的方式以键值对的形式设置默认值。在下面的例子中，我们使用 xml 文件来表示默认值：


```
<?xml version="1.0" encoding="utf-8"?>
<defaultsMap>
    <entry>
        <key>some_text</key>
        <value>Here is some text</value>
    </entry>
    <entry>
        <key>has_discount</key>
        <value>false</value>
    </entry>
    <entry>
        <key>main_color</key>
        <value>red</value>
    </entry>
</defaultsMap>
```

之后我们能通过远程配置类中的 setDefaults() 方法类设定默认值：

    firebaseRemoteConfig.setDefaults(R.xml.defaults_remote_config);

#### 获取远程配置值

现在我们设定了配置的默认值，然后就可以在应用内使用它们了。在远程配置类中，有 5 个可用方法能让我们使用来获取远程的配置值。当前我们只能够获取并存储以下方法返回的数据类型的值：
Now we’ve set our configuration defaults, we can start using them within our app right away. From the Remote Config class we have 5 methods available to us so that we can retrieve our configuration values from it. We can currently only store and retrieve data types corresponding to the types that these methods return, which are:

*   [getBoolean()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getBoolean%28java.lang.String%29) — Allows us to retrieve **boolean** configuration values

    ```
		boolean someBoolean =     
                firebaseRemoteConfig.getBoolean("some_boolean");
		```

*   [getByteArray()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getByteArray%28java.lang.String%29) — Allows us to retrieve **byte[]** configuration values

    ```
		byte[] someArray = firebaseRemoteConfig.getByteArray("some_array");
		```

*   [getDouble()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getDouble%28java.lang.String%29) — Allows us to retrieve **double** configuration values

    ```
		double someDouble = firebaseRemoteConfig.getDouble("some_double");
		```

*   [getLong()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getLong%28java.lang.String%29) — Allows us to retrieve **long** configuration values

    ```
		long someLong = firebaseRemoteConfig.getLong("some_long");
		```

*   [getString()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getString%28java.lang.String%29) — Allows us to retrieve **String** configuration values

    ```
		String someText = firebaseRemoteConfig.getString("some_text");
		```

#### 获取服务端的值

现在我们已经有了默认的设置，可以进行下一步，来实现获取值的方法。这可以通过使用远程配置实例中的 **fetch()** 方法轻松完成。

    firebaseRemoteConfig.fetch(cacheExpiration)
                    .addOnCompleteListener(new OnCompleteListener() {
                        @Override
                        public void onComplete(@NonNull Task task) {
                            if (task.isSuccessful()) {
                                mFirebaseRemoteConfig.activateFetched();
                                // We got our config, let's do something with it! 
                            } else {
                                // Looks like there was a problem getting the config...
                            }
                        }
                    });

当调用它的时候，我们使用 OnCompleteListener 来接收来自 **fetch()** 方法的回调事件。至此，这个流程已经相当简单：

*   onComplete 回调收到一个[任务](https://firebase.google.com/docs/reference/serverreference/com/google/firebase/tasks/Task)实例。 它是一个刚被执行过的异步操作的实例。
*   接下来需要使用 **isSuccessful()** 方法检查下请求有没有成功。
*   如果请求成功，则可以继续。这里我们需要将获取到的的值激活，使用 **activateFetched()** 方法。**注意:**你必须激活获取到的参数，才能在应用中使用它们。
*   如果请求失败，你需要相应地去处理错误请求。

你可能发现了在调用 **fetch() **时传入的 cacheExpiration 参数——这个值声明了一个时间，当缓存的数据在这个时间内时，它们会被分类成未到期状态。所以如果收到的数据缓存没有超过 cacheExpiration 时间，那么这个缓存数据就会被使用。

我们将会在 [Exploring Firebase eBook](http://hitherejoe.us14.list-manage.com/subscribe?u=29201953105285dda07c9fdbf&id=5725aeaf1d) 这本书中更深入地去讲述它。在我们了解如何在 iOS 中做同样的事情之后，我们将学会如果远程改变配置参数。

### Implementing Remote Config on iOS

In this section we’re going to cover how you can get your iOS application all setup and ready to go with remote configuration. Let’s get started!

**Adding the Remote Config dependancy**

To begin with, we need to start by adding the Remote Config dependancy to our **Podfile**. Seeing as we’re only using Remote Config from the Firebase Suite, we can use the dependancy as seen below:

    pod 'Firebase/RemoteConfig'

Following that, you’ll need to run:

    pod install

You’ll then be able to open your .xcworkspace file and import the dependancy for Remote config. If you’re doing this in objective-C then this will look like:

    @import Firebase;

Otherwise in Swift we can import this like so:

    import Firebase

Now that we’ve introduced Firebase Remote Config into our project setup, we need to configure an instance so that it’s ready to start using within our app. To do so, we need to first navigate to the **application:didFinishLaunchingWithOptions:** method and in Objective-C we can put:

    [FIRApp configure];

Similarly in Swift:

    FIRApp.configure()

The final step is just creating a singleton instance of the FIRRemoteCOnfig class that we can then access and use throughout our application. In Objective-C:

    self.remoteConfig = [FIRRemoteConfig remoteConfig];

and also in Swift:

    self.remoteConfig = FIRRemoteConfig.remoteConfig()

And that’s all for getting the dependancy added and setup in our app, we’re now reading to start using it!



#### Setting in-app defaults

We next need to set some in-app configuration defaults for our configuration values, this is because:

*   We may need access to the configuration values before the configuration values can be retrieved from the server.
*   There may not be any values set server-side
*   Our device is in a state where we cannot access server-side values. For example, offline.

We can set our default values in the form of key-value pairs using either an NSDictionary instance or define them with a plist file. In this example, we’ve setup an plist file to represent our default values:

    
    
    
    
        some_string
        Some string
        has_discount
        
        count
        10
    
    

Once we’ve got our default values defined, we can easily declare these values as our defaults by using the **setDefaultsFromPlistFileName** method from the Remote Config instance that we previously defined. IN Objective-C this is done like so:

    [self.remoteConfig setDefaultsFromPlistFileName:@"DefaultsRemoteConfig"];

Followed by an also-simple setup in Swift:

    remoteConfig.setDefaultsFromPlistFileName("DefaultsRemoteConfig")

#### Retrieving Remote Config values

Now we’ve set our configuration defaults, we can start using them within our app right away. From the Remote Config class we have 4 methods available to us so that we can retrieve our configuration values from it. We can currently only store and retrieve data types corresponding to the types that these methods return, below we can see some examples of fetching data types from the Remote Config library:

**Retrieving values using Objective-C**

    someString = self.remoteConfig[kSomeStringConfigKey].stringValue;
    someNumber = self.remoteConfig[kSomeNumberConfigKey].numberValue.longValue;
    someData = self.remoteConfig[kSomeDataConfigKey].dataValue;
    someBoolean = self.remoteConfig[kSomeStringConfigKey].boolValue;

**And again, but this time in Swift**

    self.remoteConfig[kSomeNumberConfigKey].numberValue.longValue;
    someData = self.remoteConfig[kSomeDataConfigKey].dataValue;
    someBoolean = self.remoteConfig[kSomeStringConfigKey].boolValue;

**And again, but this time in Swift**

    someNumber = (remoteConfig[someNumberConfigKey].numberValue?.intValue)!
    someString = remoteConfig[someStringConfigKey].stringValue
    someBoolean = remoteConfig[someBooleanConfigKey].boolValue
    someData = remoteConfig[someDataConfigKey].dataValue

#### Fetch Server-Side values

Now we have our defaults setup, we can go ahead and implement the retrieval of our values. This is simply done with the use of the **fetch** method from our Firebase Remote Config instance.

In swift, we can fetch our values likes so:

    remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
      if (status == FIRRemoteConfigFetchStatus.success) {
        self.remoteConfig.activateFetched()
      } else {
        // Something went wrong, handle it!
      }
      // Now we can react to the result, if activated then the new    value will be used otherwise it will be the default  value
    } 

And the same again, but this time using **Objective-C**:

    [self.remoteConfig fetchWithExpirationDuration:expirationDuration completionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            [self.remoteConfig activateFetched];
        } else {
            // Something went wrong, handle it!
        }
        // Now we can react to the result, if activated then the new    value will be used otherwise it will be the default  value
    }];

When calling, we use the completionHandler to receive callback events from our **fetch()** call. And from here, the flow is fairly simple:

*   The completionHandler receives a **FIRRemoteConfigFetchStatus** instance. This is essentially an instance of the asynchronous operation that was just executed.
*   Next we need to check if the request was successful by checking that the status value receives matches the FIRRemoteConfigFetchStatusSuccessenum.
*   If the request was successful, then we can continue. Here we need begin by activating the fetched results using the **activateFetched** method. **Note:** You need to activate fetched parameters before you can use them within your app.
*   Otherwise, you’ll need to handle the failed request accordingly.

You may have spotted the cacheExpiration parameter passed in when we called **fetch**— this value declares the time in which the cached data should be classed as not expired. So if the data in the cache was retrieved less than cacheExpiration seconds ago then the cached data is used.

We’ll cover this more in depth in the [Exploring Firebase eBook](http://hitherejoe.us14.list-manage.com/subscribe?u=29201953105285dda07c9fdbf&id=5725aeaf1d). After we’ve taken a look at how to achieve the same on iOS we’ll learn how to alter our configured parameters remotely.

#### Setting up the server-side configuration for Remote Config

So firebase is all set and ready to go in our application, but we’re not taking advantage of Remote Configuration as we haven’t setup any server-side values yet! Let’s take a look at how we can get going with server-side values and start configuring our application remotely.

**Set Server-Side values**

Now we have our client-side all setup, it’s time to add some values server-side so that we can begin altering our application remotely! First of all, you’ll need to navigate to the Remote Config page within the Firebase Console. You’ll find that here:

https://console.firebase.google.com/project/{YOUR-PROJECT-ID}/config

https://console.firebase.google.com/project/{YOUR-PROJECT-ID}/config

At this page you’ll be presented with the option to start adding your remote config parameters (if you haven’t done so already!). So go ahead and click that button!

![](https://cdn-images-1.medium.com/max/1760/1*fCewZn9r7NJwoPB1PKzNLw.png)

After hitting that button you’ll be presented with a pop-up that looks a little something like this:

![](https://cdn-images-1.medium.com/max/1760/1*FAVU3cQ5sm0UXT_WdAseqQ.png)

This is where you can define the server-side parameters for your remote configuration. So what do we enter here?

*   **Parameter key** — This is the key that you’ve defined within your application, these are ones that we would have defined in-app default values for in the previous sections. For example, **has_discount**.
*   **Default value** — This is the primary value to be used when the parameter is fetched from server-side.

If we don’t wish to assign a value to the server-side parameter then we can click the “Other empty values” option to be presented with a menu where we can select:

*   **No Value** — This option will make the client use the pre-defined default value
*   **Empty string** — This option will return an empty string, meaning that there will be no value and the client-side default value will also be ignored





![](https://cdn-images-1.medium.com/max/1760/1*b7A-ak_PW7W6HG2s-3zB1w.png)





You’ll also notice the **“Add value for condition”** button — this can be used to assign a condition for when the parameter should be used.





![](https://cdn-images-1.medium.com/max/1760/1*2dwEkKx9k2unB0ogenPvPg.png)





If we decide to **Define a new Condition** then we’ll be presented with a window to enter properties in which will satisfy the condition:

![](https://cdn-images-1.medium.com/max/1760/1*imvhdLXo6-1ORxjXCMwz-g.png)

Here you can see we’re displayed with several options when creating a new condition:

*   **Name** — The name we wish to use to identify the conditions
*   **Color** — The color used for the condition name when displayed in the firebase console
*   **Applies if (property)** — The property that the corresponding arguments should be tested against
*   **Applies if (arguments)** — The arguments in which should be tested for the given property

Currently we have the ability to set one or more (using the **AND** button) conditional property. The properties we can currently set for a condition are:

*   **App ID** — Select an ID from the selected application that the application instance must match in order for the condition to be satisfied.
*   **App Version** — Select an app version from the selected application that the application instance must match in order for the condition to be satisfied.
*   **OS Type** — Select an OS type in which the application instance must be running on, currently this is either Android or iOS.
*   **User in random percentile** — This is a random percentage which can be used to assign a random count of users that the parameter should be applied to. The value can be assigned to be either **greater than** or **less than OR equal** **to** the given percentage.
*   **User in audience** — Select an audience from Firebase Analytics that the given parameters should be applied to.
*   **Device in Region/Country** — Select a region/country that should be selected on the device that the application instance is running on for the condition to be satisfied.
*   **Device in language** — Select a language that the device he application instance is running on for the condition to be satisfied.

Once we’ve finished creating our condition, we can simply use the **CREATE CONDITION** button to finalise the configuration. At this point we are returned to our list of parameters and any with conditions applied to them will display the condition name in the selected colour above the value field, as shown below.

![](https://cdn-images-1.medium.com/max/1760/1*DpCGi-22CtnVMhe-fTMtvA.png)

Remember to click the **UPDATE** button to save your configuration once you’ve finished making changes 😄 From this point, your parameters should be fetch-able from within your application — as per the instructions in the sections above.



### And that’s it!

So we’ve seen what we can do with Firebase Remote Config and how to implement it into our application to begin altering the look, feel and behaviour of our application remotely. I hope from this you’ve been able to see the benefits of Firebase and how super easy it is to get setup!

And if you wish to learn more about Firebase Remote Config and other integrations, please do remember to sign-up to be alerted when my Firebase eBook is out!



![](https://cdn-images-1.medium.com/max/2000/1*adPhI66a3h5h3uX8G0eA1A.png)
