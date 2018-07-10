> * 原文地址：[How to Choose the Best Static Site Generator in 2018](https://medium.com/dailyjs/how-to-choose-the-best-static-site-generator-in-2018-98bff61c8184)
> * 原文作者：[Mathieu Dionne](https://medium.com/@MathDy24?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-choose-the-best-static-site-generator-in-2018.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-choose-the-best-static-site-generator-in-2018.md)
> * 译者：[ssshooter](https://github.com/ssshooter)
> * 校对者：

# 2018 年,如何选择最好的静态站点生成器

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

截止到现在已经有非·常·多静态站点生成器了。

即使我们已经做了 15+（还在增加）个[演示和教程](https://snipcart.com/blog/categories/jamstack)，也无法覆盖所有静态站点生成器。

我难以理解 [JAMstack](https://jamstack.org/) 和静态页面生态系统的开发人员的感受……

![](https://cdn-images-1.medium.com/max/800/0*YikT2JWUObtnzO0d.gif)

大概像爱丽丝踏入仙境那样吧。

为了解决这个问题，我们决定把我们的知识综合到一块。

本文结束时，你应该能够**对各个项目都能找到对应的最佳静态站点生成器（Static site generators 缩写 SSG）。**

你可以学习到以下内容：

1. 它们是什么（以及为什么要使用它们）。
2. 现在最好的静态站点生成器是什么。
3. 在选择 **SSG** 之前的注意事项。

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

### 1. 静态站点生成器是什么？

如果你看本文的目标是寻找合适的 SSG，那么你应该很清楚 SSG 是什么啦，不过在我这里解释一下也无伤大雅。

静态网站不是什么新鲜事物。它们是我们在动态 CMS（WordPress，Drupal 等）之前用来构建 Web 的方式。

那有什么新特性？

过去几年中出现的现代的静态站点生成器，扩展了静态站点的功能。

简而言之，静态站点生成器会获取您的站点内容，将其应用于模板，并生成纯静态HTML文件，以便传递给访问者。

![](https://cdn-images-1.medium.com/max/800/0*xztT5nlj6UvKWHU-.png)

与传统的 CMS 相比，这一处理过程带来了许多好处。

### 为什么要使用 SSG？

每次访问者在内容繁多的网站上跳转，必须动态地从数据库中提取信息，这可能导致页面呈现速度慢，从而用户流失。

SSG 将已编译的文件提供给浏览器，大大减少了加载时间。

→ **安全性和可靠性**

使用动态 CMS 开发的最大威胁之一是缺乏安全性。动态 CMS 复杂的后端架构产生了很多潜在风险。

而使用静态设置，几乎没有使用服务器端功能。

→ **灵活性**

老旧繁琐的传统 CMS 不灵活。扩展的唯一方法是使用现有插件，或者为某个平台定制。如果不懂技术直接用倒是很爽，但开发人员发现自己各种被束缚。

SSG 对技术要求可能会稍高，但自由度同样也高。他们中的大多数还有插件生态系统，主题和易于插入第三方服务。此外，使用其核心编程语言的可扩展性是无限的。

→ **他们的弱点……正在消失。**

随着 SSG 生态系统的不断发展，很多主要问题都被新工具解决。

**内容管理和管理任务**对于没有技术背景的用户来说可能并不简单。但好消息是，现在有大量的 headless CMS（无头 CMS） 可以[完善](https://snipcart.com/blog/headless-ecommerce-guide)你的 SSG。headless 和传统 CMS 之间的区别在于，您只能将前者用于“内容管理”任务，而不是模板和前端内容生成。你总会发现一个适合你的需求。

一些静态站点 CMS 直接支持SSG。例如，Jekyll 和 Hugo 的 [Forestry](https://forestry.io/#/) 或者普遍适用的[DatoCMS](https://www.datocms.com/)。

如果你需要一些**动态的特性**，也有很多很棒的服务可供选择：

*   实现后端功能的 [Serverless](https://serverless.com/) 或 [Webtask](https://webtask.io/)
*   用于部署的 [Netlify](https://www.netlify.com/)
*   用于搜索的 [Algolia](https://www.algolia.com/)
*   电商方面可以考虑 Snipcart
*   用户生成内容（如评论）可以考虑 [Disqus](https://disqus.com/) 或 [Staticman](https://staticman.net/)


这里只是[其中](https://www.thenewdynamic.org/tool/)几个例子。

> **通过将这些开发进度转化为业务优势，将 JAMstack 和静态站点生成器发布给你的客户，[**阅读本指南**](https://snipcart.com/blog/jamstack-clients-static-site-cms)了解更多。**

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

### 2. 应该选择哪个静态站点生成器？

了解 SSG 是什么是一方面，弄明白哪个 SSG 更适合自己又是另一回事了。

网上有超过 400 种 SSG。如果你要是从静态 Web 开始开发，以下内容将有助于你的决策！

我将介绍其中最好的一部分，但请记住它仅仅是所有现有 SSG 种的一小部分。完整列表建议访问[staticgen.com](https://www.staticgen.com/)。

### 2.1 2018年最佳静态站点生成器

在本节中，我将为你介绍那些广为人知并且可以满足大多数项目的需求的 SSG。这个推荐基于这些项目的热度，也取决于我们团队建立[数十个 JAMstack demo](https://github.com/snipcart) 的经验。

[**Jekyll**](https://jekyllrb.com/)

![](https://cdn-images-1.medium.com/max/800/0*xlMOOB3Swx-sifym.png)

Jekyll 仍然是最受欢迎的 SSG，具有庞大的用户群和大量插件。作为个人博客非常适合，也被电子商务网站广泛使用。

Jekyll 对新手来说的一个主要卖点是各种 **importer**。它能使现有站点相对轻松地迁移到 Jekyll。例如，如果你有 WordPress 站点，则可以使用 importer 切换到 Jekyll。

并且，Jekyll 可以让你专注于内容而无需担心数据库，更新和评论审核，同时保留永久链接，类别，页面，帖子和自定义布局。

Jekyll 用 Ruby 构建，并集成到 GitHub Page 中，因此被黑客攻击的风险要低得多。主题可以简单更换，自带 SEO，并且 Jekyll 社区提供了大量的自定义插件。

→ Jekyll 教程：

*   [静态电商网站：集成 Snipcart 与 Jekyll](https://snipcart.com/blog/static-site-e-commerce-part-2-integrating-snipcart-with-jekyll)
*   [Jekyll CloudCannon CMS：构建多语言网站](https://snipcart.com/blog/cms-jekyll-cloud-cannon-multilingual)
*   [Staticman 用户内容生成 + Jekyll 静态网站](https://snipcart.com/blog/staticman-dynamic-content-static-website)

* * *

[**Gatsby**](https://www.gatsbyjs.org/)

![](https://cdn-images-1.medium.com/max/800/0*QtVY1u5_t419rHWH.png)

Gatsby 将静态页面带到前端技术栈，依靠浏览器端 JavaScript，可重用 API 和预构建标记。这是一个易用的解决方案，可以使用React.js，Webpack，现代 JavaScript，CSS 等创建 SPA（单页应用程序）。

Gatsby.js 是一个静态 PWA（Progressive Web App）生成器。它仅提取关键的 HTML，CSS，数据和 JavaScript，以便您的网站尽可能快地加载。

其丰富的数据插件生态系统允许网站从无头 CMS，SaaS 服务，API，数据库，文件系统等渠道拉取数据。

Gatsby 应用广泛，对于需要利用来自多个来源的数据的站点而言，它是不二之选。它正在走向顶峰，如果它在未来几个月成为头号 SSG，请不要感到惊讶。

哦，它也可能解决了 SSG 最大的开发难题之一：长原子构建（long atomic build）。创作者 Kyle Matthews 以 Gatsby 为主[最近建立了一家公司](https://thenewstack.io/gatsbyjs-the-open-source-react-based-SSG-creates-company-to-evolve-cloud-native-website-builds/)。Gatsby Inc. 将为 Gatsby 网站构建一个云基础架构，可以实现增量构建，甚至可以说是改变了 SSG 的游戏规则了。

→ Gatsby 教程：

*   [Snipcart & Gatsby 搭建 ReactJS 无后台电商网站](https://snipcart.com/blog/snipcart-reactjs-static-ecommerce-gatsby)
*   [Grav CMS + Gatsby + GraphQL](https://snipcart.com/blog/react-graphql-grav-cms-headless-tutorial)
*   [静态表单，授权，无服务器功能（Gatsby + Netlify Demo）](https://snipcart.com/blog/static-forms-serverless-gatsby-netlify)

* * *

[**Hugo**](https://gohugo.io/)

![](https://cdn-images-1.medium.com/max/800/0*PAL4JxBh4U-dISqu.png)

一个易于设置，用户友好的 SSG，部署运行网站不需要太多配置。

Hugo 以其构建速度而闻名，而其[数据驱动内容](https://gohugo.io/templates/data-templates/)的特性可以轻松地基于 JSON / CSV 源生成HTML。你通过很少的代码就能使用预先构建的模板快速设置SEO，评论，分析和其他功能。

此外，Hugo 为多语言网站提供全面的 i18n 支持，受众面大大增加。这对于想要本地化的电商网站特别有用。

最近，他们[发布](https://gohugo.io/news/0.42-relnotes/) 了一种先进的主题功能，这可以让你使用可重用组件构建 Hugo 站点。

→ Hugo 教程：

*   [搭建高速静态电商网站](https://snipcart.com/blog/hugo-tutorial-static-site-ecommerce)
* [Hugo的静态电子商务与Forestry.io中的产品管理]（https://forestry.io/blog/snipcart-brings-ecommerce-static-site/#/）
*   [Forestry.io & Hugo 静态电商网站](https://forestry.io/blog/snipcart-brings-ecommerce-static-site/#/)
*   [6 种简易工具给你优秀，快速的静态电商体验](https://www.netlify.com/blog/2015/08/25/a-great-fast-static-e-commerce-experience-with-6-easy-tools/)

* * *

[**Next.js**](https://nextjs.org/)

![](https://cdn-images-1.medium.com/max/800/0*H6lYvOXmQMfbhMBf.jpg)

Next.js 本质上不只是 SSG，它是一个用于静态服务端渲染的 React 轻量框架。

Next.js 构建可以在浏览器端和服务器上都可运行的通用 JavaScript 应用程序。这个过程提升了这些应用程序在首页加载和搜索引擎优化功能方面的表现。Next.js 包括自动代码拆分，简单的前端路由，基于 webpack 的开发环境和任何 Node.js 服务器实现等一整套功能。

JavaScript 现在无处不在，React 是现在最流行的 JS 前端框架，所以它绝对值得一看。

→ Next.js 教程：

*   [Next.js 教程：SEO 友好的 React 电商单页应用](https://snipcart.com/blog/react-seo-nextjs-tutorial)
*   [用 Next.js 客户端渲染 ReactJS 应用](https://egghead.io/lessons/next-js-introducing-build-a-server-rendered-reactjs-application-with-next-js)

* * *

[**Nuxt.js**](https://nuxtjs.org/)

![](https://cdn-images-1.medium.com/max/800/0*L1wlu2hgtpcRYfcr.png)

名字和功能都与 Next.js 相似，但 Nuxt 是用于创建 Vue.js 应用程序的框架。它可以在抽象出客户端/服务器分布的同时启用 UI 呈现。它还有一个用于构建静态 Vue.js 应用程序的 **nuxt generate** 选项。

这种用于无服务器的简约框架使用十分简单，但它更倾向于程序化实现而不是传统的 DOM 脚手架。

由于 Nuxt 是 Vue 框架，因此强烈建议你先了解 Vue，当然之前使用 Vue 的开发者会感到宾至如归。随着 Vue.js 的迅速崛起，[我们也用 Vue 重构了项目](https://snipcart.com/blog/progressive-migration-backbone-vuejs-refactoring)，所以最后当然要推荐以下它啦。

> **如果你是Vue.js 用户，你也可以了解一下[**VuePress**](https://vuepress.vuejs.org/)**

→ Nuxt教程：

*   [Cockpit CMS & Nuxt.js 全栈教程](https://snipcart.com/blog/cockpit-cms-tutorial-nuxtjs)
*   [Nuxt.js 服务器端渲染、路由与页面跳转](https://css-tricks.com/simple-server-side-rendering-routing-page-transitions-nuxt-js/)

* * *

### 2.2 主要考虑因素

本节将采用另一种方法，帮助你找到最适合自己的 SSG。

在选择合适的工具之前，你应该先问自己这些问题：

#### **1. 您是否需要开箱即用的大量动态功能和扩展？**

这里有两个流派：

1. 选择一个提供大量开箱即用的功能的静态站点生成器。不需要大量的插件或自己构建一切。如果你是这样想的，**Hugo** 提供了大量内置功能，其次 **Gatsby** 也挺适合于这个情况。
2. 选择功能较少的 SSG，但提供广泛的插件生态系统，并且允许你根据需要扩展和自定义设置。这可能是 **Jekyll** 最大的优势之一。它长期以来如此热门，社区也逐渐完善，各种各样的插件也随之而出现。为了进一步推动这一概念， [**Metalsmith**](http://www.metalsmith.io/) 或 [**Spike**](https://spike.js.org/) 将设置交给插件，其具有高度可定制性让其无所不能。要权衡的是，它对技术要求很高，但如果你想学习 SSG 运行的语言，这可能是一线希望！

#### **2. 你在意构建和部署时间吗？**

正如我已经提到的，一般静态站点的速度就已经很有优势，但是个别 SSG 更是非一般的快。

这局的赢家明显是 **Hugo**。它以其超快的构建时间而闻名，可以在几毫秒内将内容和模板组合成一个简单站点，以这个速度几秒钟内可以完成数千页。

诸如 **Nuxt** 之类的响应式框架也非常适合性能和搜索引擎优化。

![](https://cdn-images-1.medium.com/max/800/0*kScgW22S3zvfmDF0.png)

Jekyll 在这方面就不怎么样了 -- 许多开发人员抱怨它的构建速度。

#### **3. 你想用 SSG 处理什么类型的项目？**

各个 SSG 实现的目的并不相同，选择前想清楚你的网站类型可以省掉很多麻烦事。

→ **博客或小型个人网站**：

**Jekyll** ，答案显而易见。它本身就为博客而生，它可以抽象出博客的主要内容。**Hexo** 是搭建简单博客平台的[另一个选择](https://snipcart.com/blog/hexo-ecommerce-nodejs-blog-framework)。不过，其实大多数 SSG 都可以做博客或个人网站。

也可以了解一下：Hugo，Pelican，Gatsby。

→ **文档**：

**GitBook** 使编写和维护高质量的文档变得容易，现在已是最流行的文档工具。

也可以了解一下 Docusaurus，MkDocs。

→ **电子商务**：

您还可以用 SSG 生成电商网站（如前面的教程中所示）。但电商网站不好做，需要考量的东西十分多：用户体验方面，例如速度和UI定制，搜索引擎优化也是必不可少的。

大型电商网站需要 CMS 进行产品管理，这个时候就要思考哪个 SSG 更适合你选择的无头 CMS。

根据我们的经验，我们推荐 **Gatsby** 和 **Nuxt** 这样的响应式框架。但如果你还是需要一切从简，你可以考虑 **Jekyll** 或 **Hugo**。

→ **营销网站**：

之前还没提过 [**Middleman**](https://middlemanapp.com/)。它的与众不同之处在于它可以灵活搭建任何类型的网站，而不是专注于博客引擎。这对于高级营销网站来说非常棒，MailChimp 和 Vox Media 等公司也将它用于自己的网站。

也可以了解一下 Gatsby，Hugo，Jekyll。

#### **4. 你是否希望自己修改网站和生成器？是否需要使用自己精通的语言？**

以下是各个框架使用的语言：

*   **JavaScript**：Next.js & Gatsby（适用于 React）、Nuxt & VuePress（适用于 Vue）、Hexo、GitBook、Metalsmith、Harp、Spike。
*   **Python**：Pelican、MkDocs、Cactus.
*   **Ruby**：Jekyll、Middleman、Nanoc、Octopress.
*   **Go**：Hugo、InkPaper。
*   **.NET**：Wyam、pretzel。

#### **5. 非技术用户是否需要管理此网站？**

开发并网站构建后，网站内容的管理员是谁？在大多数情况下，他们不是技术人员，他们很难通过代码进行内容管理。

这种情况应该将有无头 CMS 的 SSG 放在首位。CMS 的选择很重要，找到可以对接的 SSG 同样重要。

**Gatsby** 的新功能，[使用 GraphQL 实现](https://www.gatsbyjs.org/docs/querying-with-graphql/)。这里不解释[ GraphQL 是啥](https://snipcart.com/blog/graphql-nodejs-express-tutorial)，简而言之，它可以实现更快更简洁的数据查询。

#### **6. 你依赖社区和同行的帮助吗？**

如果答案是肯定的，请考虑前面列出的顶级静态站点生成器。这些都是目前最受欢迎的 SSG，社区活跃，案例研究和各种资源的支持都不会落后。

注意，现代静态网站和 JAMstack 仍然是一个相对较新的生态系统的一部分，如果你用的工具用户不多，踩到坑可能就要自己填了。

![](https://cdn-images-1.medium.com/max/800/1*4877k4Hq9dPdtmvg9hnGFA.jpeg)

### 总结

到最后我还是不会告诉你，你应该选择什么 SSG，你应该按自己的情况自己做选择。

现在你可以认真思考一下真正吸引你的是什么。有一件事是肯定的，SSG 一定就会给你自由和灵活的感觉！

你会推荐什么静态网站生成器？JAMstack 生态系统将何去何从？我真的很想听听大家的意见，请在下面的评论中加入讨论！

如果您喜欢这篇文章，就在 Twitter 上分享一下吧！

![](https://cdn-images-1.medium.com/max/800/1*ZrJKJqBsksWd-8uKM9OvgA.png)

**首发地址** [_Snipcart blog_](https://snipcart.com/blog/choose-best-static-site-generator) **本文地址（英语）** [_newsletter_](http://snipcart.us5.list-manage2.com/subscribe?u=c019ca88eb8179b7ffc41b12c&id=3e16e05ea2)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
