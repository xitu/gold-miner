> * 原文链接: [Introducing Swift 3.0](http://dev.iachieved.it/iachievedit/)
* 原文作者 : [ Joe](http://dev.iachieved.it/iachievedit/author/admin/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [iThreeKing](https://github.com/iThreeKing)
* 校对者 : [CoderBOBO](https://github.com/CoderBOBO) [shenxn](https://github.com/shenxn)

Linux 系统下 Swift 3.0 的介绍
====================

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://swift.org/)

如果你正在寻找 Swift 2.2 的 Ubuntu 包，请查看我们[这里](http://dev.iachieved.it/iachievedit/ubuntu-packages-for-open-source-swift/)的引导。
### Swift 3.0

Swift 2.2 已经从 `master` 分支移到了 `swift-2.2` 分支上。从那以后，仓库的 `master` 分支就被用来进行 3.0 版本的开发。完整克隆并编译 Swift 源码的方式已经与之前有很大变化。相比之前要逐个仓库进行克隆，现在你可以这样做:

    mkdir swift-build
    cd swift-build
    git clone https://github.com/apple/swift.git 
    ./swift/utils/update-checkout --clone

`swift` 仓库中的 `update-checkout` 脚本可以帮助你克隆编译 Swift 代码所需的仓库，并且把它们打包到 `.tar.gz` 压缩文件中。

我们使用 “build and package” 作为预设，不仅可以编译所有需要的目标文件，还能顺利地将它们打包成 `.tar.gz` 压缩文件。使用 `package.sh` 这个脚本就能完成上面的操作（可在 `package-swift` 库中找到）:

    #!/bin/bash
    pushd `dirname $0` > /dev/null
    WHERE_I_AM=`pwd`
    popd > /dev/null
    INSTALL_DIR=${WHERE_I_AM}/install
    PACKAGE=${WHERE_I_AM}/swift.tar.gz
    LSB_RELEASE=`lsb_release -rs  | tr -d .`
    rm -rf $INSTALL_DIR $PACKAGE
    ./swift/utils/build-script --preset=buildbot_linux_${LSB_RELEASE} install_destdir=${INSTALL_DIR} in

这个脚本中关键的事情就是检测 Ubuntu 的版本 (`lsb_release -rs`)，并且使用 `buildbot_linux_${LSB_RELEASE}` 预设来编译并把所有东西打包到 `${PACKAGE}` `.tar.gz` 文件中。
### apt-get

从 Apple 官方下载 `.tar.gz` 是个明智的选择。其实在 Ubuntu 发行版本上使用 `apt-get` 指令是更好的方法。为了使在 Linux 上编译 Swift 代码变得更加容易，我们为你提供了包含最新 Swift 包的 Ubuntu 仓库。

当前我们同时提供了 `swift-3.0` 和 `swift-2.2` 两个版本的包，然而他们并_不_兼容。比如，两个版本包都会将 `swift` 安装到 `/usr/bin` 目录下。我们计划将两个版本包分开安装到不同地方，不过可能要到 2016 年中才能解决这个问题。

虽然有各种限制和约束，但是也不妨碍我们开始看看如何安装 Swift 3.0 !

**1\. 添加仓库密钥 (repository key)**

    wget -qO- http://dev.iachieved.it/iachievedit.gpg.key | sudo apt-key add -

**2\. 将特定仓库添加到 `sources.list`**

**Ubuntu 14.04**

    echo "deb http://iachievedit-repos.s3.amazonaws.com/ trusty main" | sudo tee --append /etc/apt/sources.list

**Ubuntu 15.10**

echo "deb http://iachievedit-repos.s3.amazonaws.com/ wily main" | sudo tee --append /etc/apt/sources.list

**3\. 运行 `apt-get update`**

```
sudo apt-get update
```

**4\. 安装 swift-3.0!**

```
apt-get install swift-3.0
```

**5\. 试一试**

    git clone https://github.com/apple/example-package-dealer
    cd example-packager-dealer
    swift build
    Compiling Swift Module 'FisherYates' (1 sources)
    Linking Library:  .build/debug/FisherYates.a
    Compiling Swift Module 'PlayingCard' (3 sources)
    Linking Library:  .build/debug/PlayingCard.a
    Compiling Swift Module 'DeckOfPlayingCards' (1 sources)
    Linking Library:  .build/debug/DeckOfPlayingCards.a
    Compiling Swift Module 'Dealer' (1 sources)
    Linking Executable:  .build/debug/Dealer

运行 Swift 3.0!

```
.build/debug/Dealer
```

## FAQ

**Q.** Apple 官方会编译这些二进制文件吗？

**A.** 并不会，我在自己的个人服务器上编译它们，你们可以参考[这里](http://dev.iachieved.it/iachievedit/keeping-up-with-open-source-swift/)

**Q.** 编译项目中的 git 修改版本怎么查找？

**A.** 你可以使用 `apt-cache show swift-3.0` 指令来查看这项信息。比如:

    # apt-cache show swift-3.0
    Package: swift-3.0
    Status: install ok installed
    Priority: optional
    Section: development
    Installed-Size: 281773
    Maintainer: iachievedit (support@iachieved.it)
    Architecture: amd64
    Version: 1:3.0-0ubuntu2
    Depends: clang (&gt;= 3.6), libicu-dev
    Conflicts: swift-2.2
    Description: Open Source Swift
     This is a packaged version of Open Source Swift 3.0 built from
     the following git revisions of the Apple Github repositories:
           Clang:  c18bb21a04
            LLVM:  0d07a5d3d5
           Swift:  8aa4dadf92
      Foundation:  dc4fa2d80b
    Description-md5: 08508c39657c159d064917af87d8d411
    Homepage: http://dev.iachieved.it/iachievedit/swift

每次编译原始树_未受影响_。

**Q.** 上传二进制文件前你测试过它们吗？

**A.** Swift 进行编译时会对产生的二进制文件进行测试，然后我会做一些基础测试并用它编译我自己的应用程序，但是现在没有详尽全面的测试用例。

**Q.** 你会按照时间表定期编译吗？

**A.** 并不会，尽管我想尝试与 Apple 官方保持同步。然而我的想法只是做一下实验，从而我可以在 Linux 上编写 Swift 程序。

**Q.** 所有内容会被安装到哪里？

**A.**所有内容会被放在 `/usr` 目录下，就像安装 `clang` 、 `gcc` 那样。

**Q.** 如何理解包版本号的意义？

**A.** 这就是我一开始就想到的问题，我认为应该需要一个合适的包版本号。把 `3.0-0ubuntu2~trusty1` 分解一下，应该是这样：

*   3.0 是指所打包的 Swift 版本。
*   -0ubuntu2 表示为 Ubuntu 打包的第二个版本，0 表示其上没有依赖的 Debian 包。
*   ~trusty1 表示这个包是为 Trusty Tahr 准备的。

Wily 的包版本号并不包括任何类似 `~wiley1` 这样的内容，因为从 Trusty 升级到 Wiley 后，它能够正确地自动更新 `swift-3.0` 的包。

我_认为_这样是对的，但是如果你有其他想法，可以发邮件到 `support@iachieved.it` 。

## 工作原理是什么?

我参考了[这些超赞的指南](http://xn.pinkhamster.net/blog/tech/host-a-debian-repository-on-s3.html)，在 Amazon S3 上搭建了一个 Debian 包仓库。我试着在上面建立了一个 PPA (译者注:Personal-Package-Archives，个人软件包档案) 发布平台，但是说实话，为了发布一个简单的包处理如此多的元数据真的非常痛苦。我明确知道搭建分发仓库很必要，但是这样做又有一些过头。不过那些开发 [fpm](https://github.com/jordansissel/fpm) 的人也有一些关于这个的建议。

那些打包好用来编译内容并且上传到仓库的脚本可以在 [Github](https://github.com/iachievedit/package-swift) 上找到。学习 Swift 3.0 可以查看 `swift-3.0` 分支。
