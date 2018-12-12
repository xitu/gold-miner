> * 原文地址：[Protected routes and Authentication with React and Node.js](https://blog.strapi.io/protected-routes-and-authentication-with-react-and-node-js/)
> * 原文作者：[Strapi](https://blog.strapi.io/tag/strapi/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/protected-routes-and-authentication-with-react-and-node-js.md](https://github.com/xitu/gold-miner/blob/master/TODO1/protected-routes-and-authentication-with-react-and-node-js.md)
> * 译者：
> * 校对者：

# Protected routes and Authentication with React and Node.js

Well, last weekend I wanted to dig into some good old [React](https://reactjs.org/) without fancy stuffs like [Redux-Saga](https://github.com/redux-saga/redux-saga).

So I started a side project to create a tiny boilerplate with nothing more than **[Create React App](https://github.com/facebook/create-react-app) to implement the authentication flow with [Strapi](https://strapi.io)**, a Node.js framework with an extensible admin panel and built-in features (authentication, upload, permissions...).

![React Nodejs](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-21-at-10.42.51.png)

In this tutorial we'll quickly implement the **basic authentication flow using [JSON Web Tokens](https://jwt.io/)** that a [Strapi](https://strapi.io) API provides but also, (which might be more interesting) how to use **authentication providers (Facebook, GitHub, Google...) with Strapi** to authenticate your users.

![Strapi authentication](https://blog.strapi.io/content/content/images/2018/02/2018-02-20-19.41.11.gif)

_Note: the source code of this article is [available on GitHub](https://github.com/strapi/strapi-examples/tree/master/good-old-react-authentication-flow)._

## Creating the project

Before all, you need to create a Strapi API:

```
$ npm install strapi@alpha -g
$ strapi new my-app
$ cd my-app && strapi start
```

And also, your front-end application:

```
$ npm install create-react-app -g
$ create-react-app good-old-react-authentication-flow
```

**You need to [register your first user](http://localhost:1337/admin) and then you're ready to go!**

## Front-end App Architecture

I'm a huge fan of the [React Boilerplate](https://github.com/react-boilerplate/react-boilerplate) architecture so I created something similar to organize my code:

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

### Router Setup and PrivateRoute

To implement the authentication views, we first need to create a **HoC**: _Higher Order Component_ that will check if a user can access a specific URL.  
To do so, we just need to follow [the official documentation](https://reacttraining.com/react-router/web/example/auth-workflow) and modify the `fakeAuth` example and use our `auth.js` helper:

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

**Let's create the routing:**

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

### Creating the Authentication Views

Now that all our routes are implemented we need the create our views.  
The way we declared our routes allows us to have one component that is responsible for creating the correct form according to the `location`.

First of all, let's create a `forms.json` file that will handle the creation of the form on each auth view:

*   forgot-password
*   login
*   register
*   reset-password

This structure of the `JSON` will be like the following (_you can see a `customBootstrapClass` key that is needed in the `Input` component_):

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

**Setting the state on location change**

To set the form when the user navigates from `auth/login` to `auth/register` we need to use the following lifecycles:

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

The `generateForm` method is in charge of getting the data from the `forms.json` file above.

**Creating the view**

To create the form we just need to map over the data retrieve in the `forms.json` file.

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

Well, at this point all the views needed for authenticating your users should be created! We just need to make the API call to access the app.

**Posting data to the API**

To make the API call, I have a `request` helper ([that you can get in the demo app](https://github.com/strapi/strapi-examples/tree/add-providers/good-old-react-authentication-flow/src/utils)) so we just need to use it in our `handleSubmit` function:

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

Nothing fancy here, once we get the response from the API we just store the needed informations in either the `localStorage` or the `sessionStorage` and we redirect the user to the HomePage.

**Well we just achieved the most difficult part because using a custom provider like Facebook is easy as pie!**

## Using a Authentication Provider

Whatever you choose Facebook, GitHub or even Google, using a provider for authenticating your users with Strapi is **_again_** really easy 🙈. In this example, I will show you how to use it with Facebook.

Since Strapi doesn't provide (**yet**) a Javascript SDK to bridge the gap between the Strapi API and the Facebook API.

**Here is the flow**:

*   The user clicks on login with Facebook
*   It redirects him to another page so he can authorize the app
*   Once authorized, Facebook redirects the user to your app with a code in the URL
*   Send this code to Strapi

At this point, we need to implement only one lifecycle `componentDidMount` which makes the API call and redirects the user depending on the response in the `ConnectPage` container:

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

**Displaying the Providers in the AuthPage**

To do so, we need a `SocialLink`component like the following:

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

And we need to add it to the `AuthPage`:

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

**Well that's pretty much what we need to do for the front-end application now just need to setup Strapi to enable custom providers 😎**

### Setting up Facebook so we can register our users

Go to [Facebook developers](https://developers.facebook.com/) and create an app called `test`.

*   In the product section add `Facebook login`
*   Select `Web`
*   Set `http://localhost:3000` as your website URL

![Facebook setup](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-20-at-18.08.35.png)

*   Copy for App Id and App Secret from the Dashboard page of your app

![Facebook setup](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-20-at-18.10.39.png)

*   In the `Facebook login` > `Advanced settings` add: `http://localhost:1337/connect/facebook/callback` in the `Valid OAuth redirect URIs` field.

![Facebook setup](https://blog.strapi.io/content/images/2018/02/fb_settings.png)

### Setting up Strapi

Now that you have created your app on Facebook you need to configure the Facebook provider in your project.

Go to [Providers tab of the Users & Permissions section](http://localhost:1337/admin/plugins/users-permissions/providers) and fill the form like the following:

![Admin FB setup](https://blog.strapi.io/content/images/2018/02/Screen-Shot-2018-02-20-at-18.54.48.png)

_Don't forget to save your modifications._

## Conclusion

> With the **hope that this small tutorial helped you authenticating your users** with [React](https://reactjs.org/) and [Strapi](https://strapi.io).

In my opinion, there is not much to do and it is very easy! Anyway [here you can find the boilerplate](https://github.com/strapi/strapi-examples/tree/add-providers/good-old-react-authentication-flow) which was created with Create React App from this weekend.

Also another full example using the [React Boilerplate](https://github.com/react-boilerplate/react-boilerplate) available [here](https://github.com/strapi/strapi-examples/tree/master/login-react) which also has the authentication flow already implemented. This second example uses React, Redux-Saga and is also the boilerplate we used to build the admin on [Strapi](https://strapi.io).

Feel free to share it and give you your feedback in the comments!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
