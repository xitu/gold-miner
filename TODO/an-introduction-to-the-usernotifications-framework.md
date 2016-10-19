> * 原文地址：[An Introduction to the UserNotifications Framework](https://code.tutsplus.com/tutorials/an-introduction-to-the-usernotifications-framework--cms-27250)
* 原文作者：[Davis Allie](https://tutsplus.com/authors/davis-allie)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# An Introduction to the UserNotifications Framework




## Introduction

With iOS 10, tvOS 10, and watchOS 3, Apple is introducing a new framework called the UserNotifications framework. This brand new set of APIs provides a unified, object-oriented way of working with both local and remote notifications on these platforms. This is particularly useful as, compared to the existing APIs, local and remote notifications are now handled very similarly, and accessing notification content is no longer done just through dictionaries.

In this tutorial, I'll go through the basics of this new framework and show how you can easily take advantage of it to support notifications for your applications.

This tutorial requires that you are running Xcode 8 with the latest iOS, tvOS, and watchOS SDKs.

## 1. Registering for Notifications

The first step for any app supporting notifications is to request permission from the user. As with previous iOS versions, when using the UserNotifications framework, it is common practice to do this as soon as the app finishes launching. 

Before using any of the UserNotifications APIs, you will need to add the following import statement to any Swift code files that access the framework:  

    import UserNotifications

Next, in order to register your app for notifications, you will need to add the following code to your `AppDelegate`'s  `application(_:didFinishLaunchingWithOptions:)` method:

    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    center.requestAuthorization(options: options) { (granted, error) in
        if granted {
            application.registerForRemoteNotifications()
        }
    }

Initially with this code, we get a reference to the current `UNUserNotificationCenter` object. Next, we configure our `UNAuthorizationOptions` with the notification capabilities we want our app to have. Please note that you can have any combination of options here, for example, just `alert` or both `badge` and `sound`. 

Using both of these objects, we then request authorisation for our app to display notifications by calling the `requestAuthorization(options:completionHandler:)` method on our `UNUserNotificationCenter` instance. The completion handler block of code has two parameters passed into it:

*   A `Bool` value signifying whether or not authorisation was granted by the user.
*   An optional `Error` object which will contain information if, for some reason, the system was unable to request notification authorisation for your app.

You will see that in the above code, if authorisation is granted by the user, we then register for remote notifications. If you want to implement push notifications, this line of code is required. You will also have to do a bit of extra setup for your project, as detailed in this tutorial:

[Setting Up Push Notifications on iOS](https://code.tutsplus.com/tutorials/setting-up-push-notifications-on-ios--cms-21925)

*   

    Apple originally introduced push notifications to enable applications to respond to events if the application isn't running in the foreground. However, the...

    

Please note that registering for remote notifications will invoke the same `UIApplication` callback methods as in previous iOS versions. On success, `application(_:didRegisterForRemoteNotificationsWithDeviceToken:)`  will be called, and `application(_:didFailToRegisterForRemoteNotificationsWithError:)` will be called on failure.

## 2. Scheduling Notifications

For this section of the tutorial, we will be focusing entirely on scheduling local notifications using the UserNotifications framework. The sending of remote push notifications has not changed due to the introduction of this new framework.

A local notification, before being scheduled, is represented by an instance of the `UNNotificationRequest` class. Objects of this type are made up of the following components:

*   Identifier: a unique `String` which allows you to distinguish individual notifications from each other.
*   Content: a `UNNotificationContent` object which contains all the information needed for the display of your notification, including title, subtitle, and app badge number.
*   Trigger: a `UNNotificationTrigger` object which is used by the system to determine when your notification should be "sent" to your app. 

To begin with, we are going to look at the various types of triggers you can set up for local notifications. The `UNNotificationTrigger` class is an abstract class, meaning that you should never create instances of it directly. Instead, you'll use the available subclasses. Currently, the UserNotifications framework provides three for you:

*   `UNTimeIntervalNotificationTrigger`, which allows a notification to be sent a set amount of time after scheduling it.
*   `UNCalendarNotificationTrigger`, which allows a notification to be sent at a specific date and time, regardless of when it was scheduled.
*   `UNLocationNotificationTrigger`, which allows a notification to be sent when the user enters or leaves a designated geographical region.

The following code shows you how you could make a trigger of each type:

    let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0 * 60.0, repeats: false)

    var date = DateComponents()
    date.hour = 22
    let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

    let center = CLLocationCoordinate2D(latitude: 40.0, longitude: 120.0)
    let region = CLCircularRegion(center: center, radius: 500.0, identifier: "Location")
    region.notifyOnEntry = true;
    region.notifyOnExit = false;
    let locationTrigger = UNLocationNotificationTrigger(region: region, repeats: false)

With the above code, the following trigger conditions have been created:

*   The `timeTrigger` will fire one hour after the notification is scheduled. The `timeInterval` parameter passed into the `UNTimeIntervalNotificationTrigger` initialiser is measured in seconds.
*   The `calendarTrigger` will repeatedly fire every day at 10:00 PM. The exact date and time of the trigger firing can easily be changed by modifying other properties of the `DateComponents` object you pass into the `UNCalendarNotificationTrigger` initialiser.
*   The `locationTrigger` will fire when the user comes within 500 metres of the designated coordinate, in this case 40°N 120°E. As you can see from the code, this trigger type can be used for any coordinate and/or region size and can also trigger a notification upon both entering and exiting the region.

Next, we need to create the content for the notification. This is done by creating an instance of the `UNMutableNotificationContent` class. This class must be used as the regular `UNNotificationContent` class has read-only access for the various notification content properties.

The following code shows how the content for a basic notification could be created:

    let content = UNMutableNotificationContent()
    content.title = "Notification Title"
    content.subtitle = "Notification Subtitle"
    content.body = "Some notification body information to be displayed."
    content.badge = 1
    content.sound = UNNotificationSound.default()

If you want a full list of the properties available to you, please take a look at the `UNMutableNotificationContent` [class reference](https://developer.apple.com/reference/usernotifications/unmutablenotificationcontent).

Lastly, we now just need to create the `UNNotificationRequest` object and schedule it. This can be done with the following code:

    let request = UNNotificationRequest(identifier: "LocalNotification", content: content, trigger: timeTrigger)
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            // Do something with error
        } else {
            // Request was added successfully
        }
    }

Initially with this code, we create the request object by passing an identifier, content object and trigger into the initialiser. We then call the `add(_:completionHandler:)` method on the current `UNUserNotificationCenter` object and use the completion handler to perform logic based on whether or not the notification was scheduled properly. 

## 3. Receiving Notifications

When using the UserNotifications framework, processing incoming notifications is handled by an object which you designate conforming to the `UNUserNotificationCenterDelegate` protocol. This object can be anything you want and doesn't have to be the app delegate as in previous iOS versions. One important thing to note, though, is that you must set your delegate before your app has been fully launched. For an iOS app, this means that you must assign your delegate inside either the `application(_:willFinishLaunchingWithOptions:)` or `application(_:didFinishLaunchingWithOptions:)` method of your app delegate. Setting the delegate for user notifications is done very easily with the following code:

    UNUserNotificationCenter.current().delegate = delegateObject

Now with your delegate set, when a notification is received by the app, there are only two methods you need to worry about. Both methods are passed a `UNNotification` object, which represents the notification being received. This object contains a `date` property, which tells you exactly when the notification was delivered, and a `request` property, which is an instance of the `UNNotificationRequest` class mentioned earlier. From this request object, you can access the content of the notification as well as (if needed) the trigger for the notification. This trigger object will be an instance of one of the `UNNotificationTrigger` subclasses mentioned earlier or, in the case of push notifications, an instance of the `UNPushNotificationTrigger` class.

The first method defined by the `UNUserNotificationCenterDelegate` protocol is the `userNotificationCenter(_:willPresent:withCompletionHandler:)` method. This is only called when your app is running in the foreground and receives a notification. From here, you can access the content of the notification and display your own custom interface within your app if needed. Alternatively, you can tell the system to present the notification with a variety of options, as it normally would if your app wasn't running. The available options are:

*   Alert to show the system-generated interface for the notification
*   Sound to play the sound associated with the notification
*   Badge to edit the badge of your app on the user's home screen

 The following code shows an example implementation of the `userNotificationCenter(_:willPresent:withCompletionHandler:)` method:

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        // Process notification content

        completionHandler([.alert, .sound]) // Display notification as regular alert and play sound
    }

