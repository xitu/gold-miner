>* 原文链接 : [Swift 3.0 Release Process](https://swift.org/blog/swift-3-0-release-process/)
* 原文作者 : [Ted Kremenek](https://github.com/tkremenek/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


This post describes the goals, release process, and estimated schedule for Swift 3.0.

Swift 3.0 is a major release that is _not_ source-compatible with Swift 2.2\. It contains fundamental changes to the language and Swift Standard Library. A comprehensive list of implemented changes for Swift 3.0 can be found on the [Swift evolution site](https://github.com/apple/swift-evolution#implemented-proposals-for-swift-3).

Swift 3.0 is also the first release to include the [Swift Package Manager](https://swift.org/package-manager/). While the Swift Package Manager is still early in its development, it supports the development and distribution of cross-platform Swift packages. The Swift Package Manager will be available on both Darwin and Linux.

For Linux, Swift 3 will also be the first release to contain the [Swift Core Libraries](https://swift.org/core-libraries/).

Swift 3.0 is expected to be released sometime in late 2016\. In addition to its Swift.org release, Swift 3.0 will ship in a future version of Xcode.

## Developer Previews

*   Swift 3.0 will have a series of developer previews (i.e., “seeds” or “betas”) that provide qualified and converged builds of Swift 3\. The goal is to provide users with more stable and qualified Swift binaries that they can [download](https://swift.org/download) and try out (and file bugs against) instead of just grabbing the latest snapshot of `master`.

*   The cadence between Developer Previews will likely be irregular, but likely every 4-6 weeks. They will be partially driven by the volume of change going into `master` and how much time is needed to stabilize a developer preview branch.

*   Swift 3.0 will be declared “GM” from the last developer preview branch.

*   Content going into developer previews will be managed by the appropriate release manager (see below).

## Getting Changes into Swift 3.0

### Branches

*   **master**: Development of Swift 3.0 happens in `master`. All changes going in `master` will be part of the final Swift 3.0 release until the last developer preview branch is created. At that point `master` tracks development for future Swift releases.

*   **swift-3.0-preview--branch**: Branches for developer previews will be created from `master`. All changes to those branches will need to be submitted via pull requests that initiate testing on continuous integration. The release manager for the given repository approves merging a pull request into the developer preview branch.

*   **swift-3.0-branch**: The last developer preview branch created from `master` will be called `swift-3.0-branch`. This will be the final “release branch”.

### Philosophy on Taking Changes into Swift 3.0

*   As Swift 3.0 converges only changes that align with the core goals of the release will be considered.

*   Source-breaking changes to the language will be considered on a case-by-case basis.

*   All language and API changes for Swift 3.0 will go through the [Swift Evolution](https://github.com/apple/swift-evolution) process.

*   Criteria — as set by the release manager — for accepting changes will becoming increasingly restrictive over time as the release converges. The same policy applies to developer preview branches, which are essentially mini-releases.

## Schedule

*   The first developer preview branch `swift-3.0-preview-1-branch` will be created from `master` on **May 12**. It will be released 4-6 weeks later.

*   The date for creating the last developer preview branch — `swift-3.0-branch` — has not yet been established. When that date is determined the plan will be communicated both on [swift-dev](https://lists.swift.org/mailman/listinfo/swift-dev) and by updating this post.

## Impacted Repositories

The following repositories will have `swift-3.0-preview-<x>-branch</x>`/`swift-3.0-branch` branches to track sources as part of Swift 3.0 release:

*   [swift](https://github.com/apple/swift)
*   [swift-lldb](https://github.com/apple/swift-lldb)
*   [swift-cmark](https://github.com/apple/swift-cmark)
*   [swift-llbuild](https://github.com/apple/swift-llbuild)
*   [swift-package-manager](https://github.com/apple/swift-package-manager)
*   [swift-corelibs-libdispatch](https://github.com/apple/swift-corelibs-libdispatch)
*   [swift-corelibs-foundation](https://github.com/apple/swift-corelibs-foundation)
*   [swift-corelibs-xctest](https://github.com/apple/swift-corelibs-xctest)

The following repositories will only have a `swift-3.0-branch` instead of developer preview branches, as they have already effectively converged:

*   [swift-llvm](https://github.com/apple/swift-llvm)
*   [swift-clang](https://github.com/apple/swift-clang)

## Release Managers

The overall management of the release will be overseen by the following individuals, who will announce when stricter control of change goes into effect for the Swift 3.0 release as the release converges:

*   [Ted Kremenek](https://github.com/tkremenek) is the overall release manager for Swift 3.0.

*   [Frédéric Riss](https://github.com/fredriss) is the release manager for [swift-llvm](https://github.com/apple/swift-llvm) and [swift-clang](https://github.com/apple/swift-clang).

*   [Kate Stone](https://github.com/k8stone) is the release manager for [swift-lldb](https://github.com/apple/swift-lldb).

*   [Tony Parker](https://github.com/parkera) is the release manager for [swift-corelibs-foundation](https://github.com/apple/swift-corelibs-foundation).

*   [Daniel Steffen](https://github.com/das) is the release manager for [swift-corelibs-libdispatch](https://github.com/apple/swift-corelibs-libdispatch).

*   [Mike Ferris](https://github.com/mike-ferris-apple) is the release manager for [swift-corelibs-xctest](https://github.com/apple/swift-corelibs-xctest).

*   [Rick Ballard](https://github.com/rballard) is the release manager for [swift-package-manager](https://github.com/apple/swift-package-manager).

Please feel free to email [swift-dev](https://lists.swift.org/mailman/listinfo/swift-dev) or [Ted Kremenek](https://github.com/tkremenek) directly concerning any questions about the release management process.

## Pull Requests for Developer Previews

All pull requests nominating changes for inclusion in developer preview branches should include the following information:

*   **Explanation**: A description of the issue being fixed or enhancement being made. This can be brief, but it should be clear.

*   **Scope**: An assessment of the impact/importance of the change. For example, is the change a source-breaking language change, etc.

*   **SR Issue**: The SR if the change fixes/implements an issue/enhancement on [bugs.swift.org](https://bugs.swift.org).

*   **Risk**: What is the (specific) risk to the release for taking this change?

*   **Testing**: What specific testing has been done or needs to be done to further validate any impact of this change?

One or more [code owners](https://swift.org/community/#code-owners) for the impacted components should review the change. Technical review can be delegated by a code owner or otherwise requested as deemed appropriate or useful.

**All change** going into developer preview branches **must go through pull requests** that are accepted by the corresponding release manager.



