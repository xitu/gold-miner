> * 原文地址：[Getting to Swift 3](https://medium.com/airbnb-engineering/getting-to-swift-3-at-airbnb-79a257d2b656#.b0f62n181)
* 原文作者：[Chengyin Liu](https://twitter.com/chengyinliu), [Paul Kompfner](https://github.com/kompfner), [Michael Bachand](https://twitter.com/michaelbachand)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Getting to Swift 3 #

<img class="progressiveMedia-noscript js-progressiveMedia-inner" src="https://cdn-images-1.medium.com/max/800/1*yRyt_nc-U0j7xGW0bMADOg.png">

Airbnb has been using Swift since the language’s inception. We’ve seen many benefits from using this modern, safe, community-driven language.

Until recently, a large part of our codebase had been in Swift 2. We’ve just finished our migration to Swift 3, right in time for the release of Xcode that drops Swift 2 support.

We want to share with the community our approach to this migration, the effect Swift 3 has had on our app, and some technical insights we gained along the way.

### The “No Disruption to Development” Approach ###

We have dozens of modules and several 3rd-party libraries written in Swift, comprising thousands of files and hundreds of thousands of lines of code. As if the size of this Swift codebase weren’t enough of a challenge, the fact that Swift 2 and Swift 3 modules cannot import each other further complicated the migration process. Since the Swift ABI changed between versions 2 and 3, even correct Swift 3 code that imports Swift 2 libraries will not compile. This incompatibility made it difficult to parallelize code conversion.

To make sure we could incrementally convert and validate our code, we began by creating a dependency graph which topologically sorted our 36 Swift modules. Our upgrade plan was as follows:

1. Upgrade CocoaPods to 1.1.0 (to support a necessary pod upgrade)

2. Upgrade 3rd-party pods to Swift 3 versions

3. Convert our own modules in topological order

From speaking with other companies who had already completed the migration, we learned that freezing development was a common strategy. We wanted to avoid a code freeze if at all possible, even if it meant some added difficulty for those doing the migration. Since the conversion work would not be easily parallelizable, an all-hands-on-deck approach would be inefficient. Also, since it was difficult to estimate how long the conversion would take, we wanted to ensure that we could continue to ship new releases during the migration.

We had three people working on the migration. Two people focused on the code conversion, and the third focused on coordinating, communicating with the team, and benchmarking.

Including the preparation work, our project timeline looked like this:

- 1 Week: investigation and preparation (one person)

- 2.5 Weeks: conversion (two people), profiling impact of conversion and communication with larger team (one person)

- 2 Weeks: QA and bug fixing (QA team + assorted iOS feature owners)

### The Impact of Swift 3 ###

While we were excited about Swift 3’s new language features, we also wanted to understand how the update would affect our end users and overall developer experience. We closely monitored Swift 3’s impact on release IPA size and debug build time, since these have been our two largest Swift pain points so far. Unfortunately, after experimenting with different optimization settings, Swift 3 still scored marginally worse on both metrics.

#### Release IPA Size ####

After migrating to Swift 3, we saw a 2.2MB increase in our release IPA. A bit of digging revealed that this was almost entirely due to increases in the size of Swift’s libraries (the size of our own binaries barely changed). Here are a few examples we found of increases in uncompressed binary size:

- libswiftFoundation.dylib: up 233.40% (3.8 MB)

- libswiftCore.dylib: up 11.76% (1.5 MB)

- libswiftDispatch.dylib: up 344.61% (0.8 MB)

Given the enhancements in Swift 3’s libraries like Foundation, this change is understandable. Although, when the much-anticipated stable Swift ABI lands, applications should no longer have to suffer size increases to benefit from these enhancements.

#### Debug Build Time ####

Our debug build time was 4.6% slower after the migration, adding 16 seconds to what was previously 6 minutes.

We tried to compare per-function compile times between Swift 2 and Swift 3, but were unable to draw concrete conclusions since the profiles were so different. However, we did find a function whose compile time had ballooned to 12 seconds due to the migration. Fortunately, we were able to massage it back down, but it illustrated to us the importance of checking converted code for outliers like this. Tools like [Build Time Analyzer for Xcode](https://github.com/RobertGummesson/BuildTimeAnalyzer-for-Xcode)  can help, or you can just [set the appropriate Swift compiler flags and parse the resulting build logs](http://irace.me/swift-profiling) .

#### Runtime Issues ####

Unfortunately, the migration work isn’t finished even after your code compiles in Swift 3. The Xcode code conversion tool doesn’t guarantee identical runtime behavior. Moreover, as we’ll discuss later, the code conversion still involves manual work and there are some gotchas. This, unfortunately, can mean regressions. Since our unit test coverage didn’t give us sufficient confidence, we had to spend extra QA cycles on the newly migrated app.

The first QA pass through the newly migrated app yielded dozens of fairly obvious issues. The vast majority of issues were resolved quickly (in a matter of hours) by the 3-person team responsible for the migration, primarily through the application of a couple of the techniques discussed later in this doc. After this initial elimination of the low-hanging, highly visible regressions, the iOS team at large was left with 15 potential regressions — 3 of which were crashes — that required investigation before the next app version release.

### The Code Conversion Process ###

We started by creating a new `swift-3` branch from `master`. As mentioned earlier, we tackled the code conversion module by module, starting with leaf modules and working our way up the dependency tree. Wherever possible, we worked on converting different modules in parallel. When we couldn’t, we sat together, calling out what we were working on so as to avoid collisions.

For each module, the process was roughly the following:

1. Create a new branch from the `swift-3` branch

2. Run the Xcode code conversion tool on the module

3. Commit and push changes

4. Build

5. Manually fix a number of build errors

6. Commit and push changes

7. Rebuild

8. Repeat the previous 3 steps until finished

When manually updating code, we held to the philosophy “do the most literal code conversion.” This meant that we didn’t aim to improve the safety of our code during the conversion. We did this for two reasons. First, since the team was actively developing in Swift 2, the process was a race against time. Second, we wanted to minimize the ever-present risk of introducing regressions.

Fortunately, we undertook this project during a period of time when work was slower due to the holidays. This meant that we could safely go a number of days without rebasing `swift-3` onto `master` without falling too far behind. Whenever we did rebase, we used `git rebase -Xours master` to keep as much of `swift-3` as possible while defaulting to code in `master` to resolve conflicts.

Once `swift-3` was caught up with `master`, we knew we’d need about a day to sort through a number of issues before we’d be comfortable merging it. With an iOS team our size, though, `master` is a moving target. So, to complete the Swift 3 migration we strongly encouraged the entire team (minus the ones doing the migration) to really, truly take a Saturday off work 😄.

### Issues Worth Mentioning ###

#### Block Parameters in Objective-C ####

One of the most common issues we encountered where Xcode did not automatically suggest a fix has to do with bridging block parameters between Objective-C and Swift. Consider this method declaration in an Objective-C header:

![Markdown](http://i1.piimg.com/1949/300646b3b962e346.png)

A number of things have changed, but most importantly the parameter in `completionBlock` has changed from an implicitly unwrapped optional to an optional. This can break its usage within the blocks.

We decided that the most “literal” translation into Swift 3 (without touching Objective-C code) would be to declare at the top of the block a variable that has the same name as the parameter but is implicitly unwrapped:

![Markdown](http://i1.piimg.com/1949/bbdc00bdcba906bb.png)

Doing this, rather than actually unwrapping the parameter when it’s used, is the least likely to break semantics elsewhere in the block. In the above example, subsequent statements like `if let someReview = review { /* … */ } `and `review ?? anotherReview` would continue to work as expected.

#### Type Inference in Assignment of Implicitly Unwrapped Optionals ####

Another common (and related) issue has to do with how Swift 3 infers the type of a variable to which an implicitly unwrapped optional is assigned. Consider the following:

```
func doSomething() -> Int! {
  return 5
}

var result = doSomething()
```
In Swift 2.3, `result` was inferred to be of type `Int!`. In Swift 3, it’s of type `Int?`.

For reasons outlined with the block parameters, the most literal solution is to declare your variable to be an implicitly unwrapped optional type:

```
var result: Int! = doSomething()
```

This particular issue appeared more often than expected because bridged Objective-C initializers return implicitly unwrapped optionals.

#### Compile Time Explosion for Individual Functions ####

Occasionally during our code conversion work, the compiler would grind to a halt for many minutes.

Our project is home to some functions that require a lot of complex type inference. Under normal conditions these take a trivial amount of time to compile. But when they contain compilation errors, it can send the compiler into a tailspin.

When our progress was blocked by this type of problem, we used the [Build Time Analyzer for Xcode](https://github.com/RobertGummesson/BuildTimeAnalyzer-for-Xcode)  to help us discover where the bottleneck was. Then we could focus our efforts on that function and unblock our happy cycle of converting code, rebuilding, and converting more code.

#### “Near misses” on Optional Protocol Method Implementations ####

Optional protocol methods are easy to accidentally miss during a Swift 3 conversion.

Consider this method on `UICollectionViewDataSource`:

```
func collectionView(
  _ collectionView: UICollectionView, 
  viewForSupplementaryElementOfKind kind: String, 
  at indexPath: IndexPath) -> UICollectionReusableView
```
Suppose your class implements `UICollectionViewDataSource` and declares the following method:

```
func collectionView(
  collectionView: UICollectionView, 
  viewForSupplementaryElementOfKind kind: String, 
  atIndexPath indexPath: IndexPath) -> UICollectionReusableView
```

Can you spot the differences? It’s tough. But they’re there. And your class will compile just fine without updating the definition’s signature since it’s an optional protocol method.

Fortunately, there are compiler warnings to help you in some of these cases, but not all. It’s important to go through any types implementing protocols with optional methods — like most UIKit delegate and data source protocols — and verify their correctness. Searches for text like “`func collectionView(collectionView:`” (note the first parameter label, a sure sign of lingering Swift 2) can help you find offenders in your codebase.

#### Protocols with Default Method Implementations ####

Protocols may have default method implementations provided through protocol extensions. If a protocol’s method signature has changed between Swift 2 and Swift 3, it’s important to verify that it’s been changed everywhere. The compiler will happily compile if *either* the protocol extension’s implementation *or* your type’s implementation is correct, but successful compilation is no guarantee that *both* implementations are correct.

#### Enums with String Raw Values ####

In Swift 3, naming convention dictates that enum cases be `lowerCamelCase`. The Xcode code conversion tool will automatically make appropriate changes to any existing enums. It skips enums, however, whose raw value type is `String`. There is a good reason for this — it’s possible to initialize one of these enums with a `String` matching an enum case name. If you change the enum case name you risk breaking initialization somewhere. You may be tempted to “finish the job” by lower-casing some enum cases yourself, but only do so if you have the utmost confidence that it won’t break `String`-based initialization somewhere.

#### 3rd-party Library API Changes ####

Like most apps, we have some dependencies on 3rd-party libraries. The migration required updating any libraries written in Swift. This should hopefully seem obvious, but it’s worth mentioning: read release notes very carefully, especially if your dependency has undergone a major version change (which is likely when changing language versions). It helped us discover some non-obvious API changes that the compiler would not have been able to help us with.

### Next Steps ###

Whew! Our `master` branch is in Swift 3, and no new development is taking place in Swift 2. All migration-related work is done, right?

Well, not quite. As mentioned earlier, during the code conversion process we were only making the most “literal” conversion between Swift 2 and Swift 3 code. This means that we weren’t always taking advantage of Swift 3’s added safety or its new conventions.

On an ongoing basis, we’ll be looking out for a number of potential improvements.

#### More Fine-Grained Access Control ####

By default, the Xcode code conversion tool converts `private` access control modifiers to `fileprivate`, and `public` ones to `open`. This represents a “literal” conversion which guarantees that the code will continue to work as before. However, it also bypasses an opportunity for the developer to consider whether the new `private` and `public` behaviors are actually *better *tools for the job. A next step is to revisit instances of literal access control conversion and check whether we can make use of Swift 3’s increased expressiveness to provide more fine-grained control.

#### Swift 3 Method Naming ####

When manually converting code (when the Xcode conversion tool didn’t suffice, or when we were rebasing) we often took a “literal” approach to changing method names so that call sites would continue to be correct. Take the following Swift 2.3 method signature, for instance:

```
func incrementCounter(counter: Counter, atIndex index: Int)
```

In the interest of making the smallest, quickest change that would get our code compiling again in Swift 3, we would convert this to:


```
func incrementCounter(_ counter: Counter, atIndex index: Int)
```

A more “Swift 3” way of writing this, however, would be:

```
func increment(_ counter: Counter, at index: Int)
```

A next step is finding instances where took the naming shortcut and updating method signatures to better follow Swift 3 conventions.

#### Safer Use of Implicitly Unwrapped Optionals ####

As shown earlier, the way we dealt with newly-optional (in Swift 3) Objective-C block parameters was by assigning them right away to implicitly unwrapped optional variables, which obviates the need to update much of the code within the block. However, what we *should* be doing in our block is appropriately handling the possibility of the parameter being `nil`.

#### Fix Warnings ####

In an effort to wrap up the code conversion process quickly, we ended up ignoring a fair number of compiler warnings that didn’t strike us as especially urgent. Going forward, we’ll have to be conscious of getting our warning count back down.

### Conclusion ###

As Airbnb was an early and eager adopter of Swift, we accumulated lots of Swift code. The prospect of migrating to Swift 3 seemed daunting at first, and it wasn’t clear how we were going proceed or how it would affect our app. If you haven’t yet decided to convert your code to Swift 3, we hope our experience has helped demystify the process a bit.

Finally, if you’re interested in using the latest mobile technologies like Swift 3 to help people belong anywhere, [we’re hiring!](https://www.airbnb.com/careers/departments/engineering)
