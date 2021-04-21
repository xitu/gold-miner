> * 原文地址：[Snowpack: An Alternative Build Tool to Webpack](https://blog.bitsrc.io/snowpack-an-alternative-build-tool-to-webpack-9e8da197071d)
> * 原文作者：[Nathan Sebhastian](https://medium.com/@nathansebhastian)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/article/2021/snowpack-an-alternative-build-tool-to-webpack.md](https://github.com/xitu/gold-miner/blob/master/article/2021/snowpack-an-alternative-build-tool-to-webpack.md)
> * 译者：[felixliao](https://github.com/felixliao)
> * 校对者：[niayyy](https://github.com/nia3y)、[Joe](https://github.com/Usualminds)、[霜羽 Hoarfroster](https://github.com/PassionPenguin)

# Snowpack: 一个可代替 Webpack 的构建工具

![](https://cdn-images-1.medium.com/max/2024/1*XElS7rQXRta2vXlqLti4VQ.png)

得益于它灵活的构建配置以及丰富的官方支持的第三方插件，[Webpack](https://webpack.js.org/) 是近几年最流行的 JavaScript 构建工具。

Webpack 的主要功能是将你所有的 JavaScript 文件，连带所有从 NPM 导入的模块、图片、CSS 和其他网络资源，全部打包到一个可以被浏览器执行的文件中。

![用一句话形容 Webpack，[来源](https://www.snowpack.dev/concepts/how-snowpack-works)](https://cdn-images-1.medium.com/max/3840/1*XRoIfAWL1JkSECMDC6n5Hw.png)

但是 Webpack 也是一个复杂的工具，伴随着陡峭的学习曲线，因为它的灵活性意味着它有非常多的功能来应对各种不同的使用场景。更进一步讲，哪怕只是对一个文件进行了很小的改动，Webpack 会将你的整个 JavaScript 应用重新打包和构建。如果对 Webpack 的工作原理理解不到位，构建一个应用时可能要等[半小时以上](https://stackoverflow.com/questions/56431031/why-does-npm-run-build-take-30-minutes-on-development-server-and-less-than-a)。

但是话说回来，Webpack 是 2014 年发布的。在那个时候，浏览器基本不支持 ECMAScript Module (ESM) 的 `import` 和 `export` 语法，所以在浏览器中运行 JavaScript 的方式只能是将项目中所有的模块全部打包进一个文件。

这其中还包括其他的流程，比如使用 Babel 将 JavaScript 从较新版本转换为稍旧版本，以便浏览器可以运行该应用。但是使用 Webpack 最主要的目的是创造最好的开发体验，让 JavaScript 开发者可以使用最新的功能（ES6+）。

如今 ESM 语法已经被所有主流浏览器支持，所以将你所有的 JavaScript 文件打包在一起已经不是在浏览器中运行应用的必要条件了。

## 使用 Snowpack 无需进行打包配置

[Snowpack](https://www.snowpack.dev/) 是一个 JavaScript 构建工具，它利用了浏览器对 ESM 的支持，让我们可以构建单个文件并将其发送到浏览器中。每一个被构建的文件都会被缓存，在我们每修改一个文件时，只有这一个文件会被 Snowpack 重新构建。

![Snowpack 服务端打包的文件，[来源](https://www.snowpack.dev/concepts/how-snowpack-works)](https://cdn-images-1.medium.com/max/3840/1*Ep5bOeYn1t-Y0XnSRUD2mA.png)

Snowpack 的开发服务器也做了优化，它只会在浏览器请求后构建该文件。这使得 Snowpack 可以即时启动（**小于 50 毫秒**）并且扩展到大型项目时也不会增加启动速度。我自己做尝试时启动服务器只用了 35 毫秒：

![Snowpack 的调试服务器启动](https://cdn-images-1.medium.com/max/2906/1*EpNPrzN0EeeEYlMM3SLIWw.png)

## Snowpack 的构建过程

Snowpack 默认会将你的未打包应用部署到生产环境，但是你也要进行一些构建相关的优化，比如最小化、代码分割、tree-shaking、懒加载等等。

Snowpack 同时支持通过[插件连接 Webpack](https://www.npmjs.com/package/@snowpack/plugin-webpack) 来打包生产版本的应用。这样，由于 Snowpack 已经转译了你的代码，你的打包工具（Webpack）只需要将常规的 HTML、CSS 和 JavaScript 文件打包。这也是为什么你在打包过程中不需要复杂的 Webpack 配置文件。

最后，你也可以设置 `package.json` 中的 `browserslist` 属性，来设定支持的浏览器版本：

```json
/* package.json */
"browserslist": ">0.75%, not ie 11, not UCAndroid >0, not OperaMini all",
```

在你执行 `snowpack build` 指令来构建生产环境的项目时，该属性会自动被应用。Snowpack 不会在构建开发版本时执行任何转译，所以这不是一个问题，因为大部分时间你都会在最新的浏览器版本下开发。

## 上手 Snowpack

要开始使用 Snowpack，你可以立即使用 Create Snowpack App (CSA) 和 NPX 来创建 Snowpack 应用。例如，你可以用如下指令来用 CSA 新建一个初始化 React 应用：

```sh
npx create-snowpack-app react-snowpack --template @snowpack/app-template-react
```

一个新的 `react-snowpack` 文件夹会被创建，并且附带最基础的依赖：

```json
{
  "scripts": {
    "start": "snowpack dev",
    "build": "snowpack build",
    "test": "web-test-runner \"src/**/*.test.jsx\"",
    "format": "prettier --write \"src/**/*.{js,jsx}\"",
    "lint": "prettier --check \"src/**/*.{js,jsx}\""
  },
  "dependencies": {
    "react": "^17.0.0",
    "react-dom": "^17.0.0"
  },
  "devDependencies": {
    "@snowpack/plugin-dotenv": "^2.0.5",
    "@snowpack/plugin-react-refresh": "^2.4.0",
    "@snowpack/web-test-runner-plugin": "^0.2.0",
    "@testing-library/react": "^11.0.0",
    "@web/test-runner": "^0.12.0",
    "chai": "^4.2.0",
    "prettier": "^2.0.5",
    "snowpack": "^3.0.1"
  }
}
```

你立即就可以使用 `npm start` 指令运行这个应用。本地的调试服务器会在 8080 端口运行。CSA 的 React 模板和 Create React App 的默认模板非常相似：

![CSA 的默认 React 页面](https://cdn-images-1.medium.com/max/3104/1*j3OQj_TV0ODHJZZpiaTzew.png)

Snowpack 支持主流库的 [许多官方模板](https://github.com/snowpackjs/snowpack/tree/main/create-snowpack-app/cli#official-app-templates)，如 React、Vue 和 Svelte。你只需要在指令中加入 `--template` 选项。

## 结语

> 你使用一个打包工具时应该是因为你想要使用它，而不是因为你需要使用它 —— [Snowpack 官方文档](https://www.snowpack.dev/concepts/build-pipeline#bundle-for-production)

Webpack 和 Snowpack 的发布相隔了数年，尽管 Webpack 一直是打包 JavaScript 模块时人气最高的选择，但浏览器对 ESM 模块的支持开创了一种新的开发 Web 应用的方式。

伴随着不打包开发以及开发中快速构建应用的能力，Snowpack 将成为一个激动人心的 Webpack 替代品，它让我们可以更轻松地开发 JavaScript 应用。与此同时，它还能让你利用 Webpack 打包生产版本，对你的应用实现构建优化。

别忘了去看看 [Snowpack 的官方文档](https://www.snowpack.dev/) 来了解更多。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
