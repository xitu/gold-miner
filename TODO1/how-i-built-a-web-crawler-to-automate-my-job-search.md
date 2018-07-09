> * 原文地址：[How I automated my job search by building a web crawler from scratch](https://medium.freecodecamp.org/how-i-built-a-web-crawler-to-automate-my-job-search-f825fb5af718)
> * 原文作者：[Zhia Hwa Chong](https://medium.freecodecamp.org/@zhiachong?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-built-a-web-crawler-to-automate-my-job-search.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-i-built-a-web-crawler-to-automate-my-job-search.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[liruochen1998](https://github.com/liruochen1998)

# 我是如何从零开始建立一个网络爬虫来实现我的求职自动化的

### 起因

一个周五的午夜，我的朋友们在外面玩得很开心，而我仍在电脑前工作。

奇怪的是，我并没有感觉被忽视了。

我在做一些我认为真正有趣而且非常优秀的事情。

我刚从大学毕业，所以迫切地需要得到一份工作。当我离开西雅图的时候，我的背包里装满了大学课本和衣服。我可以在我的  2002 Honda Civic 后备箱中装上我的所有东西。

当时我不太喜欢社交，因此我决定用所知道的最好的方式来解决工作的问题。我试图创建一个应用程序来帮助我，这篇文章就是关于我是如何实现这一目标的。😃

### 开始使用 Craigslist

我在房间里，疯狂地开发软件，来帮我收集和回应那些在 [Craigslist](https://seattle.craigslist.org/) 上寻找软件工程师的人。Craigslist 本质上是互联网市场，在这里你可以找到出售的物品、服务、社区博客等。

![](https://cdn-images-1.medium.com/max/800/1*bEUpEKkCb2FD-wWiofJhhg.png)

Craigslist

当时，我从未构建过一个完全成熟的应用程序。我在大学里做的大部分事情都是一些学术项目，包括建立和解析二叉树、计算机图形学和语言处理模型。

我是个“小白”。

尽管如此，我还是了解到一个叫做 Python 的热门编程语言。我对 Python 知之甚少，但我还是不知疲倦地去学习关于它的知识。

因此我决定两两组合，用这种新的编程语言构建一个小的应用程序。

![](https://cdn-images-1.medium.com/max/800/1*cH7ortIVgkJ-q-da1AHW7w.jpeg)

### 构建（工作）原型之旅

我有一台用过的 [BenQ](https://www.engadget.com/2007/11/19/benq-intros-the-joybook-r43-laptop/) 笔记本，是我上大学时哥哥送给我的，我现在用它来进行开发。

从任何角度来说，这都不是最好的开发环境。我正在使用 Python 2.4 和 [Sublime text](https://www.sublimetext.com/2) 的一个旧版本，不过从头开始编写应用程序的过程确实是一种令人兴奋的体验。

我仍然不知道应该要做什么。我尝试了各式各样的事情来看看自己到底需要什么。我的第一个方法是找出我如何才能轻而易举地访问 Craigslist 数据。

我查找了 Craigslist 是否存在公开可用的 REST API。令我难过的是，并没有这些接口。

然而，我发现了**另一个好东西**。

Craigslist 有一个 [RSS 提要](https://www.craigslist.org/about/rss)，仅供个人使用。RSS 提要本质上是一个**可读的计算机摘要**网站发送的更新。在这种情况下，RSS 提要允许我在发布新的任务列表时获取它们。这对于我的需要来说，实在是太**完美了**。

![](https://cdn-images-1.medium.com/max/800/1*1b3dFtKBqYCxKSMx2dgi0w.png)

RSS 提要的示例

接下来，我需要一种可以读取 RSS 提要的方法。我不想亲自手动浏览 RSS 概要，因为那将是一个时间接收器，这与浏览 Craigslist 没有任何区别。

这个时候，我开始意识到 Google 的力量。有一个笑话说软件工程师大部分时间在 Google 上找答案。我觉得这是有一定道理的。

我用 Google 搜素了一下，我在 [StackOverflow](https://stackoverflow.com/questions/10353021/is-there-a-developers-api-for-craigslist-org) 上找到了一篇有用的文章，其中描述了如何通过 Craiglist RSS 提要进行搜索。这是 Craigslist 免费提供的过滤功能。我所要做的就是传递一个我所感兴趣的具有特定关键字的查询参数。

我专注于在西雅图寻找与软件相关的工作。在这个前提下，我在西雅图输了一个特定的 URL,来查找包含关键字 “software” 的信息。 

> [https://seattle.craigslist.org/search/sss?format=rss&query=software](https://seattle.craigslist.org/search/sss?format=rss&query=software)

很好，起作用了。**非常漂亮**。

![](https://cdn-images-1.medium.com/max/800/1*X06SL3fTW1Xbn5d3Tg__hw.png)

例如，标题为 “software” 的西雅图 RSS 提要。

### Beautiful soup 是我所使用的工具中，最好用的一个

令我不敢相信的是，我的方法起作用了。

首先，**限制列举数量**。我的数据没有包含西雅图**所有**可用职位的公告。返回的结果只是整个结果的一个子集。我希望尽可能地把范围扩大，所以我需要知道所有可用的职位清单。

其次，我意识到 RSS 提要 **不包含任何联系信息**。这确实有点让人失望。我可以找到这些清单，但是我无法联系这些发布者，除非我手动过滤这些清单。

![](https://cdn-images-1.medium.com/max/800/1*Uz73WPgVsJcy6Xievjcpgg.png)

Craigslist 回复链接的截图

我是一个有很多技能而且有很多兴趣的人，但是重复手动工作并不是其中之一。我本可以雇用别人帮我做这件事，但是我仅能用一美元的拉面勉强维持生活，所有这就意味着我不能在这个附带的项目上任意挥霍。

这是死胡同，但并不意味着**结束**。

### 持续迭代

从第一次失败的尝试中，我了解到 Craigslist 有 RSS 提要，并且每个博客都有转到真实博客本身的链接。

很好，如果我可以访问真实的博客，那么也许我可以爬取它的电子邮箱地址？🧐 这意味着我需要找到一种方法从原始博客中获取电子邮件地址。

这一次，我依旧找到了我所信任的 Google，搜索 “ways to parse a website。”

在 Google 上，我发现了一个很酷的 Python 小功能，叫做 [Beautiful Soup](https://www.crummy.com/software/BeautifulSoup/)。本质上，它是一个很好工具，允许你解析整个 [DOM 树](https://www.w3schools.com/js/js_htmldom.asp)，并帮助你理解网页的结构。

我的需求很简单：我需要一个易于使用的工具，可以让我从网页上收集数据。BeautifulSoup 检查了这两个盒子而不是花更多的时间挑选**最好的工具**，我选择了一个有用的工具，然后继续下去。这里是具有相似操作的[可选列表](https://www.quora.com/What-are-some-good-Python-libraries-for-parsing-HTML-other-than-Beautiful-Soup) 。

![](https://cdn-images-1.medium.com/max/800/1*fiIuenHyDFq0-u29iRjSPw.png)

BeautifulSoup 的主页

> 小贴士：我发现一个很优秀的[指南](https://medium.freecodecamp.org/how-to-scrape-websites-with-python-and-beautifulsoup-5946935d93fe)，它描述了如何使用 Python 和 BeautifulSoup 进行网页抓取。如果你有兴趣学习如何爬虫，那么我建议你阅读它。

有了这个新工具，我的工作流也就设置好了。

![](https://cdn-images-1.medium.com/max/1000/1*YIz3i_2XwGBtdFkDVecEng.png)

我的工作流

我现在已经准备好进行下一个任务了：从实际的博客中抓取电子邮件地址。

现在，关于开源技术，有件很酷的事情。他们是自由的而且工作很棒！这就像在炎炎夏日里免费吃冰淇**和**一块新烤好的巧克力曲奇饼一样。

BeautifulSoup 允许你在网页上搜索特定的 HTML tag 或者 marker。而且 Craigslist 已经把它们处理的很好了，所以找到电子邮件地址轻而易举。tag 是类似于 “email-reply-link” 这样的东西，它基本上已经说明了电子邮件链接是可用的。

自此以后，一起都变得简单了。我依赖于 BeautifulSoup 提供的内置功能，只需使用一些简单的操作，我就可以很容易的从 Craigslist 博客中获取电子邮件地址。

### 进行内容组合

不到一小时，我就有了自己的第一个 MVP，我已经建立了一个网页爬虫，可以收集电子邮件地址，并回复西雅图半径 100 英里范围内寻找软件工程师的人。

![](https://cdn-images-1.medium.com/max/800/1*xzmVR8pbbBgB-f1JR9s1mg.png)

代码截图

我在原始脚本的基础上添加了各种附加组件，来得到更好的效果。例如，我将结果保存在 CSV 和 HTML 页面中，以便可以更快速地解析它们。

当然还有许多其他值得注意的特点，例如：

*   记录我发送电子邮件地址的能力
*   疲劳规则可以防止向我已经接触过的人发送电子邮件的特殊情况
*   特列，一些邮件在显示之前，需要验证码，以防止机器人操作（就像我这样的）
*   Craigslist 不允许爬虫在它们的网页上，所以如果我运行的太频繁，就会被禁止操作。（我试图在不同的 VPN 之间切换，来“欺骗” Craigslist,但是不起作用）。
*   我仍然无法检索 Craigslist 上的**所有**帖子

最后一个是 kicker。但我认为如果一个帖子已经存在一段时间，那么发帖人可能无法在找到。这需要权衡，但我应该可以处理。

整个体验就像是 [Tetris](https://en.wikipedia.org/wiki/Tetris)。我知道我的最终目标是什么，而我真正的挑战是把合适的部分组合在一起以实现特定的最终目标。每一个拼图都给我带来了不同的旅程。虽然这很有挑战性，但我却乐在其中，而且每一次我都会学到新的东西。 

### 学到的教训

这是一次让人大开眼界的经验，我最终学习了一些关于互联网（和 Craigslist）如何运行的知识，各种不同的工具如何协同工作来解决一个问题，而且我得到了一个很酷的小故事，我可以和朋友分享这些。

从某种意义上说，这就像现在的技术是如何工作的。你发现了一个你需要解决的巨大而复杂的问题。而你看不到任何直接的、明显的解决方案。你把这个大而复杂的问题分解成多个不同的可管理的块，然后依次解决每一个块。

回顾过去，我的问题是：**我如何才能利用互联网上这个优秀的目录，迅速接触到有特定兴趣的人？**当时没有已知的产品或解决方案，所以我把它分解成多个部分：

1.  查找平台上的所有列表
2.  收集有关每个列表的联系信息
3.  如果有联系信息，就发送一封邮件

这就是它的全部。**技术只是作为达到目的手段**。如果我能用 Excel 电子表格来帮我做，我会选择这样做。然而，我不是 Excel 大师，所以我采用了当时对我最有意义的方法。

#### 有待改进的地方

我还有很多地方可以改进：

*   我选择了一门并不熟悉的语言开始，所以一开始会存在学习曲线。还好并不算太糟糕，因为 Python 非常容易掌握。所以我强烈建议任何一个软件爱好者使用它作为第一门语言。
*   **过度依赖开源技术，开源软件自己也存在的一系列问题。** 我使用的多个库不再处于积极的开发阶段，因此我很早就遇到了问题，我无法导入库，或者库因为一些看似无害的原因而失败。
*   **独自处理一个项目可能很有趣，但是同时带来的压力也不容小觑**。你需要很大的动力才可以获取这些东西。这个项目快速而简单，但是我仍然花了几个周末来改进。随着项目的进行，我开始失去了动力，找到工作后，我完全放弃了这个项目。

### 我使用的资源和工具

[The Hitchhiker’s Guide to Python](https://amzn.to/2J73RtJ) —— 总的来说，这是一本学习 Python 的好书。我推荐 Python 作为初学者的第一门编程语言，在我的[文章](https://medium.freecodecamp.org/how-i-landed-offers-from-microsoft-amazon-and-twitter-without-an-ivy-league-degree-d62cfe286eb8)中，我讨论了如何使用它获取来自多家顶级公司的报价。

[BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/) —— 用于构建我的网络爬虫的实用性工具。

[Web Scraping with Python](https://amzn.to/2sa43xR) —— 学习如何使用 Python 进行 web 抓取的实用性指南。

[Lean Startup](https://amzn.to/2GLnRN6) —— 从这本书中，我学到了快速原型和创建一个 MVP 来测试的想法。我认为这里的想法适用于许多不同的领域，它也帮助我完成了这个项目。

[Evernote](http://evernote.com) —— 我使用 Evernote 来为这篇文章组织我的想法。强烈推荐它 —— 我使用它来做我做的**每一件事**。

[我的笔记本电脑](https://amzn.to/2s9sziy) —— 这是我目前在家用的笔记本电脑，设置为一个工作站。与一台旧的 BenQ 笔记本相比，使用它要**容易的多**，但两者都适用于一般的编程工作。

**Credits:**

[Brandon O’brien](https://twitter.com/hakczar)，我的良师益友，对于如何改进这篇文章进行校对，而且提供了有价值的反馈。

[Leon Tager](https://twitter.com/OSPortfolio)，我的同事和朋友，用我迫切需要的经济智慧引领我，启迪我。

你可以注册 ndustry news 和 random tidbits，并在我登录[的地方](http://eepurl.com/dnt9Sf)发布新文章时，成为第一个知道的人。

* * *

**Zhia Chong 是 Twitter 的软件工程师。他在西雅图的广告测量团队工作，评估广告客户的影响和投资回报率。该团队是** [**hiring**](https://careers.twitter.com/en/work-for-twitter/201803/software-engineer-backend-advertising-measurement.html)！

**你可以在 **[**Twitter**](https://twitter.com/zhiachong) **和** [**LinkedIn**](https://www.linkedin.com/in/zhiachong/) **上找到他。**

感谢[开源 portfolio](https://medium.com/@osportfolio?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
