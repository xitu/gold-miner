> * 原文地址：[Sunsetting React Native](https://medium.com/airbnb-engineering/sunsetting-react-native-1868ba28e30a)
> * 原文作者：[Gabriel Peal](https://medium.com/@gpeal?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/sunsetting-react-native.md](https://github.com/xitu/gold-miner/blob/master/TODO1/sunsetting-react-native.md)
> * 译者：[ALVINYEH](https://github.com/ALVINYEH)
> * 校对者：[DateBro](https://github.com/DateBro)

# React Native 退役

## 由于各种技术和组织方面的问题，我们将停止使用 React Native，并将致力于让原生体验更好。

![](https://cdn-images-1.medium.com/max/2000/1*8c-9hgBkRGcllO9CHcTzbQ.jpeg)

**这是[系列博客文章](https://juejin.im/post/5b2c924ff265da59a401f050)中的第四篇，本文将会概述使用 React Native 的经验，以及 Airbnb 移动端接下来要做的事情。**今天，我们路在何方？

尽管很多团队都依赖 React Native，计划在可预见的将来投入使用，但我们最终无法实现我们原来的目标。此外，还有一些我们无法克服的[技术](https://juejin.im/post/5b3b40a26fb9a04fab44e797)和[组织](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88)挑战，使继续投入使用 React Native 变得更加困难。

因此，我们要勇往直前，**Airbnb 正式停止使用 React Native**，并将我们所有的精力重新投入原生。

### 未能实现我们的目标

#### 迭代速度需要更快

当 React Native 能按预期工作时，工程师能够以无与伦比的速度进行迭代。但是，我们在本系列博客中所概述的众多[技术](https://juejin.im/post/5b3b40a26fb9a04fab44e797)和[组织](https://medium.com/airbnb-engineering/building-a-cross-platform-mobile-team-3e1837b40a88)的问题，增加了许多项目的挫折和意外耽搁的时间。

#### 维护质量标准

最近，随着 React Native 越来越成熟，我们积累了更多专业知识，现在能够完成许多当初不确定的事情。我们构建了共享元素转换、滚动视差、并且能够显著地提高过去经常丢帧的一些屏幕的性能。然而，诸如初始化和异步优先渲染等一些[技术挑战](https://juejin.im/post/5b3b40a26fb9a04fab44e797)，满足某些目标具有挑战性。内部和外部缺乏资源使得这更加困难。 

#### 只编写一次代码而不是两次

尽管 React Native 功能中的代码几乎可以在不同平台共享，但我们的应用中也只有一小部分是 React Native。此外，为了让产品工程师能够有效地工作，还需要大量桥接基础架构。因此，我们在三个平台（而不是两个平台）上支持代码。我们看到了移动端和 Web 之间代码共享的潜力，并且能够共享一些 npm 包，但除此之外，它从未以有意义的方式实现。

#### 改善开发者体验

React Native 的开发人员经验非常不同。在某些方面，例如构建时间，情况要好得多。但是，在其他方面，比如调试，情况比较糟糕。本系列的[第 2 部分](https://juejin.im/post/5b3b40a26fb9a04fab44e797)列举了具体细节。

### 退役计划

由于无法实现我们的特定目标，因此我们做了一个艰难的决定 —— React Native 不再适合我们了。我们目前正在与团队合作制定健康的过渡计划。我们已经停止了所有新的 React Native 功能，并计划在今年年底之前，将大多数最高流量的视图页面转换为原生编写。这得到了一些即将开始的预定重新设计的帮助。我们的原生基础架构团队将支持到 2018 年的 React Native。在 2019 年，我们将开始降低支持并减少一些 React Native 开销，例如启动时的初始化运行时。

在 Airbnb，我们是开源软件的坚定信徒。我们积极使用和促进世界各地的许多开源项目，并且也开放了一些我们的 React Native工作。由于我们已经不再使用 React Native 了，我们无法像社区一样维护 React Native 的功能。为了让社区变得更好，我们将把一些 React Native 开源工作迁移到 [react-native-community](https://github.com/react-native-community)，我们已经开始使用 [react-native-maps](https://github.com/react-community/react-native-maps)，并即将使用 [native-navigation](https://github.com/airbnb/native-navigation) 和 [lottie-react-native](https://github.com/airbnb/lottie-react-native/)。 

### 这并不全是坏事

尽管无法继续通过 React Native 来实现我们的目标，但使用 React Native 的工程师都有不错的体验。在这些工程师中：

*   60% 的人认为他们的体验是令人惊讶的。
*   20% 的人认为还不错。
*   15% 的人认为比较糟糕。
*   5% 的人表现出强烈否定的态度。

如果有机会，63％ 的工程师会再次选择 React Native，74％ 的工程师会考虑将 React Native 用于新项目。但值得注意的是，这些结果中存在固有的选择偏倚，因为它只调查选择使用 React Native 的人。

这些工程师在 220 个页面上编写了 80,000 行产品代码以及 40,000 行 Javascript 基础结构。作为参考，我们在每个原生平台上分别有，大约 10 倍的代码量和 4 倍的页面数量。

### React Native 正在走向成熟

这一系列的博客真实反映出了，我们在现阶段使用 React Native 的经验。但是，Facebook 和更开放的 React Native 社区致力于适合混合应用的 React Native。React Native 正在以前所未有的速度向前发展。去年有超过 2500 个 commit，Facebook [刚刚宣布](https://facebook.github.io/react-native/blog/2018/06/14/state-of-react-native-2018)他们正在解决我们正面临的一些技术挑战。即使我们不再使用 React Native，我们也很高兴能够继续关注这些发展，因为 React Native 的技术优势为世界各地使用我们产品的人们，带来了实实在在的成功。

### 一些思考

我们将 React Native 集成到大型现有应用中，并持续以非常快的速度迭代。我们遇到的许多困难，都是由于采用了混合模型方法。但是，我们的规模能够承担并解决小公司可能没有时间解决的一些难题。想让 React Native 与原生无缝互相协作是有可能的，但很有挑战性。每个使用 React Native 的公司都会有一种由他们的团队组成、现有应用、产品需求和 React Native 成熟度确定的独特体验。

当一切齐头并进时，React Native 能匹配许多功能所做的工作、迭代速度、质量和开发人员的体验，甚至超越了我们的所有目标和期望。有时候，真的觉得我们即将改变移动开发的游戏规则。尽管这些经历令人备受鼓舞，但当我们将积极情绪与工程组织的痛点，以及当前的需求和资源相平衡时，我们认为它已不适合我们了。

决定是否使用新平台是一项重大的决策，这完全取决于你团队的独特因素。我们放弃使用的经历和原因，可能会不适用于你的团队。事实上，[许多](https://medium.com/@Pinterest_Engineering/supporting-react-native-at-pinterest-f8c2233f90e6)[公司](https://instagram-engineering.com/react-native-at-instagram-dd828a9a90c7)现今仍在继续成功使用它，对于其他公司来说，它可能仍然是多数公司的最佳选择。

虽然我们从未停止过使用原生，但 React Native 退役后可以腾出更多资源，使原生化比以往更好。请继续阅读本系列的[下一部分](https://medium.com/airbnb-engineering/whats-next-for-mobile-at-airbnb-5e71618576ab)，一起了解学习原生的新功能。

* * *

这是系列博客文章的第四部分，重点讲述了我们使用 React Native 的经验，以及 Airbnb 移动端接下来要做的事情。

*   [第一部分：Airbnb 中的 React Native](https://juejin.im/post/5b2c924ff265da59a401f050)
*   [第二部分：技术细节](https://juejin.im/post/5b3b40a26fb9a04fab44e797)
*   [第三部分：构建跨平台的移动端团队](https://github.com/xitu/gold-miner/blob/master/TODO1/sunsetting-react-native.md)
*   [**第四部分：在 React Native 上作出的决策**](https://github.com/xitu/gold-miner/blob/master/TODO1/sunsetting-react-native.md)
*   [第五部分：移动端接下来的事情](https://github.com/xitu/gold-miner/blob/master/TODO1/whats-next-for-mobile-at-airbnb.md)

在此感谢 [Laura Kelly](https://medium.com/@laura.kelly_61928?source=post_page)。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
