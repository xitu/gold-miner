> * 原文地址：[Separation of Data and Ui in your Web App](https://medium.com/front-end-weekly/separation-of-data-and-ui-in-your-web-app-2c3f1cc3fbda)
> * 原文作者：[Georgy Glezer](https://medium.com/@georgyglezer)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/separation-of-data-and-ui-in-your-web-app.md](https://github.com/xitu/gold-miner/blob/master/TODO1/separation-of-data-and-ui-in-your-web-app.md)
> * 译者：[fireairforce](https://github.com/fireairforce)
> * 校对者：[Roc](https://github.com/QinRoc)

# Web 应用程序中的数据和 UI 分离

大家好，我是 Georgy，是 **[Bringg](http://bringg.com/)** 的一个全栈开发人员，这是我写的第一篇文章。 😅

今天我想重点介绍一下在构建 web 应用程序时数据和 UI 分离的概念，它是怎样帮助你构建更清晰、更易于维护和更出色的 web 应用程序，以及我如何用 4 个不同的 UI/框架库呈现相同内容的一个小例子。😄

通常在任意的 web 应用程序中，都有两个主要部分：

* 数据
* UI

因此，你可以选择一个框架/UI 库，比如 React、Angular、Vue 等等，然后决定使用什么状态管理器，或者在没有状态管理器的情况下如何管理你的数据。

你开始写你的第一个功能，以一个用户列表为例，你有一个复选框来选择用户，然后你需要决定在哪里保存你当前选择的用户。

> 你是将它们保存在 React 组件的 state 里？或者把它们放在你的 redux store 里？亦或者是把它们放在你的 Angular 服务或 controller 里？
> 被选择的用户是否与你的数据有关？或者只是纯粹的视图指示器？

好的，我将和你分享编写功能的思路或想法，通过上面的例子，让你能更清晰地分离数据和 UI。

用户是我们应用程序中的数据，我们可以添加用户、修改用户数据、删除用户、从我们拥有的用户中获取诸如谁在线和用户总数之类的信息。

当我们显示一个用户列表时，我们只是以一种对用户更可见的方式来展示我们的数据，就像一个供用户查看的列表一样。我们允许他选择用户和取消选择用户，这只是视图的当前状态，页面上被选择的用户和数据没有任何关系，应该分离开。

通过这种分离，我们将 JavaScript 应用程序开发为纯 JavaScript 应用程序，然后选择我们想要表示数据的方式。这可以让我们获得最大的灵活性，比如在不同的地方使用不同的 UI 库，这组组件我想用 react 来表示，其它一些组件我想用 web 组件来表示，现在通过这种分离，我可以很容易实现这个想法。

> # 下面是我为展示这个概念而制作的一个示例：

我选择 [MobX](https://github.com/mobxjs/mobx) 来管理我的应用程序中的状态，并帮助我进行跨不同框架/UI 库的渲染。它具有出色的反应系统，可让你自动响应所需的事件。

我这里的 model 是 **Template**，它只有一个名称和 setter（MobX action）, 我在项目中保存了一个所有模板的列表，我用一个 `TemplateList` 来保存它，这是我全部的**数据**了。

![](https://cdn-images-1.medium.com/max/2424/1*sUeiUDg6QXbe08GrEyZNfg.png)

![](https://cdn-images-1.medium.com/max/2508/1*Klb2cKUIoGzbYmjxOFwcuA.png)

我的程序已经可以作为 JavaScript 应用程序运行了，我可以添加模板并更新它的文本，但我仍然没有它的 UI，让我们添加 React 来作为第一个 UI。

对于 React，我使用了 **[mobx-react](https://github.com/mobxjs/mobx-react)**，它是一个连接 MobX 的库，并使用其功能在 react 中渲染。

![](https://cdn-images-1.medium.com/max/3328/1*_jHARXfsu4DPvfK6G55lFg.png)

然后我选择另一个库，Vue JS。我保持几乎相同的 Html 和 CSS 类，只是用 Vue 来进行渲染。

我使用 MobX `autorun`(https://mobx.js.org/refguide/autorun.html) 并在每次添加或删除新模板时重新渲染视图。

![](https://cdn-images-1.medium.com/max/2168/1*k5ArS-smHdbb6rJlc2WMKQ.png)

现在，我们有了另一个 UI，它使用不同的库来渲染，但是基于相同的数据存储，而不需额外改变一行应用程序数据管理代码。

![](https://cdn-images-1.medium.com/max/3376/1*tGpOEofa1jIjxrwDQxqjLg.png)

因此现在屏幕有了更多的空间，我们还需要选择 2 个其它的库，这次我们选择 AngularJS。

AngularJS 的渲染有点烦人，因为它的 `ng-model` 把模型搞乱了，所以我不得不把模板的文本保存在一个对象中，然后在新模板上重新渲染。

![](https://cdn-images-1.medium.com/max/2620/1*rMgQ3As1LMKkb7GWLmn9Lg.png)

![](https://cdn-images-1.medium.com/max/3344/1*Z2M5mSR8Vc4TRQKCzkySDw.png)

最后一个库，我决定选择 [Preact](https://preactjs.com)，它和 React 很相似，在这里，我还是用 `autorun` 来更新 UI。

![](https://cdn-images-1.medium.com/max/2372/1*lqV2noA23HzDulsXr4OKLQ.png)

在这里，我还必须在每次更改时更新模板本身（类似于 mobx-react 所做的）。

![](https://cdn-images-1.medium.com/max/2112/1*gzHJHBLK-ImmilyTK2FXIA.png)

现在我们有 4 个不同的 UI/框架库，在同一个屏幕上显示相同的数据。

![](https://cdn-images-1.medium.com/max/6716/1*_Dccz9ks746qQAs4P20vYQ.png)

我真的很喜欢这种分离，它使代码更加清晰，因为它只需要管理 UI 状态，甚至只需要表示数据，它使得代码更易于维护和扩展。

希望你喜欢这个概念，如果有人有任何问题或想要讨论，或给我任何改进的意见，欢迎通过 [Facebook](https://www.facebook.com/gglezer) 或邮件 stolenng@gmail.com 与我交流。

以下是仓库和网站的链接：

[**stolenng/mobx-cross-data-example**](https://github.com/stolenng/mobx-cross-data-example)

[http://mobx-cross-data.georgy-glezer.com/](http://mobx-cross-data.georgy-glezer.com/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
