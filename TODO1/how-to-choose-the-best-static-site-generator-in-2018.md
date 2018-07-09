> * 原文地址：[How to Choose the Best Static Site Generator in 2018](https://medium.com/dailyjs/how-to-choose-the-best-static-site-generator-in-2018-98bff61c8184)
> * 原文作者：[Mathieu Dionne](https://medium.com/@MathDy24?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-choose-the-best-static-site-generator-in-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-choose-the-best-static-site-generator-in-2018.md)
> * 译者：
> * 校对者：

# How to Choose the Best Static Site Generator in 2018

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

So.

Many.

Static site generators.

Even for us who’ve done 15+ (and counting) [demos & tutorials](https://snipcart.com/blog/categories/jamstack) with them, it can get quite overwhelming.

I can’t believe what it must be like for a developer just learning about the JAMstack and static web ecosystem.

![](https://cdn-images-1.medium.com/max/800/0*YikT2JWUObtnzO0d.gif)

Like landing in freakin’ Wonderland

To try and help them, we decided to synthesize our knowledge into one comprehensive piece.

By the end of this post, you should be able **to find the best static site generator (SSG) for any particular project.**

Here’s what you’ll learn about SSGs:

1.  What they are (and why you should use them).
2.  What are the best static site generators, today.
3.  Considerations to keep in mind before choosing _the one_.

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

### 1. Static site generators, what are they?

If you’re here looking for the right SSG, I assume you have a decent understanding of what they are. Still, a bit of context can’t hurt.

Static sites aren’t new. They were what we used to build the web way before dynamic CMS (WordPress, Drupal, etc.) took over.

What’s new, then?

The modern tools — static site generators, mainly — that came out in the last years expanded the capabilities of static sites.

Simply put, a static site generator takes your site content, applies it to templates, and generates a structure of purely static HTML files ready to be delivered to visitors.

![](https://cdn-images-1.medium.com/max/800/0*xztT5nlj6UvKWHU-.png)

This process brings its share of benefits when compared to traditional CMSs.

### Why use them?

Having to dynamically pull information from a database every time a visitor hits a page on a content-heavy site can result in delays that cause frustration and bounces.

SSGs serve already compiled files to the browser, cutting load times by a large margin.

→ **Security & reliability**

One of the biggest threats of developing with a dynamic CMS is the lack of security. Their need for bigger server-side infrastructures opens the way for potential breaches.

With static setups, there’s little to no server-side functionality.

→ **Flexibility**

Opinionated and cumbersome traditional CMSs are constraining. The only way to scale is with existing plugins and customization is limited to available theming platforms. That’s cool if you’re a non-technical user, but developers quickly find themselves hands tied.

SSGs might ask for more technical skills but will reward developers with freedom. Most of them also have plugin ecosystems, theming and easy to plug third-party services. Plus, extendability using their core programming language is limitless.

→ **Their weaknesses are… disappearing.**

With an ever-growing ecosystem surrounding static site development, many of its main issues are finding answers through new tools.

_Content management and administrative tasks_ can be challenging for end users who don’t have a technical background. Good news is there’s an impressive number of headless CMSs out there [ready to complete](https://snipcart.com/blog/headless-ecommerce-guide) your SSG. The difference between headless and traditional CMSs being that you’ll use the former only for “content management” tasks, not templating and frontend content generation. I bet you’ll find one fitting your needs.

Some static site CMSs support SSGs straight up. For instance, [Forestry](https://forestry.io/#/) for Jekyll & Hugo or [DatoCMS](https://www.datocms.com/) for many of them.

As for _dynamic features_ necessary for a great user experience? There’s a bunch of awesome services available:

*   [Serverless](https://serverless.com/) or [Webtask](https://webtask.io/) for backend functions,
*   [Netlify](https://www.netlify.com/) for deployment,
*   [Algolia](https://www.algolia.com/) for search,
*   Snipcart for e-commerce,
*   [Disqus](https://disqus.com/) or [Staticman](https://staticman.net/) for user-generated content.

These are just a few examples of [what’s out there](https://www.thenewdynamic.org/tool/).

> _Sell the JAMstack and static site generators to your clients by translating these development advances into business benefits._ [_Read this guide_](https://snipcart.com/blog/jamstack-clients-static-site-cms) _to know more._

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

### 2. Which static site generator should you choose?

Knowing what static site generators are and why you should use them is one thing, knowing which one to adopt is a whole other endeavour.

There are over 400 of them roaming the web these days. If you’re only starting with static web development, what follows will help your decision-making process!

I’ll cover some of the best ones out there, but remember that it’s still a small portion of all existing SSGs. For a complete list, I suggest you visit [staticgen.com](https://www.staticgen.com/).

### 2.1 Best static site generators in 2018

In this section, I present the ones I consider you SHOULD know and that will answer the needs of most projects. These choices are based on general popularity but also on our team’s experience building [dozens of JAMstack demos](https://github.com/snipcart).

[**Jekyll**](https://jekyllrb.com/)

![](https://cdn-images-1.medium.com/max/800/0*xlMOOB3Swx-sifym.png)

Still the most popular SSG, with a large user base and a big directory of plugins. It’s great for blogs and also widely used by e-commerce sites.

One of Jekyll’s key selling points for newcomers is its wide range of _importers_. It enables an existing site to be migrated to Jekyll with relative ease. If you have a WordPress site, for example, you can switch to Jekyll using one of them.

Jekyll then allows you to focus on the content without worrying about databases, updates, and comment moderation while preserving permalinks, categories, pages, posts, and custom layouts.

It’s built with Ruby and integrated into GitHub Pages, so there’s a much lower risk of getting hacked. Theming is simple, SEO is baked in, and the Jekyll community offers a lot of plugins for customization.

→ Jekyll Tutorials:

*   [Static Site E-Commerce: Integrating Snipcart with Jekyll](https://snipcart.com/blog/static-site-e-commerce-part-2-integrating-snipcart-with-jekyll)
*   [CloudCannon CMS for Jekyll: Building a Multilingual Site](https://snipcart.com/blog/cms-jekyll-cloud-cannon-multilingual)
*   [Staticman for User-Generated Content on a Jekyll Static Website](https://snipcart.com/blog/staticman-dynamic-content-static-website)

* * *

[**Gatsby**](https://www.gatsbyjs.org/)

![](https://cdn-images-1.medium.com/max/800/0*QtVY1u5_t419rHWH.png)

Gatsby brings static pages to frontend stacks, leveraging client-side JavaScript, reusable APIs, and prebuilt Markup. It’s an easy-to-use solution that creates an SPA (Single Page Application) with React.js, Webpack, modern JavaScript, CSS, and more.

Gatsby.js is a static PWA (Progressive Web App) generator. It pulls only the critical HTML, CSS, data, and JavaScript so that your site can load as fast as possible.

Its rich data plugin ecosystem lets a website pull data from a variety of sources, including headless CMSs, SaaS services, APIs, databases, file systems, and more.

Gatsby has a wide range of applications and is a solid choice for sites that need to utilize data from many sources. It’s on its way to the top, don’t be surprised if it becomes the number one SSG in the next few months.

Oh, and it might also fix one of the biggest dev pains with SSGs: (long) atomic builds. Creator Kyle Matthews [recently created a company](https://thenewstack.io/gatsbyjs-the-open-source-react-based-ssg-creates-company-to-evolve-cloud-native-website-builds/) on top of his open source project. Gatsby Inc. will build a cloud infrastructure for Gatsby sites that might enable incremental builds — a game changer for SSGs.

→ Gatsby Tutorials:

*   [ReactJS E-Commerce With No Backend Using Snipcart & Gatsby](https://snipcart.com/blog/snipcart-reactjs-static-ecommerce-gatsby)
*   [Grav as Headless CMS Tied to Gatsby with GraphQL Schema](https://snipcart.com/blog/react-graphql-grav-cms-headless-tutorial)
*   [Static Forms, Auth & Serverless Functions (Gatsby + Netlify Demo)](https://snipcart.com/blog/static-forms-serverless-gatsby-netlify)

* * *

[**Hugo**](https://gohugo.io/)

![](https://cdn-images-1.medium.com/max/800/0*PAL4JxBh4U-dISqu.png)

An easy-to-set-up, user-friendly SSG that doesn’t need much config before you get the site up and running.

Hugo is well-known for its build speed, while its [data-driven content](https://gohugo.io/templates/data-templates/) features make it easy to generate HTML based on JSON/CSV feeds. You can also write your own shortcodes and use the pre-built templates to quickly set up SEO, comments, analytics, and other functions.

In addition, Hugo provides full i18n support for multi-language sites, making it easy to reach an international audience. This is particularly useful for e-commerce merchants who want to localize their websites.

Plus, they [recently announced](https://gohugo.io/news/0.42-relnotes/) an advanced theming feature that offers a powerful way of building Hugo sites with reusable components.

→ Hugo Tutorials:

*   [How to Build & Host a (Very Fast) Static E-Commerce Site](https://snipcart.com/blog/hugo-tutorial-static-site-ecommerce)
*   [Static E-Commerce on Hugo with Product Management in Forestry.io](https://forestry.io/blog/snipcart-brings-ecommerce-static-site/#/)
*   [A Great, Fast Static E-Commerce Experience with 6 Easy Tools](https://www.netlify.com/blog/2015/08/25/a-great-fast-static-e-commerce-experience-with-6-easy-tools/)

* * *

[**Next.js**](https://nextjs.org/)

![](https://cdn-images-1.medium.com/max/800/0*H6lYvOXmQMfbhMBf.jpg)

While not necessarily an SSG per se, Next.js is a lightweight framework for static and server-rendered React applications.

It builds Universal JavaScript apps, meaning that JS runs both on client and server. This process has boosted these apps’ performances in first-page load and SEO capabilities. Next.js’ set of features includes automatic code splitting, simple client-side routing, webpack-based dev environment and any Node.js server implementation.

JavaScript is everywhere nowadays, React being the trendiest JS frontend framework as of today, so it’s definitely worth a look.

→ Next.js Tutorial:

*   [Next.js Tutorial: SEO-Friendly React E-Commerce SPA](https://snipcart.com/blog/react-seo-nextjs-tutorial)
*   [Introducing Build a Server-rendered ReactJS application with Next.js](https://egghead.io/lessons/next-js-introducing-build-a-server-rendered-reactjs-application-with-next-js)

* * *

[**Nuxt.js**](https://nuxtjs.org/)

![](https://cdn-images-1.medium.com/max/800/0*L1wlu2hgtpcRYfcr.png)

Similar in name and purpose to Next.js, Nuxt is a framework for creating Universal Vue.js Applications. It enables UI rendering while abstracting away the client/server distribution. It also got a deployment option called _nuxt generate_ to build static generated Vue.js applications.

This minimalistic framework for going serverless is straightforward and simple but is arguably geared more toward programmatic implementation instead of a traditional DOM scaffolding.

Since Nuxt is a Vue framework, familiarity with Vue is strongly recommended, but developers who have worked with Vue before will feel right at home. With the quick rise of Vue.js in the JavaScript ecosystem — and considering [our collective love](https://snipcart.com/blog/progressive-migration-backbone-vuejs-refactoring) for it — , no wonder it ends up on this list.

> _If you’re a Vue.js fan, you could also check out_ [_VuePress_](https://vuepress.vuejs.org/)_._

→ Nuxt Tutorials:

*   [A Tutorial to Bundle Cockpit CMS & Nuxt.js in a full JAMstack](https://snipcart.com/blog/cockpit-cms-tutorial-nuxtjs)
*   [Simple Server Side Rendering, Routing, and Page Transitions with Nuxt.js](https://css-tricks.com/simple-server-side-rendering-routing-page-transitions-nuxt-js/)

* * *

### 2.2 Main considerations

This section will take another approach in helping you discover your soul mate SSG. You’ll find a few new ones here I haven’t mentioned in the last section.

Here are some questions you should ask yourself before choosing the right tool:

#### **1. Do you need lots of dynamic features & extensions out of the box?**

There are two schools of thoughts here.

1.  Pick a static site generator offering a great number of features out-of-the-box. You won’t need tons of plugins or build everything by yourself. In that case, _Hugo_ presents a huge set of built-in functionalities with which you can get straight to work. _Gatsby_ also fits the bill here.
2.  Pick an SSG that comes with fewer features, but offers a wide plugin ecosystem that allows you to expand and customize your setup as needed. This probably represents one of _Jekyll_’s greatest strengths. The fact that it has been so popular for so long has translated into a large community and a wide array of plugins. To push this notion even further, [_Metalsmith_](http://www.metalsmith.io/) or [_Spike_](https://spike.js.org/) leave all manipulations to plugins, making them highly customizable and able to build anything. The trade-off here is that this asks for a higher level of technical proficiency to handle use cases. But this might be a silver lining if you’re trying to learn the language your SSG is running on!

#### **2. How important is your build & deploy time?**

As I’ve already mentioned, static sites, in general, are a great improvement for speed, but some SSGs push the bar further.

The clear winner here is _Hugo_. It’s well-known for its blazing fast build times. It can put together a simple site from markup and templates in milliseconds and go through thousands of pages in seconds.

Reactive frameworks such as _Nuxt_ are also great for performances & SEO purposes.

![](https://cdn-images-1.medium.com/max/800/0*kScgW22S3zvfmDF0.png)

This is one area where Jekyll actually looks bad — many developers complain about its build speed.

#### **3. What is the type of project you want to handle with an SSG?**

Consider your project’s end goal. Not all generators are created for the same results, and you’ll save a lot of pain by choosing one that is specialized for what you’re trying to achieve.

→ **Blog or small personal websites**:

_Jekyll_ is the obvious one to mention here. It presents itself as a blog-aware SSG abstracting everything that could get in the way of what really matters on a blog: the content. _Hexo_ is [another one](https://snipcart.com/blog/hexo-ecommerce-nodejs-blog-framework) you should consider for building a simple blogging platform. Ultimately though, most SSGs will do the job in this area.

Also check out: Hugo, Pelican, Gatsby.

→ **Documentation**:

_GitBook_ makes it easy to write and maintain high-quality documentation and is easily the most popular tool of this kind.

Also check out: Docusaurus, MkDocs.

→ **E-Commerce**:

You can also easily integrate a shop on most static site generators (as seen in previous tutorials). E-Commerce can be tricky though, as many aspects come into consideration. Think about user-experience related aspects such as speed and UI customization. SEO is also something you don’t want to disregard when developing a business online.

For larger stores where you might need a CMS for product management, ask yourself which SSG will be the better fit for the headless CMS of your choice.

With these in mind, drawing from our own experiences we suggest looking at reactive frameworks like _Gatsby_ & _Nuxt_. But it doesn’t mean you should put aside friendlier options like _Jekyll_ or _Hugo_ if you need to keep everything simple.

→ **Marketing website**:

One I still haven’t mention yet is [_Middleman_](https://middlemanapp.com/). What differentiates this one from the bunch is that it aims to provide the flexibility to craft any type of site, instead of being heavily geared towards a blogging engine. It’s great for advanced marketing websites and companies like MailChimp and Vox Media have used it for their own.

Also check out: Gatsby, Hugo, Jekyll.

#### **4. If you’re willing to modify the site and/or generator yourself, do you need it to be in a particular language you’re well-versed in?**

If so, here’s where you should look at for the following languages:

*   **JavaScript**: Next.js & Gatsby (for React), Nuxt & VuePress (for Vue), Hexo, GitBook, Metalsmith, Harp, Spike.
*   **Python**: Pelican, MkDocs, Cactus.
*   **Ruby**: Jekyll, Middleman, Nanoc, Octopress.
*   **Go**: Hugo, InkPaper.
*   **.NET**: Wyam, pretzel.

#### **5. Are non-technical users going to work on this site?**

After the development part is done and the website is built, who is going to run it and edit its content? In most cases, this falls in the hands of non-technical users who’ll have a hard time navigating through code repos.

Here’s where you should strongly consider pairing your SSG with a headless CMS. Not only the choice of CMS is important, but also finding the right SSG to attach on the frontend is crucial.

_Gatsby_ has pushed this thinking forward with one of their latest feature, a [GraphQL implementation](https://www.gatsbyjs.org/docs/querying-with-graphql/). I won’t go into explaining [what GraphQL is](https://snipcart.com/blog/graphql-nodejs-express-tutorial), but in short, it enables faster less-bloated data queries.

#### **6. Is community and help from peers important to you?**

If so, consider one of the top static site generators listed earlier. These are the most popular right now and are backed by the most active communities spawning plugins, case studies, and resources of all kinds.

Remember that modern static sites and the JAMstack are still part of a relatively new ecosystem, and if you start with less known tools you’ll rapidly discover the lack of help available.

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

### Closing thoughts

I won’t end this post by telling you which static site generator is the best and which one you should choose. Primarily because I simply don’t have the answer, but also because you should now have enough information to make that call yourself.

All you need to do now is go out and explore every possibility that seems attractive to you. One thing’s for sure, it’s that you should have fun doing it as SSGs finally give freedom and flexibility back to developers.

What static site generator would you recommend? What’s next for the JAMstack ecosystem? I really want to hear from you, so join the discussion in the comments below!

If you’ve enjoyed this post, please take a second to share it on Twitter.

![](https://cdn-images-1.medium.com/max/800/1*ZrJKJqBsksWd-8uKM9OvgA.png)

_I originally published this on the_ [_Snipcart blog_](https://snipcart.com/blog/choose-best-static-site-generator) _and shared it in our_ [_newsletter_](http://snipcart.us5.list-manage2.com/subscribe?u=c019ca88eb8179b7ffc41b12c&id=3e16e05ea2)_._

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
