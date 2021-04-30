> * 原文地址：[5 Reasons to Switch from React to Next.js](https://javascript.plainenglish.io/5-reasons-to-switch-from-react-to-next-js-f776413693d0)
> * 原文作者：[anuragkanoria](https://medium.com/@anuragkanoria)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/5-Reasons-to-Switch-from-React-to-Next-js.md](https://github.com/xitu/gold-miner/blob/master/article/2021/5-Reasons-to-Switch-from-React-to-Next-js.md)
> * 译者：[Zz招锦](https://github.com/zenblo)
> * 校对者：[Kim Yang](https://github.com/KimYangOfCat)、[Cyberhan123](https://github.com/Cyberhan123)


# 从 React 转换到 Next.js 的五个理由

> 选择错误的框架可能会成为一个可怕的噩梦。

![图源 [arash payam](https://unsplash.com/@arash_payam?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7936/0*_KSkOhjmAnWJXTY9)

那是在 2020 年，第一次疫情封城刚开始的时候。像全球各地的人们一样，我发现自己有计划外的闲暇时间。

我决定利用这段闲暇时间学习新技术，最终学习了 React 并提升了我的 Node.js 技能。

我构建了一个博客平台，前端部分使用 React，后端部分使用 Node.js 服务器。该平台具有你所期望的一个标准应用程序所具有的所有功能。

 1. 多种账号登录选项（用谷歌、Twitter 账号等登录）。

 2. 功能丰富的编辑器，可以写出漂亮的博客。

 3. 能够创建草稿和编辑已发表的文章。

 4. 分析以及管理面板。

在这个过程中，我学到了一些关于 Web 开发的很有价值的经验知识。

从用户的角度来看，一切似乎都很好，但对于开发者来说，维护项目代码是一场噩梦。

这时我才明白 Next.js 的标语 —— “用于生产的 React 框架”的真正含义。

![源自[Next.js 站点](https://nextjs.org/)](https://cdn-images-1.medium.com/max/2672/1*sQGE3HQsLTifb1-BDf_ydg.jpeg)

我从 React 转到 Next.js 主要有以下五个原因。

## 1. React 对 SEO 不友好

每一个博客或一个可生产的网站都需要为搜索引擎进行优化（SEO），除了一些像控制面板或用户设置的网站。

已经快一年了，但我的 React 网站的大部分博客仍然没有出现在谷歌搜索上，即使我专门使用 URL 和其他工具进行搜索。

此后，我尝试过使用 [React Helmet](https://www.npmjs.com/package/react-helmet) 等库来对 React 网站进行搜索引擎优化。

React 对 SEO 不友好，是因为它不在服务器端渲染。与之相对，Next.js 的主要优势是它支持服务器端渲染。

一个好的搜索引擎优化方案可以提升有效流量，Next.js 似乎是能够保证这一点的解决方案。

然而，我想指出的是，客户端 ReactJS 应用程序并不是不能被谷歌机器人爬取。它们是能被爬取的，只是其 SEO 效果不如 Next.js 所提供的好。

如果你想详细了解 JavaScript 应用程序中的渲染和 SEO，请查看我的博客，在那里我用通俗的语言讲解过这些话题。
在建立了多个网站之后编写的初级 JavaScript 网络应用程序 SEO 指南：
[以下是我学到的关于有效流量和 SEO 的内容——javascript.plainenglish.io](https://javascript.plainenglish.io/a-beginners-guide-to-seo-for-javascript-web-applications-c67d55728291)    

## 2. AdSense 审核问题

React 创建单页应用程序（SPA），该应用程序本质上是一个单页，只需要加载一次。

当你浏览页面并跳转到其它页面时，数据将动态加载。

尽管单页应用程序以快速响应和提供原生应用程序而闻名，但它们确实存在缺点。

当尝试使用 [Google 的 AdSense](https://www.google.com/adsense/start/#/?modal_active=none) 来获取网站收益时，我发现了一个缺点。

AdSense 不是简单地检测他们要求我放入 index.html 文件中的代码，更出人意料的是，它根本找不到该网站上的任何内容。

这是因为博客是动态加载的，并且 AdSense 需要在批准网站展示广告之前先查看真实内容。

通过简单的 Google 搜索，我发现这是许多单页应用程序网站的常见问题。

这个问题根源是缺乏适当的服务器端渲染支持，而 Next.js 可以轻松解决它。

## 3. 更简单的导航

理解 React 的导航和路由需要花费很大的学习成本，特别是当这个人之前使用 Vue 这样的框架（比如我）。

React 的路由使用了一个叫 `React-Router-Dom` 依赖包，代码看上去似乎很复杂。[这里有一个 React 路由的示例](https://reactrouter.com/web/example/basic)。

由于我的网站功能丰富，拥有大量的页面，从预设的博客和注册页到常见问题和服务条款页。

Next.js 简化了所有这些页面的路由。它提供了一个基于文件系统的路由导航，建立在页面的概念上，而页面基本上就是一个 React 组件。

将这些页面文件添加到 pages 目录中，会自动使它成为一个路由。

这极大简化了路由配置，作为一个从 Vue 和 Nuxt 转换过来的开发者，这似乎很容易接受。

你可以在[这里](https://nextjs.org/docs/routing/introduction)找到更多相关信息。

## 4. 支持 API 路由

Next.js 内置了对 API 路由的支持，这使你能够使用已知的基于文件系统快速创建 API 端点。

你放在 `pages/api` 目录下的任何文件都将被视为 API 端点（作为一个 Node.js 的 serverless 功能）。

如果你需要运行一些服务器端的功能，这将是非常有用的特性，因为这些端点并不是客户端依赖包的一部分。

例如，如果你的网站上有一个输入表单，你可以向 API 端点发送 POST 请求，它将验证输入并将数据存储到数据库中。

这基本上可以让你创建 serverless 功能，它使我能够将 Node.js 和 React 代码合并为单一的 Next.js 应用程序。

Next.js 创建的前端 API 路由是 Next 利用本身的数据完成的。

如果你打算创建一个移动应用程序并从服务器获取数据，它可以提供帮助。

## 5. 内置图像组件

正如我前面提到的，我建立了一个博客网站，任何博客都需要有媒体内容以及文本。

单独看这个博客本身，除了书面内容，它还有一些图片。

[根据 Next.js 文档说明，图像占网页内容的 50%](https://nextjs.org/blog/next-10#images-on-the-web:~:text=Images%20take%20up%2050%25%20of%20the%20total%20bytes%20on%20web%20pages.)。

通常，媒体文件的大小有一个限制，例如 25 MB。

此外，一些加载的图片不在用户的视口中，也就是说，用户必须向下滚动才能看到图片。

因此，必须考虑许多因素，如懒加载、压缩、大小和格式。

Next.js 使用图像组件和自动图像优化功能解决了所有这些问题，它取代了HTML 的 `<img>` 标签。

通过使用它，图像在默认情况下被懒加载，浏览器适配图像的尺寸，在图像加载前留出空白。这就避免了图像的随机跳入，提高了用户体验。

此外，Next.js 的 `next/image` 组件使用最新的格式，如 WebP，按需缩小图片大小，WebP 比 JPEG 对应的图片要轻 30%。

此外，这些优化是按需进行的，所以不会影响构建时间，来自外部的图像也会被优化。

## 本文总结

React 是[最流行的框架](https://www.codeinwp.com/blog/angular-vs-vue-vs-react/)，毫无疑问，它是每个 Web 开发者必学的内容。

然而，这并不意味着 React 适用于每一种类型的网站。像其他框架一样，React 也有自己的不足。

构建于 React 之上的 Next.js 旨在为 React 的一些问题提供解决方案，同时也通过引入一些现代的内置解决方案来促进应用程序开发。

从 React 切换到 Next 是可行的，但如果你刚开始，请明智地选择 Next 而不是 React。

必须说明的是，在每个项目中使用 Next.js 而完全抛弃 React 也是不可取的。

每个网站和应用程序的建立都有其特定的意图和目标，这在选择正确的框架和库时可以起到至关重要的作用。

不幸的是，在我的案例中，我在完全用 React 构建网站之后，才发现我应该用 Next.js 而不是 React，原因就在上面。

希望你能从我的错误中学到一些东西，并能选择一个合适的框架。

感谢你的阅读！

更多内容请访问 [plainenglish.io](https://plainenglish.io/)。
> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
