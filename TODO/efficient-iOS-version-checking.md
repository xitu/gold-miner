>* 原文链接 : [Efficient iOS Version Checking](https://pspdfkit.com/blog/2016/efficient-iOS-version-checking/)
* 原文作者 : [Peter Steinberger](https://twitter.com/steipete)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :
* 校对者:


Few apps have the luxury to support only the most recent version of iOS. It's often necessary to set a lower [deployment target](https://pspdfkit.com/guides/ios/current/announcements/version-support/) and branch in code based on specific versions of iOS. There are various ways to accomplish this and even Apple's message is a bit conflicted. I recently saw [this tweet](https://twitter.com/stevemoseley/status/748953473069092864) where someone basically warns to **not** do this:

一些应用程序很“奢侈”的只支持最新版本的 iOS。通常需要在基于特定版本的 iOS 代码中设置一个较低的部署目标和分支。虽然苹果公司的消息有些矛盾，还是有各种办法来完成这个。最近在这条微博上看到有人警告说，基本不这样做：


    #define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)



A [GitHub search shows that there are over 8000 results](https://github.com/search?q=%5B%5B%5BUIDevice+currentDevice%5D+systemVersion%5D+substringToIndex%3A1%5D&type=Code&utf8=) calling `substringToIndex:1`. All of that code will break with iOS 10\. It will instead assume iOS 1, where the only apps that existed were jailbreak apps.

GitHub 搜索显示，有超过 8000 的结果调用了 `substringToIndex:1` 。所有这些代码碰到 iOS 10 就“懵逼”了。因为 iOS 10 会被检测成 iOS 1 了，估计只有在越狱的应用中才会出现吧。

It's the same old story again. [Windows 9 became Windows 10](http://www.pcworld.com/article/2690724/why-windows-10-isnt-named-9-windows-95-legacy-code.html) because there was [too much code out there](https://searchcode.com/?q=if%28version%2Cstartswith%28%22windows+9%22%29) checking for Windows 95 and 98 via `if (name.startsWith("windows 9"))`.

又是同样的老故事。Windows 9 变成 Windows 10 是因为有太多代码通过 `if (name.startsWith("windows 9"))` 来检查 Windows 95 和 98 了。

## 新 API

It took surprisingly long for this problem to be recognized and better API to be offered. With iOS 8, we finally got some improvements! There's now a new [`operatingSystemVersion`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSProcessInfo_Class/#//apple_ref/occ/instp/NSProcessInfo/operatingSystemVersion) method on [`NSProcessInfo`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSProcessInfo_Class/), and more importantly the [`- (BOOL)isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion)version`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSProcessInfo_Class/#//apple_ref/occ/instm/NSProcessInfo/isOperatingSystemAtLeastVersion:) method to check:

花了相当长的时间才意识到这个问题，然后提供了更合适的 API。iOS 8 中，终于有了一些改进！现在 [`NSProcessInfo`] 有一个新的 [`operatingSystemVersion`] 方法，还有更重要的 [`- (BOOL)isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion)version`] 方法来检查。

    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 9, .minorVersion = 1, .patchVersion = 0}]) {
        NSLog(@"Hello from > iOS 9.1");
    }

    // Using short-form for the struct, we can make things somewhat more compact:
    if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9,3,0}]) {
        NSLog(@"Hello from > iOS 9.3");
    }



## 使用 PSPDFKit 我们需要做啥

