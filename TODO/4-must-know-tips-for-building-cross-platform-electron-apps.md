> * 原文地址：[4 must-know tips for building cross platform Electron apps](https://blog.avocode.com/blog/4-must-know-tips-for-building-cross-platform-electron-apps)
* 原文作者：[Kilian Valkhof](https://blog.avocode.com/authors/kilian-valkhof)
* 译文出自：[掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者：
* 校对者：


[Electron](https://electron.atom.io) ，被包括 Avocode 在内的众多 app 采用的技术，允许你很快的实现并运行你跨平台桌面应用。如果你不注意的话你的 app 就会变得很怪异，你的 app 并不能像其它应用那样有序。



这是我 2016 年 5月 在 Amsterdam Electron Meetup 上演讲的手抄版，考虑到 api 的改变。注意，这些会很深入细节，并且假设你很熟悉 Electron。

**首先，我是谁**



我是 Kilian Valkhof ，一个前端工程师，UX 设计师，app 开发者，主要取决于你问谁。我有过10年丰富的互联网从业经验，用过各种环境去构建桌面应用，比如 GTK 和 QT ，当然也包括 Electron。



我最近在开发的一个应用是 [Fromscratch](https://fromscratch)，一个免费的跨平台的自动保存笔记的应用，你应该尝试一下。



在开发 Fromscratch 期间，我花了大量的时间确保 app 在所有平台上都能够用起来很好，并在 Electron 中找到了如何实现它。这些都是我挖坑填坑过程中积累起来的。



在 Electron 让 app 使用起来很舒服并且很一致并不难，你只需要注意些细节。



## **1\. 在 macOS 上复制粘贴**



想象一下，你发布了一款 app。比如是一款记笔记的应用。你在 Linux 机器上测试并重度使用了很久。然后你在 ProductHunt 上收到了一个友善的消息：



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


如果你已经有了菜单，你需要参数去包含上面的 剪切/复制/粘贴命令。

### 1.1 添加icon

...否则你的应用在 ubuntu 上就是这样的:



![icon.png](https://lh3.googleusercontent.com/hgM2iMDPsJDn-QbmIwi6TlaBygW7twHNplrfrUrGk8lp-ilSDg81t42hT7jgYjrS58PA9undzhXds-NdXxmoE5HQ6dfVie-k2WqLJL6xN8o0UIkgH3RSTY3byGzlMOx5uv5dySvF)



许多的应用都有这样的问题，因为在 windows 和 macOS 上，icon 显示在 task bar 或者 dock 的图标就是应用 icon(an .ico or .icns)，而在 ubuntu 上显示的是你的 window icon 。添加这个很简单。在  `BrowserWindow`  选项中，申明 icon：

    mainWindow = new BrowserWindow({

         title: 'ElectronApp',

         *icon: __dirname + '/app/assets/img/icon.png',*

       };
这也会让你的 Windows app 左上角显示一个小图标。

### 1.2 UI Text 不可选

当使用浏览器，文字编辑工具，或者其它原生应用时，你应该注意到你不可以选择菜单上的文字，比如 chrome。在 Electron 中让 app 变的怪异的一个方法就是无意中触发了文字选择，或者高亮了 UI 组件。



CSS 在这里可以帮助我们；对于任何按钮，菜单，或者其它任何 UI 文字，添加下面的代码：

     .my-ui-text {

           *-webkit-user-select:none;*

       }


这样文字就不可选了。它更像原生应用了。一个最简单的测试方法就是  ctrl/cmd + A  选择你 app 中所有可选的文字，可以有助于你快速识别哪些还需要添加这个效果。

### 1.3 对于三个平台，你需要三个 icon



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
好吧，我是写完构建针对不同版本选用不同 icon 脚本之后才反现的 :(



## **2\. 白色 loading 状态是属于浏览器行为**



没有什么比白色的 loading 更能代表 Electron app 只是个内嵌浏览器的本质了。不过我们可以通过两种手段来避免 loading 状态：

### 2.1 指定 BrowserWindow 背景颜色

如果你的应用没有白色背景，那么一定要在 BrowserWindow 选项中明确声明。这并不会阻止应用加载时的纯色方块，但至少它不会半路该变颜色：



     mainWindow = new BrowserWindow({

         title: 'ElectronApp',

         *backgroundColor: '#002b36',*

       };

### 2.2 在你应用加载成功前隐藏它:

因为应用实际上是在浏览器中，我们可以选择在所有资源加载完成前隐藏窗口。在开始前，确保隐藏掉浏览器窗口：

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

这个问题对在  "native" apps 中也存在，这也是我发现最令人头疼的事情之一。本来一个位置处理很好的 app 在重启时所有的位置又变为默认的了，虽然这对于开发者来说是很合理的，但这会让人有种想撞墙的冲动。千万不要这样做。

相反，保存窗口的大小和位置，并在每次重启时恢复，你的用户会很感激你的。

### 3.1预编译方案



有 [electron-window-state](https://www.npmjs.com/package/electron-window-state) 和 [electron-window-state-manager](https://www.npmjs.com/package/electron-window-state-manager) 两中预编译方案。两种都能用，好好读文档并且小心边界情况，比如最大化你的应用。如果你很想快一点编译完成并看到成品，你可以采用这两种方案。

### 3.2 自己处理滚动

你可可以自己处理滚动，这也正是我用的方案，主要是基于我前几年给  [Trimage](https://trimage.org) 写的代码的基础上实现的。并不需要写很多的代码，而且可以给你很多控制权。下面是演示：

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

当然了这在第一次打开是并不行，你的处理这种情况。可以提供默认设置，一旦你的在 JavaScript 对象中获取到了前一次的状态，就采用保存的状态去设置 BrowserWindow 的大小：

    var mainWindow = new BrowserWindow({

         title: 'ElectronApp',

         x: windowState.bounds && windowState.bounds.x || undefined,

         y: windowState.bounds && windowState.bounds.y || undefined,

         width: windowState.bounds && windowState.bounds.width || 550,

         height: windowState.bounds && windowState.bounds.height || 450,

       });
正如你看到的那样，我通过提供 回退值来添加默认设置。

现在在 Electron 中，在开启应用时并不能以最大化状态启动应用，因此我们得在创建好 BrowserWindow 之后再最大化窗口。

    // Restore maximised state if it is set.

       // not possible via options so we do it here

       if (windowState.isMaximized) {

         mainWindow.maximize();

       }

#### 3.2.3 在 move resize 和 close 时保存状态:

在理想世界中你只需要在关闭应用时保存你的窗口状态，但事实上它错过了很多未知原因导致的应用终止，比如断电之类的。

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

### 4.3系统颜色

和系统字体一样，你也可以用  [System colors](http://www.sitepoint.com/css-system-styles/) 让系统决定你应用的颜色。这其实是一个在 CSS3 中已经弃用的未完全实现的属性，但在可见的未来中它并不会被很快废弃。

### 4.4 布局

CSS 是个相当强大个布局方式，尤其是把  `calc()` 和 flexbox 结合到一起时，但这并不会减少之前在老旧的 GUI 框架比如 GTK, Qt 或者 Apple Autolayout 时代需要做的工作。你可以用  [Grid Stylesheets](https://gridstylesheets.org/)（这是一个基于约束的布局系统）  采用类似的方式实现你 app 的 GUI 。

## **感谢!**

在 Electron 中构建应用是一件很有趣的事情并且会让你有很的收获感 : 你可以在很短的时间内实现并运行一个跨平台的应用。如果你之前从没有用过 Electron 我希望这篇文章可以引起你足够的兴趣去尝试它。[Electron](http://electron.atom.io) 的网站有很全的文档以及很多很酷的 Demo 可以让你尝试它的 API 

如果你已经在写 Electron 应用了，我希望上面的可以鼓励你更多的考虑你的 app 在所有平台上究竟运行的怎么样。

最后，如果你有什么附件的小贴士，请把它写在评论区。


