> * 原文链接: [Server-side Web Components: How and Why?](https://scotch.io/tutorials/server-side-web-components-how-and-why)
* 原文作者: [Jordan Last](https://pub.scotch.io/@lastmjs)
* 译文出自: [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者: [达仔](https://github.com/zhangjd)
* 校对者: [Shangbin Yang](https://github.com/rccoder), [Gran](https://github.com/Graning)

# 为什么我们要用网页端组件去构建服务器？该怎么做

Web components（网页组件）用在服务器端渲染早已被大家所了解，在本文中，我想谈及的是：你还可以用 web components 构建服务器端应用。

先来回顾一下，web components 是一组 [新提出的标准](https://github.com/w3c/webcomponents)，提供了模块化打包 UI 组件的能力，这些组件具有可重用、声明式的特点，因此具有方便分享、容易组合到应用的优势。现在 web components 已经开始应用到前端开发当中了，但服务器端呢？[Polymer 项目](https://elements.polymer-project.org) 给了我们启发，web components 不仅对于 UI 组件很有用，而且还可以用在原始功能中。接下来我们会看看 web components 如何应用到服务器端，并分析其优势。

* 声明式
* 模块化
* 通用化
* 可共享
* 可调试
* 更平缓的学习曲线
* 客户端结构

## 声明式

首先，web components 让你得到了声明式的服务器。以下是一个使用 [Express Web Components](https://github.com/scramjs/express-web-components) 编写 Express.js 应用程序的简单示例：

```
<link rel="import" href="bower_components/polymer/polymer.html">
<link rel="import" href="bower_components/express-web-components/express-app.html">
<link rel="import" href="bower_components/express-web-components/express-middleware.html">
<link rel="import" href="bower_components/express-web-components/express-router.html">

<dom-module id="example-app">
    <template>
        <express-app port="5000">
            <express-middleware method="get" path="/" callback="[[indexHandler]]"></express-middleware>
            <express-middleware callback="[[notFound]]"></express-middleware>
        </express-app>
    </template>

    <script>
        class ExampleAppComponent {
            beforeRegister() {
                this.is = 'example-app';
            }

            ready() {
                this.indexHandler = (req, res) => {
                    res.send('Hello World!');
                };

                this.notFound = (req, res) => {
                    res.status(404);
                    res.send('not found');
                };
            }
        }

        Polymer(ExampleAppComponent);
    </script>
</dom-module>
```

现在你可以使用 HTML 语法来声明路由了。比起纯 JavaScript 语法，现在的路由可以体现出视觉层次感，看起来更加形象和易于理解。拿上面的例子来说，所有和 Express 框架有关的 endpoints(路由) / middleware(中间件) 都嵌套在 `<express-app>` 元素，连接 app 的中间件按顺序放在 `<express-middleware>` 元素中。而路由也可以很容易地嵌套，`<express-router>` 中包含的每个中间件都会连接到 router，你还可以把 `<express-route>` 放在 `<express-router>` 元素中。

## 模块化

使用 Express 和 Node.js 已经让我们实现了模块化，但我觉得模块化 web components 更加简单。以下 [这个例子](https://github.com/scramjs/node-api) 把模块化的自定义元素和 Express Web Components 结合起来使用：

```
<!--index.html-->

<!DOCTYPE html>

<html>
    <head>
        <script src="../../node_modules/scram-engine/filesystem-config.js"></script>
        <link rel="import" href="components/app/app.component.html">
    </head>

    <body>
        <na-app></na-app>
    </body>

</html>
```

`index.html` 是入口文件，实际上我们需要关心的地方只有一个，就是 `<na-app></na-app>` ：

```
<!--components/app/app.component.html-->

<link rel="import" href="../../../../bower_components/polymer/polymer.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-app.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-middleware.html">
<link rel="import" href="../api/api.component.html">

<dom-module id="na-app">
    <template>
        <express-app port="[[port]]" callback="[[appListen]]">
            <express-middleware callback="[[morganMW]]"></express-middleware>
            <express-middleware callback="[[bodyParserURLMW]]"></express-middleware>
            <express-middleware callback="[[bodyParserJSONMW]]"></express-middleware>
            <na-api></na-api>
        </express-app>
    </template>

    <script>
        class AppComponent {
            beforeRegister() {
                this.is = 'na-app';
            }

            ready() {
                const bodyParser = require('body-parser');
                const morgan = require('morgan');

                this.morganMW = morgan('dev'); // 把请求记录在控制台

                // 配置 body parser
                this.bodyParserURLMW = bodyParser.urlencoded({ extended: true });
                this.bodyParserJSONMW = bodyParser.json();

                this.port = process.env.PORT || 8080; // 设置端口

                const mongoose = require('mongoose');
                mongoose.connect('mongodb://@localhost:27017/test'); // 连接数据库

                this.appListen = () => {
                    console.log(`Magic happens on port ${this.port}`);
                };
            }
        }

        Polymer(AppComponent);
    </script>
</dom-module>
```

我们启动 Express 应用，监听 port `8080` 或者 `process.env.PORT` 端口，然后定义了三个中间件和一个自定义元素。希望你直觉上就能理解那三个中间件会在`<na-api></na-api>` 之前运行的工作原理：

```
<!--components/api/api.component.html-->

<link rel="import" href="../../../../bower_components/polymer/polymer.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-middleware.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-router.html">
<link rel="import" href="../bears/bears.component.html">
<link rel="import" href="../bears-id/bears-id.component.html">

<dom-module id="na-api">
    <template>
        <express-router path="/api">
            <express-middleware callback="[[allMW]]"></express-middleware>
            <express-middleware method="get" path="/" callback="[[indexHandler]]"></express-middleware>
            <na-bears></na-bears>
            <na-bears-id></na-bears-id>
        </express-router>
    </template>

    <script>
        class APIComponent {
            beforeRegister() {
                this.is = 'na-api';
            }

            ready() {
                // 这个中间件应用在 /api 前缀开头的所有请求
                this.allMW = (req, res, next) => {
                    // 输出日志
                    console.log('Something is happening.');
                    next();
                };

                // 测试路由，目的是确保功能正常 (通过 GET http://localhost:8080/api 访问)
                this.indexHandler = (req, res) => {
                    res.json({ message: 'hooray! welcome to our api!' });
                };
            }
        }

        Polymer(APIComponent);
    </script>
</dom-module>
```

所有 `<na-api></na-api>` 的内容都包裹在 `<express-router></express-router>` 当中。组件里的所有中间件都在访问 `/api` 时生效。接下来再看看 `<na-bears></na-bears>` 和 `<na-bears-id></na-bears-id>`：

```
<!--components/bears/bears.component.html-->

<link rel="import" href="../../../../bower_components/polymer/polymer.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-middleware.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-route.html">

<dom-module id="na-bears">
    <template>
        <express-route path="/bears">
            <express-middleware method="post" callback="[[createHandler]]"></express-middleware>
            <express-middleware method="get" callback="[[getAllHandler]]"></express-middleware>
        </express-route>
    </template>

    <script>
        class BearsComponent {
            beforeRegister() {
                this.is = 'na-bears';
            }

            ready() {
                var Bear = require('./models/bear');

                // 创建一只熊 (调用 POST http://localhost:8080/bears)
                this.createHandler = (req, res) => {
                    var bear = new Bear();      // create a new instance of the Bear model
                    bear.name = req.body.name;  // set the bears name (comes from the request)

                    bear.save(function(err) {
                        if (err)
                            res.send(err);
                        res.json({ message: 'Bear created!' });
                    });
                };

                // 获取所有熊 (调用 GET http://localhost:8080/api/bears)
                this.getAllHandler = (req, res) => {
                    Bear.find(function(err, bears) {
                        if (err)
                            res.send(err);
                        res.json(bears);
                    });
                };
            }
        }

        Polymer(BearsComponent);
    </script>
</dom-module>
```

```
<!--components/bears-id/bears-id.component.html-->

<link rel="import" href="../../../../bower_components/polymer/polymer.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-middleware.html">
<link rel="import" href="../../../../bower_components/express-web-components/express-route.html">

<dom-module id="na-bears-id">
    <template>
        <express-route path="/bears/:bear_id">
            <express-middleware method="get" callback="[[getHandler]]"></express-middleware>
            <express-middleware method="put" callback="[[updateHandler]]"></express-middleware>
            <express-middleware method="delete" callback="[[deleteHandler]]"></express-middleware>
        </express-route>
    </template>

    <script>
        class BearsIdComponent {
            beforeRegister() {
                this.is = 'na-bears-id';
            }

            ready() {
                var Bear = require('./models/bear');

                // 根据 id 获取某只熊
                this.getHandler = (req, res) => {
                    console.log(req.params);
                    Bear.findById(req.params.bear_id, function(err, bear) {
                        if (err)
                            res.send(err);
                        res.json(bear);
                    });
                };

                // 根据 id 修改某只熊
                this.updateHandler = (req, res) => {
                    Bear.findById(req.params.bear_id, function(err, bear) {
                        if (err)
                            res.send(err);
                        bear.name = req.body.name;
                        bear.save(function(err) {
                            if (err)
                                res.send(err);
                            res.json({ message: 'Bear updated!' });
                        });
                    });
                };

                // 根据 id 删除某只熊
                this.deleteHandler = (req, res) => {
                    Bear.remove({
                        _id: req.params.bear_id
                    }, function(err, bear) {
                        if (err)
                            res.send(err);
                        res.json({ message: 'Successfully deleted' });
                    });
                };
            }
        }

        Polymer(BearsIdComponent);
    </script>
</dom-module>
```

如你所见，所有路由都被分离到各自的组件中，并且要包含在 app 中也很容易。在 `index.html` 文件中的 import 引入方法非常浅显易懂，

## 通用性

我喜欢 JavaScript 的原因之一，就是可以在客户端和服务器端共享代码。虽然现在某种程度上可以说这是可行的，但实际上，由于某些 API 的缺失，依然有一部分客户端的库不能在服务器端工作，反之亦然。从根本上说，Node.js 和浏览器依然是提供不同 API 的两套环境。那有什么办法可以结合呢？我们想到了 Electron，Electron 把 Node.js 和 Chromium 项目结合成为一个单独的运行环境，使得客户端代码和服务端代码结合运行成为了可能。

> [Scram.js](https://github.com/scramjs/scram-engine) 这个小项目可以帮你轻松运行 Electron，使得运行服务端 web components 和其它 Node.js 应用一样容易。

我已经做出了一些小应用，并放上了生产环境。如果你感兴趣，可以看看 [Dokku Example](http://scramjs.org) 。

现在，我来告诉你在开发服务端 Web components 过程中一件有意思的事情。我使用一个 [客户端的 JavaScript 库](https://github.com/adlnet/xAPIWrapper) 进行某些特定的 API 请求。然而，假如请求放在客户端，就必须把我们数据库的凭证泄露给客户端。为了保证凭证安全，我们需要把请求放在服务端进行。假如要在 Node.js 运行这个库，需要对代码进行大幅重构，幸亏我们用上了 Electron 和 Scram.js，我只需要导入这个库，无需任何代码改动，就顺利在服务端运行起来了！

> 我只需要导入这个库，无需任何代码改动，就顺利在服务端运行起来了！

另外，我曾经使用 JavaScript 构建一些移动端应用。我们使用 [localForage](https://github.com/mozilla/localForage) 作为客户端数据库。这个应用是基于分布式数据库设计的，可以在没有中心服务器的情况下进行互相通信。我希望可以在 Node.js 环境下使用 localForage，使得模型可以重用，以及不需要太多修改就能把功能跑起来。过去我们不能做到这点，但现在我们可以做到了。

> Electron 和 Scram.js 提供了 LocalStorage, Web SQL 和 IndexedDB，使得 localForage 成为了可能。我们就这样搭建起了一个简单的服务器端数据库！

虽然我不确定怎样测量其性能，但至少这个方法是可行的。

而且，现在你可以在服务端使用像 [iron-ajax](https://elements.polymer-project.org/elements/iron-ajax) 和我的 [redux-store-element](https://github.com/lastmjs/redux-store-element) 组件了，使用方法和客户端一样。我希望这么做可以让客户端的范式可重用，并减少从客户端到服务端之间因环境切换而产生的不可避免的差异性。

## 可共享

这点完全得益于 web components，因为 web components 的其中一个主要目标就是使得组件易于共享，实现跨浏览器通用，并停止在同一个问题上因为框架或者库的改变而不断重复实现。共享之所以变得可能，是因为 web components 基于现有的或者提出的标准，所有主流浏览器的厂商都会想办法去实现。

> 这意味着 web components 不依赖于任何框架或者库，就可以在任何 web 平台上通用。

我希望有更多人能参与到创建服务器端 web components 的创建当中，并把各种功能打包成组件，就像前端组件那样。我从 Express components 开始了这项工作，但我还期待看到 Koa, Hapi.js, Socket.io, MongoDB 等组件的出现。

## 可调试

Scram.js 有一个 `-d` 选项，让你可以在调试时打开 Electron 窗口。现在你可以使用 Chrome 开发者工具的所有功能来帮助你调试服务器了。断点、控制台日志、网络信息等都可以在里面看到。Node.js 的服务端调试似乎总是我的第二选择，但现在它的确已经集成到了平台中：


![](https://cdn.scotch.io/1614/CILiuE9kThuL1iqBuEij_Screenshot%20from%202016-06-07%2013:17:24.png)

## 更平缓的学习曲线

服务端 web components 对降低后端编程学习难度有帮助。要知道有很多 web 设计师、交互设计和其他一些只懂 HTML 和 CSS 的人希望学习服务端开发，但现有的服务器端代码对于他们而言很难理解。然而，如果使用他们熟悉的 HTML 来编写，特别是用上语义化的自定义元素，他们就能更容易地上手服务器端编程了。至少我们可以降低他们的学习曲线吧。

## 客户端架构

客户端和服务端 app 的架构正变得越来越像了。每个 app 以 `index.html` 文件开始，然后引入相关组件。这只是一种新的统一前后端的方法。在过去，我觉得想要找到服务器端应用的入口多少有点困难，如果后端能像前端应用一样，以 `index.html` 作为标准的入口，不是挺好的吗？

以下是使用 web components 构建的客户端应用的一般结构：

```
app/
----components/
--------app/
------------app.component.html
------------app.component.js
--------blog-post/
------------blog-post.component.html
------------blog-post.component.js
----models/
----services/
----index.html
```

以下是使用 web components 构建的服务端应用的一般结构：

```
app/
----components/
--------app/
------------app.component.html
------------app.component.js
--------api/
------------api.component.html
------------api.component.js
----models/
----services/
----index.html
```

这两种结构应该都可以很好地工作，现在我们成功减少了从客户端到服务端切换的上下文数量，反之亦然。

## 可能存在的问题

Electron 在服务器生产环境中的性能和稳定性，是最有可能导致应用崩溃的原因。话虽这么说，我并不觉得性能在将来是一个大问题，因为 Electron 只是通过一个渲染进程运行 Node.js 代码，我猜想和原生 Node.js 的运行状况差不多。最大问题是，Chromium 的运行时能否足够稳定，坚持运行足够长时间（而不发生内存泄露）。

另一个潜在问题是冗余性，相比原生 JavaScript 逻辑，使用服务端 web components 完成相同任务会花费更多时间，因为标记语言需要解析。话虽这么说，我依然希望付出冗余的代价，能换来更容易理解的代码。

## 性能测试

基于好奇心，我进行了一系列基础测试，对比同一个 [应用](https://github.com/azat-co/rest-api-express) 在原生 Node.js + Express 框架，和 Electron + Scram.js 的 Express Web Components 运行性能对比。下面的图标展示出对于主路由使用 [node-ab](https://github.com/doubaokun/node-ab) 库进行压力测试的结果。以下是测试用到的一些参数：

*   在本地机器上运行
*   每秒递增 100 次 GET 请求
*   运行直到有 1% 的请求返回不成功
*   对于 Node.js app 和 Electron/Scram.js app 版本，分别运行 10 次测试
*   Node.js app
    *   使用 Node.js v6.0.0 版本
    *   使用 Express v4.10.1 版本
*   Electron/Scram.js app
    *   使用 Scram.js v0.2.2 版本
        *   默认设置（从本地服务器加载起始 html 文件）
        *   调试窗口关闭
    *   使用 Express v4.10.1 版本
    *   使用 electron-prebuilt v1.2.1 版本
*   运行库: [https://github.com/doubaokun/node-ab](https://github.com/doubaokun/node-ab)
*   运行命令: `nab http://localhost:3000 --increase 100 --verbose`

以下是结果 （QPS: Queries Per Second 每秒查询数）：

![](https://cdn.scotch.io/1614/THvMpsJNTtmW14Mlad0D_electron-and-node.png)

![](https://cdn.scotch.io/1614/qvjN1PkpRi2F1AexzP7Y_electron.png)

![](https://cdn.scotch.io/1614/yVMSAsmTnCaT9HbjOknQ_node.png)

出乎意料，Electron/Scram.js 比 Node.js 性能更佳。我们对这个结果持保留意见，但起码还是能反映出使用 Electron 作为服务器的性能不会比 Node.js 差很远，至少在短期内处理原始请求的效果是如此。还记得我之前说过“我并不觉得性能在将来是一个大问题”吗？结果证实了我的描述。

## 总结

Web components 很好很强大，给 Web 平台带来了标准化、声明式的组件模型。Web components 不仅能给客户端带来便利，而且在服务端也获益良多。客户端和服务端之间的差距正在缩小，我相信服务器端 web components 是正确方向上的一大迈进。因此，一起来使用它们构建我们的应用吧！


*   在服务器上运行 Electron: [Scram.js](https://github.com/scramjs/scram-engine)
*   基础服务端 web components: [Express Web Components](https://github.com/scramjs/express-web-components)
*   线上 demo: [Dokku Example](http://scramjs.org/)
*   示例 1: [Simple Express API](https://github.com/scramjs/rest-api-express)
*   示例 2: [Modular Express API example](https://github.com/scramjs/node-api)
*   示例 3: [Todo App](https://github.com/scramjs/node-todo)
*   示例 4: [Simple REST SPA](https://github.com/scramjs/node-tutorial-2-restful-app)
*   示例 5: [Basic App for Frontend Devs](https://github.com/scramjs/node-tutorial-for-frontend-devs)

## 信用

Node.js 是 Joyent, Inc 的商标，使用需要经过他们允许。我们并非被 Joyent 认可，也非隶属关系。
