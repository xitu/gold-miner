> * 原文地址：[Exploring Firebase on Android & iOS: Remote Config](https://medium.com/@hitherejoe/exploring-firebase-on-android-ios-remote-config-3e1407b088f6#.hb0blxber)
* 原文作者：[Joe Birch](https://medium.com/@hitherejoe)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Exploring Firebase on Android & iOS: Remote Config


Remote config is a feature of Firebase suite that allows us to alter both the look and feel of our application without the need to publish any updates to the Google Play or App store. This works by allowing us to define in-app parameters that can be overridden from within the firebase console — these parameters can then be activated for either all or a defined selection of users.

This powerful feature gives us a range of new abilities when it comes to immediate updates, temporary changes or testing new features amongst users. Let’s take a dive and learn the what, why and how of Remote Config so we can learn how to use it to benefit both ourselves and our users 🚀







Don’t forget to check out the previous article in this series:

*   [**Exploring Firebase on Android & iOS: Analytics**](https://medium.com/exploring-android/exploring-firebase-on-android-ios-analytics-8484b61a21ba#.dgyq5cpoq)









I’m also releasing a full eBook that will act as a practical guide to integrating firebase features, which will feature more detailed guides on each section of the Firebase suite. For Remote Config, in the book we’ll be taking a deeper look into the firebase console, integration of Remote Config and use of it in real-world application. Click the image below to be alerted when it’s out! 🙂







![](https://cdn-images-1.medium.com/max/2000/1*adPhI66a3h5h3uX8G0eA1A.png)







### What can we do with Firebase Remote Config?

So in a nutshell, Remote config essentially allows us to publish updates to our users immediately. Whether we wish to change the colour scheme for a screen, the layout for a particular section in our app or show promotional / seasonal options — this is completely doable using the server side parameters without the need to publish a new version.

We can even do this for a selected group of users, allowing us to change our chosen parameter for segmented users, application versions, Audience groups from Firebase Analytics, user language and more. This gives us extremely flexible control over who sees these changes. Alongside these, we can also use Remote Config to A/B test our changes with random percent targeting from Firebase Analytics or even feature switch when shipping new components within our application.

Remote Config gives us the power to:

*   Quickly and easily update our applications without the need to publish a new build to the app / play store. For example, we could easily switch out a rebuild of a component in our application for a select set of users based on the conditions that we specify.
*   We can effortlessly set how a segment behaves or looks in our application based on the user / device that is using it. For example, we may wish to switch out a component for users in Europe than one that may be shown for users in the US.
*   Following on from the above, we can use Remote Config to A/B test parts of our applications with a defined set of users before you decide to release something to your entire user base.

### Remote Config Process Flow

Remote Config works by primarily using in-app defined values to decide how the it is you’re configuring is to be configured. Then using the Firebase Console we can alter the values of these remotely, which will then cause the configuration to be changed for our defined set of users. Remote Config itself essentially only requires four simple steps in it’s setup and maintenance flow:

![](https://cdn-images-1.medium.com/max/1760/1*SXNQ6ctxBmtbjCAMIgkgeg.png) ![](https://cdn-images-1.medium.com/max/1760/1*NCvGAEVq7Pl8qHfs3bX4DQ.png) ![](https://cdn-images-1.medium.com/max/1760/1*m8-3ewgI5cX3NdrJPInd_w.png) ![](https://cdn-images-1.medium.com/max/1760/1*SQAXrF83xkWMCSl0onqRnw.png)

### Parameters, Rules and Conditions

Within Remote Config we define key-value pairs which are known as **parameters**. These **parameters** are then used to define the configuration values that are to be used within our app — such as the colour of a component, the text to be displayed in a view or even using a property of the user or device to determine what component should be displayed.

And to cover cases when these parameters may not be set on or available from the server, we also provide default values within our application.

This key-value pair provides our application of **what** the parameter is for (key, the identifier) and the **how** for what it is which we’re applying the configuration to (value, the configuration).

*   **key** — The key is a String used to define the identify for the parameter
*   **value** — The value can be of any other data type and is used to represent the value of our defined parameter.

#### Conditions

Conditions are a collection of rules that we can use to target specific app instances —for example, we may wish to only make configuration changes for users who are female or for users who don’t have a paid-for plan. If all of the rules that are specified for a condition are satisfied, then the configurations are applied to the app instance.

The **conditional value** itself is also represented as a key-value pair, it’s made up of:

*   **condition** — The condition to be satisfied for the value to be used
*   **value** — The value to be used if the condition is satisfied

We can use multiple **conditional values** for each parameter that we define in our Remote Config setup, this allows us to declare multiple rules which much be satisfied for a parameter value to be applied to an application instance.

#### Priorities

If we do have multiple conditional values setup, then how does our application know which value to use? Well, Remote Config uses a collection of rules to specify which value is to be retrieved from the Remote Config Server as well as the actual value to be used within an app instance.

When we request the value from the server conditional values are applied to determine if the given application instance satisfies any of the conditions that have been defined. If only a single condition is satisfied, then the value for it is returned. On the other hand, if multiple conditions are satisfied then the one with the highest dominance (basically, the one at the top of the list in the Remote Config Console) is returned. However, if there are no conditions values that are satisfied then the default value defined on the server is returned. **Note:** If this default value is not defined then no value is returned when requested.

So we have all of these values set within our app and also within the Remote Config console — how does the Remote Config SDK know which one is to be used? Well, this is where the set of priority rules come into play. Both the client and server-side has a defined set of rules — the server needs to decide which value should be returned, and then once the app receives the value from the server it needs to know whether to use that or one of the values defined in the application itself. This definition of these rules looks like so:

![](https://cdn-images-1.medium.com/max/2000/1*5Gh8GREOVauLT4YWDHbd2w.png)



So to be begin with, the server needs to look at the current values it has set. If we have Conditional Values that are defined, then the one that has the highest priority (this is the one at the top of the list in the firebase console) is returned. If no Conditional Values are satisfied, then the server-side default value is returned — given that one is present.

On the client side, if we receive a value back from the server then this is the value to be used within the application. However, if no value is returned from the server then if an application default value has been set then this will be used. However, if both no value is returned from the server and there is no in-app default set then the application will uses the default negative value for the data type that is requested (such as 0, false, null etc).

### Remote Config Architecture

Now we know a little more about the hows and whats of Remote Config, it’s important to understand the flow of communication between our application, the Firebase API and the server-side operations. In graphical form, this communication looks a little like this:



![](https://cdn-images-1.medium.com/max/2000/1*g0_e840r5v3wTL_UyzU96A.png)



So you can see from this diagram that the Architecture consists of three core sections, being:

**Application** — The application instance which is currently running on a device. This communicates directly with the Firebase library using an instance of the FirebaseRemoteConfig class.

**Firebase Library** — The firebase library handles all of the hard work for us. It stores the default configuration values, fetches the remote values from the server (and store them for us) and also holds activated values (once we activate fetched values). We don’t have to worry about caching or when the values may be available, we just use the method provided and the rest is done for us!

**Server** — The server holds all of our remote configuration values, we define these using the firebase console.

And how do all of these tie together?

*   To begin with, our application starts the communication when retrieving the Remote Config instance. If an instance has not been created yet then the Remote Config library will instantiate one. At the initial creation of this instance, all parameter values (Fetched, Active and Default) are empty.
*   Now our application has fetched the Remote Config instance, it’s able to set some default values for our parameters. If our application tries to fetch these before they’ve been set, then the Remote Config Library will return the set default values.
*   At this point, our application is now free to perform a range of operations on the Remote Config Library. To begin with, our application can use the Fetch method to retrieve Remote Config parameter values from the server. This call is initiated using the remote Config Library and when retrieved, the values are stored within the Fetched Config instance in the library. When fetching values, the call does not make immediate changes to the look and feel of our app — we have to wait until the values have been retrieved before we can react.
*   Before we can use the fetched parameters, our application needs to use the Activate method from the Remote Config Library. When we call this, the values from the Fetched Config instance are copied over to the Active Config instance within the Remote Config Library.
*   Once activated, our application can then use the Get methods to retrieve the values for different types of data from the Remote Config Library.

### Implementing Remote Config

Now we have a bit of knowledge on how Remote Config works, let’s take a look at how we can get Remote Config implemented into our applications. This section is going to consists of three parts:

*   Setting up Remote Config on Android, setting default values as well as fetching Remote Config values
*   Setting up Remote Config on iOS, setting default values as well as fetching Remote Config values
*   Finally, setting Remote Config values and conditions server-side from within the Firebase Console

### Implementing Remote Config on Android

In this section we’re going to cover how you can get your Android application all setup and ready to go with remote configuration. Let’s get started!

**Adding the Remote Config dependancy**

To begin with, we need to start by adding the Remote Config dependancy to our **build.gradle** file. Seeing as we’re only using Remote Config from the Firebase Suite, we can use the dependancy as seen below:

    compile 'com.google.firebase:firebase-config:9.6.0'

Once done, we can then access the FirebaseRemoteConfig instance throughout our application where required:

    FirebaseRemoteConfig firebaseRemoteConfig = 
                                     FirebaseRemoteConfig.getInstance();

If you’re using dependency injection, then you could simplify the retrieval of this class. Here’s an example using Dagger 2:

    @Provides
                                     FirebaseRemoteConfig providesFirebaseRemoteConfig() {
        return FirebaseRemoteConfig.getInstance(activity);
        }

#### Setting in-app defaults

We next need to set some in-app configuration defaults for our configuration values, this is because:

*   We may need access to the configuration values before the configuration values can be retrieved from the server.
*   There may not be any values set server-side
*   Our device is in a state where we cannot access server-side values. For example, offline.

We can set our default values in the form of key-value pairs using either a [Map](https://developer.android.com/reference/java/util/Map.html) instance or an XML file (located inside res/xml). In this example, we’ve setup an xml file to represent our default values:

    
    
        
            some_text
            Here is some text
        
        
            has_discount
            false
        
        
            main_color
            red
        
    

We can then set the defaults using the Remote Config setDefaults() method:

    firebaseRemoteConfig.setDefaults(R.xml.defaults_remote_config);

#### Retrieving Remote Config values

Now we’ve set our configuration defaults, we can start using them within our app right away. From the Remote Config class we have 5 methods available to us so that we can retrieve our configuration values from it. We can currently only store and retrieve data types corresponding to the types that these methods return, which are:

*   [getBoolean()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getBoolean%28java.lang.String%29) — Allows us to retrieve **boolean** configuration values

    boolean someBoolean =     
                firebaseRemoteConfig.getBoolean("some_boolean");

*   [getByteArray()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getByteArray%28java.lang.String%29) — Allows us to retrieve **byte[]** configuration values

    byte[] someArray = firebaseRemoteConfig.getByteArray("some_array");

*   [getDouble()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getDouble%28java.lang.String%29) — Allows us to retrieve **double** configuration values

    double someDouble = firebaseRemoteConfig.getDouble("some_double");

*   [getLong()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getLong%28java.lang.String%29) — Allows us to retrieve **long** configuration values

    long someLong = firebaseRemoteConfig.getLong("some_long");

*   [getString()](https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig.html#getString%28java.lang.String%29) — Allows us to retrieve **String** configuration values

    String someText = firebaseRemoteConfig.getString("some_text");

#### Fetch Server-Side values

Now we have our defaults setup, we can go ahead and implement the retrieval of our values. This is simply done with the use of the **fetch()** method from our Firebase Remote Config instance.

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

When calling, we use the OnCompleteListener to receive callback events from our **fetch()** call. And from here, the flow is fairly simple:

*   The onComplete callback receives a [Task](https://firebase.google.com/docs/reference/serverreference/com/google/firebase/tasks/Task) instance. This is essentially an instance of the asynchronous operation that was just executed.
*   Next we need to check if the request was successful using the **isSuccessful()** method call.
*   If the request was successful, then we can continue. Here we need begin by activating the fetched results using the **activateFetched()** method. **Note:** You need to activate fetched parameters before you can use them within your app.
*   Otherwise, you’ll need to handle the failed request accordingly.

You may have spotted the cacheExpiration parameter passed in when we called **fetch() **— this value declares the time in which the cached data should be classed as not expired. So if the data in the cache was retrieved less than cacheExpiration seconds ago then the cached data is used.

We’ll cover this more in depth in the [Exploring Firebase eBook](http://hitherejoe.us14.list-manage.com/subscribe?u=29201953105285dda07c9fdbf&id=5725aeaf1d). After we’ve taken a look at how to achieve the same on iOS we’ll learn how to alter our configured parameters remotely.

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