> * 原文地址：[Preparing Your iOS App for Extensions](https://www.raizlabs.com/dev/2016/09/preparing-ios-app-for-extensions/)
* 原文作者：[NICK BONATSAKIS](https://www.raizlabs.com/dev/author/nbonatsakis/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[jk77me](https://github.com/jiakeqi)
* 校对者：




iOS 10 和 watchOS 3 给开发者们带来许多令人激动的新系统扩展点。从 Siri 到 Messages，应用与系统交互的方法不断增加。

这些新的集成方式，和大量先有的集成，通常以应用扩展的方式加入进来。苹果的[应用扩展编程指南](https://developer.apple.com/library/ios/documentation/General/Conceptual/ExtensibilityPG/):
> “当用户其他应用或系统交互时。一个应用扩展可以让你给用户提供超出本应用的自定义功能和内容”

因为一个应用扩展是一个完全分离的实体(从你的应用进程彻底独立出来的进程)，它需要一个途径去和父应用共享功能和数据。考虑到一个健身应用允许用户用 Siri 扩展来开始锻炼，而应用和 Siri 扩展都需要访问用户创建的锻炼，锻炼搜索功能 和附加的用户偏好设置。

好消息是，苹果提供了一些机制，使得这种数据和功能共享成为可能的。坏消息是，迁移一个古老而复杂的项目去使用这些机制的过程并不简单。本文的目的是指引你通过一些细节把的旧 iOS 项目整理好,并为应用扩展做准备。

## 扩展的共享代码

在你的项目中。如果你打算在应用和应用扩展中实现共享,首先和最重要的方面是代码本身。最简单的方法实现是添加你想在应用和应用扩展工程中共享的任何代码。如果你这样做了。不仅会导致重复编译全部代码，还会收到我的轻视和嘲讽。共享代码另一个更好的方法是动态库，下面是如何进行的一些高级步骤，在对现有项目改动时，同时还有一些特殊注意事项。


## 创建动态库

 创建一个新的动态库 (**File** → **New** → **Target**; 选择 **Framework & Library** → **Cocoa Touch Framework**)。会在你的项目结构中和磁盘目录下创建一个新的工程。

[![Choosing Cocoa Touch Framework from File → New → Target → Framework & Library](https://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Cocoa-Touch-Framework.png)](http://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Cocoa-Touch-Framework.png)

在现有的项目中，我会假定你迁移了 Objective-C 代码。如果是这种情况，当你创建工程时请确认选择了 **Objective-C** 。请注意这不会阻止你以后添加 Swift 代码，如果你决定这么做只需要考虑一点点事情(下面介绍)

在你的应用扩展[工程配置](https://developer.apple.com/library/ios/featuredarticles/XcodeConcepts/Concept-Targets.html)中。你可以在 **General** 标签中开启 **Allow app extension API only** 选项，这将确保你不访问任何系统 API 的话应用扩展就不可用，从而确保你的库可以在应用和扩展中使用。

## 移动代码

添加你想要共享的资源文件到新的动态库工程,并且从应用工程中删除掉。当你完成提取功能的各种问题时，以保留最少的代码开始，并共享越来越多的代码.也强烈建议您在移动磁盘上的文件（而不仅仅是项目内的文件），以避免工程文件所有权出现冲突。

## 配置主头文件

当你创建一个新的库工程，Xcode会自动为你创建一个主文件头，这个主文件头是你想成为公开提供给库使用者的 Objective-C 代码指定头文件，例如你的主要应用和扩展
这有一个简短的示例，"Services" 的类库中的一个主头文件:






    //! Project version number for Services.

    FOUNDATION_EXPORT doubleServicesVersionNumber;

    //! Project version string for Services.

    FOUNDATION_EXPORT const unsignedcharServicesVersionString[];

    #import <Services/Utilities.h>

    #import <Services/DataService.h>

    #import <Services/WorkoutService.h>




还要注意的是，指定一个文件头的不够的: 又必须要选中这个头文件，并在属性检查器( Xcode 右边面板)中更改可见度为 **Public** 

[![Setting the umbrella header's visibility to Public](https://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Public-Visibility.png)](http://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Public-Visibility.png)

最后，请记住，对于 Swift 代码稍有不同，在工程配置中或主头文件引用时不再需要配置可见度，对比可以看出，所有 Swift 代码的可见度是由语言直接控制的 [访问控制特性](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AccessControl.html) (`private`，`internal`，和 `public`)。

## 其他注意事项

创建新动态库时要考虑的一些较轻微的陷阱，正如前面提到的，你其实可以在 Objective-C 库中引用 Swift 代码，并在一般情况下，事情会像你所期望的那样。

在写代码时，似乎不用为 Objective-C 代码创建桥接头文件，如果你想在 Objective-C 代码中 使用 Swift (动态库内)，它将是公开头文件的一部分(例如。引用主文件头)，当使用桥接头文件时，以这种方式公开暴露的 Objective-C 代码在你的静态库 Swift 代码中是自动可用的，相反(从 Objective-C 内访问 Swift 库)，你只需要引入自动生成的 Swift 文件头 (例如 `#import &lt;MyServices/MyServices-Swift.h&gt;`)。这样做会根据你指定的访问控制暴露 Swift 代码。


## 使用动态库

一旦你创建和配置您的新动态库， 即可在应用和应用扩展中使用。第一个任务是在应用和扩展中的工程的 **Embedded Binaries** 引入依赖项:

[![Add your framework under Embedded Binaries for both app and extension](https://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Embedded-Binaries.png)](http://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/Embedded-Binaries.png)

注: 在每个工程的 Xcode 工程设置中的 **General** 面板

一旦你引入了这个动态库，接下来就简单多了，在 Swift 中  `import Services` 和在 Objective-C 中 `@import Services;` 都能引用这个模块。

## 共享数据

如果你的应用在磁盘中写入一些用户数据，并且这些数据必须在应用和应用扩展中访问，只移动代码到动态库内是不够的。因为应用扩展不能像主应用那样访问这些文件，所以不能访问你写到沙盒空间的数据。

## 创建一个应用组

解决这个问题的办法是,为你的应用和在一个共享位置读写创建并配置一个应用组，而非主应用的文件层级。这适用于任何文件 I/O 去执行代码的共享库，不管是与文件直接交互，还是使用一个像磁盘文件支持核心数据的抽象层。

创建一个新的应用组，首先你需要按照[苹果开发者入门](https://developer.apple.com/account/) 下的 **App Groups** 创建应用组。使用像应用标识符相同的方式，以反转域名命名(例如: `com.mycompany.AwesomeWorkouts` )。一旦你创建应用组之后，你需要每个工程的应用和应用扩展中打开  **Capabilities** 选项

[![Click this switch to enable the app group](https://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/App-Groups.png)](http://www.raizlabs.com/dev/wp-content/uploads/sites/10/2016/08/App-Groups.png)

请确认你的项目小组是配置好的，然后点击右边的开启应用组。Xcode 使用一些黑魔法后，你会在个人账户中看到应用组的列表，为每个创建的应用和扩展开启允许访问共享数据。

## 访问共享容器

现在你的应用和应用扩展可以访问应用组了，是时候更改所有文件 I/O 代码去指向应用组的共享容器，而不是 app-specific 的位置。这可以为共享容器获取根目录 (注: 在写本文的时候，Swift 3 是最新语言版本):





    let rootURL=FileManager.default().containerURLForSecurityApplicationGroupIdentifier("group.com.mycompany.AwesomeWorkouts")




这将给你一个根位置，用来读写应用和扩展，请注意在操作应用组标识符时，你必须以 “group.” 开头，否则会查询失败。

## 迁移

现在你已经配置了应用和应用扩展从一个共享位置访问数据。你的应用的新用户开始是没有问题的。可是，用户使用现有数据时将会突然失去他们所有的数据。嘘，这是当然的! 因为你更改了所有代码去指向新的共享位置，因此所有当前数据都被留在废弃的应用里。

你可以在很多方面解决这个问题。但是最直接的选择是当第一次打开新版本应用时，执行一次性迁移。编写一些只在旧的位置有数据（沙盒）运行的代码，并不在新的位置（共享容器）没数据时运行，如果这两个条件都满足。复制必要的数据到共享容器中，则是件愉快的事情。要确保任何代码试图读取文件系统之前执行此迁移。这还包括核心数据的初始化。

## 共享配置

处理代码和数据共享之后，你还有一个应用设置的问题没解决。最常见保存这些数据的方法是通过 `NSUserDefaults`。不幸的时，像默认的 iOS 的传统文件 I/O 一样，这个方法有同样的问题，用户默认都储存在只有主应用才能访问的位置。幸运的是，这里有两个非常容易的方法去给应用和扩展暴露这些数据。

## 应用组

让我们再次完善下旧应用组。正如你可以写文件数据到共享容器。你也可以通过应用组去读写用户默认值。而不是访问标准默认值。访问共享容器默认值像下面这样:





    let defaults=UserDefaults(suiteName:"group.com.mycompany.MyApp")




你还要通过一个类似的迁移进程。复制所有旧用户默认值到新的用户默认值。文件迁移时。优先访问任何项目.

## iCloud Key-Value Storage

第二个共享用户设置的方法是利用[iCloud Key-Value storage](https://developer.apple.com/library/mac/documentation/General/Conceptual/iCloudDesignGuide/Chapters/DesigningForKey-ValueDataIniCloud.html)。
有一个关于如何使用这个系统的不错的现有文档。你可以在应用扩展和以及应用中访问 key-value 存储，因为这是用来共享配置数据很合适的方法。如果你已经为配置数据使用了 iCloud Key-value storage。就完成了! 只需通过共享库访问它。如果你在纠结使用哪个方法。我认为这种方法更好，因为即使应用被删除了，你的用户配置数据也会同步到多设备。


## 总结

就是这样! 一旦你完成了上面的步骤。[你的旧项目将会大放异彩](https://www.youtube.com/watch?v=ha-uagjJQ9k)。抽出抽象共享数据和服务到嵌入式框架可能看起来工作量艰巨，但鉴于苹果公司的移动方向(在许多不同的环境中运行通用代码)。它可以让你像介绍的那样更方便地采用新的应用扩展。iOS 的未来是系统底层指引着应用。确保符合苹果最新的架构的最佳实践，会让的应用会不断取得成功。

如果本文没有让你觉得不着边际的废话(或者有)，欢迎到 Twitter [@nickbona](https://twitter.com/nickbona) 上关注我，我会在这里聊聊软件开发和技术。





