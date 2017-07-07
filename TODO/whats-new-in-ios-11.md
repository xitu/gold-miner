> * 原文地址：[What's new in iOS 11 for developers](https://www.hackingwithswift.com/whats-new-in-ios-11)
> * 原文作者：[Paul Hudson](https://twitter.com/twostraws)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：       [Swants](https://swants.github.io)
> * 校对者：  [Danny1451](https://github.com/Danny1451)   [RichardLeeH](https://github.com/RichardLeeH)

# 开发者眼中 iOS 11 都更新了什么？

苹果在 2017 年全球开发者大会上公布了 iOS 11 , 其加入许多强大的功能，如 `Core ML`,`ARKit`,`Vision `,`PDFKit `,`MusicKit ` 拖放等等。 我尝试着把主要变化在接下来的文章里总结了出来，并在可行的地方提供代码，这样你就可以直接上手。

__注意：__ 有些地方没涉及到并不是因为懒，我已经尽我所能提供足够多的代码来帮你在应用上快速上手这些特性。但是你最终还是免不了去额外了解更多 iOS 11 中大量复杂的设计功能。

在接着读下去之前，你可能需要了解下这几篇文章：

- [What's new in Swift 4?](https://www.hackingwithswift.com/swift4)
- [What's new in Swift 3.1?](https://www.hackingwithswift.com/swift3-1)
- [What's new in iOS 10?](https://www.hackingwithswift.com/ios10)
- [What's new in iOS 9?](https://www.hackingwithswift.com/ios9)

__你可能想购买我的新书：《 Practical iOS 11 》。__ 你可以通过教程的形式获得 7 个完整的项目代码，以及更多深入了解特定新技术的技术项目 - 这是熟悉 iOS 11最快的方式！


[Buy Practical iOS 11 for $30](https://www.hackingwithswift.com/store/practical-ios11)

## 拖放

拖放是我们在桌面操作系统中认为理所当然的操作，但是拖放在 iOS 上直到 iOS 11 才出现，这真的阻碍了多任务处理的发展。换句话说，在 iOS 11 上尤其是在 iPad 上，多任务处理迎来了高速发展的时代。得益于拖放成为其中很大的一部分：你可以在 APP 内部和或 APP 之间移动内容，当你拖放的时候你可以用另一只手对其他 app 进行操作.你甚至可以利用 全新的 dock 系统来激活其他 app 的中间拖动。

__注意： 在 iPhone 上拖放被限制在单个 app 内 —— 你不能把内容拖放到其他 app 里。__

令人欣喜的是，`UITableView ` 和 `UICollectionView ` 在一定程度上都支持拖拽内置。但是想要使用拖放功能仍旧需要写相当多的代码。你也可以向其他组件添加拖放支持，而且你会发现实际上这只需要少量的工作。

下面让我们来看看如何使用简单的拖放来实现在两个列表之间拷贝行内容。首先，我们需要使用一个简单的 app 。让我们写一些代码来创建两个有示例数据的 `tableview` 供我们拷贝。

在 Xcode 内创建一个新的单一视图 app 模板，然后打开 `ViewController.swift` 类进行编辑。

现在我们需要在这里放上两个含有示例数据的 tableView 。我不打算使用 IB 的方式布局， 因为全部使用代码来实现是更清楚的。顺便提一下，我 __不打算__ 详细地解释代码，因为这都是现成的 iOS 代码，我不想浪费你的时间。

这些代码将：

- 创建两个 `tableView` ,并且创建两个分别包含`Left` 和 `Right` 元素的字符串数组。
- 制定两个 `tableView` 都使用 `view controller` 来作为它们的数据源，给他们写死位置宽高，注册一个可重用的 `cell` ，把它们两个都添加到这个 `view` 上。
- 实现 `numberOfRowsInSection` 方法，确保每个 table view 都根据其字符串数组有正确的行数。
- 实现 `cellForRowAt` 来排列，这时 cell根据 table 来从两个字符串数组中选出对应的数据源正确展示。

然后，这是 iOS 11 之前的所有代码，应该没有你不熟悉的代码。将 ViewController.swift 类的内容用下面的代码替换：

```
import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var leftTableView = UITableView()
    var rightTableView = UITableView()

    var leftItems = [String](repeating: "Left", count: 20)
    var rightItems = [String](repeating: "Right", count: 20)

    override func viewDidLoad() {
        super.viewDidLoad()

        leftTableView.dataSource = self
        rightTableView.dataSource = self

        leftTableView.frame = CGRect(x: 0, y: 40, width: 150, height: 400)
        rightTableView.frame = CGRect(x: 150, y: 40, width: 150, height: 400)

        leftTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        rightTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        view.addSubview(leftTableView)
        view.addSubview(rightTableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == leftTableView {
            return leftItems.count
        } else {
            return rightItems.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if tableView == leftTableView {
            cell.textLabel?.text = leftItems[indexPath.row]
        } else {
            cell.textLabel?.text = rightItems[indexPath.row]
        }

        return cell
    }
}
```

好：下面就是 __新__ 的内容了。如果你现在运行 app 你就会看到两个并列并且填满数据的 tableView 。我们现在想要做的就是让用户可以从一个 table 上选择一行并且复制到另一个 table 里，或者反方向操作。

第一步就是就是设置两个 tableView 的拖和放操作的代理为当前 view controller ，再把它们设置为可拖放。 最后把下面的代码加入到 `viewDidLoad()` 方法里：

```
leftTableView.dragDelegate = self
leftTableView.dropDelegate = self
rightTableView.dragDelegate = self
rightTableView.dropDelegate = self

leftTableView.dragInteractionEnabled = true
rightTableView.dragInteractionEnabled = true
```

当你做完这些后，Xcode 会抛出几个警告，因为我们当前的控制器类没有遵从 `UITableViewDragDelegate` 和 `UITableViewDropDelegate` 协议。通过给我们的类添加这两个协议很容易就修复这些警告了 —— 滚动到文件的最顶端并且改变类的定义：

```
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate {

```

但是这样又会产生新的问题：我说过我们应该遵从这两个新协议，但是我们没有实现协议必须实现的方法，在过去修复这个常常是很麻烦的，但是 Xcode 9 可以自动完成这几个协议必须实现的方法 —— 点击报红色高亮代码行上的数字 2，这时你将会看到出现了更多的详细解释。点击 "fix" 来让 Xcode 9 为我们插入两个缺少的方法 —— 你将会看到你的类里边出现了下面的代码：

```
func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    code
}

func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    code
}
```

Xcode 总是把新的方法插在你的类最上面，至少在这次初始的 beta 版本里是。如果你和我一样看这不顺眼 —— 在继续之前可以把它们移到更明智地方！

`itemsForBeginning` 方法是最简单的，让我们先从它开始。这个方法是在当用户的手指在 tableView 某行 cell 上按下执行拖的操作的时候调用。如果你返回一个空数组，你实际上就是拒绝了拖放操作。

我们打算为这个方法添加四行代码：

1. 指出哪一个字符串被拷贝，我们可以使用一个简单的三元操作符来实现：如果当前的 tableView 是在左边就从 `leftItems` 中读取，否则就从 `rightItems` 中读取。
2. 试着将这个字符串转换成一个 `Data` 对象， 以便可以通过拖放进行传递。
3. 将这个 data 放进一个 `NSItemProvider` 中，并且标记为存储了一个纯文本字符串从而其他 app 可以知道如何去处理它。
4. 最后， 把这个 `NSItemProvider` 放进一个 `UIDragItem`内，从而它可以用于 UIKit 的拖放。

为了把 data 元素标记为纯文本字符串 我们需要引入 MobileCoreServices 框架，所以请把下面的代码加入到 ViewController.swift 文件最上面：

```
import MobileCoreServices
```

现在用下面的代码替换你的 `itemsForBeginning` 方法：

```
func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let string = tableView == leftTableView ? leftItems[indexPath.row] : rightItems[indexPath.row]
    guard let data = string.data(using: .utf8) else { return [] }
    let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)

    return [UIDragItem(itemProvider: itemProvider)]
}
```

接下来我们只需要实现 `performDropWith` 方法。我说 “只需要”，但是剩下的两个潜在的复杂问题还是很棘手的。首先，如果有人拖放了很多东西我们就会同时获得很多字符串，我们需要把它们都正确插入。其次，我们可能被告知用户想要插入到哪几行，也可能不被告知 —— 用户可能只是把字符串拖放到 tableView 的空白处，这时需要我们决定该怎么处理。

要解决这两个问题需要写比你期望中的更多的代码，但我会带你一步一步编写代码，让它更容易些。

首先，是最简单的部分：找出行被拖放到哪里。 `performDropWith` 返回一个 `UITableViewDropCoordinator` 类对象，该对象有一个 `destinationIndexPath` 属性 可以告诉我们用户想把数据拖放到哪里。然而 这个方法是 __可选__ 实现：如果用户把他们的数据拖放到我们 tableView 的空单元格上，方法返回的将会是 nil 。如果这真的发生了我们会认为用户是想把数据拖放到 table 的最尾部。

所以，把下面的代码添加到 `performDropWith` 方法内继续吧：

```
let destinationIndexPath: IndexPath

if let indexPath = coordinator.destinationIndexPath {
    destinationIndexPath = indexPath
} else {
    let section = tableView.numberOfSections - 1
    let row = tableView.numberOfRows(inSection: section)
    destinationIndexPath = IndexPath(row: row, section: section)
}
```

正如你所看到的那样，如果 coordinator 的 `destinationIndexPath` 存在就直接用，如果不存在则创建一个最后一组最后一行的 `destinationIndexPath` 。

下一步就是让拖放的 coordinator 来加载拖动的所有特定类对象。在我们的例子里这个特定类是 `NSString` 。（然而，通常用 `String` 不起作用。）当所有拷贝的内容都就绪时我们需要发送一个闭包来运行，这也是最复杂的地方：我们需要把内容一个接一个地在目标行下面插入，修改 `leftItems` 或 `rightItems` 数组，最后调用我们 tableView 的 `insertRows()` 方法来展示拷贝后的结果。

那么，接下来：我们刚刚写了一些代码来指出拖放操作最终的目标行。但如果我们得到了 __多个__ 拷贝对象，那么我们所有的都是初始的 destination index path —— 第一个拷贝对象的目标行就是它，第二个拷贝对象的目标行比它低一行，第三个拷贝对象的目标行比它低两行，等等。当我们移动每个拷贝对象时，我们会创建一个新的 index path 并且把它暂存到一个 `indexPaths` 数组中，这样我们就可以让 tableView 只调用一次 `insertRows()` 方法就完成了全部插入操作 。

把代码添加到你的 `performDropWith` 方法中，放在我们刚才写的代码下面：

```
// attempt to load strings from the drop coordinator
coordinator.session.loadObjects(ofClass: NSString.self) { items in
    // convert the item provider array to a string array or bail out
    guard let strings = items as? [String] else { return }

    // create an empty array to track rows we've copied
    var indexPaths = [IndexPath]()

    // loop over all the strings we received
    for (index, string) in strings.enumerated() {
        // create an index path for this new row, moving it down depending on how many we've already inserted
        let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)

        // insert the copy into the correct array
        if tableView == self.leftTableView {
            self.leftItems.insert(string, at: indexPath.row)
        } else {
            self.rightItems.insert(string, at: indexPath.row)
        }

        // keep track of this new row
        indexPaths.append(indexPath)
    }

    // insert them all into the table view at once
    tableView.insertRows(at: indexPaths, with: .automatic)
}
```

这就是完成的所有代码了 —— 你现在能够运行这个 app 并且在两个 tableView 之间拖动行内容来完成拷贝。完成这个花费了这么多的工作量，但令人感到惊喜的是：你所做的这些工作你能够支持整个系统的拖放：譬如如果你试着用 iPad 模拟器的话，你就会发现你可以把这些文本拖放到 Apple News 内的任何一个列表上，或者把 tableView 上的文本拖放到 Safari 的搜索条上。非常酷！

在你试着去完成拖放操作之前，我想再展示一件事：如何实现为其他 View 添加拖放支持。其实比在 tableView 上实现要容易，那就让我们快速做一遍吧。

在开始之前，我们需要一个简单的控件来让我们有可以添加拖放的东西。这次我们打算创建一个 `UIImageView` 并且渲染一个简单的红色圆圈作为图片。你可以保留已存在的单视图 APP 模板 并把  ViewController.swift 的内容用新代码替换：

```
import UIKit

class ViewController: UIViewController {
    // create a property for our image view and define its size
    var imageView: UIImageView!
    let size = 512

    override func viewDidLoad() {
        super.viewDidLoad()

        // create and add the image view
        imageView = UIImageView(frame: CGRect(x: 50, y: 50, width: size, height: size))
        view.addSubview(imageView)

        // render a red circle at the same size, and use it in the image view
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        imageView.image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: size, height: size)
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.fillEllipse(in: rectangle)
        }
    }
}
```

像之前一样，这都是些 iOS 的老代码所以我不打算给你详细解释它。如果你试着在 iPad 模拟器上运行，你就会在控制器里看到一个大的红色圆圈 —— 这对供我们测试来说足够了。

自定义视图的拖放是通过一个新的叫作 `UIDragInteraction` 类来实现的。 你告诉它在哪里发送信息（在我们这个例子里，我们用的是当前的控制器），然后将它和用来交互的 View 绑定。

__重要提示：__ 千万不要忘了打开相关视图的交互，否则当拖放最后不起作用时，你会感到非常困惑。

首先， 在 `viewDidLoad()` 的最末尾添加这三行代码，就在之前的代码后面。你就会看到 Xcode 提示我们的 View Controller 没有遵循
`UIDragInteractionDelegate` 协议，所以把类的定义改成下面这样：

```
class ViewController: UIViewController, UIDragInteractionDelegate {
```

Xcode 将会继续提示我们没有实现 `UIDragInteractionDelegate` 协议的一个必要方法，所以重复之前我们所做的 —— 在出错行上单击错误提示，然后选择 "Fix" 来插入下面的代码：

```
func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
    code
}
```

这就像我们之前为我们的 tableView 实现的 `itemsForBeginning` 方法一样：当用户开始拖动我们的 imageView 的时候，我们需要返回我们想要分享的图像。

这些代码是非常好并且简单的：我们会使用 `guard` 来防止我们在 imageView 上拉取图片时出现问题，先用一个 `NSItemProvider` 包装 image，然后返回数据的时候再使用 `UIDragItem` 包装下。

将 `itemsForBeginning` 方法用下面的代码替换：

```
func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
    guard let image = imageView.image else { return [] }
    let provider = NSItemProvider(object: image)
    let item = UIDragItem(itemProvider: provider)
    return [item]
}
```

这就完成了！ 尝试使用 ipad 多任务处理功能来将图库放在屏幕的右端 —— 你能够通过拖放图片来将图片从你的 APP 拷贝到图库里。

## 增强现实

增强现实 (AR) 已经出现有一段时间了，但是苹果在 iOS 11 上做了一些可圈可点的事情：他们创造了一个卓越的实现就是让 AR 开发可以和现有的游戏开发技术无缝集成。这就意味着你不需要做太多的工作就能把你 SpriteKit 或 SceneKit 技能和 AR 集成起来，这是个非常诱人的前景。

Xcode 自带了一个非常棒可以立即使用的 ARKit 模板，因此我鼓励你去尝试一下 —— 你会惊奇地发现实现它是多么的容易！

我想快速地演示下模板的使用，这样你就可以了解到这一切是如何融合在一起的。首先，使用虚拟现实模板创建一个新的 Xcode 工程，然后选择 SpriteKit 作为内容技术。是的，SpriteKit 是一个 2D 框架，但它仍能够在 ARKit 中用得很好，因为它可以像 3D 一样通过扭曲或旋转来展示你的精灵。

如果你打开了 Main.storyboard ，你会发现这个 ARKit 模板与普通的 SpriteKit 模板有所不同：它使用了一个新的 `ARSKView` 界面对象，将 ARKit 和 SpriteKit 两个世界融合在一起。这个对象通过一个 outlet 和 ViewController.swift 连接在一起，在这个控制器中的 viewWillAppear() 方法中构建 AR 追踪，并在 viewWillDisappear() 方法中暂停追踪。

但是，真正起作用的是在两个地方：Scene.swift 文件的 `touchesBegan()` 方法内，和 ViewController.swift 文件的 `nodeFor` 方法。 在通常的 SpriteKit 中你创建节点并把节点直接添加到你的场景中，但是使用 ARKit 后创建的是 __锚点__  —— 包含场景位置和标识符的占位，但它没有实际的内容。根据需要的时候使用 `nodeFor` 方法转换为 SpriteKit 节点。如果你曾使用过 `MKMapView` ，会发现这和 `MKMapView` 添加大头针和标注的方式是类似的 —— 标注是你的模型数据，大头针是 view。

在 Scene.swift 类的 `touchesBegan()` 方法你会看到从 ARKit 拉出当前帧的代码，先计算放入一个新敌人的位置。这是通过矩阵乘法实现：如果你创建一个单位矩阵（表示位置 X:0, Y:0, Z:0 的东西），再将它的 Z 坐标移回 0.2（相当于 0.2 米），你可以乘以当前场景相机位置来实现向用户指向的方向移动。

所以，当用户指向前方锚点就会被放在前方，如果他们指向上方，锚点就会放在上方。一旦锚点被放在那，它就会呆在那：ARKit 将会自动移动，旋转或扭曲来确保当用户的设备移动时与锚点始终正确对齐。

所有的操作可以用三行代码来实现：

```
var translation = matrix_identity_float4x4
translation.columns.3.z = -0.2
let transform = simd_mul(currentFrame.camera.transform, translation)
```

一旦计算出来转换，位移就会包装成一个锚点并添加到回话中，就像这样：

```
let anchor = ARAnchor(transform: transform)
sceneView.session.add(anchor: anchor)
```

最后会调用 ViewController.swift 类的 `nodeFor` 方法。之所以会调用是因为当前 ViewController 被设置成了 `ARSKView` 的代理，
当前 ViewController 就会在需要的时候负责把锚点转换成节点。你 __不需要__ 担心定位这些节点：记住，锚点已经放置到真实世界的具体坐标上了，ARKit 负责映射锚点的位置并转换成 SpriteKit 节点。

总之，`nodeFor` 方法很简单：

```
func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
    // Create and configure a node for the anchor added to the view's session.
    let labelNode = SKLabelNode(text: "Enemy")
    labelNode.horizontalAlignmentMode = .center
    labelNode.verticalAlignmentMode = .center
    return labelNode;
}
```

如果你想知道，ARKit 锚点有一个 `identifier` 属性可以让你知道创建了什么样的节点。在 Xcode 模板中所有的节点都是未知的。但是在你自己的工程中你几乎肯定会想把事物唯一标识出来。

就是这些！这么少的代码带来的结果是非常有效的 —— ARKit 注定是一个大的飞跃。

## 插播广告 

如果你喜欢这篇文章，你可能对我新写的 iOS 11 实践教程新书感兴趣。你将会实际开发基于 Core ML , PDFView , ARKit , 拖拽等更多新技术的工程。 —— __这是学习 iOS 11 最快的方式！__

![](https://www.hackingwithswift.com/img/book-ios11@2x.png)

[Buy Practical iOS 11 for $30](https://www.hackingwithswift.com/store/practical-ios11)


## PDF 渲染

自从 OS X 10.4 开始受益于几乎不需要提供任何代码就可以提供 PDF 渲染，操作，标注甚至更多的 PDFKit 框架后，macOS 就始终对 PDF 渲染有着一流的支持。

至于，到了 iOS 11 也可以在系统中使用 PDF 框架的全部功能了：你可以使用 `PDFView` 类来显示 PDF，让用户浏览文档，选择并且分享内容，放大缩小等等操作。或者，你可以使用独立的类比如： `PDFDocument` , `PDFPage` 和 `PDFAnnotation` 来创建你自己自定义的 PDF 阅读器。

和拖放一样，我们可以创建一个简单的 app 来演示 PDFKIT 是多么的简单。如果你愿意的话，你可以继续使用你刚才创建的单视图 app 工程，但你需要向工程中导入一个 PDF 文件来供 PDFKit 去读取。

你需要学习两个新的比较小的类来编写代码，第一个是 PDFView ，它负责所有的负责工作，包括 PDF 渲染，滚动和缩放手势响应，选择文本等。它也是 iOS 系统中常见的 UIView 子类，所以你可以不使用任何参数地创建 PDFView 实例对象，然后使用自动布局来约束它的位置来满足你的需求。第二个是新的类是 PDFDocument ，它可以通过一个 URL 来加载一个在其他地方可以被渲染或者操作 PDF 文档。

把 ViewController.swift 类的全部代码用这个代替：

```
import PDFKit
import UIKit

class ViewController: UIViewController {
    // store our PDFView in a property so we can manipulate it later
    var pdfView: PDFView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // create and add the PDF view
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        // make it take up the full screen
        pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        // load our example PDF and make it display immediately
        let url = Bundle.main.url(forResource: "your-pdf-name-here", withExtension: "pdf")!
        pdfView.document = PDFDocument(url: url)
    }
}
```

如果运行 app 你应该可以看到你可以使用连续的滚动机制垂直滚动页面。如果你在真机上测试，你也可以通过捏合操作进行缩放 —— 这时你就会发现 PDF 以更高的分辨率重新渲染。如果你想要更改 PDF 的布局样式，你可以试着去设置 `displayMode`, `displayDirection`, 和 `displaysAsBook` 属性。

例如，你可以将页面以双页的模式展现，而封面默认就是这样的：

```
pdfView.displayMode = .twoUpContinuous
pdfView.displaysAsBook = true
```

`PDFView` 提供了一系列有用的方法来让用户浏览和操作 PDF。为了试验，我们会在我们的控制器上添加一些导航栏按钮，因为这是添加交互最简单的方式。

总共三步，我们先添加一个 navigation controller， 这样我们就有了一个现成的导航栏来使用。所以，打开你的 Main.storyboard ，在大纲视图里选中 View Controller Scene 。再进入编辑菜单选择 Embed In > Navigation Controller 。

接下来，在 ViewController.swift 中的 `viewDidLoad()` 方法中添加以下代码：

```
let printSelectionBtn = UIBarButtonItem(title: "Selection", style: .plain, target: self, action: #selector(printSelection))
let firstPageBtn = UIBarButtonItem(title: "First", style: .plain, target: self, action: #selector(firstPage))
let lastPageBtn = UIBarButtonItem(title: "Last", style: .plain, target: self, action: #selector(lastPage))

navigationItem.rightBarButtonItems = [printSelectionBtn, firstPageBtn, lastPageBtn]
```

这些代码添加了三个按钮来实现一些基本的功能。最后，我们只需要写这三个按钮的响应方法就好了，那么把下面这些方法添加到 `ViewController` 类中：

```
func printSelection() {
    print(pdfView.currentSelection ?? "No selection")
}

func firstPage() {
    pdfView.goToFirstPage(nil)
}

func lastPage() {
    pdfView.goToLastPage(nil)
}
```

现在，如果是在 Swift 3 下，我们可以这么做。但是到了 Swift 4 你将会看到报 "Argument of '#selector' refers to instance method 'firstPage()' that is not exposed to Objective-C" 错误。换句话说就是 Swift 的方法对 Objective-C 不可见的，而 `UIBarButtonItem` 是 Objective-C 代码实现。

当然在每个方法之前加上 @objc 是个有效的办法，我猜大部分人可能就耸耸肩（我有什么办法，我也很绝望啊），然后在类之前加上一个 @objcMembers 的定义 —— 这会像之前 Swift 3 那样自动将类的所有东西都暴露给 Objective-C 。所以，把类的定义修改成这样：

```
@objcMembers
class ViewController: UIViewController {
```

现在这就正确地编译了，现在你将会看到跳转到首页和末页的功能可以直接使用了。至于选择按钮，你只需要在点击按钮之前在 PDF 之前选择一些文本 —— 就像在 iBooks 进行文本选择操作那样。

## 开始支持 NFC 读取

iPhone 7 引入了针对 NFC 的硬件支持，至于 iOS 11，NFC 开始支持让我们在自己的 APP 内使用：你现在可以编写代码来检测附近的 NFC NDEF 标签，而且出乎意料地简单 —— 至少在 __代码层面__ 。然而在我们看代码之前，你需要绕过一些坑，所有的我都希望在正式版消失。

**Step 1:** 在 Xcode 里创建一个新的 单视图 APP 模板。

**Step 2:** 去 iTunes 配置网站 [https://developer.apple.com/account](https://developer.apple.com/account/)  为你的 APP 创建一个 包含 NFC 标签读取的 APP ID。

**Step 3:** 为这个 APP ID 创建一个描述文件，并将其安装到 Xcode 中。取消 "Automatically manage signing" 选项卡，并且选择你刚才安装的描述文件。你可以点击描述文件旁边的小 “i” 按钮来在权限列表里查看 "com.apple.developer.nfc.readersession.formats"。

**Step 4:** 使用 快捷键 Cmd+N 为工程添加一个新的文件，先选择属性列表。把它命名为 "Entitlements.entitlements" ，并且确保 "Group" 旁边有一个蓝色的图标。

**Step 5:** 打开 Entitlements.entitlements 进行编辑，右击空白处选择 "Add Row"。键值为 "com.apple.developer.nfc.readersession.formats" 并把它的类型改为数组。点击 "com.apple.developer.nfc.readersession.formats" 左侧的指示箭头，再点击右边的 + 标记。这时应该会插入一个带有空值的 "Item 0" 键 —— 把它的值改为 "NDEF"。  

**Step 6:** 定位到你的 target 的 build settings 找到 Code Signing Entitlements 。在文本框里填入 "Entitlements.entitlements" 。

**Step 7:** 打开你的 Info.plist 文件，再右击空白处选择 "Add Row" 。添加键为 "Privacy - NFC Scan Usage Description" ，值为 "SwiftyNFC" 。

是的，就是一团糟。我不知道为什么——能够扫描 NFC 几乎没有比访问某人的健康记录更私密，而且更容易做到。在你思考恶意应用会不会暗地里扫描 NFC 之前，还是省省吧：就像刚才看到的那样，这是根本不可能做到的。

在混乱的设置之后，很高兴地告诉你使 NFC 工作的代码几乎是微不足道的：创建一个属性来存储一个代表当前 NFC 扫描会话的 `NFCNDEFReaderSession` 对象，再创建这个对象并要求它开始扫描。

当你创建读取会话时，你需要给它提供三条数据：它能够发送信息的代理，它应该用于发送这些消息的队列和当它扫描到一个 NFC 标签的时候是否结束扫描。我们会用  `self` 作为代理，`DispatchQueue.main` 作为队列，将值设置为 false 当扫描到一个标签后不停止扫描，所以它会继续扫描直到60秒结束。

打开 ViewController.swift，导入 `CoreNFC`，再把这个属性添加到 `ViewController` 类：

```
var session: NFCNDEFReaderSession!
```

接下来,在 `viewDidLoad()` 方法中添加这两行代码：

```
session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
session.begin()
```

`ViewController` 现在还没有正确地遵循 `NFCNDEFReaderSessionDelegate` 协议，你需要修改你的类定义来包含它：

```
class ViewController: UIViewController, NFCNDEFReaderSessionDelegate {
```

按照惯例，Xcode 将会报你缺失一些必要方法的错，所以使用它建议的修复来插入下面这两个方法：

```
func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    code
}

func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    code
}
```

两个方法都是特别简单的，但是错误的处理也非常简单——我们只是把错误打印到 Xcode 的控制台。在 `didInvalidateWithError` 方法内像这样添加内容：

```
func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
    print(error.localizedDescription)
}
```

现在对于 `didDetectNDEFs` 方法。当它被调用的时候你会得到一个检测到的消息的数组，数组每一个元素都可以包含描述单个数据的一个或更多记录。例如，你可能会看到 NFC 被用作启动 Google Cardboard app: Cardboard 设备有一个简单的包含绝对 URL "cardboard://V1.0.0" 的 NFC 标签，当设备检测到标签后会唤起 APP 显示。

用 NFC 数据的处理就是你需要做的事了，我们只是把他打印出来了，把你的 `didDetectNDEFs` 修改成这样：

```
func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    for message in messages {
        for record in message.records {
            if let string = String(data: record.payload, encoding: .ascii) {
                print(string)
            }
        }
    }
}
```

所有的代码就完成了，那么继续开始运行这个 app 吧！如果所有的部分都起作用了，你将立即看到系统用户界面出现提示用户将其设备靠近要扫描的位置。这就是为什么恶意应用程序滥用 NFC 扫描是不可能的 - 不仅我们无法控制用户界面，而且 60 秒后扫描也会因为超时结束以避免浪费电量。

## 机器学习和视觉识别

机器学习是现在最时髦的流行语，就是让计算机根据过去接触到的处理规则来适应新的数据。比如，如果你只有一张吉他画和一个空的 Swift 类，那么”这幅画中有吉他吗？“是个非常难回答的问题，但是如果你使用大量包含吉他的图片样本来构建一个训练模型，这时你就可以有效地训练计算机识别出包含吉他的新图像。

听上去很无聊，但实际上是 iOS 11 上大量的先进技术的基础：Siri，照相机，Quick Type 都使用了机器学习来帮助它们更好的理解我们所在的世界。iOS 11 还引入了一个新的 Vision 框架，这是一个从 Core Image ，机器学习功能和所有新技术组成的一个有点模糊的组合。

在 iOS 11 里所有的这些都是由一个叫做 Core ML 的机器学习框架提供，该框架旨在支持各种各样的模型，而不仅仅是识别图像。信不信由你，编写 Core ML 的代码是很少的，然而这只是事情的一面。

你清楚的，Core ML 需要训练模型才能工作，而模型是用算法在大量数据训练得出的。这些模型可以从几千字节到数百兆字节甚至更多，而且明显需要一定的专业知识才能训练，特别是当你处理图像识别的时候。令人欣喜的是，苹果提供了一些可以用来快速上手和运行的模型，所以如果你只是想要尝试下使用 Core ML ，实际上是非常简单的。

难过的是，还有事情还有另外一面：第三方框架总是非常恶心的，你明白的，Core ML 模型为我们自动生成接收一些输入数据并返回一些输出数据的代码 - 这部分是非常友好的。但悲伤的是，处理图像时所需的输入数据不是 “UIImage”，也不是 “CGImage”，更不是 “CIImage” 。

相反，苹果选择让我们使用 “CVPixelBuffer” 输入。`CVPixelBuffer` 放进我的代码中就像血友病聚会上来了头豪猪一样不受欢迎。没有把 UIImage 转换为 CVPixelBuffer 的完美有效的方法，我是很有资格说的，因为我浪费了几个小时来寻求解决方案。幸运的是 [Chris Cieslak](https://twitter.com/cieslak) 非常慷慨把他的代码分享给我，在他的 [WTFPL](http://www.wtfpl.net/about/) 下转换是非常有效的，所以你也可以使用它进行转换。

现在让我们尝试下 Core ML 吧。先创建一个新的单视图 APP 工程（或者继续使用你现有的工程），再在工程里添加一张图片 —— 我添加的是维基百科里的 [华盛顿杜勒斯国际机场](https://upload.wikimedia.org/wikipedia/commons/9/92/Washington_Dulles_International_Airport_at_Dusk.jpg) 。把这张图片重命名为 "test.jpg" 以避免拼写错误。

现在我们有一些输入测试，我们需要添加一个训练好的模型。它可能没有看到过我们确切的照片，但它需要接触些类似的图片以便识别出这个机场。苹果在 [https://developer.apple.com/machine-learning](https://developer.apple.com/machine-learning/) 上提供了一些预配置的模型 —— 现在进入网站，并下载 “Places205-GoogLeNet” 模型。 模型只有 25MB，所以它不会占用你用户设备上太多空间。

当你下载好模型后，先把它拖到你的 Xcode 工程中，再选择它，这时你就可以看到 Core ML 的模型查看器。你会看到它是由 MIT 制作的神经网络分类器，还有可以根据知识共享许可证使用。在这个下面，你将看到它有 “sceneImage” 作为输入，还有 “sceneLabelProbs ” 和 “sceneLabel” 作为输出 —— 输入一张图片，输出一些计算机识别这张图片的文本描述。

你还将看到 “Model class” 和 “Swift generated source” —— Xcode为我们生成了一个类，只包含几行代码，这一点非常显著，你将很快看到。

现在，我们有一个可以识别的图像和一个可以检查它的训练好的模型。 我们现在需要做的是将两者放在一起：加载图片，为模型准备图片，最后询问模型的预测。

为了使这个代码更容易理解，我把它分成了一些块。 首先，打开 ViewController.swift 并将其修改为：

```
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let image = UIImage(named: "test.jpg")!

        // 1
        // 2
        // 3
    }
}
```

这只是加载我们准备被处理的测试图片。 接下来的步骤是从 “// 1” 开始逐个填写这三个注释。

基于图像的 Core ML 模型要求以精确的尺寸接收图片，这是他们接受过训练的尺寸。 对于 GoogLeNetPlaces 模型尺寸应该是 224 x 224 而其他模型有它们各自的尺寸，而 Core ML 会告诉你是否以错误的尺寸输入了东西。

所以，我们需要的第一件事是缩小我们的图像，让图片恰好是 224 x 224 ，而不管我们是使用视网膜屏设备还是其他的设备。 这可以使用 “UIGraphicsBeginImageContextWithOptions（）” 方法来强制 1.0 的比例。 用下面的代码替换这个 `// 1` 注释：

```
let modelSize = 224
UIGraphicsBeginImageContextWithOptions(CGSize(width: modelSize, height: modelSize), true, 1.0)
image.draw(in: CGRect(x: 0, y: 0, width: modelSize, height: modelSize))
let newImage = UIGraphicsGetImageFromCurrentImageContext()!
UIGraphicsEndImageContext()
```

这给了我们一个新的叫做 “newImage” 常量，它是一个符合模型中正确尺寸的 “UIImage”。

现在第二部分要做的是从 “UIImage” 到 “CVPixelBuffer” 之间恶心的转换。 因为这是毫无意义的复杂操作，所以我不打算试图解释所有的各个步骤。除了拷贝下面的代码，我不建议你做任何事情。 用下面的代码替换这个 `// 2` 注释：

```
let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
var pixelBuffer : CVPixelBuffer?
let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
guard (status == kCVReturnSuccess) else { return }

CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

context?.translateBy(x: 0, y: newImage.size.height)
context?.scaleBy(x: 1.0, y: -1.0)

UIGraphicsPushContext(context!)
newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
UIGraphicsPopContext()
CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
```

如果可能使用很多次上面的代码，你可能想要把这些复杂代码封装到一个函数里边。但无论你如何操作，请不要试图去记住它。

现在开始重要的，有趣的和微不足道的部分：实际使用 Core ML 框架，这只有三行代码，相当坦率地说，非常简单。 就像我所说的，Xcode 自动根据 Core ML 模型生成一个 Swift 类，所以我们可以立即实例化一个 “GoogLeNetPlaces” 对象。

最后我们可以将我们的图片缓存传递给它的 “prediction()” 方法，这个方法将返回预测结果或抛出一个错误。 在实践中，你可能会发现使用 `try？' 更容易获得一个值或是 nil 。 最后，我们将打印出预测结果，以便你了解到 Core ML 的表现。

用下面代码替换替换这个 `// 3` 注释：

```
let model = GoogLeNetPlaces()
guard let prediction = try? model.prediction(sceneImage: pixelBuffer!) else { return }
print(prediction.sceneLabel)
```

不管你相不相信，这就是使用 Core ML 的所有代码； 这简单的三行代码做完了所有的工作。 你打印出来的结果取决于你的输入内容和你的训练模型，但 GoogLeNetPlaces 正确地将我的图片识别为机场航站楼，这一切完全在设备上完成 —— 无需将图片发送到远程服务器处理，因此在这个黑盒子里你得到了极好的隐私保护。

## 更多其他的更新。。。

iOS 11 还有大量的其他更新 —— 这些是我最喜欢的：

- Metal 2 被设置成提高整个系统的图形性能。我没在这提供代码示例是因为这实在是一个高深的话题 —— 大多数人只会很高兴看到他们的 SpriteKit ，SceneKit 和 Unity 应用程序无需额外的工作就可以获得更快的速度。
- TableView Cell 现在自动支持自适应。以前都是设置 `UITableViewAutomaticDimension` 作为行高来触发自适应行为。但现在再也不需要设置了。
- TableView 增加了一个 新的基于闭包的 `performBatchUpdates()` 方法，它可以让你一次性对多行的插入、删除、移动操作进行动画处理，甚至可以在动画完成之后立即执行结束闭包。
- 在  Apple Music 第一次出现的新的加粗黑标题现在可以再整个系统使用了，同时支持通过一个细小的改动在我们自己的 APP 使用：在 IB 内为我们的导航条选择 "Prefers Large Titles" ，或者如果你更喜欢使用代码的话使用 `navigationController?.navigationBar.prefersLargeTitles = true` 来设置。
- 为了支持 `safeAreaLayoutGuide`  `topLayoutGuide`属性被弃用了。它提供了所有边的边缘而不仅仅是顶部和底部，这可能预示未来的 iPhone 为非矩形布局 —— 带有沉浸式相机的全屏幕 iPhone 8，有人有异议吗？
- Stack views 增加了一个 `setCustomSpacing(_:after:)` 方法，这可以让你在 stack view 添加你想要的而不是统一大小的空白。

## 接下来就是 Xcode

Xcode 9 是我见过的最令人兴奋的 Xcode 版本 —— 它充满了令人难以置信的新功能，甚至可以使最坚定的 Xcode 抱怨者重新考虑。

这些是最吸引我的功能更新：

- 可以在编辑器内进行 Swift 和 Objective-C 的重构，这意味着你只需点击几下鼠标就可以对你的代码进行彻底的更改（例如对方法重命名）。
- iOS 和 tvOS 支持无线调试了。为了使用这个功能，先使用 USB 连接你的设备，再在 Window 菜单里选择 Devices and Simulators 。
选择你的设备，最后选择 "Connect via network" 。如果第一次不能成功 不必感到惊奇 —— 这还是 beta 1 版本！
- 源代码编辑器使用 Swift 进行了重写，带来了滚动和搜索的速度极大的提升。以及一些其他有用的功能，比如按住 Ctrl 键时的范围高亮显示。
- 你现在可以将命名颜色添加到 asset catalogs，这样你可以定义一次颜色， 在任何地方使用 `UIColor(named:)` 方法初始化。
- 默认情况下启用了一个新的主线程检查器，当检测到任何不在主线程上执行的 UIKit 方法调用时，它将自动发出警告 - 这是常见的错误源头。
- 你现在可以同时运行多个模拟器，甚至可以自由调整它们的大小。 苹果在模拟器周围添加了额外的用户界面，以便我们访问硬件控件。
- 如果您不想立即使用 Swift 4，则会有一个新的 “Swift Language Version” 构建设置，您可以选择 Swift 4.0 或 Swift 3.2。 两者都使用相同的编译器，但在内部启用不同的选项

认真的，我希望我今年在 WWDC 现场，这样我就给 Xcode 工程师一个熊抱 —— 这是一个炙手可热的版本，让 Xcode 在奔向伟大的路上越行越远。

## 还在等什么？

现在你已经了解了 iOS 11 中的新功能，你也应该看一看我的新书：[Practical iOS 11](/store/practical-ios11)。这是一本用实际项目讲解 iOS 11 中所有主要变化的书籍，拥有它你可以尽可能快地熟悉 iOS 11。

[![Practical iOS 11](https://www.hackingwithswift.com/img/book-ios11@2x.png)](https://www.hackingwithswift.com/store/practical-ios11)

[Buy Practical iOS 11 for $30](https://www.hackingwithswift.com/store/practical-ios11)

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
