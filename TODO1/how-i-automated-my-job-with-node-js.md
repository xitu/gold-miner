> * 原文地址：[How I automated my job with Node.js](https://medium.com/dailyjs/how-i-automated-my-job-with-node-js-94bf4e423017)
> * 原文作者：[Shaun Michael Stone](https://medium.com/@shaunmstone?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-automated-my-job-with-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-automated-my-job-with-node-js.md)
> * 译者：[geniusq1981](https://github.com/geniusq1981)
> * 校对者：

# 我是如何使用Node.js自动完成工作的

![](https://cdn-images-1.medium.com/max/800/1*S7-c7ZO0w0ocUU8tzkB3zA.jpeg)

您知道在工作中必须完成的繁琐任务: 更新配置文件,复制和粘贴文件,更新Jira票证. 

一段时间后,时间会增加. 当我在2016年为一家网络游戏公司工作时就是这种情况. 当我不得不为游戏构建可配置的模板时,这项工作可能会非常有价值,但是大约70%的时间用于制作那些游戏的副本. 模板和部署重新设置皮肤的实现. 

### 什么是Reskin?

公司的reskin的定义是使用相同的游戏机制,屏幕和元素的定位,但改变了视觉美学,​​如颜色和资产. 因此,在像"Rock Paper Scissors"这样的简单游戏的背景下,我们将创建一个具有如下基本资源的模板. 

![](https://cdn-images-1.medium.com/max/800/1*hgFoiDduNdXaLJ-0seB-Gw.jpeg)

但是当我们创建一个reskin,我们将使用不同的资产,游戏仍然可以工作. 如果你看看像Candy Crush或Angry Birds这样的游戏,你会发现它们有很多种类的同一款游戏. 通常万圣节,圣诞节或复活节发布. 从商业角度来看,它非常有意义. 现在......回到我们的实施. 我们的每个游戏都将共享相同的捆绑JavaScript文件,并加载到具有不同内容和资产路径的JSON文件中. 结果?

![](https://cdn-images-1.medium.com/max/800/1*SYAsVKSmEmcKQ8dEZiisPg.jpeg)

我和其他开发人员已经堆积了每日时间表,我的第一个想法是"很多都可以实现自动化. "每当我创建一个新游戏时,我都必须执行以下步骤: 

1.  在模板库上做一个git pull以确保它们是最新的;
2.  从主分支创建一个新的分支 - 由Jira故障单ID标识 - ;
3.  制作我需要构建的模板的副本;
4.  跑了一口气;
5.  更新a中的内容**config.json**文件. 这将涉及资产路径,标题和段落以及数据服务请求;
6.  在本地构建并检查与利益相关者的word文档匹配的内容. *是的,我知道*;
7.  与设计师核实他们对它的外观感到满意;
8.  合并到主分支并继续下一个分支;
9.  更新Jira票的状态,并为相关的利益相关者发表评论;
10. 冲洗并重复. 

![](https://cdn-images-1.medium.com/max/800/1*7Jg9xcM_hj6g8QC22vTiiw.jpeg)

现在对我而言,这比实际的开发工作更具行政能力. 我曾在之前的角色中接触过Bash脚本,并跳过它来创建一些脚本以减少所涉及的工作量. 其中一个脚本更新了模板并创建了一个新分支,另一个脚本执行了提交并将项目合并到Staging and Production环境. 

设置项目需要三到十分钟才能手动设置. 部署可能需要五到十分钟. 根据游戏的复杂程度,它可能需要十分钟到半天. 脚本有所帮助,但仍有大量时间用于更新内容或试图追查丢失的信息. 

![](https://cdn-images-1.medium.com/max/800/0*jxmPvnNgXhpFMV3v.)

编写代码来缩短时间是不够的. 它正在考虑更好地处理我们的工作流程,以便我可以更多地利用脚本. 将内容从单词文档中移出,并移入Jira票证,将其分解为相关的自定义字段. 设计人员不是发送公共驱动器上资产所在位置的链接,而是设置一个内容交付网络 (CDN) 存储库,其中包含资产的暂存和生产URL. 

### Jira API

这样的事情可能需要一段时间才能实施,但我们的流程确实会随着时间的推移而改善. 我对Jira的API进行了一些研究;我们的项目管理工具,并对我正在处理的Jira门票做了一些请求. 我退后了*很多*有价值的数据. 非常有价值,我决定将它集成到我的Bash脚本中,以便从Jira门票中读取值,并在完成后发布评论和标记利益相关者. 

### Bash过渡到节点

Bash脚本很好,但如果有人在Windows机器上工作,则无法运行. 在做了一些挖掘之后,我决定使用JavaScript将整个过程包装成一个定制的构建工具. 我打电话给这个工具**石匠**,它会改变一切. 

### CLI

当你使用Git  - 我假设你这样做 - 在终端中,你会发现它有一个非常友好的命令行界面. 如果您错误拼写错误或输入错误的命令,它会礼貌地就其认为您尝试键入的内容提出建议. 一个名为的库**指挥官**应用相同的行为,这是我使用的许多库之一. 

考虑下面的简化代码示例. 它正在引导命令行界面 (CLI) 应用程序. 

#### SRC / mason.js

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

使用npm,您可以运行您的链接**的package.json**它将创建一个全局别名. 

    ...
    "bin": {
      "mason": "src/mason.js"
    },
    ...

当我在项目的根目录中运行npm链接时. 

    npm link

它将为我提供一个我可以调用的命令,称为mason. 因此,每当我在终端中调用mason时,它都会运行它**mason.js**脚本. 所有任务都属于一个名为mason的伞命令,我每天都用它来构建游戏. 我节省的时间是......令人难以置信. 

您可以在下面看到 - 在我当时所做的假设示例中 - 我将Jira票号作为参数传递给命令. 这会使Jira API卷曲,并获取更新游戏所需的所有信息. 然后,它将继续构建和部署项目. 然后我会发表评论并标记利益相关者和设计师,让他们知道它已经完成. 

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

所有这些都完成了一些关键的笔触!

我对整个项目非常满意,我决定在我刚刚发布的一本书中重写一个更好的版本,**'使用Node.js自动化': **

![](https://cdn-images-1.medium.com/max/800/1*wOmVnWEaWu-1g-xL874xyg.jpeg)

> ***彩色打印: ***  [*http://amzn.eu/aA0cSnu*](http://amzn.eu/aA0cSnu)***点燃: ***  [*http://amzn.eu/dVSykv1*](http://amzn.eu/dVSykv1)***工房: ***  [*https://www.kobo.com/gb/en/ebook/automating-with-node-js*](https://www.kobo.com/gb/en/ebook/automating-with-node-js)\
> ***Leanpub: *** [*https://leanpub.com/automatingwithnodejs*](https://leanpub.com/automatingwithnodejs)***Google Play: ***  <https://play.google.com/store/books/details?id=9QFgDwAAQBAJ>

这本书分为两部分: 

### 第1部分

第一部分是一系列配方或指导构建块,其作用是单独的全局命令. 这些可以在您一天中使用,并且可以随时调用以加快您的工作流程或纯粹的方便. 

### 第2部分

第二部分是从头开始创建跨平台构建工具的演练. 实现某个任务的每个脚本都是它自己的命令,主伞命令 - 通常是项目的名称 - 将它们全部封装起来. 

书中的项目被称为**nobot** * (无机器人) *基于小卡通机器人. 我希望你喜欢阅读并学习一些东西. 

![](https://cdn-images-1.medium.com/max/800/1*fiOf2PARww-2wmOiV66iWA.jpeg)

我知道每个企业的情况和流程都不同,但是你应该能够找到一些东西,即使它很小,也可以让你的办公室变得更轻松. 

**花更多时间开发,减少管理时间. **

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

谢谢阅读!如果你喜欢,请给我们下面几个拍手. 👏

有关软件/硬件各方面的视频,请查看我的YouTube频道: <https://www.youtube.com/channel/UCKr-FjGzNdbbk--gvW5tzaw>

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
