>* 原文链接 : [Design Systems Ops](https://medium.com/salesforce-ux/introducing-design-systems-ops-7f34c4561ba7#.iumcuwu3v)
* 原文作者 : [Kaelig](https://medium.com/@kaelig)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [L9m](https://github.com/l9m/)
* 校对者: [JasinYip](https://github.com/JasinYip), [shenxn](https://github.com/shenxn), [Ruixi](https://github.com/Ruixi)

# 设计师如何跟开发打好关系？

![](https://cdn-images-1.medium.com/max/2000/1*RbwXg-OMlJTG7iiHs4NMQg.jpeg)

<figcaption>Design Systems Ops: 规模化地装运（设计）。</figcaption>

伟大的产品离不开开发和设计的良好沟通。无论你是谁，归根结底，我们都是在创造软件产品。有了设计系统之后，沟通将变得更加简单。

但是谁将建立起设计和开发之间的沟通桥梁呢？

我把这些推动者称为 _Design Systems Ops._

Design Systems Ops 是设计团队的一部分，他需要足够了解设计，并且要了解他们试图概念化什么。同时，Design Systems Ops 需要理解工程师的需求和定义方法，这将有助于设计系统的装运和规模化。在某些程度上，一个 Design Systems Ops 是两个世界的翻译。

### 大多数公司存在的问题

在大多数组织流程结构中，从概念到用户的过程是相当脱节的，以致于产品最终完成时和设计师的初衷很不一致。

![](https://cdn-images-1.medium.com/max/800/1*NJbl6JkUcbGPLU1bxVW7kw.png)

<figcaption>从概念到用户的一种典型流程是：越靠近用户阶段，还原度越低。</figcaption>

信号（概念）受到干扰（低效率）而逐渐变弱，产品在一个非常低的还原度中结束。这种失败对公司创造高质量产品的能力有着巨大影响，并且造成巨大商业机会的浪费。

### 设计系统能干什么

风格指南、模式库、设计系统等都有助于围绕一种通用的设计语言去规范化实践和设计模式。而语言障碍恰恰是大多数低效率的诱因。

从颜色命名、对象、惯例、组件等开始，到记录最好的最细枝末节的体验，比如动画定时或表单元素的圆角度值。 

一个好的设计系统能让设计决策更快。（比如“ call to action 应该是什么颜色”）。从而设计师可以在同样长的时间里，将更多的时间放在（优化）用户流程和对多种概念的探索上。

一个好的设计系统也是帮助开发团队在开发阶段找到获取设计的唯一来源。这对一致性很有好处，因为所有的 call-to-action 都将表现一致。

![](https://cdn-images-1.medium.com/max/800/1*lIa0DiwLnfc1y14t3KTWpA.png)

<figcaption>设计系统能在这个过程中减少做无用功：还原度一路上将保持大致稳定。</figcaption>

一些设计系统也用代码来传达设计模式。这些设计系统从概念开始阶段，到原型阶段，直到实现阶段都能证明其价值。当公司遵循这种方式，这种方式对于生产效率和还原度都是很有帮助的。

> 一个设计系统不是一个项目，它是一个产品，服务型产品 — Nathan Curtis

然而，一些设计系统并没有获得它们应有的赞许，却沦为设计模式的光荣榜，而这些模式离真正的产品代码非常遥远。这是因为对于几个设计师和工程师的部分投资 [是不足够](https://medium.com/@marcelosomers/a-maturity-model-for-design-systems-93fff522c3ba)的：一个设计系统不是简单一个项目，它是一个产品(或就像 Nathan Curtis[说的](https://medium.com/eightshapes-llc/a-design-system-isn-t-a-project-it-s-a-product-serving-products-74dcfffef935)： “_一个设计系统不是一个项目，它是一个产品，服务性产品_。”)。为了让设计系统在交付流程的不同阶段都显现出对应的价值，它需要适当规划，用户研究和方法（和很多热爱）。那些创造出最优设计系统的团队，都将设计系统的目标定位为_有生命力的设计系统_。

### 引入 Design Systems Ops

有生命力的设计系统和其他设计系统之间存在的差距是巨大的。这主要是因为开发团队和设计团队缺乏良好的沟通。最终，产品将用代码的格式呈现，在这过程中影响效率的任何事情都应该被检查。通过引入一个 Design Systems Ops 的角色（灵感来自[DevOps](https://en.wikipedia.org/wiki/DevOps) 运动），能够改善这些低效：

![](https://cdn-images-1.medium.com/max/800/1*Bp4eHmFtS5pfdPHv4pEwdQ.png)

<figcaption>通过在设计和开发间引入一位中间者，进一步减少低效，增加软件交付的还原度。</figcaption>

来自于设计系统两边的许多问题：

*   我从哪里可以找到标记、颜色面板、数值、图标、模式、断点？
*   在制作原型时、在产品中、或者在 Web 视图中我应该如何加载 CSS？
*   加载字体图标的最佳方式是什么？
*   它们对性能有什么影响？
*   我应该在哪里发现文件错误，又应该在哪里寻找其他人解决自身问题的办法（问题追踪，知识基础）？
*   我该如何为设计系统做贡献（修复 bug 、增加一个图标）？
*   我是一个参与者，我该怎样在多种环境中测试我的代码而不至于出错呢？
*   我是一个开发者，对于设计系统我该知道些什么？
*   我是一个设计师，我该怎样迭代浏览器中的现有模式？
*   从 v1.0 到 v2.0 的升级路径是什么？
*   0.5.0 版本的文档在哪里？

我学习了一些像 [Bootstrap](http://getbootstrap.com/) 和 [Material Design Lite](http://getmdl.io/) 这样的开源项目。在《卫报》, [我开始构建起设计和开发的桥梁](https://www.youtube.com/watch?v=ciG-A_1FyVg)，里面提到主要采用 Sass 。在金融时报为 [Origami](http://origami.ft.com) 项目工作时也帮助我发现规模化设计的新思路。 我今天工作的地方， [Salesforce](https://www.lightningdesignsystem.com)，有一个团队的工程师作为 Design Systems Ops，热衷于将更快更好的代码交付给用户。

在回顾我过往如何规模化设计的经验之后，这些都是 Design System Ops 可以做的工作：

*   本地开发环境（源映射，无刷新重载，速度）
*   托管（放置设计展示和文档）
*   代码演示（比如 CodePen、JS Bin）
*   技术文档（安装、问题诊断）
*   前端自动化测试（可访问性、集成）
*   跨浏览器自动化测试
*   视觉回归测试
*   代码风格检查 ([我之前写的](https://www.theguardian.com/info/developer-blog/2014/may/13/improving-sass-code-quality-on-theguardiancom))

前面这一系列是以前端为中心的，但是这里有些更接近后端的：

*   构建系统
*   资源储存和分布（CDN、压缩）
*   性能测试（资源大小、服务器加载、CDN 响应时间等等）
*   版本流程（比如 git、SemVer）
*   发布流程 （比如 [持续开发](http://radar.oreilly.com/2009/03/continuous-deployment-5-eas.html)、[持续集成](http://guide.agilealliance.org/guide/ci.html)）
*   Testing/Staging阶段环境
*   展现测试和性能结果（比如 仪表板、邮件）

或者，更靠近市场营销这边的事情（开发宣传）：

*   构建示例
*   帮助开发者实现这套设计系统
*   给开发社区布道这套设计系统

就像前面提到的，在这些方面有坚实的解决方案能很大地帮助设计团队提高交付质量，并提高工作的速度和信心。**这是为什么我相信在设计团队中有个好的参谋将增加项目成功的可能性。**

### 总结

随着越来越多的公司构建属于自己的设计系统，他们也开始显示出增加技术人员去支持设计的工作和工具的兴趣。因为它只是这个角色的开始，有些问题也让我夜不能寐。

*   **Design Systems Ops 能在其他方面做些什么？**
*   **什么工具能帮助小型团队在成本有限的情况下遵循这个路线呢？**
*   **除了开发速度，还有那些方面应该是Design Systems Ops应该评判的？**

我非常乐意听听你的看法，如果你也在旧金山，来[喝杯咖啡](https://twitter.com/kaelig)聊一聊。

Design Systems Ops 并没有我凭空产生的想法，要理解我想法的由来，你可以阅读[Ian Feather's awesome presentation about Front End Ops](http://ianfeather.co.uk/presentations/front-end-ops/).

同样， 听 [Design Details](http://spec.fm/) 播客，全世界许多优秀的设计师都在那里分享他们创造设计系统和风格指南的经验。

如果你想从整体上讨论设计系统或者想要更多地了解它们，不要错过 2016年3月31日到4月1日在旧金山举行的 [Clarity Conference](http://clarityconf.com/) （由设计系统女王自己组织: [jina ₍˄ุ.͡˳̫.˄ุ₎](https://medium.com/u/f5d1807b438)).
