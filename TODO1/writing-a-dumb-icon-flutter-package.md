> * 原文地址：[Writing a dumb icon flutter package](https://medium.com/flutter-community/writing-a-dumb-icon-flutter-package-9682d949002f)
> * 原文作者：[Rishi Banerjee](https://medium.com/@rshrc)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-dumb-icon-flutter-package.md](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-dumb-icon-flutter-package.md)
> * 译者：[YueYong](https://github.com/YueYongDev)
> * 校对者：[Mononoke](https://github.com/imononoke)

# 写一款小众的 flutter 图标包

![](https://cdn-images-1.medium.com/max/2160/1*FJoGGIBlEwKu-35DE2DMTw.png)

当所有的 flutter 开发人员都在制作可以在日常生活中被**成千上万**人使用的移动应用程序时，我**呆坐**在房间里，不禁陷入沉思，**为何不做一款 flutter 的图标包呢** 🤔

和平常一样，**凌晨 3 点**。我在网上搜索高质量的黑色主题包，想分享给一部分人，让他们觉得“**嗯，你真厉害**”。鉴于 GitHub 是新的社交媒体，我偶然发现了一个 **“CSS”** 库，我们学校最棒的一个程序员都曾给它点过赞（starred）。心想 **“不妨深入地研究一下，看看这些字体是如何制作的。”**

在浏览了几分钟资源文件夹中的文件后，我回想起有一次，我使用了一个名为 [**EvaIcons**](https://pub.dev/packages/eva_icons_flutter) 的开源图标包。我访问了该包的 GitHub 地址，并开始阅读它的源码。和其他复杂的 flutter 包不同的是，这个 package 的结构相当简单。问题是，我应该看一个关于如何从 CSS 创建**字体/图标**并将其移植到 flutter 的教程吗？还是说我应该直接使用它，然后移植一小段代码看看是否有效?

## 开始 🏁

你需要做的第一件事就是找到一个包含 **“.ttf”** 文件的开源图标库。**那 “.ttf” 是什么文件？**

> **TTF** 文件是由苹果公司创建的一种字体文件格式，但可以同时运行在 Macintosh 和 Windows 平台上。它可以调整到任何大小并且不会失真，而且打印出来的效果和在屏幕上显示的看起来是一样的。**TrueType** 字体是 Mac OS X 和 Windows 上最常用的字体格式。我不知道其他类似的格式如 **“.svg”, “.eot” 或者 “.woff”** 是否都可以使用。

我在 GitHub 上发现了一个名为 [weather-icons](https://github.com/erikflowers/weather-icons) 开源 CSS 图标库。这是一个包含了 **222 个精美天气主题的图标库**。

## Flutter 包 📦

是时候来创建一个 flutter package 了。我们可以通过使用 Android Studio 这种**老套**而又略显**笨拙**的方法来创建一个 package，或者执行下面这个非常酷的命令。

```bash
flutter create --template=package your_awesome_package_name
```

砰! 💥💥 我们已经完成了一半。这些没什么好讲的。

## 下一步 🤔

创建一个 **assets/** 文件夹，并将 **\<font_name>.ttf** 文件放在其中。接下来我们来配置 **pubspec.yaml** 文件。这样我们就可以在我们的 dart 文件中使用图标了。

![Add the fonts like this, replacing WeatherIcons with MyAwesomeIcons or whatever suits :)](https://cdn-images-1.medium.com/max/2680/1*WOTZNBPEvxbjcQIukcIrTA.png)

终于迈出了伟大的一步！**现在我们来关注一下 dart 代码。**

## 难点 😓

在 **lib/** 目录中创建一个 **src/** 文件夹。并在其中创建一个名为 **icon_data.dart** 的文件。文件里面该写些什么？**猜的不错！** 我们需要在里面放入图标的数据。

![Your custom IconData class extending the one which is available in the widgets library.](https://cdn-images-1.medium.com/max/2584/1*0xg1ub7O-uVkAZh041V0gQ.png)

我们编写了一个构造函数，它接受一个值 **“codePoint”**，这个值是图标的十六进制代码。我们很快就会看到一些关于它的东西。

到目前为止都很容易？那接下来是什么呢？

![Huff! We can’t write this all by ourselves. 222 codePoints!!](https://cdn-images-1.medium.com/max/2776/1*6NvoCM7PiUp8yCwb-zmoBQ.png)

## 容易的一步 🤩

我们首先找到一个合适的 JSON 文件，他包含所有十六进制代码和名称。找到它，或者使用 web 抓取一个。这部分不是我做的，是 [**Nikhil**](https://github.com/muj-programmer) 做的。这是一个简单的 JS web 爬虫。我们利用它生成了一个类似的文件。

![Yupp! Cool as hell!](https://cdn-images-1.medium.com/max/2648/1*nipzxL9Nf_xncVp2PFGlEQ.png)

接下来我们需要在 lib/ 文件夹下创建一个 **flutter_weather_icons.dart** 来编写 dart 代码来解析这个 JSON 了。

我们需要使用到 **dart:convert**、**dart:io**（标准库的一部分）和 **recase** 包。所有的这些都是为 JSON 解码、文件 I/O 和将 **“wi-day-sunny”** 转换为 **“wiDaySunny”** 所准备的，以便于这些都可以在 flutter 代码中正常使用。

![Not the complete code for font generation](https://cdn-images-1.medium.com/max/4024/1*Lur-jr2_rLV7q2MrxKuYaA.png)

你可以在[这里](https://github.com/rshrc/flutter_weather_icons/blob/master/tool/generate_fonts.dart)找到 **font_generation** 的完整代码

和我想的一样。这将生成一个看起来像下面这样的文件。

![Find the complete code [here](https://github.com/rshrc/flutter_weather_icons/blob/master/lib/flutter_weather_icons.dart)](https://cdn-images-1.medium.com/max/3288/1*jov1G7ySHJYIXaP2ukoI9A.png)

发现这一点后，我和 Nikhil 都做了一堆字体图标包。

在以下链接找到并测试我们的字体 [weather icons](https://github.com/rshrc/flutter_weather_icons), [brand icons](https://github.com/muj-programmer/flutter_brand_icons), [icomoon icons](https://github.com/rshrc/flutter_icomoon_icons) 和 [feather icons](https://github.com/muj-programmer/flutter_feather_icons) 🎉

如果你喜欢我们的代码和文章，可以**点赞🌟、收藏👏**，或者在 GitHub 上**关注**我们。

我们下次再见！[Flutter Community (@FlutterComm) | Twitter****The latest Tweets from Flutter Community (@FlutterComm). Follow to get notifications of new articles and packages from…**www.twitter.com](https://www.twitter.com/FlutterComm)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
