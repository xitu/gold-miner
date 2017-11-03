
> * 原文地址：[Designing better tables for enterprise applications](https://uxdesign.cc/designing-better-tables-for-enterprise-applications-f9ef545e9fbd)
> * 原文作者：[Adhithya](https://uxdesign.cc/@adhithyarkumar)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/designing-better-tables-for-enterprise-applications.md](https://github.com/xitu/gold-miner/blob/master/TODO/designing-better-tables-for-enterprise-applications.md)
> * 译者：[Lai](https://github.com/laiyun90)
> * 校对者：[LeviDing](https://github.com/leviding) [Ruixi](https://github.com/Ruixi)

# 为企业应用设计更好的表格

## 深入了解如何在企业应用中设计表格，以及如何避免常见的错误

![](https://cdn-images-1.medium.com/max/800/1*CtL7L-xuiyljKBcX6kxjug.jpeg)

企业应用通常很复杂，因为要展示大量的包含多种来源、模式和用户信息的数据。需要先浏览一下复杂的图表、使用模式和数据列表，才能理解控制台的功能。

> 设计企业应用程序最大的挑战是来自在特定场景中工作与否的模式示例的缺乏。

由于大多数的企业应用程序都涉及与公司相关的敏感数据，所以很少有讨论设计企业应用程序时面临的常见问题的实例。现有的模式库深入讨论了每个组件如何运行工作，但是很少涉及何时使用它们。我们在设计库中看到的模式通常过于简单，而实际的企业应用程序在本质上数据和用例都更为复杂，这些模式并不起作用。 

> 这些模式在建模仓中没什么问题，但是一旦碰到复杂的工作流、特定范围的用户类型或者大规模数据时，就不能正常运行了。

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)

### 企业界的表格

下面是一个典型的企业应用界面。工作窗口里大量的面板上挤满了密密麻麻的信息，每个面板所指示的信息又和屏幕上的其他选项息息相关。

![](https://cdn-images-1.medium.com/max/800/1*DrmyxDMEPv7lSGK4W6jNFA.png)

图片来源：[http://docplayer.net/docs-images/24/3069798/images/8-0.png](http://docplayer.net/docs-images/24/3069798/images/8-0.png)

如上所述，应用程序中最耗费空间的部分是**表格**。本文将帮助设计师根据具体情况来探讨表格的正确使用方法。

一种过去大多面向消费者应用的模式，在企业界竟然也非常有效，并被广泛使用。然而也没有什么更好的方法，只有表格能展示庞大的数据列表。表格的作用在于企业应用的性质能够满足用户同时查看多行数据、通过警报扫描、比较数据，以及按照用户选择的任何特定顺序查看数据的要求。 

下面的这张图片看起来像是一个非常正常的表格，起初可能丝毫不会质疑它的可用性。但当你进一步使用它的时候，你会发现操作起来有点奇怪。

![](https://cdn-images-1.medium.com/max/800/1*hRCUhW9xF3DNMf_8iO7UGg.png)

企业应用中非常普遍的表格。

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)

### 1. 表格上的链接

![](https://cdn-images-1.medium.com/max/800/1*C9eu7Lcy_5K1hBA3cDIwRQ.png)

也许会跳转到用户的个人资料页。

第一个例子里，第一列上的链接可能暗示着点击后会跳转到用户的个人资料页面。虽然页面说明不是很清楚，但也不难猜到。

但是下面这个例子就未必了，你能猜到点击下图中的链接会跳转哪里吗？

![](https://cdn-images-1.medium.com/max/800/1*lNo9LTYR8NrnOt_IISKCGA.png)

这似乎是某种与每行内容有关的代码。以这种方式设置链接，会让用户感到困惑。

以上是一个来自企业应用程序的真实示例，点击链接后会将代码复制到剪贴板。但是这个操作不是很容易理解，应该避免这种意义不明的模式。

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)

### 2. 表格上的操作

删除、移动、打印、导出等是非常常见的操作，特别是在同时处理多个项目时。大多数企业应用程序每行都会有一个操作，这样设置有时很有必要，因为需要对某些特定行执行操作。话虽如此，其实大多数操作可以从表格的行中推算出来，成为页面的不同部分。

#### 靠近链接的操作

![](https://cdn-images-1.medium.com/max/800/1*qMOnR1H0nqFA9o3QLR-z3A.png)

要在一行中执行的操作位于距离标识列最远的最右边的列，而在本例中，操作位于第一列。

一行中要执行的操作的距离不应该远离识别列。通常情况下，这会导致在错误行上执行操作。如若不然，用户需要在识别追踪行上花费过多精力，并努力避免点击操作到另外的行。这种模式很容易出错，设计时应该避免。

#### 冗余操作

![](https://cdn-images-1.medium.com/max/800/1*dKwoZRKsF3BUQQb5Fj9t5w.png)

每行都有一个 **「删除」** 操作。

在这个例子中每行都重复出现一个「删除」操作。想象一下，每行有 5、6 个重复的操作选项，会让表格看起来非常混乱。不仅如此，这样的表格中也不能同时删除多个选项，因为没有办法选择进行多选。

![](https://cdn-images-1.medium.com/max/800/1*CJd_ovH-TA7Y_9jLV4dzow@2x.png)

现代企业应用的一个示例，表格里每项之前都有一个复选框。

在同一时间、同一个表格里，选择并执行多个项目上的操作的一个好的模式是每行都允许被选中。选中后，工具栏出现在表格的上方或下方，可以进行要执行的操作。

![](https://cdn-images-1.medium.com/max/800/1*9zqme5j3KEbNZf2V0GJXkw@2x.png)

在表格里选择多个项目后，有一个工具栏可以对所选项目执行操作。

大多数具有表格形式的列表项的企业应用程序都遵循这种模式。但是一些设计师也发现，因为表格的每行都有复选框，所以在视觉上有点混乱、令人不知所措。

在下图中可以看到，Google 收件箱的模式是，只有当鼠标悬停在该行的最左侧时，复选框才会显示出来。另外，对于操作能力较强的用户，可以使用 shift 快捷键同时选择多个项目。这是在表格上实现操作模式的一个非常好的例子。

![](https://cdn-images-1.medium.com/max/800/1*TQxn1KS_PbVsqYeFaePDCg.gif)

这种模式减少了视觉上的混乱，让用户可以思考如何实现多选。我也是尝试了几次后才找到一种可以多选的方法。

只有图标的操作选项是另一种常用的让用户思考的模式，而一个经典的用户体验法则是 [别让用户思考](https://book.douban.com/subject/1901208/)。这种模式让用户记住每个图标的含义和位置。

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)

### 3. 表格的分页和搜索

由于企业应用程序的数据量巨大，所以表格通常要运行多个页面。设计师希望了解用户是会通过翻页来查看数据，还是只查看第一页显示的内容。

> 如果表格不需要翻页就能查看数据，那这种企业应用的表格模式就是成功的。

如何实现表格不翻页就能查看数据呢? **优秀的过滤器和强大的搜索机制。**

用户翻页是因为他们正在寻找特定的信息。所以在我们设计翻页之前，必须提出一个问题

> 如何才能更快捷方便地在表格里查找信息？

一个很好的成功解决方案是在自然语境的上下文中设置过滤器。也就是说，基于当前屏幕上的用户工作流程，过滤器显示与当前场景最相关的选项。

![](https://cdn-images-1.medium.com/max/800/1*GyKRd_H80qoU-198Vnx5Dw.png)

例如，在这个演示应用程序中，根据用户的不同工作流程阶段出现不同的过滤器。也许很难实现，但是一旦成功，将是用户体验的一个伟大胜利。

**什么时候搜索能够起到帮助作用？**

刚刚离开当前页面的时候..

![](https://cdn-images-1.medium.com/max/800/1*-PSI6fE5geCxfCsO9jV24A.png)

图片来源：[https://www.aspsnippets.com/Articles/Alphabet-Paging-using-Alphabetical-Pager-in-ASPNet-GridView.aspx](https://www.aspsnippets.com/Articles/Alphabet-Paging-using-Alphabetical-Pager-in-ASPNet-GridView.aspx)

---

现在我们知道了如何考虑分页设计，无论如何这是很有必要的。我最不能忍的一种分页方式是下图中呈现的项目限制：

![](https://cdn-images-1.medium.com/max/800/1*0d74ZT5gQYQo3hxDtSXVhA.png)

这个系统每页展示 10 条数据。

用户在一页中只能查看 10 条数据，必须要翻页来查看第 11 条。为什么不能编写程序来查看表格下一页是否只有 1 到 3 条数据，如果是的话全部展示在当前这页呢？或者可以做得更好一点，判断条目少于 25 项不做分页。这些并不难实现，只是他们并没有多加考虑。

#### 分页上多选被中断

![](https://cdn-images-1.medium.com/max/800/1*cOnC-SXXAH0F39BAenXsgQ.gif)

翻页后多选失效。

用户勾选了第一页的三个选项，然后去勾选第二页的前四个选项，逻辑上来说，他点击删除按钮时，这 7 项会被全部删除。但是实际上并不会发生，因为分页时跨页面保留用户选择的信息实现起来技术挑战难度较大，成本也很高。

表格中有分页时，选择**全部**项目是另一个挑战。用户只可能选择当前视图中的所有项，或者选择完整列表中的所有项。 

![](https://cdn-images-1.medium.com/max/800/1*3hHg3-2lHMjQfOLrpJoqTg.gif)

分页时选择全部项目可能会很混乱。

上面的例子里，用户先选择了当前页面上的所有选项，然后在整个列表中选择了全部 3000 个选项。分页操作后，勾选的信息失效了。这又是由于分页技术的局限性，因为从工程技术角度来看，保留选择记忆的成本很高。

**无限滚动或者延迟加载的效果又如何呢？**

许多应用程序目前正在从全部分页模式转型到 Facebook 或 Twitter 风格的无限加载信息模式。对此，设计师们各执一词。对我个人而言，一个「加载更多」按钮效果最好。

![](https://cdn-images-1.medium.com/max/800/1*O1e15RjpEpJU-8KQo34wdw.png)

在当前加载的表格最后增加一个「加载更多」按钮。

这只会加载当前视图中的内容，如果用户主动执行加载更多地操作，则会加载出更多内容。

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)

### 最后一点想法

本文并不是一个设计表格的绝对正确的建议指南，只是一个设计表格时常见问题和解决这些问题的方法的集合。如果你有任何关于设计表格的补充建议，希望你能来信一起讨论。

[Andrew Coyle](https://medium.com/@CoyleAndrew) 在[设计更好的数据表格](https://uxdesign.cc/design-better-data-tables-4ecc99d23356)一文中提出了很好的设计表格用户界面的建议。强烈建议你读一读，以便了解良好的表格交互实践。

---

本文图片模板来自[Sketch App Resources](https://www.sketchappsources.com/free-source/2490-payment-system-admin-template-sketch-freebie-resource.html)，是由[Jurij Ternicki](https://medium.com/@ternicki)制作的支付管理系统原型。

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)

**我是 Adhithya ，旧金山 OpenDNS 的产品设计师。**

你可以关注我的 **[Twitter](https://twitter.com/adhithyaux)**； **[戳这里](http://www.adhithyakumar.com)** 查看我的作品；或者直接发邮件联系我 adhithya.ramakumar@gmail.com

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)

Adhithya 写了这篇文章来分享知识技能，并帮助设计社区成员成长。所有在 uxdesign.cc 上发布的文章都循序相同的[**设计哲学**](https://uxdesign.cc/the-design-community-we-believe-in-369d35626f2f)

![](https://cdn-images-1.medium.com/max/800/1*aNPBhln7iDMY8qRcmoyCfA.jpeg)


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
