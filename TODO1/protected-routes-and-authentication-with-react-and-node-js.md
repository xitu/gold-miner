> * 原文地址：[Protected routes and Authentication with React and Node.js](https://blog.strapi.io/protected-routes-and-authentication-with-react-and-node-js/)
> * 原文作者：[Strapi](https://blog.strapi.io/tag/strapi/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/protected-routes-and-authentication-with-react-and-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/protected-routes-and-authentication-with-react-and-node-js.md)
> * 译者：
> * 校对者：

# 受保护的路由和使用React和Node.js进行身份验证

好吧，上周末我想挖掘一些好的单纯React而没有像Redux-Saga这样的花哨的东西。 [React](https://reactjs.org/) without fancy stuffs like [Redux-Saga](https://github.com/redux-saga/redux-saga).

所以我开始了这个项目来创建一个简单的例子，其中只有Create React App，用Strapi实现身份验证流程，这是一个Node.js框架，具有可扩展的管理面板和内置功能（身份验证，上传，权限...... ）。**[Create React App](https://github.com/facebook/create-react-app) to implement the authentication flow with [Strapi](https://strapi.io)**, a Node.js framework with an extensible admin panel and built-in features (authentication, upload, permissions...).

![React Nodejs](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-21-at-10.42.51.png)

在本教程中，我们将使用 **我们将快速实现基本身份验证流程[JSON Web Tokens](https://jwt.io/)** 这是由 [Strapi](https://strapi.io) API 提供的。 **如何使用身份验证提供程序（Facebook，GitHub，Google ...)。** Strapi进行身份验证你的用户.

![Strapi authentication](https://blog.strapi.io/content/content/images/2018/02/2018-02-20-19.41.11.gif)

_Note:本文的源代码可以在GitHub上找到。(https://github.com/strapi/strapi-examples/tree/master/good-old-react-authentication-flow)._

## 创建项目

首先，您需要创建一个Strapi API:

```
$ npm install strapi@alpha -g
$ strapi new my-app
$ cd my-app && strapi start
```

而且，创建前端应用程序：

```
$ npm install create-react-app -g
$ create-react-app good-old-react-authentication-flow
```

**您需要注册您的第一个用户，然后您就可以开始了！http://localhost:1337/admin) **

## 前端应用程序架构

我是[React Boilerplate]架构的忠实粉丝所以我创建了类似于组织我的代码的东西：(https://github.com/react-boilerplate/react-boilerplate) 

```
/src
└─── containers // React components associated with a Route
|    └─── App // The entry point of the application
|    └─── AuthPage // Component handling all the auth views
|    └─── ConnectPage // Handles the auth with a custom provider
|    └─── HomePage // Can be accessed only if the user is logged in
|    └─── NotFoundPage // 404 Component
|    └─── PrivateRoute // HoC
|
└─── components // Dummy components
|
└─── utils
     └─── auth
     └─── request // Request helper using fetch
```

### 路由器设置和PrivateRoute

要实现身份验证视图，我们首先需要创建一个HoC：Higher Order Component，它将检查用户是否可以访问特定的URL。  
为此，我们只需要遵循官方文档[the official documentation]并修改 `fakeAuth`示例并使用我们的 `auth.js`帮助器：

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

**让我们创建路由:**

```
import React, { Component } from 'react';  
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';

// Components
import AuthPage from '../../containers/AuthPage';  
import ConnectPage from '../../containers/ConnectPage';  
import HomePage from '../../containers/HomePage';  
import NotFoundPage from '../../containers/NotFoundPage';

// This component ios HoC that prevents the user from accessing a route if he's not logged in
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

### 创建验证视图

现在我们所有的路线都已实现，我们需要创建我们的视图。
我们声明路线的方式允许我们有一个组件负责根据创建正确的形式`location`.

首先，让我们创建一个`forms.json`文件来处理在每个auth视图上创建表单:

*   忘记密码
*   登录
*   注册
*   重置密码

这个结构`JSON`将如下所示（您可以看到组件中`customBootstrapClass`需要的键`Input`：

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

**在位置更改时设置状态**

要在用户导航时设置表单  `auth/login` ，`auth/register`我们需要使用以下生命周期：

```
componentDidMount() {  
  // Generate the form with a function to avoid code duplication
  // in other lifecycles
  this.generateForm(this.props);
}
```

```
componentWillReceiveProps(nextProps) {  
  // Since we use the same container for all the auth views we need to update
  // the UI on location change
  if (nextProps.location.match.params.authType !== this.props.location.match.params.authType) {
    this.generateForm(nextProps);
  }
}
```

该`generateForm` 方法负责从`forms.json`上面的文件中获取数据。

**创建视图**

要创建表单，我们只需要映射`forms.json`文件中的数据检索。 

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

那么，此时应该创建验证用户所需的所有视图！我们只需要进行API调用即可访问该应用。

**将数据发布到API**

要进行API调用，我有一个`request`帮助器（你可以进入演示应用程序），所以我们只需要在我们的 `handleSubmit` 函数中使用它： (https://github.com/strapi/strapi-examples/tree/add-providers/good-old-react-authentication-flow/src/utils)) 

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

没有什么花哨这里，一旦我们得到我们只是存储所需的信息无论是在该API的响应`sessionStorage`或者`sessionStorage`，我们把用户重定向到主页。

**好吧，我们刚刚实现了最困难的部分，因为使用像Facebook这样的自定义提供商很容易！**

## 使用身份验证提供程序

无论你选择的Facebook，GitHub上，甚至谷歌，使用供应商与Strapi验证你的用户是再次很容易🙈。在这个例子中，我将向您展示如何在Facebook上使用它

由于Strapi没有提供（还）一个Javascript SDK来弥补Strapi API和Facebook API之间的差距。

**流程如下**:

*   用户点击登录Facebook
*   它将他重定向到另一个页面，以便他可以授权该应用程序
*   获得授权后，Facebook会使用URL中的代码将用户重定向到您的应用
*   将此代码发送给Strapi

此时，我们只需要实现一个生命周期`componentDidMount`，该生命周期使API调用并根据`ConnectPage`容器中的响应重定向用户：

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

**在AuthPage中显示提供程序**

为此，我们需要一个`SocialLink`如下组件 :

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

我们需要将它添加到`AuthPage`:

```
render() {  
  const providers = ['facebook', 'github', 'google', 'twitter']; // To remove a provider from the list just delete it from this array...

  return (
     <div>
       {providers.map(provider => <SocialLink provider={provider} key={provider} />)}
       {/* Some other code */}
     </div>
  );
}
```

![Login page](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-21-at-10.42.51.png)

**那么这就是我们需要为前端应用程序做的事情，现在只需要设置Strapi来启用自定义提供商😎**

### 设置Facebook，以便我们注册我们的用户

转到[Facebook developers](https://developers.facebook.com/)开发人员并创建一个名为的应用程序`test`。 

*   在产品部分添加 `Facebook login`
*   选择 `Web`
*   设置 `http://localhost:3000` 为您的网站网址

![Facebook setup](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-20-at-18.08.35.png)

*   从应用程序的仪表板页面复制App Id和App Secret

![Facebook setup](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-20-at-18.10.39.png)

*   在 `Facebook login` > `Advanced settings` 页面中添加: `http://localhost:1337/connect/facebook/callback`其中`Valid OAuth redirect URIs` 区域.

![Facebook setup](https://blog.strapi.io/content/images/2018/02/fb_settings.png)

### 设置Strapi

现在您已经在Facebook上创建了应用程序，您需要在项目中配置Facebook提供程序。

转到 [Providers tab of the Users & Permissions section](http://localhost:1337/admin/plugins/users-permissions/providers) “用户和权限”部分的“提供者”选项卡，并填写如下表单：
![Admin FB setup](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-20-at-18.54.48.png)

_不要忘记保存您的修改。_

## 结论

> 随着 **希望这个小教程帮助您验证** with [React](https://reactjs.org/) and [Strapi](https://strapi.io).

在我看来，没什么可做的，而且很容易！无论如何 [here you can find the boilerplate](https://github.com/strapi/strapi-examples/tree/add-providers/good-old-react-authentication-flow)这个周末找到使用Create React App创建的样板文件。

另一个完整的例子是使用这里提供的[React Boilerplate](https://github.com/react-boilerplate/react-boilerplate) 它也已经实现了认证流程[here](https://github.com/strapi/strapi-examples/tree/master/login-react)。第二个例子使用了React，Redux-Saga，也是我们用来在Strapi上构建管理员的样板。


Also another full example using the which also has the authentication flow already implemented. This second example uses React, Redux-Saga and is also the boilerplate we used to build the admin on [Strapi](https://strapi.io).

随意分享，并在评论中给你反馈！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
