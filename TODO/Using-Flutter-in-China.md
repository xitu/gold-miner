> * 原文地址：[Using Flutter in China](https://github.com/flutter/flutter/wiki/Using-Flutter-in-China)
> * 原文作者：[Flutter](https://github.com/flutter)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/Using-Flutter-in-China.md](https://github.com/xitu/gold-miner/blob/master/TODO/Using-Flutter-in-China.md)
> * 译者：
> * 校对者：

# Using Flutter in China

If you’re installing or using Flutter in China, it may be helpful to use a trustworthy local mirror site that hosts Flutter’s dependencies. To instruct the Flutter tool to use an alternate storage location, you will need to set two environment variables, `PUB_HOSTED_URL` and `FLUTTER_STORAGE_BASE_URL`, before running the `flutter` command.

Taking MacOS or Linux as an example, here are the first few steps in the setup process for using a mirror site. Run the following in a Bash shell from the directory where you wish to store your local Flutter clone:

```source-shell
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
git clone -b dev https://github.com/flutter/flutter.git
export PATH="$PWD/flutter/bin:$PATH"
cd ./flutter
flutter doctor
```

After these steps, you should be able to continue [setting up Flutter](https://flutter.io/setup/) normally. From here on, packages fetched by `flutter packages get` will be downloaded from `flutter-io.cn` in any shell where `PUB_HOSTED_URL` and `FLUTTER_STORAGE_BASE_URL` are set.

The `flutter-io.cn` server is a provisional mirror for Flutter dependencies and packages maintained by [GDG China](http://www.chinagdg.com/). The Flutter team cannot guarantee long-term availability of this service. You’re free to use other mirrors if they become available. If you’re interested in setting up your own mirror in China, please contact [flutter-dev@googlegroups.com](mailto:flutter-dev@googlegroups.com) for assistance.

Known issue:

*   Running the Flutter Gallery app from source requires assets hosted on a domain this workaround currently doesn't support. You can subscribe to [this bug](https://github.com/flutter/flutter/issues/13763) to receive updates. In the meantime, you can check out Flutter Gallery from Google Play or third-party app stores you trust.


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
