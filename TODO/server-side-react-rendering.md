> * 原文地址：[Server-Side React Rendering](https://css-tricks.com/server-side-react-rendering/)
> * 原文作者：[Roger Jin](https://css-tricks.com/author/rogerjin/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/server-side-react-rendering.md](https://github.com/xitu/gold-miner/blob/master/TODO/server-side-react-rendering.md)
> * 译者：[牧云云](https://github.com/MuYunyun)
> * 校对者：[CACppuccino](https://github.com/CACppuccino)、[xx1124961758](https://github.com/xx1124961758)

# React 在服务端渲染的实现

React是最受欢迎的客户端 JavaScript 框架，但你知道吗(或许更应该试试)，你可以使用 React 在服务器端进行渲染？

假设你为客户构建了一个很棒的事件列表 React app。。该应用程序使用了您最喜欢的服务器端工具构建的API。几周后，用户告诉您，他们的页面没有显示在 Google 上，发布到 Facebook 时也显示不出来。 这些问题似乎是可以解决的，对吧？

您会发现，要解决这个问题，需要在初始加载时从服务器渲染 React 页面，以便来自搜索引擎和社交媒体网站的爬虫工具可以读取您的标记。有证据表明，Google 有时会执行 javascript 程序并且对生成的内容进行索引，但并不总是这样。因此，如果您希望确保与其他服​​务（如 Facebook、Twitter）有良好的 SEO 兼容性，那么始终建议使用服务器端渲染。

在本教程中，我们将逐步介绍服务器端的呈现示例。包括围绕与 API 交流的 React 应用程序的共同路障。
在本教程中，我们将逐步向您介绍服务器端的渲染示例。包括围绕着 APIS 交流一些在服务端渲染 React 应用程序的共同障碍。

# 服务端渲染的优势

可能您的团队谈论到服务端渲染的好处是首先会想到 SEO，但这并不是唯一的潜在好处。

更大的好处如下：服务器端渲染能更快地显示页面。使用服务器端渲染，您的服务器对浏览器进行响应是在您的 HTML 页面可以渲染的时候，因此浏览器可以不用等待所有的 JavaScript 被下载和执行就可以开始渲染。当浏览器下载并执行页面所需的 JavaScript 和其他资源时，不会出现 “白屏” 现象，而 “白屏” 却可能在完全由客户端渲染的 React 网站中出现。

# 入门

接下来让我们来看看如何将服务器端渲染添加到一个基本的客户端渲染的使用 Babel 和 Webpack 的 React 应用程序中。我们的应用程序将会因从第三方 API 获取数据而变得有点复杂。我们在 GitHub 上提供了[相关代码](https://github.com/ButterCMS/react-ssr-example/releases/tag/starter-code)，您可以在其中看到完整的示例。

提供的代码中只有一个 React 组件，\`hello.js\`，这个文件将向 [ButterCMS API](https://buttercms.com/) 发出异步请求，并渲染返回 JSON 列表中的博文。ButterCMS 是一个基于 API 的博客引擎，可供个人使用，因此它非常适合测试现实生活中的用例。启动代码中连接着一个 API token，如果你想使用你自己的 API token 可以[使用你的 GitHub 账号登入 ButterCMS](https://buttercms.com/home/)。

``` js
import React from 'react';
import Butter from 'buttercms'

const butter = Butter('b60a008584313ed21803780bc9208557b3b49fbb');

var Hello = React.createClass({
  getInitialState: function() {
    return {loaded: false};
  },
  componentWillMount: function() {
    butter.post.list().then((resp) => {
      this.setState({
        loaded: true,
        resp: resp.data
      })
    });
  },
  render: function() {
    if (this.state.loaded) {
      return (
        <div>
          {this.state.resp.data.map((post) => {
            return (
              <div key={post.slug}>{post.title}</div>
            )
          })}
        </div>
      );
    } else {
      return <div>Loading...</div>;
    }
  }
});

export default Hello;
```

启动器代码中包含以下内容：
- package.json - 依赖项
- Webpack 和 Babel 配置
- index.html - app 的 HTML 文件
- index.js - 加载 React 并渲染 Hello 组件

要使应用运行，请先克隆资源库：

```
git clone ...
cd ..
```

安装依赖:

```
npm install
```

然后启动服务器:

```
npm run start
```

浏览器输入 http://localhost:8000 可以看到这个 app: (这里译者进行补充，package.json 里的 start 命令改为如下：`"start": webpack-dev-server --watch`)

![](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_1000,f_auto,q_auto/v1497358286/localhost_r84tot.png)

如果您查看渲染页面的源代码，您将看到发送到浏览器的标记只是一个到 JavaScript 文件的链接。这意味着页面的内容不能保证被搜索引擎和社交媒体平台抓取:

![](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_1000,f_auto,q_auto/v1497358332/some-html_mrmpfj.png)

# 增加服务器端渲染

接下来，我们将实现服务器端渲染，以便将完全生成的 HTML 发送到浏览器。如果要同时查看所有更改，请在 [GitHub](https://github.com/ButterCMS/react-ssr-example/commit/525c625b0f65489050983ed03b52bb7770ce6b7a) 上查看文件的差异。

开始前，让我们安装 Express，一个 Node.js 的服务器端应用程序框架：

```
npm install express --save
```

我们要创建一个渲染我们的 React 组件的服务器：

``` js
import express from 'express';
import fs from 'fs';
import path from 'path';
import React from 'react';
import ReactDOMServer from 'react-dom/server';
import Hello from './Hello.js';

function handleRender(req, res) {
  // 把 Hello 组件渲染成 HTML 字符串
  const html = ReactDOMServer.renderToString(<Hello />);

  // 加载 index.html 的内容
  fs.readFile('./index.html', 'utf8', function (err, data) {
    if (err) throw err;

    // 把渲染后的 React HTML 插入到 div 中
    const document = data.replace(/<div id="app"><\/div>/, `<div id="app">${html}</div>`);

    // 把响应传回给客户端
    res.send(document);
  });
}

const app = express();

// 服务器使用 static 中间件构建 build 路径
app.use('/build', express.static(path.join(__dirname, 'build')));

// 使用我们的 handleRender 中间件处理服务端请求
app.get('*', handleRender);

// 启动服务器
app.listen(3000);
```

让我们分解下程序看看发生了什么事情...

`handleRender` 函数处理所有请求。在文件顶部导入的 [ReactDOMServer 类](https://facebook.github.io/react/docs/react-dom-server.html)提供了将 React 节点渲染成其初始 HTML 的 renderToString() 方法
``` js
ReactDOMServer.renderToString(<Hello />);
```

这将返回 Hello 组件的 HTML，我们将其注入到 index.html 的 HTML 中，从而生成服务器上页面的完整 HTML。

``` js
const document = data.replace(/<div id="app"><\/div>/,`<div id="app">${html}</div>`);
```

要启动服务器，请更新 \`package.json\` 中的起始脚本，然后运行 `npm run start` :

```
"scripts": {
  "start": "webpack && babel-node server.js"
},
```

浏览 `http://localhost:3000` 查看应用程序。瞧！您的页面现在正在从服务器渲染出来了。但是有个问题，
如果您在浏览器中查看页面源码，您会注意到博客文章仍未包含在响应中。这是怎么回事？如果我们在 Chrome 中打开网络面板，我们会看到客户端上发生 API 请求。

![](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_1000,f_auto,q_auto/v1497358447/devtools_qx5y1o.png)

虽然我们在服务器上渲染了 React 组件，但是 API 请求在 componentWillMount 中异步生成，并且组件在请求完成之前渲染。所以即使我们已经在服务器上完成渲染，但我们只是完成了部分。事实上，[React repo 有一个 issue](https://github.com/facebook/react/issues/1739)，超过 100 条评论讨论了这个问题和各种解决方法。

# 在渲染之前获取数据

要解决这个问题，我们需要在渲染 Hello 组件之前确保 API 请求完成。这意味着要使 API 请求跳出 React 的组件渲染循环，并在渲染组件之前获取数据。我们将逐步介绍这一步，但您可以在 [GitHub 上查看完整的差异](https://github.com/ButterCMS/react-ssr-example/commit/5fdd453e31ab08dfdc8b44261696d4ed89fbb719)。

要在渲染之前获取数据，我们需安装 [react-transmit](https://github.com/RickWong/react-transmit)：

```
npm install react-transmit --save
```

React Transmit 给了我们优雅的包装器组件（通常称为“高阶组件”），用于获取在客户端和服务器上工作的数据。

这是我们使用 react-transmit 后的组件的代码：

``` js
import React from 'react';
import Butter from 'buttercms'
import Transmit from 'react-transmit';

const butter = Butter('b60a008584313ed21803780bc9208557b3b49fbb');

var Hello = React.createClass({
  render: function() {
    if (this.props.posts) {
      return (
        <div>
          {this.props.posts.data.map((post) => {
            return (
              <div key={post.slug}>{post.title}</div>
            )
          })}
        </div>
      );
    } else {
      return <div>Loading...</div>;
    }
  }
});

export default Transmit.createContainer(Hello, {
  // 必须设定 initiallVariables 和 ftagments ,否则渲染时会报错
  initialVariables: {},
  // 定义的方法名将成为 Transmit props 的名称
  fragments: {
    posts() {
      return butter.post.list().then((resp) => resp.data);
    }
  }
});
```

我们已经使用 `Transmit.createContainer` 将我们的组件包装在一个高级组件中，该组件可以用来获取数据。我们在 React 组件中删除了生命周期方法，因为无需两次获取数据。同时我们把 render 方法中的 state 替换成 props，因为 React Transmit 将数据作为 props 传递给组件。

为了确保服务器在渲染之前获取数据，我们导入 Transmit 并使用 `Transmit.renderToString` 而不是 `ReactDOM.renderToString` 方法

``` js
import express from 'express';
import fs from 'fs';
import path from 'path';
import React from 'react';
import ReactDOMServer from 'react-dom/server';
import Hello from './Hello.js';
import Transmit from 'react-transmit';

function handleRender(req, res) {
  Transmit.renderToString(Hello).then(({reactString, reactData}) => {
    fs.readFile('./index.html', 'utf8', function (err, data) {
      if (err) throw err;

      const document = data.replace(/<div id="app"><\/div>/, `<div id="app">${reactString}</div>`);
      const output = Transmit.injectIntoMarkup(document, reactData, ['/build/client.js']);

      res.send(document);
    });
  });
}

const app = express();

// 服务器使用 static 中间件构建 build 路径
app.use('/build', express.static(path.join(__dirname, 'build')));

// 使用我们的 handleRender 中间件处理服务端请求
app.get('*', handleRender);

// 启动服务器
app.listen(3000);
```

重新启动服务器浏览到 `http://localhost：3000`。查看页面源代码，您将看到该页面现在完全呈现在服务器上！

![](https://res.cloudinary.com/css-tricks/image/upload/c_scale,w_1000,f_auto,q_auto/v1497358548/rendered-react_t5neam.png)

# 更进一步

我们做到了！在服务器上使用 React 可能很棘手，尤其是从 API 获取数据时。幸运的是，React 社区正在蓬勃发展，并创造了许多有用的工具。如果您对构建在客户端和服务器上渲染的大型 React 应用程序的框架感兴趣，请查看 Walmart Labs 的 [Electrode](https://github.com/electrode-io/electrode) 或 [Next.js](https://github.com/zeit/next.js)。或者如果要在 Ruby 中渲染 React ，请查看 Airbnb 的 [Hypernova](https://github.com/airbnb/hypernova) 。


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。

