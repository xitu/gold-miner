>* 原文链接 : [Efficient iOS Version Checking](https://pspdfkit.com/blog/2016/efficient-iOS-version-checking/)
* 原文作者 : [Peter Steinberger](https://twitter.com/steipete)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [DeadLion](https://github.com/DeadLion)
* 校对者: [MAYDAY1993](https://github.com/MAYDAY1993), [Siegen](https://github.com/siegeout)

# 高效的 iOS 应用版本支持方法

极少数应用程序很“奢侈”的只支持最新版本的 iOS。 设置一个较低的[部署目标](https://pspdfkit.com/guides/ios/current/announcements/version-support/)以及基于特定 iOS 版本的代码分支通常是很有必要的。虽然苹果公司的信息有些矛盾，还是有各种办法来完成这个。最近在[这条 tweet](https://twitter.com/stevemoseley/status/748953473069092864)上看到有人警告说，不要这样做：


    #define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)


[GitHub 搜索显示，有超过 8000 的结果](https://github.com/search?q=%5B%5B%5BUIDevice+currentDevice%5D+systemVersion%5D+substringToIndex%3A1%5D&type=Code&utf8=)调用了 `substringToIndex:1` 。所有这些代码碰到 iOS 10 就“懵逼”了。因为 iOS 10 会被检测成 iOS 1 了，估计只有在越狱的应用中才会出现吧。

又是同样的老故事。[Windows 9 变成 Windows 10](http://www.pcworld.com/article/2690724/why-windows-10-isnt-named-9-windows-95-legacy-code.html) 是因为有[太多代码](https://searchcode.com/?q=if%28version%2Cstartswith%28%22windows+9%22%29)通过 `if (name.startsWith("windows 9"))` 来检查 Windows 95 和 98 了。

## 新 API

苹果公司令人惊讶的花了相当长的时间才意识到这个问题并提供了更好的 API。iOS 8 中，终于有了一些改进！现在 [`NSProcessInfo`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSProcessInfo_Class/) 有一个新的 [`operatingSystemVersion`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSProcessInfo_Class/#//apple_ref/occ/instp/NSProcessInfo/operatingSystemVersion) 方法，更重要的是还有 [`- (BOOL)isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion)version`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSProcessInfo_Class/#//apple_ref/occ/instm/NSProcessInfo/isOperatingSystemAtLeastVersion:) 方法来检查。

    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 9, .minorVersion = 1, .patchVersion = 0}]) {
        NSLog(@"Hello from > iOS 9.1");
    }

    // Using short-form for the struct, we can make things somewhat more compact:
    if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9,3,0}]) {
        NSLog(@"Hello from > iOS 9.3");
    }



## 我们在 PSPDFKit 做了什么

[PSPDFKit](https://pspdfkit.com/why-pspdfkit/)  是一个关于 PDF 的 SDK，我们可以用它在PDF文档上实现查看、注释以及填写表单的功能。最开始写这个 SDK 的时候还是 iOS 4，随着一系列新 iOS 版本的发布，它也不断的在改进。那个时候还没有专门的 API 来检测版本，许多应用采用类似下面的代码：

    if ([[[UIDevice currentDevice] systemVersion] isEqualToString:@"7.0"]) {
        //do stuff
    }



这样用不好，所以我们从来没这样用过。比较字符串速度可能很快，但是在这种情况下是个错误的选择。正确的做法是像下面[这样](https://gist.github.com/alex-cellcity/998472)：

    #define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        ...
    }


这样又太笨重了，容易出错。有种更简单的方法。我们可以用 [`NSFoundationVersionNumber`](https://developer.apple.com/reference/foundation/nsfoundationversionnumber)（或者 [`kCFCoreFoundationVersionNumber`](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFBaseUtils/#//apple_ref/c/data/kCFCoreFoundationVersionNumber)）来比较。系统检测开销降低到一个简单的 if 比较。不需要调用其它方法，所以它效率极高，即使在紧凑的循环中表现也不错。

    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0) {
        // do stuff for iOS 9 and newer
    }
    else {
        // do stuff for older versions than iOS 9
    }


事实上，这正是苹果公司在 [2013 构建现代应用程序技术论坛中章节 2](http://devstreaming.apple.com/videos/techtalks/2013/15_Architecting_Modern_Apps_Part_2/Architecting_Modern_Apps_Part_2.pdf)所建议的。


告诫：有时候会缺少一些常量。`NSFoundationVersionNumber` 是在 `NSObjCRuntime.h` 中定义的，作为 Xcode 7.3.1 的一部分，我们设定常数范围从 iPhone OS 2 到 `#define NSFoundationVersionNumber_iOS_8_4 1144.17` - 而不是 9.0-9.3\。  对于  `kCFCoreFoundationVersionNumber` 也一样。注意，虽然这些数字很相似，但是它们的意义是不同的，所以使用其中一个或者另外一个。

如果你做 macOS 开发的话，也可以[使用 `NSAppKitVersionNumber` ，它通常是更新到最新的](http://nshipster.com/swift-system-version-checking/)。

在 SDK 10（Xcode 8）苹果补充了缺少的数字，甚至还有未来的版本。

    #define NSFoundationVersionNumber_iOS_9_0 1240.1
    #define NSFoundationVersionNumber_iOS_9_1 1241.14
    #define NSFoundationVersionNumber_iOS_9_2 1242.12
    #define NSFoundationVersionNumber_iOS_9_3 1242.12
    #define NSFoundationVersionNumber_iOS_9_4 1280.25
    #define NSFoundationVersionNumber_iOS_9_x_Max 1299




会有 iOS 9.4 吗？考虑到 iOS 10 将在未来 3 个月内发布，而且 9.3.3 仍然是 beta 版，我估计是不会有了，但是最好还是占个坑吧。在 PSPDFKit 中，我们是使用下面的模式来定义缺少的版本号。如果代码以一个更高的最低部署目标构建，代码会自动编译，当我们遗漏了一些 iOS 版本时，这会很有帮助。

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



请注意部分可用的宏。这是添加到 SDK 9 中出现的一个警告。当我们打包进版本代码块时，这些没什么用，所以禁用它。我们有一些单独的宏，在做一些其他类型的可用性检查时会有用。我们在某些情况下使用，例如在 `UICollectionView` 中实现一些交互动画，[在 iOS 9 中拖拽 tab 或者 page](https://pspdfkit.com/features/document-editor/ios/)，同时也要支持 iOS 8。

    #define PSPDF_PARTIAL_AVAILABILITY_BEGIN \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wpartial-availability\"")

    #define PSPDF_PARTIAL_AVAILABILITY_END \
    _Pragma("clang diagnostic pop")



### 为什么用这些宏

自从[前段时间我们放弃了 iOS 7](https://pspdfkit.com/guides/ios/current/announcements/version-support/)，我们可以轻易的切换到新的 `isOperatingSystemAtLeastVersion:` 方法上。其内部实现是通过调用 `operatingSystemVersion` ，是相当高效的。但它会产生更多的代码，仍然比我们现在的实现要慢一点。我没看到过基础检测的正面比较，但是可以肯定的说用了这些宏会更好，如果没有用宏的话，赶紧试试吧。

如果我们直接看 `operatingSystemVersion` 的实现，确实有点丑。它被缓存了，但是它通过调用 `_CFCopySystemVersionDictionary()` 生成版本号，然后查找 `kCFSystemVersionProductVersionKey` （就是 `ProductVersion`），然后对该字符串执行 `componentsSeparatedByString:` 。不知道为啥，我更期望这是硬编码，但是从外部字典文件读取可能更加灵活。

## Swift

由于 Swift 2.0 是[支持内置版本检查的语言](https://www.hackingwithswift.com/new-syntax-swift-2-availability-checking)，以前是这么用的：

    if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0)) {
        // modern code
    }


现在可以用更少的代码完成同样的事：


    if #available(iOS 10.0, *) {
        // modern code
    } else {
        // Fallback on earlier versions
    }



**Swift 还适用于代码块中 API 调用的可用性检查**，所以我们保证了编译时安全，在 Objective-C 是无法轻易做到的。 在 [“Swift in Practice” (WWDC 2015, Session 411)](https://developer.apple.com/videos/play/wwdc2015/411/)  8：40 开始，一名苹果工程师详细介绍了这一特性。


那么，Swift 底层是怎样实现的？好在它是开源的而且有着良好的结构。让我们来看看 [`Availability.swift`](https://github.com/apple/swift/blob/master/stdlib/public/core/Availability.swift#L20-L43):

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



现在，更有趣的是，`_swift_stdlib_operatingSystemVersion()` 是干什么的，它是怎么定义的？想要找到答案的话，我们得离开舒适的 Swift 世界了，然后深入探究 [“疯狂”的 Objective-C++] 。进入   [`Availability.mm`](https://github.com/apple/swift/blob/master/stdlib/public/stubs/Availability.mm#L26):

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



Swift 使用了 iOS 8 的新 API，但是低于 iOS 8 的版本又回退到糟糕的方法了，开放了  `@"/System/Library/CoreServices/SystemVersion.plist"` 文件。这样结果就会被缓存，版本检测会访问硬盘，但是只访问一次。我的第一反应是发送一个变化的 pull 请求，简单的使用已有的公用 API（`systemVersion`），然而 [Xcode 8 设置最小部署目标为 iOS 8](https://stackoverflow.com/questions/37817554/xcode-8-recommend-me-to-change-the-min-ios-deployment-target-from-7-1-to-8-0)，我们不可能看到另外一个有着 Swift 更新的 Xcode 7.3.x 发布，所以这段代码在低于 iOS 8 的版本可能是完全无用的。

## 更多关于向后兼容

值得注意的是，苹果正在努力让这些版本检测成为不必要的。当然还有 [`respondsToSelector:`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Protocols/NSObject_Protocol/index.html#//apple_ref/occ/intfm/NSObject/respondsToSelector:) 和 [`instancesRespondToSelector:`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSObject_Class/index.html#//apple_ref/occ/clm/NSObject/instancesRespondToSelector:) ，它们是 Objective-C 的一部分。假设你已经了解这些，那么使用它们是极好的，在某些情况下，我们也会使用。然而，还是有些情况不适用的。例如，有时苹果会把已经存在于一些组件或者更深层的内部构造中的有着不同特性的 API 公开。这就是为什么 [`appStoreReceiptURL` 在 iOS 7 中添加，但是 iOS 6 中也存在的原因](https://openradar.appspot.com/14216650)。在这种情况下，显式的版本是更可靠的。此外，当你希望放弃旧版本的 iOS 时，也更容易清理代码。所有需要你做的就是移除兼容性宏和修复构建错误。

### 弱链接

在很早的时候，使用一个不在所有版本中可用的类意味着要使用下面的模式：

    Class cls = NSClassFromString (@"NSRegularExpression");
    if (cls) {
        // Create an instance of the class and use it.
    } else {
        // Alternate code path to follow when the
        // class is not available.
    }



随着 iOS 4.2 [弱链接类](https://developer.apple.com/library/ios/documentation/DeveloperTools/Conceptual/cross_development/Using/using.html#//apple_ref/doc/uid/20002000-SW3)的添加，现在这要简单得多︰


    if ([UIPrintInteractionController class]) {
        // Create an instance of the class and use it.
    } else {
        // Alternate code path to follow when the
        // class is not available.
    }




[Greg Parker 在他的 Hamster Emporium 文章中分享了更多](http://sealiesoftware.com/blog/archive/2009/09/09/objc_explain_Weak-import_classes.html)，包括这个梗：

>为 Objective-C 增加弱导入是 Snow Leopard 没有按时发布的原因。假设在 Mac OS X 10.7（以猫科动物命名）按时发布，直到 Mac OS X 10.8 你才能用的上。

弱链接可以扩展到一个整体框架。在 PSPDFKit，我们为 [SafariServices](https://developer.apple.com/library/ios/documentation/SafariServices/Reference/SafariServicesFramework_Ref/) 做了扩展，其中包含 [`SFSafariViewController`](https://developer.apple.com/library/ios/documentation/SafariServices/Reference/SFSafariViewController_Ref/index.html#//apple_ref/occ/cl/SFSafariViewController)（在 iOS 9 中加入）。

    // Part of our .xcconfig file:
    -weak_framework SafariServices

弱链接在启动的时候会有些性能损耗，所以当你不得不使用的时候再用。想学习更多，看看 [Apple's SDK Compatibility Guide](https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/cross_development/Using/using.html#//apple_ref/doc/uid/20002000-SW6)。

## 结论

对于大多数应用，在 Objective-C 中使用 `isOperatingSystemAtLeastVersion:`，在 Swift 中使用 `#available()` 就足够了。了解底层实现还是很有趣的，一切都比字符串比较要好。如果你喜欢刨根问底，那么 [PSPDFKit 就是你该来的地方。](https://pspdfkit.com/jobs/)

## 更新

发表这篇文章之后，Devin Coughlin ，`#available` 方法的作者回复了为什么在 Swift 中不能使用 `systemVersion`：

> [@steipete Also: 为什么不用 "systemVersion"? 因为 UIDevice 在 macOS 中不存在，然后我们想在所有平台上使用同样的代码路径。](https://twitter.com/coughlin/status/750706938489425921)
