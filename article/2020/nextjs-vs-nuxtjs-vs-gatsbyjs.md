> * 原文地址：[NextJS vs. NuxtJS vs. GatsbyJS](https://medium.com/better-programming/nextjs-vs-nuxtjs-vs-gatsbyjs-1a1fffb8895b)
> * 原文作者：[Mr Herath](https://medium.com/@keith95)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/nextjs-vs-nuxtjs-vs-gatsbyjs.md](https://github.com/xitu/gold-miner/blob/master/article/2020/nextjs-vs-nuxtjs-vs-gatsbyjs.md)
> * 译者：
> * 校对者：

# NextJS vs. NuxtJS vs. GatsbyJS

![Photo by [Kara Eads](https://unsplash.com/@karaeads) on [Unsplash](https://unsplash.com/)](https://cdn-images-1.medium.com/max/2000/0*nyUWEd-FwoOs3oyI)

Server-side rendering is the process of taking a client-side JavaScript framework website and rendering it to static HTML and CSS on the server.

Why is this important?

Well, we all want fast-loading websites — server-side rendering is a tool to help you get your website rendered faster. So let’s take a moment to talk about the critical path in your website’s first render. The critical path is a reference to the process of delivering the most important pieces of content to the browser, so it can render your page. If we can deliver the most important assets quickly, then the browser can do its job and render the page quickly to the user.

## Understand What’s Behind

How fast the browser renders your app depends on how you build it. The first thing the browser receives is an HTML document. This document contains references to other assets —such as images, CSS, and JavaScript. The browser knows to go fetch and download these assets when it parses this HTML document. So, even though the browser has your HTML, it can’t actually render the website until its corresponding CSS has finished parsing.

Once that’s done, the browser goes ahead and renders the page. That means that with just HTML and CSS, the browser can render the page. As we know the browser is good at this, so it does it very fast.

Now, the final part of this process is JavaScript. After the HTML document is parsed, the browser will download your JavaScript files. The download time of a JavaScript file can be significant if the file is large and the network is poor — and the browser needs to parse the JavaScript. On devices with low-powered hardware, this can take quite a bit of effort and time. Also, you could see slow load times if your first render is dependent on JavaScript. JavaScript should be considered an enhancement of HTML and CSS, since its loading can be deferred. However, it’s not always that simple. Some websites need complex features that rely heavily on JavaScript — these kinds of websites use JavaScript frameworks.

## Here Comes the Serverside Rendering

JavaScript frameworks can be fast if you’re willing to put in the work. We can put this work in with server-side rendering — where we generate the HTML on the server and send that down to the browser.

So, the user sees the HTML version of your app almost immediately, while the JavaScript app boots up in the background. This may not make your page load faster than a non-server-side rendered version, but it does give the user something to see as the JavaScript downloads in the background — a nice benefit.

## Surveys and Stats

Before discussing further, let’s see some stats from different online sources.

#### State of JavaScript

According to a survey on the state of JavaScript, we can see that Next is at the top of both Nuxt and Gatsby. Here, we do not want to consider Express since we only consider JavaScript frameworks for server-side rendering.

![Figure 01: [https://2019.stateofjs.com/back-end/](https://2019.stateofjs.com/back-end/)](https://cdn-images-1.medium.com/max/4244/1*-aPRuVhkDAfMp6chL8hjlQ.png)

According to the stats below, we can see the user attraction towards JavaScript-related backend frameworks. We can see that NextJS has higher usage and interest than NuxtJS and GatsbyJS.

![Figure 02: [https://2019.stateofjs.com/back-end/](https://2019.stateofjs.com/back-end/)](https://cdn-images-1.medium.com/max/4398/1*VTcI2ldavQoqePTHdyenhg.png)

#### GitHub repository stats

![Figure 03: [https://github.com/vercel/next.js/](https://github.com/vercel/next.js/)](https://cdn-images-1.medium.com/max/3562/1*TFDg_2S1N2e4RFtQ2muCwQ.png)

![Figure 04: [https://github.com/nuxt/nuxt.js](https://github.com/nuxt/nuxt.js)](https://cdn-images-1.medium.com/max/3564/1*F3CadZBwvdFjPpURd9u9Yg.png)

![Figure 05: [https://github.com/gatsbyjs/gatsby](https://github.com/gatsbyjs/gatsby)](https://cdn-images-1.medium.com/max/3574/1*IfqEwUiWIPnxGdmU9YDj6A.png)

According to these GitHub repositories, we can see that developers are becoming more attracted to NextJS — all watch numbers, folks, and the stars for the NextJS repository are higher. But Gatsby also has quite a similar popularity among developers.

## Why NextJS?

Next is one of the fastest growing React frameworks, especially for serverside rendering. The creators call NextJS a lightweight framework — personally, I think it’s more appropriate to think of it as a platform or perhaps even boilerplate.

![Figure 06: [https://2019.stateofjs.com/back-end/nextjs/](https://2019.stateofjs.com/back-end/nextjs/)](https://cdn-images-1.medium.com/max/4398/1*1byrI3kvuO35-xQSdB5D5Q.png)

#### Pros of NextJS

* It uses a web-pack on both client and server with hot module replacement by default. Babel also compiles your code using a bunch of presets like env or JSX by default.
* Everything is server-side rendered by default.
* You can start creating a somewhat complex React application inliterally four minutes. Also learning Next is no problem at all — the official site has its own learning page. You can also use the GitHub page.
* You can create routing by only creating JavaScript files inside one specific folder. Of course you can also create custom routing.
* The server uses node and you can do anything you want. For example, using Express.
* It automatically splits your application based on imports — unnecessary code is never loaded
* Fetching data is incredibly simple.
* Imagine you learn NextJS — what can you do with it? If you’re a freelancer, you can start a new project in no time. If you want to start a large project with potential, NextJS will be useful.
* You can configure anything you want from page initialization and route to your web pack and Babel configurations.
* You can deploy the NextJS app anywhere Node is supported.
* Completely handle search engine optimization for you.
* Overall NextJS does an incredible number of things for you.

#### Where not to use NextJS

If you’re building a simple app, I suggest NextJS would be overkill.

If you’re going to migrate a serverside app to the NextJS app, I would not suggest you do it at once, because you literally can’t — it’s a hell of a lot of work.

## Why Select NuxtJS?

NuxtJS is a higher-level framework built on top of VueJS to help you build production-ready Vue applications.

![Figure 07: [https://2019.stateofjs.com/back-end/nuxt/](https://2019.stateofjs.com/back-end/nuxt/)](https://cdn-images-1.medium.com/max/4404/1*nZe9YP8gl0d3FmZwoxaDsw.png)

#### Pros of NuxtJS

* Building a production-ready Vue application is difficult. Not only does Nuxt come pre-configured with Vuex, Vue Router, and Vue-meta. But it sets up your project with intelligent defaults based on well-researched best practices that Vue doesn’t give you out-of-the-box.
* Creating the Nuxt app is as easy. The Nuxt starter kit will ask you for the libraries you want to start with such as eslint or which CSS framework to use.
* Vue default build gives you assets and components in your source directory while Nuxt sets you up with additional folders, based on best practices such as the pages directory for your applications, views, and routes and a bunch of folders and default conventions.
* Since everything has its place, moving from one Nuxt application to another and getting up to speed as a developer is simple.
* Routing configuration can get lengthy in a big VueJS application. With Nuxt, you simply place your single file Vue components in the pages directory and Nuxt automatically generates your routes with zero configuration.
* Vue applications are not SEO friendly and you’re going to want certain pages of your applications properly indexed by search engines so they’re easily discoverable. One of the best solutions is to pre-render your view pages on the server. But this can be tricky to set up on your own. Nuxt is pre-configured to generate your application on the server along with powering up your routes to make it easy to add SEO related tags.

#### Where not to use NuxtJS

If you are building your application by using custom libraries, working with Nuxt can be challenging.

If the timeline of your Vue app is strict yuo may have problems if you’re new to Nuxt.

Debugging apps can be painful — this is a common issue among the developer community.

## Why Select GatsbyJS?

Gatsby is also a React based static website generator, powered by graphQL. Most simply, Gatsby is a static site generator. What does that mean? The static site part means Gatsby produces static HTML files that we load on to a server. This works differently to how many websites work.

It’s important to point out that static sites does not mean non-interactive or non-dynamic. We can load JavaScript into the HTML files that Gatsby serves, as well as make API calls, do interactions and build incredibly rich and immersive sites, even though they’re static.

![Figure 08: [https://2019.stateofjs.com/back-end/gatsby/](https://2019.stateofjs.com/back-end/gatsby/)](https://cdn-images-1.medium.com/max/4472/1*Gih1W60mstqRA1lnPxQJjg.png)

#### Pros of GatsbyJS

* Gatsby uses the graph QL querying language, graphQL, to get data from anywhere. However, the more exciting part of this is that we can get our data into a Gatsby site from anywhere.
* We can use markdown files we get access databases, we could hook into common CMS’s like WordPress and other headless CMS. However, Gatsby is not going to handle our data for us — rather it gets that data pulled into Gatsby and generates the site from that data.
* Gatsby also uses React and CSS, which hopefully you’re familiar with. React will be used for all of the templates and CSS for the styling. So, graphQL will pull in our data, React will take care of what the template should look like and the styling is what CSS, and then finally everything will be exported into the static Gatsby site.
* Gatsby is built with a plug-in architecture — this is a great system because we’re serving up a static site.
* Gatsby has a solid team open-source community and great documentation. It’s also an open-source project so has great potential for growth through community contribution.

#### Where not to use GatsbyJS

If you are going to use Gatsby with WordPress, you are going to use a lot of inbuilt WordPress functionalities — for example, you can’t use theme hooks.

Since Gatsby sites are static, every single change needs a new deployment.

![Photo by [Nathan Dumlao](https://unsplash.com/@nate_dumlao) on [Unsplash](https://unsplash.com/)](https://cdn-images-1.medium.com/max/2000/0*6GkumIALsOYIX3Tj)

## Conclusion

Based on the above pros and cons, and surveys, we can conclude that NextJS is the best serverside rendering framework for future implementations. However, if we look at the future for front end development, we can see that Vue is also doing well in the industry. Considering all the above factors, I suggest you learn and use NextJS.

Thanks for reading!

## Resources

* [https://2019.stateofjs.com/back-end/](https://2019.stateofjs.com/back-end/gatsby/)
* [https://github.com/vercel/next.js/](https://github.com/vercel/next.js/)
* [https://github.com/nuxt/nuxt.js/](https://github.com/vercel/next.js/)
* [https://github.com/gatsbyjs/gatsby](https://github.com/gatsbyjs/gatsby)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
