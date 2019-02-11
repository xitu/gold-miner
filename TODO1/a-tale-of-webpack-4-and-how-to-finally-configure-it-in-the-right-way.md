> * 原文地址：[A tale of Webpack 4 and how to finally configure it in the right way. Updated.](https://hackernoon.com/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way-4e94c8e7e5c1)
> * 原文作者：[Margarita Obraztsova](https://hackernoon.com/@riittagirl)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way.md)
> * 译者：
> * 校对者：

# Webpack 4 的故事以及如何用正确的方式去最终配置它【更新版】

特别提醒：没有正确的方式。 #justwebpackthings

![](https://cdn-images-1.medium.com/max/2560/1*f2JinK5jRjYoLJ31kAKyLQ.jpeg)

原图： https://www.instagram.com/p/BhPo4pqBytk/?taken-by=riittagirl

> 这篇博文最后一次更新在 2018 年 12 月 28 日，适用于 Webpack v4.28.0 版本。 

* * *

> 2018 年 06 月 23 日更新： 我收到了许多关于如何使其工作和如何改进的评论。感谢你们的反馈！我已经尽力的去考虑每一条评论！某种程度上，我也决定在 Github 上创建一个 Webpack 模板项目，你可以使用 Git 来拉取最新的 Webpack 配置文件。感谢你们的支持！链接：https://github.com/marharyta/webpack-boilerplate](https://github.com/marharyta/webpack-boilerplate)

* * *

> 更新：本文是关于 Webpack 和 React.js 搭建系列文章的一部分。在这里阅读有关配置 React 开发环境的部分：[https://medium.com/@riittagirl/how-to-develop-react-js-apps-fast-using-webpack-4-3d772db957e4](https://medium.com/@riittagirl/how-to-develop-react-js-apps-fast-using-webpack-4-3d772db957e4)

* * *

> _感谢各位对我的教程提出大量的反馈。我要很自豪的说，Webpack 前几天在 Twitter 上推荐了这篇教程，并且它已经得到了一些贡献者的认可！_

![](https://cdn-images-1.medium.com/max/600/1*LMP6qbC151q2eJ7efXurmA.jpeg)

![](https://cdn-images-1.medium.com/max/600/1*UVme7DsXop97cirV0TuaWw.jpeg)

谢谢！

* * *

网上有上百万的教程，所以你可能已经看到了上千种配置 Webpack 文件的方式，而且他们都是可运行的例子。为什么会这样？Webpack 本身发展的非常快，很多加载器和插件都必须跟上。这是这些配置文件如此不同的一个主要原因：使用同一工具的不同版本组合，可能可以运行，也可能会失败。

让我只说一件事情，这是我真诚的意见：许多人已经在抱怨 Webpack 和它的笨重，这在很多方面都是正确的。我不得不说，根据我使用 **Gulp 和 Grunt** 的经验，你也会遇到相同类型的错误，这意味着当你使用 **npm 模块**时，某些版本不可避免的会不兼容。

迄今为止，Webpack 4 是一个非常流行的模块打包器，它刚刚经历了一次大规模的更新，提供了许多新功能，如**零配置、合理的默认值、性能提升、开箱即用的优化工具。**

如果你刚接触 Webpack，阅读文档是一个很好的开始。[Webpack 有一个非常好的文档](https://webpack.js.org/concepts/)，其中解释了许多部分，因此我会简单的介绍它们。

**零配置：** Webpack 4 无需配置文件，这是 Webpack 4 的新特性。Webpack 是逐步增长的，因此没必要一开始就做一个可怕的配置。

**性能提升：** Webpack 4 是迄今为止最快的一版。

**合理的默认值：** Webpack 4 的主要概念是「 _入口、输出、加载器、插件_ 」。我不会详细介绍这些。加载器和插件之间的区别非常模糊，这完全取决于库作者如何去实现它。

### 核心概念

#### 入口

这应该是你的 _.js_ 文件。现在您可能会看到一些配置，其中人们在那里包含 _.scss_ 或 _.css_ 文件。 这是一个重大的 hack ，并可能会导致许多意外错误。有时你也会看到一个带有几个 _.js_ 文件的条目。虽然有些解决方案允许你这样做，但我会说它通常会增加更多的复杂性，只有当你真正知道你为什么这样做时才能这样做。

#### 输出

这是你的 _build/_ 、 _dist/_ 或 _wateveryounameit/_ 文件夹，其中将存放最终生成的 js 文件。这是你的最终结果，由模块组成。

#### 加载器

它们主要编译或转换你的代码，像 postcss-loader 将通过不同的插件。稍后你将能了解它。

#### 插件

插件在将代码输出到文件中的过程中起着至关重要的作用。

### 快速入门

创建一个新的目录，并切换到该目录下：

```shell
mkdir webpack-4-tutorial
cd webpack-4-tutorial
```

初始化 package.json 文件：

```shell
npm init
```
或者
```shell
yarn init
```

我们需要下载模块 **Webpack v4** 和 **webpack-cli** 。在你的终端（控制台）运行它：

```
npm install webpack webpack-cli --save-dev
```
或
```
yarn add webpack webpack-cli --dev
```

确保你已经安装了版本 4，如果没有安装，你可以在 _package.json_ 中显式指定它。现在打开 _package.json_ 然后添加构建脚本：

```javascript
"scripts": {
  "dev": "webpack"
}
```

尝试运行它，你很可能会看到一条警告：

```
WARNING in configuration

The 'mode' option has not been set, webpack will fallback to 'production' for this value. Set 'mode' option to 'development' or 'production' to enable defaults for each environment.

You can also set it to 'none' to disable any default behavior. Learn more: https://webpack.js.org/concepts/mode/
```

### Webpack 4 模式

你需要编辑脚本来包含模式标记：

```
"scripts": {
  "dev": "webpack --mode development"
}

ERROR in Entry module not found: Error: Can't resolve './src' in '~/webpack-4-quickstart'
```

这意味着 webpack 在寻找 _.src/_ 文件夹下的 _index.js_ 文件。这是 webpack 4 的默认行为，这也是它实现零配置的原因。

让我们去创建带有 _.js_ 文件的目录，如 **./src/index.js** ，并在那里放一些代码。
```
console.log("hello, world");
```

现在运行 dev 脚本：

```
npm run dev

或者

yarn dev
```

如果此时你遇到错误，请阅读本小节下面的更新。否则，现在你应该会有一个  **./dist/main.js** 目录。这很好，因为我们知道我们的代码被编译过了。但刚刚发生了什么？

> 默认情况下， Webpack 是零配置的，这意味着在你开始使用它时，你无需去配置 webpack.config.js 。因此，它必须去假定一些默认行为，例如它总是会在默认情况下查找 ./src 文件夹，在其中查找 index.js 并输出到 ./dist/main.js 。main.js 是带有依赖项的编译后文件。

* * *

> 2018.12.23 更新
>
> 如果你遇到了这个问题：

```
ERROR in ./node_modules/fsevents/node_modules/node-pre-gyp/lib/publish.js

Module not found: Error: Can't resolve 'aws-sdk' in '/Users/mobr/Documents/workshop/test-webpack-4-setup/node_modules/fsevents/node_modules/node-pre-gyp/lib'
```

> 更多细节描述请参阅[这里](https://github.com/webpack/webpack/issues/8400)， then you are most likely using one of more mature webpack v4 releases.
>
> 不幸的是，如果不创建 webpack.config.js 文件，你就无法解决它（我将在本文中后续部分向您展示如何执行此操作）。只需按照我的教程，直到 “转义你的 .js 代码” 部分并复制粘贴那里的配置文件。你需要下载 [webpack-node-externals](https://github.com/liady/webpack-node-externals)。

```
npm install webpack-node-externals --save-dev

或者是

yarn add webpack-node-externals --dev
```

> 并且在那里导入以下代码：

```
const nodeExternals = require('webpack-node-externals');
...
module.exports = {
    ...
    target: 'node',
    externals: [nodeExternals()],
    ...
};
```

> 从这个[模块](https://github.com/liady/webpack-node-externals)。

* * *

在 webpack 中，拥有两个配置文件是常见做法，尤其是在大型项目中。通常你会有一个用于开发的文件和一个用于生产的文件。在 webpack 4 中，你有 _开发_ 和 _生产_ 两种模式。这消除了对两个文件的需求（对于中型项目）。


```
"scripts": {
  "dev": "webpack --mode development",
  "build": "webpack --mode production"
}
```
如果你密切关注，你已经检查了你的 _main.js_ 文件并看到它没有被缩小。

_我将在此示例中使用构建脚本，因为它提供了大量开箱即用的优化，但从现在开始你可以随意使用它们中的任何一个。构建和开发脚本之间的核心区别在于它们如何输出文件。构建脚本为生产代码创建。开发脚本为开发而创建，这意味着它支持热模块替换、开发服务器以及许多可以帮助你进行开发工作的东西。_

你可以在 npm 脚本中很轻易地覆盖默认配置，只需要使用标记：

```
"scripts": {
  "dev": "webpack --mode development ./src/index.js --output ./dist/main.js",
  "build": "webpack --mode production ./src/index.js --output ./dist/main.js"
}
```

这将覆盖默认选项，而无需配置任何内容。

作为一个练习，你也可以试试这些标记：

*   — watch 标记来启用监听模式。它将会监控文件变化，并且在每次文件更新时重新编译。 

```
"scripts": {
  "dev": "webpack --mode development ./src/index.js --output ./dist/main.js --watch",
  "build": "webpack --mode production ./src/index.js --output ./dist/main.js --watch"
}
```

*   — entry 标记。与输出标记完全一样，但重写了输入路径。

### 转译你的 .js 代码

现代 JS 代码大多是用 ES6 编写的，然而并不是所有浏览器都支持 ES6。 因此，您需要将其 transpile ———— 一个将您的 ES6 代码转换为 ES5 的奇特词汇。 你可以使用 **babel**（现在最流行的工具）来处理。 当然，我们不仅针对 ES6 代码，而且针对许多 JS 实现，例如 TypeScript，React 等。


```
npm install babel-core babel-loader babel-preset-env --save-dev

或者

yarn add babel-core babel-loader babel-preset-env --dev
```

这是您需要为 babel 创建配置文件的部分。

```
nano .babelrc
```

把下面的内容粘贴过去：

```json
{
"presets": [
  "env"
  ]
}
```

我们有两个选择来配置 babel-loader ：

*   使用配置文件 **webpack.config.js**
*   在 **npm 脚本**使用 --module-bind 参数

从技术上讲，你可以使用 Webpack 引入的新标志来作很多事情，但是为了简单起见，我更喜欢使用 **webpack.config.js** 。

### 配置文件

虽然 webpack 将自己宣传为零配置平台，但它主要适用于一般默认设置，如入口和输出。

现在我们将使用以下内容创建 **webpack.config.js** ：

```
// webpack v4

const path = require('path');

// update from 23.12.2018
const nodeExternals = require('webpack-node-externals');

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'main.js'
  },
  target: 'node', // update from 23.12.2018
  externals: [nodeExternals()], // update from 23.12.2018
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      }
    ]
  }
};
```

我们也会从 npm 脚本中移除标记。

```
"scripts": {
  "build": "webpack --mode production",
  "dev": "webpack --mode development"
},
```
现在当我们运行 **_npm run build 或者 yarn build_** 时，他应当输出一个被很好地压缩的 _.js_ 文件到 _./dist/main.js_ 。如果没有的话，尝试重新安装 **babel-loader** 。


* * *

> 2018.12.23 更新
>
> 如果你遇到 **module '@babel/core' conflict** ，这意味着你的某些预加载的 babel 依赖项不兼容。就我而言，我遇到了

```
Module build failed: Error: Cannot find module '@babel/core'

babel-loader@8 requires Babel 7.x (the package '@babel/core'). If you'd like to use Babel 6.x ('babel-core'), you should install 'babel-loader@7'.
```

> 我解决了这个问题，通过

```
yarn add @babel/core --dev
```

* * *

> 最常见的 webpack 模式是使用它来编译 React.js 应用程序。虽然确有其事，但我们不会在本教程中专注 React 部分，因为我希望它与框架无关。相反，我将向您展示如何继续并创建 .html 和 .css 配置。

### HTML 和 CSS 的导入

让我们首先在 _./dist_ 文件夹下创建一个小小的 _index.html_ 文件：

```html
<html>
  <head>
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
    <div>Hello, world!</div>
    <script src="main.js"></script>
  </body>
</html>
```

如您所见，我们在这里导入 style.css 。让我们配置它！正如我们所说，我们只有一个 Webpack 入口点。那么我们将 css 放在哪里？在 _./src_ 文件夹中创建一个 _style.css_


```css
div {
  color: red;
}
```

别忘了在你的 .js 文件里包含它：

```javascript
import "./style.css";
console.log("hello, world");
```

> 特别提醒：在某些文章中，你会了解到 ExtractTextPlugin 不适用于 webpack 4。它在我的 webpack v4.2 上可以运行，但在我使用 webpack v4.20 时停止运行。它证明了在搭建时我的模块设置很模糊，如果它完全不适合你，你可以切换到 MiniCssExtractPlugin 。 我将在本文后面部分向您展示如何配置。
>
> 为了向后兼容，我仍然会展示 ExtractTextPlugin 示例，但是你完全可以删去它并替换成正在使用 MiniCssExtractPlugin 的部分。

在 webpack 为您的 css 文件创建一条新的规则：

```javascript
// webpack v4
const path = require('path');

// update from 23.12.2018
const nodeExternals = require('webpack-node-externals');

const ExtractTextPlugin = require('extract-text-webpack-plugin');

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'main.js'
  },
  target: 'node', // update from 23.12.2018
  externals: [nodeExternals()], // update from 23.12.2018  
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract(
          {
            fallback: 'style-loader',
            use: ['css-loader']
          })
      }
    ]
  }
};
```

在终端（控制台）运行：

```shell
npm install extract-text-webpack-plugin --save-dev
npm install style-loader css-loader --save-dev
```
或者
```shell
yarn add extract-text-webpack-plugin style-loader css-loader --dev
```

我们需要使用文本提取插件来编译 **.css** 。如您所见，我们还为 **.css** 添加了一条新规则。从版本 4 开始，Webpack 4 和这个插件有问题，所以你可能会遇到这个错误：

- [**Webpack 4 compatibility · Issue #701 · webpack-contrib/extract-text-webpack-plugin**](https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/701 "https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/701")

为了修复这个问题，你可以运行

```shell
npm install -D extract-text-webpack-plugin@next
```
或
```shell
yarn add --dev extract-text-webpack-plugin@next
```

> 专业提示：Google 一下你获得的错误信息，尝试在 Github 问题列表查找类似的问题，或者在 StackOverflow 网站恰当的提一个问题。

在那之后，你的 CSS 代码应当会编译到 _./dist/style.css_。

此时在 package.json 中，开发依赖看起来像这样：

```json
"devDependencies": {
    "babel-core": "^6.26.0",
    "babel-loader": "^7.1.4",
    "babel-preset-env": "^1.6.1",
    "css-loader": "^0.28.11",
    "extract-text-webpack-plugin": "^4.0.0-beta.0",
    "style-loader": "^0.20.3",
    "webpack": "^4.4.1",
    "webpack-cli": "^2.0.12"
 }
```

版本可能不同，但这是正常的！

请注意，另一个组合可能无法正常工作，即使将 webpack-cli v2.0.12 更新为 2.0.13 也可能会破坏它。#justwebpackthings

所以现在它应该将 _style.css_ 输出到 _./dist_ 文件夹中。

![](https://cdn-images-1.medium.com/max/800/1*q72pzP6EMWubm7J_IESMaw.png)

### Mini-CSS 插件

Mini CSS 插件旨在取代 extract-text 插件，它为您提供更好的未来兼容性。我用 [**mini-css-extract-plugin**](https://github.com/webpack-contrib/mini-css-extract-plugin "https://github.com/webpack-contrib/mini-css-extract-plugin") 重新构建了我的 webpack 文件以编译 style.css，**并且它对我很有用。**

```shell
npm install mini-css-extract-plugin --save-dev

或者是

yarn add mini-css-extract-plugin --dev
```


```javascript
// webpack v4
const path = require('path');

// update from 23.12.2018
const nodeExternals = require('webpack-node-externals');

// const ExtractTextPlugin = require('extract-text-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
  target: 'node', // update from 23.12.2018
  externals: [nodeExternals()], // update from 23.12.2018
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.css$/,
        use:  [  'style-loader', MiniCssExtractPlugin.loader, 'css-loader']
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: 'style.css',
    })
  ]
};
```
正如尼古拉·沃尔科夫所指出的那样，可能不再需要 style-loader 了，因为 **MiniCssExtractPlugin.loader 也可以做到同样的事情。** 虽然这可能属实，但我仍然建议留下它作为后备。

### Webpack 匹配规则如何工作？

> 一个关于匹配规则通常如何工作的快速描述：

```json
{
      test: /\.YOUR_FILE_EXTENSION$/,
      exclude: /SOMETHING THAT IS THAT EXTENSION BUT SHOULD NOT BE PROCESSED/,
      use: {
        loader: "loader for your file extension  or a group of loaders"
      }
}
```

**我们需要去使用** **MiniCssExtractPlugin ，因为 Webpack 默认只能解析 _.js_ 格式。 MiniCssExtractPlugin 获取你的 _.css_ ，然后提取它到一个在 _./dist_ 目录下的独立 _.css_ 文件。**

### 配置对 SCSS 的支持

使用 SASS 和 POSTCSS 开发网站是一个很平常的事情，它们非常有用。因此我们首先要包含对 SASS 的支持。让我们重命名 _./src/style.css_ ，然后创建另外的文件夹来存放 _.scss_ 文件。现在我们需要添加对 _.scss_ 格式的支持。

```shell
npm install node-sass sass-loader --save-dev
```
或者是
```shell
yarn add node-sass sass-loader --dev
```

在你的 _.js_ 文件里用  **_./scss/main.scss_** 替换 *style.css* ，更改测试以支持 _.scss_ 。

```javascript
// webpack v4
const path = require('path');
// update 23.12.2018
const nodeExternals = require('webpack-node-externals');

const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'main.js'
  },
  target: "node", // update 23.12.2018
  externals: [nodeExternals()], // update 23.12.2018
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use: [
          "style-loader",
          MiniCssExtractPlugin.loader,
          "css-loader",
          "sass-loader"
        ]
      }
    ]
  } ...
```

### HTML 模板

现在让我们创建 _.html_ 文件模板。添加 _index.html_ 到 _./src_ ，保持完全相同的结构。

```html
<html>
  <head>
    <link rel="stylesheet" href="style.css">
  </head>
  <body>
    <div>Hello, world!</div>
    <script src="main.js"></script>
  </body>
</html>
```

为了作为一个模板去使用这个文件，我们将需要对它使用 html 插件。

```shell
npm install html-webpack-plugin --save-dev
```
或者
```sh
yarn add html-webpack-plugin --dev
```

把它添加到你的 Webpack 文件：

```javascript
// webpack v4
const path = require('path');
// update 23.12.2018
const nodeExternals = require('webpack-node-externals');

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'main.js'
  },
  target: "node", // update 23.12.2018
  externals: [nodeExternals()], // update 23.12.2018

  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use: [
          "style-loader",
          MiniCssExtractPlugin.loader,
          "css-loader",
          "sass-loader"
        ]
      }
    ]
  },
  plugins: [ 
    new MiniCssExtractPlugin({
      filename: "style.css"
    }),
    new HtmlWebpackPlugin({
      inject: false,
      hash: true,
      template: './src/index.html',
      filename: 'index.html'
    })
  ]
};
```

现在，_./src/index.html_ 中的文件是最终 index.html 文件的模板。要检查一切是否正常，请删除_./dist_文件夹中的每个文件和文件夹本身。

```shell
rm -rf ./dist
npm run dev
```
或者是
```shell
yarn dev
```

你会看到 _./dist_ 文件夹是自行创建的，包含三个文件：**index.html，style.css，main.js 。**

### 缓存和哈希

开发中最常见的问题之一是实现缓存。了解它的工作原理非常重要，因为您希望用户始终拥有最新版本的代码。

由于这篇博文主要是关于 webpack 配置的，因此我们不会专注于缓存如何工作。我只想说解决缓存问题最常用的方法之一是向资源文件添加 **_哈希值_**，例如 _style.css_ 和 _script.js_ 。**你可以在[这里](https://developers.google.com/web/fundamentals/performance/webpack/use-long-term-caching#split-the-code-into-routes-and-pages)阅读相关内容。** 需要哈希来指导我们的浏览器只请求更改的文件。

Webpack 4 具有通过 [**chunkhash**](https://webpack.js.org/guides/caching/) 实现的预构建功能。它可以通过以下方式完成：

```javascript
// webpack v4
const path = require('path');

// update 23.12.2018
const nodeExternals = require("webpack-node-externals");

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
  target: "node",
  externals: [nodeExternals()],
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use: [
            "style-loader",
            MiniCssExtractPlugin.loader,
            "css-loader",
            "sass-loader"
          ]
       }
    ]
  },
  plugins: [ 
    new MiniCssExtractPlugin({
     filename: "style.[contenthash].css"
    }),

    new HtmlWebpackPlugin({
      inject: false,
      hash: true,
      template: './src/index.html',
      filename: 'index.html'
    })
  ]
};
```

在您的 _./src/index.html_ 文件中添加

```html
<html>
  <head>
    <link rel="stylesheet" href="<%=htmlWebpackPlugin.files.chunks.main.css %>">
  </head>
  <body>
    <div>Hello, world!</div>
    <script src="<%= htmlWebpackPlugin.files.chunks.main.entry %>"></script>
  </body>
</html>
```

这样的语法将会为您的 HTML 模版注入带有哈希值的文件。这是此问题后实现的新功能：

- [**Support for .css and .manifest files and cache busting by jantimon · Pull Request #14**](https://github.com/jantimon/html-webpack-plugin/pull/14 "https://github.com/jantimon/html-webpack-plugin/pull/14")

我们将使用在那里描述的 **htmlWebpackPlugin.files.chunks.main** 。 查看我们在 **_./dist_** 下的文件 **index.html**。

![](https://cdn-images-1.medium.com/max/800/1*eAcjaMGzriv946f1lI3-Hw.png)

![](https://cdn-images-1.medium.com/max/800/1*Ccl_haaqqZ4OrEco0ZCZtQ.png)

如果我们不改变我们的 _.js_ 和 . _css_ 文件中任何东西，运行

```
npm run dev
```

不论您运行多少次，运行前后两个文件中的哈希值均会彼此相同。

### CSS Hash 问题以及解决方案

* * *

> 2018.12.28 更新
>
> 如果你使用针对 CSS 的 webpack 4 版本的 ExtractTextPlugin，可能会存在这个问题。如果你使用 MiniCssExtractPlugin ，这个问题将不会发生，但阅读它是有益的！

* * *

虽然我们在这里做了一些工作，但它还不完美。如果我们更改 _.scss_ 文件中的某些代码怎么办？继续下去，在那里更改一些 scss 并再次运行 dev 脚本。现在不生成新的文件哈希。如果我们将一个新的 console.log 添加到我们的 _.js_ 文件中，如下所示：


```
import "./style.css";
console.log("hello, world");
console.log("Hello, world 2");
```

如果再次运行 dev 脚本，您将看到两个文件中的哈希值均已更新。

这个问题是已知的，甚至在 StackOverflow 上都有相关问题：

- [**Updating chunkhash in both css and js file in webpack**: I have only got the JS file in the output whereas i have used the ExtractTextPlugin to extract the Css file.Both have…](https://stackoverflow.com/questions/44491064/updating-chunkhash-in-both-css-and-js-file-in-webpack "https://stackoverflow.com/questions/44491064/updating-chunkhash-in-both-css-and-js-file-in-webpack")

#### 现在如何去修复那个问题？

在尝试了很多声称可以解决这个问题的插件之后，我终于找到了两种类型的解决方案。

#### 解决方案 1

可能还存在一些冲突，所以**现在我们试试** [**mini-css-extract plugin**](https://github.com/webpack-contrib/mini-css-extract-plugin)**.**

#### 解决方案 2

在 _.css_ 提取插件上用 **[hash]** 替换 **[chunkhash]** 。这是[问题](https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/763)的解决方案之一。 这似乎与 webpack 4.3 产生了冲突，后者引入了[自己](https://github.com/webpack/webpack/releases/tag/v4.3.0)的 `[contenthash]` 变量。结合使用此插件：[**webpack-md5-hash**](https://www.npmjs.com/package/webpack-md5-hash) **(请参阅下文).**

现在让我们测试一下 _.js_ 文件：两个文件都改变了哈希值。

### JS Hash 的问题以及解决方案

如果您已经在使用 MiniCssExtractPlugin ，则会出现相反的问题：**每次更改 SCSS 中的某些内容时，.js 文件和 .css 输出文件哈希值都会更改。**

#### 解决方案:

使用这个插件： [**webpack-md5-hash**](https://www.npmjs.com/package/webpack-md5-hash) 。如果对 _main.scss_ 文件进行更改并运行 dev 脚本，则只应使用新哈希生成新的 _style.css_ ，而不是两者。

```javascript
// webpack v4
const path = require('path');
// update 23.12.2018
const nodeExternals = require("webpack-node-externals");

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const WebpackMd5Hash = require("webpack-md5-hash");

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
  target: "node", // update 23.12.2018
  externals: [nodeExternals()], // update 23.12.2018
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use: ExtractTextPlugin.extract(
          {
            fallback: 'style-loader',
            use: ['css-loader', 'sass-loader']
          })
      }
    ]
  },
  plugins: [ 
    new MiniCssExtractPlugin({
      filename: "style.[contenthash].css"
    }),
    new HtmlWebpackPlugin({
      inject: false,
      hash: true,
      template: "./src/index.html",
      filename: "index.html"
    }),
    new WebpackMd5Hash()
  ]
};
```

> 现在，当我编辑 main.scss 时，会生成 style.css 的新哈希。当我编辑 css 时只有 css 的哈希更改，当我编辑 ./src/script.js 时，只有script.js 的哈希更改！

### 整合 PostCSS

为了优雅的输出 _.css_ ，我们可以在顶部添加 PostCSS。

[PostCSS](https://github.com/postcss/postcss) 为您提供 **autoprefixer, cssnano** 和其他漂亮和方便的东西。 我会每天展示我正在使用的内容。我们需要 **postcss-loader 。**我们还将安装 autoprefixer ，因为我们稍后会需要它。


> 更新于：2019.2.11
>
> 校对者注：
> 最新版的 postcss-loader （v3.0.0 版本以上）是自带支持 autoprefixer 的，所以我们不需要安装 autoprefixer。
>
> 具体请参阅：[postcss-preset-env 包含 autoprefixer，因此如果您已经使用了预设配置，则无需单独添加 autoprefixer 。](https://github.com/postcss/postcss-loader#autoprefixing) 


```shell
npm install postcss-loader --save-dev
npm i -D autoprefixer

或者

yarn add postcss-loader autoprefixer --dev
```

> 特别提醒：您不必为了使用 PostCSS 而使用 Webpack，Webpack 有一个相当不错的 [post-css-cli](https://github.com/postcss/postcss-cli) 插件，允许你在 npm 脚本中使用。

在需要相关插件的地方创建 _postcss.config.js_ ，粘贴

```javascript
module.exports = {
    plugins: [
      require('autoprefixer')
    ]
}
```

我们的 _webpack.config.js_ 现在看起来应该是这样：

```javascript
// webpack v4
const path = require('path');
// update 23.12.2018
const nodeExternals = require("webpack-node-externals");

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const WebpackMd5Hash = require("webpack-md5-hash");

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
  target: "node",
  externals: [nodeExternals()],
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use:  [  'style-loader', MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader', 'sass-loader']
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: 'style.[contenthash].css',
    }),
    new HtmlWebpackPlugin({
      inject: false,
      hash: true,
      template: './src/index.html',
      filename: 'index.html'
    }),
    new WebpackMd5Hash()
  ]
};
```
请注意我们用于 .scss 的插件顺序

```javascript
use:  ['style-loader', MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader', 'sass-loader']
```
加载器将从后向前应用插件。

您可以通过向 .scss 文件添加更多代码并检查输出来测试 [**autoprefixer**](https://github.com/postcss/autoprefixer)。还有一种方法可以通过在 _.browserslistrc_ 文件中指定要支持的浏览器来修复输出。

我将引导您到 [https://www.postcss.parts/](https://www.postcss.parts/) 探索可用于 PostCSS 的插件，例如：

*   [utilities](https://github.com/ismamz/postcss-utilities)
*   [cssnano](https://github.com/ben-eb/cssnano)
*   [style-lint](https://github.com/stylelint/stylelint)

我将使用 **cssnano** 来缩小我的输出文件，使用 [css-mqpacker](https://github.com/hail2u/node-css-mqpacker) 来编排我的媒体查询。我也收到了一些消息：

![](https://cdn-images-1.medium.com/max/800/1*8TyHjIG5jTjPFn51icEVtA@2x.jpeg)

如果你愿意，可以试试 **cleancss**。

### 版本控制

为了保证你的依赖在对的位置，我推荐使用 **yarn** 来替代 **npm 安装模块。长话短说，yarn 会锁定每一个包，并且当你重装模块时，你将不会遇到许多意想不到的不兼容情况。**

### 保持配置干净整洁

我们可以尝试导入 **clean-webpack-plugin** ，在重新生成文件之前清理 _./dist_ 文件夹。

```javascript
// webpack v4
const path = require('path');
// update 23.12.2018
const nodeExternals = require("webpack-node-externals");

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const WebpackMd5Hash = require("webpack-md5-hash");
const CleanWebpackPlugin = require('clean-webpack-plugin');

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
  target: "node",
  externals: [nodeExternals()],

  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: "babel-loader"
        }
      },
      {
        test: /\.scss$/,
        use:  [  'style-loader', 
                 MiniCssExtractPlugin.loader, 
                 'css-loader', 
                 'postcss-loader', 
                 'sass-loader']
      }
    ]
  },
  plugins: [ 
    new CleanWebpackPlugin('dist', {} ),
    new MiniCssExtractPlugin({
      filename: 'style.[contenthash].css',
    }),
    new HtmlWebpackPlugin({
      inject: false,
      hash: true,
      template: './src/index.html',
      filename: 'index.html'
    }),
    new WebpackMd5Hash()
  ]
};
```

现在我们的配置干净整洁，我们可以保持下去！

> 在这里，我为您提供了我的配置文件以及逐步配置它的方法。注意：由于许多 npm 依赖项可能会在您阅读此内容时发生更改，因此相同的配置可能对您无效！我恳请您将错误留在下面的评论中，以便我以后编辑。今天是 2018.04.05 。

* * *

**本文的最新版本是 2018.12.28**

带有最新版本插件的 _package.json_ 具有以下结构：

```json
{
 "name": "webpack-test",
 "version": "1.0.0",
 "description": "",
 "main": "index.js",
 "scripts": {
 "build": "webpack --mode production",
 "dev": "webpack --mode development"
 },
 "author": "",
 "license": "ISC",
 "devDependencies": {
   "@babel/core": "^7.2.2",
   "autoprefixer": "^9.4.3",
   "babel-core": "^6.26.3",
   "babel-loader": "^8.0.4",
   "babel-preset-env": "^1.7.0",
   "css-loader": "^2.0.2",
   "html-webpack-plugin": "^3.2.0",
   "mini-css-extract-plugin": "^0.5.0",
   "node-sass": "^4.11.0",
   "postcss-loader": "^3.0.0",
   "sass-loader": "^7.1.0",
   "style-loader": "^0.23.1",
   "webpack": "4.28",
   "webpack-cli": "^3.1.2"
},

 "dependencies": {
   "clean-webpack-plugin": "^1.0.0",
   "webpack-md5-hash": "^0.0.6",
   "webpack-node-externals": "^1.7.2"
 }
}
```

* * *

> 在这里阅读下一篇关于使用 React 配置开发环境的部分：[如何使用 Webpack 4 简化 React.js 开发过程](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-develop-react-js-apps-fast-using-webpack-4.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
