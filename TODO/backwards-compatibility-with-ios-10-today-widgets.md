> * 原文地址：[Tips for Backwards Compatibility with iOS 10 Today Widgets](https://kristina.io/backwards-compatibility-with-ios-10-today-widgets/)
* 原文作者：[kristina](https://kristina.io/author/kristina/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Edison Hsu](https://github.com/edison-hsu)
* 校对者：

# iOS 10 今日控件向后兼容的几个技巧
看看今日控件在过去的一些年中如何变得越来越重要是一件很有趣的事。首次出现在 iOS 8，今日控件并没有得到高度欢迎，并且在通知中心与错过的通知结合在一起。然而，在 iOS 10，今日控件彻底的改变了，完全接管主屏幕的左滑项，这过去常常被用作「滑动解锁」。在外观方面也从一个深色主题转变为一个珍珠白。

对于开发者不幸的是，如果你喜欢我的团队，并且还不能完全放弃对 iOS 10 以下的支持，那么你不得不解决完美支持两种外观风格，和一些其他在初看时不明显的东西。我最近参加了这个 [QuickBooks Self-Employed](https://quickbooks.intuit.com/self-employed/) 今日控件的改造－这有一些需要注意事项：

### 支持两种主题

![iOS 9 today widget](https://i1.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.37.05-PM.png?resize=300%2C200&ssl=1%20300w,%20https://i1.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.37.05-PM.png?resize=400%2C266&ssl=1%20400w,%20https://i1.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.37.05-PM.png?w=618&ssl=1%20618w)

iOS 9 的今日控件



![iOS 10 today widget](https://i2.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.43.07-PM.png?resize=300%2C213&ssl=1%20300w,%20https://i2.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.43.07-PM.png?resize=400%2C284&ssl=1%20400w,%20https://i2.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.43.07-PM.png?w=611&ssl=1%20611w)

iOS 10 的今日控件



Let’s start with the obvious one. You’ll either need to build two different interfaces for versions lower than iOS 10 as well as iOS 10+, or make sure that a single interface is compatible with both dark and light backgrounds. We ended up solving this by building one interface, but displaying light and dark text and background colors for our view elements depending on which version of iOS we were on. We also made sure that any image assets or colored text looked good on both backgrounds. Modifying the image tint color proved to be useful here.
让我们从明显的开始。你可以构造两个不同的界面，一个用在小于 iOS 10 的版本另一个用于iOS 10+ 的版本，或者确认一个单独的界面能够同时兼容深色和亮色背景。最后，我们通过构建一个界面来解决这个问题，但是对于我们视图的元素最终显示亮色还是深色的本文和背景色，这取决于在什么版本的 iOS 上运行。我们也确认任何图片资源或者有颜色的文本在两种背景下看起来都不错。修改图片的着色（tint color）在这被证明是有效的。

    //Swift
    var image = UIImage(named: "imageName");
    image = image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
    let imageView = UIImageView(image: image)
    imageView.tintColor = UIColor.blue

    //Objective-C
    UIImage *image = [UIImage imageNamed:@"imageName"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.tintColor = [UIColor blueColor];

### 居中控件

![Off-center iOS 9 widget](https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.19.27-PM.png?resize=300%2C293&ssl=1%20300w,%20https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.19.27-PM.png?w=378&ssl=1%20378w)

这有一个不怎么明显的问题 － iOS 9 的今日控件有轻微的居中偏移。如果你关注点在图片的上面，你可以看到上面的 `UITableView` 并不是水平居中于他的空间。除非你想要为 iOS 9 的今日控件做细微的调整，我建议设置边距（margin），允许你能够使用全部被分配的空间宽度，这与 iOS 10 上的默认保持一致。

    //Swift
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0,0,0,0);
    }

    //Objective-C
    - (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
        //centers widget for iOS 9
        return UIEdgeInsetsMake(0,0,0,0);
    }

注意：`widgetMarginInsetsForProposedMarginInsets` 是技术弃用的并且在 iOS 10　及以上的版本不会被调用。

### 在扩展模式中丧失功能

![Compact mode](https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.42-PM.png?resize=300%2C120&ssl=1%20300w,%20https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.42-PM.png?resize=400%2C160&ssl=1%20400w,%20https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.42-PM.png?w=611&ssl=1%20611w)

紧密模式



![Expanded Mode](https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.32-PM.png?resize=300%2C158&ssl=1%20300w,%20https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.32-PM.png?resize=400%2C210&ssl=1%20400w,%20https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.32-PM.png?w=612&ssl=1%20612w)

扩展模式



iOS 10 增加了一个可选的扩展模式，这可以用来增加额外的功能和控件的不动产。这是超级有用的，比如高级用户功能或者一些用户也许不想一直显示在主屏幕的东西（例如私人的或者财产信息）。你可以在 ViewDidLoad 中通过一行代码开启扩展模式：

    //Swift
    self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded

    //Objective-C
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;

然而，在 iOS 9 上这基本会破坏你的扩展，所以你实际上需要封装一下来确保仅在支持的显示模式下设置。

    //Swift
    let extensionContext = NSExtensionContext()
    if #available(iOS 10.0, *) {
        extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
    }

    //Objective-C
    if ([self.extensionContext respondsToSelector:@selector(setWidgetLargestAvailableDisplayMode:)]) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }

扩展模式还有一个事情需要考虑，那就是如果你不设置控件的高度属性，任何仅在扩展模式（超过 110 px）下显示的东西将会在 iOS 9 及以下的版本被切掉。为了解决这个问题，你需要确认你设置了控件的 preferredContentSize 高度，以至于它包含任何超过 110 px 的内容。谢谢 Greg Gardner 指出这点！
