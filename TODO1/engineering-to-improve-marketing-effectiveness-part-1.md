> * 原文地址：[Engineering to Improve Marketing Effectiveness (Part 1)](https://medium.com/netflix-techblog/engineering-to-improve-marketing-effectiveness-part-1-a6dd5d02bab7)
> * 原文作者：[Netflix Technology Blog](https://medium.com/@NetflixTechBlog?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/engineering-to-improve-marketing-effectiveness-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/engineering-to-improve-marketing-effectiveness-part-1.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[kuangbao9](https://github.com/kuangbao9)

# 提高营销效率的工程（第一部分）

作者 — [Subir Parulekar](https://www.linkedin.com/in/subir-parulekar-19ab403/)、[Gopal Krishnan](https://www.linkedin.com/in/gopal-krishnan-9057a7/)

**“让大家对我们的内容感兴趣，这样他们就会注册并进行观看”**

- Kelly Bennett，Netflix 的首席营销官

这句话已经成为我们广告技术（AdTech）团队的动力。Netflix 有大量优秀的原创内容可供推广，因此存在一个既可以利用赚钱的媒体，也可以利用付费的媒体来为世界各地的人们创造他们感兴趣的内容的独特机会。Netflix 现在已经在 190 个国家和地区进行了推广，拥有数百万中资产，以数十种语言形式在全球范围内宣传数百种内容。

AdTech 团队的宗旨是帮助我们的市场营销伙伴通过实验和自动化来利益最大化他们所花费的时间和金钱。这涉及到为推进全面改进而与市场营销、运营、财务、科学和分析团队的深入合作。这是系列博客中的第一篇，分享了与我们的营销团队合作的所有方式，从合作创作资产、组装广告到优化计划渠道上的活动。

**背景和文化：**

Netflix 营销团队相信，创造 Netflix 需求的最佳途径是推广只能在 Netflix 上观看的高质量的独家内容。如果我们成功创作了对原始内容的需求，那么新会员就会注册。作为这一过程的一部分，如果我们按照市场的正确比例创造和收集这种需求（收购营销），那么我们会更加成功。

选择支持哪些标题和市场仍然需要艺术与科学的结合，我们的创意团队与我们的技术团队携手合作，共同创造出成功的公式。市场营销根据需要关注标题集，以及与导演/节目主持人合作的片名背后的创意，制定一系列广告市场的顶级战略决策。

AdTech 团队通过以下方式来帮助我们的营销伙伴执行该策略：

1.  为了改善营销资产，我们进行创新技术来简化工作流程。这解放了营销团队，让他们可以减少对日常生活的关注，聚焦于创意领域。
2.  为了在所有宣传画布和频道中创建广告，可以创建一个统一的内部平台。例如，Facebook、YouTube 和 Instagram。TV 和户外等。
3.  启用使我们能衡量和优化我们的营销活动有效性的技术 —— 无论是通过在线编程渠道还是离线渠道。例如，我们通过 Facebook 和 YouTube 上的各种算法来实现这一点，这些算法可以帮助我们更好地理解影响并提高我们的消费效率。

我们为 Netflix 的数据驱动文化感到自豪，你可以在[这里](https://medium.com/netflix-techblog/its-all-a-bout-testing-the-netflix-experimentation-platform-4e1ca458c15)和[这里](https://ieondemand.com/presentations/quasi-experimentation-at-netflix-beyond-a-b-testing)阅读到相关内容。正如我们通过 A/B 测试来改进 Netflix 产品一样，我们的营销团队也会利用实验来引导和提高人们的判断力。我们越是能创造工具和流程来简化我们的方法，我们的团队就越能专注于帮助正确的受众体验到优秀的成果。我们的理念是“**我们花费的每一美元，都是务必要物超所值**。AdTech 团队致力于寻求技术创新，使我们的合作伙伴能够将更多的时间花在战略性和创造性的决策上，而我们则利用实验来引导 Netflix 在最佳策略上的直觉判断。

**优化增长**

Netflix 的目标是使用付费媒体来提高效率。有些人可能会注册 Netflix（例如，由于朋友的推荐），但我们不愿意在我们能够控制的范围内向他们展示广告。相反，我们最感兴趣的重点营销对象是那些尚未对 Netflix 下定决心的人。这一总体策略在很大程度上影响了我们的理念和工作，就像你在随后的博客种所发现的那样。

在更高的层次中，我们可以将 Netflix 的营销生命周期建模成以下四个步骤：

![](https://cdn-images-1.medium.com/max/800/0*f_bkj3H4z6gSA5ja.)

本文将详细介绍创意开发与本地化的第一步。我们将概述应用于 Netflix 营销市场中，支持我们创造数百万资产（预告片、艺术品等）的运营团队所做的工作。

**规模化的创意开发与本地化**

Netflix 的增长速度得力于它以数十种语言来营销 Netflix 的所有新颖的标题，包括最终将产生数百万的营销资产的许多概念和消息类型。我们需要让市场营销、社交和公关团队团结起来，在全球范围内扩展我们的内容活动。只有当我们构建了一个流线型、健壮的资产创造和交付管道来自动化所有涉及的过程时，才能实现这一目标。这是数字营销基础设施团队关注的领域！我们的目标是创建应用程序和服务，来帮助 Netflix 营销优化和自动化流程，扩大其业务范围，为正在全球范围内开展的所有 Netflix 营销活动提供大量的视频、数字和影印资产。

简而言之 —— 你可以在 YouTube、Facebook、Snpchat、Instagram 和 Twitter 和其他社交媒体平台或电视上看到 Netflix 的任何预告片和数码艺术品，它们都是用团队开发工具创建和本地化的。我们的领域甚至涉及到了世界各地的高速公路、交通灯、公共汽车和火车上，你所能看到的一些实体广告牌和海报。

![](https://cdn-images-1.medium.com/max/400/0*6vxzgYQuNvpUils5.)

![](https://cdn-images-1.medium.com/max/400/0*0qic6MBXAXNzAHLp.)

![](https://cdn-images-1.medium.com/max/400/0*BmrA1SFkZ0jKx_Dk.)

Netflix 在地铁（纽约）、电梯（哥伦比亚）和广告牌（孟买）上的海报

**那么这些预告片是如何被创建的呢？**

在音频视觉（AV）领域中，这一切都始于营销创意团队与外部机构合作，为一个特定的标题创建一组预告片。标题可以是像[Stranger Things](https://www.netflix.com/title/80057281) 这样的系列，或者是 [Bright](https://www.netflix.com/title/80119234) 这样的电影，亦或是像 [Dave Chappelle](https://www.netflix.com/title/80171965) 的独立喜剧，亦或是像 [13th](https://www.netflix.com/title/80091741) 这样的记录片。经过几轮创造性的回顾和反馈后，预告片最终确定了标题的原始语言。之后，特定领域会需要这个预告片在屏幕上的特定位置进行字幕，配音，评级卡，Netflix 标志的各种组合等。下面是展示了 [Ozark](https://www.netflix.com/title/80117552) 中的一个框架的各种组合的示例。

![](https://cdn-images-1.medium.com/max/800/0*RKKQ86KDXyAfTgZK.)

营销团队与多个合作伙伴合作，为这些预告片构建这些本地化的视频文件。然后将这些资产编码为交付给它们的社交平台的规范。

为了深入了解这些数字，下图给出了为市场营销而创建的视频资产的数量[资产的数量](https://www.netflix.com/title/80119234)。我们最终获得了 5000 多个不同的文件，涵盖了不同的语言和广告格式。

![](https://cdn-images-1.medium.com/max/800/0*25v1WBwYoFBb3Qyf.)

由于视频、字幕、配音等问题，我们的营销团队在创作，生产，测试中花费了大量的时间，有时由于视频问题还会重发这些资产。为了帮助扩展这项业务，我们还为外部机构完成这些工作承担了费用。我们希望未来可以在营销活动期间通过收集指标来确定瓶颈，能够比较各种标题的活动，并在全球团队中提供需求的可见性。

**我们如何帮助他们？**

我们通过查看营销工作流以及流程中的关键的自动化点来开始工作，然后开始构建应用程序/服务来帮助优化。我们正在构建：

*  **数字资产管理**：我们正在构建一个数字资产管理系统，为我们的合作伙伴和外部机构提供一个可以上传/下载/共享这些数字资产的用户界面。我们支持在一次上传中上传高达兆字节的数据和数百万来自视频/照片拍摄的文件。我们利用 Amazon S3 存储物理资产，但将资产的元数据存储在 DAM 中。我们已经在系统之上构建了协作功能，也在继续投资构建更多的功能，从本质上说，这将是一个 DAM + Dropbox + Google 文档，将具有与 Netflix 工具生态系统相连接的能力。

*  **云中的视频剪辑**：我们正在重建一个视频剪辑工具，我们的合作伙伴可以使用这个工具从视频片段中剪辑短片来创建预告片。

*  **为营销资产组装视频**：我们正致力于开发首个视频组装工具。单击按钮后，该工具将自动创建预告片的本地化版本，提供所有输入，如主预告片文件、字幕、配音和其他语言/区域相关信息。我们很高兴能够在组装方面进行创新，因为我们有信心通过减少当前所用的各种语言创建本地化资产所花费的时间、精力和费用来获得巨大利益。现在，创建这些本地化资产，我们需要几秒或者几分钟就可以完成任务！

*  **云中编码**：我们正在利用 [Netflix 编码服务](https://medium.com/netflix-techblog/high-quality-video-encoding-at-scale-d159db052746)将资产编码为不同平台规范。然而，营销团队不需要知道社交媒体平台所需的特定编码细节，因此我们在编码服务之上提供抽象层，团队只需要指定平台，该层会将其转换为对应的编码规范。我们将此作为 Netflix 中其他工具的服务进行提供。

*  **活动管理监督**：我们正在创建一个全球活动管理生命周期应用程序，来提供有关营销活动健康状况的监控。这项活动将持续数月，对所有正在完成的工作提供可见性，包括指标，瓶颈以及资产从开始到交付的工作流建模。该应用程序将成为各个子团队使用的中心枢纽。

当我们在每个工具上取得进展时，或者所有这些工具开始相互交互，并将资产从一个工具自动切换到另一个工具时，真正的价值就会实现，这将最大限度的减少人员对不重要决策的参与，以下是如何将它们结合在一起的方式。

![](https://cdn-images-1.medium.com/max/800/0*e_uEt-JxxMTwxHaY.)

我们设定了目标，让 2018 年成为所有移动部件开始协同工作的一年，我们期望在时间、成果和资源方面都取得巨大的进展。

团队一直在向着正确又快速的方向发展，而且自动化和优化这些工作流可以为我们节省大量人工时间和成本。这是我们扩大规模的唯一途径。我们正在招聘 AdTech 团队中的几个[空缺职位](https://sites.google.com/netflix.com/adtechjobs)，来帮助我们设计和构建这些系统。如果你有兴趣解决这些复杂的挑战，颠覆娱乐行业，塑造其未来，我们希望你成为团队的一员

就像前面提及的那样，创意开发和本地化只是营销资产创建和交付过程中的第一个阶段。在整个过程中，会存在许多有趣的机会和挑战。

我们的后续文章会深入营销生命周期的下一个阶段。敬请期待！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
