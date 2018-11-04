> * 原文地址：[Creating Swift Package Manager tools from your existing codebase](https://paul-samuels.com/blog/2018/09/01/creating-spm-tools-from-your-existing-codebase/?utm_campaign=Swift%20Weekly&utm_medium=Swift%20Weekly%20Newsletter%20Issue%20129&utm_source=Swift%20Weekly)
> * 原文作者：[Paul Samuels](https://paul-samuels.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-spm-tools-from-your-existing-codebase.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-spm-tools-from-your-existing-codebase.md)
> * 译者：[iWeslie](https://github.com/iWeslie)
> * 校对者：

# 从现有的代码库创建 Swift 包管理器

Swift 包管理器（SPM）非常适合编写快速工具，你甚至可以从应用程序中提取现有代码。诀窍是意识到你可以将文件夹符号链接到 SPM 项目中，这意味着通过一些工作你可以创建一个包装生产代码部分的命令行工具。

### 你为什么要这么做？

虽然它很依赖于项目，但是常见的用例是创建支持、调试和持续集成（CI）验证工具。例如，许多应用程序为了实现功能而使用远端的数据，应用程序需要将远程数据转换为自定义的类型，并且使用业务规则对此数据执行有用的操作。在此流程中会有多个故障点显示出应用程序的崩溃或不正确的行为，因此解决的方法是在有附加调试器的情况下启动并进行调试，Swift 包管理器将是一个帮助发现问题并潜在地阻止问题的好工具。

### 注意事项

你不能使用导入 `UIKit` 的代码，因为这项技术仅适用于基于 `Foundation` 库的代码。虽然这听起来有限制，但是在理想情况下，业务逻辑和数据操作的代码都不应该接触有关 `UIKit` 的东西。

具有依赖性导致了该技术更加难，不过你仍然可以使用它，但是需要在 `Package.swift` 中进行更多的配置。

### 你要怎么做呢？

这取决于你的项目结构，我这里有一个[示例项目](https://github.com/paulsamuels/SymlinkedSPMExample)。这是一个小型的iOS项目，它显示了一个博客的帖子列表（你并不需要看项目本身，项目本身并不重要）。项目中博客的帖子来自于假的 JSON 数据，它没有特别好的结构，因此应用程序需要进行自定义解码。为了保持它的轻量级，我将以下面的方式构建最简单的包装器：

*   从标准输入中读取	
*   使用生产解析代码
*   打印解码结果或错误

你可以疯狂地给它添加更多的更能，但是这个简单的工具将会让我们在不启动模拟器的情况下，快速反馈给我们生产代码是否接受某些 JSON 数据或者显示任何可能发生的错误。

这个示例项目的基础结构如下：

```bash
.
└── SymlinkedSPMExample
    ├── AppDelegate.swift
    ├── Base.lproj
    │   └── LaunchScreen.storyboard
    ├── Info.plist
    ├── ViewController.swift
    └── WebService
        ├── Server.swift
        └── Types
            ├── BlogPost.swift
            └── BlogPostsRequest.swift
```

我特意创建了一个仅包含我想重用的代码的 `Types` 目录。想要创建利用次生产代码的命令行工具，我们可以执行以下操作：

```bash
mkdir -p tools/web-api
cd tools/web-api
swift package init --type executable
```

现在我们已经搭建了一个可以操作的项目。首先让我们把生产代码进行链接：

```bash
cd Sources
ln -s ../../../SymlinkedSPMExample/WebService/Types WebService
cd ..
```

**你要给这个链接使用相对路径，否则在迁移到别的电脑上时会奔溃**

现在项目的结构现在看起来像这样：

```bash
.
├── SymlinkedSPMExample
│   ├── AppDelegate.swift
│   ├── Base.lproj
│   │   └── LaunchScreen.storyboard
│   ├── Info.plist
│   ├── ViewController.swift
│   └── WebService
│       ├── Server.swift
│       └── Types
│           ├── BlogPost.swift
│           └── BlogPostsRequest.swift
└── tools
    └── web-api
        ├── Package.swift
        ├── README.md
        ├── Sources
        │   ├── WebServer -> ../../../SymlinkedSPMExample/WebService/Types/
        │   └── web-api
        │       └── main.swift
        └── Tests
```

现在我需要更新 `Package.swift` 文件来给代码创建一个新的 target 并且添加一个依赖，从而使得 `web-api` 可执行文件可以使用这些生产代码

`Package.swift`

```swift
// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "web-api",
    targets: [
        .target(name: "web-api", dependencies: [ "WebService" ]),
        .target(name: "WebService"),
    ]
)
```

既然 SPM 知道如何构建项目，那就让我们利用生产解析代码来写之前提到的代码吧。

`main.swift`

```swift
import Foundation
import WebService

do {
  print(try JSONDecoder().decode(BlogPostsRequest.self, from: FileHandle.standardInput.readDataToEndOfFile()).posts)
} catch {
  print(error)
}
```

有了这些后，我们现在可以开始通过这个工具运行 JSON 来看看生产代码是否会处理它：

以下是我们尝试通过这个工具发送有效 JSON 时的样子：

```bash
$ echo '{ "posts" : [] }' | swift run web-api
[]

$ echo '{ "posts" : [ { "title" : "Some post", "tags" : [] } ] }' | swift run web-api
[WebService.BlogPost(title: "Some post", tags: [])]

$ echo '{ "posts" : [ { "title" : "Some post", "tags" : [ { "value" : "cool" } ] } ] }' | swift run web-api
[WebService.BlogPost(title: "Some post", tags: ["cool"])]
```

下面是当我们输入无效的 JSON 时所得到的错误信息示例：

```bash
$ echo '{}' | swift run web-api
keyNotFound(CodingKeys(stringValue: "posts", intValue: nil), Swift.DecodingError.Context(codingPath: [], debugDescription: "No value associated with key CodingKeys(stringValue: \"posts\", intValue: nil) (\"posts\").", underlyingError: nil))

$ echo '{ "posts" : [ { } ] }' | swift run web-api
keyNotFound(CodingKeys(stringValue: "title", intValue: nil), Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "posts", intValue: nil), _JSONKey(stringValue: "Index 0", intValue: 0)], debugDescription: "No value associated with key CodingKeys(stringValue: \"title\", intValue: nil) (\"title\").", underlyingError: nil))

$ echo '{ "posts" : [ { "title" : "Some post" } ] }' | swift run web-api
keyNotFound(CodingKeys(stringValue: "tags", intValue: nil), Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "posts", intValue: nil), _JSONKey(stringValue: "Index 0", intValue: 0)], debugDescription: "No value associated with key CodingKeys(stringValue: \"tags\", intValue: nil) (\"tags\").", underlyingError: nil))
```

*   第一个例子是错误的，因为它没有关键 `posts`
*   第二个例子也是错误的，因为 `posts` 没有 `title` 键
*   第三个例子还是错误的，因为 `posts` 没有 `tags` 键

**在实际应用中，我将用管道的方式输出一个实时或暂存断点的 `curl` 结果，而非手写的 JSON 代码**

这真的很酷，因为我可以看到生产代码没有解析其中的一些示例，并且我可以看到解释了错误原因的信息。如果没有这个工具，我需要手动运行应用程序并找出一种方法来获取不同的 JSON 有效负载而来运行解析逻辑。

### 总结

本文介绍了通过 SPM 使用生产代码来创建工具的基本技术。你可以真正地运行它并创建一些漂亮的工作流程，例如：

*   将该工具添加为 web-api 的持续集成管道中作为一个步骤，以确保使移动客户端崩溃的部署不会发生。
*   展开该工具以应用业务规则（来自生产代码）以查看是否在提要，解析或业务规则层级引入了错误。

我已经开始在我自己的项目中使用这个想法了，我很高兴它能帮助我和我团队的其他成员。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