[PSPDFKit is an SDK to view, annotate and fill forms on PDF documents.](https://pspdfkit.com/why-pspdfkit/) It was originally written when iOS 4 was around and has continued to evolve as new iOS versions have been released. Back then there was no dedicated API to check for the version, and many apps did something like this:

PSPDFKit 是一个 SDK，可以查看、注释 PDF 文档，还能在上面填写表单。最开始写的时候还是 iOS 4，一直改进到最新的 iOS 发行版。那个时候还没有专门的 API 来检测版本，许多应用用了类似下面的代码：

    if ([[[UIDevice currentDevice] systemVersion] isEqualToString:@"7.0"]) {
        //do stuff
    }



This was never a good idea so we never used it. A string compare might be fast but it's the wrong choice in this case. To get it right, you'd need to do something [like this](https://gist.github.com/alex-cellcity/998472):

这样用不好，所以我们从来没这样用过。比较字符串速度可能很快，但是在这种情况下是个错误的选择。正确的做法是像下面这样：

    #define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        ...
    }



Clunky. Easy to get wrong. There's a simpler way. We can use the [`NSFoundationVersionNumber`](https://developer.apple.com/reference/foundation/nsfoundationversionnumber) (or the [`kCFCoreFoundationVersionNumber`](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFBaseUtils/#//apple_ref/c/data/kCFCoreFoundationVersionNumber)) to compare. The system check reduces to a simple `if` compare. No method calls required, so it's extremely efficient, even in tight loops.

太笨重了，容易出错。有种更简单的方法。我们可以用 [`NSFoundationVersionNumber`] （或者 [`kCFCoreFoundationVersionNumber`]）来比较。系统检测开销降低到一个简单的 if 比较。不需要调用其它方法，所以它效率极高，即使在紧凑的循环中表现也不错。

    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0) {
        // do stuff for iOS 9 and newer
    }
    else {
        // do stuff for older versions than iOS 9
    }



