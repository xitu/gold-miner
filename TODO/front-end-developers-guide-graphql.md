> * 原文地址：[A Front End Developer’s Guide to GraphQL](https://css-tricks.com/front-end-developers-guide-graphql/)
> * 原文作者：[PEGGY RAYZIS](https://css-tricks.com/author/peggyrayzis/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/front-end-developers-guide-graphql.md](https://github.com/xitu/gold-miner/blob/master/TODO/front-end-developers-guide-graphql.md)
> * 译者：[ellcyyang](https://github.com/ellcyyang)
> * 校对者：[Xekin-FE](https://github.com/Xekin-FE), [xueshuai](https://github.com/xueshuai)

# 写给前端开发者的 GraphQL 指南

不管你的应用是复杂还是简单，你总是要从远程服务器获取数据。在前端，这意味着和某个端点进行 REST 连接、转化并缓存服务器应答以及重新渲染 UI。多年以来，REST 是 API 的标配，但是在过去的一年内，一种名为 GraphQL 的新 API 技术凭借它优秀的开发体验和叙述性数据获取方式开始流行起来。

在这篇文章中我们将会通过一系列实例来说明 GraphQL 会如何帮助你解决获取远程数据的痛点。如果你是个 GraphQL 新手，也不用害怕！我会列举一些学习资源来帮助你使用 Apollo 栈学习 GraphQL，然后你就能领先别人一步掌握它。

### GraphQL 101

在我们弄明白为什么 GraphQL 可以让前端工程师更轻松之前，我们需要先搞清楚它是什么。当我们说起 GraphQL，我们要么是指这种语言本身，要么是指与它相关的一整套丰富的工具生态系统。就其核心而言，GraphQL 是 Facebook 开发的一种类型化的查询语言，让你能够以一种叙述性的方式表达你对数据的需求。你的查询结果的格式应该和你的查询语句相匹配。在下面这个例子里，我们期待得到一个有 `currency` 和 `rates` 属性的对象，其中 `rates` 又是包含了 `currency` 和 `rate` 关键字的对象的数组。

```
{
  rates(currency: "USD") {
    currency
    rates {
      currency
      rate
    }
  }
}
```

当我们讨论广义上的 GraphQL 时，我们主要指的是由帮助部署 GraphQL 到应用中的一些工具所组成的生态系统。在后端，你将使用 [Apollo 服务器](https://www.apollographql.com/docs/apollo-server/) 来创建一个 GraphQL 服务器 —— 一个解析 GraphQL 请求并返回数据的端点。服务器怎么知道应该返回哪些数据呢？你需要使用 [GraphQL 工具](https://www.apollographql.com/docs/graphql-tools/) 来创建一个字典（你的数据蓝图）和一个分解映射（用于从一个 REST 端点、数据库或别的什么中检索数据的一系列函数）。

但它实际上比听起来要简单 —— 通过 Apollo 启动台（一个 GraphQL 服务器控制台），你可以用不超过60行代码在浏览器里创建一个可运行的 GraphQL 服务器！ 😮 我们参考了这个 [我创建的启动台](https://launchpad.graphql.com/v7mnw3m03) ，其中包含了文章中所提到的 Coinbase API。

你将会使用 [Apollo 客户端](https://www.apollographql.com/docs/react/) 连接你自己的 GraphQL 服务器和应用，它是一个为你获取、缓存和更新数据的灵活快速的客户端。鉴于 Apollo 客户端并没有和视觉层相耦合，你可以用 React、Angular、Vue 甚至原生 JavaScript 编写。除了跨框架之外，Apollo 也可以跨平台，它支持 React Native 和 Ionic。

### 试一试！🚀

现在你已经掌握到底什么是 GraphQL 了，动手尝试用几个实例把 Apollo 应用到你的前端工作中去吧。我相信你最终会认可这一点 —— 一个使用了 Apollo 的基于 GraphQL 的架构将会帮助你更快地传送数据。

#### 1. 添加新的数据需求但不添加新端点

我们都遇到过这种情况：花费几个小时创建了一个完美的 UI 组件，然后产品需求突然改变了。你突然意识到，为了获得实现新需求所需的数据，你将不得不实现一个接收 API 请求的复杂瀑布模型 —— 或者更糟 —— 一个新的 REST 端点。然后你的工作阻塞了，你不得不要求后端为这个组件再添加一个新端点。

这种常见问题在 GraphQL 中不再出现，因为你在客户端需求的数据不再和某个端点的资源相耦合。相反，你发向 GraphQL 服务器的请求总是连上同一个端点。你的服务器通过你发送的字典指定所有的可用资源，让你的查询定义你所得到的结果的格式。让我们在 [我的启动台](https://launchpad.graphql.com/v7mnw3m03) 中用之前的例子说明这些概念：

在我们的字典里的第22～26行，我们定义了 `ExchangeRate` 类型。这些字段列举出了所有在我们的应用中可查询的资源。

```
type ExchangeRate {
  currency: String
  rate: String
  name: String
}
```

在 REST 中，我们受限于数据源所能提供的数据。如果你的 `/exchange-rates` 端点不包含 name，你必须连接一个新的端点比如 `/currency` 来得到数据或者在数据不存在的情况下创建它。

有了 GraphQL，我们可以检查字典，从而了解到 name 字段是可查询的。尝试在启动台右侧面板中添加name字段，然后运行。

```
{
  rates(currency: "USD") {
    currency
    rates {
      currency
      rate
      name
    }
  }
}
```

现在，把 name 字段删掉再重新执行查询。看到了你的查询结果的格式变化了吗？

![当你改变了你的查询的叙述方式，数据也随之改变。](https://cdn.css-tricks.com/wp-content/uploads/2017/12/shape-data.jpg)

你的 GraphQL 服务器总是忠实地返回你所要求的数据，不会多给。这和 REST 有很大不同 —— 在 REST 里你必须把数据过滤和转化成你的 UI 组件所需要的样子。这不仅仅节约了时间，而且还减少了加载和解析数据所需的网络负荷和 CPU 存储空间。

#### 2. 压缩你的状态管理模版

一般来说，获取数据包含了更新你的应用的状态。你通常需要编写代码来追踪至少三个行为：数据何时被加载、数据是否成功抵达、数据是否发生错误。一旦数据抵达，你必须把它转化为你的 UI 组件所期望的样子，对它进行标准化，缓存它，然后更新页面。 这个过程是重复性的，需要无数行模版代码来处理一个请求。

让我们来看看在这个例子中 [一个 React 应用例子沙盒](https://codesandbox.io/s/jvlrl98xw3) Apollo 客户端是如何消灭这个无趣的过程的。 查看 `list.js` 并把滚动条拖到底部。

```
export default graphql(ExchangeRateQuery, {
  props: ({ data }) => {
    if (data.loading) {
      return { loading: data.loading };
    }
    if (data.error) {
      return { error: data.error };
    }
    return {
      loading: false,
      rates: data.rates.rates
    };
  }
})(ExchangeRateList);
```

在这个例子里，[React Apollo](https://www.apollographql.com/docs/react/basics/integrations.html)，Apollo 客户端的 React 集成，把我们的汇率查询关联到 ExchangeRateList 组件。一旦 Apollo 客户端处理了那个查询， 它自动追踪加载和错误状态并把它放入 `data` prop 中去。当 Apollo 客户端收到结果，它会根据查询结果更新 `data` prop，然后按照在渲染中需要用到的汇率更新 UI。 

Apollo 客户端在底层为你完成了数据格式化和缓存工作。 尝试在右侧面板单击不同种类的货币看数据刷新。现在，再一次选择某个货币，看到数据如何立刻出现了吗？这是 Apollo 缓存在工作。不需要额外设置你就能免费从 Apollo 客户端获得这些。 😍 打开 `index.js` 来看我们初始化 Apollo 客户端的代码。

#### 3. 使用 Apollo DevTools 和 GraphiQL 快速进行调试

看起来 Apollo 客户端已经为你做了很多工作！我们该如何偷看一下它的内部来了解它是如何运行的呢？有了存储检查和查询与转变过程的完全可见化，Apollo DevTools 不但能回答这些疑问，还能让调试过程不再枯燥甚至变得有趣！ 🎉 这在一个为 Chrome 和 Firefox 提供的插件中可用，很快它也将对 React Native 提供服务。

如果你想要试用一下，按照之前的例子，在你喜欢的浏览器上 [安装 Apollo DevTools](https://github.com/apollographql/apollo-client-devtools)  然后导航到 [our CodeSandbox](https://codesandbox.io/s/jvlrl98xw3)。你需要在顶部导航栏点击“下载”，解压文件，运行 `npm install` 然后 `npm start` 来在本地运行这个例子。一旦你打开了浏览器的开发工具面板，你应该看到一个叫 Apollo 的标签页。

首先，我们来检查下存储检查器。这个标签页反映了 Apollo Client 缓存中的状态，让你更容易确定你的数据是不是正确地被存储在客户端了。

![存储检查器](https://cdn.css-tricks.com/wp-content/uploads/2017/12/1_WjEM653oIZUw4wQyjCqPkA.png)

Apollo DevTools 让你也可以在 GraphiQL 中测试你的查询和变更，它是一个交互式的查询编辑器和文档浏览器。事实上，我们在第一个例子中尝试添加字段时已经使用了 GraphiQL。为了方便回顾，当你在将查询输入编辑器时，GraphiQL 将会自动补全，并且自动生成基于 GraphQL 类型系统的文档。这对于拓展字典来说极为有用，不会给开发者带来任何维护成本。

![Apollo Devtools](https://cdn.css-tricks.com/wp-content/uploads/2017/12/1_s9Bl8jejFH2TAlZk2knFBQ.png)

尝试在 [我的启动台](https://launchpad.graphql.com/v7mnw3m03) 中右侧面板的 GraphiQL 中执行查询！鼠标停在查询编辑器的字段上，并单击提示框来打开文档浏览器。如果你的查询能在 GraphiQL 里成功运行，那你就可以100%肯定这条查询也可以在你的应用中成功运行。

### 升级你的 GraphQL 技能

好样的，你已经看到这儿了！ 👏 希望你喜欢这些例子，并且开始了解应该如何在前端使用 GraphQL 了。

想要了解更多？ 🌮 把 “继续学习 GraphQL” 列入你的2018新年计划吧！因为我希望它在新的一年里能够更加流行。下面是教你如何活用新学到的概念的应用实例：

* React: [https://codesandbox.io/s/jvlrl98xw3](https://codesandbox.io/s/jvlrl98xw3)
* Angular (Ionic): [https://github.com/aaronksaunders/ionicLaunchpadApp](https://github.com/aaronksaunders/ionicLaunchpadApp)
* Vue: [https://codesandbox.io/s/3vm8vq6kwq](https://codesandbox.io/s/3vm8vq6kwq)

继续使用 GraphQL 吧（记得关注我们的 Twitter [@apollographql](https://twitter.com/apollographql)）！ 🚀


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
