> * 原文地址：[5 Tools for Faster Development in React](https://blog.bitsrc.io/5-tools-for-faster-development-in-react-676f134050f2)
> * 原文作者：[Jonathan Saring](https://blog.bitsrc.io/@JonathanSaring?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/5-tools-for-faster-development-in-react.md](https://github.com/xitu/gold-miner/blob/master/TODO1/5-tools-for-faster-development-in-react.md)
> * 译者：[Ivocin](https://github.com/Ivocin)
> * 校对者：[Haoze Xu](https://github.com/ElizurHz), [Junkai Liu](https://github.com/Moonliujk)

# 5 款工具助力 React 快速开发

**本文将会介绍 5 款工具，可加速 React UI 组件和应用程序的开发工作。**

React 非常适合快速开发具有出色的交互式 UI 的应用程序。React 组件是创建用于开发不同应用的隔离的、可复用的模块的很棒的方法。。

虽然一些[最佳实践](https://blog.bitsrc.io/how-to-write-better-code-in-react-best-practices-b8ca87d462b0)有助于开发更好的应用程序，但正确的工具可以使开发过程更快。以下是 5（+）个实用的工具，可以帮助我们加速组件和应用程序的开发。

欢迎你发表评论并提出建议。

### 1. [Bit](https://bitsrc.io)

- [**Bit —— 分享和构建组件代码**：Bit 帮助你在不同的项目和应用程序中共享、发现和使用代码组件，以构建新功能和 ... ](https://bitsrc.io "https://bitsrc.io")

[Bit](https://bitsrc.io) 是一个开源平台，用于使用组件构建应用程序。

使用 Bit，你可以组织来自不同应用程序和项目的组件（无需任何重构），并使其可以在构建新功能和应用程序时被发现、使用、开发和协作。

- YouTube 视频链接：https://youtu.be/P4Mk_hqR8dU

Bit 上共享的组件可自动地通过 NPM / Yarn 安装，或与 Bit 本身一起使用。后者使你能够同时开发来自不同项目的组件，并轻松更新（并合并）它们之间的更改。

![](https://cdn-images-1.medium.com/max/1000/1*1aWFQBNr5aEQ1OnquZrIxw.png)

为了使组件更容易被发现，Bit 为组件提供了[可视化渲染](https://blog.bitsrc.io/introducing-the-live-react-component-playground-d8c281352ee7)，测试结果（Bit 独立运行组件的单元测试）和从源代码本身解析的文档。

使用 Bit，你可以更快地开发多个应用程序和进行团队协作，并将你的组件用作新功能和项目的构建块。

### 2. [StoryBook](https://storybook.js.org/) / [Styleguidist](https://react-styleguidist.js.org/)

Storybook 和 Styleguidist 是在 React 中快速开发 UI 的环境。两者都是加速 React 应用程序开发的绝佳工具。 

两者之间存在一些重要的差异，这些差异也可以组合在一起以完成你的组件开发系统。

使用 Storybook，你可以在 JavaScript 文件中编写 **stories**。使用 Styleguidist，你可以在 Markdown 文件中编写**示例**。Storybook 一次显示一个组件的变化，而 Styleguidist 可以显示不同组件的多种变化。Storybook 非常适合显示组件的状态，而 Styleguidist 对于不同组件的文档和演示非常有用。

下面是一个简短的纲要。

#### [StoryBook](https://storybook.js.org/)

- [**storybooks/storybook**: storybook — Interactive UI component dev & test: React, React Native, Vue, Angular.](https://github.com/storybooks/storybook "https://github.com/storybooks/storybook")

[Storybook](https://github.com/storybooks/storybook) 是 UI 组件的快速开发环境。

它允许你浏览组件库，查看每个组件的不同状态，以及交互式开发和测试组件。

![](https://cdn-images-1.medium.com/max/800/1*8T0opytn0oYuEMpd8PRTsw.gif)

StoryBook 可帮助你独立于应用程序开发组件，这也有助于提高组件的可重用性和可测试性。

你可以浏览库中的组件，修改其属性，并通过热加载在网页上获得组件的即时效果。可以在这里找到一些流行的[例子](https://storybook.js.org/examples/).

不同的插件可以帮助你更快地开发，从而缩短代码调整到视觉输出之间的周期。StoryBook 还支持 [React Native](https://facebook.github.io/react-native/) 和 [Vue.js](https://vuejs.org/)。

#### [Styleguidist](https://react-styleguidist.js.org/)

- [**React Styleguidist：具有在线样式指南的独立的 React 组件开发环境**：具有在线样式指南的独立的 React 组件开发环境。](https://react-styleguidist.js.org/ "https://react-styleguidist.js.org/")

React [Styleguidist](https://github.com/styleguidist/react-styleguidist) 是一个组件开发环境，它具有热重载的开发服务器和在线样式指南，列出组件的 `propTypes` 并显示基于 .md 文件的可编辑的用法示例。

![](https://cdn-images-1.medium.com/max/800/1*9V2nSEgH1VUbmXd5Dq-hnA.gif)

它支持ES6，Flow 和 TypeScript，并且可以使用开箱即用的 Create React App。自动生成的使用文档可以让 Styleguidist 充当团队不同组件的文档门户。

* 另请查看由 Formidable Labs 提供的 [**React Live**](https://github.com/FormidableLabs/react-live)。这个组件渲染环境也用在了 [Bit 的实时组件 playground](https://bitsrc.io/bit/movie-app/components/hero) 上。

### 3. [React devTools](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en)

![](https://cdn-images-1.medium.com/max/800/1*9XrmfPqh_naIBlTi7dv3Hw.gif)

这个官方的 React Chrome devTools [扩展程序](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi?hl=en)可以让你在 Chrome 开发者工具里查看 React 组件的层次结构。它也可以作为 [FireFox 附加组件](https://addons.mozilla.org/en-US/firefox/addon/react-devtools/)使用。

使用 React devTools，你可以在操作组件树时查看并编辑组件的 props 和 state。此功能可以让你了解组件更改如何影响其他组件，以帮助你使用正确的组件结构和分离方式来设计 UI。

这个扩展程序的搜索栏可让你快速查找和检查所需的组件，从而节省宝贵的开发时间。

![](https://cdn-images-1.medium.com/max/800/1*GAPOIeQHhPFS5D0ccHHy7w.gif)

查看适用于 Safari，IE 和 React Native 的[独立应用程序](https://github.com/facebook/react-devtools/tree/master/packages/react-devtools)。

### 4. [Redux devTools](http://extension.remotedev.io/)

![](https://cdn-images-1.medium.com/max/800/1*RESAzFvlkgBlU4IgRGQjaA.gif)

此 [Chrome 扩展程序](https://github.com/zalmoxisus/redux-devtools-extension)（和 [FireFox附加组件](https://addons.mozilla.org/en-US/firefox/addon/remotedev/)）是一个开发时间程序包，是 Redux 开发工作流程的利器。它允许你检查每个 state 和 action payload，重新计算“分阶段”的 actions。

你可以将 [Redux DevTools 扩展程序 ](https://github.com/zalmoxisus/redux-devtools-extension)与任何处理状态的体系结构集成。每个 React 组件的本地状态可以有多个存储或不同的实例。你甚至可以通过“时间旅行”来取消 actions（可以观看 [Dan Abramov 的](https://medium.com/@dan_abramov) [视频](https://www.youtube.com/watch?v=xsSnOQynTHs)）。日志记录 UI 本身甚至可以自定义为 React 组件。

### 5. Boilerplates & Kick-Starters

虽然这些并不完全是开发者工具，但它们有助于快速创建 React 应用程序，同时节省构建和其他配置的时间。虽然 React 有许多[入门套件](https://reactjs.org/community/starter-kits.html)，但这里有一些最好的。

当与预制组件（在 [Bit](https://bitsrc.io) 或其他来源上）结合使用时，你可以快速创建应用程序结构并将组件组合到其中。

#### [Create React App](https://github.com/facebook/create-react-app) (50k stars)

![](https://cdn-images-1.medium.com/max/800/1*2aquNYnmp7YHa2TeefS9Ew.gif)

这个广泛使用且受欢迎的项目可能是快速创建新 React 应用程序并从头开始运行的最有效方法。

此软件包封装了新 React 应用程序所需的复杂配置（Babel，Webpack等），因此你可以节省新建应用程序所需的这段时间。

要创建新应用程序，只需运行一个命令即可。

```
npx create-react-app my-app
```

此命令在当前文件夹中创建名为 `my-app` 的目录。
在目录中，它将生成初始项目结构并安装传递依赖项，然后你就可以简单地开始编码了。

#### [React Boilerplate](https://github.com/react-boilerplate/react-boilerplate) (18k stars)

[Max Stoiber](https://medium.com/@mxstbr) 的这个 React 样板文件模板为你的 React 应用程序提供了一个启动模板，该模板专注于离线开发，并在考虑到了可扩展性和性能。

它的快速脚手架有助于直接从 CLI 创建组件、容器、路由、选择器和 sagas —— 以及它们的测试，而 CSS 和 JS 的更改可以立即反映出来。

与 create-react-app 不同，这个样板文件不是为初学者设计的，而是为经验丰富的开发人员提供的。使用它可以管理性能、异步、样式等等，从而构建产品级的应用程序。

#### [React Slingshot](https://github.com/coryhouse/react-slingshot) (8.5k stars)

[Cory House](https://medium.com/@housecor) 的这个极好的项目是 React + Redux 入门套件/样板，带有Babel、热重载、测试和 linting 等等。

与 React Boilerplate 非常相似，这个入门套件专注于快速开发的开发人员体验。每次点击“保存”时，更改都会热重载，并且会运行自动化测试。

该项目甚至包括一个示例应用，因此你无需阅读太多文档即可开始工作。

* 另外也可以了解一下 [**simple-react-app**](https://github.com/Kornil/simple-react-app)，[这篇文章](https://medium.com/@francesco.agnoletto/i-didnt-like-create-react-app-so-i-created-my-own-boilerplate-190a7dd5d74)对此工具进行了解释。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
