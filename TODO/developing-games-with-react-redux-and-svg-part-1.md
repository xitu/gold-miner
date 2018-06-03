> * 原文地址：[Developing Games with React, Redux, and SVG - Part 1](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-1/?utm_source=mybridge&utm_medium=blog&utm_campaign=read_more)
> * 原文作者：[Bruno Krebs](https://twitter.com/brunoskrebs)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 本文永久链接：[https://github.com/xitu/gold-miner/blob/master/TODO/developing-games-with-react-redux-and-svg-part-1.md](https://github.com/xitu/gold-miner/blob/master/TODO/developing-games-with-react-redux-and-svg-part-1.md)
> * 译者：[zephyrJS](https://github.com/zephyrJS)
> * 校对者：[allenlongbaobao](https://github.com/allenlongbaobao)、[dandyxu](https://github.com/dandyxu)

# 使用 React、Redux 和 SVG 开发游戏 — Part 1

**TL;DR:** 在这个系列里，您将学会用 React 和 Redux 来控制一些 SVG 元素来创建一个游戏。通过本系列的学习，您不仅能创建游戏，还能用 React 和 Redux 来开发其他类型的动画。您可以在这个 GitHub 仓库: [Aliens Go Home - Part 1](https://github.com/auth0-blog/aliens-go-home-part-1) 下找到最终的开发代码。

* * *

## React 游戏：Aliens, Go Home!

在这个系列里您将要开发的游戏叫做 **Aliens, Go Home!** 这个游戏的想法很简单，您将拥有一座炮台，然后您必须消灭那些试图入侵地球的飞碟。为了消灭这些飞碟，您必须在 SVG 画布上通过瞄准和点击来操作炮台的射击。

如果您很好奇, 您可以找到 [这个游戏最终运行版](http://bang-bang.digituz.com.br/)。但别太沉迷其中，您还要完成它的开发。

## 准备工作

作为学习这个系列的先决条件，您将需要一些 web 开发的知识 (主要是 JavaScript) 和一台 [安装了Node.js and NPM](https://nodejs.org/en/download/) 的电脑。您可以在没有很深的 JavaScript 编程语言知识，甚至不知晓 React、Redux 和 SVG 是如何工作的情况下学习本系列的内容。但是，如果您具备这些，您将花更少的时间来领会不同的主题以及它们是如何组合在一起的。

然而，更值得关注的是本系列包含的相关文章、帖子和文档，它们为主题提供了更好的补充说明。

## 开始之前

尽管前面没有提到 [Git](https://git-scm.com/)，但它确实是一个很好的开发工具。所有专业的开发者都会用 Git (或者其他的版本控制系统比如 Mercurial 或 SVN) 来开发，甚至是用于个人的业余项目。

为什么您创建了一个项目却不去备份它？您甚至不必付费就可以使用。因为您用了类似 [GitHub](https://github.com/) (最佳选择！) 或 [BitBucket](https://bitbucket.org/) (老实说并不差) 的服务并且将您的代码保存在值得信赖的云服务器上。

除了确保您的代码安全之外，这些工具还有助于您把握项目开发的进度。例如，如果您正在使用 Git 而且您的 app 的新版本刚好有一些 bug，只需几行命令，就能轻松回滚到之前写的代码。

另一个重要的好处是您可以为这个系列的任何一部分来提交代码。就像这样，您将 [轻松地看到这些部分的修改建议](https://git-scm.com/docs/git-diff)，通过本教程的学习，您的生活将变得更轻松。

所以，快给您自己安装个 Git 吧。另外，在 GitHub 上创建一个账号 (如果您还没有 GitHub 账户) 并且把您的项目保存到仓库里。然后，每完成一部分，就把修改提交到这个仓库上。噢，可别忘了 [push 这个操作啊](https://help.github.com/articles/pushing-to-a-remote/)。

## 用 Create-React-App 来开始一个 React 项目

首先您要用 `create-react-app` 来引导您创建一个 React、Redux 和 SVG 的游戏项目。您可能了解过它 (如果不知道也没关系)，[`create-react-app` 是一个由 Facebook 持有的开源工具，它帮助开发者快速的开始他的 React 项目](https://github.com/facebookincubator/create-react-app)。需要安装 Node.js 和 NPM 到本地 (5.2 或以上版本), 您甚至不用安装 `create-react-app` 就能使用它：

```Bash
# using npx will download (if needed)
# create-react-app and execute it
npx create-react-app aliens-go-home

# change directory to the new project
cd aliens-go-home
```

该工具将创建类似下面的目录结构：

```Bash
|- node_modules
|- public
  |- favicon.ico
  |- index.html
  |- manifest.json
|- src
  |- App.css
  |- App.js
  |- App.test.js
  |- index.css
  |- index.js
  |- logo.svg
  |- registerServiceWorker.js
|- .gitignore
|- package.json
|- package-lock.json
|- README.md
```

`create-react-app` 是非常热门的，它有着完善的文档和社区支持。例如，如果您想要了解它细节，您可以查看 [`create-react-app` 官方的 GitHub 仓库](https://github.com/facebook/create-react-app) 以及 [他的使用指南](https://github.com/facebook/create-react-app#user-guide)。

现在，您会想把您不需要的文件删掉。例如，您可以处理如下文件：

*   `App.css`：`App` 是一个很重要的组件但是他的样式定义需要交给其他组件来处理；
*   `App.test.js`：测试的内容会在其他的文章里提到，现在您还不需要用到它；
*   `logo.svg`：这个游戏里您不会用到 React 的 logo；

删除这些文件后，如果您执行这个项目它很可能会报错。但您只需要删除 `./src/App.js` 文件里引用的两句话就能轻松解决：

```JavaScript
// remove both lines from ./src/App.js
import logo from './logo.svg';
import './App.css';
```

然后重构下 `render()` 方法：

```JavaScript
// ... import statement and class definition
render() {
  return (
    <div className="App">
      <h1>We will create an awesome game with React, Redux, and SVG!</h1>
    </div>
  );
}

// ... closing bracket and export statement
```

> **千万别忘了** 提交您的文件到 Git 上！

## 安装 Redux 和 PropTypes

在启动了 React 项目并删掉了一些没用的文件之后，您将安装和配置 [Redux](https://redux.js.org/) 来使它成为 [您应用程序的唯一数据源](https://redux.js.org/docs/introduction/ThreePrinciples.html#single-source-of-truth). 您也需要安装 [PropTypes](https://github.com/facebook/prop-types)，[这个工具将帮助您避免常见的错误](https://reactjs.org/docs/typechecking-with-proptypes.html)。两个工具可以用一行命令来安装：

```Bash
npm i redux react-redux prop-types
```

如您所见，这行命令包含了第三个 NPM 包：`react-redux`。尽管您可以直接在 React 里面使用 Redux，但它不是最佳选择。[`react-redux` 对我们原本需要繁琐手动处理的性能优化有所帮助](https://redux.js.org/docs/basics/UsageWithReact.html)。

### 配置 Redux 和使用 PropTypes

有了这些包，您就能在您的应用里配置和使用 Redux 了。这个过程很简单，您将需要创建一个 **container** 组件，一个 **presentational** 组件，以及一个 **reducer**。容器组件和视图组件的区别在于，首先需要将视图组件 `连接` 到 Redux。reducer 是您将要创建的第三个组件，它是 Redux store 里的核心组件。这类组件主要用于当您的应用触发事件后来获取对应的 **actions** 并根据这些 actions 来调用关联的函数去修改相应的状态。

> 如果您对这些概念还不熟悉，您可以阅读 [这篇文章来更好的理解视图组件和容器组件](https://medium.com/@dan_abramov/smart-and-dumb-components-7ca2f9a7c7d0) 以及通过 [这篇 Redux 使用教程来学习关于 **actions**、**reducers**、和 **store** 的概念](https://auth0.com/blog/redux-practical-tutorial/). 尽管学会这些概念是很值得推荐的，但即使都不懂您也能无障碍地学习本系列的教程。

您最好先创建 reducer 来开始您的项目，因为它不依赖其它资源（事实上，正好相反）。为了把它们组合起来，您需要在 `src` 目录里面创建一个叫做 `reducers` 的新目录，然后往里面添加一个 `index.js` 文件。这个文件包含的源码如下：

```JavaScript
const initialState = {
  message: `It's easy to integrate React and Redux, isn't it?`,
};

function reducer(state = initialState) {
  return state;
}

export default reducer;
```

现在，您的 reducer 将简单地初始化一个叫 `message` 的应用状态，它将很容易的集成到 React 和 Redux 中。紧接着，您将定义 actions 并在文件中操作它们。

然后，您可以重构您的应用来向用户展示这个 message。此刻是您安装并使用 `prop-types` 的好时机。为此, 您需要打开 `./src/App.js` 文件并替换成如下内容：

```JavaScript
import React, {Component} from 'react';
import PropTypes from 'prop-types';

class App extends Component {
  render() {
    return (
      <div className="App">
        <h1>{this.props.message}</h1>
      </div>
    );
  }
}

App.propTypes = {
  message: PropTypes.string.isRequired,
};

export default App;
```

如您所见，用 `prop-types` 定义您组件所期望的类型是轻而易举的。您只需要用相应的 `props` 来定义组件的 `propTypes` 属性。网上总结了一些关于 propTypes 的基础和高级的用法的备忘录（例如 [这个](https://lzone.de/cheat-sheet/React%20PropTypes)、[这个](https://reactcheatsheet.com/)、还有[这个](https://devhints.io/react)）。如果需要，就去看看吧。

尽管您定义了需要渲染的 `App` 组件以及用 Redux store 初始化了 state，您仍然需要某种方法把组件组合在一起。这时候 **container** 组件登场了。用一种用组织的方式来定义您的 container，您将在 `src` 目录里创建一个 `containers` 目录。然后，您就可以在新目录下的 `Game.js` 里面创建一个叫 `Game` 的容器。这个组件将使用 `react-redux` 的 `connect` 方法并往 `App` 组件的 `message` 属性中传入 `state.message` 的值：

```JavaScript
import { connect } from 'react-redux';

import App from '../App';

const mapStateToProps = state => ({
  message: state.message,
});

const Game = connect(
  mapStateToProps,
)(App);

export default Game;
```

快大功告成了。最后一步是重构 `./src/index.js` 来把它们组织在一起，我们通过初始化 Redux store 和把它传进 `Game` 容器（该容器将获取 `message` 并把它传给 `App`）来完成这一步。下面就是 `./src/index.js` 文件重构后的代码：

```JavaScript
import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { createStore } from 'redux';
import './index.css';
import Game from './containers/Game';
import reducer from './reducers';
import registerServiceWorker from './registerServiceWorker';

/* eslint-disable no-underscore-dangle */
const store = createStore(
    reducer, /* preloadedState, */
    window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__(),
);
/* eslint-enable */

ReactDOM.render(
    <Provider store={store}>
        <Game />
    </Provider>,
    document.getElementById('root'),
);
registerServiceWorker();
```

搞定！现在您可以到项目的根目录运行 `npm start` 来看看是否一切正常。这将在开发模式中运行您的应用程序并在默认浏览器中打开它。

> [“集成 React 和 Redux 是非常容易的。”  在这里 tweet 我们 ![](https://cdn.auth0.com/blog/resources/twitter.svg)](https://twitter.com/intent/tweet?text="It%27s+easy+to+integrate+React+and+Redux."%20via%20@auth0%20http://auth0.com/blog/developing-games-with-react-redux-and-svg-part-1/)

## 用 React 创建 SVG 组件

在这个系列您将看到，用 React 创建 SVG 组件是非常轻松的事。事实上，用 HTML 和 SVG 创建 React 组件几乎没有区别。基本上，唯一的区别就是 SVG 引入了一些新的元素，而这些元素都是在 SVG 上绘制的。

话虽如此，在用 SVG 和 React 创建组件之前，简单了解下 SVG 还是很有帮助的。

### SVG 简介

SVG 是最酷和最灵活的 web 标准之一。SVG 是可伸缩矢量图形 (Scalable Vector Graphics) 标准，它是一种标记语言，允许开发人员绘制二维的矢量图形。它与 HTML 非常相似。这两种技术都是基于 XML 标记语言，可以很好地与 CSS 和 DOM 等其他 Web 标准兼容。这意味着您可以将 CSS 规则应用于 SVG 元素，就像您对 HTML 元素 (包括动画) 所做的那样。

在本系列教程里，您将用 React 创建许多 SVG 组件。您甚至将组合（填充）SVG 元素到您的 game 元素里(就像往大炮里填充炮弹一样)。

关于 SVG 详尽的介绍并不在本系列的探讨访问之内，它将使本文过于冗长。所以，如果您想学习关于 SVG 标记语言更详尽的内容，您可以去查看 [Mozilla 提供的 **SVG 教程**](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial) 以及在 [这篇文章中了解关于 SVG 坐标系的内容](https://www.sarasoueidan.com/blog/svg-coordinate-systems/)。

但是，在开始创建组件之前，您需要了解一些关于 SVG 的重要特性。首先，开发者可以将 SVG 和 DOM 组合在一起来实现某些令人兴奋的功能。我们可以很轻松地把 React 和 SVG 结合起来。

其次，SVG 坐标系跟笛卡尔平面非常相似，但却是上下颠倒的。那意味着在 x 轴上方(y 轴上半轴)默认是负值。另一方面，横坐标的值跟笛卡尔平面一样（即负值显示在 y 轴的左侧）。这些行为很容易通过 [在 SVG 的画布里转化](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/transform) 来修改。但是，为了不使其它的开发人员感到困惑，最好还是使用默认的方式。您将很快习惯它的用法。

第三也是最后一件事，您需要知道 SVG 引入了许多的新元素（例如 `circle`、`rect`、和 `path`）。 要使用这些元素，不能简单地在 HTML 元素中定义它们。首先, 您必须在您想要绘制的 SVG 组件里定义一个 svg 元素（画布）。

### SVG，Path 元素和三次贝塞尔曲线

使用 SVG 绘制元素可以通过三种方式完成。首先，您可以使用像 `rect`，`circle` 和 `line` 这些元素。尽管它们用起来不怎么方便。顾名思义，它们只能让您绘制一些简单的图形。

第二种方式是把它们组合成更为复杂的图形。例如，您可以用一个等边的 `矩形`（正方形）和两条直线组合成一个房子。但是这种做法仍然有局限性。

使用 [`path` 元素](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Paths) 是更加灵活的第三者方式。这种元素允许开发者创建更加复杂的图形。它接受一组命令来指导浏览器绘制绘制图形。例如，要绘制一个 'L'，您可以创建一个 `path` 元素，其中包含三个命令：

1.  `M 20 20`: `M` 是移动的意思，这个命令让浏览器的 `画笔` 移动到指定的 X 和 Y 坐标（即 `20, 20`）；
2.  `V 80`: 这个命令让浏览器绘制一条从上一个点到 `80` 的平行于 y 轴的垂直线；
3.  `H 50`: 这个命令让浏览器绘制一条从上一个点到 `50` 的平行于 x 轴的水平线；

```JavaScript
<svg>
  <path d="M 20 20 V 80 H 50" stroke="black" stroke-width="2" fill="transparent" />
</svg>
```

`path` 元素接受许多其他命令。其中，最重要的命令之一就是 [三次贝塞尔曲线命令](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Paths#Bezier_Curves). 此命令允许您在路径中添加一些平滑曲线，方法是获取两个参考点和两个控制点。

Mozilla 教程介绍了三次贝塞尔曲线在 SVG 上是如何工作的：

> **”三次贝塞尔曲线的每个点都有两个控制点来控制。因此，为了创建三次贝塞尔曲线，您需要定义三组坐标。最后一组坐标表示曲线的终点。另外两组是控制点。[...]。控制点实际上描述的是曲线起始点的斜率。Bezier 函数创建一个平滑曲线，描述了从起点斜率到终点斜率的渐变过程“** —[Mozilla 开发者网络](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Paths#Bezier_Curves)

例如，绘制一个 “U”，您可以按照如下步骤执行：

```JavaScrpt
<svg>
  <path d="M 20 20 C 20 110, 110 110, 110 20" stroke="black" fill="transparent"/>
</svg>
```

在这个例子里，传递给 `path` 元素的指令告诉浏览器需要执行以下步骤：

1.  先绘制一个坐标点 `20, 20`；
2.  第一个控制点的坐标是 `20, 110`；
3.  接着第二个控制点的坐标是 `110, 110`；
4.  结束曲线的终点坐标是 `110 20`；

如果您仍然不知道三次贝塞尔曲线是如何工作的，也不用担心。在本系列教程里，有将会有机会来练习它的。除此之外，您还可以在网上找到许多关于这个特性的教程而且您也可以通过类似 [JSFiddle](https://jsfiddle.net/) 和 [Codepen](https://codepen.io/) 这类工具来练习它。

### 创建 Canvas 组件

既然您的项目已经结构化，并且您已经了解了 SVG 的基本知识，那么是时候开始创建您的游戏了。您需要创建的第一个元素是 SVG 画布，您将使用它来绘制游戏的元素。

这是一个视图组件。因此，您可以在 `./src` 目录下创建一个名为 `Component` 目录，用来保存和它类似的组件。您的动画都将在上面绘制，叫 `Canvas` 是在自然不过的事了。因此，在 `./src/components/` 目录下创建 `Canvas.jsx` 文件并添加如下代码：

```JavaScript
import React from 'react';

const Canvas = () => {
  const style = {
    border: '1px solid black',
  };
  return (
    <svg
      id="aliens-go-home-canvas"
      preserveAspectRatio="xMaxYMax none"
      style={style}
    >
      <circle cx={0} cy={0} r={50} />
    </svg>
  );
};

export default Canvas;
```

有了这个文件后，您将重构您的 `App` 组件来使用 `Canvas`：

```JavaScript
import React, {Component} from 'react';
import Canvas from './components/Canvas';

class App extends Component {
  render() {
    return (
      <Canvas />
    );
  }
}

export default App;
```

如果您运行了（`npm start`）命令并查看了您的应用，您将看到浏览器只绘制了圆的四分之一。这是因为坐标系原点默认在窗口的左上角。另外，您也会看到 `svg` 并没有占满整个屏幕。

为了便于管理，您最好将画布填充满整个屏幕。您也会希望重新定位它的原点，使其位于 X 轴的中心，并且靠近底部（一会您就会把您的炮台放在原点上）。同时，您需要修改这两个文件：`./src/components/Canvas.jsx` 和 `./src/index.css`。

您可以把 `Canva` 组件的内容替换成如下代码：

```JavaScript
import React from 'react';

const Canvas = () => {
  const viewBox = [window.innerWidth / -2, 100 - window.innerHeight, window.innerWidth, window.innerHeight];
  return (
    <svg
      id="aliens-go-home-canvas"
      preserveAspectRatio="xMaxYMax none"
      viewBox={viewBox}
    >
      <circle cx={0} cy={0} r={50} />
    </svg>
  );
};

export default Canvas;
```

在新的版本里，您会为 `svg` 元素定义 [`viewBox` 特性](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/viewBox)。此特性的作用是定义画布及其内容必须适合特定容器（在当前的例子里指的是 window/browser）。如您所见，`viewBox` 特性有 4 个参数：

*   `min-x`：这个值定义的是用户看到的最左边的点。因此，要使 y 轴（和圆）出现在屏幕中心，可以将屏幕宽度除以负 2（`window.innerWidth/-2`），来得到这个属性（`min-x`）。注意您要使用 `-2` 来平分原点左（负）右（正）两边的数值。
*   `min-y`：这个值定义了您画布最上边的点。这里，您通过 `100` 减去 `window.innerHeight` 来给 Y 原点之后空出了一些区域(`100` 点)。
*   `width` 和 `height`：这些值定义了用户将在屏幕上看到多少个 X 和 Y 坐标。

除了定义 `viewBox` 特性，您也可以在新版本里定义 [`preserveAspectRatio`](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/preserveAspectRatio) 特性。您已经使用了 `xMaxYMax none` 来强制使画布和它的元素进行统一的缩放。

重构您的画布之后，您需要在 `./src/index.css` 文件中添加如下规则：

```CSS
/* ... body definition ... */

html, body {
  overflow: hidden;
  height: 100%;
}
```

这将是 `html` 和 `body` 元素隐藏（禁用）滚动。它也将是这些元素占满这个屏幕。

如果您现在查看您的应用，您会看到您的圆正水平居中并位于屏幕底部附近。

### 创建 Sky 组件

在使画布占满整个屏幕并将原点轴重新定位到它的中心之后，是时候创建真正的游戏元素了。您可以先定义一个 sky 组件来作为您的游戏背景。为此，可以在 `./src/Components/` 目录下创建 `Sky.jsx` 文件，代码如下：

```JavaScript
import React from 'react';

const Sky = () => {
  const skyStyle = {
    fill: '#30abef',
  };
  const skyWidth = 5000;
  const gameHeight = 1200;
  return (
    <rect
      style={skyStyle}
      x={skyWidth / -2}
      y={100 - gameHeight}
      width={skyWidth}
      height={gameHeight}
    />
  );
};

export default Sky;
```

您可能会感到奇怪为什么要给您的游戏设置如此巨大的区域（宽 `5000` 和高 `1200`）。事实上，宽度在这个游戏中并不重要。您只需要设置可以覆盖任何尺寸的屏幕就够了。

现在，高度是很重要的。很快，无论用户分辨率是多少横屏还是竖屏，您都会把画布高度强制显示为 `1200`。这将给您游戏带来一致地体验，每个用户都将会在同一区域看到您的游戏。像这样，您将会定义飞碟将出现在哪里以及它们将需要多长时间通过这些点。

要想您的画布显示您的新天空，请在编辑器打开 `Canvas.jsx` 并对其进行重构：

```JavaScript
import React from 'react';
import Sky from './Sky';

const Canvas = () => {
  const viewBox = [window.innerWidth / -2, 100 - window.innerHeight, window.innerWidth, window.innerHeight];
  return (
    <svg
      id="aliens-go-home-canvas"
      preserveAspectRatio="xMaxYMax none"
      viewBox={viewBox}
    >
      <Sky />
      <circle cx={0} cy={0} r={50} />
    </svg>
  );
};

export default Canvas;
```

如果您现在检查您的应用（`npm start`），您将看到您的圆仍在正中央靠近底部的位置，而且您现在有了一个蓝色（`fill: '#30abef'`）的背景。

> **注意：** 如果您将 `Sky` 组件放到 `circle` 组件后面，您将再也看不到后者。这是因为 SVG **并不** 支持 `z-index` 属性。SVG 依赖于所列元素的顺序来决定哪个元素高于另一个元素。也就是说，您必须在 `Sky` 组件之后定义 `Circle` 组件，这样才能让网页浏览器知道必须在蓝色背景之上显示它。

### 创建 Ground 组件

创建完 `Sky` 组件后， 接下来您可以创建 `Ground` 组件。为此，在 `./src/Components/` 目录下创建一个名为 `Cround.js` 的新文件，并添加如下代码：

```JavaScript
import React from 'react';

const Ground = () => {
  const groundStyle = {
    fill: '#59a941',
  };
  const division = {
    stroke: '#458232',
    strokeWidth: '3px',
  };

  const groundWidth = 5000;

  return (
    <g id="ground">
      <rect
        id="ground-2"
        data-name="ground"
        style={groundStyle}
        x={groundWidth / -2}
        y={0}
        width={groundWidth}
        height={100}
      />
      <line
        x1={groundWidth / -2}
        y1={0}
        x2={groundWidth / 2}
        y2={0}
        style={division}
      />
    </g>
  );
};

export default Ground;
```

这是一个并不怎么花哨的组件。它只由一个矩形和一条线组成。但是，如您所见，它还是需要一个值为 `5000` 的常量来定义宽度。因此，专门创建一个文件来保存这样的全局常量是一个不错的选择。

就像这样，在 `./src/` 目录下创建一个名为 `utils` 的新目录，紧接着，在这个新目录下创建一个名为 `constants.js` 文件。 现在，您可以往里面添加一个常量：

```JavaScript
// very wide to provide as full screen feeling
export const skyAndGroundWidth = 5000;
```

之后，您就可以重构您的 `Sky` 组件和 `Ground` 组件来使用这个新常量。

结束这节后，可别忘了往您的画布里添加 `Groud` 组件（记得要放在 `Sky` 组件和 `Circle`组件之间）。[如果您对于最后的这些步骤有什么疑问，请在这里给我留言](https://github.com/auth0-blog/aliens-go-home-part-1/commit/f453eb5147821f0289ecd81b8ae8deb0b7941f0e).

### 创建 Cannon 组件

现在您的游戏了已经有了 sky 组件和 ground 组件了。接下来，您将添加一些更加有趣的东西。也许，是时候让您的 cannon 组件登场了。这些组件会比其它的两个组件要复杂些。它们将会有更多行代码，这是由于您将要用三次贝塞尔曲线来绘制它们。

您可能还记得，在 SVG 上定义三次贝塞尔曲线需要四个点：起点，终点以及两个控制点。这些点在 `path` 元素上的 `d` 属性里定义，就像这样：`M 20 20 C 20 110, 110 110, 110 20`。

为了避免重复您可在代码里使用 [模板字符串](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Template_literals) 来创建这些曲线，您可以在 `./src/utils/` 目录下创建一个名为 `formulas.js` 的文件，并定义一个传入某些参数就会返回这些字符串的函数：

```JavaScript
export const pathFromBezierCurve = (cubicBezierCurve) => {
  const {
    initialAxis, initialControlPoint, endingControlPoint, endingAxis,
  } = cubicBezierCurve;
  return `
    M${initialAxis.x} ${initialAxis.y}
    c ${initialControlPoint.x} ${initialControlPoint.y}
    ${endingControlPoint.x} ${endingControlPoint.y}
    ${endingAxis.x} ${endingAxis.y}
  `;
};
```

这段代码十分简单，它先从 `cubicBezierCurve` 中提取（`initialAxis`，`initialControlPoint`，`endingControlPoint`，`endingAxis`）接着将它们传入到构建三次贝塞尔曲线的模板字符串中。

有了这个文件，您就可以构建您的炮台了。为了让事情更有条理，您需要把您的炮台分为两部分： `CannonBase` 和 `CannonPipe`。

要定义 `CannonBase`，需在 `./src/components` 目录下创建 `CannonBase.jsx` 文件并添加如下代码：

```JavaScript
import React from 'react';
import { pathFromBezierCurve } from '../utils/formulas';

const CannonBase = (props) => {
  const cannonBaseStyle = {
    fill: '#a16012',
    stroke: '#75450e',
    strokeWidth: '2px',
  };

  const baseWith = 80;
  const halfBase = 40;
  const height = 60;
  const negativeHeight = height * -1;

  const cubicBezierCurve = {
    initialAxis: {
      x: -halfBase,
      y: height,
    },
    initialControlPoint: {
      x: 20,
      y: negativeHeight,
    },
    endingControlPoint: {
      x: 60,
      y: negativeHeight,
    },
    endingAxis: {
      x: baseWith,
      y: 0,
    },
  };

  return (
    <g>
      <path
        style={cannonBaseStyle}
        d={pathFromBezierCurve(cubicBezierCurve)}
      />
      <line
        x1={-halfBase}
        y1={height}
        x2={halfBase}
        y2={height}
        style={cannonBaseStyle}
      />
    </g>
  );
};

export default CannonBase;
```

除了三次贝塞尔曲线，这个组件没有其他新意。最后，浏览器会渲染出一个带有深棕色的曲线和亮棕色背景的元素。

创建 `CannonPipe` 的代码将会类似于 `CannonBase`。不同之处在于它将使用其他颜色，并用其他的坐标点来传 `pathFromBezierCurve` 函数来绘制炮管。另外，这个组件还会使用 [transform](https://developer.mozilla.org/en-US/docs/Web/SVG/Attribute/transform) 属性来模拟炮台的旋转。

为了创建这个组件，`./src/components/` 目录下创建 `CannonPipe.jsx` 文件并添加如下代码：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';
import { pathFromBezierCurve } from '../utils/formulas';

const CannonPipe = (props) => {
  const cannonPipeStyle = {
    fill: '#999',
    stroke: '#666',
    strokeWidth: '2px',
  };
  const transform = `rotate(${props.rotation}, 0, 0)`;

  const muzzleWidth = 40;
  const halfMuzzle = 20;
  const height = 100;
  const yBasis = 70;

  const cubicBezierCurve = {
    initialAxis: {
      x: -halfMuzzle,
      y: -yBasis,
    },
    initialControlPoint: {
      x: -40,
      y: height * 1.7,
    },
    endingControlPoint: {
      x: 80,
      y: height * 1.7,
    },
    endingAxis: {
      x: muzzleWidth,
      y: 0,
    },
  };

  return (
    <g transform={transform}>
      <path
        style={cannonPipeStyle}
        d={pathFromBezierCurve(cubicBezierCurve)}
      />
      <line
        x1={-halfMuzzle}
        y1={-yBasis}
        x2={halfMuzzle}
        y2={-yBasis}
        style={cannonPipeStyle}
      />
    </g>
  );
};

CannonPipe.propTypes = {
  rotation: PropTypes.number.isRequired,
};

export default CannonPipe;
```

之后，从您的画布中移除 `circle` 组件并用 `CannonBase` 和 `CannonPipe` 来替代它。这是重构之后的代码：

```JavaScript
import React from 'react';
import Sky from './Sky';
import Ground from './Ground';
import CannonBase from './CannonBase';
import CannonPipe from './CannonPipe';

const Canvas = () => {
  const viewBox = [window.innerWidth / -2, 100 - window.innerHeight, window.innerWidth, window.innerHeight];
  return (
    <svg
      id="aliens-go-home-canvas"
      preserveAspectRatio="xMaxYMax none"
      viewBox={viewBox}
    >
      <Sky />
      <Ground />
      <CannonPipe rotation={45} />
      <CannonBase />
    </svg>
  );
};

export default Canvas;
```

检查并运行您的应用，您将看到如下矢量图所呈现的画面：

![Drawing SVG elements with React and Redux ](https://cdn.auth0.com/blog/aliens-go-home/cannon-react-component.png)

### 让 Cannon 能够瞄准

您的游戏越来越完善了。您已经给游戏添加了背景元素（`Sky` 和 `Ground`）和炮台。现在的问题是所有东西都是死的。所以，为了让事情变得更有趣，您要专注于完成炮台的瞄准功能。为此，您要给您的画布添加 `onmousemove` 时间监听器并在每次触发是刷新它（即，每次用户移动鼠标的时候），但这会降低您的游戏性能。

为了解决这种状况，您需要设置一个 [固定的间隔](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/setInterval) 来检查最后一个鼠标的位置，以调整您的 `CannonPipe` 的角度。这个策略里您将继续使用 `onmousemove` 时间监听器，不同的是这些事件不会一直触发重新渲染。它们只将更新游戏中的一个属性，然后间隔地使用这个属性来触发重新选择（通过更新 Redux store）。

这是您第一次要用 Redux 的 **action** 来更新应用程序的状态（或者是说炮台的角度）。像这样，您需要在 `./src/` 目录下创建 `actions` 的新目录。在新目录里，您需要创建 `index.js` 文件并添加如下代码：

```JavaScript
export const MOVE_OBJECTS = 'MOVE_OBJECTS';

export const moveObjects = mousePosition => ({
  type: MOVE_OBJECTS,
  mousePosition,
});
```

> **注意：** 您将调用 `MOVE_OBJECTS` 这个指令因为您不仅会用它来更新炮台。在 [本系列的下个教程里](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-2/)，您还将使用同样的指令来移动炮弹和飞碟。

在定义完 Redux action 后，您将重构您的 reducer（`./src/reducers/` 中的 `index.js` 文件）来处理它：

```JavaScript
import { MOVE_OBJECTS } from '../actions';
import moveObjects from './moveObjects';

const initialState = {
  angle: 45,
};

function reducer(state = initialState, action) {
  switch (action.type) {
    case MOVE_OBJECTS:
      return moveObjects(state, action);
    default:
      return state;
  }
}

export default reducer;
```

这个文件的新版本执行一个 action，如果 `type` 是 `MOVE_OBJECTS`, 它将调用 `moveObjects` 函数。需要注意的是，在定义该函数之前，您还需要在新版本里定义应用的初始化状态，它包含了值为 `45` 的 `angle` 属性。这定义了您应用程序里炮台的初始瞄准角度。

如您所见，`moveObjects` 函数就是一个 **reducer**。您将会在新文件里定义这个函数因为您将会有大量的 `reducer` 而您希望更好的管理和维护它们。因此，在 `./src/reducers/` 目录里创建 `moveObjects.js` 文件并添加如下代码：

```JavaScript
import { calculateAngle } from '../utils/formulas';

function moveObjects(state, action) {
  if (!action.mousePosition) return state;
  const { x, y } = action.mousePosition;
  const angle = calculateAngle(0, 0, x, y);
  return {
    ...state,
    angle,
  };
}

export default moveObjects;
```

这段代码很简单，它只是从 `mousePosition` 中获取 `x` 和 `y` 属性，并把它们传给 `calculateAngle` 函数来获取新的 `angle`。最后，会用新的 angle 来生成新的 state。

现在，您可能已经发现您还没有在 `formulas.js` 文件中定义 `calculateAngle` 函数，对吗？关于如何用两个点来算出需要的角度已经超出了本章的讨论范围，如果您感兴趣的话，可以查阅 [StackExchange 上的这个问题](https://math.stackexchange.com/questions/714378/find-the-angle-that-creating-with-y-axis-in-degrees) 来理解其背后究竟发生了什么。最后，您需要在 `formulas.js`  文件（`./src/utils/formulas`）里添加如下函数：

```JavaScript
export const radiansToDegrees = radians => ((radians * 180) / Math.PI);

// https://math.stackexchange.com/questions/714378/find-the-angle-that-creating-with-y-axis-in-degrees
export const calculateAngle = (x1, y1, x2, y2) => {
  if (x2 >= 0 && y2 >= 0) {
    return 90;
  } else if (x2 < 0 && y2 >= 0) {
    return -90;
  }

  const dividend = x2 - x1;
  const divisor = y2 - y1;
  const quotient = dividend / divisor;
  return radiansToDegrees(Math.atan(quotient)) * -1;
};
```

> **注意：** 由 JavaScript 的 `Math` 对象提供的 `atan` 函数来算出一个弧度值。您将需要把这个值转换为度数。这就是您为什么要定义（和使用）`radiansToDegrees` 函数的原因。

在之后新定义的 action 和 reducer 里，您将会继续用到这个函数。但您的游戏依赖于 Redux 来管理它的状态时，您需要将 `moveObjects` 映射到您 `App` 的 `props` 里。您将重构 `Game` 容器来完成这些操作。因此，打开 `Game.js` 文件（`./src/containers`）并替换成如下代码：

```JavaScript
import { connect } from 'react-redux';

import App from '../App';
import { moveObjects } from '../actions/index';

const mapStateToProps = state => ({
  angle: state.angle,
});

const mapDispatchToProps = dispatch => ({
  moveObjects: (mousePosition) => {
    dispatch(moveObjects(mousePosition));
  },
});

const Game = connect(
  mapStateToProps,
  mapDispatchToProps,
)(App);

export default Game;
```

有了这些映射以后，您只需要把精力放在如何在 `App` 组件里使用它们。所以，打开 `App.js` 文件（在 `./src/` 目录下）并替换成如下代码：

```JavaScript
import React, {Component} from 'react';
import PropTypes from 'prop-types';
import { getCanvasPosition } from './utils/formulas';
import Canvas from './components/Canvas';

class App extends Component {
  componentDidMount() {
    const self = this;
    setInterval(() => {
        self.props.moveObjects(self.canvasMousePosition);
    }, 10);
  }

  trackMouse(event) {
    this.canvasMousePosition = getCanvasPosition(event);
  }

  render() {
    return (
      <Canvas
        angle={this.props.angle}
        trackMouse={event => (this.trackMouse(event))}
      />
    );
  }
}

App.propTypes = {
  angle: PropTypes.number.isRequired,
  moveObjects: PropTypes.func.isRequired,
};

export default App;
```

您会发现我们对这个新版本做了很多修改。总结如下：

*   `componentDidMount`: 您定义了 [生命周期方法](https://reactjs.org/docs/react-component.html#componentdidmount) 来间断地触发 `moveObjects` 指令。
*   `trackMouse`: 您定义了这个方法用来更新 `App` 组件的 `canvasMousePosition` 属性。这个属性受控于 `moveObjects` 指令。注意这个属性获取的不是 HTML 文档上的鼠标位置。[而是引用您画布里的相对位置](https://stackoverflow.com/questions/10298658/mouse-position-inside-autoscaled-svg)。您将在稍后定义 `canvasMousePosition` 函数。
*   `render`: 现在这个方法会把 `angle` 属性和 `trackMouse` 方法传入到 `Canvas` 组件里。这个组件将使用更新 `angle` 方式来渲染您的 cannon 组件并将 `trackMouse` 作为事件监听器添加到 `svg` 元素上。稍后您将更新这个组件。
*   `App.propTypes`: 现在您在这里定义了两个属性，`angle` 和 `moveObjects`。首先是 `angle` 属性，它是用来定义您的炮台的瞄准角度度。其次是 `moveObjects` 函数，它将每隔一段时间更新您的 cannon 组件。

现在已经更新完了 `App` 组件，接下来您需要往 `formulas.js` 文件里添加如下代码：

```JavaScript
export const getCanvasPosition = (event) => {
  // mouse position on auto-scaling canvas
  // https://stackoverflow.com/a/10298843/1232793

  const svg = document.getElementById('aliens-go-home-canvas');
  const point = svg.createSVGPoint();

  point.x = event.clientX;
  point.y = event.clientY;
  const { x, y } = point.matrixTransform(svg.getScreenCTM().inverse());
  return {x, y};
};
```

如果您对为什么需要它感兴趣，[在 StackOverflow 上您会找的答案](https://stackoverflow.com/a/10298843/1232793)。

最后一步是更新您的 `Canvas` 组件来使您的炮台能够瞄准。打开 `Canvas.jsx` 文件（在 `./src/components` 里）并替换成如下内容：

```JavaScript
import React from 'react';
import PropTypes from 'prop-types';
import Sky from './Sky';
import Ground from './Ground';
import CannonBase from './CannonBase';
import CannonPipe from './CannonPipe';

const Canvas = (props) => {
  const viewBox = [window.innerWidth / -2, 100 - window.innerHeight, window.innerWidth, window.innerHeight];
  return (
    <svg
      id="aliens-go-home-canvas"
      preserveAspectRatio="xMaxYMax none"
      onMouseMove={props.trackMouse}
      viewBox={viewBox}
    >
      <Sky />
      <Ground />
      <CannonPipe rotation={props.angle} />
      <CannonBase />
    </svg>
  );
};

Canvas.propTypes = {
  angle: PropTypes.number.isRequired,
  trackMouse: PropTypes.func.isRequired,
};

export default Canvas;
```

当前版本和上一个版本的区别有：

*   `CannonPipe.rotation`：这个属性不再是写死的了。现在，它被绑定到 Redux store 所提供的状态里（通过 `App` 映射）。
*   `svg.onMouseMove`：您会将此事件监听器添加到画布中，以使得 `App` 组件能感知到鼠标的位置。
*   `Canvas.propTypes`：您会明确地为该组件定义它需要 `angle` 和 `trackMouse` 属性。

就这样！您应该准备好来预览您炮台的瞄准功能。 切换到 terminal，并在项目的根目录运行 `npm start` （如果它还没有运行）。 然后，在浏览器里打开 [http://localhost:3000/](http://localhost:3000/) 并移动鼠标。您的炮台将跟随鼠标旋转起来。

多有趣啊！？

> [“我用 React, Redux 和 SVG 创建了一个可以瞄准的炮台。这多有趣啊！？” 在这里 tweet 我们 ![](https://cdn.auth0.com/blog/resources/twitter.svg)](https://twitter.com/intent/tweet?text="I+have+created+an+animated+cannon+with+React%2C+Redux%2C+and+SVG%21+How+fun+is+that%21%3F"%20via%20@auth0%20http://auth0.com/blog/developing-games-with-react-redux-and-svg-part-1/)

## 总结和下一步

在本系列的第一部分，您学习了一些重要的主题，它将帮助您创建一个完整游戏。您也使用了 `create-react-app` 来创建您的项目并创建了一些游戏元素，如炮台、天空和大地。最后，您给炮台添加了瞄准功能。有了这些元素，您就能其他的 React 组件并让他们动起来。

[在本系列的下篇文章中](https://auth0.com/blog/developing-games-with-react-redux-and-svg-part-2/)，您将再创造一些组件，来让一些飞碟随机出现在预定的位置。之后，您将使您的炮台能够发射一些炮弹。这实在令人激动！

请保持关注！


---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[区块链](https://github.com/xitu/gold-miner#区块链)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计)、[人工智能](https://github.com/xitu/gold-miner#人工智能)等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)、[官方微博](http://weibo.com/juejinfanyi)、[知乎专栏](https://zhuanlan.zhihu.com/juejinfanyi)。


