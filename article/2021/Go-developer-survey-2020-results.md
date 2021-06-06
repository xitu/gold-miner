> * 原文地址：[Go Developer Survey 2020 Results](https://blog.golang.org/survey2020-results)
> * 原文作者：Alice Merrick
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/Go-developer-survey-2020-results.md](https://github.com/xitu/gold-miner/blob/master/article/2021/Go-developer-survey-2020-results.md)
> * 译者：[samyu2000](https://github.com/samyu2000)
> * 校对者：[PingHGao](https://github.com/PingHGao), [PassionPenguin](https://github.com/PassionPenguin)

# 2020 年 Go 语言开发者调查报告

2020 年，有 9648 人参加了我们举行的投票活动，[跟 2019 年的情况差不多](https://blog.golang.org/survey2020-results)。感谢您抽出时间在本社区提出见解并分享您使用 Go 语言的经验。

## 新型模块化的调查问卷设计

你可能注意到，有些问题的样本数量比其他的少。那是因为这些问题面向所有参与调查的人，而其他的只针对一部分人。

## 亮点

- Go 语言在业界有着广泛的应用，76% 的被调查者[在工作中使用 Go 语言](https://blog.golang.org/survey2020-results#TOC_4.1)，66% 的被调查者认为[Go 语言非常重要，能助力企业获得成功](https://blog.golang.org/survey2020-results#TOC_6.1)。
- Go 语言的[总体满意度](https://blog.golang.org/survey2020-results#TOC_6.)非常高，有 92% 的被调查者对 Go 的使用体验感到满意。
- 在不到 3 个月的时间内，大多数被调查者认为 Go 语言能助力高效工作，而且有 81% 认为它非常高效。
- 一些被调查者表示自己会[及时升级 Go 至最新版本](https://blog.golang.org/survey2020-results#TOC_7.)，其中有 76% 会在新版本发布后五个月内就更新。
- 在查找程序包时，[使用 pkg.go.dev 的被调查者成功率高达 91%](https://blog.golang.org/survey2020-results#TOC_12.)，不使用 pkg.go.dev 的成功率只有 82%。
- Go 语言的模块使用率高达 77%，但被调查者们也强调，Go 语言的相关文档需要改进。
- Go 语言广泛应用于 [API, CLIs, Web, 运维和数据处理](https://blog.golang.org/survey2020-results#TOC_7.)等领域。
- [Underrepresented groups](https://blog.golang.org/survey2020-results#TOC_12.1) tend to feel less welcome in the community.[代表性不足的那部分被调查者](https://blog.golang.org/survey2020-results#TOC_12.1)认为自己在社区不受欢迎。

## 我们的调查对象有哪些？

我们需要区分与去年相比发生的变化中，哪些是由于被调查者的感情或行为因素导致的，哪些是由于受访者群体变化而导致的。基于人口统计学原理的问卷设计有助于我们实现这个目的。由于我们今年使用的统计原理跟去年相似，我们有理由相信，这些变化很大程度上不是由于统计数据的变化导致的。

例如，公司规模、开发经验、所在行业的分布跟 2019 年相比，基本保持不变。







大约一半（48%）的被调查者使用 Go 语言的经历少于两年。根据我们的调查结果，2020 年使用 Go 语言经历少于一年的开发者变少了。



大多数被调查者表示，他们在工作中、工作之外都有可能使用 Go 语言，其中工作中使用的占 76%，工作之外使用的占 62%。工作中使用 Go 语言的比例每年都呈上升趋势。



今年我们在问卷中加入了一个新的问题，是跟主要工作职责有关的。我们发现，有 70% 被调查者的工作职责是开发软件系统和应用程序，但也有少数（10%）是负责 IT 系统和架构的设计。



我们发现，跟前几年一样，大多数被调查者很少为 Go 语言的开源社区贡献代码，在这个问题上，有 75% 的回答是“极少”或“从不”。



## 开发工具和实践

跟前几年一样，绝大多数被调查者称自己在 Linux 和 macOS 系统上进行 Go 应用开发，两者分别占 63% 和 55%。在 Linux 系统上进行开发的被调查者所占比例呈逐步下降趋势。



对编辑器的偏好已经比较稳定，这还是第一次：VS Code 仍然是用得最多的编辑器(41%)，GoLand 以 35% 的份额紧随其后。两者一共占 76%，其他编辑器跟前几年一样，没有持续下降。



今年我们让被调查者对编辑器的改进事项进行优先级评估，具体做法是：如果每人有 100 个“GopherCoins”（一种虚拟货币），你会花费多少用于优化编辑器。结果是：每人平均用于代码自动完成花费的货币最多。有半数被调查者表示会花费 10 个或更多的货币用于四个方面（它们分别是代码自动完成、代码导航、编辑器性能和代码重构）。



大多数被调查者（63%）需要花费 10–30% 的时间用于重构代码，这说明重构是一项公共任务，我们应当采取措施去改善这种情况。这也解释了为何代码重构是编辑器优化中花费成本最高的事项之一。



去年，我们就一些技术问题询问了开发人员，发现几乎 90% 的被调查者都用文本形式的日志进行程序调试，因此我们今年增加了一个问题，对该现象进行后续跟踪，以便发现他们为何这么做。结果是：43% 的被调查者认为这种方式方便了不同语言间的调试，42% 的被调查者一向偏爱这种调试方式。然而，也有 27% 不了解如何开启 Go 语言的调试工具，24% 从未使用调试工具，所以需要改进调试工具，使它易于发现和使用，并整理成文档。此外，由于四分之一的被调查者从未尝试使用调试工具，相关的痛点很可能被低估。



## 对 Go 语言的态度

2020 年是我们第一次关注总体满意度。有 92% 的被调查者表示他们在过去的一年内对 Go 语言非常满意。



这也是我们第三次询问被调查者“你会推荐...吗”，然后统计[净推荐值（NPS）](https://en.wikipedia.org/wiki/Net_Promoter)。今年我们经统计得到的 NPS 是 61（推荐的 68% 减去不推荐的 6%），跟前两年持平。

![https://blog.golang.org/survey2020/nps.svg](https://blog.golang.org/survey2020/nps.svg)

跟去年相似，91% 被调查者表示，他们开发下一个新项目会优先考虑使用 Go 语言。89% 表示 Go 语言对他们的团队很有用。我们还发现，今年认为 Go 语言对企业的成功很重要的比例从去年的 59% 上升到了 68%。就职于 5000 人以上的公司的被调查者对这些观点的赞同率较低（63%），而在小型公司工作的被调查者中赞成率较高（73%）。

![https://blog.golang.org/survey2020/attitudes_yoy.svg](https://blog.golang.org/survey2020/attitudes_yoy.svg)

跟去年一样，我们让被调查者对 Go 语言在某些领域的满意度和重要性进行评价。在云服务、调试和模块领域，Go 语言的满意度增加了，但重要性仍然维持不变。我们也引入了两个新的领域：API 和 Web 架构。我们发现，在 Web 架构方面，Go 语言的满意度比其他领域低（64%）。这对大多数现有用户来说并不重要，但将要入行的新手会把这些因素考虑在内。

![https://blog.golang.org/survey2020/feature_sat_yoy.svg](https://blog.golang.org/survey2020/feature_sat_yoy.svg)

有 81% 的被调查者认为使用 Go 语言开发效率很高。就职于大公司的受访者比在小公司工作的更加普遍地赞同这种观点。 

![https://blog.golang.org/survey2020/prod.svg](https://blog.golang.org/survey2020/prod.svg)

我们从各种非正式渠道了解到，Go 语言能很快地提高开发效率。于是我们向那些至少认为效率稍有提高的被调查者求证，问他们花了多少时间提高效率。结果有 93% 的被调查者的回答是不到一年，其中大多数只花了 3 个月的时间。

![https://blog.golang.org/survey2020/prod_time.svg](https://blog.golang.org/survey2020/prod_time.svg)

尽管认同“我在 Go 社区感到受欢迎”这一说法的受访者比例与去年大致相同，但它似乎随着时间的推移呈下降趋势，或者至少不像其他领域那样保持上升趋势。

我们也发现，认为 Go 项目经理能理解项目需求的比例有显著提高，达到了 63%。

这些调查结果表明，从大约两年前开始，人们对 Go 的认同度与开发经验呈正相关。换句话说，就是使用 Go 语言的时间越长，越有可能认同这些观点。

![https://blog.golang.org/survey2020/attitudes_community_yoy.svg](https://blog.golang.org/survey2020/attitudes_community_yoy.svg)

我们还提出了一个开放性问题：如何让 Go 开发社区更受欢迎，收到的建议大部分（21%）是希望社区能提供各种形式的学习资源和文档，以及关于这些资料的改进建议。

![https://blog.golang.org/survey2020/more_welcoming.svg](https://blog.golang.org/survey2020/more_welcoming.svg)

## 使用 Go 语言进行开发工作

Go 语言最普遍的使用场景包括：构建 API/RPC 服务（74%）和 CLI（65%）。与去年相比，我们没有看到任何显著的变化，当时我们在选项排序中引入了随机化。（在 2019 年之前，候选列表开头的那几个选项的选择是不合理的。）我们还按企业规模进行分类，发现大型企业和小型企业对 Go 的反馈是相似的，虽然大型企业较少使用 Go 语言开发返回 HTML 的 web 服务。

![https://blog.golang.org/survey2020/app_yoy.svg](https://blog.golang.org/survey2020/app_yoy.svg)

现在我们已经对受访者在家中使用的软件和在工作中使用的软件有了更深的理解。虽然返回 HTML 的 Web 服务在最常用的用例中排名第 4，这还是非工作使用。有更多的被调查者在自动化/脚本、代理、数据处理方面使用 Go 语言，而非用于开发 Web 服务。大部分最不常见的那些类型的应用（桌面/GUI 应用、游戏和移动应用）都是开发者在业余时间编写的。

![https://blog.golang.org/survey2020/app_context.svg](https://blog.golang.org/survey2020/app_context.svg)

另一个新话题是 Go 语言在每个应用领域的满意度如何。在 CLI 领域的满意度是最高的，有 85% 的被调查者表示他们对此非常、一般或轻微的满意。在通用领域的应用也有较高的满意度，但满意度和通用程度并不是等同的。比如在代理和守护进程方面，满意度排名第 2，通用程度只能排名第 6。

![https://blog.golang.org/survey2020/app_sat_bin.svg](https://blog.golang.org/survey2020/app_sat_bin.svg)

其他的问题关注了不同的用例，例如，受访者开发的 CLI 针对哪些平台。由于开发人员普遍使用 Linux 和 macOS 系统，有 93% 针对 Linux，59% 针对 macOS，这并不令人惊讶。但还是有近三分之一的 CLI 开发人员将 Windows 作为目标平台。

![https://blog.golang.org/survey2020/cli_platforms.svg](https://blog.golang.org/survey2020/cli_platforms.svg)

如果对 Go 在数据处理领域的应用一探究竟，可以发现，Kafka 是唯一兼容度较高的引擎，但大多数被调查者表示，他们使用的是定制的数据处理引擎。

![https://blog.golang.org/survey2020/dpe.svg](https://blog.golang.org/survey2020/dpe.svg)

我们还询问了 Go 语言是否有更多的应用领域。结果表明，到目前为止，最通用的领域是 Web 开发（占比为 68%），其他领域包括数据库（42%）、运维（42%）、网络编程（41%）和系统编程（40%）。

![https://blog.golang.org/survey2020/domain_yoy.svg](https://blog.golang.org/survey2020/domain_yoy.svg)

与去年的情况类似，我们还发现，76% 的被调查者对当前版本的 Go 是否适合项目开发进行了评估，今年我们改进了时间尺度，发现有 60% 的被调查者在新版本发布前或两个月内开始评估。这种情况对于那些把平台作为一种服务提供给用户的供应商来说很重要，如果事先了解这种情况，它们可以快速支持稳定的新版 Go。

![https://blog.golang.org/survey2020/update_time.svg](https://blog.golang.org/survey2020/update_time.svg)

## 使用 Go modules

今年我们发现，大家普遍在使用 Go modules，而且只把 Go modules 作为包管理工具的被调查者所占比例有明显提高。有 96% 的被调查者表示，他们使用 Go modules 对包进行管理，比去年的 89% 多。其中，只使用 Go modules 来管理包的被调查者从去年的 71% 增加到了今年的 87%。同时，其他包管理工具的使用比例也减少了。

![https://blog.golang.org/survey2020/modules_adoption_yoy.svg](https://blog.golang.org/survey2020/modules_adoption_yoy.svg)

各个模块的满意度也比去年高。有 77% 的被调查者表示，他们对模块非常、一般或比较满意，这一数据在 2019 年为 68%。

![https://blog.golang.org/survey2020/modules_sat_yoy.svg](https://blog.golang.org/survey2020/modules_sat_yoy.svg)

## 官方文档

很多被调查者表示，他们阅读官方文档有困难。62% 的被调查者由于找不到足够的资料来实现应用程序所需功能而发愁，也有超过三分之一的开发者对学习他们以前没接触过的新事物感到困难。

![https://blog.golang.org/survey2020/doc_struggles.svg](https://blog.golang.org/survey2020/doc_struggles.svg)

官方文档中问题最大的领域是模块使用和 CLI 开发，20% 的受访者认为模块文档对他们略有帮助或没有帮助，16% 的受访者认为 CLI 开发文档对他们略有帮助或没有帮助。

![https://blog.golang.org/survey2020/doc_helpfulness.svg](https://blog.golang.org/survey2020/doc_helpfulness.svg)

## Go 在云计算领域的应用

Go 在设计时也加入了对分布式计算的支持，我们希望继续改进使用 Go 构建云服务的开发人员的体验。

- 全球三大云服务供应商（Amazon Web Services、Google Cloud Platform、Microsoft Azure）的产品在受访者中的使用率持续上升，而其他供应商每年都只有很少的用户。特别是 Microsoft Azure 增长显著，从 7% 增至 12%。
- 作为最常见的部署目标，对自有服务器的 On-prem 部署继续减少。

![https://blog.golang.org/survey2020/cloud_yoy.svg](https://blog.golang.org/survey2020/cloud_yoy.svg)

部署到 AWS 和 Azure 的受访者中，部署到托管 Kubernetes 平台的比例有所增加，目前分别为 40% 和 54%。Azure 的用户中，将 Go 程序部署于虚拟机的比例显著下降，容器的使用率从 18% 增长到了 25%。与此同时，GCP（已经有很高比例的受访者表示正在使用托管 Kubernetes）部署于无服务器云上的情况有所增长，从 10% 增长到 17%。

![https://blog.golang.org/survey2020/cloud_services_yoy.svg](https://blog.golang.org/survey2020/cloud_services_yoy.svg)

总体而言，大多数受访者对在三大云服务平台上 Go 的使用感到满意，统计数字与去年相比没有变化。受访者对 AWS 和 GCP 的 Go 开发服务满意度相似，分别达到 82% 和 80%。Azure 的满意度较低(满意率为 58%)，能自由发表意见的用户反馈的意见中经常提到需要对 Azure 的 Go SDK 进行改进，以及加大对 Azure 函数的支持。

![https://blog.golang.org/survey2020/cloud_csat.svg](https://blog.golang.org/survey2020/cloud_csat.svg)

## 痛点

在无法使用 Go 进行开发的原因中，前几位仍然是：目前以其他语言作为开发语言（占 54%）、目前开发团队使用其他语言进行开发（占 34%）和 Go 语言本身缺少某些重要特性（占 26%）。

今年，我们推出了一个新的选项——“我已经可以在任何需要的场景下使用 Go 语言”，这样受访者就可以选择不做不妨碍他们使用 Go 的选择。这大大降低了所有其他选项的选择率，但没有改变它们的相对顺序。我们还引入了 “Go  语言缺乏关键框架”的选项。

如果我们只关心那些填写不使用 Go 的原因的受访者，我们就能更好地了解每年的趋势。在现有的项目中使用另一种语言，项目/团队/领导对另一种语言的偏好会随着时间的推移而减少。

![https://blog.golang.org/survey2020/goblockers_yoy_sans_na.svg](https://blog.golang.org/survey2020/goblockers_yoy_sans_na.svg)

26% 的受访者认为 Go 缺乏他们需要的语言特性，88% 的人认为泛型是 Go 语言缺少的关键特性。其他关键缺失的特性有：更好的错误处理(58%)、对 null 值的安全措施(44%)、函数式编程特性(42%)和更强/扩展类型系统(41%)。

需要明确的是，这些数据只是来自那些表示如果 Go 能提供他们所需要的一些关键功能，他们就会更多地使用 Go 的受访者子集，而不是所有受访者。从这个角度来看， 18% 的受访者是因为缺少他们需要的泛型而不使用 Go。

![https://blog.golang.org/survey2020/missing_features.svg](https://blog.golang.org/survey2020/missing_features.svg)

使用 Go 语言最大的挑战是缺少泛型（占比 18%），而模块/包管理工具和学习曲线/最佳实践/文档方面的问题都占 13%。

![https://blog.golang.org/survey2020/biggest_challenge.svg](https://blog.golang.org/survey2020/biggest_challenge.svg)

## Go 开发者社区

今年我们要求被调查者提供 5 个他们经常使用的问答网站。去年我们只要求提供 3 个，所以结果不能直接比较，然而，StackOverflow 仍然是最热门的，有 65% 的被调查者在使用。源代码仍然是热门的学习资源（占比 57%），而对于 godoc.org 网站的依赖已经明显下降（只占 39%）。查找包的网站 pkg.go.dev 是今年新加入的，已经成为了 32% 受调查者的首选。使用 pkg.go.dev 的受调查者更多地认为：他们可以更快地找到需要的包。91% 选择使用 pkg.go.dev，82% 选择其他网站。

![https://blog.golang.org/survey2020/resources.svg](https://blog.golang.org/survey2020/resources.svg)

随着时间的推移，被调查者中不再参加与 Go 有关的线下活动的比例不断增加。由于新冠肺炎疫情，我们修改了相关问题，发现超过四分之一的被调查者花在参与线上活动的时间比去年多，有 14% 参加过一场以 Go 开发为主题的虚拟聚会，是去年的两倍。其中，有 64% 表示这是他们参加的第一场虚拟会议。

![https://blog.golang.org/survey2020/events.svg](https://blog.golang.org/survey2020/events.svg)

我们发现，有 12% 的受访者来自于传统上代表性不足的群体(如少数族裔、少数性别等)，这一比例与 2019 年相同。有 2% 的受访者是女性，低于 2019 年的 3%。来自代表性不足群体的受访者更不认同 “我在 Go 社区比较受欢迎”( 10% vs. 4%)。这些问题让我们能够衡量社区的多样性，并强调拓展和增长的机会。

![https://blog.golang.org/survey2020/underrep.svg](https://blog.golang.org/survey2020/underrep.svg)

![https://blog.golang.org/survey2020/underrep_groups_women.svg](https://blog.golang.org/survey2020/underrep_groups_women.svg)

![https://blog.golang.org/survey2020/welcome_underrep.svg](https://blog.golang.org/survey2020/welcome_underrep.svg)

今年我们额外增加了一个关于辅助技术使用的问题，发现 8% 的受访者正在使用某种形式的辅助技术。最常用的辅助技术是对比度或颜色设置(有 2% 受访者在使用)。这及时地提醒我们，我们有很多有着典型需求的用户，这也能促使我们的设计团队去满足这些需求。

![https://blog.golang.org/survey2020/at.svg](https://blog.golang.org/survey2020/at.svg)

Go 团队注重多样性和包容性，这不仅仅是正确的做法，更是因为不同的声音可以照亮我们的盲点，并最终使所有用户受益。根据数据隐私法规，我们询问敏感信息的方式，包括性别和是否属于传统上代表性不足的群体，已经发生了变化，我们希望在未来让这些问题，特别是关于性别多样性的问题更具包容性。

## 结论

感谢您阅读我们这篇 2020 年开发者调查报告。了解开发者的经历和他们面临的困难将帮助我们检验自身，引导 Go 语言的未来。再次感谢所有参与这次调查的人们——没有你们，我们做不到。期待明年再次相遇。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---


> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
