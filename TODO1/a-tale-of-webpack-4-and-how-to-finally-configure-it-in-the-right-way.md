> * 原文地址：[A tale of Webpack 4 and how to finally configure it in the right way. Updated.](https://hackernoon.com/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way-4e94c8e7e5c1)
> * 原文作者：[Margarita Obraztsova](https://hackernoon.com/@riittagirl)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way.md](https://github.com/xitu/gold-miner/blob/master/TODO1/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way.md)
> * 译者：
> * 校对者：

# 【有更新】Webpack 4 的故事以及如何用正确的方式去最终配置它

剧透：没有正确的方式。 #justwebpackthings

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

网上有上百万的教程，所以你可能已经看到了上千种配置 Webpack 文件的方式，而且他们都是可运行的例子。为什么会这样？Webpack 本身发展的非常快，很多加载器和插件都必须跟上。这是配置文件如此不同的一个主要原因：使用同一工具的不同版本组合，可能可以运行，也可能会失败。

让我只说一件事情，这是我真诚的意见：许多人已经在抱怨 Webpack 和它的笨重，这在很多方面都是正确的。我不得不说，根据我使用 **Gulp 和 Grunt** 的经验，你也会遇到相同类型的错误，这意味着当你使用  **npm 模块**时，某些版本不可避免的会不兼容。

迄今为止，Webpack 4 是一个非常流行的模块打包器，它刚刚经历了一次大规模的更新，提供了许多新功能，如**零配置、合理的默认值、性能提升、开箱即用的优化工具。**

如果你刚接触 Webpack，阅读文档是一个很好的开始。[Webpack 有一个非常好的文档](https://webpack.js.org/concepts/)，其中解释了许多部分，因此我会简单的介绍它们。

**零配置：** Webpack 4 无需配置文件，这是 Webpack 4 的新特性。Webpack 是逐步增长的，因此没必要一开始就做一个可怕的配置。

**性能提升：** Webpack 4 是迄今为止最快的版本。

**合理的默认值：** Webpack 4  的主要概念是_入口、输出、加载器、插件_。我不会详细介绍这些。加载器和插件之间的区别非常模糊，这完全取决于库作者如何去实现它。

### 核心概念

#### 入口

This should be your _.js_ file. Now you will probably see a few configurations where people include _.scss_ or _.css_ file there. This is a major hack and can lead to a lot of unexpected errors. Also sometimes you see an entry with a few _.js_ files. While some solutions allow you to do so, I would say it usually adds more complexity and only do it when you really know why you are doing it.

#### 输出

This is your _build/_ or _dist/_ or _wateveryounameit/_ folder where your end js file will be hosted. This is your end result comprised of modules.

#### 加载器

它们主要编译或转换你的代码，像 postcss-loader 将通过不同的插件。稍后你将能了解它。

#### 插件

插件在将代码输出到文件中的过程中起着至关重要的作用。

### 快速入门

创建一个新的目录，并移动到它：

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

The ‘mode’ option has not been set, webpack will fallback to ‘production’ for this value. Set ‘mode’ option to ‘development’ or ‘production’ to enable defaults for each environment.

You can also set it to ‘none’ to disable any default behavior. Learn more: https://webpack.js.org/concepts/mode/
```

### Webpack 4 模式

你需要编辑脚本来包含模式标记：

```
"scripts": {
  "dev": "webpack --mode development"
}

ERROR in Entry module not found: Error: Can’t resolve ‘./src’ in ‘~/webpack-4-quickstart’
```

This means webpack is looking for a folder _.src/_ with an _index.js_ file. This is a default behaviour for webpack 4 since it requires zero configuration.

Let`s go create a directory with a _.js_ file like this **./src/index.js** and put some code there.

```
console.log("hello, world");
```

现在运行 dev 脚本：

```
npm run dev

or

yarn dev
```

If at this point you ran into an error, read the update of this section below. Otherwise, now you have a **./dist/main.js** directory. This is great since we know our code compiled. But what did just happen?

> By default, webpack requires zero configuration meaning you do not have to fiddle with webpack.config.js to get started using it. Because of that, it had to assume some default behaviour, such that it will always look for ./src folder by default and index.js in it and output to ./dist/main.js main.js is your compiled file with dependencies.

* * *

> Update 23.12.2018
>
> If you have run into this error:

```
ERROR in ./node_modules/fsevents/node_modules/node-pre-gyp/lib/publish.js

Module not found: Error: Can't resolve 'aws-sdk' in '/Users/mobr/Documents/workshop/test-webpack-4-setup/node_modules/fsevents/node_modules/node-pre-gyp/lib'
```

> described [here](https://github.com/webpack/webpack/issues/8400) in more details, then you are most likely using one of more mature webpack v4 releases.
>
> Unfortunately, you cannot solve it without creating a webpack.config.js file (I will show you how to do it below in this article). Just follow my tutorial till the ‘Transpile your .js code’ and copy-paste the config file. You will need to download [webpack-node-externals](https://github.com/liady/webpack-node-externals)

```
npm install webpack-node-externals --save-dev

or

yarn add webpack-node-externals --dev
```

> and import the following code there:

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

> from this [module](https://github.com/liady/webpack-node-externals).

* * *

Having 2 configuration files is a common practice in webpack, especially in big projects. Usually you would have one file for development and one for production. In webpack 4 you have modes: _production_ and _development_. That eliminates the need for having two files (for medium-sized projects).

```
"scripts": {
  "dev": "webpack --mode development",
  "build": "webpack --mode production"
}
```

If you paid close attention, you have checked your _main.js_ file and saw it was not minified.

_I will use build script in this example since it provides a lot of optimisation out of the box, but feel free to use any of them from now on. The core difference between build and dev scripts is how they output files. Build is created for production code. Dev is created for development, meaning that it supports hot module replacement, dev server, and a lot of things that assist your dev work._

You can override defaults in npm scripts easily, just use flags:

```
"scripts": {
  "dev": "webpack --mode development ./src/index.js --output ./dist/main.js",
  "build": "webpack --mode production ./src/index.js --output ./dist/main.js"
}
```

This will override the default option without having to configure anything yet.

As an exercise, try also these flags:

*   — watch flag for enabling watch mode. It will watch your file changes and recompile every time some file has been updated.

```
"scripts": {
  "dev": "webpack --mode development ./src/index.js --output ./dist/main.js --watch",
  "build": "webpack --mode production ./src/index.js --output ./dist/main.js --watch"
}
```

*   — entry flag. Works exactly like output, but rewrites the entry path.

### Transpile your .js code

Modern JS code is mostly written is ES6, and ES6 is not supported by all the browsers. So you need to transpile it — a fancy word for turn your ES6 code into ES5. You can use **babel** for that — the most popular tool to transpile things now. Of course, we do not only do it for ES6 code, but for many JS implementations such as TypeScript, React, etc.

```
npm install babel-core babel-loader babel-preset-env --save-dev

or

yarn add babel-core babel-loader babel-preset-env --dev
```

This is the part when you need to create a config file for babel.

```
nano .babelrc
```

paste there:

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

Although webpack advertises itself as a zero-configuration platform, it mostly applies to general defaults such as entry and output.

At this point we will create **webpack.config.js** with the following content:

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

also we will remove flags from our npm scripts now.

```
"scripts": {
  "build": "webpack --mode production",
  "dev": "webpack --mode development"
},
```

Now when we run **_npm run build or yarn build_** it should output us a nice minified _.js_ file into _./dist/main.js_ If not, try re-installing **babel-loader.**

* * *

> Update 23.12.2018
>
> If you run into a **module ‘@babel/core’ conflict,** it means that some of your preloaded babel dependencies are not compatible. In my case, I got

```
Module build failed: Error: Cannot find module '@babel/core'

babel-loader@8 requires Babel 7.x (the package '@babel/core'). If you'd like to use Babel 6.x ('babel-core'), you should install 'babel-loader@7'.
```

> which I solved by

```
yarn add @babel/core --dev
```

* * *

> The most common pattern of webpack is to use it to compile React.js application. While this is true, we will not concentrate on React part in this tutorial since I want it to be framework agnostic. Instead, I will show you how to proceed and create your .html and .css configuration.

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

如你所见，As you can see, we are importing here _style.css_ Lets configure it! As we agreed, we ca only have one entry point for webpack. So where do we put our css to?Create a _style.css_ in our _./src_ folder

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

> 剧透：in certain articles, you will hear that ExtractTextPlugin does not work with webpack 4. It worked for me for webpack v4.2 but stopped working as I used webpack v4.20. It proves my point of modules ambiguity in set-up and if it absolutely does not work for you, you can switch to MiniCssExtractPlugin. I will show you how to configure another one later in this article.
>
> For backwards compatibility, I will still show ExtractTextPlugin example, yet feel free to skim it and move to a part where I am using MiniCssExtractPlugin.

In webpack create a new rule for css files:

```
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

We need to use extract text plugin to compile our **.css**. As you can see, we also added a new rule for **.css**. Since version 4, Webpack 4 has problems with this plugin, so you might run into this error:

- [**Webpack 4 compatibility · Issue #701 · webpack-contrib/extract-text-webpack-plugin**](https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/701 "https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/701")

为了修复这个问题，你可以运行

```shell
npm install -D extract-text-webpack-plugin@next
```
或
```shell
yarn add --dev extract-text-webpack-plugin@next
```

> 专业技巧：Google 一下你获得的错误信息，尝试在 Github 问题列表查找类似的问题，或者在 StackOverflow 网站恰当的提一个问题。

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

Please, note that another combination might not work since even updating webpack-cli v2.0.12 to 2.0.13 can break it. #justwebpackthings

So now it should output your _style.css_ into _./dist_ folder.

![](https://cdn-images-1.medium.com/max/800/1*q72pzP6EMWubm7J_IESMaw.png)

### Mini-CSS 插件

The Mini CSS plugin is meant to replace extract-text plugin and provide you with better future compatibility. I have restructured my webpack file to compile style.css with [**/mini-css-extract-plugin**](https://github.com/webpack-contrib/mini-css-extract-plugin "https://github.com/webpack-contrib/mini-css-extract-plugin") **and it works for me.**

```shell
npm install mini-css-extract-plugin --save-dev
```
或者是
```bash
yarn add mini-css-extract-plugin --dev
```

and

```
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

As Nikolay Volkov pointed out, ‘style-loader’ might not be necessary anymore since **MiniCssExtractPlugin.loader does the same.** Though it might be true I would still recommend to leave it for the fallback.

### Webpack 规则如何工作？

> 一个关于规则通常如何工作的快速描述：

```
{
        test: /\.YOUR_FILE_EXTENSION$/,
        exclude: /SOMETHING THAT IS THAT EXTENSION BUT SHOULD NOT BE PROCESSED/,
        use: {
          loader: "loader for your file extension  or a group of loaders"
        }
}
```

**我们需要去使用** **MiniCssExtractPlugin ，因为 Webpack 默认只能理解 _.js_ 格式。 MiniCssExtractPlugin 获取你的 _.css_ ，然后提取它到一个在 _./dist_ 目录下的独立 _.css_ 文件。**

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

Now your file from _./src/index.html_ is a template for your final index.html file. To check that everything works, delete every file from _./dist_ folder and the folder itself.

```shell
rm -rf ./dist
npm run dev
```
或者是
```shell
yarn dev
```

You will see that _./dist_ folder was created on its own and there are three files: **index.html, style.css, main.js.**

### Caching and Hashing

One of the most common problems in development is implementing caching. It is very important to understand how it works since you want your users to always have the best latest version of your code.

Since this blogpost is mainly about webpack configuration, we will not concentrate on how caching works in details. I will just say that one of the most popular ways to solve caching problems is adding a **_hash number_** to asset files, such _style.css_ and _script.js_. **You can read about it** [**here**](https://developers.google.com/web/fundamentals/performance/webpack/use-long-term-caching#split-the-code-into-routes-and-pages)**.** Hashing is needed to teach our browser to only request changed files.

Webpack 4 has a prebuilt functionality for it implemented via [**chunkhash**](https://webpack.js.org/guides/caching/). It can be done with:

```
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

In your _./src/index.html_ file add

```
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

This syntax will teach your template to use hashed files. This is a new feature implemented after this issue:

- [**Support for .css and .manifest files and cache busting by jantimon · Pull Request #14**](https://github.com/jantimon/html-webpack-plugin/pull/14 "https://github.com/jantimon/html-webpack-plugin/pull/14")

We will use **htmlWebpackPlugin.files.chunks.main** pattern described there. Check our **_./dist_** file **index.html**

![](https://cdn-images-1.medium.com/max/800/1*eAcjaMGzriv946f1lI3-Hw.png)

![](https://cdn-images-1.medium.com/max/800/1*Ccl_haaqqZ4OrEco0ZCZtQ.png)

If we do not change anything in our _.js_ and. _css_ file and run

```
npm run dev
```

no matter how many times you run it, the numbers in hashes should be identical to each other in both files.

### Problem with CSS hashing and how to solve it

* * *

> Update 28.12.2018
>
> This problem might exist if you are using ExtractTextPlugin for your CSS with webpack 4. If you use MiniCssExtractPlugin, this problem should not occur, yet it is beneficial to read about it!

* * *

Although we have the working implementation here, it is not perfect yet. What if we change some code in our _.scss_ file? Go ahead, change some scss there and run dev script again. Now the new file hash is not generated. What if we add a new console.log to our _.js_ file like this:

```
import "./style.css";
console.log("hello, world");
console.log("Hello, world 2");
```

If you run a dev script again, you will see that hash number has been updated in both files.

This issue is known and there is even a stack overflow question about it:

- [**Updating chunkhash in both css and js file in webpack**: I have only got the JS file in the output whereas i have used the ExtractTextPlugin to extract the Css file.Both have…](https://stackoverflow.com/questions/44491064/updating-chunkhash-in-both-css-and-js-file-in-webpack "https://stackoverflow.com/questions/44491064/updating-chunkhash-in-both-css-and-js-file-in-webpack")

#### 现在如何去修复那个？

After trying a lot of plugins that claim they solve this problem I have finally came to two types of solution.

#### 解决方案 1

There might also be some conflicts still, so **now lets try** [**mini-css-extract plugin**](https://github.com/webpack-contrib/mini-css-extract-plugin)**.**

#### 解决方案 2

Replace **[chukhash]** with just **[hash]** in _.css_ extract plugin. This was one of the solutions to the [issue](https://github.com/webpack-contrib/extract-text-webpack-plugin/issues/763). This appears to be a conflict with webpack 4.3 which introduced a `[contenthash]` variable of its [own](https://github.com/webpack/webpack/releases/tag/v4.3.0). In conjunction, use this plugin: [**webpack-md5-hash**](https://www.npmjs.com/package/webpack-md5-hash) **(see more below).**

Now lets test our _.js_ files: both files change hash.

### Problem with JS hashing and how to solve it

In case if you are already using MiniCssExtractPlugin you have an opposite problem: **every time you change something in your SCSS, both .js file and .css output files change hashes.**

#### Solution:

Use this plugin: [**webpack-md5-hash**](https://www.npmjs.com/package/webpack-md5-hash)  If you make changes to your _main.scss_ file and run dev script, only a new _style.css_ should be generated with a new hash, not both.

```
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

> Now when I edit main.scss a new hash for style.css is generated. And when I edit css only css hash changes and when I edit ./src/script.js only script.js hash changes!

### Integrating PostCSS

To have out output _.css_ polished, we can add PostCSS on top.

[PostCSS](https://github.com/postcss/postcss) provides you with **autoprefixer, cssnano** and other nice and handy stuff. I will show what I am using on a daily basis. We will need **postcss-loader.** We will also install autoprefixer as we will need it later.

```
npm install postcss-loader --save-dev
npm i -D autoprefixer

or

yarn add postcss-loader autoprefixer --dev
```

> Spoiler: you do not have to use webpack to benefit from PostCSS, it has a pretty decent [post-css-cli](https://github.com/postcss/postcss-cli) plugin that allows you to use it in npm script.

Create _postcss.config.js_ where you require relevant plugins, paste

```
module.exports = {
    plugins: [
      require('autoprefixer')
    ]
}
```

Our _webpack.config.js_ now should look like this:

```
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

Please, pay attention to the order of plugins we use for our .scss

```
use:  [  'style-loader', MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader', 'sass-loader']
```

The loader uses plugins from the end to the beginning.

You can test [**autoprefixer**](https://github.com/postcss/autoprefixer) by adding more code to your .scss files and checking the output. There is also a way to fix the output by specifying which browser you want to support in the _.browserslistrc_ file.

I would direct you to [https://www.postcss.parts/](https://www.postcss.parts/) to explore the plugins available for PostCSS, such as:

*   [utilities](https://github.com/ismamz/postcss-utilities)
*   [cssnano](https://github.com/ben-eb/cssnano)
*   [style-lint](https://github.com/stylelint/stylelint)

I will use **cssnano** to minify my output file and [css-mqpacker](https://github.com/hail2u/node-css-mqpacker) to arrange my media queries. I also have received some messages that:

![](https://cdn-images-1.medium.com/max/800/1*8TyHjIG5jTjPFn51icEVtA@2x.jpeg)

Feel free to try **cleancss** if you want to.

### 版本控制

为了保证你的依赖在对的位置，我推荐使用 **yarn** 来替代 **npm 安装模块。长话短说，yarn 会锁定每一个包，并且当你重装模块时，你会避免遇到许多意想不到的不兼容情况。**

### Keeping it clean and fresh

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

Now that we have our configuration clean and neat, we can rock on!

> Here I have provided you with my configuration file and my way to configure it step by step. Note: since a lot of npm dependencies might change by the time you read this the same config might not work for you! I kindly ask you to leave your errors in the comments below so that I can edit it later. Today is 05.04.2018

* * *

**The latest revision of this article is 28.12.2018**

The _package.json_ with the latest versions of plugins has the following structure:

```
{
 “name”: “webpack-test”,
 “version”: “1.0.0”,
 “description”: “”,
 “main”: “index.js”,
 “scripts”: {
 “build”: “webpack --mode production”,
 “dev”: “webpack --mode development”
 },
 “author”: “”,
 “license”: “ISC”,
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

> Read the next part about configuring dev environment with React here: [How to streamline your React.js development process using Webpack 4](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-develop-react-js-apps-fast-using-webpack-4.md)

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
