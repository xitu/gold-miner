> * 原文地址：[Exploring Firebase on Android & iOS: Analytics](https://medium.com/exploring-android/exploring-firebase-on-android-ios-analytics-8484b61a21ba#.b0hgigy3r)
* 原文作者：[Joe Birch](https://medium.com/@hitherejoe)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Exploring Firebase on Android & iOS: Analytics








Firebase is an exciting new collection of services that I’ve been reading up on and experimenting with. In this new series of articles, we’ll be covering the features of firebase to learn exactly what we can do with each integration. In this chapter, we’re going to be taking a look at **Firebase Analytics **— the integration that allows us to begin tracking user and application data in just a few steps.











* * *







Analytics are crucial to learning more about both your application and your users. Tracking events allows you to learn things such as what works in your app, what users may not know exists, the paths users are exploring in their journey through your app and what choices are being made when presented with options. Learning from this data can not only help you to improve the user experience provided by your app, but it can also help you to increase any revenue you may make from your app and also learn about what works for future features and improvements.

Firebase Analytics is a tool which allows you to do exactly that — it helps us to learn how our Android and iOS users are engaging with our application. From setup, it’ll automatically begin tracking a defined set of events — meaning we can begin learning from the very first step. And if that isn’t enough, then we can add our own custom events that we can track. All of these events are then viewable through the Firebase Dashboard within the Firebase Console — our central point of access for analytics reports and other firebase services.

Once we’ve tracked and analysed this data, we can can make decisions on future changes to our app to better the users experience. And if that wasn’t enough, Firebase Analytics Integrates with **Firebase Crash Reporting** to create audiences for users who have experienced tracked crashes, **Firebase Notifications** to send notifications to audiences and track events based on notification interactions, **Firebase Remote Config** to change the look / feel and behaviour of our application based on Audiences, **BigQuery** to perform advanced data analysis on our tracked events and **Google Tag Manager** to our Firebase Analytics setup remotely from an alternative web application.











* * *







I’m also releasing a full eBook that will act as a practical guide to integrating firebase features, which will feature more detailed guides on each section of the Firebase suite 🙂 For analytics, in the book we’ll be taking a deeper look into analytics tracking and the firebase console. Click the image below to be alerted when it’s out!













![](https://cdn-images-1.medium.com/max/2000/1*frcwQV3MRhXAlm76fYKs5g.png)















* * *







### What makes it different from Google Analytics?

One of the first things that came to my mind when I read about Firebase Analytics was, “What about my Google Analytics setup?”. So if you already have Google Analytics in place, then why would you make the switch to Firebase Analytics? Well, here’s a couple of differences between the two:

**Audiences**

We can use Firebase Analytics to create Audiences — these are groups of users that we can then interact with using other Firebase service such as Firebase Notifications and / or Firebase Remote Config.

**Integration with other Firebase Services**

An awesome thing with Firebase Analytics is that we can integrate other Firebase services with analytics. For example, creating an Audience of users who have experienced a crash reported through Firebase Crash Reporting.

**Lower Method Count**

The Google Analytics dependency on Android has a total count of 18,607 methods and has a total of 4kb used for dependancies. On the other hand, Firebase Core (for Analytics) has a method count of 15,130 and only 1kb used for dependancies.

**Automatic Tracking**

When we add the firebase core dependency, it will automatically begin tracking a collection of user engagement events and device information for us — this is useful if you’re looking to only collect the minimal data for your app.

**Unlimited Reporting**

For up to 500 events, Firebase Analytics provides us with unlimited reporting straight out of the box for free!

**No Singleton Initialisation**

When setting up Google Analytics on Android we are required to initialize a Singleton instance. Firebase Analytics are simply available by fetching the instance directly from where we wish to track data. This isn’t much effort obviously but just makes the setup flow slightly easier.

**Single Console**

All of the data for every Firebase service is available for a single console. That makes it both easier and quicker for us to navigate from checking the analytic stats for our app to viewing the latest crash reports.











* * *







### What can we track?

The firebase SDK provides a collection of commonly used events in the form of predefined constants that can be used when tracking events. If you are only performing simple tracking, then the predefined events should cover your needs. On the other hand, using custom event names allows you to track events that are specific to your app and will allow for a deeper analytical understanding when it comes to the reports created from your tracking.

As previously mentioned, Firebase Analytics will automatically begin tracking events for us once we’ve added the core dependency — these are:

*   **first_open** — This event is tracked when the user launches the app for the first time after either installing or re-installing it. Note, this does not represent the number of downloads for the application.
*   **in_app_purchase** — This event is tracked whenever the user carries out an in-app purchase through either Google Play or iTunes. When tracking, the even used the name and ID other product, along with the quantity of the product and the currency used to complete the purchase.
*   **user_engagement** — This event tracks user engagement with the application, essentially whilst the app is foregrounded.
*   **session_start** — This event is tracked when the user has engaged with the app for a minimum given time to satisfy the required start length for a session to begin.
*   **app_update** — This event is tracked when the user updates the app to a newer version and re-launches the app. When tracked, the previous version of the app is sent as a parameter — this is used to show the gap between updating versions.
*   **app_remove** — This event is tracked when the user removes an installed application package or uninstalls the application through their devices application manager.
*   **os_update** — This event is tracked when the user updates the operating system on their device. When tracked, the previous version of the OS is sent as a parameter.
*   **app_clear_data** — This event is tracked when the user either clears or reset the application data for the tracked app on their device.
*   **app_exception** — This event is tracked when the app either throws some form of exception or crashes.
*   **notification_foreground** — This event is tracked when the app is in the foreground and a notification is received that was sent using Firebase Notifications.
*   **notification_receive** — This event is tracked when the app is in the background and a notification is received that was sent using Firebase Notifications. Note, this event is only tracked on Android devices.
*   **notification_open** — This event is tracked when a notification is opened and was sent using Firebase Notifications.
*   **notification_dismiss** — This event is tracked when a notification is dismissed and was sent using Firebase Notifications.
*   **dynamic_link_first_open** — This event is tracked when the the app is launched for the first time by the use of a dynamic link.
*   **dynamic_link_app_open** — This event is tracked when the the app is launched with the use of a dynamic link.
*   **dynamic_link_app_update** — This event is tracked when the the app is updated with the use of a dynamic link. Note, this event is only tracked on Android devices.

We can also track custom events for our application. Firebase provides a list of custom events that we may wish to use from categories such as:

*   [All Applications](https://support.google.com/firebase/answer/6317498?hl=en&ref_topic=6317484)
*   [Retail / Ecommerce](https://support.google.com/firebase/answer/6317499?hl=en&ref_topic=6317484)
*   [Jobs, Education, Local Deals, Real Estate](https://support.google.com/firebase/answer/6375140?hl=en&ref_topic=6317484)
*   [Travel](https://support.google.com/firebase/answer/6317508?hl=en&ref_topic=6317484)
*   [Games](https://support.google.com/firebase/answer/6317494?hl=en&ref_topic=6317484)

Other than these, we can also define our own within our app. We’ll look at how we can do this over the next few sections!











* * *







### Getting setup

Getting setup to use Firebase is super easy. We first need to begin by adding our application to the [Firebase Console here](https://console.firebase.google.com/). Once we’ve done so, we can add the core firebase dependancy to our project to automatically begin tracking events from our application usage. Let’s get started!

### Getting setup on Android

**Add the Core Dependency**

The Firebase Analytics functionality is found within the core firebase dependancy. So to begin tracking analytics events in our application, we need to begin by adding the firebase analytics dependency to our **build.gradle** file.

    compile 'com.google.firebase:firebase-core:9.4.0'

**Retrieving the Analytics instance**

Once we’ve added this dependency, our application will automatically begin tracking default events from our application for things such as opening the app, device information, region and other standard data.

    private FirebaseAnalytics firebaseAnalytics;

Now we’ve added the dependency, we can go ahead and make use of its classes, here we’ll be using the FirebaseAnalytics class to track analytics events. We need to begin by declaring this object in the class that we wish to use it (for example, this could be an activity or a fragment).

    firebaseAnalytics = FirebaseAnalytics.getInstance(this);

Then once that’s been declared, we can fetch the FirebaseAnalytics instance from within the onCreate() method of our Activity / Fragment.

You’ll need to retrieve this instance wherever you wish to send events to Firebase from. If you’re using dependency injection, then you could simplify this a bit — for example using Dagger 2:

    @Provides
    FirebaseAnalytics providesFirebaseAnalytics() {
        return FirebaseAnalytics.getInstance(activity);
    }

Then, wherever we wish to use the FirebaseAnalytics instance, we can do so by simply injecting an instance into our desired class like so:

    @Inject FirebaseAnalytics firebaseAnalytics;











* * *







### Getting setup on iOS

**Add the Core Dependency**

The Firebase Analytics functionality is found within the core firebase dependancy. So to begin tracking analytics events in our application, we need to add the firebase analytics dependency to our **Podfile**.

    pod ‘Firebase/core’

Once added, be sure to remember to run the following command to install the dependency:

    pod install

Almost there! We then need to import the dependency so that we can begin using it in our application. To do this, we need to add the import statement to our .xcworkspace file.

In Objective-C:

    @import Firebase;

In Swift:

    import Firebase

**Configure the Analytics instance**

Once we’ve added this dependency to our **podfile**, we need to configure the Firebase Analytics instance. Once this has been done, our application will automatically begin tracking default events from our application for things such as opening the app, device information, region and other standard data.

We can do this in Objective-C like so:

    [FIRApp configure];

And in Swift:

    FIRApp.configure()











* * *







### Tracking events on Android

Now we have access to the FirebaseAnalytics class, we can use to track events within our application. We track events using the **logEvent()** method provided by the Firebase SDK. This method takes two parameters:

*   **name** — A String representing the name of the event. This name is **case sensitive** and can be up to 32 characters in length and consist of only letters and underscores. **Note:** The name must begin with a letter.
*   **params** — A Bundle object that contains a collection of parameters that are to be tracked in relation to the named event. Parameter names can be up to 24 characters in length and just like the names, they can only be made up of alphabetic characters and underscores, as well as start with a letter. Parameter values can be of the types String, long or double and can be no longer than 36 characters in length.

We can track an event without sending any parameters by simply calling the logEvent() method with the event name, and simply passing in null for the parameters.

    firebaseAnalytics.logEvent(“checkout_complete”, null);

However, if we wish to send parameters along with our event then we can so by packaging it up into a Bundle instance. This allows us to send multiple parameters in a singular object.

    Bundle bundle = new Bundle();

    bundle.putString(“item_purchased”, “Pizza”);

    bundle.putInt(“item_quantity”, 1);

    firebaseAnalytics.logEvent(“checkout_complete”, bundle);

Once we call the **logEvent()** method, our event is tracked and sent to firebase on behalf of the firebase SDK.











* * *







### **Tracking Events on iOS**

Now we have access to the FirebaseAnalytics class, we can use to track events within our application. We track events using the **logEvent()** method provided by the Firebase SDK, this method takes two parameters:

*   **name** — A String representing the name of the event. This name is **case sensitive** and can be up to 32 characters in length and consist of only letters and underscores. **Note:** The name must begin with a letter.
*   **params** — A Bundle object that contains a collection of parameters that are to be tracked in relation to the named event. Parameter names can be up to 24 characters in length and just like the names, they can only be made up of alphabetic characters and underscores, as well as start with a letter. Parameter values can be of the types String, long or double and can be no longer than 36 characters in length.

For example say we want to track when the user shares a piece of content through our app:

    [FIRAnalytics logEventWithName:Share parameters:@{

        kFIRParameterContentType:@”Facebook article”,

        kFIRParameterId:@”01234”

    }];

All provided events and parameters are defined in the **FIREventNames.h**header file and **FIRParameterNames.h** header files. However, if we wish to track out own custom events or parameters we can do so by defining our own event and parameter names within our application — this allows us to track more customised events specific to our application. Custom event names gives us more flexibility to track events that are not already defined in the FIREventNames.h header file, whilst custom parameters allow us to track properties related to these events that may not already be defined within the **FIREventParameters.h** file. We can track custom events and parameters like so:

    [FIRAnalytics logEventWithName:@”share_facebook” parameters:@{

        @”article_name”: articleName,

        @”shared_by”: username,

        @”article_id”: articleId

    }];

**Verbose Logging on Android**

Enabling verbose logging allows to check that both our automatic and manual events are being logged correctly by the firebase SDK. We can enable verbose logging fairly easily by entering the following **adb** commands into the terminal:

    adb shell setprop log.tag.FA VERBOSE

    adb shell setprop log.tag.FA-SVC VERBOSE

    adb logcat -v time -s FA FA-SVC

Once you’ve enabled this, you can run the debug build of your app and perform actions that trigger analytic events. When events are triggered, you should see them appear in your terminal console, as shown below:









![](https://cdn-images-1.medium.com/max/1600/1*rI8XxWJAMWSV3IxIAAHuBw.png)



Logging events into the terminal



If you can’t see events being logged, be sure to check that you’re correctly calling the **logEvent()** method as discussed on the previous page!

**Verbose Logging on iOS**

To ensure that our events are being tracked correctly, we can debug our Firebase Analytics events easily within xcode itself — it’s always good practice to do so as events can take several hours to be appear within the firebase console. To enable debugging within xcode:

*   You need to begin by opening up the **Edit scheme** window. This can be done by navigating to **Product** > **Scheme** and selecting the **Edit** **scheme**option from the dropdown.
*   Next, on the left hand side you will need to select the **Run** option from the menu.
*   Then, select the tab labelled **Arguments** within the **Run** window that you just opened.
*   Finally, within the section labelled **Arguments Passed on Launch** you’ll need to add:

    -FIRAnalyticsDebugEnabled

This is essentially a flag to notify the SDK to log out any analytics events to the console.











* * *







### User Properties

User properties allow us to track data that is specific to the users who are engaging with our app. This allows us to keep a track of data that is not specifically associated with our application itself, but more focused on the users. Just like events, the Firebase SDK automatically tracks a collection of different user properties for use. These are:

*   **App Version** — The version of the app that the user has installed on their device. On android this tracks the versionName and on iOS the Bundle version is used.
*   **Device Model** — The model of the device that the application is installed on. This is the device model name, so for example iPhone 6s, or SM-G9300.
*   **Gender** — The gender of the user using the app on the installed device.
*   **Age** — The age of the user using the app on the installed device. This falls into either: 18–24, 25–34, 35–44, 45–54, 55–64 or 65+
*   **Interests** — The categorized interests of the user using the app on the installed device.
*   **OS Version** — The version of the OS running on the device. Generally in a numerical format such as 6.0 or 9.3.1.
*   **New / Established** — Two values representing timed usage of the app. **New** is when the user began using the app with the last 7 days, whereas **established** is where the user began using the app more than 7 days ago.

**Adding a new user property**

However, we’re not restricted to using these properties alone — we can define our own custom user properties from within the firebase console. We can do this by navigating to **User Properties** tab, and selecting the **New User Property** button.









![](https://cdn-images-1.medium.com/max/1600/1*mRXwy1QL936bFf9DqbVe6A.png)





Once you’ve selected that button, you’ll be displayed with a pop-up window that will allow you to enter the details for a new User Property. Here you’ll enter:

*   **User property name** — The name used to identify the user property. This should be in lowercase letters, with words separated by underscores instead of spaces.
*   **Description** — A short (maximum 150 characters) description of what the property is used for. This should be simple yet descriptive, so that both yourself and possibly others can easily understand what the property represents in the future.









![](https://cdn-images-1.medium.com/max/1600/1*blLCcbcFLOzlesPBsQ9BEg.png)





**Setting User Properties on Android**

Tracking user properties within our android app is done in a similar way to the way that we track events. Once we’ve registered the property within the firebase (as detailed in the previous section), it’s as simple as making a call to the **setUserProperty()** method from the Firebase SDK. This method takes two parameters, these are the **User Property Name** and the **User Property Value** which we wish to set for the given property.

    firebaseAnalytics.setUserProperty(
               “favourite_film_genre”, filmGenre);

Once tracked, we will be able to view the tracked User Properties from within the Firebase console. Remember that you’ll need to wait a few hours for the data displayed in the console to update.

**Setting User Properties on iOS**

Tracking user properties within our android app is done in a similar way to the way that we track events. Once we’ve registered the property within the firebase (as detailed in the previous section), it’s as simple as making a call to the **setUserPropertyString()** method from the Firebase SDK. This method takes two parameters, these are the **User Property Name** and the **User Property Value** which we wish to set for the given property.

In Objective-C, we can do this like so:

    [FIRAnalytics setUserPropertyString:filmGenre       
                                  forName:@”favourite_film_genre”]

And in Swift we can do this like so:

    FIRAnalytics.setUserPropertyString(filmGenre   
                                  forName:”favourite_film_genre”)











* * *







### And that’s it!

So we’ve seen what we can do with Firebase Analytics and how to implement it into our application to begin tracking events. I hope from this you’ve been able to see the benefits of Firebase and how super easy it is to get setup!

And if you wish to learn more about Firebase analytics and other integrations, please do remember to sign-up to be alerted when my Firebase eBook is out! ![🚀](https://linmi.cc/wp-content/themes/bokeh/images/emoji/1f680.png)







