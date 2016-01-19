* 原文链接 : [Chrome Devtools Tips & Tricks](http://mo.github.io/2015/10/19/chrome-devtools.html)
* 原文作者 : [Molsson](http://mo.github.io/)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 : [chemzqm](http://chemzqm.me)
* 校对者: [RobertWang](https://github.com/RobertWang)、[EthanWu](https://github.com/EthanWu)、[Zhangdroid](https://github.com/Zhangdroid)
* 状态 : 翻译完成

最近我花了很多的时间使用我的 Chrome 开发者工具。 通过这个过程我发现了一些以前错过的很棒的特性（或者说当时觉得没有必要去深究，例如：黑箱特性和异步栈追踪）。 因此，我想简要阐述一些我特别喜欢的开发者工具特性。

* 那个小的放大镜图标可以告诉你决定当前的 CSS 类/选择器的某个特定样式是在哪个文件里定义的。 举例来说，在任意 DOM 元素上右键打开菜单，点击 “inspect” 选项，在右下的面板中选择 “Computed” 子面板，找到你感兴趣的属性并点击前面的放大镜图标就能直接定位到定义这个样式的文件了。（如果你是直接上手一个大型 web 项目的话这会非常有用）

_译注：新版 Chrome 已经没有放大镜图标了，相应的 css 文件和定义样式的行数会在样式旁边直接显示，点击即可跳转_

![](http://mo.github.io/assets/devtools-css-magnifier-icon.png)

* 想要看到使用中应用发送的 XHR 请求，可以打开 settings 面板（译注：打开调试面板按 F1 呼出）选中 “Log XMLHttpRequests” 选项，然后就可以在 “Console” 面板中看到请求了。在我知道这件事之前，我需要创建一个代理来观察 http 请求，例如 Brup 套件这样的工具，并让 http 请求通过这个代理，如果你只想大致了解相关的请求，使用 “Console” 的方式会更方便一些。当然，使用一个中间人代理可以让你在请求发送过程中修改请求和响应的数据，这在进行某些安全性测试时会非常管用。 另一种替代的选择是在 “Sources” 面板下找到右侧面板中的 “XHR Breakpoints” 选项，然后激活 “Any XHR” 选项。（译注：新版 Chrome 支持 url 的正则匹配过滤）

![](http://mo.github.io/assets/devtools-settings-log-xhr.png)

* 现在，假设你的应用正在以一定频率发送 XHR 请求（例如为了确保当前页面状态是最新的），而你想要知道这些定时器是在哪儿定义的（很可能是通过 `setTimeout()` 或者 `setInterval()` 方法）。 想要找到它们，首先打开 “Sources” 面板，选中右边的 “Async” 确认框。 这会让你的程序中 `setTimeout()` 之类的异步调用暂停，而不会影响其它调用栈的顺利进行，即便是那个异步方法经过了很多层的调用。 这对 `requestAnimationFrame()` 以及 `addEventListener()` 之类的浏览器提供的异步方法也会起作用。你可以在这里找到这个确认框：

![](http://mo.github.io/assets/devtools-async-stacktraces.png)

* 如果你想快速定位某个特定按钮或者链接点击后所触发的代码，只需要在你真正点击按钮之前，激活一个 “Event listener breakpoint”, 选中右侧面板下 mouse 下面的 click 确认框即可（又是一个调试大型应用的杀手级特性）

![](http://mo.github.io/assets/devtools-event-listener-breakpoints.png)

* 当你使用 “Event listener breakpoint :: Mouse :: Click” 调试事件时，有很大的可能是代码在第三方的库中中断了（例如 jquery ），这时如果你想找到属于自己项目的调用需要在调试器里面点很多次的下一步才能看到。 一种很棒的方式就是把这些第三方的脚本放到黑盒里面，调试器永远不会在黑盒中的脚本内停止，它会一直向后运行，直到运行的代码行位于黑盒之外的文件。 你可以在调用栈面板中右键点击第三方脚本的文件名，然后左键在下拉菜单中点击 “Blackbox Script”。

![](http://mo.github.io/assets/devtools-blackbox-third-party-script.png)

* 你可以使用 `ctrl-p` （后面还可以跟 `:` 加行号跳转到特定行）快速跳转到一个引用文件（就像在atom 编辑器里一样）

_译注：这些 Chrome 开发者工具提供的快捷键里面的 `ctrl` 在 Mac 系统下对应为 `⌘`。_

![](http://mo.github.io/assets/devtools-open-file-ctrl-o.png)

* 你可以使用 `ctrl-shift-p` 跳转到一个特定函数（仅限当前打开的文件）

_译注：`ctrl-shift-p` 在 Mac 系统下默认操作为 ‘进去/退出全屏’。_

![](http://mo.github.io/assets/devtools-go-to-member.png)

* 你可以使用 `ctrl-shift-f` 来搜索全部的文件

![](http://mo.github.io/assets/devtools-search-all-files-ctrl-shift-f.png)

* 通过鼠标选中一个单词，然后按下 `ctrl-d` 任意次你可以同时选中相同名称的多个单词，然后借助同步的鼠标指示对它们进行同时编辑（同样，就像 atom 里面一样）。  用来做变量重命名非常不错。

![](http://mo.github.io/assets/devtools-multiple-cursors-ctrl-d.gif)

* 如果当前的站点在你的本地有对应的文件，有种办法可以让你在开发者工具内修改文件后直接保存到本地的硬盘。 选中 Sources 面板，右键点击左侧文件列表的任意文件，左键点击 “Add Folder to Workspace”, 然后选择你对应的本地文件目录。然后，右键点击你本地文件列表内的文件，然后左键选中 “Map to Network Resource…”，最后选中相应的网络文件。

![](http://mo.github.io/assets/devtools-workspace-map-network-resource.png)

额外的一些小技巧：

* 在控制台内 `$0` 指向你你在 Elements 面板内高亮选中的元素
* 你可以在控制台使用代码 `$x("//p")` 来获取元素的 XPath 表达式（这在编写 selenium 测试集时非常有用，尤其是 css 选择器不容易编写的时候）

同时向您推荐两个 Chrome 扩展工具：

*   [JSONView](https://www.google.se/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0CCAQFjAAahUKEwje6JvErs_IAhVI_iwKHSwaALo&url=https%3A%2F%2Fchrome.google.com%2Fwebstore%2Fdetail%2Fjsonview%2Fchklaanhfefbnpoihckbnefhakgolnmc%3Fhl%3Den&usg=AFQjCNH3ET5JyRh_aKGH_G5Ws5MXENK5bA&sig2=JD7IupIQ8cZJwE_05USbwg) 它能帮你格式化并缩进 JSON 代码（甚至支持折叠/展开代码块）。 它可以让你可以直接点击 JSON 中包含的 url 链接来进行跳转，这可以帮助你直接在浏览器中调试基于 JSON 的 API。 例如：你可以在插件安装完成前后试着打开这个链接[`http://omahaproxy.appspot.com/all.json`](http://omahaproxy.appspot.com/all.json)，或者这个[`https://api.github.com/`](https://api.github.com/) (可点击的 url 链接让你可以更容易的直接在浏览器内探索这些 API)

*   [JS Error Notifier (无监控版本)](https://chrome.google.com/webstore/detail/javascript-errors-notifie/fhbooopdkjpkogooopbmabepipljagfn) 它会在错误显示在控制台后弹出一个界面提示框。 遗憾的是，它的主要版本会向第三方的服务发送一些用户数据（[issue #28](https://github.com/barbushin/javascript-errors-notifier/issues/28) 可以看到更多讨论）。 不管怎么说，它都帮我注意到并解决了几个 bug。(译注：该版本已下架)

最后，我真的觉得 Chrome 开发者工具很棒，但有一点让我有点苦恼就是它不支持用户自定义快捷键:

*   [支持用户自定义快捷键](https://code.google.com/p/chromium/issues/detail?id=174309)

_译注：Chrome 所使用的 V8 引擎在处理错误栈信息时并不总是正确识别各种 `sourcemap`，如果你项目中使用 `sourcemap` 技术的话，这里有个工具 [Stack-source-map](https://github.com/chemzqm/stack-source-map) 或许可以帮上你_
