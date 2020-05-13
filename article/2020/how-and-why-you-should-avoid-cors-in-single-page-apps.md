> * 原文地址：[How and Why You Should Avoid CORS in Single Page Apps](https://blog.bitsrc.io/how-and-why-you-should-avoid-cors-in-single-page-apps-db25452ad2f8)
> * 原文作者：[Ashan Fernando](https://medium.com/@ashan.fernando)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/how-and-why-you-should-avoid-cors-in-single-page-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2020/how-and-why-you-should-avoid-cors-in-single-page-apps.md)
> * 译者：
> * 校对者：

# How and Why You Should Avoid CORS in Single Page Apps

Over the past decade, Single Page Apps have become the norm technology to build web apps. Today, frameworks like Angular, React, and Vue dominate the frontend development, providing the underlying platform for these apps. The good news is, it serves the frontend and backend APIs from a single domain. But there are instances, where we serve frontend (e.g., web.myapp.com) and backend (e.g., api.myapp.com) from separate sub-domains. Sometimes, we allow cross-origin access at the backend API for the development environment only.

![](https://cdn-images-1.medium.com/max/12500/1*TKYFiZnIhfHi_PAFcG0geg.jpeg)

[Cross-origin resource sharing](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) (CORS) is a mechanism implemented in web browsers to allow or deny requests coming from a different domain to your web app. With CORS, web browsers and web servers agree on a standard protocol to understand whether the resources are allowed to access or not. So remember, implementing CORS doesn’t mean that Bots or any other mechanism can’t access your server resources.

## Do you need CORS?

But do we need to allow CORS for your web apps? I would say for most of the cases; you don’t need to worry about CORS. However, there could be special features like allowing to embed a page (e.g., Form, Video) outside your main web app, where you might consider enabling CORS. Still, you can enable CORS scoped to that particular feature.

## The Problem with CORS

The main problem with CORS is the impact on the performance in web apps. When your frontend sends an HTTP request to a different domain, the browser will send an additional HTTP called preflight request, to see whether the server accepts messages from the sender’s domain.

**So for each HTTP request trigged by the frontend, the browser needs to send two HTTP requests, increasing the overall response time. In most cases, the added delay is visible in web apps and adversely affects user experience.**

## CORS in Single Page Apps

When it comes to Single Page Apps, usage of CORS is much more apparent. Web browsers, won’t consider CORS if the web app use only the HTTP headers (Accept, Accept-Language, DPR, Downlink, Save-Data, Viewport-Width, Width, Content-Language, Content-Type (Except the values application/x-www-form-urlencoded, multipart/form-data, text/plan)) and HTTP methods (`GET, HEAD, POST`) for the backend API calls. You will likely need beyond these HTTP headers and HTTP methods in your Single Page Apps.

In these apps, we define the backend API URL in the frontend as a variable for server operations. Besides, we might even grant CORS for development, since the development server for frontend and backend API might be running in two different ports. The development environment might also influence your setup in production, where you might deploy the frontend and backend API in different subdomains.

But do we need to go in this direction? Let’s look at ways to avoid CORS for both development and production environments.

## Avoiding CORS in Dev Environment

Today, most of the development servers we select for frontend development uses NodeJS. Most of these Node servers support proxy configuration. Besides, frameworks like Angular, React and Vue come with Webpack dev server that has inbuilt support for proxy configuration.

#### So what precisely this proxy configuration do?

Let’s assume your frontend app is running in `http://localhost:4200` , and backend API is running in http://localhost:3000/api/\<resource>. Your frontend needs to store the backend API URL and port to run the app locally. To support this, you will also need to enable CORS in your backend API, allowing access from the frontend server running at [`http://locahost:4200`.](http://locahost:4200.)

We can avoid all the above hassle by using the proxy configuration in frontend development servers. When you use a proxy, you need to store only the relative path ( `/api`) in your frontend app. When running the app locally, your frontend will try to access the backend API, using the same domain and port (http://localhost:4200/api/\<resource>), the browser won’t have any concerns over CORS.

At this stage, the proxy does its magic. Inside the proxy configuration, you can define to forward any requests coming for the path `/api` to `http://localhost:3000`at your frontend development server.

Since your development server is the middleman communicating with your backend API, it can safely avoid CORS. The example below shows how you can add proxy configuration in the [Webpack dev server](https://webpack.js.org/configuration/dev-server/#devserverproxy).

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

## Avoiding CORS in Production Environment

In the production environment, if unless your frontend and backend run inside the same web server, you need to set up a gateway or a proxy in front of them to serve from a single domain. In some cases, your load balancer would be sufficient if it can route to different endpoints based on HTTP paths.

Similar to the dev Server proxy, the gateway, proxy or load balancer does the routing based on the configuration we provide, matching the HTTP path received in the request. The following list contains a few popular gateways, proxies, and load balancers that support URL path-based routing for your reference.

* [NGINX](https://www.nginx.com/)
* [Traefik](https://containo.us/traefik/)
* [AWS CloudFront](https://aws.amazon.com/cloudfront/)
* [AWS Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)
* [Azure Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview)

Besides, it is essential to harden your backend APIs for CORS by only allowing same-origin access.

## Summary

Overall, I hope you understand the usage of CORS and the need to avoid it in your Single Page Apps. Though it might look complicated to setup proxy in your development as well as in production, it is easier than you think.

For instance, setting up a dev server proxy for Angular, React, or Vue, it is a matter of adding few lines in Webpack config file to proxy your requests to the Backend API to avoid CORS. The same applies to the production environments since there are well-established ways to implement URL path-based routing.

However, you must establish a proper path conversion for your backend API to avoid needing to update the proxy configuration each time you add a new endpoint. For instance, if you use a base path (e.g., `\api\`), it is easier to write a simple rule to route requests to the backend API for all requests having the base path and fallback to frontend assets for other HTTP paths.

At last, I would like to reemphasize that if you don’t have any requirement to use CORS, enable only the same-origin access for your backend API, both in development and production environments. From my experience, it will save a lot of time down the line avoiding many pitfalls.

## Learn More

[**Fetching Data in React using Hooks**](https://blog.bitsrc.io/fetching-data-in-react-using-hooks-c6fdd71cb24a)
[**Code Principles Every Programmer Should Follow**](https://blog.bitsrc.io/code-principles-every-programmer-should-follow-e01bfe976daf)
[**How to Set Up a Private NPM Registry Locally**](https://blog.bitsrc.io/how-to-set-up-a-private-npm-registry-locally-1065e6790796)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
