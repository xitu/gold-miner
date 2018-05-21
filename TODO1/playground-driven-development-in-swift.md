> * 原文地址：[Playground driven development in Swift](https://medium.com/flawless-app-stories/playground-driven-development-in-swift-cf167489fe7b)
> * 原文作者：[Khoa Pham](https://medium.com/@onmyway133?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/playground-driven-development-in-swift.md](https://github.com/xitu/gold-miner/blob/master/TODO1/playground-driven-development-in-swift.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：

# Swift 中的 Playground 驱动开发

![](https://cdn-images-1.medium.com/max/2000/1*EbrVuz1m60emAKFrBdboCg.png)

### 快速调整 UI 的需求

通过我们开发的 app，为用户提供最佳使用体验，让生活变得更便利，更丰富多彩，是我们作为移动开发者的天生使命。其中我们要做的一件事就是确保为用户展现的 UI 看起来很棒并且不存在丝毫问题。在大多数情况下，app 可以说是数据的美容师。我们常常从后端获取 json ，解析为 model，并通过 UIView （大多数情况下是 UITableView 或 UICollectionView）将数据渲染出来。

对于 iOS，我们需要根据设计来不断调整用户界面，使其能够适合小尺寸的手持设备。这个过程涉及到更改代码、编译、等待、检查、然后又更改代码等等……像 [Flawless App](https://flawlessapp.io/) 这样的工具可以帮助你轻松地比对 iOS 应用和 Sketch 设计的结果。但真正痛苦的是[编译](https://medium.com/@johnsundell/improving-swift-compile-times-ee1d52fb9bd)部分，这个过程需要花大量的时间，而对于 [Swift](https://github.com/fastred/Optimizing-Swift-Build-Times) 来说，情况就更加糟糕了。它会降低我们快速迭代的效率。感觉编译器像是在编译时偷偷挖矿。😅

如果你使用 [React](https://reactjs.org/)，你就知道它仅仅是状态 `UI = f(state).` 的 UI 表示。你会得到一些数据，然后创建一个 UI 来呈现它。React 具有 [hot reloader](https://github.com/gaearon/react-hot-loader) 和 [Storybook](https://github.com/storybooks/storybook)，所以 UI 迭代会非常快。你只要进行一些改变，立即可以看到结果。你还可以获得全部可能使用的 UI 的各种状态的完整概述。你深知自己也想在 iOS 中这样做！

### Playground

除了在 [2014 年 WWDC 推出了 Swift](https://developer.apple.com/videos/play/wwdc2014/408/)，苹果还推出了 Playground，据说这是“一种探索 Swift 变成语言的新颖创新方式”。

起初我并不十分相信，并且我看到很多关于 Playground 反应缓慢或无反应的抱怨。但当我看到 [Kickstarter iOS 应用](https://github.com/kickstarter/ios-oss)使用 Playground 来加速其样式和开发流程后，它给我留下了深刻的印象。所以我开始在一些应用中也成功使用了 Playground。它不像 [React Native](https://facebook.github.io/react-native/) 或 [Injection App](http://johnholdsworth.com/injection.html) 那样能够立即重新渲染，但希望它以后会越来越好。 😇

或者至少它取决于开发社区。Playground 的使用场景是我们一次只设计一个屏幕或组件。这迫使我们仔细考虑依赖关系，所以我能导入一个特定的屏幕，然后在 Playground 中进行迭代。

### Playground 中的自定义 framework

Xcode 9 允许开发者[在 Playground 中导入自定义 framework](https://help.apple.com/xcode/mac/9.0/#/devc9b33111c)，只要 framework 和 Playground 在同一工作区内。我们可以使用 [Carthage](https://github.com/Carthage/Carthage) 来获取并构建自定义 framework。但如果你使用的是 CocoPods，那么也是没有问题的。
 
![](https://cdn-images-1.medium.com/max/800/1*ZYy8VCrA3i2tI3zpIXwmEw.png)

### 创建 App Framework

如果 Playground 作为嵌套项目添加，Playground 无法访问同一工作区或父项目中的代码。为此，你需要创建一个框架，然后添加在你打算在 Playground 中开发的源文件。我们称之为应用框架。

本文的[演示](https://github.com/onmyway133/UsingPlayground)是一个使用 CocoPods 管理依赖的 iOS 项目。在编写此文时候，使用的是 Xcode 9.3 和 Swift 4.1。

让我们通过使用 CocoPods 的项目来完成 Playground 的开发工作。这里还有一些好的做法。

#### 第一步：添加 pod 文件

我主要使用 CocoaPods 来管理依赖关系。在一些屏幕中，肯定会涉及一些 pod。所以为了我们的应用框架能够正常工作，它需要链接一些 pod。

新建一个工程项目，命名为 `UsingPlayground`。该应用显示一些五彩纸屑颗粒 🎊。有很多选项可以调整这些粒子显示的方式，并且我选择 Playground 来对其进行迭代。

对于该演示，因为我们想要一些有趣的东西，我们将使用 CocoaPods 来获取一个名为 [Cheers](https://github.com/hyperoslo/Cheers) 的依赖项。如果你想庆祝用户达成一些成就时，`Cheers` 可以显示花哨的五彩纸屑效果。

使用 `UsingPlayground` 创建 `Podfile` 作为应用的 [target](https://guides.cocoapods.org/syntax/podfile.html#target)：

```
platform :ios, ‘9.0’
use_frameworks!
pod ‘Cheers’
target ‘UsingPlayground’
```

#### 第二步：在你的应用项目中使用 pod

运行 `pod install` 后，CocoaPods 会生成一个包含 2 个项目的 workspace 文件。一个是我们的 App 工程，另一个是目前只包含了 `Cheers` 的工程。现在的话只有 `Cheers`。关闭你现在的工程，改为打开生成的 workspace 文件。

这非常简单，只是为了确保 pod 能正常工作。编写一些代码来使用 `Cheers`：

```
public class ViewController: UIViewController {
  public override func viewDidLoad() {
    super.viewDidLoad()

    let cheerView = CheerView()
    view.addSubview(cheerView)
    cheerView.frame = view.bounds

    // Configure
    cheerView.config.particle = .confetti

    // Start
    cheerView.start()
  }
}
```

构建并运行工程，享受这些非常迷人的纸屑吧。🎊

#### 第三步：添加 CocoaTouch 框架

为了在 Playground 中可以访问我们的代码，我们需要将其设置为一个框架。在 iOS 中，它是 CocoaTouch 框架的 target。

在 workspace 中选择 `UsingPlayground` 项目，然后添加一个新的 CocoaTouch 框架。这个框架包含了我们的应用程序代码。我们命名为 `AppFramework`。

![](https://cdn-images-1.medium.com/max/800/0*0C17R-Oym31N9BYA.png)

现在将要测试的源文件添加到此框架中。现在，只需检查 `ViewController.swift` 文件并将其添加到 `AppFramework` 的 target 中。

![](https://cdn-images-1.medium.com/max/800/1*Jap3CnRcDmSyo-4aykWsLA.png)

这个简单的项目，现在还只有一个`ViewController.swift`。如果此文件引用了其他文件的代码，则还需要将相关文件添加到`AppFramework` 的 target 中去。这是你应该聪明地去处理[依赖](https://en.wikipedia.org/wiki/Dependency_inversion_principle)的方法。

#### 第四步：将文件添加到 AppFramework

iOS 中 的 `ViewController` 主要位于 UI 层，因此它应该只获取解析过的数据并使用 UI 组件呈现出来。如果当中有一些可能涉及缓存、网络等其他部分的逻辑，这就需要你添加更多的文件到 AppFramework。小而独立的框架显得更合理，因为可以让我们快速迭代。

Playground 不是魔法。你每次更改代码时都需要编译 AppFramework，否则这些更改将不会反映在 Playground 中。如果你不介意编译时间太慢，则可以将所有文件添加到 `AppFramework`。简单地展开组文件夹，选择和添加文件到 target 需要很多时间。更何况，如果你选择文件夹和文件，你将无法将它们添加到 target，只能单独添加文件。

![](https://cdn-images-1.medium.com/max/800/1*cOThYP8EGPrjsDnx06Zg1A.png)

更快的方式在 `AppFramework` 的 target 中选择 `Build Phase`，然后点击 `Compile Sources`。在这里，所有文件都会自动展开，你所需要做的就是选择它们并单击 `Add`。

![](https://cdn-images-1.medium.com/max/800/1*bROv-S-aMElSPB7BpEOhwA.png)

#### 第五步：声明为 public 类型

Swift 类型和方法默认是 internal。所以为了让它们在 Playground 里可见，我们需要将其声明为 public 类型。欢迎阅读更多关于 Swift [访问级别](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AccessControl.html#//apple_ref/doc/uid/TP40014097-CH41-ID5)的信息：

> **开放访问**和**公共访问**使实体可以在其定义模块中的任何源文件中使用，也可以在导入定义模块的另一个模块的源文件中使用。在为框架指定公共接口时，通常使用开放或公开访问。

```
public class ViewController: UIViewController {
  // 你的代码
}
```

#### 第六步：将 pod 添加到 AppFramework

为了让 `AppFramework` 能够使用我们的 pod，我们还需要将这些 pod 添加到框架的 target 中。在你的 `Podfile` 文件中添加  `target ‘AppFramework’`：

```
platform :ios, ‘9.0’
use_frameworks!
pod ‘Cheers’
target ‘UsingPlayground’
target ‘AppFramework’
```

现在再次运行 `pod install`。在极少数的情况下，你需要运行 `pod deintegrate` 和 `pod install` 以保证从干净的版本开始。

#### 第七步： 添加一个 Playground

添加 Playground 并将其拖到 workspace 中。命名为 `MyPlayground`。

![](https://cdn-images-1.medium.com/max/800/1*j9II1EmZWpOCFiY3TQl0YA.png)

![](https://cdn-images-1.medium.com/max/800/1*8YWhaZtgb7aSQF1pthuNZA.png)

#### 第八步：尽情享受

现在来到了最后一步：编写一些代码。在这里我们需要在 Playground 导入 `AppFramework` 和 `Cheers`。我们需要像在应用工程中一样，导入 Playground 中所有使用的 Pod。

Playground 能够最好地测试我们的独立框架或应用。选择 `MyPlayground` 并添加下面的代码。现在我们用 `liveView` 来渲染我们的 `ViewController`：

```
import UIKit
import AppFramework
import PlaygroundSupport

let controller = ViewController()
controller.view.frame.size = CGSize(width: 375, height: 667)
PlaygroundPage.current.liveView = controller.view
```

有时你想测试一个想使用的 pod。新建一个名为 `CheersAlone` 的 `Playground Page`。然后只需输入 `Cheers` 即可。

![](https://cdn-images-1.medium.com/max/800/1*k6eGq11QDCwJInOxGBf9AQ.png)

```
import UIKit
import Cheers
import PlaygroundSupport

// 单独使用 cheer
let cheerView = CheerView()
cheerView.frame = CGRect(x: 0, y: 50, width: 200, height: 400)

// 配置
cheerView.config.particle = .confetti(allowedShapes: [.rectangle, .circle])

// 开始
cheerView.start()

PlaygroundPage.current.liveView = cheerView
```

使用 `PlaygroundPage` 的 [liveView](https://developer.apple.com/documentation/playgroundsupport/playgroundpage/1964506-liveview) 来显示实时视图。切记切换为编辑器模式，以便你可以看到 Playground 的结果，接着 🎉。

![](https://cdn-images-1.medium.com/max/800/1*fY6TpydIPaDMRUBudSLopw.png)

Xcode 底部面板上有一个按钮。这是你可以在 `Automatically Run` 和 `Manual Run` 之间切换的地方。你可以手动停止和开始 Playground。非常的简洁！🤘

### 桥接头文件

你的应用也许要处理一些预构建的二进制的 pod，它们需要通过头文件将 API 暴露出去。在一些应用中，我使用了 [BuddyBuildSDK](https://cocoapods.org/?q=buddybuildsdk) 来查看崩溃日志。如果你看下它的 [podspec](https://github.com/CocoaPods/Specs/blob/master/Specs/d/4/5/BuddyBuildSDK/1.0.17/BuddyBuildSDK.podspec.json#L24)，你会发现它使用了一个名为 `BuddyBuildSDK.h` 的头文件。在我们的应用中，CocoaPods 管理得很好。你所需要做的是通过 `Bridging-Header.h` 在你的应用 target 中导入头文件。

如果你需要查看如何使用桥接头文件，可以阅读[同一项目中的 Swift 和 Objective-C](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html)。

```
#ifndef UsingPlayground_Bridging_Header_h
#define UsingPlayground_Bridging_Header_h

#import <BuddyBuildSDK/BuddyBuildSDK.h>

#endif
```

只需要确保头文件的路径是正确的：

![](https://cdn-images-1.medium.com/max/800/1*ibjorHdbDd_XMSRGOf3J8Q.png)

#### 步骤 1：导入桥接头文件

但是 `AppFramework` 的 target 不容易找到 `BuddyBuildSDK.h`。

> 不支持使用带有框架 target 的桥接头文件

解决办法是在 `AppFramework.h` 文件中引用 `Bridging-Header.h`。 

```
#import <UIKit/UIKit.h>

//! AppFramework 的项目版本号。
FOUNDATION_EXPORT double AppFrameworkVersionNumber;

//! AppFramework的项目版本字符串。
FOUNDATION_EXPORT const unsigned char AppFrameworkVersionString[];

// 在这个头文件中，你可以像 #import <AppFramework/PublicHeader.h> 这样导入你框架中所需的全部公共头文件

#import "Bridging-Header.h"
```

![](https://cdn-images-1.medium.com/max/800/1*iKT_k0n8gozJSEAxvx2uUA.png)

#### 步骤 2：将头文件声明为 public

在完成上述工作后，你会得到

> 包括在框架模块中的非模块头文件

为此，你需要将 `Bridging-Header.h` 添加到框架中，并且声明为 `public`。搜索下 SO，你就会看到[这些](https://stackoverflow.com/questions/7439192/xcode-copy-headers-public-vs-private-vs-project)：

> **Public：**界面已经完成，并打算供你的产品的客户端使用。产品中不受限制地将公共头文件作为可读源代码包括在内。
>
> **Private：**该接口不是为你的客户端设计的，或者是还处于开发的早期阶段。私有头文件会包含在产品中，但会声明为 “privite”。因此，所有客户端都可以看到这些标记，但是应该明白，不应该使用它们。
>
> **Project：**该接口仅供当前项目中的实现文件使用。项目头文件不包含在 target 中，项目代码除外。这些标记对客户端来说不可见，只对你有用。

所以，选择 `Bridging-Header.h` 并将其添加到 `AppFramework` 中，并将可见性设置为 `public`：

![](https://cdn-images-1.medium.com/max/800/1*Mp-FeCeU9qtEWc5Thx75PA.png)

如果你点开 `AppFramework` 的 `Build Phases` ，你会看到有 2 个头文件。

![](https://cdn-images-1.medium.com/max/800/1*nQv6XSSH_-ptsDX_nUOQHg.png)

现在，选择 `AppFramework` 然后点击 `Build`，工程应该可以无错地编译成功。

### 字体、本地化字符串、图片以及包

我们的屏幕不会只是简单地包括其他 pod 的视图。更多的时候，我们显示来自包中的文本和图片。在 `Asset Catalog` 中加入一张钢铁侠的图片和 `Localizable.strings` 文件。`ResourceViewController` 包含了一个 `UIImageView` 和 一个 `UILabel`。

```
import UIKit
import Anchors

public class ResourceViewController: UIViewController {
  let imageView = UIImageView()
  let label = UILabel()

  public override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.gray

    setup()
    imageView.image = UIImage(named: "ironMan")
    label.text = NSLocalizedString("ironManDescription", comment: "Can't find localised string")
  }

  private func setup() {
    imageView.contentMode = .scaleAspectFit
    label.textAlignment = .center
    label.textColor = .black
    label.font = UIFont.preferredFont(forTextStyle: .headline)
    label.numberOfLines = 0

    view.addSubview(imageView)
    view.addSubview(label)

    activate(
      imageView.anchor.width.multiplier(0.6),
      imageView.anchor.height.ratio(1.0),
      imageView.anchor.center,

      label.anchor.top.equal.to(imageView.anchor.bottom).constant(10),
      label.anchor.paddingHorizontally(20)
    )
  }
}
```

在这里，我使用 [Anchors](https://github.com/onmyway133/Anchors) 方便的声明式自动布局🤘。这也是为了展示 Swift 的 Playground 如何处理任意数量的框架。

现在，选择应用模式 `UsingPlayground` 并点击构建和运行。应用会如下所示，正确地显示了图像和本地化的字符串。

![](https://cdn-images-1.medium.com/max/800/1*4gH9VnqAP7wvJfRAQIoo1w.png)

让我们看看 Playground 能否识别这些 Assets 中的资源。在 `MyPlayground` 新建名为 `Resource` 页面，并输入以下代码：

```
import UIKit
import AppFramework
import PlaygroundSupport

let controller = ResourceViewController()
controller.view.frame.size = CGSize(width: 375, height: 667)

PlaygroundPage.current.liveView = controller.view
```

等待 Playground 运行完成。哎呀。在 Playground 中并不是那么好，它不能识别图像和本地化的字符串。😢

![](https://cdn-images-1.medium.com/max/800/1*Vgzy7nGWLfnydX3SOjmD4Q.png)

#### Resources 文件夹

实际上，每个 `Playground Page` 都有一个 `Resources` 文件夹，我们可以在其中放置这个特定页面所看到的资源文件。但是，我们需要访问应用程序包中的资源。

#### Main bundle

当访问图像和本地化字符串时，如果你不指定 `bundle`，正在运行的应用将默认选取 Main bundle 中的资源。以下是更多关于[查找和打开 Bundle](https://developer.apple.com/documentation/foundation/bundle) 的更多信息。

> 在找到资源之前，必须先指定包含该资源的 bundle。`Bundle` 类中有许多构造函数，但是最常用的是 `[main](https://developer.apple.com/documentation/foundation/bundle/1410786-main)` 函数。Main bundle 表示包含当前正在执行的代码的包目录。因此对于应用，Main bundle 对象可以让你访问与应用一起发布的资源。

> 如果应用直接与插件、框架或其他 bundle 内容交互，则可以使用此类的其他方法创建适当的 bundle 对象。

```
//获取应用的 main bundle
let mainBundle = Bundle.main

// 获取包含指定私有类的 bundle
let myBundle = Bundle(for: NSClassFromString("MyPrivateClass")!)
```

#### 步骤 1：在 AppFramework target 中添加资源

首先，我们需要在 AppFramework target 添加资源文件。选择 `Asset Catalog` 和 `Localizable.strings` 并将它们添加到 `AppFramework` target。

![](https://cdn-images-1.medium.com/max/800/1*mI2C1ode8HGlBe4-zp_5ew.png)

#### 步骤 2：指定 bundle

如果我们不指定 bundle，那么默认会使用 `mainBundle`。在执行的 Playground 的上下文中，`mainBundle` 指它的 `Resources` 文件夹。但我们希望 Playground 访问 AppFramework 中的资源，所以我们需要在 `AppFramework` 中使用一个类调用 `[Bundle.nit(for:)](https://developer.apple.com/documentation/foundation/bundle/1417717-init)` 方法来引用 `AppFramework` 中的 bundle。该类可以是 `ResourceViewController`，因为它也被添加到 `AppFramework` target 中。

将 `ResourceViewController` 中的代码更改为：

```
let bundle = Bundle(for: ResourceViewController.self)
imageView.image = UIImage(named: "ironMan", in: bundle, compatibleWith: nil)
label.text = NSLocalizedString(
  "ironManDescription", tableName: nil,
  bundle: bundle, value: "", comment: "Can't find localised string"
)
```

每次更改 `AppFramework` 中的代码时，我们都需要重新编译。这点非常重要。现在打开 Playground，应该能找到正确的资源文件了。

![](https://cdn-images-1.medium.com/max/800/1*M0_mNdOVjjV3FjAY4eRy7A.png)

#### 那么自定义字体呢？

我们需要注册字体才能使用。我们可以使用 `CTFontManagerRegisterFontsForURL` 来注册自定义字体，而不是使用 plist 文件中 `Fonts provided by application` 提供的字体。这很方便，因为字体也可以在 Playground 中动态注册。

下载一个名为 [Avengeance](http://www.fontspace.com/the-fontry/avengeance) 的免费字体，添加到应用和`AppFramework` target 中。

在 `ResourceViewController` 中添加指定字体的代码，记得重新编译 `AppFramework`：

```
// 字体
let fontURL = bundle.url(forResource: "Avengeance", withExtension: "ttf")
CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
let font = UIFont(name: "Avengeance", size: 30)!
label.font = font
```

接着，你可以在应用和 Playground 中看见自定义字体。🎉

![](https://cdn-images-1.medium.com/max/800/1*Iz6t5ai_1hZa0lkdtAkblg.png)

### 设备尺寸和特征集合

iOS 8 引入了 [TraitCollection](https://developer.apple.com/documentation/uikit/uitraitcollection) 来定义设备尺寸类，缩放以及用户界面习惯用法，简化了设备描述。Kickstarter-ios 应用有一个方便的工具来准备 `UIViewController`，以便在 Playground 中使用不同的特性。参见 [playgroundController](https://github.com/kickstarter/ios-oss/blob/master/Kickstarter-iOS.playground/Sources/playgroundController.swift)：

```
public func playgroundControllers(device: Device = .phone4_7inch,
                                  orientation: Orientation = .portrait,
                                  child: UIViewController = UIViewController(),
                                  additionalTraits: UITraitCollection = .init())
  -> (parent: UIViewController, child: UIViewController) {
```

[AppEnvironment](https://github.com/kickstarter/ios-oss/blob/1b21ce9100edc2700b30f41432f4c6077febba69/Library/AppEnvironment.swift) 像是一个堆栈，可以改变依赖，应用属性，如 bundle、区域设置和语言。参考一个关于[注册页面](https://github.com/kickstarter/ios-oss/blob/7b7be2f6ca7012bef04db90a6ed64f03f661a8f2/Kickstarter-iOS.playground/Pages/Signup.xcplaygroundpage/Contents.swift)的例子：

```
import Library
import PlaygroundSupport
@testable import Kickstarter_Framework

// 实例化注册视图控制器
initialize()
let controller = Storyboard.Login.instantiate(SignupViewController.self)

// 设置设备类型和方向
let (parent, _) = playgroundControllers(device: .phone4inch, orientation: .portrait, child: controller)

// 设置设备语言
AppEnvironment.replaceCurrentEnvironment(
  language: .en,
  locale: Locale(identifier: "en") as Locale,
  mainBundle: Bundle.framework
)

// 渲染屏幕
let frame = parent.view.frame
PlaygroundPage.current.liveView = parent
```

### 无法查找字符

使用 Playground 过程中可能会出现一些错误。其中一些是因为你的代码编写问题，一些是配置框架的方式。当我升级到 [CocoaPods 1.5.0](http://blog.cocoapods.org/CocoaPods-1.5.0/)，我碰到：

```
error: Couldn’t lookup symbols:

__T06Cheers9CheerViewCMa

__T012AppFramework14ViewControllerCMa

__T06Cheers8ParticleO13ConfettiShapeON

__T06Cheers6ConfigVN
```

符号查找问题意味着 Playground 无法找到你的代码。这可能是因为你的类没有声明为 public，或者你忘记添加文件到 `AppFramework` target。又或者 `AppFramework` 和 `Framework search path` 无法找到引用的 pod……等等。

1.5.0 的版本支持了静态库，也改变了模块头文件。与此同时，将演示的例子切换回 `CocoaPods 1.4.0`，你可以看下 [UsingPlayground demo](https://github.com/onmyway133/UsingPlayground)。

在终端中，输入 `bundler init` 来生成 `Gemfile` 文件。将 gem `cocoapods` 设置为 1.4.0：

```
# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem "cocoapods", '1.4.0'
```

现在运行 `bundler exec pod install` 来执行 `CocoaPods 1.4.0` 中的 pod 命令。应该可以解决问题。

### 了解更多

Swift 的 Playground 同时支持 `macOS` 和 `tvOS` 系统。如果你想了解更多，这里有一些有趣的链接。

*   [Playground Driven Development](https://www.youtube.com/watch?v=DrdxSNG-_DE)：[Brandon Williams](https://medium.com/@mbrandonw) 的演示文稿以及 [kickstarter-ios](https://github.com/kickstarter/ios-oss/tree/master/Kickstarter-iOS.playground) 项目对如何使用 Playground 来开发应用会有所启发。此外，在 objc.io 关于 [Playground-Driven Development](https://talk.objc.io/episodes/S01E51-playground-driven-development-at-kickstarter) 的谈话也非常不错。
*   PointFree：该[网站](https://github.com/pointfreeco/pointfreeco/tree/master/PointFree.playground)在 Playground 下开发完成的。通过阅读代码和他们的项目结构，你可以学到很多东西。
*   [Using Swift to Visualize Algorithms](https://www.youtube.com/watch?v=7e13FierAF8&index=3&list=PLCl5NM4qD3u92PwamgwWr3e_j3GmKRVTs)：Playground 也将你的想法原型化和可视化。
*   我的朋友 Felipe 在 [How to not get sand in your eyes](https://github.com/fespinoza/Talks/tree/master/2018-03-20-how-not-get-sand-in-your-eyes) 上还编写了他是如何在工作中成功使用 Playground 的文章。
*   同时，如果你想眼前一亮，[Umberto Raimondi](https://medium.com/@uraimo) 列举了一系列关于 Swift 的 [Awesome Playground 项目清单](https://github.com/uraimo/Awesome-Swift-Playgrounds)。

感谢 [Lisa Dziuba](https://medium.com/@lisadziuba?source=post_page)。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
