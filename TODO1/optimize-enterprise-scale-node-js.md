> * 原文地址：[How to Optimize Enterprise-Scale Node.js Applications](https://www.javacodegeeks.com/2018/08/optimize-enterprise-scale-node-js.html)
> * 原文作者：[AppDynamics](https://www.javacodegeeks.com/author/appdynamics)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/optimize-enterprise-scale-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/optimize-enterprise-scale-node-js.md)
> * 译者：
> * 校对者：

# 如何优化企业级规模的 Node.js 应用程序

![](https://www.javacodegeeks.com/wp-content/uploads/2018/07/advanced-node-js-success.jpg)

**总结**

Cisco (AppDynamics) 在今年的 APM 报告中排名第一。[下载 Gartner 的 2018 Magic Quadrant 来了解更多的 APM](https://www.appdynamics.com/gartner-magic-quadrant-application-performance-monitoring-2018/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=sponsored%20post%20cta%20sponsorship&utm_content=gartner%E2%80%99s%202018%20magic%20quadrant&utm_term=sponsored%20post%20cta%20sponsorship&utm_budget=digital)！

**为了发现优化、部署以及维护企业级 Node.js 应用程序的专家技术而获取高级 Node.js 成功指南**。

Node.js 正迅速成为构建快速、可伸缩的 Web 和移动应用程序的最流行平台之一。事实上，[2017 Node.js 用户调查](https://foundation.nodejs.org/wp-content/uploads/sites/50/2017/11/Nodejs_2017_User_Survey_Exec_Sum.pdf)显示，目前网上有超过 700 万个 Node.js 实例，四分之三的用户计划在未来 12 个月内增加对 Node.js 的使用。很容易发现原因：68% 的用户认为 Node.js 提高了开发者的生产力，58% 的用户认为 Node.js 降低了开发成本，50% 的用户认为 Node.js 提高了应用程序的性能。

Node.js 日益成为应用程序开发的首选技术，对 Node.js 的专业开发者的需求也逐渐增加。尽管已有大量文章为我们描述了 Node.js 可以用来做什么，开发者如何开始使用，以及它为什么会成为世界上一些大公司核心服务器的技术 —— 但实际上**并没有**多少是为了帮助初学者或中级 Node.js 开发者提高他们目前的技术水平。**到目前为止来说**。

在我们最新的 eBook 中，[高级 Node.js：优化、部署以及维护企业级 Node.js 应用程序](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital)，我们分享了 Node.js 的启动和运行企业级产品、服务和品牌构建的高级技术。

我们认为，这是一个没有得到应有关注度和专家见解的主题。在大多数情况下，发布之后的过程比开发过程要长，影响也更大。这个阶段还决定了 Node.js 应用程序在交付技术所承诺的业务价值方面是成功还是失败。

[EBook](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital) 为 Node.js 成功上线的关键前三个月提供了一个实践的成功基础 —— 从预生产计划到持续部署和测试的时间跨度。

具体来说，eBook 为以下每一个关键点都提供了提示、技巧以及最佳实践：

## 1. 为生产做准备：

在任何应用程序开发过程中，准备发布总是一个关键点，Node.js 项目也是如此。在问题影响你的部署过程、最终用户或业务本身之前，这是你的团队找到并修复问题的最后机会。

EBook 向用户介绍了发布前的过程，并强调了一下内容：

*   优化你的代码
*   Error 处理的最佳实践
*   确保你的代码符合安全要求
*   配置生产环境
*   部署的注意事项

当涉及到代码优化时，[eBook 中详细描述预生产前的最佳实践](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital)中有一个名为 “linting.” 的过程。这需要通过代码库运行一个自动化的代码质量工具 —— 比如 ESLint 或者 JShint。它通常只涉及非常基础的质量问题，但重点是：在将应用程序置于危险情况之前，它可以捕捉到可避免的 —— 而且非常容易修复的 error。

## 2.部署 Node.js 的前 24 小时

在介绍完有效预生产前的工作流的基本原理后，我们接下来将看到在部署后的最初 24 小时内所期望的是什么，以及如何做出响应。

部署企业级应用程序可能令人痛苦。毕竟，[XebiaLabs 的应用程序发布自动化调查趋势](https://www.wired.com/insights/2013/04/why-30-of-app-deployments-fail/)显示，接近 30% 的应用程序部署失败。同时，[自动化运维、持续交付以及应用程序自动化发布调查趋势](https://techbeacon.com/survey-paints-discouraging-scenario-enterprise-it-software-delivery-development)显示，77% 的组织存在然间生产发布的问题。显然，任何负责部署应用程序的人都应该为出错做好准备 —— 可能是经常性或偶尔发生的错误。

虽然健壮的预生产过程可以帮组最小化 bug、配置失败和其他可避免问题的影响，但专业 Node.js 开发者应该了解如何解决常见的“第一天”部署问题 —— 尤其是那些导致奔溃或高影响的问题。

在最初的 24 小时内可能会出现的典型问题包括：

*   Node.js 进程奔溃
*   超过 API 的利用率
*   WebSocket 问题的疑难解答
*   依赖问题
*   文件上传问题
*   DDoS 攻击

这些第一天的好消息中有一个惊喜（会有惊喜），就是你会学到更多关于构建更好 Node.js 应用程序，以及如何通过产生最少的部署问题来部署应用程序。尽管以后还会发生问题，但真正严重的问题会越来越少。

更好的消息是，一旦你有效地解决了第一天的问题，你以后就会处理一个更稳定和更可靠的应用程序。这反过来让你可以专注于如何提高应用程序的性能，以及如何升级自己的构建、测试和部署 Node.js 应用程序的流程。

## 3. 持续管理

已经成功部署后，[eBook](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital) 的最后一章将查看 Node.js 应用程序正在进行的管理。尽管这与任何其他应用程序的发布过程没有什么不同，但你还是应该注意以下一些细节：

*   内存泄露
*   管理 Node.js 的并发性
*   监控

正如我们在 eBook 中讨论的那样，应用程序性能监控（APM）对于维护应用程序部署的稳定性和检测可能导致应用程序降速或彻底失败（如果不进行检查）的敏感回归至关重要。[APM 解决方案就像 AppDynamics](https://www.appdynamics.com/solutions/nodejs-monitoring/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital) 可以提供对应用程序行为终端对终端的了解，并为 Node.js 堆栈提供特定的监视功能。

[获取指南](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital)

在我们最新的 eBook [高级 Node.js：优化、部署以及维护企业级 Node.js 应用程序](https://www.appdynamics.com/lp/advanced-nodejs-guide/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=jcg%20sponsored%20post&utm_content=how%20to%20optimize%20enterprise-scale%20node.js%20applications&utm_term=jcg%20sponsored%20post%20sponsorship&utm_budget=digital)中可以阅读到有关部署和管理你的应用程序的所有最佳实践。

[下载 Forrester 报告](https://blog.appdynamics.com/news/forrester-reveals-roi-of-appdynamics-with-cisco/?utm_source=javacodegeeks&utm_medium=sponsorship%20content%20syndication&utm_campaign=sponsored%20post%20cta%20sponsorship&utm_content=forrester%20report%20&utm_term=sponsored%20post%20cta%20sponsorship&utm_budget=digital)来了解你可以期望从 AppDynamics APM 及其与 Cisco 技术集成中节省的成本和业务利益。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
