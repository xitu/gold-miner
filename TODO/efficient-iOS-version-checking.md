>* 原文链接 : [Efficient iOS Version Checking](https://pspdfkit.com/blog/2016/efficient-iOS-version-checking/)
* 原文作者 : [Peter Steinberger](https://twitter.com/steipete)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Few apps have the luxury to support only the most recent version of iOS. It's often necessary to set a lower [deployment target](https://pspdfkit.com/guides/ios/current/announcements/version-support/) and branch in code based on specific versions of iOS. There are various ways to accomplish this and even Apple's message is a bit conflicted. I recently saw [this tweet](https://twitter.com/stevemoseley/status/748953473069092864) where someone basically warns to **not** do this:



    #define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)



A [GitHub search shows that there are over 8000 results](https://github.com/search?q=%5B%5B%5BUIDevice+currentDevice%5D+systemVersion%5D+substringToIndex%3A1%5D&type=Code&utf8=) calling `substringToIndex:1`. All of that code will break with iOS 10\. It will instead assume iOS 1, where the only apps that existed were jailbreak apps.

It's the same old story again. [Windows 9 became Windows 10](http://www.pcworld.com/article/2690724/why-windows-10-isnt-named-9-windows-95-legacy-code.html) because there was [too much code out there](https://searchcode.com/?q=if%28version%2Cstartswith%28%22windows+9%22%29) checking for Windows 95 and 98 via `if (name.startsWith("windows 9"))`.

## New API

It took surprisingly long for this problem to be recognized and better API to be offered. With iOS 8, we finally got some improvements! There's now a new [`operatingSystemVersion`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSProcessInfo_Class/#//apple_ref/occ/instp/NSProcessInfo/operatingSystemVersion) method on [`NSProcessInfo`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSProcessInfo_Class/), and more importantly the [`- (BOOL)isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion)version`](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSProcessInfo_Class/#//apple_ref/occ/instm/NSProcessInfo/isOperatingSystemAtLeastVersion:) method to check:



    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){.majorVersion = 9, .minorVersion = 1, .patchVersion = 0}]) {
        NSLog(@"Hello from > iOS 9.1");
    }

    // Using short-form for the struct, we can make things somewhat more compact:
    if ([NSProcessInfo.processInfo isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9,3,0}]) {
        NSLog(@"Hello from > iOS 9.3");
    }



## What we do at PSPDFKit

[PSPDFKit is an SDK to view, annotate and fill forms on PDF documents.](https://pspdfkit.com/why-pspdfkit/) It was originally written when iOS 4 was around and has continued to evolve as new iOS versions have been released. Back then there was no dedicated API to check for the version, and many apps did something like this:



    if ([[[UIDevice currentDevice] systemVersion] isEqualToString:@"7.0"]) {
        //do stuff
    }



This was never a good idea so we never used it. A string compare might be fast but it's the wrong choice in this case. To get it right, you'd need to do something [like this](https://gist.github.com/alex-cellcity/998472):



    #define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) \
      ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        ...
    }



Clunky. Easy to get wrong. There's a simpler way. We can use the [`NSFoundationVersionNumber`](https://developer.apple.com/reference/foundation/nsfoundationversionnumber) (or the [`kCFCoreFoundationVersionNumber`](https://developer.apple.com/library/ios/documentation/CoreFoundation/Reference/CFBaseUtils/#//apple_ref/c/data/kCFCoreFoundationVersionNumber)) to compare. The system check reduces to a simple `if` compare. No method calls required, so it's extremely efficient, even in tight loops.



    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_9_0) {
        // do stuff for iOS 9 and newer
    }
    else {
        // do stuff for older versions than iOS 9
    }



In fact, this is exactly what Apple suggested at the [2013 Tech Talks in the Architecting Modern Apps, Part 2](http://devstreaming.apple.com/videos/techtalks/2013/15_Architecting_Modern_Apps_Part_2/Architecting_Modern_Apps_Part_2.pdf) session.

Caveat: Sometimes the constants are missing. `NSFoundationVersionNumber` is defined in `NSObjCRuntime.h` and as part of Xcode 7.3.1 we have constants ranging from iPhone OS 2 to `#define NSFoundationVersionNumber_iOS_8_4 1144.17` - not 9.0-9.3\. Same for `kCFCoreFoundationVersionNumber`. Note that while these numbers are similar, they are not the same. So use one or the other.

If you do macOS development, you can also [use the `NSAppKitVersionNumber` which is usually kept more up to date.](http://nshipster.com/swift-system-version-checking/)

In SDK 10 (Xcode 8) Apple added the missing numbers and even some future ones.



    #define NSFoundationVersionNumber_iOS_9_0 1240.1
    #define NSFoundationVersionNumber_iOS_9_1 1241.14
    #define NSFoundationVersionNumber_iOS_9_2 1242.12
    #define NSFoundationVersionNumber_iOS_9_3 1242.12
    #define NSFoundationVersionNumber_iOS_9_4 1280.25
    #define NSFoundationVersionNumber_iOS_9_x_Max 1299



Will there be an iOS 9.4? Considering iOS 10 will be released in three months and 9.3.3 is in beta, I wouldn't expect it but it is still nice to have a placeholder. In PSPDFKit, we define the missing version numbers using the following pattern below. If our code is built with a higher minimum deployment target, the code is automatically compiled out, which helps a lot when we drop iOS versions.



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



    #define PSPDF_PARTIAL_AVAILABILITY_BEGIN \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Wpartial-availability\"")

    #define PSPDF_PARTIAL_AVAILABILITY_END \
    _Pragma("clang diagnostic pop")



### Why these macros?

Since [we dropped iOS 7 a while ago](https://pspdfkit.com/guides/ios/current/announcements/version-support/), we could easily switch to the new `isOperatingSystemAtLeastVersion:`. Its implementation calls `operatingSystemVersion` internally and is quite efficient. It would produce a bit more code and would still be slightly slower than our current implementation. I don't see any upside compared to the foundation check, but it's certainly nicer to use if you're not using macros.

Things get ugly if we look at the implementation of `operatingSystemVersion` directly. It's cached, but it does generate the version via calling `_CFCopySystemVersionDictionary()` and then looking up `kCFSystemVersionProductVersionKey` (which is `ProductVersion`) and then calling `componentsSeparatedByString:` on that string. I somehow expected this to be hardcoded, but reading it from an external dictionary file is probably more flexible.

## Swift

As of Swift 2.0 there's [support for version checking built right into the language](https://www.hackingwithswift.com/new-syntax-swift-2-availability-checking). So instead of calling:



    if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 10, minorVersion: 0, patchVersion: 0)) {
        // modern code
    }



You can now do the same with much less code:



    if #available(iOS 10.0, *) {
        // modern code
    } else {
        // Fallback on earlier versions
    }



**Swift also correctly applies the partial availability checks** for API called within these blocks, so we get compile-time safety that we cannot easily copy in Objective-C. In ["Swift in Practice" (WWDC 2015, Session 411)](https://developer.apple.com/videos/play/wwdc2015/411/) starting 08:40 an Apple engineer explains this in great detail.

So, what is Swift using under the hood? Good thing that it's open source and well structured! Let's take a look at [`Availability.swift`](https://github.com/apple/swift/blob/master/stdlib/public/core/Availability.swift#L20-L43):



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

