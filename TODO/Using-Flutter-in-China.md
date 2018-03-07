> * 原文地址：[Using Flutter in China](https://github.com/flutter/flutter/wiki/Using-Flutter-in-China)
> * 原文作者：[Flutter](https://github.com/flutter)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/Using-Flutter-in-China.md](https://github.com/xitu/gold-miner/blob/master/TODO/Using-Flutter-in-China.md)
> * 译者：[mysterytony](https://github.com/mysterytony)
> * 校对者：[hanliuxin5](https://github.com/hanliuxin5), [Starriers](https://github.com/Starriers)

# 在中国使用 Flutter

如果你在中国安装或使用 Flutter ，可以用一个可信的本地镜像来托管 Flutter 的依赖关系。为了让 Flutter 能使用一个备用的在线访问地址，你需要在运行 `flutter` 指令之前设置两个环境变量：`PUB_HOSTED_URL` 和 `FLUTTER_STORAGE_BASE_URL`。

比如说，在 MacOS 或 Linux 上，为了让你能使用镜像站点，下面是首先需要进行的一系列设置步骤。在你想要存储克隆下来的 Flutter 文件夹下运行下面的 Bash 命令：

```source-shell
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
git clone -b dev https://github.com/flutter/flutter.git
export PATH="$PWD/flutter/bin:$PATH"
cd ./flutter
flutter doctor
```

然后，你就应该可以继续正常地 [配置 Flutter](https://flutter.io/setup/)。从现在开始，在有 `PUB_HOSTED_URL` 和 `FLUTTER_STORAGE_BASE_URL` 环境变量的控制台用 `flutter packages get` 下载的包将会从 `flutter-io.cn` 下载。

`flutter-io.cn` 服务器是 Flutter 一个由 [GDG China](http://www.chinagdg.com/) 维护的依赖和包的临时镜像。Flutter 团队不能保证这个服务的长期可用性。你可以自由使用其他可用的镜像。如果你对在中国建立你自己的镜像感兴趣，请联系 [flutter-dev@googlegroups.com](mailto:flutter-dev@googlegroups.com) 以获得协助。

已知问题：

* 从源码运行 Flutter Gallery 程序需要的资源目前托管在这个解决方案暂不支持的域名。你可以订阅 [这个问题](https://github.com/flutter/flutter/issues/13763) 的更新。同时，你也可以在 Google Play 或者你信任的第三方商店看看 Flutter Gallery。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
