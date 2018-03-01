> * 原文地址：[Everything You Need To Know About Parcel: The Blazing Fast Web App Bundler 🚀](https://medium.freecodecamp.org/all-you-need-to-know-about-parcel-dbe151b70082)
> * 原文作者：[Indrek Lasn](https://medium.freecodecamp.org/@wesharehoodies?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/all-you-need-to-know-about-parce.md](https://github.com/xitu/gold-miner/blob/master/TODO/all-you-need-to-know-about-parce.md)
> * 译者：[Fatezeros](https://github.com/fatezeros)
> * 校对者：[MechanicianW](https://github.com/MechanicianW) [tvChan](https://github.com/tvChan)

# 关于 Parcel 你所需要知道的一切：快速的 Web 应用打包工具 🚀

![](https://cdn-images-1.medium.com/max/800/1*-Tcq85crClCEu_gYzn06gg.gif)

**真的吗?** 又一个打包/构建工具? 是的 —— 你应该相信, 进步和创新相结合给你带来了 [Parcel](https://parceljs.org/)。

![](https://cdn-images-1.medium.com/max/800/1*Gjhk6qvPM5zAy1iPPS1ttg.png)

#### **Parcel 有什么特别的，我为什么要关心呢？**

当 webpack 以高复杂性的代价给我们带来了很多配置的时候 —— **Parcel 却很简单**。它号称“零配置"。

**揭开上面的疑惑** —— Parcel 有一个开箱即用的开发服务器。它会在你更改文件的时候自动重建你的应用程序，并支持 [模块热替换](https://parceljs.org/hmr.html) 以实现快速开发。

#### **Parcel 有什么优势？**

* 快速打包 —— Parcel 比 Webpack，Rollup 和 Browserify 打包更快。

![](https://cdn-images-1.medium.com/max/800/1*jovxixL_dfSEnp9f6r8eEA.png)

Parcel benchmarks

需要考虑到的一点是：Webpack 仍然是极好的，并且有时候能更快

![](https://cdn-images-1.medium.com/max/800/1*e9ZNxTRvxQSgAHFIegC-6w.png)

[来源](https://github.com/TheLarkInn/bundler-performance-benchmark/blob/master/README.md)

* Parcel 支持 JS，CSS，HTML，文件资源等 —— **无需插件 —— 对用户更加友好。**
* 无需配置。开箱即用的代码拆分，热模块更新，css预处理，开发服务器，缓存等等！
* 更友好的错误日志。

![](https://cdn-images-1.medium.com/max/800/1*miFAZZhZpaloYs1fj3jB0A.png)

![](https://cdn-images-1.medium.com/max/400/1*2MnJM2-lQHND-icGggt4Ug.png)

Parcel 错误处理

#### 那么 —— 我们应该在什么时候使用 Parcel, Webpack 或者 Rollup 呢?

这完全取决于你，但我个人会在以下情况使用不同的打包工具：

**Parcel** —— 中小型项目（<1.5万行代码）

**Webpack** —— 大到企业级规模的项目。

**Rollup** —— NPM 包。

**让我们赶紧试下 Parcel 吧!**

* * *

#### 安装非常简单

```
npm install parcel-bundler --save-dev
```

我们在本地安装了 [parcel-bundler npm package](https://www.npmjs.com/package/parcel-bundler)。现在我们需要初始化一个 Node 项目。

![](https://cdn-images-1.medium.com/max/800/1*ncsWSVcZ9H2GvCryk1bjbw.png)

接下来，创建 `index.html` 和 `index.js` 文件。

![](https://cdn-images-1.medium.com/max/800/1*42o-xydISJg7RFPJEV8vXQ.png)

将 `index.js` 链接到 `index.html` 中

![](https://cdn-images-1.medium.com/max/600/1*mnvGwOAj77U0ukki4s4LZQ.png)

![](https://cdn-images-1.medium.com/max/600/1*0SsOP82bxYkYIt-H9XL8Zw.png)

最后添加 parcel 脚本到 `package.json`

![](https://cdn-images-1.medium.com/max/800/1*n3Al1gXiv4tNNGo3pWc-ug.png)

这就是所有的配置 —— 惊人的节省时间吧！

接下来，启动我们的服务器。

![](https://cdn-images-1.medium.com/max/600/1*Yq8tQPP6Qv80xwV3N-1lIw.gif)

![](https://cdn-images-1.medium.com/max/600/1*tWzj5lTbPm2rEZKndCgKhQ.png)

立竿见影！注意构建时间。

![](https://cdn-images-1.medium.com/max/800/1*6PKBaYyEQrK889opDE72Vg.png)

**15 ms?!** 哇，真是太快了！

添加一些 HMR 会怎么样呢?

![](https://cdn-images-1.medium.com/max/800/1*KHATEDXNqL5fshf3S0B5Zw.gif)

也感觉非常快。

* * *

### SCSS

![](https://cdn-images-1.medium.com/max/800/1*dMNikHR10Nfw1Z0PtmITXA.png)

我们所需要的只是 `node-sass` 包，让我们开始吧！

```
npm i node-sass && touch styles.scss
```

接下来，添加一些样式并且将 `styles.scss` 引入到 `index.js`

![](https://cdn-images-1.medium.com/max/600/1*lhF1lxmw4RQNyTpI1Y1Hdw.png)

![](https://cdn-images-1.medium.com/max/600/1*SSv27gQ34310LyJBHqo8ZQ.png)

>![](https://cdn-images-1.medium.com/max/1000/1*r8zgxebzyd-KV7LU63qfww.png)

* * *

### 生产环境构建

我们所需要做的就是添加一个 `build` 脚本到 `package.json`

![](https://cdn-images-1.medium.com/max/800/1*BbfYCV5-PaFwDX_Y68oXgw.png)

运行我们的 build 脚本。

![](https://cdn-images-1.medium.com/max/800/1*bPzZxDj7qAwfMFkPBy44Ow.gif)

看，Parcel 让我们的生活变得多么轻松？

![](https://cdn-images-1.medium.com/max/800/1*TVPM_3Zm60KkLxnhdDVMOQ.png)

你也可以像这样指定一个特定的构建路径：

```
parcel build index.js -d build/output
```

* * *

### React

![](https://cdn-images-1.medium.com/max/800/1*6kK9j74vyOmXYm1gN6ARhQ.png)

配置 React 也相当简单, 我们所需要做的只是安装 React 依赖并配置 `.babelrc`

```
npm install --save react react-dom babel-preset-env babel-preset-react && touch .babelrc
```

![](https://cdn-images-1.medium.com/max/800/1*8LV0jtqGPIRN-Z05nZjWZQ.png)

那么！！！就让我们使出杀手锏吧！继续往下看之前，你自己可以尝试写一个初始的 react 组件。

![](https://cdn-images-1.medium.com/max/600/1*w6prJQoCeWWClTIGe-2eCg.png)

![](https://cdn-images-1.medium.com/max/600/1*JcIe-GLpc9yiNnWauvobrQ.png)

![](https://cdn-images-1.medium.com/max/1000/1*7ME5571Q3BlWNAgFwSGxHg.png)

* * *

### Vue

![](https://cdn-images-1.medium.com/max/800/1*lJPS840gMBZYhHeZ6aop_g.png)

**同样，这是个 Vue 的例子**

首先安装 `vue` 和 `parcel-plugin-vue` —— 后者用于支持 `.vue` 组件。

```
$ npm i --save vue parcel-plugin-vue
```

我们需要添加根元素，引入 vue 的 index 文件并初始化 Vue。

首先创建一个 vue 目录，并创建 `index.js` 和 `app.vue`

```
$ npm i --save vue parcel-plugin-vue
```

 

 

```
$ mkdir vue && cd vue && touch index.js app.vue
```

现在将 `index.js` 挂载到 `index.html`

![](https://cdn-images-1.medium.com/max/800/1*PJ7L4G15cDpvreu6NkdXLQ.png)

最后，让我们实例化 vue，并写第一个 vue 组件！

![](https://cdn-images-1.medium.com/max/600/1*EHKOgp5Yc69NBCImVJUJcg.png)

![](https://cdn-images-1.medium.com/max/600/1*TCyx5wWr5GK1O9E6bKllUA.png)

![](https://cdn-images-1.medium.com/max/1000/1*XDZ71d55e8vGY8QoVeJGlw.png)

瞧！我们安装了 Vue，并支持 `.vue` 文件

* * *

### TypeScript

![](https://cdn-images-1.medium.com/max/800/1*SwI4JNcok6yj8b6a0Mykvg.png)

这部分非常容易。只需安装 TypeScript，让我们开始吧！

```
npm i --save typescript
```

创建一个 `index.ts` 文件，并将它插入到 `index.html` 中

![](https://cdn-images-1.medium.com/max/600/1*zp1272l6v1XxLmX8QSndkA.png)

![](https://cdn-images-1.medium.com/max/600/1*mR0wngPbI4UfHtMZxletxQ.png)

![](https://cdn-images-1.medium.com/max/1000/1*QpIDy402yydKokM1bO5l7A.png)

准备好了就去做吧！

### [Github源码](https://github.com/wesharehoodies/parcel-examples-vue-react-ts)

* * *

如果你认为这篇文章有用，请给我一些鼓励，并让更多的人看到它！

可以关注我的 [twitter](https://twitter.com/lasnindrek) 了解更多！

感谢阅读！ ❤


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
