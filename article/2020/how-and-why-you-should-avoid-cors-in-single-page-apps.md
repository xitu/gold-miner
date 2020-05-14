> * 原文地址：[How and Why You Should Avoid CORS in Single Page Apps](https://blog.bitsrc.io/how-and-why-you-should-avoid-cors-in-single-page-apps-db25452ad2f8)
> * 原文作者：[Ashan Fernando](https://medium.com/@ashan.fernando)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-and-why-you-should-avoid-cors-in-single-page-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-and-why-you-should-avoid-cors-in-single-page-apps.md)
> * 译者：[ZiXYu]()
> * 校对者：

# How and Why You Should Avoid CORS in Single Page Apps

# 如何且为何要在单页应用中防止跨域资源共享 

Over the past decade, Single Page Apps have become the norm technology to build web apps. Today, frameworks like Angular, React, and Vue dominate the frontend development, providing the underlying platform for these apps. The good news is, it serves the frontend and backend APIs from a single domain. But there are instances, where we serve frontend (e.g., web.myapp.com) and backend (e.g., api.myapp.com) from separate sub-domains. Sometimes, we allow cross-origin access at the backend API for the development environment only.

在过去的十年中，单页应用成为了开发一个 web 应用的常规技术手段。如今的一些框架，比如 Angular，React 和 Vue 统治着前端开发的领域，它们为这些 web 应用提供了底层的平台。好消息是，它一般从同一个域名提供前端和后端的 API。但是某些情况下，我们提供前端服务的地址 (例如 web.myapp.com) 和提供后端服务的地址 (例如 api.myapp.com) 两个不同的子域名。某些时候，我们会仅在开发环境下允许跨域访问后端 API 。

![](https://cdn-images-1.medium.com/max/12500/1*TKYFiZnIhfHi_PAFcG0geg.jpeg)

[Cross-origin resource sharing](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) (CORS) is a mechanism implemented in web browsers to allow or deny requests coming from a different domain to your web app. With CORS, web browsers and web servers agree on a standard protocol to understand whether the resources are allowed to access or not. So remember, implementing CORS doesn’t mean that Bots or any other mechanism can’t access your server resources.

[跨域资源共享](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) (CORS) 是一种在浏览器中实现的机制，用于允许或拒绝某些其它域名发送到你 web 应用的请求。 通过 CORS，web 浏览器和 web 服务器就确认资源是否可以被访问的标准协议达成一致。所以记住了，实现了 CORS 并不意味着某些爬虫机器人或者其它的机制不能访问你的服务器资源。

## Do you need CORS?

## 你需要 CORS 吗？

But do we need to allow CORS for your web apps? I would say for most of the cases; you don’t need to worry about CORS. However, there could be special features like allowing to embed a page (e.g., Form, Video) outside your main web app, where you might consider enabling CORS. Still, you can enable CORS scoped to that particular feature.

但是我们需要在我们的 web 应用中允许 CORS 吗？我想说在大多数情况下，你并不需要担心 CORS。然而，在某些特殊情况下，例如在你的主 web 应用之外允许嵌入一个页面 (比如表单，视频)，那么这里你就需要考虑启用 CORS 了。不过，你可以控制仅启用 CORS 的一部分功能来满足特定的需求。

## The Problem with CORS

## CORS 带来的问题

The main problem with CORS is the impact on the performance in web apps. When your frontend sends an HTTP request to a different domain, the browser will send an additional HTTP called preflight request, to see whether the server accepts messages from the sender’s domain.

CORS 带来最主要的问题是会影响到 web 应用的性能。当你的前端应用向一个不同的域名发送了一个 HTTP 请求，浏览器将会发送一个额外的预检 HTTP 请求以确认这个服务器是否接受来自发送域名的请求。

**So for each HTTP request trigged by the frontend, the browser needs to send two HTTP requests, increasing the overall response time. In most cases, the added delay is visible in web apps and adversely affects user experience.**

**所以对于每个由前端触发的 HTTP 请求，浏览器都需要发送 2 个 HTTP 请求，从而增加了总体的响应时间。在大多数情况下，这个额外的延迟是在 web 应用中可被感知的，同时也降低了用户体验。**

## CORS in Single Page Apps

## 单页应用中的 CORS

When it comes to Single Page Apps, usage of CORS is much more apparent. Web browsers, won’t consider CORS if the web app use only the HTTP headers (Accept, Accept-Language, DPR, Downlink, Save-Data, Viewport-Width, Width, Content-Language, Content-Type (Except the values application/x-www-form-urlencoded, multipart/form-data, text/plan)) and HTTP methods (`GET, HEAD, POST`) for the backend API calls. You will likely need beyond these HTTP headers and HTTP methods in your Single Page Apps.

在单页应用中，CORS 的使用更为显著。当 web 应用仅使用 HTTP headers (Accept, Accept-Language, DPR, Downlink, Save-Data, Viewport-Width, Width, Content-Language, Content-Type (除 application/x-www-form-urlencoded, multipart/form-data, text/plan 之外)) 和 HTTP methods (`GET, HEAD, POST`) 来调用后端 API 时，浏览器是不会考虑 CORS 的。在你的单页应用中，你也可能需要使用其它的 HTTP header 和 HTTP methods。

In these apps, we define the backend API URL in the frontend as a variable for server operations. Besides, we might even grant CORS for development, since the development server for frontend and backend API might be running in two different ports. The development environment might also influence your setup in production, where you might deploy the frontend and backend API in different subdomains.

在这些应用中，我们在前端应用中把后端 API 地址定义为一个变量。除此之外，我们可能需要在开发环境允许 CORS，因为前端和后端 API 的开发服务端可能运行在两个不同的端口。同时开发环境也可能影响你在生产环境的设置，在生产环境中你可能将前端和后端 API 部署在两个不同的子域名中。

But do we need to go in this direction? Let’s look at ways to avoid CORS for both development and production environments.

但是我们需要朝着这个方向前进吗？让我们来看看如何在开发和生产环境都避免使用 CORS 的方法吧。

## Avoiding CORS in Dev Environment

## 避免在开发环境使用 CORS

Today, most of the development servers we select for frontend development uses NodeJS. Most of these Node servers support proxy configuration. Besides, frameworks like Angular, React and Vue come with Webpack dev server that has inbuilt support for proxy configuration.

现在，我们为前端选择的开发服务端大多数都使用 NodeJS。而绝大多数的 Node 服务端支持代理设置。除此之外，像 Angular，React，Vue 这样的框架都随着 Webpack 的开发服务端内置了对代理设置的支持。

#### So what precisely this proxy configuration do?

#### 那么代理设置到底能做什么？

Let’s assume your frontend app is running in `http://localhost:4200` , and backend API is running in http://localhost:3000/api/\<resource>. Your frontend needs to store the backend API URL and port to run the app locally. To support this, you will also need to enable CORS in your backend API, allowing access from the frontend server running at [`http://locahost:4200`.](http://locahost:4200.)

让我们假设一下我们的前端应用运行在 `http://localhost:4200` ，同时后端 API 服务运行在 http://localhost:3000/api/\<resource>。你的前端应用需要存储后端的 API URL 地址和端口从而在本地运行。同时，你也必须在后端 API 服务中开启 CORS 以支持运行在 [`http://locahost:4200`](http://locahost:4200) 前端服务的访问。

We can avoid all the above hassle by using the proxy configuration in frontend development servers. When you use a proxy, you need to store only the relative path ( `/api`) in your frontend app. When running the app locally, your frontend will try to access the backend API, using the same domain and port (http://localhost:4200/api/\<resource>), the browser won’t have any concerns over CORS.

通过在前端开发服务端上配置代理设置，我们可以避免上述的所有麻烦。当你使用了代理时，你只需要在你的前端应用中存储相对路径 (`/api`)。当在本地运行前端应用时，你的前端服务会尝试使用同样的域名和端口 (http://localhost:4200/api/\<resource>) 来访问后端服务，浏览器并不会担心任何有关 CORS 的问题。

At this stage, the proxy does its magic. Inside the proxy configuration, you can define to forward any requests coming for the path `/api` to `http://localhost:3000`at your frontend development server.

在这个阶段，代理就开始发挥它的作用了。在代理设置中，你可以设置在你的前端开发服务中将所有来自 `/api` 的请求转发到 `http://localhost:3000`。

Since your development server is the middleman communicating with your backend API, it can safely avoid CORS. The example below shows how you can add proxy configuration in the [Webpack dev server](https://webpack.js.org/configuration/dev-server/#devserverproxy).

因为你的开发服务端是和后端 API 通讯的中间人，它可以安全的避免 CORS。下面的例子展示了你可以在 [Webpack 开发服务端](https://webpack.js.org/configuration/dev-server/#devserverproxy) 添加的代理配置。


```js
module.exports = {
  //...
  devServer: {
    proxy: {
      '/api': 'http://localhost:3000'
    }
  }
};
```

As an alternative approach, if you don’t want to use relative paths in the frontend for the backend API, you can start your web browser with specialized flags to disable CORS for local testing. e.g., [Run Chrome browser without CORS](https://alfilatov.com/posts/run-chrome-without-cors/).

作为一种替代的方案，如果你不想在你的前端应用中为后端 API 使用相对路径，你可以使用特殊的方法启动浏览器以禁用 CORS 进行本地测试。可参考 [禁用 CORS 启动 Chrome 浏览器](https://alfilatov.com/posts/run-chrome-without-cors/)。

## Avoiding CORS in Production Environment

## 在生产环境避免 CORS

In the production environment, if unless your frontend and backend run inside the same web server, you need to set up a gateway or a proxy in front of them to serve from a single domain. In some cases, your load balancer would be sufficient if it can route to different endpoints based on HTTP paths.

在生产环境中，除非你的前后端都运行在同一个 web 服务器中，你就需要在它们之前设置一个网关或代理从而从同一域名提供服务。在某些情况下，如果你的负载均衡可以基于不同的 HTTP 路径路由到不同的端点，那么它就足够使用了。

Similar to the dev Server proxy, the gateway, proxy or load balancer does the routing based on the configuration we provide, matching the HTTP path received in the request. The following list contains a few popular gateways, proxies, and load balancers that support URL path-based routing for your reference.

和开发环境的代理类似，网关，代理或者负载均衡都是依据我们提供的配置来匹配请求中接收到的 HTTP 路径从而进行路由的。下面的列表包括一部分支持基于 URL 路径路径的流行网关、代理和负载均衡。

* [NGINX](https://www.nginx.com/)
* [Traefik](https://containo.us/traefik/)
* [AWS CloudFront](https://aws.amazon.com/cloudfront/)
* [AWS 应用负载均衡](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)
* [Azure 应用网关](https://docs.microsoft.com/en-us/azure/application-gateway/overview)

Besides, it is essential to harden your backend APIs for CORS by only allowing same-origin access.

此外，仅允许相同来源的访问来增强你的后端 API 也是十分必要的。

## Summary

## 总结

Overall, I hope you understand the usage of CORS and the need to avoid it in your Single Page Apps. Though it might look complicated to setup proxy in your development as well as in production, it is easier than you think.

综上所述，我希望你能明白 CORS 的使用和在你的单页应用中避免使用它的必要性。尽快看起来在你的开发和生产环境设置代理好像很麻烦，但是它会比你想象的更容易。

For instance, setting up a dev server proxy for Angular, React, or Vue, it is a matter of adding few lines in Webpack config file to proxy your requests to the Backend API to avoid CORS. The same applies to the production environments since there are well-established ways to implement URL path-based routing.

例如，在 Angular，React 和 Vue 中设置一个开发服务端的代理，只需要在 Webpack 的设置文件中增加几行代码就可以把你的请求代理的后端 API 从而避免 CORS。这同样适用于生产环境，因为有非常健全的方法来实现基于 URL 路径的路由。

However, you must establish a proper path conversion for your backend API to avoid needing to update the proxy configuration each time you add a new endpoint. For instance, if you use a base path (e.g., `\api\`), it is easier to write a simple rule to route requests to the backend API for all requests having the base path and fallback to frontend assets for other HTTP paths.

然而，你必须为你的后端 API 设置一套合适的路径转换规则，以防止每次你新增加一个端点就必须去更新代理设置。比如，如果你使用了一个基本路径 (例如 `\api\`)，那么将所有包含这个基本路径的请求都转发到后端 API ，同时将其它的 HTTP 请求回退到前端资源是更容易的。

At last, I would like to reemphasize that if you don’t have any requirement to use CORS, enable only the same-origin access for your backend API, both in development and production environments. From my experience, it will save a lot of time down the line avoiding many pitfalls.

最后，我想要再强调一下，如果你不存在任何的需要来使用 CORS，那么在你的开发和生产环境都只需要让你的后端 API 允许同源访问。从我的经验来说，这会节省大量的时间，同时避免很多潜在的风险。

## Learn More

## 了解更多

[**使用 Hooks 在 React 中获取数据**](https://blog.bitsrc.io/fetching-data-in-react-using-hooks-c6fdd71cb24a)
[**每个程序猿都应该遵守的代码准则**](https://blog.bitsrc.io/code-principles-every-programmer-should-follow-e01bfe976daf)
[**如何在本地设置一个私有化 NPM 源**](https://blog.bitsrc.io/how-to-set-up-a-private-npm-registry-locally-1065e6790796)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
