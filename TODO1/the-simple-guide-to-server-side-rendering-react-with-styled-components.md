> * 原文地址：[The simple guide to server-side rendering React with styled-components](https://medium.com/styled-components/the-simple-guide-to-server-side-rendering-react-with-styled-components-d31c6b2b8fbf)
> * 原文作者：[Dennis Brotzky](https://medium.com/@JobeirDennis?source=post_header_lockup)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO1/the-simple-guide-to-server-side-rendering-react-with-styled-components.md](https://github.com/xitu/gold-miner/blob/master/TODO1/the-simple-guide-to-server-side-rendering-react-with-styled-components.md)
> * 译者：[Elliott Zhao](https://github.com/elliott-zhao)
> * 校对者：hannah(https://github.com/hannahGu) [lance10030](https://github.com/lance10030)

# 使用 styled-components 的 React 服务端渲染极简指南

![](https://cdn-images-1.medium.com/max/2000/1*esSohBffpbW40OCldHJ_zA.png)

本指南旨在分享服务端渲染的 React App 中使用 style-components 的核心原则。当你意识到把 styled-components 集成到你的程序中是多么的完美，它的美才真正凸显出来。除此之外，styled-components 还很容易集成到使用其他样式方案的现有应用程序中。

在本指南中，没有类似于 Redux，React Router 这类额外的库，或者代码拆分之类的概念 —— 让我们从基础开始。

你可以在这里看到最终能工作的例子： [**https://github.com/Jobeir/styled-components-server-side-rendering**](https://github.com/Jobeir/styled-components-server-side-rendering)，这里参与此文的讨论： [**https://spectrum.chat/thread/b95c9ef2-20cb-4bab-952f-fadd90add391**](https://spectrum.chat/thread/b95c9ef2-20cb-4bab-952f-fadd90add391)

### 开始构建我们的 React 应用

![](https://cdn-images-1.medium.com/max/600/1*wbD3IaUAwYsSHJa9Y6OBBA.png)

应用架构。

首先，让我们来看看在这个指南中我们的应用程序的架构是怎样的。我们需要把所有的依赖和脚本放在 `package.json` 中，并且我们的构建步骤会通过 `webpack.config.js` 进行处理。

除此之外，一个单独的 `server.js` 文件来处理我们的 React 应用程序的路由和服务。 `client/` 目录中有含 `App.js`，`Html.js` 和 `index.js` 在内的我们实际的应用程序。

首先，新建一个空的文件目录，通过下面的指令创建一个空的 `package.json` 文件：

`npm init --yes` 或者 `yarn init --yes`

然后把下方展示的脚本和依赖都粘进去。这个应用的依赖有 React，styled-components，Express，Wepback 和 Babel。

```json
"scripts": {
  "start": "node ./dist/server",
  "build": "webpack"
},
"devDependencies": {
  "babel-core": "^6.10.4",
  "babel-loader": "^7.1.2",
  "babel-preset-env": "^1.6.1",
  "babel-preset-react": "^6.11.1",
  "webpack": "^3.8.1",
  "webpack-node-externals": "^1.2.0"
},
"dependencies": {
  "express": "^4.14.0",
  "react": "^16.2.0",
  "react-dom": "^16.2.0",
  "styled-components": "^2.2.4"
}
```

既然我们所有的依赖关系都已经被考虑到了，并且我们已经设置了脚本来启动和构建我们的项目，我们现在可以设置我们的 React 应用程序了。

**1.`src/client/App.js`**

```javascript
import React from 'react';

const App = () => <div>💅</div>;

export default App;
```

`App.js` 返回一个包裹 💅 表情符的 div。这是一个非常基本的 React 组件，我们将把它渲染到浏览器中。

**2.`src/client/index.js`**

```javascript
import React from 'react';
import { render } from 'react-dom';
import App from './App';

render(<App />, document.getElementById('app'));
```

`index.js` 是将 React 应用程序装入 DOM 的标准方式。它会取出 `App.js` 组件并渲染它。

**3.`src/client/Html.js`**

```javascript
/**
 * Html
 * 这个 Html.js 文件充当了一个模板，我们将所有生成的应用程序代码插入其中
 * 然后作为常规的 HTML 发送给客户端。
 * 注意我们从这个函数返回一个模板字符串。
 */
const Html = ({ body, title }) => `
  <!DOCTYPE html>
  <html>
    <head>
      <title>${title}</title>
    </head>
    <body style="margin:0">
      <div id="app">${body}</div>
    </body>
  </html>
`;

export default Html;
```

到目前为止，我们已经有了一个 `package.json`，它包含了我们所有的依赖和脚本，还有在 `src/client/` 文件夹中的一个基本的 React 应用程序。这个 React 应用程序会把 `Html.js` 文件返回的模板字符串渲染为 HTML。

### 创建服务

![](https://cdn-images-1.medium.com/max/800/1*_o9W9dTKMXheC-LLQC3Bzw.png)

为了在服务器上渲染我们的应用，我们需要安装 express 处理请求并返回我们的 HTML。express 添加进来以后，我们就可以创建服务了。

**`src/server.js`**

```javascript
import express from 'express';
import React from 'react';
import { renderToString } from 'react-dom/server';
import App from './client/App';
import Html from './client/Html';

const port = 3000;
const server = express();

server.get('/', (req, res) => {
  /**
   * renderToString()  将获取我们的 React 应用程序并将其转换为一个字
   * 符串，以便插入到我们的 Html 模板函数中。
   */
  const body = renderToString(<App />);
  const title = 'Server side Rendering with Styled Components';

  res.send(
    Html({
      body,
      title
    })
  );
});

server.listen(port);
console.log(`Serving at http://localhost:${port}`);
```

### 配置 Webpack

本指南专注于非常基础的知识，因此我们让 Webpack 配置保持简单。我们使用 Webpack 和 Babel 在生产模式下构建我们的 React 应用程序。有一个单入口在 `src/server.js` 中，它将被输出到 `dist/` 下。

```javascript
const webpack = require('webpack');
const nodeExternals = require('webpack-node-externals');
const path = require('path');

module.exports = {
  entry: './src/server.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'server.js',
    publicPath: '/'
  },
  target: 'node',
  externals: nodeExternals(),
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: `'production'`
      }
    })
  ],
  module: {
    loaders: [
      {
        test: /\.js$/,
        loader: 'babel-loader'
      }
    ]
  }
};
```

现在我们已经可以构建并服务一个服务端渲染的 React 应用程序了。我们可以运行两个命令并做好准备。

首先，运行：

`yarn build` 或者 `npm build`

然后用过运行以下命令启动程序：

`yarn start` 或者 `npm start`

**如果它没有启动，你可能需要在项目的根目录中添加一个** `_.babelrc_` **文件。**

![](https://cdn-images-1.medium.com/max/800/1*1xXs7xt80kpSk37hCVyQ7w.png)

yarn build，然后 yarn start，成功后访问 [http://localhost:3000](http://localhost:3000)。

### 添加 styled-components

到目前为止，一切都很好。我们已经成功创建了一个在服务器上渲染的 React 应用程序。我们没有任何类似 React Router，Redux 的第三方库，而且我们的 Webpack 配置也是直奔主题的。

接下来，让我们开始使用 styled-components 样式化我们的应用。

**1. `src/client/App.js`**

让我们创建我们的第一个 styled component。要创建一个 styled component，首先要导入 `styled` 并且定义你的组件。

```javascript
import React from 'react';
import styled from 'styled-components';

// 我们的单个styled component 定义
const AppContaienr = styled.div`
  display: flex;
  align-items: center;
  justify-content: center;
  position: fixed;
  width: 100%;
  height: 100%;
  font-size: 40px;
  background: linear-gradient(20deg, rgb(219, 112, 147), #daa357);
`;

const App = () => <AppContaienr>💅</AppContaienr>;

export default App;
```

把一个 styled component 添加到我们的应用

**2. `src/server.js`**

这是最大的变化发生的地方。 `styled-components` 暴露了 `ServerStyleSheet`，它允许我们用 `<App />` 中的所有 `styled` 组件创建一个样式表。这个样式表稍后会传入我们的 `Html` 模板。

```javascript
import express from 'express';
import React from 'react';
import { renderToString } from 'react-dom/server';
import App from './client/App';
import Html from './client/Html';
import { ServerStyleSheet } from 'styled-components'; // <-- 导入 ServerStyleSheet

const port = 3000;
const server = express();

// 创建索引路由为我们的 React 应用程序提供服务。
server.get('/', (req, res) => {
  const sheet = new ServerStyleSheet(); // <-- 创建样式表

  const body = renderToString(sheet.collectStyles(<App />)); // <-- 搜集样式
  const styles = sheet.getStyleTags(); // <-- 从表中获取所有标签
  const title = 'Server side Rendering with Styled Components';

  res.send(
    Html({
      body,
      styles, // <-- 将样式传递给我们的 Html 模板
      title
    })
  );
});

server.listen(port);
console.log(`Serving at http://localhost:${port}`);
```

向 server.js 添加5行代码。

**3. `src/client/Html.js`**

将 `styles` 作为参数添加到我们的 `Html` 函数中，并将 `$ {styles}` 参数插入到我们的模板字符串中。

```javascript
/**
 * Html
 * 这个 Html.js 文件充当了一个模板，我们将所有生成的应用程序代码插入其中
 * 成的应用程序字符串插入进去。
 */
const Html = ({ body, styles, title }) => `
  <!DOCTYPE html>
  <html>
    <head>
      <title>${title}</title>
      ${styles}
    </head>
    <body style="margin:0">
      <div id="app">${body}</div>
    </body>
  </html>
`;

export default Html;
```

**就是这样！让我们构建并运行使用服务端渲染的 React 和 styled-components 应用程序吧。**

`yarn build` 或者 `npm build`

然后用过运行以下命令启动程序：

`yarn start` 或者 `npm start`

![](https://cdn-images-1.medium.com/max/1000/1*TuzLZNu5HEHcK4h0cEZNdw.png)

### 结论

我们已经创建了服务端渲染中使用 styled-components 的 React 应用程序的分步指南。本指南周围没有各种花哨的技巧，因为我们想要关注核心概念。从这里开始，您可以在现有应用程序中使用这些原则，或者在本指南的基础上构建更复杂的应用程序。还有其他一些指南可以帮助您添加状态管理，路由，性能改进等等。

* * *

### 不要停止学习！

感谢您阅读本指南到最后。希望它能帮助你理解并开始使用 React / SSR 和 styled-components。如果您认识任何可能从本指南中受益的人，我会很乐意推荐给他们！

如果您希望看到使用样式化组件的服务端渲染的较大代码库，则可以查看我的另一个项目，[Jobeir, on Github](https://github.com/Jobeir/jobeir). 最重要的是，[styled-components文档](https://www.styled-components.com/docs/advanced#server-side-rendering)总是一个不错的去处。

### 在 [Jobeir](https://jobeir.com) 的在 SSR React 中使用 styled-components

我是谁？我是 [**Jobeir**](https://jobeir.com) 的创始人，Jobeir 是一个专注于帮助每个人找到科技领域最好的工作的工作布告栏。我在加拿大温哥华担任高级前端开发人员。可以在 [Twitter](https://twitter.com/jobeirofficial) 上问我问题，或者跟我打招呼，又或者检索我们的 [Github](https://github.com/Jobeir) 仓库。

> 如果发现译文存在错误或其他需要改进的地方，欢迎到 [掘金翻译计划](https://github.com/xitu/gold-miner) 对译文进行修改并 PR，也可获得相应奖励积分。文章开头的 **本文永久链接** 即为本文在 GitHub 上的 MarkDown 链接。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。
