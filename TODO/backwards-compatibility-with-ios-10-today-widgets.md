> * 原文地址：[Tips for Backwards Compatibility with iOS 10 Today Widgets](https://kristina.io/backwards-compatibility-with-ios-10-today-widgets/)
* 原文作者：[kristina](https://kristina.io/author/kristina/)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：

# Tips for Backwards Compatibility with iOS 10 Today Widgets
It’s been really interesting seeing how prominence for today widgets have changed over the past couple of years. First introduced in iOS 8, today widgets weren’t given a very high place of honor and were coupled with missed notifications within Notification Center. However, in iOS 10, emphasis on today widgets has drastically changed, completely taking over the swipe-left option on the home screen that used to belong to “Slide to unlock.” They also received quite the transformation in terms of their appearance going from a dark theme to a pearly white now.

Unfortunately for developers, if you’re like my team and can’t drop support for iOS versions below 10 quite yet, you have to figure out how to best support both styles of appearance, as well as a few other things that aren’t obvious at first glance. I recently went through this transformation with the [QuickBooks Self-Employed](https://quickbooks.intuit.com/self-employed/) today widget – here’re some things to watch out for:

### Supporting Both Themes

![iOS 9 today widget](https://i1.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.37.05-PM.png?resize=300%2C200&ssl=1%20300w,%20https://i1.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.37.05-PM.png?resize=400%2C266&ssl=1%20400w,%20https://i1.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.37.05-PM.png?w=618&ssl=1%20618w)

iOS 9 today widget



![iOS 10 today widget](https://i2.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.43.07-PM.png?resize=300%2C213&ssl=1%20300w,%20https://i2.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.43.07-PM.png?resize=400%2C284&ssl=1%20400w,%20https://i2.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-4.43.07-PM.png?w=611&ssl=1%20611w)

iOS 10 today widget



Let’s start with the obvious one. You’ll either need to build two different interfaces for versions lower than iOS 10 as well as iOS 10+, or make sure that a single interface is compatible with both dark and light backgrounds. We ended up solving this by building one interface, but displaying light and dark text and background colors for our view elements depending on which version of iOS we were on. We also made sure that any image assets or colored text looked good on both backgrounds. Modifying the image tint color proved to be useful here.

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

### Centering Widget

![Off-center iOS 9 widget](https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.19.27-PM.png?resize=300%2C293&ssl=1%20300w,%20https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.19.27-PM.png?w=378&ssl=1%20378w)

Now here’s one thing that’s not so obvious – the slight center offset of iOS 9 today widgets. If you notice on the image above, you can see that the `UITableView` above is not centered horizontally in the middle of its space. Unless you feel like making slight adjustments for your iOS 9 today widget, I’d suggest setting the margins so that they allow you to use the entire width of the allocated space, matching what is default in iOS 10.

    //Swift
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -&gt; UIEdgeInsets {
        return UIEdgeInsetsMake(0,0,0,0);
    }

    //Objective-C
    - (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
        //centers widget for iOS 9
        return UIEdgeInsetsMake(0,0,0,0);
    }

Note: `widgetMarginInsetsForProposedMarginInsets` is technically deprecated and will not get called on versions iOS 10 and above.

### Lost Features in Expanded Mode

![Compact mode](https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.42-PM.png?resize=300%2C120&ssl=1%20300w,%20https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.42-PM.png?resize=400%2C160&ssl=1%20400w,%20https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.42-PM.png?w=611&ssl=1%20611w)

Compact mode



![Expanded Mode](https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.32-PM.png?resize=300%2C158&ssl=1%20300w,%20https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.32-PM.png?resize=400%2C210&ssl=1%20400w,%20https://i0.wp.com/kristina.io/wp-content/uploads/2016/10/Screen-Shot-2016-10-16-at-5.31.32-PM.png?w=612&ssl=1%20612w)

Expanded mode



iOS 10 added an optional expanded mode to add additional functionality and real estate to widgets. This is super useful in the case of power user features or something that the user might not want to show on their home screen all the time (e.g. personal or financial information). You can set this using this line of code in your viewDidLoad:

    //Swift
    self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded

    //Objective-C
    self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;

However, this basically breaks your extension in iOS 9, so you’ll actually need to wrap it to make sure it’s only set if modifying the display mode is supported.

    //Swift
    let extensionContext = NSExtensionContext()
    if #available(iOS 10.0, *) {
        extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
    }

    //Objective-C
    if ([self.extensionContext respondsToSelector:@selector(setWidgetLargestAvailableDisplayMode:)]) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    }

Probably the most important thing to consider with expanded mode is that anything that only shows in expanded mode is NOT shown in iOS 9 or below. That means anything beyond 110 px on your today widget is cut off. That leaves two options, either you can create a different interface for your iOS 9 and below widgets, or you can just let your users miss out on some functionality in your today widget. The choice is up to you. For QuickBooks Self-Employed, we ended up leaving only the top portion of our widget available to users in iOS 9, giving them even more of a reason to upgrade 😉