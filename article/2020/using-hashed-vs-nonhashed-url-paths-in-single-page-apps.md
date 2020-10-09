> * 原文地址：[Using Hashed vs. Non-Hashed URL Paths in Single Page Apps](https://blog.bitsrc.io/using-hashed-vs-nonhashed-url-paths-in-single-page-apps-a66234cefc96)
> * 原文作者：[Viduni Wickramarachchi](https://medium.com/@viduniwickramarachchi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/using-hashed-vs-nonhashed-url-paths-in-single-page-apps.md](https://github.com/xitu/gold-miner/blob/master/article/2020/using-hashed-vs-nonhashed-url-paths-in-single-page-apps.md)
> * 译者：
> * 校对者：

# Using Hashed vs. Non-Hashed URL Paths in Single Page Apps

![Image by [Eric Binder](https://pixabay.com/users/Yivra-1836258/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2998837) from [Pixabay](https://pixabay.com/?utm_source=link-attribution&utm_medium=referral&utm_campaign=image&utm_content=2998837)](https://cdn-images-1.medium.com/max/3840/1*jAhsrJZmP8gM3gwZmSrliQ.jpeg)

There are two ways to support routing in single-page apps:

* Hashed URL Paths — We break the URL path with a # (Hash) so that the browser understands it’s just a virtual fragment
* Ordinary URL Paths (Non-Hashed URL Paths) — The server needs to intercept the request and return the index.html.

In this article, you will learn the pros and cons of these two approaches, and it will help you decide on the better one for your use case.

---

Tip: **Share your reusable components** between projects using [**Bit**](https://bit.dev/) ([Github](https://github.com/teambit/bit)). Bit makes it simple to share, document, and organize independent components from any project**.**

Use it to maximize code reuse, collaborate on independent components, and build apps that scale.

[**Bit**](https://bit.dev/) supports Node, TypeScript, React, Vue, Angular, and more.

![Example: browsing through React components shared on [Bit](https://bit.dev/) ([Github](https://github.com/teambit/bit))](https://cdn-images-1.medium.com/max/2000/0*A14HrKv055f99_7c.gif)

---

## Ordinary URL paths

From their appearance, you can identify that the following are ordinary URLs.

```
https://mysite.com/dashboard
https://mysite.com/shopping-cart
```

#### Advantages

* Ordinary URLs look pretty and clean.
* These types of URLs have a better advantage in terms of SEO.
* The scaffolding of web apps using frameworks like Angular supports this by default.
* Modern Development Servers (e.g., ng serve in Angular) also support this.

All in all, you can see that using ordinary URLs is the better option considering the support available. However, these advantages come with a cost.

#### Challenges

When we consider ordinary URLs for Single Page Apps, you need to configure your webserver to support it.

* Need to configure the webserver to serve the index.html for SPA Route Paths.
* Since it’s not practical to whitelist each SPA Route Path in the web server, it needs to have a separate pattern for API to distinguish them from SPA Routes (e.g.,/api/* allocated for API).
* Needs to take special care when defining URL path links in SPA since it could lead to full page reloads.
* In some cases, like hosting the frontend and backend separately, you will need a Gateway to do the serverside path-based Routing.

## Hashed URL Paths

Hashed URLs will take the following format. The portion separated by the hash is called a fragment or an anchor.

```
https://mysite.com/#/dashboard
https://mysite.com/#/cart
```

If you started working with SPAs several years ago, Hashed URL paths were the norm back then. But, things have changed over the past few years. SPAs have become the standard for web development, and tools and technology advancement supported this. This is why now it’s hard to see a distinguished URL scheme than ordinary for SPA. However, there are several advantages with Hashed URLs that are worth knowing.

#### Advantages

* Browsers don’t consider the path fragment after the hash as a separate page. This behavior of the browser is ideal for Single Page Apps since a page refresh will reload the index.html.
* Defining links with hash in the frontend is safe, as it won’t reload the page.
* Sever configuration is simple and easy to distinguish between API and frontend requests (Still, we need to plan frontend asset paths).

#### Disadvantages

When it comes to Hashed URLs, the main disadvantage is its appearance.

* Some users might consider it to be unusual.
* Not the best for SEO.

Otherwise, it is the easiest to implement for SPA.

## Handling URL Paths in SPA

Today, almost all the modern SPA frameworks contain a Routing module with the inbuilt support to handle URL or fragment changes.

Otherwise, you will have to develop a custom solution to track the URL changes in the SPA. To implement a custom Router, you could use the following browser APIs.

* [The History API](https://developer.mozilla.org/en-US/docs/Web/API/History) — This gives direct access to your browser’s history interface. It allows you to conduct URL manipulation without hashes. It has methods such as `back()` , `forward()` which allows you to navigate to previous states or next states based on browsing history.
* [The Location AP](https://developer.mozilla.org/en-US/docs/Web/API/Location)I along with the [onHashChange](https://developer.mozilla.org/en-US/docs/Web/API/WindowEventHandlers/onhashchange) event listener — In this method, the browser will trigger the `onHashChange` every time it sees a hash change in the URL. You can easily manage hash changes without communicating with the server using this method.

## Summary

You can use either Hashed URLs or ordinary URLs for Single Page Apps. Considering the pros and cons of these two approaches, you will agree with me that both options are technically viable.

Even if you use ordinary URLs for the application, any Single Page App framework or library will support it. Therefore, you don’t need to worry about the complexities that come with Routing. But you might need to look into the server-side setup to support this.

I hope this article gives an overview of using these two types of URLs and broadens your understanding. If you come across any questions, you can put them in the comment below.

The choice is yours!

## Learn More
[**Using the URL Object in JavaScript**
**Learn everything there is to know about the URL object**blog.bitsrc.io](https://blog.bitsrc.io/using-the-url-object-in-javascript-5f43cd743804)
[**Revolutionizing Micro Frontends with Webpack 5, Module Federation, and Bit**
**See how the upcoming Module Federation plugin will change the way micro frontend works**blog.bitsrc.io](https://blog.bitsrc.io/revolutionizing-micro-frontends-with-webpack-5-module-federation-and-bit-99ff81ceb0)
[**React Router VS Reach Router**
**Which React Routing Library Should You Use?**blog.bitsrc.io](https://blog.bitsrc.io/react-router-vs-reach-router-d26fe706d8db)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
