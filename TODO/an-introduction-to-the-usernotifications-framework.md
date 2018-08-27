> * 原文地址：[An Introduction to the UserNotifications Framework](https://code.tutsplus.com/tutorials/an-introduction-to-the-usernotifications-framework--cms-27250)
* 原文作者：[Davis Allie](https://tutsplus.com/authors/davis-allie)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Danny Lau](https://github.com/Danny1451)
* 校对者：[Nicolas(Yifei) Li](https://github.com/yifili09), [肘子涵](https://github.com/zhouzihanntu)


# UserNotifications Framework 入门介绍



## 简介


随着 iOS 10, tvOS 10, 和 watchOS 3 的发布， 苹果正在引入一个新的叫做 UserNotifications 的 framework。这个全新的 API 集合提供了一种统一的面向对象的

方式在这些平台上使用本地和远程的通知。相比目前的 API 会格外好用，本地和远程通知的处理方式很相似，并且访问通知内容不再仅通过字典型数据类型。

在这个教程中，我将遍历一遍这个新的 framework 的基础并且展示如何便捷的它的优点来为你的应用增加通知功能。

这个教程要求使用包含最新 iOS, tvOS, 和 watchOS 的 SDK 的 Xcode8 。

## 1. 注册通知

对任何需要通知的应用来说，第一步就是向用户请求权限。在之前的 iOS 版本中，在使用 UserNotifications 的 framework 的时候，通常是在应用刚刚启动完之后就执行这一步操作。 

在使用任何 UserNotifications 的 API 之前，你必须在需要使用这个 framework 的 Swift 代码文件里增加下面这个导入声明

    import UserNotifications

接下来，为了给你的 app 注册通知，你需要在你的 `AppDelegate` 中的 `application(_:didFinishLaunchingWithOptions:)` 方法中增加如下代码：

    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    center.requestAuthorization(options: options) { (granted, error) in
        if granted {
            application.registerForRemoteNotifications()
        }
    }

通过这个代码，我们得到了当前 `UNUserNotificationCenter` 的对象的引用。下一步，我们根据我们应用需要的通知能力来配置 `UNAuthorizationOptions` 。请注意在这里可以任意组合以上的选项，比如只有 `alert` ，或者同时有 `badge` 和 `sound` 。

通过使用这些对象，我们接下来通过调用 `UNUserNotificationCenter` 实例中的 `requestAuthorization(options:completionHandler:)` 方法向我们的 app 申请展示通知的认证。这个 handler 的 block 会回传两个参数

*   一个代表是否得到的用户授权的 `Bool` 值。
*   在某些情况下，系统不能为你的应用请求通知的认证时，会返回一个包含错误信息的 Error 对象。

你可以在上面的代码中看到，如果授权被用户授予的话，我们可以接下来注册远程通知。如果你需要使用推送通知的话，就需要这行代码。同时你也需要为你的项目多配置几步，详见这篇教程：
[Setting Up Push Notifications on iOS](https://code.tutsplus.com/tutorials/setting-up-push-notifications-on-ios--cms-21925)

*   

    苹果原先引入推送通知的目的是使应用如果不在前台的话可以响应事件，可是...
    

请注意注册远程推送会调用之前 iOS 版本相同的 `UIApplication` 的回调方法。成功的话， `application(_:didRegisterForRemoteNotificationsWithDeviceToken:)`，这个方法会调用，失败的话 `application(_:didFailToRegisterForRemoteNotificationsWithError:)`会被调用。

## 2. 发送通知

在这一节的教程里，我们主要集中在通过使用 UserNotifications framwork 来实现发送本地推送。在这个 framework 的介绍中，发送远程推送通知的方法并没有改变。

一个本地推送在发送之前，通常是由一个 `UNNotificationRequest` 实例来代表的。这种类型的对象通常由下面几个元素组成：
*   Identifier（识别符）：一个唯一让你去区分不同通知的 `String` 字符串。
*   Content（内容）: 一个包含所有通知需要展示的信息的 `UNNotificationContent` 对象，包括标题，子标题和应用的标记数.
*   Trigger（触发器）:一个系统用来确定什么时候该发送你的通知给你的应用的 `UNNotificationTrigger` 对象。

首先，我们将看一下那些可以用来创建本地推送的不同种类的触发器。`UNNotificationTrigger` 类是个抽象类，意味着你不能直接创建它的实例。所以你只能使用那些可以用的子类。目前，UserNotifications 的framework提供了下面三种：

*   `UNTimeIntervalNotificationTrigger`, 能够在一定时间后触发发送通知。
*   `UNCalendarNotificationTrigger`, 能在特定日期和时间的触发发送通知，不管通知是什么时候创建的。
*   `UNLocationNotificationTrigger`, 能够在用户到达或者离开某个设计好的地理位置触发，发送通知。

下面的代码展示了如何生成各个类型的触发器：

    let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0 * 60.0, repeats: false)

    var date = DateComponents()
    date.hour = 22
    let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

    let center = CLLocationCoordinate2D(latitude: 40.0, longitude: 120.0)
    let region = CLCircularRegion(center: center, radius: 500.0, identifier: "Location")
    region.notifyOnEntry = true;
    region.notifyOnExit = false;
    let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)

通过上面的代码，可以生成以下条件的触发器：

*   `timeTrigger` 会在通知发送后的一个小时之后触发。 `timeInterval` 参数在 `UNTimeIntervalNotificationTrigger` 构造的时候以秒级别传入。
*   `calendarTrigger`  将会在每天 10:00PM 触发。预定的日期和时间可以在 `UNCalendarNotificationTrigger` 构造函数里通过改变传入的 `DateComponents`  这个对象的配置来轻松的改变。
*   `locationTrigger` 在用户到达指定坐标的 500 米内会触发，在这个例子里面是 40°N 120°E。从代码中可以看到，这类触发器可以使用任何坐标，或者任何区域大小，而且可以同时在进入和离开指定区域时触发通知。

下一步，我们需要创建通知的内容。这个通过创造一个 `UNMutableNotificationContent`类的对象实例来实现。这个类必须像常用的 `UNNotificationContent` 类一样使用，对大量的通知内容只有可读的权限。

下面的代码展示了如何创建一个基础通知需要的内容：

    let content = UNMutableNotificationContent()
    content.title = "Notification Title"
    content.subtitle = "Notification Subtitle"
    content.body = "Some notification body information to be displayed."
    content.badge = 1
    content.sound = UNNotificationSound.default()

如果你想要一个可用的属性列表，可以看一下 `UNMutableNotificationContent` [class reference](https://developer.apple.com/reference/usernotifications/unmutablenotificationcontent).

最后，我们现在只需要创建 `UNNotificationRequest` 对象并且发送它，可以通过下面的代码实现：

    let request = UNNotificationRequest(identifier: "LocalNotification", content: content, trigger: timeTrigger)
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            // Do something with error
        } else {
            // Request was added successfully
        }
    }

有了这些代码，我们通过传递一个标示，内容对象和触发器给构造函数来创建了请求对象。接下来我们调用当前的 `UNUserNotificationCenter` 对象中的 `add(_:completionHandler:)` 方法，然后使用完成的 handler 来实现是否成功计划发送通知之后的逻辑。

## 3. 接收通知

当使用 UserNotifications framework 的时候，处理收到消息的是一个实现了 `UNUserNotificationCenterDelegate` 协议的对象。这个对象可以是你想要的任何对象，并不是像之前的 iOS 版本，一定要是应用的代理。另一个需要注意的是，你必须在你的应用完全启动之后才能设置代理。对一个 iOS 应用来说，这个意味着你必须在你的应用的代理中除了 `application(_:willFinishLaunchingWithOptions:)` 和 `application(_:didFinishLaunchingWithOptions:)` 这两个方法中来给代理赋值。通过下面的代码可以非常容易的实现给用户通知设置代理：

    UNUserNotificationCenter.current().delegate = delegateObject

随着你的代理的设置，当应用收到了一个通知时，有两个方法你需要担心的。两个方法都会传一个 `UNNotification` 的对象，它代表了通知已经收到。这个对象包含了一个 `date` 参数，代表了这个通知什么时候发送的，和一个 `request` 参数，就是之前的 `UNNotificationRequest` 对象的实例。通过这个请求对象，你可以获取到通知的内容和触发器（如果需要的话）。这个触发器是之前说的 `UNNotificationTrigger` 子类的其中之一，或者在推送通知的情况下，是 `UNPushNotificationTrigger` 类的实例。

在 `UNUserNotificationCenterDelegate` 协议中第一个定义的方法是 `userNotificationCenter(_:willPresent:withCompletionHandler:)` ，这个只有在你的应用在前台收到消息时调用。你可以获取通知的内容并且当需要时在你的应用内展示你自定义的交互界面。或者，当你的应用不在运行时，你可以通过一些配置让系统进行消息推送，下面是可选项：

*   Alert 弹出系统生成的通知交互界面
*   Sound 播放伴随通知的提示音
*   Badge 来编辑用户主页上你的应用的标记数

 下面代码展示了一个 `userNotificationCenter(_:willPresent:withCompletionHandler:)` 实现的例子：

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        // Process notification content

        completionHandler([.alert, .sound]) // Display notification as regular alert and play sound
    }

