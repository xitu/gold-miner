>* 原文链接 : [Shaving Our Image Size](http://engineering.dollarshaveclub.com/shaving-our-image-size/?utm_campaign=iOS%2BDev%2BWeekly&utm_medium=email&utm_source=iOS_Dev_Weekly_Issue_247)
* 原文作者 : [DALTON CHERRY](https://github.com/daltoniam)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : 
* 校对者:


Displaying images is a key way we communicate our products to our users. The old saying, "A picture is worth a thousand words" holds true. An image can often communicate what words cannot. Images, of course, bring up a host of technical challenges that are prominent on mobile devices due to their potentially lower bandwidth and limited resources.

One of the unique challenges we face at DSC is the need for a transparent alpha channel in our product images. We have beautiful wood backgrounds throughout our apps and displaying images on top of these requires an image format that has a transparent alpha channel. The most common choice on iOS is the PNG format. The PNG format looks great, loads very quickly, and is natively supported on iOS. One major drawback is that image sizes tend to be very large for our high fidelity product images. Many of these product images are several megabytes in size and we have hundreds of images in our app.

We've developed a WebP view for iOS apps. You can find it [on Github](https://github.com/dollarshaveclub/ImageButter).

![Alt](http://engineering.dollarshaveclub.com/assets/images/articles/2016-04-07-shaving-our-image-size/img-comp.png)

## A Little Background

The amount and size of these PNG formatted images require that we either compress them in the app before we submit to the App Store or download them after the app is installed. Both of these presented different trade-offs. One required that we decompress the assets before being able to display them and the other required that we download several hundred MB over a potentially slow internet connection. We ended up choosing the compression option for the first release of our app. This, of course, saved a good deal of bandwidth, but still inflated the app size to almost 230 MB after install. Fortunately, the story doesn’t end there, and (drum roll…) we were able to shave the size of our images.

## Shaving Size

We needed an image format that supported a transparent alpha channel and could be smaller then our PNG images. We came across the [WebP](https://developers.google.com/speed/webp) format by Google. Our testing showed that the WebP-formatted images were 10x smaller than their PNG counterparts, and they still supported a transparent alpha channel. This saved bandwidth when downloading new images and disk space when caching images. The major concession was that the WebP images took much longer to decode, and iOS doesn’t natively support the format. We felt that the reduction in size was worth the extra decode time, so we got to work on building a WebP image viewer for iOS.

We started out by building the WebP C source code as a framework (much like a Swift framework). We then used the WebP C APIs coupled within an Objective-C class (a Swift version is in the works!) to create a class we call `WebPImage`. We then use `WebPImage` much like you would use the standard `UIImage` class. The major difference is the `WebPImage` asynchronously decodes the WebP image data as a workaround for the slow decoding time. It also supports all the native iOS formats, like PNG and JPEG, and a few non-standard ones, like animated GIFs and animated WebPs, since we have amazing animated images in our app as well.

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

We then created a `WebPImageView` that worked like a `UIImageView` with a few enhancements. It supports URLs to remotely load cached images and an optional progress dialog as it downloads and decodes the image. This allows us to use our `WebPImageView` throughout our app in place of a `UIImageView`, get all the advantages of the WebP format, and have a “network enabled” image viewer.

## Conclusion

![Alt](http://engineering.dollarshaveclub.com/assets/images/articles/2016-04-07-shaving-our-image-size/image-size-graph.png)

We were able to shave the size of our app from 230 MB of images in our first app release to just about 30 MB as of this writing, which includes far more images than the first release. This resulted in a **size reduction of over 7 times using the WebP format**. It required that we replicate and enhance some of the existing UI components in iOS and create a process of converting our images from PNG to WebP on deployment, but we believe the outcome illustrates the value of this effort. This allows us to provide an experience to our iOS users that is both forgiving to their data plan and respectful of their device storage. Dollar Shave Club, shaving the world by shaving our image sizes.
