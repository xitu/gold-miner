> * 原文地址：[Small Websites Are Dying](https://blog.bloomca.me/2018/12/03/small-websites.html)
> * 原文作者：[Seva Zaikov](https://blog.bloomca.me)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/small-websites-are-dying.md](https://github.com/xitu/gold-miner/blob/master/TODO1/small-websites-are-dying.md)
> * 译者：[EmilyQiRabbit](https://github.com/EmilyQiRabbit)
> * 校对者：[wznonstop](https://github.com/wznonstop)，[xionglong58](https://github.com/xionglong58)

# 正在消失的小型网站

网站正在日益增大，JavaScript 也在飞速发展、升级，为了能跟上时代，你需要将你的代码从最新的版本[转译](https://babeljs.io/)成浏览器兼容的模式（尽管这非常复杂，但相信 [babel](https://babeljs.io/docs/en/babel-preset-env) 能搞定）。此外，你也可以使用其他语言编写网页，比如 [typescript](https://www.typescriptlang.org/)。而在 typescript 之前，已经有过很多相关尝试([1](http://www.gwtproject.org/)，[2](https://coffeescript.org/)，[3](https://clojurescript.org/) 等等)，但一个重要的事实是，typescript 被建议要广泛应用于专门处理大型应用的场景。

## 单页面应用（SPA）之路

在历史上，小型页面是由静态 HTML 和一些零散的 JavaScript 组成的。我敢打赌现在很多传统的服务端渲染应用（比如 [Django](https://www.djangoproject.com/) 或者 [Ruby on Rails](https://rubyonrails.org/)）还是这样做的，但是这样的方式一点也不酷了，所以就算还有人使用它们，可能也仅仅是 API。这些页面（不管是静态页面或者服务端渲染页面）都有很多特设脚本，它们看上去都一团糟。维护和测试就更像是噩梦，这些代码要么就是非常长，要么就是以某种奇怪的方式连接起来。

而当这样的脚本转变成了[单页应用](https://en.wikipedia.org/wiki/Single-page_application)，这绝对是一件好事 —— 现在，至少我们的应用是部分可维护的了，使用了[合适的模块引入](https://webpack.js.org/)，以及许多允许开发者处理复杂接口，路由，多屏数据共享，跨应用甚至整个网站（例如开源组件）的 UI 元素复用的[闪亮](https://reactjs.org/)[框架](https://vuejs.org/)。但是，本篇文章并不是关于它们的 —— 我已经[吐槽](https://blog.bloomca.me/2018/02/04/spa-is-not-silver-bullet.html)过现在人们已经将 SPA 作为所有项目的默认选项；这篇文章是关于**小型**网站的。

## jQuery 的兴衰

在这之前，[jQuery](https://jquery.com/)还是主宰，它有**庞大**的插件生态圈，提供滑动窗口，图片展示以及丰富的动态效果等等。同时，它的集成简单，通常只是用某些参数（甚至是默认值就可以）初始化一些插件，并提供元素 id。其他内容通常都在标记中指定（或需要特定的标记规则），HTML 作为一种声明式语言，完全可以辨认出指定的内容。事实上，jQuery 使用范围如此之广，很多人们都很[奇怪](https://webmasters.stackexchange.com/questions/84683/why-dont-browsers-have-jquery-installed)为什么不把 jQuery 默认的加载到浏览器中。jQuery 也有很多很方便的功能（甚至可以称为 DOM 缺失的标准库），它让已经简单的交互变得极其简单。

事实上，我相信 jQuery 依旧在被广泛的使用着（我没有任何数据，只是我自己的直觉），但是有了很重要的改变。如今，jQuery 已经[不那么让人满意](http://youmightnotneedjquery.com/)，你也不会发现有很多教程，教你如何不用很了解 JavaScript 就快速写出一个页面小脚本。同时，大约五年前，库的标准就是：

*   在一些 CDN 上存储最小化后的代码
*   把它提供的功能绑定在全局变量上（比如 window.Backbone）

现在一些库依旧会打包[构建全局模块定义（UMD）](https://github.com/umdjs/umd)，它其实就是一个加载库的全局变量版，但是很多库已经不这样做了。现在，出现了更多的新的框架，这些小插件都是专门服务于框架的了，而你不仅仅是需要它们（如果你需要 jQuery 插件，那么你也需要 jQuery 这个库），而是需要用这个框架来完成你所有的页面！

## 现代解决方案

当然，这个问题已经解决，解决方法就是在已有基础上提供启动方式或者特定框架，然后你就可以使用这些小插件并编译为一个静态网站。此外，它们会在后台使用上述工具加载模块或者编译代码，所以你可以使用 JavaScript 的最新版本，并将逻辑拆分为最佳可复用的单元。这种方式的一个很好的例子就是 [GatsbyJS](https://www.gatsbyjs.org/) 和 [Nuxt.js](https://nuxtjs.org/)。启动方式通常是命令行，例如 [create-react-app](https://github.com/facebook/create-react-app)，它将繁琐的步骤都隐藏了起来，并且仅仅需要给应用一个指令 —— “只管运行”，然后你就可以开始编写组件了。

尽管如此，这种变化带来了哪些问题呢？代码的维护性更高了（这都多亏了模块），你可以使用最新版的 JavaScript，还能保证所有不支持的功能都有可以替代的补丁，这在之前是很容易出现问题的地方。但是其实，问题有很多，在我看来：

*   现在你必须非常了解 JavaScript（需要比之前更深的理解）
*   不仅是 JavaScript，你可能还需要知道 webpack（为了处理静态资源加载 —— 想象一下你忽然发现代码中在引用图像）
*   现在，你的工作包括了使用大约 200MB 的文件**构建**应用（而不是编写文档）。
*   让你的小应用膨胀起来是像滑下坡那么容易的事情。

我认为最后一部分是最值得关注的。很多教程都会建议你添加一些高级数据管理库，用某些特定的，“更声明式”的方法重构你的代码（想想那些人经常试图说服你重构 HTML 结构），然后很多人就会按照教程建议的做了！这些建议是好的，但是可能只适用于大型网站，而不是那种小型的，用 5 个 `.html` 文件就能完成的。是的，你不能复用这个菜单，但是你可以直接复制它们（同时 CSS 类让它在**某种形式上**能复用了）。

## 总结

也许我是错的，也许并没有那么糟糕。但是使用互联网、阅读博客、查看网页时，我觉得这些曾经每个人只要有 HTML 的只是和极少的 JS 技术就能完成的小型网站，正在慢慢消失，现在更多的网站被替换为更加“可扩展”的应用了。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
