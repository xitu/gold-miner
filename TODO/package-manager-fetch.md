> * 原文地址：[Using 'swift package fetch' in an Xcode project](http://www.cocoawithlove.com/blog/package-manager-fetch.html)
* 原文作者：[Matt Gallagher](http://www.cocoawithlove.com/about/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Gocy](https://github.com/Gocy015/)
* 校对者：[atuooo](https://github.com/atuooo), [lovelyCiTY](https://github.com/lovelyCiTY)

# 在 Xcode 项目中使用 swift package fetch #

到目前为止，Cocoa with Love 的 git 仓库都使用“git subtrees”来管理相关依赖，所有的依赖都被拷贝并静态存放于依赖方目录下。我希望能找到一种更动态地依赖管理方式来代替现有的方案，同时保持对库使用者的不可见性。（译者注：[Cocoa with Love](https://www.cocoawithlove.com/)）

我想要使用 Swift 包管理工具（Swift Package Manager）来解决这个问题，但我又不希望所有的仓库都必须依赖 Swift 包管理工具才能构建（build）。Swift 包管理工具所支持的构建范围相当有限，我可不愿意给我的库套上这些枷锁。

在本文中，我会讨论一种混合（hybrid）的方法，Swift 包管理工具将替代手工配置 Xcode 项目的方案，充当获取依赖的幕后工具，同时，保持对原有“subtree”形式运行的目标平台和构建结构的支持。

内容

- [依赖管理](#依赖管理)
- [展望未来](#展望未来)
- [Swift package fetch](#swift-package-fetch)
- [自动化脚本](#自动化脚本)
- [来试试看吧](#来试试看吧)
- [总结](#总结)

## 依赖管理 ##

我去年发布的 CwlSignal 库的依赖关系非常的简单：

CwlCatchException ← CwlPreconditionTesting ← CwlUtils ← CwlSignal

### Git subtree ###

直到现在，我都一直在使用 [Git subtrees](https://github.com/git/git/blob/master/contrib/subtree/git-subtree.txt)。

在本例中，你不需要分别单独地下载每个依赖；如果你看看 [CwlSignal 仓库早些时候的结构](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47)，就会发现它包含了 [CwlUtils](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47/CwlUtils)，其中又包含了 [CwlPreconditionTesting](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47/CwlUtils/CwlPreconditionTesting)，其中又包含了 [CwlCatchException](https://github.com/mattgallagher/CwlSignal/tree/72d4a10656ff4c8de8083e88f8651c5f7d0b8e47/CwlUtils/CwlPreconditionTesting/CwlCatchException)。这和手动将每个文件拷贝到仓库中有相似之处，但它的小优势在于：如果依赖发生了改变，我只需简单地调用一个 subtree pull 就可以将更新同步到依赖方了。

这样的做法有着它的缺陷。在缺乏灵活性的树结构中，你必须沿着文件链，按顺序逐步拉取改动；你无法简单地用一个指令就更新所有的依赖。每个仓库都因为需要包含它的依赖而变得臃肿。而如果你无意间修改了依赖方的依赖树，那么在拉取依赖进行合并（merge）的时候也会遇到一些麻烦。

对于依赖关系简单又轻便的 CwlSignal 库而言，这些都不是什么大问题，但这些问题和困扰我还是得指出来。

### Git submodules ###

我也可以试试 [git submodule](https://git-scm.com/docs/git-submodule)。理论上说，它能更动态地解决 git subtrees 所解决的问题。我觉得 git submodules 应该是一个理想的选择，但实际操作起来发现，git modules 对你的仓库的改变是可见（not transparent）的，而 git 那寒酸地处理方式会把一切弄得晦涩难懂。

你有可能遇到 pull 和 push 指令顺序错乱而最终导致改动丢失的情况。改变依赖目标非常麻烦，而且通常需要你手动修改 “.git” 目录下的内容。GitHub 上面的“Download ZIP”功能变得毫无用处，因为 ZIP 文件就和其它大部分非 git 代码管理方式一样，会忽略对子模块的引用。

submodules 的每个用户都要熟悉 submodule 的结构，并且每次都要微调 git 指令以确保拉取更新仓库的正确性，相比之下，git subtrees 中通常不需要注意这个问题。

### 成熟的包管理工具 ###

我当然也可以用一些成熟的包管理工具，像是 [CocoaPods](https://cocoapods.org) 或是 [Carthage](https://github.com/carthage/carthage)。我确实应该进一步改进对这些工具的兼容性，以满足部分 **希望** 使用它们的用户，但我不希望强迫 **所有** 用户都使用它们。站在自己的角度出发，我更希望能自己独立掌控工作流，而不是依赖这些工具，让它们来控制工作区（workspace）或是构建配置（build settings）。

### Swift 包管理工具 ###

于是我选择了 [Swift 包管理工具](https://github.com/apple/swift-package-manager)；一个自带构建系统和依赖管理的综合方案。

和我前文提到的几个选项相比，Swift 包管理工具提供了新的特性吗？呃，它确实提供了一个全新的构建系统，但我的主要目标是依赖管理；我并没有想找一个构建系统。

使用 Swift 包管理工具不会出现像 git submodules 那样的诡异的问题，同时，它内嵌于 Swift 中，所以比起 CocoaPods 和 Carthage，它是个更自然的选择 - 尽管我还是不想让使用我的库的用户也必须使用 Swift 包管理工具。

有没有可能只使用 Swift 包管理工具的依赖管理功能，而不使用它的构建系统？

## 展望未来 ##

我刚说“我的主要目标是依赖管理；我并没有想找一个构建系统”的时候，其实我撒了小谎。我 **理应** 是由于它出色的依赖管理能力而青睐它的，但老实说，我也很想试试 Swift 包管理工具的构建系统。

就像 [Apache Maven](https://maven.apache.org) 和 [Rust Cargo](https://github.com/rust-lang/cargo)，Swift 包管理工具包含了一个具有约定准则的构建系统。尽管一些元数据是在顶层清单（top-level manifest）中声明的，构建过程本身则尽可能由目录下的文件组织结构决定。我可是这种构建系统的忠实粉丝；构建不应该需要大量的配置。如果我们的目录结构遵循了约定，系统应该能够推测出大部分（甚至全部）的构建参数，而不是让开发者每次都列举出方方面面的参数。

我期待着 Swift 包管理工具项目成为 Xcode 模板工程的一种。自动化保持文件在各自模块目录下的逻辑，而不是随意存储在文件系统中却又要持续进行维护。构建参数通过推测生成，而不是在长串的标签和检查器中设置。依赖关系像 Xcode 中的“Debug Memory Graph”一样可视化展示。

但很明显，Xcode 暂时还不支持 Swift 包管理工具（Swift 包管理工具支持 Xcode 但我对反向支持更感兴趣）。而且说实话，在 Swift 包管理工具支持构建应用，支持在 iOS 构建，支持在 watchOS 构建，支持在 tvOS 上构建，支持混语言模块构建，支持含有资源包的构建，并能够管理独立的测试依赖或跨模块内联之前，它甚至无法满足简单如 CwlSignal 库的所有需求。

（译者注：通过 Swift 包管理工具生成的项目，支持使用 `swift package generate-xcodeproj` 指令转化成普通的 Xcode 项目，但目前 Xcode 项目无法转化成 Swift 包管理工具格式的项目）

但我依然支持你把 Swift 包管理工具作为 **次要** 构建选择，并希望几年后，它能够成为我的 **主要** 选择。


## Swift package fetch ##

想使用 Swift 包管理工具的依赖管理功能，但不将其作为首要构建系统会导致一些问题。

总的来说我们要完成以下几件事：

1. 对 Swift 包管理工具进行支持（包括构建和依赖获取）。
2. 让 Xcode 工程依赖 Swift 包管理工具下载的文件。
3. 确保上述操作对用户的不可见性。

### 1. 对 Swift 包管理工具进行支持 ###

配置好 “Package.swift” 文件，向仓库中添加语义上的版本标签并确保依赖的正确拉取只是微不足道的工作。

真正的重点是下列任务（排列顺序无关）：

1. 将项目目录层级调整为遵循 Swift 包管理工具约定中规定的结构（本例中涉及所有项目）。
2. 将 Objective-C 和 Swift 混编的模块拆分为独立模块（本例中涉及除 CwlSignal 外所有项目）。
3. 确保在 `#if SWIFT_PACKAGE` 判断下，`import` 步骤 2 中所创建的新模块（本例中涉及除 CwlSignal 外所有项目）。
4. 将 “.h” 头文件拆分出来，这样我们就可以通过一个 Xcode 全局头文件或是 Swift-PM 中的模块头文件来一并引入它们（本例中涉及除 CwlSignal 外所有项目）。
5. 确保将步骤 2 中所影响到的模块中的 `internal` 关键字改为 `public`，以确保它们能被正常访问（本例中涉及 CwlCatchException）。
6. 移除所有对 `DEBUG` 或其他非 Swift 包管理工具设置条件的依赖（本例中涉及 CwlDeferredWork 和 CwlUtils、CwlSignal 的测试文件）。
7. 对于具有双向依赖关系的 Objective-C 和 Swift 文件，将 Objective-C 中的依赖改为动态寻找以避免模块循环依赖（本例中涉及 CwlMachBadInstructionHandler）。
8. 移动 Info.plist 文件。这些文件是 Swift 包管理工具自动生成的，但它们必须被手动迁移到 Xcode 中 - Swift 包管理工具必须设置成忽略这些文件（本例中涉及所有项目）。

另外，学习了解 Swift 包管理工具的约定和工作模式，并让其引导构建的某些方面的过程也花了我们不少工夫。

### 2. 让 Xcode 工程依赖 Swift 包管理工具下载的文件

在 Swift 3.0 版本中，依赖都被放置在 “./Packages/ModuleName-X.Y.Z” 目录下，X、Y、Z 是相应的语义版本号。显然，这个路径会随着依赖版本的改变而改变。

在 Swift 3.1 以及更新的版本中，依赖被放置在 “./.build/checkout/ModuleName-XXXXXXXX” 目录下，其中 XXXXXXXX 是仓库 URL 的 hash 值。这个 hash 值是可能会变化的，并且据我所知，该路径的格式未在文档中提及而且随时可能改变。

因此，我们不能直接将 Xcode 项目中的路径直接指向上述的目录。我们需要创建一个稳定的符号链接（symlink）而不是依赖可能变化的实际路径。这意味着我们需要想一个简单的办法来确定当下的路径。

我们能在文档定义范围内找到的最靠谱的解决路径问题的方案，源于以下这条指令：

```
swift package show-dependencies --format json

```

这条指令会输出一条 JSON 结构的信息，其中包含了模块名和 checkout 的路径。尽管我们没法保证该结构能保持可靠，但 **就目前来说** 它在 3.0 到 3.1 版本中都表现良好，这可比遍历整个目录结构好多了。

我们需要将符号链接从一个稳定路径细化为 JSON 文件中所描述的具体路径。

我选择用 “./.build/cwl_symlinks/ModuleName” 路径来存储包含 Swift 3.0 以及 3.1 版本的包管理工具所使用的具体路径的符号链接。尽管这样可能出现依赖模块同名但不同源、不同版本的冲突风险，但若不考虑这细微的可能，该路径应该能稳定地指引 Xcode 找到其依赖项。如果我更新了依赖库的版本或是 hash 值改变了（我常出于测试目的，在本地分支和远端分支间切换）或是其它因素导致路径变化了，我们只需要更新符号链接就可以了。

想让 Xcode 引用符号链接来间接获取路径，而不是立刻解析符号链接还有些棘手。在使用 Swift 3.1 版本的时候，我实际上还在 “./.build/cwl_symlinks/ModuleName” 目录下拷贝了一分 “./.build/checkout/ModuleName-XXXXXXXX” 目录，并将所有文件拖入 Xcode 中，然后再删除该份拷贝，并在 “./.build/cwl_symlinks/ModuleName” 目录下创建指向 “./.build/checkout/ModuleName-XXXXXXXX” 的符号链接。

### 3. 确保操作对用户的不可见性 ###

现在，我们有以下两个对用户可见的操作需要消除：

1. 获取依赖时执行的 `swift package fetch` 指令。
2. 在稳定的目录下，为所有动态获取的依赖创建符号链接文件。

要达到目标，我们需要写一个自动化脚本。

## 自动化脚本 ##

我们需要为所有有外部依赖的 Xcode 项目添加一个用来“运行脚本”的构建阶段（“Run Script” build phase）。

当你为 Xcode 添加“运行脚本”的构建阶段时，它默认指向 “/bin/sh”。由于我对 bash 相关指令不熟，所以我把构建阶段的 “Shell” 值改为 “/usr/bin/xcrun –sdk macosx swift”（这么做是因为即便构建目标是 iOS 或其它平台，我仍然需要保证使用了 macOS SDK）并将下列代码添加到脚本中。其中的一些解析和配置逻辑或许有些复杂，但配合注释你应该可以理解大致的思路。

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

编译运行这段代码大概会花掉一秒钟时间，时间不长，但如果能在首次运行后就省去这段时间就更好了。你可以向运行脚本的 “Input Files” 列表中添加 `$(SRCROOT)/Package.swift` 并为每个 Swift 包管理工具所获取到的依赖添加一个 `$(SRCROOT)/.build/cwl_symlinks/ModuleName` （ModuleName 是获取到的模块名）。这就能避免 Xcode 在 “Package.swift” 没有改变或模块符号链接未被删除时反复运行脚本，如此便可以节省一秒的编译时间。

> **说着有点讽刺：** 为了避免静态包含依赖项，我转而在每个仓库中静态包含了这个文件。

## 来试试看吧 ##

你可以查看或下载 GitHub 上的 [CwlCatchException](https://github.com/mattgallagher/CwlCatchException)、[CwlPreconditionTesting](https://github.com/mattgallagher/CwlPreconditionTesting)、[CwlUtils](https://github.com/mattgallagher/CwlUtils) 以及 [CwlSignal](https://github.com/mattgallagher/CwlSignal) 工程。这些工程现在支持在 macOS 上用 Swift 包管理工具进行构建。理论上说，Swift 包管理工具为这其中某些库在 Linux 上运行提供了可能，但这部分内容我们留到下次探索。

这是一次对这些仓库的实验性变更。出于某些原因，我可能犯下了一些错误或是忽略了更好地选择。如果你遇到任何问题或是有任何更好的建议，欢迎在 GitHub 上提交 issue。

## 总结 ##

能把 git subtree 的依赖包含方案替换成一个更动态的方案，我十分开心。

我还十分庆幸有 Swift 包管理工具的支持。它暂时还不支持 Linux（别急嘛）但它的工作流程确实流畅（虽然要修改一大堆路径配置）而且不会特别难用。

如果能够将所有用例都完全转为依赖 Swift 包管理工具，那么事情就变简单了、结构也就更清晰了。但可惜，现版本的 Swift 包管理工具还无法处理大量不同的构建场景（包含其它应用以及在 iOS/watchOS/tvOS 平台构建），所以将 Xcode 当作首选构建环境还是相当必要的，但这意味着你需要集成两者。

“运行脚本”的构建阶段很好的隐藏了拉取依赖的过程。尽管没有网络连接时，首次构建会失败，但正常情况下它应该是不可见的，不需要特殊处理。为“运行脚本”的构建阶段设置好 “Input Files” 和 “Output Files”，能够消除绝大部分场景下构建和运行阶段所产生的额外消耗，因此其不会产生太多影响。

但我确实担心，在 Swift 包管理工具如此频繁的更新率下，这个构建脚本会很容易失效。我知道今后我要时刻关注 Swift 包管理工具的更新 - 尤其是任何可能影响到 `swift package show-dependencies --format json` 输出结果的。