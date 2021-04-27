> - 原文地址：[React vs. Vue in 2021: Best JavaScript Framework](https://dzone.com/articles/react-vs-vue-in-2021-best-javascript-framework)
> - 原文作者：[Elizabeth Lvova](https://dzone.com/users/4453916/elizabethlvova.html)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/react-vs-vue-in-2021-best-javascript-framework](https://github.com/xitu/gold-miner/blob/master/article/2021/react-vs-vue-in-2021-best-javascript-framework.md)
> - 译者：[keepmovingljzy](https://github.com/keepmovingljzy)
> - 校对者：[Chorer](https://github.com/Chorer)、[霜羽 Hoarfroster](https://github.com/PassionPenguin)

# React vs. Vue 谁是 2021 年最佳 JavaScript 框架

我们整理了这个便利的指南，以帮助您更好地理解 Vue 和 React 的使用场景，并确定哪种框架最适合您的下一个项目。

因为 JavaScript 框架对 web app 开发至关重要，许多公司一直在纠结于项目中使用 React 还是 Vue。简短的答案是，没有谁明显胜出。每个框架都有其优缺点，分别适用于不同的应用程序。因此，我们整理了这个便利的指南，以帮助您更好地理解 Vue 和 React 的使用场景，并确定哪种框架最适合您的下一个项目。

## Vue.js vs. React —— 它们是什么？

React 和 Vue 都是开源的 JavaScript 框架，可以让开发者更容易、更快捷地构建复杂的用户界面。在对 React 和 Vue 进行比较之前，我们先对各自进行简要的概述。

React 框架通过使用 ‘组件’ 提供更多的灵活性，只需一小段独立的代码，开发就可以使用它来创建更复杂的逻辑和界面。React 通过“虚拟 DOM”（真实 DOM 的副本）与 HTML 文档交互，但是所有元素都表示为 JavaScript 对象。这些元素，加上 React 的声明式编程风格和单向数据绑定，简化并加速了开发。

Vue 也提供了双向绑定和组件，并使用了虚拟 DOM。然而，Vue 的主要吸引力在于它的渐进式设计。Vue 旨在允许开发者逐步迁移现有项目到框架中，一个接一个的迁移特性，而不是一次性全部迁移。因此，根据你的项目需求，您可以将 Vue 作为一个完整的框架或者轻量级库，或者介于两者之间。

## 相同点

如你所见，Vue 和 React 在许多特性和功能都非常相似，最大的相似点是使用虚拟 DOM。

除此之外，React 和 Vue 还有如下相似点：

- 与任何现有 web app 协同工作。
- 为开发人员提供一种轻量级的方法，让他们能够快速完成工作。
- 提供具有生命周期方法的基于组件的体系架构。
- 提供更好的灵活性、速度和性能。
- 拥有庞大而活跃的社区。
- 提供广泛的库和工具。

## 不同点

尽管 React.js 和 Vue.js 有许多相似之处，但两者之间还是有一些区别，这对各自最适用于什么场景产生了重大影响。 二者的主要区别在于将内容渲染到到 DOM 的方法。Vue 使用 HTML 模板和 JSX，而 React 仅使用 JSX，这实际上是一个扩展，允许您将 HTML 直接插入到 JS 代码中。 尽管 JSX 可以加快开发并简化更大、更复杂的任务，但缺点是它也可能使本来应该容易的任务变得复杂。

此外，React 的核心是提供组件，DOM 操作和组件状态管理。其他一切都是由社区开发者支持的。虽然经验丰富的开发人员通常更喜欢这种自由度，但是新手可能会因大量的第三方库和工具而感到不知所措。

虽然 Vue 拥有广泛的社区构建方案可供选择，但其核心团队同样也构建并支持了常用工具和配套库，如 Vue-router、Vuex 和 Vue CLI。这种预构建资源和第三方资源的结合有助于满足初学者和高级开发人员的需求和愿望。

## Vue vs. React 性能

由于 React 和 Vue 有许多相似点，所以它们的总体性能大致相当。这两个框架都使用虚拟 DOM 和懒加载来提高性能和页面加载速度。

然而，在某些情况下，一个框架的性能明显优于另一个。例如，当你修改一个 React 组件的状态时，它的子树中的所有组件都将重新渲染。但在 Vue 中，会跟踪依赖项以防止不必要的重新渲染。虽然您可以使用不可变的数据结构、shouldComponentUpdate 或 PureComponent 来防止在 React 中重新渲染子组件，但这会增加额外的复杂性并导致 DOM 状态不一致。

### 1. 应用架构

React 与其他框架和库不同，因为它没有内置的架构模式。它使用基于组件的架构，有优点也有缺点。React UI 通过函数形式的组件渲染，并响应数据的更改。因此，内部架构由组件状态和用户操作之间的持续交互组成。

Vue 关注的是 MVVM 模式的 ViewModel 方法，这可以很好地应用于更大的应用程序。它使用双向数据绑定来连接视图和模型。Vue 的主要目标是提供一个简单、灵活的视图层，而不是一个成熟的框架。

### 2. 可扩展性

在考虑将 React 与 Vue 用于大型应用程序时，React 具有易扩展性，因此具有优势。由于 React 应用程序仅使用 JavaScript，因此开发人员可以利用传统的代码组织方式轻松地进行扩展。组件的可重用性增强了 React 的可扩展性。

尽管 Vue 也具有可扩展性，但由于其广泛的灵活工具选择，它更常用于较小的应用程序中（尽管应用程序的大小取决于架构）。由于采用了动态架构，因此您将需要利用 Vue 的库和 Mixin 元素来克服扩展限制。因此，如果您正在考虑使用React 还是 Vue 作为企业应用程序，React 可能会更适应未来的增长。

### 3. 文档

在文档方面，Vue 显然是赢家。Vue 的网站以卓越的质量，高度详细的描述，多语言支持，它的文档和 API 引用普遍被认为是业界最好的。您可以在文档中找到许多问题和详细的答案。但是，由于 Vue 社区不像 React 社区那么大，所以您可能很难找到文档中未涉及问题的正确答案。

React 的文档远远达不到 Vue 的水平，所以您需要更多地求助于社区去解决挑战和问题。好在 React 拥有一个庞大而活跃的社区，拥有大量可供选择的学习材料。

### 4. 社区支持

这就引出了 React 和 Vue 社区支持的话题。这是任何技术的重要组成部分，因为社区为新开发人员和有经验的开发人员提供帮助，并创建第三方解决方案和工具。

React 是由 Facebook 开发和维护的，而且 Facebook 也在自己的应用程序中使用它。因此，它拥有大量持续的支持和一个不断构建和维护新工具的活跃社区。

Vue 是由开发人员创建的，而不是一家公司，所以它没有像 React 那样迅速受到欢迎。事实上，当它第一次发布时，许多开发人员都觉得它不可靠，并犹豫是否要使用它。然而，由于用户社区的持续支持和贡献，Vue 已经有了实质性的增长并且越来越受欢迎。

### 5. 人气

毫无疑问，Vue 拥有 181K Github Star，是最受欢迎的 JavaScript 框架。但是，React 凭借 16.5 万 Star 升至第二位，并且继续增长并获得新用户。许多知名公司都有使用 Vue.js 和 React 制作的 Web 应用程序。

**Vue** 用户包括：

- Gitlab
- Euronews
- Adobe Portfolio
- Behance
- Alibaba
- Trustpilot
- Vice
- Nintendo
- BMW

**React** 用户包括：

- BBC
- Airbnb
- Facebook
- PayPal
- The New York Times
- Netflix
- Instagram
- Twitter
- WhatsApp

### 6. 安全性

Vue 和 React 都有自己的安全隐患，但是，Vue 应用程序比基于 React 的应用程序更容易获得安全保护。虽然无法针对XSS 漏洞等启用自动保护功能，但 Vue 开发人员可以在实施之前对 HTML 代码进行清理或使用外部库来帮助防御攻击。 只要您知道 HTML 是安全的，则可以在渲染前后明确渲染 HTML 内容并保护应用程序。

React 安全依靠开发人员使用安全最佳实践来防御 XSS 漏洞、服务器端渲染攻击、SQL 注入和其他威胁。这可能包括诸如使用 serialize-Javascript 模块，利用脚本注入漏洞以及使用安全的 React Native 应用程序之类的东西。因此，尽管 React 易于使用，但需要大量的专业知识和经验来确保 React 应用程序是安全的。

### 7. React vs. Vue 就业市场

React 的受欢迎程度意味着有大量的经验丰富的开发人员可供雇用。根据 2019 年前端工具调查，超过 48％ 的开发人员对使用 React 感到自在，而只有 23％ 的开发人员声称可以使用 Vue 获得舒适的开发体验。

但是，HackerRank 的开发人员技能报告发现，虽然 33.2％ 的公司希望雇用 React 开发人员，但只有 19％ 的开发人员具备所需的技能。虽然 10％ 的公司需要 Vue 开发人员，但只有 5.1％ 的开发人员合格。

Vue 人气持续增加，并在 2020 年开发人员想要学习的技术排名中位列第四。这种受欢迎程度的增长，加上 Vue 出色的文档和易于学习的知识，很可能会使得合格的 Vue 开发人员增加。

## 总结

总而言之，React 获得了更多的企业支持，在开发人员中更受欢迎，并拥有一个庞大的社区，可以回答您可能有的任何问题。它也更容易扩展，通常是复杂的企业级应用程序的首选。

另一方面，尽管 Vue 还没有得到广泛的支持和使用，但它的普及程度正在不断提高，这主要是因为它出色的文档、易用性和增量使用功能。Vue 还提供了更多的核心支持以及更广泛的内置工具和解决方案。当考虑 React 与 Vue 的开发速度时，使用 Vue CLI 4，只需几周时间就可以打造并交付一个符合市场需求的产品。

显然，这两种框架都是现代 web 应用程序的优秀框架，React 与 Vue 的优缺点根据使用场景而有所不同。到底使用哪一个，完全取决于您的项目目标和偏好。

**React** 是更好的选择如果您想要：

- 拥有多种灵活的库、工具和生态系统。
- 轻松地搭配 TypeScript、Flow、ReasonML、BuckleScript 使用。
- 开发一个易于测试和调试的高扩展性应用程序。
- 快速构建一个复杂的应用程序。
- 创建一个高性能的视频流媒体平台或媒体网站。

选择 **Vue** 当你想：

- 构建一个渐进式 web app 或 SPA。
- 立即开始开发。
- 获得更多的核心工具和支持。
- 扩展现有 app 的功能。

我们希望这个指南能帮助你决定在下一个项目中使用 React.js 还是 Vue.js。如果你还有关于技术的问题，或者你需要一个有经验的开发团队来帮助创建你的项目，请使用下面的表单给我们发送消息！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

------

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
