> * 原文地址：[Webpack’s Hot Module Replacement Feature Explained](https://blog.bitsrc.io/webpacks-hot-module-replacement-feature-explained-43c13b169986)
> * 原文作者：[Nathan Sebhastian](https://medium.com/@nathansebhastian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/webpacks-hot-module-replacement-feature-explained.md](https://github.com/xitu/gold-miner/blob/master/article/2021/webpacks-hot-module-replacement-feature-explained.md)
> * 译者：[霜羽 Hoarfroster](https://github.com/PassionPenguin)
> * 校对者：[5Reasons](https://github.com/5Reasons)、[nia3y](https://github.com/nia3y)

# 详细解读 Webpack 的模块热替换功能

![](https://cdn-images-1.medium.com/max/2024/1*q3OLOdT-Ep86tfnvugnabw.png)

在开发 JavaScript 应用程序时，每次我们保存代码更改后，我们都需要重新加载浏览器以刷新用户界面。

像 Webpack 之类的开发者工具可以通过**监视模式**来监听项目文件的更改。一旦检测到更改，Webpack 就会自动地重新构建应用程序并重新加载浏览器。

但是很快，开发者们就开始思考，有没有一种方法可以在不重新加载浏览器的情况下保存和更新页面的更改？毕竟，重新加载意味着会丢失在 UI 上的任何执行的状态：

* 我们正在使用的所有模态框或对话框都将消失。我们需要从头开始，重复步骤，以使它们再次出现。
* 我们的应用程序的状态将被重置。如果我们使用的是 React 或 Vue 之类的库，我们需要重新执行状态更改，或者通过本地存储持久化状态。
* 想要将状态持久保存到本地存储，我们需要额外多写一些代码。除非我们的在生产环境下也有这种需求，否则每次开发时都需要为了调试而添加和删除代码，着实非常不方便。
* 即便我们仅仅只对 CSS 代码做出了很小的更改，也会触发浏览器的刷新。

而[模块热替换（Hot Module Replacement，HMR）](https://webpack.js.org/concepts/hot-module-replacement/)功能就是为了解决这种问题，并且现在已经成为了为前端开发提速的有力助手。

## HMR 功能是怎么工作的？

HMR 让我们可以在应用程序运行时交换、添加或删除 JavaScript 模块，而无需重新加载浏览器。在 Webpack 中，这种效果是通过在 Webpack 开发服务器（[webpack-dev-server](https://github.com/webpack/webpack-dev-server)）中创建一个 **HMR 服务器**实现的，而该服务器会通过 Websocket 与浏览器中的 **HMR 运行时**进行通信。

![简述 HMR 工作的方式](https://cdn-images-1.medium.com/max/3840/1*UGYFDKGrQF6ID3CofCHUwg.png)

交换模块的过程如下：

* 首次构建应用程序时，Webpack 会生成一份清单文件，包含编译的哈希和所有模块的列表。Webpack 会将 **HMR 运行时**注入到生成的 `bundle.js` 文件中。
* Webpack 会在保存文件时检测文件的更改。
* Webpack 编译器会用我们所做的更改来构建我们的应用程序，创建一个新的清单文件并将其与旧的清单文件进行比较。此过程也称为“热更新”。
* **热更新**数据将被发送到 **HMR 服务器**，后者则会把更新发送至 **HMR 运行时**。
* **HMR 运行时**将解包**热更新**数据，并使用适当的加载器来处理更改。如果我们有 CSS 更改，则将调用 css-loader 或 style-loader。如果我们对 JavaScript 代码进行了更改，则通常会调用 babel-loader。

通过启用 HMR 功能，我们无需刷新浏览器即可让浏览器下载新的软件包并解包应用更改。HMR 运行时将接受来自 HMR 服务器的传入请求，包含清单文件和代码块，替换浏览器中的当前文件。

在运行启用了 HMR 的应用程序时保存代码更改时，我们实际上可以在 “Network” 选项卡上看到从 HMR 服务器发送的热更新文件：

![网络选项卡下的热更新文件](https://cdn-images-1.medium.com/max/2880/1*phxmgjIC0OrLPZVFsWlvyA.png)

当“热更新”无法替换浏览器中的代码时，HMR 运行时将通知 webpack-dev-server。然后，webpack-dev-server 将刷新浏览器以下载新的 `bundle.js` 文件。我们可以通过在 Webpack 配置中添加 `hotOnly：true` 来禁用此行为。

## 如何启用 HMR 功能

为了在项目中启用 HMR，我们需要让我们的应用程序知道如何处理**热更新**。我们可以通过实例化 Webpack 公开的 `module.hot` API 来实现：

首先，我们需要向 Webpack 配置文件中添加 `hot: true` 来启用 HMR，如下所示：

```js
// webpack.config.js

module.exports = {
    entry: {
        app: './src/index.js',
    },
    devtool: 'inline-source-map',
    devServer: {
        hot: true,
        // ... 忽略掉其他配置
    },
    plugins: [
        // 开启这个插件
        new webpack.HotModuleReplacementPlugin(),
    ],
}
```

之后，我们必须使用 `module.hot` API 处理传入的 HMR 请求。这是一个普通的 JS 项目的实现示例：

```js
// index.js

import component from "./component";

document.body.appendChild(component);

// 检查是否支持 HMR 接口
if (module.hot) {
    // 支持热更新
    module.hot.accept();
}
```

一旦告诉 Webpack 我们支持 HMR，HMR 运行时和加载程序就会接管处理更新。

但是，为复杂的应用程序实现 HMR 可能会很棘手，因为我们可能会遇到不希望的副作用，例如[仍然绑定到旧函数的事件处理程序](https://webpack.js.org/guides/hot-module-replacement/＃enabling-hmr)，尤其是当你使用 React 或 Vue 之类的库。此外，我们还需要确保[仅在开发中启用 HMR](https://webpack.js.org/guides/production/)。

不过在我们尝试自己实施 HMR 之前，建议你先为我们的项目寻找一下可用的解决方案，因为 HMR 已经集成到许多流行的 JavaScript 应用程序生成器中。

Create React App 和 Next.js 都内置了 React Fast Refresh，一种 React 专有的热重载实现。而 Vue CLI 3 的 HMR 则是通过 [vue-loader](https://github.com/vuejs/vue-loader) 实现的。[Svelte](https://github.com/sveltejs/svelte-loader) 和 [Angular](https://github.com/PatrickJS/angular-hmr) 也有自己的 HMR 集成，因此我们没有必要从头开始编写集成。

## 小结

热模块替换能让我们无需刷新浏览器即可在浏览器中查看代码更改所带来的效果，从而可以保留前端应用程序的状态。

但是实现 HMR 可能很棘手，因为它可能会产生一些副作用。幸运的是，HMR 已在许多 JavaScript 应用程序生成器中实现。因此我们可以直接享受此功能，而不必自己实现。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
