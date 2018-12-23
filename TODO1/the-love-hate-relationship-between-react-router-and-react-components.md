> * 原文地址：[The Love-Hate Relationship between React Router and React Components](https://blog.bitsrc.io/the-love-hate-relationship-between-react-router-and-react-components-dee4aac5956c)
> * 原文作者：[Kasra](https://blog.bitsrc.io/@KasraKhosravi?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-love-hate-relationship-between-react-router-and-react-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-love-hate-relationship-between-react-router-and-react-components.md)
> * 译者：[Augustwuli](https://github.com/Augustwuli)
> * 校对者：[RicardoCao-Biker](https://github.com/RicardoCao-Biker)

# React 路由和 React 组件的爱恨情仇

![](https://cdn-images-1.medium.com/max/800/1*kjZAT2HyYLv5gKT9SMBAHA.png)

来源：谷歌图片

作为 React 开发者，我们大部分人享用着使用 React Router 为 React 应用的路由带来的便利。

为什么我们 ❤️ React 路由：

*   与 React 完美结合并且遵循相同的原则
*   路由的导航方面非常容易理解
*   [组件组合、声明性 UI、状态管理](https://tylermcginnis.com/react-router-programmatically-navigate/) 并且它紧密地追随着 React 的工作流**（事件 => 状态变化 => 重新渲染）**
*   可靠的 [浏览历史特征](https://github.com/ReactTraining/react-router/blob/master/packages/react-router/docs/api/history.md) 允许用户在追踪视图状态的同时在应用中导航。

然而在使用 React 路由的时候，如果你的应用程序特定需求变得比你在 web 上的每个教程中看到的常规用法稍微复杂一些，你将面对一些困难。

好消息是即使在那些场景下，React 路由仍然允许我们以一种干净的方式解决问题；但是解决方案可能并不像一眼能开出来那么明显。这儿有个我们在 [Fjong](http:www.fjong.co) 开发团队 👗 的案例，我们在路由路径改变查询参数并且期望一个组件被重新渲染，React Router 的表现却不是那么回事儿。

在我们描述具体问题和我们如何解决这个问题之前，让我们聊聊 React 路由和 React 组件之间巨大关系的几个方面。

### 相爱关系

React 路由和 React 组件之间有很多的联系。这主要是因为它们都遵循上面提到的相同的事件循环**（事件 => 状态变化 => 重新渲染）**。现在记住这个流程，我们将解决在应用程序中导航的一个常见问题；**当路由更改的时候滚动到页面的顶部**。

假设你有一组名为 **Home**、**About** 和 **Search** 的组件

```
<Router history={History}>
  <Switch>
    <Route exact path="/" component={Home}/>
    <Route exact path="/about" component={About}/>
    <Route exact path="/search" component={Search}/>
    <Route exact component={NoMatch}/>
  </Switch>
</Router>
```

现在假设当你跳转至 `/search` 的时候，你需要滚动很多次才能在 Search 页面看到你想看到的项目。

然后，你在地址栏输入跳转至 `/about` 的链接，然后突然看到了 About Us 页面的底部，而不是顶部，这可能很烦人。这有一些方法解决这个问题，但是 React 路由为你提供了所有必要的工具来正确地完成这个任务。让我们来看看实际情况。

```
/* globals window */

/* Global Dependencies */
const React = require('react');
const { Component } = require('react');
const PropTypes = require('prop-types');
const { Route, withRouter } = require('react-router-dom');

class ScrollToTopRoute extends Component {

	componentDidUpdate(prevProps) {
		if (this.props.location.pathname !== prevProps.location.pathname) {
			window.scrollTo(0, 0);
		}
	}

	render() {
		const { component: Component, ...rest } = this.props;
    
		return <Route {...rest} render={props => (<Component {...props} />)} />;
	}
}

ScrollToTopRoute.propTypes = {
	path: PropTypes.string,
	location: PropTypes.shape({
		pathname: PropTypes.string,
	}),
	component: PropTypes.instanceOf(Component),
};

module.exports = withRouter(ScrollToTopRoute);

// Usage in App.jsx
<Router history={History}>
  <Switch>
    <ScrollToTopRoute exact path="/" component={Home}/>
    <ScrollToTopRoute exact path="/about" component={About}/>
    <ScrollToTopRoute exact path="/search" component={Search}/>
    <ScrollToTopRoute exact component={NoMatch}/>
  </Switch>
</Router>
```

### 讨厌的关系

但是对于任何关系来说，事情并不是在每种情况下都进展顺利。这与 React 路由和 React 组件的情况相同。为了更好地理解这一点，我们来看看应用程序中的一个可能的场景。

假设你要从 `/search` 至 `/about`，然后当你到达 About Us 页面时，页面显然会像你所期望的那样重新渲染。从 `/about` 导航到 `/search` 也是如此。

现在假设从 `/search?tags=Dresses` 至 `/search?tags=Bags` 的时候，你的 `SearchPage` 将搜索查询参数附加到 URL 上，并且你希望重新渲染这些参数。在这，我们更改了 React 路由路径 `location.path = /search` 上的搜索查询，它被 React 路由识别为同一位置对象上的属性 `location.search = ?tags=Dresses or ?tags=Bags`。

无论是 React 路由还是你的组件都没有意识到它们需要重新渲染页面，因为从技术上讲，我们还是在同一个页面。React 组件不允许在相同路径但是不同搜索查询间的路由跳转触发重新渲染。

目前我们的路由和组件似乎有点脱节。好难过 :(

所以，我们如何才能解决这个问题呢？其实他们每个人都有解决这个问题的方法。React 路由告诉我们 URL 中的搜索查询参数是否发生了变化而且更重要的是根据 React 正确的生命周期来做这件事。之后，组件将负责决定如何处理这些信息。

在这个案例中，如果组件需要重新渲染（由一个叫 `RouteKey` 的 boolean 属性（prop）决定）它将向组件传递一个唯一的键，该键是 `location.pathname` 和 `location.search` 的组合（这传递了键的一般经验法则，键应该是唯一的、稳定的和可预测的）在这个场景中，每当路由被请求，组件都能接受一个新的键；而且即使你停留在同一个页面，它也会为你重新渲染，没有任何副作用。我们来看看它是如何在实际中放回作用的！

```
/* globals window */

/** Global Dependencies */
const React = require('react');
const { Component } = require('react');
const PropTypes = require('prop-types');
const { Route, withRouter } = require('react-router-dom');

class ScrollToTopRoute extends Component {

	componentDidUpdate(prevProps) {
		if (this.props.location.pathname !== prevProps.location.pathname) {
			window.scrollTo(0, 0);
		}
	}

	render() {
		const { component: Component, RouteKey, location, ...rest } = this.props;

		/**
		 * Sometimes we need to force a React Route to re-render when the
		 * search params (query) in the url changes. React Router does not
		 * do this automatically if you are on the same page when the query
		 * changes. By passing the `RouteKey`ro the `ScrollToTopRoute` and
		 * setting it to true, we are passing the combination of pathname and
		 * search params as a unique key to the component and that is a enough
		 * and clear trigger for the component to re-render without side effects
		 */
		const Key = RouteKey ? location.pathname + location.search : null;

		return <Route {...rest} render={props => (<Component {...props} key={Key} />)} />;
	}
}

ScrollToTopRoute.propTypes = {
	path: PropTypes.string,
	location: PropTypes.shape({
		pathname: PropTypes.string,
	}),
	component: PropTypes.instanceOf(Component),
	RouteKey: PropTypes.boolean,
};

module.exports = withRouter(ScrollToTopRoute);

// Usage in App.jsx
<Router history={History}>
  <Switch>
    <ScrollToTopRoute exact path="/" component={Home}/>
    <ScrollToTopRoute exact path="/about" component={About}/>
    <ScrollToTopRoute exact path="/search" component={Search} RouteKey={true} />
    <ScrollToTopRoute exact component={NoMatch}/>
  </Switch>
</Router>
```

### 结论

我们介绍了React 路由和组件完美结合的例子，以及它们稍微分离时的场景。但是重要的是要记住，在大部分情况下，React 路由遵循和 React 相同的原则和设计模式，花时间熟悉这些原则及其相关的执行上下文，对于在 React 路由中修复 bug 会有很大帮助。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
