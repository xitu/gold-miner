> * ​
> * 原文作者：[Adam Lynch](https://www.smashingmagazine.com/author/adamlynch/)
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [bambooom](https://github.com/bambooom)
> * 校对者：

## 超越浏览器：从 web 应用到桌面应用

一开始我是个 web 开发者，现在我是个全栈开发者，但从未想过在桌面上有所作为。我热爱 web 技术，热爱这个无私的社区，热爱它对于开源的友好，尝试挑战极限。我热爱探索好看的网站和强大的应用。当我被指派做桌面应用的任务的时候，我非常忧虑和害怕，因为那看起来很难，或者至少非常不同。

这并不吸引人，对吧？你需要学一门新的语言，甚至三门？想象一下过时的工作流，古旧的工具，没有任何你喜欢的有关 web 的一切。你的职业发展会被怎样影响呢？

别慌，深呼吸，现实情况是，作为 web 开发者，你已经拥有一切开发现代桌面应用所需的一切技能，感谢新的强大的 API，你甚至可以在桌面应用中发挥你最大的潜能。

本文将会介绍使用 [NW.js](http://nwjs.io/) 和 [Electron](https://electron.atom.io/) 开发桌面应用，它们的优劣，使用同一套代码库给桌面、web，甚至更多。

### 为什么？

首先，为什么会有人开发桌面应用？任何现有的 web 应用（不同于网站，如果你认为它们是不同的）都可能适合变成一个桌面应用。你可以围绕任何可以从与用户系统集中中获益的 web 应用构建桌面应用；例如本地通知，开机启动，与文件的交互等。有些用户单纯更喜欢在自己的电脑中永久保存一些 app，无论是否联网都可以访问。

也许你有个想法，但只能用作桌面应用，有些事情只是在 web 应用中不可能实现（至少还有一点，但更多的是这一点）。你可能想要为公司内部创建一个独立的功能性应用程序，而不需要任何人安装除了你的 app 之外的任何内容（因为内置 Node.js ）。也许你有个有关 Mac 应用商店的想法，也许只是你的一个个人兴趣的小项目。

很难总结为什么你应该考虑开发桌面应用，因为真的有很多类型的应用你可以创建。这非常取决于你想要达到什么目的，API 是否足够有利于开发，离线使用将多大程度上增强用户体验。在我的团队，这些都是毋庸置疑的，因为我们在开发一个[聊天应用程序](https://teamwork.com/chat)。另一方面来说，一个依赖于网络而没有任何与系统集成的桌面应用应该是一个 web 应用，并且只是 web 应用。当用户并不能从桌面应用中获得比在浏览器中访问一个网址更多的价值的时候，期待用户下载你的应用（其中自带浏览器以及 Node.js）是不公平的。

比起描述你个人应该建造的桌面应用以及为什么建造，我更希望的是激发一个想法，或者只是激发你对这篇文章的兴趣。继续往下读来看看用 web 技术构造一个强大的桌面应用是多么简单，以及需要承受的困难超过（或者相同）创造一个 web 应用。

### NW.js

桌面应用已经有很长一段时间了，我知道你没有很多时间，所以我们跳过一些历史，从2011年的上海开始。来自 Intel 开源技术中心的 Roger Wang 创造了 node-webkit，一个概念验证的 Node.js 模块，这个模块可以让用户生成一个自带 WebKit 内核的浏览器窗口并直接在 `<script>` 中使用 Node.js 模块。

经过一段时间的开发以及将内核从 WebKit 转换到 Chromium（Google Chrome 基于这个开源项目开发），一个叫 Cheng Zhao 的实习生加入了这个项目。不久就有人意识到一个基于 Node.js 和 Chromium 运行的应用是一个很好的建造桌面应用的框架。于是这个项目变得颇受欢迎。

*注意*：node-webkit 后来更名为 NW.js，是因为项目不再使用 Node.js 以及 WebKit，所以需要改一个更通用的名字。Node.js 的替换选择是 io.js （Node.js fork 版本），Chromium 也已经从 WebKit 转为它自己的版本，Blink。

所以，如果现在去下载一个 NW.js 应用，实际上是下载了 Chromium，Node.js，以及真正的 app 的代码。这不仅意味着桌面应用也可以使用 HTML，CSS，JavaScript 来写，也意味着 app 可以直接使用所有 Node.js 的 API（比如读取或写入硬盘），而对于终端用户，没有比这更好的选择了。这看起来非常强大，但是它是怎么实现的呢？我们先来了解一下 Chromium。

![Chromium diagram](https://www.smashingmagazine.com/wp-content/uploads/2017/01/chromiumDiagram-preview-opt.png)

Chromium 有一个主要的后台进程，每个标签页也会有自己的进程。你可能注意到 Google Chrome 在 Windows 的任务管理器或者 macOS 的活动监视器上总是至少存在两个进程。我并没有尝试在这里安排穿插主后台进程相关的内容，但是它包括了 Blink 渲染引擎，V8 JavaScript 引擎（也就是构建了 Node.js ）以及一些从原生 API 抽象出来的平台 API。每个独立的标签页或渲染的过程都可以使用 JavaScript 引擎，CSS 解析器等，但为了提高容错性，它们又和主进程是完全隔离的。渲染进程与主进程之前是用进程间通信（IPC）来进行通讯。

![NW.js diagram](https://www.smashingmagazine.com/wp-content/uploads/2017/01/nwjsDiagram-preview-opt.png)



大致上这就是一个 NW.js app 的结构，它和 Chromium 基本一致，除了每个窗口也可以访问 Node.js。现在，你可以访问 DOM，可以访问其他脚本，npm 安装的模块，或者 NW.js 提供的内置的模块。你的 app 默认只有一个窗口，但从这一个窗口，可以生成其他窗口。

创建一个应用很简单，只需要一个 HTML 文件和一个 `package.json` 文件，就像你平时使用 Node.js 时那样。你可以使用 `npm init --yes` 新建一个默认的。一般来说，`package.json` 会指定一个 JavaScript 文件作为模块的入口（也就是使用 `main` 属性），但是如果是 NW.js，你需要去编辑一下 `main` 指向你的 HTML 文件。

```
{
  "name": "example-app",
  "version": "1.0.0",
  "description": "",
  "main": "index.html",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
```

```
<!-- index.html -->
<!DOCTYPE html>
<html>
  <head>
    <title>Example app</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>
    <h1>Hello, world!</h1>
  </body>
</html>
```

只要你安装好了 `nw`（通过 `npm install -g nw`），你就可以在项目目录下执行 `nw .` 启动 app，然后就可以看到下图。

![Example app screenshot](https://www.smashingmagazine.com/wp-content/uploads/2017/01/nwjsHelloWorld-preview-opt.png)

就是这么简单。NW.js 初始化了第一个窗口，加载了你的 HTML 文件，虽然这看起来并没有什么，但接下来就是你来添加标签及样式了，就和在 web 应用中一样。

你可以凭自己喜好去掉窗口栏，构建自己的框架模板。你可以有半透明或全透明的窗口，可以有隐藏窗口或者更多。我最近试了一下用 NW.js 复活了[回形针](http://engineroom.teamwork.com/resurrecting-clippy/) Office 助手（一般昵称 Clippy）。能看到它同时在 macOS 或者 Windows 10 中复活有种奇妙的满足感。

![Screenshot of clippy.desktop on macOS](https://www.smashingmagazine.com/wp-content/uploads/2017/01/clippy-preview-opt.png)

现在你可以写 HTML，CSS 和 JavaScript 了，你可以使用 Node.js 读取或写入硬盘，执行系统命令，生成其他可执行文件等等。设想一下，你甚至可以通过 WebRTC 造一个多玩家的轮盘赌游戏，随机删除其他人的文件。

![Bar graph showing the number of modules per major package manager](https://www.smashingmagazine.com/wp-content/uploads/2017/01/moduleCounts-preview-opt.png)

你不仅可以使用 Node.js 的 APIs，还有所有 npm 的包，现在已经有超过35万个了。例如，[auto-launch](https://github.com/Teamwork/node-auto-launch) 是我们在 [Teamwork.com](https://www.teamwork.com/) 做的开源包，用来开机启动 NW.js 或者 Electron 应用。

如果你需要做一些偏底层的事，Node.js 也有原生的模块，能让你使用 C 或者 C++创建模块。

总之，NW.js 高效包装了原生的 API，让你可以简单的与桌面环境集成。
比如你有一个托盘图标，使用系统默认应用打开一个文件或者 URL 之类的。你需要做的是使用 HTML5 notification 的 API 触发一个通知：

```
new Notification('Hello', {
  body: 'world'
});
```

### Electron

你可能认出来了，下图是 GitHub 开发的编辑器，Atom。不管你是否使用 Atom，它的出现对于桌面应用都是一个颠覆者。GitHub 从 2013 年开始开发 Atom，后来 Cheng Zhao 加入，fork 了 node-webkit 作为基础，后来开源名称为 atom-shell。

![Atom screenshot](https://www.smashingmagazine.com/wp-content/uploads/2017/01/atom-preview-opt.png)

*注意*：对于 Electron 只是 node-webkit 的 fork，还是一切从头重新做的，是很有争议的。但无论哪种方式，最终都成为终端用户的一个分支，因为 API 几乎完全一致。

在开发 Atom 的过程中，GitHub 改进了一些方案，也解决了很多 bug。2015年，atom-shell 正式更名为 Electron。它的版本已经更新到 1.0 以上（译注：最新正式版本为v1.3.14），并且因为 GitHub 的推行，它已经真正发展壮大了。

![Logos of projects that use Electron](https://www.smashingmagazine.com/wp-content/uploads/2017/01/logos-preview-opt.png)

> As well as Atom, other notable projects built with Electron include Slack, Visual Studio Code, Brave, HyperTerm and Nylas, which is really doing some cutting-edge stuff with it. Mozilla Tofino is an interesting one, too. It was an internal project at Mozilla (the company behind Firefox), with the aim of radically improving web browsers. Yeah, a team within Mozilla chose Electron (which is based on Chromium) for this experiment.

和 Atom 一样，其他用 Electron 开发的有名项目包括 [Slack](https://slack.com/)、[Visual Studio Code](https://code.visualstudio.com/)、 [Brave](https://www.brave.com/)、[HyperTerm](https://hyper.is/)、[Nylas](https://www.nylas.com/)，真的是在做着一些尖端的东西。Mozilla Tofino 也是其中一个很有趣的，它是 Mozilla（ FireFox 的公司）的一个内部项目，目标是彻底优化浏览器。你没看错，Mozilla 的团队选择了 Electron （基于 Chromium ）来做这个实验。

### Electron 有什么不同呢？

那么 Electron 和 NW.js 有什么不同？首先，Electron 没有 NW.js 那么面向浏览器，Electron app 的入口是一个在主进程中运行的脚本。

![Electron architecture diagram](https://www.smashingmagazine.com/wp-content/uploads/2017/01/electronDiagram-preview-opt-1.png)

Electron 团队修补了 Chromium 以便嵌入多个可以同时运行的 JavaScript 引擎，所以当 Chromium 发布新版本的时候，他们不需要做任何事。

*注意*：NW.js 与 Chromium 的绑定不太一样，造成了 NW.js 经常被指责不如 Electron 那样紧跟 Chromium。然而，整个2016年，NW.js 每次在 Chromium 发布主要版本之后的24小时内发布新版本，这很大程度也归功于团队组织转型。

回到主进程的话题，你的应用默认是没有窗口的，但是你可以从主进程开启任意多个窗口，每个窗口和 NW.js 一样有自己的渲染进程。

那么当然，创建一个 Electron app，你需要的只是一个 JavaScript 文件（现在暂时只是个空文件）以及一个 `package.json` 文件指向它。然后你只需要执行 `npm install --save-dev electron`，以及 `electron .` 来启动你的 app。

```
{
  "name": "example-app",
  "version": "1.0.0",
  "description": "",
  "main": "main.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
```

```
// main.js 文件，现在是空的
```

没有什么会发生，因为你的 app 没有默认窗口。接下来你可以和 NW.js 一样打开任意多个窗口，每个都有各自的渲染进程。

```
// main.js
const {app, BrowserWindow} = require('electron');
let mainWindow;

app.on('ready', () => {
  mainWindow = new BrowserWindow({
    width: 500,
    height: 400
  });
  mainWindow.loadURL('file://' + __dirname + '/index.html');
});
```
```
<!-- index.html -->
<!DOCTYPE html>
<html>
  <head>
    <title>Example app</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>
  <body>
    <h1>Hello, world!</h1>
  </body>
</html>
```

你可以在这个窗口中加载远程 URL，但是一般来说你会在本地创建 HTML 文件并加载它，好啦~加载出来啦！

![Screenshot of example Electron app](https://www.smashingmagazine.com/wp-content/uploads/2017/01/electronHelloWorld-preview-opt.png)

在 Electron 提供的模块中，像在前面例子中使用的 `app` 和 `BrowserWindow`，大多只能要么在主进程要么在某个渲染进程中使用。比方说，你只能在主进程中管理你的所有窗口，自动更新或者其他。你可能想在主进程中点击一个按钮触发一些事件，Electron 为 IPC 提供了一些内置方法。基本上你可以发出任意的事件，然后在另一端监听它们。这样，你就可以在某一个渲染进程中捕获 `click` 事件，通过 IPC 发出事件信息给主进程，主进程捕获后执行相关操作。

Electron 有着不同的进程，你需要稍微不同地组织你的 app，但这不算什么。为什么使用 Electron 而不是 NW.js？这其中有影响力的因素，有很多相关的工具和模块是它流行起来的结果。 Electron 的文档更好懂，最重要的是，Electron 的 bug 更少，并且有更好的 API。

Electron 的文档非常棒，这值得再强调一下。拿 [Electron API Demos app](https://github.com/electron/electron-api-demos) 来说，这是个 Electron app，它可以交互式的演示出你可通过 Electron 的 API 做到什么。比如新建窗口，它不仅提供了 API 的描述以及示例代码，甚至点击按钮的确可以执行代码并打开新的窗口。（下图就是 Electron API Demos app 的截图）

![A screenshot of the Electron API Demos app](https://www.smashingmagazine.com/wp-content/uploads/2017/01/apiDemosApp-preview-opt.png)

如果你通过 Electron 的 bug 追踪器提交问题，你可以在几天之内得到回复。我曾经见过 NW.js 有经过三年都未修复的 bug，我并不是坚决反对他们这么做，开发开源项目采用的语言和使用这个项目的开发者了解的语言如此的不同，是非常难维护的。NW.js 和 Electron 主要是用 C++ （以及少部分 Objective C++）写的，但是使用这两个项目的人写的是 JavaScript。我非常感激 NW.js 给我的帮助。

Electron 弥补了 NW.js API 上的一些不足。比如，你可以绑定全局的键盘快捷键，这样即使你的 app 并没有获取焦点，键盘事件也可以被捕获。曾经我在 NW.js 的应用中碰到过一个 API 的漏洞，就是我在 Windows 上可以绑定 `Control + Shift + A` 快捷键达到预期目的，但是实际上到了 Mac 上绑定的快捷键是 `Command + Shift + A`，这个的确是有意而为之的，但是仍然很奇怪。没有任何方法可以在 Mac 上绑定 `Control` 键。另外，如果想绑定 `Command` 键，在 Mac 上的确没问题，而到了 Windows 和 Linux 上绑定的却是 `Windows` 键。Electron 的团队发现了这些问题（我猜是在给 Atom 添加快捷键的时候），然后他们很快更新了他们自己的全局快捷键（globalShortcut）API，以上遇到的情况就可以正常工作了。公平起见，NW.js 修复了前一个问题，但一直没有修复后一个。

还有其他一些不同的地方。比如说，之前原生的 notification 通知，在最近的 NW.js 版本中，变成了 Chrome 风格的了。这种通知不会进入到 Mac OS X 或者 Windows 10 的通知中心里面，但是在 npm 上有方便使用的模块解决。如果你想做一些有趣的有关音频或视频的事，建议使用 Electron，因为有些解码器和 NW.js 不兼容。

Electron 还添加了一些新的 API，更加多与桌面端的集成，并且内置了自动升级，我稍后会谈到。

### 但是感觉如何呢？

感觉很好，当然，它并不是原生的。现在大多数桌面应用并不会长得像资源管理器或者 Finder，所以用户并不介意或者意识到用户界面背后是 HTML。你愿意的话，你可以使之更像原生应用，但是我并不认为那样会让用户体验更好。比如，你可以在用户将鼠标悬停在按钮上时，不让光标变成手，一般原生的桌面应用都是这样做的，但是这样做有什么好的吗？当然也有像 [Photon Kit](http://photonkit.com/) 这样的类似 Bootstrap 的 CSS 框架，可以做出 macOS 风格的组件。（下图是 Photon Kit 做出的组件 demo）

![Photon app example screenshot](https://www.smashingmagazine.com/wp-content/uploads/2017/01/photon-preview-opt.png)

### 性能

性能表现如何呢？会很慢或者延迟吗？其实你的 app 本质上来说仍然是 web 应用，所以它会和在 Google Chrome 中运行的 web app 非常类似。你可能会创造出高性能的或者反应迟缓的 app，但是没关系，你已经有分析并提升性能的技能了。app 基于 Chromium 最好的其中一点就是你可以使用它的开发者工具。你可以在 app 内调试或者远程调试，Electron 团队也开发了一款开发者工具的插件叫 [Devtron](http://electron.atom.io/devtron/) 来监控一些 Electron 特定的信息。

不过，你的桌面应用可以比 web 应用的性能更高。因为你可以创建一个工作窗口，一个用于执行耗能昂贵工作的隐藏窗口。因为每个进程都是孤立的，所以任何在这个窗口中进行的计算或者处理不会影响到其他可见窗口的渲染进程，上下滚动等等。

记住你总可以生成系统指令、可执行文件，或者原生代码，如果真的需要的话（你不会真的这么做的）。

### 分发

NW.js 和 Electron 都支持很多平台，包括 Windows，Mac 和 Linux。Electron 不支持 Windows XP 和 Vista，但 NW.js 支持。将 NW.js 应用上线到 Mac App Store 有些棘手，你必须绕几个弯子。而 Electron 支持直接的 Mac App Strore 兼容的版本，和普通的版本一样，只是某些模块你无法访问，比如自动更新（因为你的 app 会通过 Mac App Store 进行更新所以可以接受）。

Electron 甚至支持 ARM 版本，所以你的 app 可以在 Chromebook 或者树莓派上运行，最终，Google 会[逐步淘汰 Chrome 封装应用 （Packaged App）](https://blog.chromium.org/2016/08/from-chrome-apps-to-web.html)，但是 NW.js 仍然支持将应用程序移植到 NW.js 应用，并且仍然可以访问相同的 Chromium API。

虽然 32 位和 64 位的版本都支持，你也可以使用 64 位的 Mac 和 Windows 应用。但是，为了兼容，32 位和 64 位 Linux 应用程序是都需要的。

假如 Electron 胜出，你想发行一个 Electron 应用。有一个很不错的 Node.js 包叫 [electron-packager](https://github.com/electron-userland/electron-packager) 可以帮你将 app 打包成一个 `.app` 或者 `.exe` 文件。也有其他几个类似的项目，包括交互式的一步一步告诉你该怎么做。不过，你应该用 [electron-builder](https://github.com/electron-userland/electron-builder)，它以 electron-packager 为基础，添加了其他几个相关的模块，生成的是 `.dmg` 文件和 Windows 安装包，并且为你处理好了代码签名的问题。这很重要，如果没有这一步，你的应用将会被操作系统认为是不可信的，你的应用程序可能会触发防毒软件的运行，Microsoft SmartScreen 可能会尝试阻止用户启动你的应用。

关于代码签名的令人讨厌的事情是，你必须在 Mac 上为 Mac 和 Windows 上为 Windows 签署你的应用程序。因此，如果是认真要发行桌面应用的话，就需要为每个发行版本给多种机器构建。

This can feel a bit too manual or tedious, especially if you’re used to creating for the web. Thankfully, electron-builder was created with automation in mind. I’m talking here about continuous integration tools and services such as [Jenkins](https://jenkins.io/), [CodeShip](http://codeship.com/), [Travis-CI](https://travis-ci.org/), [AppVeyor](https://www.appveyor.com/) (for Windows) and so on. These could run your desktop app build at the press of a button or at every push to GitHub, for example.

### Automatic Updates

NW.js doesn’t have automatic update support, but you’ll have access to all of Node.js, so you can do whatever you want. Open-source modules are out there for it, such as [node-webkit-updater](https://github.com/edjafarov/node-webkit-updater), which handles downloading and replacing your app with a newer version. You could also roll your own custom system if you wanted.

Electron has built-in support for automatic updates, via its [autoUpdater](http://electron.atom.io/docs/api/auto-updater/) API. It doesn’t support Linux, first of all; instead, publishing your app to Linux package managers is recommended. This is common on Linux — don’t worry. The `autoUpdater` API is really simple; once you give it a URL, you can call the `checkForUpdates` method. It’s event-driven, so you can subscribe to the `update-downloaded` event, for example, and once it’s fired, call the `restartAndInstall` method to install the new version and restart the app. You can listen for a few other events, which you can use to tie the auto-updating functionality into your user interface nicely.

*Note*: You can have multiple update channels if you want, such as Google Chrome and Google Chrome Canary.

It’s not quite as simple behind the API. It’s based on the Squirrel update framework, which differs drastically between Mac and Windows, which use the [Squirrel.Mac](https://github.com/Squirrel/Squirrel.Mac) and [Squirrel.Windows](https://github.com/Squirrel/Squirrel.Windows) projects, respectively.

The update code within your Mac Electron app is simple, but you’ll need a server (albeit a simple server). When you call the autoUpdater module’s `checkForUpdates` method, it will hit your server. What your server needs to do is return a 204 (“No Content”) if there isn’t an update; and if there is, it needs to return a 200 with a JSON containing a URL pointing to a `.zip` file. Back under the hood of your app (or the client), Squirrel.Mac will know what to do. It’ll go get that `.zip`, unzip it and fire the appropriate events.

There a bit more (magic) going on in your Windows app when it comes to automatic updates. You won’t need a server, but you can have one if you’d like. You could host the static (update) files somewhere, such as AWS S3, or even have them locally on your machine, which is really handy for testing. Despite the differences between Squirrel.Mac and Squirrel.Windows, a happy medium can be found; for example, having a server for both, and storing the updates on S3 or somewhere similar.

Squirrel.Windows has a couple of nice features over Squirrel.Mac as well. It applies updates in the background; so, when you call `restartAndInstall`, it’ll be a bit quicker because it’s ready and waiting. It also supports delta updates. Let’s say your app checks for updates and there is one newer version. A binary diff (between the currently installed app and the update) will be downloaded and applied as a patch to the current executable, instead of replacing it with a whole new app. It can even do that incrementally if you’re, say, three versions behind, but it will only do that if it’s worth it. Otherwise, if you’re, say, 15 versions behind, it will just download the latest version in its entirety instead. The great thing is that all of this is done under the hood for you. The API remains really simple. You check for updates, it will figure out the optimal method to apply the update, and it will let you know when it’s ready to go.

*Note*: You will have to generate those binary diffs, though, and host them alongside your standard updates. Thankfully, electron-builder generates these for you, too.

Thanks to the Electron community, you don’t have to build your own server if you don’t want to. There are open-source projects you can use. Some allow you to [store updates on S3](https://github.com/ArekSredzki/electron-release-server) or use [GitHub releases](https://github.com/GitbookIO/nuts), and some even go as far as [providing administrative dashboards](https://github.com/ArekSredzki/electron-release-server) to manage the updates.

### Desktop Versus Web

So, how does making a desktop app differ from making a web app? Let’s look at a few unexpected problems or gains you might come across along the way, some unexpected side effects of APIs you’re used to using on the web, workflow pain points, maintenance woes and more.

Well, the first thing that comes to mind is browser lock-in. It’s like a guilty pleasure. If you’re making a desktop app exclusively, you’ll know exactly which Chromium version all of your users are on. Let your imagination run wild; you can use flexbox, ES6, pure WebSockets, WebRTC, anything you want. You can even enable experimental features in Chromium for your app (i.e. features coming down the line) or tweak settings such as your localStorage allowance. You’ll never have to deal with any cross-browser incompatibilities. This is on top of Node.js’ APIs and all of npm. You can do anything.

*Note*: You’ll still have to consider which operating system the user is running sometimes, though, but OS-sniffing is a lot more reliable and less frowned upon than browser sniffing.

#### Working With file://

Another interesting thing is that your app is essentially offline-first. Keep that in mind when creating your app; a user can launch your app without a network connection and your app will run; it will still load the local files. You’ll need to pay more attention to how your app behaves if the network connection is lost while it’s running. You may need to adjust your mindset.

*Note*: You can load remote URLs if you really want, but I wouldn’t.

One tip I can give you here is not to trust [`navigator.onLine`](https://developer.mozilla.org/en-US/docs/Web/API/NavigatorOnLine/onLine) completely. This property returns a Boolean indicating whether or not there’s a connection, but watch out for false positives. It’ll return `true` if there’s any local connection without validating that connection. The Internet might not actually be accessible; it could be fooled by a dummy connection to a Vagrant virtual machine on your machine, etc. Instead, use Sindre Sorhus’ [`is-online`](https://github.com/sindresorhus/is-online) module to double-check; it will ping the Internet’s root servers and/or the favicon of a few popular websites. For example:

```
const isOnline = require('is-online');

if(navigator.onLine){
  // hmm there's a connection, but is the Internet accessible?
  isOnline().then(online => {
    console.log(online); // true or false
  });
}
else {
  // we can trust navigator.onLine when it says there is no connection
  console.log(false);
}
```

Speaking of local files, there are a few things to be aware of when using the `file://` protocol — protocol-less URLs, for one; you can’t use them anymore. I mean URLs that start with `//` instead of `http://` or `https://`. Typically, if a web app requests `//example.com/hello.json`, then your browser would expand this to `http://example.com/hello.json` or to `https://example.com/hello.json` if the current page is loaded over HTTPS. In our app, the current page would load using the `file://` protocol; so, if we requested the same URL, it would expand to `file://example.com/hello.json` and fail. The real worry here is third-party modules you might be using; authors aren’t thinking of desktop apps when they make a library.

You’d never use a CDN. Loading local files is basically instantaneous. There’s also no limit on the number of concurrent requests (per domain), like there is on the web (with HTTP/1.1 at least). You can load as many as you want in parallel.

#### Artifacts Galore

A lot of asset generation is involved in creating a solid desktop app. You’ll need to generate executables and installers and decide on an auto-update system. Then, for each update, you’ll have to build the executables again, more installers (because if someone goes to your website to download it, they should get the latest version) and binary diffs for delta updates.

Weight is still a concern. A “Hello, World!” Electron app is 40 MB zipped. Besides the typical advice you follow when creating a web app (write less code, minify it, have fewer dependencies, etc.), there isn’t much I can offer you. The “Hello, World!” app is literally an app containing one HTML file; most of the weight comes from the fact that Chromium and Node.js are baked into your app. At least delta updates will reduce how much is downloaded when a user performs an update (on Windows only, I’m afraid). However, your users won’t be downloading your app on a 2G connection (hopefully!).

#### Expect the Unexpected

You will discover unexpected behavior now and again. Some of it is more obvious than the rest, but a little annoying nonetheless. For example, let’s say you’ve made a music player app that supports a mini-player mode, in which the window is really small and always in front of any other apps. If a user were to click or tap a dropdown (`<select/>`), then it would open to reveal its options, overflowing past the bottom edge of the app. If you were to use a non-native select library (such as select2 or chosen), though, you’re in trouble. When open, your dropdown will be cut off by the edge of your app. So, the user would see a few items and then nothing, which is really frustrating. This would happen in a web browser, too, but it’s not often the user would resize the window down to a small enough size.

![Screenshots comparing what happens to a native dropdown versus a non-native one](https://www.smashingmagazine.com/wp-content/uploads/2017/01/dropdownComparison-preview-opt.png)

You may or may not know it, but on a Mac, every window has a header and a body. When a window isn’t focused, if you hover over an icon or button in the header, its appearance will reflect the fact that it’s being hovered over. For example, the close button on macOS is gray when the window is blurred but red when you hover over it. However, if you move your mouse over something in the body of the window, there is no visible change. This is intentional. Think about your desktop app, though; it’s Chromium missing the header, and your app is the web page, which is the body of the window. You could drop the native frame and create your own custom HTML buttons instead for minimize, maximize and close. If your window isn’t focused, though, they won’t react if you were to hover over them. Hover styles won’t be applied, and that feels really wrong. To make it worse, if you were to click the close button, for example, it would focus the window and that’s it. A second click would be required to actually click the button and close the app.

To add insult to injury, Chromium has a bug that can mask the problem, making you think it works as you might have originally expected. If you move your mouse fast enough (nothing too unreasonable) from outside the window to an element inside the window, hover styles will be applied to that element. It’s a confirmed bug; applying the hover styles on a blurred window body “doesn’t meet platform expectations,” so it will be fixed. Hopefully, I’m saving you some heartbreak here. You could have a situation in which you’ve created beautiful custom window controls, yet in reality a lot of your users will be frustrated with your app (and will guess it’s not native).

So, you must use native buttons on a Mac. There’s no way around that. For an NW.js app, you must enable the native frame, which is the default anyway (you can disable it by setting `window` object’s `frame` property to `false` in your `package.json`).

You could do the same with an Electron app. This is controlled by setting the `frame` property when creating a window; for example, `new BrowserWindow({width: 800, height: 600, frame: true})`. As the Electron team does, they spotted this issue and added another option as a nice compromise; `titleBarStyle`. Setting this to `hidden` will hide the native title bar but keep the native window controls overlaid over the top-left corner of your app. This gets you around the problem of having non-native buttons on Mac, but you can still style the top of the app (and the area behind the buttons) however you like.

```
// main.js
const {app, BrowserWindow} = require('electron');
let mainWindow;

app.on('ready', () => {
  mainWindow = new BrowserWindow({
    width: 500,
    height: 400,
    titleBarStyle: 'hidden'
  });
  mainWindow.loadURL('file://' + __dirname + '/index.html');
});
```

Here’s an app in which I’ve disabled the title bar and given the `html` element a background image:

![A screenshot of our example app without the title bar](https://www.smashingmagazine.com/wp-content/uploads/2017/01/hiddenTitleBar-preview-opt.png)

See “[Frameless Window](http://electron.atom.io/docs/api/frameless-window)[57](#57)” from Electron’s documentation for more.

#### Tooling

Well, you can pretty much use all of the tooling you’d use to create a web app. Your app is just HTML, CSS and JavaScript, right? Plenty of plugins and modules are out there specifically for desktop apps, too, such as Gulp plugins for signing your app, for example (if you didn’t want to use electron-builder). [Electron-connect](https://github.com/Quramy/electron-connect) watches your files for changes, and when they occur, it’ll inject those changes into your open window(s) or relaunch the app if it was your main script that was modified. It is Node.js, after all; you can pretty much do anything you’d like. You could run webpack inside your app if you wanted to — I’ve no idea why you would, but the options are endless. Make sure to check out [awesome-electron](https://github.com/sindresorhus/awesome-electron) for more resources.

#### Release Flow

What’s it like to maintain and live with a desktop app? First of all, the release flow is completely different. A significant mindset adjustment is required. When you’re working on the web app and you deploy a change that breaks something, it’s not really a huge deal (of course, that depends on your app and the bug). You can just roll out a fix. Users who reload or change the page and new users who trickle in will get the latest code. Developers under pressure might rush out a feature for a deadline and fix bugs as they’re reported or noticed. You can’t do that with desktop apps. You can’t take back updates you push out there. It’s more like a mobile app flow. You build the app, put it out there, and you can’t take it back. Some users might not even update from a buggy version to the fixed version. This will make you worry about all of the bugs out there in old versions.

#### Quantum Mechanics

Because a host of different versions of your app are in use, your code will exist in multiple forms and states. Multiple variants of your client (desktop app) could be hitting your API in 10 slightly different ways. So, you’ll need to strongly consider versioning your API, really locking down and testing it well. When an API change is to be introduced, you might not be sure if it’s a breaking change or not. A version released a month ago could implode because it has some slightly different code.

#### Fresh Problems to Solve

You might receive a few strange bug reports — ones that involve bizarre user account arrangements, specific antivirus software or worse. I had a case in which a user had installed something (or had done something themselves) that messed with their system’s environment variables. This broke our app because a dependency we used for something critical failed to execute a system command because the command could no longer be found. This is a good example because there will be occasions when you’ll have to draw a line. This was something critical to our app, so we couldn’t ignore the error, and we couldn’t fix their machine. For users like this, a lot of their desktop apps would be somewhat broken at best. In the end, we decided to show a tailored error screen to the user if this unlikely error were ever to pop up again. It links to a document explaining why it has occurred and has a step-by-step guide to fix it.

Sure, a few web-specific concerns are no longer applicable when you’re working on a desktop app, such as legacy browsers. You will have a few new ones to take into consideration, though. There’s a 256-character limit on file paths in Windows, for example.

Old versions of npm store dependencies in a recursive file structure. Your dependencies would each get stored in their own directory within a `node_modules` directory in your project (for example, `node_modules/a`). If any of your dependencies have dependencies of their own, those grandchild dependencies would be stored in a `node_modules` within that directory (for example, `node_modules/a/node_modules/b`). Because Node.js and npm encourage small single-purpose modules, you could easily end up with a really long path, like `path/to/your/project/node_modules/a/node_modules/b/node_modules/c/.../n/index.js`.

*Note*: Since version 3, npm flattens out the dependency tree as much as possible. However, there are other causes for long paths.

We had a case in which our app wouldn’t launch at all (or would crash soon after launching) on certain versions of Windows due to an exceeding long path. This was a major headache. With Electron, you can put all of your app’s code into an [asar archive](http://electron.atom.io/docs/tutorial/application-packaging/), which protects against path length issues but has exceptions and can’t always be used.

We created a little Gulp plugin named [gulp-path-length](https://github.com/Teamwork/gulp-path-length), which lets you know whether any dangerously long file paths are in your app. Where your app is stored on the end user’s machine will determine the true length of the path, though. In our case, our installer will install it to `C:\Users\<username>\AppData\Roaming`. So, when our app is built (locally by us or by a continuous integration service), gulp-path-length is instructed to audit our files as if they’re stored there (on the user’s machine with a long username, to be safe).

```
var gulp = require('gulp');
var pathLength = require('gulp-path-length');

gulp.task('default', function(){
    gulp.src('./example/**/*', {read: false})
        .pipe(pathLength({
	        rewrite: {
		        match: './example',
		        replacement: 'C:\\Users\\this-is-a-long-username\\AppData\\Roaming\\Teamwork Chat\\'
	        }
        }));
});
```

#### Fatal Errors Can Be Really Fatal

Because all of the automatic updates handling is done within the app, you could have an uncaught exception that crashes the app before it even gets to check for an update. Let’s say you discover the bug and release a new version containing a fix. If the user launches the app, an update would start downloading, and then the app would die. If they were to relaunch app, the update would start downloading again and… crash. So, you’d have to reach out to all of your users and let them know they’ll need to reinstall the app. Trust me, I know. It’s horrible.

#### Analytics and Bug Reports

You’ll probably want to track usage of the app and any errors that occur. First of all, Google Analytics won’t work (out of the box, at least). You’ll have to find something that doesn’t mind an app that runs on `file://` URLs. If you’re using a tool to track errors, make sure to lock down errors by app version if the tool supports release-tracking. For example, if you’re using [Sentry](https://sentry.io/welcome/) to track errors, make sure to [set the `release` property when setting up your client](https://docs.sentry.io/clients/javascript/config/#optional-settings), so that errors will be split up by app version. Otherwise, if you receive a report about an error and roll out a fix, you’ll keep on receiving reports about the error, filling up your reports or logs with false positives. These errors will be coming from people using older versions.

Electron has a [`crashReporter`](http://electron.atom.io/docs/api/crash-reporter/) module, which will send you a report any time the app completely crashes (i.e. the entire app dies, not for any old error thrown). You can also listen for events indicating that your renderer process has become unresponsive.

#### Security

Be extra-careful when accepting user input or even trusting third-party scripts, because a malicious individual could have a lot of fun with access to Node.js. Also, never accept user input and pass it to a native API or command without proper sanitation.

Don’t trust code from vendors either. We had a problem recently with a third-party snippet we had included in our app for analytics, provided by company X. The team behind it rolled out an update with some dodgy code, thereby introducing a fatal error in our app. When a user launched our app, the snippet grabbed the newest JavaScript from their CDN and ran it. The error thrown prevented anything further from executing. Anyone with the app already running was unaffected, but if they were to quit it and launch it again, they’d have the problem, too. We contacted X’s support team and they promptly rolled out a fix. Our app was fine again once our users restarted it, but it was scary there for a while. We wouldn’t have been able to patch the problem ourselves without forcing affected users to manually download a new version of the app (with the snippet removed).

How can you mitigate this risk? You could try to catch errors, but you’ve no idea what they company X might do in its JavaScript, so you’re better off with something more solid. You could add a level of abstraction. Instead of pointing directly to X’s URL from your `<script>`, you could use [Google Tag Manager](https://www.google.ie/analytics/tag-manager/) or your own API to return either HTML containing the `<script>` tags or a single JavaScript file containing all of your third-party dependencies somehow. This would enable you to change which snippets get loaded (by tweaking Google Tag Manager or your API endpoint) without having to roll out a new update.

However, if the API no longer returned the analytics snippet, the global variable created by the snippet would still be there in your code, trying to call undefined functions. So, we haven’t solved the problem entirely. Also, this API call would fail if a user launches the app without a connection. You don’t want to restrict your app when offline. Sure, you could use a cached result from the last time the request succeeded, but what if there was a bug in that version? You’re back to the same problem.

Another solution would be to create a hidden window and load a (local) HTML file there that contains all of your third-party snippets. So, any global variables that the snippets create would be scoped to that window. Any errors thrown would be thrown in that window and your main window(s) would be unaffected. If you needed to use those APIs or global variables in your main window(s), you’d do this via IPC now. You’d send an event over IPC to your main process, which would then send it onto the hidden window, and if it was still healthy, it would listen for the event and call the third-party function. That would work.

This brings us back to security. What if someone malicious at company X were to include some dangerous Node.js code in their JavaScript? We’d be rightly screwed. Luckily, Electron has a nice option to disable Node.js for a given window, so it simply wouldn’t run:

```
// main.js
const {app, BrowserWindow} = require('electron');
let thirdPartyWindow;

app.on('ready', () => {
  thirdPartyWindow = new BrowserWindow({
    width: 500,
    height: 400,
    webPreferences: {
      nodeIntegration: false
    }
  });
  thirdPartyWindow.loadURL('file://' + __dirname + '/third-party-snippets.html');
});
```

#### Automated Testing

NW.js doesn’t have any built-in support for testing. But, again, you have access to Node.js, so it’s technically possible. There is a way to test stuff such as button-clicking within the app using [Chrome Remote Interface](https://github.com/cyrus-and/chrome-remote-interface), but it’s tricky. Even then, you can’t trigger a click on a native window control and test what happens, for example.

The Electron team has created [Spectron](http://electron.atom.io/spectron/) for automated testing, and it supports testing native controls, managing windows and simulating Electron events. It can even be run in continuous integration builds.

```
var Application = require('spectron').Application
var assert = require('assert')

describe('application launch', function () {
  this.timeout(10000)

  beforeEach(function () {
    this.app = new Application({
      path: '/Applications/MyApp.app/Contents/MacOS/MyApp'
    })
    return this.app.start()
  })

  afterEach(function () {
    if (this.app && this.app.isRunning()) {
      return this.app.stop()
    }
  })

  it('shows an initial window', function () {
    return this.app.client.getWindowCount().then(function (count) {
      assert.equal(count, 1)
    })
  })
})
```

Because your app is HTML, you could easily use any tool to test web apps, just by pointing the tool at your static files. However, in this case, you’d need to make sure the app can run in a web browser without Node.js.

### Desktop And Web

It’s not necessarily about desktop or web. As a web developer, you have all of the tools required to make an app for either environment. Why not both? It takes a bit more effort, but it’s worth it. I’ll mention a few related topics and tools, which are complicated in their own right, so I’ll keep just touch on them.

First of all, forget about “browser lock-in,” native WebSockets, etc. The same goes for ES6. You can either revert to writing plain old ES5 JavaScript or use something like [Babel](https://babeljs.io/) to transpile your ES6 into ES5, for web use.

You also have `require`s throughout your code (for importing other scripts or modules), which a browser won’t understand. Use a module bundler that supports CommonJS (i.e. Node.js-style `require`s), such as [Rollup](http://rollupjs.org), [webpack](https://webpack.github.io) or [Browserify](http://browserify.org). When making a build for the web, a module bundler will run over your code, traverse all of the `require`s and bundle them up into one script for you.

Any code using Node.js or Electron APIs (i.e. to write to disk or integrate with the desktop environment) should not be called when the app is running on the web. You can detect this by checking whether `process.version.nwjs` or `process.versions.electron` exists; if it does, then your app is currently running in the desktop environment.

Even then, you’ll be loading a lot of redundant code in the web app. Let’s say you have a `require` guarded behind a check like `if(app.isInDesktop)`, along with a big chunk of desktop-specific code. Instead of detecting the environment at runtime and setting `app.isInDesktop`, you could pass `true` or `false` into your app as a flag at buildtime (for example, using the [envify](https://github.com/hughsk/envify) transform for Browserify). This will aide your module bundler of choice when it’s doing its static analysis and tree-shaking (i.e. dead-code elimination). It will now know whether `app.isInDesktop` is `true`. So, if you’re running your web build, it won’t bother going inside that `if` statement or traversing the `require` in question.

#### Continuous Delivery

There’s that release mindset again; it’s challenging. When you’re working on the web, you want to be able to roll out changes frequently. I believe in continually delivering small incremental changes that can be rolled back quickly. Ideally, with enough testing, an intern can push a little tweak to your master branch, resulting in your web app being automatically tested and deployed.

As we covered earlier, you can’t really do this with a desktop app. OK, I guess you technically could if you’re using Electron, because electron-builder can be automated and, so, can spectron tests. I don’t know anyone doing this, and I wouldn’t have enough faith to do it myself. Remember, broken code can’t be taken back, and you could break the update flow. Besides, you don’t want to deliver desktop updates too often anyway. Updates aren’t silent, like they are on the web, so it’s not very nice for the user. Plus, for users on macOS, delta updates aren’t supported, so users would be downloading a full new app for each release, no matter how small a tweak it has.

You’ll have to find a balance. A happy medium might be to release all fixes to the web as soon as possible and release a desktop app weekly or monthly — unless you’re releasing a feature, that is. You don’t want to punish a user because they chose to install your desktop app. Nothing’s worse than seeing a press release for a really cool feature in an app you use, only to realize that you’ll have to wait a while longer than everyone else. You could employ a feature-flags API to roll out features on both platforms at the same time, but that’s a whole separate topic. I first learned of feature flags from “[Continuous Delivery: The Dirty Details](https://www.youtube.com/watch?v=JR-ccCTmMKY),” a talk by Etsy’s VP of Engineering, Mike Brittain.

### Conclusion

So, there you have it. With minimal effort, you can add “desktop app developer” to your resumé. We’ve looked at creating your first modern desktop app, packaging, distribution, after-sales service and a lot more. Hopefully, despite the pitfalls and horror stories I’ve shared, you’ll agree that it’s not as scary as it seems. You already have what it takes. All you need to do is look over some API documentation. Thanks to a few new powerful APIs at your disposal, you can get the most value from your skills as a web developer. I hope to see you around (in the NW.js or Electron community) soon.

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
