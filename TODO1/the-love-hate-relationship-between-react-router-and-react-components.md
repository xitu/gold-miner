> * 原文地址：[The Love-Hate Relationship between React Router and React Components](https://blog.bitsrc.io/the-love-hate-relationship-between-react-router-and-react-components-dee4aac5956c)
> * 原文作者：[Kasra](https://blog.bitsrc.io/@KasraKhosravi?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-love-hate-relationship-between-react-router-and-react-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-love-hate-relationship-between-react-router-and-react-components.md)
> * 译者：
> * 校对者：

# The Love-Hate Relationship between React Router and React Components

![](https://cdn-images-1.medium.com/max/800/1*kjZAT2HyYLv5gKT9SMBAHA.png)

Source: Google Images

As React developers, a majority of us enjoy working with React Router and how well it fits our React application.

Why we ❤️ React Router:

*   Works perfectly with React and follows the same principles
*   The navigational aspect of the Router is really easy to understand
*   [Component composition, declarative UI, state management](https://tylermcginnis.com/react-router-programmatically-navigate/) and how closely it follows React’s main flow **(event => state change => re-render)**
*   Reliable [browsing history feature](https://github.com/ReactTraining/react-router/blob/master/packages/react-router/docs/api/history.md) that allows users to navigate throughout the app while keeping track of the view state

However, you will face some roadblocks while using React Router if your application-specific needs become a little more complicated than the regular usage you see on every tutorial on the web.

The good news is that even in those scenarios, React Router still allows us to solve problems in a clean way; but the solution might not be as obvious in the first glance. That was the case for us at [Fjong](http:www.fjong.co) dev team👗 when we were changing the query params in the route path and expected a Component re-render, but that was not the case.

Before we dive into this specific issue and how we solved it, Lets us talk about few aspects of the great relationship between React Router and React Components.

### Love Relationship

React Router and React Components have a great relationship together. This mostly falls into the pattern that both of them follow the same event loop that was mentioned above **(event => state change => re-render)**. Now by having this flow in mind, we are gonna fix a common issue in navigating through the application; **scrolling to the top of the page when the route changes**.

Imagine you have a set of components named **Home**, **About** and **Search**

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

Now imagine that when you go to `/search`, you need to do a lot of scrolling to see your favorite item in the SearchPage.

Next, you enter a link in the header to go to the `/about` and then suddenly you are seeing the bottom of the About Us page instead of the top which can be annoying. There are many ways to solve this issue but React Router gives you all of the necessary tools to do this task clean and proper. Let’s see this in action.

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

### Hate Relationship

But as for any relationship, things do not go well in every situation. That is the same case for React Router and React Components. To better understand this, let's walk through a possible scenario in your application.

Imagine that you navigate from `/search` to `/about`, and when you get to the About Us, the page obviously re-renders as you would expect. Same goes for navigating from `/about` to `/search`.

Now imagine that your `SearchPage` is attaching search query parameters to the URL and you would expect a re-render when navigating from `/search?tags=Dresses` to `/search?tags=Bags`. Here we are changing the search query on the ReactRouter path `location.path = /search` which is recognized by ReactRouter as a property on the same location object `location.search = ?tags=Dresses or ?tags=Bags`

Neither React Router nor your component realizes that they need to re-render the page because technically we are on the same page. React Component disagrees with you on the terms that navigating between two routes that are on the same path but have different search queries qualifies for a re-render.

Our Route and Component seem a little detached at the moment. How sad :(

So, how can we fix this issue? Well, it turns out that each one of them has a piece of the puzzle that would fix the issue. React Router can tell us if the search query params in the URL has changed and more importantly do this in accordance with React’s correct life cycles. After that, it would be Component’s responsibility to decide what to do with that information.

In this case, if the component needed the re-render (is specified by a boolean prop called `RouteKey`) it will pass a unique key to the component which would be a combination of `location.pathname` and `location.search`. (This passes the general rule of thumb for Keys that should be **unique**, **stable** and **predictable**). In this scenario, the component receives a new key everytime the Route is requested; and even you are staying on the same page, it will re-render the page for you without any bad side effects. Shall we take a look and see how it works in practice!

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

### Conclusion

We covered examples where React Router and Component work perfectly together and scenarios when they are a little bit detached. But the main thing to remember is that for the most parts, React Router follows the same principles and design patterns that React does and taking the time to get familiar with those principles and their relative execution contexts would help immensely when bug fixing in React Router.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
