> * 原文地址：[How to make a beautiful, tiny npm package and publish it](https://medium.freecodecamp.org/how-to-make-a-beautiful-tiny-npm-package-and-publish-it-2881d4307f78)
> * 原文作者：[Jonathan Wood](https://medium.freecodecamp.org/@Bamblehorse?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-make-a-beautiful-tiny-npm-package-and-publish-it.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-make-a-beautiful-tiny-npm-package-and-publish-it.md)
> * 译者：
> * 校对者：

# 创建并发布一个小而美的 npm 包 #

你肯定想不到这有多简单！

![](https://cdn-images-1.medium.com/max/800/0*7m8mTkj_Fp916sdm)

Photo by [Chen Hu](https://unsplash.com/@huchenme?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

如果你已经写过很多 npm 模块，你就可以跳过这部分。如果没有的话，我们先看下简介

#### TL;DR

一个 npm 模块 **只** 需要包含一个带有 **name** 和 **version** 属性的 package.json 文件。

### Hey！

看看你。

就像一只懵懂无知的小象。

你不是制作 npm 包的专家，但你很想学习它。

所有的大象跺跺脚就能制作一个又一个的包，然后你会想：

> “我没法与它们竞争啊。”

好吧，其实你是可以的！

不要再怀疑自己啦。

开始吧！

#### 你不是大象

这是个 [比喻](https://www.merriam-webster.com/dictionary/metaphorical)。

想过幼年大象被叫做什么吗？

_你当然想过。_ 一个幼年大象被叫做 [小牛](https://www.reference.com/pets-animals/baby-elephant-called-a3893188e0a63095)。

#### 我相信你

[怀疑自己](https://en.wikipedia.org/wiki/Impostor_syndrome) 是存在的。

这导致了很多人做不出很酷的东西。

你觉得你做不出来，所以你啥都不做。 但是，你又会转头崇拜那些有着很高成就的牛人。

太讽刺啦。

所以我将要展示给你一个可能是最小的 npm 模块。

很快就会有 npm 模块从你的指尖飞出来。随处可见的高复用代码。没有耍什么把戏 —— 也没有复杂的指令。

### 复杂的指令

我保证过不会有…

…不过我确实做了。

没这么糟糕啦。总有一天你会原谅我的。

#### 步骤 1：npm 账户

你需要一个账号。这是流程的一部分。

[在这注册](https://www.npmjs.com/signup)。

#### 步骤 2：登录

有没注册一个 npm 账户呀？

是啊，你已经创建啦。

真棒。

我同时建议你使用 [命令行 / 控制台](https://www.davidbaumgold.com/tutorials/command-line/) 等等。从现在起我统一叫它们终端。这里可以看下它们的区别 [很明显](https://superuser.com/questions/144666/what-is-the-difference-between-shell-console-and-terminal)。

打开终端然后输入：

```
npm adduser
```

你也可以使用下面的命令：

```
npm login
```

这两个选一个跟着你混到死吧。

你会得到一个让你输入**username**，**password** 和 **email**的提示。把它们填在相应的位置吧！

你会得到类似下面的提示：

> Logged in as bamblehorse to scope [@username](http://twitter.com/username "Twitter profile for @username") on [https://registry.npmjs.org/](https://registry.npmjs.org/)。

棒极啦！

### 开始开发一个包

首先我们需要一个文件夹来装我们的代码。用一个你喜欢的方式随便建一个。我把我新建的包叫做 **tiny** 因为它真的很小。我为那些不熟悉命令行的人提供些新建相关的终端命令。

> [md](https://en.wikipedia.org/wiki/Mkdir) tiny

在新建的文件夹中，我们需要 [**package.json**](https://docs.npmjs.com/files/package.json) 文件。如果你用过 [Node.js](https://en.wikipedia.org/wiki/Node.js) — 那你肯定见过这个文件。这是一个 [JSON](https://en.wikipedia.org/wiki/JSON) 文件，它包含了你的项目信息以及众多的配置项。在本文中，我们只需关注其中的两项。

> [cd](https://en.wikipedia.org/wiki/Cd_%28command%29) tiny && [touch](https://superuser.com/questions/502374/equivalent-of-linux-touch-to-create-an-empty-file-with-powershell) package.json

#### 它能有多小呢？

真的很小。

包括官方文档在内的创建npm包的教程，都在让你在 package.json 中输入某些字段。在不影响它正常工作和发布的前提下，我们尽量试着精简下我们的包。这是 [TDD](https://en.wikipedia.org/wiki/Test-driven_development) 的一种，我们把它用在一个很小的 npm 包上。

**请注意：** 我给你讲这些就是想说明不是所有的npm包都很复杂。 想让我们开发的包为社区作出贡献的话，一般还需要很多别的模块，随后我们会讲到。

#### 发布： 第一次尝试

为了发布你的 npm 包，你需要执行规定好的命令: **npm publish**。

所以我们在创建好的包含空 package.json 的文件夹中试一下：

```
npm publish
```

啊哦！

报错：

```
npm ERR! file package.json
npm ERR! code EJSONPARSE
npm ERR! Failed to parse json
npm ERR! Unexpected end of JSON input while parsing near ''
npm ERR! File: package.json
npm ERR! Failed to parse package.json data.
npm ERR! package.json must be actual JSON, not just JavaScript.
npm ERR!
npm ERR! Tell the package author to fix their package.json file. JSON.parse
```

npm 可不喜欢报这么多错。

有道理。

#### 发布：第二次挣扎

我们先在 package.json 文件中给我们的包起个名字吧：

```
{
"name": "@bamlehorse/tiny"
}
```

你可能注意到了，我把我的 npm 用户名加到了开头。

这样做的意义是什么呢？

通过使用 **@bamblehorse/tiny** 代替 **tiny**，我们会创建一个在我们用户名 **scope** 下的一个包。这个叫做 [**scoped package**](https://docs.npmjs.com/misc/scope)。它允许我们将已经被其他包使用的名称作为包名，比如说，[**tiny** 包](https://www.npmjs.com/package/tiny) 已经在 npm 中存在。

你可能在一些著名的包中见过这种命名方法，比如来自 Google 的 [Angular](https://angular.io/)。 它们有几个 scoped packages，比如 [@angular/core](https://www.npmjs.com/package/@angular/core) 和 [@angular/http](https://www.npmjs.com/package/@angular/http)。

超级酷，对吧?

我们试着第二次发布我们的包：

```
npm publish
```

这次的报错信息少多了 —— 有进步。

```
npm ERR! package.json requires a valid “version” field
```

每个 npm 包都需要一个版本，以便开发人员在安全地更新包版本的同时不会破坏其余的代码。npm 使用的版本系统被叫做 [**SemVer**](https://semver.org/)， 是 **Semantic Versioning** 的缩写。

不要过分担心理解不了相较复杂的版本名称，下面是他们对基本版本命名的总结：

> 给定版本号 MAJOR.MINOR.PATCH, 增量规则如下：
>
> 1. MAJOR 版本号的变更说明新版本产生了不兼容低版本的 API 等，
>
> 2. MINOR 版本号的变更说明你在以向后兼容的方式添加功能，接下来
>
> 3. PATCH 版本号的变更说明你在新版本中做了向后兼容的 bug 修复。
>
> 表示预发布和构建元数据的附加标签可作为 MAJOR.MINOR.PATCH 格式的扩展。
>
> [https://semver.org](https://semver.org/)

#### **发布：第三次尝试**

我们将要定义我们 package.json 中包的版本号：**1.0.0** —— 第一个主要版本。

```
{
"name": "@bamblehorse/tiny",
"version": "1.0.0"
}
```

开始发布吧！

```
npm publish
```

哎呀，

```
npm ERR! publish Failed PUT 402
npm ERR! code E402
npm ERR! You must sign up for private packages : @bamblehorse/tiny
```

我来解释一下。

Scoped packages 会被自动发布为私有包，因为这样不但对我们这样的独立用户有用，而且它们也被公司用于在项目之间共享代码。如果我们就发布这样一个包的话，那我们的旅程可能就要在此结束了。

我们只需改变下指令来告诉 npm 我们想让每个人都可以使用这个模块 —— 不要把它锁进 npm 的保险库中。 所以我们执行如下指令：

```
npm publish --access=public
```

Boom！

```
+ @bamblehorse/tiny@1.0.0
```

我们收到一个 + 号，我们包的名称和版本号。

我们做到啦 —— 我们已经走进 npm 俱乐部啦。

好激动。

_你也肯定很激动。_

![](https://cdn-images-1.medium.com/max/800/1*oBaHFxAXy-BWtzyAKeMGBQ.png)

用友好的蓝色盖住敏感信息

#### 发现没？

> npm 爱你呦

真可爱！

[版本1](https://www.npmjs.com/package/@bamblehorse/tiny/v/1.0.0) 就躺在那呢！

### 重构一下

如果我们想成为一个严谨的开发者，并且让我们的包得以广泛使用，那我们就需要向别人展示我们的代码同时也要让他们明白怎样使用我们的包。一般我们通过将代码放在公共平台并添加描述文件来实现。

我们也需要一些代码来实现。

实话说。

我们至今还没有写任何代码呢。

GitHub 就是一个放代码的好地方。 先建一个 [新的仓库](https://github.com/new)。

![](https://cdn-images-1.medium.com/max/800/1*NGHjzcMgnzBtmSFfQuqVow.png)

#### README！

我之前通过在  **README** 编辑文字来 **描述**。

你不必再那样做了。

接下来会很有趣。

我们将添加一些来自 [shields.io](https://shields.io/) 的时髦徽章，让人们知道我们又酷又专业。

如下可以让别人知道我们当前的包版本：

![](https://cdn-images-1.medium.com/max/800/1*ZbzgGAfTeBlqNH2gtLy-GQ.png)

**npm (scoped)**

下一个徽章更有趣。它表示警告，因为我们还没有任何代码。 

我们真该写些代码…

![](https://cdn-images-1.medium.com/max/800/1*mxZkgckYLK16mhkRte1Bqw.png)

**npm bundle size (minified)**

![](https://cdn-images-1.medium.com/max/800/1*gY_-15Q4rLU129dXLg5ibQ.png)

我们简短的简介

#### 代码许可

这个名称肯定参考了 [James Bond](https://www.imdb.com/title/tt0097742/)。

我实际上忘了添加许可证。

代码许可其实就是让别人知道在什么情况下才能使用你的代码。这里有 [许多选项](https://choosealicense.com/) 供你选择。

每个 GitHub 仓库中都有一个名为 insights 的酷页面，你可以在其中查看各种统计信息 —— 包括社区定下的项目标准。我将要从那里添加我的许可。

![](https://cdn-images-1.medium.com/max/800/1*hkUyteXGLLTDt0WwKEpZ6A.png)

**社区意见**

然后你点出这个页面：

![](https://cdn-images-1.medium.com/max/800/1*ZWgFtTjkB8RpBDfRsCsLUQ.png)

Github 为你提供了每个许可证简介

#### 代码

我们还是没有任何代码。有点尴尬。

在我们完全失去可信度之前加点代码吧。

```
module.exports = function tiny(string) {
  if (typeof string !== "string") throw new TypeError("Tiny wants a string!");
  return string.replace(/\s/g, "");
};
```

虽然没用 —— 但是看着舒服多了

就是这样。

一个 **简易** 的方法，用来移除字符串中的空格。

所有 npm 包都需要一个 **index.js** 文件。这是包的入口文件。随着复杂度升高，你可以采用不同的方式来实现它。

不过如今这样对我们来说就足够了

### 我们已经到达目的地了吗？

我们很接近了。

我们应该更新我们的迷你 **package.json** 文件并在 **readme.md** 文件中添加一些指令。

不然就没人知道怎样使用我们漂亮的代码啦。

#### package.json

```
{
  "name": "@bamblehorse/tiny",
  "version": "1.0.0",
  "description": "Removes all spaces from a string",
  "license": "MIT",
  "repository": "bamblehorse/tiny",
  "main": "index.js",
  "keywords": [
    "tiny",
    "npm",
    "package",
    "bamblehorse"
  ]
}
```

解释一下！

我们添加了如下属性：

*   [description](https://docs.npmjs.com/files/package.json#description-1)：包的简介
*   [repository](https://docs.npmjs.com/files/package.json#repository)：适合写上 GitHub 地址 —— 所以你可以写成这种格式 **username/repo**
*   [license](https://docs.npmjs.com/files/package.json#license)：这里是 MIT 认证
*   [main](https://docs.npmjs.com/files/package.json#main): 包的入口文件，位置在文件夹的根目录
*   [keywords](https://docs.npmjs.com/files/package.json#keywords)：添加一些关键词更容易使你的包被搜索到

#### readme.md

![Informative!](https://i.loli.net/2018/11/26/5bfbdd88d4ac8.png)

非常丰富！

我们已经添加了有关如何安装和使用该包的说明。棒极啦！

如果您想优化下 readme 的格式，只需查看开源社区中的热门软件包，并使用它们的格式来帮助你快速入门。

### 完成

开始发布我们的棒棒的包吧。

#### 版本

首先，我们用 [npm version](https://docs.npmjs.com/cli/version) 命令来升级下包的版本。

这是一个主版本，因此我们输入：

```
npm version major
```

它会输出：

```
v2.0.0
```

#### 发布！

让我们运行我们最喜欢的命令吧：

```
npm publish
```

完成：

```
+ @bamblehorse/tiny@2.0.0
```

### 一个酷酷的东西

[Package Phobia](https://packagephobia.now.sh/result?p=%40bamblehorse%2Ftiny) 可以为你的包提供一个很棒的摘要。您也可以在 [Unpkg](https://unpkg.com/@bamblehorse/tiny@2.0.0/) 等网站上查看包内的文件。

### 感谢你的阅读

我们刚刚经历了一场美妙的旅行。我希望你会像我一样享受喜爱它。

请让我知道你在想什么！

给我们刚刚创建的包来颗 star 吧：

#### ★ [Github.com/Bamblehorse/tiny](https://github.com/Bamblehorse/tiny)

![](https://cdn-images-1.medium.com/max/800/0*qmkE3zw9beF6fP_0)

“大半个身子浸在水中的大象。” 由 [Jakob Owens](https://unsplash.com/@jakobowens1?utm_source=medium&utm_medium=referral) 拍摄，来自 [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)

请关注我～ [Twitter](https://twitter.com/Bamblehorse)，[Medium](https://medium.com/@Bamblehorse) or [GitHub](https://github.com/Bamblehorse)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
