* 原文链接 : [Debugging Node.js in Chrome DevTools](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools)
* 原文作者 : [MATT DESLAURIERS](http://mattdesl.svbtle.com/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [sqrthree (根号三)](https://github.com/sqrthree)
* 校对者: [shenxn](https://github.com/shenxn)、[CoderBOBO](https://github.com/CoderBOBO)

# 在 chrome 的开发者工具里 debug node.js 代码

这篇文章介绍了一种在 Chrome 开发者工具里面开发、调试和分析 Node.js 应用程序的新方法。

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#devtool)devtool

最近我一直在开发一个命令行工具 [devtool](https://github.com/Jam3/devtool)，它可以在 Chrome 的开发者工具中运行 Node.js 程序。

下面的记录显示了在一个 HTTP 服务器中设置断点的情况。

![movie](http://i.imgur.com/V4RQSZ2.gif)

该工具基于 [Electron](https://github.com/atom/electron/) 将 Node.js 和 Chromium 的功能融合在了一起。它的目的在于为调试、分析和开发 Node.js 应用程序提供一个简单的界面。

你可以使用 [npm](http://npmjs.com/) 来安装它:

    npm install -g devtool

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#repl)REPL

在某种程度上，我们可以用它来作为 `node` shell 命令的替代品。例如，我们可以这样打开一个 REPL (译者注: REPL 全称为"Read-Eval-Print Loop"，是一个简单的、交互式的编程环境)。

    devtool

这将启动一个带有 Node.js 特性支持的 Chrome 开发者工具实例。

![console](http://i.imgur.com/bnInBHA.png)

我们可以引用 Node 模块、本地 npm 模块和像 `process.cwd()` 这样的内置模块。也可以获取像 `copy()` 和 `table()` 这样的 Chrome 开发者工具中的函数。

其他的例子就一目了然了:

    # run a Node script
    devtool app.js

    # pipe in content to process.stdin
    devtool < audio.mp3

    # pipe in JavaScript to eval it
    browserify index.js | devtool

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#development) 开发

我们可以在通用模块和应用程序的开发中使用 `devtool`，来代替像 [nodemon](https://www.npmjs.com/package/nodemon) 这样目前已经存在的工具。

    devtool app.js --watch

这行命令将会在 Chrome 开发者工具中的控制台中启动我们的 `app.js`， 通过 `--watch` 参数，我们保存的文件将(自动)重新载入到控制台。

![console](http://i.imgur.com/NuoYkJK.png)

点击 [`app.js:1`](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools) 链接，程序将会在 `Sources` 标签中把我们带到与之相关的那一行。

![line](http://i.imgur.com/mH5jWT9.png)

在 `Sources` 标签中，你也可以敲击 `Cmd/Ctrl + P` 按键在所有依赖的模块中进行快速搜索。你甚至可以审查和调试内置模块，比如 Node.js 中的那些。你也可以使用左手边的面板来浏览模块。

![Sources](http://i.imgur.com/jn3RmnV.png)

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#debugging) 调试

因为我们能够访问 `Sources` 标签，所以我们可以用它来调试我们的应用程序。你可以设置一个断点，然后重新加载调试器(`Cmd/Ctrl + R`)，或者你也可以通过 `--break` 标记来设置一个初始断点。

    devtool app.js --break

![break](http://i.imgur.com/hJ2pLW1.png)

下面是一些对于那些学习 Chrome 开发者工具的人来说可能不是特别常用的功能:

*   [条件断点](http://blittle.github.io/chrome-dev-tools/sources/conditional-breakpoints.html)
*   [有未捕获的异常时暂停](http://blittle.github.io/chrome-dev-tools/sources/uncaught-exceptions.html)
*   [重启帧](http://blittle.github.io/chrome-dev-tools/sources/restart-frame.html)
*   [监听表达式](http://albertlee.azurewebsites.net/using-watch-tools-in-chrome-dev-tools-to-improve-your-debugging/)

> 提示 - 当调试器暂停时，你可以敲击 `Escape` 按键打开一个执行在当前作用域内的控制台。你可以修改一些变量然后继续执行。


![Imgur](http://i.imgur.com/nG9ellE.gif)

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#profiling) 分析

`devtool` 的另一个功能是分析像 [browserify](https://github.com/substack/node-browserify), [gulp](https://github.com/gulpjs/gulp) 和 [babel](https://github.com/babel/babel) 这样的程序。

这里我们使用 [`console.profile()`](https://developer.chrome.com/devtools/docs/console-api) (Chrome 的一个功能)来分析一个打包工具的 CPU 使用情况。

    var browserify = require('browserify');

    // Start DevTools profiling...
    console.profile('build');

    // Bundle some browser application
    browserify('client.js').bundle(function (err, src) {
      if (err) throw err;

      // Finish DevTools profiling...
      console.profileEnd('build');
    });

现在我们在这个文件上运行 `devtool` :

    devtool app.js

执行之后，我们可以在 `Profiles` 标签中看到结果。

![profile](http://i.imgur.com/vSu7Lcz.png)

我们可以使用右边的链接来查看和调试执行频率较高的代码路径。

![debug](http://i.imgur.com/O4DZHyv.png)

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#advanced-options) 高级选项

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#experiments) 实验

Chrome 会不断的向他们的开发者工具中推送新功能和实验，例如 **Promise Inspector**。你可以通过点击右上角的三个点，然后选择 `Settings -> Experiments` 来开启他们。

![experiments](http://i.imgur.com/dNuIMw0.png)

一旦启用，你就可以通过敲击 `Escape` 按键来调出一个带有 _Promises_ 监视器的面板。

![](https://i.imgur.com/xKkTEeg.png)

> 提示: 在 _Experiments_ 界面，如果你敲击 `Shift` 键 6 次，你会接触到一些甚至更多的实验性（不稳定）的功能。


#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#codeconsolecode)`--console`

你可以重定向控制台输出到终端中(`process.stdout` 和 `process.stderr`)。也允许你通过使用管道将它导入到其他进程中，例如 TAP prettifiers。

    devtool test.js --console | tap-spec

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#codecode-and-codeprocessargvcode)`--` 和 `process.argv`

你的脚本可以像一个普通的 Node.js 应用那样解析 `process.argv`。如果你在 `devtool` 命令中传递一个句号(`--`)，它后面的所有内容都会被当做一个新的 `process.argv` 。例如:

    devtool script.js --console -- input.txt

现在，你的脚本看起来像这样:

    var file = process.argv[2];
    console.log('File: %s', file);

输出:

    File: input.txt

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#codequitcode-and-codeheadlesscode)`--quit` 和 `--headless`

使用 `--quit`，当遇到了一个错误(如语法错误或者未捕获的异常)时，进程将会安静的退出，并返回结束码`1` 。

使用 `--headless`，开发工具将不会被打开。

这可以用于命令行脚本：

    devtool render.js --quit --headless > result.png

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#codebrowserfieldcode)`--browser-field`

一些模块为了更好的在浏览器中运行或许会提供一个入口点。当你需要这些模块时，你可以使用 `--browser-field` 来支持 [package.json flag](https://github.com/defunctzombie/package-browser-field-spec)

例如，我们可以使用 [xhr-request](https://github.com/Jam3/xhr-request) ，当带有 `"browser"` 字段被引用时，这个模块会使用 XHR。

    const request = require('xhr-request');

    request('https://api.github.com/users/mattdesl/repos', {
      json: true
    }, (err, data) => {
      if (err) throw err;
      console.log(data);
    });

在 shell 中执行:

    npm install xhr-request --save
    devtool app.js --browser-field

现在，我们可以在 `Network` 选项卡中审查请求:

![requests](http://i.imgur.com/BWciXuh.png)

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#codenonodetimerscode)`--no-node-timers`

默认情况下，我们提供全局的 `setTimeout` and `setInterval`，因此他们表现的像 Node.js 一样(返回一个带有 `unref()` and `ref()` 函数的对象)。

但是，你可以禁用这个方法来改善对异步堆栈跟踪的支持。

    devtool app.js --no-node-timers

![async](http://i.imgur.com/dmfOfMx.png)

#### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#v8-flags)V8 Flags

在当前目录，你可以创建一个 `.devtoolrc` 文件来进行诸如 V8 flags 这样的高级设置。

    {
      "v8": {
        "flags": [
          "--harmony-destructuring"
        ]
      }
    }

访问[这里](https://github.com/Jam3/devtool/blob/master/docs/rc-config.md)获取更多细节

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#gotchas)陷阱

由于程序是在一个 Browser/Electron 环境中运行，而不是在一个真正的 Node.js 环境中。因此这里有[一些陷阱](https://github.com/Jam3/devtool#gotchas)你需要注意。

## [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#comparisons)对比

目前已经存在了一些 Node.js 调试器，所以你或许想知道他们之间的区别在哪。

### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#webstorm-debugger)WebStorm 调试器

[WebStorm](https://www.jetbrains.com/webstorm/) 编辑器里面包含了一个非常强大的 Node.js 调试器。如果你已经使用 WebStorm 作为你的代码编辑器，那对你来说很棒。

> ![](https://i.imgur.com/cfwG6qY.png)

但是，它缺少一些 Chrome 开发者工具中的功能，例如:

*   一个丰富的互动的控制台
*   异常时暂停
*   异步堆栈跟踪
*   Promise 检查
*   分析

但因为你和你的 WebStorm 工作空间集成，所以你可以在调试时修改和编辑你的文件。它也是运行在一个真正的 Node/V8 环境中，而不像 `devtool` 一样。因此对于大部分的 Node.js 应用程序来说它更稳健。

### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#ironnode)iron-node

![](https://i.imgur.com/fkbLvoS.png)

一个同样基于 Electron 的调试器是[iron-node](https://github.com/s-a/iron-node)。`iron-node` 包含了一个内置的命令来重新编译原生插件，还有一个复杂的图形界面显示您的`package.json` 和 `README.md`。

而 `devtool` 更侧重于把命令行、Unix 风格的管道和重定向和 Electron/Browser 的 API 当作有趣的用例。

`devtool` 提供各种各样的功能来表现的更像 Node.js (例如 `require.main`, `setTimeout` 和 `process.exit`)，并且覆盖了内部的 `require` 机制作为 source maps，还有改进过的错误处理、断点注入、以及 `"browser"` 字段的解决方案。

### [ ](http://mattdesl.svbtle.com/debugging-nodejs-in-chrome-devtools#nodeinspector)node-inspector

![](https://i.imgur.com/T4fpxjU.png)

你或许也喜欢 [node-inspector](https://github.com/node-inspector/node-inspector)，一个使用远程调试而不是构建在 Electron 之上的工具。

这意味着你的代码将运行在一个真正的 Node 环境中，没有任何 `window` 或其他的 Browser/Electron API 来污染作用域并导致某些模块出现问题。对于大型 Node.js 应用(即本地插件)来说它有一个强有力的支持，并且在开发者工具实例中拥有更多的控制权(即可以注入断点和支持网络请求)。

然而，由于它重新实现了大量的调试技巧，因此对于开发来说感觉可能比最新版的 Chrome 开发者工具要慢、笨拙和脆弱。它经常会崩溃，往往导致 Node.js 开发人员很无奈。

而 `devtool` 的目的是让那些从 Chrome 开发者工具中转过来的人觉得比较亲切，而且也增加了像 Browser/Electron APIs 这样的功能。
