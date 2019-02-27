> * 原文地址：[iOS Performance Tricks To Make Your App Feel More Performant](https://www.smashingmagazine.com/2019/02/ios-performance-tricks-apps/)
> * 原文作者：[Axel](https://www.smashingmagazine.com/author/axel-kee)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/ios-performance-tricks-apps.md](https://github.com/xitu/gold-miner/blob/master/TODO1/ios-performance-tricks-apps.md)
> * 译者：[LoneyIsError](https://github.com/LoneyIsError)
> * 校对者：[EdmondWang](https://github.com/EdmondWang)

# 用这些 iOS 技巧让你的 APP 性能更佳

简要概括：良好的性能对于提供良好的用户体验至关重要，iOS 用户通常对其应用程序抱有很高的期望。缓慢且无响应的应用可能会让用户放弃使用你的应用，或者更糟糕的是，对应用留下差评。

虽然现代 iOS 硬件功能十分强大，足以处理许多密集和复杂的任务，但是如果你不关心你的 APP 是怎么执行的话，用户的设备仍会出现无响应的情况。在本文中，我们将研究五种优化技巧，使你的 APP 更流畅。

### 1. 使用可复用的 `tableViewCell`

> 译者注：本例阐述的是使用可复用的 `tableViewCell`，所以将所有 `cell` 翻译成 `tableViewCell`，table view 直译成表视图

你之前可能在 `tableView(_:cellForRowAt:)` 中使用了 `tableView.dequeueReusableCell(withIdentifier:for:)`。但你有没有想过为什么必须使用这个笨拙的 API，而不是只传递一个 `TableViewCell` 的数组？让我们来看看为什么。

假设你有一个有一千行的表视图。如果不使用可复用的 `tableViewCell`，我们必须为每一行创建一个新的 `tableViewCell`，如下所示：

```
func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   // Create a new cell whenever cellForRowAt is called.
   let cell = UITableViewCell()
   cell.textLabel?.text = "Cell \(indexPath.row)"
   return cell
}
```

你可能已经想到，当你滚动到底部时，这将为设备的内存添加一千个 `tableViewCell`。想象一下如果每个 `tableViewCell` 都包含一个 `UIImageView` 和大量文本会发生什么：一次性加载它们可能会导致应用内存溢出！除此之外，每个 `tableViewCell` 在滚动期间都需要分配新内存。如果你快速滚动表视图，期间会动态分配许多小块内存，这个过程将使 UI 变得卡顿！

为了解决这个问题，Apple 为我们提供了 `dequeueReusableCell(withIdentifier:for:)` 方法。通过将屏幕上不再可见的 `tableViewCell` 放入队列中进行复用，并且当新 `tableViewCell` 即将在屏幕上可见时（例如，当用户向下滚动时，下面的后续 `tableViewCell`），表视图将从此队列中检索 `tableViewCell` 并在 `cellForRowAt indexPath:` 方法中修改它。

[![Cell reuse queue mechanism](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ba882cd5-8212-4b68-8ad0-cdbf9e26aeb3/ios-performance-tricks-1-dequeue.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ba882cd5-8212-4b68-8ad0-cdbf9e26aeb3/ios-performance-tricks-1-dequeue.png)

iOS 中 `tableViewCell` 复用队列图解（[查看大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/ba882cd5-8212-4b68-8ad0-cdbf9e26aeb3/ios-performance-tricks-1-dequeue.png)）

通过使用队列来存储 `tableViewCell`，表视图中不需要创建一千个 `tableViewCell`。反而，它只需要创建足够覆盖表视图区域的 `tableViewCell` 就够了。

通过使用 `dequeueReusableCell` 方法，我们可以减少应用程序使用的内存，并减少内存溢出的可能性！

### 2. 使用看起来像应用首页的启动页

正如 Apple [人机界面指南](https://developer.apple.com/design/human-interface-guidelines/ios/icons-and-images/launch-screen/)（HIG）里提到的，启动屏幕可用于增强对应用程序响应能力的感知：

> 「它仅用于增强你的应用程序的感知，以便快速启动并立即使用。每个应用程序都必须提供启动页。」

将启动页用作启动画面以显示品牌或添加加载动画是一个常见的错误。如 Apple 所述，应将启动页设计为与应用的第一个页面相同：

> 「设计一个与应用程序首页几乎相同的启动页。如果你的应用程序在完成启动后包含着与启动页看起来不同的元素，那么用户则可能会在启动页到应用程序的第一个页面的过程中感到令人不快的闪屏。」
>   
> 「启动页并不是一个做品牌推广的机会。避免将程序入口设计成类似启动页面或者“关于”页面的感觉。不要包含徽标或其他品牌元素，除非它们是应用程序第一个页面的静态部分。」

使用启动页进行加载或品牌化可能会减慢首次使用的时间，并使用户感觉应用程序运行缓慢。

当你新建 iOS 项目时，Xcode 会创建一个空白的 `LaunchScreen.storyboard` 供你使用。当应用程序加载视图控制器和布局时，将向用户显示此页面。

> 译者注：文段中没有 Xcode，下文中提及为 Xcode 新建项目。

为了让你的应用感觉更快，你可以将启动页设计为与将向用户显示的第一个页面（视图控制器）类似。

例如，Safari APP 的启动页与其第一个页面类似：

[![Launch screen and first view look similar](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5cf91d55-0418-45e0-8019-3be8f875086e/ios-performance-tricks-2-launchscreen.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5cf91d55-0418-45e0-8019-3be8f875086e/ios-performance-tricks-2-launchscreen.png)

比较：Safari APP的启动页和第一个页面（[查看大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5cf91d55-0418-45e0-8019-3be8f875086e/ios-performance-tricks-2-launchscreen.png)）

启动页的 `storyboard` 与任何其他 `storyboard` 文件一样，除了您只能使用标准的 `UIKit` 类，如 `UIViewController`、`UITabBarController` 和 `UINavigationController`。如果你尝试使用任何其他自定义子类（例如 `UserViewController`），Xcode 将提示你禁止使用自定义类名。

[![Xcode shows error when a custom class is used](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/526ff784-be5f-4f25-8e04-ce81ef038088/ios-performance-tricks-3.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/04546e45-0976-4fbd-b776-5d720b982bb4/ios-performance-tricks-3-illegal.png)

启动页 `storyboard` 不能包含非 `UIKit` 标准类。（[查看大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/04546e45-0976-4fbd-b776-5d720b982bb4/ios-performance-tricks-3-illegal.png)）

另外需要注意的是，当 `UIActivityIndicatorView` 放置在启动页上时，不会生成动画，因为 iOS 只会将启动页 `storyboard` 生成静态图像并将其展示给用户。（这在 WWDC 2014 “[Platforms State of the Union](https://developer.apple.com/videos/play/wwdc2014/102/)” 演示中简要提到，大概在 `01:21:56`。）

Apple 的人机界面指南还建议我们不要在启动页上包含文本，因为启动页是静态的，应用程序不能将文本本地化以适应不同的语言。

**推荐阅读：[具有面部识别功能的移动应用程序：如何实现](https://www.smashingmagazine.com/2018/02/mobile-app-facial-recognition-feature/)**

### 3. 视图控制器的状态恢复

视图控制器的状态保存和恢复，允许用户在离开应用程序后可以返回到之前完全相同的用户界面状态。有时，由于内存不足，操作系统可能需要在应用程序处于后台时从内存中删除应用程序，如果不保留状态，应用程序可能会丢失其对最后一个UI状态的跟踪，可能会导致用户丢失正在进行的操作！

在多任务屏幕中，我们可以看到已放在后台的应用程序列表。我们可以假设这些应用程序仍在后台运行；实际上，由于内存的需求，一些应用程序可能会被系统杀死并重新启动。我们在多任务视图中看到的应用程序快照实际上是系统在退出应用程序时截取到的屏幕截图。（即转到主屏幕或多任务屏幕）。

[![iOS fabricates the illusion of apps running in the background by taking a screenshot of the most recent view](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2edd59aa-1195-40cd-8322-7f71a5e2e91b/ios-performance-tricks-4-multitask.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2edd59aa-1195-40cd-8322-7f71a5e2e91b/ios-performance-tricks-4-multitask.png)

用户退出应用程序时 iOS 截取的应用程序截图（[查看大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/2edd59aa-1195-40cd-8322-7f71a5e2e91b/ios-performance-tricks-4-multitask.png)）

iOS 使用这些屏幕截图来给人一种假象，即应用程序仍在运行或仍在显示此特定视图，而应用程序可能已被后台终止或重新启动，但此时仍显示相同的屏幕截图。

您是否曾体验过，从多任务屏幕恢复应用程序后，该应用程序显示的用户界面与多任务视图中显示的快照有什么不一样？ 这是因为应用程序没有实现状态恢复机制，当应用程序在后台被杀死时，显示的数据丢失。这可能会导致糟糕的体验，因为用户希望你的应用程序与离开时处于相同的状态。

在 Apple 的 [保留你应用程序的 UI](https://developer.apple.com/documentation/uikit/view_controllers/preserving_your_app_s_ui_across_launches?language=objc) 文章中提及：

> 「用户希望你的应用程序与他们离开时处于同一状态。状态保存和恢复可确保应用程序在再次启动时恢复到以前的状态。」

`UIKit` 为简化状态保护和恢复做了很多工作：它可以在适当的时间自动处理应用程序状态的保存和加载。我们需要做的就是添加一些配置来告诉应用程序支持状态保存和恢复，以及告诉应用程序需要保存哪些数据。

为了实现状态保存和恢复，我们可以在 `AppDelegate.swift` 中实现下面两个方法：

```
func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
   return true
}
```

```
func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
   return true
}
```

这将告诉应用程序自动保存和恢复应用程序的状态。

接下来，我们将告诉应用程序需要保留哪些视图控制器。我们通过在 `storyboard` 中指定 `restoration ID` 来实现这一点：

[![Setting restoration ID in storyboard](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/0eb257d5-cd70-4a0b-9565-3782999b9926/ios-performance-tricks-5-restorationid.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/0eb257d5-cd70-4a0b-9565-3782999b9926/ios-performance-tricks-5-restorationid.png) 

在 `storyboard` 中设置 `restoration ID`（[查看大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/0eb257d5-cd70-4a0b-9565-3782999b9926/ios-performance-tricks-5-restorationid.png)）

你也可以选中 `Use Storyboard ID` 以使用 `storyboard ID` 作为 `restoration ID`。

如果要在代码中设置 `restoration ID`，我们可以使用视图控制器的 `restorationIdentifier` 属性。

```
// ViewController.swift
self.restorationIdentifier = "MainVC"
```

在状态保留期间，所有被分配了恢复标识符的视图控制器或视图都会将其状态保存到磁盘。

可以将恢复标识符组合在一起以形成恢复路径。标识符是通过视图层次结构来分组的，从根视图控制器到当前活动视图控制器。假设 `MyViewController` 嵌入在 `navigation` 控制器中，`navigation` 控制器嵌入在另一个 `tabbar` 控制器中。假设他们使用自己的类名作为恢复标识符，恢复路径将如下所示：

```
TabBarController/NavigationController/MyViewController
```

当用户将 `MyViewController` 作为活动视图控制器并离开应用程序时，该路径将会被应用程序保存; 那么应用程序将记住以前的视图层次结构即（*Tab Bar Controller → Navigation Controller → My View Controller*）。

在分配了恢复标识符之后，我们需要在每个保留的视图控制器里实现 `encodeRestorableState(with coder:)` 和 `decodeRestorableState(with coder:)` 方法。这两种方法让我们指定需要保存或加载的数据以及如何对它们进行编码或解码。

我们来看看视图控制器里如何实现：

```
// MyViewController.swift

// MARK: State restoration
// UIViewController already conforms to UIStateRestoring protocol by default
extension MyViewController {

   // will be called during state preservation
   override func encodeRestorableState(with coder: NSCoder) {
       // encode the data you want to save during state preservation
       coder.encode(self.username, forKey: "username")
       super.encodeRestorableState(with: coder)
   }
   
   // will be called during state restoration
   override func decodeRestorableState(with coder: NSCoder) {
     // decode the data saved and load it during state restoration
     if let restoredUsername = coder.decodeObject(forKey: "username") as? String {
       self.username = restoredUsername
     }
     super.decodeRestorableState(with: coder)
   }
} 
```

记得在自己的方法底部调用父类实现。这样可确保父类有机会保存和恢复状态。

一旦指定保存的对象解码完成，`applicationFinishedRestoringState()` 将被调用以告诉视图控制器状态已被恢复。我们可以在此方法中更新视图控制器的 UI。

```
// MyViewController.swift

// MARK: State restoration
// UIViewController already conforms to UIStateRestoring protocol by default
extension MyViewController {
   ...
 
   override func applicationFinishedRestoringState() {
     // update the UI here
     self.usernameLabel.text = self.username
   }
}
```

这些，就是为你的应用程序实现状态保存和恢复的基本方法了！请记住，当应用程序被用户强行关闭时，操作系统将删除已保存的状态，避免在状态保存和恢复时出现问题。

此外，请勿将任何模型数据（即应保存到 UserDefaults 或 Core Data 的数据）存储到该状态,即使这样做似乎很方便。当用户强制退出你的应用程序时，状态数据将被删除，你当然不希望以这种方式丢失模型数据。

要测试状态保存和恢复是否正常，请按照以下步骤操作：

1. 使用Xcode构建和启动应用程序。
2. 跳转到要测试状态保留和恢复的页面。
3. 返回主屏幕（通过向上滑动或双击 `home` 按钮，或者在用模拟器时键入 `Shift ⇧` + `Cmd ⌘` + `H`）将应用程序发送到后台。
4. 通过在Xcode中点击 ⏹ 按钮，停止程序运行。
5. 再次启动应用程序并检查状态是否已成功还原。

由于本节仅涵盖了状态保存和恢复的基础知识，因此我推荐 Apple Inc. 上的以下文章。了解更多有关状态恢复的知识：

1. [状态的保存和恢复](https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/PreservingandRestoringState.html)
2. [UI 保存过程](https://developer.apple.com/documentation/uikit/view_controllers/preserving_your_app_s_ui_across_launches/about_the_ui_preservation_process)
3. [UI 恢复过程](https://developer.apple.com/documentation/uikit/view_controllers/preserving_your_app_s_ui_across_launches/about_the_ui_restoration_process)

### 4. 尽可能减少透明视图的使用

不透明视图是指没有透明度的视图，意味着放在它后面的任何 UI 元素不可见。我们可以在 Interface Builder 中将视图设置为不透明：

[![This will inform the drawing system to skip drawing whatever is behind this view](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/0402cef9-9dc9-4d61-b394-21de713e039b/ios-performance-tricks-6.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5af9b5bc-8786-41d9-88ab-2342f69c2b88/ios-performance-tricks-6-opaque.png)

在 storyboard 中将 UIView 设置为不透明（[查看大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/5af9b5bc-8786-41d9-88ab-2342f69c2b88/ios-performance-tricks-6-opaque.png)）

或者我们可以在代码中修改 UIView 的 isOpaque 属性：

```
view.isOpaque = true
```

将视图设置为不透明将使绘图系统在渲染屏幕时优化一些绘图性能。

如果视图具有透明度（即 alpha 低于 1.0），那么 iOS 将需要做些额外的工作来混合视图层次结构中不同的视图层以计算出哪些内容需要展示。另一方面，如果视图设置为不透明，则绘图系统仅会将此视图放在前面，并避免在其后面混合多个视图层的额外工作。

您可以在 iOS 模拟器中通过 _Debug_ → _Color Blended Layers_ 来检查哪些（透明）图层正在混合。

[![Green is non-color blended, red is blended layer](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8b312287-e25e-4f1e-ad67-aea5aa91f2f3/ios-performance-tricks-7.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/d7c3eeb5-0d64-4b38-9f01-da23dd7d244e/ios-performance-tricks-7-colorblendedlayers.png)

在 Simulator 中显示各种图层的颜色

当选择 _Color Blended Layers_ 选项后，你可以看到一些视图是红色的，一些是绿色的。 红色表示视图不是不透明的，并且其显示的是在其后面混合的图层。绿色表示视图不透明且未进行混合。

[![With an opaque color background, the layer doesn’t need to blend with another layer](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7dfe406f-434b-4358-8458-7408ba61bcc4/ios-performance-tricks-9-greenish.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7dfe406f-434b-4358-8458-7408ba61bcc4/ios-performance-tricks-9-greenish.png)

尽可能为 UILabel 指定非透明背景颜色以减少颜色混合图层。（[查看大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/7dfe406f-434b-4358-8458-7408ba61bcc4/ios-performance-tricks-9-greenish.png)）

上面显示的所有 label（“查看朋友”等）被红色突出显示，是因为当 label 被拖动到 storyboard 时，其背景颜色默认设置为透明。当绘图系统在 label 区域附近的进行绘制时，它将询问 label 后面的图层并进行一些计算。

优化应用性能的方法是尽可能减少用红色突出显示的视图数量。

通过将 label 颜色从 `label.backgroundColor = UIColor.clear` 修改成 `label.backgroundColor = UIColor.white`，我们可以减少 label 和它后面的视图层之间的图层混合。

[![Using a transparent background color will cause layer blending](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/56fc5367-3cca-49f1-a5bd-a5fd15eb1cc0/ios-performance-tricks-8-redgreen.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/56fc5367-3cca-49f1-a5bd-a5fd15eb1cc0/ios-performance-tricks-8-redgreen.png)

许多 label 以红色突出显示，因为它们的背景颜色是透明的，导致 iOS 通过混合背后的视图来计算背景颜色。（[查看大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/56fc5367-3cca-49f1-a5bd-a5fd15eb1cc0/ios-performance-tricks-8-redgreen.png)）

你可能已经注意到，即使你已将 UIImageView 设置为不透明并为其指定了背景颜色，模拟器仍将在 imageView 上显示红色。这可能是因为你用于 imageView 的图像具有Alpha通道。

要删除图像的 Alpha 通道，可以使用预览应用程序复制图像（`Shift⇧` + `Cmd⌘`+ `S`），并在保存时取消选中 `Alpha` 复选框。

[![Uncheck the ‘Alpha’ checkbox when saving an image to discard the alpha channel.](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/13b72d22-093d-4957-b297-25c9b950ad4c/ios-performance-tricks-10-uncheck.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/13b72d22-093d-4957-b297-25c9b950ad4c/ios-performance-tricks-10-uncheck.png)

保存图像时，取消选中 `Alpha` 复选框以取消 Alpha 通道。（[查看大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/13b72d22-093d-4957-b297-25c9b950ad4c/ios-performance-tricks-10-uncheck.png)）

### 5. 在后台线程中处理繁重的功能（GCD）

因为 UIKit 仅适用于主线程，所以在主线程上执行繁重的处理工作会降低 UI 的速度。主线程使用 UIKit 不仅要处理和响应用户的交互，还需要绘制屏幕。
> 译者注：将touch input 翻译成交互，是因为点击和输入属于交互范畴。

使应用程序保持响应的关键是尽可能多的将繁重处理任务放到后台线程。应当尽量避免在主线程上执行复杂的计算，网络和繁重的IO操作（例如，磁盘的读取和写入）。

你可能曾经使用过突然对你的操作停止响应的应用程序，就好像应用程序已挂起。这很可能是因为应用程序在主线程上运行繁重的计算任务。

主线程中通常在 UIKit 任务（如处理用户输入）和一些间隔很小的轻量级任务之间交替。如果在主线程上运行繁重的任务，那么 UIKit 需要等到繁重的任务完成以后才能处理用户交互。

[![Avoid running performance-intensive or time-consuming task on the main thread](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8f319bf3-4849-4e94-9c1b-6666415f4f98/ios-performance-tricks-11-mainthread.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8f319bf3-4849-4e94-9c1b-6666415f4f98/ios-performance-tricks-11-mainthread.png)

这是主线程处理 UI 任务的方式以及在执行繁重任务时导致 UI 挂起的原因。（[查看大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/8f319bf3-4849-4e94-9c1b-6666415f4f98/ios-performance-tricks-11-mainthread.png)）

默认情况下，视图控制器生命周期方法（如 viewDidLoad）和 IBOutlet 相关方法是在主线程上执行。要将繁重的处理任务移到后台线程，我们可以使用 Apple 提供的 [Grand Central Dispatch](https://apple.github.io/swift-corelibs-libdispatch/) 队列。

以下是切换队列的例子：

```
// Switch to background thread to perform heavy task.
DispatchQueue.global(qos: .default).async {
   // Perform heavy task here.
 
   // Switch back to main thread to perform UI-related task.
   DispatchQueue.main.async {
       // Update UI.
   }
}
```

`qos` 代表着「quality of service」。不同的 QoS 值表示任务不同的优先级。对于在具有较高 QoS 值的队列中分配的任务，操作系统将分配更多的 CPU 时间、CPU 功率和 I/O 吞吐量，这意味着任务将在具有更高 QoS 值的队列中更快地完成。较高的 QoS 值也会因使用更多资源而消耗更多能量。

以下是从最高优先级到最低优先级的 QoS 值列表：

[![Quality-of-service values of queue sorted by performance and energy efficiency](https://res.cloudinary.com/indysigner/image/fetch/f_auto,q_auto/w_400/https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bbfaec6b-7e95-4d5e-a1d6-d5c96944d363/ios-performance-tricks-12-qos.png)](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bbfaec6b-7e95-4d5e-a1d6-d5c96944d363/ios-performance-tricks-12-qos.png)

按性能和能效排序的 QoS 值（[查看大图](https://cloud.netlifyusercontent.com/assets/344dbf88-fdf9-42bb-adb4-46f01eedd629/bbfaec6b-7e95-4d5e-a1d6-d5c96944d363/ios-performance-tricks-12-qos.png)）

Apple 提供了 [一个简单的表格](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/EnergyGuide-iOS/PrioritizeWorkWithQoS.html#//apple_ref/doc/uid/TP40015243-CH39-SW1) 其中包含用于不同任务的 QoS 值的示例。

需要记住，所有 UIKit 代码始终都应该在主线程上执行。在后台线程上修改 UIKit 对象（例如 `UILabel` 和 `UIImageView`）可能会产生意想不到的后果，例如UI实际上没有更新，发生崩溃等等。

在 Apple 的 [主线程检查器](https://developer.apple.com/documentation/code_diagnostics/main_thread_checker) 文章中提及：

> 「在主线程以外的线程上更新 UI 是一种常见错误，这可能导致 UI 不更新，视觉缺陷，数据损坏以及崩溃。」

我建议观看 Apple 的 WWDC 2012 视频上的 [UI 并发](https://developer.apple.com/videos/play/wwdc2012/211/)，以便更好地了解如何构建响应式应用。

#### 后记

性能优化需要你在应用程序的功能之上编写更多的代码或配置其他设置。这可能会使您的应用程序交付时间超出预期，并且您将来会有更多代码需要维护，而更多代码意味着更多潜在的 bug。

在花时间优化应用之前，先问问自己应用是否已经流畅，或者是否有一些真正需要优化的无响应的部分。花费大量时间优化已经很流畅的应用程序来减少 0.01 秒的耗时是不值得的，最好将这些时间花在开发更好的功能或优先级更高的任务。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
