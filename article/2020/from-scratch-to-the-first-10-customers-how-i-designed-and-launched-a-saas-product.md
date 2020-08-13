> - 原文地址：[From scratch to the first 10 customers: How I designed and launched a SaaS product](https://codeburst.io/from-scratch-to-the-first-10-customers-how-i-designed-and-launched-a-saas-product-9176a8996b89)
> - 原文作者：[Valerio Barbera](https://medium.com/@valeriobarbera)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/from-scratch-to-the-first-10-customers-how-i-designed-and-launched-a-saas-product.md](https://github.com/xitu/gold-miner/blob/master/article/2020/from-scratch-to-the-first-10-customers-how-i-designed-and-launched-a-saas-product.md)
> - 译者：[YueYongDEV](https://github.com/YueYongDev)
> - 校对者：[scarqin](https://github.com/scarqin)、[lsvih](https://github.com/lsvih)

# 从头开始到最初的 10 个客户：我是如何设计并推出一个 SaaS 产品

![Photo by [PhotoMIX Company](https://www.pexels.com/@wdnet?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/black-samsung-tablet-computer-106344/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/12032/1*xNt4aprSuOo2bdYg9F-6gw.jpeg)

对于许多具有创业精神的程序员来说，创建一个成功的软件即服务（SaaS）产品是他们追求的梦想。在推出我自己的 SaaS 产品的过程时，我发现与其他创业者分享和探讨经验是必不可少的，如果没有这一点，我可能根本就不会想着去创建它。

在本文中，我将分享我从零开始创建 SaaS 产品的思路和实践过程，以及我是如何获得第一个付费客户的。无论是正在考虑创建一个新产品，还是已经推出了这个产品，你都可以通过对比自己的策略和文章中对我而言有效的策略，来调整适合你的策略

![](https://cdn-images-1.medium.com/max/2822/1*chMcZ5-kuoA-FvcH5R3FNg.png)

我每周会花 5 个小时研究其他创业者的经历。我一直在寻找新的想法以及避免错误的方法，评估新的策略可以帮助我获得具体的结果（即改进产品并增加客户满意度）。

出于这个原因，我决定以一种完全坦率和透明的方式工作，并分享我的道路上的一切 —— 包括什么已经起作用了，什么没有起作用 —— 目的是通过直接和理性的讨论互相帮助。

## 文章结构

这篇文章按时间顺序分为七个部分，下面是我所做的工作的每个阶段：

- **发现问题**
- **量化问题**
- **评估竞争对手和他们解决问题的方法**
- **开发第一个原型**
- **扔掉一切然后重新开始**
- **获得第一个订阅**
- **如何走得更远**

我开发的 SaaS 产品是 [Inspector](https://www.inspector.dev/)，一个实时监控工具，可以帮助软件开发人员避免因程序技术问题而失去客户和资金。

## 发现问题

![Photo by Pixabay from [Pexels](https://www.pexels.com/photo/black-samsung-tablet-computer-106344/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/10368/1*qWDI9beoYFfBmghh-Z6ybQ.jpeg)

在过去的 10 年里，我一直与软件开发团队一起工作，在这期间，我意识到，对于开发人员来说，每天处理影响应用程序的技术问题非常复杂。开发团队与客户之间有着密切的关系，这对于生产软件的公司来说有很高的风险，因为一旦出现问题，你就会意识到这种联系是多么脆弱。

用户不喜欢出现问题！这是显而易见的，但这方面经常会被忽视。这是一个令人不安的事实。没有人喜欢遇到问题，本能的做法是把问题最小化。但如果你否认这一事实，你可能会惹恼客户，甚至会让他们重新考虑是否“应该”付钱给你。

客户是不会花时间向你报告问题和错误的。没有人会关心能否帮助我们解决 bug。它们只是退出我们的应用，可能要过好几年我们才能再见到他们。因此，我工作过的每个团队都使用最直观的方法来判断应用是否正常工作：

> “如果你的客户投诉你，就说明你的软件有问题。”

这并不是一个技术解决方案……

紧迫、有限的预算，不断向客户、经理施压，这迫使开发人员必须顶着巨大的压力工作，采用权宜之计（暂时解决问题）这种生存策略。也许这看起来很荒谬，但只有深知项目内容的内部工作人员才会知道这些。这样的经历下工作了十年，我意识到这部分明显出现了问题。

## 量化问题

![Photo by Pixabay from [Pexels](https://www.pexels.com/photo/black-samsung-tablet-computer-106344/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/10000/1*aOZ8uDUscHo0oRipuqKPBg.jpeg)

2019 年初，我刚刚完成了一些重要的项目，并希望能享受一段平静的时光。在过去的几年里，我利用这些时间寻找可以让我充分发挥自己技术才能的商机，希望以此找到合适的条件来启动我的商业想法。

作为一名开发人员，我的经验告诉我，通过简单而即时的监视工具足以帮助开发团队时刻了解应用程序最新的信息，不需要依赖客户的电话来知道软件什么时候出现了问题。另一方面，我不需要一个工具来监视每件事，因为并不是每件事都有意义。同时我也不希望它变得复杂——我不想仅仅为了这份工作而花一个月的时间学习它的工作原理，也不想为此雇佣专业的工程师。我的生活必须比以前更轻松。因此有必要准备一个随时可用的开发人员工具。

第一步是了解是否已经有尝试解决此问题的解决方案了，因此我谷歌了一下“**application monitoring**”，出现了 941,000,000 个结果：

![](https://cdn-images-1.medium.com/max/2022/1*i2ZmDlt4rYw7d90QgEWwzA.png)

哇。这可真是一个大问题。但究竟有多大呢?

软件开发团队效率低下是我一直面对的一个问题，但是在评估工作任务和量化问题的经济影响之间存在很大差异。从大范围来说，这就更加困难了。这条推文引起了我的注意：

![](https://cdn-images-1.medium.com/max/2000/1*TvugFYsVbZuQSD_iFwWBTw.png)

**50％的开发人员承认他们需要花费多达 50％的时间来验证应用程序是否正常运行。**

软件开发这个工作的报酬主要是通过技术人员在项目上所花费的时间来衡量的，如果开发人员需要花费 50%的时间来检查一切是否正常，那么一种完全自动化完成这项工作的工具可能会更有用。

**那么为什么它没有在这么多开发人员中流行起来呢？**

## 评估竞争对手和他们解决问题的方法

![Photo by [Startup Stock Photos](https://www.pexels.com/@startup-stock-photos?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/man-wearing-black-and-white-stripe-shirt-looking-at-white-printer-papers-on-the-wall-212286/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/10944/1*N-6vdg-eP1w_5Femejg5pA.jpeg)

当公司决定使用哪些工具来提高生产力时，我考虑了两个主要因素:

1. **简单**（易于安装和使用）
2. **功效**（我花 x 去解决一个价值 x+10 的问题，所以我得到+10）

使用这些参数，我花了大约一个星期的时间创建了一个知名监测工具的评估表，并且把它们放在一个图表中

![](https://cdn-images-1.medium.com/max/3682/1*jCKXywhfbMjCF98suUklJg.png)

经过几天的整理收集，看一下图表就足以了解问题所在。简单的工具不能为大多数开发人员提供足够的价值。相反，更完整的工具被认为是针对大型组织的，需要熟练的员工致力于安装、配置和使用，这最终会使团队操作复杂化而不是简化。

**在我看来，问题不是监控本身，而是团队效率的发展。**

对于大规模的采用，很有必要有一种产品，其安装时间在一分钟左右且无需额外配置，同时还需要提供完整、容易的信息以供参考，甚至允许中型开发团队对问题进行修复以及实时监控。

当然，它必须很酷。

![](https://cdn-images-1.medium.com/max/3682/1*v3O5TbWyrm1P1zC4IeM9TQ.png)

## 开发第一个原型

最后，我决定尝试一下。上次的工作进展顺利，我认为创建该工具并不是没有可能。因此，我立即通知我的合作伙伴，我想在接下来的两三个月内建立一个 MVP。当我向他们解释时，很难让他们理解问题，因为他们并不是和我涉及同一领域的技术人员，好在他们给了我 90％的信任许可，我对此表示感谢。

在三个月的时间里，我创造出了这个原型：

![](https://cdn-images-1.medium.com/max/2000/1*KgapMnraeCMY4GqmriE_fw.gif)

在实现过程中，我逐渐明白了实现这类工具的痛点，甚至包括用户在使用过程中可能会遇到的问题。从技术角度来看，监控产品必须设计成能够处理大量数据，最好我也想让它可以实时处理这些数据。

因为我花费比预期更长的时间开发后端部分（换句话说，看不见的部分，或者云端软件的后台），导致忽视了用户可以看到和使用的图形界面（例如你在上面看到的）。

## 扔掉一切然后重新开始

![Photo by [Steve Johnson](https://www.pexels.com/@steve?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/focus-photo-of-yellow-paper-near-trash-can-850216/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/9056/1*bsLtywHzuhiY52OKpFii6Q.jpeg)

在过去的几年里，对于产品上市的梦想促使我不断的学习并将适用于 SaaS 软件的营销策略应用于不同的项目（甚至失败的项目）。我开始为我的博客写文章，在将其发布在不同的网站和社交媒体上，以收集第一批反馈。

很抱歉，由于英语不是我的母语，我写了很多非常糟糕的内容，时不时还有些写作上的错误，不过好在我已经开始收到关于这些想法的反馈了，这些反馈有：

- 我不知道我能用它做什么。
- 我如何安装它？
- 为什么用它而不是 XXX？
- 其他……

要客观地看待开发人员的回应和评论并不容易。情绪反应总是会占据主导，对于我来说，真的很难理解哪里出了错，因为我不是销售代理人或卖方，而是一个技术人员。

## 以下是我一路走来学到的经验

#### 第一课——销售很烂

![Photo by Pixabay from [Pexels](https://www.pexels.com/photo/black-samsung-tablet-computer-106344/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/7638/1*4uq5q1_6T7myy2dANraKPA.jpeg)

得益于工具的技术投入，实际上我并不需要销售。相反，我只需要学会如何交流每天遇到的问题，以及如何用我的工具解决它们。

我花了整整一个月的时间来撰写我所知道的、最重要的有关监控和应用程序可伸缩性问题，以及我决定开始启动这个项目的原因，在开发产品过程中遇到的困难，以及我如何解决这些问题并继续前进，代码示例、技术指南、我的最佳实践等等。

然后，我将一切都交给了 [Robin](https://www.fiverr.com/robinoo/professionally-proofread-1000-words?context=recommendation&context_alg=recently_ordered%7Cco&context_referrer=homepage&context_type=gig&mod=rep&pckg_id=1&pos=1&source=recently_and_inspired&tier_selection=recommended&ref_ctx_id=1bf19e6d-aa27-407d-86ea-f8ca268b8131)，他是我在 Fiverr 上找到的一位加拿大文案撰稿人，他修改了所有的内容，包括网站上的文字，并把文章修改成英语母语水平。

#### 第 2 课——产品不足

![Photo by [Kate Trifo](https://www.pexels.com/@katetrifo?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/almost-empty-shelf-on-grocery-store-4019401/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/12480/1*UeZnUESwTIC3iLYnCsDdSw.jpeg)

担心忽视用户界面是有理由的。我所做的工作还不足以创造出我心中的那种交互体验，所以我必须重新开始。这样做的好处是我解决了大部分的技术问题。对一个工程师来说，设身处地为设计师着想并不容易。

为了提高我的设计感知，我参加了两门关于图形界面开发的课程，阅读了三本关于设计和用户体验的书籍，并使用 VueJs 作为前端框架进行了直接的实验。

## 第三课——试一试，尽管有疑虑

![Photo by Pixabay from [Pexels](https://www.pexels.com/photo/black-samsung-tablet-computer-106344/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/9216/1*Obd6Tg-u6D_Hf-he9M4LFw.jpeg)

当我们花时间阅读有关商场营销的书籍和视频时，我们总是会学习一些常见的建议，而这些建议在实际情况下通常是行不通的。例如，想想这句口头禅：“如果你等到一切都准备好了，你就永远不会开始创业。” **如此真实**！

但初次体验会促使我们做出应激反应，会使我们处于防御状态。这是一个非常大的错误，因为创建一个因其实用性而值得购买的产品是一个过程，并不是一蹴而就的。“启动”这个词误导了我们，因此请别管它，而将注意力集中在“创造”上，与外界相比，该过程会一步步帮助你了解为实现目标而需要进行改进的内容。

## Inspector 诞生了！

这个项目又花了我两个月的时间。在这几个月里，我决定从零开始重新创建这个品牌，尝试将原型体验不仅仅用于产品，还用于市场营销和传播。

[Inspector](https://www.inspector.dev/) —— 在不到一分钟的时间内，在用户反应之前识别出代码中的问题!

![](https://cdn-images-1.medium.com/max/3072/1*7tXxOtkvca_518-3LPNEQA.png)

我们无休止地重复，其目的不是监视本身，而是帮助开发人员使他们的工作流程自动化：

- **不费吹灰之力**
- **无需浪费时间进行手动操作**
- **必要时保证灵活性**

## 获得第一个订阅

![Photo by [Malte Luk](https://www.pexels.com/@maltelu?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels) from [Pexels](https://www.pexels.com/photo/selective-focus-photography-of-spark-1234390/?utm_content=attributionCopyText&utm_medium=referral&utm_source=pexels)](https://cdn-images-1.medium.com/max/8544/1*ZYIMfCsYF84XptBZ0v68lw.jpeg)

2019 年 7 月 14 日，我的一份技术指南被批准在 Laravel News 上发表。Laravel News 是 Laravel 开发者社区最重要的网站之一，它使这一工具广为宣传。 在四天内，有 2,000 多人访问了 Inspector 网站，近 100 家公司注册签约，其中包括两位来自荷兰和瑞士的用户订阅了，成为了第一批用户。

当我收到 Stripe 公司的通知，告知我已经收到了我的第一笔付款时，那时已是深夜，我无法描述我当时的心情。这种感觉就像我背着大象七个月，最后它消失了，让我如释重负。

在接下来的几个月中出现了很多问题，这些问题需要时间，精力和金钱来解决。其中包括黑客攻击和基础设施超载之类的问题，这些问题迫使我即使在平安夜也要和电脑捆绑在一起。这些问题会让你重新回到现实，让你意识到事情比以前更加困难，因为你现在已经拥有了一些可以失去的东西了。

有了第一批付费用户，我知道我有了一个有趣的产品，多亏了网络和云，我才有机会让世界各地的开发人员宣传我的产品。所以这几个月来我每天都在全职工作，每天在尽可能多的渠道上创作和发表我的技术文章：

- [https://medium.com/inspector](https://medium.com/inspector)
- [https://dev.to/inspector](https://dev.to/inspector)
- [https://valerio.hashnode.dev/](https://valerio.hashnode.dev/)
- [https://www.facebook.com/inspector.realtime](https://www.facebook.com/inspector.realtime)
- [https://www.linkedin.com/company/14054676](https://www.linkedin.com/company/14054676)
- [https://twitter.com/Inspector_rt](https://twitter.com/Inspector_rt)
- [https://www.indiehackers.com/product/inspector](https://www.indiehackers.com/product/inspector)
- [https://www.reddit.com/r/InspectorFans/](https://www.reddit.com/r/InspectorFans/)
- [https://www.producthunt.com/posts/inspector](https://www.producthunt.com/posts/inspector)

现在，超过 800 家公司和商业人士已经尝试了 Inspector，我们有超过 20 个活跃订阅，来自新加坡，德国，纽约，法国，香港，荷兰等。

## 如何走的更远

与他人分享和比较是我成功的基础，所以我打算继续走下去。完全没有意识到这些问题比我们意识还有很多地方需要改进更糟糕。这就是为什么我们在最重要的意大利活动中（以创新为主题）开始讲这个故事的原因。

现在我们加入了[**哈勃**](https://www.inspector.dev/inspector-joins-nana-bianca-the-italian-startup-accelerator/)计划，这是一家意大利创业孵化器，三位创始人分别是 Paolo Barberis、Jacopo Marello 和 Alessandro Sordi。达达的三位创始人花了 20 年的时间合作，为 30 多家正在成长的意大利和外国公司提供资金和支持。

我们的目标是将 Inspector 介绍给其他的经理、商务人士、市场和技术专家，测试新的工具和策略，以将产品提升到一个新的水平，并使 Inspector 在全球范围内广为人知。我们希望帮助软件开发人员以一种更高效有趣的方式工作，借助智能工具可以给他们更多的空闲时间花在更有价值的活动上，而不必进行无聊的，重复的手动检查。

## 总结

在本文中，我分享了我从头创建和启动 SaaS 产品的思想和实践过程，以及我是如何获得第一批付费用户的。如果我之前不写文章分享我的历程，我就不会有机会创建 [Inspector](https://www.inspector.dev)，因此，感谢您阅读本文。我邀请您在下面发表评论，提出任何问题，或者只是告诉我您的想法。 如果你认为这篇文章可能对其他人有用，请在你的社交媒体上分享它！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
