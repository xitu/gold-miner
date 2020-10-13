> * 原文地址：[NextJS vs. NuxtJS vs. GatsbyJS](https://medium.com/better-programming/nextjs-vs-nuxtjs-vs-gatsbyjs-1a1fffb8895b)
> * 原文作者：[Mr Herath](https://medium.com/@keith95)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2020/nextjs-vs-nuxtjs-vs-gatsbyjs.md](https://github.com/xitu/gold-miner/blob/master/article/2020/nextjs-vs-nuxtjs-vs-gatsbyjs.md)
> * 译者：[z0gSh1u](https://github.com/z0gSh1u)
> * 校对者：[JohnieXu](https://github.com/JohnieXu)、[nia3y](https://github.com/nia3y)

# NextJS vs. NuxtJS vs. GatsbyJS

![由 [Kara Eads](https://unsplash.com/@karaeads) 发布于 [Unsplash](https://unsplash.com/)](https://cdn-images-1.medium.com/max/2000/0*nyUWEd-FwoOs3oyI)

所谓服务端渲染，就是将原先运行在客户端的 JavaScript 框架的渲染过程放在服务器上，渲染出静态的 HTML 和 CSS 的过程。

为什么说它很重要呢？

我们都想提升网站的加载速度 —— 而服务端渲染技术就是这么一个可以加速页面渲染的工具。下面我们来看一看页面渲染的关键步骤：浏览器渲染页面的关键步骤是接受服务端发送的关键数据并渲染成可视化的页面，如果我们能更快地将这些关键资源分发到浏览器，那么页面就可以更快地渲染好并呈现给用户。

## 服务端渲染的原理

浏览器渲染你的应用的速度，取决于你如何构建它。浏览器收到的第一个东西是 HTML 文档。文档包括了指向各种资源的引用 —— 如图片、CSS 和 JavaScript 代码。在浏览器解析 HTML 文档时，它知道要去获取并下载这些资源。所以，即使浏览器已经下载好了 HTML，也还是会在 CSS 解析完成之后才会开始渲染页面。

一旦 CSS 解析结束，浏览器便进一步地渲染页面。也就是说，只需要 HTML 和 CSS，浏览器就能渲染页面。我们都知道浏览器就擅长这个，所以这个过程是很快的。

现在，最后的一步是 JavaScript。HTML 文档解析结束后，浏览器会下载你的 JavaScript 文件。如果文件很大，或者网络状况很差，那下载时间会很长，而且浏览器还得解析 JavaScript。在硬件配置较差的设备上，这部分的时间消耗会很可观。并且，如果你的首次渲染依赖于 JavaScript，你还会多次地看到慢的加载过程。JavaScript 应被看作 HTML 和 CSS 的一个增强，因为它的加载是可以延迟的。然而，情况并不总是这么简单。有的网站需要一些严重依赖于 JavaScript 的功能 —— 这类网站使用了 JavaScript 框架。

## 服务端渲染的过程

上面提到的 JavaScript 框架的渲染过程其实也是可以优化的，比如可以在服务端提前完成其渲染过程，再将生成好的 HTML 下发至浏览器。

所以，用户几乎能立刻看到你之前在服务端提前生成好的 HTML 页面，同时 JavaScript 在后台启动执行。这不一定能让你的页面比非服务端渲染的版本加载的要快，但它确实能在 JavaScript 还在后台下载的过程中给用户一些能看到的内容 —— 这挺好的。

## 调查与统计

在我们进一步讨论之前，让我们来看看一些来自不同网站的统计信息。

#### JavaScript 的情况

根据一项关于 JavaScript 情况的调查，我们可以看到，Next 排在了 Nuxt 和 Gatsby 之前。在本文中，我们不会考虑 Express 等，因为我们只关注用于服务端渲染的 JavaScript 框架。

![图 01: [https://2019.stateofjs.com/back-end/](https://2019.stateofjs.com/back-end/)](https://cdn-images-1.medium.com/max/4244/1*-aPRuVhkDAfMp6chL8hjlQ.png)

根据下面的统计，我们可以看到用户对与 JavaScript 相关的后端框架的关注度。可以看出，NextJS 比起 NuxtJS 和 GatsbyJS，用户的使用量和兴趣都是最高的。

![图 02: [https://2019.stateofjs.com/back-end/](https://2019.stateofjs.com/back-end/)](https://cdn-images-1.medium.com/max/4398/1*VTcI2ldavQoqePTHdyenhg.png)

#### GitHub 仓库统计信息

![图 03: [https://github.com/vercel/next.js/](https://github.com/vercel/next.js/)](https://cdn-images-1.medium.com/max/3562/1*TFDg_2S1N2e4RFtQ2muCwQ.png)

![图 04: [https://github.com/nuxt/nuxt.js](https://github.com/nuxt/nuxt.js)](https://cdn-images-1.medium.com/max/3564/1*F3CadZBwvdFjPpURd9u9Yg.png)

![图 05: [https://github.com/gatsbyjs/gatsby](https://github.com/gatsbyjs/gatsby)](https://cdn-images-1.medium.com/max/3574/1*IfqEwUiWIPnxGdmU9YDj6A.png)

依据这些 GitHub 仓库，我们可以看到开发者越来越被 NextJS 所吸引 —— 不管是 Watch、Fork 还是 Star 数，NextJS 都来得高一些。但 Gatsby 在开发者之间也差不多受欢迎。

## 为什么选 NextJS？

Next 是快速成长的 React 框架之一，尤其是在服务端渲染方面。作者把 NextJS 称作一个轻量级框架。我个人认为把它看作一个平台或者是起始模板更合适。

![图 06: [https://2019.stateofjs.com/back-end/nextjs/](https://2019.stateofjs.com/back-end/nextjs/)](https://cdn-images-1.medium.com/max/4398/1*1byrI3kvuO35-xQSdB5D5Q.png)

#### NextJS 的优点

* 它默认在用户端和服务器端都使用支持热重载的 Webpack。Babel 也默认用诸如 env 或 JSX 的 preset 来编译你的代码。
* 所有东西默认都是服务端渲染的。
* 你可以在四分钟内起手写一个略为复杂的 React 应用。另外，学习 Next 也没有任何问题 —— 官方网站有专门的学习页面。你也可以看看它的 GitHub 页面。
* 你只需要在一个特定的目录下新建 JavaScript 文件，就能创建路由。当然你也可以自定义路由。
* 服务器端用的是 Node，你可以做任何你想做的事，比如用 Express。
* 它能基于 import 自动地拆分你的应用 —— 不必要的代码不会被加载。
* 获取数据极其简单。
* 想像一下你要学习 NextJS —— 你可以用它做什么？如果你是一个自由开发者，你可以很快开始一个新项目；如果你要构建一个潜在的大项目，NextJS 也会很有用。
* 你可以配置你需要的任何东西 —— 从页面初始化和路由，到 Webpack 和 Babel 配置。
* 在任何支持 Node 的环境都可以部署 NextJS 应用。
* 为你完整地处理了搜索引擎优化（SEO）。
* 总的来说，NextJS 为你做了大量的事情。

#### 不该用 NextJS 的地方

如果你在构建一个简单的应用，我估计 NextJS 会过犹不及。

如果你打算把一个服务端的应用集成到 NextJS 应用中，我不建议你立即就开始这么做，因为实际上是做不到的 —— 工作量太大了。

## 为什么选 NuxtJS？

NuxtJS 是在 VueJS 上层构建的高层次框架，能帮助你构建适用于生产环境的 Vue 应用。

![图 07: [https://2019.stateofjs.com/back-end/nuxt/](https://2019.stateofjs.com/back-end/nuxt/)](https://cdn-images-1.medium.com/max/4404/1*nZe9YP8gl0d3FmZwoxaDsw.png)

#### NuxtJS 的优点

* 构建一个可用于生产环境的 Vue 应用是比较复杂的。Nuxt 不仅预先配置好了 Vuex、Vue Router 和 Vue-meta，还聪明地使用基于充分的研究得来的最佳实践，来预设你的项目。 这些，Vue 并没有以开箱即用的方式提供给你。
* 创建 Nuxt 应用很简单。Nuxt 脚手架会问你要安装哪些库，比如 ESLint ，或者某个要用的 CSS 框架。
* Vue 的默认项目结构会把资源文件和组件文件放在你的源代码目录，而 Nuxt 把你的应用的页面、视图、路由和其他文件夹放在另外的、基于最佳实践的位置。
* 由于每样东西都有自己固定的位置，在 Nuxt 应用之间迁移和让开发者尽快上手项目是很简单的。
* 在大的 Vue 项目中，路由配置会很长。使用 Nuxt，你只需要把你的单文件组件放在页面目录下，Nuxt 就会自动零配置地生成路由。
* Vue 应用对 SEO 并不友好，而你会希望你的应用的某些页面能被搜索引擎恰当地索引，从而更容易被人找到。最好的解决方案之一是在服务器端预渲染你的页面，但靠自己来配置，可能需要很强的技巧性。而 Nuxt 已经被预设好了，能够借助路由配置在服务器端生成你的应用，并更容易添加 SEO 相关的 tag。

#### 不该使用 NuxtJS 的地方

如果你使用自定义的库来构建应用，使用 Nuxt 可能会颇具挑战性。

如果你第一次使用 Nuxt，同时你的 Vue 应用的开发计划排期比较紧，你可能会遇到一些问题。

应用调试会很痛苦 —— 这是开发者社区中的常见问题。

## 为什么选 GatsbyJS？

Gatsby 也是一个基于 React 的、GraphQL 驱动的静态站点生成器。更简单地说，Gatsby 是一个静态站点生成器。这是什么意思呢？静态站点的意思是我们放在服务器上的东西是由 Gatsby 生成的静态的 HTML 文件。这与许多网站的工作方式不同。

需要指出的是，静态站点并不意味着不可互动和非动态。我们可以在 Gatsby 服务器上的 HTML 文件中加载 JavaScript，发起 API 请求、进行交互、构建丰富大型的网站等，尽管它们是静态的。

![图 08: [https://2019.stateofjs.com/back-end/gatsby/](https://2019.stateofjs.com/back-end/gatsby/)](https://cdn-images-1.medium.com/max/4472/1*Gih1W60mstqRA1lnPxQJjg.png)

#### GatsbyJS 的优点

* Gatsby 使用 GraphQL —— 我们可以从任何地方导入数据到 Gatsby 站点，这太激动人心了。
* 我们可以使用从数据库中获取到的 Markdown 文件，可以接入常见的 CMS，例如 WordPress 或者其他的 Headless CMS。然而，Gatsby 并不会为我们处理数据 —— 它只是获取拉取到 Gastby 中的数据，并从数据中生成站点。
* Gatsby 也使用 React 和 CSS，你应该会很熟悉。React 用于所有的模板和 CSS 样式中。也就是说，GraphQL 会拉取来我们的数据，React 处理应该使用何种模板和 CSS 样式。最后，所有东西都会被导出到静态的 Gatsby 站点。
* Gatsby 是基于插件架构的 —— 由于我们在构建一个静态站点，这是一个很好的架构。
* Gatsby 有一个强大的团队、开源社区和完善的文档。它是一个开源项目，所以也很有从社区贡献中获得成长的潜力。

#### 不该使用 GatsbyJS 的地方

如果你要和 WordPress 一起使用 Gatsby，你需要换用很多 WordPress 内置的功能 —— 比如，你不能使用主题的自定义布局。

由于 Gatsby 站点是静态的，所以每个改动都需要一次新的部署。

![由 [Nathan Dumlao](https://unsplash.com/@nate_dumlao) 发布于 [Unsplash](https://unsplash.com/)](https://cdn-images-1.medium.com/max/2000/0*6GkumIALsOYIX3Tj)

## 结论

基于上面的优缺点和调查，我们可以得出结论：NextJS 是未来最好的服务端渲染框架。然而，如果我们看看前端开发的未来，我们可以看到，Vue 在实际项目开发中也表现得不错。基于上面的各项因素，我建议你学习和使用 NextJS。

感谢阅读。

## 资源

* [https://2019.stateofjs.com/back-end/](https://2019.stateofjs.com/back-end/gatsby/)
* [https://github.com/vercel/next.js/](https://github.com/vercel/next.js/)
* [https://github.com/nuxt/nuxt.js/](https://github.com/vercel/next.js/)
* [https://github.com/gatsbyjs/gatsby](https://github.com/gatsbyjs/gatsby)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
