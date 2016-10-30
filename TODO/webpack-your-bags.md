>* 原文链接 : [Webpack your bags](https://blog.madewithlove.be/post/webpack-your-bags/)
* 原文作者 : [Maxime Fabre](https://twitter.com/anahkiasen)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [达仔](https://github.com/Zhangjd)
* 校对者: [Malcolm](https://github.com/malcolmyu)、[L9m](https://github.com/L9m)

# 让 Webpack 来帮你打包吧

![](https://webpack.github.io/assets/what-is-webpack.png)

你可能已经在前端社区听过这个称为 **Webpack** 的新玩意儿了。有人将它当作像 **Gulp** 的构建工具，也有人把它作为一个类似 **Browserify** 的模块管理器，如果你没有深入研究的话，你可能会因此感到困惑。但另一方面，如果你已经了解过它了，你大概还是会感到疑惑，因为官网表示 Webpack 身兼两职。

实话实说，刚开始时，围绕 “什么是 Webpack” 的模棱两可的回答让我很挫败。毕竟我已经建立起一套构建系统了，并且这套系统运行良好。并且如果你也在密切关注 Javascript 生态圈的发展的话，你大概也会被过去的种种盲目跟风所伤害过。现在我知道的多一点了，我觉得我应该写下这篇文章给那些对于 Webpack 保持观望态度的人们看看到底什么是 Webpack，更重要的是，为什么 Webpack 很棒，值得我们更多的关注。

## 什么是 Webpack?

现在回答介绍中提出的问题：Webpack 到底是一个构建系统，还是一个模块打包器？嗯，它两种都是 —— 我的意思不是它两种工作都做，而是它把这两种工作组合起来了。Webpack 并不是帮你分别构建静态资源和打包模块，而是_把你的静态资源也当作模块本身_。

更确切地说，这意味着你不需要构建你的 Sass 文件和对图片资源做优化了，只需要一边把它们都包含进来，然后打包你所有的模块，另一边在页面里引用资源。比如这样：


```javascript
    import stylesheet from 'styles/my-styles.scss';
    import logo from 'img/my-logo.svg';
    import someTemplate from 'html/some-template.html';

    console.log(stylesheet); // "body{font-size:12px}"
    console.log(logo); // "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5[...]"
    console.log(someTemplate) // "<html><body><h1>Hello</h1></body></html>"
```


你的所有静态资源都可以被当作是模块，然后引入、修改、操作，并打包到最终的输出文件中。

为了实现这个目的，你需要在 Webpack 配置文件中注册 **loaders** 。Loaders 是一些小插件，其功能基本可以归纳为“对不同的类型的文件执行不同的操作”。以下是一些 loader 的例子：



    {
      // 当你引入 .ts 后缀的文件时，使用 TypeScript 解析文件
      test: /\.ts/,
      loader: 'typescript',
    },
    {
      // 遇到图片文件，使用 image-webpack (封装了 imagemin) 压缩，并转换为内联 data64 URLs
      test: /\.(png|jpg|svg)/,
      loaders: ['url', 'image-webpack'],
    },
    {
      // 遇到 SCSS 文件，使用 node-sass 解析，然后传递给 autoprefixer，最终以 CSS 字符串的形式返回结果
      test: /\.scss/,
      loaders: ['css', 'autoprefixer', 'sass'],
    }



所有 loader 最终的输出都是返回字符串。这使得 Webpack 可以把他们都打包进 Javascript 模块当中。在例子中，你的 Sass 文件经过 loader 转换，最终输出的字符串可能是这样的：



    export default 'body{font-size:12px}';



![](http://ww2.sinaimg.cn/large/a490147fgw1f4i0yb05tmg20dw06i4qp.gif)

## 到底为什么你要那样做呢？

一旦你明白了 Webpack 是什么之后，你会很快想到第二个问题：Webpack 这种做法有什么好处呢？“图像和 CSS 都在 JS 中？这到底是什么鬼！” 试想，在很长的一段时间里，我们被教导要把所有东西整合到一个文件里，这样的好处是可以减少 HTTP 请求。

这种做法有一个很大的缺陷，因为现在大部分人把他们所有的静态资源打包到一个 `app.js` 文件中。这意味着在大部分时间里，打开某个特定页面，你额外加载了一大堆不必要的静态资源。如果你不想那样做的话，你很可能会把静态资源手动包含在特定页面里，导致依赖树非常混乱，难以维护和保持跟踪：这个依赖项用在哪个页面中？样式表 A 和 B 会影响哪些页面？

这两种做法无关对错。可以把 Webpack 设想为一个平衡点 —— 既不只是构建系统，也不是打包器，它是一个聪明绝顶的模块打包系统。一旦合理配置好后，它甚至比你更了解你的技术栈，并帮你实现最佳的优化方案。

## 让我们一起来建一个小型 app 吧

为了让你更好地理解 Webpack 的好处，我们将构建一个非常小的 app，并打包所有静态资源。在这个教程中，我建议你运行 Node 4 (或者 5) 和 NPM3，因为平行依赖树会避免 Webpack 的一些坑。如果你还没安装 NPM 3，可以通过 `npm install npm@3 -g` 安装。



    $ node --version
    v5.7.1
    $ npm --version
    3.6.0



我建议你把 `node_modules/.bin` 添加到环境变量，以避免每次输入 `node_modules/.bin/webpack` 。在下面我运行的命令中，我将不会把 `node_modules/.bin` 部分写出了。

### 基本引导

让我们开始创建工程和安装 Webpack。我们引入 jQuery 来演示之后的一些功能。



    $ npm init -y
    $ npm install jquery --save
    $ npm install webpack --save-dev



现在让我们创建 app 的入口文件，我们现在使用 ES5 语法：

**src/index.js**



    var $ = require('jquery');

    $('body').html('Hello');



然后创建 Webpack 配置文件，配置在 `webpack.config.js` 文件中，语法也是 Javascript ，并且需要输出一个对象。

**webpack.config.js**



    module.exports = {
        entry:  './src',
        output: {
            path:     'builds',
            filename: 'bundle.js',
        },
    };



在这里，`entry` 告诉 Webpack 哪些文件是你的应用的入口点。那些文件都是你的主要文件，并且在依赖树的顶层。然后指明了输出的打包文件位于 `builds` 目录的 `bundle.js` 文件中。接下来让我们相应地创建首页的 HTML 文件。


```HTML
    <!DOCTYPE html>
    <html>
    <body>
        <h1>My title</h1>
        <a>Click me</a>

        <script src="builds/bundle.js"></script>
    </body>
    </html>
```


现在运行 Webpack，如果所有步骤都没有出错，我们会得到一下信息，告诉我们 `bundle.js` 已经编译好了。



    $ webpack
    Hash: d41fc61f5b9d72c13744
    Version: webpack 1.12.14
    Time: 301ms
        Asset    Size  Chunks             Chunk Names
    bundle.js  268 kB       0  [emitted]  main
       [0] ./src/index.js 53 bytes {0} [built]
        + 1 hidden modules



这里你可以看到 Webpack 告诉你，`bundle.js` 包含了我们的入口点 (`index.js`) 和一个隐藏的模块，也就是 jQuery。默认情况下，Webpack 不会显示那些不是你的模块，想要看见 Webpack 编译好的所有模块，可以加上 `--display-modules` 选项：



    $ webpack --display-modules
    bundle.js  268 kB       0  [emitted]  main
       [0] ./src/index.js 53 bytes {0} [built]
       [1] ./~/jquery/dist/jquery.js 259 kB {0} [built]



你还可以运行 `webpack --watch` ，使 webpack 自动监听你的文件改变，按需重新编译。

### 设置我们的第一个 loader

还记得我们提到 Webpack 是如何输入 CSS、HTML 和其他内容的吗？他们适合在哪些地方？如果你在关注最近几年 Web Components 的巨大变化 (Angular 2, Vue, React, Polymer, X-Tag 等)，你可能会听说过这种思路 —— 使用一套可重用、相互独立的 UI 组件，称为 web components（我在这里不做详述，读者明白意思就好），代替一套完整的、相互连接的 UI。现在，为了让组件真正地相互独立开，必须在组件内部打包其所有的依赖。

现在开始写我们的按钮：首先，我猜你们大部分人现在更习惯使用 ES2015，因此我们先添加第一个 loader: Babel。要在 Webpack 安装 loader，需要两个步骤：输入命令 `npm install {whatever}-loader`，并在配置文件的 `module.loaders` 部分添加信息，如下所示，先安装 Babel：



    $ npm install babel-loader --save-dev



注意 babel loader 并不会自动安装 babel，所以我们还需要安装 Babel 本身的 `babel-core` 包，以及我们需要的 `es2015` preset：



    $ npm install babel-core babel-preset-es2015 --save-dev



现在我们要创建一个 `.babelrc` 文件，告诉 Babel 使用哪个 preset。这是一个简单的 JSON 文件，允许你配置 Babel 使用哪些转换器来转换你的代码 —— 在我们的例子里使用的就是 `es2015` preset。


**.babelrc** `{ "presets": ["es2015"] }`

现在 Babel 已经安装配置好，我们可以修改 Webpack 配置了：我们想要 Babel 作用在所有 `.js` 文件里，**但是** 因为 Webpack 会遍历所有依赖，我们要避免 Babel 作用在 jQuery 这些第三方库。因此，我们可以加上过滤规则。Loaders 可以同时包含 `include` 或者 `exclude` 规则，它们的值可以是字符串、正则表达式、回调函数或者其它你想要的东西。在我们的例子中，我们想要 Babel 只作用在我们自己写的文件里，所以加上 `include` 规则，让它只作用在我们的源代码目录里。



    module.exports = {
        entry:  './src',
        output: {
            path:     'builds',
            filename: 'bundle.js',
        },
        module: {
            loaders: [
                {
                    test:   /\.js/,
                    loader: 'babel',
                    include: __dirname + '/src',
                }
            ],
        }
    };



由于引入了 Babel，现在我们可以用 ES6 重写 `index.js` 了，从现在开始我们都使用 ES6 语法。



    import $ from 'jquery';

    $('body').html('Hello');



### 写一个小组件

我们现在来写一个小的按钮组件，它包含某些 SCSS 样式，一个 HTML 模板和一些行为。现在先安装依赖，我们使用 Mustache，它是一个轻量级的模板包，但我们还需要 Sass 和 HTML 文件的 loaders。由于结果是从一个 loader 向另一个 loader 管道式传递的，我们还需要 CSS loader 来处理 Sass loader 的输出结果。现在我们有了 CSS 资源，可以通过多种方式来处理它们，目前，我们会使用一个 `style-loader` ，它可以读取 CSS 文件，动态注入到页面中。



    $ npm install mustache --save
    $ npm install css-loader style-loader html-loader sass-loader node-sass --save-dev



现在，为了告诉 Webpack 从一个 loader 向另一个 loader 管道式地传送文件，我们从右到左把 loader 串联起来，中间通过 `!` 分隔。或者你也可以使用一个数组作为值，然后用 `loaders` 属性代替 `loader`。



    {
        test:    /\.js/,
        loader:  'babel',
        include: __dirname + '/src',
    },
    {
        test:   /\.scss/,
        loader: 'style!css!sass',
        // 或者
        loaders: ['style', 'css', 'sass'],
    },
    {
        test:   /\.html/,
        loader: 'html',
    }



现在我们已经把 loader 放在合适位置了，是时候开始写我们的按钮了：

**src/Components/Button.scss**



    .button {
      background: tomato;
      color: white;
    }



**src/Components/Button.html**



     class="button" href="{{link}}">{{text}}



**src/Components/Button.js**



    import $ from 'jquery';
    import template from './Button.html';
    import Mustache from 'mustache';
    import './Button.scss';

    export default class Button {
        constructor(link) {
            this.link = link;
        }

        onClick(event) {
            event.preventDefault();
            alert(this.link);
        }

        render(node) {
            const text = $(node).text();

            // 渲染按钮
            $(node).html(
                Mustache.render(template, {text})
            );

            // 绑定事件
            $('.button').click(this.onClick.bind(this));
        }
    }



你的 `Button.js` 现在是 100% 完全独立的，不管在何时引入和怎样的上下文中运行，它都能运用手上所有工具正确地调用和渲染。现在，我们只需要在页面中渲染我们的按钮就可以了（虽然这种写法很不优雅）。

**src/index.js**

```js
import Button from './Components/Button';

const button = new Button('google.com');

button.render('a');
```

现在运行 Webpack 然后刷新页面，你应该能看到页面中出现了一个丑丑的按钮了。

![](http://i.imgur.com/8Ov1x2P.png)

现在你学会了如何设置 loaders 以及如何定义 app 中每个部分的依赖关系。虽然现在看起来还没多大用途，但是我们将继续改进代码。

### 代码分离

上述的例子虽好，但是有时候我们不需要用到按钮，可能某些页面里不存在 `a` 标签让按钮放在那儿，在这种情况下，我们可不想引入所有的按钮样式、模板、Mustache 等各种东西，对吧？这时候代码分离就起作用了。代码分离，正是 Webpack 对于 “整个模块” 和 “不可维护的手动引入” 给出的答案。其思路就是可以在代码中定义“分离点”：这部分代码将被分离成一个独立的文件，按需加载。其语法非常简单：



    import $ from 'jquery';

    // 这里就是分离点
    require.ensure([], () => {
      // 把所有代码和需要引入的内容放在这里
      // 这里的代码最终会分离到一个独立的文件中
      const library = require('some-big-library');
      $('foo').click(() => library.doSomething());
    });



`require.ensure` 回调函数里面的所有内容，会被分离成一个_数据块（chunk）_ —— Webpack 只有在页面需要时，才会通过 AJAX 按需加载这部分内容。这意味着我们的代码结构变成了这样：


    bundle.js
    |- jquery.js
    |- index.js // 主文件
    chunk1.js
    |- some-big-libray.js
    |- index-chunk.js // Callback 里的代码



你不需要在任何地方引入或者加载 `chunk1.js` 文件，Webpack 会在页面真正需要这部分代码时按需加载。这意味着你可以把许多不同的代码逻辑包裹成不同的块，在我们的例子中，我们想要的是在页面包含 a 标签时才引入 Button 的代码：

**src/index.js**



    if (document.querySelectorAll('a').length) {
        require.ensure([], () => {
            const Button = require('./Components/Button').default;
            const button = new Button('google.com');

            button.render('a');
        });
    }



要注意的是，使用 `require` 时，如果你想要默认 export，你需要手动包裹在 `.default` 里，因为 `require` 不会同时处理默认 export 和其它的 export，你需要指定 return 哪些内容。然而 `import` 对此有一个系统，它可以处理得很好（比如 `import foo from 'bar'` 和 `import {baz} from 'bar'`）。

Webpack 的输出现在应该发生了相应的变化，我们可以在命令加上 `--display-chunks` 参数，看看哪些模块在哪个 chunk 里面：



    $ webpack --display-modules --display-chunks
    Hash: 43b51e6cec5eb6572608
    Version: webpack 1.12.14
    Time: 1185ms
          Asset     Size  Chunks             Chunk Names
      bundle.js  3.82 kB       0  [emitted]  main
    1.bundle.js   300 kB       1  [emitted]
    chunk    {0} bundle.js (main) 235 bytes [rendered]
        [0] ./src/index.js 235 bytes {0} [built]
    chunk    {1} 1.bundle.js 290 kB {0} [rendered]
        [1] ./src/Components/Button.js 1.94 kB {1} [built]
        [2] ./~/jquery/dist/jquery.js 259 kB {1} [built]
        [3] ./src/Components/Button.html 72 bytes {1} [built]
        [4] ./~/mustache/mustache.js 19.4 kB {1} [built]
        [5] ./src/Components/Button.scss 1.05 kB {1} [built]
        [6] ./~/css-loader!./~/sass-loader!./src/Components/Button.scss 212 bytes {1} [built]
        [7] ./~/css-loader/lib/css-base.js 1.51 kB {1} [built]
        [8] ./~/style-loader/addStyles.js 7.21 kB {1} [built]



正如你看到的那样，我们的入口点 (`bundle.js`) 现在只包含了 Webpack 本身的一些逻辑，其它内容 (jQuery, Mustache, Button) 放在了 `1.bundle.js` 块中，只会在页面包含 a 标签时才会引入。现在，为了让 Webpack 知道在哪里找到这个块，然后通过 AJAX 引入，我们需要在配置文件里多加一行：



    path:       'builds',
    filename:   'bundle.js',
    publicPath: 'builds/',



`output.publicPath` 选项告诉 Webpack 在哪里可以找到生成的静态资源，其路径相对于我们的视图页面（所以在我们的例子里是 /builds/）。如果我们打开页面，效果依然相同，但更重要的是，我们会看到页面包含 a 标签时，Webpack 才会加载我们的块。

![](http://i.imgur.com/rPvIRiB.png)

如果页面里没有 a 标签，只会加载 `bundle.js` 文件。这种做法允许你智能地分离出一些繁重的逻辑，让它们在页面真正需要时，才按需加载进来。值得注意的是，我们可以给分离点起个名字，替换原来的 `1.bundle.js` ，使得块名更加有意义。你可以通过给 `require.ensure` 传递第三个参数来做到这点：



    require.ensure([], () => {
        const Button = require('./Components/Button').default;
        const button = new Button('google.com');

        button.render('a');
    }, 'button');



这样生成的文件名将会是 `button.bundle.js` 而非 `1.bundle.js`。

### 添加第二个组件

现在一切都不错，我们试着添加第二个组件：

**src/Components/Header.scss**



    .header {
      font-size: 3rem;
    }



**src/Components/Header.html**



     class="header">{{text}}



**src/Components/Header.js**



    import $ from 'jquery';
    import Mustache from 'mustache';
    import template from './Header.html';
    import './Header.scss';

    export default class Header {
        render(node) {
            const text = $(node).text();

            $(node).html(
                Mustache.render(template, {text})
            );
        }
    }



然后在应用里渲染它:



    // 如果有 a 标签，渲染按钮
    if (document.querySelectorAll('a').length) {
        require.ensure([], () => {
            const Button = require('./Components/Button');
            const button = new Button('google.com');

            button.render('a');
        });
    }

    // 如果有 h1 标签，渲染页眉
    if (document.querySelectorAll('h1').length) {
        require.ensure([], () => {
            const Header = require('./Components/Header');

            new Header().render('h1');
        });
    }



现在，使用 `--display-chunks --display-modules` 参数调用 Webpack：



    $ webpack --display-modules --display-chunks
    Hash: 178b46d1d1570ff8bceb
    Version: webpack 1.12.14
    Time: 1548ms
          Asset     Size  Chunks             Chunk Names
      bundle.js  4.16 kB       0  [emitted]  main
    1.bundle.js   300 kB       1  [emitted]
    2.bundle.js   299 kB       2  [emitted]
    chunk    {0} bundle.js (main) 550 bytes [rendered]
        [0] ./src/index.js 550 bytes {0} [built]
    chunk    {1} 1.bundle.js 290 kB {0} [rendered]
        [1] ./src/Components/Button.js 1.94 kB {1} [built]
        [2] ./~/jquery/dist/jquery.js 259 kB {1} {2} [built]
        [3] ./src/Components/Button.html 72 bytes {1} [built]
        [4] ./~/mustache/mustache.js 19.4 kB {1} {2} [built]
        [5] ./src/Components/Button.scss 1.05 kB {1} [built]
        [6] ./~/css-loader!./~/sass-loader!./src/Components/Button.scss 212 bytes {1} [built]
        [7] ./~/css-loader/lib/css-base.js 1.51 kB {1} {2} [built]
        [8] ./~/style-loader/addStyles.js 7.21 kB {1} {2} [built]
    chunk    {2} 2.bundle.js 290 kB {0} [rendered]
        [2] ./~/jquery/dist/jquery.js 259 kB {1} {2} [built]
        [4] ./~/mustache/mustache.js 19.4 kB {1} {2} [built]
        [7] ./~/css-loader/lib/css-base.js 1.51 kB {1} {2} [built]
        [8] ./~/style-loader/addStyles.js 7.21 kB {1} {2} [built]
        [9] ./src/Components/Header.js 1.62 kB {2} [built]
       [10] ./src/Components/Header.html 64 bytes {2} [built]
       [11] ./src/Components/Header.scss 1.05 kB {2} [built]
       [12] ./~/css-loader!./~/sass-loader!./src/Components/Header.scss 192 bytes {2} [built]



你可能会发现一个相当重要的问题：我们的组件都依赖 jQuery 和 Mustache，这意味着这些依赖在我们的子块中重复出现了，这样的结果并不是我们想要的。默认情况下，Webpack 只会执行很少优化，但是它包含了强大的工具帮你改变这一状况，它就是_插件_。


插件和 loader 的区别在于，插件作用在所有文件，执行更多高级操作，但这些操作不一定和转换相关；而 loader 只是作用在特定集合的文件，以及作为“管道”的一部分。Webpack 提供了一系列插件进行各种不同的优化，在这个例子中，**CommonChunksPlugin** 可以解决这个问题：它可以分析子块中的共同依赖，并提取出来放到其它地方，可以放在一个完全独立的文件（比如 `vendor.js`），或者在你的主文件中。

在我们的例子里，我们打算把共同依赖放在主入口文件，因为如果所有页面都需要 jQuery 和 Mustache，我们可以把它们合起来。所以，现在我们更改一下配置文件：



    var webpack = require('webpack');

    module.exports = {
        entry:   './src',
        output:  {
          // ...
        },
        plugins: [
            new webpack.optimize.CommonsChunkPlugin({
                name:      'main', // 把依赖移动到主文件
                children:  true, // 寻找所有子模块的共同依赖
                minChunks: 2, // 设置一个依赖被引用超过多少次就提取出来
            }),
        ],
        module:  {
          // ...
        }
    };



如果我们再次运行 Webpack，可以看到情况已经发生了变化，这里 `main` 是默认的块的名字。



    chunk    {0} bundle.js (main) 287 kB [rendered]
        [0] ./src/index.js 550 bytes {0} [built]
        [2] ./~/jquery/dist/jquery.js 259 kB {0} [built]
        [4] ./~/mustache/mustache.js 19.4 kB {0} [built]
        [7] ./~/css-loader/lib/css-base.js 1.51 kB {0} [built]
        [8] ./~/style-loader/addStyles.js 7.21 kB {0} [built]
    chunk    {1} 1.bundle.js 3.28 kB {0} [rendered]
        [1] ./src/Components/Button.js 1.94 kB {1} [built]
        [3] ./src/Components/Button.html 72 bytes {1} [built]
        [5] ./src/Components/Button.scss 1.05 kB {1} [built]
        [6] ./~/css-loader!./~/sass-loader!./src/Components/Button.scss 212 bytes {1} [built]
    chunk    {2} 2.bundle.js 2.92 kB {0} [rendered]
        [9] ./src/Components/Header.js 1.62 kB {2} [built]
       [10] ./src/Components/Header.html 64 bytes {2} [built]
       [11] ./src/Components/Header.scss 1.05 kB {2} [built]
       [12] ./~/css-loader!./~/sass-loader!./src/Components/Header.scss 192 bytes {2} [built]



如果我们特别指定 `name: 'vendor'`:



    new webpack.optimize.CommonsChunkPlugin({
        name:      'vendor',
        children:  true,
        minChunks: 2,
    }),



由于数据块还不存在，Webpack 会创建一个 `builds/vendor.js` 文件，我们需要在 HTML 中手动引入。


```HTML
<script src="builds/vendor.js"></script>
<script src="builds/bundle.js"></script>
```


你也可以不指定块名称并加上  `async: true`，让共同的依赖异步加载。Webpack 还有很多这类型的强大智能优化的插件。我不可能把他们一一列举出来，但是作为练习，我们再来试试创建一个 _生产环境_ 版本的配置。

### 生产环境和更多

Ok，首先我们要添加几个插件到配置文件里，但是仅当 `NODE_ENV` 的值是 `production` 的时候，才会加载它们，我们要在配置文件里添加一些逻辑，由于配置文件是 JS 语法，所以很简单：



    var webpack    = require('webpack');
    var production = process.env.NODE_ENV === 'production';

    var plugins = [
        new webpack.optimize.CommonsChunkPlugin({
            name:      'main', // 把依赖移动到主文件
            children:  true, // 寻找所有子模块的共同依赖
            minChunks: 2, // 设置一个依赖被引用超过多少次就提取出来
        }),
    ];

    if (production) {
        plugins = plugins.concat([
           // Production plugins go here
        ]);
    }

    module.exports = {
        entry:   './src',
        output:  {
            path:       'builds',
            filename:   'bundle.js',
            publicPath: 'builds/',
        },
        plugins: plugins,
        // ...
    };



其次，Webpack 还有一些相关设置，我们要在生产环境里关闭掉：



    module.exports = {
        debug:   !production,
        devtool: production ? false : 'eval',



第一个设置是关于 loader 的调试模式，如果关闭，意味着方便本地调试的那部分代码不会包含到代码中。第二个设置是关于 sourcemap 的生成，Webpack 有 [几种方法](http://webpack.github.io/docs/configuration.html#devtool) 生成 [sourcemaps](http://www.html5rocks.com/en/tutorials/developertools/sourcemaps/)，`eval` 在本地环境下是最佳选择。在生产环境中，我们不需要用到 sourcemap 所以可以把选项关掉。现在，添加我们的生产环境插件：



    if (production) {
        plugins = plugins.concat([

            // 这个插件搜索相似的块与文件并合并它们
            new webpack.optimize.DedupePlugin(),

            // 这个插件通过计算子块和模块的使用次数进行优化
            new webpack.optimize.OccurenceOrderPlugin(),

            // 这个插件在子块文件太小时，会阻止生成，因为不值得独立加载
            new webpack.optimize.MinChunkSizePlugin({
                minChunkSize: 51200, // ~50kb
            }),

            // 这个插件对最终生成的 JS 代码进行 Uglify
            new webpack.optimize.UglifyJsPlugin({
                mangle:   true,
                compress: {
                    warnings: false, // Suppress uglification warnings
                },
            }),

            // 这个插件定义了不同变量，我们可以在生成环境关闭一些变量
            // 避免调试代码被编译到我们最终的包里
            new webpack.DefinePlugin({
                __SERVER__:      !production,
                __DEVELOPMENT__: !production,
                __DEVTOOLS__:    !production,
                'process.env':   {
                    BABEL_ENV: JSON.stringify(process.env.NODE_ENV),
                },
            }),

        ]);
    }



以上是我最常使用的插件，不过 Webpack 还提供了很多其它插件，供你协调你的模块和数据块。此外，还有一部分用户贡献的插件，可以在 NPM 上找到，供你完成更多的事情。一些插件的链接可以在本文末尾找到。

现在还有另一个问题，理想情况下，我们想要静态资源带上版本号。还记得我们设置 `output.filename` 为 `bundle.js` 吗？事实上有一些选项可以用在变量里，其中一个是 `[hash]`，对应着最终打包生成的文件内容的哈希值，我们改变一下这个设置。此外，我们还想要 `output.chunkFilename` 也带上版本号：



    output: {
        path:          'builds',
        filename:      production ? '[name]-[hash].js' : 'bundle.js',
        chunkFilename: '[name]-[chunkhash].js',
        publicPath:    'builds/',
    },



在这个简单的应用里，我们不想要动态取得编译出来的包名字，我们只会在生产环境里打上版本号，比如，我们可能想要在打包生产环境代码前，清理 builds 文件夹，这时候我们要安装一个第三方插件来完成这个事情：



    $ npm install clean-webpack-plugin --save-dev



然后添加到配置文件中：



    var webpack     = require('webpack');
    var CleanPlugin = require('clean-webpack-plugin');

    // ...

    if (production) {
        plugins = plugins.concat([

            // 在编译最终的静态资源之前，清理 builds/ 文件夹
            new CleanPlugin('builds'),



现在我们完成了很棒的优化了，对比看看结果：



    $ webpack
                    bundle.js   314 kB       0  [emitted]  main
    1-21660ec268fe9de7776c.js  4.46 kB       1  [emitted]
    2-fcc95abf34773e79afda.js  4.15 kB       2  [emitted]





    $ NODE_ENV=production webpack
    main-937cc23ccbf192c9edd6.js  97.2 kB       0  [emitted]  main



Webpack 完成了这些事情：首先，由于我们的例子非常轻量级，我们的两个异步子块不值得额外 HTTP 请求，因此 Webpack 把它们和入口模块合在一起了。其次，所有内容都被压缩了，我们从三个 HTTP 请求，共 322kb，缩减到一个 HTTP 请求，仅 97kb。

> 但是 Webpack 生成了一个庞大的 JS 文件呀？

确实如此，不过这是由于我们的 app 非常小。试想：之前你不需要过多考虑合并什么、何时在哪合并。但是如果你的子块突然要依赖更多东西，子块或许会变为异步加载而不会被合并，如果这些子块的内容相似，不值得异步加载，那还不如合并起来。用上 Webpack，你只需要设置规则，从那以后，Webpack 会自动帮助你优化应用，不需要手工劳动，也不需要考虑依赖放在哪，所有事情都变成了自动完成。

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i100zj8gg206x04kaim.gif)

你可能注意到，我没有设置压缩 HTML 和 CSS，因为 `css-loader` 和 `html-loader` 在 `debug` 为 `false` 时，默认会完成这个工作，这也是 Uglify 单独拿出来做插件的原因：Webpack 并没有  `js-loader`，因为 Webpack 本身就是处理 JS 的。

### 提取

现在你可能会注意到，从一开始我们的样式就被动态地注入到页面里，导致页面加载完成前，样式会闪烁(Flash of Ugly Ass Page, FOUAP)。如果我们能把所有样式也打包成一个单独的 CSS 文件，不就更好吗？我们引入一个额外的插件来做这件事情：



    $ npm install extract-text-webpack-plugin --save-dev



这个插件的作用正如我刚才所说的，从最终的文件包里拿出某些内容，导出的别的地方，最常见的用例就是 CSS，修改一下配置：



    var webpack    = require('webpack');
    var CleanPlugin = require('clean-webpack-plugin');
    var ExtractPlugin = require('extract-text-webpack-plugin');
    var production = process.env.NODE_ENV === 'production';

    var plugins = [
        new ExtractPlugin('bundle.css'), //
        new webpack.optimize.CommonsChunkPlugin({
            name:      'main', // 把依赖移动到主文件
            children:  true, // 寻找所有子模块的共同依赖
            minChunks: 2, // 设置一个依赖被引用超过多少次就提取出来
        }),
    ];

    // ...

    module.exports = {
        // ...
        plugins: plugins,
        module:  {
            loaders: [
                {
                    test:   /\.scss/,
                    loader: ExtractPlugin.extract('style', 'css!sass'),
                },
                // ...
            ],
        }
    };



现在 `extract` 方法接收两个参数：第一个我们在子块里 (`'style'`) 对提取出的内容做什么；第二个是在主文件 (`'css!sass'`) 里面对内容做什么。现在如果我们在子块里，我们不能像以前那样直接添加 CSS，需要使用 `style` loader，但对于所有主文件里的 CSS，导出到 `builds/bundle.css` 文件。让我们来试一试，在应用里添加一点主样式：


**src/styles.scss**



    body {
      font-family: sans-serif;
      background: darken(white, 0.2);
    }



**src/index.js**



    import './styles.scss';

    // 文件的剩余部分



运行 Wepback，并确保在 HTML 里引入了 `bundle.css` 文件：


    $ webpack
                    bundle.js    318 kB       0  [emitted]  main
    1-a110b2d7814eb963b0b5.js   4.43 kB       1  [emitted]
    2-03eb25b4d6b52a50eb89.js    4.1 kB       2  [emitted]
                   bundle.css  59 bytes       0  [emitted]  main



如果你还想提取子块的样式，你可以传递 `ExtractTextPlugin('bundle.css', {allChunks: true})` 选项。注意你也可以在文件名使用变量，如果你想要样式表带上版本号，和 JS 文件一样，使用 `ExtractTextPlugin('[name]-[hash].css')` 选项。

### 带上图片

现在我们能很好地处理 JS 文件了，但是我们还没涉及到具体的静态资源：图片、字体等。Webpack 是如果在上下文中处理这些资源，我们又可以做什么优化呢？让我们在网上拿一张图片，用作背景图。我在 [Geocities](https://www.google.com/search?q=Geocities&tbm=isch) 看见别人这么做了，看着挺酷：

![](http://ww1.sinaimg.cn/large/a490147fgw1f4i0mf8uwuj203k03kq2r.jpg)

把图片保存为 `img/puppy.jpg`，并对应更新 Sass 文件：

**src/styles.scss**



    body {
        font-family: sans-serif;
        background: darken(white, 0.2);
        background-image: url('../img/puppy.jpg');
        background-size: cover;
    }



现在如果你这么做，Webpack 会义正言辞地告诉你：“我压根不知道怎么处理 JPG 文件啊！”，因为没有合适的 loader 来处理它。我们有两个选择来处理这些资源： `file-loader` 和 `url-loader`：第一个会给静态资源返回一个 URL，不作其它更改，并允许你给文件加上版本号（这也是默认行为）；第二个会把资源转化成 `data:image/jpeg;base64` 格式。

实际上没有绝对的对与错：如果背景是 2Mb 大小的图片，你可能不会把它内联，分开加载比较合理；如果是 2kb 的小图标文件，最好转为 base64 以节省 HTTP 请求，所以我们两个一起用：



    $ npm install url-loader file-loader --save-dev





    {
        test:   /\.(png|gif|jpe?g|svg)$/i,
        loader: 'url?limit=10000',
    },



这里，我们传递了一个 `limit` 参数给 `url-loader` ，告诉 Webpack：如果文件小于 10kb 则内联，否则 fallback 给 `file-loader` 作处理。这种语法称为查询字符串，你可以用来配置 loader，或者你也可以通过写一个对象来配置：



    {
        test:   /\.(png|gif|jpe?g|svg)$/i,
        loader: 'url',
        query: {
          limit: 10000,
        }
    }



现在看看效果：



                    bundle.js   15 kB       0  [emitted]  main
    1-b8256867498f4be01fd7.js  317 kB       1  [emitted]
    2-e1bc215a6b91d55a09aa.js  317 kB       2  [emitted]
                   bundle.css  2.9 kB       0  [emitted]  main



我们可以看到，没有提及到 JPG 文件，因为我们的小狗图片比配置的大小要小，所以被内联了。这意味着如果我们打开页面，我们就可以看到小狗图片了。

![](http://ww3.sinaimg.cn/large/a490147fgw1f4i0nf5qr1j20gz0n30w3.jpg)

现在我们的 Webpack 已经很强大了，因为它可以智能地优化任何具体资源，以减少 HTTP 请求的频率和流量。使用 [image-loader](https://github.com/tcoopman/image-webpack-loader) 你还可以做更多优化工作，比如构建时传递 `imagemin` 参数，它甚至还有 `?bypassOnDebug` 查询字符串，允许你在生产环境才那么做。事实上还有很多类似插件，我鼓励你看完这篇文章后，再翻一翻文件结尾的列表。

### 实时更新

现在我们兼顾到了生产环境，把目光放回到开发环境。当提及到构建工具时，总有一个大坑需要填：实时刷新。LiveReload, BrowserSync 等，不管你喜欢用什么，等待整个页面重新刷新总是非常烦人，更好的做法是 _模块热替换（HMR，hot module replacement）_ 或者 _热刷新_。我们的想法是，由于 Webpack 清晰知道每个模块在依赖树的位置，发生更改时，只需要更换发生变化的那部分就好了。更清晰的想法是：你的更改实时反应在屏幕上，不需要刷新页面。


为了用上 HMR，我们需要一个 server 来处理资源热替换。Webpack 提供了 `dev-server` 解决这个问题，我们可以安装它：



    $ npm install webpack-dev-server --save-dev



现在运行 dev server，非常简单，只需一条命令：



    $ webpack-dev-server --inline --hot



第一个参数告诉 Webpack，把 HMR 逻辑内联到页面（而不是在 iframe 中呈现页面），第二个参数是启用 HMR。现在打开服务器地址 `http://localhost:8080/webpack-dev-server/`，再试试修改 Sass 文件，见证奇迹的时刻：

![](http://ww2.sinaimg.cn/large/a490147fgw1f4i10s9casg20i006w48b.gif)

现在你可以把 webpack-dev-server 当作本地服务器了，如果你打算一直使用 HMR，你可以在配置文件里作修改：



    output: {
        path:          'builds',
        filename:      production ? '[name]-[hash].js' : 'bundle.js',
        chunkFilename: '[name]-[chunkhash].js',
        publicPath:    'builds/',
    },
    devServer: {
        hot: true,
    },



现在无论何时运行 `webpack-dev-server` 它总是在 HMR 模式中。注意我们在这里只是使用 `webpack-dev-server` 来处理热加载，但是你还可以用一些其它选项，用法就像 Express 的服务器那样。Webpack 还提供了一个中间件，使得你可以添加 HMR 功能给其它服务器。

### 添加语法检查

如果你一直紧跟教程，你可能留意到一个奇怪的问题：为什么 loaders 是嵌套在 `module.loaders` 而插件不是呢？因为你还可以在 `module` 放入其他东西。Webpack 除了 loaders，还有 pre-loaders 和 post-loaders，也就是在主 loaders 前后执行的内容。比如：这篇文章里的代码量很大，我们在转换前，需要借助 ESLint 来检测代码：



    $ npm install eslint eslint-loader babel-eslint --save-dev



先创建一个 `.eslintrc` 文件，定义一个肯定不能通过的规则：

**.eslintrc**



    parser: 'babel-eslint'
    rules:
      quotes: 2



现在添加 pre-loader，和前面的语法一样，但是放在 `module.preLoaders` 中：



    module:  {
        preLoaders: [
            {
                test: /\.js/,
                loader: 'eslint',
            }
        ],



现在运行 Webpack，果然构建失败了：



    $ webpack
    Hash: 33cc307122f0a9608812
    Version: webpack 1.12.2
    Time: 1307ms
                        Asset      Size  Chunks             Chunk Names
                    bundle.js    305 kB       0  [emitted]  main
    1-551ae2634fda70fd8502.js    4.5 kB       1  [emitted]
    2-999713ac2cd9c7cf079b.js   4.17 kB       2  [emitted]
                   bundle.css  59 bytes       0  [emitted]  main
        + 15 hidden modules

    ERROR in ./src/index.js

    /Users/anahkiasen/Sites/webpack/src/index.js
       1:8   error  Strings must use doublequote  quotes
       4:31  error  Strings must use doublequote  quotes
       6:32  error  Strings must use doublequote  quotes
       7:35  error  Strings must use doublequote  quotes
       9:23  error  Strings must use doublequote  quotes
      14:31  error  Strings must use doublequote  quotes
      16:32  error  Strings must use doublequote  quotes
      18:29  error  Strings must use doublequote  quotes



再举一个 pre-loader 的例子：对于每个组件，我们都输入和组件名字相同的样式表以及模板，使用一个 pre-loader 可以自动地帮我完成这个工作：



    $ npm install baggage-loader --save-dev





    {
        test: /\.js/,
        loader: 'baggage?[file].html=template&[file].scss',
    }



这个配置告诉 Webpack：如果遇到一个同名的 HTML 文件和 Sass 文件，作为模板和样式引入进来，现在可以把组件代码从：



    import $ from 'jquery';
    import template from './Button.html';
    import Mustache from 'mustache';
    import './Button.scss';



改为：



    import $ from 'jquery';
    import Mustache from 'mustache';



正如你看到的那样，pre-loaders 非常强大，而 post-loaders 也一样。在文章最后的列表中搜索一下，相信你会找到许多 post-loaders 的适用场景。

### 还想知道更多？

现在我们的应用还很轻量，但是一旦应用变得更加复杂，我们可能需要观察依赖树的情况，以便分析有什么做得好的和不合理的，以及应用的瓶颈等。Webpack 内部对此很了解，因此我们可以向 Webpack 了解更多，通过以下命令生成一个 _描述文件（profile file）_ ：



    webpack --profile --json > stats.json



第一个参数告诉 Webpack 生成配置文件，第二个参数是生成 JSON 格式，最终把所有内容输出到一个 JSON 文件中。现在有多个网站可以解析 profile 文件，Webpack 也有官方网站来分析信息。打开 [Webpack Analyze](http://webpack.github.io/analyse/) 并上传你的 JSON 文件，在 **Modules** 标签页，你可以看到依赖树的可视化结果：

![](http://ww2.sinaimg.cn/large/a490147fjw1f4i0piefhaj20or0kvmyk.jpg)

点的颜色越红，说明问题越大。这里把 jQuery 标红，因为它是我们所有模块中最重的。顺便看看其它标签页，你可能不会在我们的小应用里看到什么有价值的信息，但是这个工具对于了解依赖树和最终的包内容是非常重要的。现在正如我说的那样，其它网站服务也提供类似功能，比如我喜欢的是 [Webpack Visualizer](http://chrisbateman.github.io/webpack-visualizer/)，提供了环形图来显示你的包里面什么东西最占空间，在我们的例子里当然是 jQuery 了：

![](http://ww4.sinaimg.cn/large/a490147fjw1f4i0pxgo3bj20lo0knmzm.jpg)

## 总结

在我的案例里面，Webpack 完全替代了 Grunt / Gulp：它们的大部分功能被 Webpack 取代，剩下的部分我只需要用 NPM scripts 来处理。比如我们想要使用 Aglio，把 API 文档转换为 HTML，只需要这么写：

**package.json**



    {"scripts":{"build":"webpack","build:api":"aglio -i docs/api/index.apib -o docs/api/index.html"}}



但是，如果你在 Gulp 里面调用了更加复杂的任务，和打包或者静态资源无关，Webpack 对于其他构建系统也兼容，比如下面这个例子把 Gulp 整合到 Webpack 里：



    var gulp = require('gulp');
    var gutil = require('gutil');
    var webpack = require('webpack');
    var config = require('./webpack.config');

    gulp.task('default', function(callback) {
      webpack(config, function(error, stats) {
        if (error) throw new gutil.PluginError('webpack', error);
        gutil.log('[webpack]', stats.toString());

        callback();
      });
    });



就这么简单，由于 Webpack 还有 Node API，所以可以用在其它构建系统中，无论是哪种情况，你都可以找到一种包裹方式挂载它。

总而言之，我认为这篇文章可以帮你概览 Webpack 能帮你做什么事情。你可能会觉得我在本文里提及了很多内容，但是我们还只是讲了一点皮毛：多入口点、预加载、上下文替换等还没提及呢。Webpack 很好很强大，所以比起其它构建工具的配置显得成本更高，但是我并不会因此而拒绝它。一旦你领悟了它，会给你带来很多好处。我在好几个项目里用上了 Webpack，它提供了强大的优化能力和自动处理能力，老实说我已经不能想象怎么回到那个手动解决静态资源问题的时代了。

## 相关资源

*   [Webpack 官方文档](https://webpack.github.io/)
*   [Loaders 列表](http://webpack.github.io/docs/list-of-loaders.html)
*   [Plugins 列表](http://webpack.github.io/docs/list-of-plugins.html)
*   [本文的源代码](https://github.com/madewithlove/webpack-article/commits/master)
*   [本文的 Webpack 配置文件](https://github.com/madewithlove/webpack-config)

