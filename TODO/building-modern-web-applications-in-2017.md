
> * 原文地址：[Choosing a frontend framework in 2017](https://medium.com/this-dot-labs/building-modern-web-applications-in-2017-791d2ef2e341)
> * 原文作者：[Taras Mankovski](https://medium.com/@tarasm)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/building-modern-web-applications-in-2017.md](https://github.com/xitu/gold-miner/blob/master/TODO/building-modern-web-applications-in-2017.md)
> * 译者：[LeviDing](https://github.com/leviding)
> * 校对者：[sunui](https://github.com/sunui), [warcryDoggie](https://github.com/warcryDoggie)

# 2017 年了，这么多前端框架，你会怎样选择？

![](https://cdn-images-1.medium.com/max/800/1*T551HACMn9A95dnwpPK-eQ.png)

图片来源: [Ember.js: 解决你框架疲劳的良药](http://brewhouse.io/blog/2015/05/13/emberjs-an-antidote-to-your-hype-fatigue.html)

过去七年来，前端框架生态系统发展蓬勃。我们已经学了很多关于构建和维护大型应用的知识。我们看到了很多新想法的出现。其中一些新想法改变了我们构建 Web 应用的方式，而其他想法被废弃，因为它们起不到什么作用。

在这个过程中，我们看到很多炒作和冲突的观点，选择一个框架变得困难重重。当您为长期维护一个应用的组织挑选框架时，更是难上加难。

在本文中，我想描述我们对如何构建现代 Web 应用的理解的演变，并提出一种如何在多种技术中进行选择的方法。

在开始前，我想先回顾一下，回到第一个使构建网络应用更像编程的库。 Backbone.js 于 2010 年 10 月发布，2013 年 3 月达到 1.0 版本。它是第一个广泛使用的采用模型与视图之间相分离的 JavaScript 库。

![](https://cdn-images-1.medium.com/max/800/1*vqOV_K_r66lUwdFeABCWEQ@2x.png)

图片来源：Angular Model 和 View 之间的关系 —— [http://backbonejs.org](http://backbonejs.org)
Backbone.js 的 Model 表示数据和业务逻辑。它们触发视图层的变化。当改变事件触发的时候，显示模型数据的视图负责将该更改应用于 DOM。Backbone 并不知道您首选 HTML 模板的方法，需要开发者自行编写 render 函数解决如何更新 View 到 DOM。

在 Backbone 1.0 诞生的时候，Angular.js 被发布并开始普及。它不像 Backbone 那样侧重于模型，而是侧重于使视图做的更好。

Angular.js 采用了编译模型以使 HTML 动态化的想法。它允许使用指令将行为注入到 HTML 元素中。您可以将模型与视图进行绑定，并且当模板改变的时候，视图会自动更新。

Angular.js 的流行度迅速增长，因为你很容易将 Angular.js 添加到任何项目中，并且上手简单。许多开发人员被 Angular.js 所吸引，因为它是由 Google 开发的，这赋予 Angular.js 天生的可靠度。

大约在同一时间，Web 组件规范承诺使开发人员可以创建与其上下文分离的，并且易于与其他组件进行组合的可重用组件。

[Web Components 规范](https://www.w3.org/standards/history/components-intro)是由四个独立的规范组合而成的。

- HTML 模板 — 为组件提供 HTML 标记
- 自定义元素 — 提供了一种创建自定义 HTML 元素的机制
- Shadow DOM — 将组件的内部与渲染它的上下文隔进行离
- HTML 导入 — 使将 Web 组件加载到页面中成为可能

Google 的一个团队创建了一个补丁库，为当时所有浏览器提供 Web Components 支持。这个库被称为 Polymer，并于 2013 年 11 月开源。

Polymer 是第一个使通过组合组件构建交互式应用成为可能的库。早期使用者受益于可组合性，但发现性能问题还是需要用框架来解决。

同时，一小群开发人员受到 Ruby on Rails 思想的启发，希望创建一个基于约定的社区驱动的开源框架来构建大型 Web 应用。

他们开始基于 SproutCore 2.0 进行开发。SproutCore 2.0 是一个基于 MVC 的框架，在模型、控制器和视图之间有明显的分隔。这个新框架叫做 Ember.js。

创建基于约定的框架的第一个挑战是找到大型 Web 应用的通用模式。 Ember.js 团队查看了大型 Backbone 应用，以找到相似之处。

他们发现应用的某些部分是一致的，而其他部分会有些改动。在这种地方就需要嵌套视图。

他们还将 URL 视为 Web 应用架构中的关键角色。他们结合了嵌套视图的想法和 URL 的重要性，创建一个路由系统，作为入口点进入应用并控制初始视图呈现。

![](https://cdn-images-1.medium.com/max/800/1*rx9bWvoWTaEJSY8qAuuh4A.png)

Ember.js 的元素 —— 原文 [Ember JS 深入介绍](https://www.smashingmagazine.com/2013/11/an-in-depth-introduction-to-ember-js/)

Ember 社区在 Ember.js 核心团队的领导下，于 2013 年 8 月发布了 Ember.js 1.0。它具有 MVC 架构，强大的路由系统和可编译模板的组件。像 Angular.js 和 Polymer 一样，Ember.js 主要依靠双向绑定来保持视图与状态同步。

在 2014 年的年中，一个新的库开始引起开发者的注意。Facebook 为他们的平台创建了一个框架，并以 “React” 的命名发布。

在其他的框架都依赖于对象突变和属性绑定的时候，React 引入了将诸如纯函数和组件参数之类的组件作为函数参数来处理的想法。

![](https://cdn-images-1.medium.com/max/800/1*sUeInQGMBhFVqW-rHj1JZg.png)

组件是返回 DOM 的函数 —— 原文 [https://facebook.github.io/react/docs/components-and-props.html#functional-and-class-components](https://facebook.github.io/react/docs/components-and-props.html#functional-and-class-components)

当一个参数的值改变时，组件的 `render` 函数被调用并返回一个新的组件树。 React 将返回的组件树与虚拟 DOM 树进行比较，以确定如何更新真实的DOM。这种重新渲染所有内容并将结果与虚拟 DOM 进行比较的技术经实践证明是非常有效的。

![](https://cdn-images-1.medium.com/max/800/1*cV-klTo3DKl0Uo2Znk3V6g.png)

原文: [React.js Reconciliation](https://www.infoq.com/presentations/react-reconciliation)

Angular.js 开发人员面临着 Angular.js 变更检测机制引发的性能问题。Ember 社区正在学习如何解决维护依赖于双向绑定和观察者模式的大型应用的挑战。

React 主攻的是 Polymer 所未能解决的问题。React 显示了如何提高组件架构的性能。 React 在基准测试中打败了 Ember 和 Angular.js。一些较有尝试新技术精神的 Backbone 开发人员将 React 作为视图添加到其应用中，以解决他们遇到的性能问题。

为了应对 React 的威胁，Ember 核心团队制定了一项计划，将 React 提出的想法纳入 Ember 框架。他们认识到需要提升向后兼容性，并创建了一个版本升级的途径，允许现有应用升级到包含新 的 React-inspired 渲染引擎的 Ember 版本。

在 4 个次要版本的更新过程中，Ember.js 已弃用 Views，将社区迁移到基于 CLI 的构建过程，并将基于组件的架构作为 Ember 应用开发的基础。逐渐对框架进行重要的重构的过程被称为“稳定无停滞”，成为 Ember 社区的基本宗旨。

当 Ember 正在向 React 学习时，React 社区正在采用由 Ember 推广的路由。 大型 React 应用是使用 [React Router](https://github.com/ReactTraining/react-router) 编写的，该路由器是从用于 Ember 路由的 [router.js](https://github.com/tildeio/router.js/) 分支发展而来的。

Ember 对我们构建现代 Web 应用最大的贡献之一是他们在使用命令行工具作为构建和部署 Web 应用的默认界面上的领导力和普及。此工具称为 EmberCLI。它启发了 React 的 [create-react-app](https://github.com/facebookincubator/create-react-app) 和 [AngularCLI](https://github.com/angular/angular-cli)。现在的每个 Web 框架都提供了一个命令行工具来简化 Web 应用的开发。

在 2015 年上半年，Angular.js 的核心团队得出结论，他们的框架正在进入一个进化的死胡同。Google 需要一个开发人员可以用来构建强大的应用的工具，而 Angular.js 不能成为这个工具。他们开始研究一个新的框架，这将是 Angular.js 的精神继承者。 Angular.js 是在谷歌不是很支持的情况下流行起来的，而这个新框架则与 Angular.js 不同，得到了 Google 的全力支持。Google 分出了超过 30 多位开发人员，来开发这个被称为 Angular.js 精神继承者的框架。

新框架的范围远远大于 Angular.js。Angular 团队将新框架称为平台，因为他们计划提供专业开发人员构建 Web 应用所需的一切。像 Ember 和 React 一样，Angular 使用基于组件的架构，但它是使 TypeScript 成为其默认编程语言的第一个框架。

![](https://cdn-images-1.medium.com/max/800/1*c4T4WMmvhkQ4yc24dfzgMA.png)

具有 TypeScript 的 Angular 组件 —— [https://github.com/johnpapa/angular-tour-of-heroes/blob/master/src/app/heroes.component.ts](https://github.com/johnpapa/angular-tour-of-heroes/blob/master/src/app/heroes.component.ts)
TypeScript 提供类、模块和接口。它支持可选的静态类型检查，它对 Java 和 C＃ 的开发人员来说是一个非常棒的语言。具有 Visual Studio Code 编辑器对 TypeScript 代码提供了很棒的智能支持功能。

![](https://cdn-images-1.medium.com/max/800/1*m6CUCh3LRpJNHV2axqtkAQ.png)

对 Angular Apps 的智能支持 —— 原文：[http://rafaelaudy.github.io/simple-angular-2-app/](http://rafaelaudy.github.io/simple-angular-2-app/)

Angular 是高度结构化和以公共标准为基础的，然而仍然存在配置机制的问题。它有一个强大的路由器。Angular 团队正在努力为 Google 开发人员从专业开发环境的角度提供一个全新的框架。对完整性的关注对整个 Angular 社区都非常有好处。

在 2017 年 5 月，Polymer 2.0 改进了绑定系统，减少了对 `heavy polyfills` 的依赖，并与最新的 JavaScript 标准保持一致。新版本引入了一些突破性变化，并为用户升级到新版本提供了详细的计划。新的 Polymer 配备了一个命令行工具来帮助构建和部署 Polymer 项目。

截至 2017 年 6 月，所有顶级框架都将组件架构作为开发范例。每个框架都提供路由作为将应用分解为逻辑块的一种手段。所有框架都可以使用像 Redux 这样的状态管理技术。React、Ember 和 Angular 都允许服务器端渲染 SEO 和快速初始启动。

那么你怎么知道用什么工具来构建一个现代的 Web 应用呢？我建议你看看各个组织的人口统计数据，以确定哪个框架最适合。

React 是一个类似于一大张拼图中的一块的库。React 提供一个轻量级的视图层，并将其留给开发人员选择其余的架构。盒子里没有任何东西，所以你的团队可以完全控制你使用的一切。如果你有一个经验丰富的 JavaScript 开发人员团队，他们对于功能编程和不可变数据结构都很满意，那么 React 是一个不错的选择 React 社区在使用 Web 技术方面处于创新的前沿。如果你的组织需要使用相同的代码库来跨平台，那么你应该知道 React 允许你使用 React Native 编写本地的 Web，使用 ReactVR 编写 VR 设备。

Angular 是一个非常适合有 Java 或 C＃ 背景的企业开发人员的平台。TypeScript 和 Intellisense 的支持将使这些开发人员感觉到非常熟悉。虽然 Angular 是新的，但它已经有很多第三方组件库了，公司可以立即购买并立即开始使用。Angular 团队承诺要快速迭代框架，使之更好，且不会再次破坏向后兼容性。Angular 可用于使用 NativeScript 构建高性能原生应用。

Ember.js 是一个优化小团队和技能水平较高的独立开发者的生产力框架。其对配置上的约定，为新开发人员和组织长期维护大型项目提供了极好的起点。承诺的“稳定无停滞”已被证明是维护大型应用的有效方法，而不需要在最佳实践改变时进行重写。稳定性、成熟度和致力于创造共享代码，促生了一个生态系统，这个生态系统使得大多数开发的简易程度让人惊讶。如果您正在寻找一个长期项目的可靠框架，Ember 是一个很好的选择。

Polymer 是一个对于希望创建单一样式指南，和要在整个组织中使用的组件集合的大型组织而言特别适合的框架。该框架提供可比较的开发工具。如果你想将一些现代化的功能应用在你的程序上，而不需要编写大量 JavaScript，那么 Polymer 是你们很不错的选择。

我们正在了解如何为浏览器构建应用，并汇集好的想法。 所有框架的制作者都非常关心使用他们的库的人。 问题是哪个社区和生态系统是你的组织和用例的最佳选择。

我希望这篇文章有助于揭示现代网络生态系统的发展，并帮助您构建下一代现代 Web 应用。

在评论区留下你的看法吧。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
