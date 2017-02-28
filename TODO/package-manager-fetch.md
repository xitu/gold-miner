> * 原文地址：[Using 'swift package fetch' in an Xcode project](http://www.cocoawithlove.com/blog/package-manager-fetch.html)
* 原文作者：[Matt Gallagher](http://www.cocoawithlove.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Gocy](https://github.com/Gocy015/)
* 校对者：

# Using 'swift package fetch' in an Xcode project #
# 在 Xcode 项目中使用 swift package fetch 

Up until now, the Cocoa with Love git repositories have included their dependencies as “git subtrees” where each dependency is copied and statically hosted within the depender. I want to replace this arrangement with a more dynamic dependency management while remaining totally transparent to users of the library.

I’d like to use the Swift Package Manager for the task but it’s complicated by the fact that I don’t want the Swift Package Manager to be a required way to build any of these repositories. The Swift Package Manager has a very narrow range of build capabilities and I don’t want my libraries to be subject to these limitations.

In this article, I’ll look at a hybrid approach where the Swift Package Manager is used as a behind-the-scenes tool to fetch dependencies for an otherwise manually configured Xcode project that continues to support the same target platforms and build structures from the previous “subtree” arrangement.

到目前为止，Cocoa with Love 的 git 仓库都使用“git subtrees”来管理相关依赖，所有的依赖都被拷贝并静态存放于依赖方目录下。我希望能找到一种更动态地依赖管理方式来代替现有的方案，同时依赖方式对库使用者的不可见性（或者翻译成“同时保持库对使用者的抽象性”？或者校者有更好的翻译吗）。（译者注：[Cocoa with Love](https://www.cocoawithlove.com/)）

我想要使用 Swift 包管理工具（Swift Package Manager）来解决这个问题，但我又不希望所有的仓库都必须依赖 Swift 包管理工具才能构建（build）。Swift 包管理工具所支持的构建范围相当有限，我可不愿意给我的库套上这些枷锁。

在本文中，我会讨论一种混合（hybrid）的方法，Swift 包管理工具将替代手工配置 Xcode 项目的方案，充当获取依赖的幕后工具，同时，保持对原有“subtree”形式运行的目标平台和构建结构的支持。

Contents

- [Managing dependencies](#managing-dependencies)
- [Hoping for the future](#hoping-for-the-future)
- [Swift package fetch](#swift-package-fetch)
- [Some kind of automated script](#some-kind-of-automated-script)
- [Try it out](#try-it-out)
- [Conclusion](#conclusion)

目录

- [依赖管理](#managing-dependencies)
- [Hoping for the future](#hoping-for-the-future)
- [Swift package fetch](#swift-package-fetch)
- [Some kind of automated script](#some-kind-of-automated-script)
- [Try it out](#try-it-out)
- [Conclusion](#conclusion)

## Managing dependencies ##

The dependency graph for the CwlSignal library that I released last year is pretty simple:

CwlCatchException ← CwlPreconditionTesting ← CwlUtils ← CwlSignal

<span id="managing-dependencies">## 依赖管理</span>


### Git subtree ###

Until now, I’ve been using [Git subtrees](https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt).

In this arrangement, you don’t need to separately download any dependencies; if you browse [the previous structure of the CwlSignal repository](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47), you’ll notice that it contains [CwlUtils](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47/CwlUtils), which contains [CwlPreconditionTesting](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47/CwlUtils/CwlPreconditionTesting), which contains [CwlCatchException](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47/CwlUtils/CwlPreconditionTesting/CwlCatchException). This is not totally different to manually copying the files into each repository but with the minor advantage that if a dependency changes, I can easily pull changes into the depender with a simple subtree pull.

This arrangement has its problems. Subtrees scale poorly since changes need to be manually pulled into each subsequent link in the chain; you can’t easily update all dependencies with a single command. Each repository is bloated by needing to contain its dependencies. It also creates merge problems if you accidentally modify a dependency’s subtree in the depender then try to pull the dependency.

None of these are major problems for a small, simple dependency graph like CwlSignal but they’ve always been concerns that I’ve wanted to address.

### Git submodules ###

I could use [git submodule](https://git-scm.com/docs/git-submodule). In theory, it’s just a more dynamic approach for the problem that git subtrees solve. I feel as though git submodules should be ideal choice but in practice, git modules are not a transparent change to your git repository and their poor handling by git makes them confusing and frustrating for users.

It is possible to pull and push repositories in the wrong order and end up overwriting your changes. Switching from one dependency to another is complicated and often involves manually editing the contents of the “.git” directory. The “Download ZIP” functionality on Github becomes completely useless as the ZIP file omits the submodule references as do most other non-git means of managing your code.

In comparison to git subtrees which usually go unnoticed, submodules suffer from the fact that every user needs to be aware of the submodule arrangement and needs to run slightly different git commands just to fetch and update the repository correctly.

### Established package managers ###

I could move to an established package manager like [CocoaPods](https://cocoapods.org) or [Carthage](https://github.com/carthage/carthage). While I should probably do more to improve compatibility with these systems for users who *want* to use them, I’d rather not force *everyone* to use them. For my own purposes, I’d rather avoid the loss of control over the workspace or build settings imposed by the use of these systems so I’d rather keep a workflow that can be used independent of these systems.

### Swift Package Manager ###

Which brings me to the [Swift Package Manager](https://github.com/apple/swift-package-manager); a combined build-system and dependency manager.

Does the Swift Package Manager offer anything new compared to the previous options I’ve mentioned? Well, it offers a new build system but my primary motivation here is dependency management; I wasn’t looking for a build system.

Using the Swift Package Manager isn’t going to have the weird effects on the repository that git submodules have. It is also bundled with Swift, so it’s a lower friction option than CocoaPods or Carthage – although I still don’t want to force users of my library to use the Swift Package Manager.

Is it possible to use the Swift Package Manager as a dependency resolver without using it as a build system?

## Hoping for the future ##

When I said “my primary motivation here is dependency management; I wasn’t looking for a build system”, I wasn’t being totally honest. I *should* be primarily motivated by dependency management but truthfully, I’d also like to play around with the Swift Package Manager build system.

Like [Apache Maven](https://maven.apache.org) or [Rust Cargo](https://github.com/rust-lang/cargo), the Swift Package Manager includes a convention-based build system. While some metadata is declared in a top-level manifest, the build is, as much as possible, determined by the organization of files in the repository. I’m a big fan of this type of build system; a build shouldn’t require substantial configuring. Assuming folder structure conventions are followed, it should be possible to infer most – even all – parameters for a build, rather than forcing the programmer to manually enumerate all aspects, every time.

I would like to see Swift Package Manager projects become a project type in Xcode. Automatically keeping files sensibly in module folders rather than arbitrarily distributed around the filesystem and needing constant sheparding. Build settings inferred rather than configured through a vast array of tabs and inspectors. Dependencies viewable like the Xcode “Debug Memory Graph” display.

Obviously, though, Xcode doesn’t support the Swift Package Manager, yet (Swift Package Manager supports Xcode but it’s the other direction that’s more interesting to me). And, bluntly, until the Swift Package Manager can build apps, build for iOS, build for watchOS, build for tvOS, build mixed language modules, build bundles with resources, manage separate dependencies for tests or inline across modules, it won’t satisfy all the requirements of even a relatively simple library like CwlSignal.

But I’d still like to support the Swift Package Manager as a *secondary* build option in the hope that it in a couple years it will be possible to make it the *primary* option.

## Swift package fetch ##

Wanting to use the Swift Package Manager for dependency management but not as the primary build system creates some problems.

Summarizing what need to be done:

1. Support the Swift Package Manager (for both building and fetching dependencies)
2. Make Xcode projects refer to the files downloaded by Swift Package Manager.
3. Make everything transparent to the user.

### 1. Support the Swift Package Manager ###

Setting up the “Package.swift” file, adding semantic version tags to repositories and making sure that dependencies are fetched is trivial.

The signficant work was actually across the following tasks (in no particular order):

1. Reorganize my folders to follow the convention-based structure expected by the Swift Package Manager (all projects).
2. Separate my mixed Objective-C/Swift modules into separate modules (all projects except CwlSignal).
3. Under a `#if SWIFT_PACKAGE` guard, be certain to `import` the new modules created by the separation in step 2 (all projects except CwlSignal).
4. Separate my “.h” files so that they can be included from a project-wide umbrella header as in Xcode or from a module header as in Swift-PM (all projects except CwlSignal).
5. Ensure that symbols affected by step 2 that were previously `internal` were `public` so they remained accessible (CwlCatchException).
6. Remove any reliance on `DEBUG` or other conditions not set by the Swift Package Manager (CwlDeferredWork and tests in CwlUtils and CwlSignal).
7. In Objective-C files that needed to both reference and be referenced by Swift, changed the references from Objective-C to Swift to dynamic lookups to avoid circular module dependencies (CwlMachBadInstructionHandler).
8. Move Info.plist files around. These are generated automatically by the Swift-PM but must manually exist for Xcode – Swift-PM must be set to ignore them all (all projects).

There was also a non-zero amount of effort involved in accepting how the conventions of the Swift Package Manager work and letting it guide some aspects of the build.

### 2. Make Xcode projects refer to the files downloaded by Swift Package Manager ###

In Swift 3.0, dependencies are placed in “./Packages/ModuleName-X.Y.Z” where X.Y.Z is the semantic version tag of checkout. Obviously, this will change if you ever change the version depended upon.

Swift 3.1 and later place dependencies in “./.build/checkout/ModuleName-XXXXXXXX” where XXXXXXXX is a hash derived from the repository URL. The hash is not guaranteed to be stable and as far as I can tell, the path format is undocumented and subject to change.

Clearly, we can’t point Xcode directly at either of these since they’re subject to change. We need to create symlinks from a stable location to these subject-to-change locations. This means that we need a simple way to determine the current locations.

The closest we get to a documented solution for handling these paths is the output to the following command:

```
swift package show-dependencies --format json

```

The output from this command offers a JSON structure that includes the module names and the checkout paths. While there’s no guarantee that this structure will remain stable in the future, it is *currently* stable across 3.0 and 3.1 so it’s better than simply enumerating directories.

We need to create symlinks from a stable location to the locations detailed in this JSON file.

I chose to use the location “./.build/cwl_symlinks/ModuleName” to store a symlink to the actual location used by either Swift 3.0 or Swift 3.1 package managers. This creates the minor risk of collision in the scenario where two dependencies have the same module name but different origin or version but outside of that possibility it should offer a stable location that my Xcode projects can use to find these dependencies. When I change the version of a library that I depend upon or the hash changes (because I’m switching between local and remote versions of a repository for testing) or something else that affects the path, all we’ll need to do is update the symlink.

Getting Xcode to keep a path through the symlink rather than immediately resolve the symlink is a little tricky. While using Swift 3.1, I actually created a duplicate of each “./.build/checkout/ModuleName-XXXXXXXX” folder at the “./.build/cwl_symlinks/ModuleName” location, added all the files to Xcode before deleting the duplicate and creating a symlink at “./.build/cwl_symlinks/ModuleName” pointing to “./.build/checkout/ModuleName-XXXXXXXX”.

### 3. Making everything transparent to the user ###

We now have two non-transparent steps that we need to eliminate:

1. Run `swift package fetch` to get the dependencies.
2. Create symlinks in a stable location for all dynamically fetched dependencies.

For this, we’ll need some kind of automated script.

## Some kind of automated script ##

We need a “Run script” build phase at the top of any Xcode target with external dependencies.

When you add a “Run script” build phase to Xcode, it defaults to “/bin/sh”. I got about 5 lines into that before remembering that I’m terrible at bash so I change the “Shell” value for the build phase to “/usr/bin/xcrun –sdk macosx swift” (since I need to ensure the macOS SDK is used, even when building targets for iOS or other platforms) and set the script to the following code. Some of the parsing and configuring is a little dense but you should be able to read the comments to get a general feel for what’s happening.

```
import Foundation

/// Launch a process and run to completion, returning the standard out on success.
func launch(_ command: String, _ args: [String], directory: String? = nil) -> String? {
   let proc = Process()
   proc.launchPath = command
   proc.arguments = args
   _ = directory.map { proc.currentDirectoryPath = $0 }
   let pipe = Pipe()
   proc.standardOutput = pipe
   proc.launch()
   let result = String(data: pipe.fileHandleForReading.readDataToEndOfFile(),
      encoding: .utf8)!
   proc.waitUntilExit()
   return proc.terminationStatus != 0 ? nil : result
}

let srcRoot = ProcessInfo.processInfo.environment["SRCROOT"]!

// STEP 1: use `swift package fetch` to get all dependencies
print(launch("/usr/bin/swift", ["package", "fetch"], directory: srcRoot)!)

// Create a symlink only if it is not already present and pointing to the destination
let symlinksPath = "\(srcRoot)/.build/cwl_symlinks"
func createSymlink(srcRoot: String, name: String, destination: String) throws {
   let location = "\(symlinksPath)/\(name)"
   let link = "../../\(destination)"
   if (try? FileManager.default.destinationOfSymbolicLink(atPath: location)) != link {
      _ = try? FileManager.default.removeItem(atPath: location)
      try FileManager.default.createSymbolicLink(atPath: location, withDestinationPath:
         link)
      print("Created symbolic link: \(location) -> \(link)")
   }
}

// Recursively parse the dependency graph JSON, creating symlinks in our own location
func createSymlinks(srcRoot: String, description: Dictionary<String, Any>, topLevelPath:
   String) throws {
   guard let dependencies = description["dependencies"] as? [Dictionary<String, Any>]
      else { return }
   for dependency in dependencies {
      let path = dependency["path"] as! String
      let relativePath = path.substring(from: path.range(of: topLevelPath)!.upperBound)
      let name = dependency["name"] as! String
      try createSymlink(srcRoot: srcRoot, name: name, destination: relativePath)
      try createSymlinks(srcRoot: srcRoot, description: dependency, topLevelPath:
         topLevelPath)
   }
}

// STEP 2: create symlinks from our stable locations to the fetched locations
let descriptionString = launch("/usr/bin/swift", ["package", "show-dependencies",
   "--format", "json"], directory: srcRoot)!
let descriptionData = descriptionString.data(using: .utf8)!
let description = try JSONSerialization.jsonObject(with: descriptionData, options: [])
   as! Dictionary<String, Any>
let topLevelPath = (description["path"] as! String) + "/"
do {
   try FileManager.default.createDirectory(atPath: symlinksPath,
      withIntermediateDirectories: true, attributes: nil)
   try createSymlinks(srcRoot: srcRoot, description: description, topLevelPath:
      topLevelPath)
   print("Complete.")
} catch {
   print(error)
}
```

Compiling and running this code takes about a second but it would still be better to avoid that overhead after the first run. You can add `$(SRCROOT)/Package.swift` to the “Input Files” list for the Run Script and add one of `$(SRCROOT)/.build/cwl_symlinks/ModuleName` (where “ModuleName” is a modules fetched by the task) for each dependency fetched by the Swift Package Manager. This will prevent Xcode re-running unless the “Package.swift” file changes or the module symlink is deleted, eliminating that additional second of overhead.

> **Irony note:** To avoid the static inclusion of dependencies, I’ve statically included this file in each repository.

## Try it out ##

You can inspect or download the [CwlCatchException](https://github.com/mattgallagher/CwlCatchException), [CwlPreconditionTesting](https://github.com/mattgallagher/CwlPreconditionTesting), [CwlUtils](https://github.com/mattgallagher/CwlUtils) and [CwlSignal](https://github.com/mattgallagher/CwlSignal) projects from github. They now all support the Swift Package Manager for building on macOS. Theoretically, the Swift Package Manager opens up the possibility of some of these on Linux but that’ll be an exercise for another day.

This is an experimental change to these repositories. There’s every likelihood that I’ve broken something or ignored a better option, somehow. Create an issue on github if you encounter any problems or have a suggestion for a better approach.

## Conclusion ##

I’m glad to remove the git subtree inclusion of dependencies and replace it with something more dynamic.

I’m also happy to have Swift Package Manager support. It’s not Linux support yet (give me time) but it works really smoothly and – other than needing to change a lot of paths – wasn’t particularly difficult.

If it was possible to completely switch to the Swift Package Manager for all use cases, then that would be the end of the story and everything would be a lot cleaner. Unfortunately, current versions of the Swift Package Manager can’t handle a large number of build scenarios (including apps and iOS/watchOS/tvOS platforms) so it’s necessary to keep Xcode as the primary build environment and that means integrating the two.

The “Run Script” build phase works pretty well to hide fetch machinery. Things are going to fail if you don’t have a internet connection when trying to build for the first time, but otherwise it should be transparent and effortless. By setting the “Input Files and “Output Files” for the “Run Script” build step, the minor overhead of compiling and running this step is eliminated in almost all cases so it’s very low interference.

I do have concerns that this build script is liable to break while the Swift Package Manager remains under a high rate of change. I’m sure I’ll need to keep an eye on future Swift Package Manager updates – particularly any that might affect the `swift package show-dependencies --format json` output.

Previous article:
[Compiling a Mac OS 8 application on macOS Sierra](/blog/porting-from-macos8-to-sierra.html)
