> * 原文链接: [iOS 9 系列教程: 使用 UIKit 进行面向协议的编程](http://www.captechconsulting.com/blogs/ios-9-tutorial-series-protocol-oriented-programming-with-uikit)
* 原文作者 : [TYLER TILLAGE](http://www.captechconsulting.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [walkingway](https://github.com/walkingway)
* 校对者 :
* 状态 : 完成

# UIKit 里如何面向协议编程

Swift 中令人耳目一新的「面向协议编程」在 2015 年 WWDC 上一经推出，街头巷尾都在热情洋溢地讨论着**协议扩展**（protocol extensions）---这一激动人心的语言新特性，既然是新特性，第一次接触总要走点弯路。

我已经阅读过无数篇关于 Swift 协议和协议扩展来龙去脉的文章，这些文章无疑都表达了同一个观点：在 Swift 新版图中**协议扩展**拥有绝对主力位置。苹果官方甚至推荐默认使用协议（protocol）来替换类（class），而实现这种方式的关键正是面向协议编程。

但是我读过的这些文章只是把「什么是协议扩展」讲清楚了，并没有揭开「面向协议编程」真正的面纱。尤其是针对日常 UI 的开发，大部分示例代码并没有切合实际的使用场景，也没有利用任何框架。

我想要明确的是：**协议扩展**如何影响现有构建的工程，并且利用这一新特性更好地与 UIKit 协同工作。

现在我们已经拥有了协议扩展，那么在以类为主的 UIKit 中改用基于协议的实现方式是否更有价值。这篇文章我尝试将 Swift 的协议扩展与真实世界的 UI 完美结合，但随着我们进一步探索，就会发现二者的匹配度并不如我们所期望的那样。 

###协议的优势

协议并不是什么新技术，但我们可以使用内置的函数扩展他们，共享内部逻辑，很神奇不是吗？真是个美妙的想法，协议越多代表灵活性越好。一个协议扩展代表可被部署的单一功能模块，并且该模块可以被重载（或不可以）和通过 where 子句与特定类型的代码交互。

> 协议 _Protocols_ 存在的目的让编译器满意就好，但协议扩展 _extensions_ 是一段代码片段，可在整个代码库里共享的有形资产

虽然只可能从一个父类继承，但只要我们需要，可以尽可能多地部署协议扩展。部署一个协议就像是添加一个指令到 Angular.js 里的元素中，我们通过向某些对象注入逻辑从而改变这些对象的行为。协议不再仅仅是一份合同，通过扩展成为了一种可被部署的功能。

## 如何使用扩展协议

协议扩展的用法非常简单，这篇文章不会教你用法，而是引领你们手握`协议扩展`这一利器在 UKIit 开发领域做一些有价值的尝试。如果你需要火速熟悉基本用法，请参考苹果的官方文档 [Official Swift Documentation on Procotol Extensions](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/Protocols.html#//apple_ref/doc/uid/TP40014097-CH25-ID521)

### 协议扩展的局限

在我们开始前，先让我们澄清下**协议扩展**不是什么，有很多事情**协议扩展**是做不了的，这种限制取决于语言自身设计。不过我还是很期待苹果在未来的 Swift 版本更新中解除一些限制。

* 不能在协议扩展里调用来自 Objective-C 的成员
* 不能使用 `where` 字句限定 `struct` 类型
* 不能定义多个以逗号分隔的 `where` 从句，类似于 `if let` 语句
* 不能在协议扩展内部存储动态变量
	* 该规则同样适用于非泛型扩展
	* 静态变量应该是允许的，但截至 Xcode 7.0 还会打印 "静态存储属性不支持泛型类型" 的错误。
* <del>与非泛型扩展不同，不能调用 `super` 来执行一个协议扩展</del> [@ketzusaka](https://twitter.com/ketzusaka) 指出可以通过 `(self as MyProtocol).method()` 来调用
	* 因为这个原因，协议扩展没有真正意义上的继承概念
* 不能在多个协议扩展中部署重名的成员方法
	* Swift 的运行时只会选择最后部署的协议，而忽略其他的
	* 举个例子，如果你有两个协议扩展都实现了相同的方法，那么只有后部署的协议方法的会被实际调用，不能从其他扩展里执行该方法
* 不能扩展可选的协议方法
	* 可选协议要求 @objc 标签，不能和协议扩展一起使用
* 不能在同一时刻声明一个协议和他的扩展
	* 如果你真的想要声明实现放在一起，那就使用 `extension protocol SomeProtocol {}` 吧，因为声明实现都在同一位置，只提供协议实现就好，声明可以省略。

## Part 1: 扩展现有UIKit协议

当我第一次学习协议扩展时，首先想到的就是 `UITableViewDataSource` 这个广为人知的数据源协议。我琢磨着如果能向所有部署了 `UITableViewDataSource` 协议的对象都提供默认的实现，岂不是很酷？

如果每个 `UITableView` 都有一组 sections，那么为什么不扩充 `UITableViewDataSource`，然后在同一个位置实现 `numberOfSectionsInTableView:` 方法？如果在所有的 tables 上都需要滑动删除的功能，为什么不在协议扩展里实现 `UITableViewDelegate` 的相关方法？

但就目前来说，这都是不可能的

**我们不能做什么：**
为 Objective-C 协议提供一个默认的实现

UIKit 依旧采用 Objective-C 编译，况且 Objective-C 没有协议扩展的概念。这意味着在真实项目中尽管我们有能力在 UIKit 协议里声明扩展，但是 UIKit 对象并不能看到我们扩展里的方法。

举个例子，如果我们扩充了 `UICollectionViewDelegate` 来实现 `collectionView:didSelectItemAtIndexPath:`。但是当你点击 cell 并不会触发该协议方法，这是因为在 Objective-C 上下文环境中 `UICollectionView` 自己是看不到我们实现的协议方法。如果我们将一个必须实现的 delegate 方法（`collectionView:cellForItemAtIndexPath:`）放到协议扩展中，编译器会向我们抱怨：「声明实现协议的对象」没有遵守 `UICollectionViewDelegate` 协议（因为看不到） 

Xcode 尝试在我们的协议扩展方法前添加 `@objc` 来解决这一问题，只能说想象总是美好的，现实却很残酷。又冒出一个新错误：「协议扩展中的方法不能应用于 Objective-C」，这才是根本问题所在--协议扩展只适用于 Swift 2.0 以上的版本

**我们能做什么**
添加一个新方法到现有的 Objective-C 协议中

我们能够在 Swift 中直接调用 UIKit 协议扩展里的方法，即使 UIKit 看不见他们。这就意味着尽管我们不能覆盖 _override_ UIKit 已有的协议方法，但是我们能为现有的协议添加新的便利方法。

我承认，不那么令人兴奋，任何属于 Objective-C 的框架代码都不能调用这些方法。但别灰心，我们还有机会。下面一些例子尝试将协议扩展和 UIKit 里存在的协议结合起来。

### UIKit协议扩展示例

#### 扩展 `UICoordinateSpace`

有时候需要在 Core Graphics 和 UIKit 的坐标系之间进行转换，我们可以添加一个 helper 方法到协议 `UICoordinateSpace` 中，UIView 也遵守该协议

```swift
extension UICoordinateSpace {
    func invertedRect(rect: CGRect) -> CGRect {
        var transform = CGAffineTransformMakeScale(1, -1)
        transform = CGAffineTransformTranslate(transform, 0, -self.bounds.size.height)
        return CGRectApplyAffineTransform(rect, transform)
    }
}
```

现在我们的 `invertedRect` 方法可以应用在任何遵守 `UICoordinateSpace` 协议的对象上，我们在绘图代码中使用他：

```swift
class DrawingView : UIView {
    // Example -- Referencing custom UICoordinateSpace method inside UIView drawRect.
    override func drawRect(rect: CGRect) {
        let invertedRect = self.invertedRect(CGRectMake(50.0, 50.0, 200.0, 100.0))
        print(NSStringFromCGRect(invertedRect)) // 50.0, -150.0, 200.0, 100.0
    }
}
```
> `UIView` 遵守 `UICoordinateSpace` 协议

#### 扩展 `UITableViewDataSource`

尽管我们不能提供关于 `UITableViewDataSource` 默认的实现方法，但我们依旧可以将全局逻辑放进协议中方便遵守 `UITableViewDataSource` 的对象使用。

```swift
extension UITableViewDataSource {
    // Returns the total # of rows in a table view.
    func totalRows(tableView: UITableView) -> Int {
        let totalSections = self.numberOfSectionsInTableView?(tableView) ?? 1
        var s = 0, t = 0
        while s < totalSections {
            t += self.tableView(tableView, numberOfRowsInSection: s)
            s++
        }
        return t
    }
}
```

上面的 `totalRows:` 方法可以快速统计 table view 中有多少条目（item），特别是 cell 分散在各个 sections 之中，而又想快速得到一个总条目数时尤其有用。调用该方法的一个绝佳位置就在 `tableView:titleForFooterInSection:` 里：

```swift
class ItemsController: UITableViewController {
    // Example -- displaying total # of items as a footer label.
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == self.numberOfSectionsInTableView(tableView) - 1 {
            return String("Viewing %f Items", self.totalRows(tableView))
        }
        return ""
    }
}
```

####扩展 `UIViewControllerContextTransitioning`

或许你已拜读过我在 iOS 7 出来时写的关于自定义导航栏的[文章](https://www.captechconsulting.com/blogs/ios-7-tutorial-series-custom-navigation-transitions--more)，也尝试开始自定义导航栏过渡。这里有一组之前文章使用的方法，让我们统统放进 `UIViewControllerContextTransitioning` 协议里。

```swift
extension UIViewControllerContextTransitioning {
    // Mock the indicated view by replacing it with its own snapshot. 
    // Useful when we don't want to render a view's subviews during animation, 
    // such as when applying transforms.
    func mockViewWithKey(key: String) -> UIView? {
        if let view = self.viewForKey(key), container = self.containerView() {
            let snapshot = view.snapshotViewAfterScreenUpdates(false)
            snapshot.frame = view.frame

            container.insertSubview(snapshot, aboveSubview: view)
            view.removeFromSuperview()
            return snapshot
        }

        return nil
    }

    // Add a background to the container view. Useful for modal presentations, 
    // such as showing a partially translucent background behind our modal content.
    func addBackgroundView(color: UIColor) -> UIView? {
        if let container = self.containerView() {
            let bg = UIView(frame: container.bounds)
            bg.backgroundColor = color

            container.addSubview(bg)
            container.sendSubviewToBack(bg)
            return bg
        }
        return nil
    }
}
```

我们在 `transitionContext` 对象（`UIViewControllerContextTransitioning`）中执行这些方法，该对象一般作为参数传递给我们的 **animation coordinator**（`UIViewControllerAnimatedTransitioning`）：

```swift
class AnimationCoordinator : NSObject, UIViewControllerAnimatedTransitioning {
    // Example -- using helper methods during a view controller transition.
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        // Add a background
        transitionContext.addBackgroundView(UIColor(white: 0.0, alpha: 0.5))

        // Swap out the "from" view
        transitionContext.mockViewWithKey(UITransitionContextFromViewKey)

        // Animate using awesome 3D animation...
    }

    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 5.0
    }
}
```

比方说我们的应用程序有多个 `UIPageControl` 实例，然后我们复制粘贴一些代码在 `UIScrollViewDelegate` 的实现里让其工作。通过协议扩展我们可以构建全局一种逻辑，调用时仍然使用 `self`

```swift
extension UIScrollViewDelegate {
    // Convenience method to update a UIPageControl with the correct page.
    func updatePageControl(pageControl: UIPageControl, scrollView: UIScrollView) {
        pageControl.currentPage = lroundf(Float(scrollView.contentOffset.x / (scrollView.contentSize.width / CGFloat(pageControl.numberOfPages))));
    }
}
```

此外，如果我们知道 `Self` 就是 `UICollectionViewController`，那么可以去掉**参数** `scrollView` 

```swift
extension UIScrollViewDelegate where Self: UICollectionViewController {
   func updatePageControl(pageControl: UIPageControl) {
        pageControl.currentPage = lroundf(Float(self.collectionView!.contentOffset.x / (self.collectionView!.contentSize.width / CGFloat(pageControl.numberOfPages))));
    }
}

// Example -- Page control updates from a UICollectionViewController using a protocol extension.
class PagedCollectionView : UICollectionViewController {
    let pageControl = UIPageControl()

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updatePageControl(self.pageControl)
    }
}
```

无可否认的，这些例子有些牵强，事实证明想要扩展现有 UIKit 协议时，我们并没有太多手段，任何努力都有点微不足道。但是，这儿仍有一个问题需要我们面对，就是如何配合现有的 UIKit 设计模式部署自定义的协议扩展。 

## Part 2: 扩展自定义协议

### MVC 中使用面向协议编程

一个 iOS 应用程序从其核心来看执行三个基本功能，通常描述为 MVC（模型-视图-控制器）模型。所有的 App 所做的不过是对数据进行一些操作并将其显示在屏幕上。

![](http://www.captechconsulting.com/blogs/library/A9AAC94D44AB4D64B4F2634F2E4AF6B8.ashx?h=480&w=1200)

下面三个例子中，我将会向你们安利**面向协议编程**的设计模式思想，并尝试使用**协议扩展**依次改造 MVC 模式下的三个组件 Model -> Controller -> View。

### Model 管理中的协议（M）

假设我们要做一个音乐 App，叫做鸭梨音乐。也就是有一堆关于艺术家、专辑、歌曲和播放列表的 **model** 对象，接下来我们要构建一些**基于的标识符代码**来从网络下载这些 models（标识符已经预先载入）

实践协议最好的方式是从高等级的抽象开始。最原始的想法是我们有一个资源需要通过远端服务器 API 获取，来吧少年！开始创建一个协议

```swift
// Any entity which represents data which can be loaded from a remote source.
protocol RemoteResource {}
```

但是别急，这还只是一个空协议! `RemoteResource` 并不是用来直接部署的，他不是一份合同契约，而是一组用来执行网络请求的功能集合。因此 `RemoteResource` 真正的价值在于他的协议扩展。

```swift
extension RemoteResource {
    func load(url: String, completion: ((success: Bool)->())?) {
        print("Performing request: ", url)

        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!) { (data, response, error) -> Void in
            if let httpResponse = response as? NSHTTPURLResponse where error == nil && data != nil {
                print("Response Code: %d", httpResponse.statusCode)

                dataCache[url] = data
                if let c = completion {
                    c(success: true)
                }
            } else {
                print("Request Error")
                if let c = completion {
                    c(success: false)
                }
            }
        }
        task.resume()
    }

    func dataForURL(url: String) -> NSData? {
        // A real app would require a more robust caching solution.
        return dataCache[url]
    }
}

public var dataCache: [String : NSData] = [:]
```

现在我们有一个协议，内建了从远程服务器抓取数据的功能，任何部署了该协议的对象都能自动获得这些方法。

我们有两个 API 用来和远程服务器交互，一个适用于 JSON 数据 (api.pearmusic.com)，另一个适用于媒体数据 (media.pearmusic.com)，为了处理这些数据，我们将针对不同的数据类型创建相应的 `RemoteResource` 子协议。

```swift
protocol JSONResource : RemoteResource {
    var jsonHost: String { get }
    var jsonPath: String { get }
    func processJSON(success: Bool)
}

protocol MediaResource : RemoteResource {
    var mediaHost: String { get }
    var mediaPath: String { get }
}
```

让我们实现这些协议

```swift
extension JSONResource {
    // Default host value for REST resources
    var jsonHost: String { return "api.pearmusic.com" }

    // Generate the fully qualified URL
    var jsonURL: String { return String(format: "http://%@%@", self.jsonHost, self.jsonPath) }

    // Main loading method.
    func loadJSON(completion: (()->())?) {
        self.load(self.jsonURL) { (success) -> () in
            // Call adopter to process the result
            self.processJSON(success)

            // Execute completion block on the main queue
            if let c = completion {
                dispatch_async(dispatch_get_main_queue(), c)
            }
        }
    }
}
```

我们提供了一个默认主机值，一个生成完整 URL 的请求方法，以及一个从 `RemoteResource` 载入加载资源的 `load:` 方法。我们稍后会依赖以上实现来提供正确的解析方法 `jsonPath`

`MediaResource` 的实现遵循类似模式：

```swift
extension MediaResource {
    // Default host value for media resources
    var mediaHost: String { return "media.pearmusic.com" }

    // Generate the fully qualified URL
    var mediaURL: String { return String(format: "http://%@%@", self.mediaHost, self.mediaPath) }

    // Main loading method
    func loadMedia(completion: (()->())?) {
        self.load(self.mediaURL) { (success) -> () in
            // Execute completion block on the main queue
            if let c = completion {
                dispatch_async(dispatch_get_main_queue(), c)
            }
        }
    }
}
```

你或许可能注意到了这些实现非常相似。事实上，将很多方法提升到 `RemoteResource` 层面具有非凡的意义，根据需要从子协议返回相应的主机值（host）即可。

美中不足的是，我们的协议并不是相互排斥的，我们希望有一个对象能同时满足 `JSONResource` 和 `MediaResource`。记住协议扩展是彼此相互覆盖的，除非我们采用不同的属性或方法，不然每次都是最后部署的协议才会被调用

让我们来专门研究下数据访问方法

```swift
extension JSONResource {
    var jsonValue: [String : AnyObject]? {
        do {
            if let d = self.dataForURL(self.jsonURL), result = try NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                return result
            }
        } catch {}
        return nil
    }
}

extension MediaResource {
    var imageValue: UIImage? {
        if let d = self.dataForURL(self.mediaURL) {
            return UIImage(data: d)
        }
        return nil
    }
}
```

这是一个关于协议扩展经典的例子，传统的协议会说：「我承诺我属于这种类型，具备这些特性」。而一个协议扩展则会说：「因为我有这些特性，所以我能做这些独一无二的事情」。既然 `MediaResource` 有能力访问图像数据，那么应用该协议的对象也能很轻松地提供一个 `imageValue` ，而不用考虑特定类型或上下文环境。

前面提到我们将会基于已知的标识符加载 models，所以让我们为「具有唯一标识的实体」创建一个协议

```swift
protocol Unique {
    var id: String! { get set }
}

extension Unique where Self: NSObject {
    // Built-in init method from a protocol!
    init(id: String?) {
        self.init()
        if let identifier = id {
            self.id = identifier
        } else {
            self.id = NSUUID().UUIDString
        }
    }
}

// Bonus: Make sure Unique adopters are comparable.
func ==(lhs: Unique, rhs: Unique) -> Bool {
    return lhs.id == rhs.id
}
extension NSObjectProtocol where Self: Unique {
    func isEqual(object: AnyObject?) -> Bool {
        if let o = object as? Unique {
            return o.id == self.id
        }
        return false
    }
}
```

由于不能在扩展 extension 中创建存储属性，我们还是需要依赖遵守 `Unique` 协议的对象来声明`id` 属性。加之，你或许注意到了我仅在 `Self: NSObject` 时扩展了 `Unique`，否则，我们不能调用 `self.init()`，这是因为没有他的声明。一个变通的解决方案就是在该协议中声明一个 `init()` ，但是需要遵守协议的对象来显式实现他， 因为我们所有的 models 都是基于 `NSObject`的，所幸这并不成问题。

好了，我们已经得到了一个从网络获取资源的基本方案，让我们开始创建遵守这些协议的  models。下面是我们的 `Song` 模型的样子：

```swift
class Song : NSObject, JSONResource, Unique {
    // MARK: - Metadata
    var title: String?
    var artist: String?
    var streamURL: String?
    var duration: NSNumber?
    var imageURL: String?

    // MARK: - Unique
    var id: String!
}
```

等等，`JSONResource` 的实现在哪里？

相比直接在类中实现 `JSONResource`，我们可以使用条件协议扩展来代替，这会让我们有能力将所有基于 `RemoteResource` 的逻辑代码组织整合在一起，这样调整起来更方便，也使 model 实现更清晰。因此除了 `RemoteResource` 逻辑之前的代码外，我们将下面的代码放进 `RemoteResource.swift` 文件，

```swift
extension JSONResource where Self: Song {
    var jsonPath: String { return String(format: "/songs/%@", self.id) }

    func processJSON(success: Bool) {
        if let json = self.jsonValue where success {
            self.title = json["title"] as? String ?? ""
            self.artist = json["artist"] as? String ?? ""
            self.streamURL = json["url"] as? String ?? ""
            self.duration = json["duration"] as? NSNumber ?? 0
        }
    }
}
```

将所有与 `RemoteResource` 相关的代码整合在同一个位置好处多多。首先在同一个地方完成协议实现，扩展的作用域很清晰。当声明一个将要扩展的协议时，我建议将扩展代码和声明的协议放在同一文件中

下面是加载歌曲 `Song` 的实现，多亏了 `JSONResource` 和 `Unique` 协议扩展

```swift
let s = Song(id: "abcd12345")
let artistLabel = UILabel()

s.loadJSON { (success) -> () in
    artistLabel.text = s.artist
}
```

我们的歌曲 `Song` 对象是一些元数据的简单封装，他本该如此，所有的苦差事都应交给协议扩展去做。

下面例子中的 `Playlist` 对象同时遵守了 `JSONResource` 和 `MediaResource` 协议

```swift
class Playlist: NSObject, JSONResource, MediaResource, Unique {
    // MARK: - Metadata
    var title: String?
    var createdBy: String?
    var songs: [Song]?

    // MARK: - Unique
    var id: String!
}

extension JSONResource where Self: Playlist {
    var jsonPath: String { return String(format: "/playlists/%@", self.id) }

    func processJSON(success: Bool) {
        if let json = self.jsonValue where success {
            self.title = json["title"] as? String ?? ""
            self.createdBy = json["createdBy"] as? String ?? ""
            // etc...
        }
    }
}
```

在我们盲目地为 `Playlist` 实现 `MediaResource` 之前，先回退一步，我们注意到我们的媒体 API 只需要远端的标识，并没有指定协议应用者的类型，这就意味只要我们知道标识符，我们就能构建 `mediaPath`。让我们使用一个 `where` 从句来限定 `MediaResource` 聪明到只在 `Unique` 下工作

```swift
extension MediaResource where Self: Unique {
    var mediaPath: String { return String(format: "/images/%@", self.id) }
}
```

因为 `Playlist` 已经遵循了 `Unique`，因此我们不需要再做字面上的处理，就可以和 `MediaResource` 一起愉快地工作！同样的逻辑反过来也成立（遵循了 `MediaResource`，也必然适配于 `Unique` 协议），即只要对象的标识对应媒体 API 中的一张图片，就能正常工作。（创建 `mediaPath`）

下面演示如何载入 `Playlist` 图像

```swift
let p = Playlist(id: "abcd12345")
let playlistImageView = UIImageView(frame: CGRectMake(0.0, 0.0, 200.0, 200.0))

p.loadMedia { () -> () in
    playlistImageView.image = p.imageValue
}
```

我们现在拥有一种通用方式来定义远程资源，能够被程序中的任意实体使用，而不仅仅局限于这些模型对象。我们能够很方便地扩展 `RemoteResource` 来处理不同类型的 REST 操作，并针对更多的数据类型添加额外的子协议。

### 数据格式化的协议

现在我们已经构造了一种加载模型对象的方式，继续深入到下一个阶段吧。我们需要格式化来自对象的元数据，并以一致的方式显示在用户面前。

鸭梨音乐是一个大工程，拥有相当数量不同类型的模型，每一个模型都可能在不同位置显示。比如，如果我们有一个以 `Artist` 为标题的 view controller，我们会只显示艺术家名字 {name}。但是，如果我们拥有额外的空间，比如一个存在 `UITableViewCell`，我们就会使用 "{name} ({instrument})"。再进一步，如果在 `UILabel` 里有更大空间，则会使用 "{name} ({instrument}) {bio}"。

虽然将这些格式化代码放到 view controllers, cells 和 labels 中也可以正常工作，但是如果我们能将这些分散的逻辑提取出来供整个 app 使用，会提高整个应用的可维护性。

我们可以将字符串格式化代码就放在模型对象中，但当我们真要显示字符串时，需要确定 model 的类型。

我们可以在基类中定义一些便利方法，然后每个子类模型都提供自己的格式化方法，但是在面向协议编程中，我们应该思考更加通用的方式。

让我们将这种想法抽象成另一个协议，指定一些可以表现为字符串的实体。然后将会针对各种 UI 方案，提供不同长度的字符串

```swift
// Any entity which can be represented as a string of varying lengths.
protocol StringRepresentable {
    var shortString: String { get }
    var mediumString: String { get }
    var longString: String { get }
}

// Bonus: Make sure StringRepresentable adopters are printed descriptively to the console.
extension NSObjectProtocol where Self: StringRepresentable {
    var description: String { return self.longString }
}
```

足够简单吧，这里还有几个模型对象，我们将他们变成 `StringRepresentable`：

```swift
class Artist : NSObject, StringRepresentable {
    var name: String!
    var instrument: String!
    var bio: String!
}

class Album : NSObject, StringRepresentable {
    var title: String!
    var artist: Artist!
    var tracks: Int!
}
```

类似于在 `RemoteResource` 中我们的实现，我们将所有的格式化逻辑放进单独的 `StringRepresentable.swift` 文件。

```swift
extension StringRepresentable where Self: Artist {
    var shortString: String { return self.name }
    var mediumString: String { return String(format: "%@ (%@)", self.name, self.instrument) }
    var longString: String { return String(format: "%@ (%@), %@", self.name, self.instrument, self.bio) }
}

extension StringRepresentable where Self: Album {
    var shortString: String { return self.title }
    var mediumString: String { return String(format: "%@ (%d Tracks)", self.title, self.tracks) }
    var longString: String { return String(format: "%@, an Album by %@ (%d Tracks)", self.title, self.artist.name, self.tracks) }
}
```

至此，我们已经处理了各种格式。现在我们需要针对特定的 UI 来显示对应的字符串。基于这种通用的方式，让我们定义一种行为，将满足了 `StringRepresentable` 协议的对象显示在屏幕上，在该协议提供了 `containerSize` 和 `containerFont` 用来计算。

```swift
protocol StringDisplay {
    var containerSize: CGSize { get }
    var containerFont: UIFont { get }
    func assignString(str: String)
}
```

我推荐在协议中只声明方法，而具体实现放到遵循协议的对象中。在协议扩展中，我们将添加真正的实现代码。`displayStringValue:` 方法会决定哪个字符串会被使用，然后传递给指定类型的 `assignString:` 方法


```swift
extension StringDisplay {
    func displayStringValue(obj: StringRepresentable) {
        // Determine the longest string which can fit within the containerSize, then assign it.
        if self.stringWithin(obj.longString) {
            self.assignString(obj.longString)
        } else if self.stringWithin(obj.mediumString) {
            self.assignString(obj.mediumString)
        } else {
            self.assignString(obj.shortString)
        }
    }

#pragma mark - Helper Methods

    func sizeWithString(str: String) -> CGSize {
        return (str as NSString).boundingRectWithSize(CGSizeMake(self.containerSize.width, .max),
            options: .UsesLineFragmentOrigin,
            attributes:  [NSFontAttributeName: self.containerFont],
            context: nil).size
    }

    private func stringWithin(str: String) -> Bool {
        return self.sizeWithString(str).height <= self.containerSize.height
    }
}
```

现在我们有一个遵守 `StringRepresentable` 协议的模型对象，还拥有可以自动选择字符串的协议。此协议一旦成功部署，会自动帮助我们选择正确的字符串，那么接下来该如何整合进 UIKit 中呢？

先拿最简单的 `UILabel` 开刀吧。传统的方式是创建 `UILabel` 的子类，然后部署该协议，接下来在需要使用 `StringRepresentable` 的地方使用这个自定义的 `UILabel`。但更好的选择是使用一个指定类型（UILable 类）的扩展让所有的 `UILabel` 实例自动部署 `StringDisplay` 协议：

>这种方式就不需要创建 `UILable` 的子类了

```swift
extension UILabel : StringDisplay {
    var containerSize: CGSize { return self.frame.size }
    var containerFont: UIFont { return self.font }
    func assignString(str: String) {
        self.text = str
    }
}
```

就是这么简单，对于其他的 UIKit 类，我们可以做同样的事情，只要满足 `StringDisplay` 协议就能正常工作了，是不是很神奇呢？

```swift
extension UITableViewCell : StringDisplay {
    var containerSize: CGSize { return self.textLabel!.frame.size }
    var containerFont: UIFont { return self.textLabel!.font }
    func assignString(str: String) {
        self.textLabel!.text = str
    }
}

extension UIButton : StringDisplay {
    var containerSize: CGSize { return self.frame.size}
    var containerFont: UIFont { return self.titleLabel!.font }
    func assignString(str: String) {
        self.setTitle(str, forState: .Normal)
    }
}

extension UIViewController : StringDisplay {
    var containerSize: CGSize { return self.navigationController!.navigationBar.frame.size }
    var containerFont: UIFont { return UIFont(name: "HelveticaNeue-Medium", size: 34.0)! } // default UINavigationBar title font
    func assignString(str: String) {
        self.title = str
    }
}
```

下面我们来看看以上实现在真实世界的样子，先声明一个 `Artist` 对象，已经部署了 `StringRepresentable` 协议。

```swift
let a = Artist()
a.name = "Bob Marley"
a.instrument = "Guitar / Vocals"
a.bio = "Every little thing's gonna be alright."
```

因为 `UIButton` 的所有实例都通过扩展的方式部署了 `StringDisplay` 协议，妈妈再也不用担心我们直接调用他们的 `displayStringValue:` 方法了

```swift
let smallButton = UIButton(frame: CGRectMake(0.0, 0.0, 120.0, 40.0))
smallButton.displayStringValue(a)

print(smallButton.titleLabel!.text) // 'Bob Marley'

let mediumButton = UIButton(frame: CGRectMake(0.0, 0.0, 300.0, 40.0))
mediumButton.displayStringValue(a)

print(mediumButton.titleLabel!.text) // 'Bob Marley (Guitar / Vocals)'
```

按钮现可以根据自身 frame 大小灵活显示标题了。

当用户点击一个 `Album` 唱片，我们为其压栈（push）一个 `AlbumDetailsViewController`。此刻我们的协议能够依照协定找到一个合适字符串作为导航栏标题。这是因为在 `StringDisplay` 协议扩展中的定义，`UINavigationBar` 会在 iPad 上显示长的标题，而在 iPhone 上显示短标题。

```swift
class AlbumDetailsViewController : UIViewController {
    var album: Album!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Display the right string based on the nav bar width.
        self.displayStringValue(self.album)
    }
}
```

我们可以将模型 models 中有关字符串格式化的代码全部集中转移到一个协议扩展里面，之后再根据具体的 UI 元素灵活显示。这种模式可以在将来的模型对象上重复使用，应用在各种 UI 元素上。此外这种协议具备良好的扩展性，还可以推广到更多非 UI 的场景。

### 在样式中使用协议 (V)

我们已经完成了用协议扩展对模型、格式化字符串的改造，现在让我们来看一个纯粹的前端示例，学习下协议扩展如何增强我们的UI开发

我们可以将协议看做类似于 CSS 的东西，并且使用他们来定义我们 UIKit 对象的样式。通过部署这些样式协议，来自动更新显示外观。

首先，我们将定义一个基础协议，用来表示一个应用样式的实体；声明一个方法，用于最终的应用样式。

```swift
// Any entity which supports protocol-based styling.
protocol Styled {
    func updateStyles()
}
```

接着我们将会创建一些子协议，这些协议会定义各种类型的样式。

```swift
protocol BackgroundColor : Styled {
    var color: UIColor { get }
}

protocol FontWeight : Styled {
    var size: CGFloat { get }
    var bold: Bool { get }
}
```

我们让这些子协议继承自 `Styled`，这样遵守这些子协议的对象就不用再显式调用了。

现在我们可以将具体的样式分类，并使用协议扩展返回需要的值。

```swift
protocol BackgroundColor_Purple : BackgroundColor {}
extension BackgroundColor_Purple {
    var color: UIColor { return UIColor.purpleColor() }
}

protocol FontWeight_H1 : FontWeight {}
extension FontWeight_H1 {
    var size: CGFloat { return 24.0 }
    var bold: Bool { return true }
}
```

剩下的事情就是基于具体的 UIKit 元素类型，实现 `updateStyles` 方法。我们将使用指定类型的扩展让所有的 `UITableViewCell` 实例都遵从 `Styled` 协议

```swift
extension UITableViewCell : Styled {
    func updateStyles() {
        if let s = self as? BackgroundColor {
            self.backgroundColor = s.color
            self.textLabel?.textColor = .whiteColor()
        }

        if let s = self as? FontWeight {
            self.textLabel?.font = (s.bold) ? UIFont.boldSystemFontOfSize(s.size) : UIFont.systemFontOfSize(s.size)
        }
    }
}
```

为了确保 `updateStyles` 会被自动调用，我们将在扩展中重载 `awakeFromNib` 方法。有些童鞋可能会好奇，这种重载操作实际是插入到继承链中，就如同扩展是 `UITableViewCell` 自身的直接子类。在 `UITableViewCell` 的子类中调用 `super`，之后就可以直接调用 `updateStyles` 了。

```swift
public override func awakeFromNib() {
        super.awakeFromNib()
        self.updateStyles()
    }
}
```

现在我们创建了自己的 cell，接下来就可以部署我们需要的样式了

```swift
class PurpleHeaderCell : UITableViewCell, BackgroundColor_Purple, FontWeight_H1 {}
```

我们已经在 UIKit 元素上创建了类似于 CSS 样式风格的声明。使用协议扩展，我们甚至可以为 UIKit 山寨一个 Bootstrap 样式。这种方式可以在很多场景下都能增强我们的开发体验，特别是在应用开发中，当拥有数量繁多的视觉元素，且样式高度动态时尤其有用。

想象一下，一个 App 拥有 20 个以上不同的 view controllers，每个都遵守 2~3 个通用的视觉样式，比起强迫我们创建一个基类或使用一组数量持续增长的全局方法来定义样式，现在仅需要遵守一些样式协议，然后顺手实现就好。

## 我们得到了什么？

我们目前为止做了很多有趣的事情，那么通过使用协议和协议扩展我们最终得到了什么？可能有人觉得我们跟本没必要创建这么多协议。

>面向协议编程并不完美匹配所有基于 UI 的场景。

当我们需要在应用中添加共享代码和通用的功能时，协议和协议扩展将变得非常有价值。并且代码的组织结构也更加清晰有条理。

随着数据类型的增多，协议就越能发挥其用武之地。特别是当 UI 需要显示多种格式的信息时，使用协议会让我们身轻如燕。但是这并不意味着我们需要添加六个协议和一大堆扩展，只是为了让一个紫色的单元格显示一个艺术家的名字。

让我们扩充鸭梨音乐场景，来见识一下「面向协议编程」真正的价值所在。

## 添加复杂度

我们已经在 Pear Music 上下了很大功夫，现在拥有界面美观的专辑列表、艺术家、歌曲和播放列表，我们还使用了美妙的协议和协议扩展来优化 MVC 的原有结构。现在鸭梨公司 CEO 要求我们构建鸭梨音乐 2.0 的版本，希望可以和 Apple Music 一争高下。

我们需要一项酷炫的新特性来脱颖而出，经过头脑风暴后，我们决定添加：「长按预览」这个新特性。听上去是个大胆的创意，我们的 Jony Ive（黑的漂亮）似乎已经在摄像机前娓娓而谈了。让我们使用面向协议编程配合 UIKit 来完成任务。

### 创建 Modal Page

下面来阐述下新特性的工作原理，当用户**长按**艺术家、专辑、歌曲或播放列表时，一个模态视图会以动画的形式出现在屏幕上，展示从网络载入的条目图像，以及描述信息和一个 Facebook 分享按钮。

我们先来构建一个 `UIViewController`，用做用户长按手势后的模态展示的 VC。从一开始我们就能让初始化方法更加通用，传入的参数仅需遵守 `StringRepresentable` 和 `MediaResource` 即可。

```swift
class PreviewController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    // The main model object which we're displaying
    var modelObject: protocol<stringrepresentable>!

    init(previewObject: protocol<stringrepresentable>) {
        self.modelObject = previewObject

        super.init(nibName: "PreviewController", bundle: NSBundle.mainBundle())
    }
}
```

下一步，我们可以使用内建的协议扩展方法分配数据给我们的 `descriptionLabel` 和 `imageView`

```swift
override func viewDidLoad() {
        super.viewDidLoad()

        // Apply string representations to our label. Will use the string which fits into our descLabel.
        self.descriptionLabel.displayStringValue(self.modelObject)

        // Load MediaResource image from the network if needed
        if self.modelObject.imageValue == nil {
            self.modelObject.loadMedia { () -> () in
                self.imageView.image = self.modelObject.imageValue
            }
        } else {
            self.imageView.image = self.modelObject.imageValue
        }
    }
```

最后，我们可以使用相同的方法来从 Facebook 函数获取元数据

```swift
// Called when tapping the Facebook share button.
    @IBAction func tapShareButton(sender: UIButton) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)

            // Use StringRepresentable.shortString in the title
            let post = String(format: "Check out %@ on Pear Music 2.0!", self.modelObject.shortString)
            vc.setInitialText(post)

            // Use the MediaResource url to link to
            let url = String(self.modelObject.mediaURL)
            vc.addURL(NSURL(string: url))

            // Add the entity's image
            vc.addImage(self.modelObject.imageValue!);

            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
}
```

我们已经收获了许多协议，没有他们，我们或许要在 `PreviewController` 中根据不同的类型，分别创建初始化方法。通过协议的方式，不仅保持了 view controller 的绝对简洁，还保证了其在未来的可扩展性。

最后只剩一个轻量级的、清爽的 `PreviewController`，可以接受一个 `Artist`, `Album`, `Song`, `Playlist` 或任意匹配了我们协议的 **model**。`PreviewController` 没有一行关于特定模型的代码。

### 集成第三方代码

当我们使用协议和协议扩展构建 `PreviewController` 时，这里还有最后一个特别棒的应用场景。我们融入了一个新的框架，该框架在我们的 App 中可以用来载入音乐家的 Twitter 信息。我们想要在主页面显示 tweets 列表，通常会指定一个 model 对象对应一条 tweet：

```swift
class TweetObject {
    var favorite_count: Int!
    var retweet_count: Int!
    var text: String!
    var user_name: String!
    var profile_image_id: String!
}
```

我们并不拥有此代码，也不能修改 `TweetObject`，但我们仍然想要用户通过长按手势，在`PreviewController` UI 上来预览这些 tweets。而我们所要做的就是扩展这些现有协议。

```swift
extension TweetObject : StringRepresentable, MediaResource {
    // MARK: - MediaResource
    var mediaHost: String { return "api.twitter.com" }
    var mediaPath: String { return String(format: "/images/%@", self.profile_image_id) }

    // MARK: - StringRepresentable
    var shortString: String { return self.user_name }
    var mediumString: String { return String(format: "%@ (%d Retweets)", self.user_name, self.retweet_count) }
    var longString: String { return String(format: "%@ Wrote: %@", self.user_name, self.text) }
}
```

现在我们可以传递一个 `TweetObject` 到我们的 `PreviewController` 中，对于 `PreviewController` 来讲，他甚至不知道我们正在工作的外部框架

```swift
let tweet = TweetObject()
let vc = PreviewController(previewObject: tweet)
```

## 课程总结

在 WWDC 2015 的开发者大会上，苹果官方推荐使用协议来替代类，但是我认为这条规则忽视了协议扩展工作在某些重型框架（UIKit）下的局限性。只有当协议扩展被广泛使用，而且不需要考虑遗产代码时，才能发挥他的威力。虽然最初的例子看上去较为琐碎，但随时间的增长，应用的尺寸和复杂度都会成倍增长，这种通用设计就会变得格外有效。

这是一个代码解释性的成本收益问题。在一个的 UI 占大头的大型应用中，协议 & 扩展并不那么实用。如果你有一个单独的页面只展示一种类型的信息（今后也不会改变），那么就不要考虑用协议来实现了。但是如果你的应用界面在不同的视觉样式、表现风格间游走，那么将协议和协议扩展作为连接数据和外观之间的桥梁是极其有用的，你会在未来的开发中受益匪浅。

最后，我并不是想把协议看成一种银弹，而是将其看做是在某些开发场景中的一把利器。尽管如此，面向协议编程都是值得开发者们学习的--只有你真正按照协议的方式，重新审视、重构之前的代码，才能体会其中的精妙之处。

如果你有任何问题，或想了解更多的细节，请务必联系我 [email](mailto:ttillage@captechconsulting.com) ，这是我的 [Twitter](https://twitter.com/ttillage)！
