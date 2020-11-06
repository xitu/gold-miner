> * 原文地址：[How to use cookies for persisting users in Nextjs](https://dev.to/debosthefirst/how-to-use-cookies-for-persisting-users-in-nextjs-4617)
> * 原文作者：[Adebola](https://dev.to/debosthefirst)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-use-cookies-for-persisting-users-in-nextjs.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-use-cookies-for-persisting-users-in-nextjs.md)
> * 译者：
> * 校对者：

# How to use cookies for persisting users in Nextjs

## With LocalStorage

There are a number of ways to persist users in a React or Single Page Appplication. A lot of times, devs generally use localStorage to store user data and load the data from there when required. While this approach works, it's not the most effective way as it leaves users vulnerable to attacks. Using cookies is a little safer although it's still not the safest option. Personally, I prefer a mixture of using cookies and JWT's [JSON Web tokens](https://jwt.io/) with expiry to persist user session and to force a user to re-login when their session expires. Using JWT's is out of the scope of this article.

As LocalStorage is undefined on the server-side(since localStorag does not exist on the server), it's impossible to access localStorage before rendering a route. As such, our best bet is to check if a user's cookie is valid on the server side before rendering a route.

## Getting started using cookies in React/NextJS

To use cookies in NextJS, we need to install 2 packages. For this tutorial, we'll be using **cookie** and **react-cookie**. **React-cookie** allows us set the cookie from the client side while the **cookie** package lets us access the set cookie from the server-side. Install both packages by running  

```bash
npm install react-cookie cookie
```

[Cookie-cutter](https://npmjs.com/package/cookie-cutter) is a tiny package that does the same thing as react-cookie.

## Setting a cookie

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

## Giving your app access to the Cookie

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

## [](#setting-up-the-function-to-parse-the-cookie)Setting up the function to parse the cookie

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

## Accessing the cookie within your component

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
