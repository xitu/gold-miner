> * 原文链接: [Simultaneous Xcode 7 and Xcode 8 compatibility](http://radex.io/xcode7-xcode8/)
* 原文作者 : [Radek](http://radex.io/about/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者 : 

You’re an iOS developer. You’re excited about all the great new features iOS 10 brings, and you’re eager to implement them in your app. You want to start working on it _right now_ so that you’re ready to ship on day one. But that’s still a few months away, and until then, you have to keep shipping new versions of your app every few weeks. Does that sound like you?

Of course, you can’t use Xcode 8 to compile your shipping app — it wouldn’t pass App Store validation. So you split your project into two branches, one stable, another for iOS 10 development…

And inevitably, it will suck. Branching works beautifully when merely working on a feature for a while. But try maintaining a huge branch for many months, with changes spread across the whole codebase, while the main branch also evolves, and you can brace yourself for some serious merging pains. I mean, have you ever tried to resolve `.xcodeproj` merge conflicts?

In this article, I will show you how to avoid branching altogether. For most apps, it should be possible to have a single project file that will compile for both iOS 9 (Xcode 7) and iOS 10 (Xcode 8). And even if you do end up branching, these tips will help you minimize the difference between your two branches, and make syncing them less painful.

## Swift 2.3 and you

Let me get this straight:

We’re all excited about Swift 3\. It’s awesome, and if you’re reading this article, _you shouldn’t be using it_ (yet). As great as it might be, it’s a huge source-incompatible change, much bigger than Swift 2 was a year ago. And if you have any Swift dependencies, they too need to upgrade to Swift 3 before your app can.

The great news is that, for the first time ever, Xcode 8 comes with _two_ versions of Swift: 2.3 and 3.0.

In case you missed the announcement, Swift 2.3 is the same language as Swift 2.2 in Xcode 7, but with some _minor_ API changes (more on those later).

So! To maintain simultaneous compatibility, we’ll be using Swift 2.3.

## Xcode settings

But that much is likely obvious to you. Now let me show you how to actually configure your Xcode project so that it runs on both versions.

### Swift version

![http://radex.io/assets/2016/xcode7-xcode8/BuildSettings.png](insert screenshot here)

To begin, open your project in Xcode 7\. Go to project settings, open the Build settings tab, and click the “+” to add a User-Defined Setting:

    “SWIFT_VERSION” = “2.3”

This option is new to Xcode 8, so while it will cause it to use Swift 2.3, Xcode 7 (which doesn’t _actually_ have Swift 2.3) just ignores it completely and keeps building with Swift 2.2.

### Framework provisioning

Xcode 8 makes some changes in how Framework provisioning works — they will continue to compile as-is for the simulator, but will fail to build for a device.

To fix this, go through Build Settings for all your Framework targets and add this option, like we did with `SWIFT_VERSION`:

    “PROVISIONING_PROFILE_SPECIFIER” = “ABCDEFGHIJ/“

Be sure to replace “ABCDEFGHIJ” with your Team ID (you can find it in [Apple Developer Portal](https://developer.apple.com/account/#/membership/)), and keep the forward slash at the end.

This essentially tells Xcode 8 “hey, I’m from this team, you take care of codesign, okay?”. And again, Xcode 7 will just ignore it, so you’re safe.

### Interface Builder

Go through all of your `.xib` and `.storyboard` files, open the right sidebar, go to the first (File inspector) tab, and find the “Opens in” setting.

It will most likely say “Default (7.0)”. Change it to “Xcode 7.0”. This will ensure that even if you touch the file in Xcode 8, it will only make changes that are backwards-compatible with Xcode 7.

I still suggest to be very careful about changing XIBs with Xcode 8\. It will add metadata about the Xcode version (I can’t guarantee that this is stripped when you upload to App Store), and will sometimes try to revert the file to Xcode 8-only format (this is a bug). When possible, avoid touching interface files from Xcode 8, and when you have to, carefully review the diff, and only commit the lines you need.

### SDK version

Make sure that your project and all its targets have the “Base SDK” build setting set to “Latest iOS”. (This will almost surely be true, but worth double-checking.) This way, Xcode 7 will compile for iOS 9, but you can open the same project in Xcode 8 and work on iOS 10 features.

### CocoaPods settings

If you’re using CocoaPods, you also have to update the Pods project to have the right Swift and provisioning settings.

But instead of doing this manually, add this post-install hook to your `Podfile`:


```
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    # Configure Pod targets for Xcode 8 compatibility
    config.build_settings['SWIFT_VERSION'] = '2.3'
    config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = 'ABCDEFGHIJ/'
    config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
  end
end
```


Again, be sure to replace `ABCDEFGHIJ` with your Team ID. And then run `pod install` to regenerate the Pods project.

### Open in Xcode 8

Alright, it’s time: open the project with Xcode 8\. The first time you do so, you will be bombarded with a lot of requests.

Xcode will urge you to upgrade to the new Swift. Decline.

Xcode will also suggest to update the project to “recommended settings”. Ignore this as well.

Remember, we already set up the project so it compiles on both versions. For now, it’s best to change as little as possible to keep simultaneous compatibility. And more importantly, we don’t want the `.xcodeproj` to contain any metadata about Xcode 8 while we use the same file to ship to the App Store.

## Dealing with Swift 2.3 differences

Like I said before, Swift 2.3 is the same _language_ as Swift 2.2\. However, the iOS 10 SDK _frameworks_ have updated their Swift annotations. I’m not talking about the [Grand Renaming](https://developer.apple.com/videos/play/wwdc2016/403/) (that only applies to Swift 3) — still, the names, types, and optionality of many APIs are slightly different.

### Conditional compilation

In case you missed it, Swift 2.2 [introduced](https://github.com/apple/swift-evolution/blob/master/proposals/0020-if-swift-version.md) conditional compilation preprocessor macro. It’s straightforward to use:



```
#if swift(>=2.3)
// this compiles on Xcode 8 / Swift 2.3 / iOS 10
#else
// this compiles on Xcode 7 / Swift 2.2 / iOS 9
#endif
```



Awesome! One file, no branching, simultaneous compatibility on two versions of Xcode.

Two caveats you need to be aware of:

*   There’s no `#if swift(<2.3)` or anything like that, you can only use `>=` (but you can use `#elseif`, if needed)
*   Unlike with the C pre-processor, the code between `#if` and `#else` must be valid Swift. You can’t, for example, just change a function signature, but not its body (see the examples later for solutions)

### Optionality changes

In Swift 2.3, many signatures lost their unnecessary optionality, and some (such as many properties of `NSURL`) now _became_ optional.

You could, of course, just use conditional compilation to deal with it, like:



```
#if swift(>=2.3)
let specifier = url.resourceSpecifier ?? ""
#else
let specifier = url.resourceSpecifier
#endif
```



But here’s a little helper you might find useful:



```
func optionalize<T>(optional: T?) -> T? {
    return optional
}

func optionalize<T>(nonoptional: T) -> T? {
    return nonoptional
}
```



I know, it’s a little weird. Perhaps it will be easier to explain if you first see the result:



```
let specifier = optionalize(url.resourceSpecifier) ?? "" // works on both versions!
```



We’re taking advantage of function overloading to get rid of ugly conditional compilation at call site. See, what the `optionalize()` function does is it turns whatever you pass in into an Optional, unless it’s already an Optional, in which case, it just returns the argument as-is. This way, regardless if the `url.resourceSpecifier` is optional (Xcode 8) or not (Xcode 7), the “optionalized” version is always the same.

(A note about the implementation, if you’re curious: the way the overloading rules work in Swift is, the more specific variant of a function will always be selected above a less specific variant. So, even though `String?` matches both variants — `T?` for `T = String` and `T` for `T = String?`, the argument is more closely matched with the first variant.)

### Typealiasing out signature changes

In Swift 2.3, a numer of functions (especially in the macOS SDK) have changed their argument types.

For example, the `NSWindow` initializer used to look like this:



```
init(contentRect: NSRect, styleMask: Int, backing: NSBackingStoreType, defer: Bool)
```



And now looks like this:



```
init(contentRect: NSRect, styleMask: NSWindowStyleMask, backing: NSBackingStoreType, defer: Bool)
```



Notice the type of `styleMask`. It used to be a loosely-typed Int (with the options imported as global constants), but in Xcode 8, it’s imported as a proper `OptionSetType`.

Unfortunately you can’t conditionally compile two versions of the signature with the same body block. But don’t worry, conditionaly-compiled type aliases come to rescue!



```
#if swift(>=2.3)
#else
typealias NSWindowStyleMask = Int
#endif
```


Now you can use `NSWindowStyleMask` in the signature, as you would with Swift 2.3\. And on Swift 2.2, where the type doesn’t exist, `NSWindowStyleMask` is just an alias for `Int`, so the type checker stays happy.

### Informal vs formal protocols

Swift 2.3 changed some previously [informal protocols](https://developer.apple.com/library/ios/documentation/General/Conceptual/DevPedia-CocoaCore/Protocol.html) to formal protocols.

For example, to be a `CALayer` delegate, you just had to descend from `NSObject`, no need to declare conformance to `CALayerDelegate`. Indeed, the protocol didn’t even exist in Xcode 7\. But it does now.

Again, the intuitive solution of conditionally compiling the class declaration line won’t work. But you can solve this by declaring your own dummy protocol on Swift 2.2, like so:



```
#if swift(>=2.3)
#else
private protocol CALayerDelegate {}
#endif

class MyView: NSView, CALayerDelegate { . . . }
```



## Building iOS 10 features

By this point, your project should be able to compile on both Xcode 7 and Xcode 8 without any branching necessary. Awesome!

It’s time to actually build iOS 10 features now, and with all of the tips and tricks described above, this should be fairly straightforward. Still, here are some things you need to be aware of:

1.  Just using `@available(iOS 10, *)` and `if #available(iOS 10, *)` is not enough. First of all, it’s safer not to compile any iOS 10 code in your shipping app. But more crucially, while the compiler requires these checks to ensure safe API usage, it still needs to be aware that an API exists. If you mention any method or type that doesn’t exist in iOS 9 SDK, the code won’t compile on Xcode 7.
2.  Therefore, you need to wrap all of your iOS 10-specific code in `#if swift(>=2.3)` (You can safely assume Swift 2.3 and iOS 10 are equivalent for now).
3.  Often times, you’ll need _both_ conditional compilation (so that you don’t compile unavailable code on Xcode 7) and `@available`/`#available` (to pass safety checks on Xcode 8).
4.  When you’re working on an iOS 10-specific feature, it’s easiest to extract all the relevant code into separate files — this way you can just wrap the whole contents of a file in a `#if swift…` check. (The file might still touch the compiler on Xcode 7, but all of its contents will be ignored.)

## App extensions

But the thing is, if you’re working on iOS 10, you probably want to make one of those new extensions for your app, not merely add more code to the app itself.

That’s tricky. We can conditionally compile our code, but there’s no such thing as a “conditional target”.

The good news is that Xcode 7 won’t complain about those targets as long as it doesn’t have to actually compile them. (Yes, it might issue a warning that the project contains a target configured to deploy on a higher version of iOS than the base SDK, but that’s not a big deal.)

So here’s the idea: keep the target and its code everywhere, but conditionally remove it from the “Target Dependencies” and “Embed App Extensions” build phases of the app target.

How to do this? The best approach I came up with is to have the app extension disabled from build by default for Xcode 7 compatibility. And only while you’re working with Xcode 8, re-add the extensions temporarily, but never actually commit the change.

If doing this manually sounds fickle (not to mention incompatible with CI and automated builds), don’t worry, I made a script for you!

To install it:

```
sudo gem install configure_extensions

```

Before comitting any changes in the Xcode project, remove iOS 10-only app extensions from the app target:

```
configure_extensions remove MyApp.xcodeproj MyAppTarget NotificationsUI Intents

```

And to work with Xcode 8, add them back:

```
configure_extensions add MyApp.xcodeproj MyAppTarget NotificationsUI Intents

```

You can put this your `script/`, use it with Xcode build pre-actions, with Git pre-commit hooks, or integrate it with your CI or automated build system. (More info about the tool on [GitHub](https://github.com/radex/configure_extensions))

One final note about iOS 10 app extensions: Xcode templates for those will generate Swift 3, not Swift 2.3 code. This won’t actually work, so make sure to set the app extension’s “Use Legacy Swift Language Version” build setting to “Yes”, and rewrite the code to Swift 2.3.

## In September

Once September hits and iOS 10 is out, it’s time to drop Xcode 7 support and clean up your project!

I made a little checklist for you (be sure to bookmark it for future reference):

*   Remove any Swift 2.2 code left over and the unnecessary `#if swift(>=2.3)` checks
*   Remove any transition hacks, such as uses of `optionalize()`, temporary typealiases, or dummy protocols
*   Remove uses of the `configure_extensions` script, and commit the project settings with new app extensions enabled
*   Update CocoaPods, if you use it, and remove the `post_install` hook we’ve added from your `Podfile` (it will almost surely not be necessary by September)
*   Update to recommended Xcode project settings (select project in the sidebar, then in the menu: Editor → Validate Settings…)
*   Consider upgrading your provisioning settings to use the new `PROVISIONING_PROFILE_SPECIFIER`
*   Make sure all of the Swift libraries you depend on have updated to Swift 3\. If not, consider contributing the Swift 3 port yourself.
*   When all of the above is ready, you can upgrade your app to Swift 3! Go to Edit → Convert → To Current Swift Syntax…, select all of your targets (remember, you need to convert everything at once), review the diff, test, and commit!
*   If you haven’t done so already, consider removing support for iOS 8 — this way you can get rid of more `@available` checks and other conditional code.

Good luck!

Published July 28, 2016. [Send feedback](http://radex.io/xcode7-xcode8/).
