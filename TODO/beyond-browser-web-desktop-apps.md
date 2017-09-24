> * 原文地址：[Beyond The Browser: From Web Apps To Desktop Apps](https://www.smashingmagazine.com/2017/03/beyond-browser-web-desktop-apps/)
> * 原文作者：本文已获原作者 [Adam Lynch](https://www.smashingmagazine.com/author/adamlynch/) 授权
> * 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
> * 译者： [bambooom](https://github.com/bambooom)、[imink](https://github.com/imink)
> * 校对者：[bambooom](https://github.com/bambooom)、[imink](https://github.com/imink)、[sunui](https://github.com/sunui)

## 超越浏览器：从 web 应用到桌面应用

一开始我是个 web 开发者，现在我是个全栈开发者，但从未想过在桌面上有所作为。我热爱 web 技术，热爱这个无私的社区，热爱它对于开源的友好，尝试挑战极限。我热爱探索好看的网站和强大的应用。当我被指派做桌面应用任务的时候，我非常忧虑和害怕，因为那看起来很难，或者至少不一样。

这并不吸引人，对吧？你需要学一门新的语言，甚至三门？想象一下过时的工作流，古旧的工具，没有任何你喜欢的有关 web 的一切。你的职业发展会被怎样影响呢？

别慌，深呼吸，现实情况是，作为 web 开发者，你已经拥有开发现代桌面应用所需的一切技能，得益于新的强大的 API，你甚至可以在桌面应用中发挥你最大的潜能。

本文将会介绍使用 [NW.js](http://nwjs.io/) 和 [Electron](https://electron.atom.io/) 开发桌面应用，包括它们的优劣，以及如何使用同一套代码库来开发桌面、web 应用，甚至更多。

### 为什么？

首先，为什么会有人开发桌面应用？任何现有的 web 应用（不同于网站，如果你认为它们是不同的）都可能适合变成一个桌面应用。你可以围绕任何可以从与用户系统集成中获益的 web 应用构建桌面应用；例如本地通知、开机启动、与文件的交互等。有些用户单纯更喜欢在自己的电脑中永久保存一些 app，无论是否联网都可以访问。

也许你有个想法，但只能用作桌面应用，有些事情只是在 web 应用中不可能实现（至少还有一点，但更多的是这一点）。你可能想要为公司内部创建一个独立的功能性应用程序，而不需要任何人安装除了你的 app 之外的任何内容（因为内置 Node.js ）。也许你有个有关 Mac 应用商店的想法，也许只是你的一个个人兴趣的小项目。

很难总结为什么你应该考虑开发桌面应用，因为真的有很多类型的应用你可以创建。这非常取决于你想要达到什么目的，API 是否足够有利于开发，离线使用将多大程度上增强用户体验。在我的团队，这些都是毋庸置疑的，因为我们在开发一个[聊天应用程序](https://teamwork.com/chat)。另一方面来说，一个依赖于网络而没有任何与系统集成的桌面应用应该做成一个 web 应用，并且只做 web 应用。当用户并不能从桌面应用中获得比在浏览器中访问一个网址更多的价值的时候，期待用户下载你的应用（其中自带浏览器以及 Node.js）是不公平的。

比起描述你个人应该建造的桌面应用及其原因，我更希望的是激发一个想法，或者只是激发你对这篇文章的兴趣。继续往下读来看看用 web 技术构造一个强大的桌面应用是多么简单，以及在创建过程中你应该付出什么。

### NW.js

桌面应用已经有很长一段时间了，我知道你没有很多时间，所以我们跳过一些历史，从 2011 年的上海开始。来自 Intel 开源技术中心的 Roger Wang 开发了 node-webkit，一个概念验证的 Node.js 模块，这个模块可以让用户创建一个 WebKit 内核的浏览器窗口并直接在 `<script>` 中调用 Node.js 模块。

经过一段时间的开发以及将内核从 WebKit 转换到 Chromium（Google Chrome 基于这个开源项目开发），一个叫 Cheng Zhao 的实习生加入了这个项目。不久就有人意识到一个基于 Node.js 和 Chromium 运行的应用是一个很好的建造桌面应用的框架。于是这个项目变得颇受欢迎。

*注意*：node-webkit 后来更名为 NW.js，是因为项目不再使用 Node.js 以及 WebKit，所以需要改一个更通用的名字。Node.js 的替换选择是 io.js （Node.js fork 版本），Chromium 也已经从 WebKit 转为它自己的版本 —— Blink。

所以，如果现在去下载一个 NW.js 应用，实际上是下载了 Chromium、Node.js，以及真正的 app 的代码。这不仅意味着桌面应用也可以使用 HTML、CSS、JavaScript 来写，也意味着 app 可以直接使用所有 Node.js 的 API（比如读取或写入硬盘），而对于终端用户，没有比这更好的选择了。这看起来非常强大，但是它是怎么实现的呢？我们先来了解一下 Chromium。

![Chromium diagram](https://www.smashingmagazine.com/wp-content/uploads/2017/01/chromiumDiagram-preview-opt.png)

Chromium 有一个主要的后台进程，每个标签页也会有自己的进程。你可能注意到 Google Chrome 在 Windows 的任务管理器或者 macOS 的活动监视器上总是至少存在两个进程。我并没有尝试在这里安排穿插主后台进程相关的内容，但是它包括了 Blink 渲染引擎、V8 JavaScript 引擎（也构建了 Node.js ）以及一些从原生 API 抽象出来的平台 API。每个独立的标签页或渲染的过程都可以使用 JavaScript 引擎、CSS 解析器等，但为了提高容错性，它们又和主进程是完全隔离的。渲染进程与主进程之间是用进程间通信（IPC）来进行通讯。

![NW.js diagram](https://www.smashingmagazine.com/wp-content/uploads/2017/01/nwjsDiagram-preview-opt.png)



大致上这就是一个 NW.js app 的结构，它和 Chromium 基本一致，除了每个窗口也可以访问 Node.js。现在，你可以访问 DOM，可以访问其他脚本、npm 安装的模块，或者 NW.js 提供的内置的模块。你的 app 默认只有一个窗口，但从这一个窗口，可以生成其他窗口。

创建一个应用很简单，只需要一个 HTML 文件和一个 `package.json` 文件，就像你平时使用 Node.js 时那样。你可以使用 `npm init --yes` 新建一个默认的。一般来说，`package.json` 会指定一个 JavaScript 文件作为模块的入口（也就是使用 `main` 属性），但是如果是 NW.js，你需要去编辑一下 `main` 指向你的 HTML 文件。

```json
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

```html
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

你可以凭自己喜好去掉窗口栏，构建自己的框架模板。你可以有半透明或全透明的窗口，可以有隐藏窗口或者更多。我最近尝试使用 NW.js 做了[Clippy](http://engineroom.teamwork.com/resurrecting-clippy/)（Office 助手）。能在 macOS 和 Windows 10 上看到它有种奇妙的满足感。

![Screenshot of clippy.desktop on macOS](https://www.smashingmagazine.com/wp-content/uploads/2017/01/clippy-preview-opt.png)

现在你可以写 HTML，CSS 和 JavaScript 了，你可以使用 Node.js 读写硬盘、执行系统命令、生成其他可执行文件等等。设想一下，你甚至可以通过 WebRTC 造一个多玩家的轮盘赌游戏，随机删除其他人的文件。

![Bar graph showing the number of modules per major package manager](https://www.smashingmagazine.com/wp-content/uploads/2017/01/moduleCounts-preview-opt.png)

你不仅可以使用 Node.js 的 API，还有所有 npm 的包，现在已经有超过 35 万个了。例如，[auto-launch](https://github.com/Teamwork/node-auto-launch) 是我们在 [Teamwork.com](https://www.teamwork.com/) 做的开源包，用来开机启动 NW.js 或者 Electron 应用。

如果你需要做一些偏底层的事，Node.js 也有原生的模块，能让你使用 C 或者 C++ 创建模块。

总之，NW.js 高效封装了原生的 API，让你可以简单地与桌面环境集成。比如你有一个任务栏图标，使用系统默认应用打开一个文件或者 URL 之类的。你需要做的是使用 HTML5 notification 的 API 触发一个通知：

```javascript
new Notification('Hello', {
  body: 'world'
});
```

### Electron

你可能认出来了，下图是 GitHub 开发的编辑器，Atom。不管你是否使用 Atom，它的出现对于桌面应用都是一个颠覆者。GitHub 从 2013 年开始开发 Atom，后来 Cheng Zhao 加入，fork 了 node-webkit 作为基础，后来以 atom-shell 为名开源。

![Atom screenshot](https://www.smashingmagazine.com/wp-content/uploads/2017/01/atom-preview-opt.png)

*注意*：对于 Electron 只是 node-webkit 的 fork，还是一切从头重新做的，是很有争议的。但无论哪种方式，最终都成为终端用户的一个分支，因为 API 几乎完全一致。

在开发 Atom 的过程中，GitHub 改进了一些方案，也解决了很多 bug。2015年，atom-shell 正式更名为 Electron。它的版本已经更新到 1.0 以上（译注：最新正式版本为v1.3.14），并且因为 GitHub 的推行，它已经真正发展壮大了。

![Logos of projects that use Electron](https://www.smashingmagazine.com/wp-content/uploads/2017/01/logos-preview-opt.png)

和 Atom 一样，其他用 Electron 开发的有名项目包括 [Slack](https://slack.com/)、[Visual Studio Code](https://code.visualstudio.com/)、 [Brave](https://www.brave.com/)、[HyperTerm](https://hyper.is/)、[Nylas](https://www.nylas.com/)，真的是在做着一些尖端的东西。Mozilla Tofino 也是其中很有趣的一个，它是 Mozilla（ FireFox 的公司）的一个内部项目，目标是彻底优化浏览器。你没看错，Mozilla 的团队选择了 Electron （基于 Chromium ）来做这个实验。

### Electron 有什么不同呢？

那么 Electron 和 NW.js 有什么不同？首先，Electron 没有 NW.js 那么面向浏览器，Electron app 的入口是一个在主进程中运行的脚本。

![Electron architecture diagram](https://www.smashingmagazine.com/wp-content/uploads/2017/01/electronDiagram-preview-opt-1.png)

Electron 团队修补了 Chromium 以便嵌入多个可以同时运行的 JavaScript 引擎，所以当 Chromium 发布新版本的时候，他们不需要做任何事。

*注意*：NW.js 与 Chromium 的绑定不太一样，造成了 NW.js 经常被指责不如 Electron 那样紧跟 Chromium。然而，整个 2016 年，NW.js 每次在 Chromium 发布主要版本之后的 24 小时内发布新版本，这很大程度也归功于团队组织转型。

回到主进程的话题，你的应用默认是没有窗口的，但是你可以从主进程开启任意多个窗口，每个窗口和 NW.js 一样有自己的渲染进程。

那么当然，创建一个 Electron app，你需要的只是一个 JavaScript 文件（现在暂时只是个空文件）以及一个 `package.json` 文件指向它。然后你只需要执行 `npm install --save-dev electron`，以及 `electron .` 来启动你的 app。

```json
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

没有什么会发生，因为你的 app 没有默认窗口。接下来你可以和 NW.js 应用一样打开任意多个窗口，每个都有各自的渲染进程。

```javascript
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
```html
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

你可以在这个窗口中加载远程 URL，但是一般来说你会在本地创建 HTML 文件并加载它，当当当当～加载出来啦！

![Screenshot of example Electron app](https://www.smashingmagazine.com/wp-content/uploads/2017/01/electronHelloWorld-preview-opt.png)

在 Electron 提供的内置模块中，像在前面例子中使用的 `app` 和 `BrowserWindow`，大多只能要么在主进程要么在某个渲染进程中使用。比方说，你只能在主进程中管理你的所有窗口，自动更新或者其他。你可能想在主进程中点击一个按钮触发一些事件，因此 Electron 为 IPC 提供了一些内置方法。基本上你可以触发任意的事件，然后在另一端监听它们。这样，你就可以在某一个渲染进程中捕获 `click` 事件，通过 IPC 发出事件信息给主进程，主进程捕获后执行相关操作。

Electron 有着不同的进程，你需要稍微不同地组织你的 app，但这不算什么。为什么人们使用 Electron 而不是 NW.js？这其中有影响力的因素，它的流行造就了许多相关的工具和模块。 Electron 的文档更好懂，最重要的是，Electron 的 bug 更少，并且有更好的 API。

Electron 的文档非常棒，这值得再强调一下。拿 [Electron API Demos app](https://github.com/electron/electron-api-demos) 来说，这是个 Electron app，它可以交互式的演示出你可通过 Electron 的 API 做到什么。比如新建窗口，它不仅提供了 API 的描述以及示例代码，甚至点击按钮的确可以执行代码并打开新的窗口。（下图就是 Electron API Demos app 的截图）

![A screenshot of the Electron API Demos app](https://www.smashingmagazine.com/wp-content/uploads/2017/01/apiDemosApp-preview-opt.png)

如果你通过 Electron 的 bug 追踪器提交问题，你可以在几天之内得到回复。我曾经见过 NW.js 有经过三年都未修复的 bug，我并不是坚决反对他们这么做，开发开源项目采用的语言和使用这个项目的开发者了解的语言如此的不同，是非常难维护的。NW.js 和 Electron 主要是用 C++ （以及少部分 Objective C++）写的，但是使用这两个项目的人写的是 JavaScript。我非常感激 NW.js 给我们的帮助。

Electron 弥补了 NW.js API 上的一些不足。比如，你可以绑定全局的键盘快捷键，这样即使你的 app 并没有获取焦点，键盘事件也可以被捕获。曾经我在 NW.js 的应用中碰到过一个 API 的漏洞，就是我在 Windows 上可以绑定 `Control + Shift + A` 快捷键达到预期目的，但是实际上到了 Mac 上绑定的快捷键是 `Command + Shift + A`，这个的确是有意而为之的，但是仍然很奇怪。没有任何方法可以在 Mac 上绑定 `Control` 键。另外，如果想绑定 `Command` 键，在 Mac 上的确没问题，而到了 Windows 和 Linux 上绑定的却是 `Windows` 键。Electron 的团队发现了这些问题（我猜是在给 Atom 添加快捷键的时候），然后他们很快更新了他们自己的全局快捷键（globalShortcut）API，以上遇到的情况就可以正常工作了。公平起见，NW.js 修复了前一个问题，但一直没有修复后一个。

还有其他一些不同的地方。比如说，之前原生的 notification 通知，在最近的 NW.js 版本中，变成了 Chrome 风格的了。这种通知不会进入到 Mac OS X 或者 Windows 10 的通知中心里面，但是在 npm 上有方便使用的模块解决。如果你想做一些有趣的有关音频或视频的东西，建议使用 Electron，因为有些解码器和 NW.js 不兼容。

Electron 还添加了一些新的 API，更加多地与桌面端的集成，并且内置了自动升级，我稍后会谈到。

### 但是感觉如何呢？

感觉很好，当然，它并不是原生的。现在大多数桌面应用并不会长得像资源管理器或者 Finder，所以用户并不介意或者意识到用户界面背后是 HTML。你愿意的话，你可以使之更像原生应用，但是我并不认为那样会让用户体验更好。比如，你可以在用户将鼠标悬停在按钮上时，不让光标变成手，一般原生的桌面应用都是这样做的，但是这样做有什么好的吗？当然也有像 [Photon Kit](http://photonkit.com/) 这样的类似 Bootstrap 的 CSS 框架，可以做出 macOS 风格的组件。（下图是 Photon Kit 做出的组件 demo）

![Photon app example screenshot](https://www.smashingmagazine.com/wp-content/uploads/2017/01/photon-preview-opt.png)

### 性能

性能表现如何呢？会很慢或者延迟吗？其实你的 app 本质上来说仍然是 web 应用，所以它会和在 Google Chrome 中运行的 web app 非常类似。你可能会创造出高性能的或者反应迟缓的 app，但是没关系，你已经有分析并提升性能的技能了。app 基于 Chromium 最好的其中一点就是你可以使用它的开发者工具。你可以在 app 内调试或者远程调试，Electron 团队也开发了一款开发者工具的插件叫 [Devtron](http://electron.atom.io/devtron/) 来监控一些 Electron 特定的信息。

不过，你的桌面应用可以比 web 应用的性能更高。因为你可以创建一个工作窗口，一个用于执行耗能昂贵工作的隐藏窗口。因为每个进程都是孤立的，所以任何在这个窗口中进行的计算或者处理不会影响到其他可见窗口的渲染进程，上下滚动等等。

记住你总可以生成系统指令、可执行文件，或者原生代码，如果真的需要的话（你不会真的这么做的）。

### 分发

NW.js 和 Electron 都支持很多平台，包括 Windows，Mac 和 Linux。Electron 不支持 Windows XP 和 Vista，但 NW.js 支持。将 NW.js 应用上线到 Mac App Store 有些棘手，你必须绕几个弯子。而 Electron 支持直接的 Mac App Strore 兼容的版本，和普通的版本一样，只是某些模块你无法访问，比如自动更新（因为你的 app 会通过 Mac App Store 进行更新所以可以接受）。

Electron 甚至支持 ARM 版本，所以你的 app 可以在 Chromebook 或者树莓派上运行，最终，Google 可能会[逐步淘汰 Chrome 封装应用 （Packaged App）](https://blog.chromium.org/2016/08/from-chrome-apps-to-web.html)，但是 NW.js 仍然支持将应用程序移植到 NW.js 应用，并且仍然可以访问相同的 Chromium API。

虽然 32 位和 64 位的版本都支持，所以你完全可以使用 64 位的 Mac 和 Windows 应用。但是，为了兼容，32 位和 64 位 Linux 应用程序是都需要的。

假如 Electron 胜出，你想发行一个 Electron 应用。有一个很不错的 Node.js 包叫 [electron-packager](https://github.com/electron-userland/electron-packager) 可以帮你将 app 打包成一个 `.app` 或者 `.exe` 文件。也有其他几个类似的项目，包括交互式的一步一步告诉你该怎么做。不过，你应该用 [electron-builder](https://github.com/electron-userland/electron-builder)，它以 electron-packager 为基础，添加了其他几个相关的模块，生成的是 `.dmg` 文件和 Windows 安装包，并且为你处理好了代码签名的问题。这很重要，如果没有这一步，你的应用将会被操作系统认为是不可信的，你的应用程序可能会触发防毒软件的运行，Microsoft SmartScreen 可能会尝试阻止用户启动你的应用。

关于代码签名的令人讨厌的事情是，你必须单独为某个平台签名你的应用程序，比如在 Mac 上签名 Mac 应用，在 Windows 签名 Windows 应用。因此，如果你很在乎发行桌面应用的话，就必须为每个发行版本分别构建适用于不同平台的应用（以及分别签名）。

这可能会感到不够自动化很繁琐，特别是如果你习惯于在 web 上创建。幸运的是，electron-builder 被创造出来完成这些自动化工作。我说的是持续集成工具例如 [Jenkins](https://jenkins.io/)、[CodeShip](http://codeship.com/)、[Travis-CI](https://travis-ci.org/)、[AppVeyor](https://www.appveyor.com/)（Windows 集成）等。这些工具可以让你按一个按钮或者每次更新代码到 GitHub 时重新构建你的桌面应用。

### 自动更新

NW.js 没有支持自动更新，但是由于我们可以随意使用 Node.js，我们可以做任何事情。开源模块可以帮你实现，比如 [node-webkit-updater](https://github.com/edjafarov/node-webkit-updater) 可以下载并替换为更新版本的 app。当然你也可以自己造轮子。

通过 [autoUpdater](http://electron.atom.io/docs/api/auto-updater/) API，Electron 自带支持自动更新。但是它不支持 Linux 系统，所以我们建议发布你的 app 到 Linux 包管理器。不必担心，这在 Linux 上很常见。`autoUpdater` API 使用非常简单，给定一个 URL 就可以调用 `checkForUpdates` 方法。因为它是事件驱动，所以你可以订阅 `update-downloaded` 事件，一旦该事件触发，就调用 `restartAndInstall` 方法来下载新版本 app 并且重启。你可以监听一些其他的事件，将自动更新和用户界面很好的捆绑起来。

*注意*：你可以使用多个更新渠道，比如 Google Chrome 和 Google Chrome Canary。

API 背后的逻辑可就没这么简单了。它是基于 Squirrel 更新框架，用来区分 Mac 和 Windows 平台，对应的软件分别是 [Squirrel.Mac](https://github.com/Squirrel/Squirrel.Mac) 和 [Squirrel.Windows](https://github.com/Squirrel/Squirrel.Windows)。

Mac 上的 Electron app 和更新有关的代码非常简单，但是你还是需要一个简单的服务器。一旦你调用 autoUpdater 模块中的 `checkForUpdates` 的方法，它会访问服务器。如果没有更新，服务器返回 204（“No Content”）；如果有更新，则返回 200 和一个包含 `.zip` 文件 URL 的 JSON。再回到客户端 app，Squirrel 知道接下来该怎么做：它会下载 `.zip`，解压然后触发相应的事件。

Windows 平台上 app 的更新需要更多点功夫。你不一定需要一台服务器。你可以把静态文件部署在某些地方，比如亚马逊的 AWS S3，或者甚至放在本地机器，可以方便测试。虽然 Mac 平台上的 Squirrel 和 Windows 平台上的 Squirrel 有些不同，但是依然有折中的办法来实现更新，比如给每个平台都分别部署一个服务器，或者把更新文件放在 S3 或者其他地方。

Squirrel.Windows 有些很不错的特性是 Squirrel.Mac 所没有的。Squirrel.Windows 在后台实现更新，所以当你调用`restartAndInstall`，速度会更快，因为本地已经提前下载好了需要的更新文件。Squirrel.Windows 也支持 delta 更新，比如 app 检测到新版本需要更新，需要更新的部分会以补丁包的方式被下载和安装，而不是重新下载整个新的 app。假如当前的 app 要比最新版本低三个版本，Squirrel.Windows 甚至可以按照递增的方式来下载和安装需要的更新。当然如果当前 app 已经落后最新版本 15 个版本，Squirrel.Windows 就直接下载和安装整个最新的 app。这些功能底层已经帮你实现好了，API 使用起来依然很简单。你只需要检查更新，系统会帮你找到最优方案实现更新，并且告知用户更新完毕。

*注意*：虽然这些补丁包也必须部署在服务器上，但是 electron-builder 会帮你生成这些文件。

感谢 Electron 社区，让我们不一定非要构建自己的服务器。有很多开源项目帮助你实现把[更新文件部署在 S3 上](https://github.com/ArekSredzki/electron-release-server)，或者用 [GitHub release](https://github.com/GitbookIO/nuts)，甚至还有[提供后台控制面板](https://github.com/ArekSredzki/electron-release-server)来管理不同的更新版本。

### 桌面应用和网页应用的对决

那么桌面 app 到底和 web app 有些哪些不同？让我们来看看你可能遇到的一些意想不到的问题或收获，比如在 web 平台上使用 API 的副作用以及工作流中的痛点还有维护困难等。

第一件事情就是浏览器限定（browser lock-in），你也许会因此暗自高兴。假如你只做桌面 app，你很清楚用户用的是哪个版本的 Chromium。让我们来假设一下：你可以在 app 当中用到 flexbox，ES6，原生的 WebSocket，WebRTC 以及任何你想到的东西。你甚至可以在 app 当中开启尚在测试的 Chromium 特性，或者允许使用 localStorage。你根本不用处理任何跨浏览器的兼容问题。基于 Node.js API 和 NPM，你可以做任何事情。

*注意*：但你依然需要考虑用户在使用什么样的操作系统。不过相比较不同浏览器之间的问题，跨操作系统的兼容性处理要更简单些。

#### 处理 file://

另外一个有趣的事情是你的 app 要做到离线优先（offline-first）。在构建 app 的时候需要牢记的是，用户即使在没有网路的情况下也能正常使用 app，载入本地文件。你需要认真考虑 app 在网络条件差的情况下，如何正常工作。你可能需要改变思考问题的方式。

*注意*：你可以载入远程 URL，但是我不建议这么做。

我给出的建议是不要完全相信 [`navigator.onLine`](https://developer.mozilla.org/en-US/docs/Web/API/NavigatorOnLine/onLine)。这个属性会返回布尔值来反馈是否存在网络连接，不过请注意误报。如果有本地连接它就返回 true 而不去验证连接的有效性。网络连接虽然显示成功，但是可能实际上无法正常访问网页。比如本地机器到 Vagrant 虚拟机的连接会被误认为是成功的网络连接。所以，请使用 Sindre Sorhus 的 [`is-online`](https://github.com/sindresorhus/is-online) 来复核网络连接状态。它会 ping 互联网的根服务器或者一些著名网站的 favicon 文件。比如：

```javascript
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

说到本地文件，有几件事情需要注意，比如你无法使用少协议（protocol less）的 URL，我的意思是比如用 `//` 代替 `http://` 或者 `https://`。理论上，如果一个 web app 在请求 `//example.com/hello.json` 时，浏览器会把地址扩展为 `http://example.com/hello.json` 或者 `https://example.com/hello.json` （如果当前页面是通过 HTTPS 加载）。在我们的 app 当中，如果这么做，当前页面会使用 `file://` 协议。所以，当我们请求同样的 URL 时候，app 会把地址扩展为 `file://example.com/hello.json` 然后请求失败。我们真正要担心的是那些第三方模块；那些作者可能并没有按照桌面 app 的思路来制作模块。

你不会使用到 CDN，因为载入本地文件基本上是瞬间完成的。而且不像浏览器，你没有同时请求数量的限制，至少不会像 HTTP/1.1 那样。你可以并发载入尽可能多的文件。

#### 大量文件生成

构建一个可靠稳固的桌面 app 需要生产大量的文件。你需要为一个自动更新的系统生成可执行文件和安装包。然后对应的每一个更新，都需要再次构建可执行文件和更多的安装包（因为如果有人去你的网站下载，他们应当下载到最新版本）以及针对增量更新（delta update）的更新补丁。

文件大小仍然是一个需要考虑的问题。一个“Hello, World!”的 Electron app 压缩包是 40 MB。在构建 web app 的时候，除了遵循一些常见规则外（比如写更少的代码、压缩文件、使用更少的依赖等等），我可以提供的意见不多。“Hello World” app 本质上就是一个包含了 HTML 文件的 app；占 app 体积的绝大多数文件是来自 Chromium 和 Node.js。至少在 Windows 平台上增量更新可以有效减少下载文件的大小。但是我希望用户不要在 2G 网络上去下载文件。

#### 预判意外状况

在日后你一定会遇到一些意想不到的事情。有些事情要比其他更明显而且让人恼火。比如你制作了一个音乐播放器的 app，它支持迷你化，在其他应用之上用小窗口展示。假如用户点击了下拉菜单，app 会展示可选项，从 app 的底部边界溢出。如果你使用了非原生的包（比如 select2 或者 chosen），你会因此陷入麻烦。在打开下拉菜单的时候，它会被 app 的底部边界切割。用户会看到很少的选项甚至什么也看不到，这确实让人无语。当然这件事也会发生在浏览器上。但是用户不太可能会调整窗口到那么小。

![Screenshots comparing what happens to a native dropdown versus a non-native one](https://www.smashingmagazine.com/wp-content/uploads/2017/01/dropdownComparison-preview-opt.png)

你也许会知道，在 Mac 上每一个窗口都有一个 header 和 body。当窗口没有聚焦的时候，如果你把鼠标停留在 header 里面的图标或者按钮上，窗口的外观会对应的显示为鼠标停留状态。举个例子，macOS 上窗口的关闭按钮在未被停留时是灰色模糊的，当鼠标停留时，按钮变成红色。但是如果鼠标只是停留在 body 上，窗口外观不会发生改变。这是有意而为之的设计。让我们再回到我们的桌面 app，基于 Chromium 的 app 是没有 header，整个 web app 就是窗口 body。你可以不用原生的框架而创建自己的 HTML 按钮来取代原生的最小化，最大化还有关闭按钮。如果窗口没有被聚焦，当鼠标停留的时候，窗口不会有任何变化。Hover 的样式没有被应用，这总让人感觉不太对。更糟糕的是，只有在点击关闭按钮的时候，窗口才会被聚焦。然后你还得再次点击关闭按钮来真正关闭当前窗口。

雪上加霜的是，Chromium 有一个 bug 可以掩盖这个问题，让你以为窗口会按照你期待的样子工作。把鼠标从窗口外移动到窗口内的元素，如果你移动得足够快，hover 样式会被应用。这是已经确认的 bug。把 hover 样式应用在一个模糊化的窗口 body 上“并不满足当前系统平台的要求”，日后该 bug 会被修复。但愿我上面说的话不会让你太心碎。事实上，你可以创建一个足够漂亮的自定义窗口控制区，但现实是许多用户会因此苦恼（他们会怀疑这到底是不是原生的）。

所以你必须用到 Mac 原生的按钮。没有其他更好的办法了。对于 NW.js app，你必须开启使用原生框架（你也可以通过在 `package.json` 里面把 `window` 的属性 `frame` 设置为 `false` 来关闭使用原生框架）。

Electron app 也可以实现同样效果。比如设置 `new BrowserWindow({width: 800, height: 600, frame: true})` 来创建窗口。Electron 官方团队就是这么做的，他们还加入另外一种不错的选项：把 `titleBarStyle` 设置成 `hidden` 会隐藏原生标题栏但是通过覆盖 app 左上角来保留原生的窗口控制。 这样就解决了之前的问题，但同时可以使用在左上角使用自定义按钮。

```javascript
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

下面这张图，我禁用了标题栏然后设置了`html` 的背景图片:

![A screenshot of our example app without the title bar](https://www.smashingmagazine.com/wp-content/uploads/2017/01/hiddenTitleBar-preview-opt.png)

详见 Electron 官方文档 “[Frameless Window](http://electron.atom.io/docs/api/frameless-window)[57](#57)” 

#### 工具

你可以尽情地使用在构建 web app 时候用到的工具。你的 app 其实就是 HTML，CSS 还有 JavaScript 不是吗？针对桌面 app 开源社区也有丰富的插件和模块供你使用，比如你可以用 Gulp 插件来为你的 app 签名（如果你不打算用 electron-builder）。[Electron-connect](https://github.com/Quramy/electron-connect) 可以用来监控文件改动，如果主要的脚本文件有改动，它会在打开的窗口中应用这些改动或者重启 app。毕竟这就是 Node.js，你可以做任何事情。你也可以在 app 中用到 webpack 如果你想的话，虽然我不知道为什么要这么做，但这也是一个选择嘛。详情见 [awesome-electron](https://github.com/sindresorhus/awesome-electron) 获取更多资源。

#### 版本发布流程

维护和开发一个桌面应用是怎么样的体验？首先，发行版本流是完全不一样的。观念上就需要重新调整。在开发 web app 的时候，如果部署了之后然后遇到问题，这些都不是事。你直接修复 bug 就行了。新用户直接访问页面或者老用户重新加载页面就能得到最新的代码。开发者一旦有新任务，就直接去完成任务或者修复 bug 就好了。但是开发桌面 app 可不是这样。一旦冒失犯错，就无法撤回。这特别像开发移动 app 一样。你构建了 app，然后发布，就不可能撤回了。有些用户可能都不会从立即更新到最新的修复版本。这些存在于旧版本的 bug 可能会让你非常苦恼。

#### 量子力学

考虑到要服务于不同版本的 app，你的代码会以不同的形式和状态而存在。多个版本的客户端（桌面 app）会以多种方式访问你的 API。所以你得认真考虑 API 的版本控制问题，做好测试。当 API 有变化时，你无法获知此次变动会不会造成问题。一个月前发布的版本可能会因为一些代码的变动而发生崩溃。

#### 亟待解决的问题

你也许会遇到一些很奇怪的问题，一些涉及到奇怪的账户管理，反病毒软件或者更糟。我之前遇到过一个案例，用户自己安装某些文件导致系统环境变量被修改。这直接导致了我们的 app 当中某个重要的依赖安装失败，因为系统命令无法找到。这些案例提醒我们有些情况下必须划清界限，这对我们的 app 很重要，所以不能忽略报错，但我们也不能帮用户修好电脑。对于遇到这种问题的用户，他们的多数桌面应用顶多也是无法正常启动。最后我们决定如果再次报错，用户会看到一条链接到文档的报错信息，这个文档用来解释错误为什么会发生，同时告诉用户如何一步步去修复错误。

当然，一些基于 web 的顾虑将不再适配于桌面 app，比如一些历史遗留的浏览器问题。但有一些新的问题需要考虑，比如在 Windows 上文件路径有 256 字节大小的限制。

旧版本的 npm 采用递归的文件结构存储依赖。你的依赖都各自存储在项目中的 `node_modules` 目录下的文件夹里（例如， `node_modules/a`）。如果依赖模块自己本身也有依赖模块，这些子级的子级依赖会被存储在父级的 `node_modules` 中，比如 `node_modules/a/node_modules/b`。因为 Node.js 和 npm 鼓励使用小巧的单用途模块，你可能会很容易遇到长路径，比如 `path/to/your/project/node_modules/a/node_modules/b/node_modules/c/.../n/index.js`。

*注意*：版本 3 之后 npm 尽可能地扁平化依赖关系树。但是也存在一些其他原因导致长路径。

我们之前遇到一个问题，就是在特定版本的 Windows 上因为路径太长 app 无法正常启动或者启动之后就崩溃。这是个很头痛的问题。使用 Electron 时，你可以把所有代码放在 [asar archive](http://electron.atom.io/docs/tutorial/application-packaging/) 当中。虽然使用这种方法也存在例外而不能保证永远都能正常使用。

我们做了一个小小的 Gulp 插件  [gulp-path-length](https://github.com/Teamwork/gulp-path-length) 用来告知开发者当前 app 当中是否存在任何危险的长文件路径。终端用户将 app 放在哪里才能最终决定是否存在长文件路径。举个例子，假如安装包安装在 `C:\Users\<username>\AppData\Roaming`，当 app 构建完成（在本地通过持续集成服务完成），gulp-path-length 会用来监控是否当前目录下存在长文件路径（比如用户机器上的用户名过长而导致问题）。

```javascript
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

#### 关键性错误真的很致命

因为所有的自动更新都发生在 app 内部，在每次检查更新前，未捕获的异常会导致 app 崩溃。假设你发现了一个 bug 然后发布了新版本进行修复。如果用户启动 app，自动更新开始下载，然后 app 崩溃。如果用户重新启动 app，自动更新再次下载，再次崩溃...所以，你必须想尽办法让用户知道他们需要重新安装 app。相信我，这确实很糟糕。

#### 分析和 bug 报告

你很可能想追踪 app 的使用情况和各种错误。首先 Google Analytics 不起作用。你得找到一个分析工具可以支持 `file://` URL。如果你正使用工具来追查错误，假如工具支持发布版本追踪，一定要确保错误和版本挂钩。例如，如果你使用 [Sentry](https://sentry.io/welcome/) 追踪错误，[确保在设定客户端的时候设定了正确的 `release` 属性 ](https://docs.sentry.io/clients/javascript/config/#optional-settings)，这样错误会按照版本分类。否则当你收到错误报告准备修复错误的时候，你会持续收到错误报告和日志，这当中会包含一些误报。而这些误报来自用户正在使用旧版本 app。

Electron 包含了 [`crashReporter`](http://electron.atom.io/docs/api/crash-reporter/) 模块，该模块在 app 完全崩溃后（例如整个 app 崩溃，而不是错误抛出）自动向开发者发送报告。你也可以监听一些事件用来指示 app 的渲染进程无法响应。

#### 安全

当接收用户输入或者信任第三方脚本的时候需要格外注意，因为恶意攻击者会用各种意想不到的方式来使用 Node.js。而且记住永远不要在未经检查直接接受用户输入并传值到原生 API 或者命令。

也不要相信来自 vendors 的代码。我们最近遇到的问题来自公司 X 的分析应用的第三方代码片段。官方团队在发布的新版本当中包含了问题代码，导致了 app 致命错误。当用户启动 app 的时候，代码片段从 CDN 获取最新的 JavaScript 代码然后运行，随后抛出异常导致 app 无法继续运行。任何正在运行的 app 都不会受到影响，但是一旦重新打开 app 就会产生问题。我们联系公司 X 客服，随后他们发布了修复版本。如果再次重启 app 就会正常运行了，虽然已经解决了问题，但是回头想想还是很让人担心。如果我们不去强制受影响的用户手动下载修复版本的 app，我们自己就很难直接解决问题。

该怎么样才能规避风险呢？也许你可以试着捕获报错，但是你完全不知道公司 X 在 JavaScript 里面究竟做了什么。你最好使用更可靠稳固的代码。你可以加入一层抽象，不直接在 `<script>` 指向公司 X 的URL而使用 [Google Tag Manager](https://www.google.ie/analytics/tag-manager/) 或者你自己的 API 来返回包含有 `<script>` 标签的 HTML 文件或者包含所有第三方依赖的单独的 JavaScript 文件。这样在避免重新安装新版本的情况下，指定任意第三方代码片段被加载。

但是，假如 API 不再返回用来分析的代码片段，之前被代码片段创建的全局变量依然会存在你的代码当中，这些全局变量会尝试调用未定义的函数。所以我们并没有完全解决问题。而且，如果用户没有联网就打开 app，API 调用会失败。你并不想在离线时限制你的 app。当然你可以用上次成功请求的缓存文件来用作离线版本的加载。但是如果当前版本出现问题怎么办，你又回到了之前提到的问题（如果不强制用户下载新版本，app 就会崩溃）。

另外一种解决方案是创建一个隐藏窗口加载包含了所有第三方代码片段的本地HTML 文件。这样，任何由全局变量导致的问题会在这个隐藏窗口里报错，而主要窗口不受影响。如果你需要在主要窗口当中调用 这些 API 或者 全局变量，你可以通过 IPC 的方式来实现。通过 IPC 向主进程发送一个事件，然后该事件会被发送到隐藏窗口当中。如果隐藏窗口没有任何问题，它会监听事件同时调用第三方函数。这样就可以解决之前提到的问题。

这会带来安全问题。万一来自公司 X 的恶意攻击者在他们的 JavaScript 中包含有危险的 Node.js 代码？我们肯定死惨了。幸运的是，Electron 里有一个很不错的设置用来禁止在给定窗口中执行 Node.js 代码，使恶意代码不会运行：

```javascript
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

#### 自动化测试

NW.js 本身不包含对测试的支持。但是由于你可以使用 Node.js， 技术上，测试是可行的。 例如 [Chrome Remote Interface](https://github.com/cyrus-and/chrome-remote-interface) 可以用来测试 app 当中的按钮点击。但这个还是有点牵强，因为你无法触发原生窗口按钮的点击，也就无法测试。

Electron 官方团队开发了 [Spectron](http://electron.atom.io/spectron/) 用来自动测试。它支持测试原生控制按钮，管理窗口还有模拟 Electron 事件。它甚至可以在持续集成构建中运行。

```javascript
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

考虑到你的 app 就是 HTML 文件，仅仅在静态文件中添加指向测试工具的脚本，你可以用任何工具来测试 web app。但是你得确保 app 可以在没有 Node.js 的 web 浏览器中依然可以运行。

### 桌面和 Web

这不仅仅是关乎桌面 app 或者 web app。作为一个 web 开发者，你可以用任何工具制作 app 确保在任何平台和环境中运行。但是为什么没有一劳永逸的办法呢？我们还需要努力，但这是值得的。接下来我会提到一些相关的话题和工具，考虑到它们太过复杂，我就点到为止。

首先，忘记什么“浏览器限定”和原生 WebSockets 等等其他的事情。ES6 也是如此.你要么写纯粹的 ES5，要么用类似 [Babel](https://babeljs.io/) 的工具来把 ES6 代码编译成 ES5，供 web 使用。

你的代码里也会写满了许多浏览器不会理解的 `require`（用来引入其他脚本文件或者模块）。使用支持 CommonJS 的模块打包器，比如 [Rollup](http://rollupjs.org)，[webpack](https://webpack.github.io) 或者 [Browserify](http://browserify.org)。当构建 web app 的时候，模块打包器会遍历代码，找到所有的 `require` 然后把他们放在一个脚本文件里。

任何用到 Node.js 或者 Electron API（比如写盘操作或者集成桌面环境）的代码都不应该在 app 运行在 web 端的时候被调用。你可以通过检测 `process.version.nwjs` 和 `process.versions.electron` 是否存在来判断。如果存在，则表明 app 当前运行在桌面环境。

即便如此，你仍会在 web app 上加载大量冗余代码。假设你的代码中 `if(app.isInDesktop)` 后面紧接着和桌面环境有关的 `require` 代码。与其在 app 运行的时候来检测当前运行环境，同时设置对应的 `app.isInDesktop`，不如把 `true` 和 `false` 当做 flag 在构建的时候传值到 app。在它进行静态和树状分析（也就是消除无用代码）时，这将有助于模块捆绑的选择。它会知道 `app.isInDesktop` 是否为 `true`。因此，当你运行 web app 的时候，它不会到代码里去找对应的 `if` 条件，或者找到相关的 `require`。

#### 持续交付

我们对于版本发行的观念也需要换一换了，这非常有挑战性。当你在开发 web app 的时候，你希望能够频繁发布新的改动。我相信在持续交付中，小的增量改动可以快速回滚。理想情况是，经过足够的测试，一个实习生也可以把改动的代码 push 到 master 分支，然后让 web app 自动测试和部署。

我们之前谈到，你不能像 web app 那样在桌面 app 中实现同样的效果。没错，理论上如果你使用 Electron 的话，electron-builder 可以自动测试，而且 spectron 也可以测试。我不知道还有谁这么做，我自己不会有信心这么做。记住，错误的代码不可以撤销，你可能打破正常的更新流。而且，你也不想让桌面 app 更新太过频繁。更新不会悄无声息的发生，不像 web app 那样，这对于用户来说其实很不友好。而且在 macOS 上不支持增量更新，用户必须针对每一个发行版本都要下载完整的新版本的 app，不管更新是多么的小。

你得找到一个平衡点。一个妥协的做法是针对 web app 要尽可能快的更新和修复问题，对于桌面 app 每周或者每月更新一次就可以，除非你要发布新功能。你也不能指责用户选择安装桌面 app。没有什么比等待很久来发布新功能更糟糕的事情了。你可以采用功能发布控制器（feature-flag）API 来在同一平台同一时间发布新功能，但这又是另外一个话题了。我第一次学习和了解到功能发布控制器是来自 Etsy 的工程师 VP，Mike Brittain 的讲话，[持续交付：肮脏的细节](https://www.youtube.com/watch?v=JR-ccCTmMKY)（需翻墙）

### 总结

那么你已经掌握了。只要一点点努力，你就可以在简历中加上”桌面 app 开发者“的标签了。我们从创建第一个现代桌面 app，打包，分发，讲到售后服务还有更多。但愿我提到的一些陷阱和坑对你来说并没有那么可怕。你已经知道它们的前因后果了。你需要做的就是看一遍 API 文档。感谢那些可供我们任意使用的强大的 API，你可以从 web 开发者的技能树上获取更多有价值的东西。我希望可以在 NW.js 和 Electron 社区中看到你的身影。

---

> [掘金翻译计划](https://github.com/xitu/gold-miner) 是一个翻译优质互联网技术文章的社区，文章来源为 [掘金](https://juejin.im) 上的英文分享文章。内容覆盖 [Android](https://github.com/xitu/gold-miner#android)、[iOS](https://github.com/xitu/gold-miner#ios)、[React](https://github.com/xitu/gold-miner#react)、[前端](https://github.com/xitu/gold-miner#前端)、[后端](https://github.com/xitu/gold-miner#后端)、[产品](https://github.com/xitu/gold-miner#产品)、[设计](https://github.com/xitu/gold-miner#设计) 等领域，想要查看更多优质译文请持续关注 [掘金翻译计划](https://github.com/xitu/gold-miner)。
