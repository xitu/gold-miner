> * 原文地址：[Faster, More Reliable CI Builds with Yarn](https://medium.com/javascript-scene/faster-more-reliable-ci-builds-with-yarn-7dbc0ef31580#.8jbyo2k64)
* 原文作者：[Eric Elliott](https://medium.com/@_ericelliott)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[Romeo0906](https://github.com/Romeo0906)
* 校对者：

# Faster, More Reliable CI Builds with Yarn

# Yarn 更快更可靠的 CI 创建工具


You may have heard of Yarn. It’s intended as a faster, more reliable alternative to the npm client. It’s nice to have packages install faster locally, but to really get the most from Yarn, you should also be using it with your continuous integration server.

你可能听说过 Yarn ，它剑指苍穹，要做成一个更快、更可靠的 npm 客户端。能够更快的在本地安装扩展包的确很棒，但是为了真正能够使用 Yarn 到淋漓尽致，你最好在持续继集成务器上使用它。

When paired with a continuous integration server, Yarn can reduce the number of random CI failures that result from packages resolving differently for different installs.

当配合一台持续集成服务器使用时，Yarn 能够减少因为各式各样的扩展包和安装导致的随机的 CI 错误。

Because slow installs and random CI failures can slow down your whole team, they have a multiplying drag effect on your team’s productivity. Random failures are even more frustrating than slow installs, because when something fails, you have to determine whether or not it was an intermittent bug, or the result of shifting packages. Easier said than done.

由于安装缓慢和 CI 产生的随机错误会降低整个团队的开发效率，它们将会成倍地给你的团队拖后腿。随机错误的出现甚至比安装缓慢更令人沮丧，因为一旦出错，你必须要确定是程序出现了 BUG 还是扩展包的问题。知之非难，行之不易。

Yarn to the rescue!

Yarn 来拯救你了！









![](https://cdn-images-1.medium.com/max/1600/1*m6zlwvyKm9BPeFQCKvGQEQ.png)





### Yarn is Not

### Yarn 误区

*   A replacement for the npm registry

*   一种新的 npm 资源管理器

Yarn is not a replacement for the npm package registry. It is not a competing package library ecosystem. This is not a repeat of the Bower fiasco.

Yarn 并不是 npm 的包资源管理器的替代，它也并非是一款有竞争力的扩展包生态管理库，所以它不会重蹈 Bower 惨败的覆辙。

It’s a client that works with the npm package registry.

Yarn 是一款利用了 npm 扩展包资料库工作的客户端。

### Yarn Is

### Yarn 正解

*   Faster installs.
*   Deterministic dependencies — with `yarn.lock`, you’ll get the same versions of the same packages installed in the same directory structure every time.

*   安装更快。
*   决定性的依赖 — 通过 `yarn.lock`，你能够每次都获取到相同安装位置相同版本的包文件。

### Switching to Yarn

### 转战 Yarn

When Yarn was announced, I immediately understood that it could be valuable, but I waited a few days to hear from other people whether or not it lived up to the promise.

When word started getting around that it was working well for people, I decided to start using it in an app project.

Yarn 刚刚发布的时候，我马上意识到它可能会非常有价值，但是我仍然按兵不动，想看看它是否真的实现了当时吹下的牛逼。

后来越来越多的人说 Yran 很好用，我才决定要在一款应用中使用它。

#### Installing Yarn

#### 安装 Yarn

The Yarn team recommends installing Yarn the same way you’d install a native app. **I recommend that you ignore their install documentation**.

There is no native Mac installer, so on Mac, they recommend Homebrew. Unless you used Homebrew to install Node (which I don’t recommend — use [nvm instead](https://github.com/creationix/nvm), to save a lot of headaches and easily switch between Node versions), **you should not use Homebrew to install Yarn**.

Yarn 团队建议像安装原生应用那样安装 Yarn，**而我建议你完全可以不看他们的安装文档**。

而 Yarn 没有 Mac 的原生安装包，所以他们推荐在 Mac 上使用 Homebrew。除非你已经用 Homebrew 安装了 Node（其实我并不推荐这样做 — 使用[nvm](https://github.com/creationix/nvm)能减少很多麻烦，也能自由地切换版本），**你不应该用 Homebrew 安装 Yarn**.

Homebrew will also install Node, which will relink the `node` and `npm` global commands to the Homebrew path and break your previous Node setup.

In addition to the dependency management problems with the Homebrew route, if you upgrade macOS to the latest version, it will break Homebrew by messing with the ownership of `usr/local`, so you’ll have that mess to sort out, too.

Homebrew 安装的同时也会安装 Node，它会将全局的 `node` 和 `npm` 命令添加到 Homebrew 路径中，并且会破坏你原本的 Node 的安装。

另外，由于 Homebrew 路径的依赖管理问题，如果你升级 macOS 到最新版，它将会打乱 `usr/local`的权限从而破坏 Homebrew ，因此你还需要整理这团乱麻。

**Thankfully there’s a better option:**

**幸亏还有更好的选择：**

    npm install -g yarn

Bonus: When you set up your CI server, you should have `npm` available there, too, so you can **use the same installer to install** `yarn` **everywhere you need it**.

好处：当你搭建 CI 服务器的时候，你同样需要 `npm` ，所以你可以**使用相同的方法安装** `yarn` **在任何你需要的地方**。

Ironically, yes: I do recommend that you install a JavaScript package manager to install your new JavaScript package manager. I’m convinced that this is the real reason that the Yarn team recommends Homebrew for Mac installs. Mostly to avoid this slightly embarrassing irony. But trust me:

> `npm` is the easiest and best way for experienced JavaScript developers to install Yarn.

很讽刺吧，是的：我确实建议你安装了一个 JavaScript 包管理工具来安装新的 JavaScript 包管理工具。我确信，这也是 Yarn 团队建议在 Mac 上使用 Homebrew 安装的真正原因，是为了避免这种稍稍有点尴尬的讽刺的事情。但是相信我：

> `npm` 对于有经验的 JavaScript 开发者来说，这是最简单最好的安装 Yarn 的方式。

The Yarn team will tell you that the OS native package dependency manager is the best way because it can keep track of all your package dependencies. I can see that logic, but in practice, _it only holds up on Linux_. **Homebrew is not the native package dependency manager for macOS. It does not and should not manage all your app dependencies on Mac.**

Yarn’s chief dependency is Node, and **Homebrew is not the best way to install Node**. So why use Homebrew to manage Yarn dependencies?

Yarn 团队会告诉你 OS 原生包依赖管理工具才是最好的方式，因为它会记录你所有的包依赖关系。我了解这种关系，但事实上_这只在 Linux 系统下才支持_。**Homebrew 并不是 macOS 原生的包依赖管理工具，它并不会也不应该管理你所有的应用依赖。**

Yarn 最主要的依赖是 Node，并且 **Homebrew 并不是安装 Node 的最好的方式**。所以，我们为什么要用 Homebrew 去管理 Yarn 的依赖关系呢？

Windows has its own story, which I’m less familiar with, so I won’t comment on how well their install instructions work for Windows users.

You know what does work on Mac, Windows, and Linux, though, with one set of instructions and none of the platform-specific headaches? **npm.**

Windows 下那又是别有洞天了，由于我并不了解，所以我暂不评论 Windows 下的安装如何。

但是众所周知，是什么能够在 Mac、Windows 和 Linux 下用法相同却没有跨平台的烦恼？** npm **

### Using Yarn

### 使用 Yarn

These are the commands you need to memorize, in a nutshell:

以下是你需要识记的在 nutshell 下的命令：

**Add a dependency:**

**添加依赖**

`yarn add `

**Add a dev dependency:**

**添加设备依赖**

`yarn add --dev `

**Remove a dependency:**

**移除依赖**

`yarn remove `

**Install:**

**安装**

`yarn` _(install is the default behavior)_

`yarn` _（安装是默认行为）_









![](https://cdn-images-1.medium.com/max/1600/1*FdFjSsPAyHmg1nft-VuqSw.gif)





That’s all you need most of the time.

以上是你大部分时候会用到的。

### The Lock File

### 锁定文件

Yarn pulls off its deterministic dependency magic using the `yarn.lock` file. It’s supposed to be an even more reliable form of `npm shrinkwrap`. The key difference is that npm’s installer algorithm is not deterministic, even shrinkwrapped. Yarn’s installer algorithm is deterministic. That means what gets installed on one machine, using the same lock file, will be exactly what gets installed on another machine.

Yarn 非常神奇地用 `yarn.lock` 文件解决了决定性依赖关系，它应该是一种更加可靠的 `npm shrinkwrap`的形式。关键的区别就是 npm 的安装算法并不是决定性的，甚至是压缩算法，而 Yarn 的算法是决定性的。这意味着使用同一个锁定文件，你在这台机器上的安装将会和在另一台机器上的安装完全相同。

> Don’t .gitignore yarn.lock. It is there to ensure deterministic dependency resolution to avoid “works on my machine” bugs.

In order for the lock file to work for you, **you must check it into git.**

> 不要在 git 中忽略 yran.lock ，它的存在就是为了确保决定性依赖关，从而避免 “works on my machine” 的错误。

### Setting Up Continuous Integration

### 搭建持续集成服务

As I mentioned in the install step, you can install yarn with `npm install -g yarn`, and that will work on most CI servers. Here’s an example `.travis.yml`for Travis-CI users:

正如我在安装阶段所提到的那这样，你可以用 `npm install -g yarn`方式安装 yarn ，这种方式能够在大多数 CI 服务器上运行。以下是 Travis-CI users 的一个 `.travis.yml`例子：

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



### How Does Yarn Work in Reality?

### 实际上 Yarn 到底如何工作？

If you’re curious about how much faster installs are, here are the numbers I pulled from my test app for from-scratch installs:

如果你非常好奇 yarn 安装到底有多快，以下是我在应用中测试安装 from-scratch 的数据：

**Using npm:**

    $ time npm install
    0m30.193s

**Using Yarn:**

    $ time yarn
    0m44.835s

**_Oops!_**

Yarn’s primary selling point is that it’s supposed to be faster than npm, but in my testing with real projects, it’s actually _slower at installing all dependencies from scratch._

What about adding new dependencies?

Yarn 的主要的买点就在于它要比 npm 更快，但是在我的项目实测中，它实际上_在从 scratch 安装依赖的时候更慢了_

那么添加新的依赖呢？

**Using npm:**

    $ time npm install lodash
    0m6.204s

**Using Yarn:**

    $ time yarn add lodash
    0m2.948s

Okay, that’s more like it. I’m still concerned about the from-scratch install time, but for now, adding packages with yarn is roughly **twice as fast as npm**.

Clearly, there is room for improvement on from-scratch installs (which is what determines the speed of your CI install), but I’m satisfied for now.

OK ，这才像点样子。我一直还在担心 from-scratch 的安装时间，但是现在，利用 yarn 添加扩展包大概**比 npm 快了两倍**。

显然，from-scrath 的安装仍然有很大的提升空间（这决定了你的 CI 的安装速度），但是我已经很满意了。

Take this with a grain of salt, because these things can change from one OS to another, and one version patch to the next:

> Yarn adds new packages about twice as fast as npm.  
> Yarn is slower than npm at from-scratch installs.

且对它持半信半疑的态度，因为这些结果可能会因系统、版本等因素而有不同。

### Conclusion

### 小结

My experience with Yarn so far has been _mostly good._

I’m just starting to test it out in production, so I can’t speak confidently about its reliability yet, but I’m optimistic.

If it does work out as expected, Yarn could save your team a lot of time. So far I’ve had mixed results.

迄今为止，我对 Yarn 的体验_非常不错_。

我仅仅是刚开始在产品中测试，所以我不能很自信地对其稳定性论及一二，但是我抱以乐观的心态。

如果 Yarn 能够证明如万众期待的那样，它将会节省你的团队非常多的时间。目前为止，我得到的结果也良莠不齐。

#### Should you be using Yarn?

#### 你是不是也应该使用 Yarn ？

It’s too early for me to say absolutely yes, but I’m going to give it an optimistic nod of approval. I’m rooting for the Yarn team to iron out the issues and improve it over time.

让我现在很绝对地说是有点太早了，但是我将会乐观地给予它鼓励性的肯定。我非常支持 Yarn 团队能够在后续的时间里解决问题并不断做出改进。