In fact, this is exactly what Apple suggested at the [2013 Tech Talks in the Architecting Modern Apps, Part 2](http://devstreaming.apple.com/videos/techtalks/2013/15_Architecting_Modern_Apps_Part_2/Architecting_Modern_Apps_Part_2.pdf) session.

事实上，这正是苹果公司在 2013 构建现代应用程序技术论坛，章节 2 中所建议的。

Caveat: Sometimes the constants are missing. `NSFoundationVersionNumber` is defined in `NSObjCRuntime.h` and as part of Xcode 7.3.1 we have constants ranging from iPhone OS 2 to `#define NSFoundationVersionNumber_iOS_8_4 1144.17` - not 9.0-9.3\. Same for `kCFCoreFoundationVersionNumber`. Note that while these numbers are similar, they are not the same. So use one or the other.

警示：有时候会缺少一些常量。`NSFoundationVersionNumber` 是在 `NSObjCRuntime.h` 中定义的，作为 Xcode 7.3.1 的一部分，我们设定常数范围从 iPhone OS 2 到 `#define NSFoundationVersionNumber_iOS_8_4 1144.17` - 而不是 9.0-9.3\。  对于  `kCFCoreFoundationVersionNumber` 也一样。注意，虽然这些数字很相似，但是它们是不相同的，所以使用其中一个或者另外一个。

If you do macOS development, you can also [use the `NSAppKitVersionNumber` which is usually kept more up to date.](http://nshipster.com/swift-system-version-checking/)

如果你做 macOS 开发的话，也可以使用 `NSAppKitVersionNumber` ，它通常是更新到最新的。

In SDK 10 (Xcode 8) Apple added the missing numbers and even some future ones.

在 SDK 10（Xcode 8）苹果公司添加了缺少的数字，甚至还有未来的版本。

    #define NSFoundationVersionNumber_iOS_9_0 1240.1
    #define NSFoundationVersionNumber_iOS_9_1 1241.14
    #define NSFoundationVersionNumber_iOS_9_2 1242.12
    #define NSFoundationVersionNumber_iOS_9_3 1242.12
    #define NSFoundationVersionNumber_iOS_9_4 1280.25
    #define NSFoundationVersionNumber_iOS_9_x_Max 1299



Will there be an iOS 9.4? Considering iOS 10 will be released in three months and 9.3.3 is in beta, I wouldn't expect it but it is still nice to have a placeholder. In PSPDFKit, we define the missing version numbers using the following pattern below. If our code is built with a higher minimum deployment target, the code is automatically compiled out, which helps a lot when we drop iOS versions.

会有 iOS 9.4 吗？考虑到 iOS 10 将在未来 3 个月内发布，而且 9.3.3 仍然是 beta 版，我估计是不会有了，但是最好还是占个坑吧。在 PSPDFKit 中，我们是使用下面的模式来定义缺少的版本号。如果我们的代码使用一个更高的最低部署目标，代码自动编译会帮我们自动忽略掉一些 iOS 版本。

    // iOS 9 compatibility
    #ifndef kCFCoreFoundationVersionNumber_iOS_9_0
    #define kCFCoreFoundationVersionNumber_iOS_9_0 1223.1
    #endif

    #define PSPDF_IS_IOS9_OR_GREATER (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_9_0)

    #if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
    #define PSPDF_IF_IOS9_OR_GREATER(...) \
    if (PSPDF_IS_IOS9_OR_GREATER) { \
    PSPDF_PARTIAL_AVAILABILITY_BEGIN \
    __VA_ARGS__ \
    PSPDF_PARTIAL_AVAILABILITY_END }
    #else
    #define PSPDF_IF_IOS9_OR_GREATER(...)
    #endif

    #if defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED < 90000
    #define PSPDF_IF_PRE_IOS9(...)  \
    if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_9_0) { \
    PSPDF_PARTIAL_AVAILABILITY_BEGIN \
    __VA_ARGS__ \
    PSPDF_PARTIAL_AVAILABILITY_END }
    #else
    #define PSPDF_IF_PRE_IOS9(...)
    #endif



Notice the partial availability macros. This is a warning that was added with SDK 9\. It's not really useful when we already wrap things in version blocks, so we disable it. We have those as standalone macros since sometimes this is useful in code that uses other kinds of availability checks. We used it, for example, when implementing interactive transitions in `UICollectionView` to implement [dragging of tabs or pages on iOS 9](https://pspdfkit.com/features/document-editor/ios/) while also also supporting iOS 8.

请注意部分可用的宏。这是添加到 SDK 9 中出现的一个警告。当我们打包版本块时这没什么用，所以禁用它。我们有一些单独的宏，在做一些其他类型的可用性检查时会有用。我们在某些情况下使用，例如在 `UICollectionView` 中实现一些交互动画，在 iOS 9 中拖拽 tab 或者 page，同时也要支持 iOS 8。

    #define PSPDF_PARTIAL_AVAILABILITY_BEGIN \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wpartial-availability\"")

    #define PSPDF_PARTIAL_AVAILABILITY_END \
    _Pragma("clang diagnostic pop")



### Why these macros? 为什么是这些宏

Since [we dropped iOS 7 a while ago](https://pspdfkit.com/guides/ios/current/announcements/version-support/), we could easily switch to the new `isOperatingSystemAtLeastVersion:`. Its implementation calls `operatingSystemVersion` internally and is quite efficient. It would produce a bit more code and would still be slightly slower than our current implementation. I don't see any upside compared to the foundation check, but it's certainly nicer to use if you're not using macros.

自从前段时间我们放弃了 iOS 7，我们可以轻易的切换到新的 `isOperatingSystemAtLeastVersion:` 方法上。其内部实现是通过调用 `operatingSystemVersion` ，是相当高效的。它会产生更多的代码，仍然比我们现在的实现要慢一点。我没看到过基础检测的正面比较，但是可以肯定的说用了会更好，如果没有用宏的话，赶紧试试吧。

Things get ugly if we look at the implementation of `operatingSystemVersion` directly. It's cached, but it does generate the version via calling `_CFCopySystemVersionDictionary()` and then looking up `kCFSystemVersionProductVersionKey` (which is `ProductVersion`) and then calling `componentsSeparatedByString:` on that string. I somehow expected this to be hardcoded, but reading it from an external dictionary file is probably more flexible.

如果我们直接看 `operatingSystemVersion` 的实现，确实有点丑。它被缓存了，但是它通过调用 `_CFCopySystemVersionDictionary()` 生成版本号，然后查找 `kCFSystemVersionProductVersionKey` （就是 `ProductVersion`），然后对该字符串执行 `componentsSeparatedByString:` 。不知道为啥，我更期望这是硬编码，但是从外部字典文件读取可能更加灵活。

## Swift

As of Swift 2.0 there's [support for version checking built right into the language](https://www.hackingwithswift.com/new-syntax-swift-2-availability-checking). So instead of calling:

由于 Swift 2.0 是支持内置版本检查的语言，所以应该用：

    if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0)) {
        // modern code
    }



