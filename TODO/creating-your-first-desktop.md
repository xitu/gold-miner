> * 原文链接 : [Creating Your First Desktop App With HTML, JS and Electron | Tutorialzine](http://tutorialzine.com/2015/12/creating-your-first-desktop-app-with-html-js-and-electron/)
* 原文作者 : [Danny Markov](http://tutorialzine.com/category/tutorials/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [Zhangdroid](https://github.com/Zhangdroid)
* 校对者: [void-main](https://github.com/void-main)、[根号三](https://github.com/sqrthree)
* 状态 :  完成

Web 应用这些年来变得越来越强大，但相比于桌面应用能够完全访问计算机硬件，Web 应用还有一些差距。现在，你能够通过已经熟悉了的HTML、JavaScript 和 Node.js 来创建桌面应用，然后打包成可执行文件，并在 Windows、OS X 和 Linux 上发布它。

目前已经有两个流行的开源项目实现了这个想法。首先是 [NW.js](http://nwjs.io/)，[我们在几个月前讨论过它](http://tutorialzine.com/2015/01/your-first-node-webkit-app/ "Creating Your First Desktop App With HTML, JS and Node-WebKit")；然后是更新一些的 [Electron](http://electron.atom.io/), 也就是我们今天所使用到的（可以在[这里](https://github.com/atom/electron/blob/master/docs/development/atom-shell-vs-node-webkit.md)查看它与 NW.js 的不同之处）。我们将用 Electron 重写旧的 NW.js 版本的应用，这样你就能轻易的对比它们了。

### Electron 入门

使用 Electron 创建的应用其实就是一个在内嵌的 Chromium 浏览器中打开的 Web 网站。除了常规的 HTML5 API，(这些网站)还可以使用任意的 Node.js 模块和一些 Electron 特有的模块来访问操作系统。

在整个教程中，我们将创建一个简单的应用：它能够通过 RSS 获取到 Tutorialzine 上最近的文章，并通过一个看起来很酷的轮播效果来展示它们。所有需要的文件已经打包好，**[点击这里](http://demo.tutorialzine.com/2015/12/creating-your-first-desktop-app-with-html-js-and-electron/creating-your-first-desktop-app-with-electron.zip)**下载。

把它解压到你想要的地方。从项目结构上看，你一定猜不到这不仅仅是一个简单的网站，而且是一个桌面应用程序。

![项目结构](http://cdn.tutorialzine.com/wp-content/uploads/2015/12/electron-app-tree.png)

项目结构


我们一会儿会更仔细的看看这些有趣的文件，了解它们的原理。不过在此之前，先让我们把应用跑起来吧。

### 运行应用

由于 Electron 是一个优秀的 Node.js 应用，所以你必须安装 [npm](https://www.npmjs.com/)。 你可以轻松的在[这里](http://blog.npmjs.org/post/85484771375/how-to-install-npm)学习到如何安装它。

完成之后，在项目目录下打开 cmd 或者终端，运行下面的命令：

```
npm install
```

它将会创建 **node_modules** 文件夹来存放这个应用运行所需的所有 Node.js 依赖。 一切都没问题的话在同一个终端下输入下面的命令：

```
npm start
```

你所创建的应用应该会在一个独立的窗口中打开。可以注意到它有一个顶部菜单栏和其他的一些部分！

![Electron App In Action](http://cdn.tutorialzine.com/wp-content/uploads/2015/12/electron_app_1.png)

Electron 实战



你可能注意到打开这个应用的方式对用户并不友好。但这仅仅是开发者打开它的方式，当它面向公众被打包好之后, 就可以像一般的应用一样安装，并通过双击图标来打开它。

### 如何工作

在这部分，我们将讨论所有 Electron 应用中最重要的一些文件。首先是 package.json，它包含有关项目的各种信息，比如版本、npm 依赖和其他重要设置。

#### package.json

```
{
  "name": "electron-app",
  "version": "1.0.0",
  "description": "",
  "main": "main.js",
  "dependencies": {
    "pretty-bytes": "^2.0.1"
  },
  "devDependencies": {
    "electron-prebuilt": "^0.35.2"
  },
  "scripts": {
    "start": "electron main.js"
  },
  "author": "",
  "license": "ISC"
}
```

如果以前用过 node.js，那么你已经知道它是如何工作的了。最重要的是注意这里的 **scripts** 属性，它定义了 `npm start` 命令，这条命令能够让我们像之前那样运行应用。当我们执行这条命令时，我们其实是在要求 electron 去运行 **main.js** 这个文件。这个 JS 文件包括一些简短的脚本：打开应用的窗口、定义一些设置和一些事件的处理。 

#### main.js

```
var app = require('app');  // 控制应用生命周期的模块。
var BrowserWindow = require('browser-window');  // 创建原生浏览器窗口的模块

// 保持一个对于 window 对象的全局引用，不然，当 JavaScript 被 "垃圾回收机制" 回收，
// 窗口会被自动地关闭
var mainWindow = null;

// 当所有窗口被关闭了，退出。
app.on('window-all-closed', function() {
  // 在 OS X 上，通常用户在明确地按下 Cmd + Q 之前
  // 应用会保持活动状态
  if (process.platform != 'darwin') {
    app.quit();
  }
});

// 当 Electron 完成了初始化并且准备创建浏览器窗口的时候
// 这个方法就被调用
app.on('ready', function() {
  // 创建浏览器窗口。
  mainWindow = new BrowserWindow({width: 900, height: 600});

  // 加载应用的 index.html
  mainWindow.loadURL('file://' + __dirname + '/index.html');


  // 当 window 被关闭，这个事件会被发出
  mainWindow.on('closed', function() {
    // 取消引用 window 对象，如果你的应用支持多窗口的话，
    // 通常会把多个 window 对象存放在一个数组里面，
    // 但这次不是。
    mainWindow = null;
  });
});
```

观察一下我们在“ready”方法中做的事情。首先我们定义一个浏览器窗口并给它了初始化的大小，然后我们在它里面载入了  **index.html** 这个文件，效果和你在浏览器里打开它差不多。

正如你所看到的，这个 HTML 文件没有什么特别的 – 一个图片轮播和一段显示 CPU 和 RAM 统计数据的文字被包含在容器之中。
#### index.html

```


    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1">

    <title>Tutorialzine Electron Experiment</title>

    <link rel="stylesheet" href="./css/jquery.flipster.min.css">
    <link rel="stylesheet" href="./css/styles.css">

<!-- 在 Electron中，应该这样引入 jQuery -->
<script>window.$ = window.jQuery = require('./js/jquery.min.js');</script>

```

这个 HTML 文件同样也引入了所需的 CSS 文件、JS库和其它的脚本。注意，jQuery 需要以一种奇怪的方式引入。更多相关信息可以参考[这里](http://stackoverflow.com/questions/32621988/electron-jquery-is-not-defined)。

最后，这是这个应用实际的 Javascript 文件。在这里面，我们访问 Tutorialzine 的 RSS 源，获取最新的文章并把它们显示出来。直接在浏览器中这样做是没有效果的，因为从不同的域名获取 RSS 订阅是被禁止的（参见[同源策略](https://developer.mozilla.org/zh-CN/docs/Web/Security/Same-origin_policy)）。但在 Electron 中并没有这个限制，我们可以通过 AJAX 请求轻松的获取到我们想要的信息。

```
$(function(){

    // 显示有关该计算机的一些统计数据，使用的是 node 的 os 模块。

    var os = require('os');
    var prettyBytes = require('pretty-bytes');

    $('.stats').append('Number of cpu cores: ' + os.cpus().length + '');
    $('.stats').append('Free memory: ' + prettyBytes(os.freemem())+ '');

    // Electron 的 UI 库。我们在之后会用到它。

    var shell = require('shell');

    // 从 Tutorialzine 上获取最近的文章。

    var ul = $('.flipster ul');

    // Electron 并没有采用同源安全策略, 所以我们能够
    // 发送 ajax 请求给其它网站。让我们获取 Tutorialzine 的 RSS 订阅：

    $.get('http://feeds.feedburner.com/Tutorialzine', function(response){

        var rss = $(response);

        // 在 RSS 订阅中找到所有的文章：

        rss.find('item').each(function(){
            var item = $(this);

            var content = item.find('encoded').html().split('')[0]+'';
            var urlRegex = /(http|ftp|https):\/\/[\w\-_]+(\.[\w\-_]+)+([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?/g;

            // 获取文章的第一幅图。
            var imageSource = content.match(urlRegex)[1];

            // 为每一篇文章创建一个 li 元素，并把它追加到 ul 中。
            var li = $('*   <a target="_blank"></a>');

            li.find('a')
                .attr('href', item.find('link').text())
                .text(item.find("title").text());

            li.find('img').attr('src', imageSource);

            li.appendTo(ul);

        });

        // 初始化 flipster 插件。

        $('.flipster').flipster({
            style: 'carousel'
        });

        // 当一篇文章被点击时，用系统默认的浏览器打开它，
        // 否则的话会用 electron 的窗口打开它，这不是我们想要的结果。

        $('.flipster').on('click', 'a', function (e) {

            e.preventDefault();

            // 使用系统默认的浏览器打开 URL。

            shell.openExternal(e.target.href);

        });

    });

});
```

上面的代码里有一件很酷的事情，在一个文件中我们同时使用了：

*   JavaScript 库 – 使用 jQuery 和 [jQuery Flipster](https://github.com/drien/jquery-flipster) 来实现图片轮播。
*   Electron 原生模块 – Shell 提供了一些桌面任务相关的 API，在这里我们通过它使用了系统默认的浏览器打开 URL。
*   Node.js 模块 – 使用 [OS](https://nodejs.org/api/os.html) 来获取系统的内存信息，使用 [Pretty Bytes](https://www.npmjs.com/package/pretty-bytes) 格式化它们。

就这样我们的应用已经准备好了！

### 打包和发布

还有一件重要的事情：让你的应用准备好面对最终的用户。你需要把它打包成一个在用户电脑上双击就可以使用的可执行文件。由于 Electron 应用能够在多个操作系统上运行，每个操作系统又各不相同，所以需要为 Windows、Linux和 OS X 分别打包。使用像这个 npm 模块一样的工具可以很好的帮助你开始 – [Electron Packager](https://github.com/maxogden/electron-packager).

考虑到要将所有的资源文件、所有需要的 npm 模块、以及一个迷你的 WebKit 浏览器打包进一个可执行文件，所有的这些打包完后（的大小约）有 50MB。对于像这样一个简单的应用来说这是相当大的了，是不现实的。但当我们创建更大、更复杂的应用时，这个问题就变的无关紧要了。

### 结论

通过我们的例子，你可以看到 NW.js 与 Electron 最主要的不同是：NW.js 直接打开了一个 HTML页面；而 Electron 是通过 JavaScript 文件启动并通过代码来创建应用程序窗口。 Electron 的方式给了你更多控制的权利，你能够轻松地创建多窗口应用程序并组织它们之间的通信。

总而言之 Electron 是一种非常令人激动的通过 Web 技术来创建桌面应用的方式。这是你接下来可能需要阅读的内容：

* [Electron 快速入门](https://github.com/atom/electron/blob/master/docs-translations/zh-CN/tutorial/quick-start.md)
* [Electron 文档](https://github.com/atom/electron/tree/master/docs-translations/zh-CN)
* [使用 Electron 创建的应用](http://electron.atom.io/#built-on-electron)
