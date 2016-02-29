> * 原文链接 : [Distributing React components](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs)
* 原文作者 : [Krasimir ](http://krasimirtsonev.com/blog/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [aleen42](http://aleen42.github.io/)
* 校对者: [Aaaaaashu](https://github.com/Aaaaaashu)、[achilleo](https://github.com/achilleo)
* 状态 : 完成

在我开源 [react-place](https://github.com/krasimir/react-place) 项目到时候，我注意到那么一个问题。那就是，准备构件发布有些复杂。因此，我决定在此记录该过程，以便日后遇到同样的问题时可查。

在准备构件期间，你会惊奇地发现建立`jsx`文件并不意味着该构件可用于发布，或该构件对于其他开发人员来说是可用的东西。

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#the-component)构件

[react-place](https://github.com/krasimir/react-place) 是一个提供输入服务的构件。当用户输入一个城市的名字时，该构件会作出预测并提供建议选项给该用户。`onLocationSet`是该构件的一个属性。当用户选择某些建议选项时，它将会被触发。触发后，构件里的一个函数，它将接收一个对象作为参数输入。该对象包含有对一个城市的简短描述以及其地理坐标。总的来说，我们是和一个外部 API （谷歌地图）和一个参与的硬关联（自动完成输入组件）进行通信操作。[这里](http://krasimir.github.io/react-place/example/index.html)有一个例子，它将展示该构件如何工作。

下面，我们来一起看看构件是如何完成？为何完成后，该构件还不能被发布？

时下，有一些概念处于风口浪尖。其中，就有 React 和它的[ JSX 语法](https://facebook.github.io/react/docs/jsx-in-depth.html)。另外，还有新版的 ES6 标准，而所有的这些，都与我们的浏览器息息相关。虽然，我想尽早应用这些新鲜的概念，但我需要一个转译器，用于解决它们兼容性不高的问题。该转译器将需要解析 ES6 标准下的代码并生成对应 ES5 标准下的。[Babel](http://babeljs.io/) 就是一款专门做这样工作的转换编译器，并且它能很好地结合于 React 使用。除了转译器之外，我还需要一个代码包装工具。该工具能解析[输入](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import)并生成一个包含应用的文件。在众多包装工具中，[webpack](https://webpack.github.io/) 是我的选择。

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#the-base)主要开发过程

两周前，我创建了一个 [react-webpack-started](https://github.com/krasimir/react-webpack-starter)。它接收一个 JSX 文件作为输入并用 Babel 生成对应的 ES5 文件。我们有一部本地开发伺服器、测试设定以及一个 linter 插件，然而这是另外一个故事，这里并不详述。（在[这里](http://krasimirtsonev.com/blog/article/a-modern-react-starter-pack-based-on-webpack)有相关更多的信息）。

在半年前，我更喜欢用 NPM 来定义项目的任务建立。下面是我刚开始可以运行的 NPM 脚本：

    // in package.json
    "scripts": {
      "dev": "./node_modules/.bin/webpack --watch --inline",
      "test": "karma start",
      "test:ci": "watch 'npm run test' src/"
    }

`npm run dev` 该命令将触发 webpack 进行编译并启动设备进行服务。测试是通过 [Karma runner](http://karma-runner.github.io/) 和 Phantomjs 来完成的。而我使用的文件结构则如下所示：

    |
    +-- example-es6
    |   +-- build
    |   |   +-- app.js
    |   |   +-- app.js.map
    |   +-- src
    |   |   +-- index.js
    |   +-- index.html
    +-- src
        +-- vendor
        |   +-- google.js
        + -- Location.jsx

我要发布的构件是放在`Location.jsx`里。为了测试它，我创建了一个简单的 app 应用（`example-es6` 文件夹）来导入该文件。

花了一些时间，终于把该构件开发完成。我把更改部分推送到 GitHub 的 [repository](https://github.com/krasimir/react-place) 并错误认为该构件已经可以被分享出去。然而，五分钟后我意识到这构件并不能。那是因为：

*   如果我以 NPM 包发布该构件，我将需要一个入口地址。那么我想，我的 JSX 文件适合作入口地址吗？并不能，因为并不是所有的开发人员都喜欢 JSX。因此，该构件应该开发成非 JSX 版本。
*   我入口地址的代码是遵循 ES6 标准来书写的，然而并不是所有的开发者都遵循 ES6 标准且在建立过程中使用到转译器。因此，入口地址代码应该是遵循兼容性更高的 ES5 标准。
*   webpack 的输出确实满足了上面所述的两个要求，然而它有一个问题。那就是该代码包装工具包含了整个 React 库，而我们想包装的只是该组件，不是 React。

综上所述，webpack 在开发过程的确是很有用，然而却并不能生成一个可用于引入或导入的文件。我尝试过使用 webpack 的 [externals](https://webpack.github.io/docs/library-and-externals.html) 选项来解决问题。但是我发现，当我们有全局可用的依赖时，该问题仍然是存在的。

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#producing-es5-entry-point)建立符合 ES5 标准的入口地址

从前面可以看到，定义一个是新的 NPM 脚本是很重要的。 NPM 甚至[有](https://docs.npmjs.com/misc/scripts)一个`prepublish`入口。它可以在包发布前且在本地执行`npm install`命令时运行。下面是我新添加的定义：

    // package.json
    "scripts": {
      "prepublish": "./node_modules/.bin/babel ./src --out-dir ./lib --source-maps --presets es2015,react"
      ...
    }

在这里，我们不需要使用 webpack，而只是使用 Babel。它会从`src`文件夹获取所有需要的东西，转化 JSX 文件为纯 JavaScript 调用并把 ES6 标准下的代码转成 ES5标准下的。 因此，文件结构将是：

    |
    +-- example-es6
    +-- lib
    |   +-- vendor
    |   |   +-- google.js
    |   |   +-- google.js.map
    |   +-- Location.js
    |   +-- Location.js.map
    +-- src
        +-- vendor
        |   +-- google.js
        + -- Location.jsx

`src`文件夹中的文件会被翻译成普通的 JavaScript 文件并加上所生成的源映射。在这过程，`--presets`选项中的 [`es2015`](https://babeljs.io/docs/plugins/preset-es2015/) 和 [`react`](https://babeljs.io/docs/plugins/preset-react/) 扮演着重要的角色。

理论上，从 ES5 标准下的代码中，我们应该可以通过命令`require('Location.js')`使得构件运作起来。但是，当我打开文件时，我发现这里并没有`module.exports`，而只是发现

    exports.default = Location;

这将意味着我需要通过下面的命令来引入库：

    require('Location').default;

很感谢地说，[babel-plugin-add-module-exports](https://www.npmjs.com/package/babel-plugin-add-module-exports) 解决了该问题。因此，我把 NPM 脚本改成了如下：

    ./node_modules/.bin/babel ./src --out-dir ./lib 
    --source-maps --presets es2015,react 
    --plugins babel-plugin-add-module-exports

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#generating-browser-bundle)浏览器化

前面部分介绍所生成的是一个可被任何 JavaScript 项目导入或引用的文件。任何一个代码包装工具像 webpack 或 [Browserify](http://browserify.org/) 都会解析所需要的依赖。但我最后考虑的一点是，如果开发人员不使用代码包装工具，那怎么办？简而言之，就是我们需要一个已经生成好的 JavaScript 文件，并直接可以使用 `<script>` 标签引入该文件到我的页面里。假设 React 已经加载到页面里，那么我只需要再把有着自动完成组件的构件引入到页面即可。

为了解决这个，我将会有效地利用了`lib`文件夹下的文件。这就是我之前所提的“浏览器化”。那么，我们来看看该怎么处理：

    ./node_modules/.bin/browserify ./lib/Location.js 
    -o ./build/react-place.js 
    --transform browserify-global-shim 
    --standalone ReactPlace

`-o`选项是用来指定输出文件。`--standalone` 选项是必须的，因为我并没有一个模块系统，所以该构件需要可全局访问。有趣的一点是`--transform browserify-global-shim`选项。这是一个转化加载项，其可用于排除 React 而只导入那个自动完成组件。为了使其工作，我需要像下面一样在`package.js`添加新的条目，：

    // package.json
    "browserify-global-shim": {
      "react": "React",
      "react-dom": "ReactDOM"
    }

在此，我声明了一些全局变量的名字。而这些全局变量将会在调用构件里的`require('react')`和`require('react-dom')`时被解析。当我们打开生成的`build/react-place.js`文件，我们将会看到：

    var _react = (window.React);
    var _reactDom = (window.ReactDOM);

在谈论把构件作为`script>`标签引入时，我想我们应该需要对其进行压缩。当然，在生产环境，我们还应该对`build/react-place.js`文件生成一个压缩版本。[Uglifyjs](https://www.npmjs.com/package/uglify-js) 是一个不错的模块，其可用于压缩 JavaScript 代码。因此，我们只需要在“浏览器化”后调用即可：

    ./node_modules/.bin/uglifyjs ./build/react-place.js 
    --compress --mangle 
    --output ./build/react-place.min.js 
    --source-map ./build/react-place.min.js.map

## [](http://krasimirtsonev.com/blog/article/distributing-react-components-babel-browserify-webpack-uglifyjs#the-result)结果

最后，所生成的脚本文件是一个结合了 Babel， Browserify 和 Uglifyjs三个模块的文件。

    // package.json
    "prepublish": "
      ./node_modules/.bin/babel ./src --out-dir ./lib --source-maps --presets es2015,react --plugins babel-plugin-add-module-exports && 
      ./node_modules/.bin/browserify ./lib/Location.js -o ./build/react-place.js --transform browserify-global-shim --standalone ReactPlace && 
      ./node_modules/.bin/uglifyjs ./build/react-place.js --compress --mangle --output ./build/react-place.min.js --source-map ./build/react-place.min.js.map
    ",

_（注：为了使得脚本可读性更高，我把语句分成了几行。但是，在原来的 [package.json](https://github.com/krasimir/react-place/blob/master/package.json#L25) 文件里，所有的语句都被摆放成一行。）_

最后，项目里的文件夹/文件将如下所示：

    |
    +-- build
    |   +-- react-place.js
    |   +-- react-place.min.js
    |   +-- react-place.min.js.map
    +-- example-es6
    |   +-- build
    |   |   +-- app.js
    |   |   +-- app.js.map
    |   +-- src
    |   |   +-- index.js
    |   +-- index.html
    +-- lib
    |   +-- vendor
    |   |   +-- google.js
    |   |   +-- google.js.map
    |   +-- Location.js
    |   +-- Location.js.map
    +-- src
        +-- vendor
        |   +-- google.js
        + -- Location.jsx
