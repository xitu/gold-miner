> * 原文地址：[A guide to color accessibility in product design](https://medium.com/inside-design/a-guide-to-color-accessibility-in-product-design-516e734c160c)
> * 原文作者：[InVision](https://medium.com/@InVisionApp?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-color-accessibility-in-product-design.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-guide-to-color-accessibility-in-product-design.md)
> * 译者：[Hopsken](https://hopsken.com)
> * 校对者：

# A guide to color accessibility in product design

## 关于无障碍设计的讨论有很多，但你是否想过色彩的无障碍设计？

最近，有一个客户带来了一个项目，该项目具有非常具体、复杂的无障碍色彩体系。由此，我意识到，这个课题是如此重要，其内容又是如此丰富。

![](https://cdn-images-1.medium.com/max/800/1*U3GwUaniqzo5nZYd2LkaUA.png)

图片：[Justin Reyna](https://twitter.com/justinreyreyna)

让我们来学习如何使用你已经知道的设计原则来进行色彩无障碍设计。

### 为什么无障碍性如此重要？

数字产品的[无障碍设计](https://invisionapp.com/inside-design/accessibility-for-developers/)旨在为所有人提供精致的使用体验，这包括我们中有视觉、语言、听觉、身体或者认知障碍的人。作为设计师、开发者以及所有科技行业从业人员，我们有能力去创造一个我们所有人都位置骄傲的网络 —— 一个为所有人创造，服务于所有人，不排斥任何群体的网络。

而且，做出不具备无障碍性的产品是种很粗鲁的行为。所以，请保持礼貌。

[色彩无障碍设计](https://invisionapp.com/inside-design/guide-web-content-accessibility/)使得有视力障碍或者色觉缺陷的人能够获得与正常人同样的数字体验。2017年，[WHO（世界卫生组织）](http://www.who.int/en/news-room/fact-sheets/detail/blindness-and-visual-impairment)估计，大约有 2.17 亿人患有某种形式的中度至重度视力障碍。仅凭这个数据，我们就有足够的理由去做无障碍设计。

> _“做出不具备无障碍性的产品是种很粗鲁的行为。所以，请保持礼貌。”_

无障碍设计不仅仅只是道德上的最佳实践，如果不服从关于无障碍性的监管要求，还会有潜在的法律隐患。在 2017 年，联邦法院收到过至少[ 814 条](https://www.adatitleiii.com/2018/01/2017-website-accessibility-lawsuit-recap-a-tough-year-for-businesses/)关于网站涉嫌未提供无障碍访问的诉讼，包括为数不少的集体诉讼。各个组织都在努力建立无障碍性标准，其中最著名的是美国无障碍委员会（United States Access Board，Section 508）和 W3C 组织（World Wide Web Consortium）。以下是这些规范的概述:

*   **Section 508:** 508 号法令援引自 1973 年康复法案（Rehabilitation Act of 1973）的第 508 节。你可以在[这里](https://www.section508.gov/manage/laws-and-policies)找到详细的说明。总而言之，根据 508 法令，如果你隶属于联邦机构，或者为联邦机构构建网站（例如：承包商），那么你的网站必须具有无障碍性。
*   **W3C:** W3C 组织是一个国际性的自发性组织，于 1994 年建立，为互联网提供开发性规范。在 [WCAG 2.1](https://www.w3.org/TR/WCAG21/) 中，W3C 概述了它们关于互联网无障碍性的指导方针。这基本上就是关于互联网无障碍性的金科玉律。

### 确保你的产品具备色彩无障碍性

最好是在产品生命周期的早期就考虑无障碍性 —— 这在以后可以帮您省下不少时间和金钱。为了保证色彩无障碍性，在你为产品选择主题色彩时就要考虑好，随着产品发展下去，你会发现这么做的好处。

Here are some quick tips to ensure you’re creating color-accessible products.

#### 提供足够的对比度

为了达到 [W3C 标准 AA 评级](https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html)最低限度，背景与文字的对比度至少为 4.5:1。因此，在设计按钮、卡片或者导航元素之类时，记得检查色彩组合的对比度是否符合要求。

![](https://cdn-images-1.medium.com/max/800/1*PZXhnoxM0Sza0AJWp8G1BA.png)

有很多工具可以帮助你检查色彩组合的无障碍性，我个人认为最好用的是 [Colorable](https://colorable.jxnblk.com/ffffff/6b757b) 和 [Colorsafe](http://colorsafe.co/)。我之所以喜欢 Colorable 是因为你可以通过使用滑动条来调整色相、饱和度和明度，它会实时显示出你的调整将如何影响特定颜色组合的无障碍性。

#### 不要单纯依赖颜色

为了保证无障碍性，确保你没有完全依赖颜色来展示系统不同层级的关键信息。因此，对于错误状态、成功状态或者系统警告等，诸如此类，确保同时使用文字或者图标来清晰地展示发生了什么。

![](https://cdn-images-1.medium.com/max/800/1*gmsRDSNDAzUqs-SG-D5P4Q.png)

除此以外，当展示图片、表格之类时，允许用户选择是否加入纹理或图案。确保色盲用户能够准确地分辨出它们，而不用担心颜色会影响他们对数据的理解。[Trello](https://www.trello.com/) 在这上面做得很棒，它特别提供了[色盲友好模式](https://twitter.com/trello/status/543420024166174721?lang=en)。

![](https://cdn-images-1.medium.com/max/800/1*D6PDBf8Y7YNof6Fkh9X5gQ.png)

### 聚焦（Focus）状态对比度

当使用键盘浏览站点时，聚焦状态可以通过在元素周围显示视觉引导来帮助人们在页面上导航。这对有视觉缺陷、运动障碍，以及只是喜欢用键盘导航的人群会很有帮助。 

所有浏览器都有一个默认的聚焦状态颜色，但是如果你打算在你的产品上覆盖掉它，那么请务必确保你有提供足够的色彩对比度。这使得有视力障碍或色觉缺陷的人群可以通过聚焦状态在页面内导航。

#### 文档化和推广色彩系统

最后，创建色彩无障碍系统过程中最关键的一步就是，要让你的团队能够在需要的时候能够查阅它，这样每个人都清楚恰当的用法。这不仅可以减少混乱和滥用，也可以保证在你的团队中无障碍设计永远是个优先事项。根据我的经验，明确地在 UI 套件或设计系统中显示出特定颜色组合的可访问性评级是最有效的，尤其是在通过某个工具（如：[InVision Craft](https://www.invisionapp.com/craft) 或 [InVision DSM](https://support.invisionapp.com/hc/en-us/articles/115005685166-Introduction-to-Design-System-Manager)）进行团队间合作时。这里有一个关于如何文档化背景文字颜色组合及其可访问性评级的例子。

![](https://cdn-images-1.medium.com/max/800/1*N_9UOR4mnJyxJq4Cg071LQ.png)

### 让我们行动起来

这只是一些提高产品无障碍性的小建议。另外，别忘了这只是关于色彩无障碍性的建议。要想详细地了解无障碍设计原则，推荐先熟悉 [WCAG 2.1](https://www.w3.org/TR/WCAG21/) 规范。虽然这些规范看上去有些吓人，但网上有**大量的**的资源可以帮到你。如果遇到困难，不要犹豫，向你身边的（或者网上的）设计师们寻求帮助。


> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
