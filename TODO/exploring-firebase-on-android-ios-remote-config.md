> * 原文地址：[Exploring Firebase on Android & iOS: Remote Config](https://medium.com/@hitherejoe/exploring-firebase-on-android-ios-remote-config-3e1407b088f6#.hb0blxber)
* 原文作者：[Joe Birch](https://medium.com/@hitherejoe)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Jamweak](https://github.com/jamweak)
* 校对者：[Zheaoli](https://github.com/Zheaoli), [Jasper Zhong](https://github.com/DeadLion)

# 探索 Firebase 在 Android 和 iOS 的使用: 远程配置


远程配置是 Firebase 套件的一个特性，它允许我们在没有发布任何更新到 Google Play 或 Apple Store 的情况下，改变我们应用的外观及用户体验。 它的工作原理是通过允许我们预先定义一些存于应用内部的参数，然后通过 firebase 的控制台修改这些参数。随后这些参数可以对所有用户激活，或是仅面向某些特定的用户激活。


这个强大的特性使得我们有能力进行立即更新、临时更改或是在用户中尝试某些新的特性。让我们来深入学习一下什么是远程配置，为何要使用以及怎样使用它，这不仅给我们带来方便，也使得用户受益。🚀


不要忘记查看下我们这个系列的前一篇文章：

*   [**探索 Firebase 在 Android 和 iOS 的使用: 分析**](https://medium.com/exploring-android/exploring-firebase-on-android-ios-analytics-8484b61a21ba#.dgyq5cpoq)

我也正在筹划一本完整的电子书，它可以当做集成 firebase 特性的实际指导教程。这本书将会详细介绍 Firebase 套件相关功能的每个部分。对于远程配置而言，在书中我们将深入分析 firebase 控制台，在应用中集成 firebase 从而真正使用它。点击下面的图片订阅本书的发布消息！🙂


![](https://cdn-images-1.medium.com/max/2000/1*adPhI66a3h5h3uX8G0eA1A.png)


### 我们能使用 Firebase 的远程配置做什么?

简而言之，远程配置的作用大体上就是能使我们面向用户立即发布应用更新。无论是我们想修改应用在某些窗口下的颜色主题、某些特定的布局或是增加广告/运营宣传等——这完全可以通过修改服务器端的参数来做到，而不用发布一个新的版本。

我们甚至能向某部分用户来完成更新，这使得我们能根据用户段、应用版本号、Firebase 分析中的受众群里、用户的语言等等来完成更新。因此，我们的整个开发流程变得更为灵活，我们可以决定对哪些特定的用户来推送特定的更新。除了这些，我们还可以使用远程配置来针对 Firebase 分析中随机指定的目标做 A/B 测试，甚至是在应用加入新组件时，某些特性的替换。

远程配置带给我们:

*   无需发版，快速简洁地更新我们的应用。例如，我们可以轻松地为那些根据指定条件选定的用户，在应用中切换至新生成的组件。
*   我们能轻松地对组件进行定制，让其对不同的用户/设备等展现出不同的样式或者交互逻辑。例如，为了适应欧洲和美国用户的需求的差别，我们可能将会根据的确切换至不同的组件。
*   根据以上，我们能使用远程配置进行 A/B 测试，在决定发布面向全部用户的版本之前，预先面向一部分用户试用我们的新版本应用。

### 远程配置的工作流程

远程配置主要是使用在应用内部定义的一些值来确定你对应用的配置。随后使用 firebease 的控制台来远程改变这些值，这将对定义好的用户群，其应用配置被改变。远程配置只需四步简单的步骤即可使用：

![](https://cdn-images-1.medium.com/max/1760/1*SXNQ6ctxBmtbjCAMIgkgeg.png) ![](https://cdn-images-1.medium.com/max/1760/1*NCvGAEVq7Pl8qHfs3bX4DQ.png) ![](https://cdn-images-1.medium.com/max/1760/1*m8-3ewgI5cX3NdrJPInd_w.png) ![](https://cdn-images-1.medium.com/max/1760/1*SQAXrF83xkWMCSl0onqRnw.png)

### 参数, 配置和场景

在远程配置中我们定义了叫做**参数**的键值对，这些**参数**被用作定义应用中使用的配置值——例如组件颜色，视图中待显示的图形，甚至是表征用户或设备的属性值，这个属性决定组件是否该被显示出来。

为了覆盖参数没有设置或者不能从服务器端配置的情形，我们也提供了应用中的默认值。

这个键值对提供了在应用中可以改变**什么**参数（键, 标识符），以及**怎样**改变我们要更新到应用中的配置（值，配置）。

*   **键** — 键是一个字符串，用来定义参数的标识符
*   **值** — 值可以是其它任何数据类型，用来表示被定义参数的值

#### 场景

场景是一系列条件的集合，我们可以通过它来匹配特定的应用实例——例如，我们可能希望仅仅面向女性用户修改配置或是面向不想付费的用户。如果指定的所有条件都被某个场景满足，配置也会为此部分的应用实例改变。

**场景值** 本身也是被一个键值对表示，它由以下组成：
*   **场景** — 值将要被应用到的待匹配场景
*   **value** — 如果场景被匹配，将要生效的值

我们可以在远程配置的设置过程中对每个参数使用多个**场景值**。这允许我们声明多个条件，必须满足这些条件，参数值才会被应用到应用实例中。


#### 优先级

如果我们确实有多个场景值设置，那么我们的应用该怎样确定该使用哪一个值？其实，远程配置使用一系列条件集合来确定从远程配置服务器取得哪些值，这也适用于确定哪些值该被用于应用实例中。

当我们从服务器请求场景值时，需要确定应用实例是否满足所有的条件都被满足。如果仅有一个场景被匹配，那么仅仅会返回它的场景值。另一方面，如果多个场景被匹配，那么优先级最高的值（基本上是远程配置清单中最上面的那个）将会被返回。然而，如果没有场景被匹配，那么服务器中定义的默认值会被返回。**注意**如果这个默认值没有被定义，那么将不会有值被返回。

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

在这个部分，我们将会讨论怎样在 Android 应用中完全配置使用远程配置。让我们开始吧！


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

*   [getBoolean()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getBoolean%28java.lang.String%29) — 允许我们获取 **boolean** 类型的配置值

    boolean someBoolean =     
                firebaseRemoteConfig.getBoolean("some_boolean");
   

*   [getByteArray()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getByteArray%28java.lang.String%29) —允许我们获取 **byte[]** 类型的配置值

    byte[] someArray = firebaseRemoteConfig.getByteArray("some_array");
   

*   [getDouble()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getDouble%28java.lang.String%29) — 允许我们获取 **double** 类型的配置值

    double someDouble =  firebaseRemoteConfig.getDouble("some_double");

*   [getLong()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getLong%28java.lang.String%29) — 允许我们获取 **long** 类型的配置值

    long someLong = firebaseRemoteConfig.getLong("some_long");
   
*   [getString()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getString%28java.lang.String%29) — 允许我们获取 **String** 类型的配置值

    String someText = firebaseRemoteConfig.getString("some_text");
    

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

### 在 iOS 中实现远程配置

在这个部分，我们将会讨论怎样在 iOS 应用中完全配置使用远程配置。让我们开始吧！


**添加远程配置库依赖**

我们将从添加远程配置依赖到 **Podfile** 文件开始. 鉴于我们只需用到 Firebase 套件中的远程配置库，因此我们可以按如下方式添加依赖：

    pod 'Firebase/RemoteConfig'

接下来，你需要运行如下命令：

    pod install

在这之后，你就可以打开工程中的 .xcworkspace 文件然后开始添加远程配置库的依赖。如果你是使用 objective-C 的话，可以这样写：

    @import Firebase;

如果是使用 Swift 的话，可以这样写：

    import Firebase

现在，我们已经在工程项目设置中引入了远程配置库，但还需要配置一个它的实例，从而能在我们的应用中使用远程配置。在这之前，我们需要首先找到 **application:didFinishLaunchingWithOptions:** 方法，在 Objective-C 中，我们可以这样写：

    [FIRApp configure];

同样地，在 Swift 中：

    FIRApp.configure()

最后一步就是创建一个 FIRRemoteCOnfig 类的单例，以便在全应用范围内使用它。在 Objective-C 中，写法如下：

    self.remoteConfig = [FIRRemoteConfig remoteConfig];

在 Swift 中，写法如下:

    self.remoteConfig = FIRRemoteConfig.remoteConfig()

这就是在应用中加入远程配置依赖和设置的所有步骤，接下来我们可以开始准备使用它了！

#### 设定应用中的默认值

接下来我们需要设定一系列应用中配置的默认值，这样做的目的是：

*   我们可能需要在还没有从服务器获取到配置值之前访问配置值。
*   服务器端可能不存在任何配置值
*   设备可能处于不能访问服务器端的状态——比如，离线状态。

我们可以通过 NSDictionay 实例或者在 plist 文件中定义的方法以键值对的形式定义这些默认值。在本例中，我们配置了一个 plist 文件来表示我们的默认配置值：

    
    
    
    
        some_string
        Some string
        has_discount
        
        count
        10
    
    
一旦我们定义好了默认值，我们可以方便地通过使用 **setDefaultsFromPlistFileName** 方法声明这些值为默认值。该方法存在于之前初始化的远程配置库实例中。如果是使用 Objective-C 的话，可以这样写：

    [self.remoteConfig setDefaultsFromPlistFileName:@"DefaultsRemoteConfig"];

下面的是使用 Swift 的写法:

    remoteConfig.setDefaultsFromPlistFileName("DefaultsRemoteConfig")

#### 获取远程配置值

现在我们已经设置好了配置的默认值，之后就可以在应用中立即使用这些值了。在远程配置库的类中，有 4 个可用方法能让我们使用来获取远程的配置值。当前我们只能够获取并存储以下方法返回的数据类型的值，下面是一些示例：

**使用 Objective-C 获取值**

    someString = self.remoteConfig[kSomeStringConfigKey].stringValue;
    someNumber = self.remoteConfig[kSomeNumberConfigKey].numberValue.longValue;
    someData = self.remoteConfig[kSomeDataConfigKey].dataValue;
    someBoolean = self.remoteConfig[kSomeStringConfigKey].boolValue;

**使用 Swift 的版本**

    self.remoteConfig[kSomeNumberConfigKey].numberValue.longValue;
    someData = self.remoteConfig[kSomeDataConfigKey].dataValue;
    someBoolean = self.remoteConfig[kSomeStringConfigKey].boolValue;

**使用 Swift 的版本**

    someNumber = (remoteConfig[someNumberConfigKey].numberValue?.intValue)!
    someString = remoteConfig[someStringConfigKey].stringValue
    someBoolean = remoteConfig[someBooleanConfigKey].boolValue
    someData = remoteConfig[someDataConfigKey].dataValue

#### 获取服务器端的值

现在我们设置好了默认值，接下来我们可以实现从远程获取值的方法。这可以通过远程配置库实例中的 **fetch** 方法轻松实现。

在 **Swift** 中，可以这样获取远程值：

    remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) -> Void in
      if (status == FIRRemoteConfigFetchStatus.success) {
        self.remoteConfig.activateFetched()
      } else {
        // Something went wrong, handle it!
      }
      // Now we can react to the result, if activated then the new    value will be used otherwise it will be the default  value
    } 

同样，使用 **Objective-C** 的写法如下：

    [self.remoteConfig fetchWithExpirationDuration:expirationDuration completionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            [self.remoteConfig activateFetched];
        } else {
            // Something went wrong, handle it!
        }
        // Now we can react to the result, if activated then the new    value will be used otherwise it will be the default  value
    }];

当调用方法时，我们使用了 completionHandler 来接收 **fetch** 方法的回调事件。至此，整个流程已经相当简单：

*   completionHandler 接收一个 **FIRRemoteConfigFetchStatus** 实例。它是一个刚被执行过的异步操作的实例。
*   接下来我们需要检查请求是否成功，需要查看收到的状态值是否与 FIRRemoteConfigFetchStatusSuccessenum 匹配。
*   如果请求成功，则继续。通过 **activeFetched** 方法将返回值设成配置值。 **注意：** 你必须先激活这些返回值，才能在应用中使用它们。
*   如果请求失败, 你需要处理相应的错误请求。


你可能发现了在调用 **fetch() **时传入的 cacheExpiration 参数——这个值声明了一个时间，当缓存的数据在这个时间内时，它们会被分类成未到期状态。所以如果收到的数据缓存没有超过 cacheExpiration 时间，那么这个缓存数据就会被使用。

我们将会在 [Exploring Firebase eBook](http://hitherejoe.us14.list-manage.com/subscribe?u=29201953105285dda07c9fdbf&id=5725aeaf1d) 这本书中更深入地去讲述它。在我们了解如何在 iOS 中做同样的事情之后，我们将学会如果远程改变配置参数。

#### 为远程配置设置服务器端的配置值

至此 firebase 已经全部配置好，可以在应用中使用了，但是我们还没有利用到远程配置，因为还未为服务器端配置任何值！让我们一起来看一下如何在远程配置服务器端的配置值。

**设定服务器端的值**

因为我们已经配置好了客户端，接下来是时候添加服务器端的值，来远程更新我们的应用了！首先，你必须先找到 Firebase 控制台的远程配置页面，可以在这找到它：

https://console.firebase.google.com/project/{YOUR-PROJECT-ID}/config

https://console.firebase.google.com/project/{YOUR-PROJECT-ID}/config

在这个页面中，你将会看到有一个按钮选项，上面写着“开始添加你的远程配置参数”（如果你还没有点击按钮的话），点击这个按钮继续下一步！

![](https://cdn-images-1.medium.com/max/1760/1*fCewZn9r7NJwoPB1PKzNLw.png)

在点击按钮之后，你将会看到一个弹窗，截图如下所示：

![](https://cdn-images-1.medium.com/max/1760/1*FAVU3cQ5sm0UXT_WdAseqQ.png)

这里就是你定义远程配置参数的地方。我们该在这里输入什么呢？

*   **参数键名** — 这个键名是你之前在应用内部定义过的，像上文配置过程中说的那样。可以举一个例子，比如 **has_discount**。
*   **默认值** — 这个值是当客户端获取到之后，首先被采用的值。

如果我们不希望在服务器端给参数分配值，我们可以点击菜单中的 “其它空值” 选项：

*   **没有值** — 这个选项将会让客户端使用已定义的默认值。
*   **空字符串** — 这个选项会返回一个空字符串，表示没有值，客户端中的默认配置值也会被忽略掉。





![](https://cdn-images-1.medium.com/max/1760/1*b7A-ak_PW7W6HG2s-3zB1w.png)





你或许也注意到了**“为场景添加值”**按钮——它可以用作分配一个参数被应用的场景。





![](https://cdn-images-1.medium.com/max/1760/1*2dwEkKx9k2unB0ogenPvPg.png)





如果我们点击**定义一个新的场景**按钮，我们将会看到一个新的窗口，在这可以输入匹配场景的属性：

![](https://cdn-images-1.medium.com/max/1760/1*imvhdLXo6-1ORxjXCMwz-g.png)

在上图可以看到，在创建新场景时的一些设置项：

*   **名字** — 该场景的名字
*   **颜色** — 场景的名字在 firebase 控制台显示时的颜色
*   **应用条件 (属性)** — 必须满足这些属性值，相应的参数才会被应用
*   **应用条件 (参数)** — 对于给定的属性，必须应用的配置参数

当前我们可以设置一条或多条（通过使用**与**按钮）场景属性。目前我们能设置如下场景属性：

*   **应用 ID** — 从被选应用中选择一个 ID ，这个 ID 必须能被包括在应用中，以便可以匹配场景。
*   **应用版本号** — 从被选应用中选择一个版本号，这个版本号必须被包括在应用中，以便可以匹配场景。
*   **操作系统类型** — 选择一个应用实例运行所在的操作系统，当前只能是 Android 或 iOS。
*   **随机用户百分比** — 这是一个随机百分比，用来选择一定量的随机用户来应用给定的参数。这个值可以设置为**大于**或**小于或等于**给定的百分比。
*   **受众用户** — 从 Firebase Analytics 中选择受众来应用给定的参数。
*   **设备所在的地区/国家** — 选择一个运行所选应用的设备所在的地区/国家来匹配场景。
*   **设备语言** — 选择一个运行所选应用的设备中的当前语言来匹配场景。

一旦我们完成以上步骤，就可以使用**创建场景**按钮来完成配置。这之后我们就会看到我们定义参数的清单以及任何应用这些参数的场景，每种场景的应用值都会在场景名字的下方，场景名是用上一步所选择的颜色来表示的，如下图所示：

![](https://cdn-images-1.medium.com/max/1760/1*DpCGi-22CtnVMhe-fTMtvA.png)

在你每次改动配置之后，记得点击**更新**按钮😄。现在，你的应用就可以获取到这些参数了——如果你按上述的每一个章节指导的方法的话。



### 写在最后

我们现在看到了 Firebase 远程配置能做到什么，也知道了怎样在我们的应用中实现远程配置来远程地改变应用的外观，体验以及行为。我希望你能从本文体验到 Firebase 的优势以及简易配置性！

如果你想了解更多关于 Firebase 远程配置和其它方面特性的集成，请记得登录之后订阅我的 Firebase 电子书的发布消息！



![](https://cdn-images-1.medium.com/max/2000/1*adPhI66a3h5h3uX8G0eA1A.png)
