> * 原文地址：[Micro Frontends](https://martinfowler.com/articles/micro-frontends.html)
> * 原文作者：[Cam Jackson](https://camjackson.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)
> * 译者：[DEARPORK](https://github.com/Usey95)
> * 校对者：[lgh757079506](https://github.com/lgh757079506), [solerji](https://github.com/solerji)

# 微前端：未来前端开发的新趋势 — 第四部分

做好前端开发不是件容易的事情，而比这更难的是扩展前端开发规模以便于多个团队可以同时开发一个大型且复杂的产品。本系列文章将描述一种趋势，可以将大型的前端项目分解成许多个小而易于管理的部分，也将讨论这种体系结构如何提高前端代码团队工作的有效性和效率。除了讨论各种好处和代价之外，我们还将介绍一些可用的实现方案和深入探讨一个应用该技术的完整示例应用程序。

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

## 跨应用通信

### 微前端

我们从我们一直引用的全局渲染函数继续。我们应用的主页是个可筛选的餐馆列表，入口代码如下所示：

```
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import registerServiceWorker from './registerServiceWorker';

window.renderBrowse = (containerId, history) => {
  ReactDOM.render(<App history={history} />, document.getElementById(containerId));
  registerServiceWorker();
};

window.unmountBrowse = containerId => {
  ReactDOM.unmountComponentAtNode(document.getElementById(containerId));
};
```

通常在 React.js 应用中，`ReactDOM.render` 的调用会在最顶层作用域，这意味着一旦脚本文件加载完成，它就会立即在一个硬编码的 DOM 元素中开始渲染。对于这个应用，我们需要能够同时控制渲染发生的时间和位置，所以我们将它包裹在一个接收 DOM 元素 ID 作为参数的函数里，并把这个函数添加到全局的 `window` 对象。相应的，我们还可以看到用于清理的 un-mounting 函数。

虽然我们已经看到当微前端集成到整个容器应用时这个函数将被如何调用，但这里成功的最大标准之一是我们是否能够独立地开发和运行微前端。所以每个微前端也有自己的 `index.html`，它带有内联的脚本，以便于在容器外以“独立”模式渲染应用。

```
<html lang="en">
  <head>
    <title>Restaurant order</title>
  </head>
  <body>
    <main id="container"></main>
    <script type="text/javascript">
      window.onload = () => {
        window.renderRestaurant('container');
      };
    </script>
  </body>
</html>
```

![`order` 页在容器外独立运行的截图](https://martinfowler.com/articles/micro-frontends/screenshot-order.png)

图 9：每个微前端都可以在容器外独立运行。

在此之前，微前端大部分只是普通的旧 React 应用。[browse](https://github.com/micro-frontends-demo/browse) 应用从后端拉取餐厅列表，提供 `input` 标签用于搜索和筛选，并渲染 React Router `<Link>` 元素导航到特定餐馆。这时我们要切换到 `order` 微前端，它负责渲染单独的餐厅及其菜单。

![一个架构图，显示了上文导航的一系列步骤](https://martinfowler.com/articles/micro-frontends/demo-architecture.png)

图 10：这些微前端仅通过路由变换相互作用，并不直接交互

有关我们的微前端，最后一件值得一提的事是他们都使用了 `styled-component` 来完成它们所有的样式。这个 CSS-in-JS 库可以很容易地将样式和特定组件关联，这样我们可以保证微前端的样式不会泄露以影响容器或其他微前端的样式。

### 基于路由的跨应用通信

我们[较早前提到](https://martinfowler.com/articles/micro-frontends.html#Cross-applicationCommunication)跨应用通信应该尽量避免。在这个例子中，我们唯一（需要跨应用通信）的需求是浏览页需要告诉详情页加载哪个餐馆。这里我们将看到怎样用客户端路由去解决这个问题。

这里涉及的三个 React 应用都使用了 React Router 进行声明式路由，但是通过两种略有差别的方式进行初始化。容器应用中，我们创建了一个 `<BrowserRouter>`，它在内部会实例化一个 `history` 对象。这是我们之前一直在“掩饰”的 `history` 对象。我们用这个对象操作客户端历史记录，同时我们也用它将不同的 React Router 连接起来。在我们的微前端里，我们像这样初始化 Router：

```
<Router history={this.props.history}>
```

在这种情况下，我们使用的是容器应用的 history 实例，而并不会让路由组件自己实例化一个新的 history 对象。所有的 `<Router>` 实例现在都已经连接在一起，因此任何实例触发的路由变化都会反映在所有实例中。这为我们提供了一种通过 URL 将“参数”从一个微前端传递到另一个微前端的简单方法。例如在 browse 微前端，我们有一个这样的链接：

```
<Link to={`/restaurant/${restaurant.id}`}>
```

当这个链接被点击时，容器中的路由会被更新，该容器会看到新的 URL 然后决定挂载以及渲染 restaurant 微前端。该微前端自己的路由逻辑将从 URL 提取 restaurant ID 并渲染正确的信息。

希望这个示例流程展示了简洁 URL 的灵活性及强大功能。除了便于分享与做书签以外，在这个特定的架构里，它还可以是微前端互相交流意图的有用方式。基于这个目的使用 URL 有以下许多优势：

* 其结构是定义明确的开放标准
* 页面上所有代码皆可访问
* 其有限的空间鼓励我们仅发送少量数据
* 它面向用户，鼓励我们诚实地依据域组织数据模型
* 它是声明式的，非命令式。即它仅表示“这是我们所在的地方”而非“请做这件事”
* 它迫使微前端间接进行通信，而非直接互相了解互相依赖

当我们使用路由作为微前端通信的模式时，我们选择的路由构成了一个**合约**。在这种情况下，我们规定可以在 `/restaurant/:restaurantId` 查看一个餐厅的详细信息，并且我们无法在不更新所有引用该路由的应用的情况下更新路由。鉴于此合约的重要性，我们应该进行自动化测试以检查合约是否被遵守。

### 公用内容

虽然我们希望我们的团队以及我们的微前端尽可能独立，但有些事情仍应该是共有的。我们之前写过关于[公用组件库](https://martinfowler.com/articles/micro-frontends.html#SharedComponentLibraries)如何帮助实现微前端的一致性的文章，但对于这些小 demo 来说公用组件库有点杀鸡用牛刀。所以作为替代，我们有一个小的[公用内容仓库](https://github.com/micro-frontends-demo/content)，包含图像，JSON 数据和 CSS，它们通过网络提供给所有微前端。

还有一样东西我们可以选择在微前端之间共享：依赖库。正如我们将[简要描述](https://martinfowler.com/articles/micro-frontends.html#PayloadSize)，依赖的重复是微前端的常见缺点。即便在应用之间共享依赖也有自身的一些困难，但对于这个 demo 来说，谈论一下如何完成它是值得的。

第一步是选择要共享的依赖。编译后代码的快速分析显示我们 50% 的 bundle 体积是由 `react` 和 `react-dom` 贡献的。抛开他们的体积不谈，这两个库是我们最“核心”的依赖，因此我们知道所有微前端都可以从提取它们成为公共依赖中受益。最后，这些都是稳定、成熟的库，通常只在两个主版本间引入重大更改，因此跨应用更新不会太困难。

至于实际提取操作，我们要做的就是在 webpack config 中将库标记为 [externals](https://webpack.js.org/configuration/externals/)，我们可以抄抄[前面](https://martinfowler.com/articles/micro-frontends.html#TheContainer)。

```
module.exports = (config, env) => {
  config.externals = {
    react: 'React',
    'react-dom': 'ReactDOM'
  }
  return config;
};
```

然后我们在每个 `index.html` 中加几个 `script` 标签，从我们的共享内容服务器中获取这两个库。

```
<body>
  <noscript>
    You need to enable JavaScript to run this app.
  </noscript>
  <div id="root"></div>
  <script src="%REACT_APP_CONTENT_HOST%/react.prod-16.8.6.min.js"></script>
  <script src="%REACT_APP_CONTENT_HOST%/react-dom.prod-16.8.6.min.js"></script>
</body>
```

在团队中共享代码一直是个很难做好的事情。我们要确保我们只共享我们真正想公用且一次需要修改多处地方的东西。如果我们对我们共享与不共享的事情保持谨慎，我们将从中真正受益。

### 基础设施

该应用托管在 AWS，拥有核心基础设施（S3 存储桶，CloudFront 分配，域名，证书等)，使用 Terraform 的[集中仓库](https://github.com/micro-frontends-demo/infra)一次性配置。每个微前端都有自己的源码仓库，在 [Travis CI](https://travis-ci.org/micro-frontends-demo/) 上有自己的连续部署管道，用于构建、测试以及部署静态资源到 S3 存储桶中。这平衡了集中式基础架构管理的便利性与独立部署的灵活性。

请注意，每个微前端（以及容器）都有自己的存储桶。这意味着它们可以自由控制里面的内容，我们不需要担心来自其他团队或应用的对象名称冲突或冲突的访问规则。

* * *

## 缺点

在本文开头，我们提到过微前端技术的取舍，就像任何架构一样。我们提到过的好处确实有成本，我们将在此介绍。

### 负载体积

独立构建的 Javascript bundle 会造成公共依赖的重复，从而增加了我们必须通过网络发送给最终用户的字节数。例如，如果每个微前端都包含了自己的 React 副本，那么我们将迫使用户下载 React **n** 次。页面性能与用户参与/转换有[直接关系](https://developers.google.com/web/fundamentals/performance/why-performance-matters/)，并且世界上大部分地区运行在比发达城市慢得多的网络设施上，所以我们有很多理由关心下载体积。

这个问题不容易解决。一方面我们希望团队独立编译他们的应用以便自主工作，另一方面又我们希望他们可以共享公共依赖，这两者之间存在内在的紧张关系。一种解决办法是[像我们前面 demo 描述的](https://martinfowler.com/articles/micro-frontends.html#CommonContent)，将我们编译后代码的常见依赖外置。一旦我们沿着这条路走下去，我们将重新引入一些微前端之间构建过程的耦合。现在它们之间有着一个隐含的合约：“我们都必须使用这些依赖的明确版本”。如果其中一个依赖产生重大改动，我们可能最终需要一个大的协调升级工作以及一次性的同步发版。这是我们使用微前端最初想要避免的一切！

内在的紧张关系是个困难的问题，但并不全是坏消息。首先，即便我们对于重复的依赖不采取任何措施，每个单独页面仍可能比我们构建整个前端更快地加载。原因是通过独立编译每个页面，我们有效地以我们自己的形式实现了代码分割。在传统的前端中，应用中的任何页面加载完成时，我们通常会一次性下载所有页面的源码和依赖。通过独立构建，任何单独的页面加载将只会下载那个页面的源码和依赖。这可能导致更快的首页加载，但随后的导航速度会变慢，因为用户必须在每个页面上重新下载相同的依赖。如果我们严格地不用不必要的依赖使我们的微前端膨胀，或者我们知道用户在应用中通常访问的一两个页面，即便有重复依赖，我们也很可能在性能方面达到净**增益**。

在前一段有很多“可能”和“也许”，表明了每个应用通常都有它们自己独特的性能特征。如果你想确切地知道特定的变化会造成什么性能影响，只能靠实际测量，而且最好是在生产环境中。我们见过很多团队仅仅为了下载数兆大小的高清图像或者对一个运行非常慢的数据库进行昂贵的查询额外多写几千字节的 JavaScript 代码。因此，尽管考虑每个架构决策的性能影响很重要，但请确保你知道真正的瓶颈在哪里。

### 环境差异

我们应该能够开发一个单一的微前端，而无需考虑其他团队正在开发的所有其它微前端。我们可能甚至应该在“独立”模式下，在空白页面上运行我们的微前端，而不是运行在将在生产环境中承载微前端的容器应用内部。这可以使开发变得更加简单，特别是当真正的容器是一个复杂的遗留代码库的时候，而通常情况下我们使用微前端来逐步从旧世界迁移到新世界。但是，在与生产环境完全不同的环境中开发存在风险。如果我们的开发时容器与生产容器的行为不同，那么我们可能会发现我们的微前端被破坏，或者在我们部署到生产环境时表现不同。特别值得关注的是可能由容器或其他微前端带来的全局样式。

这里的解决方案与我们不得不担心环境差异的任何其他情况没有什么不同。如果我们在一个与生产环境不同的本地环境开发，我们需要确保定期将我们的微前端集成和部署到像生产环境的环境中，并且我们应该在这些环境中进行测试（手动以及自动化）以尽早发现集成问题。这不会完全解决问题，但最终这是一个取舍：简化开发环境的生产力提升是否值得冒集成出问题的风险？答案取决于项目！

### 运维复杂度

最后的缺点是与微服务直接平行的缺点。作为一个更加分散的架构，微前端将不可避免地导致需要管理更多的**东西** —— 更多的存储库，更多的工具，更多的构建/部署管道，更多的服务器，更多的域等等。因此，在采用这样的架构之前，你应该考虑几个问题：

* 你是否有足够的自动化可行地提供以及管理额外所需的基础设施？
* 你的前端开发、测试和发布进程是否会扩展到许多应用中？
* 你是否对围绕工具和开发的实践变得更加分散且不易控制的决策感到满意？
* 你将如何确保你的多个独立前端代码库中的最低代码质量，一致性或代码管理？

我们可能会另写一篇文章讨论这些主题。我们希望提出的主要观点是，当你选择微前端时，根据定义，你选择创建许多小东西而不是一个整体。你应该考虑你是否有采用这种方法所需的技术和组织成熟度，从而不造成混乱。

* * *

## 总结

随着前端代码库在过去几年中变得越来越复杂，我们看到对更具可扩展性的架构的需求不断增长。我们需要能够划清界限，在技术和域实体之间建立正确的耦合和内聚层级。我们应该能够跨独立开发团队可扩展地进行软件交付。

虽然远非唯一方案，但我们已经看到许多微前端提供了这些好处的真实案例，并且我们已经能够逐渐将该技术应用于遗留代码库以及新代码库。无论微前端是否适合你和你的组织，我们只能希望这将成为持续趋势的一部分，在这个趋势中，前端工程化和前端架构以我们应有的严肃性被对待。

* * *

如果您发现此文章有用，请分享它。我很感激反馈与鼓励。

## 致谢

非常感谢 Charles Korn，Andy Marks，和 Willem Van Ketwich 的全面审校和反馈。

同时感谢 Bill Codding，Michael Strasser，和 Shirish Padalkar 在 ThoughtWorks 内部邮件列表提供的意见。

感谢 Martin Fowler 的反馈意见，并发布在自己的网站上给了文章一个家。

最后，感谢 Evan Bottcher 和 Liauw Fendy 的鼓励和支持。

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
