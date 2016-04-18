>* 原文链接 : [Design Systems Ops](https://medium.com/salesforce-ux/introducing-design-systems-ops-7f34c4561ba7#.iumcuwu3v)
* 原文作者 : [Kaelig](https://medium.com/@kaelig)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [L9m](https://github.com/l9m/)
* 校对者:


![](https://cdn-images-1.medium.com/max/2000/1*RbwXg-OMlJTG7iiHs4NMQg.jpeg)

<figcaption>Design Systems Ops: 规模化地装运（设计）。</figcaption>

伟大的产品离不开工程师和设计师的良好沟通。无论你是谁，归根结底，我们都是在装运软件。有了设计系统之后，沟通将变得更好。

但是谁将建立起设计和开发之间的沟通桥梁呢？

我把这些推动者称之为 _Design Systems Ops._

Design Systems Ops 是设计团队的一部分，他需要是一名设计师，并且需要了解将设计师所想进行概念化。同时， Design Systems Ops 需要理解有助于装运和规模化设计系统的开发需求和定义方法。 在某种情况下，Design Systems Ops 是两个世界的转换人。

### 很多公司的通病

在大多数组织结构中，从概念到用户的过程是相当脱节的，产品结束时并不完全是设计者最初的想法。

![](https://cdn-images-1.medium.com/max/800/1*NJbl6JkUcbGPLU1bxVW7kw.png)

<figcaption>从概念到用户阶段的一种典型流程：越靠近用户阶段还原度会越低。</figcaption>

信号 （概念）受到干扰（低效）而逐渐变弱 ，并在一个相当低的还原度中完成。这种交付失败对公司有着巨大商业机会成本，构建高质量产品的能力有着巨大的影响。

### 设计系统的作用

样式指南，模式库，设计系统等围绕一种语言所有有助于规范化实践和设计模式。大多数低效都是源自于语言的障碍。

从颜色的命名，对象，约定，组件等等直到记录最佳的体验细节。比如动画定时或表单元素的圆角度值。 

一个好的设计系统能让设计决策更快。（比如 “行动召唤应该是什么颜色的”）。设计师们有更多时间聚焦于用户流程，并且在同时间内去探索多种概念，

一个好的设计系统也能帮助开发团队引用弹幕的真相来源。这对一致性有好处，因为所有的行动召唤跨屏幕将表现一致。

![](https://cdn-images-1.medium.com/max/800/1*lIa0DiwLnfc1y14t3KTWpA.png)

<figcaption>设计系统在这个过程中能减少低效：还原度一路上将保持大致稳定。</figcaption>

一些设计系统也用代码装运模式。这些设计系统从概念开始阶段，到原型阶段，直到实现阶段都能证明其价值。 当公司遵循这条路线，对生产效率和还原度都是一个好消息。

> 一个设计系统不是一个项目，它是一个产品，服务型产品 — Nathan Curtis

然而，一些设计系统远至产品代码获得它们应得的赞并在光荣列表中结束这是因为对于几个设计师和工程师的部分投资 [是不足够](https://medium.com/@marcelosomers/a-maturity-model-for-design-systems-93fff522c3ba)的：一个设计系统不是简单一个项目，他是一个产品(或就像 Nathan Curtis [说的](https://medium.com/eightshapes-llc/a-design-system-isn-t-a-project-it-s-a-product-serving-products-74dcfffef935): “_一个设计系统不是一个项目，它是一个产品，服务型产品_.”). 为了让设计系统在交付流程的不同阶段都显示出对应的价值，它需要适当规划，用户研究和方法（和很多热爱）。 我们将那些团队把设计系统目标定位为：_有生命力的设计系统_称之为最优设计系统。

### 介绍 Design Systems Ops

有生命力的设计系统和世界上数不清其他设计系统间剩下的低效率。 大多数是因为开发团队和设计团队缺乏良好的沟通。 在结束的那一天，产品将用代码的格式装运 ，在这过程中任何影响效率的任何事情都应该被审查。介绍一种 Design Systems Ops 的角色 （灵感来自 [DevOps](https://en.wikipedia.org/wiki/DevOps) 运动），它可以缓解这些低效率：

![](https://cdn-images-1.medium.com/max/800/1*Bp4eHmFtS5pfdPHv4pEwdQ.png)

<figcaption>通过在设计和开发间引入一位中间者，进一步增加效率，增加软件交付的还原度。</figcaption>

来自于两边的关于设计系统的一些问题：

*   我从哪里可以找到标记, 颜色面板，数值，图标，模式，断点？
*   如果我在原型中，产品中，Web view 中如何加载CSS？
*   加载字体图标的最佳方式事什么？
*   他们对性能有什么影响？
*   我应该在哪里发现文件错误并且在哪里寻找其他人对他们问题的解决办法（问题追踪，知识基础）？
*   我该如何为设计系统做贡献（修复 bug,增加一个图标）？
*   我是一个参与者，我该怎样在多种环境中测试我的代码而不至于出错呢？
*   我事一个开发者，对于设计系统我该知道什么？
*   我事一个设计师，我该怎样在浏览器中迭代一个现有模式呢？
*   从 v1.0 到 v2.0 的升级路径事什么？
*   0.5.0 版本的文档在哪里？

我学习了一些像[Bootstrap](http://getbootstrap.com/) 和 [Material Design Lite](http://getmdl.io/) 这样的开源项目。在卫报, [我开始构建起设计和开发的桥梁](https://www.youtube.com/watch?v=ciG-A_1FyVg)，大多采用 Sass 。在金融时报时 [Origami](http://origami.ft.com) 工作时帮助我发现规模化设计的新思路。 我今天工作的地方， [Salesforce](https://www.lightningdesignsystem.com)，有一个团队的工程师作为 Design Systems Ops，热爱于装运更快并且更好的代码给用户。

在回顾我过往如何规模化设计的经验之后，这里有些事能归入Design System Ops 的作用下：

*   本地开发环境 （源映射，无刷新重载，速度）
*   托管（放置设计展示和文档）
*   代码演示（比如 CodePen, JS Bin）
*   技术文档（安装，问题诊断）
*   前端自动化测试（可访问性，集成）
*   跨浏览器自动化测试
*   视觉回归测试
*   代码风格检查 ([我之前写的](https://www.theguardian.com/info/developer-blog/2014/may/13/improving-sass-code-quality-on-theguardiancom))

前面这一系列是以前端为中心的，但是这里有些更接近后端的：

*   构建系统
*   资源储存和分布（CDN，压缩）
*   性能测试（资源大小，服务器加载，CDN 响应时间等等）
*   版本流程（比如 git, SemVer）
*   发布流程 （比如 [持续开发](http://radar.oreilly.com/2009/03/continuous-deployment-5-eas.html), [持续集成](http://guide.agilealliance.org/guide/ci.html)）
*   测试/阶段环境
*   展现测试结果和性能结果（比如 仪表板，邮件）

或者，更靠近市场营销这边的事情（开发宣传）：

*   构建示例
*   帮助开发者实现这个设计系统
*   跟开发社区布道这个设计系统

就像前面提到的这些方面有坚实的解决方案能很大地帮助设计团队提高交付质量。提高他们操作的速度和信心。 **这是我相信为什么在设计团队中有个好的参谋将增加项目成功的可能。**

### 总结

随着越来越多的公司构建属于自己的设计系统，他们也显示出对于增加支持设计工作和工具的技术人员表现出兴趣。因为它只是这个角色的开始 ，我们将有很多问题。那些让我夜不能寐。

*   **Design Systems Ops 能在其他方面做些什么？**
*   **什么工具能帮助小型团队在成本有限的情况下遵循这个路线呢？**
*   **除了开发速度，还有那些方面应该是Design Systems Ops应该评判的？**

我喜欢了解你的所想，如果你也在旧金山，来[享受一杯咖啡](https://twitter.com/kaelig)并谈谈你的想法吧。

Design Systems Ops 并不是我凭空产生的想法，要理解我想法的由来，你可以阅读[Ian Feather's awesome presentation about Front End Ops](http://ianfeather.co.uk/presentations/front-end-ops/).

同样， 听 [Design Details](http://spec.fm/) 播客，那里有创造他们的设计系统和风格指南的全世界很优秀的设计师。

最后，如果你想从整体上讨论上设计系统或想去更多学习它们，不要错过 2016年3月31日到4月1日在旧金山举行的 [Clarity Conference](http://clarityconf.com/) （由设计系统女王自己组织: [jina ₍˄ุ.͡˳̫.˄ุ₎](https://medium.com/u/f5d1807b438)).

