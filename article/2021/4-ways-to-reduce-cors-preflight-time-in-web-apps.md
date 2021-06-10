> - 原文地址：[4 Ways to Reduce CORS Preflight Time in Web Apps](https://blog.bitsrc.io/4-ways-to-reduce-cors-preflight-time-in-web-apps-1f47fe7558)
> - 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga)
> - 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> - 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/4-ways-to-reduce-cors-preflight-time-in-web-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2021/4-ways-to-reduce-cors-preflight-time-in-web-apps.md)
> - 译者：[regon-cao](https://github.com/regon-cao)
> - 校对者：[zenblo](https://github.com/zenblo) [Ashira97](https://github.com/Ashira97)

# 减少 Web 应用程序中 CORS 预检时间的 4 种方法

![](https://cdn-images-1.medium.com/max/4480/1*JBeY4hI_q0S2Y-7AE7Eq7w.jpeg)

[跨域资源共享](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing)（CORS）是一个浏览器和服务器之间关于跨域问题的协议。它允许服务器规定哪些资源可以被外部的主域名和子域名访问，并通知浏览器遵循这些规则。

> 例如，如果你的 web 应用托管在 myapp.com 中，并且前端请求 api.myapp.com 中的 API，那么你将会遇到跨域资源共享问题。

尽管出于安全目的使用 CORS 很重要，但大多数开发人员忽略了它对应用程序性能的影响。

当你从前端向不同的域发送 HTTP 请求时，浏览器会预先发送另一个 HTTP 请求，以确保服务器允许本次请求。

> 这个额外的请求被称为预检请求，在大多数情况下，它会对响应时间造成很大的延迟，从而影响 web 应用程序的性能。

因此，让我们看看如何绕过预检请求或者减少预检响应时间，以提高 web 应用程序的性能。

## 1. 使用浏览器的预检缓存

如前所述，预检请求对应用程序性能有影响。根据前端调用 API 的数量，很可能会发送许多预检请求。

作为一种解决方案，预检缓存是减少影响的常用方法之一。这背后的原理很简单。

预检缓存的行为与任何其他缓存机制类似。每当浏览器发出预检请求时，它首先检查预检缓存，看看是否有对该请求的响应。如果浏览器找到了响应，它不会向服务器发送预检请求，而是使用缓存的响应。只有在预检缓存中没有找到响应时，浏览器才会发送预检请求。

**`Access-Control-Max-Age`** 响应头表示结果可以在浏览器缓存中缓存多长时间。

![有和没有预检缓存的浏览器行为](https://cdn-images-1.medium.com/max/2000/1*zCXcC1VkBB16BDXUxkWoew.png)

上面的图表显示了浏览器在使用预检缓存（第一次请求）和没有预检缓存（第二次请求）时的行为。

## 2. 使用代理、网关或负载均衡实现服务器端缓存

在前面的方法中，我们讨论了在浏览器中缓存预检请求的方法，现在我们来看看服务器端缓存。

尽管这种方法不是专门用于预检请求缓存，但我们可以使用代理、网关甚至像 AWS CloudFront 这样的 CDN 的默认缓存机制来减少预检请求延迟时间。

> 其思想就是通过缩短预检请求的传输距离来减少响应时间。

![CloudFront 边缘位置缓存](https://cdn-images-1.medium.com/max/2000/1*cS016V1j7hUZt8ebOhNyow.png)

例如，以 AWS CloudFront CDN 为示例。它是一个代理，使用了一种被称为边缘位置（比原始服务器更接近用户的浏览器）的概念来拦截 HTTP 请求。

> 在这里，可以在边缘位置附近缓存预检响应，这样预检请求甚至不需要访问源服务器。

## 3. 使用代理、网关或负载均衡避免预检请求

如果你可以通过同一个域同时服务前端和后端，我们就可以完全避免预检请求，因为此时不存在 CORS。

假设正在本地环境开发一个应用, 前端运行在 [http://localhost:4200](http://localhost:4200)，后端运行在 [http://localhost:3000/api](http://localhost:3000/api)。

> 你可能有过类似经验，必须在后端开启 CORS 才能在二者之间通信。但是，你可以在前端配置简单的代理以在前后端之间形成映射，这样就可以完全避免 CORS。

你只需要定义一个代理配置来转发前往 `[http://localhost:3000](http://localhost:3000)` 的 `/api` 路径请求。然后在前端（[http://localhost:4200/api/](http://localhost:4200/api/)…）就可以请求同一域名下的后端 API，此时浏览器不会再发送任何预检请求。

同样地, 在生产环境可以使用 API 网关，负载均衡，代理或者 CDN，比如 [NGINX](https://www.nginx.com/)，[Traefik](https://containo.us/traefik/)，[AWS CloudFront](https://aws.amazon.com/cloudfront/)，[AWS Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)，[Azure Application Gateway](https://docs.microsoft.com/en-us/azure/application-gateway/overview) 来做基于路由的配置。

## 4. 简单请求

另一种避免预检请求的方法是使用**简单请求**。预检请求对于简单请求不是强制性的，根据 [w3c CORS 说明](https://www.w3.org/wiki/CORS)，如果 HTTP 请求满足以下条件，可以将其标记为简单请求。

- 请求方式应该是 `GET`，`POST`，或者 `HEAD`。
- 只允许携带几个固定的头信息，包括 `Accept`，`Accept-Language`，`Content-Language`，`Content-Type`，`DPR`，`Downlink`，`Save-Data`，`Viewport-Width` 和 `Width`。
- 尽管 `Content-Type` 头被允许, 它只限于`application/x-www-form-urlencoded`，`multipart/form-data` 和 `text/plain`。

> 你现在肯定很疑惑为什么我们不能总是使用简单请求呢？

答案也很简单。这些限制对于现代的 web 应用程序来说太过严格，我们不能限定在这些范围之内来为客户提供最佳的解决方案。例如，在简单请求中不允许使用授权头，现在几乎所有的 HTTP 请求都在使用授权头。

所以，如果打算使用简单请求，你应该对应用的要求保持谨慎。

## 最后的感想

我希望你现在明白了我们可以遵循的降低或避免 CORS 预检响应时间的方法。但在使用这些方法之前，你应该对 CORS 和背后它出现的原因有充分的了解。有了这些了解再加上项目需求，你就能决定是否需要使用 CORS。

根据我的经验，我建议你只在必要时才使用 CORS，因为与启用后端 API 的同源访问来改善项目延迟的工作相比，我们可以节省大量开发时间。在这种情况下，你可以很容易地使用代理配置、API 网关或负载均衡来减少麻烦。

但有些情况下无法避免 CORS。此时，你可以简单地遵循浏览器缓存或服务器端缓存机制来最小化响应时间。我保证这将使你的 web 应用程序获得性能上的提升。

因此，我邀请你在下一个 web 应用程序中尝试这些方法，感受它们的不同。

感谢阅读！！！

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
