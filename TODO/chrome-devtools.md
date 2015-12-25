> * 原文链接 : [Chrome 开发者工具建议与技巧](http://mo.github.io/2015/10/19/chrome-devtools.html)
* 原文作者 : [	Assigned](https://code.google.com/p/chromium/issues/detail?id=174309)
* 译文出自 : [掘金翻译计划](https://github.com/xitu/gold-miner)
* 译者 :  matrixorz
* 校对者: 
* 状态 :  待定

最近我在Chrome开发者工具上花费了比平时更多的时间，一路上我发现一系列很炫酷的技巧，这些技巧是我之前错过的(至少没有探讨的如此深刻，比如黑盒子和异步栈跟踪)。由此，我想总结那些我喜欢的开发工具的技巧

*  放大镜小图标会告诉你css文件中css类|选择器决定选中的元素和css属性的最终样式。举个例子，在任一个DOM元素选择”审查“后，进而转到右边的计算后子标签页。找到你感兴趣的css属性，然后点击放大图标会直接将你导入到正确的css类和选择器（这个技巧在当你开始做大型web应用时非常有用）

![](http://mo.github.io/assets/devtools-css-magnifier-icon.png)

*   在使用XHRs时想知道Web应用发送了什么样的XHRs，可以在设置下选中Log XMLHttpRequests 复选框，同时注意console标签页。在你知道发生了什么之前，我已将浏览器建立类似Burp Suite的HTTP拦截代理上了，但是这里的代理在你只是想得到一个快速的概览时使用更方便。当然，使用拦截代理时你也有机会在XHRs到达服务器之前进行修改，这对于安全测试是非常有用的。一个轻量化的替代方案是在”Sources::XHR Breakpoints“下激活”任意XHR“断点

![](http://mo.github.io/assets/devtools-settings-log-xhr.png)
*   现在，假设你开发的web应用在定期创建XHR（比如保证当前视图最新），你想知道在哪儿建立定时器（比如在哪里调用setTimeout或者setInterval），为了弄清楚这个问题，你可以调到源码标签页，选中“Async“复选框。这样会让你所有的栈跟踪能继续跳过setTimeout以及关联的事件，甚至多层嵌套。对于requestAnimationFrame和addEventListener以及其他的事件同样适用。你将在下面看到复选框。

![](http://mo.github.io/assets/devtools-async-stacktraces.png)  
*   为了快速的发现你点击的按钮或链接时将要运行的代码，在你点击特定的按钮之前激活鼠标::点击的"事件监听断点"（当你开始做现有的大型web应用中的另一个杀手级特征）

![](http://mo.github.io/assets/devtools-event-listener-breakpoints.png)
*   当你使用"事件监听断点::鼠标::点击"时，一开始你可能会结束在jQuery这样的第三方库中，你不得不在调试器中多进入几次从而到达真正的事件处理中，一个避免这样问题的优雅方法是黑盒化三方脚本。调试器在黑盒化后的脚本将不会停止，取而代之的是他将继续运行，直到它到达不在黑盒脚本文件中的首行。你可以在调用栈中，通过右击三方库的脚本文件从上下文菜单中选择黑盒化脚本选项黑盒化一个脚本。

![](http://mo.github.io/assets/devtools-blackbox-third-party-script.png)
*   你可以跳转到特定的文件，也就是，使用ctrl-p（与atom中使用方法一样）

![](http://mo.github.io/assets/devtools-open-file-ctrl-o.png)

*   你能跳转到一个函数（不限制于当前打开的文件中），也就是，使用‘ctrl-shift-p';

![](http://mo.github.io/assets/devtools-go-to-member.png)

*   你可以通过'ctrl-shift-f'搜索所有的文件：

![](http://mo.github.io/assets/devtools-search-all-files-ctrl-shift-f.png)

*   你可以多次使用'ctrl-d'去选择一个单词的关联实例，使多个游标选择一些单词然后同时进行编辑（再一次的与atom使用方法一样）。在重命名变量时这个技巧非常有用。

![](http://mo.github.io/assets/devtools-multiple-cursors-ctrl-d.gif)
*   当在本地存储的网站上工作时，在开发工具中可能会去编辑文件，想在本地磁盘中存储这些变化。为了达到这样的目的，可以回到source标签页，右击Source子标签页然后选择”添加文件夹到工作空间“中，进而选择你项目所在的本地文件夹，之后，在你的网站上右击一些文件的本地副本，选择“映射到网络资源...”，并选择相应的网络文件：

![](http://mo.github.io/assets/devtools-workspace-map-network-resource.png)

其他实用技巧包括

*    终端中的`$0`是你在元素视图中选择的那个元素
*    你可以使用`$x("//p")`计算Xpath表达式(在你编写不完全的seleninum测试用例和css选择器时非常有用)

我也建议你安装下面两个Chrome扩展：

*   [JSONView](https://www.google.se/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0CCAQFjAAahUKEwje6JvErs_IAhVI_iwKHSwaALo&url=https%3A%2F%2Fchrome.google.com%2Fwebstore%2Fdetail%2Fjsonview%2Fchklaanhfefbnpoihckbnefhakgolnmc%3Fhl%3Den&usg=AFQjCNH3ET5JyRh_aKGH_G5Ws5MXENK5bA&sig2=JD7IupIQ8cZJwE_05USbwg)将为你缩进和高亮json块，（甚至允许你对其展开/折叠）。它也可让json中的urls可以点击，能够通过浏览器就可探查基于json的api，例如，访问[`http://omahaproxy.appspot.com/all.json`](http://omahaproxy.appspot.com/all.json)，之后你安装JSONView，发现json格式化的更好,[`https://api.github.com/`](https://api.github.com/)也可以 (可点击的URLs能够更容易探查API)

*   [JS Error Notifier (non-“spyware” version)](https://chrome.google.com/webstore/detail/javascript-errors-notifie/fhbooopdkjpkogooopbmabepipljagfn) 会创建弹出框当在终端上打印javascript 错误时。不幸的是，这个扩展的主版本会提交私有使用数据到一个第三方服务(讨论参见 [issue #28](https://github.com/barbushin/javascript-errors-notifier/issues/28))。但是，这个扩展确实帮助我留意和修改了好几个bug。


总之，我非常喜欢开发者工具，我能想到的困扰就只是不能进行键盘绑定的定制化：


*   [Allow to customize keyboard shortcuts/key bindings](https://code.google.com/p/chromium/issues/detail?id=174309)

