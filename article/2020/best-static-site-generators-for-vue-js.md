> * 原文地址：[Best Static Site Generators for Vue.js](https://blog.bitsrc.io/best-static-site-generators-for-vue-js-e273d52ea208)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/best-static-site-generators-for-vue-js.md](https://github.com/xitu/gold-miner/blob/master/article/2020/best-static-site-generators-for-vue-js.md)
> * 译者：
> * 校对者：

# Best Static Site Generators for Vue.js

#### Get to know Nuxt.js, VuePress, Gridsome, and Saber in comparison

![Photo by [Igor Son](https://unsplash.com/@igorson?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/green?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/9180/1*xKSrtHfuh8uTPcNyZmxjGw.jpeg)

Over the past few years, Vue.js has become a popular choice for web application development. With its popularity, the framework has expanded its reach to static site generation, an area once dominated by React.

Like Gatsby and NextJS that uses React, you can find several frameworks using Vue.js that supports static site generation. However, choosing one isn’t that easy considering the features they provide.

Therefore, in this article, I will introduce the top four Vue.js frameworks for static site generation with a detailed comparison to find the right match for your use case.

---

## 1. Nuxt.js — 32000 Stars & 280+ Contributors

![Source: [https://nuxtjs.org/](https://nuxtjs.org/)](https://cdn-images-1.medium.com/max/3296/1*XyZK_B7uum1Da-Q0VZ6Niw.png)

First on our list is Nuxt.js, an open-source, high-level framework built on top of Vue.js. Nuxt.js simplifies web development by abstracting away client-server distribution details.

Nuxt.js follows a robust modular architecture, and there are more than 50 different modules to get started. These modules will provide the inbuilt support to bring in PWA features and standard functionalities such as Google analytics into your application.

One of the biggest strengths of Nuxt.js comes with the `nuxt generate` command.

> # With this command, you can generate a completely static version of your website with minimum effort.

If we look into the stats about Nuxt.js, it has more than 32000 stars and 280+ contributors. Companies like GitLab, NESPRESSO, and UBISOFT have started their journey with Nuxt.js.

#### Pros

* Optimization support.
* Server-side rendering.
* Fast development and runtime.
* Well-define project structure.
* Support serverless static site generation.
* Automatic code splitting.

#### Cons

* There can be challenges in using custom libraries.
* There are many issues reported regarding the ease of debugging.
* Large community but still behind Gatsby and Next.js.

---

## 2. VuePress — Optimized for Content Centric Static Sites

![Source: [https://vuepress.vuejs.org/](https://vuepress.vuejs.org/)](https://cdn-images-1.medium.com/max/2468/1*6rBV7Id9ZvogzPotQBP9cA.png)

VuePress is another static site generator power by Vue.js, and this was first developed as a document generation system. However, after the release of version 1.x, VuePress was considered as a static file generator.

In VuePress, each page is considered a markdown file, and they are rendered into an HTML page and act as a single page application when the page is loaded.

According to their official documentation, VuePress consists of 2 major parts:

1. Static site generator with a Vue.js-based theme system.
2. Plugin API to add global level functionality and a default theme that is optimized for documentation.

If we compare VuePress with Nuxt.js, we can see that Nuxt.js can almost do everything that VuePress is capable of.

> # However, VuePress is more optimized for content-centric static site creation, while Nuxt.js focuses more on web application development.

If we consider the GitHub stats, VuePress has more than 17800 stars and 340+ contributors in its repository. It is also used by companies like FinTech Consortium, IADC, and Directus.

#### Pros

* Better loading performance.
* SEO friendly.
* Provide built-in markdown extensions.
* Includes powerful plugins for searching, PWA features, Google analytics, etc.
* Handle markdown to HTML conversion by default.

#### Cons

* New in comparison and not yet established like Nuxt.js.
* VuePress isn’t installed on most shared hosting providers.

---

Tip: **Share your reusable components** between projects using [**Bit**](https://bit.dev/) ([Github](https://github.com/teambit/bit)).

Bit makes it simple to share, document, and reuse independent components between projects**.** Use it to maximize code reuse, keep a consistent design, collaborate as a team, speed delivery, and build apps that scale.

[**Bit**](https://bit.dev/) supports Node, TypeScript, React, Vue, Angular, and more.

![Example: exploring reusable React components shared on [Bit.dev](https://bit.dev/)](https://cdn-images-1.medium.com/max/3678/0*TGZuXdpfuFXkwLGS.gif)

---

## 3.Gridsome — Data-Driven Framework with GraphQL

![Source: [https://gridsome.org/](https://gridsome.org/)](https://cdn-images-1.medium.com/max/3122/1*fmNKCcOC47EB-KAdeXfD0g.png)

Third on our list is Gridsome, and it is known for building lighting fast static websites. Similar to Gatsby in React, Gridsome is a data-driven framework. Gridsome uses a GraphQL layer to get content from the sources and then dynamically generates pages from it.

> # GraphQL acts as a content management system for Gridsome.

You can explore this GraphQL data layer at **localhost:8080/___explore** by running the project locally using `gridsome develop` command.

Similarly, you can build your website using `gridsome build`, ****and it will generate production-ready optimized HTML files.

If we went through the GitHub statistics of Gridsome, it only has 7000 stars and 100 odd contributors. Besides, Gridsome brings some unique features with it to compete with others.

#### Pros

* Easy local development setup with hot reloading.
* Provides code-splitting, asset optimization, progressive images out of the box to Increase performance.
* PWA ready.
* SEO friendly.
* Well defined structure and automatic routing.
* Rich plugins.

#### Cons

* Need to have basic knowledge of GraphQL.
* New in comparison and not yet established like Nuxt.js, VuePress.

---

## 4. Saber — Extract Data from Different File Systems

![Source: [https://saber.land/](https://saber.land/)](https://cdn-images-1.medium.com/max/2702/1*OR9DwoeaIjrjEAuPF0FhqA.png)

Saber.js is another static site generator with a large number of built-in features to play with.

> # After going through Saber.js for a while, I feel that it is more like a combination of Gatsby, Gridsome, and Nuxt.js.

Similar to Gatsby and Gridsome, Saber allows you to create static web sites with the data you want. You can extract data from different file systems. With Saber, you won’t need to worry about GraphQL.

Saber uses its file system as the routing API (which is very similar to Nuxt.js), and it is highly extensible. Although it only supports Vue.js for now, the Saber team has planned to extend the support for React as well.

Since Saber is still new to the business, it only has 2000 stars in its GitHub repo. I’m sure that these numbers will improve once the framework gets stable.

#### Pros

* Automatic code splitting.
* File-system based routing.
* Hot code reloading.
* Built-in Markdown support.
* Support i18n.

#### Cons

* Don’t have a CLI.
* Still at the Beta version.

---

## Conclusion

When it comes to static site generators, React was the number 1 choice and dominated the space. However, Vue.js was able to change that situation with those fantastic frameworks we discussed above. Besides, some of them have been a real threat to React-based frameworks.

For example, Gatsby and Gridsome look pretty much similar in the way they behave. Besides, Gridsome has been able to keep up with Gatsby in terms of performance, learning curve, community size, etc.

Let’s compare Vue.js based ones with React-based static site generators. We can see that frameworks like Nuxt.js, VuePress, and Gridsome have the capacity to compete with Gatsby and NextJS.

However, when comparing the above four frameworks, Nuxt.js and VuePress are at the top based on their GitHub and [npmtrends.com](https://www.npmtrends.com/) statistics.

![[npmtrends.com Stat Comparison](https://www.npmtrends.com/gridsome-vs-nuxt-vs-vuepress-vs-saber)](https://cdn-images-1.medium.com/max/2684/1*NsUUJyOV9gsT2Hwjmy-sbw.png)

![GitHub Statistics](https://cdn-images-1.medium.com/max/2000/1*2ydbJAirl8vJ3J8JA1M6xA.png)

However, we shouldn’t forget that each of these frameworks has unique features in its arsenal. For example, Saber has the potential to be a global hit since it has plans to extend support for React.

I hope this article has helped you to find the right framework for your use case. If you have any questions, please mention them in the comments below.

---
[**4 Best Practices for Large Scale Vue.js Projects**
**Building enterprise-level Vue.js projects.**blog.bitsrc.io](https://blog.bitsrc.io/4-best-practices-for-large-scale-vue-js-projects-9a533450bdb2)
[**Quasar vs. Vutify vs. Bootstrap Vue: Choosing the Right Vue.js UI Library**
**Insight to determine the best UI library for your Vue project**blog.bitsrc.io](https://blog.bitsrc.io/quasar-vs-vutify-vs-bootstrap-vue-choosing-the-right-vuejs-ui-library-cf566f61bc4)
[**11 Vue UI Component Libraries You Should Know In 2019**
**11 Vue.js component libraries tools and frameworks for your next app in 2019.**blog.bitsrc.io](https://blog.bitsrc.io/11-vue-js-component-libraries-you-should-know-in-2018-3d35ad0ae37f)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
