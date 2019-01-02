> * 原文地址：[Faster, More Reliable CI Builds with Yarn](https://medium.com/javascript-scene/faster-more-reliable-ci-builds-with-yarn-7dbc0ef31580#.8jbyo2k64)
* 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[王子建](https://github.com/Romeo0906)
* 校对者：[Gnakoaix](https://github.com/xuxiaokang)，[鳗鱼鱼](https://github.com/cyseria)

# Yarn 更快更可靠的 CI 创建工具


你可能听说过 Yarn ，它剑指苍穹，要做成一个更快、更可靠的 npm 客户端。能够更快的在本地安装扩展包的确很棒，但是为了真正能够使用 Yarn 到淋漓尽致，你最好在持续继集成务器上使用它。

当配合一台持续集成服务器使用时，Yarn 能够减少因为各式各样的安装包的解析方式不同导致的随机 CI 错误。

由于安装缓慢和 CI 产生的随机错误会降低整个团队的开发效率，它们将会成倍地给你的团队拖后腿。随机错误的出现甚至比安装缓慢更令人沮丧，因为一旦出错，你必须要确定是程序出现了 BUG 还是扩展包的问题。知之非难，行之不易。

Yarn 来拯救你了！









![](https://cdn-images-1.medium.com/max/1600/1*m6zlwvyKm9BPeFQCKvGQEQ.png)





### Yarn 误区

*   一种新的 npm 资源管理器

Yarn 并不是 npm 的包资源管理器的替代，它也并非是一款有竞争力的扩展包生态管理库，所以它不会重蹈 Bower 惨败的覆辙。

Yarn 是一款与 npm 包管理协同工作的软件。

### Yarn 正解

*   安装更快。
*   确定的依赖管理 — 通过 `yarn.lock`，你能够每次都获取到相同安装位置相同版本的包文件。

### 转战 Yarn

Yarn 刚刚发布的时候，我马上意识到它可能会非常有价值，但是我仍然按兵不动，想看看它是否真的实现了当时吹下的牛逼。

后来越来越多的人说 Yarn 很好用，我才决定要在一款应用中使用它。

#### 安装 Yarn

Yarn 团队建议像安装原生应用那样安装 Yarn，**而我建议你完全可以不看他们的安装文档**。

Yarn 没有 Mac 的原生安装包，所以他们推荐在 Mac 上使用 Homebrew。除非你已经用 Homebrew 安装了 Node（其实我并不推荐这样做 — 使用 [nvm](https://github.com/creationix/nvm) 能减少很多麻烦，也能自由地切换版本），**否则不要用 Homebrew 来安装 Yarn**.

Homebrew 安装的同时也会安装 Node，它会将全局的 `node` 和 `npm` 命令添加到 Homebrew 路径中，并且会破坏你原本的 Node 的安装。

另外，由于 Homebrew 路径的依赖管理问题，如果你升级 macOS 到最新版，它将会打乱 `usr/local` 的权限从而破坏 Homebrew ，因此你还需要整理这团乱麻。

**幸亏还有更好的选择：**

    npm install -g yarn

好处：当你搭建 CI 服务器的时候，你同样需要 `npm` ，所以你可以**使用相同的方法安装** `yarn` **在任何你需要的地方**。

很讽刺吧，是的：我确实建议你安装一个 JavaScript 包管理工具来安装新的 JavaScript 包管理工具。我确信，这也是 Yarn 团队建议在 Mac 上使用 Homebrew 安装的真正原因，是为了避免这种稍稍有点尴尬的讽刺的事情。但是相信我：

> `npm` 对于有经验的 JavaScript 开发者来说，这是最简单最好的安装 Yarn 的方式。

Yarn 团队会告诉你 OS 原生包依赖管理工具才是最好的方式，因为它会记录你所有的包依赖关系。我了解这种关系，但事实上**这只在 Linux 系统下才支持**。**况且 Homebrew 并不是 macOS 原生的包依赖管理工具，它并不会也不应该管理你所有的应用依赖。**

Yarn 最主要的依赖是 Node，并且 **Homebrew 并不是安装 Node 的最好的方式**。既然如此，我们为什么还要用 Homebrew 去管理 Yarn 的依赖关系呢？

Windows 下那又是别有洞天了，由于我并不了解，所以我暂不评论 Windows 下的安装如何。

你知道什么包管理软件能够在Mac、Windows和Linux下用法相同却没有跨平台的烦恼呢？ **npm**。

### 使用 Yarn

有一些你需要识记的命令，简而言之：

**添加依赖**

`yarn add `

**添加开发依赖**

`yarn add --dev `

**移除依赖**

`yarn remove `

**安装**

`yarn` **（安装是默认行为）**









![](https://cdn-images-1.medium.com/max/1600/1*FdFjSsPAyHmg1nft-VuqSw.gif)





以上是你大部分时候会用到的。

### 锁定文件

Yarn 非常神奇地用 `yarn.lock` 文件解决了确定的依赖关系，它应该是一种更加可靠的 `npm shrinkwrap` 的形式。关键的区别就是 npm 的安装算法并不是确定的，甚至是压缩算法，而 Yarn 的算法是确定的。这意味着使用同一个锁定文件，你在这台机器上的安装将会和在另一台机器上的安装完全相同。

> 不要在 git 中忽略 yran.lock ，它的存在就是为了保证确定的依赖关系，从而避免 “works on my machine” 的错误。

为了让锁定文件能够大显神通，**你必须在 git 中 check 它**。

### 搭建持续集成服务

正如我在安装阶段所提到的那这样，你可以用 `npm install -g yarn` 方式安装 yarn ，这种方式能够在大多数 CI 服务器上运行。以下是 Travis-CI users 的一个 `.travis.yml`例子：

    language: node_js
    node_js:
      - "6"
    env:
      - CXX=g++-4.8
    addons:
      apt:
        sources:
          - ubuntu-toolchain-r-test
        packages:
          - g++-4.8
    before_install:
      - npm install -g yarn --cache-min 999999999
    install:
      - yarn



### 实际上 Yarn 到底如何工作？

如果你非常好奇 yarn 安装到底有多快，以下是我在应用中测试安装 from-scratch 的数据：

**使用 npm:**

    $ time npm install
    0m30.193s

**使用 Yarn:**

    $ time yarn
    0m44.835s

**哦！**

Yarn 的主要的卖点就在于它要比 npm 更快，但是在我的项目实测中，它实际上**在从 scratch 安装依赖的时候更慢了**。

那么添加新的依赖呢？

**使用 npm:**

    $ time npm install lodash
    0m6.204s

**使用 Yarn:**

    $ time yarn add lodash
    0m2.948s

OK，这才像点样子。我一直还在担心 from-scratch 的安装时间，但是现在，利用 yarn 添加扩展包大概**比 npm 快了两倍**。

显然，from-scrath 的安装仍然有很大的提升空间（这决定了你的 CI 的安装速度），但是我已经很满意了。

且对它持半信半疑的态度，因为这些结果可能会因系统、版本等因素而有不同。

### 小结

迄今为止，我对 Yarn 的体验**大部分情况下都很好**。

我仅仅是刚开始在产品中测试，所以我不能很自信地对其稳定性论及一二，但是我抱以乐观的心态。

如果 Yarn 能够证明如万众期待的那样，它将会节省你的团队非常多的时间。但是到目前为止，我得到的结果也良莠不齐。

#### 你是不是也应该使用 Yarn ？

让我现在很绝对地说是有点太早了，但是我将会乐观地给予它鼓励性的肯定。我非常支持 Yarn 团队能够在后续的时间里解决问题并不断做出改进。
