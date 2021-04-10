> * 原文地址：[The New King of Bundlers Is Here: All Bow Before Vitejs](https://blog.bitsrc.io/the-new-king-of-bundlers-is-here-all-bow-before-vitejs-fe6f42c97ce9)
> * 原文作者：[Fernando Doglio](https://medium.com/@deleteman123)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/the-new-king-of-bundlers-is-here-all-bow-before-vitejs.md](https://github.com/xitu/gold-miner/blob/master/article/2021/the-new-king-of-bundlers-is-here-all-bow-before-vitejs.md)
> * 译者：[zenblo](https://github.com/zenblo)
> * 校对者：[Badd](https://juejin.cn/user/1134351730353207)、[5Reasons](https://github.com/5Reasons)

# 新型前端构建工具 Vitejs 开发使用

![[Paweł Furman](https://unsplash.com/@pawelo81?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/s/photos/king?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText)](https://cdn-images-1.medium.com/max/13714/1*LlgpXcXbw-wEPTqxiRDDDw.jpeg)

在我刚接触编程的时候，JavaScript 只是被用来给网站添加一些交互效果。你还记得如何添加鼠标拖拽效果吗？或者如何在鼠标悬停时改变链接颜色？

当然，多年来，Web 开发已经有了很大的发展，如今 JavaScript 在 Web 应用中的使用量正在呈指数级增长。正因为如此，JavaScript 愈加笨重的依赖包正在成为它的瓶颈。

一些应用程序的依赖包体积已经影响到用户使用应用程序前的等待时长了（在依赖包下载完成之前，他们无法使用应用程序），构建过程本身也导致开发时间的增加（有时改变一行代码就会触发一个需要几分钟的编译过程）。虽然有一些技术可以帮助解决这个问题，但并不是所有的技术都能斩草除根，而能斩草除根者往往需要花费大量精力才能实现。作为这些构建工具的使用者，你或许不在意它的实现技术，但如果你是构建工具的开发者，那么维护起来就会变得非常痛苦。

这就是为什么今天我想向你介绍一款能解决所有这些问题的工具：[ViteJS](https://vitejs.dev/)。

## ViteJS 为何如此优秀

显然，这是你应该问自己的第一个问题。

已经有很多的构建工具了，你还需要一个吗？是的，你需要。

ViteJS 不仅仅是一个构建工具。事实上，ViteJS 的目标是成为构建任何基于 JavaScript 项目的首选工具。它改变了通常的构建工具对依赖包的处理方式，直接利用 ES 模块来打包构建，让浏览器来完成一些工作。

它还大量使用 HTTP 缓存不更改的代码。所以，与其使用一个巨大的依赖文件，把所有的代码发送给客户端，不如由客户端决定保留哪些代码和经常刷新哪些代码（下文会详细阐述）。

你可能要注意的 ViteJS 功能特性：

* **构建时考虑到了处理时效**。ViteJS 所做的少量依赖和转码工作，都是使用 [esbuild](https://esbuild.github.io/) 来完成的，而 esbuild 是建立在 Go 中的。这反过来又提供了更快的体验（根据他们的说法，比任何基于 JavaScript 的构建工具快 10~20 倍）。
* **与 TypesScript 兼容**。虽然它不执行类型检查，但通常你的 IDE 会处理这个问题，你甚至可以在构建脚本中添加一个快速的单行代码来为你做这件事（快速的 `tsc --noEmit`）。
* **它支持热模块替换（HMR）**。ViteJS 提供了一个 [API](https://vitejs.dev/guide/api-hmr.html#hot-data)，供任何 ESM 兼容的框架使用。
* **改进了代码拆分技术**。ViteJS 实现了对浏览器正常分块加载过程的一些改进。这确保了如果有机会并行加载几个分块，它们将以这种方式加载。

事实上，ViteJS 的功能特性还在继续增加，所以一定要去 ViteJS 网站查看更多详情。

## ViteJS 内置插件系统

ViteJS 的主要优势之一是它内置了一个插件系统，这意味着社区可以（并且已经）给其他框架（如 React 和 Vue）添加额外的功能和插件。

### Vue 项目使用 ViteJS

[Vue 的插件列表](https://github.com/vitejs/awesome-vite#vue)是相当丰富的，唯一需要注意的是，这些插件并不都是兼容同一个版本的框架（有的插件适用于 Vue 2，而有的插件只适用于 Vue 3，有的则是两者都适用）。

为了让你的 Vue App 方便使用，你可以使用一个插件，例如 [Vitesse](https://github.com/antfu/vitesse)，你可以简单地克隆和重命名。它预装了多种内置功能和插件，例如：

* [**WindiCSS**](https://github.com/windicss/windicss) 作为 UI 框架和 [**WindiCSS 排版**](https://windicss.netlify.app/guide/plugins.html#typography)。
* [**Iconify**](https://iconify.design/) 允许你使用网络上多个图标库的图标。
* **ViteJS 的 [Vue i18n 插件](https://github.com/intlify/vite-plugin-vue-i18n)**，增加国际化支持。
* **VS Code 扩展系列** (例如 Vite 的 `dev server`、`i18n ally`、`WindiCSS`、`Iconify Intellisense` 等)，如果你是 VS Code 用户，这是很好的选择。

还有更多的内置功能，一定要去看 [Repo](https://github.com/antfu/vitesse)。

如果你只是想从头开始，构建自己的应用，你也可以简单地使用 ViteJS 的 CLI 工具。

```bash
# 如果你正在使用 npm 7
$ npm init @vitejs/app my-vue-app -- --template vue 

# 如果你正在使用 npm 6
$ npm init @vitejs/app my-vue-app --template vue

# 如果你是一个偏向于使用 yarn 的开发者
$ yarn create @vitejs/app my-vue-app --template vue
```

以上任意一个命令都会产生相同的输出：

![](https://cdn-images-1.medium.com/max/2860/1*2pPul6Se15bcLeUJpwTHDA.png)

它的速度真的很快（不到一秒），在遵循这额外的三个步骤后，你的 Vue 应用就会启动并运行。

![](https://cdn-images-1.medium.com/max/2092/1*hfPIpmBPpAffHUcwhMa1Qg.png)

### React 项目使用 ViteJS

你不是 Vue 开发者？没问题，Vite 可以帮你解决。

只需使用与之前相同的命令行，并且使用 `react` 或 `react-ts` 代替 `vue` 就可以了。

```bash
$ npm init @vitejs/app my-react-app --template react-ts
$ cd my-react-app
$ npm install
$ npm run dev
```

以上命令行将使用 TypeScript 输出相同的 React 应用程序。

![](https://cdn-images-1.medium.com/max/2368/1*UMWnw5t9qw1Lj2Ffo-UxLA.png)

你想要更多的预设吗？根据你的需求可以找到两个插件：

1. 如果你正在寻找一个带有 TypeScript、[Chakra](https://chakra-ui.com/) 和 [Cypress](https://www.cypress.io/) 的项目，你可以使用这个[插件](https://github.com/Dieman89/vite-reactts-chakra-starter)。
2. 如果你不想使用 Chakra，而是想创建一个 Electron 应用，你可以使用这个[插件](https://github.com/maxstue/vite-reactts-electron-starter)，它还包含了 [TailwindCSS](https://tailwindcss.com/)。

这两个选项都可以和 TypeScript 一起使用，如果你熟悉这些组合，我建议你选择使用这些插件而不是从头开始。你要知道，默认的启动项目是完全没有问题的，但是你可以通过这些插件得到一部分已经完成的模板设置。

## 关于其它构建工具

ViteJS 并不是第一个尝试这样做的工具，也绝对不是最知名的。但它之所以被创造出来，是因为目前的主流工具并没有用行业的最新趋势来解决性能问题。他们还在试图解决一些鉴于当今最先进的技术而不应该存在的问题。

ViteJS 和其他构建工具（如 Webpack）的主要区别在于，后者会尝试通过你的依赖树，编译和优化打包后的代码，以更好地让任何浏览器获取你的代码。注意这里的**任何**一词，因为这将是 ViteJS 的主要问题。然而，这个过程需要时间，如果你一直在使用这些成熟的构建工具，你可能知道我的意思。它需要一段时间，但最终的结果对任何浏览器来说都是好的。

另一方面，我们有 ViteJS，就像我已经提到的，它利用了浏览器的 ES 模块支持。这意味着浏览器将负责处理 `import` 和 `export`，并单独请求它们。这意味着你可以在短时间内让你的应用运行起来，但这也意味着只有新的浏览器才能兼容你的应用。

从下面的 [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules) 表格中可以看出，现代浏览器对 `import` 的支持是很好的，但是，旧版本永远无法支持。

![MDN 截图](https://cdn-images-1.medium.com/max/4020/1*A3skPd6C2oiKF743LgwO0A.png)

兼容性方面还有工作要做，所以如果你考虑在下一个项目中使用 ViteJS，请确保你的目标受众倾向于定期更新他们的浏览器。

---

当涉及到依赖工具时，ViteJS 有可能颠覆当前的行业标准。它有技术，它有插件生态系统，它有所需的功能。唯一阻止它获得事实上的构建工具桂冠的，是它对旧浏览器的兼容性。

显然，浏览器兼容性在今天仍旧是一个问题，但这是我们行业中越来越少的一部分人的问题，所以请关注 ViteJS，因为它会随着浏览器的更新而愈加流行。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
