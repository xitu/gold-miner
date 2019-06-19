> * 原文地址：[Micro Frontends](https://martinfowler.com/articles/micro-frontends.html)
> * 原文作者：[Cam Jackson](https://camjackson.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * 译者：[Jenniferyingni](https://github.com/Jenniferyingni)
> * 校对者：[Stevens1995](https://github.com/Stevens1995), [Baddyo](https://github.com/Baddyo)

# 微前端：未来前端开发的新趋势 — 第一部分

做好前端开发不是件容易的事情，而比这更难的是扩展前端开发规模以便于多个团队可以同时开发一个大型且复杂的产品。本文将描述一种趋势，可以将大型的前端项目分解成许多个小而易于管理的部分，也将讨论这种体系结构如何提高前端代码团队工作的有效性和效率。除了讨论各种好处和代价之外，我们还将介绍一些可用的实现方案和深入探讨一个应用该技术的完整示例应用程序。

* * *

近年来，[微服务](https://martinfowler.com/articles/microservices.html) 已经大受欢迎，许多组织使用这种架构风格来避免大型单体（monolithic）后端的局限性。关于如何在服务器端软件中也采用类似风格，虽然现在已经有许多相关的文章，但是许多公司仍然还是在单体前端代码库中挣扎。

也许您想构建一个渐进式或响应式 Web 应用程序，但无法找到一个方法将这些特性整合到现有代码中。也许您想要使用 JavaScript 的新特性（或者是其他的可以编译成 JavaScript 的语言），但无法在项目已有的构建流程中加入新增的构建工具。又或者您可能只是想扩展您的开发规模，以便多个团队可以同时处理一个项目，但现有单体架构中的耦合和复杂性意味着每个人负责的代码都会有不可避免的重合。这些都是真实存在的问题，这些问题都会对您有效地为客户提供高质量服务的能力产生负面影响。

最近，我们越来越关注复杂的现代 Web 开发所需的整体架构和组织结构。值得一提的是，我们看到了一种将前端整体分解为小而简单的块的模式。这些块可以独立开发、测试和部署，同时仍然聚合为一个产品出现在客户面前。 我们将这种技术称为**微前端**，我们将其定义为：

> 一种将多个可独立交付的小型前端应用聚合为一个整体的架构风格

在 2016 年 11 月发表的 **ThoughtWorks 技术雷达**期刊中，我们将[微前端](https://www.thoughtworks.com/radar/techniques/micro-frontends)归为了评估等级。后来又将其提升到了试验等级，最终列为了采纳等级，这意味着，我们将微前端视为一种经过验证的方法，应该在合适的情境中采用它。

![**ThoughtWorks 技术雷达**中的微前端文章截图](https://martinfowler.com/articles/micro-frontends/radar.png)

图 1：微前端在**技术雷达**中多次被提及。

采用微前端的几个主要优点是：

* 体积小、易拼合且易于维护的代码库
* 更具扩展性的互相解耦且独立的团队
* 和以前相比能采用增量的方式，更易于对前端的某些部分进行升级、更新甚至重写

以上列出的优点与微服务的优点相同，这并非巧合。

当然了，“天底下没有免费的午餐”，这句话在软件架构中同样适用，有些微前端实现可能导致依赖项的重复，增加了用户所需下载依赖的体积。除此之外，团队独立性的急剧增加会造成团队风格的差异。尽管如此，我们认为这些是可控的风险，并且使用微前端所带来的好处要远远多于付出的代价。

* * *

## 优点

我们会着重关注微前端的新属性以及它们带来的好处，而不是使用具体的技术或者实现细节来定义微前端。

### 增量升级

对于许多团队来说，这是他们开始微前端之旅的初始原因。那种陈旧而庞大的前端单体模式，被过时的技术栈或赶工完成的代码质量死死拖住后腿，其程度之严重，已经到了让人看了就禁不住想推翻重写的地步。为了避免完全重写的[风险](https://www.joelonsoftware.com/2000/04/06/things-you-should-never-do-part-i/) ，我们更加倾向于将旧的应用程序逐步地[翻新](https://martinfowler.com/bliki/StranglerApplication.html)，与此同时不受影响地继续为我们的客户提供新功能。

这往往就需要用到微前端架构。一旦有团队能做到持续地增加新功能并且对原有的整体几乎不做修改，其它的团队也会争相效仿。已有的代码依旧需要维护，有些情况下继续为其增加新功能也是有必要的，但是现在微前端提供了可选项。

微前端能使我们更加自由地对产品的各个部分做出独立的决策，使我们的架构、依赖以及用户体验都能够增量升级。如果主框架中有一个非兼容性的重要更新，每个微前端可以选择在合适的时候更新，而不是被迫中止当前的开发并立即更新。如果我们想要尝试新的技术，或者是新的交互模式，对整体的影响也会更小。

### 简单、解耦的代码库

每个单独的微前端项目的源代码库会远远小于一个单体前端项目的源代码库。这些小的代码库将会更易于开发。更值得一提的是，我们避免了不相关联的组件之间无意造成的不适当的耦合。通过增强应用程序的[边界](https://martinfowler.com/bliki/BoundedContext.html)来减少这种意外耦合的情况的出现。

当然了，一个独立的、高级的架构方式（例如微前端），不是用来取代规范整洁的优秀老代码的。我们不是想要逃避代码优化和代码质量提升。相反，我们加大做出错误决策的难度，增加正确决策的可能性，从而使我们进入[成功的陷阱](https://blog.codinghorror.com/falling-into-the-pit-of-success/)。例如，我们将跨边界共享域模型变得很困难，所以开发者不太可能这样做。同样，微前端会促使您明确并慎重地了解数据和事件如何在应用程序的不同部分之间传递，这本是我们早就应该开始做的事情！

### 独立部署

与微服务一样，微前端的独立可部署性是关键。它减少了部署的范围，从而降低了相关风险。无论您的前端代码在何处托管，每个微前端都应该有自己的连续交付通道，该通道可以构建、测试并将其一直部署到生产环境中。我们应当能够在不考虑其他代码库或者是通道的情况下来部署每个微服务。做到即使原来的单体项目是固定的按照季度手动发布版本，或者其他团队提交了未完成的或者是有问题的代码到他们的主分支上，也不会对当前项目产生影响。如果一个微前端项目已准备好投入生产，它应该具备这种能力，而决定权就在构建并且维护它的团队手中。

![图示：三个彼此独立的应用从源代码控制开始，经过构建、测试直至部署到生产环境](https://martinfowler.com/articles/micro-frontends/deployment.png)

图 2 : 每个微前端都独立的部署到生产环境上

### 自主的团队

将我们的代码库和发布周期分离的更高阶的好处，是使我们拥有了完全独立的团队，可以参与到自己产品的构思、生产及后续的过程。每个团队都拥有为客户提供价值所需的全部资源，这就使得他们可以快速且有效地行动。为了达到这个目的，我们的团队需要根据业务功能纵向地划分，而不是根据技术种类。一种简单的方法是根据最终用户将看到的内容来分割产品，因此每个微前端都封装了应用程序的单个页面，并由一个团队全权负责。与根据技术种类或“横向”关注点（如样式、表单或验证）来组成团队相比，这会使得团队工作更有凝聚力。

![图示：根据三个应用构成三个团队，提醒大家不要根据“样式”分队](https://martinfowler.com/articles/micro-frontends/horizontal.png)

图 3：每个应用都由一个团队负责

### 总结

简而言之，微前端都是将巨大的东西分成更小、更易于管理的小部分，然后明确它们之间的依赖关系。我们的技术选择、代码库、团队以及发布流程都应该能够彼此独立地运行和开发，不需要过多的协调。

我们将分期发表这篇文章。后续的文章将介绍用于实现这些功能的替代集成方法、如何处理诸如样式和应用间通信这类实现问题，我们也将讨论一些缺点，还有介绍详细的示例实现。

想知道我们何时发布后续部分，请订阅 [RSS 源](https://martinfowler.com/feed.atom)、[Cam 的 twitter](https://twitter.com/thecamjackson)、或者 [Martin 的 twitter](https://twitter.com/martinfowler)。

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

## 重要修改

**2019 年 6 月 10 日**：发布第一期文章，探讨了微前端的优点

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。

