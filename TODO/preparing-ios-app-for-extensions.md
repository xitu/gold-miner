> * 原文地址：[Preparing Your iOS App for Extensions](https://www.raizlabs.com/dev/2016/09/preparing-ios-app-for-extensions/)
* 原文作者：[NICK BONATSAKIS](https://www.raizlabs.com/dev/author/nbonatsakis/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：





iOS 10 and watchOS 3 are bringing a number of exciting new system extension points to developers. From Siri to Messages, the number of ways an app can integrate with the system is ever increasing.

These new integrations, as well as the large number of existing integrations, typically come in the form of app extensions. From Apple’s [App Extension Programming Guide](https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/):

> “An app extension lets you extend custom functionality and content beyond your app and make it available to users while they’re interacting with other apps or the system.”

Because an app extension is an entirely separate entity (completely independent process from your app process), it needs a way to share both functionality and data with its parent app. Consider a workout app that allows a user to initiate a workout via a Siri extension. Both the app and the Siri extension need to have access to the user-created workouts, functionality for searching through workouts, and any additional user preferences.

Fortunately, Apple provides a number of mechanisms that make this sort of data and functionality sharing possible. Unfortunately, the process of migrating an old and crufty project to use these mechanisms is not always straightforward. This post aims to guide you through some of the finer points of getting your old and busted iOS project nice and ready for app extensions.

## Sharing Code with the Extension

The first and most important aspect of your project that you’ll want to share between your app and app extension is the code itself. The naive way to achieve this is to add whatever code you want to share to both app and app extension targets. If you do this, not only will you incur the cost of compiling all of this code twice, but you will also be the recipient of my unending scorn and ridicule.

A much better  way to share code is via embedded dynamic frameworks. Below are some high-level steps on how to proceed, along with some special considerations for doing this on existing projects:

## Creating the Framework

Create a new Dynamic Framework target (**File** → **New** → **Target**; Choose **Framework & Library** → **Cocoa Touch Framework**). This will create a new target as well as a new directory on disk within your project structure.

[![Choosing Cocoa Touch Framework from File → New → Target → Framework & Library](https://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Cocoa-Touch-Framework.png)](http://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Cocoa-Touch-Framework.png)

Since we’re doing this for an existing project, I’m going to assume that you’ll be mostly migrating Objective-C code. If this is the case, be sure to choose **Objective-C** as the language when you create the target. Be aware that this won’t preclude you from adding Swift code later; there are just a few things you’ll want to consider once you do so (covered below).

You’ll also want to enable the **Allow app extension API only** checkbox on the **General** tab of your app extension [target configuration](https://developer.apple.com/library/ios/featuredarticles/XcodeConcepts/Concept-Targets.html). This will ensure that you do not access any system API that is not available to app extensions, thus ensuring that your framework can be consumed by both your app and extension.

## Move Code

Add the source and resource files you’d like to share to this new target and remove them from your app target. It’s a good idea to start with the fewest files you can and work your way up to sharing more and more code as you work through the various issues of extracting functionality. It’s also strongly recommended that you move the files on disk (not just within the project groups), in order to avoid any future confusion around target file ownership.

## Configure Umbrella Header

When you create a new framework target, Xcode will automatically create an umbrella header for you as well. This header is where you specify the headers for the Objective-C code you want to be publicly available to consumers of your framework, e.g. your main app and extension.

Here’s a short example of an umbrella header for a framework called “Services”:





    //! Project version number for Services.

    FOUNDATION_EXPORT doubleServicesVersionNumber;

    //! Project version string for Services.

    FOUNDATION_EXPORT const unsignedcharServicesVersionString[];

    #import

    #import

    #import





Note also, that specifying a header here is not enough: you must also select that header file and change the visibility to **Public** in the Attributes Inspector (right panel in Xcode).

[![Setting the umbrella header's visibility to Public](https://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Public-Visibility.png)](http://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Public-Visibility.png)

Finally, keep in mind that the behavior for Swift code is slightly different in that you don’t need to configure visibility via inclusion in the umbrella header or target configuration. Rather, visibility for all Swift code is controlled directly by the language [access control features](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AccessControl.html) (`private`, `internal`, and `public`).

## Other Considerations

A few more minor gotchas to consider when creating your new framework. As mentioned before, you can in fact include Swift code in your Objective-C framework, and in general, things will bridge just as you would expect.

As of this writing, it doesn’t seem like there is a way to create a bridging header for your Objective-C code, so if you want to access any of your Objective-C code from Swift (within the framework), it will have to be part of the public headers (i.e. included in the umbrella header). Any Objective-C code exposed publicly in this way is automatically available to your framework Swift code just as if you were using a bridging header.

For the reverse situation (accessing Swift framework code from within Objective-C), you simply have to import the auto-generated Swift header (e.g. `#import &lt;MyServices/MyServices-Swift.h&gt;`). This will expose your Swift code according to the access control you’ve specified.

## Consuming the Framework

Once you’ve created and configured your new framework, it’s time to consume it from your app and app extension. The first task is to include it as a dependency by adding it under **Embedded Binaries** in the target configuration for both app and extension:

[![Add your framework under Embedded Binaries for both app and extension](https://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Embedded-Binaries.png)](http://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Embedded-Binaries.png)

Caption: Find the embedded binaries configuration on the **General** tab of the Xcode target configuration for each target in your project.

Once you’ve included the framework, it’s simply a matter of including the module using `@import Services;` for Objective-C and `import Services` for Swift.

## Sharing Data

If your app writes any user data to disk, and that same data must be accessible to both your app and app extension, simply moving your code to an embedded framework is not enough. This is because app extensions do not have access to the same files as your main app, and therefore cannot access data you’ve written to places such as the Documents directory.

## Creating an App Group

The solution to this problem is to create and configure an App Group for your app and read/write to a shared location for that group, rather than the main app’s file hierarchy. This is true for any file I/O you perform via code in your shared framework, whether that be interacting with files directly, or using an abstraction layer like Core Data that is backed by files on disk.

To create a new app group, the first thing you’ll need to do is create the group itself on the [Apple Developer Portal](https://developer.apple.com/account/) under **App Groups**. Name your app group using the same reverse domain naming scheme as your app identifier (e.g. `com.mycompany.AwesomeWorkouts`). Once you’ve created the app group, you’ll need to enable it for both your app and app extension via the **Capabilities** section of each respective target configuration.

[![Click this switch to enable the app group](https://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/App-Groups.png)](http://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/App-Groups.png)

Make sure your project is configured for the appropriate team and then click the switch on the right to enable the App Groups. Xcode will work some magic and you’ll be presented with a list of App Groups for your account. Enable the one you just created for this app and rinse/repeat for each extension that requires access to shared data.

## Access Shared Container

Now that your app and app extension have access to an app group, it’s time to change all of your file I/O code to point to the group’s shared container, rather than to app-specific locations.

This can be done by obtaining the root directory for the shared container (Note: at the time of this writing, Swift 3 is the latest language version):





    letrootURL=FileManager.default().containerURLForSecurityApplicationGroupIdentifier("group.com.mycompany.AwesomeWorkouts")





This will give you a root location to which you can read from and write to in both your app and its extensions. Note that when dealing with the group identifier, you must prefix it with “group.”, or else the lookup will fail.

## The Great Migration

Now that you’ve configured your app with an app extension to access data from a shared location, new users of your app will have no problem getting started (yay!). However, users with existing data will suddenly lose all of their data. Boo!. This is of course, because you’ve changed all of your code to point to the new shared location, thus leaving all existing data stranded in the now abandoned app.

You can address this in a number of ways, but the most straightforward option is to perform a one-time migration the first time a user opens this new version of your app. Write some code that runs only if there is data present in the “old” location (Documents directory) and no data present in the “new” location (shared container). If both conditions are met, copy the requisite data over to the shared container and merrily move on to happier things. Be sure to perform this migration _before_ any code attempts to read from the file system. This includes Core Data initialization.

## Sharing Configuration

After dealing with code and data sharing, you have the issue of app settings to address. The most common way to persist this data is via `NSUserDefaults`. Unfortunately, this method suffers from the same issue as traditional file I/O on iOS in that by default, user defaults are stored in a location accessible only to the main app. Luckily, there are two very easy methods for exposing this data to your app and extension.

## App Groups

Trusty old app groups to the rescue again. Just as you can write file data to a shared container, you can also read and write user defaults via app groups. Instead of accessing the standard defaults, access shared container defaults like this:





    letdefaults=UserDefaults(suiteName:"group.com.mycompany.MyApp")





You’ll also have to go through a similar migration process, copying all of your “old” user defaults to your “new” user defaults, prior to accessing any item, as you did for file migration.

## iCloud Key-Value Storage

The second approach for sharing user preferences is by taking advantage of [iCloud Key-Value storage](https://developer.apple.com/library/mac/documentation/General/Conceptual/iCloudDesignGuide/Chapters/DesigningForKey-ValueDataIniCloud.html). There’s a good deal of existing documentation on how to use this system, but suffice it to say, you can access key-value storage in app extensions as well as apps, so it’s a suitable way to share configuration data.

If you’re already using iCloud Key-value storage for your configuration data, you’re done. Simply start accessing it via your shared framework. If you’re on the fence over which method to use, consider that this method has the added bonus that your user’s configuration data will be synced across devices and will survive app deletion.

## Wrapping Up

And that’s it! Once you’ve gone through the above steps, [your old and busted project will shine with new hotness](https://www.youtube.com/watch?v=ha-uagjJQ9k). Taking the time to abstract your shared data and services into embedded frameworks may seem like a daunting amount of work, but given the direction in which Apple are moving (common code running in many different contexts), it will allow you to more easily adopt new app extensions as they are introduced. The future of iOS is rooted in system integration points over direct app usage. Set your app up for continuing success by ensuring it adheres to the latest Apple architecture best practices.

If this post didn’t strike you as rambling nonsense (or even if it did), you’re welcome to follow me on Twitter [@nickbona](https://twitter.com/nickbona), where I intentionally ramble about software development and technology.



