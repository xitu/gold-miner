> * 原文地址：[How to Write Beautiful and Meaningful README.md](https://blog.bitsrc.io/how-to-write-beautiful-and-meaningful-readme-md-for-your-next-project-897045e3f991)
> * 原文作者：[Divyansh Tripathi [SilentLad]](https://medium.com/@silentlad)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-beautiful-and-meaningful-readme-md-for-your-next-project.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-write-beautiful-and-meaningful-readme-md-for-your-next-project.md)
> * 译者：[Jessica](https://github.com/cyz980908)
> * 校对者：[Vito](https://github.com/vitoxli), [Hsu Zilin](https://github.com/Starry316)

# 如何写出优雅且有意义的 README.md

#### 写出一个超棒的 Readme 文件的小技巧（以及为什么 README 很重要）

作为开发人员，我们对代码以及项目中的所有细节都信手拈来。然而我们中的一些人（包括我在内）就连在网络社区中的软技能都缺乏。

> **一个开发人员会花一个小时来调整一个按钮的 padding 和 margin。却不会抽出 15 分钟的来完善项目的 Readme 文件。**

> 我希望你们大多数人已经知道 README 文件是什么，它是用来做什么的。但是对于萌新来说，我还是会尽可能地来解释它到底是什么。

#### 什么是 Readme.md？

README（顾名思义：“read me“）是启动新项目时应该阅读的第一个文件。它既包含了一系列关于项目的有用信息又是一个项目的手册。它是别人在 Github 或任何 Git 托管网站点，打开你仓库时看到的第一个文件。

![](https://cdn-images-1.medium.com/max/2000/1*DZa8j46R3Rw0nNYRLewSqg.png)

你可以清楚地看到，**Readme.md** 文件位于仓库的根目录中，在 Github 上的项目目录下它会自动显示。

`.md` 这个文件后缀名来自于单词：**markdown**。它是一种用于文本格式化的标记语言。就像 HTML 一样，可以优雅地展示我们的文档。

下面是一个 markdown 文件的例子，以及它在 Github 上会如何渲染。这里，我使用 VSCode 预览，它可以同时显示 markdown 文件渲染后的预览。

![](https://cdn-images-1.medium.com/max/2144/1*WAn_bJ_mLxOMCzBAKtu4ZQ.png)

如果你想要深入了解这门语言，这里有一个官方的 **[Github Markdown 备忘录](https://guides.github.com/pdfs/markdown-cheatsheet-online.pdf)**。

## 为什么要在 Readme 上花时间？

现在我们谈正事吧。你花了几个小时在一个项目上，你在 GitHub 上发布了它，并且你希望游客、招聘人员、同事、（或者前任？）看到这个项目。你真的认为他们会进入 `root/src/app/main.js` 来查看你的代码的逻辑吗？真的会吗？

现在你已经意识到这个问题了，让我们看看如何解决这个问题。

## 为你的组件生成文档

除了项目的 Readme 之外，记录组件对于构建易于理解的代码库也很重要。这使得重用组件和维护代码变得更加容易。比如，使用像[**Bit**](https://bit.dev) ([Github](https://github.com/teambit/bit)) 这样的工具，来为在 [bit.dev](https://bit.dev) 上共享的组件自动生成文档。（译者注：这里是作者在打广告）

![例子：在 Bit.dev 上共享的组件中查找](https://cdn-images-1.medium.com/max/2000/1*Nj2EzGOskF51B5AKuR-szw.gif)
[**团队共享可重用的代码组件 · Bit**](https://bit.dev)

## 描述你的项目！（技巧说白了就是）

为你的项目写一个好的描述。仅出于建议，您可以将描述的格式设置为以下主题：

* 标题（如果可以的话，提供标题图像。如果你不是平面设计师，请在 canva.com 上进行编辑）；
* 描述（用文字和图片来描述）；
* Demo（图片、视频链接、在线演示 Demo 链接)；
* 技术栈；
* 你项目中需要注意的几个陷阱（你遇到的坑、项目中的独特元素）；
* 项目的技术说明，如：安装、启动、如何贡献；

## 让我们深入探讨技术细节

我将使用我的这个项目作为参考，我认为它是我写过甚至遇到过的最漂亮的 Readme 文件之一。你可以在这里查看它的 Readme.md 文件的代码: [**silent-lad/VueSolitaire**](https://github.com/silent-lad/VueSolitaire)

使用铅笔图标来显示 markdown 代码：

![](https://cdn-images-1.medium.com/max/2000/1*fmypQUo2pAjk9GOCO1lPnQ.png)

## 1. 添加图片！拜托!

你可能对你的项目记忆犹新，但是你的读者可能需要一些项目演示的实际图片。

例如，我制作了一个纸牌项目，并在 Readme 文件中添加了图像作为描述。

![](https://cdn-images-1.medium.com/max/2000/1*29b3hWXq4PTI1Yg2J97RyA.png)

现在你可能想要添加一个视频描述您的项目。就像我项目里那样。但是，Github 不允许在 Readme 文件中添加视频。那…该怎么办呢？

#### …我们可以使用 GIF

![哈哈！搞定你了 Github。](https://cdn-images-1.medium.com/max/2000/1*iP4iC4WnyEJHE9SQ7oROWQ.gif)

GIF 也是一种图片，Github 支持我们将它放在 Readme 文件中。

## 2. 荣誉勋章

Readme 文件上的徽章会使游客有一定的真实感。您可以从下面的网址，为您的仓库设置自定义或者常规使用的盾牌（徽章）：[**https://shields.io**](https://shields.io/) 

![](https://cdn-images-1.medium.com/max/2000/1*iGaDiLE_BwCbSROvPT8XKg.png)

你还可以设置个性化的盾牌，如仓库的星星数量和代码百分比指标。

## 3. 增加一个在线演示 Demo

如果可以的话，请托管你的项目，并开启一个正在运行的演示 demo。之后，**将这个演示链接到 Readme 文件**。你也不知道可能会有多少人来“把玩”你的项目。另外，招聘人员只喜欢可以在线演示的项目。**它表明你的项目不仅仅是放在 Github 上的代码，而是确实跑起来业务。**

![](https://cdn-images-1.medium.com/max/2000/1*LSR8M5mctiQsFsPzsH9ujQ.png)

您可以在 Readme 中使用超链接。比如在标题图片下面提供一个在线演示链接。

## 4. 使用代码样式

Markdown 提供了将文本渲染为代码样式的选项。因此，不要以纯文本形式编写代码，应该使用 \`（反单引号）将代码包裹在代码样式中，例如 `var a = 1;`。

Github还提供了**指定代码编写语言**的选项，这样它就可以使用特定的文本高亮来提高代码的可读性。你只需要这样使用：

**\`\`\`{代码语言}\<space>{代码块}\`\`\`**

{ \`\`\` } —— 三个反单引号用于多行代码，同时它还允许你指定代码块的语言。

**使用代码高亮：**

![](https://cdn-images-1.medium.com/max/2000/1*lTbiCaBk1Y4TWG4bI1-D7A.png)

**不使用代码高亮：**

![](https://cdn-images-1.medium.com/max/2000/1*_w3yaD4Lhcwqxa2AU4TSrA.png)

## 5. 使用 HTML

是的，你可以在 Readme 里使用 HTML。尽管并不是 HTML 里所有的功能都可以使用，但大部分可以。虽然你最好是只包含 markdown 的语法，但一些功能，如居中图像和居中文本是只能用 HTML 实现的。

![](https://cdn-images-1.medium.com/max/2726/1*pq9WpGpyChqxmTLMz34l5A.png)

## 6. 有创造性

剩下的就交给你了，每个项目都需要不同的 Readme.md 文件和不同类型的描述。但是请记住，你在 Readme 文件上花费的 15 —— 20 分钟可能会对你 Github 的访问者数量产生**巨大**的影响。

仅供参考，这里有一些带 Readme 的项目：

- [**silent-lad/VueSolitaire**](https://github.com/silent-lad/VueSolitaire)
- [**silent-lad/Vue2BaremetricsCalendar**](https://github.com/silent-lad/Vue2BaremetricsCalendar)

## 了解更多

- [**如何在项目和应用之间共享 React UI 组件**](https://blog.bitsrc.io/how-to-easily-share-react-components-between-projects-3dd42149c09)
- [**2020 年的 13 个顶级 React 组件库**](https://blog.bitsrc.io/13-top-react-component-libraries-for-2020-488cc810ca49)
- [**2020 年的 11 个顶级 React 开发人员工具**](https://blog.bitsrc.io/11-top-react-developer-tools-for-2020-3860f734030b)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
