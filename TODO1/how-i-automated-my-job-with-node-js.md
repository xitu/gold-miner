> * 原文地址：[How I automated my job with Node.js](https://medium.com/dailyjs/how-i-automated-my-job-with-node-js-94bf4e423017)
> * 原文作者：[Shaun Michael Stone](https://medium.com/@shaunmstone?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-automated-my-job-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-automated-my-job-with-node-js.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：[Starriers](https://github.com/Starriers)

# 我如何使用 Node.js 来实现工作自动化

![](https://cdn-images-1.medium.com/max/800/1*S7-c7ZO0w0ocUU8tzkB3zA.jpeg)

您知道在工作中有很多必须完成的繁琐任务: 更新配置文件,复制和粘贴文件,更新 Jira 任务。

一段时间之后,这些工作的消耗时间会逐渐累积。2016 年，我在一家网络游戏公司工作时，情况就是如此。为游戏构建可配置的模板对于游戏开发来说是一项非常有意义的工作，但我大约 70% 的时间都花在了复制这些游戏模板和部署这些重新封装的实现上。

### 什么是 Reskin?

公司 reskin 的定义是指使用相同的游戏机制，屏幕和元素的定位，但改变诸如色彩和素材资源之类的纯视觉美学的相关内容。因此，在像“Rock Paper Scissors”这样简单的游戏中，我们创建一个具有如下基本素材资源的模板。

![](https://cdn-images-1.medium.com/max/800/1*hgFoiDduNdXaLJ-0seB-Gw.jpeg)

当我们创建一个这样的 reskin 之后，我们就可以更换不同的素材资源。如果你看看像 Candy Crush 或 Angry Birds 这样的游戏，你会发现它们一个游戏有很多不同的版本。通常有对应万圣节，圣诞节或复活节的版本来区分发布。从商业角度来看，这样做非常有意义。现在...回到我们的实现。每个游戏都共用相同的 JavaScript 文件，但会加载包含不同内容和资源路径的 JSON 文件。结果是？

![](https://cdn-images-1.medium.com/max/800/1*SYAsVKSmEmcKQ8dEZiisPg.jpeg)

我和其他开发人员每天都有一堆的工作日程表，我的第一个想法是“其实很多工作都可以实现自动化”。每当我去创建一个新游戏时，我都必须执行以下步骤：

1. git pull 模板仓库以确保它们是最新的；
2. 从主分支创建一个新的分支 — 由 Jira 任务 ID 标识；
3. 制作我需要构建的模板的副本；
4. 运行 gulp；
5. 更新 **config.json** 文件中的内容。这里面涉及到资源路径，标题，段落以及数据服务请求等；
6. 本地编译并检查与任务需求文档要求的内容是否匹配；
7. 与设计师确认他们对结果是否满意；
8. 合并到主分支并继续下一个分支;
9. 更新 Jira 任务的状态，并发表评论;
10. 整理并再重复以上过程。

![](https://cdn-images-1.medium.com/max/800/1*7Jg9xcM_hj6g8QC22vTiiw.jpeg)

对我来说，这感觉更像是一种管理工作而不是实际的开发工作。我曾在以前的角色中接触过 Bash 脚本，并在此基础上创建过一些脚本，以减少所做的工作。其中一个脚本可以更新模板并创建一个新的分支，另一个脚本执行了一个 commit 并将项目合并到开发和生产环境中。

手动创建一个项目需要三到十分钟。部署可能需要五到十分钟。这些会根据游戏的复杂程度而不同，有时甚至可能需要十分钟到半天。脚本会有所帮助,但仍然需要大量时间用于更新内容或追查丢失的信息。

![](https://cdn-images-1.medium.com/max/800/0*jxmPvnNgXhpFMV3v.)

只通过编写代码来缩短时间是不够的。需要考虑更好的方法来处理我们的工作流，以便我可以更好地利用这些脚本。将内容从文档中移出，将其分解为相关的自定义字段，并移入 Jira 任务。设计人员不需要再发送资源在公共服务器的链接地址，而更实际的做法是设置一个内容交付网络（CDN）存储库，其中包含资源的开发和生产的 URL。

### Jira API

这样的事情可能需要运行一段时间才能得到看到效果，但我们的流程确实会随着时间的推移而有所改善。我对我们的项目管理工具 Jira 的 API 进行了一些研究，并对我正在处理的 Jira 任务做了一些请求。我收集了很多有价值的数据。这些数据非常有价值,所以我决定将她们集成到我的 Bash 脚本中,以便从 Jira 任务中读取这些数据，并在完成任务后给相关负责人留言。

### 从 Bash 转到 Node

Bash 脚本很好，但如果有人在 Windows 上工作，就无法使用了。在做了一些研究之后，我决定使用 JavaScript 将整个过程包装成一个定制化的构建工具。我称之为 **Mason**，它会改变一切。

### CLI

当您在终端中使用 Git 时，您会注意到它有一个非常友好的命令行接口。如果你拼写错误或者输入错误的命令，它会礼貌地给出你要输入内容的相关建议。一个名为 commander 的库也使用了相同的行为，它是我使用过的众多库中的一个。

考虑下面的简化代码示例。它正在引导命令行接口（CLI）应用程序。

#### SRC / mason.js
```
    #! /usr/bin/env node

    const mason = require('commander');
    const { version } = require('./package.json');
    const console = require('console');

    // commands
    const create = require('./commands/create');
    const setup = require('./commands/setup');

    mason
        .version(version);

    mason
        .command('setup [env]')
        .description('run setup commands for all envs')
        .action(setup);

    mason
        .command('create <ticketId>')
        .description('creates a new game')
        .action(create);

    mason
        .command('*')
        .action(() => {
            mason.help();
        });

    mason.parse(process.argv);

    if (!mason.args.length) {
        mason.help();
    }
```

使用 npm，您可以运行 **package.json** 中的一个链接，它创建了一个全局的别名。
```
    ...
    "bin": {
      "mason": "src/mason.js"
    },
    ...
```

当我在项目的根目录中运行 npm link。
```
    npm link
```

它将为我提供一个我可以调用的 mason 命令。所以每当我在终端调用 mason，它就会运行 mason.js 脚本。所有的任务都在这个 mason 命令中实现了，我每天都用它来构建游戏。我节省的时间真是难以置信。

您可以在下面看到——在我当时所设想的示例中——我将一个 Jira 任务号作为参数传递给命令。这将访问 Jira API，并获取更新游戏我所需要的全部信息。然后，它将继续编译和部署项目。之后我会发一条评论，@负责人和设计师，让他们知道已经完成了。

```
    $ mason create GS-234
    ... calling Jira API 
    ... OK! got values!
    ... creating a new branch from master called 'GS-234'
    ... updating templates repository
    ... copying from template 'pick-from-three'
    ... injecting values into config JSON
    ... building project
    ... deploying game
    ... Perfect! Here is the live link 
    http://www.fake-studio.com/game/fire-water-earth
    ... Posted comment 'Hey [~ben.smith], this has been released. Does the design look okay? [~jamie.lane]' on Jira.
```

所有这一切只用几个键就搞定了!

我对整个项目非常满意，于是我决定在我刚刚出版的一本书中重写一个更好的版本，书名为《用 Node.js 实现自动化》。

![](https://cdn-images-1.medium.com/max/800/1*wOmVnWEaWu-1g-xL874xyg.jpeg)

> * **_彩色打印：_** [http://amzn.eu/aA0cSnu](http://amzn.eu/aA0cSnu)
> * **_Kindle：_** [http://amzn.eu/dVSykv1](http://amzn.eu/dVSykv1)  
> * **_Kobo：_** [https://www.kobo.com/gb/en/ebook/automating-with-node-js](https://www.kobo.com/gb/en/ebook/automating-with-node-js)  
> * **_Leanpub：_** [https://leanpub.com/automatingwithnodejs](https://leanpub.com/automatingwithnodejs) 
> * **_Google Play：_** [https://play.google.com/store/books/details?id=9QFgDwAAQBAJ](https://play.google.com/store/books/details?id=9QFgDwAAQBAJ)

这本书分为两部分：

### 第 1 部分
第一部分是一个方法合集，或者作为单个全局命令的指令构建模块。它们可以在你每天的工作中使用，也可以纯粹为了方便在任何时候调用它们来加快你的工作流程。

### 第 2 部分

第二部分是一个从头开始创建跨平台编译工具的演练。每个脚本实现特定的某个任务，由主命令，通常就是项目的名称，将它们全部封装起来。

书中的项目被称为 **nobot** _(no-bot)_，它基于一个小卡通机器人。我希望你能喜欢并从中可以学到一些东西。

![](https://cdn-images-1.medium.com/max/800/1*fiOf2PARww-2wmOiV66iWA.jpeg)

我知道每个企业的情况和流程都不同，但是你应该从中发现一些东西，即使它很不起眼，也会让你每天在办公室里的工作变得更加轻松。

**花更多时间开发，减少管理时间。**

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

谢谢阅读！如果你喜欢，请在下面给我们点赞。👏

有关软件/硬件各方面的视频,请查看我的 YouTube 频道：<https://www.youtube.com/channel/UCKr-FjGzNdbbk--gvW5tzaw>

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