另外一个 `UNUserNotificationCenterDelegate` 协议定义的方法是 `userNotificationCenter(_:didReceive:withCompletionHandler:)` 。这个方法是当用户对你应用通知进行交互时调用，包括消除它或者通过它打开你的应用。 

这个方法会传入一个 `UNNotificationResponse` 对象，而不是 `UNNotification` 对象。这个对象包含了 `UNNotification` 对象代表了发送的通知。它还包含了一个 `actionIdentifier` 参数来区分用户是如何与这个通知交互的。UserNotifications framework 提供了动作常量给你比对，来区分通知是消失了还是你的应用被打开了。

下面的代码展示了一个`userNotificationCenter(_:didReceive:withCompletionHandler:)` 方法实现的例子：

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier

        switch actionIdentifier {
        case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
            // Do something
            completionHandler()
        case UNNotificationDefaultActionIdentifier: // App was opened from notification
            // Do something
            completionHandler()
        default:
            completionHandler()
        }
    }

请注意对这个两个函数来说，你必须在处理完通知之后调用 handler 。一旦你调用了，系统就会知道你已经用完这个通知了并且可以执行任何需要的进程了，比如把通知放到用户的 Notification 中心。

## 4. 管理通知

时候，你的应用的一个用户会在应用不在运行的时候收到很多条通知。他们可能也会在主页直接打开你的应用，而不是通过一个通知。在上述任何一个情况下，没有一个 `UNUserNotificationCenterDelegate` 协议的方法会被调用。当使用本地通知的时候，你有时也会想在展示给用户之前移除一个通知。

