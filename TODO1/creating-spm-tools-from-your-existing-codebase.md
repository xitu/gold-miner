> * 原文地址：[Creating Swift Package Manager tools from your existing codebase](https://paul-samuels.com/blog/2018/09/01/creating-spm-tools-from-your-existing-codebase/?utm_campaign=Swift%20Weekly&utm_medium=Swift%20Weekly%20Newsletter%20Issue%20129&utm_source=Swift%20Weekly)
> * 原文作者：[Paul Samuels](https://paul-samuels.com)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/creating-spm-tools-from-your-existing-codebase.md](https://github.com/xitu/gold-miner/blob/master/TODO1/creating-spm-tools-from-your-existing-codebase.md)
> * 译者：
> * 校对者：

# Creating Swift Package Manager tools from your existing codebase

The Swift Package Manager (SPM) is perfect for writing quick tools and you can even bring along your existing code from your production apps. The trick is realising that you can symlink a folder into the SPM project, which means with some work you can create a command line tool that wraps parts of your production code.

### Why would you want to do this?

It's very project dependent but a common use case would be for creating support/debugging/CI validation tools. For example a lot of apps work with remote data - in order to carry out it's function the app will need to convert the remote data into custom types and use business rules to do useful things with this data. There are multiple failure points in this flow that will manifest as either an app crash or incorrect app behaviour. The way to debug this would be to fire up the app with the debugger attached and start exploring, this is where it would be nice to have tools to help explore problems and potentially prevent them.

### Caveats

You can not use code that imports `UIKit` which means that this technique is only going to work for `Foundation` based code. This sounds limiting but ideally business logic and data manipulation code shouldn't know about `UIKit`.

Having dependencies makes this technique harder. You can still get this to work but it will require more configuration in `Package.swift`.

### How do you do it?

This depends on how your project is structured. I've got an example project [here](https://github.com/paulsamuels/SymlinkedSPMExample). This project is a small iOS app that displays a list of blog posts (don't look at the iOS project itself it's not really important for this). The blog posts come from a fake JSON feed that doesn't have a particularly nice structure, so the app needs to do custom decoding. In order to keep this light I'm going to build the simplest wrapper possible - it will:

*   Read from standard in
*   Use the production parsing code
*   Print the decoded results or an error

You can go wild and add a lot more features to this but this simple tool will give us really quick feedback on whether some JSON will be accepted by the production code or show any errors that might occur, all without firing up a simulator.

The basic structure of this example project looks like this:

```
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

I have deliberately created a `Types` directory that contains only the code I want to reuse.

To create a command line tool that makes use of this production code I can perform the following:

```
mkdir -p tools/web-api
cd tools/web-api
swift package init --type executable
```

This has scaffolded a project that we can now manipulate. First let's get our production source symlinked:

```
cd Sources
ln -s ../../../SymlinkedSPMExample/WebService/Types WebService
cd ..
```

_You'll want to use a relative path for the symlink or it will break when moving between machines_

The project structure now looks like this:

```
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

Now I need to update the `Package.swift` file to create a new target for this code and to add a dependency so that the `web-api` executable can utilise the production code.

`Package.swift`

```
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

Now that SPM knows how to build the project let's write the code mentioned above to use the production parsing code.

`main.swift`

```
import Foundation
import WebService

do {
  print(try JSONDecoder().decode(BlogPostsRequest.self, from: FileHandle.standardInput.readDataToEndOfFile()).posts)
} catch {
  print(error)
}
```

With this in place we can now start to run JSON through the tool and see if the production code would handle it or not:

Here's what it looks like when we try and send valid JSON through the tool:

```
$ echo '{ "posts" : [] }' | swift run web-api
[]

$ echo '{ "posts" : [ { "title" : "Some post", "tags" : [] } ] }' | swift run web-api
[WebService.BlogPost(title: "Some post", tags: [])]

$ echo '{ "posts" : [ { "title" : "Some post", "tags" : [ { "value" : "cool" } ] } ] }' | swift run web-api
[WebService.BlogPost(title: "Some post", tags: ["cool"])]
```

Here's an example of the error messages we get with invalid JSON:

```
$ echo '{}' | swift run web-api
keyNotFound(CodingKeys(stringValue: "posts", intValue: nil), Swift.DecodingError.Context(codingPath: [], debugDescription: "No value associated with key CodingKeys(stringValue: \"posts\", intValue: nil) (\"posts\").", underlyingError: nil))

$ echo '{ "posts" : [ { } ] }' | swift run web-api
keyNotFound(CodingKeys(stringValue: "title", intValue: nil), Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "posts", intValue: nil), _JSONKey(stringValue: "Index 0", intValue: 0)], debugDescription: "No value associated with key CodingKeys(stringValue: \"title\", intValue: nil) (\"title\").", underlyingError: nil))

$ echo '{ "posts" : [ { "title" : "Some post" } ] }' | swift run web-api
keyNotFound(CodingKeys(stringValue: "tags", intValue: nil), Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "posts", intValue: nil), _JSONKey(stringValue: "Index 0", intValue: 0)], debugDescription: "No value associated with key CodingKeys(stringValue: \"tags\", intValue: nil) (\"tags\").", underlyingError: nil))
```

*   The first example is erroring as there is no key `posts`
*   The second example is erroring because a `post` does not have a `title` key
*   The third example is erroring because a `post` does not have a `tags` key

_In real life I would be piping the output of `curl`ing a live/staging endpoint not hand crafting JSON._

This is really cool because I can see that the production code does not parse some of these examples and I get the error messages that explain why. If I didn't have this tool I would need to run the app manually and figure out a way to get the different JSON payloads to run through the parsing logic.

### Conclusion

This post covers the basic technique of using SPM to create tools using your production code. You can really run with this and create some beautiful workflows like:

*   Add the tool as a step in the CI pipeline of the web-api to ensure no deployments could take place that break the mobile clients.
*   Expand the tool to also apply the business rules (from the production code) to see if errors are introduced at the level of the feed, parsing or business rules.

I've started using the idea in my own projects and I'm excited about how it going to help me and potentially other members of my team.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
