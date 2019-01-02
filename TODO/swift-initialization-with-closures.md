> * 原文链接: ：[Swift + 闭包初始化](https://medium.com/the-traveled-ios-developers-guide/swift-initialization-with-closures-5ea177f65a5#.dt9an4mzn)
* 原文作者: [Jordan Morgan](https://medium.com/@JordanMorgan10)
* 译文出自: [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: [circlelove](https://github.com/circlelove)
* 校对者:[Kulbear](https://github.com/Kulbear), [siegeout](https://github.com/siegeout)

# Swift + 闭包初始化

闭包 FTW


我准备开始彻底的探明 Swift 安装的整个流程。[过去写过这个东西](https://medium.com/the-traveled-ios-developers-guide/they-say-it-s-all-about-how-you-finish-d0203c7fbe8a#.w30umpm7t)。[我解释了它的工作方式](https://medium.com/the-traveled-ios-developers-guide/on-definitive-initialization-54284ef5c96f#.mdqytwjfr)。我做了一期讨论，阅读了大量相关内容。但是，我又回来讨论更多有关它的问题。

在 Swift 众多漂亮多样的安装方法当中————使用闭包并不是一向被推荐的方式。但是，它可以使得 boilerplatey**™** init() 的代码故障更少，可操作性更强。

程序用户界面开发者们————这是给你们的🍻!

### UIKit == UIHugeSetupCode()

看，这不是 UIKits 的错。因为各种偏好设置，需要跟用户交互的组件会给它们自己增加大量的设置代码。通常，这些组件中的大部分不是在 viewDidLoad 就是在 loadView ：
```
override func loadView()
{
    let helloWorldLbl = UILabel()
    helloWorldLbl.text = NSLocalizedString(“controller.topLbl.helloWorld”, comment: “Hello World!”)
    helloWorldLbl.font =   UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    helloWorldLbl.textColor = UIColor.whiteColor()
    helloWorldLbl.textAlignment = .Center
    self.view.addSubview(helloWorldLbl)
}
```

眼下，这对于我们中尝试脱离 .xib 或 .storyboard 使用 Cocoa Touch Waters 的人来说是稀松平常的事。不过，如果你和我一样我对微小 viewDidLoad 或  loadView 方法十分喜爱，你可以把它放在其他地方。

比如，一个属性：

```
let helloWorldLbl:UILabel = {
    let lbl = UILabel()
    lbl.text = NSLocalizedString(“controller.topLbl.helloWorld”, comment: “Hello World!”)
    lbl.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    lbl.textColor = UIColor.whiteColor()
    lbl.textAlignment = .Center
    return lbl
    }()
```

的确。在 Apple 自己的 Swift 书当中指出“ 如果你的属性的默认值需要一些定制或者配置，你可以利用闭包或者全局函数为属性提供默认值”。 正如我们刚才提到的，UIKit 产生大量的定制和配置。

不过，其中一个漂亮的副产品就是 loadView 现在的样子：
```
override func loadView
{
    self.view.addSubview(self.helloWorldLbl)
    }
```

然而，注意到 “()”  在属性声明的闭包末端。这样让编译你代码的 Swift 程序了解到这个实例已经被分配给了  _return_  类型的闭包。如果我们忽略这个，就有可能将实例分配给闭包本身。

这个例子当中，那是 🙅.

### 规则，还是规则！

即使我们有一个崭新的新玩具，记住这里的规则也是十分重要的。因为我们在将一个属性赋给一个闭包，而其他它所包含的实例很可能还没有被初始化。因此，在闭包执行时，它不可能引用其他属性值或者从自身引用：

例如：

```
let helloWorldLbl:UILabel = {
    let lbl = UILabel()
    lbl.text = self.someFunctionToDetermineText() //Compiler error
    lbl.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    lbl.textColor = self.myAppTheme.textColor() //Another error
    lbl.textAlignment = .Center
    return lbl
    }()
```

自我的实例可能还不能安全地被使用，或者它可能无法通过 Swift 两相初始化过程。任何实例属性也都会这样，而不会简单地由分配和初始化从闭包实施后立即执行。

这是一个独特的，但需要使用闭包初始化的缺点。这是非常重要的，不过也就在符合这三个快速的设计目标之一：安全。

### 用集合变得可爱

我发现，这种技术特别有用的一个领域是实例，它代表 Swift 里许多不同形式的集合之一。Swift 许多才能当中，像使用 1000 个站立泰坦的力量一样的强大性能，从集合中进行分离和筛选的处理是我最喜欢的功能之一。

考虑下面的例子，是从我目前运行的项目中提取的构造器。安置代码的类具有一个开发者属性。重启之后，在一个 .plist  文件当中设置初始化值。之后，这些就通过 NSKeyedArchiver 保存了起来。

```
guard let devs = NSKeyedUnarchiver.unarchiveObjectWithFile(DevDataManager.ArchiveURL.path!) as? [Developer] else
{
    self.developers = {
        let pListData = //Get plist data
        var devArray:[Developer] = [Developer]()
        //Set up devArray from plist data
        return devArray.map{ $0.setLocation() }
                       .filter{ $0.isRentable }
                       .sort{ $0.name < $1.name }
     }()
    return
}
self.developers = devs
```

我相当喜欢这种方法，因为构造器之外即使我们没有用它，代码意图也相当的明确，它就只是负责设置属性。

随着构造器和 viewDidLoad 覆盖范围变大，(至少）这样的事件拆分对于可读性而言是十分受欢迎的。

### 获取  NSCute 


如果你只是真的用闭包挖掘初始化的东西，但是严重受限于代码中那些功能化  $ 的缺失，振作起来。利用一些内行的 Swiftery ，一个人可以创建一个闭包本身内的一些推断类型的代码，那会生成一些专业的风格设计。思考下这个代码，我在一直提供信息的 [NSHipster](http://nshipster.com/new-years-2016/): 当中我经常碰到。

```
@warn_unused_result
public func Init<Type>(value : Type, @noescape block: (object: Type) -> Void) -> Type
{
    block(object: value)
    return value
}

```


我喜欢这种方式。一个公共函数，它需要一个闭包与使用泛型类型的对象，这意味着你可以转而用更多类型信息初始化的东西。反过来我们的第一个代码示例将会像这样

```
let helloWorldLbl = Init(UILabel()) {
    $0.text = NSLocalizedString(“controller.topLbl.helloWorld”, comment: “Hello World!”)
    $0.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    $0.textColor = UIColor.whiteColor()
    $0.textAlignment = .Center
}
```

尽管看起来很神奇，它确实让我们在闭包中不再需要使用实例变量，也去掉了所需的（）。很棒 👏.。

### 最后的想法

有人说用这种技术是多此一举。尽管程序员处理的代码行数还是那么庞大，我需要强调的是场景和灵活性使之成为理想的环境。

这是搞定项目的一个有意思的办法，还有许多可以用我们的老朋友 Objective-C 处理同样事情的办法。不过你看，你懂的越来越多了，我说的对吧？

Until nextWeek = { let week = Week() week.advancedBy(days: 7) }()
