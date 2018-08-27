> * 原文链接: [Simultaneous Xcode 7 and Xcode 8 compatibility](http://radex.io/xcode7-xcode8/)
* 原文作者 : [Radek](http://radex.io/about/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [circlelove](http://github.com/circlelove)
* 校对者 :  [yifili09](https://github.com/yifili09),  [MAYDAY1993](https://github.com/MAYDAY1993)

# 等不及集成 iOS 10 新特性？如何在应用维护与新特性集成之间找到平衡点

你是一位 iOS 开发者。你对于 iOS 10 带来的强大的新特性感到无比兴奋，想把这些在你的应用上实现。想要 _立刻_ 就上手，这样就可以在第一天就转移过去了。但是那是几个月开外的事情了，到时候你需要每隔几周装配正式版本到你的 app 上。这听起来像你吗？

当然，你不能使用 Xcode 8 来编译你的正式——它不可能通过 App Store 审核。所以你将工程分成两个分支，一个是稳定版，另一个是为  iOS 10 开发……

当然这很坑。分支在一段时间内一个特性下的工作是没有压力的。但是要在长达数月的时间里面维持巨大分支，版本变化遍布整个代码仓库，尽管主分支也在演进，你还是能挺住合并时候出现的惨痛的。我的意思是，你有没有尝试过解决 `.xcodeproj` 的合并冲突?

本文当中，我会给你展示如何避免将分支全部合并在一起。对多数应用来说，可能有单个工程文件能够同时在 iOS 9 (Xcode 7) 和 iOS 10 (Xcode 8) 上编译。甚至说如果你结束了分支，这些技巧也能够帮你尽量减少两个分支的区别，同步起来就没那么费力了。

## Swift 2.3 和你

让我们直奔主题：

我们对 Swift 3 感到十分兴奋，那太棒了，如果你在读这篇文章，_你不该还没有使用过它_。它可能就是那么伟大，进行了较大的源代码不兼容更改，比一年前的 Swift 2 大很多。如果你有任何的 Swift 依赖，他也需要在你的 app 完成前更新到 Swift 3 。

有个好消息就是， Xcode8 第一次带有_两个_ Swift 版本：2.0 和3.0 。

为了避免你错过通知， Swift 2.3 在 Xcode 7 里面和 Swift 2.2 是一样的语言，但是有些_小的_ API (之后会有更多)变化。
 
所以！为了保证同步兼容，我们将使用 Swift 2.3 。

## Xcode 配置

但是那样对你来说太明显了。现在让我给你展示如何实际地配置你的 Xcode 项目使得它可以在两个版本下正常运行。

### Swift 版本

![](http://radex.io/assets/2016/xcode7-xcode8/BuildSettings.png)

要开始了，在 Xcode 7 中打开你的项目。进入项目设置，打开创建设置标签，点击 “+” 添加一个 自定义设置：

    “SWIFT_VERSION” = “2.3”

这个选项是 Xcode 8 新添加的，所以尽管这会致使它使用 Swift 2.3 ， Xcode 7 （没有_真正_带有 Swift 2.3 ），就会完全略过它而继续利用 Swift 2.3 构建项目。

###框架资源调配

在框架资源调配方面 Xcode 8 做出了一些调整————他们可以继续为模拟器编译，但是无法为设备进行构建。

为了修复它，检查所有框架目标的创建设置，添加这个选项，就像我们对 `SWIFT_VERSION` 操作的那样：

    “PROVISIONING_PROFILE_SPECIFIER” = “ABCDEFGHIJ/“

确保用你的团队 ID （你可以在 [苹果开发者门户](https://developer.apple.com/account/#/membership/) 里面找到）替代“ABCDEFGHIJ”。

这基本上就是告诉 Xcode 8 “嘿，我来自这个团队，你照应下代码签名，好吗？” 。同样地， Xcode 7 也会忽略它，所以你是安全的。

### 界面生成器

浏览你所有的 `.xib` 和 `.storyboard` 文件，打开右侧边栏，找到第一个（文件检索）标签，找到“打开” 设置。

多数情况下说是“默认（7.0）”。将它改为 “Xcode 7.0” 。这可以确保如果你建立了 Xcode 8 的文件，他只是改变那些和 Xcode 7 向后兼容的部分。

我还是建议你谨慎使用 Xcode 8 改变 XIBs 。它会添加 Xcode version 版本的元数据（我不能保证当你上传到 App Store 的时候会不会去掉），有时也会尝试恢复文件为只适用 Xcode 8 的格式（这是个 bug ）。尽可能地从 Xcode 8 创建文件， 当你没法选择的时候，谨慎地审核 diff ，只提交你需要的代码行。

### SDK 版本

确定你的项目和所有目标都有为 “最新 iOS” 构建配置的“基础 SDK ”
（这几乎是肯定的，但还应该再次检查一下）。这样， Xcode 7 可以为 iOS 9 进行编译，但是你也可以在 Xcode 8 下运行  iOS 10 的特性。

###  CocoaPods 设置

如果你使用 CocoaPods ，你也不得不更新 Pods 工程使其有正确的 Swift 来进行供应配置。

不过不要手工操作，只要把后期安装的钩子加的你的 `Podfile` 上即可：


```
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    # Configure Pod targets for Xcode 8 compatibility
    config.build_settings['SWIFT_VERSION'] = '2.3'
    config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = 'ABCDEFGHIJ/'
    config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
  end
end
```


再次确认使用了你的团队 ID 替代  `ABCDEFGHIJ` 。之后运行 `pod install` 重新生成新的 Pods 工程。

### 在 Xcode 8 之中打开。

好的，时候差不多了：用  Xcode 8 打开你的工程。第一次操作的时候会被众多请求轰炸。

Xcode 会催促你更新到最新的  Swift 。拒绝。

Xcode 也会要求你按“推荐设置”更新工程。同样拒绝。

记住，我们已经设置好了可以在两个版本上编译的工程。现在来说，为了保持同时兼容，最好的事情就是减少变化。更重要的是，我们不想让 `.xcodeproj` 包含任何有关 Xcode 8 的源数据，当我们用了同样的文件发往应用商店的时候。

## 处理 Swift 2.3 差异

正像我上面提到的那样， Swift 2.3 和 Swift 2.2 是同种_语言_。然而， iOS 10 SDK _框架_ 更新了他们的 Swift 解释。我并不是在讨论 [Grand Renaming](https://developer.apple.com/videos/play/wwdc2016/403/)（只能用于 Swift 3 ）————不过，名称、类型和许多可选的 API 都有少量的调整。

### 条件式编译

为了防止你忽略它， Swift 2.2 [介绍了](https://github.com/apple/swift-evolution/blob/master/proposals/0020-if-swift-version.md) 条件编译预处理宏。很容易使用：



```
#if swift(>=2.3)
// this compiles on Xcode 8 / Swift 2.3 / iOS 10
#else
// this compiles on Xcode 7 / Swift 2.2 / iOS 9
#endif
```



漂亮！一个文件，没有分支，实现在两个版本的 Xcode 同时兼容。

有两条你需要知道的警告：

*   这里没有 `#if swift(<2.3)` 或类似的东西，你只能使用 `>=` （不过如果需要的话可以用 `#elseif` ）。
*   与带有 C 预处理器不同， `#if` 和 `#else` 间必须是实在的 Swift 代码。比如，你不能只改变函数签名而不触动本体(见之后的解决案例）。

### 可选变化

在 Swift 2.3 当中，许多特征舍去了不必要的选项，有些（比如许多 `NSURL` 属性）现在_变成_可选的。

当然，你应该使用可选编译来处理，就像这样：


```
#if swift(>=2.3)
let specifier = url.resourceSpecifier ?? ""
#else
let specifier = url.resourceSpecifier
#endif
```



不过这里有条小帮助你可能会对你有用：


```
func optionalize<T>(optional: T?) -> T? {
    return optional
}

func optionalize<T>(nonoptional: T) -> T? {
    return nonoptional
}
```



我知道，它有点奇怪。或许你初次看到结果的时候会比较容易解释：


```
let specifier = optionalize(url.resourceSpecifier) ?? "" // works on both versions!
```



我们利用函数过载来摆脱丑陋的条件编译。看，`optionalize()` 函数把你传过去的一切都变成可选的，除非它早就是可选的，这么一来，它只原样返回参数。这下不论 `url.resourceSpecifier` 是可选的（ Xcode 8 ）还是不可选（ Xcode 7 ），“选项化” 之后的版本都是一样。。


（如果你有兴趣的话，有一条关于实例的要点：过载规则在 Swift 中运行的方式是，一个函数中更具体的变量始终会比一个不太特定的变量更优先选择 。所以，即使 `String?` 匹配两个变量 `T?` 的 `T = String` 和 `T` 的 `T = String?` ，参数还是更接近匹配第一个变量。

类型别名签名变化

在 Swift 2.3 当中，一些函数（尤其是在 macOS SDK ）的自变量类型会发生变化。

例如， `NSWindow` 初始程序曾经看起来像这样：

```
init(contentRect: NSRect, styleMask: Int, backing: NSBackingStoreType, defer: Bool)
```

现在是这样：


```
init(contentRect: NSRect, styleMask: NSWindowStyleMask, backing: NSBackingStoreType, defer: Bool)
```



注意 `styleMask` 的类型。它过去是泛整型（选项作为全局常量导入），但是在 Xcode 8 当中，它被当作合适的 `OptionSetType` 导入。

不幸地，你无法有条件地用同个主体块编译两个版本的签名。但是，不用担心，条件编译类的别名会来助你一臂之力的！




```
#if swift(>=2.3)
#else
typealias NSWindowStyleMask = Int
#endif
```
 

现在你可以在签名中使用 `NSWindowStyleMask` 了，正如在 Swift 2.3 当中的那样。在 Swift 2.2 中，不存在该类型， `NSWindowStyleMask` 只是
`Int` 的别名，所以类型检查没什么问题。

### 非正式和正式协议对比

Swift 2.3 将过去的一些[非正式协议](https://developer.apple.com/library/ios/documentation/General/Conceptual/DevPedia-CocoaCore/Protocol.html)改为了正式协议。

例如，为了做一个 `CALayer` 授权，你只要从 `NSObject` 提取即可，无需宣称遵守 `CALayerDelegate` 。事实上， Xcode 7 上甚至不存在什么协议。不过现在有了。

那么，可选编译类的直观解决方案声明行不起作用。但是你可以在你的Swift 2.2当中的虚拟协议中声明，就像这样：


```
#if swift(>=2.3)
#else
private protocol CALayerDelegate {}
#endif

class MyView: NSView, CALayerDelegate { . . . }
```



## 构建 iOS 10 特性

这么一来，你的工程可以同时在 Xcode 7 和 Xcode 8 进行编译而无需分支。漂亮！

那么现在是时候真正创建 iOS 10 特性了，根据上述的建议和技巧，这完全应该是水到渠成的事情。不过，这里还有一些你需要了解的东西：

1.   仅仅使用 `@available(iOS 10, *)` 和 `if #available(iOS 10, *)` 是不够的。首先，不在正式版应用当中编译任何  iOS 10 代码会更加安全。但是更关键地，当编译器需要这些检查来保证安全 API 使用，还是需要了解这个 API 是否存在 。如果你提到任何 iOS 9 SDK 中不存在的方法或类，代码就无法在 Xcode 7 中编译。

2.  因此，你需要在 `#if swift(>=2.3)` 中封装所有你的 iOS 10 特有代码（你可以安全地认为Swift 2.3 和 iOS 10 现在是等价的）

3.  通常，你需要两个都条件编译（就不会出现 Xcode 7 上无效编译的情况）以及` @available/#available `（来在Xcode 8上通过安全检查）。

4.   当你在 iOS 10 特有特性下工作时，提取所有相关代码为零散的文件最简单了————如此你就可以只在 `#if swift…` 检查封装完整的文件了。（文件可能触及 Xcode 7编译器，但是所有的内容都会被忽略）

## App 扩展

但是事实是，如果你在 iOS 10 上工作，你也许想要为你的 app 添这些新的扩展，而不是仅仅给 app 添加更多代码。

这很难办。我们可以条件编译我们的代码，但是没有这种“条件化目标”。


有个好消息就是，只要 Xcode 7 不用真正编译那些目标，它是不会抱怨的。（似的，它也许会发出提醒工程包含比基本 SDK 高版本 iOS 编译的目标，但是这不是什么大事）。


因此有这样的想法：保留所有的目标和代码，但是选择性地从“目标依赖关系”和“嵌入应用扩展”构建项目当中有条件地移除。

该怎么做呢？我能想到的最好的办法就是为了 Xcode 7 的兼容性，将应用扩展默认禁用创建。只有当你使用 Xcode 8 工作的时候，临时添加扩展，但是永远无法真正提交改变。


如果手动操作这些听起来反复（更不用说和 CI 不兼容以及自动创建了），别担心，我给你做了一个脚本！


打算安装它需要：
```
sudo gem install configure_extensions

```

在 Xcode 工程提交任何改变之前，从应用目标当中移除只适用 iOS 10 的应用扩展：


```
configure_extensions remove MyApp.xcodeproj MyAppTarget NotificationsUI Intents

```

如果在 Xcode8 上工作的时候，把他们添加回来：
```
configure_extensions add MyApp.xcodeproj MyAppTarget NotificationsUI Intents

```

你可以配置你的 `script/` ，在利用 Xcode 构建预启动， Git 预提交钩子，或者与 CI 整合或者自动构建系统（更多工具信息见 [GitHub](https://github.com/radex/configure_extensions) ）。

最后一个关于 iOS 10 app 扩展的建议：Xcode 模板生成的是 Swift 3 而不是 Swift 2.3 的代码。这不会实际工作，所以确保设置应用的扩展“使用了传统 Swift 语言版本”构建为“ yes” ，然后重新在 Swift 2.3 上重写代码。

## 在九月

一旦九月伴着 iOS 10 的发布来临，是时候撤掉对 Xcode 7 的支持而清理一下你的工程了。

我为你们做了一个小的清单（请留个书签以便日后参考）：

*   移除所有残留的 Swift 2.2 代码和不必要的 `#if swift(>=2.3)` 检查。

*   移除所有的过渡代码，例如对 `optionalize()` 的使用，临时的类型别名和假协议
*   移除 `configure_extensions` 脚本的使用，并通过启用新的应用扩展来提交工程设置。
*   更新 CocodaPods ，如果你用到它，从我们添加的  `Podfile`  上移除 `post_install` 钩子（它九月份基本就没什么用了）。
*   更新到 Xcode 工程推荐设置（在侧边栏选择工程，进入菜单，编辑→确认设置……）
*   考虑升级你的供应设置以使用新的  `PROVISIONING_PROFILE_SPECIFIER`
*   确认你依赖所有的 Swift 库都更新到 Swift 3。如果没有，考虑下为 Swift 3 端口出力。
*   当上述所有都已就绪，你就能升级应用到 Swift 3 了！进入 编辑→转换→到最新 Swift  语法……，选择所有你的目标（记住，你需要一次性转换所有内容），查看 diff 并提交！
*   如果你还没有完成，考虑一下移除对 iOS 8 的支持————这样你就可以移除更多的 `@available` 检查和其他条件代码


祝你好运！


发布于July 28, 2016。[反馈](http://radex.io/xcode7-xcode8/)。