因此， UserNotifications framework 在当前 `UNUserNotificationCenter` 的实例中提供了以下的方法来操作待定的本地通知和收到却还未处理的通知。

*   `getPendingNotificationRequests(completionHandler:)` 在处理器里提供了一个 `UNNotificationRequest` 对象的数组。这个数组包含了所有你计划了却还没触发的本地通知。
*   `removePendingNotificationRequests(withIdentifiers:)` 移除所有包含你传进去的`String`数组中对象的标示的本地通知。
*   `removeAllPendingNotificationRequests` 移除你应用所有的本地通知。
*   `getDeliveredNotifications(completionHandler:)` 在处理器里提供了一个 `UNNotificationRequest` 对象的数组。这个数组包含了所有你收到了还在用户中心显示的通知。
*   `removeDeliveredNotifications(withIdentifiers:)` 在用户中心中移除所有包含你传进去的`String`数组中对象的标示的收到的通知。
*   `removeAllDeliveredNotifications` 移除你应用所有收到的通知。

## 5. 自定义动作通知

UserNotifications framework 也让你可以更好的使用在 iOS8 中引入的自定义通知拓展和动作。

首先，你需要分别定义你应用支持 `unnotificationaction` 和 `unnotificationcategory` 类的自定义的动作和拓展。比如你想让用户可以输入文字的动作，你可以使用 `UNTextInputNotificationAction` 类，它是 `UNNotificationAction` 的子类。一旦你的动作和拓展定义好了，你只需要在当前的 `UNUserNotificationCenter` 的实例中调用 `setNotificationCategories(_:)` 方法。下面的代码展示了，如何简单地在你应用中为消息类型注册回复和删除动作：


    let replyAction = UNTextInputNotificationAction(identifier: "com.usernotificationstutorial.reply", title: "Reply", options: [], textInputButtonTitle: "Send", textInputPlaceholder: "Type your message")
    let deleteAction = UNNotificationAction(identifier: "com.usernotificationstutorial.delete", title: "Delete", options: [.authenticationRequired, .destructive])
    let category = UNNotificationCategory(identifier: "com.usernotificationstutorial.message", actions: [replyAction, deleteAction], intentIdentifiers: [], options: [])
    center.setNotificationCategories([category])

接下来，当用户使用你的一个自定义动作地时候，之前我们提到的 `userNotificationCenter(_:didReceive:withCompletionHandler:)` 相同的方法会被调用。在这个例子里，这个传入的 `UNNotificationResponse` 对象的动作标示将和你之前定义的自定义动作相同。这个需要注意的是，如果用户通过一个文字输入的通知动作交互的话，方法中传入的响应对象会是 `UNTextInputNotificationResponse` 类型的。

下面的代码展示了一个实现这个方法的例子，包括了之前创建动作的逻辑：

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let actionIdentifier = response.actionIdentifier
        let content = response.notification.request.content

        switch actionIdentifier {
        case UNNotificationDismissActionIdentifier: // Notification was dismissed by user
            // Do something
            completionHandler()
        case UNNotificationDefaultActionIdentifier: // App was opened from notification
            // Do something
            completionHandler()
        case "com.usernotificationstutorial.reply":
            if let textResponse = response as? UNTextInputNotificationResponse {
                let reply = textResponse.userText
                // Send reply message
                completionHandler()
            }
        case "com.usernotificationstutorial.delete":
            // Delete message
            completionHandler()
        default:
            completionHandler()
        }
    }
另外，如果你想好好利用本地通知的优点的话，你可以简单的在创建通知的时候在你的 `UNMutableNotificationContent` 对象上设置 `categoryIdentifier` 属性。

## 结论

新的 UserNotifications framework 提供了全面并且使用简单的 面向对象的 API 来操作在 iOS，watchOS 和 tvOS 中本地和远程通知。这使得它可以简洁的安排不同情境下的本地通知，同时也简化了处理通知和自定义动作的整个工作流程。

与往常一样，请务必在下面留下你的评论和反馈，并看下我们的其他关于 iOS 10 和 watchOS3 新特点的文章和教程。 
UserNotifications framework 也让你可以更好的使用在 iOS8 中引入的自定义通知拓展和动作。
