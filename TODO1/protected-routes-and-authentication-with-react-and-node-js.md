> * 原文地址：[Protected routes and Authentication with React and Node.js](https://blog.strapi.io/protected-routes-and-authentication-with-react-and-node-js/)
> * 原文作者：[Strapi](https://blog.strapi.io/tag/strapi/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/protected-routes-and-authentication-with-react-and-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/protected-routes-and-authentication-with-react-and-node-js.md)
> * 译者：[ElizurHz](https://github.com/ElizurHz)
> * 校对者：[LeviDing](https://leviding.com)

# 用 React 和 Node.js 实现受保护的路由和权限验证

上周末我想挖掘一些没有 [Redux-Saga](https://github.com/redux-saga/redux-saga) 这种花里胡哨的东西的纯粹的 [React](https://reactjs.org/)。

所以我创建了一个小项目，在 [Strapi](https://strapi.io) — 一个包括了可扩展的管理后台面板和一些内置功能（授权，上传，权限控制...）的 Node.js 框架的配合下，仅使用 [Create React App](https://github.com/facebook/create-react-app) 创建一个小模板来实现授权流程。

![React Nodejs](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-21-at-10.42.51.png)

在本教程中，我们会使用 [Strapi](https://strapi.io) 的 API 提供的 [JSON Web Tokens](https://jwt.io/) 快速地实现基本的授权流程，并且会一步步教大家在 Strapi 中使用第三方登陆授权提供器（Facebook, GitHub, Google...）来授权你的用户登录（这可能会更有趣）。

![Strapi authentication](https://blog.strapi.io/content/content/images/2018/02/2018-02-20-19.41.11.gif)

**注: 本文的源代码可以在 [GitHub](https://github.com/strapi/strapi-examples/tree/master/good-old-react-authentication-flow) 上找到。**

## 创建项目

在开始之前，你需要创建一个 Strapi API：

```
$ npm install strapi@alpha -g
$ strapi new my-app
$ cd my-app && strapi start
```

和你的前端应用：

```
$ npm install create-react-app -g
$ create-react-app good-old-react-authentication-flow
```

**你需要 [先注册第一个用户](http://localhost:1337/admin)，然后就可以开始了！**

## 前端应用构架

我是 [React Boilerplate](https://github.com/react-boilerplate/react-boilerplate) 框架的忠实粉丝，所以我创建了一个类似的应用来组织我的代码：

```
/src
└─── containers // 与路由相关的 React 组件
|    └─── App // 应用的入口
|    └─── AuthPage // 负责所有授权页面的组件
|    └─── ConnectPage // 负责使用第三方提供器进行授权
|    └─── HomePage // 只能在用户登陆后访问到
|    └─── NotFoundPage // 404 组件
|    └─── PrivateRoute // 高阶组件
|
└─── components // 展示组件
|
└─── utils
     └─── auth
     └─── request // 使用 fetch 的网络请求辅助库
```

### 设置路由和 PrivateRoute

为了实现身份验证的视图，我们需要先创建一个 **HoC**：**高阶组件** 来检查是否用户可以访问一个特定的 URL。为此，我们只需要遵循 [官方文档](https://reacttraining.com/react-router/web/example/auth-workflow)，修改 `fakeAuth` 示例，并使用我们的 `auth.js` 辅助文件：

```
import React from 'react';  
import { Redirect, Route } from 'react-router-dom';

// Utils
import auth from '../../utils/auth';

const PrivateRoute = ({ component: Component, ...rest }) => (  
  <Route {...rest} render={props => (
    auth.getToken() !== null ? (
      <Component {...props} />
    ) : (
      <Redirect to={{
        pathname: 'auth/login',
        state: { from: props.location }
        }}
      />
    ):
  )} />
);

export default PrivateRoute;  
```

**然后我们来创建路由吧：**

```
import React, { Component } from 'react';  
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';

// Components
import AuthPage from '../../containers/AuthPage';  
import ConnectPage from '../../containers/ConnectPage';  
import HomePage from '../../containers/HomePage';  
import NotFoundPage from '../../containers/NotFoundPage';

// 这个组件是用于防止未登录用户访问特定路由的高阶组件
import PrivateRoute from '../../containers/PrivateRoute';

// Design
import './styles.css';

class App extends Component {  
  render() {
    return (
      <Router>
        <div className="App">
          <Switch>
            {/* A user can't go to the HomePage if is not authenticated */}
            <PrivateRoute path="/" component={HomePage} exact />
            <Route path="/auth/:authType/:id?" component={AuthPage} />
            <Route exact path="/connect/:provider" component={ConnectPage} />
            <Route path="" component={NotFoundPage} />
          </Switch>
        </div>
      </Router>
    );
  }
}

export default App;
```

### 创建授权视图

现在所有需要用于创建视图的路由都已经实现了。
我们声明路由的方式允许我们创建一个能够根据 `路径` 创建正确的表单的组件。

首先，让我们创建 `forms.json` 来处理在每个 auth 视图中创建表单的操作：

*   forgot-password
*   login
*   register
*   reset-password

`JSON` 结构如下所示（**你可以发现在 `Input` 组件中 `customBootstrapClass` 这个熟悉是必需的**）：

```
{
  "views": {    
    "login": [
      {
        "customBootstrapClass": "col-md-12",
        "label": "Username",
        "name": "identifier",
        "type": "text",
        "placeholder": "johndoe@gmail.com"
      },
      {
        "customBootstrapClass": "col-md-12",
        "label": "Password",
        "name": "password",
        "type": "password"
      },
      {
        "customBootstrapClass": "col-md-6",
        "label": "Remember me",
        "name": "rememberMe",
        "type": "checkbox"
      }
    ]
  },
  "data": {
    "login": {
      "identifier": "",
      "password": "",
      "rememberMe": false
    }
  }
}
```

**当路由变化时设置 state**

如果要在用户从路由 `auth/login` 切换到路由 `auth/register` 时设置表单，我们需要使用以下生命周期：

```
componentDidMount() {  
  // 使用一个函数生成表单以防
  // 表单在其他生命周期里重复
  this.generateForm(this.props);
}
```

```
componentWillReceiveProps(nextProps) {  
  // 因为我们对所有的 auth 视图使用同样的容器
  // 所以我们需要在路径改变的时候更新 UI
  if (nextProps.location.match.params.authType !== this.props.location.match.params.authType) {
    this.generateForm(nextProps);
  }
}
```

`generateForm` 方法负责从上面的 `forms.json` 文件中获取数据。

**创建视图**

要创建表单，我们只需要映射 `forms.json` 中的数据。

```
handleChange = ({ target }) => this.setState({ value: { ...this.state.value, [target.name]: target.value } });

render() {  
  const inputs = get(forms, ['views', this.props.match.params.authType, []);

  return (
    <div>
      <form onSubmit={this.handleSubmit}>
        {inputs.map((input, key) => (
          <Input
            autoFocus={key === 0}
            key={input.name}
            name={input.name}
            onChange={this.handleChange}
            type={input.type}
            value={get(this.state.value, [input.name], '')}
          />
        ))}
        <Button type="submit" />
      </form>
    </div>
  );
}
```

![Strapi login view](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-21-at-10.43.01.png)

那么此时，所有授权用户需要的视图都应该已经创建好了！我们只需要进行 API 调用即可访问该应用。

**将数据发布到 API**

为了进行 API 调用，我写了一个 `request` 的辅助文件（[你可以在这里访问 demo app](https://github.com/strapi/strapi-examples/tree/add-providers/good-old-react-authentication-flow/src/utils)），我们只需要在我们的 `handleSubmit` 函数中使用它：

```
handleSubmit = (e) => {  
  e.preventDefault();
  const body = this.state.value;
  const requestURL = 'http://localhost:1337/auth/local';

  request(requestURL, { method: 'POST', body: this.state.value})
    .then((response) => {
      auth.setToken(response.jwt, body.rememberMe);
      auth.setUserInfo(response.user, body.rememberMe);
      this.redirectUser();
    }).catch((err) => {
      console.log(err);
    });
}

redirectUser = () => {  
  this.props.history.push('/');
}
```

这里没有什么花里胡哨的操作，当我们获得了 API 的响应后，我们只要将所需的信息存到 `localStorage` 或者 `sessionStorage` 中，然后我们可以将用户重定向至 HomePage。

**我们刚实现了最困难的部分，因为使用像 Facebook 这样的第三方授权提供器非常容易！**

## 使用授权提供器

无论你选择 Facebook、GitHub 还是 Google，在 Strapi 使用第三方授权提供器来授权你的用户登陆是非常简单的 🙈。在这个例子中，我将为大家展示怎样使用 Facebook 的第三方授权提供器。

因为 Strapi（**还**）没有提供 Javascript SDK 来对接 Strapi 的 API 和 Facebook 的 API。

**具体流程如下**:

*   用户“点击使用 Facebook 登录”
*   将用户重定向至另一个页面，在那里他可以进行授权
*   授权之后，Facebook 会将用户重定向到你的应用里，并带在 URL 中附带一个 code
*   把这个 code 发送给 Strapi

此时，我们只需要在 `componentDidMount` 生命周期中发起 API 的请求，然后根据 `ConnectPage` 容器中的响应内容将用户重定向至相应页面：

```
componentDidMount() {  
  const { match: {params: { provider }}, location: { search } } = this.props;
  const requestURL = `http://localhost:1337/auth/${provider}/callback${search}`;

 request(requestURL, { method: 'GET' })
   .then((response) => {
      auth.setToken(response.jwt, true);
      auth.setUserInfo(response.user, true);
      this.redirectUser('/');
   }).catch(err => {
      console.log(err.response.payload)
      this.redirectUser('/auth/login');
   });
}

redirectUser = (path) => {  
  this.props.history.push(path);
}
```

**在 AuthPage 中显示授权提供器**

为此，我们需要一个如下所示的 `SocialLink` 组件：

```
/**
*
* SocialLink
*
*/

import React from 'react';  
import PropTypes from 'prop-types';

import Button from '../../components/Button'

function SocialLink({ provider }) {  
  return (
    <a href={`http://localhost:1337/connect/${provider}`} className="link">
      <Button type="button" social={provider}>
        <i className={`fab fa-${provider}`} />
        {provider}
      </Button>
    </a>
  );
}

SocialLink.propTypes = {  
  provider: PropTypes.string.isRequired,
};

export default SocialLink;
```

然后我们需要把它加入到 `AuthPage` 中：

```
render() {  
  const providers = ['facebook', 'github', 'google', 'twitter']; // 如果要把一个提供器移除，只要把它从这个数组中删除即可...

  return (
     <div>
       {providers.map(provider => <SocialLink provider={provider} key={provider} />)}
       {/* Some other code */}
     </div>
  );
}
```

![Login page](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-21-at-10.42.51.png)

**这些就是我们在前端应用中需要做的，现在只需要配置 Strapi 来启用第三方授权提供器 😎**

### 设置 Facebook 授权提供器来进行用户注册

到 [Facebook developers](https://developers.facebook.com/) 并且创建一个名叫 `test` 的应用。

*   在 product 区域添加 `Facebook login`
*   选择 `Web`
*   将 Site URL 设为 `http://localhost:3000`

![Facebook setup](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-20-at-18.08.35.png)

*   从 Dashboard 页面中拷贝 App Id 和 App Secret 到你的应用中

![Facebook setup](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-20-at-18.10.39.png)

*   在 `Facebook login` > `Advanced settings` 中，添加：`http://localhost:1337/connect/facebook/callback` 到 `Valid OAuth redirect URIs` 字段。

![Facebook setup](https://blog.strapi.io/content/images/2018/02/fb_settings.png)

### 配置 Strapi

现在你已经在 Facebook 上创建了一个可以用于配置你项目中 Facebook 提供器的应用。

到 [Users & Permissions 区域的 Providers 标签页](http://localhost:1337/admin/plugins/users-permissions/providers)，按照如下所示填写表单：

![Admin FB setup](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-20-at-18.54.48.png)

**不要忘记保存修改。**

## 结论

> 希望这个小教程可以帮助你使用 [React](https://reactjs.org/) 和 [Strapi](https://strapi.io) 进行用户授权登陆。

我认为这个工作量不大，而且很简单！你可以在 [这里](https://github.com/strapi/strapi-examples/tree/add-providers/good-old-react-authentication-flow) 找到这个周末我使用 Create React App 创建的模板。

[这里](https://github.com/strapi/strapi-examples/tree/master/login-react) 也有另一个使用 [React Boilerplate](https://github.com/react-boilerplate/react-boilerplate) 的完整的例子，它也是已经完整实现了整个授权的流程。第二个例子使用了 React 和 Redux-Saga，它也是我们用于构建基于 Strapi 的管理后台的模板。

大家可以分享并在评论中留言！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
