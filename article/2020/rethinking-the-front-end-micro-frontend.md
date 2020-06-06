> * 原文地址：[Rethinking the Front-end: Micro Frontend](https://medium.com/front-end-weekly/rethinking-the-front-end-micro-frontend-4cf21f0e22e)
> * 原文作者：[Ritesh Kumar](https://medium.com/@riteshiitbbs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/rethinking-the-front-end-micro-frontend.md](https://github.com/xitu/gold-miner/blob/master/article/2020/rethinking-the-front-end-micro-frontend.md)
> * 译者：[IAMSHENSH](https://github.com/IAMSHENSH)
> * 校对者：[刘海东](https://github.com/lhd951220) [X. Zhuo](https://github.com/z0gSh1u)

# 重新思考前端：微前端

![](https://cdn-images-1.medium.com/max/2000/1*8wFsg7DNlsY8IFpEr6_Szg.jpeg)

> 假设如今正在开发的大多数 Web 应用程序，都面临着类似的情况：前端变得越来越大，而与后端的相关性越来越小。

重新思考不同的前端框架如何共存，例如，使用 JQuery 或 AngularJS 1.x 构建的旧模块，与使用 React 或 Vue 构建的新模块联动。

#### 整体方法不适用于普遍的 Web 应用程序。

管理十个十人的项目，要比管理一个百人的大项目更简单。

可扩展性在这里是主要的构想。我们可以简化得到：

- 独立仓库
- 单独部署
- 更快速构建与发布
- 自主的团队
- 更轻松测试与处理

**举个例子:**

**Myapp.com/** - 静态 HTML 构建的登录页面.

**Myapp.com/settings** - 安装了 AngularJS 1.x 的陈旧设置模块。

**Myapp.com/dashboard** - 使用 React 构建的新仪表盘模块。

我可以想象它有以下需求：

- > 纯 JavaScript 的共享代码库，例如路由管理与用户会话管理。以及一些可共用的 CSS。两者都应该尽可能的轻量。
- > 在各种框架中设计的一系列“微型应用”独立模块，存储在不同的代码库中。
- > 一套部署架构，将不同代码库的模块都捆绑在一起，并在模块被修改时，将其更新到服务器。

**但事实证明，其他人也在思考同样的问题。典型术语是“微前端”。**

![来源: cygnismedia](https://cdn-images-1.medium.com/max/2100/1*rxsVRHNFdG-6gvOIUGAdcw.jpeg)

![来源: cygnismedia](https://cdn-images-1.medium.com/max/2896/1*rhF-hehEm-EN1lu8FnDvgw.png)

React 多年来发展迅捷，并且使开发人员的工作变得更轻松，是目前最流行的微前端框架.

## 实现微前端

以下是实现微前端的几种不同方法：

1. [**Single-SPA** “元框架”](https://github.com/CanopyTax/single-spa) 无须刷新，便可将多个框架组合在同一页面（参考组合了 React、 Vue、 Angular 1 与 Angular 2 等框架的[示例](https://single-spa.surge.sh/)）。[在这里参考 Bret Little 的解释](https://medium.com/@blittle/great-article-d618ef46161c)。
2. [**存在于不同 URL 的多个单页应用程序**](https://news.ycombinator.com/item?id=13011795)。 这些应用程序使用 NPM 或 Bower 组件来共享功能。
3. 通过[第三方库与 Window.postMessage API 配合](https://news.ycombinator.com/item?id=13009285)，将微应用隔离到 **IFrames** 中。
4. [**Web组件**作为集成层](https://technologyconversations.com/2015/08/09/including-front-end-web-components-into-microservices/)。
5. [**React** 的“黑盒”组件](https://news.ycombinator.com/item?id=13012916)。

阅读愉快！

干杯，
Ritesh :)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
