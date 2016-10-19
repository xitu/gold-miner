>* 原文链接 : [Shaving Our Image Size](http://engineering.dollarshaveclub.com/shaving-our-image-size/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS_Dev_Weekly_Issue_247)
* 原文作者 : [DALTON CHERRY](https://github.com/daltoniam)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [circlelove](https://github.com/circlelove)
* 校对者: [rockzhai](https://github.com/rockzhai) ，  [ldhlfzysys](https://github.com/ldhlfzysys)

# 使用 webP 减少图片的大小

图片是我们给用户展示产品的利器。老话说的好，“一图胜千言”！图像往往能表达出语言所不能及的含义。当然，由于移动设备带宽和资源限制，图片也带来了一系列突出的技术挑战。

我们在 DSC 上面临的技术挑战就是产品图像对于透明 alpha 通道的需求。我们已经在 app 上采用了美丽的仿木背景，此外还需要采用带有透明 alpha 通道的格式。最常见的 ios 系统图片格式是 PNG 格式。PNG 格式看上去很不错，加载也快，支持原生 iOS 。
一个主要的缺点是，我们的高保真度的产品图片尺寸都很大。许多这些产品图片是几兆字节的大小，而我们的的应用程序有数百幅的图像。

我们为之开发了一个 WebP 视图控件为 iOS 应用来查看图片。 你可以在[on Github](https://github.com/dollarshaveclub/ImageButter). 找到它。


![Alt](http://engineering.dollarshaveclub.com/assets/images/articles/2016-04-07-shaving-our-image-size/img-comp.png)

## 一个小的背景

我们在提交 APP 到应用商店和在应用商店下载 APP 的时候都需要上传或下载这些大量的 PNG 格式的大图。这些显示的是不同的方案。一个需要我们在展示之前解压，另一个可能需要我们通过慢吞吞的网络去下载几百兆资源图片。 我们最终决定为我们第一个发行版选择压缩的方式。当然，这省下了大量带宽，却依然让这款 APP 安装后的大小高达230 MB。 幸运的是，这个故事并没有结束， （咚咚咚咚。。。。一连串鼓声表示到了精彩部分），我们还能够减小图片的尺寸。

## 消减尺寸
我们需要一个支持透明 alpha 通道而且比 PNG 小的图片格式。偶然发现了 Google 的 [WebP](https://developers.google.com/speed/webp)  。经过我们的测试显示 WebP 格式化的图片仅有原来 PNG 参考版本的十分之一大小，他们也同样支持透明 alpha 通道。这样就在下载和缓存新图片的时候省下来带宽和磁盘空间。其主要的不足在于 WebP 图片需要更长的解码，而 iOS 原生系统并不支持这种格式。我们感觉图片大小的减少值得花更长时间解码，于是致力于为 iOS 构建一个 WebP 图片查看器。

我们开始开发 WebP 的 C 程序源代码作为框架（其实更像是 Swift 框架）。之后利用 WebP C API 耦合在一个 Object-C 的类当中（一个Swift 的版本是在工作中！）来创建一个叫做 `WebPImage` 的类。之后用 `WebPImage`更像是在利用标准 `UIImage` 类。主要的不同在于 `WebPImage`是解决缓慢异步解码 WebP 图片数据的。它同时支持所有原生 iOS 格式，像 PNG 和 JPEG ，还有一些非标准的，例如动态 GIF 和 WebP 图片数据的，因为我们的 app 当中也有惊艳的动态图像。


    WebPImageView *imgView = [[WebPImageView alloc] initWithFrame:CGRectMake(0, 30, 300, 300)];
    [self.view addSubview:imgView];
    imgView.url = [NSURL URLWithString:@"https://yourUrl/imageName@3x.webp"];

    // Add the loading View.
    WebPLoadingView *loadingView = [[WebPLoadingView alloc] init];
    loadingView.lineColor = [UIColor orangeColor];
    loadingView.lineWidth = 8;

    // Add the loading view to the imageView.
    imgView.loadingView = loadingView;

    // If you want to add some inset on the image.
    CGFloat pad = 20;
    imgView.loadingInset = UIEdgeInsetsMake(pad, pad, pad*2, pad*2);

你可以[在github里面找到上述代码](https://github.com/dollarshaveclub/ImageButter)

之后我们创建了 `WebPImageView` ，也就是功能升级了的 `UIImageView` 。它提供远程缓存图片和下载解码进度条的 URL 。这样我们就可以用我们的 `WebPImageView`  替换所有的 `UIImageView` ，充分利用 WebP 格式的优势，进行“网络可用”的图片查看。


##结论
![Alt](http://engineering.dollarshaveclub.com/assets/images/articles/2016-04-07-shaving-our-image-size/image-size-graph.png)

截至文章写作时，我们可以将首次发行的 app 从230 MB 减小到仅有30 MB，里面还包含了更多的图片。这样的结果使得 **利用 WebP 格式压缩了七倍以上的尺寸** 。这需要我们复制和提交一些 iOS 已有的 UI 组件并创建 PNG 转换为 WebP 展开的进程，但是我们相信结果说明了我们努力的一切。我们就可以为 iOS 用户提供良好的体验，既满足他们的数据计划，又尊重了他们的存储需求。Dollar Shave Club ，减小图片来减小世界。