The other method defined by the `UNUserNotificationCenterDelegate` protocol is the `userNotificationCenter(_:didReceive:withCompletionHandler:)` method. This method is called when the user interacts with a notification for your app in any way, including dismissing it or opening your app from it. 

Instead of a `UNNotification` object, this method has a `UNNotificationResponse` object passed into it as a parameter. This object contains the `UNNotification` object representing the delivered notification. It also includes an `actionIdentifier` property to determine how the user interacted with the notification. In the case of the notification being dismissed or your app being opened, the UserNotifications framework provides constant action identifiers for you to compare with.

The following code shows an example implementation of the `userNotificationCenter(_:didReceive:withCompletionHandler:)` method:

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

Please note that for both delegate methods, it is essential that you call the completion handler as soon as you are done processing the notification. Once you do, the system then knows you are done with the notification and can perform any needed processes, such as putting the notification in the user's Notification Centre.

## 4. Managing Notifications

Sometimes a user of your application might receive multiple notifications while your app is not running. They might also open your app directly from the home screen and not through a notification. In either of these cases, neither of the `UNUserNotificationCenterDelegate` protocol methods will be called. When working with local notifications, you sometimes may also want to remove a scheduled notification before it is displayed to the user.

Because of this, the UserNotifications framework provides the following methods on the current `UNUserNotificationCenter` instance to work with pending local notifications and delivered notifications that have not yet been processed:

