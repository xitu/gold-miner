> * 原文地址：[TSLint in 2019](https://medium.com/palantir/tslint-in-2019-1a144c2317a9)
> * 原文作者：[Palantir](https://medium.com/@palantir)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/tslint-in-2019.md](https://github.com/xitu/gold-miner/blob/master/TODO1/tslint-in-2019.md)
> * 译者：
> * 校对者：

## TSLint in 2019

![](https://cdn-images-1.medium.com/max/5984/1*YtDebDXHLQIWDyJl2LWh8g.png)

Palantir是[TSLint项目](https://github.com/palantir/tslint)（TypeScript的标准静态代码分析工具）的创建者和主要的维护者。TypeScript社区正致力于提供统一的、跨TypeScript和JavaScript两种语言的开发体验，我们在努力让TSLint和ESLint进行收敛，在这篇文章中，我们会解释我们为什么要这么做以及如何去做。

## 现在的TSLint和ESLint

现在，TSLint事实上已经是TypeScript项目的标准静态代码分析工具了。TSLint的生态由一个核心的规范集，社区维护的多种自定义规则以及配置包组成。

同时，ESLint是JavaScript的标准静态代码分析工具。和TSLint一样，ESLint也是由一个核心规范集和许多社区维护的自定义规则组成。ESLint支持TSLint所缺少的很多功能，比如，[条件lint配置](https://github.com/palantir/tslint/issues/3447)和[自动缩进](https://github.com/palantir/tslint/issues/2814)。相反，ESLint的规则不能受益于（至少现在不能）TypeScript语言所提供的静态分析以及类型推断，因此无法捕获TSLint[语义规则](https://palantir.github.io/tslint/usage/type-checking/)所覆盖的一类错误和代码异味（code smells）。

## TypeScript + ESLint

TypeScript团队的[战略方向](https://github.com/Microsoft/TypeScript/issues/29288)是让“每个桌面，在每栋房子里，每个JS开发者都使用类型”。换句话说，这个方向主要是通过类型和静态代码分析来逐渐完善JavaScript的开发体验，直到TypeScript和JavaScript开发体验逐渐融合。

很明显，静态代码分析是TypeScript以及JavaScript开发体验的一个核心部分，所以Palantir的TSLint团队和Redmond的TypeScript核心团队会面，讨论了TypeScript和JavaScript融合对于静态代码分析的意义。TypeScript社区旨在满足JavaScript开发人员的需求，ESLint是JavaScript的首选静态代码分析工具。为了避免分裂TypeScript的静态代码检查工具，我们计划废弃TSLint，并且集中精力去改进ESLint对于TypeScript的支持。我们认为这是正确的前进道路，具有战略意义并且务实的原因：

* **无障碍接入**：JavaScript开发人员迁移到TypeScript的障碍之一是从ESLint到TSLint的无障碍迁移。允许开发人员可以从现有的ESLint设置开始，逐步添加TypeScript特定的静态分析规则，可以降低这样的迁移障碍。

* **社区整合**：TSLint和ESLint有着同样的核心目标：通过强大的规范集和可扩展的插件来提供出色的静态代码分析体验。现在，在ESLint中提供TypeScript解析，我们认为这是让社区标准化的最好方式，而非工具之间的竞争。

* **更高性能的分析工具**：ESLint API支持更有效地进行某些类型的检查。虽然可以对于TSLint的API进行重构，但是直接利用ESLint的架构并且将开发资源集中到其他地方是明智的选择。

* **投入预估**：在Palantir中，TSLint为我们的TypeScript语言实现的交易保驾护航。因此，他的功能集和架构已经非常成熟，并且达到了稳定的状态。因此，我们很难确定需要的社区贡献，才能够让TSLint达到我们承诺的水平。

## 下一步

Palantir将会通过一系列功能和插件的贡献支持TSLint社区实现从TSLint到ESLint的平滑过渡。（快去叫[James Henry](https://github.com/JamesHenry)和其他贡献者一起，让这个过程开始吧），比如：

* **在TypeScript中编写ESLint规范的支持和文档：** 可以看[这个typescript-eslint issue](https://github.com/typescript-eslint/typescript-eslint/issues/40)。

* **typescript-eslint的测试架构：**ESLint的内置规则测试器很难使用，并且测试用例语法很难阅读。我们会提供类似[TSLint的测试基础架构](https://palantir.github.io/tslint/develop/testing-rules/)来保证体验不会差于TSLint。

* **基于语义的类型检查规则：**移植并且添加新的，为TypeScript语言服务的规则。

一旦我们觉得ESLint中关于TSLint的特性已经完整，我们就会废弃TSLint，并且帮助用户们迁移到ESLint，在那之前，我们的主要任务包括：

* **继续支持TSLint：**在TSLint维护中，我们最重要的任务是确保其与TypeScript新版本的编译器和功能的兼容性。

* **TSLint到ESLint的兼容包：**一旦ESLint静态分析检查功能到达了与ESLint相同的时候，我们将会发布*eslint-config-palantir*包，这是将我们的TSLint规则集到ESLint的插入式替换。

我们很高兴看到TypeScript和TSLint在过去几年中的应用变得越来越多，并且我们也很高兴能为Web开发生态中更为具有影响力的TypeSCript做出贡献！如果你有任何问题或者疑虑，请通过评论此帖子或者Github issue的方式与我们取得联系。

## 作者

[Adi D.](https://twitter.com/adi_dahiya)，[John W.](https://github.com/johnwiseheart)，[Robert F.](https://github.com/uschi2000)，Stephanie Y.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
