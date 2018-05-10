> * 原文地址：[Build it, Test it, Deliver it! Complete iOS Guide on Continuous Delivery with fastlane and Jenkins](https://medium.com/flawless-app-stories/build-it-test-it-deliver-it-complete-ios-guide-on-continuous-delivery-with-fastlane-and-jenkins-cbe44e996ac5)
> * 原文作者：[S.T.Huang](https://medium.com/@koromikoneo?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/build-it-test-it-deliver-it-complete-ios-guide-on-continuous-delivery-with-fastlane-and-jenkins.md](https://github.com/xitu/gold-miner/blob/master/TODO1/build-it-test-it-deliver-it-complete-ios-guide-on-continuous-delivery-with-fastlane-and-jenkins.md)
> * 译者：[talisk](https://github.com/talisk)
> * 校对者：[ALVINYEH](https://github.com/ALVINYEH)，[rydensun](https://github.com/rydensun)

# 构建、测试、分发！运用 Fastlane 与 Jenkins，完整的 iOS 持续交付指南。

![](https://cdn-images-1.medium.com/max/2000/0*Rj31MgxTgf2Z0Peo.)

iOS/macOS 真的很有趣。
你可以在很多领域获得知识！你可能会了解 Bezier 或 3D 变换等图形技术。你也需要了解如何使用数据库、设计高效的架构。此外，你应该掌握嵌入式系统的内存管理方式（特别是那些处于 MRC 时代的人）。所有这些使得 iOS/macOS 的开发如此多元化并且具有挑战性。

**在这篇文章里，我们将要学习你可能想了解的另一些知识：持续交付（CD）**。持续交付是一种软件方法，可帮助你随时可靠地发布产品。持续交付（CD）通常带有术语**持续集成（CI）**。CI 也是一种软件工程技术。这意味着系统始终将开发者的工作不断地合并到主线。CI 和 CD 不仅对一个大团队有用，而且对单人团队也有用。如果你是单人团队的唯一开发人员，CD 对你来说可能意味着更多，因为每个应用程序开发人员都无法避免交付。因此，本文将重点介绍如何为你的应用程序构建 CD 系统。幸运的是，所有这些技术也可以用于构建 CI 系统。

想象一下我们正在开发一款名为 **Brewer** 的 iOS 应用，我们的工作流大概像下图这样：

![](https://cdn-images-1.medium.com/max/800/0*0jXhBlVFGke_tF_2.)

首先，我们开发。然后 QA 组的同事帮我们手工测试应用。QA 人员批准构建测试后，我们放出（提交到 AppStore 待审核）我们的应用。在不同的阶段中，我们有不同的环境。在开发期，我们创建的应用在一个测试环境中，以备平时测试。当 QA 组正在测试时，我们准备一个生产环境的应用，这可能是每周专门提供给 QA 测试用。最后，我们提交一个生产环境的应用。这样，最终构建可能没有一个明确的时间表。

让我们深入了解交付部分。你可能会发现我们在构建测试应用程序方面有很多重复的工作。这是 CD 系统可以帮助你的。具体来说，我们的 CD 系统需要：

1. 在不同的环境中构建应用程序（测试环境/生产环境）。
2. 根据我们选择的环境给应用签名。
3. 导出应用程序并将其发送到分发平台（例如 Crashlytics 和 TestFlight）。
4. 根据特定的时间表，构建应用程序。

### **概要**

以下是我们在本文中要做的事情：

* **设置你的项目**：如何设置你的项目以支持不同环境之间的切换。
* **手动代码签名**：如何手动处理证书和配置文件。
* **独立环境**：如何使用 Bundler 隔离系统环境。
* **使用 fastlane 构建**：如何使用 fastlane 构建和导出应用程序。
* **Jenkins 今晚将为你服务**：Jenkins 如何帮助你安排任务。

开始之前，你可能需要看看这些：

*   什么是 [fastlane](https://fastlane.tools/)
*   什么是 [Jenkins](https://jenkins.io/)
*   什么是 [Code signing](https://developer.apple.com/support/code-signing/)

如果你是个忙碌的帅哥或靓女，别担心，我为你在公共仓库里准备了 Brewer 应用以及一些示例脚本！

* [**koromiko/Brewer**: Brewer - We brew beer every night! github.com](https://github.com/koromiko/Brewer)

那么，让我们开始吧！

### 设置你的项目

我们通常在开发人员测试阶段连接到开发服务器或测试服务器。我们还需要在将应用发给 QA 组测试，或 AppStore 时，连接到生产服务器。通过编辑代码切换服务器可能不是一个好主意。这里我们使用 Xcode 中的构建配置和编译器标志。我们不会详细介绍配置。如果你对该设置该兴趣，可以看看这篇 [Yuri Chukhlib](https://twitter.com/D4Yuri) 写的不错的文章：

* [**轻而易举地在 Swift 项目中管理环境**
medium.com](https://github.com/xitu/gold-miner/blob/master/TODO1/manage-different-environments-in-your-swift-project-with-ease.md)

在我们的 Brewer 项目中，我们有三个构建选项：

*   Staging
*   Production
*   Release

每个都映射到特定的 Bundle 标识：

![](https://cdn-images-1.medium.com/max/800/0*CyWbsYZ-6ZzrrY9y.)

我们通过设置标识，来让代码知晓我们正在用哪个环境。

![](https://cdn-images-1.medium.com/max/800/0*k8Fb1CXd1SpIgFoK.)

因此我们可以像这样来写：

```
#if PROD
  print(“We brew beer in the Production”)
#elseif STG
  print(“We brew beer in the Staging”)
#endif
```

现在我们能够不用修改代码，通过构建选项来切换测试环境与生产环境了！🎉

### 手动代码签名

![](https://cdn-images-1.medium.com/max/800/0*rfY9x3TB7VEnUENC.)

这是每个 iOS / macOS 开发人员熟知的红色按钮。我们通过取消选中此框来启动每个项目。但为什么它如此臭名昭着？你可能知道它会下载证书和配置文件，并将其嵌入到你的项目和系统中。如果有任何文件遗漏，它会为你制作一个新文件。对于单人的项目组来说，这里不会有问题。但是如果你在一个大团队中，你可能会无意中刷新原始证书，然后由于证书无效而导致构建系统停止工作。对我们来说，这是一个隐藏了太多信息的黑匣子。

所以在我们 Brewer 项目中，我们想手动做这件事，在我们的配置中有有三个应用 ID：

*   **works.sth.brewer.staging**
*   **works.sth.brewer.production**
*   **works.sth.brewer**

我们将在这篇文章里关注前两个配置，现在我们要准备：

*   **Certificate**：一个 Ad Hoc、App Store 分发证书，采用 .p12 格式。
*   **Provisioning Profiles**：两个应用标识的 Ad Hoc 分发配置文件，**works.sth.brewer.staging** 与 **works.sth.brewer.production**。

提醒下，我们需要 p12 格式的证书文件，因为我们希望其可用在不同的机器上，只有 .p12 格式包含了证书的私钥。看[这篇文章](https://stackoverflow.com/questions/39091048/convert-cer-to-p12)来了解如何将 .cer（DEM 格式）文件转换为 .p12（P12 格式）格式文件。

现在目录下有我们的证书签名文件：

![](https://cdn-images-1.medium.com/max/800/0*qnhxIxQwwRlMeTP3.)

这些文件由 CD 系统使用，所以请将该文件夹放在 CD 机器上。 请**不要**将这些文件放到你的项目中，**不要**将它们提交到你的项目仓库。 将代码签名文件托管在不同的私有仓库中可以。你可能希望了解有关安全问题的讨论，可以看看 [match — fastlane docs](https://docs.fastlane.tools/actions/match/#is-this-secure)。

### 用 fastlane 构建 🚀

[fastlane](https://docs.fastlane.tools/) 是让开发和发布工作流自动化的工具。比如，它可以通过一个脚本构建应用、运行单元测试、向 Crashlytics 上传二进制。你不需要一步一步手动地做这些事。

在这个项目中，我们将要用 fastlane 完成两项任务：

*   构建、发布测试环境的应用。
*   构建、发布生产环境的应用。

这两种方法之间的区别仅仅在于配置。共同的任务包括：

*   用证书和配置文件签名
*   构建并导出应用
*   把应用上传到 Crashlytics（或其它分发平台）

明确了任务，我们现在可以开始编写 fastlane 脚本了。我们将使用 Swift 版 fastlane 在我们的项目中编写我们的脚本。Swift 版 fastlane 还在测试阶段，运行一切良好，但除了：

*   它还不支持插件
*   它不能捕获异常

但是用 Swift 编写脚本使得开发人员更易于阅读和维护。而且你可以轻松地将 Swift 脚本转换为 Ruby 脚本。所以让我们试试吧！

首先初始化我们的项目（还记得 Bundler 吧？）：

```
bundler exec fastlane init swift
```

然后，你可以在 fastlane/Fastfile.swift 中找到脚本。在脚本中，有一个 fastfile 类。这是我们的主要程序。在本类中用 **Lane** 为后缀命名的每一个方法都是一个 lane。我们可以将预定义的动作添加到 lane，并使用命令执行 lane：

```
bundle exec fastlane <lane name>.
```

让我们填充一些代码：

```
class Fastfile: LaneFile {
    func developerReleaseLane() {
        desc("Create a developer release")
	package(config: Staging())
	crashlytics
    }

    func qaReleaseLane() {
        desc("Create a qa release")
        package(config: Production())
        crashlytics
    }
}
```

我们为任务创建两个 lane：**developerRelease** 和 **qaRelease**。这两个任务都做了同样的事：用指定配置来构建打包，并将导出的 ipa 上传到 Crashlytics。

两个 lane 都有一个 package 方法。**package()** 方法的声明看起来是这样：

```
func package(config: Configuration) {
}
```

参数时一个遵循 Configuration 协议的对象。Configuration 的定义如下：

```
protocol Configuration {
    /// file name of the certificate 
    var certificate: String { get } 

    /// file name of the provisioning profile
    var provisioningProfile: String { get } 

    /// configuration name in xcode project
    var buildConfiguration: String { get }

    /// the app id for this configuration
    var appIdentifier: String { get }

    /// export methods, such as "ad-doc" or "appstore"
    var exportMethod: String { get }
}
```

然后我们创建两个两个遵循该协议的结构体：

```
struct Staging: Configuration { 
    var certificate = "ios_distribution"
    var provisioningProfile = "Brewer_Staging"
    var buildConfiguration = "Staging"
    var appIdentifier = "works.sth.brewer.staging"
    var exportMethod = "ad-hoc"
}

struct Production: Configuration { 
    var certificate = "ios_distribution"
    var provisioningProfile = "Brewer_Production"
    var buildConfiguration = "Production"
    var appIdentifier = "works.sth.brewer.production"
    var exportMethod = "ad-hoc"
}
```

使用该协议，我们能够确保每个配置都具有所需的设置。每当我们有新的配置时，我们不需要编写 package 的详细信息。

那么，**package(config:)** 看起来如何？说爱你他需要从文件系统中导入证书。记住我们的代码签名文件夹，我们用 [importCertificate](https://docs.fastlane.tools/actions/import_certificate/) action 来实现我们的目标。

```
importCertificate(
    keychainName: environmentVariable(get: "KEYCHAIN_NAME"),
    keychainPassword: environmentVariable(get: "KEYCHAIN_PASSWORD"),
    certificatePath: "\(ProjectSetting.codeSigningPath)/\(config.certificate).p12",
    certificatePassword: ProjectSetting.certificatePassword
)
```

keychainName是你的钥匙串的名称，默认名称是『登录』。**keychainPassword** 是你钥匙串的密码，fastlane 使用它来解锁你的钥匙串。由于我们将 Fastfile.swift 提交到仓库以确保交付代码在每台计算机中都是一致的，因此在 Fastfile.swift 中将密码写为字符串文字可不是一个好主意。因此，我们使用环境变量来替换字符串文字。在系统中，我们用这个方式来保存环境变量：

```
export KEYCHAIN_NAME=”KEYCHAIN_NAME”;
export KEYCHAIN_PASSWORD=”YOUR_PASSWORD”;
```

在 Fastfile 中，我们用 **environmentVariable(get:)** 获得环境变量的值。通过使用环境变量，我们可以避免代码中出现密码，来显著提高安全性。

回到 **importCertificate()**，**certificatePath** 是你的 .p12 证书文件的路径。我们创建一个名为 **ProjectSetting** 的枚举来标识共享的项目设置。这里我们也用环境变量来传递密码。

```
enum ProjectSetting {
    static let codeSigningPath = environmentVariable(get: "CODESIGNING_PATH")
    static let certificatePassword = environmentVariable(get: "CERTIFICATE_PASSWORD")
}
```

导入证书后，我们将设置配置文件。我们用 [updateProjectProvisioning](https://docs.fastlane.tools/actions/update_project_provisioning/)：

```
updateProjectProvisioning(
    xcodeproj: ProjectSetting.project,
    profile: "\(ProjectSetting.codeSigningPath)/\(config.provisioningProfile).mobileprovision",
    targetFilter: "^\(ProjectSetting.target)$",
    buildConfiguration: config.buildConfiguration
)
```

此操作获取配置文件，导入配置文件并在指定的配置中修改你的项目设置。配置文件参数是提供配置文件的路径。目标过滤器使用正则表达式符号来查找我们要修改的目标。请注意，updateProjectProvisioning 不会修改你的项目文件，因此如果你想在本地计算机上运行它，请小心。CD 任务无关紧要，因为 CD 系统不会对代码库进行任何更改。

好的，我们完成了代码签名部分！以下部分将非常简单明了，请耐心等待！

让我们现在来构建应用：

```
buildApp(
    workspace: ProjectSetting.workspace,
    scheme: ProjectSetting.scheme,
    clean: true,
    outputDirectory: "./",
    outputName: "\(ProjectSetting.productName).ipa",
    configuration: config.buildConfiguration,
    silent: true,
    exportMethod: config.exportMethod,
    exportOptions: [
        "signingStyle": "manual",
        "provisioningProfiles": [config.appIdentifier: config.provisioningProfile] ],
    sdk: ProjectSetting.sdk
)
```

[buildApp](https://docs.fastlane.tools/actions/build_app/) 帮助你构建并导出项目。它底层是调用 **xcodebuild** 的。除了 **exportOptions**，每个参数都很直观。让我们看看它长啥样：

```
exportOptions: [
    "signingStyle": "manual",
    "provisioningProfiles": [config.appIdentifier: config.provisioningProfile] ]
```

不像其他参数，它是一个 dictionary。**signingStyle** 是你想要代码签名的方式，我们在这里放置了 **manual**。**provisioningProfiles** 也是一个字典。这是应用程序 ID 和相应的配置文件之间的映射。最后我们完成了 fastlane 设置！现在你可以直接执行：

```
bundle exec fastlane qaRelease
```

或是这样：

```
bundle exec fastlane developerRelease
```

来用合适的配置发布测试构建！

### Jenkins 今晚将为你服务

Jenkins是一个自动化服务器，可帮助你执行 CI 与 CD 任务。它运行一个 Web GUI 界面，并且很容易定制，所以它对于敏捷团队来说是一个很好的选择。Jenkins 在我们项目中的规则如图所示：

![](https://cdn-images-1.medium.com/max/800/0*9grv9Y-KdYv5vHGk.)

Jenkins 获取项目的最新代码并定期为你运行任务。在执行脚本的部分，我们可以看到 Jenkins 实际上执行了我们在前几节中所做的任务。但现在我们不需要自己做，Jenkins 无缝地为你完成了这些！

从每晚构建作业开始，让我们开始创建一个 Jenkins 任务。首先，我们创建一个『自定义项目』，并进入它的『配置』页面。我们需要配置的第一件事是**源代码管理**（SCM）部分：

![](https://cdn-images-1.medium.com/max/800/0*6txUjxhUml5zC1wb.)

**Repository URL** 是项目源代码的地址。如果你的仓库是私有的，你需要添加 **Credentials** 以获得仓库读取权限。你可以在 **Branches to build** 中设置目标分支，通常它是你的默认分支。

然后，接下来我们可以看到 **Builder Trigger** 部分。在本节中，我们可以决定是什么触发了构建作业。根据我们的工作流，我们希望它每周周末晚上开始。

![](https://cdn-images-1.medium.com/max/800/0*I-YHW-1sJ44wooCR.)

然后我们检查 **Poll SCM**，这意味着 Jenkins 会定期轮询指定的仓库。日程安排文本区域要写上以下内容：

```
H 0 * * 0–4
```

这是什么意思呢？让我们先看看官方说明：

> 这个字段遵循 cron 的语法（有细微差别）。具体而言，每行包含由 TAB 或空格分隔的 5 个字段：
> MINUTE HOUR DOM MONTH DOW
> MINUTE 分钟小时内的分钟数（0-59）
> HOUR 小时一天中的小时（0-23）
> DOM 每月的一天（1-31）
> MONTH（1-12）
> DOW 星期几（0-7），其中0和7是星期日。

它由五部分构成

*   分钟
*   小时
*   日期
*   月份
*   周

该字段可以是数字。 我们也可以用『\*』来表示『所有』数字。 我们用『H』表示一个 hash，自动选择『某个』数字。

所以我们会这样写：

```
H 0 * * 0–4
```

意思是：任务将在周日到周四，每晚零点到一点执行。

最后，但是最重要的，来检查下 **Build** 部分的内容，这是我们希望 Jenkins 执行的东西：

```
export LC_ALL=en_US.UTF-8;
export LANG=en_US.UTF-8;

export CODESIGNING_PATH=”/path/to/cert”;
export CERTIFICATE_PASSWORD=”xxx”;
export KEYCHAIN_NAME=”XXXXXXXX”;
export KEYCHAIN_PASSWORD=”xxxxxxxxxxxxxx”

bundle install — path vendor/bundler
bundle exec fastlane developerRelease
```

前 6 行是设置我们之前描述的环境变量。第 7 行安装依赖项，包括 fastlane。然后最后一行执行一个名为『developerRelease』的 lane。总之，这个任务每个工作日晚上都会建立并上传一个 developerRelease。这是我们第一次每晚构建！🚀

你可以通过单击 Jenkins 项目页面的侧面菜单中的内部版本号来检查构建状态：

![](https://cdn-images-1.medium.com/max/800/0*YFImLvOHvNHYCyfS.)

### 综述

我们一起学会了如何用 fastlane 和 Jenkins 创建 CD 系统。我们了解如何手动管理代码签名。我们自动为我们创建了一条运行任务。我们还探讨了如何在不更改代码的情况下切换配置。最后，我们建立了一个每天晚上构建应用程序的 CD 系统。

尽管许多 iOS 与 macOS 应用程序是由单人团队创建的，但自动化交付流程仍然是一项高效的改进。通过自动化流程，我们可以降低配置错误的风险，避免被过期的代码签名所阻塞，并减少构建上传的等待时间。

本文中介绍的工作流程可能与你的工作流程不完全相同，但掌握每个团队自己的工作流程和步伐非常重要。所以你必须创建自己的 CD 系统来满足你的团队的需要。通过将这些技术用作构建模块，你一定能够构建自己定制的、更好的 CD 系统！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
