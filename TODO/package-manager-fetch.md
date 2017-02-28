> * 原文地址：[Using 'swift package fetch' in an Xcode project](http://www.cocoawithlove.com/blog/package-manager-fetch.html)
* 原文作者：[Matt Gallagher](http://www.cocoawithlove.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Gocy](https://github.com/Gocy015/)
* 校对者：

# 在 Xcode 项目中使用 swift package fetch #

到目前为止，Cocoa with Love 的 git 仓库都使用“git subtrees”来管理相关依赖，所有的依赖都被拷贝并静态存放于依赖方目录下。我希望能找到一种更动态地依赖管理方式来代替现有的方案，同时依赖方式对库使用者的不可见性（或者翻译成“同时保持库对使用者的抽象性”？或者校者有更好的翻译吗）。（译者注：[Cocoa with Love](https://www.cocoawithlove.com/)）

我想要使用 Swift 包管理工具（Swift Package Manager）来解决这个问题，但我又不希望所有的仓库都必须依赖 Swift 包管理工具才能构建（build）。Swift 包管理工具所支持的构建范围相当有限，我可不愿意给我的库套上这些枷锁。

在本文中，我会讨论一种混合（hybrid）的方法，Swift 包管理工具将替代手工配置 Xcode 项目的方案，充当获取依赖的幕后工具，同时，保持对原有“subtree”形式运行的目标平台和构建结构的支持。

内容

- [依赖管理](#依赖管理)
- [展望未来](#展望未来)
- [Swift package fetch](#swift-package-fetch)
- [Some kind of automated script](#some-kind-of-automated-script)
- [Try it out](#try-it-out)
- [Conclusion](#conclusion)

## 依赖管理 ##

我去年发布的 CwlSignal 库的依赖关系非常的简单：

CwlCatchException ← CwlPreconditionTesting ← CwlUtils ← CwlSignal

### Git subtree ###

直到现在，我都一直在使用 [Git subtrees](https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt)。

在本例中，你不需要分别单独地下载每个依赖；如果你看看 [CwlSignal 仓库早些时候的结构](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47)，就会发现它包含了 [CwlUtils](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47/CwlUtils)，其中又包含了 [CwlPreconditionTesting](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47/CwlUtils/CwlPreconditionTesting)，其中又包含了 [CwlCatchException](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47/CwlUtils/CwlPreconditionTesting/CwlCatchException)。这和手动将每个文件拷贝到仓库中有相似之处，其唯一的小优势在于：如果依赖发生了改变，我只需简单地调用一个 subtree pull 就可以将更新同步到依赖方了。

这样的做法有着它的缺陷。在缺乏灵活性的树结构中，你必须沿着文件链，按顺序逐步拉取改动；你无法简单地用一个指令就更新所有的依赖。每个仓库都因为需要包含它的依赖而变得臃肿。而如果你无意间修改了依赖方的依赖树，那么在拉取依赖进行合并（merge）的时候也会遇到一些麻烦。

对于依赖关系简单又轻便的 CwlSignal 库而言，这些都不是什么大问题，但这些问题和困扰我还是得指出来。

### Git submodules ###

我也可以试试 [git submodule](https://git-scm.com/docs/git-submodule)。理论上说，它能更动态地解决 git subtrees 所解决的问题。我觉得 git submodules 应该是一个理想的选择，但实际操作起来发现，git modules 对你的仓库的改变是可见（not transparent）的，而 git 那寒酸地处理方式会把一切弄得晦涩难懂。

你有可能遇到 pull 和 push 指令顺序错乱而最终导致改动丢失的情况。改变依赖目标非常麻烦，而且通常需要你手动修改“.git”目录下的内容。Github 上面的“Download ZIP”功能变得毫无用处，因为 ZIP 文件就和其它大部分非 git 代码管理方式一样，会忽略对子模块的引用。

submodules 的每个用户都要熟悉 submodule 的结构，并且每次都要微调 git 指令以确保拉取更新仓库的正确性，相比之下，git subtrees 中通常不需要注意这个问题。

### 有保障的包管理工具 ###

我当然也可以用一些有保障的包管理工具，像是 [CocoaPods](https://cocoapods.org) 或是 [Carthage](https://github.com/carthage/carthage)。我确实应该进一步改进对这些工具的兼容性，以满足部分 **希望** 使用它们的用户，但我不希望强迫 **所有** 用户都使用它们。站在自己的角度出发，我更希望能自己独立掌控工作流，而不是依赖这些工具，让它们来控制工作区（workspace）或是构建配置（build settings）。

### Swift 包管理工具 ###

于是我选择了 [Swift 包管理工具](https://github.com/apple/swift-package-manager)；一个自带构建系统和依赖管理的综合方案。

和我前文提到的几个选项相比，Swift 包管理工具提供了新的特性吗？呃，它确实提供了一个全新的构建系统，但我的主要目标是依赖管理；我并没有想找一个构建系统。

使用 Swift 包管理工具不会出现像 git submodules 那样的诡异的问题，同时，它内嵌于 Swift 中，所以比起 CocoaPods 和 Carthage，它是个更自然的选择 - 尽管我还是不想让使用我的库的用户也必须使用 Swift 包管理工具。

有没有可能只使用 Swift 包管理工具的依赖管理功能，而不使用它的构建系统？

## 展望未来 ##

我刚说“我的主要目标是依赖管理；我并没有想找一个构建系统”的时候，其实我撒了小谎。我 **理应** 是由于它出色的依赖管理能力而青睐它的，但老实说，我也很想试试 Swift 包管理工具的构建系统。

就像 [Apache Maven](https://maven.apache.org) 和 [Rust Cargo](https://github.com/rust-lang/cargo)，Swift 包管理工具包含了一个具有约定准则的构建系统。尽管一些元数据是在顶层清单（top-level manifest）中声明的，构建过程本身则尽可能由目录下的文件组织结构决定。我可是这种构建系统的忠实粉丝；构建不应该需要大量的配置。如果我们的目录结构遵循了约定，系统应该能够推测出大部分 - 甚至全部 - 的构建参数，而不是让开发者每次都列举出方方面面的参数。

我期待着 Swift 包管理工具项目成为 Xcode 模板工程的一种。自动化保持文件在各自模块目录下的逻辑，而不是随意存储在文件系统中却又要持续进行维护。构建参数通过推测生成，而不是在长串的标签和检查器中设置。依赖关系像 Xcode 中的“Debug Memory Graph”一样可视化展示。

但很明显，Xcode 暂时还不支持 Swift 包管理工具（Swift 包管理工具支持 Xcode 但我对反向支持更感兴趣）。而且说实话，在 Swift 包管理工具支持构建应用，支持在 iOS 构建，支持在 watchOS 构建，支持在 tvOS 上构建，支持混语言模块构建，支持含有资源包的构建，并能够管理独立的测试依赖或跨模块内联之前，它甚至无法满足简单如 CwlSignal 库的所有需求。

（译者注：通过 Swift 包管理工具生成的项目，支持使用 `swift package generate-xcodeproj` 指令转化成普通的 Xcode 项目，但目前 Xcode 项目无法转化成 Swift 包管理工具格式的项目）

但我依然支持你把 Swift 包管理工具作为 **次要** 构建选择，并希望几年后，它能够成为我的 **主要** 选择。


## Swift package fetch ##

想使用 Swift 包管理工具的依赖管理功能，但不将其作为首要构建系统导致了一些问题。

总的来说我们要完成以下几件事：

1. 对 Swift 包管理工具进行支持（包括构建和依赖获取）。
2. 让 Xcode 工程依赖 Swift 包管理工具下载的文件。
3. 确保上述操作对用户的不可见性。

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

### 1. 对 Swift 包管理工具进行支持 ###

配置好 “Package.swift” 文件，向仓库中添加语义上的版本标签并确保依赖的正确拉取只是微不足道的工作。

真正的重点是下列任务（排列顺序无关）：

1. 将项目目录层级调整为遵循 Swift 包管理工具约定中规定的结构（本例中涉及所有项目）。
2. 将 Objective-C 和 Swift 混编的模块拆分为独立模块（本例中涉及除 CwlSignal 外所有项目）。
3. 确保在 `#if SWIFT_PACKAGE` 判断下，`import` 步骤 2 中所创建的新模块（本例中涉及除 CwlSignal 外所有项目）。
4. 将“.h”头文件拆分出来，这样我们就可以通过一个 Xcode 全局头文件或是 Swift-PM 中的模块头文件来一并引入它们（例中涉及除 CwlSignal 外所有项目）。
5. 确保将步骤 2 中所影响到的模块中的 `internal` 关键字改为 `public`，以确保它们能被正常访问（本例中涉及 CwlCatchException）。
6. 移除所有对 `DEBUG` 或其他非 Swift 包管理工具设置条件的依赖（本例中涉及 CwlDeferredWork 和 CwlUtils、CwlSignal 的测试文件）。
7. 对于具有双向依赖关系的 Objective-C 和 Swift 文件，将 Objective-C 中的依赖改为动态寻找以避免模块循环依赖（本例中涉及 CwlMachBadInstructionHandler）。
8. 移动 Info.plist 文件。这些文件是 Swift 包管理工具自动生成的，但它们必须被手动迁移到 Xcode 中 - Swift 包管理工具必须设置成忽略这些文件（本例中涉及所有项目）。

另外，学习了解 Swift 包管理工具的约定和工作模式，并让其引导构建的某些方面的过程也花了我们不少工夫。

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
