> * 原文地址：[OPTIMIZING WEBPACK FOR FASTER REACT BUILDS](http://engineering.invisionapp.com/post/optimizing-webpack/)
> * 原文作者：[Jonathan Rowny](http://invisionapp.com/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-webpack-for-faster-react-builds.md](https://github.com/xitu/gold-miner/blob/master/TODO1/optimizing-webpack-for-faster-react-builds.md)
> * 译者：[Starrier](https://github.com/Starriers)
> * 校对者：[lcx-seima](https://github.com/lcx-seima)、[sishenhei7](https://github.com/sishenhei7)

# 优化 WEBPACK 以更快地构建 REACT

![](https://imgs.xkcd.com/comics/compiling.png)

如果您的 Webpack 构建缓慢且有大量的库 —— 别担心，有一种方法可以提高增量构建的速度！Webpack 的 `DLLPlugin` 允许您将所有的依赖项构建到一个文件中。这是一个取代分块的很好选择。该文件稍后将由您的主 Webpack 配置，甚至可以在共享同一组依赖项的其他项目上使用。典型的 React 应用程序可能包含几十个供应商库，这取决于您的 Flux、插件、路由和其他工具（如 `lodash`）。我们将通过允许 Webpack 跳过 DLL 中包含的任何引用来节省宝贵的构建时间。

本文假设您已经熟悉典型的 Webpack 和 React 设置。如果没有，请查看 [SurviveJS](http://survivejs.com/webpack_react/webpack/) 在 Webpack 和 React 方面的优秀内容，当您的构建时间逐步增加时，请回到本文。

## 第 1 步，列出您的供应商

构建和维护 DLL 的最简单的方法是在您的项目中创建一个 JS 文件 —— `vendors.js`，其中引入您使用的所有库。例如，在我们最近的项目中，我们的 `vendors.js` 文件内容如下：

```
require("classnames");
require("dom-css");
require("lodash");
require("react");
require("react-addons-update");
require("react-addons-pure-render-mixin");
require("react-dom");
require("react-redux");
require("react-router");
require("redux");
require("redux-saga");
require("redux-simple-router");
require("redux-storage");
require("redux-undo");
```

这是我们将要“构建”的 DLL 文件，它没有任何功能，只是导入我们使用的库。

**注意：** 您也可以在这里使用 ES6 风格的 `import`，但是我们需要用 Bable 来构建 DLL。您仍然可以像您习惯的那样，在您的主项目中使用 `import` 和其他所有 ES2015 语法糖。

## 第 2 步，构建 DLL

现在我们可以创建一个 Webpack 配置来构建 DLL。这将从您的应用程序主 Webpack 配置中**完全分离**，并且会影响部分文件。它不会被您的 Webpack 中间件、Webpack 服务器或其他任何东西调用（手动或通过预构建除外）。

我们称之为 `webpack.dll.js`

```
var path = require("path");
var webpack = require("webpack");

module.exports = {
    entry: {
        vendor: [path.join(__dirname, "client", "vendors.js")]
    },
    output: {
        path: path.join(__dirname, "dist", "dll"),
        filename: "dll.[name].js",
        library: "[name]"
    },
    plugins: [
        new webpack.DllPlugin({
            path: path.join(__dirname, "dll", "[name]-manifest.json"),
            name: "[name]",
            context: path.resolve(__dirname, "client")
        }),
        new webpack.optimize.OccurenceOrderPlugin(),
        new webpack.optimize.UglifyJsPlugin()
    ],
    resolve: {
        root: path.resolve(__dirname, "client"),
        modulesDirectories: ["node_modules"]
    }
};
```

这是典型的 Webpack 配置，除了 `webpack.DLLPlugin` 以外，它包含 name、context 和 mainifest 路径。mainifest 非常重要，它为其他 Webpack 配置提供了您到已经构建模块的映射。context 是客户端源码的根，而 name 是入口的名称，在本例中是“供应商”。继续尝试使用命令 `webpack --config=webpack.dll.js` 运行这个构建。最后，您应该得到一个包含模块的排列映射 —— `dll\vendor-manifest.json` 已经包含了您所有供应商库的精简包 ——  `dist\dll\dll.vendor.js`。

## 第 3 步，构建项目

**注意:**下述示例不包含 sass、assets、或热加载程序。如果您已经在配置中使用了，它们仍然可以正常工作。

现在我们需要做的就是添加 `DLLReferencePlugin`，并将其指向我们已经构建的 DLL。您的 `webpack.dev.js` 可能是如下模样：

```
var path = require("path");
var webpack = require("webpack");

module.exports = {
    cache: true,
    devtool: "eval", //or cheap-module-eval-source-map
    entry: {
        app: path.join(__dirname, "client", "index.js")
    },
    output: {
        path: path.join(__dirname, "dist"),
        filename: "[name].js",
        chunkFilename: "[name].js"
    },
    plugins: [
        //Typically you'd have plenty of other plugins here as well
        new webpack.DllReferencePlugin({
            context: path.join(__dirname, "client"),
            manifest: require("./dll/vendor-manifest.json")
        }),
    ],
    module: {
        loaders: [
            {
                test: /\.jsx?$/,
                loader: "babel",
                include: [
                    path.join(__dirname, "client") //important for performance!
                ],
                query: {
                    cacheDirectory: true, //important for performance
                    plugins: ["transform-regenerator"],
                    presets: ["react", "es2015", "stage-0"]
                }
            }
        ]
    },
    resolve: {
        extensions: ["", ".js", ".jsx"],
        root: path.resolve(__dirname, "client"),
        modulesDirectories: ["node_modules"]
    }
};
```

我们还做了一些其他事来提高性能，包括：

*   确保我们有 `cache: true`
*   确保 Babel 在查询中加载程序有 `cacheDirectory:true`
*   在 bable loader 中使用 `include`（您应该在所有的 loader 中这样做）
*   将 devTool 设置为 `eval`，因为我们正在为构建时间优化 `#nobugs`

## 第 4 步，包含 DLL

此时，您已经生成了一个供应商 DLL 文件，并且您的 Webpack 构建并生成 app.js 文件。您需要在模版中提供并包含这两个文件，但 DLL 应该是第一位的。您可能已经使用 `HtmlWebpackPlugin` 设置了模版。因为我们不关心热重载 DLL，所以除了在主 app.js 之前包含 `<script src="dll/dll.vendor.js"></script>` 之外，您实际上不需要做任何事。如果您使用的是 `webpack-middleware` 或者您自己定制化的服务器，则还需要确保为 DLL 提供服务。此时，一切都应该按原样运行，但是使用 Webpack 进行增量构建的速度应该非常快。

## 第 5 步，构建脚本

我们可以使用 NPM 和 `package.json` 添加一些为我们构建的简单脚本。要清除 `dist` 文件夹，请继续运行 `npm i rimraf --saveDev`。现在可以添加到您的 package.json 中了：

```
"scripts": {
    "clean": "rimraf dist",
    "build:webpack": "webpack --config config.prod.js",
    "build:dll": "webpack --config config.dll.js",
    "build": "npm run clean && npm run build:dll && npm run build:webpack",
    "watch": "npm run build:dll && webpack --config config.dev.js --watch --progress"
  }
```

现在您可以运行 `npm run watch`。如果您喜欢手动运行 `build:dll`，则可以将其从监视脚本中删除，以便更快地启动。

## 就这样，伙计们！

我希望这能让您深入了解 InVision 如何使用 Webpack 的 `DLLPlugin` 来提高构建速度。如果您有任何问题或想法，欢迎发表评论。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)
