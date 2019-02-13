> * 原文地址：[How to streamline your React.js development process using Webpack 4](https://medium.freecodecamp.org/how-to-develop-react-js-apps-fast-using-webpack-4-3d772db957e4)
> * 原文作者：[Margarita Obraztsova](https://medium.freecodecamp.org/@riittagirl)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-develop-react-js-apps-fast-using-webpack-4.md](https://github.com/xitu/gold-miner/blob/master/TODO1/how-to-develop-react-js-apps-fast-using-webpack-4.md)
> * 译者：[JerryOnlyZRJ](https://github.com/jerryOnlyZRJ)
> * 校对者：[iceytea](https://github.com/iceytea)，[xilihuasi](https://github.com/xilihuasi)

# 如何利用 Webpack4 提升你的 React.js 开发效率

![](https://cdn-images-1.medium.com/max/2600/1*NLzcqb-jEMHg9K5Ov0oAyw.jpeg)

图片来源：https://www.instagram.com/p/BiaH379hrAp/?taken-by=riittagirl

在现实生活的开发中，我们经常需要对新功能进行快速迭代。在本教程中，我将向你展示一些你可以采取的措施，以提升大约 20% 的开发速度。

**为什么要这样**，你可能会问？

因为在编程时进行人工操作往往会非常适得其反，我们希望尽可能将流程自动化。因此，我将向你展示使用 Webpack v4.6.0 提升 React 的开发过程中的哪些部分。

我不会介绍如何初始化配置 webpack，因为我已经在[**之前的帖子**](https://hackernoon.com/a-tale-of-webpack-4-and-how-to-finally-configure-it-in-the-right-way-4e94c8e7e5c1)里讲过它。在那篇文章里，我详细介绍了如何配置 Webpack。我假设在阅读本文之前你已经熟悉 Webpack 配置的基础知识，这样我们就可以从准备好了基本配置之后开始。

### 配置 Webpack

在你的 `webpack.config.js` 文件中，添加以下代码：

```
// webpack v4
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const WebpackMd5Hash = require('webpack-md5-hash');
const CleanWebpackPlugin = require('clean-webpack-plugin');

module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
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
  },
  plugins: [ 
    new CleanWebpackPlugin('dist', {} ),
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

并在你的 `package.json` 文件中添加这些依赖：

```
{
 "name": "post",
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
    "babel-cli": "^6.26.0",
    "babel-core": "^6.26.0",
    "babel-loader": "^7.1.4",
    "babel-preset-env": "^1.6.1",
    "babel-preset-react": "^6.24.1",
    "babel-runtime": "^6.26.0",
    "clean-webpack-plugin": "^0.1.19",
    "html-webpack-plugin": "^3.2.0",
    "react": "^16.3.2",
    "react-dom": "^16.3.2",
    "webpack": "^4.6.0",
    "webpack-cli": "^2.0.13",
    "webpack-md5-hash": "0.0.6"
  }
}
```

接下来你可以安装你的项目所需依赖：

```
npm i
```

并将 `index.html` 和 `index.js` 两个文件添加进项目的 `src/` 目录下

首先在 `src/index.html` 文件中添加如下代码：

```
<html>
  <head>
  </head>
  <body>
    <div id="app"></div>
    <script src="<%= htmlWebpackPlugin.files.chunks.main.entry %>"></script>
  </body>
</html>
```

接着在 `src/index.js` 中添加：

```
console.log("hello, world");
```

执行 dev 脚本：

```
npm run dev
```

**接下来你就会发现：项目完成编译了**！现在让我们继续为它配置 React。

### 配置 React 项目

由于 React 使用了名为 JSX 的特殊语法，我们需要转换代码。如果我们去 babel 的官网，就可以看到它为我们提供了 [React 的 preset](https://babeljs.io/docs/plugins/preset-react/).


```
npm install --save-dev babel-cli babel-preset-react
```

我们的 `.babelrc` 文件应该长这样：

```
{
  "presets": ["env", "react"]
}
```

在你的 `index.js` 文件中添加一些项目的初始化代码：

```
import React from 'react';
import { render } from 'react-dom';

class App extends React.Component {

render() {
    return (
      <div>
        'Hello world!'
      </div>
    );
  }
}

render(<App />, document.getElementById('app'));
```

接着执行 dev 脚本：

```
npm run dev
```

如果在你的 `./dist` 目录下能够看到一个 `index.html` 文件和一个带有 hash 值的 `main.js` 文件，**那么说明你做得很棒！项目完成了编译！**

### 配置 web-dev-server

严格来说，我们并不是必须要使用它，因为社区里有很多为前端服务的 node.js 服务端程序。但我之所以建议使用 **webpack-dev-server** 因为本就是为 Webpack 而设计的，它支持一些很好的功能，如**热模块替换**、**Source Maps（源文件映射）**等。

正如他们在[官方文档](https://github.com/webpack/webpack-dev-server)中提到的那样：

> 使用 [webpack](https://webpack.js.org/) 和后端开发服务配合能够实现 live reloading（热重启），但这只应当被用于开发环境下。

**这可能会让人感到有些困惑**：怎样使 webpack-dev-server 仅在开发模式下生效？

```
npm i webpack-dev-server --save-dev
```

在你的 `package.json` 文件中，调整：

```
"scripts": {
  "dev": "webpack-dev-server --mode development --open",
  "build": "webpack --mode production"
}
```

**现在它应该能够启动一个本地服务器并使用你的应用程序自动打开浏览器选项卡。**

你的 `package.json` 现在看起来应该像这样：

```
{
 “name”: “post”,
 “version”: “1.0.0”,
 “description”: “”,
 “main”: “index.js”,
 “scripts”: {
   "dev": "webpack-dev-server --mode development --open",
   "build": "webpack --mode production"
 },
 “author”: “”,
 “license”: “ISC”,
 “devDependencies”: {
   “babel-cli”: “6.26.0”,
   “babel-core”: “6.26.0”,
   “babel-loader”: “7.1.4”,
   “babel-preset-env”: “1.6.1”,
   “babel-preset-react”: “6.24.1”,
   “babel-runtime”: “6.26.0”,
   “clean-webpack-plugin”: “0.1.19”,
   “html-webpack-plugin”: “3.2.0”,
   “react”: “16.3.2”,
   “react-dom”: “16.3.2”,
   “webpack”: “4.6.0”,
   “webpack-cli”: “2.0.13”,
   “webpack-dev-server”: “3.1.3”,
   “webpack-md5-hash”: “0.0.6”
 }
}
```

现在，如果你尝试修改应用中的某些代码，浏览器就会自动刷新页面。

![](https://cdn-images-1.medium.com/max/1600/1*7vXsZHPYCclQ9KtJ0A6_Og.gif)

接下来，你需要将 React devtools 添加到 Chrome 扩展程序。

![](https://cdn-images-1.medium.com/max/1600/1*Bw2FhT8CyLq5NUci8GZZGQ.png)

**这样，你就可以更轻松地使用 Chrome 控制台调试应用。**

### ESLint 配置

我们为什么需要它？好吧，通常来讲我们不是必须使用它，但 ESLint 是一个方便的工具。在我们的例子中，它将呈现并突出显示（在编辑器和终端中以及在浏览器上）我们代码中的错误，包括拼写错误等等（如果有的话），这称为 **linting**。

ESLint 是一个开源的 JavaScript linting 实用程序，最初由 Nicholas C. Zakas 于 2013 年 6 月开发完成。它有其替代品，但到目前为止，它与 ES6 和 React 配合使用效果特别好，能够发现常见问题，并能与项目的生态系统其他部分集成。

现在，让我们在本地为我们自己的新项目安装它。当然，此时 ESLint 会有很多设置。你可以在[官方网站](https://eslint.org/docs/about/)阅读更多相关信息。

```
npm install eslint --save-dev

./node_modules/.bin/eslint --init
```

最后一个命令将创建一个配置文件。系统将提示你选择以下三个选项：

![](https://cdn-images-1.medium.com/max/1600/1*kLrjReWpcFvbz3R2LPCv0g.png)

在本教程中，我选择了第一个：回答问题。以下是我的答案：

![](https://cdn-images-1.medium.com/max/1600/1*I0dtDFE0l2vSSlp2rN3aaw.png)

这会将一个 `.eslintrc.js` 文件添加到项目目录中。我生成的文件如下所示：

```
module.exports = {
    "env": {
        "browser": true,
        "commonjs": true,
        "es6": true
    },
    "extends": "eslint:recommended",
    "parserOptions": {
        "ecmaFeatures": {
            "experimentalObjectRestSpread": true,
            "jsx": true
        },
        "sourceType": "module"
    },
    "plugins": [
        "react"
    ],
    "rules": {
        "indent": [
            "error",
            4
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "error",
            "single"
        ],
        "semi": [
            "error",
            "always"
        ]
    }
};
```

到目前为止什么都没发生。虽然这是一个完全有效的配置，但这还不够，我们必须将它与 Webpack 和我们的文本编辑器集成才能工作。正如我所提到的，我们可以在代码编辑器、终端（作为 linter）或 git 的 precommit 钩子中使用它。我们现在将为我们的编辑器配置它：

#### Visual Studio Code 中安装

如果你想要，几乎每个常用的代码编辑器都有 ESLint 插件，包括 **Visual Studio Code、Visual Studio、SublimeText、Atom、WebStorm 甚至是 vim**。所以，下载[你自己的文本编辑器](https://prettier.io/docs/en/editors.html)的对应版本。在本次示例中我会使用 **VS Code**。

![](https://cdn-images-1.medium.com/max/1600/1*AJ3s5IVxDjZTEk0_wrrDEw.png)

现在我们可以看到出现了一些代码错误提示。这是因为项目有一个 Lint 配置文件，它会在没有遵守某些规则时标记代码并提示警告。

![](https://cdn-images-1.medium.com/max/1600/1*QWa23sp5U4AXteyZcJimeA.png)

你可以通过检查错误消息手动调试它，或者你可以使用它只需执行保存便自动修复问题的功能。

![](https://cdn-images-1.medium.com/max/1600/1*XMEzmLN03Ub5MKKWRNMzPg.gif)

你现在也可以调整 ESLint 设置：

```
module.exports = {
    "env": {
        "browser": true,
        "commonjs": true,
        "es6": true
    },
    "extends": ["eslint:recommended", "plugin:react/recommended"],
    "parserOptions": {
        "ecmaFeatures": {
            "experimentalObjectRestSpread": true,
            "jsx": true
        },
        "sourceType": "module"
    },
    "plugins": [
        "react"
    ],
    "rules": {
        "indent": [
            "error",
            2
        ],
        "linebreak-style": [
            "error",
            "unix"
        ],
        "quotes": [
            "warn",
            "single"
        ],
        "semi": [
            "error",
            "always"
        ]
    }
};
```

更改了配置之后，如果你错误地使用了双引号而不是单引号，ESLint 不会中断构建。它还将为 JSX 添加一些检查。

#### 添加 Prettier

![](https://cdn-images-1.medium.com/max/1600/1*mYS-gqOHDfadjSPRVRk-Qg.png)

Prettier 是当今最流行的格式化程序之一，它已被编码社区广泛使用。它可以添加到 ESLint、[你的编辑器](https://prettier.io/docs/en/editors.html)，也可以被挂载在 git 的 pre-commit 钩子上。

![](https://cdn-images-1.medium.com/max/1600/1*l2Mh782tYEIhFY7nQrFr9Q.png)

我会在这里将它安装到我的 VS Code 中

安装后，你可以尝试再次检查代码。如果我们写一些奇怪的缩进并执行保存，它应该会自动格式化代码。

![](https://cdn-images-1.medium.com/max/1600/1*44ug1_PkUfZb07-H_mkvOg.gif)

但这还不够。为了使其与 ESLint 同步工作并且不会两次发出相同的错误，甚至发生规则冲突，你需要将它[与 ESLint 集成](https://prettier.io/docs/en/eslint.html)。

```
npm i --save-dev prettier eslint-plugin-prettier
```

在官方文档中，他们建议你使用 yarn，但 npm 现在同样也能安装。在你的 `.eslintrc.json` 文件中添加：

```
...
  sourceType: "module"
},
plugins: ["react", "prettier"],
extends: ["eslint:recommended", "plugin:react/recommended"],
rules: {
  indent: ["error", 2],
  "linebreak-style": ["error", "unix"],
  quotes: ["warn", "single"],
  semi: ["error", "always"],
  "prettier/prettier": "error"
}
...
```

**现在我们想扩展我们的 ESLint 规则以包含 prettier 的规则：**

```
npm i --save-dev eslint-config-prettier
```

并为你的 eslint 配置添加一些 extends：

```
...
extends: [
  "eslint:recommended",
  "plugin:react/recommended",
  "prettier",
  "plugin:prettier/recommended"
]
...
```

![](https://cdn-images-1.medium.com/max/1600/1*xUdYUgdomd75VQNmSJpzww.gif)

让我们为它添加更多[配置](https://prettier.io/docs/en/options.html)。为了避免默认的 Prettier 规则和你的 ESLint 规则之间的不匹配，你应该像我现在这样做：

![](https://cdn-images-1.medium.com/max/1600/1*peNFmblwA6zx1DkANNye3Q.png)

Prettier 借用了 ESLint 的 [override 格式](http://eslint.org/docs/user-guide/configuring#example-configuration)，这允许你将配置应用于特定的文件。

你现在可以以 `.js ` 文件的形式为其创建配置文件。

```
nano prettier.config.js
```

现在，粘贴到该文件中：

```
module.exports = {
  printWidth: 80,
  tabWidth: 2,
  semi: true,
  singleQuote: true,
  bracketSpacing: true
};
```

![](https://cdn-images-1.medium.com/max/1600/1*u8OnUOEonV58hwoQ6-nw_A.gif)

现在，当你执行保存时，你会看到代码自动格式化。那不是很漂亮（prettier）吗？双关语很有意思。

我的 `package.json` 文件现在看起来是这样：

```
{
 "name": "post",
 "version": "1.0.0",
 "description": "",
 "main": "index.js",
 "scripts": {
  "build": "webpack --mode production",
  "dev": "webpack-dev-server --mode development --open"
 },
 "author": "",
 "license": "ISC",
 "devDependencies": {
  "babel-cli": "^6.26.0",
  "babel-core": "^6.26.0",
  "babel-loader": "^7.1.4",
  "babel-preset-env": "^1.6.1",
  "babel-preset-react": "^6.24.1",
  "babel-runtime": "^6.26.0",
  "clean-webpack-plugin": "^0.1.19",
  "eslint": "^4.19.1",
  "eslint-config-prettier": "^2.9.0",
  "eslint-plugin-prettier": "^2.6.0",
  "eslint-plugin-react": "^7.7.0",
  "html-webpack-plugin": "^3.2.0",
  "prettier": "^1.12.1",
  "react": "^16.3.2",
  "react-dom": "^16.3.2",
  "webpack": "^4.6.0",
  "webpack-cli": "^2.0.13",
  "webpack-dev-server": "^3.1.4",
  "webpack-md5-hash": "0.0.6"
 }
}
```

现在我们已经完成了很多工作，让我们快速回顾一下：ESLint 会监视代码中的错误，而 Prettier 是一种样式格式化工具。ESLint 有许多方法可以捕获错误，而 Prettier 可以很好地格式化你的代码。

```
// webpack v4
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const WebpackMd5Hash = require('webpack-md5-hash');
const CleanWebpackPlugin = require('clean-webpack-plugin');
module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[chunkhash].js'
  },
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
  },
  plugins: [ 
    new CleanWebpackPlugin('dist', {} ),
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

#### 问题：Prettier 不会自动格式化 Visual Studio Code 中的代码

有些人指出 VS Code 无法使用 Prettier。

如果你的 Prettier 插件在保存时没有自动格式化代码，你可以通过将下面的代码添加到 VS Code 设置来修复它：

```
"[javascript]": {
    "editor.formatOnSave": true
  }
```

问题描述在[这里](https://github.com/prettier/prettier-vscode/issues/290)。

#### 添加 ESLint loader 到你的 pipeline 中

由于 ESLint 是在项目中配置的，因此一旦运行 dev 服务器，它也会在终端中提示警告。

![](https://cdn-images-1.medium.com/max/1600/1*wFH1KjXh8n6Tr8fp6fLCZw.png)

> **特别提示**：尽管可以这样做，但此时我不建议将 ESLint 用作 Webpack 的 loader。它将破坏 source map 的生成，我在我的前一篇文章[《如何解决 Webpack 中的问题 —— 一些实际案例》](https://medium.com/@riittagirl/how-to-solve-webpack-problems-the-practical-case-79fb676417f4)中有更详细的描述。我将展示如何在这里设置它，以防这些人已经修复了他们的错误。

Webpack 有它自己的 [ESLint loader](https://www.npmjs.com/package/eslint-loader).

```
npm install eslint-loader --save-dev
```

你必须将 ESLint 添加到 rules 配置中。当使用了使用了编译类的 loader（如 babel-loader）时，请确保它们的执行顺序正确（从下到上）。否则，Webpack 将检查文件经过 babel-loader 编译后的文件。

```
...
module: {
  rules: [
    {
      test: /\.js$/,
      exclude: /node_modules/,
      use: [{ loader: "babel-loader" }, { loader: "eslint-loader" }]
    }
  ]
},
...
```

![](https://cdn-images-1.medium.com/max/1600/1*tPh8qjDAdQeTnaQR54sKAw.png)

以下是你可能遇到的一些问题：

*   将未使用的变量添加到 index 文件中

![](https://cdn-images-1.medium.com/max/1600/1*OSM0SXJIZ0Ain2VrHn7xYA.png)

如果你偶然发现了这个错误（no-unused-vars），那么在 GitHub 和[这里](https://github.com/yannickcr/eslint-plugin-react/issues/1146)的[这个 issue](https://github.com/babel/babel-eslint/issues/6) 中很好地解释了这个错误。

我们可以通过添加一些规则来解决这个问题，[这里](https://github.com/yannickcr/eslint-plugin-react#recommended)和[这里](https://github.com/yannickcr/eslint-plugin-react/blob/master/docs/rules/jsx-uses-vars.md)都有解答。

你可能已经注意到，这里会出现 [no-unused-vars](https://eslint.org/docs/rules/no-unused-vars) 错误，你需要将其设为警告而不是错误，因为这样可以更轻松地进行快速开发。你需要向 ESLint 添加新规则，以便不会收到默认错误。

你可以在[此处](https://eslint.org/docs/rules/no-unused-vars)和[此处](https://eslint.org/docs/user-guide/formatters/)更详细地了解这个配置。

```
...
semi: ['error', 'always'],
'no-unused-vars': [
  'warn',
  { vars: 'all', args: 'none', ignoreRestSiblings: false }
],
'prettier/prettier': 'error'
}
...
```

这样我们就会得到漂亮的错误和警告信息。

我喜欢使用自动修复功能，但我们必须明确一点：我并不是特别想让事情神奇地改变。为了避免这种情况，我们现在可以提交 autofix。

### Pre commit 钩子

在使用 Git 工具时，人们都会非常小心。但我向你保证，这个东西非常简单而且直截了当。挂载了 Prettier 的 Pre commit 钩子之后，团队在每个项目文件中将有一致的代码风格，并且没有人可以提交不规范的代码。要为你的项目设置 Git 集成，如下所示：

```
git init
git add .
nano .gitignore (add your node_modules there)
git commit -m "First commit"
git remote add origin your origin
git push -u origin master
```

这里有一些关于 [git 钩子](https://www.atlassian.com/git/tutorials/git-hooks)和[使用 Prettier](https://prettier.io/docs/en/precommit.html) 的精彩文章。

对于那些说你只能在本地做这些操作的人说：不，那不是真的！

你可以使用 [Andrey Okonetchnikov](https://medium.com/@okonetchnikov) 开源的 [lint-staged](https://github.com/okonet/lint-staged) 工具执行此操作。

### 添加 propTypes

让我们在我们的应用程序中创建一个新组件。到目前为止，我们的 `index.js` 看起来像这样：

```
import React from 'react';
import { render } from 'react-dom';

class App extends React.Component {
  render() {
    return <div>Hello</div>;
  }
}
render(<App />, document.getElementById('app'));
```

我们将创建一个名为 Hello.js 的新组件用于演示。

```
import React from 'react';
class Hello extends React.Component {
  render() {
    return <div>{this.props.hello}</div>;
  }
}
export default Hello;
```

现在在 `index.js` 文件中引入：

```
import React from 'react';
import { render } from 'react-dom';
import Hello from './Hello';
class App extends React.Component {
  render() {
    return (
      <div>
      <Hello hello={'Hello, world! And the people of the world!'} />
     </div>
   );
  }
}
render(<App />, document.getElementById('app'));
```

我们应该看到这个元素，但 ESLint 提示警告：

![](https://cdn-images-1.medium.com/max/1600/1*ZGEz6llC5Y1ITWxgnyjbgQ.png)

**Error: [eslint] ‘hello’ is missing in props validation (react/prop-types)**

在 React v16 中，必须添加 [prop 类型](https://www.tutorialspoint.com/reactjs/reactjs_props_validation.htm)以避免类型混淆。你可以在[这里](https://reactjs.org/docs/typechecking-with-proptypes.html)阅读更多相关信息。

```
import React from 'react';
import PropTypes from 'prop-types';
class Hello extends React.Component {
  render() {
    return <div>{this.props.hello}</div>;
  }
}
Hello.propTypes = {
  hello: PropTypes.string
};
export default Hello;
```

![](https://cdn-images-1.medium.com/max/1600/1*hbcqU2L5sIf6xHhYfTAt_w.png)

### 热模块替换

现在你已经检查了代码，现在是时候向 React 应用添加更多组件了。到目前为止，你只有两个，但在大多数情况下，你会有几十个。

当然，每次更改项目中的某些内容时，重新编译整个应用程序都不是一种好的选择，你需要一种更快的方法来优化它。

所以让我们添加热模块替换，即 HMR。在[文档中](https://webpack.js.org/concepts/hot-module-replacement/)，它被描述为：
> 热模块更换（HMR）在应用程序运行时变更、添加或删除[模块](https://webpack.js.org/concepts/modules/)无需完全重新加载。可以通过以下几种方式显著提升开发速度：

> 保留在完全重新加载期间丢失的应用程序状态。

> 只更新已变更的内容，即可节省宝贵的开发时间。

> 更快地调整样式 —— 几乎可以与在浏览器控制台中进行样式更改相媲美。

我不会在这里讨论它的工作原理：这足够写成一篇单独的文章，但我会告诉你该如何配置它：

```
...
output: {
  path: path.resolve(__dirname, 'dist'),
  filename: '[name].[chunkhash].js'
},
devServer: {
  contentBase: './dist',
  hot: true
},
module: {
  rules: [
...
```

### 解决 HMR 的小问题

![](https://cdn-images-1.medium.com/max/1600/1*fNtuYu1IhiI8Tfx4Kayrxg.png)

我们必须使用 hash 来替换 chunkhash，因为很明显 webpack 已经修复了自上次以来的问题，现在我们终于让热模块替换开始正常工作了！

```
...
module.exports = {
   entry: { main: './src/index.js' },
   output: {
     path: path.resolve(__dirname, 'dist'),
     filename: '[name].[hash].js'
   },
   devServer: {
     contentBase: './dist',
...
```

### 解决 bugs

如果我们在这里运行 dev 脚本：

![](https://cdn-images-1.medium.com/max/1600/1*WY_Y_fPRy26ixkq8N8aWsg.png)

然后使用[这个 issue](https://github.com/webpack/webpack/issues/1151) 提到的方案来解决它：

接下来，在 `package.json` 中添加 --hot 参数到 dev 脚本中：

```
...
"scripts": {
   "build": "webpack --mode production",
   "dev": "webpack-dev-server --hot"
}
...
```

### Source maps:

我之前提到过，**source maps 不能和 ESLint loader 一起使用**，我在[这里](https://github.com/webpack-contrib/eslint-loader/issues/227#issuecomment-386798932)提了一个 issue。

> 通常，你无论如何都不希望它们出现在你的项目中（因为你想从 ESLint 错误消息中调试项目），总所周知，他们会使 HMR 变慢。

你可以在[这里](https://github.com/facebook/create-react-app/pull/109#issuecomment-234674331)和[这里](https://github.com/facebook/create-react-app/pull/109#issuecomment-234674331)阅读更多。

![](https://cdn-images-1.medium.com/max/1600/1*TpqdcojSNpZCgwgruvJeHw.png)

如果你希望生成 source maps，最简单的方法就是通过 [devtools](https://webpack.js.org/configuration/devtool/) 选项。

```
...
module.exports = {
  entry: { main: './src/index.js' },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].[hash].js'
  },
  devtool: 'inline-source-map',
  devServer: {
    contentBase: './dist',
    hot: true
  },
  ...
```

注意：你必须以正确的方式配置环境，否则 source maps 将不起作用。你可以在[这里](https://medium.com/@riittagirl/how-to-solve-webpack-problems-the-practical-case-79fb676417f4)阅读我的调试过程。下面我将为你梳理一个流程并解释我如何解决该问题。

如果我们现在在代码中创建一个错误，它将显示在控制台中并指向正确的位置：

![](https://cdn-images-1.medium.com/max/1600/1*woAOu4zwBh0El7IDnm0jqw.png)

但现实好像不太尽人意…

![](https://cdn-images-1.medium.com/max/1600/1*1MqvBQ4uXHOFJdndj7_vNQ.png)

这是错误的做法

你需要更改环境变量，如下所示：

```
...
"main": "index.js",
"scripts": {
  "build": "webpack --mode=production",
  "start": "NODE_ENV=development webpack-dev-server --mode=development --hot"
},
"author": ""
...
```

`webpack.config.js`

```
...
devtool: 'inline-source-map',
devServer: {
  contentBase: './dist',
  open: true
}
...
```

现在它就有效了！

![](https://cdn-images-1.medium.com/max/1600/1*OgplHry1FcpiYgiHiQV3Cw.png)

如你所见，我们得到了发生错误的确切文件！

现在项目的开发环境已经搭建成功！

让我们回顾一下：

*   我们配置了 webpack
*   我们创建了第一个 React 组件
*   我们引入 ESLint 来检查代码是否存在错误
*   我们配置了热模块替换
*   我们（可能）添加了 source maps 功能

**特别提醒**：由于许多 npm 依赖项可能会在你阅读此内容时发生更改，因此相同的配置可能对你无效。我恳请你将错误留在下面的评论中，以便我以后编辑。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
