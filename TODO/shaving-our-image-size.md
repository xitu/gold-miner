>* 原文链接 : [Shaving Our Image Size](http://engineering.dollarshaveclub.com/shaving-our-image-size/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS_Dev_Weekly_Issue_247)
* 原文作者 : [DALTON CHERRY](https://github.com/daltoniam)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [circlelove](https://github.com/circlelove)
* 校对者:

使用 webP 减少图片的大小

Displaying images is a key way we communicate our products to our users. The old saying, "A picture is worth a thousand words" holds true. An image can often communicate what words cannot. Images, of course, bring up a host of technical challenges that are prominent on mobile devices due to their potentially lower bandwidth and limited resources.
图片是我们给用户展示产品的利器。老话说的好，“一图胜千言”！图像往往能表达出语言所不能及的含义。当然，图片也带来很多由于设备带宽和资源限制的技术挑战。

One of the unique challenges we face at DSC is the need for a transparent alpha channel in our product images. We have beautiful wood backgrounds throughout our apps and displaying images on top of these requires an image format that has a transparent alpha channel. The most common choice on iOS is the PNG format. The PNG format looks great, loads very quickly, and is natively supported on iOS. One major drawback is that image sizes tend to be very large for our high fidelity product images. Many of these product images are several megabytes in size and we have hundreds of images in our app.
 我们在 DSC 上面临的技术挑战就是产品图像对于透明 alpha 通道的需求。我们已经在 app 上采用了美丽的仿木背景，其顶端需要采用带有透明 alpha 通道的格式。最常见的 ios 系统图片格式。PNG 格式看上去很不错，下载也快，支持原生 iOS 。
一个主要的缺点是，图像尺寸都很大，我们的高保真度的产品图片。许多这些产品图片是几兆字节的大小，而我们的的应用程序有数以百计的图像。
We've developed a WebP view for iOS apps. You can find it [on Github](https://github.com/dollarshaveclub/ImageButter).
我们为之开发了一个 WebP 为 ios 应用来查看图片。 你可以在[on Github](https://github.com/dollarshaveclub/ImageButter). 找到它。


![Alt](http://engineering.dollarshaveclub.com/assets/images/articles/2016-04-07-shaving-our-image-size/img-comp.png)

## A Little Background
## 一个小的背景

The amount and size of these PNG formatted images require that we either compress them in the app before we submit to the App Store or download them after the app is installed. Both of these presented different trade-offs. One required that we decompress the assets before being able to display them and the other required that we download several hundred MB over a potentially slow internet connection. We ended up choosing the compression option for the first release of our app. This, of course, saved a good deal of bandwidth, but still inflated the app size to almost 230 MB after install. Fortunately, the story doesn’t end there, and (drum roll…) we were able to shave the size of our images.
PNG 格式的数量和尺寸决定了我们在提交 app 之前和下载 app 之后都需要下载它们。这些显示的是不同的方案。一个需要我们在展示之前解压，一个需要我们下载几百 MB 的可能慢吞吞的网络连接。 我们最终决定为我们第一个发行版选择压缩的方式。当然，这省下了大量带宽，却依然让这款 app 安装后的大小高达230 MB。 幸运的是，这个故事并没有结束， （咚咚咚咚。。。。一连串鼓声表示到了精彩部分），我们能够减小图片的尺寸。

## Shaving Size
消减尺寸
We needed an image format that supported a transparent alpha channel and could be smaller then our PNG images. We came across the [WebP](https://developers.google.com/speed/webp) format by Google. Our testing showed that the WebP-formatted images were 10x smaller than their PNG counterparts, and they still supported a transparent alpha channel. This saved bandwidth when downloading new images and disk space when caching images. The major concession was that the WebP images took much longer to decode, and iOS doesn’t natively support the format. We felt that the reduction in size was worth the extra decode time, so we got to work on building a WebP image viewer for iOS.
我们需要一个支持透明 alpha 通道而且比 PNG 小的图片格式。偶然发现了 Google 的 [WebP](https://developers.google.com/speed/webp)  。经过我们的测试显示 WebP 格式化的图片仅有原来 PNG 参考版本的十分之一大小，他们也同样支持透明 alpha 通道。这样就在下载和缓存新图片的时候省下来带宽和磁盘空间。其主要的不足在于 WebP 图片需要更长的解码，而 iOS 原生系统并不支持这种格式。我们感觉图片大小的减少值得花更长时间解码，于是致力于为 iOS 构建一个 WebP 图片查看器

We started out by building the WebP C source code as a framework (much like a Swift framework). We then used the WebP C APIs coupled within an Objective-C class (a Swift version is in the works!) to create a class we call `WebPImage`. We then use `WebPImage` much like you would use the standard `UIImage` class. The major difference is the `WebPImage` asynchronously decodes the WebP image data as a workaround for the slow decoding time. It also supports all the native iOS formats, like PNG and JPEG, and a few non-standard ones, like animated GIFs and animated WebPs, since we have amazing animated images in our app as well.
我们开始开发 WebP 的 C 程序源代码作为框架（其实更像是 Swift 框架）。之后利用 WebP C API 耦合在一个 Object-C 的类当中（一个Swift 的版本是在工作中！）来创建一个叫做 `WebPImage` 的类。之后用 `WebPImage`更像是在利用标准 `UIImage` 类。主要的不同在于 `WebPImage`是异步解码动态 GIF 和 WebP 图片数据的，因为我们的 app 当中也有惊艳的动态图像


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

You can [find the source code on Github](https://github.com/dollarshaveclub/ImageButter)
你可以[在github里面找到上述代码](https://github.com/dollarshaveclub/ImageButter)

We then created a `WebPImageView` that worked like a `UIImageView` with a few enhancements. It supports URLs to remotely load cached images and an optional progress dialog as it downloads and decodes the image. This allows us to use our `WebPImageView` throughout our app in place of a `UIImageView`, get all the advantages of the WebP format, and have a “network enabled” image viewer.
之后我们创建了 `WebPImageView` ，也就是功能升级了的 `UIImageView` 。它提供远程缓存图片和下载解码进度条的 URL 。这样我们就可以用我们的 `WebPImageView`  替换所有的 `UIImageView` ，充分利用 WebP 格式的优势，进行“启用网络的”的图片查看。


## Conclusion
结论
![Alt](http://engineering.dollarshaveclub.com/assets/images/articles/2016-04-07-shaving-our-image-size/image-size-graph.png)

We were able to shave the size of our app from 230 MB of images in our first app release to just about 30 MB as of this writing, which includes far more images than the first release. This resulted in a **size reduction of over 7 times using the WebP format**. It required that we replicate and enhance some of the existing UI components in iOS and create a process of converting our images from PNG to WebP on deployment, but we believe the outcome illustrates the value of this effort. This allows us to provide an experience to our iOS users that is both forgiving to their data plan and respectful of their device storage. Dollar Shave Club, shaving the world by shaving our image sizes.
我们可以讲首次发行的 app 从230 MB 减小到30 MB，里面还包含了更多的图片。这样的结果使得 ** 利用 WebP 格式压缩了七倍以上的尺寸** 。这需要我们复制和提要一些 iOS 已有的 UI 组件并创建 PNG 转换为 WebP 展开的进程，但是我们相信结果说明了我们努力的一切。我们就可以为 iOS 用户提供良好的体验，既满足他们的数据计划，又尊重了他们的存储需求。剃须刀俱乐部，减小图片来减小世界。
