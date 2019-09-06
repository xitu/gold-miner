> * 原文地址：[Writing a dumb icon flutter package](https://medium.com/flutter-community/writing-a-dumb-icon-flutter-package-9682d949002f)
> * 原文作者：[Rishi Banerjee](https://medium.com/@rshrc)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-dumb-icon-flutter-package.md](https://github.com/xitu/gold-miner/blob/master/TODO1/writing-a-dumb-icon-flutter-package.md)
> * 译者：
> * 校对者：

# Writing a dumb icon flutter package

![](https://cdn-images-1.medium.com/max/2160/1*FJoGGIBlEwKu-35DE2DMTw.png)

When all the flutter developers are making real-life mobile applications that can be used by **thousands** in their daily life, there sits my **dumb lazy ass** in the room thinking, **“what if there is yet another font package for flutter?”** 🤔

It was a pretty normal day, **3 A.M** in the morning, browsing the internet in search of good quality **extra dark memes** that I can share with a few people to give them the assurance that **yes, I am not normal**. Since GitHub is the new social media I stumbled across this **“CSS”** repository which had been starred by one of the best programmers in our college. I was like, **“hmm, let’s dive deeper into this, see how these fonts are made in the first place”**

After a few minutes of scanning through the files inside the source folder I remembered how once, I used an open-source icon package named [**EvaIcons.**](https://pub.dev/packages/eva_icons_flutter) So, I Went to the GitHub repository of that package and started reading their code. Fairly simple structure, unlike the other complicated flutter packages. The question was, should I watch a flutter tutorial on how to make **font/icons** from CSS and port it to flutter? or should I just go with it and see if copying teeny tiny bits of code works?

## Getting Started 🏁

The first thing you need to do is find an open-source repository of icons that has a **“.ttf”** file in it. **What is “.ttf”?**

> A **TTF** file is a font file format created by Apple, but used on both Macintosh and Windows platforms. It can be resized to any size without losing quality and looks the same when printed as it does on the screen. The **TrueType** font is the most common font format used by both Mac OS X and Windows platforms. Well I don’t know if any other format like “**.svg”, “.eot” or “woff”** would work or not.

I found this open-source CSS icon package on GitHub named [weather-icons](https://github.com/erikflowers/weather-icons). A collection of **222 beautifully crafted weather themed icons**. **Pretty Dope!**

## The Flutter Package 📦

Time to create the flutter package. We can use the **old** and **dumb** way of creating a package using the Android Studio method of selecting package instead of application or use this really cool command line technique.

```bash
flutter create --template=package your_awesome_package_name
```

Bam! 💥💥 We are half way through now. Not much to cover.

## Next Step 🤔

Create an **assets/** folder and place the **\<font_name>.ttf** file inside there. Time to configure the **pubspec.yaml** file so that we can use the icons inside our dart files.

![Add the fonts like this, replacing WeatherIcons with MyAwesomeIcons or whatever suits :)](https://cdn-images-1.medium.com/max/2680/1*WOTZNBPEvxbjcQIukcIrTA.png)

Great work comrade! **Now we can focus on the dart code.**

## The Hard Way 😓

Create a **src/** folder inside the **lib/** directory. Inside that create a simple file aptly named **icon_data.dart**. What goes in there? The Icon Data. **Good guess!**

![Your custom IconData class extending the one which is available in the widgets library.](https://cdn-images-1.medium.com/max/2584/1*0xg1ub7O-uVkAZh041V0gQ.png)

We have a constructor which takes in a value **‘codePoint’** which is just the hexadecimal code for the icon. Will see something regarding it real soon.

This was not hard? Then what was?

![Huff! We can’t write this all by ourselves. 222 codePoints!!](https://cdn-images-1.medium.com/max/2776/1*6NvoCM7PiUp8yCwb-zmoBQ.png)

## The Easy Way 🤩

We first find an appropriate JSON file which has all the hex codes along with the names. Find it, or create one using web scraping. I did not do this part, it was done by [**Nikhil**](https://github.com/muj-programmer). A simple JS web scraper. We generated a file which looked something like this.

![Yupp! Cool as hell!](https://cdn-images-1.medium.com/max/2648/1*nipzxL9Nf_xncVp2PFGlEQ.png)

Time to write a dart code which can parse this JSON and create that infamous **flutter_weather_icons.dart** file inside the lib/ folder.

We will need the **dart:convert**, **dart:io** (part of the standard library) and the **recase** package. All of these are needed for JSON decoding, file I/O and converting **‘wi-day-sunny’** to **‘wiDaySunny’** that can be used normally inside the flutter code.

![Not the complete code for font generation](https://cdn-images-1.medium.com/max/4024/1*Lur-jr2_rLV7q2MrxKuYaA.png)

The compete code for **font_generation** can be found [here](https://github.com/rshrc/flutter_weather_icons/blob/master/tool/generate_fonts.dart).

Done I guess. This will generate a file which in all it’s beauty will look something like this.

![Find the complete code [here](https://github.com/rshrc/flutter_weather_icons/blob/master/lib/flutter_weather_icons.dart)](https://cdn-images-1.medium.com/max/3288/1*jov1G7ySHJYIXaP2ukoI9A.png)

Discovering this made both me and Nikhil make a bunch of font icon sets. **Quite the marathon.**

Find and test the fonts at the following links [weather icons](https://github.com/rshrc/flutter_weather_icons), [brand icons](https://github.com/muj-programmer/flutter_brand_icons), [icomoon icons](https://github.com/rshrc/flutter_icomoon_icons) and [feather icons](https://github.com/muj-programmer/flutter_feather_icons) 🎉

If you like our code do consider **starring** them 🌟 or maybe **clap** this article 👏 or maybe if you are an epic person then **follow** us on GitHub ❤️.

Good times, see you again!
[**Flutter Community (@FlutterComm) | Twitter**
**The latest Tweets from Flutter Community (@FlutterComm). Follow to get notifications of new articles and packages from…**www.twitter.com](https://www.twitter.com/FlutterComm)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
