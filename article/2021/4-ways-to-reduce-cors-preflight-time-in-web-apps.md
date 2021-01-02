> * 原文地址：[4 Ways to Reduce CORS Preflight Time in Web Apps](https://blog.bitsrc.io/4-ways-to-reduce-cors-preflight-time-in-web-apps-1f47fe7558)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/4-ways-to-reduce-cors-preflight-time-in-web-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2021/4-ways-to-reduce-cors-preflight-time-in-web-apps.md)
> * 译者：
> * 校对者：

# 4 Ways to Reduce CORS Preflight Time in Web Apps

![](https://cdn-images-1.medium.com/max/4480/1*JBeY4hI_q0S2Y-7AE7Eq7w.jpeg)

[Cross-origin resource sharing](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing) (CORS) is an agreement between web browsers and web servers across origins. This agreement allows servers to decide what resources are allowed to access outside it’s hosted domain/sub-domain and instruct the browsers to follow the rules.

> For example, you will encounter CORS if your web application is hosted in myapp.com, and it accesses the API in api.myapp.com from the frontend.

Although there is an importance of having CORS for security purposes, most developers overlook its impact on the application performance.

Whenever you make an HTTP request from the frontend to a different domain, the browser will send another HTTP request ahead of that, sequentially to make sure the server grants it.

> This additional request is called a Preflight request, and in most cases, it creates a significant delay in response time, affecting the performance of the web application.

So, let’s find out how we can bypass the Preflight request or reduce the response time to enhance our web applications’ performance.

## 1. Preflight Caching Using Browser

As I mentioned earlier, the Preflight request has an impact on application performance. It’s most likely that there will be many preflight requests sent, based on the number of API calls your frontend performs.

As a solution, Preflight caching is one of the commonly used methods to reduce the impact. The concept behind this is straightforward.

Preflight cache behaves similarly to any other caching mechanism. Whenever the browser makes a Preflight request, it first checks in the Preflight cache to see if there is a response to that request. If the browser finds the response, it won’t send the Preflight request to the server, and instead, it uses the cached response. The browser will only send the Preflight request if there is no response in the Preflight cache.

**`Access-Control-Max-Age`** response header indicates how long the result can be cached in the browser cache.

![Browsers behavior with and without Preflight cache results.](https://cdn-images-1.medium.com/max/2000/1*zCXcC1VkBB16BDXUxkWoew.png)

The above diagrams show the browser’s behavior with Preflight cache (First Request) and without Preflight cache (Second Request).

## 2. Server-Side Caching using Proxies, Gateways, or Load balancers

In the previous method, we talked about the approach of caching Preflight requests in browsers, and now we are moving into Server-Side caching.

Although this method is not specialized for Preflight request caching, we can use the default caching mechanism of Proxies, Gateways or even CDNs like AWS CloudFront to reduce Preflight requests’ latency.

> The idea is to reduce the Preflight request response time by reducing the distance the Preflight request travels.

![CloudFront edge location caching](https://cdn-images-1.medium.com/max/2000/1*cS016V1j7hUZt8ebOhNyow.png)

For example, let’s take AWS CloudFront CDN that also acts as a proxy. It uses a concept called edge locations (closer to the application user’s browser location than the original server) to intercept the HTTP requests.

> Here, it is possible to instruct to cache the Preflight response near the edge location even without hitting the origin server.

## 3. Avoid it using Proxies, Gateways, or Load balancers

If we can serve both frontend and backend through the same domain, we can completely avoid Preflight requests since there is no need for CORS.

Let’s assume that you are developing a web application locally, and the frontend is running on [http://localhost:4200](http://localhost:4200), and the backend is running on [http://localhost:3000/api](http://localhost:3000/api).

> As you may have experienced, it is necessary to enable CORS in your backend to communicate between these two. But you can easily avoid this by using a simple proxy configuration in your frontend to map your frontend and backend.

You just need to define a proxy configuration to forward any requests coming for the path `/api` to `[http://localhost:3000](http://localhost:3000)`. Then you can access your backend API using the same domain and port used for the frontend ([http://localhost:4200/api/](http://localhost:4200/api/)…), and the browser won’t send any Preflight requests since there is no need for CORS.

Similarly, when it comes to the production environments, you can use API Gateways, Load balancers, Proxies or CDNs, like [NGINX](https://www.nginx.com/), [Traefik](https://containo.us/traefik/), [AWS CloudFront](https://aws.amazon.com/cloudfront/), [AWS Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html), [Azure Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview) to do the route base configuration for you.

## 4. Simple Requests

Another way to avoid Preflight requests is to use **simple requests**. Preflight requests are not mandatory for simple requests, and according to [w3c CORS specification](https://www.w3.org/wiki/CORS), we can label HTTP requests as simple requests if they meet the following conditions.

* Request method should be `GET`, `POST`, or `HEAD`.
* Only a limited number of headers are allowed, including `Accept`, `Accept-Language`, `Content-Language`, `Content-Type`, `DPR`, `Downlink`, `Save-Data`, `Viewport-Width`, and `Width`.
* Although `Content-Type` header is allowed, it should only contain values types of application/x-www-form-urlencoded,`multipart/form-data `and `text/plain`.

> Now you must be wondering that why don’t we always use these simple requests?

The answer to that question is also simple. These restrictions are too tight for modern-day web applications, and we can’t lock ourselves within these boundaries and provide the best solutions for customers. For example, Authorization headers are not allowed in simple requests, and nowadays, we use authorization headers in almost all HTTP requests.

So, if you’re going to use a simple request, you should be extremely cautious about your application’s requirements.

## Final Thoughts

I hope now you understand the methods we can follow to improve or avoid CORS Preflight response time. However, before using these methods, you should have a good understanding of CORS and the reasons behinds its establishment. With that understanding and based on the project requirements, you will be able to decide whether you are going to use CORS or not.

With my experience, I would advise you to use CORS only if necessary because we can save a lot of development time while improving our projects’ latency by enabling same-origin access for your backend API. You can easily go with a proxy configuration, API gateway, or a load balancer to minimize the trouble in such situations.

But there are scenarios where you cannot avoid CORS. In these situations, you can easily follow browser caching or Server-Side caching mechanisms to minimize response time. I’m sure it will benefit your web application to gain an edge over performance.

So I invite you to try out these methods in your next web application to feel the difference.

Thank you for Reading!!!

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
