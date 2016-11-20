> * 原文地址：[Create React apps with no build configuration](https://github.com/facebookincubator/create-react-app?utm_source=javascriptweekly&utm_medium=email)
* 原文作者：[Facebook Incubato](https://github.com/facebookincubator)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[贾克奇](https://github.com/jiakeqi)
* 校对者：[XHShirley](https://github.com/XHShirley) [Gocy015](https://github.com/Gocy015)

# 无需配置即可创建 React App

* [开始](#getting-started) – 如何创建一个新 app。
* [用户指南](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md) – 如何使用 Create React App 脚手架开发 app。

## 

```sh
npm install -g create-react-app

create-react-app my-app
cd my-app/
npm start

```

然后打开 [http://localhost:3000/](http://localhost:3000/) 查看你的 app。<br>
当你准备部署到生产模式时，使用 `npm run build` 构建更小体积的包。

<img src='https://camo.githubusercontent.com/506a5a0a33aebed2bf0d24d3999af7f582b31808/687474703a2f2f692e696d6775722e636f6d2f616d794e66434e2e706e67' width='600' alt='npm start'>

## 开始

### 安装

全局安装:

```sh
npm install -g create-react-app
```

*你机器上 Node 的版本不能低于 4.0*。

**为了加快安装速度和更好的利用磁盘，我们强烈建议使用 Node6+ 和 npm3+。** 你可以使用 [nvm](https://github.com/creationix/nvm#usage) 在不同的项目中切换 Node 版本。

**这个工具不一定需要 Node 作为后端**。 安装 Node 只是为了本地构建工具的依赖，比如说 Webpack 和 Babel 。

### 创建一个 app

要创建一个新 app， 运行:

```sh
create-react-app my-app
cd my-app
```

它会在当前目录下创建一个叫做 `my-app` 的文件夹。<br> 在这个文件夹中，它会生成初始项目结构和安装相应依赖:

```
my-app/
  README.md
  node_modules/
  package.json
  .gitignore
  public/
    favicon.ico
    index.html
  src/
    App.css
    App.js
    App.test.js
    index.css
    index.js
    logo.svg
```

无需配置或者复杂的目录结构，只有你构建 app 所需的文件。<br>
一旦安装完毕后，你可以在项目文件夹下运行一些命令:

### `npm start`

在开发模式下运行 app 。<br>
在浏览器中打开 [http://localhost:3000](http://localhost:3000) 查看视图。

对界面的编辑会实时刷新。<br>
你可以在控制台下看到构建错误和语法警告。

<img src='https://camo.githubusercontent.com/41678b3254cf583d3186c365528553c7ada53c6e/687474703a2f2f692e696d6775722e636f6d2f466e4c566677362e706e67' width='600' alt='Build errors'>

### `npm test`

在交互模式下运行测试。 默认情况下，运行与自上次提交以来更改的文件的相关测试。

[更多关于测试的文章](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#running-tests)。

### `npm run build`

会以生产模式构建 app 到 `build`文件夹内。<br>
它在生产模式下正确打包 React，并优化构建以获得最佳性能。

这个构建的体积已经被压缩过了，并且文件名都包含了哈希。<br>
你的 app 已经部署好了!

## 用户指南

这个 [用户指南](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md) 包含的信息涵盖了不同的话题，如:

- [Updating to New Releases](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#updating-to-new-releases)
- [Folder Structure](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#folder-structure)
- [Available Scripts](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#available-scripts)
- [Displaying Lint Output in the Editor](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#displaying-lint-output-in-the-editor)
- [Installing a Dependency](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#installing-a-dependency)
- [Importing a Component](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#importing-a-component)
- [Adding a Stylesheet](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#adding-a-stylesheet)
- [Post-Processing CSS](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#post-processing-css)
- [Adding Images and Fonts](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#adding-images-and-fonts)
- [Using the `public` Folder](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#using-the-public-folder)
- [Adding Bootstrap](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#adding-bootstrap)
- [Adding Flow](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#adding-flow)
- [Adding Custom Environment Variables](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#adding-custom-environment-variables)
- [Can I Use Decorators?](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#can-i-use-decorators)
- [Integrating with a Node Backend](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#integrating-with-a-node-backend)
- [Proxying API Requests in Development](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#proxying-api-requests-in-development)
- [Using HTTPS in Development](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#using-https-in-development)
- [Generating Dynamic `<meta>` Tags on the Server](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#generating-dynamic-meta-tags-on-the-server)
- [Running Tests](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#running-tests)
- [Deployment](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#deployment)

用户指南的副本将在你的项目文件夹中创建为 `README.md` 。

## 如何更新到最新版本?

有关信息请参阅 [用户指南](https://github.com/facebookincubator/create-react-app/blob/master/packages/react-scripts/template/README.md#updating-to-new-releases)。

## 哲学理念

* **单依赖:** 只有一个构建依赖。它使用了 Webpack，Babel，ESLint，和其他很棒的项目，但是把他们整合到一起提供给用户。

* **零配置:** 这里没有配置文件或者命令行选项。开发和生产构建配置都已经设置完毕，这样以来你可以专注于写代码。

* **无锁定:** 您可以随时到自定义设置。运行一个简单的命令，所有配置和构建依赖会移动到你的项目内，因此你可以选择他们的位置。

## 为什么使用?

**如果你用 React 开始**，使用 `create-react-app` 自动构建你的 app。无需配置文件，并且 `react-scripts` 是在 `package.json` 额外的构建依赖。你的环境会提供你需要构建现代化 React app 的任何东西:

* React，JSX，和 ES6 支持。
* ES6 之外的语言扩展，如对象扩展运算符。
* 一个开发服务器用来检查常见错误。
* 从 JavaScript 中 引入 CSS 和图片文件。
* 自动补全 CSS，因此你不需要 `-webkit` 或者其他前缀。
* 一个 `build` 构建脚本为生产模式从源码去打包 JS、CSS、和图片。

**一些功能是受限制的**。它不支持一些高级功能，如服务端渲染或者 CSS 模块。目前也不支持测试。这个工具之所以是 **无配置** ，是因为当用户调整任何东西时，很难提供一个粘性方案，简单地让整个工具集更新。

**你不一定非要使用。** 纵观历史，[逐渐过渡](https://www.youtube.com/watch?v=BF58ZJ1ZQxY) 到 React 是非常容易的。但是仍有很多人每天从零开始构建单页面 React app。我们注意到一些 [提示](https://medium.com/@ericclemmons/javascript-fatigue-48d4011b6fc4) 和 [反馈](https://twitter.com/thomasfuchs/status/708675139253174273)，特别是如果这是你的第一个 JavaScript 构建栈，这个过程非常繁琐并且容易出错。这个项目是尝试开发 React 应用程序更好的解决方案。

### 转到自定义配置

**如果你是重度用户** 并且对默认配置不满意，你可以从工具中退出，并像样板生成器一样使用它。

运行 `npm run eject` 复制所有依赖文件和相应依赖 (Webpack、Babel、ESLint 等等) 到你的项目，因此完全可控。类似 `npm start` 和 `npm run build` 的命令依旧会工作， 但他们会指向复制的脚本，因此你可以调整。在这一点上，你只能靠自己。

**注: 这是个单向操作。一旦 `eject`，你就回不去啦!**

你可能不需要使用 `eject`。 这个功能集适合中小型部署，而且你不应该感到有义务使用此功能。但是，我们明白如果你无法自定义该工具，那么它将不会有用。

## 限制

一些功能现在是 **不支持的** :

* 服务端渲染。
* 一些实验语法扩展 (如: 装饰器)。
* CSS 模块。
* LESS 或者 Sass。
* 组件热加载。

如果他们是稳定的，对大多数 React 应用程序有用，不与现有工具冲突，并且不引入额外的配置，它们可能会在未来添加。

## 内部是什么?

创建 React 应用程序使用的技术栈可能还会更改。目前它构建于许多令人惊叹的社区项目的上层，如:

* [webpack](https://webpack.github.io/) 和 [webpack-dev-server](https://github.com/webpack/webpack-dev-server)，[html-webpack-plugin](https://github.com/ampedandwired/html-webpack-plugin) 和 [style-loader](https://github.com/webpack/style-loader)
* [Babel](http://babeljs.io/) 与 ES6 和 Facebook 使用的扩展 (JSX，[object spread](https://github.com/sebmarkbage/ecmascript-rest-spread/commits/master)，[class properties](https://github.com/jeffmo/es-class-public-fields))
* [Autoprefixer](https://github.com/postcss/autoprefixer)
* [ESLint](http://eslint.org/)
* [Jest](http://facebook.github.io/jest)
* 其他...

这些都是 npm 包提供的相应依赖。

## 贡献

我们很希望你为 `create-react-app` 提供帮助! 有关我们希望得到什么帮助以及如何开始，请查看[CONTRIBUTING.md](CONTRIBUTING.md)。

## 感谢

我们感谢现有相关项目作者的想法和合作:

* [@eanplatter](https://github.com/eanplatter)
* [@insin](https://github.com/insin)
* [@mxstbr](https://github.com/mxstbr)

## 备选项

如果你不同意在这个项目中做出的选择，你可能想探索不同权衡的替代品。有一些更受欢迎和积极维护的项目:

* [insin/nwb](https://github.com/insin/nwb)
* [mozilla/neo](https://github.com/mozilla/neo)
* [NYTimes/kyt](https://github.com/NYTimes/kyt)
* [zeit/next.js](https://github.com/zeit/next.js)
* [gatsbyjs/gatsby](https://github.com/gatsbyjs/gatsby)

著名的类似项目还包括:

* [enclave](https://github.com/eanplatter/enclave)
* [motion](https://github.com/motion/motion)
* [quik](https://github.com/satya164/quik)
* [sagui](https://github.com/saguijs/sagui)
* [roc](https://github.com/rocjs/roc)
* [aik](https://github.com/d4rkr00t/aik)
* [react-app](https://github.com/kriasoft/react-app)
* [dev-toolkit](https://github.com/stoikerty/dev-toolkit)
* [tarec](https://github.com/geowarin/tarec)

你也可以直接使用模块打包工具，像 [webpack](http://webpack.github.io) 和 [Browserify](http://browserify.org/) 。<br>
React 文档也包含了这个话题 [a walkthrough](https://facebook.github.io/react/docs/package-management.html) 。