You can now do the same with much less code:

你可以用更少的代码完成同样的事：


    if #available(iOS 10.0, *) {
        // modern code
    } else {
        // Fallback on earlier versions
    }



**Swift also correctly applies the partial availability checks** for API called within these blocks, so we get compile-time safety that we cannot easily copy in Objective-C. In ["Swift in Practice" (WWDC 2015, Session 411)](https://developer.apple.com/videos/play/wwdc2015/411/) starting 08:40 an Apple engineer explains this in great detail.

Swift 还能正确的适用于这些代码块中 API 调用的可用性检查，所以我们得到了编译时安全，在 Objective-C 是无法轻易做到的。 在 “Swift in Practice” (WWDC 2015, Session 411) 8：40 开始，一名苹果工程师详细介绍了这一特性。

So, what is Swift using under the hood? Good thing that it's open source and well structured! Let's take a look at [`Availability.swift`](https://github.com/apple/swift/blob/master/stdlib/public/core/Availability.swift#L20-L43):

那么，Swift 在底层用了什么？好在它是开源的而且有着良好的结构。让我们来看看 [`Availability.swift`](https://github.com/apple/swift/blob/master/stdlib/public/core/Availability.swift#L20-L43):

    /// Returns 1 if the running OS version is greater than or equal to
    /// major.minor.patchVersion and 0 otherwise.
    ///
    /// This is a magic entry point known to the compiler. It is called in
    /// generated code for API availability checking.
    @_semantics("availability.osversion")
    public func _stdlib_isOSVersionAtLeast(
      _ major: Builtin.Word,
      _ minor: Builtin.Word,
      _ patch: Builtin.Word
    ) -> Builtin.Int1 {
    #if os(OSX) || os(iOS) || os(tvOS) || os(watchOS)
      let runningVersion = _swift_stdlib_operatingSystemVersion()
      let queryVersion = _SwiftNSOperatingSystemVersion(
        majorVersion: Int(major),
        minorVersion: Int(minor),
        patchVersion: Int(patch)
      )

      let result = runningVersion >= queryVersion

      return result._value
    #else
      // FIXME: As yet, there is no obvious versioning standard for platforms other
      // than Darwin-based OS', so we just assume false for now.
      // rdar://problem/18881232
      return false._value
    #endif
    }



Now, much more interestingly, what is `_swift_stdlib_operatingSystemVersion()` and how is it defined? For that we have to leave the cozy Swift world and dig into [the madness that is Objective-C++](https://pspdfkit.com/blog/2016/swifty-objective-c/). Enter [`Availability.mm`](https://github.com/apple/swift/blob/master/stdlib/public/stubs/Availability.mm#L26):

现在，更有趣的是，`_swift_stdlib_operatingSystemVersion()` 是干什么的，它是怎么定义的？想要找到答案我们得离开舒适的 Swift 世界了，然后在 [Objective-C++ 世界中深挖] 。进入   [`Availability.mm`](https://github.com/apple/swift/blob/master/stdlib/public/stubs/Availability.mm#L26):

    /// Return the version of the operating system currently running for use in
    /// API availability queries.
    _SwiftNSOperatingSystemVersion swift::_swift_stdlib_operatingSystemVersion() {
      static NSOperatingSystemVersion version = ([]{
        // Use -[NSProcessInfo.operatingSystemVersion] when present
        // (on iOS 8 and OS X 10.10 and above).
        if ([NSProcessInfo
             instancesRespondToSelector:@selector(operatingSystemVersion)]) {
          return [[NSProcessInfo processInfo] operatingSystemVersion];
        } else {
          // Otherwise load and parse from SystemVersion dictionary.
          return operatingSystemVersionFromPlist();
        }
      })();

      return { version.majorVersion, version.minorVersion, version.patchVersion };
    }



Swift uses the new API that we got in iOS 8 but falls back to horrible things on < 8, opening the `@"/System/Library/CoreServices/SystemVersion.plist"` file instead. The result here is cached however, so the version check does hit the disk, but only once. My first reflex was to send a pull request with a change to simply use existing public API (`systemVersion`), however [Xcode 8 sets the minimum deployment target to iOS 8](https://stackoverflow.com/questions/37817554/xcode-8-recommend-me-to-change-the-min-ios-deployment-target-from-7-1-to-8-0) and it's unlikely that we see another Xcode 7.3.x release with an updated Swift version, so the code will likely just go away completely.

## More on backwards compatibility

It's worth noting that Apple has worked to make these kind of version checks unnecessary. Of course, there's [`respondsToSelector:`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Protocols/NSObject_Protocol/index.html#//apple_ref/occ/intfm/NSObject/respondsToSelector:) and [`instancesRespondToSelector:`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSObject_Class/index.html#//apple_ref/occ/clm/NSObject/instancesRespondToSelector:) which is an integral part of Objective-C. I assume that you already know about these. It's perfectly fine to use those, and we do that occasionally in some cases. However, there are also reasons why this is not always appropriate. For example, sometimes Apple makes API public that existed in some form or another internally before but with different characteristics. This was the case with [`appStoreReceiptURL` which was added in iOS 7 but also existed in iOS 6](https://openradar.appspot.com/14216650). In such cases, being explicit about the version is more reliable. In addition, it also makes it easier to clean up code as you hopefully drop older versions of iOS. All you need to do is remove your compatibility macros and fix the resulting build errors.

### Weak Linking

In the very early days, using a class not available on all versions meant using this pattern:



    Class cls = NSClassFromString (@"NSRegularExpression");
    if (cls) {
        // Create an instance of the class and use it.
    } else {
        // Alternate code path to follow when the
        // class is not available.
    }



With the addition of [weakly linked classes](https://developer.apple.com/library/ios/documentation/DeveloperTools/Conceptual/cross_development/Using/using.html#//apple_ref/doc/uid/20002000-SW3) in iOS 4.2, this is now much simpler:



    if ([UIPrintInteractionController class]) {
        // Create an instance of the class and use it.
    } else {
        // Alternate code path to follow when the
        // class is not available.
    }



[Greg Parker shares more about this in his Hamster Emporium archive](http://sealiesoftware.com/blog/archive/2009/09/09/objc_explain_Weak-import_classes.html), including this gem:

> Weak import for Objective-C did not make Snow Leopard for scheduling reasons. Assuming it ships in Mac OS X 10.7 Cat Name Forthcoming, you won't be able to use it until Mac OS X 10.8 LOLcat.

Weak linking can be extended to a whole framework. In PSPDFKit, we do this for [`SafariServices`](https://developer.apple.com/library/ios/documentation/SafariServices/Reference/SafariServicesFramework_Ref/), which contains [`SFSafariViewController`](https://developer.apple.com/library/ios/documentation/SafariServices/Reference/SFSafariViewController_Ref/index.html#//apple_ref/occ/cl/SFSafariViewController) (added in iOS 9).



    // Part of our .xcconfig file:
    -weak_framework SafariServices



Weak linking incurs a small performance penalty on startup so only use this when you have to. To learn more about it, check [Apple's SDK Compatibility Guide](https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/cross_development/Using/using.html#//apple_ref/doc/uid/20002000-SW6).

## Conclusion

For most apps, using `isOperatingSystemAtLeastVersion:` in Objective-C and `#available()` in Swift is the way to go. It's still interesting to know what's going on under the hood - and everything is better than string comparison. If you enjoy digging deep, then [PSPDFKit is the place for you to be.](https://pspdfkit.com/jobs/)

## Update

After posting this article, Devin Coughlin, who _wrote_ the `#available` feature replied why `systemVersion` can't be used in the Swift implementation:

> [@steipete Also: why not "systemVersion"? Because UIDevice is not present on macOS and we wanted the same code path on all platforms.](https://twitter.com/coughlin/status/750706938489425921)
