> * 原文地址：[Best Static Site Generators for Vue.js](https://blog.bitsrc.io/best-static-site-generators-for-vue-js-e273d52ea208)
> * 原文作者：[Chameera Dulanga](https://medium.com/@chameeradulanga)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/best-static-site-generators-for-vue-js.md](https://github.com/xitu/gold-miner/blob/master/article/2020/best-static-site-generators-for-vue-js.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[NieZhuZhu](https://github.com/NieZhuZhu)、[wynn-w](https://github.com/wynn-w)

# 四个优秀 Vue.js 静态站点生成器

![Photo by [Igor Son](https://unsplash.com/@igorson?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/green?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/9180/1*xKSrtHfuh8uTPcNyZmxjGw.jpeg)

在过去几年里，Vue.js 已经成为 web 应用程序开发的热门选择。随着它的流行，该框架已经扩展到曾经以 React 为主导的静态站点生成器领域。

像  Gatsby 和 NextJS 等这类 React.js 的静态网页生成器，你可以找到几个支持生成静态网页的 Vue.js 框架。然而，考虑到它们的功能特性，选择一个合适的并不容易。

因此，在本文中，我将介绍四个最佳 Vue.js 静态网页生成器框架，并进行详细的比较，以便你找到合适的框架进行使用。

## 1. Nuxt.js — 32k stars 和 280+ 贡献者

![Source: [https://nuxtjs.org/](https://nuxtjs.org/)](https://cdn-images-1.medium.com/max/3296/1*XyZK_B7uum1Da-Q0VZ6Niw.png)

首先要介绍的是 Nuxt.js，这是一个建立在 Vue.js 之上的开源框架。Nuxt.js 通过抽象客户-服务器分布细节来简化 web 开发。

Nuxt.js 遵循健壮的模块化架构设计，有 50 多个不同的模块可供使用。这些模块将提供内置支持，用以将 PWA 功能和标准功能（如谷歌分析）引入应用程序。

Nuxt.js 最大的优点之一是具有 `nuxt generate` 命令。

> 通过这个命令，你只要花费很少的精力就能开发一个纯静态的网站。

通过查看 Nuxt.js 的统计数据，你会发现它有 32k stars 和 280+ 贡献者。例如 GitLab、NESPRESSO 和 UBISOFT 这些公司已经开始使用 Nuxt.js。

#### 优点

* 优化支持。
* 服务器端渲染。
* 快速开发和运行快。
* 明确的项目结构
* 支持无服务器静态站点生成。
* 自动代码拆分。

#### 缺点

* 使用自定义库可能会有一些问题。
* 关于调试的使用存在很多待解决 issue。
* 有大型社区但仍比不上 Gatsby 和 Next.js。

## 2. VuePress — 针对以内容为中心的静态网站进行优化

![Source: [https://vuepress.vuejs.org/](https://vuepress.vuejs.org/)](https://cdn-images-1.medium.com/max/2468/1*6rBV7Id9ZvogzPotQBP9cA.png)

VuePress 是作为一个文档生成系统开发的另一个 Vue.js 静态站点生成器。然而，1.x 版本发布后，VuePress 被认为是一个静态文件生成器。

在 VuePress 中，每个页面都被视为一个标记文件，它们被呈现为一个 HTML 页面，并在页面加载时充当单页面应用程序。

根据官方文件，VuePress 主要由两部分组成：

1. 带有基于 Vue.js 主题系统的静态站点生成器。
2. 添加全局功能以及针对文档优化的默认主题的插件 API。

如果我们把 VuePress 和 Nuxt.js 进行比较，可以看到 Nuxt.js 几乎可以做到 VuePress 所能做到的一切。

> **然而，VuePress 更适合用来创建以内容为中心的静态网站，而 Nuxt.js 更侧重于网络应用程序开发。**

查看在 GitHub 的统计数据，VuePress 的项目仓库中有 17k stars 和 340+ 贡献者。它还被一些公司使用，例如 FinTech Consortium、IADC 和 Directus。

#### 优点

* 更好的加载性能。
* SEO 友好。
* 提供内置 markdown 扩展。
* 包含强大的搜索插件、PWA 功能、谷歌分析等。
* 带有 markdown 到 HTML 的默认转换处理。

#### 缺点

* 相比之下是新技术，还不如 Nuxt.js 那样受认可。
* 大多数共享主机提供商都没有安装 VuePress。

## 3.Gridsome — 基于 GraphQL 的数据驱动框架

![Source: [https://gridsome.org/](https://gridsome.org/)](https://cdn-images-1.medium.com/max/3122/1*fmNKCcOC47EB-KAdeXfD0g.png)

接下来要介绍的是 Gridsome，它以建立快速轻量静态网站而闻名。跟 React 中的 Gatsby 类似，Gridsome 是一个数据驱动的框架。Gridsome 使用一个 GraphQL 的数据层从数据源中获取内容，然后动态生成页面。

> GraphQL 充当 Gridsome 的内容管理系统。

你可以通过使用 `gridsome develop` 命令在本地运行项目，在 **localhost:8080/___explore** 上浏览这个 GraphQL 数据层。

同样，你可以使用 `gridsome build` 构建网站，它将生成可用于生产环境的优化 HTML 文件。

查看 Gridsome 的 GitHub 统计，它只有 7k stars 和 100+ 贡献者。但这并不妨碍 Gridsome 拥有一些独特且竞争力强的功能特性。

#### 优点

* 便捷的本地开发设置和热重载。
* 提供开箱即用的代码拆分、资源优化和渐进式图片展示，以提高性能。
* 支持 PWA 功能。
* SEO 友好。
* 结构清晰和自动配置路由。
* 丰富的插件。

#### 缺点

* 需要掌握 GraphQL 基础知识。
* 相比之下是新技术，还不如 Nuxt.js、VuePress 那样受认可。

## 4. Saber — 从不同的文件系统中提取数据

![Source: [https://saber.land/](https://saber.land/)](https://cdn-images-1.medium.com/max/2702/1*OR9DwoeaIjrjEAuPF0FhqA.png)

Saber.js 是另一个静态站点生成器，有大量的内置特性可以使用。

> 大概浏览一下 Saber.js，感觉更像是 Gatsby、Gridsome 和 Nuxt.js 的结合。

类似于 Gatsby 和 Gridsome，Saber 允许你用想要的数据创建静态网站。你可以从不同的文件系统中提取数据。使用 Saber，你就不用担心不会用 GraphQL。

Saber 使用其文件系统作为路由 API(与 Nuxt.js 非常类似)，具有很高的可扩展性。虽然 Saber 团队目前只支持 Vue.js，但它也计划扩展对 React 的支持。

由于 Saber 对这项业务来说仍然是新技术，它的 GitHub 项目也只有2k stars。我相信 Saber 框架只要稳定下来，它的 star 数量肯定会增加。

#### 优点

* 自动代码拆分。
* 基于文件系统的路由。
* 热代码重载。
* 内置 Markdown 支持。
* 支持 i18n。

#### 缺点

* 没有 CLI。
* 还处于 Beta 版本。

## 结论

在静态网站生成器领域，React 是首选，并占据了整个空间。然而，Vue.js 能够用我们上面讨论的那些优秀的框架来改变这种情况。此外，它们中的一些框架已经对基于 React 的框架构成了真正的威胁。

例如，Gatsby 和 Gridsome 在功能特性上看起来非常相似。除此之外，Gridsome 在使用表现、学习曲线、社区规模等方面已经能够追上 Gatsby。

让我们比较一下基于 Vue.js 的和基于 React 的静态站点生成器，可以看到像 Nuxt.js、VuePress、Gridsome 这样的框架有能力和 Gatsby、NextJS 竞争。

然而，当比较上述四个框架时，从 GitHub 和 [npmtrends.com](https://www.npmtrends.com/) 统计数据来看，其中 Nuxt.js 和 VuePress 是佼佼者。

![[npmtrends.com Stat Comparison](https://www.npmtrends.com/gridsome-vs-nuxt-vs-vuepress-vs-saber)](https://cdn-images-1.medium.com/max/2684/1*NsUUJyOV9gsT2Hwjmy-sbw.png)

![GitHub Statistics](https://cdn-images-1.medium.com/max/2000/1*2ydbJAirl8vJ3J8JA1M6xA.png)

但是，我们不应该忘记，这些框架中的每一个都有其独特的功能。例如，Saber 有可能成为全球热门，因为它计划扩大对 React 的支持。

我希望这篇文章能帮助你找到合适的框架。如果你有任何问题，请在下面的评论中提及。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
