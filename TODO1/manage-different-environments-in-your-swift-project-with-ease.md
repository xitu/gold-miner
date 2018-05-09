> * 原文地址：[Managing different environments in your Swift project with ease](https://medium.com/flawless-app-stories/manage-different-environments-in-your-swift-project-with-ease-659f7f3fb1a6)
> * 原文作者：[Yuri Chukhlib](https://medium.com/@YuriD4?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/manage-different-environments-in-your-swift-project-with-ease.md](https://github.com/xitu/gold-miner/blob/master/TODO1/manage-different-environments-in-your-swift-project-with-ease.md)
> * 译者：[melon8](https://github.com/melon8)
> * 校对者：[ALVINYEH](https://github.com/ALVINYEH)，[Swants](https://github.com/swants)

# 轻松管理 Swift 项目中的不同环境

![](https://cdn-images-1.medium.com/max/2000/1*Rk8JulyapCiTCUtLsnsEcQ.png)

想象一下，你已经完成了应用程序的开发和测试，现在你已准备好将其提交并发布。但有个问题：你所有的 API key、URL、图标或其他设置都是针对测试环境进行配置的。因此，在提交应用程序之前，你必须将所有这些内容切换到生产环境。显然，这听起来就不太好。此外，你可能会在你庞大的应用中忘记一两个更改，你所提供的服务自然将无法正常工作。

与其使用这种混乱的方法，不如设置几个环境，并在需要时简单地更改它们。今天，我们将最常用的几个方法来尝试管理环境配置:

1. **使用注释。**
2. **使用全局变量或枚举。**
3. **使用 target 配置和 scheme 并结合全局标志。**
4. **使用 target 配置和 scheme 并结合多个** ***.plist 文件。**

### 1. 使用注释

当你有两个不同的环境时，应用程序需要知道它应该连接到哪个环境。想象一下，你有 `Production`，`Development` 和 `Staging` 环境和多个 API 端点。处理这个问题的最快速和简单的方法是使用 3 个不同的变量，并注释掉其中的 2 个：

```
// MARK: - Development
let APIEndpointURL = "http://mysite.com/dev/api"
let analyticsKey = "jsldjcldjkcs"

// MARK: - Production
// let APIEndpointURL = "http://mysite.com/prod/api"
// let analyticsKey = "sdcsdcsdcdc"
// MARK: - Staging
// let APIEndpointURL = "http://mysite.com/staging/api"
// let analyticsKey = "lkjllnlnlk"
```

这种方法很脏乱，会让你哭得很厉害。有时我在黑客马拉松上用它，那对代码的质量没有任何要求，只看重速度和灵活性。在任何其他情况下，我强烈建议不要使用它。

### 2.使用全局变量或枚举

另一种流行的方法是有一个全局变量或 `Enum`（这个会更好）来处理不同的配置。你需要在你的 `Enum` 中声明 3 个环境（例如在 `AppDelegate` 文件中）设置它的值：

```
enum Environment {
    case development
    case staging 
    case production
}
 
let environment: Environment = .development
 
switch environment {
case .development:
    // 将 web 服务 URL 设置为开发环境
    // 将 API key 设置为开发环境
    print("It's for development")
case .staging:
    // 将 web 服务 URL 设置为预上线环境
    // 将 API key 设置为开发环境
    print("It's for staging")
case .production:
    // 将 web 服务 URL 设置为生产环境
    // 将 API key 设置为开发环境
    print("It's for production")
}
```

这种方法让你每次要更改代码时只需设置一次环境。与以前的方法相比，这个更好，更快而且可读性更强，但也有很多限制。首先，在运行任何环境时，你始终拥有相同的 Bundle ID。这意味着你无法同时在设备上拥有 2 个分别对应不同环境的应用，这简直让人难受。

此外，为每个环境设置不同的图标也是一个不错的主意，但采用这种方法，你无法更改图标。而且，如果你在发布应用程序之前忘记更改这个全局变量，那你肯定会遇到问题。

* * *

让我们继续尝试另外两种方法来更快地切换环境。这两个方法对于新建的项目和现有的大型项目都适用。所以跟着本教程，你可以很容易地应用在你现有的一个项目上。

应用这些方法之后，你的应用的每个环境将会使用相同的代码库，但对于每种配置，能够拥有不同的图标和不同的 Bundle ID。分发过程也非常简单。而最重要的是，项目经理和测试人员将能够将你不同环境配置的应用独立安装在他们的设备上，所以他们会完全理解他们试用的版本。

### 3. 使用 target 配置和 scheme 并结合全局标志

在这种方法中，我们需要创建 3 个不同的 configuration 和 3 种不同的 scheme，并将 scheme 和对应 configuration 连接起来。我将创建一个叫“Environments”的项目来演示这一过程，你也可以创建一个新项目或在现有项目中实现。

在 Project Navigator 面板中点击你的项目跳到项目设置。在 target 部分中，右键单击现有 target 并选择 Dublicate 来复制当前 target。

![](https://cdn-images-1.medium.com/max/800/0*kJt7iX0pJ_OCbYH7.)

现在我们有一个新的 target 和一个叫做“Environments copy”的 scheme。让我们重命名为一个合适的名字。左键单击你的新 target，回车，将其名称更改为“Environments Dev”。

接下来，点击“Manage Schemes…”，选择在上一步中创建的新 scheme，然后按回车，重命名使其与新创建的 target 同名避免混淆。

![](https://cdn-images-1.medium.com/max/800/0*pAV3RMB8AJBsTIgL.)

然后，让我们创建一个新的图标资源，以便测试人员和管理员方便地知道他们启动的 app 对应的配置。

进入 Assets.xcassets，点击“+”并选择“New iOS App Icon”。将其名称更改为“AppIcon-Dev”。

![](https://cdn-images-1.medium.com/max/800/0*Wuq-Rd6IHVMAgTm0.)

现在我们可以将这个新的图标资源与我们的开发环境对应起来。进入“Targets”，左键单击你的 Dev taget，找到“App Icon Source”并选择你的新的图标资源。

![](https://cdn-images-1.medium.com/max/800/0*LyxuDi3gg8Ca69p7.)

就是这样，现在每个 configuration 都有不同的图标。请注意，当我们创建第二个 configuration 时，第二个 *.plist 文件也是为我们的第二个环境生成的。

重要提示：现在我们有两种不同的方法来处理两种不同的配置：

1. **为生产和开发目标添加预处理宏/编译器标志。**
2. **将变量添加到 `*.plist` 中。**

我们将从第一个方法开始讲这两种方法。

添加一个代表开发环境的标志，首先需要选择刚才建立的开发环境的 target，进入“Build Settings”并找到“Swift Compiler — Custom Flags”部分。将该值设置为“-DEVELOPMENT”，将你的目标标记为开发环境。

![](https://cdn-images-1.medium.com/max/800/0*Henhnxiv07NEtDkk.)

然后在代码中像这样配置不同的环境：

```
#if DEVELOPMENT
let SERVER_URL = "http://dev.server.com/api/"
let API_TOKEN = "asfasdadasdass"
#else
let SERVER_URL = "http://prod.server.com/api/"
let API_TOKEN = "fgbfkbkgbmkgbm"
#endif
```

现在，如果您选择 Dev scheme 并运行你的程序，应用程序将会自动运在开发环境配置下。

### 4.使用 target 配置和 scheme 并结合多个 *.plist 文件

在这种方法中，我们需要重复上一个方法的前几个步骤，创建和上个方法相同的几种 configuration 和 scheme。然后，我们不需要再添加全局标志，而是需要添加必要的值到我们的 .plist 文件中。另外，我们将在两个 *.plist 文件中分别添加一个 String 类型的 `serverBaseURL` 变量，并填上 URL。现在每个 *.plist 文件都包含一个 URL，我们需要从代码中调用它。我认为，为我们的 Bundle 创建一个 extension 将是一个不错的主意，如下所示：

```
extension Bundle {
    var apiBaseURL: String {
	return object(forInfoDictionaryKey: "serverBaseURL") as? String ?? ""
    }
}

//And call it from the code like this:
let baseURL = Bundle.main.apiBaseURL
```

就我个人而言，我更喜欢这种方法，因为在你不应该在代码中检查你的配置。你只需询问 Bundle，只用一行代码，就可以根据当前配置得到需要的结果。

#### 在使用多个 target 的时候

*   请记住，存储在 *.plist 文件中的数据可能会被读取，并且可能非常不安全。一种解决方案是，把敏感密钥放在代码中，并仅将其键名放在 *.plist 文件中。
*   添加新文件时，请不要忘记选择两个 target 以保持你的代码在两种配置中同步。
*   如果你使用了持续集成服务，例如 [Travis CI](https://travis-ci.org/) 或 [Jenkins](https://jenkins-ci.org/)，请不要忘记为它们正确地配置。

### 结论

从一开始就以可读和灵活的方式将你的 app 分成不同环境总是有用的。即使用最简单的技术，我们也可以避免许多配置中的典型问题，并显着提高我们的代码质量。

今天，我们简要地从最简单的方法介绍了几种方法，可能还有更多其它的方法来管理配置。我很期待在评论中看见你的方法。

谢谢阅读 ：）


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
