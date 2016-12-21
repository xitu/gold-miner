> * 原文地址：[4 must-know tips for building cross platform Electron apps](https://blog.avocode.com/blog/4-must-know-tips-for-building-cross-platform-electron-apps)
* 原文作者：[Kilian Valkhof](https://blog.avocode.com/authors/kilian-valkhof)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：[huanglizhuo](https://github.com/huanglizhuo/)
* 校对者：[DeadLion](https://github.com/DeadLion) , [zhouzihanntu](https://github.com/zhouzihanntu)

# 开发 Electron app 必知的 4 个 tips 

[Electron](https://electron.atom.io) ，是包括 Avocode 在内的众多 app 采用的技术，能让你快速实现并运行一个跨平台桌面应用。有些问题不注意的话，你的 app 很快就会掉到“坑”里。无法从其它 app 中脱颖而出。



这是我 2016 年 5月 在 Amsterdam 的 Electron Meetup 上演讲的手抄版，加入了对 api 变化的考虑。注意，以下内容会很深入细节，并假设你对 Electron有一定了解。

**首先，我是谁**



我是 Kilian Valkhof ，一个前端工程师，UX 设计师，app 开发者，取决于你的提问对象是谁。我有超过10年的互联网从业经验，在各种环境下构建过桌面应用，比如 GTK 和 QT ，当然也包括 Electron。



你或许应该试试我最近开发的一个自动保存笔记的免费跨平台应用 [Fromscratch](https://fromscratch/) 。



在 Fromscratch 的开发过程中，我花了大量时间确保应用在三大平台上都能保持良好运行，并找到了在 Electron 中的实现方法。这些都是我挖坑填坑过程中积累起来的。



使用 Electron 让 app 使用感和一致性良好并不难，你只需要注意以下细节。

## **1\. 在 macOS 上复制粘贴**



想象一下，你发布了一款记笔记的应用。你在 Linux 机器上进行了多次使用和测试,然而你在 ProductHunt 上收到了一个友善的消息：



![cp.png](https://lh6.googleusercontent.com/TlfwI6UWMb7sFhVU-KIE3C25bBcl0EIPm50HGgHnXDhY0NBGRjzgiNGfM3u3pzGgXvctkKaqBIp6BTIfo2bQuaA7oY1_pNmlYclk44qW-afSILxCIALGu2-KJYBlaZL0FM_DgkM4)



     if (process.platform === 'darwin') {

           var template = [{

             label: 'FromScratch',

             submenu: [{

               label: 'Quit',

               accelerator: 'CmdOrCtrl+Q',

               click: function() { app.quit(); }

             }]

           }, {

             label: 'Edit',

             submenu: [{

               label: 'Undo',

               accelerator: 'CmdOrCtrl+Z',

               selector: 'undo:'

             }, {

               label: 'Redo',

               accelerator: 'Shift+CmdOrCtrl+Z',

               selector: 'redo:'

             }, {

               type: 'separator'

             }, {

               label: 'Cut',

               accelerator: 'CmdOrCtrl+X',

               selector: 'cut:'

             }, {

               label: 'Copy',

               accelerator: 'CmdOrCtrl+C',

               selector: 'copy:'

             }, {

               label: 'Paste',

               accelerator: 'CmdOrCtrl+V',

               selector: 'paste:'

             }, {

               label: 'Select All',

               accelerator: 'CmdOrCtrl+A',

               selector: 'selectAll:'

             }]

           }];

           var osxMenu = menu.buildFromTemplate(template);

           menu.setApplicationMenu(osxMenu);

       }


如果你已经有了菜单，你需要将以上 剪切/复制/粘贴 命令添加到你的已有菜单中。

### 1.1 添加 icon

...否则你的应用在 ubuntu 上就是这样的:



![icon.png](https://lh3.googleusercontent.com/hgM2iMDPsJDn-QbmIwi6TlaBygW7twHNplrfrUrGk8lp-ilSDg81t42hT7jgYjrS58PA9undzhXds-NdXxmoE5HQ6dfVie-k2WqLJL6xN8o0UIkgH3RSTY3byGzlMOx5uv5dySvF)



许多应用都有这样的问题，因为在 Windows 和 macOS 系统上，任务栏或 dock 中显示的图标就是应用图标(一个 .ico 或者 .icns)，而在 Ubuntu 系统上显示的却是你的窗口图标。 。添加这个很简单。在  `BrowserWindow`  选项中，申明 icon：

    mainWindow = new BrowserWindow({

         title: 'ElectronApp',

         *icon: __dirname + '/app/assets/img/icon.png',*

       };
这也会让你的 Windows app 左上角显示一个小图标。

### 1.2 UI Text 不可选

当使用浏览器，文字编辑工具，或者其它原生应用时，你应该注意到你不可以选择菜单上的文字，比如 chrome。在 Electron 中让 app 变的怪异的一个方法就是无意中触发了文字选择，或者高亮了 UI 组件。



CSS 在这里可以帮助我们：向所有按钮，菜单，或者其它任何 UI 元素，添加下面的代码：

     .my-ui-text {

           *-webkit-user-select:none;*

       }


这样文字就不可选了。它更像原生应用了。一个最简单的测试方法就是  ctrl/cmd + A  选中你的应用中所有可选的文字，可以有助于你快速识别哪些还需要添加这个效果。

### 1.3 你需要在三大平台上分别使用三种图标



说实在的，这真是太不方便了，在 Windows 上你需要 .ico 文件，在 macOS 上你需要 .icns 文件，而在 Linux 上你需要 .png 文件。



![facepalm.jpg](https://lh6.googleusercontent.com/_f669yBlzhJADMhMhrZtR3pwIRg5GhSmIHd_CvDWg_hL6UnpwfoxXHZ37Wl6XW4uBMzw8df2PNJeQsIQnkVO6LTrXyYduBljhCbel0SkU05DAlrR8rD1jRnrtRl_XDFtsKJEC6hl)



幸运的是普通的 png 图可以生成另俩个 icon。下面这是最方便的做法：



1\. 制作一张 1024x1024 像素的 PNG，这意味着你已近完成 1/3 的工作了。 (Linux, check!)

2\.  对于 Windows，用 [icotools](http://www.nongnu.org/icoutils/) 生成 .ico:

   `icontool -c icon.png > icon.ico`

3\.  对于 macOS，用 png2icns 生成 icns:

   `png2icns icon.icns icon.png`

4\. 完成了!

在 macOS 上也有像 [img2icns](http://www.img2icnsapp.com/) 这样的 GUI 工具，或者 [iconverticons](https://iconverticons.com/online/) 这样的 web 工具，但我并没有用过。

### 1.4 意外之喜!

electron-packager 不需要额外的 icon 来为给定的平台选择正确的图标：

    $ electron-packager . MyApp *--icon=img/icon* --platform=all --arch=all --version=0.36.0 --out=../dist/ --asar
好吧，我是写完构建针对不同版本选用不同 icon 脚本之后才发现的 :(



## **2\. 白色 loading 状态是属于浏览器行为**



没有什么比白色的 loading 更能代表 Electron app 只是个内嵌浏览器的本质了。不过我们可以通过两种手段来避免 loading 状态：

### 2.1 指定 BrowserWindow 背景颜色

如果你的应用没有白色背景，那么一定要在 BrowserWindow 选项中明确声明。这并不会阻止应用加载时的纯色方块，但至少它不会半路改变颜色：



     mainWindow = new BrowserWindow({

         title: 'ElectronApp',

         *backgroundColor: '#002b36',*

       };

### 2.2 在你应用加载完成前隐藏它:

因为应用实际上是在浏览器中运行的，我们可以选择在所有资源加载完成前隐藏窗口。在开始前，确保隐藏掉浏览器窗口：

     var mainWindow = new BrowserWindow({

           title: 'ElectronApp',

           *show: false,*

       };
然后在所有东西都加载完成时，显示窗口并聚焦在上面提醒用户。这里推荐使用  `BrowserWindow` 的 "ready-to-show" 事件实现，或者用 webContents 的 'did-finish-load' 事件。

     mainWindow.on('ready-to-show', function() {

           mainWindow.show();

           mainWindow.focus();

       });


这里记得要调用 foucs ，提醒用户你的应用已经加载完成了。

## **3\. 保持窗口的大小和位置**

这个问题在很多原生应用中也存在，我发现这是最令人头疼的事情之一。本来一个位置处理很好的 app 在重启时所有的位置又变为默认的了，虽然这对于开发者来说是很合理的，但这会让人有种想撞墙的冲动。千万不要这样做。

相反，保存窗口的大小和位置，并在每次重启时恢复，你的用户会很感激的。

### 3.1 预编译方案



有 [electron-window-state](https://www.npmjs.com/package/electron-window-state) 和 [electron-window-state-manager](https://www.npmjs.com/package/electron-window-state-manager) 两种预编译方案。两种都能用，好好读文档并且小心边界情况，比如最大化你的应用。如果你很想快一点编译完成并看到成品，你可以采用这两种方案。

### 3.2 自己处理滚动

你可以自己处理滚动，这也正是我用的方案，主要是基于我前几年给  [Trimage](https://trimage.org) 写的代码的基础上实现的。并不需要写很多的代码，而且可以给你很多控制权。下面是演示：

#### 3.2.1 把状态保存起来

首先我们得把应用的位置和大小保存在某个地方。用 [Electron-settings](https://github.com/nathanbuchar/electron-settings) 可以轻松做到这一点，但我选择用 [node-localstorage](https://www.npmjs.com/package/node-localstorage) 因为它更简单。

    var JSONStorage = require('node-localstorage').JSONStorage;

       var storageLocation = app.getPath('userData');

       global.nodeStorage = new JSONStorage(storageLocation);

如果你把数据保存到  _`getPath('userData')`_ ， electron 将会把它保存到自己的应用设置里，在 _`~/.config/YOURAPPNAME`_ 位置，在 Windows 上就是你的用户文件夹下的 appdata 文件夹中。

#### 3.2.2 打开应用时恢复你的状态

    var windowState = {};

         try {

           windowState = global.nodeStorage.getItem('windowstate');

         } catch (err) {

           // the file is there, but corrupt. Handle appropriately.

         }

当然了，第一次启动的时是不可行，你得处理这种情况。可以提供默认设置，一旦你在 JavaScript 对象中获取到了前一次的状态，就使用保存的状态信息去设置 BrowserWindow 的大小：

    var mainWindow = new BrowserWindow({

         title: 'ElectronApp',

         x: windowState.bounds && windowState.bounds.x || undefined,

         y: windowState.bounds && windowState.bounds.y || undefined,

         width: windowState.bounds && windowState.bounds.width || 550,

         height: windowState.bounds && windowState.bounds.height || 450,

       });
正如你看到的那样，我通过提供回退值来添加默认设置。

现在在 Electron 中，在开启应用时并不能以最大化状态启动应用，因此我们得在创建好 BrowserWindow 之后再最大化窗口。

    // Restore maximised state if it is set.

       // not possible via options so we do it here

       if (windowState.isMaximized) {

         mainWindow.maximize();

       }

#### 3.2.3 在 move resize 和 close 时保存状态:

在理想世界中你只需要在关闭应用时保存你的窗口状态，但事实上它错过了很多未知原因导致的应用终止事件，比如断电之类的。

在每次 move resize 事件时获取和保存状态可以让我们可以恢复上次已知状态的位置和大小。

     ['resize', 'move', 'close'].forEach(function(e) {

         mainWindow.on(e, function() {

           storeWindowState();

         });

       });

    And the storeWindowState function:

    var storeWindowState = function() {

         windowState.isMaximized = mainWindow.isMaximized();

         if (!windowState.isMaximized) {

           // only update bounds if the window isn't currently maximized

           windowState.bounds = mainWindow.getBounds();

         }

         global.nodeStorage.setItem('windowstate', windowState);

       };

storeWindowState 函数有个小小的问题：如果你最小化一个最大化状态的原生窗口时，它会恢复到前一个状态，这意味着本来我们想要保存的是最大化的状态，但我们并不想覆盖掉前一个窗口的大小（没有最大化的窗口），因此如果你最大化，关闭，重新打开，取消最大化，这时应用的位置是你最大化之前的位置。

## **4\. 一些小贴士**

下面是一些很小很简短有用的小技巧。

### 4.1 快捷键

通常来讲 Windows 和 Linux 使用 Ctrl，而 macOS 用 Cmd 。为了避免给每个快捷键（在 Electron 这叫做加速器 _Accelerator_ ）添加两次，你可以用  "CmdOrCtrl" 一次性给所有的平台进行设置。

### 4.2 使用系统字体 San Francisco

用系统默认的字体意味着你的应用可以和操作系统看起来很和谐。为了避免给每个系统都单独设置字体，你可以用下面的 CSS 代码块速实现更随系统字体：

     body {

         font: caption;

       }

"caption" 是 CSS 中关键字，它会连接到系统指定字体。

### 4.3 系统颜色

和系统字体一样，你也可以用  [System colors](http://www.sitepoint.com/css-system-styles/) 让系统决定你应用的颜色。这其实是一个在 CSS3 中已经弃用的未完全实现的属性，但在可见的未来中它并不会被很快废弃。

### 4.4 布局

CSS 是个相当强大的布局方式，尤其是把  `calc()` 和 flexbox 结合到一起时，但这并不会减少在像 GTK, Qt 或者 Apple Autolayout 这类老旧的 GUI 框架中需要做的工作。你可以用  [Grid Stylesheets](https://gridstylesheets.org/)（这是一个基于约束的布局系统）  采用类似的方式实现你 app 的 GUI 。

## **感谢!**

在 Electron 中构建应用是一件很有趣的事情并且会让你有很多的收获 : 你可以在很短的时间内实现并运行一个跨平台的应用。如果你之前从没有用过 Electron 我希望这篇文章可以引起你足够的兴趣去尝试它。很多的收获[Electron](http://electron.atom.io) 的网站有很全的文档以及很多很酷的 Demo 可以让你尝试它的 API 

如果你已经在写 Electron 应用了，我希望上面的可以鼓励你更多的考虑你的 app 在所有平台上究竟运行的怎么样。

最后，有什么其他的小贴士，请把它写在评论区。


