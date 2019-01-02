>* 原文链接 : [10-things-you-probably-didnt-know-about-javascript-react-and-nodejs-and-graphql-development-at-facebook](https://hashnode.com/post/10-things-you-probably-didnt-know-about-javascript-react-and-nodejs-and-graphql-development-at-facebook-cink0r0e500h5io53fpl7ediu)
* 原文作者 : [Sandeep Panda](https://hashnode.com/@sandeep)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Jack](https://github.com/Jack-Kingdom)
* 校对者: [DeadLion](https://github.com/DeadLion),[Joddiy](https://github.com/joddiy)

# 10 个你可能不知道的事，关于 Facebook 内部开发环境是如何使用 JavaScript 和 GraphQL 的

最近, 来自 Facebook 的 Lee Byron ([@leebyron](https://hashnode.com/@leebyron)) 在Hashnode上主办了一场 [AMA](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda)( Ask Me Anything )。 这里提出了许多有趣的问题，并且 Lee 透露了一些关于 Facebook 如何使用 React 、GraphQL 、和 React Native 的惊人事实与细节。我拜读了他在 AMA 上的回答，思考并总结出了十条有趣的重点。

那么，开始吧。

## React 背后的灵感?

React 一定程度上受到了 [XHP](https://github.com/facebook/xhp-lib) 的启发，来自 Facebook 的 Marcel Laverdet 在2009年创建了此项目，用于模块化 Facebook 的用户界面。详见[这里](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda#cin120uib00edlv533i6d8yd7)。

## Facebook计划用React Native 重写他的移动应用吗？

好吧, 答案是 : _他们已经这样做了_。 有一部分 Facebook 的应用使用了 React Native 构建，也有一部分不是。 详细的答案见这个[讨论](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda#cin6vg5r201wqjh53ne77tao1).

## 哪些场景正在使用 Immutable.js ？

*   Ads Manager 和他们基于 React Native 的 Android 和 IOS 应用。
*   Messenger 网站 ([messenger.com](https://hashnode.com/util/redirect?url=http://messenger.com))
*   用 Draft.js 写的新文章。
*   在 Facebook News Feed 上所有的评论。

## Facebook 如何为 React 组件写 CSS ?

Lee 透露到他们禁止导入 CSS 规则到除 React 组件以外的任意文件。 这样不仅确保了一个组件经由格式化的属性所应该暴露出的正确的 API ，同时其他的组件不能够通过导入一个规则来覆盖他。 此外，他们并不需要通过 JavaScript 的一些技巧来导入 CSS 文件。相反，他们遵循`Button.js` 临靠 `Button.css` 的规范。详见 [这里](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda#cin5qpdbv01apk85319o2c1fx)。

## Facebook 会随着每个 React 重要发行版而更新 React 组件吗？

*   是的，他们会。
*   Facebook 通常将 React **master** 分支用于生产环境
*   从2012开始，React API 并没有进行多少重大的更改。 因此，React 团队也很少面临必须更新组件的状况。
*   如果有突发的更新，React 团队的成员 Ben Alpert 将会负责代码库的所有同步工作。
*   他们也会使用类似 [jscodeshift](https://github.com/facebook/jscodeshift) 的自动化工具去简化问题。

## GraphQL 背后的故事是什么?

GraphQL 诞生于2012年，当时 Lee 正在 IOS 组致力于 News Feed 。 当时，在一些网络环境糟糕的地区，Facebook 正急速增长。 因此, GraphQL 最初被设计于应对缓慢的手机连接。 不久，当 Relay 正准备开源时，他们认为缺乏 GraphQL ，Relay 的开源就没有多少意义。 同时，他们也意识到 GraphQL 服务编写得很巧妙并且大多数 Facebook 以外的公司都未尝使用过。因此，他们决定通过编写一个语言无关的规范来发布它。那就是 GraphQL 背后的故事。详情可阅读 [此处](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda#cin1gw37n00kwlv53rretxpe8) 的回答。

## Facebook 正在什么场景使用 GraphQL ？

Facebook的 Android 和 IOS 应用 几乎全部依赖于 GraphQL 支持。 在一些情况下, 如Ads Manager，整个应有都在使用 Relay + GraphQL 。

是的, Facebook 重度依赖 SSR 。尽管如此，Lee 说他们很少有在服务器使用 React 渲染组件的场景。这个主要取决于他们的服务器环境。

## Facebook 使用 Node.js 吗？

Lee 说他们有许多客户端的工具由 Javascript 编写并通过 Node 运行。[remodel](https://github.com/facebook/remodel) 就是这样一个通过 npm 安装的工具.他们所有的 IOS 和 android 上的内部 GraphQL 客户端工具都在使用 Node 。但是他们在服务器端使用 Node 并不多，因为迄今都没有一个强烈的需求。 即使某一天他们想在服务器端使用 Javascript (例如：在服务器上渲染 React )，他们也会直接使用 V8 引擎而非 Node 。

## Falcor (by Netflix) 对比 GraphQL 如何？
据 Lee 所说, 两个工具都在尝试解决类似的问题。当 GraphQL 团队第一次听说 Falcor 时，他们与 Netflix 团队见了一面并交换了一些想法。虽然如此，Falcor 与GraphQL 之间还是有许多区别的。阅读 [此处](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda#cinj7lim4002lid53x47g060n) 的回答可以知道更多。

我希望你能喜欢这份非常简短的总结。 详细的回答与讨论请移步 [AMA 页面](https://hashnode.com/ama/with-lee-byron-cin0kpe8p0073rb53b19emcda)。
