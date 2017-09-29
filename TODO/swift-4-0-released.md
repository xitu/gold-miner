
> * 原文地址：[Swift 4.0 Released!](https://swift.org/blog/swift-4-0-released/)
> * 原文作者：[Ted Kremenek](https://github.com/tkremenek/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/swift-4-0-released.md](https://github.com/xitu/gold-miner/blob/master/TODO/swift-4-0-released.md)
> * 译者：
> * 校对者：

# Swift 4.0 Released!

Swift 4 is now officially released! Swift 4 builds on the strengths of Swift 3, delivering greater robustness and stability, providing source code compatibility with Swift 3, making improvements to the standard library, and adding features like archival and serialization.

You can watch a quick overview of it by watching the [WWDC 2017: What’s New in Swift](https://developer.apple.com/videos/play/wwdc2017/402/) presentation, and try out some of the new features in this [playground](https://github.com/ole/whats-new-in-swift-4) put together by Ole Begemann.

## Language updates

Swift 4.0 is a major language release and contains the following language changes and updates that went through the Swift Evolution process:

### String

Swift 4 includes a faster, easier to use String implementation that retains Unicode correctness and adds support for creating, using and managing substrings.

See more at:

- [SE-0163 String Revision: Collection Conformance, C Interop, Transcoding](https://github.com/apple/swift-evolution/blob/master/proposals/0163-string-revision-1.md)
- [SE-0168 Multi-Line String Literals](https://github.com/apple/swift-evolution/blob/master/proposals/0168-multi-line-string-literals.md)
- [SE-0178 Add unicodeScalars property to Character](https://github.com/apple/swift-evolution/blob/master/proposals/0178-character-unicode-view.md)
- [SE-0180 String Index Overhaul](https://github.com/apple/swift-evolution/blob/master/proposals/0180-string-index-overhaul.md)
- [SE-0182 String Newline Escaping](https://github.com/apple/swift-evolution/blob/master/proposals/0182-newline-escape-in-strings.md)
- [SE-0183 Substring performance affordances](https://github.com/apple/swift-evolution/blob/master/proposals/0183-substring-affordances.md)

## Collection

Swift 4 adds improvements for creating, using and managing Collection types.

See more at:

- [SE-0148 Generic Subscripts](https://github.com/apple/swift-evolution/blob/master/proposals/0148-generic-subscripts.md)
- [SE-0154 Provide Custom Collections for Dictionary Keys and Values](https://github.com/apple/swift-evolution/blob/master/proposals/0154-dictionary-key-and-value-collections.md)
- [SE-0165 Dictionary & Set Enhancements](https://github.com/apple/swift-evolution/blob/master/proposals/0165-dict.md)
- [SE-0172 One-sided Ranges](https://github.com/apple/swift-evolution/blob/master/proposals/0172-one-sided-ranges.md)
- [SE-0173 Add MutableCollection.swapAt(_:_:)](https://github.com/apple/swift-evolution/blob/master/proposals/0173-swap-indices.md)

## Archival and serialization

Swift 4 supports archival of struct and enum types and enables type-safe serialization to external formats such as JSON and plist.

See more at: [SE-0166 Swift Archival & Serialization](https://github.com/apple/swift-evolution/blob/master/proposals/0166-swift-archival-serialization.md)

## Additional language updates

Swift 4 also implements the following language proposals from the Swift Evolution process:

- [SE-0104 Protocol-oriented integers](https://github.com/apple/swift-evolution/blob/master/proposals/0104-improved-integers.md)
- [SE-0142 Permit where clauses to constrain associated types](https://github.com/apple/swift-evolution/blob/master/proposals/0142-associated-types-constraints.md)
- [SE-0156 Class and Subtype existentials](https://github.com/apple/swift-evolution/blob/master/proposals/0158-package-manager-manifest-api-redesign.md)
- [SE-0160 Limiting @objc inference](https://github.com/apple/swift-evolution/blob/master/proposals/0160-objc-inference.md)
- [SE-0164 Remove final support in protocol extensions](https://github.com/apple/swift-evolution/blob/master/proposals/0164-remove-final-support-in-protocol-extensions.md)
- [SE-0169 Improve Interaction Between private Declarations and Extensions](https://github.com/apple/swift-evolution/blob/master/proposals/0169-improve-interaction-between-private-declarations-and-extensions.md)
- [SE-0170 NSNumber bridging and Numeric types](https://github.com/apple/swift-evolution/blob/master/proposals/0170-nsnumber_bridge.md)
- [SE-0171 Reduce with inout](https://github.com/apple/swift-evolution/blob/master/proposals/0171-reduce-with-inout.md)
- [SE-0176 Enforce Exclusive Access to Memory](https://github.com/apple/swift-evolution/blob/master/proposals/0176-enforce-exclusive-access-to-memory.md)
- [SE-0179 Swift run Command](https://github.com/apple/swift-evolution/blob/master/proposals/0179-swift-run-command.md)

## New compatibility modes

With Swift 4, you may not need to modify your code to use the new version of the compiler. The compiler supports two language modes:

- **Swift 3.2**: In this mode, the compiler will accept the majority of sources that built with the Swift 3.x compilers. Updates to previously existing APIs (either those that are part of the standard library or APIs shipped by Apple) will not appear in this mode, in order to provide this level of source compatibility. Most new language features in Swift 4 are available in this language mode.

- **Swift 4.0**: This mode includes all Swift 4.0 language and API changes. Some source migration will be needed for many projects, although the number of source changes are quite modest compared to many previous major changes between Swift releases.

The language mode is specified to the compiler by the -swift-version flag, which is automatically handled by the Swift Package Manager and Xcode.

One advantage of these language modes is that you can start using the new Swift 4 compiler and migrate fully to Swift 4 at your own pace, taking advantage of new Swift 4 features, one module at a time.

For more information about Swift 4 migration and compatibility modes, see [Migrating to Swift 4](https://swift.org/migration-guide-swift4/)

## Package Manager Updates

Swift 4 introduces new workflow features and a more complete API for the Swift Package Manager:

- It’s now easier to develop multiple packages in tandem before tagging your first official release, or to work on a branch of multiple packages together.

- Package products have been formalized, making it possible to control what libraries a package publishes to clients.

- The new Package API allows packages to specify a number of new settings, giving package authors more control over how packages build or how sources are organized on disk. Overall, the API used to create a package is now cleaner and clearer, while retaining source-compatibility with older packages.

- On macOS, Swift package builds now occur in a sandbox which prevents network access and file system modification, to help mitigate the effect of maliciously crafted manifests.

Further, the Swift Package Manager builds on top of package manager tools versioning introduced in Swift 3.1 ([SE-0159](https://github.com/apple/swift-evolution/blob/master/proposals/0152-package-manager-tools-version.md)) which allows a package author to specify the version of Swift required for building a package — which now includes Swift 4.

For more information about enhancements to the Package Manager, see:

- [SE-0146 Package Manager Product Definitions](https://github.com/apple/swift-evolution/blob/master/proposals/0146-package-manager-product-definitions.md)
- [SE-0149 Package Manager Support for Top of Tree development](https://github.com/apple/swift-evolution/blob/master/proposals/0149-package-manager-top-of-tree.md)
- [SE-0150 Package Manager Support for branches](https://github.com/apple/swift-evolution/blob/master/proposals/0150-package-manager-branch-support.md)
- [SE-0158 Package Manager Manifest API Redesign](https://github.com/apple/swift-evolution/blob/master/proposals/0158-package-manager-manifest-api-redesign.md)
- [SE-0162 Package Manager Custom Target Layouts](https://github.com/apple/swift-evolution/blob/master/proposals/0162-package-manager-custom-target-layouts.md)
- [SE-0175 Package Manager Revised Dependency Resolution](https://github.com/apple/swift-evolution/blob/master/proposals/0175-package-manager-revised-dependency-resolution.md)
- [SE-0179 Swift run Command](https://github.com/apple/swift-evolution/blob/master/proposals/0179-swift-run-command.md)
- [SE-0181 Package Manager C/C++ Language Standard Support](https://github.com/apple/swift-evolution/blob/master/proposals/0181-package-manager-cpp-language-version.md)

## Documentation

An updated version of The Swift Programming Language for Swift 4.0 is now available on Swift.org. It is also available for free on Apple’s iBooks store.

## Platforms

## Linux

Official binaries for Ubuntu 16.10, Ubuntu 16.04 and Ubuntu 14.04 are available for download.

## Apple (Xcode)

For development on Apple’s platforms, Swift 4.0 ships as part of Xcode 9.

## Sources

Development on Swift 4.0 was tracked in the swift-4.0-branch on the following repositories on GitHub:

- [swift](https://github.com/apple/swift)
- [swift-llvm](https://github.com/apple/swift-llvm)
- [swift-clang](https://github.com/apple/swift-clang)
- [swift-lldb](https://github.com/apple/swift-lldb)
- [swift-cmark](https://github.com/apple/swift-cmark)
- [swift-corelibs-foundation](https://github.com/apple/swift-corelibs-foundation)
- [swift-corelibs-libdispatch](https://github.com/apple/swift-corelibs-libdispatch)
- [swift-corelibs-xctest](https://github.com/apple/swift-corelibs-xctest)
- [swift-llbuild](https://github.com/apple/swift-llbuild)
- [swift-package-manager](https://github.com/apple/swift-package-manager)
- [swift-xcode-playground-support](https://github.com/apple/swift-xcode-playground-support)
- [swift-compiler-rt](https://github.com/apple/swift-compiler-rt)
- [swift-integration-tests](https://github.com/apple/swift-integration-tests)

The tag `swift-4.0-RELEASE` designates the specific revisions in those repositories that make up the final version of Swift 4.0.

The `swift-4.0-branch` will remain open, but under the same release management process, to accumulate changes for a potential future bug-fix “dot” release.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
