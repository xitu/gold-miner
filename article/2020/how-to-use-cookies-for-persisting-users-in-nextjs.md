> * 原文地址：[How to use cookies for persisting users in Nextjs](https://dev.to/debosthefirst/how-to-use-cookies-for-persisting-users-in-nextjs-4617)
> * 原文作者：[Adebola](https://dev.to/debosthefirst)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-use-cookies-for-persisting-users-in-nextjs.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-use-cookies-for-persisting-users-in-nextjs.md)
> * 译者：[plusmultiply0](https://github.com/plusmultiply0)
> * 校对者：

# 如何在 Nextjs 中使用 cookies 来持久化保存用户信息

## 使用 LocalStorage

在 React 或单页应用中有许多方式来持久化保存用户信息。大多数时候，开发者通常使用 localStorage 来保存以及按需加载用户数据。虽然这个方法可行，但不是最好的方法，因为它会让用户易于遭到攻击。使用 cookies 会相对安全但仍不是最安全的选择。就个人而言，我倾向于混合使用 cookies 和 JWT's [JSON Web tokens](https://jwt.io/) 来持久化用户会话和强制用户重新登陆当会话过期时。如何使用 JWT's [JSON Web tokens](https://jwt.io/) 不在本文的介绍范围内。

由于 LocalStorage 在服务器端是未定义的（因为服务器端没有 LocalStorage），所以在渲染路由前是不可能访问到 localStorage 的。如前所述，我们最好的做法是，在渲染路由前检查用户的 cookie 是否可用。

## 在 React/NextJS 中使用 cookies

为了在 NextJS 中使用 cookies，我们需要安装两个 packages。在本文中，我们将会使用 **cookie** 和 **react-cookie**。**React-cookie** 允许我们能从客户端设置 cookie 而 **cookie** 则让我们能访问于服务器端设置的 cookie。运行以下命令安装 packages。

```bash
npm install react-cookie cookie
```

[Cookie-cutter](https://npmjs.com/package/cookie-cutter) 功能类似 react-cookie，但是体积更小。

## 设置 cookie

With both packages installed, It's time to set a cookie. Usually, we set a cookie for a user once they've succesfully signed in or signed up to our application. To set a cookie on Sign in, follow the example below.  

```js
// pages/login.js
import { useCookies } from "react-cookie"

const Login = () => {
  const [setCookie] = useCookies(["user"])

  const handleSignIn = async () => {
    try {
      const response = await yourLoginFunction(username) //handle API call to sign in here.
      const data = response.data

      setCookie("user", JSON.stringify(data), {
        path: "/",
        maxAge: 3600, // Expires after 1hr
        sameSite: true,
      })
    } catch (err) {
      console.log(err)
    }
  }

  return (
    <>
      <label htmlFor="username">
        <input type="text" placeholder="enter username" />
      </label>
    </>
  )
}

export default Login
```

In the snippet above, we call the `setCookie` hook from `react-cookies` and set it to a default name. In our case, that's **user**. We then  
make a request to sign in a user by calling a function to log the user in. We take the response from that API call, stringify the data(cookies are formatted as text) and store that data in a cookie.

We also pass some additional options to the cookie including **path** \- makes sure your cookie is accessible in all routes, **maxAge**, how long from the time the cookie is set till it expires and **sameSite**. Samesite indicates that this cookie can only be used on the site it originated from - It is important to set this to true to avoid errors within firefox logs.

## 赋予 Cookie 访问应用的权限

To ensure that every route in our application has access to the cookie, we need to wrap our APP component in a cookie provider.

Inside `_app.js`, add the following bit of code.  

```js
// pages/_app.js
import { CookiesProvider } from "react-cookie"

export default function MyApp({ pageProps }) {
  return (
    <CookiesProvider>
      <Component {...pageProps} />
    </CookiesProvider>
  )
}
```

## [](#setting-up-the-function-to-parse-the-cookie)设置解析 cookie 的函数

Next, we need to setup a function that will check if the cookie exists on the server, parse the cookie and return it. Created a new folder called **helpers** and within that add an **index.js** file.

Inside this file, add the following piece of code.  

```js
// helpers/index.js

import cookie from "cookie"

export function parseCookies(req) {
  return cookie.parse(req ? req.headers.cookie || "" : document.cookie)
}
```

The function above accepts a request object and checks the request headers to find the cookie stored.

## 在组件中访问 cookie

Finally, we will use `getInitialProps` in our component to check if the user already has a valid cookie on the server side before rendering the requested route. An alternative to this approach is using `getServerSideProps`.  

```js
import { parseCookies } from "../helpers/"

export default function HomePage({ data }) {
  return (
    <>
      <div>
        <h1>Homepage </h1>
        <p>Data from cookie: {data.user}</p>
      </div>
    </>
  )
}

HomePage.getInitialProps = async ({ req }) => {
  const data = parseCookies(req)

if (res) {
    if (Object.keys(data).length === 0 && data.constructor === Object) {
      res.writeHead(301, { Location: "/" })
      res.end()
    }
  }

  return {
    data: data && data,
  }
}
```

Within `getInitialProps`, we're passing in the request object(req) that's available to us on the server-side in NextJS to the `parseCookies` function. This function returns the cookie to us which we can then send back to the client as props.

We also do a check on the server to see if the response object is available. The **res** object is only available on the server. If a user hits the **HomePage** route using **next/link** or **next/router**, the **res** object will not be available.

Using the **res** object, we check if there are cookies and if they're still valid. We do this check using the `res` object. If the `data` object is empty, it means the cookie isn't valid. If the cookie isn't valid, we then redirect the user back to the index page rather than showing a flash of the **HomePage** before redirecting the user.

Note that subsequent requests to pages containing `getInitialProps` **using next/link** or **next/router** will be done from the client side. i.e The cookie will be extracted from the client rather than the server side for other routes that are accessed via **using next/link** or **next/router**

And with that, you can now store cookies for users in your application, expire those cookies and secure your app to a good extent.

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
