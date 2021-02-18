> * 原文地址：[6 Principles for Performant Web Applications](https://blog.bitsrc.io/6-principles-for-performant-web-applications-7b9b8357edce)
> * 原文作者：[Mahdhi Rezvi](https://medium.com/@mahdhirezvi)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/6-principles-for-performant-web-applications.md](https://github.com/xitu/gold-miner/blob/master/article/2021/6-principles-for-performant-web-applications.md)
> * 译者：
> * 校对者：

# 6 Principles for Performant Web Applications

#### Make better web applications with proper principles

![Photo by [Eduardo Balderas](https://unsplash.com/@eduardobal?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/10368/0*GH7V_NpnI9c1i9AE)

---

Web Development has come a very long way since the birth of the internet. From dialup connections to fiber setups, the journey has been unprecedented. With the increase in connection speeds, there was a reduction in users' patience. People tend to expect their daily tasks to be quick and smooth. This led to the need of creating websites that ran quickly and smoothly.

But one huge hurdle that we as developers must somehow overcome is that we do not have any control over the hardware specifications of the devices our users would access our website on. The end-user may access your website on a high-end or low-end device with either a great or poor internet connection. This means that you have to make sure your website is optimized as much as possible for you to be able to satisfy the requirements of any user.

In order to create websites that perform smoothly even on the poorest of hardware, there are several principles that are used by web developers. This article is a listicle explaining some of these principles. Please note that these points are not in any order.

And one last thing — to keep the right balance between optimization and actually delivering features on time, make sure to always share and reuse your code — or, more specifically, your [components](https://bit.dev). That can be done, as you go, from any repo at all and without special preparations using tools and platforms like [Bit](https://bit.dev) ([Github](https://github.com/teambit/bit)).
[**teambit/bit**
**Documentation * Tutorials * Quick start guide * Workflows * bit.dev components cloud * Video demo Bit is an open-source…**github.com](https://github.com/teambit/bit)

---

## Image compression using next-gen formats

Images and videos are great these days. They have high quality and are very well delivered. But one major issue of the current media content is the size. According to [Jecelyn](https://twitter.com/jecelynyeen), on average a web page consumes 5 MB of data just for images. This can be a heavy burden on the users as it can be very costly in some countries, especially on mobile data. The users will also have issues with site loading times, notably with slower connection speeds. This can have a negative impact on your website.

#### WebP

WebP is a modern image format that provides both lossy and lossless compression formats at a lower payload size. This image format is currently developed by the tech giant — Google. WebP has been gaining a lot of momentum recently, especially from bigger tech companies, mainly because of its performance and the backing of Google. WebP competes directly with lossy image formats such as JPG and lossless formats such as PNG.

Due to its dual nature WebP is somewhat the hot trend these days as it gives you the best of both worlds — Lossy and lossless.

**Advantages**

* WebP lossless images are [26% smaller](https://developers.google.com/speed/webp/docs/webp_lossless_alpha_study#results) in size compared to PNGs.
* WebP lossy images are [25–34% smaller](https://developers.google.com/speed/webp/docs/webp_study) than comparable JPEG images at equivalent [SSIM](https://en.wikipedia.org/wiki/Structural_similarity) quality index.
* Lossless WebP supports image transparency as well.

![Comparison between lossless WebP and PNG by Jeremy Wagner — Source: [InsaleLab](https://insanelab.com/blog/web-development/webp-web-design-vs-jpeg-gif-png/)](https://cdn-images-1.medium.com/max/2132/0*VWvA3GARxP6p4Yik.png)

You can read more about WebP and other next-gen formats in my article over here.
[**Website Optimization with New Media Formats**
**Build faster, richer and engaging websites without any heavy burden on your consumers**blog.bitsrc.io](https://blog.bitsrc.io/website-optimization-with-media-formats-such-as-webp-and-webm-1df43bd252d)

---

## Cache whenever possible

Web caching is a key design feature of the HTTP protocol intended to reduce network traffic while enhancing the presumed responsiveness of the system as a whole. Caches are found at every stage of the content journey from the original server to the browser.

In simple terms, web caching enables you to reuse HTTP responses that have been stored in the cache, with HTTP requests of similar nature.

In a real-world situation, you cannot implement aggressive caching as it would probably return stale data most of the time. This is why a custom made caching policy should be in place to balance between implementing long-term caching and responding to the demands of a changing site by implementing suitable cache eviction algorithms. Since each system is unique and has its own set of requirements, adequate time should be spent on creating cache policies.

The key to a perfect caching policy is to tread a fine line that promotes aggressive caching whenever possible while leaving openings to invalidate entries in the future when changes are made.

To know more about the basics of caching, please read the article below.
[**Fundamentals of Caching Web Applications**
**Enabling high performant applications with caching**blog.bitsrc.io](https://blog.bitsrc.io/fundamentals-of-caching-web-applications-a215c4333cbb)

---

## Appropriate content loading strategy

There can be instances where our website has huge content being displayed on it. This can be a list of high-resolution images, a long list of records, etc. Since these payloads are heavy, they can impact your page load times by a great deal. But your page audience would not like to be kept waiting until this content fully loads.

Using a content loading strategy such as lazy loading can help you lower down the initial page payload and loading time but not compromise on the content. Lazy loading is a technique that defers the loading of non-critical resources at page load time. Instead, these non-critical resources are loaded at the moment of need.

But there can be instances where you might need the content loaded beforehand itself. You can use eager loading under these circumstances. There is also another content loading strategy called pre-loading, which loads the content after the initial page load.

There is no one perfect solution that can be implemented across all websites. It is up to you to analyze and select the most suitable strategy based on your requirement.

You can learn more about loading strategies over here.
[**Eager Loading, Lazy Loading, and Pre-Loading in Angular 2+: What, When, and How?**
**Angular 2+ has been a very popular front-end platform for modern web applications since 2016. It introduced a…**medium.com](https://medium.com/@lifei.8886196/eager-loading-lazy-loading-and-pre-loading-in-angular-2-what-when-and-how-798bd107090c)

---

## Optimization of algorithms

There is no use in building a smooth web application if it takes a long time to process its task. There can be instances where you have heavy loaded tasks running on your server that take a considerable amount of time to compute. It is quite obvious that your website audience would not like to be kept waiting until this process is complete.

You have two options to speed up this computation. You can either scale and expand your architecture so that it is capable of handling these tasks rather quickly. But this approach will increase the cost of running the server considerably.

Alternatively, you can optimize your algorithms. In fact, this is the option that should be followed before scaling your architecture. An optimized algorithm can significantly reduce your process times, and thereby enabling a quicker response.

But beware, algorithm optimization is not something that can be done without some heavy thinking. You will need to analyze your existing solution and see whether you can come up with a better one. This will take time and patience.

---

## Proper API design

Building an efficient API is one of the key aspects of an all-round web application. One of the biggest mistakes of rookie developers is that they start designing their API without understanding its concepts.

It is your responsibility as an API designer to understand the benefits and trade-offs of different architectural styles and the implications of applying the style constraints on the product you are building.

It is pretty obvious that there is no universal design that will work for all problems. Different products need different designs to fulfill their business objectives and requirements.

One of the most trending topics these days in GraphQL. There is always an argument amongst developers regarding GraphQL and REST. I would highly recommend you to read the following resource to get a better idea of API design.
[**REST vs. GraphQL: A Critical Review**
**Are you building an API? Here is the idea: If you have never heard about the REST architectural style constraints and…**goodapi.co](https://goodapi.co/blog/rest-vs-graphql)

---

## Asynchronous scripting

You have an option to either load scripts synchronously or asynchronously. Synchronous script loading can slow down your page loading speed. If just one file has an issue or takes a long time to load, nothing else will start until that is complete. The browser will halt the rendering of the page in order to complete the execution of the JavaScript code. This approach risks delaying your website load time.

But with asynchronous script loading, even if one file takes a long time to load, the rest of the scripts will continue to get loaded onto the application. This will greatly affect the load time of your application as your scripts can be loaded in parallel and even if one script takes time to complete, this will not affect the execution of the rest of the scripts.

You can read more about these over here.
[**Synchronous vs Asynchronous JavaScript (sync vs async)**
**This article explains the difference between loading JavaScript synchronously and asynchronously on a web page…**community.tealiumiq.com](https://community.tealiumiq.com/t5/Getting-Started/Synchronous-vs-Asynchronous-JavaScript-sync-vs-async/ta-p/13490)

---

## Conclusion: One improvement will not speed up your site

A single enhancement is never sufficient enough to drive the site to where it needs to be. You will need to take care of all aspects related to your web application to get a proper increase in performance. This would consist of anything and everything between your server and your browser.

It can be seen as several cuts in your body, through which there is a loss of blood. You will have to find and mend each cut to fully stop the blood loss. Your body can survive a few cuts by repairing itself. But if there are too many cuts, it will be difficult to survive. Similarly, your web application needs to keep these “performance killers” at a minimum to achieve the business objective and requirement with ease.

---

## Learn More
[**Is JavaScript Becoming TypeScript?**
**What might the future hold in store?**blog.bitsrc.io](https://blog.bitsrc.io/does-typescript-influence-javascript-e03fd8af288d)
[**Introduction to Aleph - The React Framework in Deno**
**Aleph is a JavaScript framework that offers you the best developer experience in building modern web applications with…**blog.bitsrc.io](https://blog.bitsrc.io/introduction-to-aleph-the-react-framework-in-deno-322ec26d0fa9)
[**Why You Should Use Picture Tag Instead of Img Tag**
**Resolution Switching, Art Direction, Chrome DevTools Support, and More**blog.bitsrc.io](https://blog.bitsrc.io/why-you-should-use-picture-tag-instead-of-img-tag-b9841e86bf8b)

---

**Resources
**[Article by Tim Grant](https://techbeacon.com/app-dev-testing/5-misguided-principles-web-performance-how-revise-them)
[Paper by Xin](https://link.springer.com/chapter/10.1007/978-3-642-28655-1_91)
[Quicksprout](https://www.quicksprout.com/boost-website-loading-time/)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
