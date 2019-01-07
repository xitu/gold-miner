> * 原文地址：[State Restoration Tutorial: Getting Started](https://www.raywenderlich.com/1395-state-restoration-tutorial-getting-started)
> * 原文作者：[Luke Parham](https://www.raywenderlich.com/1395-state-restoration-tutorial-getting-started)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/state-restoration-tutorial-getting-started.md](https://github.com/xitu/gold-miner/blob/master/TODO1/state-restoration-tutorial-getting-started.md)
> * 译者：[nanjingboy](https://github.com/nanjingboy)
> * 校对者：[chausson](https://github.com/chausson)

# 状态恢复入门教程

在这篇状态恢复教程中，我们将了解如何使用 Apple 的状态恢复接口来提升用户的应用体验。

**注意**：Xcode 7.3、iOS 9.3 和 Swift 2.2 已于 2016-04-03 更新。

在 iOS 系统中，状态恢复机制是一个经常被忽略的特性，当用户再次打开 app 的时候，它能够精确的恢复到退出之前的状态 - 而不用关心发生了什么。

某些时候，操作系统可能需要从内存中删除你的应用；这可能会严重中断用户的工作流。你的用户再也不必担心因为切换到另一个应用而影响到工作的事情了。这就是状态恢复机制所起到的作用。

在这篇恢复教程中，你将更新现有应用以添加保留和恢复功能，并在其工作流可能被中断的情况下提升用户体验。

## 入门

下载本教程的 [入门项目](https://koenig-media.raywenderlich.com/uploads/2016/01/PetFinder-Starter.zip)。该应用名为「**Pet Finder**」；对于那些碰巧在寻找毛茸茸猫科动物陪伴的人来说，这是一款方便的应用。

运行该应用；你将会看到一张关于猫的图片，这代表你有机会可以领养它：

[![Pet Finder](https://koenig-media.raywenderlich.com/uploads/2015/11/petfinder_intro_1-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/11/petfinder_intro_1.png)

向右滑动即可与新的毛茸茸的朋友配对；向左滑动表示你想要继续传递这个绒毛球小猫。你可以从**匹配**选项卡栏中查看当前所有的匹配列表：

[![Matches](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_matches_1-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_matches_1.png)

点击来查看所选中朋友的更多详细信息：

[![Details](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1-282x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1.png)

你甚至可以编辑你新朋友的名字（或年龄，如果你是在扭曲事实）：

[![Edit](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2.png)

你希望当你离开该应用然后返回时，你会被带回到上一次查看的同一个毛茸茸朋友。但真的是这样吗？要知道答案的唯一方法就是测试它。

## 状态恢复测试

运行应用，向右滑动至少一只猫，查看你的匹配项，然后选择一只猫并查看他或她的详细信息。按组合键 **Cmd + Shift + H** 返回主页面。如果存在任何逻辑上的状态，它都会被保存并且都将在此时运行。

接下来，通过 Xcode 停止应用：

[![Stop App](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_stop_app-480x41.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_stop_app.png)

当用户手动杀死应用或状态恢复失败时，状态恢复框架将丢弃任何状态信息。之所以存在这些检查，以避免你的应用不会陷入无线循环的错误状态以及恢复崩溃。谢谢，Apple！:\]

**注意**：你**无法**通过应用切换器自行终止应用，否则状态恢复将无法正常工作。

再次启动应用；你将回到主屏幕，而不是宠物详情视图。看起来你需要自己添加一些状态恢复逻辑。

## 实现状态恢复

设置状态恢复的第一步是在你的应用代理中启用它，打开 **AppDelegate.swift** 并添加以下代码：

```swift
func application(application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
  return true
}

func application(application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
  return true
}
```

应用代理中有五个方法来管理状态恢复。返回 `true` 的 `application(_:shouldSaveApplicationState:)`，告诉系统保存 view 的状态，并在应用处于后台运行状态时查看 view controller。返回 `true` 的 `application(_:shouldRestoreApplicationState:)`，告诉系统在应用重新启动时尝试恢复原始状态。

你可以在某些情况下让这些代理方法返回 `false`，例如在测试时或用户运行的应用的旧版本无法恢复时。

构建并运行你的应用，然后导航到猫的详情页。按住组合键 **Cmd + Shift + H** 让你的应用进入后台，然后通过 Xcode 停止应用。你将看到以下内容：

[![Pet Finder](https://koenig-media.raywenderlich.com/uploads/2015/11/petfinder_intro_1-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/11/petfinder_intro_1.png)

[![confused](https://koenig-media.raywenderlich.com/uploads/2015/10/confused-365x320.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/confused.png)

与你之前看到的完全相同！只选择进行状态恢复还不够。虽然你已在应用中启用了保存和恢复，但 view controller 尚未参与。要解决这个问题，你需要为每个场景提供一个**恢复标识符**。

## 设置恢复标识符

恢复标识符只是一个 view 和 view controller 的字符串属性，UIKit 使用它来将这些对象恢复到之前的状态。它存在一个 UIKit 与你希望保留的对象通讯的值。只要这些属性的值是唯一的，它们的实际内容并不重要。

打开 **Main.storyboard**，你将看到一个 tab bar controller、一个 navigation controller 和三个自定义 view controller：

[![cinder_storyboard](https://koenig-media.raywenderlich.com/uploads/2015/10/cinder_storyboard-700x350.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/cinder_storyboard.png)

恢复标识符可以在代码中或在 Interface Builder 中设置。简单起见，在本教程中你将在 Interface Builder 中进行设置。你**可以**进入并为每一个 view controller 设置一个唯一的名称，但 Interface Builder 有一个 **Use Storyboard ID** 的快捷选项，它允许你将 Storyboard ID 用于恢复标识符。

在 **Main.storyboard** 中，单击 tab bar controller 并打开 Identity Inspector。启用 **Use Storyboard ID** 选项，如下所示：

[![Use Storyboard ID](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_enable_restoration_id-480x320.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_enable_restoration_id.png)

这样会把 view controller 行存档记录，并且在状态恢复过程中进行还原。

对 navigation controller 和其它三个 view controller 重复此过程。确保你已经为每个 view controller 选中了 Use Storyboard ID。否则你的应用可能无法正常恢复其状态。

请注意，所有 controller 都已经具有 **Storyboard ID**，并且该复选框仅使用已作为 **Storyboard ID** 的相同字符串。如果你未使用 **Storyboard ID**，你需要手动输入一个唯一的 **Storyboard ID**。

恢复标识符汇集在一起，通过应用中任何 view controller 的唯一路径形成**恢复路径**；它与 API 中的 URI 类似，其中唯一路径标识每个资源的唯一路径。

比如，以下路径代表 **MatchedPetsCollectionViewController**：

**RootTabBarController/NavigationController/MatchedPetsCollectionViewController**

通过这些设置，应用将记住你停止使用时的 view controller（大多数情况下），并且任何 UIKit view 都将保留其先前的状态。

构建并运行你的应用；返回宠物详情页测试恢复流程。暂停和恢复应用后，你应该看到以下内容：

[![No Data](https://koenig-media.raywenderlich.com/uploads/2015/10/restoredNoData1-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/restoredNoData1.png)

虽然系统恢复了正确的 view controller，但它似乎缺少填充 view 所需的猫对象。如何恢复 view controller 及其所需的对象呢？

## UIStateRestoring 协议

在实现状态恢复方面，UIKit 为你做了很多工作，但是你的应用需要负责自行处理一些事情：

1.  告诉 UIKit 它想参与状态恢复，就是你在应用代理中所做的那些。
2.  告诉 UIKit 应该保留和恢复哪些 view controller 和 view。你通过为 view controller 分配恢复标识符来解决此问题。
3.  编码和解码任何需要重建 view controller 之前状态的相关数据。你还没有这样做，但这是 `UIStateRestoring` 协议需要解决的问题。

每个具有恢复标识符的 view controller 都将在保存应用时接收 `UIStateRestoring` 协议对 `encodeRestorableStateWithCoder(_:)` 的调用。另外，view controller 将在应用恢复时接收 `decodeRestorableStateWithCoder(_:)` 的调用。

要完成恢复流程，你需要添加对 view controller 进行编码和解码的逻辑。虽然该过程可能是最耗时的，但概念相对简单。你通常会编写一个扩展来增加协议的一致性，但是 UIKit 会自动关注册 view controller 以符合 `UIStateRestoring` - 你只需要覆盖适当的方法。

打开 **PetDetailsViewController.swift**，并在类的末尾添加以下代码：

```swift
override func encodeRestorableStateWithCoder(coder: NSCoder) {
  //1
  if let petId = petId {
    coder.encodeInteger(petId, forKey: "petId")
  }

  //2
  super.encodeRestorableStateWithCoder(coder)
}
```

以下是上述代码要做的事：

1.  如果当前猫对象存在 ID，使用提供的编码器进行保存以便稍后检索。
2.  确保调用 `super` 以便继承的状态恢复功能的其它部分能够按照预期发生。

通过少量的修改，现在你的应用可以保存当前猫的信息。但请注意，你实际上并未保存猫的模型对象，而是稍后可用于获取猫对象的 ID，当你保存通过 `MatchedPetsCollectionViewController` 选择的猫时，可以使用相同的概念。

Apple 非常清楚，状态恢复**仅**用于存档创建 view 层次结构所需并将应用恢复到其原始状态的信息。每当应用进入后台时，使用提供的编码器来保存和恢复简单模型数据是很诱人的，但是只要状态恢复失败或用户杀死应用，iOS 将会丢弃所有存档数据。由于你的用户每次重新启动应用时都不会非常乐意回到起始页，所以最好遵循 Apple 的建议并仅使用此策略保存状态恢复。

现在你已经在 **PetDetailsViewController.swift** 中实现了编码，你可以在下面添加相应的解码方法：

```swift
override func decodeRestorableStateWithCoder(coder: NSCoder) {
  petId = coder.decodeIntegerForKey("petId")

  super.decodeRestorableStateWithCoder(coder)
}
```

解密 ID 并将其设置回 view controller 的 `petId` 属性。

一旦解码了 view controller 的对象，该 `UIStateRestoring` 协议就会提供 `applicationFinishedRestoringState()` 的其他配置步骤。

在 **PetDetailsViewController.swift** 中添加以下代码：

```swift
override func applicationFinishedRestoringState() {
  guard let petId = petId else { return }
  currentPet = MatchedPetsManager.sharedManager.petForId(petId)
}
```

上面是基于解码后的宠物 ID 设置当前宠物，并完成 view controller 的恢复。当然，你可以在 `decodeRestorableStateWithCoder(_:)` 执行此操作，但最好保持逻辑分离，因为当它们全部捆绑在一起时它将变得笨拙。

构建并运行你的应用；导航到宠物的详情页并让应用置于后台，然后通过 Xcode 杀死该应用以触发保存序列。重启应用并验证你的毛茸茸玩具是否按预期显示：

[![Details](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1-282x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1.png)

你已经学习了如何恢复通过 storyboard 创建的 view controller。但你在代码中创建的 view controller 应该如何处理呢？要在运行时恢复基于 storyboard 创建的 view controller，UIKit 要做的是在 main storyboard 中找到它们。幸运的是，恢复基于代码创建的 view controller 几乎一样容易。

## 恢复基于代码创建的 view controller

视图控制器 `PetEditViewController` 完全由代码创建；它用于编辑猫的名字和年龄。你将使用它来学习如何恢复基于代码创建的 view controller。

构建并运行你的应用；导航到猫的详情页，然后点击编辑。修改猫的名字，但不保存你的更改，如下所示：

[![Edit](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2.png)

现在将应用置于后台并通过 Xcode 杀死它以触发保存序列。重启应用，iOS 将返回宠详情页而不是编辑页：

[![Details](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1-282x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_details_1.png)

正如你在 Interface Builder 中构建的 view controller 所做的那样，你需要为 view controller 提供恢复 ID，并添加 `UIStateRestoring` 协议中的编码和解码方法以便正确恢复状态。

查看 **PetEditViewController.swift**；你会注意到编码和解码的方法已经存在。逻辑类似于你在上一节中实现的编码和解码方法，但它还具有一些额外的属性。

手动分配恢复标识符是一个简单的过程。在 `viewDidLoad()` 中调用 `super` 后立即添加以下内容：

```swift
restorationIdentifier = "PetEditViewController"
```

这会为 `restorationIdentifier` 视图控制器分配唯一 ID。

在状态恢复过程中，UIKit 需要知道从何处获得 view controller 引用。在你设置 `restorationIdentifier` 的下面添加以下代码：

```swift
restorationClass = PetEditViewController.self
```

这将设置 `PetEditViewController` 为负责实例化 view controller 的恢复类。恢复类必须采用 UIViewControllerRestoration 协议并实现所需的恢复方法。为此，将以下扩展代码添加到 **PetEditViewController.swift** 的末尾：

```swift
extension PetEditViewController: UIViewControllerRestoration {
  static func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject],
      coder: NSCoder) -> UIViewController? {
    let vc = PetEditViewController()
    return vc
  }
}
```

这实现了返回类实例所需的 `UIViewControllerRestoration` 协议方法。现在 UIKit 有了它正在寻找的对象的副本，iOS 可以调用编码和解码方法并恢复状态。

构建并运行你的应用；导航到猫的编辑页。像之前一样更改猫的名字，但不保存更改，然后将应用置于后台并通过 Xcode 将其删除。重启你的应用，并验证你所做的所有工作，为你的毛茸茸朋友提出一个伟大的独特名称并非都是徒劳的！

[![Edit](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2-281x500.png)](https://koenig-media.raywenderlich.com/uploads/2015/10/petfinder_edit_2.png)

## 接下来去哪儿？

你可以 [在此处现在已完成的项目](https://koenig-media.raywenderlich.com/uploads/2016/01/PetFinder-Completed-1.zip)。状态恢复框架是任何 iOS 开发人员工具包中非常有用的工具；你现在可以将基本恢复代码添加到任何应用，并以此提高你的用户体验。

有关使用该框架可能实现的更多信息，请查看 [2012 年](https://developer.apple.com/videos/play/wwdc2012-208/) 和 [2013 年](https://developer.apple.com/videos/play/wwdc2013-222/)的 WWDC 视频。2013年的演示文稿特别有用，因为它涵盖了 iOS 7 中引入的恢复概念，比如用于保存和恢复任意对象的 `UIObjectRestoration` 和在需求更复杂的应用中恢复表和集合视图的 `UIDataSourceModelAssociation`。

如果你对本教程有任何疑问或建议，请加入以下论坛讨论！

* [其他核心 API](https://www.raywenderlich.com/library?domain_ids%5B%5D=1&category_ids%5B%5D=152&sort_order=released_at)
* [iOS 和 Swift 手册](https://www.raywenderlich.com/library?domain_ids%5B%5D=1&sort_order=released_at)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
