> * 原文地址：[Why TypeScript Is Growing More Popular](https://thenewstack.io/typescript-getting-popular/)
> * 原文作者：[Mary Branscombe](https://thenewstack.io/author/marybranscombe/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者：[loveky](https://github.com/loveky)
> * 校对者：[Aladdin-ADD](https://github.com/Aladdin-ADD)  [Germxu](https://github.com/Germxu)

# 为何 TypeScript 愈发流行了？ #

![](https://cdn.thenewstack.io/media/2017/04/2fd01361-unnamed-1024x876.jpg)

为何 [TypeScript](https://www.typescriptlang.org/) 这么流行呢？许多主流的开发框架依赖于它，它还能提高开发者在不断变化的 JavaScript 世界中的生产力。

在最近的 [Stack Overflow 开发者调查](https://stackoverflow.com/insights/survey/2017#technology)以及年度 [RedMonk](http://redmonk.com) 编程[语言排名](https://redmonk.com/sogrady/2017/03/17/language-rankings-1-17/)中都显示 [TypeScript](https://www.thenewstack.io/tag/TypeScript) —— 由微软发起的结合了编译高级 JavaScript 特性与静态类型检查及工具的开源项目 —— 正在达到新的人气高度。通过为 JavaScript 提供[最基本的检查语法](https://medium.com/@tomdale/glimmer-js-whats-the-deal-with-typescript-f666d1a3aad0)，TypeScript 允许开发者对他们的代码进行类型检查，这可以[暴露 bug 并改善大型 JavaScript 代码库的结构和文档]((https://slack.engineering/typescript-at-slack-a81307fa288d))。

参与了 Stack Overflow 调查的开发者中有 9.5% 的人正在使用 TypeScript，这使得 TypeScript 成为了第九流行的编程语言，排名在 Ruby 之前，用户量是 Perl 的两倍。此次 Stack Overflow 调查中的受访者来自不同领域，使用最广泛的两种语言是 JavaScript 和 SQL，这说明此次调查并非只针对前端开发。事实上，TypeScript 程序员出现在了参与 Stack Overflow 调查的所有 4 种工作角色中：web 开发者、桌面开发者、系统管理员与 DevOps 以及数据科学家。

RedMonk 的排名将 Stack Overflow 的数据与 GitHub 上的 pull request 结合起来试图理解开发者的想法以及他们正在使用什么。TypeScript 同样受到了开发者的欢迎，排名从第 26 位上升到了第 17 位。其中一部分原因是 TypeScript 在 Stack Overflow 上关注度的提升，但主要还是因为在 GitHub 上参与的开发者在不断增多。

的确，GitHub 在其 2016 [年度总结](https://octoverse.github.com/)中把 TypeScript 列为在 GitHub 上用于项目开发的 316 种编程语言中最受欢迎榜单的第 15 位（基于 pull request 的数量以及相较与前一年 pull request 250% 的增长率）。

在另一个针对开发者的调查中，TypeScript 在众多 JavaScript 的『替代』[风格](http://stateofjs.com/2016/flavors/)中拥有最高的使用率（21%）以及尚未的用户中最高的关注度（39%）。这项调查的方式不同寻常 —— 它很奇怪地将转译器和包管理器（如 [npm](https://www.npmjs.com/) 和 [Bower](https://bower.io/)）混合在一起 —— 但参与了这项调查且经常使用 TypeScript 的开发者也经常使用 [ECMAScript 2015](http://www.ecma-international.org/ecma-262/6.0/)、[NativeScript](https://www.nativescript.org/)、[Angular](https://angular.io/)，尤其是 Angular2。

来自 RedMonk 的 [Stephen O’Grady](http://redmonk.com/team/stephen-ogrady/) 指出『似乎有理由相信 Angular』在 TypeScript 的日益普及中发挥了作用。虽然 Angular2 只是众多使用了 TypeScript 的项目中的一个（Asana 和 Dojo 已经在使用了，Adobe、Google、Palantir、SitePen 以及 eBay 的一些内部项目也是一样），但最为人们所熟知的恐怕还是像 [Rob Wormald](https://twitter.com/robwormald) 这样的 Google 员工在宣传 Angular 时顺带推广了 TypeScript。

## 不止是 Angular2 ##

『毫无疑问，我们与 Angular 团队的合作有助于 TypeScript 的推广』，TypeScript 核心成员 [Anders Hejlsberg ](https://twitter.com/ahejlsberg?lang=en) 向 New Stack 说到。『但即便如此，我认为真正重要的点在于这是一次代表了行业力量重大信心的信任投票。』

他指出，这种信任投票带来的影响不仅仅在于 Angular。『目前，许多其它框架也在使用 TypeScript。[Aurelia](http://aurelia.io/)、[Ionic](https://ionicframework.com/)、NativeScript都以某种方式使用了 TypeScript。[Ember](https://www.emberjs.com/) 框架与 [Glimmer](https://github.com/glimmerjs) 框架的最新发布版本就是使用 TypeScript 编写的。』

> 『我们看到许多来自在这个行业经验丰富的人的信任投票。我想这可能是每个在大公司的人都会注意到的』—— Anders Hejlsberg

这种信任投票也给框架的使用者带来了机会。『我们做了很多努力以成为 [React 生态](https://facebook.github.io/react/)中的重要一员。我们支持 [JSX](https://jsx.github.io/)，支持所有你在重构或是浏览 JSX 代码时想要用到的类型系统的高级特性。我们还正在和 [Vue.js](https://vuejs.org/) 社区合作以更好的支持这个框架中用到的各种模式。』 Hejlsberg说到。

为新框架提供支持是在开发者中保持流行度的一项重要手段。『我们一直都在关注框架领域。我们知道这是一个不断变化的生态系统。它在不断变化，你必须时刻准备着并保证一切都能正常工作。』

对于工具链来说也是如此，尤其是在 ECMAScript 模块愈发流行的情况下。『许多人使用模块编写现代风格的 JavaScript 应用，当你使用 ECMAScript 6 模块的时候，你需要使用一个类似 [Webpack](https://webpack.github.io/) 或 [Rollup.js](https://rollupjs.org/) 这样的打包工具将代码打包起来以便能在浏览器中运行。我们要确保 TypeScript 可以与这些工具配合使用以保证我们可以融入整个工具链之中』 Hejlsberg说到。

[![](https://cdn.thenewstack.io/media/2017/04/940acc19-stateofthenation.png)](http://vmob.me/DE1Q17)

React 是由 Facebook 发起的库。Angular 是从 Google 衍生出来的框架。有很多分析把它们做了比较。总的来说，Angular 处于领跑地位，与此同时 Vue.js 正在受到大量关注。Angular 在 TypeScript 的用户圈中受到追捧，41% 的人倾向于 2.x 版本，另外 18% 的人则更喜欢老版本。随着近期 Angular 4 的发布以及 TypeScript 的日益流行，我们预计 JavaScript 的战争还将持续下去（Lawrence Hecht）。

拥有 TypeScript 类型定义的库的数量也在稳步增长。[DefinitelyTyped](http://definitelytyped.org/)，一个维护 TypeScript 类型定义的仓库，现在已经包含了超过 3000 个框架和库。通过把声明文件作为 npm 包发布在 @type 命名空间下，这个过程被大大提速了。

『这意味着现在有了一个可以预测哪些框架支持类型的方法 —— 我们可以自动提供这些类型。当我们发现你引用了某个特定的框架时，我们就可以帮你找到类型定义，你就不必亲自去寻找了。』事实上，Hejlsberg 声称：『对某些开发者来说，某个框架是否拥有类型定义，已经成为了他们在选择框架时的决定性因素。』

>『通常，TypeScript 被采用的流程 —— 不论是企业，创业团队还是个人开发者 —— 是你在某个项目中尝试使用并发现它很棒，接着你就开始推荐给别人。就这样，它就在你的影响范围内传播开了。』—— Anders Hejlsberg

关注度的提高似乎是用户增长的原因之一。『我们没做过任何推广，所有这些都是社区驱动的。实际上是在稳步增长，我们现在开始注意到增长速度更快了。』Hejlsberg 说道。

Hejlsberg 指出 TypeScript 还是在 Stack Overflow 的调查中排在 Rust 和 Smalltalk 之后第三受欢迎的语言（排在 Swift 和 go 之前）以及第六急需人才的语言，排在 C# 和 Swift 之前。『我认为这从很大程度上说明我们真的解决了实际问题』Hejlsberg 指出。


## 微软的影响范围 ##

人们很容易把 TypeScript 的成功视为微软通过熟悉的工具把已经在微软世界中的企业开发者引入 JavaScript 的结果。

『我们有一个围绕着 C#、C++ 以及 Visual Basic 的大型开发者生态系统。许多企业在使用微软的工具同时也有前端开发的需求，当我们开始改善前端开发的时候，他们就坐下来，关注并开始使用了。』Hejlsberg坦言。

但是，虽然很多 TypeScript 的开发工作是在 [Visual Studio](https://www.visualstudio.com/) 中进行的，和使用 [Visual Studio Code](https://code.visualstudio.com/) —— 微软开源的，跨平台的 IDE —— 的一样多。『那是一个和我们没有太多联系的社区。以 Visual Studio Code 来说，一半的用户来自非 Windows 系统，因此突然间我们就与一个之前没什么交流的开发者社区建立了联系。』

## 开源快车道 ##

TypeScript 团队最近宣布发布频率将由每季度改为每两个月，Heljsberg 呼吁让发布日期更加可预测，而不是为了添加某个新功能而延迟发布。这也正是 ECMAScript 委员会正在采取的做法。

新的发布节奏也会与 Visual Studio Code 保持一致，部分原因是因为 Visual Studio Code 是由 TypeScript 开发的，但更重要的原因在于工具是 TypeScript 吸引力的重要组成部分。

尽管 TypeScript 支持多种编辑器与 IDE 很重要，但 Hejlsberg 指出 Visual Studio Code 是另一个帮助该语言普及的因素。

事实上，即便只是开发 JavaScript，你也能从 TypeScript 获得更好的编码特性，他解释道。『Visual Studio Code 和 Visual Studio 都使用 TypeScript 语言服务作为它们的 JavaScript 语言服务。由于 TypeScript 是 JavaScript 的超集，这意味着 JavaScript 是 TypeScript 的一个子集，它只是没有类型注释的 TypeScript 罢了。』他指出。

在 Visual Studio Code中，打开一个 JavaScript 文件会触发 TypeScript 的解析器、扫描器、词法分析器和类型分析器以提供 JavaScript 代码中的语句补全和代码导航功能。『即使没有类型注释，我们也可以通过你使用的模块以及声明的类来推断出关于项目结构的很多信息』Hejlsberg 说道。『令人惊奇的是，我们可以自动为你引用的框架导入类型信息，然后就可以为你提供出色的语句补全功能。』

使这样的快速发布节奏成为可能的是所有 pull request 被合并前必须通过测试，这保证了 master 分支的代码质量和 TypeScript 的流行，意味着任何问题都可以被快速发现。

『我们是一个开源项目，我们在 GitHub 上做了很多工作。除非能通过我们现有的 55000 个测试，否则我们绝不合并任何 pull request；如果是增加新功能，就必须提供相应的测试代码；如果是修改 bug，就必须提供回归测试。这意味着我们的 master 分支始终保持着很高的代码质量。』他说道。

## JavaScript: 强大但复杂 ##

除了任何一个单一因素以外，驱使 TypeScript 愈发流行的真实原因可能是现如今 JavaScript 开发越来越高的复杂性以及越来越强大的能力。

『我们的行业和 JavaScript 的使用都发生了巨大的变化。』 Hejlsberg指出。『以前我们生活在一个同质的世界。所有人都使用 Windows 和浏览器，这就是你如何使用 JavaScript 的。现在世界已经变得非常多元化。有各种不同的设备 —— 手机和平板电脑，还在后端使用 node 运行 JavaScript。JavaScript 还挣脱了浏览器，通过使用 NativeScript、React Native 或是 Cordova 你已经可以使用 JavaScript 构建原生应用。』

『是的，它变得更复杂，但也有着无限多的能力。』 Hejlsberg 谈到 JavaScript 时说道。『利用 JavaScript，你可以使用同一种语言和工具开发出如此多种类的应用。对我而言，这正是推动所有这一切的原因：你可以开发不同类型应用的多样性以及你能从这个不断进化的生态系统中获得的可重用性。它不仅仅变得更复杂了，也更强大了。』

**TNS 分析员 [Lawrence Hecht](https://thenewstack.io/author/lawrence-hecht/) 为此份报告的撰写提供了帮助。**



---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
