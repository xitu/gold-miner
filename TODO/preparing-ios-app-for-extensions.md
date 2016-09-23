> * 原文地址：[Preparing Your iOS App for Extensions](https://www.raizlabs.com/dev/2016/09/preparing-ios-app-for-extensions/)
* 原文作者：[NICK BONATSAKIS](https://www.raizlabs.com/dev/author/nbonatsakis/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[jk77me](https://github.com/jiakeqi)
* 校对者：




iOS 10 和 watchOS 3 给开发者们带来许多令人激动的新系统扩展点. 送 Siri 到 Messages, 应用与系统的方法不断增加

这些新的集成方式, 和大量先有的集成, 通常以应用扩展的方式加入进来. 苹果的[应用扩展编程指南](https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/):
> “当用户于其他应用或系统交互时. 一个应用扩展可以让你给用户提供超出本应用的自定义功能和内容”

因为一个应用扩展是一个完全分离的实体(从你的应用进程彻底独立出来的进程), 它需要一个途径去和父应用分享功能和数据. 考虑到一个健身应用允许用户用 Siri 扩展来开始锻炼, 而应用和 Siri 扩展都需要访问用户创建的锻炼, 锻炼搜索功能 和附加的用户偏好设置.

好消息是，苹果提供了一些机制，使得这种数据和功能共享成为可能的. 坏消息是, 迁移一个古老而复杂的项目去使用这些机制的过程并不简单。这个帖子的目的是指引你通过一些细节把的旧 iOS 项目整理好,并为应用扩展做准备.

## 扩展的共享代码

在你的项目中. 你想在应用和应用扩展中实现共享,首先和最重要的方面是代码本身.最简单的方法实现是添加你想在应用和应用扩展工程中共享的任何代码. 如果你这样做了.不仅会导致重复编译全部代码,还会受到我的轻视和嘲讽.
共享代码另一个更好的方法是动态库,下面是如何进行的一些高级步骤,在对现有项目改动时还有一些特殊注意事项：


## 创建动态库

 创建一个新的动态库 (**File** → **New** → **Target**; 选择 **Framework & Library** → **Cocoa Touch Framework**).
 会在你的项目结构中和硬盘的目录下创建一个新的工程.

[![Choosing Cocoa Touch Framework from File → New → Target → Framework & Library](https://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Cocoa-Touch-Framework.png)](http://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Cocoa-Touch-Framework.png)

在现有的项目中, 我会假定你迁移了 Objective-C 代码. 如果是这种情况, 当你创建工程时请确认选择了 **Objective-C** . 请注意这不会阻止你以后添加 Swift 代码, 如果你决定这么做只需要考虑一点点事情(下面介绍)

在你的应用扩展[工程配置](https://developer.apple.com/library/ios/featuredarticles/XcodeConcepts/Concept-Targets.html)中. 你可以在 **General** 标签中开启 **Allow app extension API only** 选项, 这将确保你不访问任何系统 API 的话应用扩展就不可用, 从而确保你的库可以在应用和扩展中使用

## 移动代码

添加你想要共享的资源文件到新的动态库工程,并且从应用工程中删除掉. 当你完成提取功能的各种问题, 开始时保留最少的代码, 并共享越来越多的代码.也强烈建议您在移动磁盘上的文件（而不仅仅是项目内的文件），以避免工程文件所有权出现冲突。

## 配置主头文件

当你创建一个新的库工程, Xcode会自动为你创建一个主头文件, 这个头文件是你想成为公开提供给库使用者的Objective-C代码指定头文件，例如你的主要应用和扩展
这有一个简短的示例, "Services" 的类库中的一个主头文件:






    //! Project version number for Services.

    FOUNDATION_EXPORT doubleServicesVersionNumber;

    //! Project version string for Services.

    FOUNDATION_EXPORT const unsignedcharServicesVersionString[];

    #import <Services/Utilities.h>

    #import <Services/DataService.h>

    #import <Services/WorkoutService.h>




还要注意的是, 指定一个头文件的不够的: 又必须要选中这个头文件,并在属性检查器( Xcode 右边面板)中更改可见度为 **Public** 

[![Setting the umbrella header's visibility to Public](https://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Public-Visibility.png)](http://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Public-Visibility.png)

最后, 请记住, 对于 Swift 代码稍有不同, 在工程配置中或主头文件引用时不再需要配置可见度, 对比, 所有 Swift 代码的可见度是由语言直接控制的 [访问控制特性](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AccessControl.html) (`private`, `internal`, 和 `public`).

## 其他注意事项

创建新动态库时要考虑的一些较轻微的陷阱, 正如前面提到的，你其实可以在 Objective-C 库中引用 Swift 代码，并在一般情况下，事情会像你所期望的那样。

在写代码时, 似乎不用为 Objective-C 代码创建桥接头文件, 如果你想在 Objective-C 代码中 使用Swift(动态库内), 它将是公开头文件的一部分(例如. 引用主头文件), 当使用桥接头文件时, 以这种方式公开暴露的Objective-C代码在你的静态库 Swift 代码中是自动可用的,

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





    let rootURL=FileManager.default().containerURLForSecurityApplicationGroupIdentifier("group.com.mycompany.AwesomeWorkouts")





This will give you a root location to which you can read from and write to in both your app and its extensions. Note that when dealing with the group identifier, you must prefix it with “group.”, or else the lookup will fail.

## The Great Migration

Now that you’ve configured your app with an app extension to access data from a shared location, new users of your app will have no problem getting started (yay!). However, users with existing data will suddenly lose all of their data. Boo!. This is of course, because you’ve changed all of your code to point to the new shared location, thus leaving all existing data stranded in the now abandoned app.

You can address this in a number of ways, but the most straightforward option is to perform a one-time migration the first time a user opens this new version of your app. Write some code that runs only if there is data present in the “old” location (Documents directory) and no data present in the “new” location (shared container). If both conditions are met, copy the requisite data over to the shared container and merrily move on to happier things. Be sure to perform this migration _before_ any code attempts to read from the file system. This includes Core Data initialization.

## Sharing Configuration

After dealing with code and data sharing, you have the issue of app settings to address. The most common way to persist this data is via `NSUserDefaults`. Unfortunately, this method suffers from the same issue as traditional file I/O on iOS in that by default, user defaults are stored in a location accessible only to the main app. Luckily, there are two very easy methods for exposing this data to your app and extension.

## App Groups

Trusty old app groups to the rescue again. Just as you can write file data to a shared container, you can also read and write user defaults via app groups. Instead of accessing the standard defaults, access shared container defaults like this:





    let defaults=UserDefaults(suiteName:"group.com.mycompany.MyApp")





You’ll also have to go through a similar migration process, copying all of your “old” user defaults to your “new” user defaults, prior to accessing any item, as you did for file migration.

## iCloud Key-Value Storage

The second approach for sharing user preferences is by taking advantage of [iCloud Key-Value storage](https://developer.apple.com/library/mac/documentation/General/Conceptual/iCloudDesignGuide/Chapters/DesigningForKey-ValueDataIniCloud.html). There’s a good deal of existing documentation on how to use this system, but suffice it to say, you can access key-value storage in app extensions as well as apps, so it’s a suitable way to share configuration data.

If you’re already using iCloud Key-value storage for your configuration data, you’re done. Simply start accessing it via your shared framework. If you’re on the fence over which method to use, consider that this method has the added bonus that your user’s configuration data will be synced across devices and will survive app deletion.

## Wrapping Up

And that’s it! Once you’ve gone through the above steps, [your old and busted project will shine with new hotness](https://www.youtube.com/watch?v=ha-uagjJQ9k). Taking the time to abstract your shared data and services into embedded frameworks may seem like a daunting amount of work, but given the direction in which Apple are moving (common code running in many different contexts), it will allow you to more easily adopt new app extensions as they are introduced. The future of iOS is rooted in system integration points over direct app usage. Set your app up for continuing success by ensuring it adheres to the latest Apple architecture best practices.

If this post didn’t strike you as rambling nonsense (or even if it did), you’re welcome to follow me on Twitter [@nickbona](https://twitter.com/nickbona), where I intentionally ramble about software development and technology.



