> * 原文地址：[Micro Frontends](https://martinfowler.com/articles/micro-frontends.html)
> * 原文作者：[Cam Jackson](https://camjackson.net/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * 译者：[xilihuasi](https://github.com/xilihuasi)
> * 校对者：[Stevens1995](https://github.com/Stevens1995), [lgh757079506](https://github.com/lgh757079506)

# 微前端：未来前端开发的新趋势 — 第三部分

做好前端开发不是件容易的事情，而比这更难的是扩展前端开发规模以便于多个团队可以同时开发一个大型且复杂的产品。本系列文章将描述一种趋势，可以将大型的前端项目分解成许多个小而易于管理的部分，也将讨论这种体系结构如何提高前端代码团队工作的有效性和效率。除了讨论各种好处和代价之外，我们还将介绍一些可用的实现方案和深入探讨一个应用该技术的完整示例应用程序。

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

## 跨应用通信

关于微前端最常见的问题就是如何让它们互相交流。一般来说，我们建议通信越少越好，因为这通常会重新引入不恰当的耦合，而这种耦合是我们首先想要避免的。

也就是说，某种程度上的通信通常是需要的。[自定义事件]((https://developer.mozilla.org/en-US/docs/Web/Guide/Events/Creating_and_triggering_events))允许微前端直接通信，这是最小化直接耦合的好方法，虽然它确实使确定和执行微前端之间存在的约定变得更加困难。另外，向下传递回调和数据（在这里是从容器应用向下到微前端）的 React 模型也是一种好方法，它使得约定更加明确。第三种方法是使用地址栏作为通信机制，后面我们会谈到[更多细节](https://martinfowler.com/articles/micro-frontends.html#Cross-applicationCommunicationViaRouting)。

> 如果你在使用 redux，常用的方法是建立一个对于整个应用单一、全局、共享的 store。然而，如果微前端都应该是它自己的独立应用，那么它们每个都有自己的 redux store 是有意义的。Redux 文档甚至提到[“将 Redux 应用程序隔离为更大应用程序中的组件”](https://redux.js.org/faq/store-setup#can-or-should-i-create-multiple-stores-can-i-import-my-store-directly-and-use-it-in-components-myself)作为拥有多个 store 的正当理由。

无论选择哪种方式，我们希望微前端通过发送消息或者事件来彼此通信，避免任何状态共享。就像跨微服务共享数据库，只要我们共享数据结构和领域模型，就会产生大量的耦合，这会变得非常难以维护。

与样式一样，有几种不同的方法可以在这方面起到很好的作用。最重要的事情是对你正在引入的耦合考虑深远，以及你将如何保持约定。就像微服务之间的集成一样，如果没有跨不同应用程序和团队的协调升级过程，你就无法对集成做出重大变更。

你也应该考虑如何自动验证集成没有挂掉。功能测试是一种方式，但我们更希望限制编写功能测试的数量，以便控制实现和维护它们的成本。或者你可以实施某种形式的[消费者驱动的约定](https://martinfowler.com/articles/consumerDrivenContracts.html)，这样每个微前端可以指定它对于其他微前端的依赖，无需在浏览器中实际集成和运行它们。

* * *

## 后端通信

如果我们有独立的团队在前端应用程序上独立工作，那么后端开发呢？我们非常相信全栈团队的价值，他们从可视化代码到 API 开发、数据库和基础架构代码负责整个应用的开发。[BFF](https://samnewman.io/patterns/architectural/bff/) 模式在这里发挥了作用，每一个前端应用都有一个对应的后端来单独满足前端的需求。虽然 BFF 模式最初可能意味着每个前端通道（web、mobile 等）的专用后端，它可以很容易地扩展为每一个微前端的后端。

这里有很多因素需要考虑。BFF 可能是自包含的，具有自己的业务逻辑和数据库，或者也可能只是一个下游服务的聚合器。如果有下游服务，那么拥有微前端及其 BFF 的团队可能有或可能没有意义，来拥有一些这样的服务。如果微前端只有一个与之通讯的 API ，并且它相当稳定，那么构建 BFF 就根本没有多大价值了。有一个指导原则是，团队构建一个特定微前端时不应该必须得等其他团队来为他们构建东西。因此如果每当给微前端添加新功能时也要求后端更改，那么由同一个团队拥有的 BFF 就是一个很好的案例。

![该图表显示三对前端/后端。第一个后端只与自己的数据库对话。其他两个后端与共享下游服务进行通信。两种方法都是有效的](https://martinfowler.com/articles/micro-frontends/bff.png)

图 7：有很多不同的方式构建你的前/后端关系

其他常见问题有，应该如何通过服务器对微前端应用的用户进行身份验证和授权？明显我们的用户应该只需要认证一次，因此鉴权通常成为属于容器应用拥有的广泛关注的问题。容器可能有某种登录形式，我们通过它获得某种令牌。令牌由容器保存，可以在初始化时注入到每个微前端中。最终，微前端可以在任何发送给服务器的请求中携带令牌，然后服务器就可以执行任何需要的验证。

* * *

## 测试

在测试方面，我们认为笨重前端和微前端之间没有太大区别。通常来讲，你用来测试笨重前端的任何策略都可以应用于每个微前端。也就是说，每个微前端都应该有自己全面的自动化测试套件来保证代码的质量和正确性。

明显的障碍是各种微前端与容器应用的集成测试。这个可以使用你喜欢的功能/端对端测试工具（比如 Selenium 或 Cypress）来完成，但是不要过度使用。功能测试应该只涵盖无法在[测试金字塔](https://martinfowler.com/bliki/TestPyramid.html)较低级别测试的方面。我们的意思是，使用单元测试涵盖低级别业务逻辑和渲染逻辑，功能测试只用来验证页面是否正确渲染。例如，你可以在特定 URL 上加载完全集成的应用程序，并断言相应微前端的硬编码标题出现在页面上。

如果用户的使用跨越微前端，那么你可以用功能测试来测试这些，但要保证功能测试专注于验证前端的整合，而不是每个微前端的内部业务逻辑，这应该已经被单元测试所涵盖。[正如刚才提到的](https://martinfowler.com/articles/micro-frontends.html#Cross-applicationCommunication)，用户驱动的约定有助于直接指定微前端之间发生的交互，而不会出现集成环境和功能测试的瑕疵。

* * *

## 案例详解

本文后面的大部分内容将详细解释我们的示例应用程序实现的一种方式。我们将重点关注容器应用和微前端如何[使用 JavaScript 整合在一起](https://martinfowler.com/articles/micro-frontends.html#Run-timeIntegrationViaJavascript)，这可能是最有趣也最复杂的部分。你可以在 [https://demo.microfrontends.com](https://demo.microfrontends.com) 看到实时部署的最终结果，所有源代码都可以在 [Github](https://github.com/micro-frontends-demo) 上看到。

![整个微前端示例应用的首页“概览”截图](https://martinfowler.com/articles/micro-frontends/screenshot-browse.png)

图 8：整个微前端示例应用的首页“概览”

该示例完全使用 React 开发，有必要说明的是，React **没有**垄断这个架构。可以使用许多不同的工具或框架来实现微前端。这里我们使用 React 是因为它的受欢迎程度以及我们对它的熟悉程度。

### 容器

我们从[容器](https://github.com/micro-frontends-demo/container)开始，因为它是我们用户的入口。让我们从它的 `package.json` 中看看可以发现什么：

```
{
  "name": "@micro-frontends-demo/container",
  "description": "Entry point and container for a micro frontends demo",
  "scripts": {
    "start": "PORT=3000 react-app-rewired start",
    "build": "react-app-rewired build",
    "test": "react-app-rewired test"
  },
  "dependencies": {
    "react": "^16.4.0",
    "react-dom": "^16.4.0",
    "react-router-dom": "^4.2.2",
    "react-scripts": "^2.1.8"
  },
  "devDependencies": {
    "enzyme": "^3.3.0",
    "enzyme-adapter-react-16": "^1.1.1",
    "jest-enzyme": "^6.0.2",
    "react-app-rewire-micro-frontends": "^0.0.1",
    "react-app-rewired": "^2.1.1"
  },
  "config-overrides-path": "node_modules/react-app-rewire-micro-frontends"
}
```

从 `react` 和 `react-scripts` 依赖可以看出它是通过 [`create-react-app`](https://facebook.github.io/create-react-app/) 创建的 React 应用。更有趣的是那**没有**的：任何提及我们将要组成以形成我们的最终应用程序的微前端。如果我们在这里将它们指定为库依赖项，那么我们将走向构建时集成的道路，那就会[像之前提到的](https://martinfowler.com/articles/micro-frontends.html#Build-timeIntegration)会导致在我们的发布周期中有问题的耦合。

> `react-scripts` 1.x 版本可以在单个页面中拥有多个应用而不产生冲突，但在 2.x 版本使用一些 webpack 特性，当两个以上应用在单个页面渲染时会导致错误。基于这个原因我们使用 `react-app-rewired` 覆盖一些 webpack 内部的 `react-scripts` 配置。它会修复这些错误，让我们继续依靠 `react-scripts` 来管理我们的构建工具。

为了了解我们如何选择和展示微前端，我们来看一下 `App.js`。我们使用 [React Router](https://reacttraining.com/react-router/) 将当前 URL 与预定义的路由列表进行匹配，并且渲染相应组件：

```
<Switch>
  <Route exact path="/" component={Browse} />
  <Route exact path="/restaurant/:id" component={Restaurant} />
  <Route exact path="/random" render={Random} />
</Switch>
```

`Random` 组件不那么有趣 —— 它只是重定向到随机选择的餐厅 URL 对应的页面。`Browse` 和 `Restaurant` 是这样：

```
const Browse = ({ history }) => (
  <MicroFrontend history={history} name="Browse" host={browseHost} />
);
const Restaurant = ({ history }) => (
  <MicroFrontend history={history} name="Restaurant" host={restaurantHost} />
);
```

这两种情况，我们渲染 `MicroFrontend` 组件。除了 history 对象（后面会变得重要），我们指定应用的唯一名称，以及 bundle 下载的主机地址。在本地运行时，这个配置驱动的 URL 类似于 `http://localhost:3001`，生产环境则类似 `https://browse.demo.microfrontends.com`。

在 `App.js` 中选择了一个微前端，现在我们将在 `MicroFrontend.js` 渲染它，这只是另一个 React 组件：

```
class MicroFrontend extends React.Component {
  render() {
    return <main id={`${this.props.name}-container`} />;
  }
}
```

这不是完整的类，我们很快会看到它更多的方法。

渲染时，我们要做的就是在页面上放置带有微前端唯一 ID 的容器元素。这是我们告诉微前端渲染自己的地方。我们使用 React 的 `componentDidMount` 作为下载和渲染微前端的触发器：

> `componentDidMount` 是 React 组件的生命周期函数，它只会在组件实例首次在 DOM 中“渲染”时被框架调用。

MicroFrontend 类……

```
  componentDidMount() {
    const { name, host } = this.props;
    const scriptId = `micro-frontend-script-${name}`;

    if (document.getElementById(scriptId)) {
      this.renderMicroFrontend();
      return;
    }

    fetch(`${host}/asset-manifest.json`)
      .then(res => res.json())
      .then(manifest => {
        const script = document.createElement('script');
        script.id = scriptId;
        script.src = `${host}${manifest['main.js']}`;
        script.onload = this.renderMicroFrontend;
        document.head.appendChild(script);
      });
  }
```

> 我们必须从静态清单文件中获取脚本的 URL，因为 `react-scripts` 输出的编译后 JavaScript 文件名中包含便于缓存的哈希值。

首先我们检查有唯一 ID 的相关脚本是否已经下载，如果下载了，我们可以立即渲染它。如果没有，我们获取从适当的主机获取 `asset-manifest.json` 文件，以便查找主脚本资产的完整 URL。一旦我们设置了脚本的 URL，剩下的就是将它附加到文档中，使用 `onload` 处理程序渲染微前端：

MicroFrontend 类

```
  renderMicroFrontend = () => {
    const { name, history } = this.props;

    window[`render${name}`](`${name}-container`, history);
    // E.g.: window.renderBrowse('browse-container, history');
  };
```

在上面的代码中我们调用了 `window.renderBrowse` 全局函数，它被我们刚刚下载的脚本放在那里。我们给微前端应该渲染的 `<main>` 元素分配一个 ID 和 `history` 对象，我们很快会解释。**这个全局函数的签名是容器应用和微前端之间的关键约定**。这是任何通讯或集成应该发生的地方，因此保持它相当轻量级使其易于维护，并在未来添加新的微前端。每当我们想要做一些需要更改此代码的事情时，我们应该仔细地思考它对于我们的代码库的耦合以及约定的维护意味着什么。

最后一件是处理清理工作。当我们的 `MicroFrontend` 组件卸载时（从 DOM 中移除），我们也想卸载相应的微前端。为此，每个微前端都定义了一个相应的全局函数，我们在适当的 React 生命周期方法中调用它：

MicroFrontend 类……

```
  componentWillUnmount() {
    const { name } = this.props;

    window[`unmount${name}`](`${name}-container`);
  }
```

就它本身的内容而言，容器直接渲染的所有内容是网站的顶层头部和导航栏，因为这些在所有页面中都是不变的。这些元素的 CSS 已经过仔细编写，以确保它只对标题中的元素进行样式化，所以它不应该与微前端内的任何样式代码冲突。

这就是容器应用的结尾！它相当初级，但这给了我们一个 shell，可以在运行时动态下载我们的微前端，并将它们粘合在一起形成一个单一页面上的内容。这些微前端可以单独部署在生产上，无需改变任何其他微前端或容器本身。

> **建议按照顺序阅读本系列文章：**
>
> * [微前端：未来前端开发的新趋势 — 第一部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-1.md)
> * [微前端：未来前端开发的新趋势 — 第二部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-2.md)
> * [微前端：未来前端开发的新趋势 — 第三部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-3.md)
> * [微前端：未来前端开发的新趋势 — 第四部分](https://github.com/xitu/gold-miner/blob/master/TODO1/micro-frontends-4.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