*   `getPendingNotificationRequests(completionHandler:)` provides you with an array of `UNNotificationRequest` objects in the completion handler. This array will contain all the local notifications you have scheduled which have not yet been triggered.
*   `removePendingNotificationRequests(withIdentifiers:)` removes all scheduled local notifications with identifiers contained in the `String` array you pass in as a parameter.
*   `removeAllPendingNotificationRequests` removes all scheduled local notifications for your app.
*   `getDeliveredNotifications(completionHandler:)` provides you with an array of `UNNotification` objects in the completion handler. This array will contain all the notifications delivered for your app which are still visible in the user's Notification Centre.
*   `removeDeliveredNotifications(withIdentifiers:)` removes all delivered notifications with identifiers contained in the `String` array you pass in from the user's Notification Centre.
*   `removeAllDeliveredNotifications` removes all delivered notifications for your app.

## 5. Custom Action Notifications

The UserNotifications framework also makes it easy for your app to take advantage of the custom notification categories and actions introduced in iOS 8. 

Firstly, you need to define the custom actions and categories that your app supports using the `UNNotificationAction` and `UNNotificationCategory` classes respectively. For actions where you want the user to be able to input text, you can use the `UNTextInputNotificationAction` class, which is a subclass of `UNNotificationAction`. Once your actions and categories are defined, you then just need to call the `setNotificationCategories(_:)` method on the current `UNUserNotificationCenter` instance. The following code shows how you could easily register reply and delete actions for a message category notification in your own app:

    let replyAction = UNTextInputNotificationAction(identifier: "com.usernotificationstutorial.reply", title: "Reply", options: [], textInputButtonTitle: "Send", textInputPlaceholder: "Type your message")
    let deleteAction = UNNotificationAction(identifier: "com.usernotificationstutorial.delete", title: "Delete", options: [.authenticationRequired, .destructive])
    let category = UNNotificationCategory(identifier: "com.usernotificationstutorial.message", actions: [replyAction, deleteAction], intentIdentifiers: [], options: [])
    center.setNotificationCategories([category])

Next, when a user uses one of your custom notification actions, the same `userNotificationCenter(_:didReceive:withCompletionHandler:)` method that we covered earlier is called. In this case, the action identifier of the `UNNotificationResponse` object passed in will be the same as the one you defined for your custom action. It is also important to note that, if the user interacted with a text input notification action, then the response object passed into this method will be of type `UNTextInputNotificationResponse`.

The following code shows an example implementation of this method, including logic for the actions created earlier:

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

Additionally, if you want to take advantage of custom actions for your local notifications, then you can simply set the `categoryIdentifier` property on your `UNMutableNotificationContent` object when creating the notification.

## Conclusion

The new UserNotifications framework provides fully functional and easy-to-use object-oriented APIs for working with local and remote notifications on iOS, watchOS, and tvOS. It makes it very easy to schedule local notifications for a variety of scenarios as well as greatly simplifying the whole flow of processing incoming notifications and custom actions.

As always, please be sure to leave your comments and feedback in the comments below. And check out some of our other articles and tutorials about new features in iOS 10 and watchOS 3!



