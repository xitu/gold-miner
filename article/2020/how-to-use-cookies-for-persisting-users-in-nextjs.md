> * 原文地址：[How to use cookies for persisting users in Nextjs](https://dev.to/debosthefirst/how-to-use-cookies-for-persisting-users-in-nextjs-4617)
> * 原文作者：[Adebola](https://dev.to/debosthefirst)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-use-cookies-for-persisting-users-in-nextjs.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-to-use-cookies-for-persisting-users-in-nextjs.md)
> * 译者：[plusmultiply0](https://github.com/plusmultiply0)
> * 校对者：[Liusq-Cindy](https://github.com/Liusq-Cindy)、[HurryOwen](https://github.com/HurryOwen)

# 如何在 Nextjs 中使用 cookies 来持久化保存用户信息

## 使用 LocalStorage

在 React 或单页应用中有许多方式来持久化保存用户信息。大多数时候，开发者通常使用 localStorage 来保存以及按需加载用户数据。虽然这个方法可行，但不太好，因为它会让用户易于遭到攻击。使用 cookies 会是相对安全的选择。就个人而言，我倾向于混合使用 cookies 和 JWT 的 [JSON Web tokens](https://jwt.io/) 来持久化用户会话以及，当会话过期时，强制用户重新登录。如何使用 JWT 的 [JSON Web tokens](https://jwt.io/) 不在本文的介绍范围内。

由于 localStorage 在服务器端是未定义的（因为服务器端没有 localStorage），所以在渲染路由前是不可能访问到 localStorage 的。如前所述，我们最好的做法是，在渲染路由前，检查用户的 cookie 是否可用。

## 在 React/NextJS 中使用 cookies

为了在 NextJS 中使用 cookies，我们需要安装两个 packages。在本文中，我们将会使用 **cookie** 和 **react-cookie**。**react-cookie** 允许我们从客户端设置 cookie，而 **cookie** 则让我们能从服务器端访问设置的 cookie。运行以下命令安装 packages。

```bash
npm install react-cookie cookie
```

[Cookie-cutter](https://npmjs.com/package/cookie-cutter) 功能与 react-cookie 相同，但是包体积更小。

## 设置 cookie

安装了上面的两个 packages 后，现在来设置一个 cookie。通常，我们会在用户成功注册或登录时设置一个 cookie。要在登录时设置一个 cookie，可以遵循下面的例子。  

```js
// pages/login.js
import { useCookies } from "react-cookie"

const Login = () => {
  const [setCookie] = useCookies(["user"])

  const handleSignIn = async () => {
    try {
      const response = await yourLoginFunction(username) //执行用以登录的 API 调用
      const data = response.data

      setCookie("user", JSON.stringify(data), {
        path: "/",
        maxAge: 3600, // cookeie 一小时后过期
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

在上面的代码片中，我们调用了 `react-cookies` 包中的 `setCookie` 钩子并为其设置了默认值。在我们的示例中，默认值为 **user**。然后，
我们通过调用登录函数，发起一个请求用以用户登录。我们从 API 调用中获取 response 后，将 response.data 字符串化（cookies 应格式化为文本）并存储在 cookie 中。

我们也传递了额外的选项参数到 cookie 中，如：**path**，确保你的 cookie 在所有的路由中均可访问； **maxAge**，定义了从设置 cookie 开始到过期的时间，即 cookie 的有效期；**sameSite**，Samesite 指示 cookie 仅能用于设置了 cookie 的站点——将其设置为 true 非常重要，因为可以避免其在 Firefox 日志出现错误。

## 赋予应用访问 Cookie 的权限

为了确保应用中的所有路由都能访问到 cookie，我们需要将 App 组件包装在提供 cookie 的组件内。

在 `_app.js` 文件中，添加下列代码。  

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

接下来，我们需要设置一个函数用来检查 cookie 是否存在于服务器上，（存在的话）解析 cookie 并将其作为返回值。新建一个名为 **helpers** 的文件夹，并在里面添加一个 **index.js** 文件。

在文件内，添加如下代码。

```js
// helpers/index.js

import cookie from "cookie"

export function parseCookies(req) {
  return cookie.parse(req ? req.headers.cookie || "" : document.cookie)
}
```

上面的函数接收一个 request 对象，然后检查 request 的 headers 以找到存储的 cookie。

## 在组件中访问 cookie

最后，在渲染请求的路由前，我们将使用组件中的 `getInitialProps` 来检查用户在服务器端是否存在有效的 cookie。另外，你可以使用 `getServerSideProps` 作为替代。

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

在 `getInitialProps` 中，我们把在 NextJS 服务器端可用的 request 对象（req）传递给 `parseCookies` 函数。 该函数将 cookie 返回给我们，我们就可以将 cookie 作为参数发送给客户端。

我们同样会在服务器端检查 response 对象是否可用。**res** 对象（response）仅在服务器端可用。如果用户使用 **next/link** 或 **next/router** 访问到 **HomePage** 路由，**res** 对象将不可用。

通过使用 **res** 对象，我们可以检查是否存在 cookies 以及它们是否有效。如果 `data` 是空对象，则意味着 cookie 无效。如果 cookie 无效，我们将重定向用户返回至主页而不是在重定向用户前显示刷新的主页。

注意到，后续使用 **next/link** 或 **next/router** 以及包含 `getInitialProps` 的页面请求会在客户端被完成。也就是说，对于通过使用 **next/link** 或 **next/router** 访问的其他路由，cookie 会从客户端提取而不是服务器端。

这样，你可以在应用中存储用户的 cookies，过期无效 cookies 以及很好地保证应用的安全。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
