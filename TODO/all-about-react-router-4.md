
  > * 原文地址：[All About React Router 4](https://css-tricks.com/react-router-4/)
  > * 原文作者：[BRAD WESTFALL](https://css-tricks.com/author/bradwestfall/)
  > * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
  > * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/all-about-react-router-4.md](https://github.com/xitu/gold-miner/blob/master/TODO/all-about-react-router-4.md)
  > * 译者：[undead25](https://github.com/undead25)
  > * 校对者：

  # 关于 React Router 4 的一切

  我在 React Rally 2016 大会上第一次遇到了 [Michael Jackson](https://twitter.com/mjackson)，不久之后便写了一篇 [an article on React Router 3](https://css-tricks.com/learning-react-router/)。Michael 与 [Ryan Florence](https://twitter.com/ryanflorence) 一起，都是 React Router 的主要作者之一。遇到一位我非常喜欢的工具的创建者是激动人心的，但当他这么说的时候，我感到很震惊。“让我向你们展示我们在 React Router 4 的想法，它的**方式**是截然不同的！”。老实说，我真的不明白新的方向以及为什么它需要如此大的改变。由于路由是应用程序架构的重要组成部分，因此这可能会改变一些我喜欢的模式。这些改变的想法让我很焦虑。考虑到社区凝聚力以及 React Router 在这么多的 React 应用程序中扮演着重要的角色，我不知道社区将如何接受这些改变。

几个月后，[React Router 4](https://reacttraining.com/react-router/) 发布了，仅仅从 Twitter 的嗡嗡声中我便得知，对于这个重大的重写存在着不同的想法。这让我想起了第一个版本的 React Router 针对其渐进概念的推回。在某些方面，早期版本的 React Router 符合我们传统的思维模式，即一个应用的路由“应该”将所有的路由规则放在一个地方。然而，并不是每个人都接受使用嵌套的 JSX 路由。但就像 JSX 自身说服了批评者一样（至少是大多数），许多人都认为嵌套的 JSX 路由是很酷的想法。

如是，我学习了 React Router 4。无可否认，第一天是挣扎的。挣扎的倒不是其 API，而更多的是使用它的模式和策略。我使用 React Router 3 的思维模式并没有很好地迁移到 v4。如果要成功，我将不得不改变我对路由和布局组件之间的关系的看法。最终，出现了对我有意义的新模式，我对路由的新方向感到非常高兴。React Router 4 允许我做我使用 v3 能做的所有事情，而且更多。此外，起初我对 v4 的使用过于复杂。一旦我获得了一个新的思维模式，我就意识到这个新的方向是惊人的！

本文的意图并不是重复 React Router 4 [已写好的文档](https://reacttraining.com/react-router/)。我将介绍最常见的 API，但真正的重点是我发现成功的模式和策略。

对于本文，以下是一些你需要熟悉的 JavaScript 概念:

- React [（无状态）函数组件](https://facebook.github.io/react/docs/components-and-props.html)
- ES2015 [箭头函数](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions) 以及它们的“隐式返回”
- ES2015 [解构](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)
- ES2015 [模板字符串](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals)

如果你喜欢跳转到演示，你可以去：

[查看演示](https://codepen.io/bradwestfall/project/editor/XWNWge/?preview_height=50&amp;open_file=src/app.js)

### 新的 API 和新的思维模式

React Router 的早期版本将路由规则集中在一个位置，使它们与布局组件分离。当然，路由可以被划分成多个文件，但从概念上讲，路由是一个单元，基本上是一个美化的配置文件。

或许了解 v4 不同之处的最好方法是在每个版本中编写一个简单的两页应用程序并进行比较。示例应用程序只有两个路由，对应首页和用户页面。

这里是 v3 的：

```jsx
import { Router, Route, IndexRoute } from 'react-router'

const PrimaryLayout = props => (
  <div className="primary-layout">
    <header>
      Our React Router 3 App
    </header>
    <main>
      {props.children}
    </main>
  </div>
)

const HomePage =() => <div>Home Page</div>
const UsersPage = () => <div>Users Page</div>

const App = () => (
  <Router history={browserHistory}>
    <Route path="/" component={PrimaryLayout}>
      <IndexRoute component={HomePage} />
      <Route path="/users" component={UsersPage} />
    </Route>
  </Router>
)

render(<App />, document.getElementById('root'))
```

以下是 v3 中的一些关键概念，但在 v4 中是不正确的:

- 路由集中在一个地方。
- 布局和页面嵌套是通过 `<Route>` 组件的嵌套而来的。
- 布局和页面组件完全是路由的一部分。

React Router 4 不再主张集中式路由了。相反，路由规则位于布局和 UI 本身之间。例如，以下是 v4 中的相同的应用程序：

```jsx
import { BrowserRouter, Route } from 'react-router-dom'

const PrimaryLayout = () => (
  <div className="primary-layout">
    <header>
      Our React Router 4 App
    </header>
    <main>
      <Route path="/" exact component={HomePage} />
      <Route path="/users" component={UsersPage} />
    </main>
  </div>
)

const HomePage =() => <div>Home Page</div>
const UsersPage = () => <div>Users Page</div>

const App = () => (
  <BrowserRouter>
    <PrimaryLayout />
  </BrowserRouter>
)

render(<App />, document.getElementById('root'))
```

**新的 API 概念**：由于我们的应用程序是用于浏览器的，所以我们需要将它封装在来自 v4 的 `BrowserRouter` 中。还要注意的是我们现在从 `react-router-dom` 中导入它（这意味着我们安装的是 `react-router-dom` 而不是 `react-router`）。提示！现在叫做 `react-router-dom` 是因为还有一个 [native version](https://reacttraining.com/react-router/native)。

对于使用 React Router v4 构建的应用程序，首先看到的是“路由”似乎丢失了。在 v3 中，路由是我们的应用程序直接呈现给 DOM 的最巨大的东西。 现在，除了 `<BrowserRouter>` 外，我们首先抛给 DOM 的是我们的应用程序本身。

另一个在 v3 的例子中有而在 v4 中没有的是，使用 `{props.children}` 来嵌套组件。这是因为在 v4 中，`<Route>` 组件在何处编写，如果路由匹配，子组件将在那里渲染。

### 包容性路由

在前面的例子中，你可能已经注意到了 `exact` 这个属性。那么它是什么呢？V3 的路由规则是“排他性”的，这意味着只有一条路由将获胜。V4 的路由默认为“包含”的，这意味着多个 `<Route>` 可以同时进行匹配和渲染。

在上一个例子中，我们试图根据路径渲染 `HomePage` 或者 `UsersPage`。如果从示例中删除了 `exact` 属性，那么在浏览器中访问 `/users` 时，`HomePage` 和 `UsersPage` 组件将同时渲染。

要更好地了解匹配逻辑，请查看 [path-to-regexp](https://www.npmjs.com/package/path-to-regexp)，这是 v4 现在正在使用的，以确定路由是否匹配 URL。

为了演示包容性路由是有帮助的，我们在标题中包含一个 `UserMenu`，但前提是我们在应用程序的用户部分：

```jsx
const PrimaryLayout = () => (
  <div className="primary-layout">
    <header>
      Our React Router 4 App
      <Route path="/users" component={UsersMenu} />
    </header>
    <main>
      <Route path="/" exact component={HomePage} />
      <Route path="/users" component={UsersPage} />
    </main>
  </div>
)
```

现在，当用户访问 `/users` 时，两个组件都会渲染。类似这样的事情在 v3 中通过特定的匹配模式也是可行的，但它更复杂。得益于 v4 的包容性路由，现在能够很轻松地实现。

### 排他性路由

如果你只需要在路由列表里匹配一个路由，则使用 `<Switch>` 来启用排他路由：

```jsx
const PrimaryLayout = () => (
  <div className="primary-layout">
    <PrimaryHeader />
    <main>
      <Switch>
        <Route path="/" exact component={HomePage} />
        <Route path="/users/add" component={UserAddPage} />
        <Route path="/users" component={UsersPage} />
        <Redirect to="/" />
      </Switch>
    </main>
  </div>
)
```

在给定的 `<Switch>` 路由中只有一条将渲染。在 `HomePage` 路由上，我们仍然需要 `exact` 属性，尽管我们会先把它列出来。否则，当访问诸如 `/users` 或 `/users/add` 的路径时，主页路由也将匹配。事实上，战略布局是使用排他路由策略（因为它总是与传统路由一起使用）时的关键。请注意，我们在 `/users` 之前策略性地放置了 `/ users/add` 的路由，以确保正确匹配。由于路径 `/users/add` 将匹配 `/users` 和 `/users/add`，所以最好先把 `/users/add` 放在前面。

当然，如果我们以某种方式使用 `exact`，我们可以把它们放在任何顺序上，但至少我们有选择。

如果遇到，`<Redirect>` 组件将会始终执行浏览器重定向，但是当它位于 `<Switch>` 语句中时，只有在其他路由不匹配的情况下，才会渲染重定向组件。想了解在非切换环境下如何使用 `<Redirect>`，请参阅下面的**授权路由**。

### “根路由”和“未找到”

尽管在 v4 中已经没有 `<IndexRoute>` 了，但可以使用 `<Route exact>` 来达到同样的效果。如果没有路由解析，则可以使用 `<Switch>` 与 `<Redirect>` 重定向到具有有效路径的默认页面（如同我对本示例中的 `HomePage` 所做的），甚至可以是一个未找到页面。

### 嵌套布局

你可能开始期待嵌套子布局，以及如何实现它们。我不认为我会纠结这个概念，但我确实做到了。React Router v4 给了我们很多选择，这使它变得很强大。但是，选择意味着有选择不理想策略的自由。表面上看，嵌套布局很简单，但根据你的选择，可能会因为你组织路由的方式而遇到阻碍。

为了演示，假设我们想扩展我们的用户部分，所以我们会有一个“用户列表”页面和一个“用户详情”页面。我们也希望产品也有类似的页面。用户和产品都需要其个性化的子布局。例如，每个可能都有不同的导航选项卡。有几种方法可以解决这个问题，有的好，有的不好。第一种方法不是很好，但我想告诉你，这样你就不会掉入这个陷阱。第二种方法要好很多。

首先，我们修改 `PrimaryLayout`，以适应用户和产品对应的列表及详情页面：

```jsx
const PrimaryLayout = props => {
  return (
    <div className="primary-layout">
      <PrimaryHeader />
      <main>
        <Switch>
          <Route path="/" exact component={HomePage} />
          <Route path="/users" exact component={BrowseUsersPage} />
          <Route path="/users/:userId" component={UserProfilePage} />
          <Route path="/products" exact component={BrowseProductsPage} />
          <Route path="/products/:productId" component={ProductProfilePage} />
          <Redirect to="/" />
        </Switch>
      </main>
    </div>
  )
}
```

虽然这在技术上可行的，但仔细观察这两个用户页面就会发现问题：

```jsx
const BrowseUsersPage = () => (
  <div className="user-sub-layout">
    <aside>
      <UserNav />
    </aside>
    <div className="primary-content">
      <BrowseUserTable />
    </div>
  </div>
)

const UserProfilePage = props => (
  <div className="user-sub-layout">
    <aside>
      <UserNav />
    </aside>
    <div className="primary-content">
      <UserProfile userId={props.match.params.userId} />
    </div>
  </div>
)
```

**新 API 概念**：`props.match` 被赋到由 `<Route>` 渲染的任何组件。你可以看到，`userId` 是由 `props.match.params` 提供的，了解更多请参阅 [v4 文档](https://reacttraining.com/react-router/web/example/url-params)。或者，如果任何组件需要访问 `props.match`，而这个组件没有由 `<Route>` 直接渲染，那么我们可以使用 [withRouter()](https://reacttraining.com/react-router/web/api/withRouter) 高阶组件。

每个用户页面不仅要渲染其各自的内容，而且还必须关注子布局本身（并且每个子布局都是重复的）。虽然这个例子很小，可能看起来微不足道，但重复的代码在一个真正的应用程序中可能是一个问题。更不用说，每次 `BrowseUsersPage` 或 `UserProfilePage` 被渲染时，它将创建一个新的 `UserNav` 实例，这意味着所有的生命周期方法都将重新开始。如果导航标签需要初始网络流量，这将导致不必要的请求 —— 这都是因为我们决定如何使用路由。

这里有另一种更好的方法：

```jsx
const PrimaryLayout = props => {
  return (
    <div className="primary-layout">
      <PrimaryHeader />
      <main>
        <Switch>
          <Route path="/" exact component={HomePage} />
          <Route path="/users" component={UserSubLayout} />
          <Route path="/products" component={ProductSubLayout} />
          <Redirect to="/" />
        </Switch>
      </main>
    </div>
  )
}
```

与每个用户和产品页面相对应的四条路由不同，我们为每个部分的布局提供了两条路由。

请注意，上述示例没有使用 `exact` 属性，因为我们希望 `/users` 匹配任何以 `/users` 开头的路由，同样适用于产品。

通过这种策略，渲染其它路由将成为子布局的任务。`UserSubLayout` 可能如下所示：

```jsx
const UserSubLayout = () => (
  <div className="user-sub-layout">
    <aside>
      <UserNav />
    </aside>
    <div className="primary-content">
      <Switch>
        <Route path="/users" exact component={BrowseUsersPage} />
        <Route path="/users/:userId" component={UserProfilePage} />
      </Switch>
    </div>
  </div>
)
```

新策略中最明显的胜出在于所有用户页面之间的不重复布局。这是一个双赢，因为它不会像第一个示例那样具有相同生命周期的问题。

有一点需要注意的是，即使我们在布局结构中深入嵌套，路由仍然需要识别它们的完整路径才能匹配。为了节省重复输入（以防你决定将“用户”改为其他内容），请改用 `props.match.path`：

```jsx
const UserSubLayout = props => (
  <div className="user-sub-layout">
    <aside>
      <UserNav />
    </aside>
    <div className="primary-content">
      <Switch>
        <Route path={props.match.path} exact component={BrowseUsersPage} />
        <Route path={`${props.match.path}/:userId`} component={UserProfilePage} />
      </Switch>
    </div>
  </div>
)
```

### Match

As we've seen so far, `props.match` is useful for knowing what `userId` the profile is rendering and also for writing our routes. The `match` object gives us several properties including `match.params`, `match.path`, `match.url` and [several more](https://reacttraining.com/react-router/web/api/match).

#### **match.path** vs **match.url**

The differences between these two can seem unclear at first. Console logging them can sometimes reveal the same output making their differences even more unclear. For example, both these console logs will output the same value when the browser path is `/users`:

```
const UserSubLayout = ({ match }) => {
  console.log(match.url)   // output: "/users"
  console.log(match.path)  // output: "/users"
  return (
    <div className="user-sub-layout">
      <aside>
        <UserNav />
      </aside>
      <div className="primary-content">
        <Switch>
          <Route path={match.path} exact component={BrowseUsersPage} />
          <Route path={`${match.path}/:userId`} component={UserProfilePage} />
        </Switch>
      </div>
    </div>
  )
}
```

**ES2015 Concept:**`match` is being [destructured](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) at the parameter level of the component function. This means we can type `match.path` instead of `props.match.path`.

While we can't see the difference yet, `match.url` is the actual path in the browser URL and `match.path` is the path written for the router. This is why they are the same, at least so far. However, if we did the same console logs one level deeper in `UserProfilePage` and visit `/users/5` in the browser, `match.url` would be `"/users/5"` and `match.path` would be `"/users/:userId"`.

### Which to choose?

If you're going to use one of these to help build your route paths, I urge you to choose `match.path`. Using `match.url` to build route paths will eventually lead a scenario that you don't want. Here's a scenario which happened to me. Inside a component like `UserProfilePage` (which is rendered when the user visits `/users/5`), I rendered sub components like these:

```
const UserComments = ({ match }) => (
  <div>UserId: {match.params.userId}</div>
)

const UserSettings = ({ match }) => (
  <div>UserId: {match.params.userId}</div>
)

const UserProfilePage = ({ match }) => (
  <div>
    User Profile:
    <Route path={`${match.url}/comments`} component={UserComments} />
    <Route path={`${match.path}/settings`} component={UserSettings} />
  </div>
)
```

To illustrate the problem, I'm rendering two sub components with one route path being made from `match.url` and one from `match.path`. Here's what happens when visiting these pages in the browser:

- Visiting `/users/5/comments` renders "UserId: undefined".
- Visiting `/users/5/settings` renders "UserId: 5".

So why does `match.path` work for helping to build our paths and `match.url` doesn't? The answer lies in the fact that `{${match.url}/comments}` is basically the same thing as if I had hard-coded `{'/users/5/comments'}`.  Doing this means the subsequent component won't be able to fill `match.params` correctly because there were no params in the path, only a hardcoded `5`.

It wasn't until later that I saw [this part of the documentation](https://reacttraining.com/react-router/core/api/match) and realized how important it was:

> match:
>
> - path - (string) The path pattern used to match. **Useful for building nested `<Route>`s**
> - url - (string) The matched portion of the URL. **Useful for building nested `<Link>`s**

### Avoiding Match Collisions

Let's assume the app we're making is a dashboard so we want to be able to add and edit users by visiting `/users/add` and `/users/5/edit`. But with the previous examples, `users/:userId` already points to a `UserProfilePage`. So does that mean that the route with `users/:userId` now needs to point to yet another sub-sub-layout to accomodate editing and the profile? I don't think so. Since both the edit and profile pages share the same user-sub-layout, this strategy works out fine:

```
const UserSubLayout = ({ match }) => (
  <div className="user-sub-layout">
    <aside>
      <UserNav />
    </aside>
    <div className="primary-content">
      <Switch>
        <Route exact path={props.match.path} component={BrowseUsersPage} />
        <Route path={`${match.path}/add`} component={AddUserPage} />
        <Route path={`${match.path}/:userId/edit`} component={EditUserPage} />
        <Route path={`${match.path}/:userId`} component={UserProfilePage} />
      </Switch>
    </div>
  </div>
)
```

Notice that the add and edit routes strategically come before the profile route to ensure there the proper matching. Had the profile path been first, visiting `/users/add` would have matched the profile (because "add" would have matched the `:userId`.

Alternatively, we can put the profile route first if we make the path `${match.path}/:userId(\\d+)` which ensures that `:userId` must be a number. Then visiting `/users/add` wouldn't create a conflict. I learned this trick in the docs for [path-to-regexp](https://github.com/pillarjs/path-to-regexp#custom-match-parameters).

### Authorized Route

It's very common in applications to restrict the user's ability to visit certain routes depending on their login status. Also common is to have a "look-and-feel" for the unauthorized pages (like "log in" and "forgot password") vs the "look-and-feel" for the authorized ones (the main part of the application). To solve each of these needs, consider this main entry point to an application:

```
class App extends React.Component {
  render() {
    return (
      <Provider store={store}>
        <BrowserRouter>
          <Switch>
            <Route path="/auth" component={UnauthorizedLayout} />
            <AuthorizedRoute path="/app" component={PrimaryLayout} />
          </Switch>
        </BrowserRouter>
      </Provider>
    )
  }
}
```

Using [react-redux](https://github.com/reactjs/react-redux) works very similarly with React Router v4 as it did before, simply wrap `<BrowserRouter>` in `<Provider>` and it's all set.

There are a few takeaways with this approach. The first being that I'm choosing between two top-level layouts depending on which section of the application we're in. Visiting paths like `/auth/login` or `/auth/forgot-password` will utilize the `UnauthorizedLayout` — one that looks appropriate for those contexts. When the user is logged in, we'll ensure all paths have an `/app` prefix which uses `AuthorizedRoute` to determine if the user is logged in or not. If the user tries to visit a page starting with `/app` and they aren't logged in, they will be redirected to the login page.

`AuthorizedRoute` isn't a part of v4 though. I made it myself [with the help of v4 docs](https://reacttraining.com/react-router/web/example/auth-workflow). One amazing new feature in v4 is the ability to create your own routes for specialized purposes. Instead of passing a `component` prop into `<Route>`, pass a `render` callback instead:

```
class AuthorizedRoute extends React.Component {
  componentWillMount() {
    getLoggedUser()
  }

  render() {
    const { component: Component, pending, logged, ...rest } = this.props
    return (
      <Route {...rest} render={props => {
        if (pending) return <div>Loading...</div>
        return logged
          ? <Component {...this.props} />
          : <Redirect to="/auth/login" />
      }} />
    )
  }
}

const stateToProps = ({ loggedUserState }) => ({
  pending: loggedUserState.pending,
  logged: loggedUserState.logged
})

export default connect(stateToProps)(AuthorizedRoute)
```

While your login strategy might differ from mine, I use a network request to `getLoggedUser()` and plug `pending` and `logged` into Redux state. `pending` just means the request is still in route.

Click here to see a fully working [Authentication Example at CodePen](https://codepen.io/bradwestfall/project/editor/XWNWge/?preview_height=50&amp;open_file=src/app.js).

[![](https://res.cloudinary.com/css-tricks/image/upload/f_auto,q_auto/v1502066098/rr4_jmydzy.gif)](https://codepen.io/bradwestfall/project/editor/XWNWge/?preview_height=50&amp;open_file=src/app.js)

### Other mentions

There's a lot of other cool aspects React Router v4. To wrap up though, let's be sure to mention a few small things so they don't catch you off guard.

#### **<Link>** vs **<NavLink>**

In v4, there are two ways to integrate an anchor tag with the router: [`<Link>`](https://reacttraining.com/react-router/web/api/Link) and [`<NavLink>`](https://reacttraining.com/react-router/web/api/NavLink)

`<NavLink>` works the same as `<Link>` but gives you some extra styling abilities depending on if the `<NavLink>` matches the browser's URL. For instance, in the [example application](https://codepen.io/bradwestfall/project/editor/XWNWge/#), there is a `<PrimaryHeader>` component that looks like this:

```
const PrimaryHeader = () => (
  <header className="primary-header">
    <h1>Welcome to our app!</h1>
    <nav>
      <NavLink to="/app" exact activeClassName="active">Home</NavLink>
      <NavLink to="/app/users" activeClassName="active">Users</NavLink>
      <NavLink to="/app/products" activeClassName="active">Products</NavLink>
    </nav>
  </header>
)
```

The use of `<NavLink>` allows me to set a class of `active` to whichever link is active. But also, notice that I can use `exact` on these as well. Without `exact` the home page link would be active when visiting `/app/users` because of the inclusive matching strategies of v4. In my personal experiences, `<NavLink>` with the option of `exact` is a lot more stable than the v3 `<Link>` equivalent.

#### URL Query Strings

There is no longer way to get the query-string of a URL from React Router v4. It seems to me that the [decision was made](https://github.com/ReactTraining/react-router/issues/4410) because there is no standard for how to deal with complex query strings. So instead of v4 baking an opinion into the module, they decided to just let the developer choose how to deal with query strings. This is a good thing.

Personally, I use [query-string](https://www.npmjs.com/package/query-string) which is made by the always awesome [sindresorhus](https://twitter.com/sindresorhus).

#### Dynamic Routes

One of the best parts about v4 is that almost everything (including `<Route>`) is just a React component. Routes aren't magical things anymore. We can render them conditionally whenever we want. Imagine an entire section of your application is available to route to when certain conditions are met. When those conditions aren't met, we can remove routes. We can even do some crazy cool [recursive route](https://reacttraining.com/react-router/web/example/recursive-paths) stuff.

React Router 4 is easier because it's [Just Components™](https://youtu.be/Mf0Fy8iHp8k?t=3m22s)


  ---

  > [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
  